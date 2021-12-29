part of misc;

class HeartBeat extends StatefulWidget{
  const HeartBeat({Key? key}) : super(key: key);

  @override
  HeartBeatState createState() => HeartBeatState();
}

class HeartBeatState extends State<HeartBeat> with SingleTickerProviderStateMixin{
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500))..repeat();
    _animation = Tween(begin: 1.0, end: 1.25).animate(CurvedAnimation(parent: _controller, curve: const Interval(0.0, 1.0, curve: SpinKitPumpCurve())));
  }

  @override
  void dispose(){
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(scale: _animation, child: const Icon(Icons.favorite, color: Colors.red, size: 35));
  }
}

class SpinKitPumpCurve extends Curve {
  const SpinKitPumpCurve();

  static const magicNumber = 4.54545454;

  @override
  double transform(double t){
    if(t >= 0.0 && t < 0.22){
      return math.pow(t, 1.0) * magicNumber;
    }else if(t >= 0.22 && t < 0.44){
      return 1.0 - (math.pow(t - 0.22, 1.0) * magicNumber);
    }else if (t >= 0.44 && t < 0.5){
      return 0.0;
    }else if (t >= 0.5 && t < 0.72){
      return math.pow(t - 0.5, 1.0) * (magicNumber / 2);
    }else if (t >= 0.72 && t < 0.94){
      return 0.5 - (math.pow(t - 0.72, 1.0) * (magicNumber / 2));
    }
    return 0.0;
  }
}