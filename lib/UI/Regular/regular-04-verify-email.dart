import 'package:facesbyplaces/API/Regular/01-Start/api-start-regular-03-verify-email.dart';
import 'package:facesbyplaces/API/Regular/01-Start/api-start-regular-11-verification-code-resend.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-07-regular-button.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-08-regular-background.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-09-regular-message.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:facesbyplaces/Bloc/bloc-01-bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class RegularVerifyEmail extends StatefulWidget{

  RegularVerifyEmailState createState() => RegularVerifyEmailState();
}

class RegularVerifyEmailState extends State<RegularVerifyEmail>{

  final TextEditingController controller = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    String verificationCode = ModalRoute.of(context).settings.arguments;
    controller.text = verificationCode;
    ResponsiveWidgets.init(context,
      height: SizeConfig.screenHeight,
      width: SizeConfig.screenWidth,
    );
    return MultiBlocProvider(
      providers: [
        BlocProvider<BlocUpdateButtonText>(create: (context) => BlocUpdateButtonText(),),
        BlocProvider<BlocShowMessage>(create: (context) => BlocShowMessage(),),
      ],
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
            body: ContainerResponsive(
              height: SizeConfig.screenHeight,
              width: SizeConfig.screenWidth,
              alignment: Alignment.center,
              child: ContainerResponsive(
                width: SizeConfig.screenWidth,
                heightResponsive: false,
                widthResponsive: true,
                alignment: Alignment.center,
                child: BlocBuilder<BlocUpdateButtonText, int>(
                  builder: (context, textNumber){
                    return BlocBuilder<BlocShowMessage, bool>(
                      builder: (context, showMessage){
                        return Stack(
                          children: [

                            SingleChildScrollView(physics: NeverScrollableScrollPhysics(), child: Container(height: SizeConfig.screenHeight, child: MiscRegularBackgroundTemplate(image: AssetImage('assets/icons/background2.png'),),),),

                            ((){ return showMessage ? MiscRegularMessageTemplate() : Container(); }()),

                            SingleChildScrollView(
                              physics: ClampingScrollPhysics(),
                              child: Padding(
                                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                                child: Column(
                                  children: [

                                    SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                                    Align(alignment: Alignment.centerLeft, child: IconButton(onPressed: (){context.read<BlocUpdateButtonText>().reset(); Navigator.pop(context); }, icon: Icon(Icons.arrow_back, color: Color(0xff000000), size: ScreenUtil().setHeight(30),),),),

                                    SizedBox(height: SizeConfig.blockSizeVertical * 5,),

                                    Center(child: Text('Verify Email', style: TextStyle(fontSize: ScreenUtil().setSp(30, allowFontScalingSelf: true), fontWeight: FontWeight.bold, color: Color(0xff000000),),),),

                                    SizedBox(height: SizeConfig.blockSizeVertical * 5,),

                                    Center(child: Text('We have sent a verification code to your email address. Please enter the verification code to continue.', textAlign: TextAlign.center, style: TextStyle(fontSize: ScreenUtil().setSp(16, allowFontScalingSelf: true), fontWeight: FontWeight.w300, color: Color(0xff000000),),),),

                                    SizedBox(height: SizeConfig.blockSizeVertical * 5,),

                                    Padding(
                                      padding: EdgeInsets.only(left: 20.0, right: 20.0),
                                      child: PinPut(
                                        controller: controller,
                                        fieldsCount: 3,
                                        textStyle: TextStyle(
                                          fontSize: ScreenUtil().setSp(56, allowFontScalingSelf: true),
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xff000000)
                                        ),
                                        followingFieldDecoration: BoxDecoration(
                                          border: Border(bottom: BorderSide(color: Color(0xff000000), width: SizeConfig.blockSizeVertical * .1))
                                        ),
                                        selectedFieldDecoration: BoxDecoration(
                                          border: Border(bottom: BorderSide(color: Color(0xff000000), width: SizeConfig.blockSizeVertical * .1))
                                        ),
                                        submittedFieldDecoration: BoxDecoration(
                                          border: Border(bottom: BorderSide(color: Color(0xff000000), width: SizeConfig.blockSizeVertical * .1))
                                        ),
                                      ),
                                    ),

                                    SizedBox(height: SizeConfig.blockSizeVertical * 10,),

                                    RichText(
                                      text: TextSpan(
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: 'Didn\'t receive a code? ', 
                                            style: TextStyle(
                                              fontSize: ScreenUtil().setSp(18, allowFontScalingSelf: true),
                                              fontWeight: FontWeight.w300,
                                              color: Color(0xff000000),
                                            ),
                                          ),

                                          TextSpan(
                                            text: 'Resend',
                                            style: TextStyle(
                                              fontSize: ScreenUtil().setSp(18, allowFontScalingSelf: true),
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
                                                  // await showDialog(context: context, builder: (build) => MiscRegularAlertDialog(title: 'Success', content: 'Another code has been sent to your email address. Please check your inbox.', confirmText: 'OK', color: Colors.green,),);
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
                                                      buttonOkColor: Colors.green,
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

                                    SizedBox(height: SizeConfig.blockSizeVertical * 15,),

                                    MiscRegularButtonTemplate(
                                      buttonText: controller.text.length != 3 ? 'Next' : 'Sign Up',
                                      buttonTextStyle: TextStyle(
                                        fontSize: ScreenUtil().setSp(16, allowFontScalingSelf: true),
                                        fontWeight: FontWeight.bold, 
                                        color: Color(0xffffffff),
                                      ),
                                      onPressed: () async{

                                        if(controller.text.length != 3){
                                          context.read<BlocShowMessage>().showMessage();
                                          Duration duration = Duration(seconds: 2);

                                          Future.delayed(duration, (){
                                            context.read<BlocShowMessage>().showMessage();
                                          });
                                        }else{

                                          context.showLoaderOverlay();
                                          bool result = await apiRegularVerifyEmail(verificationCode: controller.text);
                                          context.hideLoaderOverlay();

                                          context.read<BlocUpdateButtonText>().reset();

                                          if(result){
                                            Navigator.pushNamed(context, '/regular/upload-photo');
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
                                      width: SizeConfig.screenWidth / 2, 
                                      height: ScreenUtil().setHeight(45),
                                      buttonColor: Color(0xff04ECFF),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  }
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}