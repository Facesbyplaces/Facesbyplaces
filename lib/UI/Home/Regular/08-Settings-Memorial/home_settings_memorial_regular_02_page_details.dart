import 'package:facesbyplaces/UI/Home/Regular/02-View-Memorial/home_view_memorial_regular_01_managed_memorial.dart';
import 'package:facesbyplaces/API/Regular/09-Settings-Memorial/api_settings_memorial_regular_01_show_page_details.dart';
import 'package:facesbyplaces/API/Regular/09-Settings-Memorial/api_settings_memorial_regular_07_update_page_details.dart';
import 'home_settings_memorial_regular_09_memoria_settings_locate_map.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter/material.dart';
import 'package:dialog/dialog.dart';
import 'package:loader/loader.dart';
import 'package:misc/misc.dart';

class HomeRegularPageDetails extends StatefulWidget{
  final int memorialId;
  const HomeRegularPageDetails({Key? key, required this.memorialId}) : super(key: key);

  @override
  HomeRegularPageDetailsState createState() => HomeRegularPageDetailsState();
}

class HomeRegularPageDetailsState extends State<HomeRegularPageDetails>{
  final GlobalKey<MiscInputFieldTemplateState> _key1 = GlobalKey<MiscInputFieldTemplateState>();
  final GlobalKey<MiscInputFieldDropDownState> _key2 = GlobalKey<MiscInputFieldDropDownState>();
  final GlobalKey<MiscInputFieldTemplateState> _key3 = GlobalKey<MiscInputFieldTemplateState>();
  final GlobalKey<MiscInputFieldTemplateState> _key5 = GlobalKey<MiscInputFieldTemplateState>();
  Future<APIRegularShowPageDetailsMain>? futureMemorialSettings;
  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  TextEditingController controller3 = TextEditingController();
  ValueNotifier<LatLng?> location = ValueNotifier(null);
  DateTime dob = DateTime(1000);
  DateTime rip = DateTime.now();

  @override
  void initState(){
    super.initState();
    futureMemorialSettings = getMemorialSettings(widget.memorialId);
  }

