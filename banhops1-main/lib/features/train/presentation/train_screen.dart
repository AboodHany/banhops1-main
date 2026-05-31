import 'package:flutter/material.dart';

import '../../../core/localization/app_localizations.dart';

class TrainScreen extends StatefulWidget {
  const TrainScreen({super.key});

  @override
  State<TrainScreen> createState() => _TrainScreenState();
}

class _TrainScreenState extends State<TrainScreen> {
  String _selectedHub = 'Cairo';

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(localization.translate('train_map'))),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _HubSelector(
            selectedHub: _selectedHub,
            onChanged: (value) => setState(() => _selectedHub = value),
          ),
          const SizedBox(height: 16),
          AspectRatio(
            aspectRatio: 1.25,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: InteractiveViewer(
                minScale: 0.8,
                maxScale: 3.2,
                child: CustomPaint(
                  painter: _TrainMapPainter(selectedHub: _selectedHub),
                  child: const SizedBox.expand(),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Pan and zoom the conceptual rail corridor map. Hook this view to Google Maps tiles or a route overlay once the API key and map dataset are provided.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HubSelector extends StatelessWidget {
  const _HubSelector({required this.selectedHub, required this.onChanged});

  final String selectedHub;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        for (final hub in const ['Cairo', 'Tanta', 'Mansoura', 'Minya'])
          ChoiceChip(
            label: Text(hub),
            selected: hub == selectedHub,
            onSelected: (_) => onChanged(hub),
          ),
      ],
    );
  }
}

class _TrainMapPainter extends CustomPainter {
  _TrainMapPainter({required this.selectedHub});

  final String selectedHub;

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPaint = Paint()..color = const Color(0xFFF8FBFF);
    canvas.drawRect(Offset.zero & size, backgroundPaint);

    final linePaint = Paint()
      ..color = const Color(0xFF0F4C81)
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    final connectorPaint = Paint()
      ..color = const Color(0xFF1B998B)
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    final hubs = <String, Offset>{
      'Cairo': Offset(size.width * 0.18, size.height * 0.72),
      'Tanta': Offset(size.width * 0.42, size.height * 0.45),
      'Mansoura': Offset(size.width * 0.68, size.height * 0.28),
      'Minya': Offset(size.width * 0.84, size.height * 0.72),
    };

    canvas.drawLine(hubs['Cairo']!, hubs['Tanta']!, linePaint);
    canvas.drawLine(hubs['Tanta']!, hubs['Mansoura']!, linePaint);
    canvas.drawLine(hubs['Tanta']!, hubs['Minya']!, connectorPaint);
    canvas.drawLine(Offset(size.width * 0.12, size.height * 0.18), hubs['Cairo']!, connectorPaint);

    final labelStyle = TextStyle(
      color: const Color(0xFF102033),
      fontSize: size.width * 0.028,
      fontWeight: FontWeight.w700,
    );

    for (final entry in hubs.entries) {
      final isSelected = entry.key == selectedHub;
      final center = entry.value;
      final nodePaint = Paint()..color = isSelected ? const Color(0xFFF28E2B) : const Color(0xFF1B998B);
      canvas.drawCircle(center, isSelected ? 20 : 15, nodePaint);
      final painter = TextPainter(
        text: TextSpan(text: entry.key, style: labelStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      painter.paint(canvas, center + Offset(-painter.width / 2, 26));
    }

    final subLabelPainter = TextPainter(
      text: TextSpan(
        text: 'Benha corridor demo using placeholder geometry',
        style: TextStyle(color: Colors.grey.shade600, fontSize: size.width * 0.022),
      ),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: size.width * 0.8);
    subLabelPainter.paint(canvas, Offset(size.width * 0.1, size.height * 0.08));

    final benhaTag = TextPainter(
      text: const TextSpan(
        text: 'Benha',
        style: TextStyle(color: Color(0xFF0F4C81), fontWeight: FontWeight.w800, fontSize: 18),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    benhaTag.paint(canvas, Offset(size.width * 0.14, size.height * 0.84));

    final highlight = Paint()
      ..color = const Color(0x331B998B)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(hubs['Tanta']!, 40, highlight);
  }

  @override
  bool shouldRepaint(covariant _TrainMapPainter oldDelegate) => oldDelegate.selectedHub != selectedHub;
}
