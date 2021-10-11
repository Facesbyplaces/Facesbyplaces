import 'package:facesbyplaces/UI/Home/Regular/02-View-Memorial/home_view_memorial_regular_01_managed_memorial.dart';
import 'package:facesbyplaces/API/Regular/09-Settings-Memorial/api_settings_memorial_regular_01_show_page_details.dart';
import 'package:facesbyplaces/API/Regular/09-Settings-Memorial/api_settings_memorial_regular_07_update_page_details.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loader_overlay/loader_overlay.dart';
// // ignore: import_of_legacy_library_into_null_safe
// import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:flutter/material.dart';
import 'package:dialog/dialog.dart';
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
  final GlobalKey<MiscInputFieldTemplateState> _key5 = GlobalKey<MiscInputFieldTemplateState>();
  final GlobalKey<MiscInputFieldTemplateState> _key6 = GlobalKey<MiscInputFieldTemplateState>();
  Future<APIRegularShowPageDetailsMain>? futureMemorialSettings;
  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();
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

                          MiscInputFieldTemplate(
                            key: _key6,
                            labelText: 'Cemetery',
                            displayText: memorialSettings.data!.almMemorial.showPageDetailsDetails.showPageDetailsDetailsCemetery,
                            labelTextStyle: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xffBDC3C7),),
                          ),

                          const SizedBox(height: 80,),

                          MiscButtonTemplate(
                            buttonTextStyle: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xffFFFFFF),),
                            buttonColor: const Color(0xff04ECFF),
                            buttonText: 'Update',
                            width: 150,
                            height: 50,
                            onPressed: () async{
                              if(memorialSettings.data!.almMemorial.showPageDetailsName != _key1.currentState!.controller.text || memorialSettings.data!.almMemorial.showPageDetailsRelationship != _key2.currentState!.currentSelection || memorialSettings.data!.almMemorial.showPageDetailsDetails.showPageDetailsDetailsDob != controller1.text || memorialSettings.data!.almMemorial.showPageDetailsDetails.showPageDetailsDetailsRip != controller2.text || memorialSettings.data!.almMemorial.showPageDetailsDetails.showPageDetailsDetailsCountry != _key5.currentState!.controller.text || memorialSettings.data!.almMemorial.showPageDetailsDetails.showPageDetailsDetailsCemetery != _key6.currentState!.controller.text){
                                bool confirmResult = await showDialog(context: (context), builder: (build) => const MiscConfirmDialog(title: 'Confirm', content:'Do you want to save the changes?', confirmColor_1: Color(0xff04ECFF), confirmColor_2: Color(0xffFF0000),),);

                                if(confirmResult){
                                  context.loaderOverlay.show();
                                  bool result = await apiRegularUpdatePageDetails(name: _key1.currentState!.controller.text, relationship: _key2.currentState!.currentSelection, dob: controller1.text, rip: controller2.text, country: _key5.currentState!.controller.text, cemetery: _key6.currentState!.controller.text, memorialId: widget.memorialId,);
                                  context.loaderOverlay.hide();

                                  if(result){
                                    // await showDialog(
                                    //   context: context,
                                    //   builder: (_) => AssetGiffyDialog(
                                    //     title: const Text('Success', textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontFamily: 'NexaRegular'),),
                                    //     description: const Text('Successfully updated the account details.', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular',),),
                                    //     image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                    //     entryAnimation: EntryAnimation.DEFAULT,
                                    //     onlyOkButton: true,
                                    //     onOkButtonPressed: (){
                                    //       Navigator.pop(context, true);
                                    //     },
                                    //   ),
                                    // );
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
                                    // await showDialog(
                                    //   context: context,
                                    //   builder: (_) => AssetGiffyDialog(
                                    //     title: const Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontFamily: 'NexaRegular'),),
                                    //     description: const Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular',),),
                                    //     image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                    //     entryAnimation: EntryAnimation.DEFAULT,
                                    //     buttonOkColor: const Color(0xffff0000),
                                    //     onlyOkButton: true,
                                    //     onOkButtonPressed: (){
                                    //       Navigator.pop(context, true);
                                    //     },
                                    //   ),
                                    // );
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
                return SizedBox(height: SizeConfig.screenHeight, child: Center(child: Container(child: const SpinKitThreeBounce(color: Color(0xff000000), size: 50.0,), color: const Color(0xffffffff),),),);
              }
            },
          ),
        ),
      ),
    );
  }
}