  Future<APIRegularShowPageDetailsMain> getMemorialSettings(int memorialId) async{
    var newValue = await apiRegularShowPageDetails(memorialId: memorialId);
    controller1 = TextEditingController(text: newValue.almMemorial.showPageDetailsDetails.showPageDetailsDetailsDob);
    controller2 = TextEditingController(text: newValue.almMemorial.showPageDetailsDetails.showPageDetailsDetailsRip);
    controller3 = TextEditingController(text: newValue.almMemorial.showPageDetailsDetails.showPageDetailsDetailsCemetery);
    location.value = LatLng(newValue.almMemorial.showPageDetailsDetails.showPageDetailsDetailsLatitude, newValue.almMemorial.showPageDetailsDetails.showPageDetailsDetailsLongitude);
    return await apiRegularShowPageDetails(memorialId: memorialId);
  }

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
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xff04ECFF),
            centerTitle: false,
            title: const Text('Page Details', style: TextStyle(fontSize: 26, fontFamily: 'NexaRegular', color: Color(0xffffffff),),),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Color(0xffffffff), size: 35,),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
          ),
          body: ValueListenableBuilder(
            valueListenable: location,
            builder: (_, LatLng? locationListener, __) => FutureBuilder<APIRegularShowPageDetailsMain>(
              future: futureMemorialSettings,
              builder: (context, memorialSettings){
                if(memorialSettings.hasData){
                  return Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                        child: ListView(
                          physics: const ClampingScrollPhysics(),
                          children: [
                            MiscInputFieldTemplate(
                              key: _key1,
                              labelText: 'Page Name',
                              displayText: memorialSettings.data!.almMemorial.showPageDetailsName,
                              labelTextStyle: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xffBDC3C7),),
                            ),

                            const SizedBox(height: 20,),

                            MiscInputFieldDropDown(
                              key: _key2,
                              displayText: memorialSettings.data!.almMemorial.showPageDetailsRelationship,
                            ),

                            const SizedBox(height: 20,),

                            MiscInputFieldTemplate(
                              key: _key3,
                              labelText: 'Birthplace',
                              displayText: memorialSettings.data!.almMemorial.showPageDetailsDetails.showPageDetailsDetailsBirthplace,
                              labelTextStyle: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xffBDC3C7),),
                            ),

                            const SizedBox(height: 20,),

                            TextFormField(
                              controller: controller1,
                              decoration: const InputDecoration(alignLabelWithHint: true, labelText: 'DOB', labelStyle: TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xffBDC3C7),), focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xff000000),),),),
                              style: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xff2F353D),),
                              cursorColor: const Color(0xff000000),
                              keyboardType: TextInputType.text,
                              readOnly: true,
                              onTap: (){
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
                              decoration: const InputDecoration(alignLabelWithHint: true, labelText: 'RIP', labelStyle: TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xffBDC3C7),), focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xff000000),),),),
                              style: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xff2F353D),),
                              cursorColor: const Color(0xff000000),
                              keyboardType: TextInputType.text,
                              readOnly: true,
                              onTap: (){
                                DatePicker.showDatePicker(
                                  context,
                                  maxTime: DateTime.now(),
                                  currentTime: DateTime.now(),
                                  showTitleActions: true,
                                  locale: LocaleType.en,
                                  minTime: dob,
                                  onConfirm: (date){
                                    String format = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
                                    rip = date;
                                    controller2.text = format;
                                  },
                                );
                              },
                            ),

                            const SizedBox(height: 20,),

                            MiscInputFieldTemplate(
                              key: _key5,
                              labelText: 'Country',
                              displayText: memorialSettings.data!.almMemorial.showPageDetailsDetails.showPageDetailsDetailsCountry,
                              labelTextStyle: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xffBDC3C7),),
                            ),

                            const SizedBox(height: 20,),

                            TextFormField(
                              controller: controller3,
                              keyboardType: TextInputType.text,
                              maxLines: 1,
                              cursorColor: const Color(0xff000000),
                              style: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xff2F353D),),
                              onChanged: (value){
                                if(value == ''){
                                  location.value = null;
                                }
                              },
                              decoration: InputDecoration(
                                alignLabelWithHint: true, 
                                labelText: 'Cemetery', 
                                labelStyle: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xff888888),),
                                focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0xff000000),),),
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.add_location), 
                                  onPressed: () async{
                                    var memorialLocation = await Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeRegularMemorialSettingsLocateMap()));

                                    if(memorialLocation != null){
                                      if(memorialLocation.runtimeType == String){ // CHECKS IF THE USER OPTS OUT OF PINNING ON THE MAPS SCREEN
                                        controller3.text = memorialLocation;
                                        location.value = null; // REMOVES THE LISTENER
                                      }else{
                                        location.value = memorialLocation[0];
                                        controller3.text = memorialLocation[1];
                                      }
                                    }
                                  },
                                ),
                              ),
                            ),

                            const SizedBox(height: 80,),

                            MiscButtonTemplate(
                              buttonTextStyle: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xffFFFFFF),),
                              buttonColor: const Color(0xff04ECFF),
                              buttonText: 'Update',
                              width: 150,
                              height: 50,
                              onPressed: () async{
                                if(memorialSettings.data!.almMemorial.showPageDetailsName != _key1.currentState!.controller.text || memorialSettings.data!.almMemorial.showPageDetailsRelationship != _key2.currentState!.currentSelection || memorialSettings.data!.almMemorial.showPageDetailsDetails.showPageDetailsDetailsBirthplace != _key3.currentState!.controller.text || memorialSettings.data!.almMemorial.showPageDetailsDetails.showPageDetailsDetailsDob != controller1.text || memorialSettings.data!.almMemorial.showPageDetailsDetails.showPageDetailsDetailsRip != controller2.text || memorialSettings.data!.almMemorial.showPageDetailsDetails.showPageDetailsDetailsCountry != _key5.currentState!.controller.text || memorialSettings.data!.almMemorial.showPageDetailsDetails.showPageDetailsDetailsCemetery != controller3.text){
                                  bool confirmResult = await showDialog(context: (context), builder: (build) => const MiscConfirmDialog(title: 'Confirm', content:'Do you want to save the changes?', confirmColor_1: Color(0xff04ECFF), confirmColor_2: Color(0xffFF0000),),);

                                  if(confirmResult){
                                    context.loaderOverlay.show();
                                    bool result = await apiRegularUpdatePageDetails(
                                      name: _key1.currentState!.controller.text, 
                                      relationship: _key2.currentState!.currentSelection, 
                                      birthplace: _key3.currentState!.controller.text, 
                                      dob: controller1.text, rip: controller2.text, 
                                      country: _key5.currentState!.controller.text, 
                                      cemetery: controller3.text, 
                                      memorialId: widget.memorialId,
                                      latitude: location.value!.latitude,
                                      longitude: location.value!.longitude,
                                    );
                                    context.loaderOverlay.hide();

                                    if(result){
                                      await showDialog(
                                        context: context,
                                        builder: (context) => CustomDialog(
                                          image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                          title: 'Success',
                                          description: 'Successfully updated the account details.',
                                          okButtonColor: const Color(0xff4caf50), // GREEN
                                          includeOkButton: true,
                                        ),
                                      );
                                      Route route = MaterialPageRoute(builder: (context) => HomeRegularProfile(memorialId: widget.memorialId, managed: true, newlyCreated: false, relationship: memorialSettings.data!.almMemorial.showPageDetailsRelationship));
                                      Navigator.of(context).pushAndRemoveUntil(route, ModalRoute.withName('/home/regular'));
                                    }else{
                                      await showDialog(
                                        context: context,
                                        builder: (context) => CustomDialog(
                                          image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                          title: 'Error',
                                          description: 'Something went wrong. Please try again.',
                                          okButtonColor: const Color(0xfff44336), // RED
                                          includeOkButton: true,
                                        ),
                                      );
                                    }
                                  }
                                }
                              },
                            ),

                            const SizedBox(height: 10,),
                          ],
                        ),
                      ),
                    ],
                  );
                }else if(memorialSettings.hasError){
                  return SizedBox(height: SizeConfig.screenHeight, child: const Center(child: Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: Color(0xff000000),),),));
                }else{
                  return const Center(child: CustomLoaderThreeDots(),);
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}