import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-01-blm-input-field.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-07-blm-background.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-06-blm-button.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'home-create-memorial-blm-02-create-memorial.dart';
import 'package:date_time_picker/date_time_picker.dart';
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
    required this.blmName, 
    required this.description, 
    required this.location, 
    required this.dob, 
    required this.rip, 
    required this.state, 
    required this.country, 
    required this.precinct, 
    required this.relationship, 
    required this.imagesOrVideos, 
    required this.latitude, 
    required this.longitude,
  });
}


class HomeBLMCreateMemorial1 extends StatefulWidget{

  HomeBLMCreateMemorial1State createState() => HomeBLMCreateMemorial1State();
}

class HomeBLMCreateMemorial1State extends State<HomeBLMCreateMemorial1>{

  final GlobalKey<MiscBLMInputFieldDropDownState> _key1 = GlobalKey<MiscBLMInputFieldDropDownState>();
  final GlobalKey<MiscBLMInputFieldTemplateState> _key2 = GlobalKey<MiscBLMInputFieldTemplateState>();
  final GlobalKey<MiscBLMInputFieldTemplateState> _key3 = GlobalKey<MiscBLMInputFieldTemplateState>();
  final GlobalKey<MiscBLMInputFieldTemplateState> _key6 = GlobalKey<MiscBLMInputFieldTemplateState>();
  final GlobalKey<MiscBLMInputFieldTemplateState> _key7 = GlobalKey<MiscBLMInputFieldTemplateState>();

  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();

  DateTime dob = DateTime.now();
  DateTime rip = DateTime.now();

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

                    DateTimePicker(
                      type: DateTimePickerType.date,
                      controller: controller1,
                      cursorColor: Color(0xff000000),
                      firstDate: DateTime(1000),
                      lastDate: DateTime.now(),
                      decoration: InputDecoration(
                        alignLabelWithHint: true,
                        labelText: 'DOB',
                        labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey,),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xff000000),
                          ),
                        ),
                      ),
                      selectableDayPredicate: (date) {
                        if(date.isBefore(rip)  || date.isAtSameMomentAs(rip)){
                          return true;
                        }else{
                          return false;
                        }
                      },
                      onChanged: (changed){
                        setState(() {
                          dob = DateTime.parse(changed);
                        });
                      },
                    ),

                    SizedBox(height: 20,),

                    DateTimePicker(
                      type: DateTimePickerType.date,
                      controller: controller2,
                      cursorColor: Color(0xff000000),
                      firstDate: DateTime(1000),
                      lastDate: DateTime.now(),
                      decoration: InputDecoration(
                        alignLabelWithHint: true,
                        labelText: 'RIP',
                        labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey,),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xff000000),
                          ),
                        ),
                      ),
                      selectableDayPredicate: (date) {
                        if(date.isAfter(dob) || date.isAtSameMomentAs(dob)){
                          return true;
                        }else{
                          return false;
                        }
                      },
                      onChanged: (changed){
                        setState(() {
                          rip = DateTime.parse(changed);
                        });
                      },
                    ),

                    SizedBox(height: 20,),

                    MiscBLMInputFieldTemplate(key: _key6, labelText: 'Country'),

                    SizedBox(height: 20,),

                    MiscBLMInputFieldTemplate(key: _key7, labelText: 'State'),

                    SizedBox(height: 40,),

                    MiscBLMButtonTemplate(
                      onPressed: () async{

                        if(_key2.currentState!.controller.text == '' || _key3.currentState!.controller.text == '' || controller1.text == '' || controller2.text == '' || _key6.currentState!.controller.text == '' || _key7.currentState!.controller.text == ''){
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
                          Navigator.push(
                            context, MaterialPageRoute(builder: (context) => 
                              HomeBLMCreateMemorial2(
                                relationship: _key1.currentState!.currentSelection,
                                locationOfIncident: _key2.currentState!.controller.text,
                                precinct: _key3.currentState!.controller.text,
                                dob: controller1.text,
                                rip: controller2.text,
                                country: _key6.currentState!.controller.text,
                                state: _key7.currentState!.controller.text,
                              ),
                            )
                          );
                        }

                      }, 
                      width: SizeConfig.screenWidth! / 2,
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
