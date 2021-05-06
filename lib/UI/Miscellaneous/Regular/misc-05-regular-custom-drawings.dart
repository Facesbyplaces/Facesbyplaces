import 'package:flutter/material.dart';

class MiscRegularCurvePainter extends CustomPainter{

  @override
  void paint(Canvas canvas, Size size){
    var paint = Paint();
    paint.color = const Color(0xff04ECFF);
    paint.style = PaintingStyle.fill;

    var path = Path();

    path.moveTo(0, size.height * 0.75);
    path.quadraticBezierTo(size.width / 2, size.height * 1.2, size.width, size.height * 0.75);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate){
    return true;
  }
}