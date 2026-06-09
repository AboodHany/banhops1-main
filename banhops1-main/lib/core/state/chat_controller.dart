import 'package:flutter/material.dart';

import '../config/app_config.dart';
import '../models/chat_message.dart';
import '../models/transit_enums.dart';
import '../models/transit_route_option.dart';
import '../services/ai_agent_service.dart';
import '../services/chat_persistence_service.dart';
import '../services/user_session.dart';

const String kTransitScopeApologyAr =
    'عذراً، أنا مساعد ذكي مخصص للإجابة على استفسارات المواصلات والرحلات فقط. كيف يمكنني مساعدتك في رحلتك اليوم؟';
const String kTransitScopeApologyEn =
    'Sorry, I can only help with transit, routes, fares, and trips. How can I help with your trip today?';

class ChatController extends ChangeNotifier {
  ChatController({required AppConfig config})
    : _aiAgentService = AiAgentService(config) {
    initChat();
  }

  final AiAgentService _aiAgentService;

  List<ChatMessage> _messages = <ChatMessage>[];
  ChatPhase _phase = ChatPhase.readyForQAndA;
  String? _lastResponse;
  String _username = 'guest';

  List<ChatMessage> get messages => List.unmodifiable(_messages);
  ChatPhase get phase => _phase;
  String? get lastResponse => _lastResponse;

  Future<void> initChat() async {
    _username = await UserSession.getUsername();
    await loadHistory();
  }

  Future<void> loadHistory() async {
    try {
      final data = await ChatPersistenceService.getMessages(_username);
      if (data.isNotEmpty) {
        _messages = data
            .map(
              (m) => ChatMessage(
                role: m['isUser'] == true ? 'user' : 'assistant',
                content: m['message'] ?? '',
                createdAt:
                    DateTime.tryParse(m['createdAt'] ?? '') ?? DateTime.now(),
              ),
            )
            .toList();
      } else {
        _messages = <ChatMessage>[
          ChatMessage(
            role: 'assistant',
            content:
                'Ask me about the fastest, cheapest, or least-transfer route in Benha.',
            createdAt: DateTime.now(),
            isSystem: true,
          ),
        ];
      }
      notifyListeners();
    } catch (_) {}
  }

  Future<void> clearChat() async {
    try {
      await ChatPersistenceService.clearChat(_username);
      _messages = <ChatMessage>[
        ChatMessage(
          role: 'assistant',
          content:
              'Ask me about the fastest, cheapest, or least-transfer route in Benha.',
          createdAt: DateTime.now(),
          isSystem: true,
        ),
      ];
      notifyListeners();
    } catch (_) {}
  }

  Future<void> ask({
    required String prompt,
    required TripPlanResult plan,
  }) async {
    final normalizedPrompt = prompt.trim();
    if (normalizedPrompt.isEmpty) {
      return;
    }

    final recentContext = _recentTurns();
    final userMsg = ChatMessage(
      role: 'user',
      content: normalizedPrompt,
      createdAt: DateTime.now(),
    );
    _messages = [..._messages, userMsg];
    _phase = ChatPhase.analyzingInput;
    notifyListeners();

    try {
      if (!_isTransitScoped(normalizedPrompt, recentContext)) {
        await _appendAssistant(
          _scopeApology(normalizedPrompt),
          isSystem: true,
          persist: true,
        );
        return;
      }

      // Only persist user message on client side if we are calling Gemini API directly.
      // If we use the Railway backend, it handles database persistence internally.
      if (_aiAgentService.isGeminiDirect) {
        await ChatPersistenceService.saveMessage(
          username: _username,
          message: normalizedPrompt,
          isUser: true,
        );
      }

      final result = await _aiAgentService.generateAdvice(
        userRequest: normalizedPrompt,
        plan: plan,
        recentContext: recentContext,
      );

      _lastResponse = result.reply;
      await _appendAssistant(result.reply, isSystem: result.usedFallback);
    } catch (e) {
      debugPrint('Error in ChatController.ask: $e');
      await _appendAssistant(
        _aiAgentService.localRouteSummary(normalizedPrompt, plan),
        isSystem: true,
      );
    } finally {
      _phase = ChatPhase.readyForQAndA;
      notifyListeners();
    }
  }

