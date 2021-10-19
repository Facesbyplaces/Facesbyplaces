// part of dashedcircle;

// class DashedCirclePainter extends CustomPainter{
//   final int dashes;
//   final Color color;
//   final double gapSize;
//   final double strokeWidth;

//   DashedCirclePainter({this.dashes = _DefaultDashes, this.color = _DefaultColor, this.gapSize = _DefaultGapSize, this.strokeWidth = _DefaultStrokeWidth});

//   @override
//   void paint(Canvas canvas, Size size) {
//     final double gap = pi / 180 * gapSize;
//     final double singleAngle = (pi * 2) / dashes;

//     for (int i = 0; i < dashes; i++) {
//       final Paint paint = Paint()
//         ..color = color
//         ..strokeWidth = _DefaultStrokeWidth
//         ..style = PaintingStyle.stroke;

//       canvas.drawArc(Offset.zero & size, gap + singleAngle * i, singleAngle - gap * 2, false, paint);
//     }
//   }

//   @override
//   bool shouldRepaint(DashedCirclePainter oldDelegate) {
//     return dashes != oldDelegate.dashes || color != oldDelegate.color;
//   }
// }

// class DashedCirclePainter extends CustomPainter{
//   final double strokeWidth;
//   final double gapSize;
//   final Color color;
//   final int dashes;

//   const DashedCirclePainter({required this.strokeWidth, required this.gapSize, required this.color, required this.dashes});

//   @override
//   void paint(Canvas canvas, Size size){
//     final double gap = pi / 180 * gapSize;
//     final double angle = (pi * 2) / dashes;

//     for(int i = 0; i < dashes; i++){
//       final Paint paint = Paint()
//         ..color = color
//         ..strokeWidth = strokeWidth
//         ..style = PaintingStyle.stroke;

//       canvas.drawArc(Offset.zero & size, gap + angle * i, angle - gap * 2, false, paint);
//     }
//   }

//   @override
//   bool shouldRepaint(DashedCirclePainter oldDelegate){
//     return dashes != oldDelegate.dashes || color != oldDelegate.color;
//   }
// }

import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:math' as math;

class NewestTest extends StatefulWidget{
  const NewestTest({Key? key}) : super(key: key);

  @override
  NewestTestState createState() => NewestTestState();
}

class NewestTestState extends State<NewestTest> with TickerProviderStateMixin{
  // Animation<double>? animation;
  // AnimationController? controller;
  // final Tween<double> _rotationTween = Tween(begin: -math.pi, end: math.pi);

  Animation<int>? animation;
  AnimationController? controller;
  Tween<int> _rotationTween = Tween(begin: 1, end: 30);

  // var _sides = 3.0;
  // var _radius = 100.0;
  // var _radians = 0.0;
  int dashes = 1;

  @override
  void initState(){
    super.initState();
    controller = AnimationController(vsync: this, duration: const Duration(seconds: 4));

    // controller.forward()

    animation = _rotationTween.animate(controller!)
      ..addListener(() {
        setState(() {
          // if(dashes <= 30){
          //   dashes++;
          // }else{
          //   dashes = 1;
          // }
        });
      })
      ..addStatusListener((status) {
        if(status == AnimationStatus.completed){
          controller!.repeat();
        }else if(status == AnimationStatus.dismissed){
          controller!.forward();
        }
      });

    controller!.forward();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomPaint(
        painter: ShapePainter(2.0, 3.0, Colors.red, animation!.value),
        child: Container(),
      ),
    );
  }
}

