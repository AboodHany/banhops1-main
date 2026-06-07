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
    final isAr = localization.locale.languageCode == 'ar';

    return Scaffold(
      appBar: AppBar(title: Text(localization.translate('train_map'))),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _HubSelector(
            selectedHub: _selectedHub,
            isAr: isAr,
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
                  painter: _TrainMapPainter(selectedHub: _selectedHub, isAr: isAr),
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
                isAr
                    ? 'خريطة ممرات القطارات المتصلة ببنها. يمكنك التكبير والتحريك لرؤية محطات خطوط الوجه البحري وقناة السويس والمنوفية.'
                    : 'Conceptual rail corridors map connecting to Benha. Pan and zoom to view Lower Egypt, Suez Canal, and Menoufia rail lines.',
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
  const _HubSelector({required this.selectedHub, required this.onChanged, required this.isAr});

  final String selectedHub;
  final ValueChanged<String> onChanged;
  final bool isAr;

  @override
  Widget build(BuildContext context) {
    final hubs = [
      {'id': 'Cairo', 'name': isAr ? 'القاهرة' : 'Cairo'},
      {'id': 'Tanta', 'name': isAr ? 'طنطا' : 'Tanta'},
      {'id': 'Zagazig', 'name': isAr ? 'الزقازيق' : 'Zagazig'},
      {'id': 'Menouf', 'name': isAr ? 'منوف' : 'Menouf'},
    ];
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        for (final hub in hubs)
          ChoiceChip(
            label: Text(hub['name']!),
            selected: hub['id'] == selectedHub,
            onSelected: (_) => onChanged(hub['id']!),
          ),
      ],
    );
  }
}

class _TrainMapPainter extends CustomPainter {
  _TrainMapPainter({required this.selectedHub, required this.isAr});

  final String selectedHub;
  final bool isAr;

