import 'package:facesbyplaces/API/Regular/01-Start/api-start-regular-03-verify-email.dart';
import 'package:facesbyplaces/API/Regular/01-Start/api-start-regular-10-verification-code-resend.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-06-regular-button.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-07-regular-background.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class RegularVerifyEmail extends StatefulWidget{
  final String verificationCode;
  RegularVerifyEmail({required this.verificationCode});

  RegularVerifyEmailState createState() => RegularVerifyEmailState(verificationCode: verificationCode);
}

class RegularVerifyEmailState extends State<RegularVerifyEmail>{
  final String verificationCode;
  RegularVerifyEmailState({required this.verificationCode});

  final TextEditingController controller = TextEditingController(text: '');

  void initState(){
    super.initState();
    controller.text = verificationCode;
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

              SingleChildScrollView(physics: NeverScrollableScrollPhysics(), child: Container(height: SizeConfig.screenHeight, child: MiscRegularBackgroundTemplate(image: AssetImage('assets/icons/background2.png'),),),),

              SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Column(
                    children: [

                      SizedBox(height: 20),

                      Align(
                        alignment: Alignment.centerLeft, 
                        child: IconButton(
                          onPressed: (){
                            Navigator.pop(context);
                          }, 
                          icon: Icon(Icons.arrow_back, color: Color(0xff000000), size: 30),
                        ),
                      ),

                      SizedBox(height: 40),

                      Center(child: Text('Verify Email', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Color(0xff000000),),),),

                      SizedBox(height: 40),

                      Center(child: Text('We have sent a verification code to your email address. Please enter the verification code to continue.', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300, color: Color(0xff000000),),),),

                      SizedBox(height: 40),

                      Padding(
                        padding: EdgeInsets.only(left: 20.0, right: 20.0),
                        child: PinPut(
                          fieldsAlignment: MainAxisAlignment.spaceEvenly,
                          controller: controller,
                          fieldsCount: 3,
                          textStyle: TextStyle(
                            fontSize: 56,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff000000)
                          ),
                          followingFieldDecoration: BoxDecoration(
                            border: Border(bottom: BorderSide(color: Color(0xff000000),),)
                          ),
                          selectedFieldDecoration: BoxDecoration(
                            border: Border(bottom: BorderSide(color: Color(0xff000000),),)
                          ),
                          submittedFieldDecoration: BoxDecoration(
                            border: Border(bottom: BorderSide(color: Color(0xff000000),),)
                          ),
                        ),
                      ),

                      SizedBox(height: 80),

                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Didn\'t receive a code? ', 
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w300,
                                color: Color(0xff000000),
                              ),
                            ),

                            TextSpan(
                              text: 'Resend',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff000000),
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () async{
                                  context.showLoaderOverlay();
                                  bool result = await apiRegularVerificationCodeResend();
                                  context.hideLoaderOverlay();

                                  if(result == true){
                                    await showOkAlertDialog(
                                      context: context,
                                      title: 'Success',
                                      message: 'Another code has been sent to your email address. Please check your inbox.',
                                    );
                                  }else{
                                    await showOkAlertDialog(
                                      context: context,
                                      title: 'Error',
                                      message: 'Something went wrong. Please try again.',
                                    );
                                  }
                                }
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 120),

                      MiscRegularButtonTemplate(
                        buttonText: controller.text.length != 3 ? 'Next' : 'Sign Up',
                        buttonTextStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold, 
                          color: Color(0xffffffff),
                        ),
                        onPressed: () async{

                          if(controller.text.length != 3){
                            await showOkAlertDialog(
                              context: context,
                              title: 'Error',
                              message: 'Please enter the verification code.',
                            );
                          }else{

                            context.showLoaderOverlay();
                            bool result = await apiRegularVerifyEmail(verificationCode: controller.text);
                            context.hideLoaderOverlay();

                            if(result){
                              Navigator.pushNamed(context, '/regular/upload-photo');
                            }else{
                              await showOkAlertDialog(
                                context: context,
                                title: 'Error',
                                message: 'Something went wrong. Please try again.',
                              );
                            }
                          }

                        }, 
                        width: SizeConfig.screenWidth! / 2, 
                        height: 45,
                        buttonColor: Color(0xff04ECFF),
                      ),

                      SizedBox(height: 40),
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