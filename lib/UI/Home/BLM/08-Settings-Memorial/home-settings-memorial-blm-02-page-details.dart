import 'package:facesbyplaces/UI/Home/BLM/02-View-Memorial/home-view-memorial-blm-01-managed-memorial.dart';
import 'package:facesbyplaces/API/BLM/09-Settings-Memorial/api-settings-memorial-blm-01-show-page-details.dart';
import 'package:facesbyplaces/API/BLM/09-Settings-Memorial/api-settings-memorial-blm-07-update-page-details.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-01-blm-input-field.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-02-blm-dialog.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-06-blm-button.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:flutter/material.dart';

class HomeBLMPageDetails extends StatefulWidget{

  final int memorialId;
  const HomeBLMPageDetails({required this.memorialId});

  HomeBLMPageDetailsState createState() => HomeBLMPageDetailsState(memorialId: memorialId);
}

class HomeBLMPageDetailsState extends State<HomeBLMPageDetails>{

  final int memorialId;
  HomeBLMPageDetailsState({required this.memorialId});

  final GlobalKey<MiscBLMInputFieldTemplateState> _key1 = GlobalKey<MiscBLMInputFieldTemplateState>();
  final GlobalKey<MiscBLMInputFieldTemplateState> _key2 = GlobalKey<MiscBLMInputFieldTemplateState>();
  final GlobalKey<MiscBLMInputFieldDropDownState> _key3 = GlobalKey<MiscBLMInputFieldDropDownState>();
  final GlobalKey<MiscBLMInputFieldTemplateState> _key4 = GlobalKey<MiscBLMInputFieldTemplateState>();
  final GlobalKey<MiscBLMInputFieldTemplateState> _key7 = GlobalKey<MiscBLMInputFieldTemplateState>();
  final GlobalKey<MiscBLMInputFieldTemplateState> _key8 = GlobalKey<MiscBLMInputFieldTemplateState>();
  final GlobalKey<MiscBLMInputFieldTemplateState> _key9 = GlobalKey<MiscBLMInputFieldTemplateState>();

  Future<APIBLMShowPageDetailsMain>? futureMemorialSettings;
  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  DateTime dob = DateTime.now();
  DateTime rip = DateTime.now();

  void initState(){
    super.initState();
    futureMemorialSettings = getMemorialSettings(memorialId);
  }

