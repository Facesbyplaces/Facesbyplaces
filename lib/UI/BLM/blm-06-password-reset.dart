// import 'package:facesbyplaces/API/Regular/10-Settings-User/api-settings-user-regular-03-change-password.dart';
// import 'package:facesbyplaces/UI/Home/Regular/09-Settings-User/home-settings-user-regular-01-user-details.dart';
import 'package:facesbyplaces/API/BLM/01-Start/api-start-blm-09-password-change.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-02-blm-dialog.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-06-regular-input-field.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-07-regular-button.dart';
// import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-08-regular-dialog.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter/material.dart';

class BLMPasswordReset extends StatefulWidget{
  final String resetToken;
  BLMPasswordReset({this.resetToken});

  BLMPasswordResetState createState() => BLMPasswordResetState();
}

class BLMPasswordResetState extends State<BLMPasswordReset>{
  final String resetToken;
  BLMPasswordResetState({this.resetToken});

  final GlobalKey<MiscRegularInputFieldTemplateState> _key1 = GlobalKey<MiscRegularInputFieldTemplateState>();
  final GlobalKey<MiscRegularInputFieldTemplateState> _key2 = GlobalKey<MiscRegularInputFieldTemplateState>();

  @override
  void initState(){
    super.initState();
    FlutterBranchSdk.logout();
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
            title: Text('Reset Password', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xffffffff)),),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Color(0xffffffff),), 
              onPressed: (){
                Navigator.pop(context);
              },
            ),
          ),
          body: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Container(
              padding: EdgeInsets.all(20.0),
              height: SizeConfig.screenHeight,
              child: Column(
                children: [

                  MiscRegularInputFieldTemplate(key: _key1, labelText: 'New Password', obscureText: true,),

                  SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                  MiscRegularInputFieldTemplate(key: _key2, labelText: 'Reenter New Password', obscureText: true,),

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


                      if(_key1.currentState.controller.text == _key2.currentState.controller.text){
                        context.showLoaderOverlay();
                        bool result = await apiBLMPasswordChange(
                          password: _key1.currentState.controller.text, 
                          passwordConfirmation: _key2.currentState.controller.text,
                          resetToken: resetToken,
                          // resetToken: 'hmvZH4U6XeA6S7pKTqRP',
                        );
                        context.hideLoaderOverlay();

                        if(result){
                          await showDialog(context: (context), builder: (build) => MiscBLMAlertDialog(title: 'Success', content: 'Successfully updated the password.', color: Colors.green,));
                          Navigator.pushReplacementNamed(context, '/home/regular');
                        }else{
                          await showDialog(context: (context), builder: (build) => MiscBLMAlertDialog(title: 'Error', content: 'Something went wrong. Please try again.'));
                        }
                      }

                      // if(_key1.currentState.controller.text == _key2.currentState.controller.text){
                      //   context.showLoaderOverlay();
                      //   bool result = await apiRegularChangePassword(currentPassword: _key1.currentState.controller.text, newPassword: _key2.currentState.controller.text);
                      //   context.hideLoaderOverlay();

                      //   if(result){
                      //     await showDialog(context: (context), builder: (build) => MiscRegularAlertDialog(title: 'Success', content: 'Successfully updated the password.', color: Colors.green,));
                      //     Navigator.pushReplacementNamed(context, '/home/regular');
                      //   }else{
                      //     await showDialog(context: (context), builder: (build) => MiscRegularAlertDialog(title: 'Error', content: 'Something went wrong. Please try again.'));
                      //   }
                      // }

                      // context.showLoaderOverlay();
                      // bool result = await apiRegularChangePassword(currentPassword: _key1.currentState.controller.text, newPassword: _key2.currentState.controller.text);
                      // context.hideLoaderOverlay();

                      // if(result){
                      //   await showDialog(context: (context), builder: (build) => MiscRegularAlertDialog(title: 'Success', content: 'Successfully updated the password.', color: Colors.green,));

                      //   // Route route = MaterialPageRoute(builder: (context) => HomeRegularUserProfileDetails(userId: userId), settings: RouteSettings(name: '/profile-settings'));
                      //   // Navigator.popAndPushNamed(context, route.settings.name);
                      //   Navigator.popAndPushNamed(context, '/home/regular/profile-settings');
                      // }else{
                      //   await showDialog(context: (context), builder: (build) => MiscRegularAlertDialog(title: 'Error', content: 'Something went wrong. Please try again.'));
                      // }
                    }, 
                    width: SizeConfig.screenWidth / 2, 
                    height: SizeConfig.blockSizeVertical * 7, 
                    buttonColor: Color(0xff04ECFF),
                  ),

                  SizedBox(height: SizeConfig.blockSizeVertical * 20,),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}