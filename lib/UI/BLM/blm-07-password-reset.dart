import 'package:facesbyplaces/API/BLM/01-Start/api-start-blm-09-password-change.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-01-blm-input-field.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-06-blm-button.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:flutter/material.dart';

class BLMPasswordReset extends StatefulWidget{
  final String resetToken;
  BLMPasswordReset({required this.resetToken});

  BLMPasswordResetState createState() => BLMPasswordResetState(resetToken: resetToken);
}

class BLMPasswordResetState extends State<BLMPasswordReset>{
  final String resetToken;
  BLMPasswordResetState({required this.resetToken});

  final GlobalKey<MiscBLMInputFieldTemplateState> _key1 = GlobalKey<MiscBLMInputFieldTemplateState>();
  final GlobalKey<MiscBLMInputFieldTemplateState> _key2 = GlobalKey<MiscBLMInputFieldTemplateState>();

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
          body: Stack(
            children: [

              SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Column(
                    children: [

                      Column(
                        children: [
                          SizedBox(height: 40),
                          
                          Align(
                            alignment: Alignment.topLeft, 
                            child: IconButton(
                              onPressed: (){
                                Navigator.pop(context);
                              }, 
                              icon: Icon(Icons.arrow_back, size: 30,),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 80),

                      Center(child: Text('Change Password', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Color(0xff000000),),),),

                      SizedBox(height: 40,),

                      Center(child: Text('Please enter your new password.', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300, color: Color(0xff000000),),),),

                      SizedBox(height: 80,),

                      Padding(
                        padding: EdgeInsets.only(left: 20.0, right: 20.0),
                        child: MiscBLMInputFieldTemplate(
                          key: _key1, 
                          labelText: 'New Password', 
                          type: TextInputType.emailAddress, 
                          labelTextStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400, 
                            color: Color(0xff000000),
                          ),
                          obscureText: true,
                        ),
                      ),

                      SizedBox(height: 40,),

                      Padding(
                        padding: EdgeInsets.only(left: 20.0, right: 20.0),
                        child: MiscBLMInputFieldTemplate(
                          key: _key2, 
                          labelText: 'Confirm Password', 
                          type: TextInputType.emailAddress, 
                          labelTextStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400, 
                            color: Color(0xff000000),
                          ),
                          obscureText: true,
                        ),
                      ),

                      SizedBox(height: 80,),

                      MiscBLMButtonTemplate(
                        buttonText: 'Change',
                        buttonTextStyle: TextStyle(
                          fontSize: 16, 
                          fontWeight: FontWeight.bold, 
                          color: Color(0xffffffff),
                        ),
                        onPressed: () async{

                          if(_key1.currentState!.controller.text == '' || _key2.currentState!.controller.text == ''){
                            await showDialog(
                              context: context,
                              builder: (_) => 
                                AssetGiffyDialog(
                                image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                title: Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                                entryAnimation: EntryAnimation.DEFAULT,
                                description: Text('Please complete the form before submitting.',
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
                          }else if(_key1.currentState!.controller.text != _key2.currentState!.controller.text){
                            await showDialog(
                              context: context,
                              builder: (_) => 
                                AssetGiffyDialog(
                                image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                title: Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                                entryAnimation: EntryAnimation.DEFAULT,
                                description: Text('Passwords don\'t match. Please try again.',
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
                          }else{
                            context.showLoaderOverlay();
                            bool result = await apiBLMPasswordChange(
                              password: _key1.currentState!.controller.text, 
                              passwordConfirmation: _key2.currentState!.controller.text,
                              resetToken: resetToken,
                            );
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
                              Navigator.popUntil(context, ModalRoute.withName('/regular/login'));
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
                          
                        },
                        width: SizeConfig.screenWidth! / 2, 
                        height: 45, 
                        buttonColor: Color(0xff04ECFF),
                      ),

                      SizedBox(height: 20),

                    ],
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}