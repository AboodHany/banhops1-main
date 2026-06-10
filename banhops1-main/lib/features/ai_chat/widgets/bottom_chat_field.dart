import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:banhops1/features/ai_chat/state/chat_provider.dart';
import 'package:banhops1/features/ai_chat/state/settings_provider.dart';
import 'package:banhops1/features/ai_chat/utilities/app_motion.dart';
import 'package:banhops1/features/ai_chat/utilities/app_snackbar.dart';
import 'package:banhops1/features/ai_chat/utilities/chat_error_formatter.dart';
import 'package:banhops1/core/localization/app_localizations.dart';
import 'package:banhops1/core/state/trip_planner_controller.dart';
import 'package:provider/provider.dart';

class BottomChatField extends StatefulWidget {
  const BottomChatField({
    super.key,
    required this.chatProvider,
  });

  final ChatProvider chatProvider;

  @override
  State<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends State<BottomChatField> {
  final TextEditingController textController = TextEditingController();
  final FocusNode textFieldFocus = FocusNode();

  @override
  void initState() {
    textController.addListener(_handleComposerChange);
    super.initState();
  }

  void _handleComposerChange() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    textController.removeListener(_handleComposerChange);
    textController.dispose();
    textFieldFocus.dispose();
    super.dispose();
  }

  Future<void> sendChatMessage({
    required String message,
    required ChatProvider chatProvider,
  }) async {
    final enableHaptics = context.read<SettingsProvider>().enableHaptics;
    
    // Read local planned trip context automatically
    final planner = context.read<TripPlannerController>();
    final plan = planner.latestPlan ?? planner.planTrip();

    final draftText = message;
    var didSend = false;

    try {
      if (draftText.trim().isNotEmpty) {
        textController.clear();
      }
      
      await chatProvider.sentMessage(
        message: draftText.trim(),
        isTextOnly: true,
        plan: plan, // pass transit plan context automatically
      );
      didSend = true;
      if (enableHaptics) {
        await HapticFeedback.lightImpact();
      }
    } catch (e) {
      if (!mounted) {
        return;
      }
      if (!didSend && draftText.trim().isNotEmpty && textController.text.isEmpty) {
        textController.value = TextEditingValue(
          text: draftText,
          selection: TextSelection.collapsed(offset: draftText.length),
        );
      }
      showAppSnackBar(context, formatChatError(e), bottomOffset: 132);
    }
  }

  Future<void> _submitCurrentDraft() async {
    final canSend = textController.text.trim().isNotEmpty;

    if (widget.chatProvider.isLoading || !canSend) {
      return;
    }

    await sendChatMessage(
      message: textController.text,
      chatProvider: widget.chatProvider,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final settingsProvider = context.watch<SettingsProvider>();
    final motionDuration =
        settingsProvider.reduceMotion ? Duration.zero : AppMotion.regular;

    final canSend = textController.text.trim().isNotEmpty;

    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerLow.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: colorScheme.outlineVariant.withValues(alpha: 0.38),
            ),
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withValues(alpha: 0.12),
                blurRadius: 28,
                offset: const Offset(0, 16),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(30),
            child: AnimatedSize(
              duration: motionDuration,
              curve: AppMotion.curve,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: TextField(
                          focusNode: textFieldFocus,
                          controller: textController,
                          autofocus: settingsProvider.autoFocusComposer &&
                              widget.chatProvider.inChatMessages.isEmpty,
                          keyboardType: TextInputType.multiline,
                          textInputAction: TextInputAction.send,
                          minLines: 1,
                          maxLines: 5,
                          textCapitalization: TextCapitalization.sentences,
                          onSubmitted: settingsProvider.sendWithEnter
                              ? (_) => _submitCurrentDraft()
                              : null,
                          decoration: InputDecoration(
                            hintText: AppLocalizations.of(context).translate('message_hint'),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            focusedErrorBorder: InputBorder.none,
                            filled: false,
                            contentPadding: EdgeInsets.fromLTRB(
                              18,
                              18,
                              10,
                              18,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8, bottom: 8, left: 8),
                        child: IconButton.filled(
                          onPressed: widget.chatProvider.isLoading || !canSend
                              ? null
                              : _submitCurrentDraft,
                          icon: widget.chatProvider.isLoading
                              ? SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.2,
                                    color: colorScheme.onPrimary,
                                  ),
                                )
                              : const Icon(CupertinoIcons.arrow_up),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
