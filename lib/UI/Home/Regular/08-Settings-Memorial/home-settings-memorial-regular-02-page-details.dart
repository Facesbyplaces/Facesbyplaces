import 'package:facesbyplaces/UI/Home/Regular/02-View-Memorial/home-view-memorial-regular-01-managed-memorial.dart';
import 'package:facesbyplaces/API/Regular/09-Settings-Memorial/api-settings-memorial-regular-01-show-page-details.dart';
import 'package:facesbyplaces/API/Regular/09-Settings-Memorial/api-settings-memorial-regular-07-update-page-details.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-01-regular-input-field.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-06-regular-button.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-02-regular-dialog.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:flutter/material.dart';

class HomeRegularPageDetails extends StatefulWidget{

  final int memorialId;
  const HomeRegularPageDetails({required this.memorialId});

  HomeRegularPageDetailsState createState() => HomeRegularPageDetailsState(memorialId: memorialId);
}

class HomeRegularPageDetailsState extends State<HomeRegularPageDetails>{

  final int memorialId;
  HomeRegularPageDetailsState({required this.memorialId});

  final GlobalKey<MiscRegularInputFieldTemplateState> _key1 = GlobalKey<MiscRegularInputFieldTemplateState>();
  final GlobalKey<MiscRegularInputFieldDropDownState> _key2 = GlobalKey<MiscRegularInputFieldDropDownState>();
  final GlobalKey<MiscRegularInputFieldTemplateState> _key5 = GlobalKey<MiscRegularInputFieldTemplateState>();
  final GlobalKey<MiscRegularInputFieldTemplateState> _key6 = GlobalKey<MiscRegularInputFieldTemplateState>();

  Future<APIRegularShowPageDetailsMain>? futureMemorialSettings;
  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  DateTime dob = DateTime.now();
  DateTime rip = DateTime.now();

  void initState(){
    super.initState();
    futureMemorialSettings = getMemorialSettings(memorialId);
  }

  Future<APIRegularShowPageDetailsMain> getMemorialSettings(int memorialId) async{
    var newValue = await apiRegularShowPageDetails(memorialId: memorialId);
    controller1 = TextEditingController(text: newValue.almMemorial.showPageDetailsDetails.showPageDetailsDetailsDob);
    controller2 = TextEditingController(text: newValue.almMemorial.showPageDetailsDetails.showPageDetailsDetailsRip);
    return await apiRegularShowPageDetails(memorialId: memorialId);
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
          body: FutureBuilder<APIRegularShowPageDetailsMain>(
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

                          MiscRegularInputFieldTemplate(key: _key1, labelText: 'Page Name', displayText: memorialSettings.data!.almMemorial.showPageDetailsName),

                          const SizedBox(height: 20,),

                          MiscRegularInputFieldDropDown(key: _key2, displayText: memorialSettings.data!.almMemorial.showPageDetailsRelationship),

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

                          MiscRegularInputFieldTemplate(key: _key5, labelText: 'Country', displayText: memorialSettings.data!.almMemorial.showPageDetailsDetails.showPageDetailsDetailsCountry),

                          const SizedBox(height: 20,),

                          MiscRegularInputFieldTemplate(key: _key6, labelText: 'Cemetery', displayText: memorialSettings.data!.almMemorial.showPageDetailsDetails.showPageDetailsDetailsCemetery),

                          const SizedBox(height: 80,),

                          MiscRegularButtonTemplate(
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
                                memorialSettings.data!.almMemorial.showPageDetailsName != _key1.currentState!.controller.text ||
                                memorialSettings.data!.almMemorial.showPageDetailsRelationship != _key2.currentState!.currentSelection ||
                                memorialSettings.data!.almMemorial.showPageDetailsDetails.showPageDetailsDetailsDob != controller1.text ||
                                memorialSettings.data!.almMemorial.showPageDetailsDetails.showPageDetailsDetailsRip != controller2.text ||
                                memorialSettings.data!.almMemorial.showPageDetailsDetails.showPageDetailsDetailsCountry !=  _key5.currentState!.controller.text ||
                                memorialSettings.data!.almMemorial.showPageDetailsDetails.showPageDetailsDetailsCemetery !=  _key6.currentState!.controller.text
                              ){
                                bool confirmResult = await showDialog(context: (context), builder: (build) => const MiscRegularConfirmDialog(title: 'Confirm', content: 'Do you want to save the changes?', confirmColor_1: const Color(0xff04ECFF), confirmColor_2: const Color(0xffFF0000),));

                                if(confirmResult){
                                  context.loaderOverlay.show();
                                  bool result = await apiRegularUpdatePageDetails(
                                    name: _key1.currentState!.controller.text,
                                    relationship: _key2.currentState!.currentSelection,
                                    dob: controller1.text,
                                    rip: controller2.text,
                                    country: _key5.currentState!.controller.text,
                                    cemetery: _key6.currentState!.controller.text,
                                    memorialId: memorialId,
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
                                    Route route = MaterialPageRoute(builder: (context) => HomeRegularProfile(memorialId: memorialId, managed: true, newlyCreated: false, relationship: memorialSettings.data!.almMemorial.showPageDetailsRelationship));
                                    Navigator.of(context).pushAndRemoveUntil(route, ModalRoute.withName('/home/regular'));
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
    );
  }
}