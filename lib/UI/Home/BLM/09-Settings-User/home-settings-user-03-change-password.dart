import 'package:facesbyplaces/API/BLM/10-Settings-User/api-settings-user-blm-05-change-password.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-01-blm-input-field.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-06-blm-button.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'home-settings-user-01-user-details.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:flutter/material.dart';

class HomeBLMUserChangePassword extends StatefulWidget{
  final int userId;
  HomeBLMUserChangePassword({required this.userId});

  HomeBLMUserChangePasswordState createState() => HomeBLMUserChangePasswordState(userId: userId);
}

class HomeBLMUserChangePasswordState extends State<HomeBLMUserChangePassword>{
  final int userId;
  HomeBLMUserChangePasswordState({required this.userId});

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
            title: Text('Change Password', style: TextStyle(fontSize: 16, color: Color(0xffffffff)),),
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
            padding: EdgeInsets.all(20.0),
            child: Column(
              children: [

                MiscBLMInputFieldTemplate(key: _key1, labelText: 'Current Password', obscureText: true,),

                SizedBox(height: 20,),

                MiscBLMInputFieldTemplate(key: _key2, labelText: 'New Password', obscureText: true,),

                SizedBox(height: 80,),

                MiscBLMButtonTemplate(
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

                    context.showLoaderOverlay();
                    bool result = await apiBLMChangePassword(currentPassword: _key1.currentState!.controller.text, newPassword: _key2.currentState!.controller.text);
                    context.hideLoaderOverlay();

                    if(result){
                      await showDialog(
                        context: context,
                        builder: (_) => 
                          AssetGiffyDialog(
                          image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                          title: Text('Success', textAlign: TextAlign.center, style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                          entryAnimation: EntryAnimation.DEFAULT,
                          description: Text('Successfully updated the password.',
                            textAlign: TextAlign.center,
                            style: TextStyle(),
                          ),
                          onlyOkButton: true,
                          buttonOkColor: Colors.green,
                          onOkButtonPressed: () {
                            Navigator.pop(context, true);
                          },
                        )
                      );

                      Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMUserProfileDetails(userId: userId,)));
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
                  },
                ),

                SizedBox(height: 20,),

              ],
            ),
          ),
        ),
      ),
    );
  }
}