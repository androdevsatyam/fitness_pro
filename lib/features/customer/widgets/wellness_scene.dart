import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Original Flutter illustration: a quiet home studio, with no network assets.
class WellnessScene extends StatelessWidget {
  const WellnessScene({super.key});
  @override
  Widget build(BuildContext context) => Semantics(
    label: 'A peaceful home studio with a yoga mat, sunlight and a plant',
    image: true,
    child: AspectRatio(
      aspectRatio: 1.05,
      child: CustomPaint(painter: _StudioPainter()),
    ),
  );
}

class _StudioPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 420, size.height / 400);
    final paint = Paint();
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        const Rect.fromLTWH(22, 10, 376, 380),
        topLeft: const Radius.circular(180),
        topRight: const Radius.circular(180),
        bottomLeft: const Radius.circular(24),
        bottomRight: const Radius.circular(24),
      ),
      paint..color = const Color(0xFFE9EBDD),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(108, 52, 175, 237),
        const Radius.circular(90),
      ),
      paint..color = const Color(0xFFF7F5E9),
    );
    paint
      ..color = const Color(0xFFD5DCCB)
      ..strokeWidth = 2;
    canvas.drawLine(const Offset(195, 55), const Offset(195, 287), paint);
    canvas.drawLine(const Offset(112, 170), const Offset(279, 170), paint);
    canvas.drawCircle(
      const Offset(239, 104),
      26,
      paint..color = const Color(0xFFE7CC9E),
    );
    canvas.drawOval(
      const Rect.fromLTWH(68, 324, 285, 35),
      paint..color = const Color(0xFFD8DDCE),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(80, 318, 243, 16),
        const Radius.circular(10),
      ),
      paint..color = const Color(0xFF8CA38C),
    );
    // Seated figure: relaxed shoulders and crossed legs.
    canvas.drawCircle(
      const Offset(205, 174),
      23,
      paint..color = const Color(0xFFC08F6D),
    );
    canvas.drawArc(
      const Rect.fromLTWH(181, 149, 47, 40),
      3.1,
      3.3,
      false,
      paint
        ..color = AppColors.ink
        ..style = PaintingStyle.fill,
    );
    final body = Path()
      ..moveTo(190, 201)
      ..quadraticBezierTo(170, 215, 174, 265)
      ..lineTo(234, 265)
      ..quadraticBezierTo(237, 218, 218, 201)
      ..close();
    canvas.drawPath(body, paint..color = const Color(0xFFF6F0E4));
    paint
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 13
      ..color = const Color(0xFFC08F6D);
    canvas.drawPath(
      Path()
        ..moveTo(181, 216)
        ..quadraticBezierTo(167, 242, 144, 268),
      paint,
    );
    canvas.drawPath(
      Path()
        ..moveTo(226, 216)
        ..quadraticBezierTo(243, 245, 264, 268),
      paint,
    );
    paint
      ..strokeWidth = 30
      ..color = AppColors.primary;
    canvas.drawPath(
      Path()
        ..moveTo(189, 273)
        ..quadraticBezierTo(116, 272, 155, 300)
        ..quadraticBezierTo(189, 317, 240, 292),
      paint,
    );
    canvas.drawPath(
      Path()
        ..moveTo(222, 272)
        ..quadraticBezierTo(286, 278, 250, 304)
        ..quadraticBezierTo(222, 317, 173, 292),
      paint,
    );
    paint..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(317, 278, 42, 49),
        const Radius.circular(8),
      ),
      paint..color = const Color(0xFFBB9477),
    );
    paint
      ..color = const Color(0xFF6B8565)
      ..strokeWidth = 3;
    canvas.drawLine(const Offset(339, 285), const Offset(335, 205), paint);
    for (var i = 0; i < 4; i++) {
      canvas.drawOval(
        Rect.fromLTWH(312 + (i % 2) * 24, 214 + i * 14, 25, 12),
        paint,
      );
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
