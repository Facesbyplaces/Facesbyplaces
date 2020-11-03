import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/Bloc/bloc-01-bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class MiscInputFieldOTP extends StatefulWidget {  
  MiscInputFieldOTP({Key key}) : super(key: key);

  @override
  MiscInputFieldOTPState createState() => MiscInputFieldOTPState();
}

class MiscInputFieldOTPState extends State<MiscInputFieldOTP> {

  TextEditingController controller = TextEditingController();
  bool readOnly;
  bool checker;

  @override
  void initState(){
    super.initState();
    checker = false;
  }


  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLength: 1,
      maxLengthEnforced: true,
      cursorColor: Color(0xff000000),
      controller: controller,
      textAlign: TextAlign.center,
      keyboardType: TextInputType.number,
      onChanged: (value){
        if(!checker){
          if(value.length == 1){
            context.bloc<BlocUpdateButtonText>().add();
            setState(() {
              checker = true;
            });
          }
        }else{
          if(value.length == 0){
            context.bloc<BlocUpdateButtonText>().remove();
            setState(() {
              checker = false;
            });
          }
        }
      },
      style: TextStyle(
        fontSize: SizeConfig.safeBlockHorizontal * 15,
        fontWeight: FontWeight.bold,
        color: Color(0xff000000)
      ),
      decoration: InputDecoration(
        alignLabelWithHint: true,
        counterText: '',
        labelStyle: TextStyle(
          fontSize: SizeConfig.safeBlockHorizontal * 4,
          fontWeight: FontWeight.w400,
          color: Color(0xff000000).withOpacity(.5),
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xff000000),
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xff000000),
          ),
        ),
      ),
    );
  }
}

class MiscInputFieldTemplate extends StatefulWidget{
  final String labelText;
  final TextStyle labelTextStyle;
  final bool obscureText;
  final TextInputType type;
  final int maxLines;
  final bool readOnly;
  final bool includeSuffixIcon;

  MiscInputFieldTemplate({
    Key key,
    this.labelText = '',
    this.labelTextStyle = const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey,),
    this.obscureText = false, 
    this.type = TextInputType.text, 
    this.maxLines = 1, 
    this.readOnly = false,
    this.includeSuffixIcon = false, 
  }) : super(key: key);
  

  MiscInputFieldTemplateState createState() => MiscInputFieldTemplateState(labelText: labelText, labelTextStyle: labelTextStyle, obscureText: obscureText, type: type, maxLines: maxLines, readOnly: readOnly, includeSuffixIcon: includeSuffixIcon);
}


class MiscInputFieldTemplateState extends State<MiscInputFieldTemplate>{
  final String labelText;
  final TextStyle labelTextStyle;
  final bool obscureText;
  final TextInputType type;
  final int maxLines;
  final bool readOnly;
  final bool includeSuffixIcon;

  MiscInputFieldTemplateState({this.labelText, this.labelTextStyle, this.obscureText, this.type, this.maxLines, this.readOnly, this.includeSuffixIcon});

  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: type,
      maxLines: maxLines,
      readOnly: readOnly,
      cursorColor: Color(0xff000000),
      decoration: InputDecoration(
        alignLabelWithHint: true,
        labelText: labelText,
        labelStyle: labelTextStyle,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xff000000),
          ),
        ),
        // suffixIcon: ((){
        //   if(includeSuffixIcon){
        //     if(obscure){
        //       return IconButton(
        //         onPressed: (){
        //           setState(() {
        //             obscure = !obscure;
        //           });
        //         },
        //         icon: Icon(Icons.visibility_off, color: Color(0xff000000).withOpacity(0.3), size: SizeConfig.blockSizeVertical * 4,),
        //       );
        //     }else{
        //       return IconButton(
        //         onPressed: (){
        //           setState(() {
        //             obscure = !obscure;
        //           });
        //         },
        //         icon: Icon(Icons.visibility, color: Color(0xff000000).withOpacity(0.3), size: SizeConfig.blockSizeVertical * 4,),
        //       );
        //     }
        //   }
        // }()),
      ),
    );
  }
}




class MiscInputFieldMultiTextTemplate extends StatefulWidget{
  final String labelText;
  final TextStyle labelTextStyle;
  final TextInputType type;
  final int maxLines;
  final bool readOnly;
  final Color backgroundColor;

  MiscInputFieldMultiTextTemplate({
    Key key,
    this.labelText = '',
    this.labelTextStyle = const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey,),
    this.type = TextInputType.text, 
    this.maxLines = 10,
    this.readOnly = false,
    this.backgroundColor = const Color(0xffffffff),
  }) : super(key: key);
  

  MiscInputFieldMultiTextTemplateState createState() => MiscInputFieldMultiTextTemplateState(labelText: labelText, labelTextStyle: labelTextStyle, type: type, maxLines: maxLines, readOnly: readOnly, backgroundColor: backgroundColor);
}


class MiscInputFieldMultiTextTemplateState extends State<MiscInputFieldMultiTextTemplate>{
  final String labelText;
  final TextStyle labelTextStyle;
  final TextInputType type;
  final int maxLines;
  final bool readOnly;
  final Color backgroundColor;

  MiscInputFieldMultiTextTemplateState({this.labelText, this.labelTextStyle, this.type, this.maxLines, this.readOnly, this.backgroundColor});

  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return TextFormField(
      controller: controller,
      cursorColor: Color(0xff000000),
      maxLines: maxLines,
      keyboardType: type,
      readOnly: readOnly,
      decoration: InputDecoration(
        fillColor: backgroundColor,
        filled: true,
        alignLabelWithHint: true,
        labelText: labelText,
        labelStyle: labelTextStyle,
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xff000000),
          ),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xff000000),
          ),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
    );
  }
}