import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
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

  MiscRegularInputFieldTemplate({
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
  
  MiscRegularInputFieldTemplateState createState() => MiscRegularInputFieldTemplateState(labelText: labelText, labelTextStyle: labelTextStyle, obscureText: obscureText, type: type, maxLines: maxLines, readOnly: readOnly, includeSuffixIcon: includeSuffixIcon, displayText: displayText);
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

  MiscRegularInputFieldTemplateState({this.labelText, this.labelTextStyle, this.obscureText, this.type, this.maxLines, this.readOnly, this.includeSuffixIcon, this.displayText});

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

  MiscRegularPhoneNumberTemplate({
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

  MiscRegularPhoneNumberTemplateState({this.labelText, this.labelTextStyle, this.obscureText, this.type, this.maxLines, this.readOnly, this.includeSuffixIcon, this.displayText});

  TextEditingController controller;
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

class MiscRegularInputFieldMultiTextPostTemplate extends StatefulWidget{
  final String labelText;
  final TextStyle labelTextStyle;
  final TextInputType type;
  final int maxLines;
  final bool readOnly;
  final Color backgroundColor;

  MiscRegularInputFieldMultiTextPostTemplate({
    Key key,
    this.labelText = '',
    this.labelTextStyle = const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey,),
    this.type = TextInputType.text, 
    this.maxLines = 10,
    this.readOnly = false,
    this.backgroundColor = const Color(0xffffffff),
  }) : super(key: key);
  

  MiscRegularInputFieldMultiTextPostTemplateState createState() => MiscRegularInputFieldMultiTextPostTemplateState(labelText: labelText, labelTextStyle: labelTextStyle, type: type, maxLines: maxLines, readOnly: readOnly, backgroundColor: backgroundColor);
}


class MiscRegularInputFieldMultiTextPostTemplateState extends State<MiscRegularInputFieldMultiTextPostTemplate>{
  final String labelText;
  final TextStyle labelTextStyle;
  final TextInputType type;
  final int maxLines;
  final bool readOnly;
  final Color backgroundColor;

  MiscRegularInputFieldMultiTextPostTemplateState({this.labelText, this.labelTextStyle, this.type, this.maxLines, this.readOnly, this.backgroundColor});

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
            color: Colors.transparent,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.transparent,
          ),
        ),
      ),
    );
  }
}


class MiscRegularInputFieldDropDown extends StatefulWidget{

  final String displayText;

  MiscRegularInputFieldDropDown({
    Key key,
    this.displayText = 'Father',
  }) : super(key: key);

  @override
  MiscRegularInputFieldDropDownState createState() => MiscRegularInputFieldDropDownState(displayText: displayText);
}

class MiscRegularInputFieldDropDownState extends State<MiscRegularInputFieldDropDown>{

  final String displayText;

  MiscRegularInputFieldDropDownState({this.displayText});

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

class MiscRegularInputFieldSecurityQuestions extends StatefulWidget{

  final String displayText;

  MiscRegularInputFieldSecurityQuestions({
    Key key,
    this.displayText = 'What\'s the name of your first dog?',
  }) : super(key: key);

  @override
  MiscRegularInputFieldSecurityQuestionsState createState() => MiscRegularInputFieldSecurityQuestionsState(displayText: displayText);
}

class MiscRegularInputFieldSecurityQuestionsState extends State<MiscRegularInputFieldSecurityQuestions>{

  final String displayText;

  MiscRegularInputFieldSecurityQuestionsState({this.displayText});

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
          onChanged: (String newValue) {
            setState(() {
              currentSelection = newValue;
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

class RegularRelationshipItem{

  final String name;
  final String image;
  
  const RegularRelationshipItem({this.name, this.image});
}


class MiscRegularInputFieldDropDownUser extends StatefulWidget{

  MiscRegularInputFieldDropDownUser({Key key}) : super(key: key);

  @override
  MiscRegularInputFieldDropDownUserState createState() => MiscRegularInputFieldDropDownUserState();
}

class MiscRegularInputFieldDropDownUserState extends State<MiscRegularInputFieldDropDownUser>{

  List<RegularRelationshipItem> relationship = [
    const RegularRelationshipItem(name: 'Richard Nedd Memories', image: 'assets/icons/profile2.png'),
    const RegularRelationshipItem(name: 'New Memorial', image: 'assets/icons/profile2.png'),
  ];

  RegularRelationshipItem currentSelection = const RegularRelationshipItem(name: 'New Memorial', image: 'assets/icons/profile2.png');

  @override
  Widget build(BuildContext context){
    return InputDecorator(
      decoration: InputDecoration(
        alignLabelWithHint: true,
        labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide.none,
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide.none,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<RegularRelationshipItem>(
          value: currentSelection,
          isDense: true,
          onChanged: (RegularRelationshipItem newValue) {
            setState(() {
              currentSelection = newValue;
            });
          },
          items: relationship.map((RegularRelationshipItem value) {
            return DropdownMenuItem<RegularRelationshipItem>(
              value: value,
              child: Row(
                children: [
                  CircleAvatar(backgroundImage: AssetImage(value.image),),

                  SizedBox(width: SizeConfig.blockSizeHorizontal * 2,),

                  Text(value.name),
                ],
              ),
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

  MiscRegularInputFieldDateTimeTemplate({Key key, this.labelText = '', this.dateTimePickerType = DateTimePickerType.date, this.displayText = ''}) : super(key: key);

  MiscRegularInputFieldDateTimeTemplateState createState() => MiscRegularInputFieldDateTimeTemplateState(labelText: labelText, dateTimePickerType: dateTimePickerType, displayText: displayText);
}


class MiscRegularInputFieldDateTimeTemplateState extends State<MiscRegularInputFieldDateTimeTemplate>{
    final String labelText;
    final DateTimePickerType dateTimePickerType;
    final String displayText;

    MiscRegularInputFieldDateTimeTemplateState({this.labelText, this.dateTimePickerType, this.displayText});

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