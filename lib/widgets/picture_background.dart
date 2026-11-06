import 'package:flutter/material.dart';

class PictureBackground extends StatelessWidget {
  const PictureBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _PicturePainter(Theme.of(context).colorScheme),
      child: const SizedBox.expand(),
    );
  }
}

class _PicturePainter extends CustomPainter {
  const _PicturePainter(this.scheme);
  final ColorScheme scheme;

  @override
  void paint(Canvas canvas, Size size) {
    final background = Paint()..color = scheme.surfaceContainerHighest;
    canvas.drawRect(Offset.zero & size, background);
    final hill = Paint()..color = scheme.primary.withValues(alpha: .18);
    final path = Path()
      ..moveTo(0, size.height * .72)
      ..quadraticBezierTo(size.width * .25, size.height * .48, size.width * .5,
          size.height * .72)
      ..quadraticBezierTo(
          size.width * .75, size.height * .95, size.width, size.height * .62)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(path, hill);
    final sun = Paint()..color = Colors.amber.withValues(alpha: .55);
    canvas.drawCircle(Offset(size.width * .78, size.height * .2), 34, sun);
  }

  @override
  bool shouldRepaint(covariant _PicturePainter oldDelegate) =>
      oldDelegate.scheme != scheme;
}
