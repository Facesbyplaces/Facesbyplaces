import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-01-regular-input-field.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-06-regular-button.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-07-regular-background.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'home-create-memorial-regular-02-create-memorial.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'home-create-memorial-regular-04-locate-map.dart';
// ignore: import_of_legacy_library_into_null_safe
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
  const RegularCreateMemorialValues({required this.memorialName, required this.description, required this.birthplace, required this.dob, required this.rip, required this.cemetery, required this.country, required this.relationship, required this.imagesOrVideos, required this.latitude, required this.longitude,});
}

class HomeRegularCreateMemorial1 extends StatefulWidget{

  HomeRegularCreateMemorial1State createState() => HomeRegularCreateMemorial1State();
}

class HomeRegularCreateMemorial1State extends State<HomeRegularCreateMemorial1>{
  GlobalKey<MiscRegularInputFieldDropDownState> _key1 = GlobalKey<MiscRegularInputFieldDropDownState>();
  GlobalKey<MiscRegularInputFieldTemplateState> _key2 = GlobalKey<MiscRegularInputFieldTemplateState>();
  // GlobalKey<MiscRegularInputFieldTemplateState> _key5 = GlobalKey<MiscRegularInputFieldTemplateState>();
  GlobalKey<MiscRegularInputFieldTemplateState> _key6 = GlobalKey<MiscRegularInputFieldTemplateState>();
  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  TextEditingController controller3 = TextEditingController();
  TextEditingController controller4 = TextEditingController();
  ValueNotifier<GeoPoint?> location = ValueNotifier(null);
  DateTime dob = DateTime(1000);
  DateTime rip = DateTime.now();

