import 'package:facesbyplaces/UI/Miscellaneous/misc-01-input-field.dart';
import 'package:facesbyplaces/UI/Miscellaneous/misc-02-dialog.dart';
import 'package:facesbyplaces/UI/Miscellaneous/misc-07-button.dart';
import 'package:facesbyplaces/UI/Miscellaneous/misc-08-background.dart';
import 'package:facesbyplaces/UI/Miscellaneous/misc-09-message.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/API/BLM/api-03-blm-verify-email.dart';
import 'package:facesbyplaces/Bloc/bloc-01-bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class BLMVerifyEmail extends StatelessWidget{

  final GlobalKey<MiscInputFieldOTPState> _key1 = GlobalKey();
  final GlobalKey<MiscInputFieldOTPState> _key2 = GlobalKey();
  final GlobalKey<MiscInputFieldOTPState> _key3 = GlobalKey();

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider<BlocUpdateButtonText>(create: (context) => BlocUpdateButtonText(),),
        BlocProvider<BlocShowMessage>(create: (context) => BlocShowMessage(),),
        BlocProvider<BlocShowLoading>(create: (context) => BlocShowLoading(),),
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
            body: BlocBuilder<BlocShowLoading, bool>(
              builder: (context, loading){
                return BlocBuilder<BlocShowMessage, bool>(
                  builder: (context, showMessage){
                    return BlocBuilder<BlocUpdateButtonText, int>(
                      builder: (context, textNumber){
                        return ((){
                          switch(loading){
                            case false: return Stack(
                              children: [

                                SingleChildScrollView(physics: NeverScrollableScrollPhysics(), child: Container(height: SizeConfig.screenHeight, child: MiscBackgroundTemplate(image: AssetImage('assets/icons/background2.png'),),),),

                                ((){ return showMessage ? MiscMessageTemplate() : Container(); }()),

                                SingleChildScrollView(
                                  physics: ClampingScrollPhysics(),
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 20.0, right: 20.0),
                                    child: Column(
                                      children: [

                                        SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                                        Align(alignment: Alignment.centerLeft, child: IconButton(onPressed: (){context.bloc<BlocUpdateButtonText>().reset(); Navigator.pop(context); }, icon: Icon(Icons.arrow_back, color: Color(0xff000000), size: SizeConfig.blockSizeVertical * 5,),),),

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
                                                  ..onTap = (){}
                                              ),
                                            ],
                                          ),
                                        ),

                                        SizedBox(height: SizeConfig.blockSizeVertical * 15,),

                                        MiscButtonTemplate(
                                          buttonText: textNumber == 3
                                          ? 'Sign Up'
                                          : 'Next',
                                          buttonTextStyle: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 5, fontWeight: FontWeight.bold, color: Color(0xffffffff),), 
                                          onPressed: () async{
                                            if(textNumber != 3){
                                              context.bloc<BlocShowMessage>().showMessage();
                                              Duration duration = Duration(seconds: 2);

                                              Future.delayed(duration, (){
                                                context.bloc<BlocShowMessage>().showMessage();
                                              });
                                            }else{
                                              context.bloc<BlocShowLoading>().modify(true);
                                              bool result = await apiBLMVerifyEmail();
                                              context.bloc<BlocShowLoading>().modify(false);

                                              context.bloc<BlocUpdateButtonText>().reset();

                                              if(result){
                                                Navigator.pushNamed(context, '/blm/blm-05-upload-photo'); 
                                              }else{
                                                await showDialog(context: (context), builder: (build) => MiscAlertDialog(title: 'Error', content: 'Something went wrong. Please try again.'));
                                              }

                                            }
                                          }, 
                                          width: SizeConfig.screenWidth / 2, 
                                          height: SizeConfig.blockSizeVertical * 7, 
                                          buttonColor: Color(0xff000000),
                                        ),

                                      ],
                                    ),
                                  ),
                                ),

                              ],
                            ); break;
                            case true: return Container(height: SizeConfig.screenHeight, child: Center(child: Container(child: SpinKitThreeBounce(color: Color(0xff000000), size: 50.0,), color: Color(0xffffffff),),)); break;
                          }
                        }());
                      },
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}