import 'package:flutter/material.dart';

class BubblePainter extends CustomPainter {
  BubblePainter({
    required this.isMe,
    required this.color,
  });

  final bool isMe;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    const radius = 18.0;

    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(radius),
    );

    final path = Path()..addRRect(rect);

    if (isMe) {
      path
        ..moveTo(size.width - 5, 8)
        ..quadraticBezierTo(size.width + 5, 7, size.width + 7, 3)
        ..quadraticBezierTo(size.width + 9, 5, size.width, 14);
    } else {
      path
        ..moveTo(5, 8)
        ..quadraticBezierTo(-5, 7, -7, 3)
        ..quadraticBezierTo(-9, 5, 0, 14);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
