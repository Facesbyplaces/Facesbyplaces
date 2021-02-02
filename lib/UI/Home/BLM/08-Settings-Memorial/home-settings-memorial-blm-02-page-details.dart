import 'package:facesbyplaces/UI/Home/BLM/02-View-Memorial/home-view-memorial-blm-01-managed-memorial.dart';
import 'package:facesbyplaces/API/BLM/09-Settings-Memorial/api-settings-memorial-blm-01-show-page-details.dart';
import 'package:facesbyplaces/API/BLM/09-Settings-Memorial/api-settings-memorial-blm-07-update-page-details.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-01-blm-input-field.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-02-blm-dialog.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-07-blm-button.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/Configurations/date-conversion.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter/material.dart';

class HomeBLMPageDetails extends StatefulWidget{

  final int memorialId;
  HomeBLMPageDetails({this.memorialId});

  HomeBLMPageDetailsState createState() => HomeBLMPageDetailsState(memorialId: memorialId);
}

class HomeBLMPageDetailsState extends State<HomeBLMPageDetails>{

  final int memorialId;
  HomeBLMPageDetailsState({this.memorialId});

  final GlobalKey<MiscBLMInputFieldTemplateState> _key1 = GlobalKey<MiscBLMInputFieldTemplateState>();
  final GlobalKey<MiscBLMInputFieldTemplateState> _key2 = GlobalKey<MiscBLMInputFieldTemplateState>();
  final GlobalKey<MiscBLMInputFieldDropDownState> _key3 = GlobalKey<MiscBLMInputFieldDropDownState>();
  final GlobalKey<MiscBLMInputFieldTemplateState> _key4 = GlobalKey<MiscBLMInputFieldTemplateState>();
  final GlobalKey<MiscBLMInputFieldDateTimeTemplateState> _key5 = GlobalKey<MiscBLMInputFieldDateTimeTemplateState>();
  final GlobalKey<MiscBLMInputFieldDateTimeTemplateState> _key6 = GlobalKey<MiscBLMInputFieldDateTimeTemplateState>();
  final GlobalKey<MiscBLMInputFieldTemplateState> _key7 = GlobalKey<MiscBLMInputFieldTemplateState>();
  final GlobalKey<MiscBLMInputFieldTemplateState> _key8 = GlobalKey<MiscBLMInputFieldTemplateState>();
  final GlobalKey<MiscBLMInputFieldTemplateState> _key9 = GlobalKey<MiscBLMInputFieldTemplateState>();

  Future futureMemorialSettings;

  void initState(){
    super.initState();
    futureMemorialSettings = getMemorialSettings(memorialId);
  }

