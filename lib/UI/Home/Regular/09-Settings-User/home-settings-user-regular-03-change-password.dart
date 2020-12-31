import 'package:facesbyplaces/API/Regular/10-Settings-User/api-settings-user-regular-03-change-password.dart';
import 'package:facesbyplaces/UI/Home/Regular/09-Settings-User/home-settings-user-regular-01-user-details.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-06-regular-input-field.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-07-regular-button.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-08-regular-dialog.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter/material.dart';

class HomeRegularUserChangePassword extends StatefulWidget{
  final int userId;
  HomeRegularUserChangePassword({this.userId});

  HomeRegularUserChangePasswordState createState() => HomeRegularUserChangePasswordState(userId: userId);
}

class HomeRegularUserChangePasswordState extends State<HomeRegularUserChangePassword>{
  final int userId;
  HomeRegularUserChangePasswordState({this.userId});

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
            title: Text('Change Password', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xffffffff)),),
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

                  MiscRegularInputFieldTemplate(key: _key1, labelText: 'Current Password', obscureText: true,),

                  SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                  MiscRegularInputFieldTemplate(key: _key2, labelText: 'New Password', obscureText: true,),

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

                      context.showLoaderOverlay();
                      bool result = await apiRegularChangePassword(currentPassword: _key1.currentState.controller.text, newPassword: _key2.currentState.controller.text);
                      context.hideLoaderOverlay();

                      if(result){

                        // Navigator.pushReplacement(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => HomeRegularUserProfileDetails(userId: userId,), settings: RouteSettings(name: 'newRoute')),
                        // );

                        // Navigator.popUntil(context, ModalRoute.withName('newRoute'));

                        Route route = MaterialPageRoute(builder: (context) => HomeRegularUserProfileDetails(userId: userId), settings: RouteSettings(name: '/profile-settings'));
                        Navigator.popAndPushNamed(context, route.settings.name);
                      }else{
                        await showDialog(context: (context), builder: (build) => MiscRegularAlertDialog(title: 'Error', content: 'Something went wrong. Please try again.'));
                      }
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