  Future<APIBLMShowPageDetailsMain> getMemorialSettings(int memorialId) async{
    var newValue = await apiBLMShowPageDetails(memorialId: memorialId);
    controller1 = TextEditingController(text: newValue.blmMemorial.showPageDetailsDetails.showPageDetailsDetailsDob);
    controller2 = TextEditingController(text: newValue.blmMemorial.showPageDetailsDetails.showPageDetailsDetailsRip);
    return await apiBLMShowPageDetails(memorialId: memorialId);
  }

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
            backgroundColor: const Color(0xff04ECFF),
            title: const Text('Memorial Settings', style: const TextStyle(fontSize: 16, color: const Color(0xffffffff)),),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: const Color(0xffffffff),), 
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

                            MiscBLMInputFieldTemplate(key: _key1, labelText: 'Page Name', displayText: memorialSettings.data!.blmMemorial.showPageDetailsName,),

                            const SizedBox(height: 20,),

                            MiscBLMInputFieldTemplate(key: _key2, labelText: 'Description', displayText: memorialSettings.data!.blmMemorial.showPageDetailsDetails.showPageDetailsDetailsDescription,),

                            const SizedBox(height: 20,),

                            MiscBLMInputFieldDropDown(key: _key3, displayText: memorialSettings.data!.blmMemorial.showPageDetailsRelationship,),

                            const SizedBox(height: 20,),

                            MiscBLMInputFieldTemplate(key: _key4, labelText: 'Location', displayText: memorialSettings.data!.blmMemorial.showPageDetailsDetails.showPageDetailsDetailsLocation,),

                            const SizedBox(height: 20,),

                            DateTimePicker(
                              type: DateTimePickerType.date,
                              controller: controller1,
                              cursorColor: const Color(0xff000000),
                              firstDate: DateTime(1000),
                              lastDate: DateTime.now(),
                              dateLabelText: memorialSettings.data!.blmMemorial.showPageDetailsDetails.showPageDetailsDetailsDob,
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
                                  controller1.text = dob.toString();
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
                                try{
                                  if(date.isAfter(dob) || date.isAtSameMomentAs(dob)){
                                    return true;
                                  }else{
                                    return false;
                                  }
                                }catch(e){
                                  print('The error is $e');
                                }
                                return true;
                              },
                              onChanged: (changed){
                                setState(() {
                                  rip = DateTime.parse(changed);
                                  controller2.text = dob.toString();
                                });
                              },
                            ),

                            const SizedBox(height: 20,),

                            MiscBLMInputFieldTemplate(key: _key7, labelText: 'State', displayText: memorialSettings.data!.blmMemorial.showPageDetailsDetails.showPageDetailsDetailsState,),

                            const SizedBox(height: 20,),

                            MiscBLMInputFieldTemplate(key: _key8, labelText: 'Country', displayText: memorialSettings.data!.blmMemorial.showPageDetailsDetails.showPageDetailsDetailsCountry,),

                            const SizedBox(height: 20,),

                            MiscBLMInputFieldTemplate(key: _key9, labelText: 'Precinct', displayText: memorialSettings.data!.blmMemorial.showPageDetailsDetails.showPageDetailsDetailsPrecinct,),

                            const SizedBox(height: 80,),

                            MiscBLMButtonTemplate(
                              buttonText: 'Update', 
                              buttonTextStyle: const TextStyle(
                                fontSize: 16, 
                                fontWeight: FontWeight.bold, 
                                color: const Color(0xffffffff),
                              ),
                              width: 150,
                              height: 45,
                              buttonColor: const Color(0xff04ECFF),
                              onPressed: () async{

                                if(
                                  memorialSettings.data!.blmMemorial.showPageDetailsName != _key1.currentState!.controller.text ||
                                  memorialSettings.data!.blmMemorial.showPageDetailsDetails.showPageDetailsDetailsDescription !=  _key2.currentState!.controller.text ||
                                  memorialSettings.data!.blmMemorial.showPageDetailsRelationship != _key3.currentState!.currentSelection ||
                                  memorialSettings.data!.blmMemorial.showPageDetailsDetails.showPageDetailsDetailsLocation != _key4.currentState!.controller.text ||
                                  memorialSettings.data!.blmMemorial.showPageDetailsDetails.showPageDetailsDetailsDob != controller1.text ||
                                  memorialSettings.data!.blmMemorial.showPageDetailsDetails.showPageDetailsDetailsRip != controller2.text ||
                                  memorialSettings.data!.blmMemorial.showPageDetailsDetails.showPageDetailsDetailsState != _key7.currentState!.controller.text ||
                                  memorialSettings.data!.blmMemorial.showPageDetailsDetails.showPageDetailsDetailsCountry != _key8.currentState!.controller.text ||
                                  memorialSettings.data!.blmMemorial.showPageDetailsDetails.showPageDetailsDetailsPrecinct != _key9.currentState!.controller.text
                                ){
                                  bool confirmResult = await showDialog(context: (context), builder: (build) => MiscBLMConfirmDialog(title: 'Confirm', content: 'Do you want to save the changes?', confirmColor_1: Color(0xff04ECFF), confirmColor_2: Color(0xffFF0000),));

                                  if(confirmResult){
                                    context.loaderOverlay.show();

                                    bool result = await apiBLMUpdatePageDetails(
                                      memorialId: memorialId,
                                      name: _key1.currentState!.controller.text,
                                      description: _key2.currentState!.controller.text,
                                      relationship: _key3.currentState!.currentSelection,
                                      location: _key4.currentState!.controller.text ,
                                      dob: controller1.text,
                                      rip: controller2.text,
                                      state: _key7.currentState!.controller.text,
                                      country: _key8.currentState!.controller.text,
                                      precinct: _key9.currentState!.controller.text,
                                    );

                                    context.loaderOverlay.hide();

                                    if(result){
                                      await showDialog(
                                        context: context,
                                        builder: (_) => 
                                          AssetGiffyDialog(
                                          image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                          title: const Text('Success', textAlign: TextAlign.center, style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                                          entryAnimation: EntryAnimation.DEFAULT,
                                          description: const Text('Successfully updated the account details.',
                                            textAlign: TextAlign.center,
                                          ),
                                          onlyOkButton: true,
                                          onOkButtonPressed: () {
                                            Navigator.pop(context, true);
                                          },
                                        )
                                      );
                                      Route route = MaterialPageRoute(builder: (context) => HomeBLMProfile(memorialId: memorialId, managed: true, newlyCreated: false, relationship: memorialSettings.data!.blmMemorial.showPageDetailsRelationship,));
                                      Navigator.of(context).pushAndRemoveUntil(route, ModalRoute.withName('/home/blm'));
                                    }else{
                                      await showDialog(
                                        context: context,
                                        builder: (_) => 
                                          AssetGiffyDialog(
                                          image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                          title: const Text('Error', textAlign: TextAlign.center, style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                                          entryAnimation: EntryAnimation.DEFAULT,
                                          description: const Text('Something went wrong. Please try again.',
                                            textAlign: TextAlign.center,
                                          ),
                                          onlyOkButton: true,
                                          buttonOkColor: const Color(0xffff0000),
                                          onOkButtonPressed: () {
                                            Navigator.pop(context, true);
                                          },
                                        )
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
                  return Container(height: SizeConfig.screenHeight, child: const Center(child: const Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, color: const Color(0xff000000),),),));
                }else{
                  return Container(height: SizeConfig.screenHeight, child: Center(child: Container(child: const SpinKitThreeBounce(color: const Color(0xff000000), size: 50.0,), color: const Color(0xffffffff),),),);
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}