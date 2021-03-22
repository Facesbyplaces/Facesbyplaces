import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-01-regular-input-field.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-06-regular-button.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-07-regular-background.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'home-create-memorial-regular-02-create-memorial.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class RegularCreateMemorialValues{
  String memorialName;
  String description;
  String birthplace;
  String dob;
  String rip;
  String cemetery;
  String country;
  String relationship;
  List<File> imagesOrVideos;
  double longitude;
  double latitude;

  RegularCreateMemorialValues({
    required this.memorialName, 
    required this.description, 
    required this.birthplace, 
    required this.dob, 
    required this.rip, 
    required this.cemetery, 
    required this.country,  
    required this.relationship, 
    required this.imagesOrVideos, 
    required this.latitude, 
    required this.longitude,
  });
}

class HomeRegularCreateMemorial1 extends StatefulWidget{

  HomeRegularCreateMemorial1State createState() => HomeRegularCreateMemorial1State();
}

class HomeRegularCreateMemorial1State extends State<HomeRegularCreateMemorial1>{

  GlobalKey<MiscRegularInputFieldDropDownState> _key1 = GlobalKey<MiscRegularInputFieldDropDownState>();
  GlobalKey<MiscRegularInputFieldTemplateState> _key2 = GlobalKey<MiscRegularInputFieldTemplateState>();
  GlobalKey<MiscRegularInputFieldTemplateState> _key5 = GlobalKey<MiscRegularInputFieldTemplateState>();
  GlobalKey<MiscRegularInputFieldTemplateState> _key6 = GlobalKey<MiscRegularInputFieldTemplateState>();

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
            title: Text('Create a Memorial Page for Friends and family.', maxLines: 2, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xffffffff))),
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
                child: Container(height: SizeConfig.screenHeight, child: MiscRegularBackgroundTemplate(image: AssetImage('assets/icons/background2.png'),),),
              ),

              Container(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                child: ListView(
                  physics: ClampingScrollPhysics(),
                  children: [
                    MiscRegularInputFieldDropDown(key: _key1,),

                    SizedBox(height: 20,),

                    MiscRegularInputFieldTemplate(key: _key2, labelText: 'Birthplace'),

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

                    MiscRegularInputFieldTemplate(key: _key5, labelText: 'Cemetery'),

                    SizedBox(height: 20,),

                    MiscRegularInputFieldTemplate(key: _key6, labelText: 'Country'),

                    SizedBox(height: 40,),

                    MiscRegularButtonTemplate(
                      onPressed: () async{

                        if(_key2.currentState!.controller.text == '' || controller1.text == '' || controller2.text == '' ||  _key5.currentState!.controller.text == '' || _key6.currentState!.controller.text == ''){
                          await showOkAlertDialog(
                            context: context,
                            title: 'Error',
                            message: 'Please complete the form before submitting.',
                          );
                        }else{
                          Navigator.push(context, MaterialPageRoute(builder: (context) => 
                              HomeRegularCreateMemorial2(
                                relationship: _key1.currentState!.currentSelection,
                                birthplace: _key2.currentState!.controller.text,
                                dob: controller1.text,
                                rip: controller2.text,
                                cemetery: _key5.currentState!.controller.text,
                                country: _key6.currentState!.controller.text,
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
