import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:ui';

class NewestTest extends StatefulWidget{
  const NewestTest({Key? key}) : super(key: key);

  @override
  NewestTestState createState() => NewestTestState();
}

class NewestTestState extends State<NewestTest> with TickerProviderStateMixin{
  // Animation<int>? animation;
  // AnimationController? controller;
  // final Tween<int> _rotationTween = Tween(begin: 1, end: 30);

  // Animation<double>? animation;
  // AnimationController? controller;
  // final Tween<double> _rotationTween = Tween(begin: -math.pi, end: math.pi);

  @override
  void initState(){
    super.initState();
    // controller = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    // //   ..addListener(() => setState(() {}))
    // //   ..repeat();
    // // animation = Tween(begin: -math.pi, end: -math.pi).animate(controller!);
    // animation = _rotationTween.animate(controller!)
    //   ..addListener(() {
    //     setState(() {
    //     });
    //   })
    //   ..addStatusListener((status) {
    //     if(status == AnimationStatus.completed){
    //       controller!.repeat();
    //     }else if(status == AnimationStatus.dismissed){
    //       controller!.forward();
    //     }
    //   });

    // controller!.forward();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomPaint(
        painter: ShapePainter(2.0, 3.0, Colors.red, 30),
        child: Container(),
      ),
    );
  }
}

class ShapePainter extends CustomPainter{
  final double strokeWidth;
  final double gapSize;
  final Color color;
  // final int dashes;
  final double dashes;
  ShapePainter(this.strokeWidth, this.gapSize, this.color, this.dashes);

  @override
  void paint(Canvas canvas, Size size){
    // var paint = Paint()
    //   ..color = Colors.teal
    //   ..strokeWidth = 5
    //   ..style = PaintingStyle.stroke
    //   ..strokeCap = StrokeCap.round;

    Offset center = Offset(size.width / 2, size.height / 2);

    // double x = radius * math.cos(radians + angle * increment) + center.dx;
    // double y = radius * math.sin(radians + angle * increment) + center.dy;

    // path.moveTo(x, y);
    // path.close();
    // canvas.drawPath(path, paint);

      var radius = 100.0;
      var radians = 0.0;
      var path = Path();
      final double angle = (math.pi * 2) / dashes;

      // Offset center = Offset(size.width / 2, size.height / 2);

      for (int i = 1; i <= 30; i++){ // DOTS
        double x = radius * math.cos(radians + angle * i) + center.dx;
        double y = radius * math.sin(radians + angle * i) + center.dy;

        print('The value of i is $i');

        Color color = Colors.red;

        if(i % 2 != 0){
          print('Odd');
          color = Colors.blue;
        }

        var newpaint = Paint()
          ..color = i % 2 == 0 ? Colors.red : Colors.blue
          ..strokeWidth = 5
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round; 

        path.moveTo(x, y);
        // print('The value of x is $x and y is $y');
        path.close();
        canvas.drawPath(path, newpaint);
      }

      // Offset center = Offset(size.width / 2, size.height / 2);
      // double x = radius * math.cos(radians + angle * dashes) + center.dx;
      // double y = radius * math.sin(radians + angle * dashes) + center.dy;    

      // path.moveTo(x, y);
      // path.close();
      // canvas.drawPath(path, paint);

      // for (int i = 1; i <= 3; i++){
      //   recreate(canvas, size, paint, i);
      // }
  }

  // void recreate(Canvas canvas, Size size, Paint paint, int increment){
  //     var radius = 100.0;
  //     var radians = 0.0;
  //     var path = Path();
  //     final double angle = (math.pi * 2) / dashes;

  //     Offset center = Offset(size.width / 2, size.height / 2);

  //     double x = radius * math.cos(radians + angle * increment) + center.dx;
  //     double y = radius * math.sin(radians + angle * increment) + center.dy;

  //     path.moveTo(x, y);
  //     path.close();
  //     canvas.drawPath(path, paint);
  // }

  @override
  bool shouldRepaint(CustomPainter oldDelegate){
    return true;
  }
}




// import 'package:flutter/material.dart';
// import 'dart:math' as math;
// import 'dart:ui';
// import 'dart:math' as math show sin, pi;

// import 'package:flutter/animation.dart';

// class NewestTest extends StatefulWidget{
//   const NewestTest({Key? key}) : super(key: key);

//   @override
//   NewestTestState createState() => NewestTestState();
// }

// class NewestTestState extends State<NewestTest> with TickerProviderStateMixin{
//   // final List<double> delays = [.0, -1.1, -1.0, -0.9, -0.8, -0.7, -0.6, -0.5, -0.4, -0.3, -0.2, -0.1];
//   final List<double> delays = [.0, -1.1,];
//   AnimationController? _controller;
//   double size = 50.0;
//   IndexedWidgetBuilder? itemBuilder;

//   // AnimationController? controller;

//   @override
//   void initState() {
//     super.initState();

//     // _controller = (widget.controller ?? AnimationController(vsync: this, duration: widget.duration))..repeat();
//     // _controller = (AnimationController(vsync: this, duration: const Duration(seconds: 15)))..repeat();
//     _controller = AnimationController(vsync: this, duration: const Duration(seconds: 1))..repeat();
//   }

//   @override
//   void dispose(){
//     _controller!.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context){
//     return Center(
//       child: SizedBox.fromSize(
//         size: Size.square(size),
//         child: Stack(
//           children: List.generate(delays.length, (index) {
//             final _position = size * .5;
//             return Positioned.fill(
//               left: _position,
//               top: _position,
//               child: Transform(
//                 transform: Matrix4.rotationZ(30.0 * index * 0.0174533),
//                 child: Align(
//                   alignment: Alignment.center,
//                   child: ScaleTransition(
//                     scale: DelayTween(begin: 0.0, end: 1.0, delay: delays[index]).animate(_controller!),
//                     child: SizedBox.fromSize(size: Size.square(size * 0.15), child: _itemBuilder(index)),
//                   ),
//                 ),
//               ),
//             );
//           }),
//         ),
//       ),
//     );
//   }

//   Widget _itemBuilder(int index) => itemBuilder != null
//       ? itemBuilder!(context, index)
//       : const DecoratedBox(decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle));
// }

// class DelayTween extends Tween<double> {
//   DelayTween({double? begin, double? end, required this.delay}) : super(begin: begin, end: end);

//   final double delay;

//   @override
//   double lerp(double t) => super.lerp((math.sin((t - delay) * 2 * math.pi) + 1) / 2);

//   @override
//   double evaluate(Animation<double> animation) => lerp(animation.value);
// }