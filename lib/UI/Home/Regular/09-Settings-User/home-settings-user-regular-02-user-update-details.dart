import 'package:facesbyplaces/API/Regular/10-Settings-User/api-settings-user-regular-04-update-account-details.dart';
import 'package:facesbyplaces/API/Regular/10-Settings-User/api-settings-user-regular-01-show-account-details.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-01-regular-input-field.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-06-regular-button.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-02-regular-dialog.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'home-settings-user-regular-01-user-details.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:flutter/material.dart';

class HomeRegularUserUpdateDetails extends StatefulWidget{
  final int userId;
  HomeRegularUserUpdateDetails({required this.userId});

  HomeRegularUserUpdateDetailsState createState() => HomeRegularUserUpdateDetailsState(userId: userId);
}

class HomeRegularUserUpdateDetailsState extends State<HomeRegularUserUpdateDetails>{
  final int userId;
  HomeRegularUserUpdateDetailsState({required this.userId});

  final GlobalKey<MiscRegularInputFieldTemplateState> _key1 = GlobalKey<MiscRegularInputFieldTemplateState>();
  final GlobalKey<MiscRegularInputFieldTemplateState> _key2 = GlobalKey<MiscRegularInputFieldTemplateState>();
  final GlobalKey<MiscRegularInputFieldTemplateState> _key3 = GlobalKey<MiscRegularInputFieldTemplateState>();
  final GlobalKey<MiscRegularPhoneNumberTemplateState> _key4 = GlobalKey<MiscRegularPhoneNumberTemplateState>();
  final GlobalKey<MiscRegularInputFieldSecurityQuestionsState> _key5 = GlobalKey<MiscRegularInputFieldSecurityQuestionsState>();

  Future<APIRegularShowAccountDetails>? accountDetails;

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
            title: Text('Account Details', style: TextStyle(fontSize: 16, color: Color(0xffffffff)),),
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
                  padding: EdgeInsets.all(20),
                  physics: ClampingScrollPhysics(),
                  child: Column(
                    children: [

                      MiscRegularInputFieldTemplate(key: _key1, labelText: 'First Name', displayText: details.data!.showAccountDetailsFirstName,),

                      SizedBox(height: 20,),

                      MiscRegularInputFieldTemplate(key: _key2, labelText: 'Last Name', displayText: details.data!.showAccountDetailsLastName,),

                      SizedBox(height: 20,),

                      MiscRegularInputFieldTemplate(key: _key3, labelText: 'Email Address', displayText: details.data!.showAccountDetailsEmail, type: TextInputType.emailAddress,),

                      SizedBox(height: 20,),

                      MiscRegularPhoneNumberTemplate(key: _key4, labelText: 'Phone Number', displayText: details.data!.showAccountDetailsPhoneNumber,),

                      SizedBox(height: 20,),

                      MiscRegularInputFieldSecurityQuestions(key: _key5, displayText: details.data!.showAccountDetailsQuestion != '' ? details.data!.showAccountDetailsQuestion : 'What\'s the name of your first dog?',),

                      SizedBox(height: 80,),

                      MiscRegularButtonTemplate(
                        buttonText: 'Update',
                        buttonTextStyle: TextStyle(
                          fontSize: 16, 
                          fontWeight: FontWeight.bold, 
                          color: Color(0xffffffff),
                        ),
                        width: SizeConfig.screenWidth! / 2,
                        height: 45,
                        buttonColor: Color(0xff04ECFF),
                        onPressed: () async{

                          if(
                            details.data!.showAccountDetailsFirstName != _key1.currentState!.controller.text ||
                            details.data!.showAccountDetailsLastName !=  _key2.currentState!.controller.text ||
                            details.data!.showAccountDetailsEmail != _key3.currentState!.controller.text ||
                            details.data!.showAccountDetailsPhoneNumber != _key4.currentState!.controller.text ||
                            details.data!.showAccountDetailsQuestion != _key5.currentState!.currentSelection
                          ){
                            bool confirmResult = await showDialog(context: (context), builder: (build) => MiscRegularConfirmDialog(title: 'Confirm', content: 'Do you want to save the changes?', confirmColor_1: Color(0xff04ECFF), confirmColor_2: Color(0xffFF0000),));

                            if(confirmResult){

                              context.loaderOverlay.show();
                              bool result = await apiRegularUpdateAccountDetails(
                                firstName: _key1.currentState!.controller.text,
                                lastName: _key2.currentState!.controller.text,
                                email: _key3.currentState!.controller.text,
                                phoneNumber: _key4.currentState!.controller.text,
                                question: _key5.currentState!.currentSelection
                              );
                              context.loaderOverlay.hide();

                              if(result){
                                await showDialog(
                                  context: context,
                                  builder: (_) => 
                                    AssetGiffyDialog(
                                    image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                    title: Text('Success', textAlign: TextAlign.center, style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                                    entryAnimation: EntryAnimation.DEFAULT,
                                    description: Text('Successfully updated the profile picture.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(),
                                    ),
                                    onlyOkButton: true,
                                    onOkButtonPressed: () {
                                      Navigator.pop(context, true);
                                    },
                                  )
                                );
                                Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularUserProfileDetails(userId: userId,)));
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

                      SizedBox(height: 20,),

                    ],
                  ),
                );
              }else if(details.hasError){
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