import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:banhops1/features/ai_chat/models/message.dart';
import 'package:banhops1/features/ai_chat/utilities/app_snackbar.dart';
import 'package:banhops1/features/ai_chat/widgets/chat/assistant_response_content.dart';
import 'package:banhops1/core/localization/app_localizations.dart';

class AssistantMessageWidget extends StatelessWidget {
  const AssistantMessageWidget({
    super.key,
    required this.message,
  });

  final Message message;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final text = message.message.toString();
    
    final parsedRoute = _parseRouteFromText(text);
    final displayText = _cleanMessageText(text);
    final hasCodeBlocks = AssistantResponseContent.containsCodeBlocks(displayText);

    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.94,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerLow.withValues(alpha: 0.82),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: colorScheme.outlineVariant.withValues(alpha: 0.5),
            ),
          ),
          padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
          margin: const EdgeInsets.only(bottom: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Icon(
                      CupertinoIcons.sparkles,
                      size: 13,
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'AI',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const Spacer(),
                  if (displayText.isNotEmpty && !hasCodeBlocks)
                    IconButton(
                      tooltip: 'Copy',
                      visualDensity: VisualDensity.compact,
                      onPressed: () async {
                        await Clipboard.setData(ClipboardData(text: displayText));
                        if (context.mounted) {
                          showAppSnackBar(context, 'Copied', bottomOffset: 132);
                        }
                      },
                      icon: const Icon(CupertinoIcons.doc_on_doc, size: 18),
                    ),
                ],
              ),
              const SizedBox(height: 10),
              if (text.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: CupertinoActivityIndicator(),
                )
              else ...[
                if (displayText.isNotEmpty)
                  AssistantResponseContent(text: displayText),
                if (parsedRoute != null)
                  _ChatRouteCard(route: parsedRoute),
              ],
            ],
          ),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
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
        color: isDark ? const Color(0xFF1F2937) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
          width: 1,
        ),
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
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: isDark ? const Color(0xFFE8EDF3) : const Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.access_time_rounded,
                      size: 14,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${route.timeMin}-${route.timeMax} ${localization.translate('min')}',
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                    const SizedBox(width: 12),
                    const Icon(
                      Icons.payments_outlined,
                      size: 14,
                      color: Colors.grey,
                    ),
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
