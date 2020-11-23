import 'package:facesbyplaces/API/BLM/api-11-blm-show-page-details.dart';
import 'package:facesbyplaces/API/BLM/api-13-blm-update-page-details.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-01-blm-input-field.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-02-blm-dialog.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-07-blm-button.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-12-blm-appbar.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/Bloc/bloc-01-bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class HomeBLMPageDetails extends StatefulWidget{

  HomeBLMPageDetailsState createState() => HomeBLMPageDetailsState();
}

class HomeBLMPageDetailsState extends State<HomeBLMPageDetails>{


  final GlobalKey<MiscBLMInputFieldTemplateState> _key1 = GlobalKey<MiscBLMInputFieldTemplateState>();
  final GlobalKey<MiscBLMInputFieldTemplateState> _key2 = GlobalKey<MiscBLMInputFieldTemplateState>();
  final GlobalKey<MiscBLMInputFieldDropDownState> _key3 = GlobalKey<MiscBLMInputFieldDropDownState>();
  final GlobalKey<MiscBLMInputFieldTemplateState> _key4 = GlobalKey<MiscBLMInputFieldTemplateState>();
  final GlobalKey<MiscBLMInputFieldDateTimeTemplateState> _key5 = GlobalKey<MiscBLMInputFieldDateTimeTemplateState>();
  final GlobalKey<MiscBLMInputFieldDateTimeTemplateState> _key6 = GlobalKey<MiscBLMInputFieldDateTimeTemplateState>();
  final GlobalKey<MiscBLMInputFieldTemplateState> _key7 = GlobalKey<MiscBLMInputFieldTemplateState>();
  final GlobalKey<MiscBLMInputFieldTemplateState> _key8 = GlobalKey<MiscBLMInputFieldTemplateState>();
  final GlobalKey<MiscBLMInputFieldTemplateState> _key9 = GlobalKey<MiscBLMInputFieldTemplateState>();

  String convertDate(String input){
    DateTime dateTime = DateTime.parse(input);

    final y = dateTime.year.toString().padLeft(4, '0');
    final m = dateTime.month.toString().padLeft(2, '0');
    final d = dateTime.day.toString().padLeft(2, '0');
    return '$d/$m/$y';
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
        child: MultiBlocProvider(
          providers: [
            BlocProvider<BlocShowLoading>(create: (context) => BlocShowLoading(),)
          ],
          child: BlocBuilder<BlocShowLoading, bool>(
            builder: (context, loading){
              return Scaffold(
                appBar: MiscBLMAppBarTemplate(
                  appBar: AppBar(), 
                  title: Text('Memorial Settings', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xffffffff)),),
                  leadingAction: (){Navigator.pop(context);},
                  actions: [
                    GestureDetector(
                      onTap: (){
                        Navigator.pushNamed(context, '/home/blm/home-09-blm-memorial-settings');
                      },
                      child: Padding(
                        padding: EdgeInsets.only(right: 20.0), 
                        child: Center(
                          child: Icon(
                            Icons.check,
                            color: Color(0xffffffff),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                body: FutureBuilder<APIBLMShowPageDetailsMain>(
                  future: apiBLMShowPageDetails(),
                  builder: (context, memorialSettings){
                    if(memorialSettings.hasData){
                      return Stack(
                        children: [

                          Container(
                            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                            child: ListView(
                              physics: ClampingScrollPhysics(),
                              children: [

                                MiscBLMInputFieldTemplate(key: _key1, labelText: 'Page Name', displayText: memorialSettings.data.memorial.name,),

                                SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                                MiscBLMInputFieldTemplate(key: _key2, labelText: 'Description', displayText: memorialSettings.data.memorial.details.description,),

                                SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                                MiscBLMInputFieldDropDown(key: _key3, displayText: memorialSettings.data.memorial.relationship,),

                                SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                                MiscBLMInputFieldTemplate(key: _key4, labelText: 'Location', displayText: memorialSettings.data.memorial.details.location,),

                                SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                                MiscBLMInputFieldDateTimeTemplate(key: _key5, labelText: 'DOB', displayText: memorialSettings.data.memorial.details.dob,),

                                SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                                MiscBLMInputFieldDateTimeTemplate(key: _key6, labelText: 'RIP', displayText: memorialSettings.data.memorial.details.rip,),

                                SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                                MiscBLMInputFieldTemplate(key: _key7, labelText: 'State', displayText: memorialSettings.data.memorial.details.state,),

                                SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                                MiscBLMInputFieldTemplate(key: _key8, labelText: 'Country', displayText: memorialSettings.data.memorial.details.country,),

                                SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                                MiscBLMInputFieldTemplate(key: _key9, labelText: 'Precinct', displayText: memorialSettings.data.memorial.details.precinct,),

                                SizedBox(height: SizeConfig.blockSizeVertical * 10,),

                                MiscBLMButtonTemplate(
                                  buttonText: 'Update', 
                                  buttonTextStyle: TextStyle(
                                    fontSize: SizeConfig.safeBlockHorizontal * 4, 
                                    fontWeight: FontWeight.bold, 
                                    color: Color(0xffffffff),
                                  ),
                                  onPressed: () async{

                                    // bool confirmResult;

                                    if(
                                      memorialSettings.data.memorial.name != _key1.currentState.controller.text ||
                                      memorialSettings.data.memorial.details.description !=  _key2.currentState.controller.text ||
                                      memorialSettings.data.memorial.relationship != _key3.currentState.currentSelection ||
                                      memorialSettings.data.memorial.details.location != _key4.currentState.controller.text ||
                                      convertDate(memorialSettings.data.memorial.details.dob) != convertDate(_key5.currentState.controller.text) ||
                                      convertDate(memorialSettings.data.memorial.details.rip) != convertDate(_key6.currentState.controller.text) ||
                                      memorialSettings.data.memorial.details.state != _key7.currentState.controller.text ||
                                      memorialSettings.data.memorial.details.country != _key8.currentState.controller.text ||
                                      memorialSettings.data.memorial.details.precinct != _key9.currentState.controller.text
                                    ){
                                      bool confirmResult = await showDialog(context: (context), builder: (build) => MiscBLMConfirmDialog(title: 'Confirm', content: 'Do you want to save the changes?', confirmColor_1: Color(0xff04ECFF), confirmColor_2: Color(0xffFF0000),));

                                      if(confirmResult){
                                        context.bloc<BlocShowLoading>().modify(true);

                                        bool result = await apiBLMUpdatePageDetails(
                                          name: _key1.currentState.controller.text,
                                          description: _key2.currentState.controller.text,
                                          location: _key4.currentState.controller.text ,
                                          dob: convertDate(_key5.currentState.controller.text),
                                          rip: convertDate(_key6.currentState.controller.text),
                                          state: _key7.currentState.controller.text,
                                          country: _key8.currentState.controller.text,
                                          precinct: _key9.currentState.controller.text,
                                        );
                                        
                                        context.bloc<BlocShowLoading>().modify(false);

                                        if(result){
                                          Navigator.popUntil(context, ModalRoute.withName('/home/blm/home-09-blm-memorial-settings'));
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
              );
            }
          ),
        ),
      ),
    );
  }
}