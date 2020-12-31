import 'package:facesbyplaces/UI/Home/Regular/02-View-Memorial/home-view-memorial-regular-01-managed-memorial.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-06-regular-input-field.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-07-regular-button.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-08-regular-dialog.dart';
import 'package:facesbyplaces/API/Regular/09-Settings-Memorial/api-settings-memorial-regular-05-show-page-details.dart';
import 'package:facesbyplaces/API/Regular/09-Settings-Memorial/api-settings-memorial-regular-06-update-page-details.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/Configurations/date-conversion.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loader_overlay/loader_overlay.dart';
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
    return await apiRegularShowPageDetails(memorialId);
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
            title: Text('Memorial Settings', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xffffffff)),),
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

                          MiscRegularInputFieldTemplate(key: _key1, labelText: 'Page Name', displayText: memorialSettings.data.memorial.name),

                          SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                          MiscRegularInputFieldDropDown(key: _key2, displayText: memorialSettings.data.memorial.relationship),

                          SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                          MiscRegularInputFieldDateTimeTemplate(key: _key3, labelText: 'DOB', displayText: memorialSettings.data.memorial.details.dob),

                          SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                          MiscRegularInputFieldDateTimeTemplate(key: _key4, labelText: 'RIP', displayText: memorialSettings.data.memorial.details.rip),

                          SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                          MiscRegularInputFieldTemplate(key: _key5, labelText: 'Country', displayText: memorialSettings.data.memorial.details.country),

                          SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                          MiscRegularInputFieldTemplate(key: _key6, labelText: 'Cemetery', displayText: memorialSettings.data.memorial.details.cemetery),

                          SizedBox(height: SizeConfig.blockSizeVertical * 10,),

                          MiscRegularButtonTemplate(
                            buttonText: 'Update', 
                            buttonTextStyle: TextStyle(
                              fontSize: SizeConfig.safeBlockHorizontal * 4, 
                              fontWeight: FontWeight.bold, 
                              color: Color(0xffffffff),
                            ),
                            onPressed: () async{

                              if(
                                memorialSettings.data.memorial.name != _key1.currentState.controller.text ||
                                memorialSettings.data.memorial.relationship != _key2.currentState.currentSelection ||
                                convertDate(memorialSettings.data.memorial.details.dob) != convertDate(_key3.currentState.controller.text) ||
                                convertDate(memorialSettings.data.memorial.details.rip) != convertDate(_key4.currentState.controller.text) ||
                                memorialSettings.data.memorial.details.country !=  _key5.currentState.controller.text ||
                                memorialSettings.data.memorial.details.cemetery !=  _key6.currentState.controller.text
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
                                  );

                                  context.hideLoaderOverlay();

                                  if(result){

                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (context) => HomeRegularProfile(memorialId: memorialId,), settings: RouteSettings(name: 'newRoute')),
                                    );

                                    Navigator.popUntil(context, ModalRoute.withName('newRoute'));
                                  }else{
                                    await showDialog(context: (context), builder: (build) => MiscRegularAlertDialog(title: 'Error', content: 'Something went wrong. Please try again.'));
                                  }
                                }
                              }

                            }, 
                            width: SizeConfig.screenWidth / 2, 
                            height: SizeConfig.blockSizeVertical * 7, 
                            buttonColor: Color(0xff04ECFF),
                          ),

                        ],
                      ),
                    ),
                  ],
                );
              }else if(memorialSettings.hasError){
                return Container(height: SizeConfig.screenHeight, child: Center(child: Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),),));
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

