import 'package:facesbyplaces/UI/Home/BLM/02-View-Memorial/home_view_memorial_blm_01_managed_memorial.dart';
import 'package:facesbyplaces/API/BLM/09-Settings-Memorial/api_settings_memorial_blm_01_show_page_details.dart';
import 'package:facesbyplaces/API/BLM/09-Settings-Memorial/api_settings_memorial_blm_07_update_page_details.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter/material.dart';
import 'package:dialog/dialog.dart';
import 'package:loader/loader.dart';
import 'package:misc/misc.dart';

class HomeBLMPageDetails extends StatefulWidget{
  final int memorialId;
  const HomeBLMPageDetails({Key? key, required this.memorialId}) : super(key: key);

  @override
  HomeBLMPageDetailsState createState() => HomeBLMPageDetailsState();
}

class HomeBLMPageDetailsState extends State<HomeBLMPageDetails>{
  final GlobalKey<MiscInputFieldTemplateState> _key1 = GlobalKey<MiscInputFieldTemplateState>();
  final GlobalKey<MiscInputFieldTemplateState> _key2 = GlobalKey<MiscInputFieldTemplateState>();
  final GlobalKey<MiscInputFieldDropDownState> _key3 = GlobalKey<MiscInputFieldDropDownState>();
  final GlobalKey<MiscInputFieldTemplateState> _key4 = GlobalKey<MiscInputFieldTemplateState>();
  final GlobalKey<MiscInputFieldTemplateState> _key7 = GlobalKey<MiscInputFieldTemplateState>();
  final GlobalKey<MiscInputFieldTemplateState> _key8 = GlobalKey<MiscInputFieldTemplateState>();
  final GlobalKey<MiscInputFieldTemplateState> _key9 = GlobalKey<MiscInputFieldTemplateState>();
  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  Future<APIBLMShowPageDetailsMain>? futureMemorialSettings;
  DateTime dob = DateTime(1000);
  DateTime rip = DateTime.now();

  @override
  void initState(){
    super.initState();
    futureMemorialSettings = getMemorialSettings(widget.memorialId);
  }

