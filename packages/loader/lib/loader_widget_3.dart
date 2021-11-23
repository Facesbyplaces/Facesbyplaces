part of loader;

class CustomLoaderTextLoader extends StatefulWidget{
  const CustomLoaderTextLoader({Key? key}) : super(key: key);

  @override
  CustomLoaderTextLoaderState createState() => CustomLoaderTextLoaderState();
}

class CustomLoaderTextLoaderState extends State<CustomLoaderTextLoader> with SingleTickerProviderStateMixin{
  late AnimationController _controller;
  double size = 50.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500))..repeat();
  }

  @override
  void dispose(){
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xffffffff),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Your memorial page is still being created. Please wait a moment.', textAlign: TextAlign.center, style: TextStyle(fontSize: 32, color: Color(0xff888888), fontFamily: 'NexaBold',),),

            const SizedBox(height: 50),
            
            SizedBox.fromSize(
              size: Size(size * 2, size),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(3, (i) {
                  return ScaleTransition(
                    scale: DelayTween(begin: 0.0, end: 1.0, delay: i * .2).animate(_controller),
                    child: SizedBox.fromSize(size: Size.square(size * 0.5), child: const DecoratedBox(decoration: BoxDecoration(color: Color(0xff000000), shape: BoxShape.circle))),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class DelayTween extends Tween<double> {
//   DelayTween({double? begin, double? end, required this.delay}) : super(begin: begin, end: end);

//   final double delay;

//   @override
//   double lerp(double t) => super.lerp((math.sin((t - delay) * 2 * math.pi) + 1) / 2);

//   @override
//   double evaluate(Animation<double> animation) => lerp(animation.value);
// }