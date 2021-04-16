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
  HomeRegularPageDetails({required this.memorialId});

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
            backgroundColor: Color(0xff04ECFF),
            title: Text('Memorial Settings', style: TextStyle(fontSize: 16, color: Color(0xffffffff)),),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Color(0xffffffff),), 
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
                      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                      child: ListView(
                        physics: ClampingScrollPhysics(),
                        children: [

                          MiscRegularInputFieldTemplate(key: _key1, labelText: 'Page Name', displayText: memorialSettings.data!.almMemorial.showPageDetailsName),

                          SizedBox(height: 20,),

                          MiscRegularInputFieldDropDown(key: _key2, displayText: memorialSettings.data!.almMemorial.showPageDetailsRelationship),

                          SizedBox(height: 20,),

                          DateTimePicker(
                            type: DateTimePickerType.date,
                            controller: controller1,
                            cursorColor: Color(0xff000000),
                            firstDate: DateTime(1000),
                            lastDate: DateTime.now(),
                            decoration: InputDecoration(
                              alignLabelWithHint: true,
                              labelText: 'DOB',
                              labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey,),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xff000000),
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

                          SizedBox(height: 20,),

                          DateTimePicker(
                            type: DateTimePickerType.date,
                            controller: controller2,
                            cursorColor: Color(0xff000000),
                            firstDate: DateTime(1000),
                            lastDate: DateTime.now(),
                            decoration: InputDecoration(
                              alignLabelWithHint: true,
                              labelText: 'RIP',
                              labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey,),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xff000000),
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

                          SizedBox(height: 20,),

                          MiscRegularInputFieldTemplate(key: _key5, labelText: 'Country', displayText: memorialSettings.data!.almMemorial.showPageDetailsDetails.showPageDetailsDetailsCountry),

                          SizedBox(height: 20,),

                          MiscRegularInputFieldTemplate(key: _key6, labelText: 'Cemetery', displayText: memorialSettings.data!.almMemorial.showPageDetailsDetails.showPageDetailsDetailsCemetery),

                          SizedBox(height: 80,),

                          MiscRegularButtonTemplate(
                            buttonText: 'Update', 
                            buttonTextStyle: TextStyle(
                              fontSize: 16, 
                              fontWeight: FontWeight.bold, 
                              color: Color(0xffffffff),
                            ),
                            width: 150,
                            height: 45,
                            buttonColor: Color(0xff04ECFF),
                            onPressed: () async{

                              if(
                                memorialSettings.data!.almMemorial.showPageDetailsName != _key1.currentState!.controller.text ||
                                memorialSettings.data!.almMemorial.showPageDetailsRelationship != _key2.currentState!.currentSelection ||
                                memorialSettings.data!.almMemorial.showPageDetailsDetails.showPageDetailsDetailsDob != controller1.text ||
                                memorialSettings.data!.almMemorial.showPageDetailsDetails.showPageDetailsDetailsRip != controller2.text ||
                                memorialSettings.data!.almMemorial.showPageDetailsDetails.showPageDetailsDetailsCountry !=  _key5.currentState!.controller.text ||
                                memorialSettings.data!.almMemorial.showPageDetailsDetails.showPageDetailsDetailsCemetery !=  _key6.currentState!.controller.text
                              ){
                                bool confirmResult = await showDialog(context: (context), builder: (build) => MiscRegularConfirmDialog(title: 'Confirm', content: 'Do you want to save the changes?', confirmColor_1: Color(0xff04ECFF), confirmColor_2: Color(0xffFF0000),));

                                if(confirmResult){
                                  context.showLoaderOverlay();
                                  bool result = await apiRegularUpdatePageDetails(
                                    name: _key1.currentState!.controller.text,
                                    relationship: _key2.currentState!.currentSelection,
                                    dob: controller1.text,
                                    rip: controller2.text,
                                    country: _key5.currentState!.controller.text,
                                    cemetery: _key6.currentState!.controller.text,
                                    memorialId: memorialId,
                                  );
                                  context.hideLoaderOverlay();

                                  if(result){
                                    await showDialog(
                                      context: context,
                                      builder: (_) => 
                                        AssetGiffyDialog(
                                        image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                        title: Text('Success', textAlign: TextAlign.center, style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                                        entryAnimation: EntryAnimation.DEFAULT,
                                        description: Text('Successfully updated the account details.',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(),
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
                                        title: Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                                        entryAnimation: EntryAnimation.DEFAULT,
                                        description: Text('Something went wrong. Please try again.',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(),
                                        ),
                                        onlyOkButton: true,
                                        buttonOkColor: Colors.red,
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
                return Container(height: SizeConfig.screenHeight, child: Center(child: Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: Color(0xff000000),),),));
              }else{
                return Container(height: SizeConfig.screenHeight, child: Center(child: Container(child: SpinKitThreeBounce(color: Color(0xff000000), size: 50.0,), color: Color(0xffffffff),),),);
              }
            },
          ),
        ),
      ),
    );
  }
}
