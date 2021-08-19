import 'package:facesbyplaces/UI/Home/BLM/02-View-Memorial/home-view-memorial-blm-01-managed-memorial.dart';
import 'package:facesbyplaces/API/BLM/09-Settings-Memorial/api-settings-memorial-blm-01-show-page-details.dart';
import 'package:facesbyplaces/API/BLM/09-Settings-Memorial/api-settings-memorial-blm-07-update-page-details.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-01-blm-input-field.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-02-blm-dialog.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-06-blm-button.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loader_overlay/loader_overlay.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:flutter/material.dart';

class HomeBLMPageDetails extends StatefulWidget{
  final int memorialId;
  const HomeBLMPageDetails({required this.memorialId});

  HomeBLMPageDetailsState createState() => HomeBLMPageDetailsState();
}

class HomeBLMPageDetailsState extends State<HomeBLMPageDetails>{
  final GlobalKey<MiscBLMInputFieldTemplateState> _key1 = GlobalKey<MiscBLMInputFieldTemplateState>();
  final GlobalKey<MiscBLMInputFieldTemplateState> _key2 = GlobalKey<MiscBLMInputFieldTemplateState>();
  final GlobalKey<MiscBLMInputFieldDropDownState> _key3 = GlobalKey<MiscBLMInputFieldDropDownState>();
  final GlobalKey<MiscBLMInputFieldTemplateState> _key4 = GlobalKey<MiscBLMInputFieldTemplateState>();
  final GlobalKey<MiscBLMInputFieldTemplateState> _key7 = GlobalKey<MiscBLMInputFieldTemplateState>();
  final GlobalKey<MiscBLMInputFieldTemplateState> _key8 = GlobalKey<MiscBLMInputFieldTemplateState>();
  final GlobalKey<MiscBLMInputFieldTemplateState> _key9 = GlobalKey<MiscBLMInputFieldTemplateState>();
  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  Future<APIBLMShowPageDetailsMain>? futureMemorialSettings;
  DateTime dob = DateTime(1000);
  DateTime rip = DateTime.now();

