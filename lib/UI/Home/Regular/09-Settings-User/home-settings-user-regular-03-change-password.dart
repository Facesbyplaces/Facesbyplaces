import 'package:facesbyplaces/API/Regular/10-Settings-User/api-settings-user-regular-05-change-password.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-01-regular-input-field.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-06-regular-button.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'home-settings-user-regular-01-user-details.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:flutter/material.dart';

class HomeRegularUserChangePassword extends StatefulWidget{
  final int userId;
  const HomeRegularUserChangePassword({required this.userId});

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
            backgroundColor: const Color(0xff04ECFF),
            title: const Text('Change Password', style: const TextStyle(fontSize: 16, color: const Color(0xffffffff)),),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: const Color(0xffffffff),), 
              onPressed: (){
                Navigator.pop(context);
              },
            ),
          ),
          body: Container(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              physics: const ClampingScrollPhysics(),
              child: Column(
                children: [
                  MiscRegularInputFieldTemplate(key: _key1, labelText: 'Current Password', obscureText: true,),

                  const SizedBox(height: 20,),

                  MiscRegularInputFieldTemplate(key: _key2, labelText: 'New Password', obscureText: true,),

                  const SizedBox(height: 80,),

                  MiscRegularButtonTemplate(
                    buttonText: 'Update',
                    buttonTextStyle: const TextStyle(
                      fontSize: 16, 
                      fontWeight: FontWeight.bold, 
                      color: const Color(0xffffffff),
                    ),
                    width: SizeConfig.screenWidth! / 2,
                    height: 45,
                    buttonColor: const Color(0xff04ECFF),
                    onPressed: () async{
                      context.loaderOverlay.show();
                      bool result = await apiRegularChangePassword(currentPassword: _key1.currentState!.controller.text, newPassword: _key2.currentState!.controller.text);
                      context.loaderOverlay.hide();

                      if(result){
                        await showDialog(
                          context: context,
                          builder: (_) => 
                            AssetGiffyDialog(
                            image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                            title: const Text('Success', textAlign: TextAlign.center, style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                            entryAnimation: EntryAnimation.DEFAULT,
                            description: const Text('Successfully updated the password.',
                              textAlign: TextAlign.center,
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
                            title: const Text('Error', textAlign: TextAlign.center, style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                            entryAnimation: EntryAnimation.DEFAULT,
                            description: const Text('Something went wrong. Please try again.',
                              textAlign: TextAlign.center,
                            ),
                            onlyOkButton: true,
                            buttonOkColor: const Color(0xffff0000),
                            onOkButtonPressed: () {
                              Navigator.pop(context, true);
                            },
                          )
                        );
                      }
                    },
                  ),

                  const SizedBox(height: 160,),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}