import 'package:facesbyplaces/API/BLM/01-Start/api_start_blm_09_password_change.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc_01_blm_input_field.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc_06_blm_button.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:loader_overlay/loader_overlay.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:flutter/material.dart';

class BLMPasswordReset extends StatefulWidget{
  final String resetToken;
  const BLMPasswordReset({Key? key, required this.resetToken}) : super(key: key);

  @override
  BLMPasswordResetState createState() => BLMPasswordResetState();
}

class BLMPasswordResetState extends State<BLMPasswordReset>{
  final GlobalKey<MiscBLMInputFieldTemplateState> _key1 = GlobalKey<MiscBLMInputFieldTemplateState>();
  final GlobalKey<MiscBLMInputFieldTemplateState> _key2 = GlobalKey<MiscBLMInputFieldTemplateState>();

  @override
  void initState(){
    super.initState();
    FlutterBranchSdk.logout();
  }

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
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraint){
                return SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraint.maxHeight),
                    child: IntrinsicHeight(
                      child: Column(
                        children: [
                          Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: IconButton(
                                  icon: const Icon(Icons.arrow_back, color: Color(0xff000000), size: 35),
                                  onPressed: (){
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 80),

                          const Center(child: Text('Change Password', style: TextStyle(fontSize: 42, fontFamily: 'NexaBold', color: Color(0xff2F353D),),),),

                          const SizedBox(height: 40,),

                          const Center(child: Text('Please enter your new password', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xff000000),),),),

                          const SizedBox(height: 80,),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: MiscBLMInputFieldTemplate(
                              key: _key1,
                              labelText: 'New Password',
                              labelTextStyle: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xff000000),),
                              type: TextInputType.emailAddress,
                              obscureText: true,
                            ),
                          ),

                          const SizedBox(height: 40,),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: MiscBLMInputFieldTemplate(
                              key: _key2,
                              labelText: 'Confirm Password',
                              labelTextStyle: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xff000000),),
                              type: TextInputType.emailAddress,
                              obscureText: true,
                            ),
                          ),

                          const SizedBox(height: 80,),

                          MiscBLMButtonTemplate(
                            buttonText: 'Change',
                            buttonTextStyle: const TextStyle(fontSize: 24, fontFamily: 'NexaBold', color: Color(0xffFFFFFF),),
                            buttonColor: const Color(0xff04ECFF),
                            width: SizeConfig.screenWidth! / 2,
                            height: 50,
                            onPressed: () async{
                              if(_key1.currentState!.controller.text == '' || _key2.currentState!.controller.text == ''){
                                await showDialog(
                                  context: context,
                                  builder: (_) => AssetGiffyDialog(
                                    title: const Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontFamily: 'NexaRegular'),),
                                    description: const Text('Please complete the form before submitting.', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular'),),
                                    image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                    entryAnimation: EntryAnimation.DEFAULT,
                                    buttonOkColor: const Color(0xffff0000),
                                    onlyOkButton: true,
                                    onOkButtonPressed: (){
                                      Navigator.pop(context, true);
                                    },
                                  ),
                                );
                              }else if (_key1.currentState!.controller.text != _key2.currentState!.controller.text){
                                await showDialog(
                                  context: context,
                                  builder: (_) => AssetGiffyDialog(
                                    title: const Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontFamily: 'NexaRegular'),),
                                    description: const Text('Passwords don\'t match. Please try again.', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular'),),
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
                                context.loaderOverlay.show();
                                bool result = await apiBLMPasswordChange(password: _key1.currentState!.controller.text, passwordConfirmation: _key2.currentState!.controller.text, resetToken: widget.resetToken,);
                                context.loaderOverlay.hide();

                                if(result){
                                  await showDialog(
                                    context: context,
                                    builder: (_) => AssetGiffyDialog(
                                      title: const Text('Success', textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontFamily: 'NexaRegular',),),
                                      description: const Text('Successfully updated the password.', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular'),),
                                      image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                      entryAnimation: EntryAnimation.DEFAULT,
                                      onlyOkButton: true,
                                      onOkButtonPressed: (){
                                        Navigator.pop(context, true);
                                        Navigator.of(context).pushNamedAndRemoveUntil('/start', (Route<dynamic> route) => false);
                                      },
                                    ),
                                  );
                                }else{
                                  await showDialog(
                                    context: context,
                                    builder: (_) => AssetGiffyDialog(
                                      title: const Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontFamily: 'NexaRegular'),),
                                      description: const Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular'),),
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
                            },
                          ),

                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                );
              }
            ),
          ),
        ),
      ),
    );
  }
}