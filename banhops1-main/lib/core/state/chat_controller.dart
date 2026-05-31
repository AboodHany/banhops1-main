import 'package:flutter/material.dart';

import '../config/app_config.dart';
import '../models/chat_message.dart';
import '../models/transit_enums.dart';
import '../models/transit_route_option.dart';
import '../services/ai_agent_service.dart';
import '../services/supabase_service.dart';

class ChatController extends ChangeNotifier {
  ChatController({required AppConfig config})
      : _aiAgentService = AiAgentService(config) {
    _messages = <ChatMessage>[
      ChatMessage(
        role: 'assistant',
        content: 'Ask me about the fastest, cheapest, or least-transfer route in Benha.',
        createdAt: DateTime.now(),
        isSystem: true,
      ),
    ];
  }

  final AiAgentService _aiAgentService;

  List<ChatMessage> _messages = <ChatMessage>[];
  ChatPhase _phase = ChatPhase.readyForQAndA;
  String? _lastResponse;

  List<ChatMessage> get messages => List.unmodifiable(_messages);
  ChatPhase get phase => _phase;
  String? get lastResponse => _lastResponse;

  Future<void> ask({
    required String prompt,
    required List<TransitRouteOption> alternatives,
    String? origin,
    String? destination,
  }) async {
    if (prompt.trim().isEmpty) {
      return;
    }

    _messages = [
      ..._messages,
      ChatMessage(role: 'user', content: prompt.trim(), createdAt: DateTime.now()),
    ];
    _phase = ChatPhase.analyzingInput;
    notifyListeners();

    final result = await _aiAgentService.generateAdvice(
      userRequest: prompt,
      alternatives: alternatives,
      origin: origin,
      destination: destination,
      userPreferences: <String, dynamic>{
        'supabaseSession': SupabaseService.isInitialized
            ? SupabaseService.client?.auth.currentSession?.user.id
            : null,
      },
    );

    _lastResponse = result.reply;
    _messages = [
      ..._messages,
      ChatMessage(
        role: 'assistant',
        content: result.reply,
        createdAt: DateTime.now(),
        isSystem: result.usedFallback,
      ),
    ];
    _phase = ChatPhase.responseGenerated;
    notifyListeners();

    _phase = ChatPhase.readyForQAndA;
    notifyListeners();
  }
}