  List<ChatMessage> _recentTurns() {
    final chatOnly = _messages.where((message) => !message.isSystem).toList();
    return chatOnly
        .skip(chatOnly.length > 6 ? chatOnly.length - 6 : 0)
        .toList();
  }

  Future<void> _appendAssistant(
    String reply, {
    bool isSystem = false,
    bool persist = false,
  }) async {
    _lastResponse = reply;
    _messages = [
      ..._messages,
      ChatMessage(
        role: 'assistant',
        content: reply,
        createdAt: DateTime.now(),
        isSystem: isSystem,
      ),
    ];

    if (_aiAgentService.isGeminiDirect || persist) {
      await ChatPersistenceService.saveMessage(
        username: _username,
        message: reply,
        isUser: false,
      );
    }
  }

  bool _isTransitScoped(String prompt, List<ChatMessage> recentContext) {
    final text = prompt.toLowerCase();

    const transitTerms = <String>[
      'route',
      'routes',
      'trip',
      'transport',
      'transit',
      'microbus',
      'bus',
      'train',
      'station',
      'terminal',
      'fare',
      'cost',
      'price',
      'time',
      'eta',
      'fastest',
      'cheapest',
      'nearest',
      'transfer',
      'benha',
      'qalyubia',
      'go',
      'travel',
      'how',
      'get to',
      'where',
      'stop',
      'ticket',
      'cairo',
      'giza',
      'alex',
      'mansoura',
      'tanta',
      'gamasa',
      'damietta',
      'zagazig',
      'monufia',
      'menofia',
      'sharqia',
      'gharbia',
      'dakahlia',
      'beheira',
      'kafr',
      'ismailia',
      'suez',
      'port said',
      'fayoum',
      'minya',
      'assiut',
      'sohag',
      'qena',
      'luxor',
      'aswan',
      'مواصل',
      'طريق',
      'سفر',
      'رحل',
      'مشوار',
      'ميكرو',
      'مكرو',
      'باص',
      'اتوبيس',
      'أتوبيس',
      'سوزوكي',
      'سوزوكى',
      'قطار',
      'قطر',
      'محط',
      'موقف',
      'أجر',
      'اجر',
      'تكلف',
      'سعر',
      'أسعار',
      'اسعار',
      'تذكر',
      'وقت',
      'أسرع',
      'اسرع',
      'أرخص',
      'ارخص',
      'أقرب',
      'اقرب',
      'تحويل',
      'بنها',
      'قليوب',
      'جمص',
      'بلطيم',
      'منصور',
      'دمياط',
      'اسكندر',
      'إسكندر',
      'قاهر',
      'جيز',
      'طنطا',
      'زقازيق',
      'شيبين',
      'شبين',
      'منوف',
      'محل',
      'فيوم',
      'سويس',
      'اسماعيل',
      'إسماعيل',
      'بورسعيد',
      'عريش',
      'شرق',
      'غرب',
      'دقهل',
      'بحير',
      'كفر',
      'ذهاب',
      'الذهاب',
      'ذاهب',
      'اذهب',
      'أذهب',
      'اروح',
      'أروح',
      'روح',
      'اوصل',
      'أوصل',
      'وصل',
      'كيف',
      'ازاي',
      'إزاي',
      'فين',
      'ليه',
      'متى',
      'امتى',
      'إمتى',
      'كام',
      'بكام',
      'كم',
      'بلد',
      'بلاد',
      'محافظ',
      'مدين',
      'قرية',
      'قريه',
      'مركز',
      'شارع',
      'حي',
      'حى',
      'ميدان',
    ];

    if (transitTerms.any(text.contains)) {
      return true;
    }

    const followUpTerms = <String>[
      'how much',
      'how long',
      'what about',
      'and',
      'there',
      'it',
      'كم',
      'كام',
      'بكام',
      'قد ايه',
      'قد إيه',
      'ازاي',
      'إزاي',
      'اروح',
      'أروح',
    ];

    return recentContext.isNotEmpty && followUpTerms.any(text.contains);
  }

  String _scopeApology(String prompt) {
    return _prefersArabic(prompt)
        ? kTransitScopeApologyAr
        : kTransitScopeApologyEn;
  }

  bool _prefersArabic(String text) => RegExp(r'[\u0600-\u06FF]').hasMatch(text);
}
