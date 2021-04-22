import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:date_time_picker/date_time_picker.dart';
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

  MiscRegularInputFieldTemplate({
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

  final String displayText;

  MiscRegularInputFieldDropDown({
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

  MiscRegularInputFieldSecurityQuestions({
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
      decoration: InputDecoration(
        alignLabelWithHint: true,
        labelText: 'Security Question',
        labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xff000000),
          ),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          style: TextStyle(
            fontSize: 14, fontWeight: FontWeight.w400, color: Color(0xff000000)
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
  final DateTimePickerType dateTimePickerType;
  final String displayText;

  MiscRegularInputFieldDateTimeTemplate({required Key key, this.labelText = '', this.dateTimePickerType = DateTimePickerType.date, this.displayText = ''}) : super(key: key);

  MiscRegularInputFieldDateTimeTemplateState createState() => MiscRegularInputFieldDateTimeTemplateState(labelText: labelText, dateTimePickerType: dateTimePickerType, displayText: displayText);
}

class MiscRegularInputFieldDateTimeTemplateState extends State<MiscRegularInputFieldDateTimeTemplate>{
  final String labelText;
  final DateTimePickerType dateTimePickerType;
  final String displayText;

  MiscRegularInputFieldDateTimeTemplateState({required this.labelText, required this.dateTimePickerType, required this.displayText});

  TextEditingController controller = TextEditingController(text: '');

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
        labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey,),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xff000000),
          ),
        ),
      ),
    );
  }
}

// class MiscRegularPhoneNumberPickerTemplate extends StatefulWidget{
//   final String labelText;
//   final TextStyle labelTextStyle;
//   final bool obscureText;
//   final TextInputType type;
//   final int maxLines;
//   final bool readOnly;
//   final bool includeSuffixIcon;
//   final String displayText;

//   MiscRegularPhoneNumberPickerTemplate({
//     required Key key,
//     this.labelText = '',
//     this.labelTextStyle = const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey,),
//     this.obscureText = false, 
//     this.type = TextInputType.text, 
//     this.maxLines = 1, 
//     this.readOnly = false,
//     this.includeSuffixIcon = false,
//     this.displayText = '',
//   }) : super(key: key);
  
//   MiscRegularPhoneNumberPickerTemplateState createState() => MiscRegularPhoneNumberPickerTemplateState(labelText: labelText, labelTextStyle: labelTextStyle, obscureText: obscureText, type: type, maxLines: maxLines, readOnly: readOnly, includeSuffixIcon: includeSuffixIcon, displayText: displayText);
// }

// class MiscRegularPhoneNumberPickerTemplateState extends State<MiscRegularPhoneNumberPickerTemplate>{
//   final String labelText;
//   final TextStyle labelTextStyle;
//   final bool obscureText;
//   final TextInputType type;
//   final int maxLines;
//   final bool readOnly;
//   final bool includeSuffixIcon;
//   final String displayText;

//   MiscRegularPhoneNumberPickerTemplateState({required this.labelText, required this.labelTextStyle, required this.obscureText, required this.type, required this.maxLines, required this.readOnly, required this.includeSuffixIcon, required this.displayText});

//   TextEditingController controller1 = TextEditingController(text: '+1');
//   TextEditingController controller2 = TextEditingController(text: '');

//   var globalPhoneType = PhoneNumberType.mobile;
//   var globalPhoneFormat = PhoneNumberFormat.international;

//   String get overrideCountryCode {
//     if (controller1.text.isNotEmpty) {
//       try {
//         return CountryManager().countries.firstWhere((element) => element.phoneCode == controller1.text.replaceAll(RegExp(r'[^\d]+'), '')).countryCode;
//       } catch (_) {
//         return '';
//       }
//     } else {
//       return '';
//     }
//   }

//   void initState(){
//     super.initState();
//     controller2 = TextEditingController(text: displayText);
//   }

//   @override
//   Widget build(BuildContext context) {
//     SizeConfig.init(context);
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Container(
//           width: 50,
//           child: TextFormField(
//             onTap: (){
//             showCountryPicker(
//               context: context,
//               showPhoneCode: true,
//               onSelect: (Country country) {
//                 setState(() {
//                   controller1.text = '+${country.phoneCode}';
//                 });
//               },
//             );
//             },
//             readOnly: true,
//             controller: controller1,
//             decoration: InputDecoration(
//               hintStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey,),
//               focusedBorder: UnderlineInputBorder(
//                 borderSide: BorderSide(
//                   color: Color(0xff000000),
//                 ),
//               ),
//             ),
//           ),
//         ),

//         SizedBox(width: 20,),
        
//         Expanded(
//           child: TextFormField(
//             keyboardType: TextInputType.phone,
//             controller: controller2,
//             cursorColor: Color(0xff000000),
//             decoration: InputDecoration(
//               focusedBorder: UnderlineInputBorder(
//                 borderSide: BorderSide(
//                   color: Color(0xff000000),
//                 ),
//               ),
//             ),
            
//             inputFormatters: [
//               LibPhonenumberTextFormatter(
//                 phoneNumberType: globalPhoneType,
//                 phoneNumberFormat: globalPhoneFormat,
//                 overrideSkipCountryCode: overrideCountryCode,
//               ),
//             ],
//           ),
//         ),

//       ],
//     );
//   }
// }

class MiscRegularPhoneNumberTemplate extends StatefulWidget{
  final String labelText;
  final TextStyle labelTextStyle;
  final bool obscureText;
  final TextInputType type;
  final int maxLines;
  final bool readOnly;
  final bool includeSuffixIcon;
  final String displayText;

  MiscRegularPhoneNumberTemplate({
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
    SizeConfig.init(context);
    return InternationalPhoneNumberInput(
      selectorConfig: SelectorConfig(selectorType: PhoneInputSelectorType.BOTTOM_SHEET, showFlags: false,),
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
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xff000000),
          ),
        ),
      ),
    );
  }
}
