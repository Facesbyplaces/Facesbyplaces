// import 'package:date_time_picker/date_time_picker.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-01-blm-input-field.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-08-blm-background.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-07-blm-button.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class BLMCreateMemorialValues{
  String blmName;
  String description;
  String location;
  String dob;
  String rip;
  String state;
  String country;
  String precinct;
  String relationship;
  List<File> imagesOrVideos;
  double longitude;
  double latitude;

  BLMCreateMemorialValues({
    this.blmName, 
    this.description, 
    this.location, 
    this.dob, 
    this.rip, 
    this.state, 
    this.country, 
    this.precinct, 
    this.relationship, 
    this.imagesOrVideos, 
    this.latitude, 
    this.longitude,
  });
}


class HomeBLMCreateMemorial1 extends StatefulWidget{

  HomeBLMCreateMemorial1State createState() => HomeBLMCreateMemorial1State();
}

class HomeBLMCreateMemorial1State extends State<HomeBLMCreateMemorial1>{

  final GlobalKey<MiscBLMInputFieldDropDownState> _key1 = GlobalKey<MiscBLMInputFieldDropDownState>();
  final GlobalKey<MiscBLMInputFieldTemplateState> _key2 = GlobalKey<MiscBLMInputFieldTemplateState>();
  final GlobalKey<MiscBLMInputFieldTemplateState> _key3 = GlobalKey<MiscBLMInputFieldTemplateState>();
  final GlobalKey<MiscBLMInputFieldDateTimeTemplateState> _key4 = GlobalKey<MiscBLMInputFieldDateTimeTemplateState>();
  final GlobalKey<MiscBLMInputFieldDateTimeTemplateState> _key5 = GlobalKey<MiscBLMInputFieldDateTimeTemplateState>();
  final GlobalKey<MiscBLMInputFieldTemplateState> _key6 = GlobalKey<MiscBLMInputFieldTemplateState>();
  final GlobalKey<MiscBLMInputFieldTemplateState> _key7 = GlobalKey<MiscBLMInputFieldTemplateState>();

  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();

  DateTime dobLastDate = DateTime.now();
  DateTime ripLastDate = DateTime.now();
  DateTime dobDate;
  DateTime ripDate;

  // bool decideWhichDayToEnable(DateTime time) {
  //   // if ((day.isAfter(DateTime.now().subtract(Duration(days: 1))) &&
  //   //     day.isBefore(DateTime.now().add(Duration(days: 10))))) {
  //   //   return true;
  //   // }
  //   // return false;

  //   if(controller1.text != null && controller2.text != null){
  //     DateTime newDate1 = DateTime.parse(controller1.text);
  //     DateTime newDate2 = DateTime.parse(controller2.text);
      

  //     print('The newDate is ${newDate1.toString()}');
  //     print('The newDate is ${newDate2.toString()}');

  //     print('The difference is ${newDate1.difference(newDate2).inDays}');
  //   }else{
  //     print('Error!');
  //   }

  //   return true;
    
