import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'home_create_memorial_regular_02_create_memorial.dart';
import 'home_create_memorial_regular_04_locate_map.dart';
import 'package:flutter/material.dart';
import 'package:dialog/dialog.dart';
import 'package:misc/misc.dart';
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
  const HomeRegularCreateMemorial1({Key? key}) : super(key: key);

  @override
  HomeRegularCreateMemorial1State createState() => HomeRegularCreateMemorial1State();
}

class HomeRegularCreateMemorial1State extends State<HomeRegularCreateMemorial1>{
  final GlobalKey<MiscInputFieldDropDownState> _key1 = GlobalKey<MiscInputFieldDropDownState>();
  final GlobalKey<MiscInputFieldTemplateState> _key2 = GlobalKey<MiscInputFieldTemplateState>();
  final GlobalKey<MiscInputFieldTemplateState> _key6 = GlobalKey<MiscInputFieldTemplateState>();
  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  TextEditingController controller3 = TextEditingController();
  TextEditingController controller4 = TextEditingController();
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
              title: const Text('Create a Memorial Page for Friends and family.', maxLines: 2, style: TextStyle(fontSize: 26, fontFamily: 'NexaRegular', color: Color(0xffffffff),),),
              centerTitle: true,
              backgroundColor: const Color(0xff04ECFF),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Color(0xffffffff), size: 35,),
                onPressed: (){
                  Navigator.pop(context);
                },
              ),
            ),
            body: Stack(
              children: [
                SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: SizedBox(height: SizeConfig.screenHeight, child: const MiscBackgroundTemplate(image: AssetImage('assets/icons/background2.png'),),),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  child: ListView(
                    physics: const ClampingScrollPhysics(),
                    children: [
                      MiscInputFieldDropDown(key: _key1,),

                      const SizedBox(height: 20,),
                      
                      MiscInputFieldTemplate(
                        key: _key2, 
                        labelText: 'Birthplace',
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
                          labelStyle: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xff000000),),
                          focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0xff000000),),),
                          alignLabelWithHint: true,
                          labelText: 'DOB',
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.close), 
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

                      TextFormField(
                        controller: controller4,
                        keyboardType: TextInputType.text,
                        maxLines: 1,
                        cursorColor: const Color(0xff000000),
                        style: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xff2F353D),),
                        decoration: InputDecoration(
                          alignLabelWithHint: true, 
                          labelText: 'Cemetery', 
                          labelStyle: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xff000000),),
                          focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0xff000000),),),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.add_location), 
                            onPressed: () async{
                              var memorialLocation = await Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeRegularCreateMemorialLocateMap()));

                              if(memorialLocation != null){
                                location.value = memorialLocation[0];
                                controller4.text = memorialLocation[1];
                              }
                            },
                          ),
                        ),
                      ),
                      
                      
                      const SizedBox(height: 20,),

                      MiscInputFieldTemplate(
                        key: _key6, 
                        labelText: 'Country',
                        labelTextStyle: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xff000000),),
                      ),

                      const SizedBox(height: 40,),

                      MiscButtonTemplate(
                        buttonTextStyle: const TextStyle(fontSize: 24, color: Color(0xffffffff), fontFamily: 'NexaBold',),
                        width: SizeConfig.screenWidth! / 2,
                        height: 50,
                        onPressed: () async{
                          if(_key2.currentState!.controller.text == '' || controller1.text == '' || controller2.text == '' || controller4.text == '' || _key6.currentState!.controller.text == ''){
                            await showDialog(
                              context: context,
                              builder: (context) => CustomDialog(
                                image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                title: 'Error',
                                description: 'Please complete the form before submitting.',
                                okButtonColor: const Color(0xfff44336), // RED
                                includeOkButton: true,
                              ),
                            );
                          }else if(locationListener == null){
                            await showDialog(
                              context: context,
                              builder: (context) => CustomDialog(
                                image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                title: 'Error',
                                description: 'Pin the location of the cemetery first before proceeding.',
                                okButtonColor: const Color(0xfff44336), // RED
                                includeOkButton: true,
                              ),
                            );
                          }else{
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