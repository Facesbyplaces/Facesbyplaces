import 'package:facesbyplaces/API/BLM/01-Start/api-start-blm-03-verify-email.dart';
import 'package:facesbyplaces/API/BLM/01-Start/api-start-blm-10-verification-code-resend.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-06-blm-button.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:loader_overlay/loader_overlay.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class BLMVerifyEmail extends StatelessWidget{
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
                    image: const DecorationImage(
                      fit: BoxFit.cover,
                      image: const AssetImage('assets/icons/background2.png'),
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
                                  icon: const Icon(Icons.arrow_back, color: const Color(0xff000000), size: 35,),
                                  onPressed: (){
                                    Navigator.pop(context);
                                  },
                                ),
                              ),

                              const SizedBox(height: 40,),

                              const Center(child: const Text('Verify Email', style: const TextStyle(fontSize: 42, fontFamily: 'NexaBold', color: const Color(0xff2F353D),),),),

                              const SizedBox(height: 40,),

                              const Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 40),
                                child: const Text('We have sent a verification code to your email address. Please enter the verification code to continue.',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: const Color(0xff000000),),
                                ),
                              ),

                              const SizedBox(height: 40,),

                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: PinPut(
                                  fieldsAlignment: MainAxisAlignment.spaceEvenly,
                                  controller: controller,
                                  fieldsCount: 3,
                                  textStyle: const TextStyle(fontSize: 56, fontWeight: FontWeight.bold, color: const Color(0xff000000),),
                                  followingFieldDecoration: const BoxDecoration(border: const Border(bottom: const BorderSide(color: const Color(0xff000000),),),),
                                  selectedFieldDecoration: const BoxDecoration(border: const Border(bottom: const BorderSide(color: const Color(0xff000000),),),),
                                  submittedFieldDecoration: const BoxDecoration(border: const Border(bottom: const BorderSide(color: const Color(0xff000000),),),),
                                ),
                              ),

                              const SizedBox(height: 80,),

                              RichText(
                                text: TextSpan(
                                  children: <TextSpan>[
                                    const TextSpan(text: 'Didn\'t receive a code? ', style: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: const Color(0xff000000),),),

                                    TextSpan(
                                      text: 'Resend',
                                      style: const TextStyle(fontSize: 24, fontFamily: 'NexaBold', color: const Color(0xff000000), decoration: TextDecoration.underline),
                                      recognizer: TapGestureRecognizer()
                                      ..onTap = () async{
                                        context.loaderOverlay.show();
                                        bool result = await apiBLMVerificationCodeResend();
                                        context.loaderOverlay.hide();

                                        if(result == true){
                                          await showDialog(
                                            context: context,
                                            builder: (_) => AssetGiffyDialog(
                                              title: const Text('Success', textAlign: TextAlign.center, style: const TextStyle(fontSize: 32, fontFamily: 'NexaRegular',),),
                                              description: const Text('Another code has been sent to your email address. Please check your inbox.', textAlign: TextAlign.center, style: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular',),),
                                              image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                              entryAnimation: EntryAnimation.DEFAULT,
                                              onlyOkButton: true,
                                              onOkButtonPressed: (){
                                                Navigator.pop(context, true);
                                              },
                                            ),
                                          );
                                        }else{
                                          await showDialog(
                                            context: context,
                                            builder: (_) => AssetGiffyDialog(
                                              title: const Text('Error', textAlign: TextAlign.center, style: const TextStyle(fontSize: 32, fontFamily: 'NexaRegular',),),
                                              description: const Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular',),),
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
                                      },
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 120),

                              MiscBLMButtonTemplate(
                                buttonText: controller.text.length != 3 ? 'Next' : 'Sign Up',
                                buttonTextStyle: const TextStyle(fontSize: 24, color: const Color(0xffffffff), fontFamily: 'NexaBold'),
                                buttonColor: const Color(0xff000000),
                                width: SizeConfig.screenWidth! / 2,
                                height: 50,
                                onPressed: () async{
                                  if(controller.text.length != 3){
                                    await showDialog(
                                      context: context,
                                      builder: (_) => AssetGiffyDialog(
                                        title: const Text('Error', textAlign: TextAlign.center, style: const TextStyle(fontSize: 32, fontFamily: 'NexaRegular',),),
                                        description: const Text('Please enter the verification code.', textAlign: TextAlign.center, style: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular',),),
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
                                    String result = await apiBLMVerifyEmail(verificationCode: controller.text);
                                    context.loaderOverlay.hide();

                                    if(result == 'Success'){
                                      Navigator.pushNamed(context, '/blm/upload-photo');
                                    }else{
                                      await showDialog(
                                        context: context,
                                        builder: (_) => AssetGiffyDialog(
                                          title: const Text('Error', textAlign: TextAlign.center, style: const TextStyle(fontSize: 32, fontFamily: 'NexaRegular',),),
                                          description: Text('Error: $result', textAlign: TextAlign.center, style: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular',),),
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