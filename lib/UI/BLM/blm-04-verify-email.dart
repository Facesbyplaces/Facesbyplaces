import 'package:facesbyplaces/API/BLM/01-Start/api-start-blm-03-verify-email.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-02-blm-dialog.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-07-blm-button.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-08-blm-background.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-09-blm-message.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:facesbyplaces/Bloc/bloc-01-bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class BLMVerifyEmail extends StatefulWidget{

  BLMVerifyEmailState createState() => BLMVerifyEmailState();
}

class BLMVerifyEmailState extends State<BLMVerifyEmail>{

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
                child: BlocBuilder<BlocShowMessage, bool>(
                  builder: (context, showMessage){
                    return BlocBuilder<BlocUpdateButtonText, int>(
                      builder: (context, textNumber){
                        return Stack(
                          children: [

                            SingleChildScrollView(physics: NeverScrollableScrollPhysics(), child: Container(height: SizeConfig.screenHeight, child: MiscBLMBackgroundTemplate(image: AssetImage('assets/icons/background2.png'),),),),

                            ((){ return showMessage ? MiscBLMMessageTemplate() : Container(); }()),

                            SingleChildScrollView(
                              physics: ClampingScrollPhysics(),
                              child: Padding(
                                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                                child: Column(
                                  children: [

                                    SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                                    Align(alignment: Alignment.centerLeft, child: IconButton(onPressed: (){context.bloc<BlocUpdateButtonText>().reset(); Navigator.pop(context); }, icon: Icon(Icons.arrow_back, color: Color(0xff000000), size: ScreenUtil().setHeight(30),),),),

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
                                              ..onTap = (){}
                                          ),
                                        ],
                                      ),
                                    ),

                                    SizedBox(height: SizeConfig.blockSizeVertical * 15,),

                                    MiscBLMButtonTemplate(
                                      buttonText: controller.text.length != 3 ? 'Next' : 'Sign Up',
                                      buttonTextStyle: TextStyle(fontSize: ScreenUtil().setSp(16, allowFontScalingSelf: true), fontWeight: FontWeight.bold, color: Color(0xffffffff),), 
                                      onPressed: () async{
                                        if(controller.text.length != 3){
                                          context.bloc<BlocShowMessage>().showMessage();
                                          Duration duration = Duration(seconds: 2);

                                          Future.delayed(duration, (){
                                            context.bloc<BlocShowMessage>().showMessage();
                                          });
                                        }else{

                                          context.showLoaderOverlay();
                                          bool result = await apiBLMVerifyEmail(verificationCode: controller.text);
                                          context.hideLoaderOverlay();

                                          context.bloc<BlocUpdateButtonText>().reset();

                                          if(result){
                                            Navigator.pushNamed(context, '/blm/upload-photo'); 
                                          }else{
                                            await showDialog(context: (context), builder: (build) => MiscBLMAlertDialog(title: 'Error', content: 'Something went wrong. Please try again.'));
                                          }

                                        }

                                      }, 
                                      width: SizeConfig.screenWidth / 2, 
                                      height: ScreenUtil().setHeight(45),
                                      buttonColor: Color(0xff000000),
                                    ),

                                    SizedBox(height: ScreenUtil().setHeight(10)),

                                  ],
                                ),
                              ),
                            ),

                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}