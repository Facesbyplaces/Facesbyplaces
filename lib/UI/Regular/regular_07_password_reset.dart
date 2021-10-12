import 'package:facesbyplaces/API/Regular/01-Start/api_start_regular_09_password_change.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter/material.dart';
import 'package:dialog/dialog.dart';
import 'package:misc/misc.dart';

class RegularPasswordReset extends StatefulWidget{
  final String resetToken;
  const RegularPasswordReset({Key? key, required this.resetToken}) : super(key: key);

  @override
  RegularPasswordResetState createState() => RegularPasswordResetState();
}

class RegularPasswordResetState extends State<RegularPasswordReset>{
  final GlobalKey<MiscInputFieldTemplateState> _key1 = GlobalKey<MiscInputFieldTemplateState>();
  final GlobalKey<MiscInputFieldTemplateState> _key2 = GlobalKey<MiscInputFieldTemplateState>();

  @override
  void initState(){
    super.initState();
    FlutterBranchSdk.logout(); // TO RESET THE BRANCH
  }

  @override
  Widget build(BuildContext context){
    SizeConfig.init(context);
    return RepaintBoundary(
      child: WillPopScope(
        onWillPop: () async{
          return Navigator.canPop(context);
        },
        child: GestureDetector(
          onTap: (){
            FocusNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus){
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
                                    icon: const Icon(Icons.arrow_back, color: Color(0xff000000), size: 35,),
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
                              child: MiscInputFieldTemplate(
                                key: _key1,
                                labelText: 'New Password',
                                type: TextInputType.emailAddress,
                                labelTextStyle: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xff000000),),
                                obscureText: true,
                              ),
                            ),

                            const SizedBox(height: 40,),

                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: MiscInputFieldTemplate(
                                key: _key2,
                                labelText: 'Confirm Password',
                                type: TextInputType.emailAddress,
                                labelTextStyle: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xff000000),),
                                obscureText: true,
                              ),
                            ),

                            const SizedBox(height: 80,),

                            MiscButtonTemplate(
                              buttonText: 'Change',
                              buttonTextStyle: const TextStyle(fontSize: 24, fontFamily: 'NexaBold', color: Color(0xffFFFFFF),),
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
                                      description: 'Please complete the form before submitting.',
                                      okButtonColor: const Color(0xfff44336), // RED
                                      includeOkButton: true,
                                    ),
                                  );
                                }else if(_key1.currentState!.controller.text != _key2.currentState!.controller.text){
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
                                }else{
                                  context.loaderOverlay.show();
                                  bool result = await apiRegularPasswordChange(password: _key1.currentState!.controller.text, passwordConfirmation: _key2.currentState!.controller.text,resetToken: widget.resetToken,);
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
                                        okButton: (){
                                          Navigator.pop(context, true);
                                          Navigator.of(context).pushNamedAndRemoveUntil('/start', (Route<dynamic> route) => false);
                                        },
                                      ),
                                    );
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
      ),
    );
  }
}