import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';

class MiscBLMInputFieldTemplate extends StatefulWidget{
  final String labelText;
  final TextStyle labelTextStyle;
  final bool obscureText;
  final TextInputType type;
  final int maxLines;
  final bool readOnly;
  final bool includeSuffixIcon;
  final String displayText;

  const MiscBLMInputFieldTemplate({
    required Key key,
    this.labelText = '',
    this.labelTextStyle = const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: const Color(0xff888888),),
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

  MiscBLMInputFieldTemplateState({required this.labelText, required this.labelTextStyle, required this.obscureText, required this.type, required this.maxLines, required this.readOnly, required this.includeSuffixIcon, required this.displayText});

  TextEditingController controller = TextEditingController(text: '');

  void initState(){
    super.initState();
    controller = TextEditingController(text: displayText);
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: type,
      maxLines: maxLines,
      readOnly: readOnly,
      cursorColor: const Color(0xff000000),
      decoration: InputDecoration(
        alignLabelWithHint: true,
        labelText: labelText,
        labelStyle: labelTextStyle,
        focusedBorder: const UnderlineInputBorder(
          borderSide: const BorderSide(
            color: const Color(0xff000000),
          ),
        ),
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

  const MiscBLMInputFieldMultiTextTemplate({
    required Key key,
    this.labelText = '',
    this.labelTextStyle = const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: const Color(0xff888888),),
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

  MiscBLMInputFieldMultiTextTemplateState({required this.labelText, required this.labelTextStyle, required this.type, required this.maxLines, required this.readOnly, required this.backgroundColor});

  TextEditingController controller = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      cursorColor: const Color(0xff000000),
      maxLines: maxLines,
      keyboardType: type,
      readOnly: readOnly,
      decoration: InputDecoration(
        fillColor: backgroundColor,
        filled: true,
        alignLabelWithHint: true,
        labelText: labelText,
        labelStyle: labelTextStyle,
        border: const OutlineInputBorder(
          borderSide: const BorderSide(
            color: const Color(0xff000000),
          ),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: const BorderSide(
            color: const Color(0xff000000),
          ),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
      ),
    );
  }
}

class MiscBLMInputFieldDropDown extends StatefulWidget{

  final String displayText;
  const MiscBLMInputFieldDropDown({required Key key, this.displayText = 'Father',}) : super(key: key);

  @override
  MiscBLMInputFieldDropDownState createState() => MiscBLMInputFieldDropDownState(displayText: displayText);
}

class MiscBLMInputFieldDropDownState extends State<MiscBLMInputFieldDropDown>{

  final String displayText;
  MiscBLMInputFieldDropDownState({required this.displayText});

  List<String> relationship = ['Father', 'Mother', 'Sister', 'Brother', 'Aunt', 'Uncle', 'Nephew', 'Grandmother', 'Grandfather'];
  String currentSelection = 'Father';

  void initState(){
    super.initState();
    currentSelection = displayText;
  }

  @override
  Widget build(BuildContext context){
    return InputDecorator(
      decoration: const InputDecoration(
        alignLabelWithHint: true,
        labelText: 'Relationship',
        labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: const Color(0xff888888)),
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
          onChanged: (String? newValue) {
            setState(() {
              currentSelection = newValue!;
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

class MiscBLMInputFieldSecurityQuestions extends StatefulWidget{

  final String displayText;
  const MiscBLMInputFieldSecurityQuestions({required Key key, this.displayText = 'What\'s the name of your first dog?',}) : super(key: key);

  @override
  MiscBLMInputFieldSecurityQuestionsState createState() => MiscBLMInputFieldSecurityQuestionsState(displayText: displayText);
}

class MiscBLMInputFieldSecurityQuestionsState extends State<MiscBLMInputFieldSecurityQuestions>{

  final String displayText;
  MiscBLMInputFieldSecurityQuestionsState({required this.displayText});

  List<String> securityQuestions = [
    'What\'s the name of your first dog?', 
    'What primary school did you attend?', 
    'In what city or town was your first job?', 
    'What was your childhood nickname?', 
    'What street did you live on in third grade?',
  ];
  String currentSelection = 'What\'s the name of your first dog?';

  void initState(){
    super.initState();
    currentSelection = displayText;
  }

  @override
  Widget build(BuildContext context){
    return InputDecorator(
      decoration: const InputDecoration(
        alignLabelWithHint: true,
        labelText: 'Security Question',
        labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: const Color(0xff888888)),
        focusedBorder: const UnderlineInputBorder(
          borderSide: const BorderSide(
            color: const Color(0xff000000),
          ),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          style: const TextStyle(
            fontSize: 14, fontWeight: FontWeight.w400, color: const Color(0xff000000)
          ),
          value: currentSelection,
          isDense: true,
          onChanged: (String? newValue) {
            setState(() {
              currentSelection = newValue!;
            });
          },
          items: securityQuestions.map((String value) {
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

  const MiscBLMInputFieldDateTimeTemplate({required Key key, this.labelText = '', this.dateTimePickerType = DateTimePickerType.date, this.displayText = ''}) : super(key: key);

  MiscBLMInputFieldDateTimeTemplateState createState() => MiscBLMInputFieldDateTimeTemplateState(labelText: labelText, dateTimePickerType: dateTimePickerType, displayText: displayText);
}

class MiscBLMInputFieldDateTimeTemplateState extends State<MiscBLMInputFieldDateTimeTemplate>{
  final String labelText;
  final DateTimePickerType dateTimePickerType;
  final String displayText;

  MiscBLMInputFieldDateTimeTemplateState({required this.labelText, required this.dateTimePickerType, required this.displayText});

  TextEditingController controller = TextEditingController(text: '');

  void initState(){
    super.initState();
    controller = TextEditingController(text: displayText);
  }

  @override
  Widget build(BuildContext context) {
    return DateTimePicker(
      type: dateTimePickerType,
      controller: controller,
      cursorColor: const Color(0xff000000),
      firstDate: DateTime(1000),
      lastDate: DateTime.now(),
      decoration: InputDecoration(
        alignLabelWithHint: true,
        labelText: labelText,
        labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: const Color(0xff888888),),
        focusedBorder: const UnderlineInputBorder(
          borderSide: const BorderSide(
            color: const Color(0xff000000),
          ),
        ),
      ),
    );
  }
}

class MiscBLMPhoneNumberTemplate extends StatefulWidget{
  final String labelText;
  final TextStyle labelTextStyle;
  final bool obscureText;
  final TextInputType type;
  final int maxLines;
  final bool readOnly;
  final bool includeSuffixIcon;
  final String displayText;

  const MiscBLMPhoneNumberTemplate({
    required Key key,
    this.labelText = '',
    this.labelTextStyle = const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: const Color(0xff888888),),
    this.obscureText = false, 
    this.type = TextInputType.text, 
    this.maxLines = 1, 
    this.readOnly = false,
    this.includeSuffixIcon = false,
    this.displayText = '', 
  }) : super(key: key);
  
  MiscBLMPhoneNumberTemplateState createState() => MiscBLMPhoneNumberTemplateState(labelText: labelText, labelTextStyle: labelTextStyle, obscureText: obscureText, type: type, maxLines: maxLines, readOnly: readOnly, includeSuffixIcon: includeSuffixIcon, displayText: displayText);
}

class MiscBLMPhoneNumberTemplateState extends State<MiscBLMPhoneNumberTemplate>{
  final String labelText;
  final TextStyle labelTextStyle;
  final bool obscureText;
  final TextInputType type;
  final int maxLines;
  final bool readOnly;
  final bool includeSuffixIcon;
  final String displayText;

  MiscBLMPhoneNumberTemplateState({required this.labelText, required this.labelTextStyle, required this.obscureText, required this.type, required this.maxLines, required this.readOnly, required this.includeSuffixIcon, required this.displayText});

  TextEditingController controller = TextEditingController(text: '');
  bool valid = false;  

  void initState(){
    super.initState();
    controller = TextEditingController(text: displayText);
  }

  @override
  Widget build(BuildContext context) {
    return InternationalPhoneNumberInput(
      selectorConfig: const SelectorConfig(selectorType: PhoneInputSelectorType.BOTTOM_SHEET, showFlags: false,),
      textFieldController: controller,
      onInputChanged: (PhoneNumber number){
        print(number.phoneNumber);
      },
      onInputValidated: (bool value) {
        setState(() {
          valid = value;
        });
      },
      inputDecoration: InputDecoration(
        alignLabelWithHint: true,
        labelText: labelText,
        labelStyle: labelTextStyle,
        focusedBorder: const UnderlineInputBorder(
          borderSide: const BorderSide(
            color: const Color(0xff000000),
          ),
        ),
      ),
    );
  }
}