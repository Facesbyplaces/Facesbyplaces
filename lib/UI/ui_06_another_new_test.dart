import 'package:flutter/material.dart';
import 'dart:math' as math;

// class MyPainter extends StatelessWidget{
//   const MyPainter({Key? key}) : super(key: key);

class MyPainter extends StatefulWidget{
  const MyPainter({Key? key}) : super(key: key);

  @override
  MyPainterState createState() => MyPainterState();
}

class MyPainterState extends State<MyPainter> with TickerProviderStateMixin{
  Animation<double>? animation;
  AnimationController? controller;
  final Tween<double> _rotationTween = Tween(begin: -math.pi, end: math.pi);

  var _sides = 3.0;
  var _radius = 100.0;
  var _radians = 0.0;

  @override
  void initState(){
    super.initState();
    controller = AnimationController(vsync: this, duration: const Duration(seconds: 4));

    animation = _rotationTween.animate(controller!)
      ..addListener(() {
        setState(() {
          
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
      // body: CustomPaint(
      //   painter: ShapePainter(),
      //   child: Container(),
      // ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: CustomPaint(
                painter: ShapePainter(_sides, _radius, _radians),
                // painter: ShapePainter(_sides, _radius, animation!.value),
                child: Container(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text('Sides'),
            ),
            Slider(
              value: _sides,
              min: 3.0,
              max: 10.0,
              label: _sides.toInt().toString(),
              divisions: 7,
              onChanged: (value) {
                setState(() {
                  _sides = value;
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text('Size'),
            ),
            Slider(
              value: _radius,
              min: 10.0,
              max: MediaQuery.of(context).size.width / 2,
              onChanged: (value) {
                setState(() {
                  _radius = value;
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text('Rotation'),
            ),
            Slider(
              value: _radians,
              min: 0.0,
              max: math.pi,
              onChanged: (value) {
                setState(() {
                  _radians = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ShapePainter extends CustomPainter{
  final double sides;
  final double radius;
  final double radians;
  ShapePainter(this.sides, this.radius, this.radians);
  @override
  void paint(Canvas canvas, Size size){
    var paint = Paint()
      ..color = Colors.teal
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Offset startingPoint = Offset(0, size.height / 2);
    // Offset endingPoint = Offset(size.width, size.height / 2);

    // canvas.drawLine(startingPoint, endingPoint, paint);

    // var path = Path();
    // path.moveTo(0, size.height / 2);
    // path.lineTo(size.width, size.height / 2);
    // canvas.drawPath(path, paint);

    

    // Offset center = Offset(size.width / 2, size.height / 2);

    // canvas.drawCircle(center, 100, paint);

    // var path = Path();
    // path.addOval(Rect.fromCircle(center: Offset(size.width / 2, size.height / 2), radius: 100));
    // canvas.drawPath(path, paint);



    // int sides = 4;
    // double radius = 100.0;

    var path = Path();
    var angle = (math.pi * 2) / sides;

    Offset center = Offset(size.width / 2, size.height / 2);

    Offset startPoint = Offset(radius * math.cos(radians), radius * math.sin(radians));
    path.moveTo(startPoint.dx + center.dx, startPoint.dy + center.dy);

    // double x = radius * math.cos(angle * 1) + center.dx;
    // double y = radius * math.sin(angle * 1) + center.dy;
    // path.lineTo(x, y);

    for (int i = 1; i <= sides; i++) {
      double x = radius * math.cos(radians + angle * i) + center.dx;
      double y = radius * math.sin(radians + angle * i) + center.dy;
      path.lineTo(x, y);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate){
    return true;
  }
}