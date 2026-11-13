import 'package:flutter/material.dart';

import '../models/canvas_background.dart';

class PictureBackground extends StatelessWidget {
  const PictureBackground({super.key, required this.background});

  final CanvasBackground background;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _PicturePainter(Theme.of(context).colorScheme, background),
      child: const SizedBox.expand(),
    );
  }
}

class _PicturePainter extends CustomPainter {
  const _PicturePainter(this.scheme, this.background);
  final ColorScheme scheme;
  final CanvasBackground background;

  @override
  void paint(Canvas canvas, Size size) {
    final base = Paint()..color = Colors.white;
    canvas.drawRect(Offset.zero & size, base);
    if (background == CanvasBackground.blank) return;

    if (background == CanvasBackground.sunset) {
      _paintSunset(canvas, size);
    } else if (background == CanvasBackground.mountains) {
      _paintMountains(canvas, size);
    } else {
      _paintGarden(canvas, size);
    }
  }

  void _paintSunset(Canvas canvas, Size size) {
    final sky = Paint()..color = const Color(0xffffd7a8);
    canvas.drawRect(Offset.zero & size, sky);
    final sun = Paint()..color = const Color(0xffff9f68);
    canvas.drawCircle(Offset(size.width * .76, size.height * .24), 38, sun);
    final hill = Paint()..color = const Color(0xff8d6a9f);
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
  }

  void _paintMountains(Canvas canvas, Size size) {
    final sky = Paint()..color = const Color(0xffd9eff7);
    canvas.drawRect(Offset.zero & size, sky);
    final back = Paint()..color = const Color(0xff91b7bd);
    final backPath = Path()
      ..moveTo(0, size.height * .7)
      ..lineTo(size.width * .25, size.height * .3)
      ..lineTo(size.width * .43, size.height * .7)
      ..lineTo(size.width * .65, size.height * .2)
      ..lineTo(size.width, size.height * .72)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(backPath, back);
    final front = Paint()..color = const Color(0xff477477);
    final frontPath = Path()
      ..moveTo(0, size.height * .82)
      ..lineTo(size.width * .33, size.height * .45)
      ..lineTo(size.width * .58, size.height * .8)
      ..lineTo(size.width * .8, size.height * .5)
      ..lineTo(size.width, size.height * .82)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(frontPath, front);
  }

  void _paintGarden(Canvas canvas, Size size) {
    final grass = Paint()..color = const Color(0xffdff1d5);
    canvas.drawRect(Offset.zero & size, grass);
    final ground = Paint()..color = const Color(0xff9bcf83);
    canvas.drawRect(
        Rect.fromLTWH(0, size.height * .7, size.width, size.height * .3),
        ground);
    final stem = Paint()
      ..color = const Color(0xff427a4c)
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    final flower = Paint()..color = const Color(0xffe76f91);
    for (final x in [
      size.width * .2,
      size.width * .5,
      size.width * .78,
    ]) {
      canvas.drawLine(
          Offset(x, size.height * .86), Offset(x, size.height * .56), stem);
      canvas.drawCircle(Offset(x, size.height * .53), 13, flower);
      canvas.drawCircle(Offset(x + 12, size.height * .58), 9, flower);
      canvas.drawCircle(Offset(x - 12, size.height * .58), 9, flower);
    }
  }

  @override
  bool shouldRepaint(covariant _PicturePainter oldDelegate) =>
      oldDelegate.scheme != scheme || oldDelegate.background != background;
}