  Future<APIBLMShowPageDetailsMain> getMemorialSettings(int memorialId) async{
    var newValue = await apiBLMShowPageDetails(memorialId: memorialId);
    controller1 = TextEditingController(text: newValue.blmMemorial.showPageDetailsDetails.showPageDetailsDetailsDob);
    controller2 = TextEditingController(text: newValue.blmMemorial.showPageDetailsDetails.showPageDetailsDetailsRip);
    return await apiBLMShowPageDetails(memorialId: memorialId);
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
            title: const Text('Page Details', style: TextStyle(fontSize: 26, fontFamily: 'NexaRegular', color: Color(0xffffffff),),),
            centerTitle: false,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Color(0xffffffff), size: 35,),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
          ),
          body: SafeArea(
            child: FutureBuilder<APIBLMShowPageDetailsMain>(
              future: futureMemorialSettings,
              builder: (context, memorialSettings){
                if(memorialSettings.hasData){
                  return Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                        child: ListView(
                          physics: const ClampingScrollPhysics(),
                          children: [
                            MiscInputFieldTemplate(
                              key: _key1,
                              labelText: 'Page Name',
                              labelTextStyle: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xffBDC3C7),),
                              displayText: memorialSettings.data!.blmMemorial.showPageDetailsName,
                            ),

                            const SizedBox(height: 20,),

                            MiscInputFieldTemplate(
                              key: _key2,
                              labelText: 'Description',
                              labelTextStyle: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xffBDC3C7),),
                              displayText: memorialSettings.data!.blmMemorial.showPageDetailsDetails.showPageDetailsDetailsDescription,
                            ),

                            const SizedBox(height: 20,),

                            MiscInputFieldDropDown(
                              key: _key3,
                              displayText: memorialSettings.data!.blmMemorial.showPageDetailsRelationship,
                            ),

                            const SizedBox(height: 20,),

                            MiscInputFieldTemplate(
                              key: _key4,
                              labelText: 'Location',
                              displayText: memorialSettings.data!.blmMemorial.showPageDetailsDetails.showPageDetailsDetailsLocation,
                            ),

                            const SizedBox(height: 20,),

                            TextFormField(
                              controller: controller1,
                              cursorColor: const Color(0xff000000),
                              keyboardType: TextInputType.text,
                              readOnly: true,
                              style: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xff2F353D),),
                              decoration: const InputDecoration(
                                labelText: 'DOB',
                                alignLabelWithHint: true,
                                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xff000000),),),
                                labelStyle: TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xffBDC3C7),),
                              ),
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
                              cursorColor: const Color(0xff000000),
                              keyboardType: TextInputType.text,
                              readOnly: true,
                              style: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xff2F353D),),
                              decoration: const InputDecoration(
                                labelText: 'RIP',
                                alignLabelWithHint: true,
                                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xff000000),),),
                                labelStyle: TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xffBDC3C7),),
                              ),
                              onTap: (){
                                DatePicker.showDatePicker(
                                  context,
                                  showTitleActions: true,
                                  minTime: dob,
                                  maxTime: DateTime.now(),
                                  currentTime: DateTime.now(),
                                  onConfirm: (date){
                                    String format = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
                                    rip = date;
                                    controller2.text = format;
                                  },
                                  locale: LocaleType.en,
                                );
                              },
                            ),
                            
                            const SizedBox(height: 20,),

                            MiscInputFieldTemplate(
                              key: _key7,
                              labelText: 'State',
                              displayText: memorialSettings.data!.blmMemorial.showPageDetailsDetails.showPageDetailsDetailsState,
                              labelTextStyle: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xffBDC3C7),),
                            ),

                            const SizedBox(height: 20,),

                            MiscInputFieldTemplate(
                              key: _key8,
                              labelText: 'Country',
                              displayText: memorialSettings.data!.blmMemorial.showPageDetailsDetails.showPageDetailsDetailsCountry,
                              labelTextStyle: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xffBDC3C7),),
                            ),

                            const SizedBox(height: 20,),

                            MiscInputFieldTemplate(
                              key: _key9,
                              labelText: 'Precinct',
                              displayText: memorialSettings.data!.blmMemorial.showPageDetailsDetails.showPageDetailsDetailsPrecinct,
                              labelTextStyle: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xffBDC3C7),),
                            ),

                            const SizedBox(height: 80,),

                            MiscButtonTemplate(
                              buttonText: 'Update',
                              buttonTextStyle: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xffFFFFFF),),
                              buttonColor: const Color(0xff04ECFF),
                              width: 150,
                              height: 50,
                              onPressed: () async{
                                if(memorialSettings.data!.blmMemorial.showPageDetailsName != _key1.currentState!.controller.text || memorialSettings.data!.blmMemorial.showPageDetailsDetails.showPageDetailsDetailsDescription != _key2.currentState!.controller.text || memorialSettings.data!.blmMemorial.showPageDetailsRelationship != _key3.currentState!.currentSelection || memorialSettings.data!.blmMemorial.showPageDetailsDetails.showPageDetailsDetailsLocation != _key4.currentState!.controller.text || memorialSettings.data!.blmMemorial.showPageDetailsDetails.showPageDetailsDetailsDob != controller1.text || memorialSettings.data!.blmMemorial.showPageDetailsDetails.showPageDetailsDetailsRip != controller2.text || memorialSettings.data!.blmMemorial.showPageDetailsDetails.showPageDetailsDetailsState != _key7.currentState!.controller.text || memorialSettings.data!.blmMemorial.showPageDetailsDetails.showPageDetailsDetailsCountry != _key8.currentState!.controller.text || memorialSettings.data!.blmMemorial.showPageDetailsDetails.showPageDetailsDetailsPrecinct != _key9.currentState!.controller.text){
                                  bool confirmResult = await showDialog(context: (context), builder: (build) => const MiscConfirmDialog(title: 'Confirm', content: 'Do you want to save the changes?', confirmColor_1: Color(0xff04ECFF), confirmColor_2: Color(0xffFF0000),),);

                                  if(confirmResult){
                                    context.loaderOverlay.show();
                                    bool result = await apiBLMUpdatePageDetails(memorialId: widget.memorialId, name: _key1.currentState!.controller.text, description: _key2.currentState!.controller.text,relationship: _key3.currentState!.currentSelection, location: _key4.currentState!.controller.text, dob: controller1.text, rip: controller2.text, state: _key7.currentState!.controller.text, country: _key8.currentState!.controller.text, precinct: _key9.currentState!.controller.text,);
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
                                      Route route = MaterialPageRoute(builder: (context) => HomeBLMProfile(memorialId: widget.memorialId, managed: true, newlyCreated: false, relationship: memorialSettings.data!.blmMemorial.showPageDetailsRelationship,));
                                      Navigator.of(context).pushAndRemoveUntil(route, ModalRoute.withName('/home/blm'));
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

                            const SizedBox(height: 20,),
                          ],
                        ),
                      ),
                    ],
                  );
                }else if(memorialSettings.hasError){
                  return SizedBox(
                    height: SizeConfig.screenHeight,
                    child: const Center(child: Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: Color(0xff000000),),),),
                  );
                }else{
                  return const Center(child: CustomLoader(),);
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}