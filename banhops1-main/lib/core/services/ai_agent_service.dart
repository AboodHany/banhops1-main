import 'dart:convert';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;

import '../config/app_config.dart';
import '../models/chat_message.dart';
import '../models/transit_enums.dart';
import '../models/transit_route_option.dart';
import 'user_session.dart';

class AiAgentResult {
  const AiAgentResult({
    required this.reply,
    required this.rawPayload,
    required this.usedFallback,
  });

  final String reply;
  final Map<String, dynamic> rawPayload;
  final bool usedFallback;
}

class AiAgentService {
  AiAgentService(this._config);

  final AppConfig _config;

  bool get isGeminiDirect {
    return _config.aiAgentBaseUrl.contains(
          'generativelanguage.googleapis.com',
        ) ||
        (_config.aiAgentApiKey.isNotEmpty &&
            !_config.aiAgentBaseUrl.contains('railway') &&
            !_config.aiAgentBaseUrl.contains('api/chat'));
  }

  bool get isGroq => _config.isGroq;

  Future<AiAgentResult> generateAdvice({
    required String userRequest,
    required TripPlanResult plan,
    List<ChatMessage> recentContext = const <ChatMessage>[],
  }) async {
    final username = await UserSession.getUsername();
    final compactPlan = _compactPlan(plan);
    final isGeminiDirect = this.isGeminiDirect;

    final payload = <String, dynamic>{
      'message': userRequest,
      'plan': compactPlan,
      if (recentContext.isNotEmpty)
        'recentContext': _compactRecentTurns(recentContext),
    };

    try {
      Uri uri;
      Map<String, dynamic> requestBody;
      final headers = <String, String>{'Content-Type': 'application/json'};

      final isGroq = this.isGroq;

      if (isGeminiDirect) {
        final baseUrl =
            _config.aiAgentBaseUrl.isNotEmpty &&
                _config.aiAgentBaseUrl.contains(
                  'generativelanguage.googleapis.com',
                )
            ? _config.aiAgentBaseUrl
            : 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent';

        uri = Uri.parse(baseUrl);
        if (_config.aiAgentApiKey.isNotEmpty) {
          uri = uri.replace(queryParameters: {'key': _config.aiAgentApiKey});
        }

        // First attempt: WITH Google Search
        try {
          requestBody = _buildGeminiRequestBody(
            userRequest: userRequest,
            compactPlan: compactPlan,
            recentContext: recentContext,
            enableSearch: true,
          );

          final response = await http
              .post(uri, headers: headers, body: jsonEncode(requestBody))
              .timeout(const Duration(seconds: 20));

          if (response.statusCode >= 200 && response.statusCode < 300) {
            final decoded = jsonDecode(response.body);
            final hasError = _geminiResponseHasError(decoded);
            if (!hasError) {
              final reply = _parseGeminiReply(decoded, userRequest, plan);
              return AiAgentResult(
                reply: reply,
                rawPayload: decoded is Map<String, dynamic>
                    ? decoded
                    : <String, dynamic>{'response': decoded},
                usedFallback: false,
              );
            }
          }
          developer.log('Gemini search attempt failed or had error, retrying without search...');
        } catch (searchError) {
          developer.log('Gemini search request threw error, retrying without search...', error: searchError);
        }

        // Retry: WITHOUT Google Search (fallback)
        requestBody = _buildGeminiRequestBody(
          userRequest: userRequest,
          compactPlan: compactPlan,
          recentContext: recentContext,
          enableSearch: false,
        );

        final retryResponse = await http
            .post(uri, headers: headers, body: jsonEncode(requestBody))
            .timeout(const Duration(seconds: 15));

        if (retryResponse.statusCode >= 200 && retryResponse.statusCode < 300) {
          final decoded = jsonDecode(retryResponse.body);
          final reply = _parseGeminiReply(decoded, userRequest, plan);
          return AiAgentResult(
            reply: reply,
            rawPayload: decoded is Map<String, dynamic>
                ? decoded
                : <String, dynamic>{'response': decoded},
            usedFallback: false,
          );
        }
        throw Exception('AI API Error ${retryResponse.statusCode}');
      } else if (isGroq) {
        uri = Uri.parse(_config.aiAgentBaseUrl);
        headers['Authorization'] = 'Bearer ${_config.aiAgentApiKey}';

        final messages = <Map<String, dynamic>>[
          {'role': 'system', 'content': _getSystemInstruction()},
        ];

        final recentTurns = _compactRecentTurns(recentContext);
        for (final turn in recentTurns) {
          messages.add({
            'role': turn['role'] == 'model' ? 'assistant' : 'user',
            'content': turn['text'],
          });
        }

        messages.add({
          'role': 'user',
          'content': 'Language: ${_languageCode(userRequest)}\nQ: $userRequest\nTrip: ${jsonEncode(compactPlan)}',
        });

        requestBody = <String, dynamic>{
          'model': _config.groqModel,
          'messages': messages,
          'temperature': 0.7,
          'max_tokens': 512,
        };
      } else {
        uri = Uri.parse(
          _config.aiAgentBaseUrl.isNotEmpty
              ? _config.aiAgentBaseUrl
              : '${_config.backendBaseUrl}/api/chat/send',
        );

        if (_config.aiAgentApiKey.isNotEmpty) {
          headers['Authorization'] = 'Bearer ${_config.aiAgentApiKey}';
        }

        requestBody = <String, dynamic>{
          'username': username,
          'message': userRequest,
          'language': _languageCode(userRequest),
          'from': compactPlan['origin'],
          'to': compactPlan['destination'],
          'transportMode': compactPlan['mode'],
          'costMin': compactPlan['costEgp'].toString(),
          'costMax': compactPlan['costEgp'].toString(),
          'timeMax': compactPlan['etaMin'].toString(),
        };
      }

      final response = await http
          .post(uri, headers: headers, body: jsonEncode(requestBody))
          .timeout(const Duration(seconds: 15));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = jsonDecode(response.body);
        final String reply;
        if (isGeminiDirect) {
          reply = _parseGeminiReply(decoded, userRequest, plan);
        } else if (isGroq) {
          reply = _parseGroqReply(decoded, userRequest, plan);
        } else {
          reply = _parseBackendReply(decoded, userRequest, plan);
        }

        return AiAgentResult(
          reply: reply,
          rawPayload: decoded is Map<String, dynamic>
              ? decoded
              : <String, dynamic>{'response': decoded},
          usedFallback: false,
        );
      }

      throw Exception('AI API Error ${response.statusCode}');
    } catch (e) {
      developer.log('Error during AI agent generation', error: e);
      return AiAgentResult(
        reply: localRouteSummary(userRequest, plan),
        rawPayload: {...payload, 'error': e.toString()},
        usedFallback: true,
      );
    }
  }

  String getTransitModeLabel(TransitMode mode) {
    switch (mode) {
      case TransitMode.microbus:
        return 'Microbus';
      case TransitMode.train:
        return 'Train';
      case TransitMode.borderBus:
        return 'Border Bus';
    }
  }

  String localRouteSummary(String userRequest, TripPlanResult plan) {
    final useArabic = _prefersArabic(userRequest);
    final best = plan.routes.isNotEmpty ? plan.routes.first : null;
    if (best == null) {
      if (!useArabic) {
        return 'I checked your question: $userRequest\nNo route is currently available between ${plan.originLabel} and ${plan.destinationLabel}. Try changing the origin or destination.';
      }
      return 'حللت سؤالك: $userRequest\nمفيش مسار متاح حالياً بين ${plan.originLabel} و ${plan.destinationLabel}. جرّب تغيّر نقطة البداية أو المقصد.';
    }

    if (!useArabic) {
      return 'I checked your question: $userRequest\n'
          'Best current route from ${plan.originLabel} to ${plan.destinationLabel}: ${best.title}\n'
          'Mode: ${getTransitModeLabel(best.mode)}\n'
          'ETA: ${best.durationMinutes} minutes\n'
          'Fare: ${best.estimatedCost.toStringAsFixed(1)} EGP\n'
          'Transfers: ${best.transfers}';
    }

    return 'حللت سؤالك: $userRequest\n'
        'أنسب مسار حالياً من ${plan.originLabel} إلى ${plan.destinationLabel}: ${best.title}\n'
        'الوسيلة: ${getTransitModeLabel(best.mode)}\n'
        'الوقت المتوقع: ${best.durationMinutes} دقيقة\n'
        'التكلفة: ${best.estimatedCost.toStringAsFixed(1)} جنيه\n'
        'التحويلات: ${best.transfers}';
  }

