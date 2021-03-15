import 'package:facesbyplaces/Configurations/size_configuration.dart';
// import 'package:intl_phone_number_input/intl_phone_number_input.dart';
// import 'package:intl_phone_field/intl_phone_field.dart';
// import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter_libphonenumber/flutter_libphonenumber.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:country_picker/country_picker.dart';
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

  MiscBLMInputFieldTemplate({
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

class MiscBLMInputFieldMultiTextTemplate extends StatefulWidget{
  final String labelText;
  final TextStyle labelTextStyle;
  final TextInputType type;
  final int maxLines;
  final bool readOnly;
  final Color backgroundColor;

  MiscBLMInputFieldMultiTextTemplate({
    required Key key,
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

  MiscBLMInputFieldMultiTextTemplateState({required this.labelText, required this.labelTextStyle, required this.type, required this.maxLines, required this.readOnly, required this.backgroundColor});

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

class MiscBLMPhoneNumberTemplate extends StatefulWidget{
  final String labelText;
  final TextStyle labelTextStyle;
  final bool obscureText;
  final TextInputType type;
  final int maxLines;
  final bool readOnly;
  final bool includeSuffixIcon;
  final String displayText;

  MiscBLMPhoneNumberTemplate({
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

  TextEditingController controller = TextEditingController();
  bool valid = false;  

  void initState(){
    super.initState();
    controller = TextEditingController(text: displayText);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Container();
    // return IntlPhoneField(
    //   decoration: InputDecoration(
    //     alignLabelWithHint: true,
    //     labelText: labelText,
    //     labelStyle: labelTextStyle,
    //     focusedBorder: UnderlineInputBorder(
    //       borderSide: BorderSide(
    //         color: Color(0xff000000),
    //       ),
    //     ),
    //   ),
    // );
    // return InternationalPhoneNumberInput(
    //   selectorConfig: SelectorConfig(selectorType: PhoneInputSelectorType.BOTTOM_SHEET, showFlags: false,),
    //   textFieldController: controller,
    //   onInputChanged: (PhoneNumber number){
    //     print(number.phoneNumber);
    //   },
    //   onInputValidated: (bool value) {
    //     setState(() {
    //       valid = value;
    //     });
    //   },
    //   inputDecoration: InputDecoration(
    //     alignLabelWithHint: true,
    //     labelText: labelText,
    //     labelStyle: labelTextStyle,
    //     focusedBorder: UnderlineInputBorder(
    //       borderSide: BorderSide(
    //         color: Color(0xff000000),
    //       ),
    //     ),
    //   ),
    // );
  }
}

class MiscBLMInputFieldDropDown extends StatefulWidget{

  final String displayText;

  MiscBLMInputFieldDropDown({
    required Key key,
    this.displayText = 'Father',
  }) : super(key: key);

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

  MiscBLMInputFieldSecurityQuestions({
    required Key key,
    this.displayText = 'What\'s the name of your first dog?',
  }) : super(key: key);

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

// class MiscBLMInputFieldDateTimeTemplate extends StatefulWidget{
//   final String labelText;
//   final DateTimePickerType dateTimePickerType;
//   final String displayText;

//   MiscBLMInputFieldDateTimeTemplate({required Key key, this.labelText = '', this.dateTimePickerType = DateTimePickerType.date, this.displayText = ''}) : super(key: key);

//   MiscBLMInputFieldDateTimeTemplateState createState() => MiscBLMInputFieldDateTimeTemplateState(labelText: labelText, dateTimePickerType: dateTimePickerType, displayText: displayText);
// }

// class MiscBLMInputFieldDateTimeTemplateState extends State<MiscBLMInputFieldDateTimeTemplate>{
//   final String labelText;
//   final DateTimePickerType dateTimePickerType;
//   final String displayText;

//   MiscBLMInputFieldDateTimeTemplateState({required this.labelText, required this.dateTimePickerType, required this.displayText});

//   TextEditingController controller = TextEditingController();

//   void initState(){
//     super.initState();
//     controller = TextEditingController(text: displayText);
//   }

//   @override
//   Widget build(BuildContext context) {
//     SizeConfig.init(context);
//     return Container();
//     // return DateTimePicker(
//     //   type: dateTimePickerType,
//     //   controller: controller,
//     //   cursorColor: Color(0xff000000),
//     //   firstDate: DateTime(1000),
//     //   lastDate: DateTime.now(),
//     //   decoration: InputDecoration(
//     //     alignLabelWithHint: true,
//     //     labelText: labelText,
//     //     labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey,),
//     //     focusedBorder: UnderlineInputBorder(
//     //       borderSide: BorderSide(
//     //         color: Color(0xff000000),
//     //       ),
//     //     ),
//     //   ),
//     // );
//   }
// }


class MiscBLMInputFieldDateTimeTemplate extends StatefulWidget{

  final String labelText;
  final DateTimePickerType dateTimePickerType;
  final String displayText;

  MiscBLMInputFieldDateTimeTemplate({required Key key, this.labelText = '', this.dateTimePickerType = DateTimePickerType.date, this.displayText = ''}) : super(key: key);

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



class MiscBLMPhoneNumberPickerTemplate extends StatefulWidget{
  final String labelText;
  final TextStyle labelTextStyle;
  final bool obscureText;
  final TextInputType type;
  final int maxLines;
  final bool readOnly;
  final bool includeSuffixIcon;
  final String displayText;

  MiscBLMPhoneNumberPickerTemplate({
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
  
  MiscBLMPhoneNumberPickerTemplateState createState() => MiscBLMPhoneNumberPickerTemplateState(labelText: labelText, labelTextStyle: labelTextStyle, obscureText: obscureText, type: type, maxLines: maxLines, readOnly: readOnly, includeSuffixIcon: includeSuffixIcon, displayText: displayText);
}

class MiscBLMPhoneNumberPickerTemplateState extends State<MiscBLMPhoneNumberPickerTemplate>{
  final String labelText;
  final TextStyle labelTextStyle;
  final bool obscureText;
  final TextInputType type;
  final int maxLines;
  final bool readOnly;
  final bool includeSuffixIcon;
  final String displayText;

  MiscBLMPhoneNumberPickerTemplateState({required this.labelText, required this.labelTextStyle, required this.obscureText, required this.type, required this.maxLines, required this.readOnly, required this.includeSuffixIcon, required this.displayText});

  TextEditingController controller1 = TextEditingController(text: '+1');
  TextEditingController controller2 = TextEditingController(text: '');

  var globalPhoneType = PhoneNumberType.mobile;
  var globalPhoneFormat = PhoneNumberFormat.international;

  String get overrideCountryCode {
    if (controller1.text.isNotEmpty) {
      try {
        return CountryManager().countries.firstWhere((element) => element.phoneCode == controller1.text.replaceAll(RegExp(r'[^\d]+'), '')).countryCode;
      } catch (_) {
        return '';
      }
    } else {
      return '';
    }
  }

  void initState(){
    super.initState();
    controller2 = TextEditingController(text: displayText);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: 50,
          child: TextFormField(
            onTap: (){
            showCountryPicker(
              context: context,
              showPhoneCode: true,
              onSelect: (Country country) {
                setState(() {
                  controller1.text = '+${country.phoneCode}';
                });
              },
            );
            },
            readOnly: true,
            controller: controller1,
            decoration: InputDecoration(
              hintStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey,),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xff000000),
                ),
              ),
            ),
          ),
        ),

        SizedBox(width: 20,),
        
        Expanded(
          child: TextFormField(
            // textAlign: TextAlign.,
            keyboardType: TextInputType.phone,
            controller: controller2,
            cursorColor: Color(0xff000000),
            decoration: InputDecoration(
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xff000000),
                ),
              ),
            ),
            
            inputFormatters: [
              LibPhonenumberTextFormatter(
                phoneNumberType: globalPhoneType,
                phoneNumberFormat: globalPhoneFormat,
                overrideSkipCountryCode: overrideCountryCode,
              ),
            ],
          ),
        ),

      ],
    );
  }
}