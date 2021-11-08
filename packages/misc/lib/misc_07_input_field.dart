part of misc;

class MiscInputFieldSecurityQuestions extends StatefulWidget{
  final String displayText;
  const MiscInputFieldSecurityQuestions({Key? key, this.displayText = 'What\'s the name of your first dog?',}) : super(key: key);

  @override
  MiscInputFieldSecurityQuestionsState createState() => MiscInputFieldSecurityQuestionsState();
}

class MiscInputFieldSecurityQuestionsState extends State<MiscInputFieldSecurityQuestions>{
  List<String> securityQuestions = [
    'What\'s the name of your first dog?',
    'What primary school did you attend?',
    'In what city or town was your first job?',
    'What was your childhood nickname?',
    'What street did you live on in third grade?',
  ];
  String currentSelection = 'What\'s the name of your first dog?';

  @override
  void initState(){
    super.initState();
    currentSelection = widget.displayText;
  }

  @override
  Widget build(BuildContext context){
    return InputDecorator(
      decoration: const InputDecoration(
        alignLabelWithHint: true,
        labelText: 'Security Question',
        labelStyle: TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xffBDC3C7),),
        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xff000000),),),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          style: const TextStyle(fontSize: 18, fontFamily: 'NexaRegular', color: Color(0xff2F353D),),
          value: currentSelection,
          isDense: true,
          onChanged: (String? newValue){
            setState((){
              currentSelection = newValue!;
            });
          },
          items: securityQuestions.map((String value){
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value, overflow: TextOverflow.clip, style: const TextStyle(fontSize: 18, fontFamily: 'NexaRegular', color: Color(0xff2F353D),),),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class MiscInputFieldDateTimeTemplate extends StatefulWidget{
  final String labelText;
  final String displayText;
  const MiscInputFieldDateTimeTemplate({Key? key, this.labelText = '', this.displayText = ''}) : super(key: key);

  @override
  MiscInputFieldDateTimeTemplateState createState() => MiscInputFieldDateTimeTemplateState();
}

class MiscInputFieldDateTimeTemplateState extends State<MiscInputFieldDateTimeTemplate>{
  TextEditingController controller = TextEditingController(text: '');

  @override
  void initState(){
    super.initState();
    controller = TextEditingController(text: widget.displayText);
  }

  @override
  Widget build(BuildContext context){
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        alignLabelWithHint: true,
        labelText: widget.labelText,
        labelStyle: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xffBDC3C7),),
        focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0xff000000),),),
      ),
      cursorColor: const Color(0xff000000),
      keyboardType: TextInputType.text,
      readOnly: true,
      onTap: (){
        DatePicker.showDatePicker(
          context,
          currentTime: DateTime.now(),
          showTitleActions: true,
          minTime: DateTime(1000),
          maxTime: DateTime.now(),
          locale: LocaleType.en,
          onConfirm: (date){
            String format = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
            controller.text = format;
          },
        );
      },
    );
  }
}

class MiscPhoneNumberTemplate extends StatefulWidget{
  final String labelText;
  final TextStyle labelTextStyle;
  final bool obscureText;
  final TextInputType type;
  final int maxLines;
  final bool readOnly;
  final bool includeSuffixIcon;
  final String displayText;
  const MiscPhoneNumberTemplate({
    Key? key,
    this.labelText = '',
    this.labelTextStyle = const TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xff888888),),
    this.obscureText = false,
    this.type = TextInputType.text,
    this.maxLines = 1,
    this.readOnly = false,
    this.includeSuffixIcon = false,
    this.displayText = '',
  }) : super(key: key);

  @override
  MiscPhoneNumberTemplateState createState() => MiscPhoneNumberTemplateState();
}

class MiscPhoneNumberTemplateState extends State<MiscPhoneNumberTemplate>{
  TextEditingController controller = TextEditingController(text: '');
  bool valid = false;

  @override
  void initState(){
    super.initState();
    controller = TextEditingController(text: widget.displayText);
  }

  @override
  Widget build(BuildContext context){
    return InternationalPhoneNumberInput(
      inputDecoration: InputDecoration(alignLabelWithHint: true, labelText: widget.labelText, labelStyle: widget.labelTextStyle, focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0xff000000),),),),
      textStyle: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xff2F353D),),
      selectorConfig: const SelectorConfig(selectorType: PhoneInputSelectorType.BOTTOM_SHEET, showFlags: false,),
      textFieldController: controller,
      errorMessage: '',
      onInputChanged: (PhoneNumber number){
      },
      onInputValidated: (bool value){
        setState((){
          valid = value;
        });
      },
    );
  }
}

