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

    glow = Tween(begin: 6.0, end: 14.0).animate(
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
          width: 42,
          height: 42,
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
          child: CustomPaint(painter: _AvatarPainter()),
        );
      },
    );
  }
}

class _AvatarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final r = size.width / 2.8;

    final paint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFFFFFFFF), Color(0xFFB0F0FF)],
      ).createShader(Rect.fromCircle(center: center, radius: r))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawCircle(center.translate(-6, -4), 4, paint);
    canvas.drawCircle(center.translate(6, -4), 4, paint);

    final mouth = Path()
      ..moveTo(center.dx - 6, center.dy + 4)
      ..quadraticBezierTo(center.dx, center.dy + 8, center.dx + 6, center.dy + 4);

    canvas.drawPath(mouth, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}