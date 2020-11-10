import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/Bloc/bloc-01-bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class MiscRegularInputFieldTemplate extends StatefulWidget{
  final String labelText;
  final TextStyle labelTextStyle;
  final bool obscureText;
  final TextInputType type;
  final int maxLines;
  final bool readOnly;
  final bool includeSuffixIcon;

  MiscRegularInputFieldTemplate({
    Key key,
    this.labelText = '',
    this.labelTextStyle = const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey,),
    this.obscureText = false, 
    this.type = TextInputType.text, 
    this.maxLines = 1, 
    this.readOnly = false,
    this.includeSuffixIcon = false, 
  }) : super(key: key);
  

  MiscRegularInputFieldTemplateState createState() => MiscRegularInputFieldTemplateState(labelText: labelText, labelTextStyle: labelTextStyle, obscureText: obscureText, type: type, maxLines: maxLines, readOnly: readOnly, includeSuffixIcon: includeSuffixIcon);
}


class MiscRegularInputFieldTemplateState extends State<MiscRegularInputFieldTemplate>{
  final String labelText;
  final TextStyle labelTextStyle;
  final bool obscureText;
  final TextInputType type;
  final int maxLines;
  final bool readOnly;
  final bool includeSuffixIcon;

  MiscRegularInputFieldTemplateState({this.labelText, this.labelTextStyle, this.obscureText, this.type, this.maxLines, this.readOnly, this.includeSuffixIcon});

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


class MiscRegularInputFieldMultiTextTemplate extends StatefulWidget{
  final String labelText;
  final TextStyle labelTextStyle;
  final TextInputType type;
  final int maxLines;
  final bool readOnly;
  final Color backgroundColor;

  MiscRegularInputFieldMultiTextTemplate({
    Key key,
    this.labelText = '',
    this.labelTextStyle = const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey,),
    this.type = TextInputType.text, 
    this.maxLines = 10,
    this.readOnly = false,
    this.backgroundColor = const Color(0xffffffff),
  }) : super(key: key);
  

  MiscRegularInputFieldMultiTextTemplateState createState() => MiscRegularInputFieldMultiTextTemplateState(labelText: labelText, labelTextStyle: labelTextStyle, type: type, maxLines: maxLines, readOnly: readOnly, backgroundColor: backgroundColor);
}


class MiscRegularInputFieldMultiTextTemplateState extends State<MiscRegularInputFieldMultiTextTemplate>{
  final String labelText;
  final TextStyle labelTextStyle;
  final TextInputType type;
  final int maxLines;
  final bool readOnly;
  final Color backgroundColor;

  MiscRegularInputFieldMultiTextTemplateState({this.labelText, this.labelTextStyle, this.type, this.maxLines, this.readOnly, this.backgroundColor});

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


class MiscRegularInputFieldDropDown extends StatefulWidget{

  MiscRegularInputFieldDropDown({Key key}) : super(key: key);

  @override
  MiscRegularInputFieldDropDownState createState() => MiscRegularInputFieldDropDownState();
}

class MiscRegularInputFieldDropDownState extends State<MiscRegularInputFieldDropDown>{

  List<String> relationship = ['Father', 'Mother', 'Sister', 'Brother', 'Aunt', 'Uncle', 'Nephew', 'Grandmother', 'Grandfather'];
  String currentSelection = 'Father';

  @override
  Widget build(BuildContext context){
    return InputDecorator(
      decoration: InputDecoration(
        alignLabelWithHint: true,
        labelText: 'Relationship',
        labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xff000000),
          ),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: currentSelection,
          isDense: true,
          onChanged: (String newValue) {
            setState(() {
              currentSelection = newValue;
            });
          },
          items: relationship.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class MiscRegularInputFieldDropDownUser extends StatefulWidget{

  MiscRegularInputFieldDropDownUser({Key key}) : super(key: key);

  @override
  MiscRegularInputFieldDropDownUserState createState() => MiscRegularInputFieldDropDownUserState();
}

class MiscRegularInputFieldDropDownUserState extends State<MiscRegularInputFieldDropDownUser>{

  List<String> relationship = ['Richard Nedd Memories', 'Default'];
  String currentSelection = 'Richard Nedd Memories';

  @override
  Widget build(BuildContext context){
    return InputDecorator(
      decoration: InputDecoration(
        alignLabelWithHint: true,
        labelText: 'Relationship',
        labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide.none,
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide.none,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: currentSelection,
          isDense: true,
          onChanged: (String newValue) {
            setState(() {
              currentSelection = newValue;
            });
          },
          items: relationship.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }
}


class MiscRegularInputFieldOTP extends StatefulWidget {  
  MiscRegularInputFieldOTP({Key key}) : super(key: key);

  @override
  MiscRegularInputFieldOTPState createState() => MiscRegularInputFieldOTPState();
}

class MiscRegularInputFieldOTPState extends State<MiscRegularInputFieldOTP> {

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
