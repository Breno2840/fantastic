import 'dart:math';
import 'package:flutter/material.dart';

class NeonAvatar extends StatefulWidget {
  const NeonAvatar({super.key});

  @override
  State<NeonAvatar> createState() => _NeonAvatarState();
}

class _NeonAvatarState extends State<NeonAvatar>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> glow;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    glow = Tween(begin: 8.0, end: 16.0).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeInOut),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: glow,
      builder: (_, __) {
        return Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [
                Color(0xFF6A5CFF),
                Color(0xFF1BC9FF),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6A5CFF),
                blurRadius: glow.value,
              ),
            ],
          ),
          child: CustomPaint(painter: _HackerPainter()),
        );
      },
    );
  }
}

class _HackerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final center = Offset(w / 2, h / 2 + 2);

    final hoodPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF0B0F14), Color(0xFF1C2530)],
      ).createShader(Rect.fromLTWH(0, 0, w, h));

    final facePaint = Paint()..color = const Color(0xFF0B0F14);

    final hoodPath = Path()
      ..moveTo(w * 0.15, h * 0.75)
      ..quadraticBezierTo(w * 0.1, h * 0.35, w * 0.5, h * 0.18)
      ..quadraticBezierTo(w * 0.9, h * 0.35, w * 0.85, h * 0.75)
      ..close();

    canvas.drawPath(hoodPath, hoodPaint);

    canvas.drawOval(
      Rect.fromCenter(center: center, width: w * 0.45, height: h * 0.45),
      facePaint,
    );

    final eyePaint = Paint()
      ..color = const Color(0xFF1BC9FF)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(w * 0.38, h * 0.52),
      Offset(w * 0.46, h * 0.52),
      eyePaint,
    );

    canvas.drawLine(
      Offset(w * 0.54, h * 0.52),
      Offset(w * 0.62, h * 0.52),
      eyePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}