part of misc;

class MiscButtonTemplate extends StatelessWidget{
  final String buttonText;
  final TextStyle buttonTextStyle;
  final Function() onPressed;
  final double width;
  final double height;
  final Color buttonColor;
  const MiscButtonTemplate({
    Key? key,
    this.buttonText = 'Next',
    this.buttonTextStyle = const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xffffffff),),
    required this.onPressed,
    required this.width,
    required this.height,
    this.buttonColor = const Color(0xff04ECFF),
  }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return MaterialButton(
      child: Text(buttonText, style: buttonTextStyle,),
      shape: const StadiumBorder(),
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      color: buttonColor,
      minWidth: width,
      height: height,
    );
  }
}