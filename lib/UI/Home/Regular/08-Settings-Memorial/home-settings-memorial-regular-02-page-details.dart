import 'package:facesbyplaces/UI/Home/Regular/02-View-Memorial/home-view-memorial-regular-01-managed-memorial.dart';
import 'package:facesbyplaces/API/Regular/09-Settings-Memorial/api-settings-memorial-regular-01-show-page-details.dart';
import 'package:facesbyplaces/API/Regular/09-Settings-Memorial/api-settings-memorial-regular-07-update-page-details.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-01-regular-input-field.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-06-regular-button.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-02-regular-dialog.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/Configurations/date-conversion.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:flutter/material.dart';

class HomeRegularPageDetails extends StatefulWidget{

  final int memorialId;
  HomeRegularPageDetails({this.memorialId});

  HomeRegularPageDetailsState createState() => HomeRegularPageDetailsState(memorialId: memorialId);
}

class HomeRegularPageDetailsState extends State<HomeRegularPageDetails>{

  final int memorialId;
  HomeRegularPageDetailsState({this.memorialId});

  final GlobalKey<MiscRegularInputFieldTemplateState> _key1 = GlobalKey<MiscRegularInputFieldTemplateState>();
  final GlobalKey<MiscRegularInputFieldDropDownState> _key2 = GlobalKey<MiscRegularInputFieldDropDownState>();
  final GlobalKey<MiscRegularInputFieldDateTimeTemplateState> _key3 = GlobalKey<MiscRegularInputFieldDateTimeTemplateState>();
  final GlobalKey<MiscRegularInputFieldDateTimeTemplateState> _key4 = GlobalKey<MiscRegularInputFieldDateTimeTemplateState>();
  final GlobalKey<MiscRegularInputFieldTemplateState> _key5 = GlobalKey<MiscRegularInputFieldTemplateState>();
  final GlobalKey<MiscRegularInputFieldTemplateState> _key6 = GlobalKey<MiscRegularInputFieldTemplateState>();

  Future futureMemorialSettings;

  void initState(){
    super.initState();
    futureMemorialSettings = getMemorialSettings(memorialId);
  }

  Future<APIRegularShowPageDetailsMain> getMemorialSettings(int memorialId) async{
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

                          MiscRegularInputFieldTemplate(key: _key1, labelText: 'Page Name', displayText: memorialSettings.data.almMemorial.showPageDetailsName),

                          SizedBox(height: 20,),

                          MiscRegularInputFieldDropDown(key: _key2, displayText: memorialSettings.data.almMemorial.showPageDetailsRelationship),

                          SizedBox(height: 20,),

                          MiscRegularInputFieldDateTimeTemplate(key: _key3, labelText: 'DOB', displayText: memorialSettings.data.almMemorial.showPageDetailsDetails.showPageDetailsDetailsDob),

                          SizedBox(height: 20,),

                          MiscRegularInputFieldDateTimeTemplate(key: _key4, labelText: 'RIP', displayText: memorialSettings.data.almMemorial.showPageDetailsDetails.showPageDetailsDetailsRip),

                          SizedBox(height: 20,),

                          MiscRegularInputFieldTemplate(key: _key5, labelText: 'Country', displayText: memorialSettings.data.almMemorial.showPageDetailsDetails.showPageDetailsDetailsCountry),

                          SizedBox(height: 20,),

                          MiscRegularInputFieldTemplate(key: _key6, labelText: 'Cemetery', displayText: memorialSettings.data.almMemorial.showPageDetailsDetails.showPageDetailsDetailsCemetery),

                          SizedBox(height: 80,),

                          MiscRegularButtonTemplate(
                            buttonText: 'Update', 
                            buttonTextStyle: TextStyle(
                              fontSize: 16, 
                              fontWeight: FontWeight.bold, 
                              color: Color(0xffffffff),
                            ),
                            onPressed: () async{

                              if(
                                memorialSettings.data.almMemorial.showPageDetailsName != _key1.currentState.controller.text ||
                                memorialSettings.data.almMemorial.showPageDetailsRelationship != _key2.currentState.currentSelection ||
                                convertDate(memorialSettings.data.almMemorial.showPageDetailsDetails.showPageDetailsDetailsDob) != convertDate(_key3.currentState.controller.text) ||
                                convertDate(memorialSettings.data.almMemorial.showPageDetailsDetails.showPageDetailsDetailsRip) != convertDate(_key4.currentState.controller.text) ||
                                memorialSettings.data.almMemorial.showPageDetailsDetails.showPageDetailsDetailsCountry !=  _key5.currentState.controller.text ||
                                memorialSettings.data.almMemorial.showPageDetailsDetails.showPageDetailsDetailsCemetery !=  _key6.currentState.controller.text
                              ){
                                bool confirmResult = await showDialog(context: (context), builder: (build) => MiscRegularConfirmDialog(title: 'Confirm', content: 'Do you want to save the changes?', confirmColor_1: Color(0xff04ECFF), confirmColor_2: Color(0xffFF0000),));

                                if(confirmResult){
                                  context.showLoaderOverlay();
                                  bool result = await apiRegularUpdatePageDetails(
                                    name: _key1.currentState.controller.text,
                                    relationship: _key2.currentState.currentSelection,
                                    dob: convertDate(_key3.currentState.controller.text),
                                    rip: convertDate(_key4.currentState.controller.text),
                                    country: _key5.currentState.controller.text,
                                    cemetery: _key6.currentState.controller.text,
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
                                        buttonOkColor: Colors.green,
                                        onOkButtonPressed: () {
                                          Navigator.pop(context, true);
                                        },
                                      )
                                    );

                                    Route route = MaterialPageRoute(builder: (context) => HomeRegularProfile(memorialId: memorialId, managed: true,));
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
                            width: 150,
                            height: 45,
                            buttonColor: Color(0xff04ECFF),
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

