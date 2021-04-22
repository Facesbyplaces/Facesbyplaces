import 'package:facesbyplaces/API/Regular/01-Start/api-start-regular-03-verify-email.dart';
import 'package:facesbyplaces/API/Regular/01-Start/api-start-regular-10-verification-code-resend.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-06-regular-button.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-07-regular-background.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class RegularVerifyEmail extends StatefulWidget{

  RegularVerifyEmailState createState() => RegularVerifyEmailState();
}

class RegularVerifyEmailState extends State<RegularVerifyEmail>{

  final TextEditingController controller = TextEditingController(text: '');
  
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
                                  await showDialog(
                                    context: context,
                                    builder: (_) => 
                                      AssetGiffyDialog(
                                      image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                      title: Text('Success', textAlign: TextAlign.center, style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                                      entryAnimation: EntryAnimation.DEFAULT,
                                      description: Text('Another code has been sent to your email address. Please check your inbox.',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(),
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
                            await showDialog(
                              context: context,
                              builder: (_) => 
                                AssetGiffyDialog(
                                image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                title: Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                                entryAnimation: EntryAnimation.DEFAULT,
                                description: Text('Please enter the verification code.',
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
                            print('The inputted code is ${controller.text}');

                            String result = await apiRegularVerifyEmail(verificationCode: controller.text);
                            context.hideLoaderOverlay();

                            if(result == 'Success'){
                              Navigator.pushNamed(context, '/regular/upload-photo');
                            }else{
                              await showDialog(
                                context: context,
                                builder: (_) => 
                                  AssetGiffyDialog(
                                  image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                  title: Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                                  entryAnimation: EntryAnimation.DEFAULT,
                                  description: Text('Error: $result',
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