  @override
  Widget build(BuildContext context){
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
        child: ValueListenableBuilder(
          valueListenable: location,
          builder: (_, GeoPoint? locationListener, __) => Scaffold(
            appBar: AppBar(
              title: Text('Create a Memorial Page for Friends and family.', maxLines: 2, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 3.16, fontFamily: 'NexaRegular', color: const Color(0xffffffff),),),
              centerTitle: true,
              backgroundColor: const Color(0xff04ECFF),
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Color(0xffffffff), size: SizeConfig.blockSizeVertical! * 3.52,),
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
                      
                      MiscRegularInputFieldTemplate(
                        key: _key2, 
                        labelText: 'Birthplace',
                        labelTextStyle: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.11, fontFamily: 'NexaRegular', color: const Color(0xff000000),),
                      ),

                      const SizedBox(height: 20,),

                      TextFormField(
                        controller: controller1,
                        cursorColor: const Color(0xff000000),
                        keyboardType: TextInputType.text,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelStyle: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.11, fontFamily: 'NexaRegular', color: const Color(0xff000000),),
                          focusedBorder: const UnderlineInputBorder(borderSide: const BorderSide(color: const Color(0xff000000),),),
                          alignLabelWithHint: true,
                          labelText: 'DOB',
                          suffixIcon: IconButton(
                            icon: Icon(Icons.close), 
                            onPressed: (){
                              controller1.text = '';
                              dob = DateTime(1000);
                            },
                          ),
                        ),
                        onTap: () {
                          DatePicker.showDatePicker(
                            context,
                            currentTime: DateTime.now(),
                            showTitleActions: true,
                            locale: LocaleType.en,
                            minTime: dob,
                            maxTime: rip,
                            onConfirm: (date){
                              String format = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
                              dob = date;
                              controller1.text = format;
                            },
                          );
                        },
                      ),

                      const SizedBox(height: 20,),

                      TextFormField(
                        controller: controller2,
                        cursorColor: const Color(0xff000000),
                        keyboardType: TextInputType.text,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelStyle: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.11, fontFamily: 'NexaRegular', color: const Color(0xff000000),),
                          focusedBorder: const UnderlineInputBorder(borderSide: const BorderSide(color: const Color(0xff000000),),),
                          alignLabelWithHint: true,
                          labelText: 'RIP',
                          suffixIcon: IconButton(
                            icon: Icon(Icons.close), 
                            onPressed: (){
                              controller2.text = '';
                              rip = DateTime.now();
                            },
                          ),
                        ),
                        onTap: (){
                          DatePicker.showDatePicker(
                            context,
                            showTitleActions: true,
                            minTime: dob,
                            maxTime: DateTime.now(),
                            currentTime: DateTime.now(),
                            locale: LocaleType.en,
                            onConfirm: (date){
                              String format = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
                              rip = date;
                              controller2.text = format;
                            },
                          );
                        },
                      ),

                      const SizedBox(height: 20,),

                      // MiscRegularInputFieldTemplate(
                      //   key: _key5, 
                      //   labelText: 'Cemetery',
                      //   labelTextStyle: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.11, fontFamily: 'NexaRegular', color: const Color(0xff000000),),
                      // ),

                      TextFormField(
                        controller: controller4,
                        keyboardType: TextInputType.text,
                        maxLines: 1,
                        cursorColor: const Color(0xff000000),
                        style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.64, fontFamily: 'NexaRegular', color: const Color(0xff2F353D),),
                        decoration: InputDecoration(
                          alignLabelWithHint: true, 
                          labelText: 'Cemetery', 
                          labelStyle: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.11, fontFamily: 'NexaRegular', color: const Color(0xff000000),),
                          focusedBorder: const UnderlineInputBorder(borderSide: const BorderSide(color: const Color(0xff000000),),),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.add_location), 
                            onPressed: () async{

                              var p = await Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularCreateMemorialLocateMap()));

                              if(p != null){
                                location.value = p as GeoPoint;

                              print('The location latitude is ${location.value!.latitude}');
                              print('The location longitude is ${location.value!.latitude}');
                              }

                            },
                          ),
                        ),
                      ),
                      
                      
                      const SizedBox(height: 20,),

                      MiscRegularInputFieldTemplate(
                        key: _key6, 
                        labelText: 'Country',
                        labelTextStyle: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.11, fontFamily: 'NexaRegular', color: const Color(0xff000000),),
                      ),

                      const SizedBox(height: 40,),

                      MiscRegularButtonTemplate(
                        buttonTextStyle: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.74, color: const Color(0xffffffff), fontFamily: 'NexaBold',),
                        width: SizeConfig.screenWidth! / 2,
                        height: 45,
                        onPressed: () async{
                          if(_key2.currentState!.controller.text == '' || controller1.text == '' || controller2.text == '' || controller4.text == '' || _key6.currentState!.controller.text == ''){
                          // if(_key2.currentState!.controller.text == '' || controller1.text == '' || controller2.text == '' || _key5.currentState!.controller.text == '' || _key6.currentState!.controller.text == ''){
                            await showDialog(
                              context: context,
                              builder: (_) => AssetGiffyDialog(
                                description: Text('Please complete the form before submitting.', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.87, fontFamily: 'NexaRegular'),),
                                title: Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 3.16, fontFamily: 'NexaRegular'),),
                                image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                entryAnimation: EntryAnimation.DEFAULT,
                                buttonOkColor: const Color(0xffff0000),
                                onlyOkButton: true,
                                onOkButtonPressed: (){
                                  Navigator.pop(context, true);
                                },
                              ),
                            );
                          }else if(locationListener == null){
                            await showDialog(
                              context: context,
                              builder: (_) => AssetGiffyDialog(
                                description: Text('Pin the location of the cemetery first before proceeding.', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.87, fontFamily: 'NexaRegular'),),
                                title: Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 3.16, fontFamily: 'NexaRegular'),),
                                image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                entryAnimation: EntryAnimation.DEFAULT,
                                buttonOkColor: const Color(0xffff0000),
                                onlyOkButton: true,
                                onOkButtonPressed: (){
                                  Navigator.pop(context, true);
                                },
                              ),
                            );
                          }else{
                            // Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularCreateMemorial2(relationship: _key1.currentState!.currentSelection, birthplace: _key2.currentState!.controller.text, dob: controller1.text, rip: controller2.text, cemetery: _key5.currentState!.controller.text, country: _key6.currentState!.controller.text,),),);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularCreateMemorial2(relationship: _key1.currentState!.currentSelection, birthplace: _key2.currentState!.controller.text, dob: controller1.text, rip: controller2.text, cemetery: controller4.text, country: _key6.currentState!.controller.text, latitude: '${location.value!.latitude}', longitude: '${location.value!.longitude}',),),);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}