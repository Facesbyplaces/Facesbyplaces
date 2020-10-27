import 'package:facesbyplaces/Bloc/bloc-01-bloc.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/UI/Miscellaneous/misc-01-input-field.dart';
import 'package:facesbyplaces/UI/Miscellaneous/misc-07-button.dart';
import 'package:facesbyplaces/UI/Miscellaneous/misc-08-background.dart';
import 'package:facesbyplaces/UI/Miscellaneous/misc-09-message.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BLMVerifyEmail extends StatelessWidget{

  final GlobalKey<MiscInputFieldOTPState> _key1 = GlobalKey();
  final GlobalKey<MiscInputFieldOTPState> _key2 = GlobalKey();
  final GlobalKey<MiscInputFieldOTPState> _key3 = GlobalKey();

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider<BlocUpdateButtonText>(
          create: (context) => BlocUpdateButtonText(),
        ),
        BlocProvider<BlocShowMessage>(
          create: (context) => BlocShowMessage(),
        ),
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
            body: Stack(
              children: [

                MiscBackgroundTemplate(image: AssetImage('assets/icons/background2.png'),),

                BlocBuilder<BlocShowMessage, bool>(
                  builder: (context, state){
                    return state
                    ? MiscMessageTemplate()
                    : Container();
                  },
                ),


                SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Column(
                      children: [

                        SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                        BlocBuilder<BlocUpdateButtonText, int>(
                          builder: (context, state){
                            return Align(
                              alignment: Alignment.centerLeft, 
                              child: IconButton(
                                onPressed: (){
                                  context.bloc<BlocUpdateButtonText>().reset();
                                  Navigator.pop(context);
                                }, 
                                icon: Icon(Icons.arrow_back, color: Color(0xff000000), size: SizeConfig.blockSizeVertical * 5,),
                              ),
                            );
                          }
                        ),

                        SizedBox(height: SizeConfig.blockSizeVertical * 5,),

                        Center(child: Text('Verify Email', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 8, fontWeight: FontWeight.bold, color: Color(0xff000000),),),),

                        SizedBox(height: SizeConfig.blockSizeVertical * 5,),

                        Center(child: Text('We have sent a verification code to your email address. Please enter the verification code to continue.', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, fontWeight: FontWeight.w300, color: Color(0xff000000),),),),

                        SizedBox(height: SizeConfig.blockSizeVertical * 5,),

                        Padding(
                          padding: EdgeInsets.only(left: 20.0, right: 20.0),
                          child: Row(
                            children: [
                              Expanded(child: MiscInputFieldOTP(key: _key1,),),

                              SizedBox(width: SizeConfig.blockSizeHorizontal * 5,),

                              Expanded(child: MiscInputFieldOTP(key: _key2,),),

                              SizedBox(width: SizeConfig.blockSizeHorizontal * 5,),

                              Expanded(child: MiscInputFieldOTP(key: _key3,),),
                            ],
                          ),
                        ),

                        SizedBox(height: SizeConfig.blockSizeVertical * 10,),

                        RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Didn\'t receive a code? ', 
                                style: TextStyle(
                                  fontSize: SizeConfig.safeBlockHorizontal * 5,
                                  fontWeight: FontWeight.w300,
                                  color: Color(0xff000000),
                                ),
                              ),

                              TextSpan(
                                text: 'Resend',
                                style: TextStyle(
                                  fontSize: SizeConfig.safeBlockHorizontal * 5,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff000000),
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = (){
                                  }
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: SizeConfig.blockSizeVertical * 15,),

                        BlocBuilder<BlocUpdateButtonText, int>(
                          builder: (context, state){
                            return state == 3
                            ? MiscButtonTemplate(
                              buttonText: 'Sign Up', 
                              buttonTextStyle: TextStyle(
                                fontSize: SizeConfig.safeBlockHorizontal * 5, 
                                fontWeight: FontWeight.bold, 
                                color: Color(0xffffffff),
                              ), 
                              onPressed: (){
                                Navigator.pop(context); context.bloc<BlocUpdateButtonText>().reset();
                                Navigator.pushNamed(context, 'blm/blm-05-upload-photo'); 
                              }, 
                              width: SizeConfig.screenWidth / 2, 
                              height: SizeConfig.blockSizeVertical * 8, 
                              buttonColor: Color(0xff04ECFF),
                            ) : MiscButtonTemplate(
                              buttonText: 'Next', 
                              buttonTextStyle: TextStyle(
                                fontSize: SizeConfig.safeBlockHorizontal * 5, 
                                fontWeight: FontWeight.bold, 
                                color: Color(0xffffffff),
                              ), 
                              onPressed: (){
                                context.bloc<BlocShowMessage>().showMessage();
                                Duration duration = Duration(seconds: 2);

                                Future.delayed(duration, (){
                                  context.bloc<BlocShowMessage>().showMessage();
                                });
                              }, 
                              width: SizeConfig.screenWidth / 2, 
                              height: SizeConfig.blockSizeVertical * 8, 
                              buttonColor: Color(0xff000000),
                            );
                          }
                        ),

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