class MiscInputFieldDropDown extends StatefulWidget{
  final String displayText;
  const MiscInputFieldDropDown({required Key key, this.displayText = 'Father',}) : super(key: key);

  @override
  MiscInputFieldDropDownState createState() => MiscInputFieldDropDownState();
}

class MiscInputFieldDropDownState extends State<MiscInputFieldDropDown>{
  List<String> relationship = ['Father', 'Mother', 'Sister', 'Brother', 'Son', 'Daughter', 'Aunt', 'Uncle', 'Nephew', 'Grandmother', 'Grandfather'];
  String currentSelection = 'Father';

  @override
  void initState(){
    super.initState();
    currentSelection = widget.displayText;
  }

  @override
  Widget build(BuildContext context){
    return InputDecorator(
      decoration: const InputDecoration(
        alignLabelWithHint: true,
        labelText: 'Relationship',
        labelStyle: TextStyle(fontSize: 22, fontFamily: 'NexaRegular', color: Color(0xff888888),),
        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xff000000),),),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: currentSelection,
          isDense: true,
          onChanged: (String? newValue){
            setState((){
              currentSelection = newValue!;
            });
          },
          items: relationship.map((String value){
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value, style: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xff2F353D),),),
            );
          }).toList(),
        ),
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
  const MiscInputFieldMultiTextTemplate({
    Key? key,
    this.labelText = '',
    this.labelTextStyle = const TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xff888888),),
    this.type = TextInputType.text,
    this.maxLines = 10,
    this.readOnly = false,
    this.backgroundColor = const Color(0xffffffff),
  }) : super(key: key);

  @override
  MiscInputFieldMultiTextTemplateState createState() => MiscInputFieldMultiTextTemplateState();
}

class MiscInputFieldMultiTextTemplateState extends State<MiscInputFieldMultiTextTemplate>{
  TextEditingController controller = TextEditingController(text: '');

  @override
  Widget build(BuildContext context){
    return TextFormField(
      controller: controller,
      maxLines: widget.maxLines,
      keyboardType: widget.type,
      readOnly: widget.readOnly,
      cursorColor: const Color(0xff000000),
      style: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xff2F353D),),
      decoration: InputDecoration(
        filled: true,
        alignLabelWithHint: true,
        labelText: widget.labelText,
        fillColor: widget.backgroundColor,
        labelStyle: widget.labelTextStyle,
        border: const OutlineInputBorder(borderSide: BorderSide(color: Color(0xff000000),), borderRadius: BorderRadius.all(Radius.circular(10)),),
        focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color(0xff000000),), borderRadius: BorderRadius.all(Radius.circular(10)),),
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
  final String displayText;
  final bool edited;
  const MiscInputFieldTemplate({
    Key? key,
    this.labelText = '',
    // this.labelTextStyle = const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Color(0xff888888),),
    this.labelTextStyle = const TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xff888888),),
    this.obscureText = false,
    this.type = TextInputType.text,
    this.maxLines = 1,
    this.readOnly = false,
    this.includeSuffixIcon = false,
    this.displayText = '',
    this.edited = false,
  }) : super(key: key);

  @override
  MiscInputFieldTemplateState createState() => MiscInputFieldTemplateState();
}

class MiscInputFieldTemplateState extends State<MiscInputFieldTemplate>{
  TextEditingController controller = TextEditingController(text: '');
  
  @override
  void initState(){
    super.initState();
    controller = TextEditingController(text: widget.displayText);
  }

  @override
  Widget build(BuildContext context){
    return TextFormField(
      controller: controller,
      keyboardType: widget.type,
      maxLines: widget.maxLines,
      readOnly: widget.readOnly,
      obscureText: widget.obscureText,
      cursorColor: const Color(0xff000000),
      style: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xff2F353D),),
      validator: (value){
        if(value!.isEmpty){
          return '';
        }
      },
      decoration: InputDecoration(
        alignLabelWithHint: true, 
        labelText: widget.labelText, 
        labelStyle: widget.labelTextStyle, 
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xff000000),),
        ),
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red,),
        ),
      ),
    );
  }
}