import 'dart:convert';
import 'package:http/http.dart' as http;

import '../config/app_config.dart';
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
    return _config.aiAgentBaseUrl.contains('generativelanguage.googleapis.com') ||
           (_config.aiAgentApiKey.isNotEmpty && 
            !_config.aiAgentBaseUrl.contains('railway') && 
            !_config.aiAgentBaseUrl.contains('api/chat'));
  }

  Future<AiAgentResult> generateAdvice({
    required String userRequest,
    required List<TransitRouteOption> alternatives,
    String? origin,
    String? destination,
    Map<String, dynamic> userPreferences = const <String, dynamic>{},
  }) async {
    final username = await UserSession.getUsername();

    // Determine if we should call Gemini API directly.
    final isGeminiDirect = this.isGeminiDirect;

    final payload = <String, dynamic>{
      'message': userRequest,
      'origin': origin,
      'destination': destination,
      'alternatives': alternatives.map((route) => route.toJson()).toList(),
      'preferences': userPreferences,
      'context': _buildContext(userRequest, alternatives, origin, destination, userPreferences),
    };

    try {
      Uri uri;
      Map<String, dynamic> requestBody;
      Map<String, String> headers = {"Content-Type": "application/json"};

      if (isGeminiDirect) {
        final baseUrl = _config.aiAgentBaseUrl.isNotEmpty && 
                       _config.aiAgentBaseUrl.contains('generativelanguage.googleapis.com')
            ? _config.aiAgentBaseUrl
            : 'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent';
        
        uri = Uri.parse(baseUrl);
        if (_config.aiAgentApiKey.isNotEmpty) {
          uri = uri.replace(queryParameters: {'key': _config.aiAgentApiKey});
        }

        final systemInstructionText = _getSystemInstruction();
        final userText = _buildGeminiUserPrompt(userRequest, alternatives, origin, destination, userPreferences);
        
        requestBody = {
          'systemInstruction': {
            'parts': [
              {'text': systemInstructionText}
            ]
          },
          'contents': [
            {
              'role': 'user',
              'parts': [
                {'text': userText}
              ]
            }
          ]
        };
      } else {
        uri = Uri.parse(_config.aiAgentBaseUrl.isNotEmpty 
            ? _config.aiAgentBaseUrl 
            : "https://banhops-backend-production.up.railway.app/api/chat/send");
        
        if (_config.aiAgentApiKey.isNotEmpty) {
          headers['Authorization'] = 'Bearer ${_config.aiAgentApiKey}';
        }

        final instruction = 'IMPORTANT INSTRUCTION: ONLY answer if the user message is about transportation, routes, stations, microbuses, trains, costs, or transit in Benha/Qalyubia. If it is NOT related (e.g. sports like "Egypt or Senegal", politics, programming, cooking, general knowledge, etc.), you MUST decline to answer. Directly say: "عذراً، أنا مساعد ذكي مخصص للإجابة على استفسارات مواصلات وطرق بنها والقليوبية فقط. كيف يمكنني مساعدتك في رحلتك اليوم؟" and do not say anything else.';
        
        // Inject all route options into context so the backend LLM can see them
        String contextInfo = '';
        if (alternatives.isNotEmpty) {
          final routesText = alternatives.map((r) => '${r.title} (${getTransitModeLabel(r.mode)}, cost: ${r.estimatedCost} EGP, duration: ${r.durationMinutes} minutes)').join(', ');
          contextInfo = ' [Available route alternatives: $routesText]';
        }
        
        final fromParam = origin != null ? '$origin$contextInfo ($instruction)' : '$instruction$contextInfo';

        final bestAlternative = alternatives.isNotEmpty ? alternatives.first : null;
        requestBody = {
          "username": username,
          "message": userRequest,
          "from": fromParam,
          if (destination != null) "to": destination,
          if (bestAlternative != null) "transportMode": getTransitModeLabel(bestAlternative.mode),
          if (bestAlternative != null) "costMin": bestAlternative.estimatedCost.toString(),
          if (bestAlternative != null) "costMax": bestAlternative.estimatedCost.toString(),
          "timeMin": "0",
          if (bestAlternative != null) "timeMax": bestAlternative.durationMinutes.toString(),
        };
      }

      final response = await http.post(
        uri,
        headers: headers,
        body: jsonEncode(requestBody),
      ).timeout(const Duration(seconds: 12));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = jsonDecode(response.body);
        String reply;
        
        if (isGeminiDirect) {
          try {
            reply = decoded['candidates'][0]['content']['parts'][0]['text'].toString().trim();
          } catch (e) {
            print('Error parsing Gemini direct response: $e. Body: ${response.body}');
            reply = _fallbackResponse(userRequest, alternatives);
          }
        } else {
          final responseMap = decoded is Map<String, dynamic> ? decoded : <String, dynamic>{'response': decoded.toString()};
          reply = responseMap['reply']?.toString().trim().isNotEmpty == true
              ? responseMap['reply'].toString().trim()
              : responseMap['response']?.toString().trim().isNotEmpty == true
                  ? responseMap['response'].toString().trim()
                  : responseMap['message']?.toString().trim().isNotEmpty == true
                      ? responseMap['message'].toString().trim()
                      : _fallbackResponse(userRequest, alternatives);
        }

        return AiAgentResult(
          reply: reply,
          rawPayload: decoded is Map<String, dynamic> ? decoded : <String, dynamic>{'response': decoded},
          usedFallback: false,
        );
      }
      
      throw Exception("AI API Error ${response.statusCode}");
    } catch (e) {
      print('Error during AI agent generation: $e');
      return AiAgentResult(
        reply: _fallbackResponse(userRequest, alternatives),
        rawPayload: {
          ...payload,
          'error': e.toString(),
        },
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

  String _getSystemInstruction() {
    return '''أنت "بنهوبس AI" - مساعد رحلات ومواصلات ذكي لمحافظة القليوبية ومدينة بنها وضواحيها.
مهمتك الأساسية هي تزويد المستخدمين بإرشادات تفصيلية، دقيقة، ومفيدة حول وسائل النقل والتكلفة وأفضل الطرق والربط بين المحطات بناءً على الخيارات المتاحة.

قواعد هامة جداً عن حركة المواصلات المحلية والداخلية في بنها يجب أن تفهمها وتصيغ إجاباتك بناءً عليها:
1. الوجهات الـ 10 المتاحة في مدينة بنها هي:
   - موقف بنها (الموقف الرئيسي ميكروباصات لكل المحافظات).
   - محطة قطار بنها (السكة الحديد).
   - مجمع الكليات (كلية تجارة - كلية اداب).
   - إدارة الجامعة.
   - كلية طب ومستشفى الجامعة وكورنيش النيل (إشارة).
   - منطقة الأهرام.
   - كوبري (بنها القديمة).
   - كلية الحقوق.
   - المدينة الجامعية.
   - منطقة الفلل.
2. قاعدة السوزوكي الداخلي (أجرة 5 جنيه):
   - للذهاب لأي مقصد من المقاصد الداخلية (مجمع الكليات، إدارة الجامعة، منطقة الأهرام، كلية الحقوق، إلخ): يسافر الراكب بميكروباص للموقف أولاً، ثم يستقل "سوزوكي داخلي" من الموقف للوجهة المحددة بأجرة ثابتة 5 جنيه.
   - استثناء محطة قطار بنها: إذا كان قادماً بالقطار، فإنه ينزل في "محطة قطار بنها" مباشرة دون الحاجة للذهاب للموقف أو دفع 5 جنيه للسوزوكي. أما إذا كان قادماً بميكروباص، فيصل للموقف أولاً ثم يستقل سوزوكي داخلي بـ 5 جنيه للمحطة.
3. القرى والمناطق الفرعية:
   - جميع القرى الفرعية بالقليوبية والمنوفية (مثل دجوى، طحلة، بطا، العمار، بلتان، برشوم، ميت بره، مشيرف، إلخ) تظهر في قائمة "المدينة/المنطقة". وضح لهم أن لها مواصلات ميكروباص محلية ومباشرة من موقف بنها.

قاعدة أساسية وصارمة حول نطاق الأسئلة:
- يجب عليك عدم الإجابة على أي أسئلة ليس لها علاقة بمشروع "بنهوبس" أو مواصلات بنها والقليوبية والرحلات والاتجاهات والطرق والأسعار.
- إذا سألك المستخدم عن أي موضوع خارج هذا النطاق (مثل: البرمجة، الطبخ، العلوم والتاريخ، الترجمة العامة، الترفيه، أو أي أسئلة عامة أخرى)، يجب عليك رفض الإجابة بلطف واعتذر له بوضوح موضحاً أنك مساعد ذكي مخصص فقط لمساعدة المستخدمين في الاستفسار عن طرق ومواصلات بنها وضواحيها.

عند الإجابة:
- كن ودوداً ومرحباً، تحدث بلهجة مصرية مهذبة ومحببة أو لغة عربية سهلة وواضحة.
- قم بتحليل بدائل المسارات المتاحة المرفقة وقارن بينها لتنصح المستخدم بالخيار الأفضل (مثلاً: "الخيار الأول أرخص لكن الخيار الثاني أسرع...") ووضح له خطوات التحويل.
- إذا لم تكن هناك خيارات سير متاحة في البيانات المرفقة, اقترح عليه حلولاً عامة ذكية وتوجيهات منطقية للوصول للموقف ثم ركوب السوزوكي الداخلي للوجهة.''';
  }

  String _buildGeminiUserPrompt(
    String userRequest,
    List<TransitRouteOption> alternatives,
    String? origin,
    String? destination,
    Map<String, dynamic> userPreferences,
  ) {
    final buffer = StringBuffer()
      ..writeln('تنبيه صارم جداً للنموذج: يجب عليك فحص سؤال المستخدم. إذا كان سؤال المستخدم ليس له علاقة بمواصلات وطرق وأسعار بنها والقليوبية (مثل مقارنة الفرق الرياضية، البرمجة، الأسئلة العامة)، يجب عليك فوراً رفض الإجابة والاعتذار بلطف بصيغة محددة كالتالي دون إعطاء أي معلومات أو آراء عن السؤال الخارجي: "عذراً، أنا مساعد ذكي مخصص للإجابة على استفسارات مواصلات وطرق بنها والقليوبية فقط. كيف يمكنني مساعدتك في رحلتك اليوم؟".')
      ..writeln('سؤال المستخدم الحالي: $userRequest')
      ..writeln('مكان البداية (Origin): ${origin ?? 'غير محدد'}')
      ..writeln('المقصد النهائي في بنها (Destination): ${destination ?? 'غير محدد'}')
      ..writeln('بدائل الطرق المتاحة المحتسبة حالياً في الكود:');

    if (alternatives.isEmpty) {
      buffer.writeln('لا توجد خيارات مسارات مباشرة محتسبة في قاعدة البيانات.');
    } else {
      for (final route in alternatives) {
        buffer.writeln(
          '- البديل: ${route.title} | وسيلة النقل: ${getTransitModeLabel(route.mode)} | التكلفة: ${route.estimatedCost} جنيه | عدد التحويلات: ${route.transfers} | تفاصيل المسار: ${route.details}'
        );
      }
    }
    return buffer.toString();
  }

  String _buildContext(
    String userRequest,
    List<TransitRouteOption> alternatives,
    String? origin,
    String? destination,
    Map<String, dynamic> userPreferences,
  ) {
    final buffer = StringBuffer()
      ..writeln('User request: $userRequest')
      ..writeln('Origin: ${origin ?? 'unknown'}')
      ..writeln('Destination: ${destination ?? 'unknown'}')
      ..writeln('Preferences: ${jsonEncode(userPreferences)}')
      ..writeln('Available routes:');

    for (final route in alternatives) {
      buffer
        ..writeln('- ${route.title} | mode=${getTransitModeLabel(route.mode)} | duration=${route.durationMinutes} min | cost=${route.estimatedCost} EGP | transfers=${route.transfers} | score=${route.score.toStringAsFixed(3)}');
    }

    return buffer.toString();
  }

  String _fallbackResponse(String userRequest, List<TransitRouteOption> alternatives) {
    final best = alternatives.isNotEmpty ? alternatives.first : null;
    final buffer = StringBuffer()
      ..writeln('I analyzed your request: $userRequest')
      ..writeln('')
      ..writeln('Recommended route: ${best?.title ?? 'No route data available'}')
      ..writeln('ETA: ${best?.durationMinutes ?? 0} minutes')
      ..writeln('Fare: ${best?.estimatedCost.toStringAsFixed(2) ?? '0.00'} EGP')
      ..writeln('Transfers: ${best?.transfers ?? 0}')
      ..writeln('')
      ..writeln('Smart Insight: choose the fastest route if you are prioritizing punctuality, otherwise the cheapest route saves fare with a small time tradeoff.');
    return buffer.toString();
  }
}