class ShapePainter extends CustomPainter{
  final double strokeWidth;
  final double gapSize;
  final Color color;
  final int dashes;
  ShapePainter(this.strokeWidth, this.gapSize, this.color, this.dashes);
  @override
  void paint(Canvas canvas, Size size){
    // final double gap = math.pi / 180 * gapSize;
    // final double angle = (math.pi * 2) / dashes;

    // for(int i = 0; i < dashes; i++){
    //   final Paint paint = Paint()
    //     ..color = color
    //     ..strokeWidth = strokeWidth
    //     ..style = PaintingStyle.stroke;

    //   // canvas.drawArc(Offset.zero & size, gap + angle * i, angle - gap * 2, false, paint);
    //   var path = Path();
    //   Offset center = Offset(size.width / 2, size.height / 2);
    //   // canvas.drawCircle(center, 100, paint);
    //   // canvas.drawPoints(PointMode, points, paint)


    //   Offset startPoint1 = Offset(100.0 * math.cos(0.0), 100.0 * math.sin(0.0));
    //   path.moveTo(startPoint1.dx + center.dx, startPoint1.dy + center.dy);
    //   // Offset startPoint2 = Offset(100.0 * math.cos(0.0), 100.0 * math.sin(0.0));

    //   canvas.drawPoints(PointMode.points, [startPoint1, startPoint1], paint);

      
      // for (int i = 0; i < dashes; i++) {
      //   // final Paint paint = Paint()
      //   //   ..color = color
      //   //   ..strokeWidth = _DefaultStrokeWidth
      //   //   ..style = PaintingStyle.stroke;
      //   // canvas.drawArc(Offset.zero & size, gap + singleAngle * i, singleAngle - gap * 2, false, paint);
      //   double x = 100.0 * math.cos(100.0 + angle * i) + center.dx;
      //   // canvas.drawPoints(PointMode.points, x, paint);
      //   canvas.drawPoints(pointMode, points, paint)

      //   // canvas.drawArc(Offset.zero & size, gap + singleAngle * i, singleAngle - gap * 2, false, paint);
      //   // canvas.drawPoints(PointMode.points, points, paint)
      // }

    var paint = Paint()
      ..color = Colors.teal
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

      // var sides = 3.0;
      var radius = 100.0;
      var radians = 0.0;

      var path = Path();
      // var angle = (math.pi * 2) / sides;
      final double angle = (math.pi * 2) / dashes;

      Offset center = Offset(size.width / 2, size.height / 2);

      // Offset startPoint = Offset(radius * math.cos(radians), radius * math.sin(radians));
      // path.moveTo(startPoint.dx + center.dx, startPoint.dy + center.dy);

      // double x = radius * math.cos(angle * 1) + center.dx;
      // double y = radius * math.sin(angle * 1) + center.dy;
      // path.lineTo(x, y);

      // for (int i = 1; i <= sides; i++) {
      //   double x = radius * math.cos(radians + angle * i) + center.dx;
      //   double y = radius * math.sin(radians + angle * i) + center.dy;
      //   path.lineTo(x, y);
      // }

      double x = radius * math.cos(radians + angle * dashes) + center.dx;
      double y = radius * math.sin(radians + angle * dashes) + center.dy;    

      path.moveTo(x, y);
      path.close();
      canvas.drawPath(path, paint);

      // for (int i = 1; i <= 30; i++){ // DOTS
      //   double x = radius * math.cos(radians + angle * i) + center.dx;
      //   double y = radius * math.sin(radians + angle * i) + center.dy;    

      //   path.moveTo(x, y);
      //   path.close();
      //   canvas.drawPath(path, paint);
      // }

      // double x = radius * math.cos(radians + angle * 1) + center.dx;
      // double y = radius * math.sin(radians + angle * 1) + center.dy;

      // path.moveTo(x, y);
      // path.close();
      // canvas.drawPath(path, paint);

      // double x2 = radius * math.cos(radians + angle * 2) + center.dx;
      // double y2 = radius * math.sin(radians + angle * 2) + center.dy;

      // path.moveTo(x2, y2);
      // path.close();
      // canvas.drawPath(path, paint);

      // double x3 = radius * math.cos(radians + angle * 3) + center.dx;
      // double y3 = radius * math.sin(radians + angle * 3) + center.dy;

      // path.moveTo(x3, y3);
      // path.close();
      // canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate){
    return true;
  }
}