import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-01-regular-input-field.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-06-regular-button.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-07-regular-background.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'home-create-memorial-regular-02-create-memorial.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class RegularCreateMemorialValues{
  final String memorialName;
  final String description;
  final String birthplace;
  final String dob;
  final String rip;
  final String cemetery;
  final String country;
  final String relationship;
  final List<File> imagesOrVideos;
  final double longitude;
  final double latitude;

  const RegularCreateMemorialValues({
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
            title: const Text('Create a Memorial Page for Friends and family.', maxLines: 2, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xffffffff))),
            centerTitle: true,
            backgroundColor: const Color(0xff04ECFF),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: const Color(0xffffffff),), 
              onPressed: (){
                Navigator.pop(context);
              },
            ),
          ),
          body: Stack(
            children: [

              SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Container(height: SizeConfig.screenHeight, child: const MiscRegularBackgroundTemplate(image: const AssetImage('assets/icons/background2.png'),),),
              ),

              Container(
                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                child: ListView(
                  physics: const ClampingScrollPhysics(),
                  children: [
                    MiscRegularInputFieldDropDown(key: _key1,),

                    const SizedBox(height: 20,),

                    MiscRegularInputFieldTemplate(key: _key2, labelText: 'Birthplace'),

                    const SizedBox(height: 20,),

                    DateTimePicker(
                      type: DateTimePickerType.date,
                      controller: controller1,
                      cursorColor: const Color(0xff000000),
                      firstDate: DateTime(1000),
                      lastDate: DateTime.now(),
                      decoration: const InputDecoration(
                        alignLabelWithHint: true,
                        labelText: 'DOB',
                        labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: const Color(0xff888888),),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: const BorderSide(
                            color: const Color(0xff000000),
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

                    const SizedBox(height: 20,),

                    DateTimePicker(
                      type: DateTimePickerType.date,
                      controller: controller2,
                      cursorColor: const Color(0xff000000),
                      firstDate: DateTime(1000),
                      lastDate: DateTime.now(),
                      decoration: const InputDecoration(
                        alignLabelWithHint: true,
                        labelText: 'RIP',
                        labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: const Color(0xff888888),),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: const BorderSide(
                            color: const Color(0xff000000),
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

                    const SizedBox(height: 20,),

                    MiscRegularInputFieldTemplate(key: _key5, labelText: 'Cemetery'),

                    const SizedBox(height: 20,),

                    MiscRegularInputFieldTemplate(key: _key6, labelText: 'Country'),

                    const SizedBox(height: 40,),

                    MiscRegularButtonTemplate(
                      onPressed: () async{
                        if(_key2.currentState!.controller.text == '' || controller1.text == '' || controller2.text == '' ||  _key5.currentState!.controller.text == '' || _key6.currentState!.controller.text == ''){
                          await showDialog(
                            context: context,
                            builder: (_) => 
                              AssetGiffyDialog(
                              image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                              title: const Text('Error', textAlign: TextAlign.center, style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                              entryAnimation: EntryAnimation.DEFAULT,
                              description: const Text('Please complete the form before submitting.',
                                textAlign: TextAlign.center,
                              ),
                              onlyOkButton: true,
                              buttonOkColor: const Color(0xffff0000),
                              onOkButtonPressed: () {
                                Navigator.pop(context, true);
                              },
                            )
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