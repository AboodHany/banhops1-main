import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:banhops1/features/ai_chat/apis/api_service.dart';
import 'package:banhops1/features/ai_chat/state/chat_provider.dart';
import 'package:banhops1/features/ai_chat/state/settings_provider.dart';
import 'package:banhops1/features/ai_chat/utilities/app_motion.dart';
import 'package:banhops1/features/ai_chat/utilities/app_snackbar.dart';
import 'package:banhops1/features/ai_chat/utilities/chat_error_formatter.dart';
import 'package:banhops1/features/ai_chat/widgets/app_screen_scaffold.dart';
import 'package:banhops1/features/ai_chat/widgets/chat/chat_empty_state.dart';
import 'package:banhops1/features/ai_chat/widgets/chat/chat_header.dart';
import 'package:banhops1/features/ai_chat/widgets/chat_messages.dart';
import 'package:banhops1/features/ai_chat/widgets/bottom_chat_field.dart';
import 'package:banhops1/core/state/trip_planner_controller.dart';
import 'package:provider/provider.dart';

class AIChatScreen extends StatefulWidget {
  const AIChatScreen({super.key, this.initialPrompt});

  final String? initialPrompt;

  @override
  State<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> {
  final ScrollController _scrollController = ScrollController();
  int _lastMessageCount = 0;
  bool _showJumpToLatest = false;

  @override
  void initState() {
    _scrollController.addListener(_syncJumpToLatestButton);
    super.initState();
    if (widget.initialPrompt != null && widget.initialPrompt!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _sendSuggestion(widget.initialPrompt!);
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_syncJumpToLatestButton);
    _scrollController.dispose();
    super.dispose();
  }

  bool _shouldShowJumpToLatest() {
    if (!_scrollController.hasClients) {
      return false;
    }

    final position = _scrollController.position;
    final distanceToBottom = position.maxScrollExtent - position.pixels;
    return position.maxScrollExtent > 180 && distanceToBottom > 56;
  }

  void _syncJumpToLatestButton() {
    if (!mounted) {
      return;
    }

    final shouldShow = _shouldShowJumpToLatest();
    if (shouldShow != _showJumpToLatest) {
      setState(() {
        _showJumpToLatest = shouldShow;
      });
    }
  }

  void _refreshJumpToLatestButton() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _syncJumpToLatestButton();
    });
  }

  void _resetJumpToLatestState() {
    _lastMessageCount = 0;
    if (_showJumpToLatest && mounted) {
      setState(() {
        _showJumpToLatest = false;
      });
    } else {
      _showJumpToLatest = false;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(0);
      }
    });
  }

  void _scrollToBottom() {
    final reduceMotion = context.read<SettingsProvider>().reduceMotion;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) {
        return;
      }

      final maxScrollExtent = _scrollController.position.maxScrollExtent;

      if (reduceMotion) {
        _scrollController.jumpTo(maxScrollExtent);
        _syncJumpToLatestButton();
        return;
      }

      _scrollController
          .animateTo(
            maxScrollExtent,
            duration: AppMotion.scroll,
            curve: AppMotion.curve,
          )
          .whenComplete(_syncJumpToLatestButton);
    });
  }

  void _syncAutoScroll({
    required ChatProvider chatProvider,
    required SettingsProvider settingsProvider,
  }) {
    if (!chatProvider.hasMessages) {
      _resetJumpToLatestState();
      return;
    }

    if (!settingsProvider.autoScroll) {
      _lastMessageCount = chatProvider.messageCount;
      _refreshJumpToLatestButton();
      return;
    }

    if (chatProvider.messageCount != _lastMessageCount) {
      _lastMessageCount = chatProvider.messageCount;
      if (chatProvider.messageCount > 0) {
        _scrollToBottom();
      }
    }

    _refreshJumpToLatestButton();
  }



  Future<void> _sendSuggestion(String prompt) async {
    final chatProvider = context.read<ChatProvider>();
    final planner = context.read<TripPlannerController>();
    final plan = planner.latestPlan ?? planner.planTrip();

    try {
      await chatProvider.sentMessage(
        message: prompt,
        isTextOnly: true,
        plan: plan, // Pass transit route contexts when suggestions are clicked
      );
    } catch (error) {
      if (!mounted) {
        return;
      }
      showAppSnackBar(context, formatChatError(error), bottomOffset: 132);
    }
  }



  @override
  Widget build(BuildContext context) {
    return Consumer2<ChatProvider, SettingsProvider>(
      builder: (context, chatProvider, settingsProvider, child) {
        _syncAutoScroll(
          chatProvider: chatProvider,
          settingsProvider: settingsProvider,
        );

        final showJumpButton = chatProvider.hasMessages && _showJumpToLatest;
        final motionDuration =
            settingsProvider.reduceMotion ? Duration.zero : AppMotion.regular;
        final bottomInset = homeIndicatorSpacing(
          context,
          base: 12,
          factor: 0.12,
          maxExtra: 6,
        );
        final composerInset = bottomInset + 92;
        final contentBottomPadding =
            composerInset > 24 ? composerInset - 24 : composerInset;

        return AppScreenScaffold(
          padding: const EdgeInsets.fromLTRB(
            16,
            10,
            16,
            0,
          ),
          child: Column(
            children: [
              const ChatHeader(),
              const SizedBox(height: 16),
              Expanded(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned.fill(
                      child: AnimatedSwitcher(
                        duration: motionDuration,
                        child: chatProvider.hasMessages
                            ? ChatMessages(
                                key: const ValueKey('chat-messages'),
                                scrollController: _scrollController,
                                chatProvider: chatProvider,
                                bottomPadding: contentBottomPadding,
                              )
                            : Padding(
                                key: const ValueKey('chat-empty'),
                                padding: EdgeInsets.only(
                                  bottom: contentBottomPadding,
                                ),
                                child: ChatEmptyState(
                                  apiConfigured: ApiService.isConfigured,
                                  showStarterPrompts:
                                      settingsProvider.showStarterPrompts,
                                  onSuggestionTap: _sendSuggestion,
                                ),
                              ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: composerInset + 8,
                      child: Align(
                        alignment: Alignment.center,
                        child: IgnorePointer(
                          ignoring: !showJumpButton,
                          child: AnimatedSlide(
                            duration: motionDuration,
                            offset: showJumpButton
                                ? Offset.zero
                                : const Offset(0, 0.3),
                            child: AnimatedOpacity(
                              duration: motionDuration,
                              opacity: showJumpButton ? 1 : 0,
                              child: _JumpToLatestButton(
                                onTap: _scrollToBottom,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: bottomInset,
                      child: BottomChatField(chatProvider: chatProvider),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _JumpToLatestButton extends StatelessWidget {
  const _JumpToLatestButton({
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return IconButton.filledTonal(
      onPressed: onTap,
      style: IconButton.styleFrom(
        backgroundColor: isDark
            ? colorScheme.primaryContainer.withValues(alpha: 0.92)
            : colorScheme.surfaceContainerLow.withValues(alpha: 0.92),
        foregroundColor:
            isDark ? colorScheme.onPrimaryContainer : colorScheme.onSurface,
      ),
      tooltip: 'Jump to latest',
      icon: const Icon(CupertinoIcons.arrow_down),
    );
  }
}
