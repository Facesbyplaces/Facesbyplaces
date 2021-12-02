import 'package:facesbyplaces/API/BLM/01-Start/api_start_blm_03_verify_email.dart';
import 'package:facesbyplaces/API/BLM/01-Start/api_start_blm_10_verification_code_resend.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:dialog/dialog.dart';
import 'package:misc/misc.dart';

class BLMVerifyEmail extends StatelessWidget{
  BLMVerifyEmail({Key? key}) : super(key: key);
  final TextEditingController controller = TextEditingController(text: '');

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
          body: Stack(
            children: [
              SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Container(
                  height: SizeConfig.screenHeight,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/icons/background2.png'),
                    ),
                  ),
                ),
              ),

              LayoutBuilder(
                builder: (context, constraint){
                  return SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: constraint.maxHeight),
                      child: IntrinsicHeight(
                        child: SafeArea(
                          child: Column(
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

                              const SizedBox(height: 40,),

                              const Center(child: Text('Verify Email', style: TextStyle(fontSize: 42, fontFamily: 'NexaBold', color: Color(0xff2F353D),),),),

                              const SizedBox(height: 40,),

                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 40),
                                child: Text('We have sent a verification code to your email address. Please enter the verification code to continue.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xff000000),),
                                ),
                              ),

                              const SizedBox(height: 40,),

                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: PinPut(
                                  fieldsAlignment: MainAxisAlignment.spaceEvenly,
                                  controller: controller,
                                  fieldsCount: 3,
                                  textStyle: const TextStyle(fontSize: 56, fontWeight: FontWeight.bold, color: Color(0xff000000),),
                                  followingFieldDecoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xff000000),),),),
                                  selectedFieldDecoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xff000000),),),),
                                  submittedFieldDecoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xff000000),),),),
                                ),
                              ),

                              const SizedBox(height: 80,),

                              RichText(
                                text: TextSpan(
                                  children: <TextSpan>[
                                    const TextSpan(text: 'Didn\'t receive a code? ', style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xff000000),),),

                                    TextSpan(
                                      text: 'Resend',
                                      style: const TextStyle(fontSize: 24, fontFamily: 'NexaBold', color: Color(0xff000000), decoration: TextDecoration.underline),
                                      recognizer: TapGestureRecognizer()
                                      ..onTap = () async{
                                        context.loaderOverlay.show();
                                        bool result = await apiBLMVerificationCodeResend();
                                        context.loaderOverlay.hide();

                                        if(result == true){
                                          await showDialog(
                                            context: context,
                                            builder: (context) => CustomDialog(
                                              image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                              title: 'Success',
                                              description: 'Another code has been sent to your email address. Please check your inbox.',
                                              okButtonColor: const Color(0xff4caf50), // GREEN
                                              includeOkButton: true,
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
                                      },
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 120),

                              MiscButtonTemplate(
                                buttonText: controller.text.length != 3 ? 'Next' : 'Sign Up',
                                buttonTextStyle: const TextStyle(fontSize: 24, color: Color(0xffffffff), fontFamily: 'NexaBold'),
                                buttonColor: const Color(0xff000000),
                                width: SizeConfig.screenWidth! / 2,
                                height: 50,
                                onPressed: () async{
                                  if(controller.text.length != 3){
                                    await showDialog(
                                      context: context,
                                      builder: (context) => CustomDialog(
                                        image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                        title: 'Error',
                                        description: 'Please enter the verification code.',
                                        okButtonColor: const Color(0xfff44336), // RED
                                        includeOkButton: true,
                                      ),
                                    );
                                  }else{
                                    context.loaderOverlay.show();
                                    String result = await apiBLMVerifyEmail(verificationCode: controller.text);
                                    context.loaderOverlay.hide();

                                    if(result == 'Success'){
                                      Navigator.pushNamed(context, '/blm/upload-photo');
                                    }else{
                                      await showDialog(
                                        context: context,
                                        builder: (context) => CustomDialog(
                                          image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                          title: 'Error',
                                          description: 'Error: $result',
                                          okButtonColor: const Color(0xfff44336), // RED
                                          includeOkButton: true,
                                        ),
                                      );
                                    }
                                  }
                                },
                              ),

                              const SizedBox(height: 40,),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }
              ),
            ],
          ),
        ),
      ),
    );
  }
}