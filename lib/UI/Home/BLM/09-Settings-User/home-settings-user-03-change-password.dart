import 'package:facesbyplaces/API/BLM/10-Settings-User/api-settings-user-blm-03-change-password.dart';
import 'package:facesbyplaces/UI/Home/BLM/09-Settings-User/home-settings-user-01-user-details.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-01-blm-input-field.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-02-blm-dialog.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-07-blm-button.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter/material.dart';

class HomeBLMUserChangePassword extends StatefulWidget{
  final int userId;
  HomeBLMUserChangePassword({this.userId});

  HomeBLMUserChangePasswordState createState() => HomeBLMUserChangePasswordState(userId: userId);
}

class HomeBLMUserChangePasswordState extends State<HomeBLMUserChangePassword>{
  final int userId;
  HomeBLMUserChangePasswordState({this.userId});

  final GlobalKey<MiscBLMInputFieldTemplateState> _key1 = GlobalKey<MiscBLMInputFieldTemplateState>();
  final GlobalKey<MiscBLMInputFieldTemplateState> _key2 = GlobalKey<MiscBLMInputFieldTemplateState>();

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

                  MiscBLMInputFieldTemplate(key: _key1, labelText: 'Current Password', obscureText: true,),

                  SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                  MiscBLMInputFieldTemplate(key: _key2, labelText: 'New Password', obscureText: true,),

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

                      context.showLoaderOverlay();
                      bool result = await apiBLMChangePassword(currentPassword: _key1.currentState.controller.text, newPassword: _key2.currentState.controller.text);
                      context.hideLoaderOverlay();

                      if(result){
                        await showDialog(context: (context), builder: (build) => MiscBLMAlertDialog(title: 'Success', content: 'Successfully updated the password.', color: Colors.green,));

                        Route route = MaterialPageRoute(builder: (context) => HomeBLMUserProfileDetails(userId: userId), settings: RouteSettings(name: '/profile-settings'));
                        Navigator.popAndPushNamed(context, route.settings.name);
                      }else{
                        await showDialog(context: (context), builder: (build) => MiscBLMAlertDialog(title: 'Error', content: 'Something went wrong. Please try again.'));
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