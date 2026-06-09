import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/localization/app_localizations.dart';
import '../../../core/models/transit_enums.dart';
import '../../../core/models/transit_route_option.dart';
import '../../../core/state/chat_controller.dart';
import '../../../core/state/trip_planner_controller.dart';

class AIChatScreen extends StatefulWidget {
  const AIChatScreen({super.key});

  @override
  State<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> {
  final _controller = TextEditingController();
  final _scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatController>().initChat();
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollCtrl.hasClients) {
      _scrollCtrl.animateTo(
        _scrollCtrl.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    }
  }

  void _confirmClearChat(ChatController chat, AppLocalizations localization) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(localization.translate('clear_chat_history')),
        content: Text(localization.translate('clear_chat_confirm')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(localization.translate('cancel')),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(localization.translate('clear'), style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (ok == true) {
      await chat.clearChat();
      _scrollToBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final chat = context.watch<ChatController>();
    final planner = context.watch<TripPlannerController>();
    final plan = planner.latestPlan ?? planner.planTrip();
    final isTyping = chat.phase == ChatPhase.analyzingInput;

    // Trigger scroll to bottom on new message
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    return Scaffold(
      appBar: AppBar(
        title: Text(localization.translate('ai_assistant')),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 20),
            label: Text(
              localization.translate('clear_chat_button'),
              style: const TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            onPressed: () => _confirmClearChat(chat, localization),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollCtrl,
              padding: const EdgeInsets.all(16),
              itemCount: chat.messages.length + (isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (isTyping && index == chat.messages.length) {
                  return const _TypingBubble();
                }
                final message = chat.messages[index];
                final isUser = message.role == 'user';
                final parsedRoute = !isUser ? _parseRouteFromText(message.content) : null;
                final displayText = isUser ? message.content : _cleanMessageText(message.content);

                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(14),
                    constraints: const BoxConstraints(maxWidth: 420),
                    decoration: BoxDecoration(
                      color: isUser ? const Color(0xFF0F4C81) : Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(20),
                        topRight: const Radius.circular(20),
                        bottomLeft: Radius.circular(isUser ? 20 : 4),
                        bottomRight: Radius.circular(isUser ? 4 : 20),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(5),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (displayText.isNotEmpty)
                          Text(
                            displayText,
                            style: TextStyle(
                              color: isUser ? Colors.white : const Color(0xFF1A1F2B),
                            ),
                          ),
                        if (parsedRoute != null) _ChatRouteCard(route: parsedRoute),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          if (chat.messages.length <= 1)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final chip in [
                    localization.translate('fastest_route'),
                    localization.translate('what_cost'),
                    localization.translate('nearest_station'),
                  ])
                    ActionChip(
                      label: Text(chip),
                      onPressed: isTyping ? null : () => _sendPrompt(context, chip, plan),
                    ),
                ],
              ),
            ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: localization.translate('ask_anything_hint'),
                      ),
                      onSubmitted: isTyping ? null : (_) => _sendPrompt(context, _controller.text, plan),
                    ),
                  ),
                  const SizedBox(width: 12),
                  IconButton.filled(
                    onPressed: isTyping
                        ? null
                        : () => _sendPrompt(context, _controller.text, plan),
                    icon: isTyping
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Icon(Icons.send_rounded),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _sendPrompt(BuildContext context, String prompt, TripPlanResult plan) async {
    final normalized = prompt.trim();
    if (normalized.isEmpty) {
      return;
    }
    _controller.clear();
    await context.read<ChatController>().ask(
          prompt: normalized,
          alternatives: plan.routes,
          origin: plan.originLabel,
          destination: plan.destinationLabel,
        );
  }
}

class _TypingBubble extends StatefulWidget {
  const _TypingBubble();

  @override
  State<_TypingBubble> createState() => _TypingBubbleState();
}

class _TypingBubbleState extends State<_TypingBubble> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(4),
            bottomRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(5),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            return AnimatedBuilder(
              animation: _ctrl,
              builder: (_, __) {
                final t = ((_ctrl.value + i * 0.22) % 1.0);
                final offset = sin(t * pi * 2) * 2.5;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.5),
                  child: Transform.translate(
                    offset: Offset(0, offset),
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Color(0xFF0F4C81),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                );
              },
            );
          }),
        ),
      ),
    );
  }
}

class ParsedRoute {
  final String transport;
  final String costMin;
  final String costMax;
  final String timeMin;
  final String timeMax;

  ParsedRoute({
    required this.transport,
    required this.costMin,
    required this.costMax,
    required this.timeMin,
    required this.timeMax,
  });
}

ParsedRoute? _parseRouteFromText(String text) {
  final regex = RegExp(r'<ROUTE>([\s\S]*?)<ROUTE/>');
  final match = regex.firstMatch(text);
  if (match == null) return null;

  final block = match.group(1) ?? '';
  String transport = 'MICROBUS';
  String costMin = '0';
  String costMax = '0';
  String timeMin = '0';
  String timeMax = '0';

  final lines = block.split('\n');
  for (final line in lines) {
    final parts = line.split(':');
    if (parts.length < 2) continue;
    final key = parts[0].trim().toLowerCase();
    final value = parts[1].trim();

    if (key == 'transport') {
      transport = value;
    } else if (key == 'cost_min') {
      costMin = value;
    } else if (key == 'cost_max') {
      costMax = value;
    } else if (key == 'time_min') {
      timeMin = value;
    } else if (key == 'time_max') {
      timeMax = value;
    }
  }

  return ParsedRoute(
    transport: transport,
    costMin: costMin,
    costMax: costMax,
    timeMin: timeMin,
    timeMax: timeMax,
  );
}

String _cleanMessageText(String text) {
  final regex = RegExp(r'<ROUTE>([\s\S]*?)<ROUTE/>');
  return text.replaceAll(regex, '').trim();
}

class _ChatRouteCard extends StatelessWidget {
  final ParsedRoute route;
  const _ChatRouteCard({required this.route});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    IconData icon = Icons.directions_bus_rounded;
    Color color = const Color(0xFF0F4C81);
    String modeLabel = localization.translate(route.transport.toLowerCase());

    if (route.transport.toUpperCase() == 'TRAIN') {
      icon = Icons.train_rounded;
      color = const Color(0xFF1B998B);
    } else if (route.transport.toUpperCase() == 'MICROBUS') {
      icon = Icons.directions_bus_filled_rounded;
      color = const Color(0xFFE28743);
    } else if (route.transport.toUpperCase() == 'PUBLIC_BUS') {
      icon = Icons.directions_bus_rounded;
      color = const Color(0xFF0F4C81);
    }

    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  modeLabel,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.access_time_rounded, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      '${route.timeMin}-${route.timeMax} ${localization.translate('min')}',
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                    const SizedBox(width: 12),
                    const Icon(Icons.payments_outlined, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      '${route.costMin}-${route.costMax} ${localization.translate('egp')}',
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
