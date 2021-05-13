import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter/material.dart';

class MiscRegularInputFieldTemplate extends StatefulWidget{
  final String labelText;
  final TextStyle labelTextStyle;
  final bool obscureText;
  final TextInputType type;
  final int maxLines;
  final bool readOnly;
  final bool includeSuffixIcon;
  final String displayText;
  final bool edited;

  const MiscRegularInputFieldTemplate({
    required Key key,
    this.labelText = '',
    this.labelTextStyle = const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey,),
    this.obscureText = false, 
    this.type = TextInputType.text, 
    this.maxLines = 1, 
    this.readOnly = false,
    this.includeSuffixIcon = false,
    this.displayText = '',
    this.edited = false,
  }) : super(key: key);
  
  MiscRegularInputFieldTemplateState createState() => MiscRegularInputFieldTemplateState(labelText: labelText, labelTextStyle: labelTextStyle, obscureText: obscureText, type: type, maxLines: maxLines, readOnly: readOnly, includeSuffixIcon: includeSuffixIcon, displayText: displayText, edited: edited);
}

class MiscRegularInputFieldTemplateState extends State<MiscRegularInputFieldTemplate>{
  final String labelText;
  final TextStyle labelTextStyle;
  final bool obscureText;
  final TextInputType type;
  final int maxLines;
  final bool readOnly;
  final bool includeSuffixIcon;
  final String displayText;
  final bool edited;

  MiscRegularInputFieldTemplateState({required this.labelText, required this.labelTextStyle, required this.obscureText, required this.type, required this.maxLines, required this.readOnly, required this.includeSuffixIcon, required this.displayText, required this.edited});

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

class MiscRegularInputFieldMultiTextTemplate extends StatefulWidget{
  final String labelText;
  final TextStyle labelTextStyle;
  final TextInputType type;
  final int maxLines;
  final bool readOnly;
  final Color backgroundColor;

  const MiscRegularInputFieldMultiTextTemplate({
    required Key key,
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

  MiscRegularInputFieldMultiTextTemplateState({required this.labelText, required this.labelTextStyle, required this.type, required this.maxLines, required this.readOnly, required this.backgroundColor});

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

class MiscRegularInputFieldDropDown extends StatefulWidget{

  final String displayText;

  const MiscRegularInputFieldDropDown({
    required Key key,
    this.displayText = 'Father',
  }) : super(key: key);

  @override
  MiscRegularInputFieldDropDownState createState() => MiscRegularInputFieldDropDownState(displayText: displayText);
}

class MiscRegularInputFieldDropDownState extends State<MiscRegularInputFieldDropDown>{

  final String displayText;

  MiscRegularInputFieldDropDownState({required this.displayText});

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
        focusedBorder: const UnderlineInputBorder(
          borderSide: const BorderSide(
            color: const Color(0xff000000),
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

class MiscRegularInputFieldSecurityQuestions extends StatefulWidget{

  final String displayText;

  const MiscRegularInputFieldSecurityQuestions({
    required Key key,
    this.displayText = 'What\'s the name of your first dog?',
  }) : super(key: key);

  @override
  MiscRegularInputFieldSecurityQuestionsState createState() => MiscRegularInputFieldSecurityQuestionsState(displayText: displayText);
}

class MiscRegularInputFieldSecurityQuestionsState extends State<MiscRegularInputFieldSecurityQuestions>{

  final String displayText;

  MiscRegularInputFieldSecurityQuestionsState({required this.displayText});

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

class MiscRegularInputFieldDateTimeTemplate extends StatefulWidget{

  final String labelText;
  final String displayText;

  const MiscRegularInputFieldDateTimeTemplate({required Key key, this.labelText = '', this.displayText = ''}) : super(key: key);

  MiscRegularInputFieldDateTimeTemplateState createState() => MiscRegularInputFieldDateTimeTemplateState(labelText: labelText, displayText: displayText);
}

class MiscRegularInputFieldDateTimeTemplateState extends State<MiscRegularInputFieldDateTimeTemplate>{
  final String labelText;
  final String displayText;

  MiscRegularInputFieldDateTimeTemplateState({required this.labelText, required this.displayText});

  TextEditingController controller = TextEditingController(text: '');

  void initState(){
    super.initState();
    controller = TextEditingController(text: displayText);
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.text,
      cursorColor: const Color(0xff000000),
      readOnly: true,
      onTap: (){
        DatePicker.showDatePicker(
          context, 
          showTitleActions: true,
          minTime: DateTime(1000),
          maxTime: DateTime.now(),
          currentTime: DateTime.now(),
          onConfirm: (date) {
            String format = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
            controller.text = format;
          },
          locale: LocaleType.en,
        );
      },
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

class MiscRegularPhoneNumberTemplate extends StatefulWidget{
  final String labelText;
  final TextStyle labelTextStyle;
  final bool obscureText;
  final TextInputType type;
  final int maxLines;
  final bool readOnly;
  final bool includeSuffixIcon;
  final String displayText;

  const MiscRegularPhoneNumberTemplate({
    required Key key,
    this.labelText = '',
    this.labelTextStyle = const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey,),
    this.obscureText = false, 
    this.type = TextInputType.text, 
    this.maxLines = 1, 
    this.readOnly = false,
    this.includeSuffixIcon = false,
    this.displayText = '',
  }) : super(key: key);
  
  MiscRegularPhoneNumberTemplateState createState() => MiscRegularPhoneNumberTemplateState(labelText: labelText, labelTextStyle: labelTextStyle, obscureText: obscureText, type: type, maxLines: maxLines, readOnly: readOnly, includeSuffixIcon: includeSuffixIcon, displayText: displayText);
}

class MiscRegularPhoneNumberTemplateState extends State<MiscRegularPhoneNumberTemplate>{
  final String labelText;
  final TextStyle labelTextStyle;
  final bool obscureText;
  final TextInputType type;
  final int maxLines;
  final bool readOnly;
  final bool includeSuffixIcon;
  final String displayText;

  MiscRegularPhoneNumberTemplateState({required this.labelText, required this.labelTextStyle, required this.obscureText, required this.type, required this.maxLines, required this.readOnly, required this.includeSuffixIcon, required this.displayText});

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