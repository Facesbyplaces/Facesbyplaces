import 'package:facesbyplaces/API/Regular/10-Settings-User/api-settings-user-regular-05-change-password.dart';
import 'package:facesbyplaces/API/Regular/10-Settings-User/api-settings-user-regular-13-add-password.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-01-regular-input-field.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-06-regular-button.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'home-settings-user-regular-01-user-details.dart';
import 'package:loader_overlay/loader_overlay.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:flutter/material.dart';

class HomeRegularUserChangePassword extends StatefulWidget{
  final int userId;
  final bool isAddPassword;
  const HomeRegularUserChangePassword({required this.userId, required this.isAddPassword});

  HomeRegularUserChangePasswordState createState() => HomeRegularUserChangePasswordState();
}

class HomeRegularUserChangePasswordState extends State<HomeRegularUserChangePassword>{
  final GlobalKey<MiscRegularInputFieldTemplateState> _key1 = GlobalKey<MiscRegularInputFieldTemplateState>();
  final GlobalKey<MiscRegularInputFieldTemplateState> _key2 = GlobalKey<MiscRegularInputFieldTemplateState>();

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
            centerTitle: false,
            title: Text(widget.isAddPassword == true ? 'Add Password' : 'Change Password', textAlign: TextAlign.left, style: TextStyle(fontSize: 26, fontFamily: 'NexaRegular', color: const Color(0xffffffff)),),
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: const Color(0xffffffff), size: 35,),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
          ),
          body: SafeArea(
            child: Container(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                physics: const ClampingScrollPhysics(),
                child: Column(
                  children: [
                    MiscRegularInputFieldTemplate(
                      key: _key1,
                      labelText: widget.isAddPassword == true ? 'New Password' : 'Current Password',
                      obscureText: true,
                      labelTextStyle: TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: const Color(0xffBDC3C7),),
                    ),

                    const SizedBox(height: 20,),

                    MiscRegularInputFieldTemplate(
                      key: _key2,
                      labelText: widget.isAddPassword == true ? 'Confirm Password' : 'New Password',
                      obscureText: true,
                      labelTextStyle: TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: const Color(0xffBDC3C7),),
                    ),

                    const SizedBox(height: 80,),

                    MiscRegularButtonTemplate(
                      buttonTextStyle: TextStyle(fontSize: 24, fontFamily: 'NexaBold', color: const Color(0xffffffff),),
                      buttonText: widget.isAddPassword == true ? 'Add' : 'Update',
                      buttonColor: const Color(0xff04ECFF),
                      width: SizeConfig.screenWidth! / 2,
                      height: 50,
                      onPressed: () async{
                        if(_key1.currentState!.controller.text == '' || _key2.currentState!.controller.text == ''){
                          await showDialog(
                            context: context,
                            builder: (_) => AssetGiffyDialog(
                              description: Text('Password can\'t be empty. Please try again.', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular',),),
                              title: Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontFamily: 'NexaRegular',),),
                              image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                              entryAnimation: EntryAnimation.DEFAULT,
                              buttonOkColor: const Color(0xffff0000),
                              onlyOkButton: true,
                              onOkButtonPressed: (){
                                Navigator.pop(context, true);
                              },
                            ),
                          );
                        }else{
                          if(widget.isAddPassword == true){
                            if(_key1.currentState!.controller.text == _key2.currentState!.controller.text){
                              context.loaderOverlay.show();
                              bool result = await apiRegularAddPassword(newPassword: _key1.currentState!.controller.text);
                              context.loaderOverlay.hide();

                              if(result){
                                await showDialog(
                                  context: context,
                                  builder: (_) => AssetGiffyDialog(
                                    description: Text('Successfully added a password.', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular',),),
                                    title: Text('Success', textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontFamily: 'NexaRegular'),),
                                    image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                    entryAnimation: EntryAnimation.DEFAULT,
                                    onlyOkButton: true,
                                    onOkButtonPressed: (){
                                      Navigator.pop(context, true);
                                    },
                                  ),
                                );
                                Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularUserProfileDetails(userId: widget.userId,)));
                              }else{
                                await showDialog(
                                  context: context,
                                  builder: (_) => AssetGiffyDialog(
                                    description: Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular',),),
                                    title: Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontFamily: 'NexaRegular',),),
                                    image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                    entryAnimation: EntryAnimation.DEFAULT,
                                    buttonOkColor: const Color(0xffff0000),
                                    onlyOkButton: true,
                                    onOkButtonPressed: (){
                                      Navigator.pop(context, true);
                                    },
                                  ),
                                );
                              }
                            }else{
                              await showDialog(
                                context: context,
                                builder: (_) => AssetGiffyDialog(
                                  description: Text('Passwords don\'t match. Please try again.', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular',),),
                                  title: Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontFamily: 'NexaRegular',),),
                                  image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                  entryAnimation: EntryAnimation.DEFAULT,
                                  buttonOkColor: const Color(0xffff0000),
                                  onlyOkButton: true,
                                  onOkButtonPressed: (){
                                    Navigator.pop(context, true);
                                  },
                                ),
                              );
                            }
                          }else{
                            context.loaderOverlay.show();
                            bool result = await apiRegularChangePassword(currentPassword: _key1.currentState!.controller.text, newPassword: _key2.currentState!.controller.text);
                            context.loaderOverlay.hide();

                            if(result){
                              await showDialog(
                                context: context,
                                builder: (_) => AssetGiffyDialog(
                                  description: Text('Successfully updated the password.', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular',),),
                                  title: Text('Success', textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontFamily: 'NexaRegular'),),
                                  image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                  entryAnimation: EntryAnimation.DEFAULT,
                                  onlyOkButton: true,
                                  onOkButtonPressed: (){
                                    Navigator.pop(context, true);
                                  },
                                ),
                              );
                              Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularUserProfileDetails(userId: widget.userId,)));
                            }else{
                              await showDialog(
                                context: context,
                                builder: (_) => AssetGiffyDialog(
                                  description: Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular',),),
                                  title: Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontFamily: 'NexaRegular',),),
                                  image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                  entryAnimation: EntryAnimation.DEFAULT,
                                  buttonOkColor: const Color(0xffff0000),
                                  onlyOkButton: true,
                                  onOkButtonPressed: (){
                                    Navigator.pop(context, true);
                                  },
                                ),
                              );
                            }
                          }
                        }
                      },
                    ),

                    SizedBox(height: 160,),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}