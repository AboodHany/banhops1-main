import 'package:flutter/material.dart';

import '../config/app_config.dart';
import '../models/chat_message.dart';
import '../models/transit_enums.dart';
import '../models/transit_route_option.dart';
import '../services/ai_agent_service.dart';
import '../services/chat_persistence_service.dart';
import '../services/user_session.dart';

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
        _messages = data.map((m) => ChatMessage(
          role: m['isUser'] == true ? 'user' : 'assistant',
          content: m['message'] ?? '',
          createdAt: DateTime.tryParse(m['createdAt'] ?? '') ?? DateTime.now(),
        )).toList();
      } else {
        _messages = <ChatMessage>[
          ChatMessage(
            role: 'assistant',
            content: 'Ask me about the fastest, cheapest, or least-transfer route in Benha.',
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
          content: 'Ask me about the fastest, cheapest, or least-transfer route in Benha.',
          createdAt: DateTime.now(),
          isSystem: true,
        ),
      ];
      notifyListeners();
    } catch (_) {}
  }

  Future<void> ask({
    required String prompt,
    required List<TransitRouteOption> alternatives,
    String? origin,
    String? destination,
  }) async {
    if (prompt.trim().isEmpty) {
      return;
    }

    final userMsg = ChatMessage(role: 'user', content: prompt.trim(), createdAt: DateTime.now());
    _messages = [..._messages, userMsg];
    _phase = ChatPhase.analyzingInput;
    notifyListeners();

    try {
      // Only persist user message on client side if we are calling Gemini API directly.
      // If we use the Railway backend, it handles database persistence internally.
      if (_aiAgentService.isGeminiDirect) {
        await ChatPersistenceService.saveMessage(
          username: _username,
          message: prompt.trim(),
          isUser: true,
        );
      }

      final result = await _aiAgentService.generateAdvice(
        userRequest: prompt,
        alternatives: alternatives,
        origin: origin,
        destination: destination,
      );

      _lastResponse = result.reply;
      final assistantMsg = ChatMessage(
        role: 'assistant',
        content: result.reply,
        createdAt: DateTime.now(),
        isSystem: result.usedFallback,
      );
      _messages = [..._messages, assistantMsg];
      
      // Only persist assistant message on client side if we are calling Gemini API directly.
      if (_aiAgentService.isGeminiDirect) {
        await ChatPersistenceService.saveMessage(
          username: _username,
          message: result.reply,
          isUser: false,
        );
      }
    } catch (e) {
      print('Error in ChatController.ask: $e');
      final errorMsg = ChatMessage(
        role: 'assistant',
        content: 'Sorry, I couldn\'t connect to the server. Please check your network and try again.',
        createdAt: DateTime.now(),
        isSystem: true,
      );
      _messages = [..._messages, errorMsg];
    } finally {
      _phase = ChatPhase.readyForQAndA;
      notifyListeners();
    }
  }
}