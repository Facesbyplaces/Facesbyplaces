import 'package:facesbyplaces/Bloc/bloc-01-bloc.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/UI/Miscellaneous/misc-01-input-field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BLMVerifyEmail extends StatelessWidget{

  static final GlobalKey<MiscInputFieldOTPState> _key1 = GlobalKey();
  static final GlobalKey<MiscInputFieldOTPState> _key2 = GlobalKey();
  static final GlobalKey<MiscInputFieldOTPState> _key3 = GlobalKey();

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Stack(
      children: [

        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/icons/background2.png'),
              colorFilter: ColorFilter.srgbToLinearGamma(),
            ),
          ),
        ),

        BlocBuilder<BlocShowMessage, bool>(
          builder: (context, state){
            return context.bloc<BlocShowMessage>().state 
            ? Padding(
              padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 8,),
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  height: SizeConfig.blockSizeVertical * 5,
                  width: SizeConfig.screenWidth / 1.2,
                  child: Center(
                    child: Text('Enter Verification Code', 
                      textAlign: TextAlign.center, 
                      style: TextStyle(
                        fontSize: SizeConfig.safeBlockHorizontal * 4,
                        fontWeight: FontWeight.w300,
                        color: Color(0xffffffff),
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xff000000),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),
              ),
            )
            : Container();
          },
        ),

        SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(left: 20.0, right: 20.0),
            child: Column(
              children: [

                SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: (){
                      context.bloc<BlocUpdateCubitBLM>().modify(2);
                      context.bloc<BlocUpdateButtonText>().reset();
                      context.bloc<BlocShowMessage>().reset();
                    },
                    icon: Icon(Icons.arrow_back, color: Color(0xff000000), size: SizeConfig.blockSizeVertical * 5),
                  ),
                ),

                SizedBox(height: SizeConfig.blockSizeVertical * 5,),

                Center(
                  child: Text('Verify Email', 
                    style: TextStyle(
                      fontSize: SizeConfig.safeBlockHorizontal * 8,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff000000)
                    ),
                  ),
                ),

                SizedBox(height: SizeConfig.blockSizeVertical * 5,),

                Center(
                  child: Text('We have sent a verification code to your email address. Please enter the verification code to continue.', 
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: SizeConfig.safeBlockHorizontal * 4,
                      fontWeight: FontWeight.w300,
                      color: Color(0xff000000)
                    ),
                  ),
                ),

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

                MaterialButton(
                  padding: EdgeInsets.zero,
                  onPressed: (){
                    if(context.bloc<BlocUpdateButtonText>().state != 3){
                      context.bloc<BlocShowMessage>().showMessage();
                      Duration duration = Duration(seconds: 2);

                      Future.delayed(duration, (){
                        context.bloc<BlocShowMessage>().showMessage();
                      });
                    }else{
                      context.bloc<BlocShowMessage>().reset();
                      context.bloc<BlocUpdateCubitBLM>().modify(4);
                      context.bloc<BlocUpdateButtonText>().reset();
                    }
                  },

                  child: BlocBuilder<BlocUpdateButtonText, int>(
                    builder: (context, state){
                      return context.bloc<BlocUpdateButtonText>().state == 3
                      ? Text('Sign Up',
                        style: TextStyle(
                          fontSize: SizeConfig.safeBlockHorizontal * 5,
                          fontWeight: FontWeight.bold,
                          color: Color(0xffffffff),
                        ),
                      )
                      : Text('Next',
                        style: TextStyle(
                          fontSize: SizeConfig.safeBlockHorizontal * 5,
                          fontWeight: FontWeight.bold,
                          color: Color(0xffffffff),
                        ),
                      );
                    },
                  ),
                  minWidth: SizeConfig.screenWidth / 2,
                  height: SizeConfig.blockSizeVertical * 7,
                  shape: StadiumBorder(),
                  color: Color(0xff000000),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

