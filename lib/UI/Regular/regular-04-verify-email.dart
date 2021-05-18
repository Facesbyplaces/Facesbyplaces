import 'package:facesbyplaces/API/Regular/01-Start/api-start-regular-03-verify-email.dart';
import 'package:facesbyplaces/API/Regular/01-Start/api-start-regular-10-verification-code-resend.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-06-regular-button.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-07-regular-background.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:loader_overlay/loader_overlay.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class RegularVerifyEmail extends StatelessWidget{

  final TextEditingController controller = TextEditingController(text: '');
  
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

                SingleChildScrollView(physics: const NeverScrollableScrollPhysics(), child: Container(height: SizeConfig.screenHeight, child: const MiscRegularBackgroundTemplate(image: const AssetImage('assets/icons/background2.png'),),),),

                SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Column(
                      children: [

                        const SizedBox(height: 20),

                        Align(
                          alignment: Alignment.centerLeft, 
                          child: IconButton(
                            onPressed: (){
                              Navigator.pop(context);
                            }, 
                            icon: const Icon(Icons.arrow_back, color: const Color(0xff000000), size: 30),
                          ),
                        ),

                        const SizedBox(height: 40),

                        const Center(child: const Text('Verify Email', style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: const Color(0xff000000),),),),

                        const SizedBox(height: 40),

                        const Center(child: const Text('We have sent a verification code to your email address. Please enter the verification code to continue.', textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w300, color: const Color(0xff000000),),),),

                        const SizedBox(height: 40),

                        Padding(
                          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                          child: PinPut(
                            fieldsAlignment: MainAxisAlignment.spaceEvenly,
                            controller: controller,
                            fieldsCount: 3,
                            textStyle: const TextStyle(
                              fontSize: 56,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xff000000)
                            ),
                            followingFieldDecoration: const BoxDecoration(
                              border: const Border(bottom: const BorderSide(color: const Color(0xff000000),),)
                            ),
                            selectedFieldDecoration: const BoxDecoration(
                              border: const Border(bottom: const BorderSide(color: const Color(0xff000000),),)
                            ),
                            submittedFieldDecoration: const BoxDecoration(
                              border: const Border(bottom: const BorderSide(color: const Color(0xff000000),),)
                            ),
                          ),
                        ),

                        const SizedBox(height: 80),

                        RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              const TextSpan(
                                text: 'Didn\'t receive a code? ', 
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w300,
                                  color: const Color(0xff000000),
                                ),
                              ),

                              TextSpan(
                                text: 'Resend',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xff000000),
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                ..onTap = () async{
                                  context.loaderOverlay.show();
                                  bool result = await apiRegularVerificationCodeResend();
                                  context.loaderOverlay.hide();

                                  if(result == true){
                                    await showDialog(
                                      context: context,
                                      builder: (_) => 
                                        AssetGiffyDialog(
                                        image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                        title: const Text('Success', textAlign: TextAlign.center, style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                                        entryAnimation: EntryAnimation.DEFAULT,
                                        description: const Text('Another code has been sent to your email address. Please check your inbox.',
                                          textAlign: TextAlign.center,
                                        ),
                                        onlyOkButton: true,
                                        onOkButtonPressed: () {
                                          Navigator.pop(context, true);
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
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 120),

                        MiscRegularButtonTemplate(
                          buttonText: controller.text.length != 3 ? 'Next' : 'Sign Up',
                          buttonTextStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold, 
                            color: const Color(0xffffffff),
                          ),
                          width: SizeConfig.screenWidth! / 2, 
                          height: 45,
                          buttonColor: const Color(0xff04ECFF),
                          onPressed: () async{

                            if(controller.text.length != 3){
                              await showDialog(
                                context: context,
                                builder: (_) => 
                                  AssetGiffyDialog(
                                  image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                  title: const Text('Error', textAlign: TextAlign.center, style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                                  entryAnimation: EntryAnimation.DEFAULT,
                                  description: const Text('Please enter the verification code.',
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
                              String result = await apiRegularVerifyEmail(verificationCode: controller.text);
                              context.loaderOverlay.hide();

                              if(result == 'Success'){
                                Navigator.pushNamed(context, '/regular/upload-photo');
                              }else{
                                await showDialog(
                                  context: context,
                                  builder: (_) => 
                                    AssetGiffyDialog(
                                    image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                    title: const Text('Error', textAlign: TextAlign.center, style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                                    entryAnimation: EntryAnimation.DEFAULT,
                                    description: Text('Error: $result',
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

                        const SizedBox(height: 40),
                      ],
                    ),
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