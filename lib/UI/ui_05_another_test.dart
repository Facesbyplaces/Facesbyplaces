// import 'dart:math' as math;
// import 'dart:math';


// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';
// import 'dart:async';


// class SpinKitParagraphTest extends StatefulWidget {
//   const SpinKitParagraphTest({
//     Key? key,
//     required this.color,
//     this.size = 70,
//     this.lineWidth = 2.0,
//     this.itemCount = 5,
//     this.duration = const Duration(milliseconds: 3000),
//     this.controller,
//   }) : super(key: key);

//   final Color color;
//   final double size;

//   final double lineWidth;
//   final int itemCount;

//   final Duration duration;
//   final AnimationController? controller;

//   @override
//   SpinKitParagraphTestState createState() => SpinKitParagraphTestState();
// }

// class SpinKitParagraphTestState extends State<SpinKitParagraphTest> with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   // late Animation<double> _animation;

//   late Animation<double> _animation1;
//   late Animation<double> _animation2;
//   late Animation<double> _animation3;

//   @override
//   void initState() {
//     super.initState();

//     // _controller = (widget.controller ?? AnimationController(vsync: this, duration: widget.duration))
//     //   ..addListener(() => setState(() {}))
//     //   ..repeat();

//     // _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);

//     _controller = (widget.controller ?? AnimationController(vsync: this, duration: widget.duration))
//       ..addListener(() => setState(() {}))
//       ..repeat();
//     _animation1 = Tween(begin: 0.0, end: 1.0)
//         .animate(CurvedAnimation(parent: _controller, curve: const Interval(0.0, 1.0, curve: Curves.linear)));
//    _animation2 = Tween(begin: -2 / 3, end: 1 / 2)
//         .animate(CurvedAnimation(parent: _controller, curve: const Interval(0.5, 1.0, curve: Curves.linear)));
//     _animation3 = Tween(begin: 0.25, end: 5 / 6)
//         .animate(CurvedAnimation(parent: _controller, curve: const Interval(0.0, 1.0, curve: Curves.easeInCirc)));
//   }