  @override
  void paint(Canvas canvas, Size size) {
    // Background
    final backgroundPaint = Paint()..color = const Color(0xFFF0F5FA);
    canvas.drawRect(Offset.zero & size, backgroundPaint);

    // Grid lines for aesthetic
    final gridPaint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.15)
      ..strokeWidth = 1;
    for (double i = 0; i < size.width; i += size.width / 10) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), gridPaint);
    }
    for (double i = 0; i < size.height; i += size.height / 10) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), gridPaint);
    }

    // Node Positions
    final benha = Offset(size.width * 0.5, size.height * 0.55);
    final cairo = Offset(size.width * 0.5, size.height * 0.88);
    final tanta = Offset(size.width * 0.3, size.height * 0.35);
    final alex = Offset(size.width * 0.1, size.height * 0.15);
    final zagazig = Offset(size.width * 0.72, size.height * 0.55);
    final ismailia = Offset(size.width * 0.9, size.height * 0.4);
    final menouf = Offset(size.width * 0.28, size.height * 0.65);
    final shebin = Offset(size.width * 0.18, size.height * 0.5);

    // Paints
    final deltaLinePaint = Paint()
      ..color = const Color(0xFF0F4C81)
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    final eastLinePaint = Paint()
      ..color = const Color(0xFF1B998B)
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    final westLinePaint = Paint()
      ..color = const Color(0xFFE08B14)
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    final inactivePaint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.3)
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    // Draw Line 1: Cairo - Benha - Tanta - Alexandria (Main Delta Line)
    final deltaActive = selectedHub == 'Cairo' || selectedHub == 'Tanta';
    canvas.drawLine(cairo, benha, deltaActive ? deltaLinePaint : inactivePaint);
    canvas.drawLine(benha, tanta, deltaActive ? deltaLinePaint : inactivePaint);
    canvas.drawLine(tanta, alex, deltaActive ? deltaLinePaint : inactivePaint);

    // Draw Line 2: Benha - Zagazig - Ismailia (East Line)
    final eastActive = selectedHub == 'Zagazig';
    canvas.drawLine(benha, zagazig, eastActive ? eastLinePaint : inactivePaint);
    canvas.drawLine(zagazig, ismailia, eastActive ? eastLinePaint : inactivePaint);

    // Draw Line 3: Benha - Menouf - Shebin El Kom (West Line)
    final westActive = selectedHub == 'Menouf';
    canvas.drawLine(benha, menouf, westActive ? westLinePaint : inactivePaint);
    canvas.drawLine(menouf, shebin, westActive ? westLinePaint : inactivePaint);

    // Hub metadata
    final stations = [
      {'id': 'Benha', 'pos': benha, 'name_ar': 'بنها (الملتقى)', 'name_en': 'Benha (Hub)', 'color': const Color(0xFF0F4C81), 'isHub': true},
      {'id': 'Cairo', 'pos': cairo, 'name_ar': 'القاهرة', 'name_en': 'Cairo', 'color': const Color(0xFF0F4C81), 'isHub': false},
      {'id': 'Tanta', 'pos': tanta, 'name_ar': 'طنطا', 'name_en': 'Tanta', 'color': const Color(0xFF0F4C81), 'isHub': false},
      {'id': 'Alexandria', 'pos': alex, 'name_ar': 'الإسكندرية', 'name_en': 'Alex', 'color': const Color(0xFF0F4C81), 'isHub': false},
      {'id': 'Zagazig', 'pos': zagazig, 'name_ar': 'الزقازيق', 'name_en': 'Zagazig', 'color': const Color(0xFF1B998B), 'isHub': false},
      {'id': 'Ismailia', 'pos': ismailia, 'name_ar': 'الإسماعيلية', 'name_en': 'Ismailia', 'color': const Color(0xFF1B998B), 'isHub': false},
      {'id': 'Menouf', 'pos': menouf, 'name_ar': 'منوف', 'name_en': 'Menouf', 'color': const Color(0xFFE08B14), 'isHub': false},
      {'id': 'Shebin', 'pos': shebin, 'name_ar': 'شبين الكوم', 'name_en': 'Shebin El Kom', 'color': const Color(0xFFE08B14), 'isHub': false},
    ];

    // Label style
    final labelStyle = TextStyle(
      color: const Color(0xFF1F2E40),
      fontSize: size.width * 0.026,
      fontWeight: FontWeight.bold,
      backgroundColor: Colors.white.withValues(alpha: 0.7),
    );

    // Draw Stations Nodes and Labels
    for (final station in stations) {
      final isSelected = station['id'] == selectedHub;
      final isBenha = station['isHub'] as bool;
      final center = station['pos'] as Offset;
      final color = station['color'] as Color;

      // Draw outer glowing ring for selected or Benha
      if (isSelected || isBenha) {
        final ringPaint = Paint()
          ..color = color.withValues(alpha: 0.25)
          ..style = PaintingStyle.fill;
        canvas.drawCircle(center, isBenha ? 24 : 18, ringPaint);
      }

      final nodePaint = Paint()
        ..color = isBenha 
            ? const Color(0xFFD32F2F) 
            : (isSelected ? color : color.withValues(alpha: 0.7))
        ..style = PaintingStyle.fill;

      canvas.drawCircle(center, isBenha ? 12 : 8, nodePaint);

      // Label text
      final name = isAr ? station['name_ar'].toString() : station['name_en'].toString();
      final painter = TextPainter(
        text: TextSpan(text: name, style: labelStyle),
        textDirection: TextDirection.ltr,
      )..layout();

      // Position label offset to avoid overlaps
      Offset labelOffset;
      if (station['id'] == 'Benha') {
        labelOffset = center + Offset(-painter.width / 2, -30);
      } else if (center.dx > size.width * 0.6) {
        labelOffset = center + Offset(12, -painter.height / 2);
      } else if (center.dx < size.width * 0.4) {
        labelOffset = center + Offset(-painter.width - 12, -painter.height / 2);
      } else {
        labelOffset = center + Offset(-painter.width / 2, 12);
      }

      painter.paint(canvas, labelOffset);
    }
  }

  @override
  bool shouldRepaint(covariant _TrainMapPainter oldDelegate) {
    return oldDelegate.selectedHub != selectedHub || oldDelegate.isAr != isAr;
  }
}
