import 'package:facesbyplaces/API/BLM/10-Settings-User/api-settings-user-blm-01-show-account-details.dart';
import 'package:facesbyplaces/API/BLM/10-Settings-User/api-settings-user-blm-02-update-account-details.dart';
import 'package:facesbyplaces/UI/Home/BLM/09-Settings-User/home-settings-user-01-user-details.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-01-blm-input-field.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-02-blm-dialog.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-07-blm-button.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter/material.dart';

class HomeBLMUserUpdateDetails extends StatefulWidget{
  final int userId;
  HomeBLMUserUpdateDetails({this.userId});

  HomeBLMUserUpdateDetailsState createState() => HomeBLMUserUpdateDetailsState(userId: userId);
}

class HomeBLMUserUpdateDetailsState extends State<HomeBLMUserUpdateDetails>{
  final int userId;
  HomeBLMUserUpdateDetailsState({this.userId});

  final GlobalKey<MiscBLMInputFieldTemplateState> _key1 = GlobalKey<MiscBLMInputFieldTemplateState>();
  final GlobalKey<MiscBLMInputFieldTemplateState> _key2 = GlobalKey<MiscBLMInputFieldTemplateState>();
  final GlobalKey<MiscBLMInputFieldTemplateState> _key3 = GlobalKey<MiscBLMInputFieldTemplateState>();
  final GlobalKey<MiscBLMPhoneNumberTemplateState> _key4 = GlobalKey<MiscBLMPhoneNumberTemplateState>();
  // final GlobalKey<MiscBLMInputFieldTemplateState> _key5 = GlobalKey<MiscBLMInputFieldTemplateState>();
    final GlobalKey<MiscBLMInputFieldSecurityQuestionsState> _key5 = GlobalKey<MiscBLMInputFieldSecurityQuestionsState>();

  Future accountDetails;

  void initState(){
    super.initState();
    accountDetails = getAccountDetails(userId);
  }

  Future<APIBLMShowAccountDetails> getAccountDetails(int userId) async{
    return await apiBLMShowAccountDetails(userId);
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
            title: Text('Account Details', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xffffffff)),),
            centerTitle: true,
            leading: Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
          body: FutureBuilder<APIBLMShowAccountDetails>(
            future: accountDetails,
            builder: (context, details){
              if(details.hasData){
                return SingleChildScrollView(
                  physics: ClampingScrollPhysics(),
                  child: Container(
                    padding: EdgeInsets.all(20.0),
                    height: SizeConfig.screenHeight,
                    child: Column(
                      children: [

                        MiscBLMInputFieldTemplate(key: _key1, labelText: 'First Name', displayText: details.data.firstName,),

                        SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                        MiscBLMInputFieldTemplate(key: _key2, labelText: 'Last Name', displayText: details.data.lastName,),

                        SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                        MiscBLMInputFieldTemplate(key: _key3, labelText: 'Email Address', displayText: details.data.email, type: TextInputType.emailAddress,),

                        SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                        MiscBLMPhoneNumberTemplate(key: _key4, labelText: 'Mobile Number', displayText: details.data.phoneNumber, type: TextInputType.phone, labelTextStyle: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, fontWeight: FontWeight.w400, color: Colors.grey)),

                        SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                        MiscBLMInputFieldSecurityQuestions(key: _key5, displayText: details.data.question,),

                        SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                        Expanded(child: Container(),),

                        MiscBLMButtonTemplate(
                          buttonText: 'Update',
                          buttonTextStyle: TextStyle(
                            fontSize: SizeConfig.safeBlockHorizontal * 4, 
                            fontWeight: FontWeight.bold, 
                            color: Color(0xffffffff),
                          ), 
                          onPressed: () async{
                              if(
                                details.data.firstName != _key1.currentState.controller.text ||
                                details.data.lastName !=  _key2.currentState.controller.text ||
                                details.data.email != _key3.currentState.controller.text ||
                                details.data.phoneNumber != _key4.currentState.controller.text || 
                                details.data.question != _key5.currentState.currentSelection
                              ){
                                bool confirmResult = await showDialog(context: (context), builder: (build) => MiscBLMConfirmDialog(title: 'Confirm', content: 'Do you want to save the changes?', confirmColor_1: Color(0xff04ECFF), confirmColor_2: Color(0xffFF0000),));

                                if(confirmResult){

                                  context.showLoaderOverlay();
                                  bool result = await apiBLMUpdateAccountDetails(
                                    firstName: _key1.currentState.controller.text,
                                    lastName: _key2.currentState.controller.text,
                                    email: _key3.currentState.controller.text,
                                    phoneNumber: _key4.currentState.controller.text,
                                    question: _key5.currentState.currentSelection,
                                  );
                                  context.hideLoaderOverlay();

                                  if(result){
                                    await showDialog(context: (context), builder: (build) => MiscBLMAlertDialog(title: 'Success', content: 'Successfully updated the account details.', color: Colors.green,));

                                    Route route = MaterialPageRoute(builder: (context) => HomeBLMUserProfileDetails(userId: userId), settings: RouteSettings(name: '/profile-settings'));
                                    Navigator.popAndPushNamed(context, route.settings.name);
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

                        Expanded(child: Container(),),

                      ],
                    ),
                  ),
                );
              }else if(details.hasError){
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