  void initState() {
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
            title: Row(
              children: [
                Text('Page Details', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 3.16, fontFamily: 'NexaRegular', color: const Color(0xffffffff),),),

                Spacer(),
              ],
            ),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: const Color(0xffffffff), size: SizeConfig.blockSizeVertical! * 3.52,),
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
                        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                        child: ListView(
                          physics: const ClampingScrollPhysics(),
                          children: [
                            MiscBLMInputFieldTemplate(
                              key: _key1,
                              labelText: 'Page Name',
                              labelTextStyle: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.11, fontFamily: 'NexaRegular', color: const Color(0xffBDC3C7),),
                              displayText: memorialSettings.data!.blmMemorial.showPageDetailsName,
                            ),

                            const SizedBox(height: 20,),

                            MiscBLMInputFieldTemplate(
                              key: _key2,
                              labelText: 'Description',
                              labelTextStyle: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.11, fontFamily: 'NexaRegular', color: const Color(0xffBDC3C7),),
                              displayText: memorialSettings.data!.blmMemorial.showPageDetailsDetails.showPageDetailsDetailsDescription,
                            ),

                            const SizedBox(height: 20,),

                            MiscBLMInputFieldDropDown(
                              key: _key3,
                              displayText: memorialSettings.data!.blmMemorial.showPageDetailsRelationship,
                            ),

                            const SizedBox(height: 20,),

                            MiscBLMInputFieldTemplate(
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
                              style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.64, fontFamily: 'NexaRegular', color: const Color(0xff2F353D),),
                              decoration: InputDecoration(
                                labelText: 'DOB',
                                alignLabelWithHint: true,
                                focusedBorder: const UnderlineInputBorder(borderSide: const BorderSide(color: const Color(0xff000000),),),
                                labelStyle: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.11, fontFamily: 'NexaRegular', color: const Color(0xffBDC3C7),),
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
                              style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.64, fontFamily: 'NexaRegular', color: const Color(0xff2F353D),),
                              decoration: InputDecoration(
                                labelText: 'RIP',
                                alignLabelWithHint: true,
                                focusedBorder: const UnderlineInputBorder(borderSide: const BorderSide(color: const Color(0xff000000),),),
                                labelStyle: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.11, fontFamily: 'NexaRegular', color: const Color(0xffBDC3C7),),
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

                            MiscBLMInputFieldTemplate(
                              key: _key7,
                              labelText: 'State',
                              displayText: memorialSettings.data!.blmMemorial.showPageDetailsDetails.showPageDetailsDetailsState,
                              labelTextStyle: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.11, fontFamily: 'NexaRegular', color: const Color(0xffBDC3C7),),
                            ),

                            const SizedBox(height: 20,),

                            MiscBLMInputFieldTemplate(
                              key: _key8,
                              labelText: 'Country',
                              displayText: memorialSettings.data!.blmMemorial.showPageDetailsDetails.showPageDetailsDetailsCountry,
                              labelTextStyle: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.11, fontFamily: 'NexaRegular', color: const Color(0xffBDC3C7),),
                            ),

                            const SizedBox(height: 20,),

                            MiscBLMInputFieldTemplate(
                              key: _key9,
                              labelText: 'Precinct',
                              displayText: memorialSettings.data!.blmMemorial.showPageDetailsDetails.showPageDetailsDetailsPrecinct,
                              labelTextStyle: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.11, fontFamily: 'NexaRegular', color: const Color(0xffBDC3C7),),
                            ),

                            const SizedBox(height: 80,),

                            MiscBLMButtonTemplate(
                              buttonText: 'Update',
                              buttonTextStyle: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.64, fontFamily: 'NexaRegular', color: const Color(0xffFFFFFF),),
                              buttonColor: const Color(0xff04ECFF),
                              width: 150,
                              height: 45,
                              onPressed: () async{
                                if(memorialSettings.data!.blmMemorial.showPageDetailsName != _key1.currentState!.controller.text || memorialSettings.data!.blmMemorial.showPageDetailsDetails.showPageDetailsDetailsDescription != _key2.currentState!.controller.text || memorialSettings.data!.blmMemorial.showPageDetailsRelationship != _key3.currentState!.currentSelection || memorialSettings.data!.blmMemorial.showPageDetailsDetails.showPageDetailsDetailsLocation != _key4.currentState!.controller.text || memorialSettings.data!.blmMemorial.showPageDetailsDetails.showPageDetailsDetailsDob != controller1.text || memorialSettings.data!.blmMemorial.showPageDetailsDetails.showPageDetailsDetailsRip != controller2.text || memorialSettings.data!.blmMemorial.showPageDetailsDetails.showPageDetailsDetailsState != _key7.currentState!.controller.text || memorialSettings.data!.blmMemorial.showPageDetailsDetails.showPageDetailsDetailsCountry != _key8.currentState!.controller.text || memorialSettings.data!.blmMemorial.showPageDetailsDetails.showPageDetailsDetailsPrecinct != _key9.currentState!.controller.text){
                                  bool confirmResult = await showDialog(context: (context), builder: (build) => MiscBLMConfirmDialog(title: 'Confirm', content: 'Do you want to save the changes?', confirmColor_1: Color(0xff04ECFF), confirmColor_2: Color(0xffFF0000),),);

                                  if(confirmResult){
                                    context.loaderOverlay.show();
                                    bool result = await apiBLMUpdatePageDetails(memorialId: widget.memorialId, name: _key1.currentState!.controller.text, description: _key2.currentState!.controller.text,relationship: _key3.currentState!.currentSelection, location: _key4.currentState!.controller.text, dob: controller1.text, rip: controller2.text, state: _key7.currentState!.controller.text, country: _key8.currentState!.controller.text, precinct: _key9.currentState!.controller.text,);
                                    context.loaderOverlay.hide();

                                    if(result){
                                      await showDialog(
                                        context: context,
                                        builder: (_) =>  AssetGiffyDialog(
                                          description: Text('Successfully updated the account details.', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.87, fontFamily: 'NexaRegular'),),
                                          title: Text('Success', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 3.16, fontFamily: 'NexaRegular'),),
                                          image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                          entryAnimation: EntryAnimation.DEFAULT,
                                          onlyOkButton: true,
                                          onOkButtonPressed: (){
                                            Navigator.pop(context, true);
                                          },
                                        )
                                      );

                                      Route route = MaterialPageRoute(builder: (context) => HomeBLMProfile(memorialId: widget.memorialId, managed: true, newlyCreated: false, relationship: memorialSettings.data!.blmMemorial.showPageDetailsRelationship,));
                                      Navigator.of(context).pushAndRemoveUntil(route, ModalRoute.withName('/home/blm'));
                                    }else{
                                      await showDialog(
                                        context: context,
                                        builder: (_) => AssetGiffyDialog(
                                          description: Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.87, fontFamily: 'NexaRegular'),),
                                          title: Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 3.87, fontFamily: 'NexaRegular'),),
                                          image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                          entryAnimation: EntryAnimation.DEFAULT,
                                          buttonOkColor: const Color(0xffff0000),
                                          onlyOkButton: true,
                                          onOkButtonPressed: (){
                                            Navigator.pop(context, true);
                                          },
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
                  return Container(
                    height: SizeConfig.screenHeight,
                    child: const Center(child: const Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, color: const Color(0xff000000),),),),
                  );
                }else{
                  return Container(
                    height: SizeConfig.screenHeight,
                    child: Center(child: Container(child: const SpinKitThreeBounce(color: const Color(0xff000000), size: 50.0,), color: const Color(0xffffffff),),),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}