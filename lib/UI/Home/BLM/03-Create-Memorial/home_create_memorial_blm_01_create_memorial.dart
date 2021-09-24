import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc_01_blm_input_field.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc_04_blm_background.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'home_create_memorial_blm_02_create_memorial.dart';
import 'home_create_memorial_blm_04_locate_map.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:flutter/material.dart';
import 'package:misc/misc.dart';
import 'dart:io';

class BLMCreateMemorialValues{
  final String blmName;
  final String description;
  final String location;
  final String dob;
  final String rip;
  final String state;
  final String country;
  final String precinct;
  final String relationship;
  final List<File> imagesOrVideos;
  final double longitude;
  final double latitude;
  const BLMCreateMemorialValues({required this.blmName, required this.description, required this.location, required this.dob, required this.rip, required this.state, required this.country, required this.precinct, required this.relationship, required this.imagesOrVideos, required this.latitude, required this.longitude,});
}

class HomeBLMCreateMemorial1 extends StatefulWidget{
  const HomeBLMCreateMemorial1({Key? key}) : super(key: key);

  @override
  HomeBLMCreateMemorial1State createState() => HomeBLMCreateMemorial1State();
}

class HomeBLMCreateMemorial1State extends State<HomeBLMCreateMemorial1>{
  final GlobalKey<MiscBLMInputFieldDropDownState> _key1 = GlobalKey<MiscBLMInputFieldDropDownState>();
  final GlobalKey<MiscBLMInputFieldTemplateState> _key3 = GlobalKey<MiscBLMInputFieldTemplateState>();
  final GlobalKey<MiscBLMInputFieldTemplateState> _key6 = GlobalKey<MiscBLMInputFieldTemplateState>();
  final GlobalKey<MiscBLMInputFieldTemplateState> _key7 = GlobalKey<MiscBLMInputFieldTemplateState>();
  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  TextEditingController controller3 = TextEditingController();
  ValueNotifier<LatLng?> location = ValueNotifier(null);
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
          builder: (_, LatLng? locationListener, __) => Scaffold(
            appBar: AppBar(
              title: const Text('Cry out for the Victims', maxLines: 2, style: TextStyle(fontSize: 26, fontFamily: 'NexaRegular', color: Color(0xffffffff),),),
              backgroundColor: const Color(0xff04ECFF),
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Color(0xffffffff), size: 35,),
                onPressed: (){
                  Navigator.pop(context);
                },
              ),
            ),
            body: Stack(
              children: [
                SingleChildScrollView(physics: const NeverScrollableScrollPhysics(), child: SizedBox(height: SizeConfig.screenHeight, child: const MiscBLMBackgroundTemplate(image: AssetImage('assets/icons/background2.png'),),),),

                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  child: ListView(
                    physics: const ClampingScrollPhysics(),
                    children: [
                      MiscBLMInputFieldDropDown(key: _key1,),

                      const SizedBox(height: 20,),

                      TextFormField(
                        controller: controller3,
                        style: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xff2F353D),),
                        cursorColor: const Color(0xff000000),
                        keyboardType: TextInputType.text,
                        maxLines: 1,
                        decoration: InputDecoration(
                          labelText: 'Location of the incident',
                          labelStyle: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xff000000),),
                          focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0xff000000),),),
                          alignLabelWithHint: true,
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.add_location), 
                            onPressed: () async{
                              var memorialLocation = await Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeBLMCreateMemorialLocateMap()));

                              if(memorialLocation != null){
                                location.value = memorialLocation;
                              }
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 20,),

                      MiscBLMInputFieldTemplate(
                        key: _key3,
                        labelText: 'Precinct / Station House (Optional)',
                        labelTextStyle: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xff000000),),
                      ),

                      const SizedBox(height: 20,),

                      TextFormField(
                        controller: controller1,
                        cursorColor: const Color(0xff000000),
                        keyboardType: TextInputType.text,
                        readOnly: true,
                        style: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xff2F353D),),
                        decoration: InputDecoration(
                          labelText: 'DOB',
                          alignLabelWithHint: true,
                          focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0xff000000),),),
                          labelStyle: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xff000000),),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: (){
                              controller1.text = '';
                              dob = DateTime(1000);
                            },
                          ),
                        ),
                        onTap: (){
                          DatePicker.showDatePicker(
                            context,
                            showTitleActions: true,
                            minTime: dob,
                            maxTime: rip,
                            currentTime: DateTime.now(),
                            locale: LocaleType.en,
                            onConfirm: (date) {
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
                        style: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xff2F353D),),
                        decoration: InputDecoration(
                          labelStyle: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xff000000),),
                          focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0xff000000),),),
                          alignLabelWithHint: true,
                          labelText: 'RIP',
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: (){
                              controller2.text = '';
                              rip = DateTime.now();
                            },
                          ),
                        ),
                        onTap: () {
                          DatePicker.showDatePicker(
                            context,
                            showTitleActions: true,
                            minTime: dob,
                            maxTime: DateTime.now(),
                            currentTime: DateTime.now(),
                            locale: LocaleType.en,
                            onConfirm: (date) {
                              String format = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
                              rip = date;
                              controller2.text = format;
                            },
                          );
                        },
                      ),

                      const SizedBox(height: 20,),

                      MiscBLMInputFieldTemplate(
                        key: _key6, 
                        labelText: 'Country',
                        labelTextStyle: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xff000000),),
                      ),

                      const SizedBox(height: 20,),

                      MiscBLMInputFieldTemplate(
                        key: _key7, 
                        labelText: 'State',
                        labelTextStyle: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xff000000),),
                      ),

                      const SizedBox(height: 40,),

                      MiscButtonTemplate(
                        buttonTextStyle: const TextStyle(fontSize: 24, color: Color(0xffffffff), fontFamily: 'NexaBold',),
                        width: SizeConfig.screenWidth! / 2,
                        height: 50,
                        onPressed: () async{
                          if(controller3.text == '' || controller1.text == '' || controller2.text == '' || _key6.currentState!.controller.text == '' || _key7.currentState!.controller.text == ''){
                            await showDialog(
                              context: context,
                              builder: (_) => AssetGiffyDialog(
                                description: const Text('Please complete the form before submitting.', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular'),),
                                title: const Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontFamily: 'NexaRegular'),),
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
                                description: const Text('Pin the location of the cemetery first before proceeding.', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular'),),
                                title: const Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontFamily: 'NexaRegular'),),
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
                            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMCreateMemorial2(relationship: _key1.currentState!.currentSelection, locationOfIncident: controller3.text, precinct: _key3.currentState!.controller.text, dob: controller1.text, rip: controller2.text, country: _key6.currentState!.controller.text, state: _key7.currentState!.controller.text, latitude: '${location.value!.latitude}', longitude: '${location.value!.longitude}',),),);
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