  // }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return WillPopScope(
      onWillPop: () async{
        return Navigator.canPop(context);
      },
      child: GestureDetector(
        onTap: (){
          FocusNode currentFocus = FocusScope.of(context);
          if(!currentFocus.hasPrimaryFocus){
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text('Cry out for the Victims', maxLines: 2, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xffffffff))),
            centerTitle: true,
            backgroundColor: Color(0xff04ECFF),
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Color(0xffffffff),), 
              onPressed: (){
                Navigator.pop(context);
              },
            ),
          ),
          body: Stack(
            children: [

              SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                child: Container(height: SizeConfig.screenHeight, child: MiscBLMBackgroundTemplate(image: AssetImage('assets/icons/background2.png'),),),
              ),

              Container(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                child: ListView(
                  physics: ClampingScrollPhysics(),
                  children: [
                    MiscBLMInputFieldDropDown(key: _key1,),

                    SizedBox(height: 20,),

                    MiscBLMInputFieldTemplate(key: _key2, labelText: 'Location of the incident'),

                    SizedBox(height: 20,),

                    MiscBLMInputFieldTemplate(key: _key3, labelText: 'Precinct / Station House (Optional)'),

                    SizedBox(height: 20,),

                    MiscBLMInputFieldDateTimeTemplate(key: _key4, labelText: 'DOB'),

                    // DateTimePicker(
                    //   type: DateTimePickerType.date,
                    //   controller: controller1,
                    //   cursorColor: Color(0xff000000),
                    //   firstDate: DateTime(1000),
                    //   // lastDate: DateTime.now(),
                    //   lastDate: dobLastDate,
                    //   // onChanged: (String date){
                    //   //   // print('The date is $date');
                    //   //   // print('The controller1 in first text is ${controller1.text}');
                    //   //   // print('The controller2 in first text is ${controller2.text}');

                    //   //   print('hehe');

                    //   //   if(controller2.text != null){
                    //   //     DateTime newDate1 = DateTime.parse(controller1.text);
                    //   //     DateTime newDate2 = DateTime.parse(controller2.text);
                          

                    //   //     print('The newDate is ${newDate1.toString()}');
                    //   //     print('The newDate is ${newDate2.toString()}');

                    //   //     // if(newDate1. > newDate2){

                    //   //     // }

                    //   //     print('The difference is ${newDate1.difference(newDate2).inDays}');

                    //   //   }
                    //   // },
                    //   // selectableDayPredicate: (date) {
                    //   //   // Disable weekend days to select from the calendar
                    //   //   // if (date.weekday == 6 || date.weekday == 7) {
                    //   //   //   return false;
                    //   //   // }

                    //   //   // return true;
                    //   //   // if()
                    //   // },
                    //   // selectableDayPredicate: decideWhichDayToEnable,
                    //   // selectableDayPredicate: (date) {
                    //   //   // Disable weekend days to select from the calendar
                    //   //   // if (date.weekday == 6 || date.weekday == 7) {
                    //   //   //   return false;
                    //   //   // }

                    //   //   // return true;
                    //   //   if(dobDate != null){
                    //   //     // print('Null!');
                    //   //     // DateTime.now().subtract(Duration(days: 0)),
                    //   //     dobDate.subtract(Duration(days: 0));
                    //   //   }

                    //   //   return true;
                    //   // },
                    //   decoration: InputDecoration(
                    //     alignLabelWithHint: true,
                    //     labelText: 'DOB',
                    //     labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey,),
                    //     focusedBorder: UnderlineInputBorder(
                    //       borderSide: BorderSide(
                    //         color: Color(0xff000000),
                    //       ),
                    //     ),
                    //   ),
                    // ),

                    SizedBox(height: 20,),

                    MiscBLMInputFieldDateTimeTemplate(key: _key5, labelText: 'RIP'),

                    // DateTimePicker(
                    //   type: DateTimePickerType.date,
                    //   controller: controller2,
                    //   cursorColor: Color(0xff000000),
                    //   firstDate: DateTime(1000),
                    //   // lastDate: DateTime.now(),
                    //   lastDate: ripLastDate,
                    //   onChanged: (String date){
                    //     // print('The date is $date');
                    //     print('The controller1 in second text is ${controller1.text}');
                    //     print('The controller2 in second text is ${controller2.text}');
                    //   },
                    //   // selectableDayPredicate: (date) {
                    //   //   // Disable weekend days to select from the calendar
                    //   //   // if (date.weekday == 6 || date.weekday == 7) {
                    //   //   //   return false;
                    //   //   // }

                    //   //   // return true;
                    //   // },
                    //   decoration: InputDecoration(
                    //     alignLabelWithHint: true,
                    //     labelText: 'RIP',
                    //     labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey,),
                    //     focusedBorder: UnderlineInputBorder(
                    //       borderSide: BorderSide(
                    //         color: Color(0xff000000),
                    //       ),
                    //     ),
                    //   ),
                    // ),

                    SizedBox(height: 20,),

                    MiscBLMInputFieldTemplate(key: _key6, labelText: 'Country'),

                    SizedBox(height: 20,),

                    MiscBLMInputFieldTemplate(key: _key7, labelText: 'State'),

                    SizedBox(height: 40,),

                    MiscBLMButtonTemplate(
                      onPressed: () async{

                        if(_key2.currentState.controller.text == '' || _key4.currentState.controller.text == '' || _key5.currentState.controller.text == '' || _key6.currentState.controller.text == '' || _key7.currentState.controller.text == ''){
                          await showDialog(
                            context: context,
                            builder: (_) => 
                              AssetGiffyDialog(
                              image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                              title: Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                              entryAnimation: EntryAnimation.DEFAULT,
                              description: Text('Please complete the form before submitting.',
                                textAlign: TextAlign.center,
                                style: TextStyle(),
                              ),
                              onlyOkButton: true,
                              buttonOkColor: Colors.red,
                              onOkButtonPressed: () {
                                Navigator.pop(context, true);
                              },
                            )
                          );
                        }else{
                          Navigator.pushNamed(
                            context, '/home/blm/create-memorial-2',
                            arguments: BLMCreateMemorialValues(
                              relationship: _key1.currentState.currentSelection,
                              location: _key2.currentState.controller.text,
                              precinct: _key3.currentState.controller.text,
                              dob: _key4.currentState.controller.text,
                              rip: _key5.currentState.controller.text,
                              country: _key6.currentState.controller.text,
                              state: _key7.currentState.controller.text,
                            ),
                          );
                        }

                      }, 
                      width: SizeConfig.screenWidth / 2,
                      height: 45,
                    ),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
