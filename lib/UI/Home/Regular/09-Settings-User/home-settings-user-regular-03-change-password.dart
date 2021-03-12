import 'package:facesbyplaces/API/Regular/10-Settings-User/api-settings-user-regular-05-change-password.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-01-regular-input-field.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-06-regular-button.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'home-settings-user-regular-01-user-details.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter/material.dart';

class HomeRegularUserChangePassword extends StatefulWidget{
  final int userId;
  HomeRegularUserChangePassword({required this.userId});

  HomeRegularUserChangePasswordState createState() => HomeRegularUserChangePasswordState(userId: userId);
}

class HomeRegularUserChangePasswordState extends State<HomeRegularUserChangePassword>{
  final int userId;
  HomeRegularUserChangePasswordState({required this.userId});

  final GlobalKey<MiscRegularInputFieldTemplateState> _key1 = GlobalKey<MiscRegularInputFieldTemplateState>();
  final GlobalKey<MiscRegularInputFieldTemplateState> _key2 = GlobalKey<MiscRegularInputFieldTemplateState>();

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
            title: Text('Change Password', style: TextStyle(fontSize: 16, color: Color(0xffffffff)),),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Color(0xffffffff),), 
              onPressed: (){
                Navigator.pop(context);
              },
            ),
          ),
          body: Container(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20.0),
              physics: ClampingScrollPhysics(),
              child: Column(
                children: [

                  MiscRegularInputFieldTemplate(key: _key1, labelText: 'Current Password', obscureText: true,),

                  SizedBox(height: 20,),

                  MiscRegularInputFieldTemplate(key: _key2, labelText: 'New Password', obscureText: true,),

                  SizedBox(height: 80,),

                  MiscRegularButtonTemplate(
                    buttonText: 'Update',
                    buttonTextStyle: TextStyle(
                      fontSize: 16, 
                      fontWeight: FontWeight.bold, 
                      color: Color(0xffffffff),
                    ),
                    onPressed: () async{

                      context.showLoaderOverlay();
                      bool result = await apiRegularChangePassword(currentPassword: _key1.currentState!.controller.text, newPassword: _key2.currentState!.controller.text);
                      context.hideLoaderOverlay();

                      if(result){
                        await showOkAlertDialog(
                          context: context,
                          title: 'Success',
                          message: 'Successfully updated the password.',
                        );
                        Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularUserProfileDetails(userId: userId,)));
                      }else{
                        await showOkAlertDialog(
                          context: context,
                          title: 'Error',
                          message: 'Something went wrong. Please try again.',
                        );
                      }
                    }, 
                    width: SizeConfig.screenWidth! / 2,
                    height: 45,
                    buttonColor: Color(0xff04ECFF),
                  ),

                  SizedBox(height: 160,),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}