String _getSystemInstruction() {
    return 'You are Banhops AI, a friendly and helpful Egyptian assistant. '
        'Your primary expertise is in Egyptian transit and travel '
        '(routes, fares, schedules, transfers, cities, neighborhoods, landmarks, nearby services). '
        'If the user asks about a currently planned trip, use the provided trip context. '
        'You are also happy to answer general knowledge questions, recommendations, '
        'news, weather, sports scores, cultural questions, and any other topic the user asks about. '
        'Use the Google Search tool whenever you need up-to-date or real-time information '
        '(current fares, schedules, news, weather, events, prices, etc.). '
        'Always prefer searching the web when you are not 100% confident in your answer. '
        'Reply in the same language as the user: Arabic if Arabic, English if English. '
        'Mention internal Suzuki fare is 5 EGP when relevant to transit questions. '
        'Only decline if the question is asking you to do something you truly cannot do '
        '(e.g., writing full code programs, solving complex math homework, generating images). '
        'For everything else, be helpful, concise, and friendly.';
  }

  Map<String, dynamic> _buildGeminiRequestBody({
    required String userRequest,
    required Map<String, dynamic> compactPlan,
    required List<ChatMessage> recentContext,
    required bool enableSearch,
  }) {
    final body = <String, dynamic>{
      'systemInstruction': {
        'parts': [
          {'text': _getSystemInstruction()},
        ],
      },
      'contents': _buildGeminiContents(
        userRequest: userRequest,
        plan: compactPlan,
        recentContext: recentContext,
      ),
      'generationConfig': {
        'temperature': 0.7,
        'maxOutputTokens': 1024,
      },
    };
    if (enableSearch) {
      body['tools'] = [
        {'google_search': {}},
      ];
    }
    return body;
  }

  bool _geminiResponseHasError(dynamic decoded) {
    try {
      if (decoded is! Map<String, dynamic>) return true;
      // Check for explicit error field
      if (decoded.containsKey('error')) return true;
      // Check candidates exist
      final candidates = decoded['candidates'];
      if (candidates == null || candidates is! List || candidates.isEmpty) {
        return true;
      }
      final candidate = candidates[0];
      // Check for blocked content
      final finishReason = candidate['finishReason']?.toString() ?? '';
      if (finishReason == 'SAFETY' || finishReason == 'RECITATION') {
        return true;
      }
      // Check content has text parts
      final content = candidate['content'];
      if (content == null) return true;
      final parts = content['parts'];
      if (parts == null || parts is! List || parts.isEmpty) return true;
      // Check at least one part has text
      for (final part in parts) {
        if (part is Map && part.containsKey('text') &&
            part['text'].toString().trim().isNotEmpty) {
          return false;
        }
      }
      return true; // No text parts found
    } catch (e) {
      return true;
    }
  }

  String _parseGeminiReply(
    dynamic decoded,
    String userRequest,
    TripPlanResult plan,
  ) {
    try {
      final parts = decoded['candidates'][0]['content']['parts'] as List;
      final buffer = StringBuffer();
      for (final part in parts) {
        if (part is Map && part.containsKey('text')) {
          buffer.write(part['text']);
        }
      }
      final result = buffer.toString().trim();
      if (result.isNotEmpty) return result;
      return localRouteSummary(userRequest, plan);
    } catch (e) {
      developer.log('Error parsing Gemini direct response', error: e);
      return localRouteSummary(userRequest, plan);
    }
  }

  String _parseGroqReply(
    dynamic decoded,
    String userRequest,
    TripPlanResult plan,
  ) {
    try {
      return decoded['choices'][0]['message']['content'].toString().trim();
    } catch (e) {
      developer.log('Error parsing Groq response', error: e);
      return localRouteSummary(userRequest, plan);
    }
  }

  String _parseBackendReply(
    dynamic decoded,
    String userRequest,
    TripPlanResult plan,
  ) {
    final responseMap = decoded is Map<String, dynamic>
        ? decoded
        : <String, dynamic>{'response': decoded.toString()};
    final reply = responseMap['reply']?.toString().trim();
    final response = responseMap['response']?.toString().trim();
    final message = responseMap['message']?.toString().trim();

    if (reply != null && reply.isNotEmpty) return reply;
    if (response != null && response.isNotEmpty) return response;
    if (message != null && message.isNotEmpty) return message;
    return localRouteSummary(userRequest, plan);
  }

  Map<String, dynamic> _compactPlan(TripPlanResult plan) {
    final best = plan.routes.isNotEmpty ? plan.routes.first : null;
    return <String, dynamic>{
      'origin': plan.originLabel,
      'destination': plan.destinationLabel,
      'mode': best == null ? 'unknown' : getTransitModeLabel(best.mode),
      'etaMin': best?.durationMinutes ?? 0,
      'costEgp': best?.estimatedCost ?? 0,
    };
  }

  List<Map<String, String>> _compactRecentTurns(
    List<ChatMessage> recentContext,
  ) {
    final chatOnly = recentContext
        .where((message) => !message.isSystem)
        .toList();
    final window = chatOnly.skip(chatOnly.length > 6 ? chatOnly.length - 6 : 0);
    return window
        .map(
          (message) => <String, String>{
            'role': message.role == 'assistant' ? 'model' : 'user',
            'text': message.content.trim(),
          },
        )
        .where((message) => message['text']!.isNotEmpty)
        .toList();
  }

  List<Map<String, dynamic>> _buildGeminiContents({
    required String userRequest,
    required Map<String, dynamic> plan,
    required List<ChatMessage> recentContext,
  }) {
    final contents = _compactRecentTurns(recentContext)
        .map(
          (message) => <String, dynamic>{
            'role': message['role'],
            'parts': [
              {'text': message['text']},
            ],
          },
        )
        .toList();

    contents.add({
      'role': 'user',
      'parts': [
        {
          'text':
              'Language: ${_languageCode(userRequest)}\nQ: $userRequest\nTrip: ${jsonEncode(plan)}',
        },
      ],
    });
    return contents;
  }

  String _languageCode(String text) => _prefersArabic(text) ? 'ar' : 'en';

  bool _prefersArabic(String text) => RegExp(r'[\u0600-\u06FF]').hasMatch(text);
}
