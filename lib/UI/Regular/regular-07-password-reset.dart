import 'package:facesbyplaces/API/Regular/01-Start/api-start-regular-09-password-change.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-01-regular-input-field.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-06-regular-button.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:flutter/material.dart';

class RegularPasswordReset extends StatefulWidget{
  final String resetToken;
  RegularPasswordReset({required this.resetToken});

  RegularPasswordResetState createState() => RegularPasswordResetState(resetToken: resetToken);
}

class RegularPasswordResetState extends State<RegularPasswordReset>{
  final String resetToken;
  RegularPasswordResetState({required this.resetToken});

  final GlobalKey<MiscRegularInputFieldTemplateState> _key1 = GlobalKey<MiscRegularInputFieldTemplateState>();
  final GlobalKey<MiscRegularInputFieldTemplateState> _key2 = GlobalKey<MiscRegularInputFieldTemplateState>();

  @override
  void initState(){
    super.initState();
    FlutterBranchSdk.logout(); // TO RESET THE BRANCH
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return RepaintBoundary(
      child: WillPopScope(
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
                  physics: const ClampingScrollPhysics(),
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Column(
                    children: [
                      Column(
                        children: [
                          const SizedBox(height: 40),
                          
                          Align(
                            alignment: Alignment.topLeft,
                            child: IconButton(
                              onPressed: (){
                                Navigator.pop(context);
                              }, 
                              icon: const Icon(
                                Icons.arrow_back, 
                                size: 30,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 80),

                      const Center(child: const Text('Change Password', style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: const Color(0xff000000),),),),

                      const SizedBox(height: 40,),

                      const Center(child: const Text('Please enter your new password.', textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w300, color: const Color(0xff000000),),),),

                      const SizedBox(height: 80,),

                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                        child: MiscRegularInputFieldTemplate(
                          key: _key1, 
                          labelText: 'New Password', 
                          type: TextInputType.emailAddress, 
                          labelTextStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400, 
                            color: const Color(0xff000000),
                          ),
                          obscureText: true,
                        ),
                      ),

                      const SizedBox(height: 40,),

                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                        child: MiscRegularInputFieldTemplate(
                          key: _key2, 
                          labelText: 'Confirm Password', 
                          type: TextInputType.emailAddress, 
                          labelTextStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400, 
                            color: const Color(0xff000000),
                          ),
                          obscureText: true,
                        ),
                      ),

                      const SizedBox(height: 80,),

                      MiscRegularButtonTemplate(
                        buttonText: 'Change',
                        buttonTextStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold, 
                          color: const Color(0xffffffff),
                        ),
                        width: SizeConfig.screenWidth! / 2, 
                        height: 45,
                        buttonColor: const Color(0xff04ECFF),
                        onPressed: () async{

                          if(_key1.currentState!.controller.text == '' || _key2.currentState!.controller.text == ''){
                            await showDialog(
                              context: context,
                              builder: (_) => 
                                AssetGiffyDialog(
                                image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                title: const Text('Error', textAlign: TextAlign.center, style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                                entryAnimation: EntryAnimation.DEFAULT,
                                description: const Text('Please complete the form before submitting.',
                                  textAlign: TextAlign.center,
                                ),
                                onlyOkButton: true,
                                buttonOkColor: const Color(0xffff0000),
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
                                title: const Text('Error', textAlign: TextAlign.center, style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                                entryAnimation: EntryAnimation.DEFAULT,
                                description: const Text('Passwords don\'t match. Please try again.',
                                  textAlign: TextAlign.center,
                                ),
                                onlyOkButton: true,
                                buttonOkColor: const Color(0xffff0000),
                                onOkButtonPressed: () {
                                  Navigator.pop(context, true);
                                },
                              )
                            );
                          }else{
                            context.loaderOverlay.show();
                            bool result = await apiRegularPasswordChange(
                              password: _key1.currentState!.controller.text, 
                              passwordConfirmation: _key2.currentState!.controller.text,
                              resetToken: resetToken,
                            );
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
                                    Navigator.of(context).pushNamedAndRemoveUntil('/start', (Route<dynamic> route) => false);
                                  },
                                )
                              );
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
                          }
                          
                        },
                      ),

                      const SizedBox(height: 20),
                      
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}