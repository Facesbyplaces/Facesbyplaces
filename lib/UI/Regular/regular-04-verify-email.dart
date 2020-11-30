import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-07-regular-button.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-08-regular-dialog.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-10-regular-background.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-14-regular-message.dart';
import 'package:facesbyplaces/API/Regular/api-03-regular-verify-email.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/Bloc/bloc-01-bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
            body: BlocBuilder<BlocUpdateButtonText, int>(
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

                                Align(alignment: Alignment.centerLeft, child: IconButton(onPressed: (){context.bloc<BlocUpdateButtonText>().reset(); Navigator.pop(context); }, icon: Icon(Icons.arrow_back, color: Color(0xff000000), size: SizeConfig.blockSizeVertical * 5,),),),

                                SizedBox(height: SizeConfig.blockSizeVertical * 5,),

                                Center(child: Text('Verify Email', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 8, fontWeight: FontWeight.bold, color: Color(0xff000000),),),),

                                SizedBox(height: SizeConfig.blockSizeVertical * 5,),

                                Center(child: Text('We have sent a verification code to your email address. Please enter the verification code to continue.', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, fontWeight: FontWeight.w300, color: Color(0xff000000),),),),

                                SizedBox(height: SizeConfig.blockSizeVertical * 5,),

                                Padding(
                                  padding: EdgeInsets.only(left: 20.0, right: 20.0),
                                  child: PinPut(
                                    controller: controller,
                                    fieldsCount: 3,
                                    textStyle: TextStyle(
                                      fontSize: SizeConfig.safeBlockHorizontal * 15,
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

                                MiscRegularButtonTemplate(
                                  buttonText: controller.text.length != 3 ? 'Next' : 'Sign Up',
                                  buttonTextStyle: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 5, fontWeight: FontWeight.bold, color: Color(0xffffffff),),
                                  onPressed: () async{

                                    if(controller.text.length != 3){
                                      context.bloc<BlocShowMessage>().showMessage();
                                      Duration duration = Duration(seconds: 2);

                                      Future.delayed(duration, (){
                                        context.bloc<BlocShowMessage>().showMessage();
                                      });
                                    }else{

                                      context.showLoaderOverlay();
                                      bool result = await apiRegularVerifyEmail(controller.text);
                                      context.hideLoaderOverlay();

                                      context.bloc<BlocUpdateButtonText>().reset();

                                      if(result){
                                        Navigator.pushNamed(context, '/regular/regular-05-upload-photo');
                                      }else{
                                        await showDialog(context: (context), builder: (build) => MiscRegularAlertDialog(title: 'Error', content: 'Something went wrong. Please try again.', color: Colors.red,));
                                      }
                                      
                                    }
                                  }, 
                                  width: SizeConfig.screenWidth / 2, 
                                  height: SizeConfig.blockSizeVertical * 7,
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
    );
  }
}