//   @override
//   void dispose() {
//     if (widget.controller == null) {
//       _controller.dispose();
//     }
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: AnimatedBuilder(
//         builder: (BuildContext context, Widget? child) {
//           return CustomPaint(
//             child: SizedBox.fromSize(size: Size.square(widget.size)),
//             painter: SpinKitParagraphTestPainter(
//               paintWidth: 5,
//               trackColor: Colors.red,
//               progressPercent: _animation3.value,
//               startAngle: pi * _animation2.value,
//             ),
//           );
//         },
//         // animation: _animation,
//         animation: _animation1,
//       ),
//     );
//   }
// }

// class SpinKitParagraphTestPainter extends CustomPainter {

//   // double paintWidth = 5;
//   // Paint trackPaint = Paint();
//   // Color trackColor = Colors.red;
//   // double progressPercent = 1.0;
//   // double startAngle = 30.0;

//   SpinKitParagraphTestPainter({
//     required this.paintWidth,
//     this.progressPercent,
//     this.startAngle,
//     required this.trackColor,
//   }) : trackPaint = Paint()
//           ..color = trackColor
//           ..style = PaintingStyle.stroke
//           ..strokeWidth = paintWidth
//           ..strokeCap = StrokeCap.square;

//   final double paintWidth;
//   final Paint trackPaint;
//   final Color trackColor;
//   final double? progressPercent;
//   final double? startAngle;

//   @override
//   void paint(Canvas canvas, Size size) {
//     // const textStyle = TextStyle(
//     //   color: Colors.black,
//     //   fontSize: 30,
//     // );
//     // const textSpan = TextSpan(
//     //   text: 'Hello, world.',
//     //   style: textStyle,
//     // );
//     // final textPainter = TextPainter(
//     //   text: textSpan,
//     //   textDirection: TextDirection.ltr,
//     // );
//     // textPainter.layout(
//     //   minWidth: 0,
//     //   maxWidth: size.width,
//     // );
//     // const offset = Offset(50, 100);
//     // textPainter.paint(canvas, offset);
    
//     final center = Offset(size.width / 2, size.height / 2);
//     final radius = (min(size.width, size.height) - paintWidth) / 2;
//     canvas.drawArc(
//       Rect.fromCircle(center: center, radius: radius),
//       startAngle!,
//       2 * pi * progressPercent!,
//       false,
//       trackPaint,
//     );
//   }

//   @override
//   bool shouldRepaint(CustomPainter old) {
//     return true;
//   }
// }




// class SpinKitCircleTest extends StatefulWidget {
//   const SpinKitCircleTest({
//     Key? key,
//     this.color,
//     this.size = 50.0,
//     this.itemBuilder,
//     this.duration = const Duration(milliseconds: 1200),
//     this.controller,
//   })  : assert(!(itemBuilder is IndexedWidgetBuilder && color is Color) && !(itemBuilder == null && color == null),
//             'You should specify either a itemBuilder or a color'),
//         super(key: key);

//   final Color? color;
//   final double size;
//   final IndexedWidgetBuilder? itemBuilder;
//   final Duration duration;
//   final AnimationController? controller;

//   @override
//   SpinKitCircleTestState createState() => SpinKitCircleTestState();
// }

// class SpinKitCircleTestState extends State<SpinKitCircleTest> with SingleTickerProviderStateMixin {
//   final List<double> delays = [.0, -1.1, -1.0, -0.9, -0.8, -0.7, -0.6, -0.5, -0.4, -0.3, -0.2, -0.1];
//   late AnimationController _controller;

//   @override
//   void initState() {
//     super.initState();

//     _controller = (widget.controller ?? AnimationController(vsync: this, duration: widget.duration))..repeat();
//   }

//   @override
//   void dispose() {
//     if (widget.controller == null) {
//       _controller.dispose();
//     }
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: SizedBox.fromSize(
//         size: Size.square(widget.size),
//         child: Stack(
//           children: List.generate(delays.length, (index) {
//             final _position = widget.size * .5;
//             return Positioned.fill(
//               left: _position,
//               top: _position,
//               child: Transform(
//                 transform: Matrix4.rotationZ(30.0 * index * 0.0174533),
//                 // child: Align(
//                 //   alignment: Alignment.center,
//                 //   child: ScaleTransition(
//                 //     scale: DelayTween(begin: 0.0, end: 1.0, delay: delays[index]).animate(_controller),
//                 //     child: SizedBox.fromSize(size: Size.square(widget.size * 0.15), child: _itemBuilder(index)),
//                 //   ),
//                 // ),
//               ),
//             );
//           }),
//         ),
//       ),
//     );
//   }

//   Widget _itemBuilder(int index) => widget.itemBuilder != null
//       ? widget.itemBuilder!(context, index)
//       : DecoratedBox(decoration: BoxDecoration(color: widget.color, shape: BoxShape.circle));
// }


// class SpinKitSpinningLinesTest extends StatefulWidget {
//   const SpinKitSpinningLinesTest({
//     Key? key,
//     required this.color,
//     this.size = 70,
//     this.lineWidth = 2.0,
//     this.itemCount = 5,
//     this.duration = const Duration(milliseconds: 3000),
//     this.controller,
//   }) : super(key: key);

//   final Color color;
//   final double size;

//   final double lineWidth;
//   final int itemCount;

//   final Duration duration;
//   final AnimationController? controller;

//   @override
//   SpinKitSpinningLinesTestState createState() => SpinKitSpinningLinesTestState();
// }

// class SpinKitSpinningLinesTestState extends State<SpinKitSpinningLinesTest> with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _animation;

//   @override
//   void initState() {
//     super.initState();

//     _controller = (widget.controller ?? AnimationController(vsync: this, duration: widget.duration))
//       ..addListener(() => setState(() {}))
//       ..repeat();

//     _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
//   }

//   @override
//   void dispose() {
//     if (widget.controller == null) {
//       _controller.dispose();
//     }
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: AnimatedBuilder(
//         builder: (BuildContext context, Widget? child) {
//           return CustomPaint(
//             child: SizedBox.fromSize(size: Size.square(widget.size)),
//             painter: SpinningLinesPainter(
//               _animation.value,
//               lineWidth: widget.lineWidth,
//               color: widget.color,
//               itemCount: widget.itemCount,
//             ),
//           );
//         },
//         animation: _animation,
//       ),
//     );
//   }
// }

// class SpinningLinesPainter extends CustomPainter {
//   SpinningLinesPainter(
//     this.rotateValue, {
//     required Color color,
//     required this.lineWidth,
//     required this.itemCount,
//   }) : _linePaint = Paint()
//           ..color = color
//           ..strokeWidth = 1
//           ..style = PaintingStyle.fill;

//   final double rotateValue;
//   final double lineWidth;
//   final int itemCount;

//   final Paint _linePaint;

//   @override
//   void paint(Canvas canvas, Size size) {
//     for (var i = 1; i <= itemCount; i++) {
//       _drawSpin(canvas, size, _linePaint, i);
//     }
//   }

//   void _drawSpin(Canvas canvas, Size size, Paint paint, int scale) {
//     final scaledSize = size * (scale / itemCount);
//     final spinnerSize = Size.square(scaledSize.longestSide);

//     final startX = spinnerSize.width / 2;
//     final startY = spinnerSize.topCenter(Offset.zero).dy;

//     final radius = spinnerSize.width / 4;

//     final endX = startX;
//     final endY = spinnerSize.bottomCenter(Offset.zero).dy;

//     final borderWith = lineWidth;

//     final scaleFactor = -(scale - (itemCount + 1));

//     final path = Path();
//     path.moveTo(startX, startY);
//     path.arcToPoint(
//       Offset(endX, endY),
//       radius: Radius.circular(radius),
//       clockwise: false,
//     );
//     path.arcToPoint(
//       Offset(startX, startY + borderWith),
//       radius: Radius.circular(radius),
//     );
//     path.lineTo(startX, startY);

//     canvas.save();
//     _translateCanvas(canvas, size, spinnerSize);
//     _rotateCanvas(
//       canvas,
//       spinnerSize,
//       _getRadian(rotateValue * 360 * scaleFactor),
//     );
//     canvas.drawPath(path, paint);
//     canvas.restore();
//   }

//   void _translateCanvas(Canvas canvas, Size size, Size spinnerSize) {
//     final offset = (size - spinnerSize as Offset) / 2;
//     canvas.translate(offset.dx, offset.dy);
//   }

//   /// I use the following resource to calculate rotation of the canvas
//   /// https://stackoverflow.com/a/54336099/9689717
//   void _rotateCanvas(Canvas canvas, Size size, double angle) {
//     final double r = sqrt(size.width * size.width + size.height * size.height) / 2;
//     final alpha = atan(size.height / size.width);
//     final beta = alpha + angle;
//     final shiftY = r * sin(beta);
//     final shiftX = r * cos(beta);
//     final translateX = size.width / 2 - shiftX;
//     final translateY = size.height / 2 - shiftY;
//     canvas.translate(translateX, translateY);
//     canvas.rotate(angle);
//   }

//   double _getRadian(double angle) => math.pi / 180 * angle;

//   @override
//   bool shouldRepaint(SpinningLinesPainter oldDelegate) =>
//       oldDelegate.rotateValue != rotateValue ||
//       oldDelegate.lineWidth != lineWidth ||
//       oldDelegate.itemCount != itemCount ||
//       oldDelegate._linePaint != _linePaint;
// }


// class GlobalLoaderOverlayTest extends StatelessWidget{
//   GlobalLoaderOverlayTest({
//     required this.child,
//     this.useDefaultLoading = true,
//     this.overlayColor,
//     this.overlayOpacity,
//     this.overlayWidget,
//     this.textDirection = TextDirection.ltr,
//   });

//   final Widget child;
//   final bool useDefaultLoading;
//   final Color? overlayColor;
//   final double? overlayOpacity;
//   final Widget? overlayWidget;
//   final TextDirection textDirection;

//   @override
//   Widget build(BuildContext context) {
//     return Directionality(
//       textDirection: textDirection,
//       child: LoaderOverlayTest(
//         useDefaultLoading: useDefaultLoading,
//         overlayColor: overlayColor,
//         overlayOpacity: overlayOpacity,
//         overlayWidget: overlayWidget,
//         child: child,
//       ),
//     );
//   }
// }

// ///Just a extension to make it cleaner to show or hide the overlay
// extension OverlayControllerWidgetExtension on BuildContext {
//   @Deprecated('Use context.loaderOverlay instead')
//   OverlayControllerWidgetTest? getOverlayController() =>
//       OverlayControllerWidgetTest.of(this);

//   ///Extension created to show the overlay
//   @Deprecated('Use context.loaderOverlay.show() instead')
//   void showLoaderOverlay({
//     Widget? widget,
//   }) =>
//       getOverlayController()!.setOverlayVisible(true, widget: widget);

//   ///Extension created to hide the overlay
//   @Deprecated('Use context.loaderOverlay.hide() instead')
//   void hideLoaderOverlay() => getOverlayController()?.setOverlayVisible(false);

//   _OverlayExtensionHelper get loaderOverlay =>
//       _OverlayExtensionHelper(OverlayControllerWidgetTest.of(this));
// }

// class _OverlayExtensionHelper {
//   static final _OverlayExtensionHelper _singleton =
//       _OverlayExtensionHelper._internal();
//   late OverlayControllerWidgetTest _overlayController;

//   Widget? _widget;
//   bool? _visible;

//   OverlayControllerWidgetTest get overlayController => _overlayController;
//   bool get visible => _visible ?? false;

//   factory _OverlayExtensionHelper(OverlayControllerWidgetTest? overlayController) {
//     if (overlayController != null) {
//       _singleton._overlayController = overlayController;
//     }

//     return _singleton;
//   }
//   _OverlayExtensionHelper._internal();

//   Type? get overlayWidgetType => _widget?.runtimeType;

//   void show({Widget? widget}) {
//     _widget = widget;
//     _visible = true;
//     _overlayController.setOverlayVisible(_visible!, widget: _widget);
//   }

//   void hide() {
//     _visible = false;
//     _overlayController.setOverlayVisible(_visible!);
//   }
// }

// class OverlayControllerWidgetTest extends InheritedWidget {
//   OverlayControllerWidgetTest({required Widget child}) : super(child: child);

//   static OverlayControllerWidgetTest? of(BuildContext context) =>
//       context.findAncestorWidgetOfExactType<OverlayControllerWidgetTest>();

//   final StreamController<Map<String, dynamic>> visibilityController =
//       StreamController();

//   Stream<Map<String, dynamic>> get visibilityStream =>
//       visibilityController.stream;

//   ///Set the visibility of the overlay
//   void setOverlayVisible(
//     bool loading, {
//     Widget? widget,
//   }) =>
//       visibilityController.add(<String, dynamic>{
//         'loading': loading,
//         'widget': widget,
//       });

//   ///Dispose the controller
//   void dispose() => visibilityController.close();

//   @override
//   bool updateShouldNotify(InheritedWidget oldWidget) => true;
// }

// class LoaderOverlayTest extends StatefulWidget {
//   const LoaderOverlayTest({
//     this.overlayWidget,
//     this.useDefaultLoading = useDefaultLoadingValue,
//     this.overlayOpacity,
//     this.overlayColor = defaultOverlayColor,
//     required this.child,
//   });

//   final Widget? overlayWidget;
//   final bool useDefaultLoading;
//   final double? overlayOpacity;
//   final Color? overlayColor;
//   final Widget child;

//   static const _prefix = '@loader-overlay';

//   static const defaultOverlayWidgetKey = Key('$_prefix/default-widget');

//   static const opacityWidgetKey = Key('$_prefix/opacity-widget');

//   static const defaultOpacityValue = 0.4;

//   static const defaultOverlayColor = Colors.grey;

//   static const containerForOverlayColorKey =
//       Key('$_prefix/container-for-overlay-color');

//   static const useDefaultLoadingValue = true;

//   @override
//   _LoaderOverlayState createState() => _LoaderOverlayState();
// }

// // Has the Center CircularProgressIndicator as the default loader
// class _LoaderOverlayState extends State<LoaderOverlayTest> {
//   OverlayControllerWidgetTest? _overlayControllerWidget;

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     setState(() {
//       _overlayControllerWidget = OverlayControllerWidgetTest.of(context);
//     });
//   }

//   @override
//   void dispose() {
//     _overlayControllerWidget?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return OverlayControllerWidgetTest(
//       child: Builder(
//         builder: (innerContext) => StreamBuilder<Map<String, dynamic>>(
//           stream: innerContext.loaderOverlay.overlayController.visibilityStream,
//           initialData: const <String, dynamic>{
//             'loading': false,
//             'widget': null,
//           },
//           builder: (_, snapshot) {
//             final isLoading = snapshot.data!['loading'] as bool;
//             final widgetOverlay = snapshot.data!['widget'] as Widget?;
//             return Stack(
//               children: <Widget>[
//                 widget.child,
//                 if (isLoading) ...[
//                   Opacity(
//                     key: LoaderOverlayTest.opacityWidgetKey,
//                     opacity: isLoading
//                         ? (widget.overlayOpacity ??
//                             LoaderOverlayTest.defaultOpacityValue)
//                         : 0,
//                     child: Container(
//                       key: LoaderOverlayTest.containerForOverlayColorKey,
//                       color: widget.overlayColor,
//                     ),
//                   ),
//                   if (widgetOverlay != null)
//                     _widgetOverlay(widgetOverlay)
//                   else
//                     widget.useDefaultLoading
//                         ? _getDefaultLoadingWidget()
//                         : widget.overlayWidget!,
//                 ] else
//                   const SizedBox.shrink(),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }

//   Widget _widgetOverlay(Widget widget) => SizedBox(
//         height: double.infinity,
//         width: double.infinity,
//         child: Material(
//           color: Colors.transparent,
//           child: widget,
//         ),
//       );

//   Widget _getDefaultLoadingWidget() => const Center(
//         child: CircularProgressIndicator(
//           key: LoaderOverlayTest.defaultOverlayWidgetKey,
//         ),
//       );
// }


// class AnotherTest extends StatefulWidget{
//   const AnotherTest({Key? key}) : super(key: key);

//   @override
//   AnotherTestState createState() => AnotherTestState();
// }

// class AnotherTestState extends State<AnotherTest>{

//   // void onPress() async{
//   //   // print('hehehe');
//   //   Future.delayed(const Duration(seconds: 3), (){

//   //     print('Here');
//   //   });
//   // }

//   // Future.delayed(duration)<int> onPress() async{
//   //   // Timer(const Duration(seconds: 3), () {
//   //   //   print('Here');
//   //   // });
//   //   Future.delayed(const Duration(seconds: 3));
//   //   print('Here');
//   //   return 1;
//   // }

//   // @override
//   // void initState(){
//   //   super.initState();
    
//   // }

//   Future<bool> newTest() async{
//     // https://api.sampleapis.com/beers/ale
//     Dio dioRequest = Dio();
//     var response = await dioRequest.get('https://api.sampleapis.com/beers/ale',
//       options: Options(
//         headers: <String, dynamic>{
//           'Content-Type': 'application/json',
//         },
//         validateStatus: (status){
//           return status! < 600;
//         },
//         followRedirects: false,
//       ),
//     );

//     print('The response is ${response.statusCode}');

//   if(response.statusCode == 200){
//     return true;
//   }else{
//     return false;
//   }
//   }

//   @override
//   Widget build(BuildContext context){
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Center(
//         child: MaterialButton(
//           onPressed: () async{
//             context.loaderOverlay.show();
//             // const Duration(seconds: 3);
//             // onPress();
//             // Timer(const Duration(seconds: 3), onPress);

//             // int newValue = onPress();
//             bool newValue = await newTest();
//             print('The newValue is $newValue');

//             context.loaderOverlay.hide();
//           },
//           child: const Text('Press!'),
//           color: Colors.red,
//         ),
//       ),
//     );
//   }
// }