  Future<APIBLMShowPageDetailsMain> getMemorialSettings(int memorialId) async{
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
          body: FutureBuilder<APIBLMShowPageDetailsMain>(
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

                          MiscBLMInputFieldTemplate(key: _key1, labelText: 'Page Name', displayText: memorialSettings.data.blmMemorial.showPageDetailsName,),

                          SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                          MiscBLMInputFieldTemplate(key: _key2, labelText: 'Description', displayText: memorialSettings.data.blmMemorial.showPageDetailsDetails.showPageDetailsDetailsDescription,),

                          SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                          MiscBLMInputFieldDropDown(key: _key3, displayText: memorialSettings.data.blmMemorial.showPageDetailsRelationship,),

                          SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                          MiscBLMInputFieldTemplate(key: _key4, labelText: 'Location', displayText: memorialSettings.data.blmMemorial.showPageDetailsDetails.showPageDetailsDetailsLocation,),

                          SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                          MiscBLMInputFieldDateTimeTemplate(key: _key5, labelText: 'DOB', displayText: memorialSettings.data.blmMemorial.showPageDetailsDetails.showPageDetailsDetailsDob,),

                          SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                          MiscBLMInputFieldDateTimeTemplate(key: _key6, labelText: 'RIP', displayText: memorialSettings.data.blmMemorial.showPageDetailsDetails.showPageDetailsDetailsRip,),

                          SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                          MiscBLMInputFieldTemplate(key: _key7, labelText: 'State', displayText: memorialSettings.data.blmMemorial.showPageDetailsDetails.showPageDetailsDetailsState,),

                          SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                          MiscBLMInputFieldTemplate(key: _key8, labelText: 'Country', displayText: memorialSettings.data.blmMemorial.showPageDetailsDetails.showPageDetailsDetailsCountry,),

                          SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                          MiscBLMInputFieldTemplate(key: _key9, labelText: 'Precinct', displayText: memorialSettings.data.blmMemorial.showPageDetailsDetails.showPageDetailsDetailsPrecinct,),

                          SizedBox(height: SizeConfig.blockSizeVertical * 10,),

                          MiscBLMButtonTemplate(
                            buttonText: 'Update', 
                            buttonTextStyle: TextStyle(
                              fontSize: SizeConfig.safeBlockHorizontal * 4, 
                              fontWeight: FontWeight.bold, 
                              color: Color(0xffffffff),
                            ),
                            onPressed: () async{

                              if(
                                memorialSettings.data.blmMemorial.showPageDetailsName != _key1.currentState.controller.text ||
                                memorialSettings.data.blmMemorial.showPageDetailsDetails.showPageDetailsDetailsDescription !=  _key2.currentState.controller.text ||
                                memorialSettings.data.blmMemorial.showPageDetailsRelationship != _key3.currentState.currentSelection ||
                                memorialSettings.data.blmMemorial.showPageDetailsDetails.showPageDetailsDetailsLocation != _key4.currentState.controller.text ||
                                convertDate(memorialSettings.data.blmMemorial.showPageDetailsDetails.showPageDetailsDetailsDob) != convertDate(_key5.currentState.controller.text) ||
                                convertDate(memorialSettings.data.blmMemorial.showPageDetailsDetails.showPageDetailsDetailsRip) != convertDate(_key6.currentState.controller.text) ||
                                memorialSettings.data.blmMemorial.showPageDetailsDetails.showPageDetailsDetailsState != _key7.currentState.controller.text ||
                                memorialSettings.data.blmMemorial.showPageDetailsDetails.showPageDetailsDetailsCountry != _key8.currentState.controller.text ||
                                memorialSettings.data.blmMemorial.showPageDetailsDetails.showPageDetailsDetailsPrecinct != _key9.currentState.controller.text
                              ){
                                bool confirmResult = await showDialog(context: (context), builder: (build) => MiscBLMConfirmDialog(title: 'Confirm', content: 'Do you want to save the changes?', confirmColor_1: Color(0xff04ECFF), confirmColor_2: Color(0xffFF0000),));

                                if(confirmResult){
                                  context.showLoaderOverlay();

                                  bool result = await apiBLMUpdatePageDetails(
                                    memorialId: memorialId,
                                    name: _key1.currentState.controller.text,
                                    description: _key2.currentState.controller.text,
                                    relationship: _key3.currentState.currentSelection,
                                    location: _key4.currentState.controller.text ,
                                    dob: convertDate(_key5.currentState.controller.text),
                                    rip: convertDate(_key6.currentState.controller.text),
                                    state: _key7.currentState.controller.text,
                                    country: _key8.currentState.controller.text,
                                    precinct: _key9.currentState.controller.text,
                                  );

                                  context.hideLoaderOverlay();

                                  if(result){
                                    await showDialog(context: (context), builder: (build) => MiscBLMAlertDialog(title: 'Success', content: 'Successfully updated the account details.', color: Colors.green,));

                                    Route route = MaterialPageRoute(builder: (context) => HomeBLMProfile(memorialId: memorialId, managed: true,));
                                    Navigator.of(context).pushAndRemoveUntil(route, ModalRoute.withName('/home/blm'));
                                    
                                  }else{
                                    await showDialog(context: (context), builder: (build) => MiscBLMAlertDialog(title: 'Error', content: 'Something went wrong. Please try again.'));
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