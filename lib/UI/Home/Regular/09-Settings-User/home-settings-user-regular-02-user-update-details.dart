import 'package:facesbyplaces/API/Regular/10-Settings-User/api-settings-user-regular-04-update-account-details.dart';
import 'package:facesbyplaces/API/Regular/10-Settings-User/api-settings-user-regular-01-show-account-details.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-01-regular-input-field.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-07-regular-button.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-02-regular-dialog.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'home-settings-user-regular-01-user-details.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter/material.dart';

class HomeRegularUserUpdateDetails extends StatefulWidget{
  final int userId;
  HomeRegularUserUpdateDetails({this.userId});

  HomeRegularUserUpdateDetailsState createState() => HomeRegularUserUpdateDetailsState(userId: userId);
}

class HomeRegularUserUpdateDetailsState extends State<HomeRegularUserUpdateDetails>{
  final int userId;
  HomeRegularUserUpdateDetailsState({this.userId});

  final GlobalKey<MiscRegularInputFieldTemplateState> _key1 = GlobalKey<MiscRegularInputFieldTemplateState>();
  final GlobalKey<MiscRegularInputFieldTemplateState> _key2 = GlobalKey<MiscRegularInputFieldTemplateState>();
  final GlobalKey<MiscRegularInputFieldTemplateState> _key3 = GlobalKey<MiscRegularInputFieldTemplateState>();
  final GlobalKey<MiscRegularPhoneNumberTemplateState> _key4 = GlobalKey<MiscRegularPhoneNumberTemplateState>();
  final GlobalKey<MiscRegularInputFieldSecurityQuestionsState> _key5 = GlobalKey<MiscRegularInputFieldSecurityQuestionsState>();

  Future accountDetails;

  void initState(){
    super.initState();
    accountDetails = getAccountDetails(userId);
  }

  Future<APIRegularShowAccountDetails> getAccountDetails(int userId) async{
    return await apiRegularShowAccountDetails(userId: userId);
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
          body: FutureBuilder<APIRegularShowAccountDetails>(
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

                        MiscRegularInputFieldTemplate(key: _key1, labelText: 'First Name', displayText: details.data.showAccountDetailsFirstName,),

                        SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                        MiscRegularInputFieldTemplate(key: _key2, labelText: 'Last Name', displayText: details.data.showAccountDetailsLastName,),

                        SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                        MiscRegularInputFieldTemplate(key: _key3, labelText: 'Email Address', displayText: details.data.showAccountDetailsEmail, type: TextInputType.emailAddress,),

                        SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                        MiscRegularPhoneNumberTemplate(key: _key4, labelText: 'Mobile Number', displayText: details.data.showAccountDetailsPhoneNumber, type: TextInputType.phone, labelTextStyle: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, fontWeight: FontWeight.w400, color: Colors.grey)),

                        SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                        MiscRegularInputFieldSecurityQuestions(key: _key5, displayText: details.data.showAccountDetailsQuestion,),

                        SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                        Expanded(child: Container(),),

                        MiscRegularButtonTemplate(
                          buttonText: 'Update',
                          buttonTextStyle: TextStyle(
                            fontSize: SizeConfig.safeBlockHorizontal * 4, 
                            fontWeight: FontWeight.bold, 
                            color: Color(0xffffffff),
                          ), 
                          onPressed: () async{
                              if(
                                details.data.showAccountDetailsFirstName != _key1.currentState.controller.text ||
                                details.data.showAccountDetailsLastName !=  _key2.currentState.controller.text ||
                                details.data.showAccountDetailsEmail != _key3.currentState.controller.text ||
                                details.data.showAccountDetailsPhoneNumber != _key4.currentState.controller.text ||
                                details.data.showAccountDetailsQuestion != _key5.currentState.currentSelection
                              ){
                                bool confirmResult = await showDialog(context: (context), builder: (build) => MiscRegularConfirmDialog(title: 'Confirm', content: 'Do you want to save the changes?', confirmColor_1: Color(0xff04ECFF), confirmColor_2: Color(0xffFF0000),));

                                if(confirmResult){

                                  context.showLoaderOverlay();
                                  bool result = await apiRegularUpdateAccountDetails(
                                    firstName: _key1.currentState.controller.text,
                                    lastName: _key2.currentState.controller.text,
                                    email: _key3.currentState.controller.text,
                                    phoneNumber: _key4.currentState.controller.text,
                                    question: _key5.currentState.currentSelection
                                  );
                                  context.hideLoaderOverlay();

                                  if(result){
                                    await showDialog(context: (context), builder: (build) => MiscRegularAlertDialog(title: 'Success', content: 'Successfully updated the account details.', color: Colors.green,));
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularUserProfileDetails(userId: userId,)));
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