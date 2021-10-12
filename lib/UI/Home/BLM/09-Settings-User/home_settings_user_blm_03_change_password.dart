import 'package:facesbyplaces/API/BLM/10-Settings-User/api_settings_user_blm_05_change_password.dart';
import 'package:facesbyplaces/API/BLM/10-Settings-User/api_settings_user_blm_13_add_password.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'home_settings_use_blm_01_user_details.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter/material.dart';
import 'package:dialog/dialog.dart';
import 'package:misc/misc.dart';

class HomeBLMUserChangePassword extends StatefulWidget{
  final int userId;
  final bool isAddPassword;
  const HomeBLMUserChangePassword({Key? key, required this.userId, required this.isAddPassword}) : super(key: key);

  @override
  HomeBLMUserChangePasswordState createState() => HomeBLMUserChangePasswordState();
}

class HomeBLMUserChangePasswordState extends State<HomeBLMUserChangePassword>{
  final GlobalKey<MiscInputFieldTemplateState> _key1 = GlobalKey<MiscInputFieldTemplateState>();
  final GlobalKey<MiscInputFieldTemplateState> _key2 = GlobalKey<MiscInputFieldTemplateState>();

  @override
  Widget build(BuildContext context){
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
            title: Text(widget.isAddPassword == true ? 'Add Password' : 'Change Password', textAlign: TextAlign.left, style: const TextStyle(fontSize: 26, fontFamily: 'NexaRegular', color: Color(0xffffffff)),),
            centerTitle: false,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Color(0xffffffff), size: 35,),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
          ),
          body: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                MiscInputFieldTemplate(
                  key: _key1,
                  obscureText: true,
                  labelText: widget.isAddPassword == true ? 'New Password' : 'Current Password',
                  labelTextStyle: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xffBDC3C7),),
                ),

                const SizedBox(height: 20,),

                MiscInputFieldTemplate(
                  key: _key2,
                  obscureText: true,
                  labelText: widget.isAddPassword == true ? 'Confirm Password' : 'New Password',
                  labelTextStyle: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xffBDC3C7),),
                ),

                const SizedBox(height: 80,),

                MiscButtonTemplate(
                  buttonText: widget.isAddPassword == true ? 'Add' : 'Update',
                  buttonTextStyle: const TextStyle(fontSize: 24, fontFamily: 'NexaBold', color: Color(0xffffffff),),
                  buttonColor: const Color(0xff04ECFF),
                  width: SizeConfig.screenWidth! / 2,
                  height: 50,
                  onPressed: () async{
                    if(_key1.currentState!.controller.text == '' || _key2.currentState!.controller.text == ''){
                      await showDialog(
                        context: context,
                        builder: (context) => CustomDialog(
                          image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                          title: 'Error',
                          description: 'Password can\'t be empty. Please try again.',
                          okButtonColor: const Color(0xfff44336), // RED
                          includeOkButton: true,
                        ),
                      );
                    }else{
                      if(widget.isAddPassword == true){
                        if(_key1.currentState!.controller.text == _key2.currentState!.controller.text){
                          context.loaderOverlay.show();
                          bool result = await apiBLMAddPassword(newPassword: _key1.currentState!.controller.text);
                          context.loaderOverlay.hide();

                          if(result){
                            await showDialog(
                              context: context,
                              builder: (context) => CustomDialog(
                                image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                title: 'Success',
                                description: 'Successfully added a password.',
                                okButtonColor: const Color(0xff4caf50), // GREEN
                                includeOkButton: true,
                              ),
                            );
                            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMUserProfileDetails(userId: widget.userId,)));
                          }else{
                            await showDialog(
                              context: context,
                              builder: (context) => CustomDialog(
                                image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                title: 'Error',
                                description: 'Something went wrong. Please try again.',
                                okButtonColor: const Color(0xfff44336), // RED
                                includeOkButton: true,
                              ),
                            );
                          }
                        }else{
                          await showDialog(
                            context: context,
                            builder: (context) => CustomDialog(
                              image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                              title: 'Error',
                              description: 'Passwords don\'t match. Please try again.',
                              okButtonColor: const Color(0xfff44336), // RED
                              includeOkButton: true,
                            ),
                          );
                        }
                      }else{
                        context.loaderOverlay.show();
                        bool result = await apiBLMChangePassword(currentPassword: _key1.currentState!.controller.text, newPassword: _key2.currentState!.controller.text);
                        context.loaderOverlay.hide();

                        if(result){
                          await showDialog(
                            context: context,
                            builder: (context) => CustomDialog(
                              image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                              title: 'Success',
                              description: 'Successfully updated the password.',
                              okButtonColor: const Color(0xff4caf50), // GREEN
                              includeOkButton: true,
                            ),
                          );
                          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMUserProfileDetails(userId: widget.userId,)));
                        }else{
                          await showDialog(
                            context: context,
                            builder: (context) => CustomDialog(
                              image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                              title: 'Error',
                              description: 'Something went wrong. Please try again.',
                              okButtonColor: const Color(0xfff44336), // RED
                              includeOkButton: true,
                            ),
                          );
                        }
                      }
                    }
                  },
                ),

                const SizedBox(height: 20,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}