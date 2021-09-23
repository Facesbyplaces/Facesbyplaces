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

class MiscRegularMessageClipper extends CustomClipper<Path>{

  @override
  Path getClip(Size size){
    final double width = size.width;
    final double height = size.height;
    final double startMargin = width / 14;

    final double s1 = height * 0.3;
    final double s2 = height * 0.7;
    final Path path = Path()
      ..addRRect(RRect.fromRectAndRadius(Rect.fromLTWH(startMargin, 0, width - startMargin, height), const Radius.circular(5)),)
      ..lineTo(startMargin, s1)
      ..lineTo(0, size.height / 2)
      ..lineTo(startMargin, s2)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper){
    return oldClipper != this;
  }
}