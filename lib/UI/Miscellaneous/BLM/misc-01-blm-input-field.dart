import 'package:date_time_picker/date_time_picker.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/Bloc/bloc-01-bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class MiscBLMInputFieldOTP extends StatefulWidget {  
  MiscBLMInputFieldOTP({Key key}) : super(key: key);

  @override
  MiscBLMInputFieldOTPState createState() => MiscBLMInputFieldOTPState();
}

class MiscBLMInputFieldOTPState extends State<MiscBLMInputFieldOTP> {

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

class MiscBLMInputFieldTemplate extends StatefulWidget{
  final String labelText;
  final TextStyle labelTextStyle;
  final bool obscureText;
  final TextInputType type;
  final int maxLines;
  final bool readOnly;
  final bool includeSuffixIcon;
  final String displayText;

  MiscBLMInputFieldTemplate({
    Key key,
    this.labelText = '',
    this.labelTextStyle = const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey,),
    this.obscureText = false, 
    this.type = TextInputType.text, 
    this.maxLines = 1, 
    this.readOnly = false,
    this.includeSuffixIcon = false,
    this.displayText = '',
  }) : super(key: key);
  

  MiscBLMInputFieldTemplateState createState() => MiscBLMInputFieldTemplateState(labelText: labelText, labelTextStyle: labelTextStyle, obscureText: obscureText, type: type, maxLines: maxLines, readOnly: readOnly, includeSuffixIcon: includeSuffixIcon, displayText: displayText);
}


class MiscBLMInputFieldTemplateState extends State<MiscBLMInputFieldTemplate>{
  final String labelText;
  final TextStyle labelTextStyle;
  final bool obscureText;
  final TextInputType type;
  final int maxLines;
  final bool readOnly;
  final bool includeSuffixIcon;
  final String displayText;

  MiscBLMInputFieldTemplateState({this.labelText, this.labelTextStyle, this.obscureText, this.type, this.maxLines, this.readOnly, this.includeSuffixIcon, this.displayText});

  TextEditingController controller;

  void initState(){
    super.initState();
    controller = TextEditingController(text: displayText);
  }

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




class MiscBLMInputFieldMultiTextTemplate extends StatefulWidget{
  final String labelText;
  final TextStyle labelTextStyle;
  final TextInputType type;
  final int maxLines;
  final bool readOnly;
  final Color backgroundColor;

  MiscBLMInputFieldMultiTextTemplate({
    Key key,
    this.labelText = '',
    this.labelTextStyle = const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey,),
    this.type = TextInputType.text, 
    this.maxLines = 10,
    this.readOnly = false,
    this.backgroundColor = const Color(0xffffffff),
  }) : super(key: key);
  

  MiscBLMInputFieldMultiTextTemplateState createState() => MiscBLMInputFieldMultiTextTemplateState(labelText: labelText, labelTextStyle: labelTextStyle, type: type, maxLines: maxLines, readOnly: readOnly, backgroundColor: backgroundColor);
}


class MiscBLMInputFieldMultiTextTemplateState extends State<MiscBLMInputFieldMultiTextTemplate>{
  final String labelText;
  final TextStyle labelTextStyle;
  final TextInputType type;
  final int maxLines;
  final bool readOnly;
  final Color backgroundColor;

  MiscBLMInputFieldMultiTextTemplateState({this.labelText, this.labelTextStyle, this.type, this.maxLines, this.readOnly, this.backgroundColor});

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

class MiscBLMInputFieldDropDown extends StatefulWidget{

  final String displayText;

  MiscBLMInputFieldDropDown({
    Key key,
    this.displayText = 'Father',
  }) : super(key: key);

  @override
  MiscBLMInputFieldDropDownState createState() => MiscBLMInputFieldDropDownState(displayText: displayText);
}

class MiscBLMInputFieldDropDownState extends State<MiscBLMInputFieldDropDown>{

  final String displayText;

  MiscBLMInputFieldDropDownState({this.displayText});

  List<String> relationship = ['Father', 'Mother', 'Sister', 'Brother', 'Aunt', 'Uncle', 'Nephew', 'Grandmother', 'Grandfather'];
  // String currentSelection = 'Father';

  String currentSelection;

  void initState(){
    super.initState();
    currentSelection = displayText;
  }

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

class MiscBLMInputFieldDateTimeTemplate extends StatefulWidget{
  final String labelText;
  final DateTimePickerType dateTimePickerType;
  final String displayText;

  MiscBLMInputFieldDateTimeTemplate({Key key, this.labelText = '', this.dateTimePickerType = DateTimePickerType.date, this.displayText = ''}) : super(key: key);

  MiscBLMInputFieldDateTimeTemplateState createState() => MiscBLMInputFieldDateTimeTemplateState(labelText: labelText, dateTimePickerType: dateTimePickerType, displayText: displayText);
}


class MiscBLMInputFieldDateTimeTemplateState extends State<MiscBLMInputFieldDateTimeTemplate>{
  final String labelText;
  final DateTimePickerType dateTimePickerType;
  final String displayText;

  MiscBLMInputFieldDateTimeTemplateState({this.labelText, this.dateTimePickerType, this.displayText});

  TextEditingController controller = TextEditingController();

  void initState(){
    super.initState();
    controller = TextEditingController(text: displayText);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return DateTimePicker(
      type: dateTimePickerType,
      controller: controller,
      cursorColor: Color(0xff000000),
      firstDate: DateTime(1000),
      lastDate: DateTime.now(),
      decoration: InputDecoration(
        alignLabelWithHint: true,
        labelText: labelText,
        labelStyle: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, fontWeight: FontWeight.w400, color: Colors.grey,),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xff000000),
          ),
        ),
      ),
    );
  }
}