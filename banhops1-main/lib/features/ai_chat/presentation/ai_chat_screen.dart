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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final chat = context.watch<ChatController>();
    final planner = context.watch<TripPlannerController>();
    final plan = planner.latestPlan ?? planner.planTrip();

    return Scaffold(
      appBar: AppBar(title: Text(localization.translate('ai_assistant'))),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: chat.messages.length,
              itemBuilder: (context, index) {
                final message = chat.messages[index];
                return Align(
                  alignment: message.role == 'user' ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(14),
                    constraints: const BoxConstraints(maxWidth: 420),
                    decoration: BoxDecoration(
                      color: message.role == 'user' ? const Color(0xFF0F4C81) : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      message.content,
                      style: TextStyle(
                        color: message.role == 'user' ? Colors.white : const Color(0xFF1A1F2B),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
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
                    onPressed: () => _sendPrompt(context, chip, plan),
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
                      decoration: const InputDecoration(hintText: 'Ask anything about your trip'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  IconButton.filled(
                    onPressed: chat.phase == ChatPhase.analyzingInput
                        ? null
                        : () => _sendPrompt(context, _controller.text, plan),
                    icon: chat.phase == ChatPhase.analyzingInput
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
    await context.read<ChatController>().ask(
          prompt: normalized,
          alternatives: plan.routes,
          origin: plan.originLabel,
          destination: plan.destinationLabel,
        );
    if (context.mounted) {
      _controller.clear();
    }
  }
}
