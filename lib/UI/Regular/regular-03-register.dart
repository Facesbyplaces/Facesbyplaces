import 'package:facesbyplaces/API/Regular/01-Start/api-start-regular-02-registration.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-06-regular-input-field.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-07-regular-button.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-08-regular-dialog.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-10-regular-background.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class RegularRegister extends StatelessWidget{

  final GlobalKey<MiscRegularInputFieldTemplateState> _key1 = GlobalKey<MiscRegularInputFieldTemplateState>();
  final GlobalKey<MiscRegularInputFieldTemplateState> _key2 = GlobalKey<MiscRegularInputFieldTemplateState>();
  final GlobalKey<MiscRegularPhoneNumberTemplateState> _key3 = GlobalKey<MiscRegularPhoneNumberTemplateState>();
  final GlobalKey<MiscRegularInputFieldTemplateState> _key4 = GlobalKey<MiscRegularInputFieldTemplateState>();
  final GlobalKey<MiscRegularInputFieldTemplateState> _key5 = GlobalKey<MiscRegularInputFieldTemplateState>();
  final GlobalKey<MiscRegularInputFieldTemplateState> _key6 = GlobalKey<MiscRegularInputFieldTemplateState>();

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    ResponsiveWidgets.init(context,
      height: SizeConfig.screenHeight,
      width: SizeConfig.screenWidth,
    );
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
          body: ContainerResponsive(
            height: SizeConfig.screenHeight,
            width: SizeConfig.screenWidth,
            alignment: Alignment.center,
            child: ContainerResponsive(
              width: SizeConfig.screenWidth,
              heightResponsive: false,
              widthResponsive: true,
              alignment: Alignment.center,
              child: Stack(
                children: [

                  SingleChildScrollView(
                    physics: NeverScrollableScrollPhysics(), 
                    child: Container(
                      height: SizeConfig.screenHeight, 
                      child: MiscRegularBackgroundTemplate(
                        image: AssetImage('assets/icons/background2.png'),
                      ),
                    ),
                  ),

                  Container(
                    height: SizeConfig.screenHeight / 6, 
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover, 
                        image: AssetImage('assets/icons/regular-background.png'),
                      ),
                    ),
                  ),

                  Column(
                    children: [
                      SizedBox(height: SizeConfig.screenHeight / 6),

                      Expanded(
                        child: SingleChildScrollView(
                          physics: ClampingScrollPhysics(),
                          padding: EdgeInsets.only(left: 20.0, right: 20.0),
                          child: Column(
                            children: [

                              MiscRegularInputFieldTemplate(
                                key: _key1, 
                                labelText: 'Your Name', 
                                type: TextInputType.name, 
                                labelTextStyle: TextStyle(
                                  // fontSize: SizeConfig.safeBlockHorizontal * 4,
                                  fontSize: ScreenUtil().setSp(14, allowFontScalingSelf: true),
                                  fontWeight: FontWeight.w400, 
                                  color: Colors.grey,
                                ),
                              ),
                              
                              SizedBox(height: SizeConfig.blockSizeVertical * 2,),
                              
                              MiscRegularInputFieldTemplate(
                                key: _key2, 
                                labelText: 'Last Name', 
                                type: TextInputType.name, 
                                labelTextStyle: TextStyle(
                                  // fontSize: SizeConfig.safeBlockHorizontal * 4,
                                  fontSize: ScreenUtil().setSp(14, allowFontScalingSelf: true),
                                  fontWeight: FontWeight.w400, 
                                  color: Colors.grey,
                                ),
                              ),

                              SizedBox(height: SizeConfig.blockSizeVertical * 2,),
                              
                              MiscRegularPhoneNumberTemplate(
                                key: _key3, 
                                labelText: 'Mobile #', 
                                type: TextInputType.phone, 
                                labelTextStyle: TextStyle(
                                  // fontSize: SizeConfig.safeBlockHorizontal * 4,
                                  fontSize: ScreenUtil().setSp(14, allowFontScalingSelf: true),
                                  fontWeight: FontWeight.w400, 
                                  color: Colors.grey,
                                ),
                              ),

                              SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                              MiscRegularInputFieldTemplate(
                                key: _key4, 
                                labelText: 'Email Address', 
                                type: TextInputType.emailAddress, 
                                labelTextStyle: TextStyle(
                                  // fontSize: SizeConfig.safeBlockHorizontal * 4,
                                  fontSize: ScreenUtil().setSp(14, allowFontScalingSelf: true),
                                  fontWeight: FontWeight.w400, 
                                  color: Colors.grey,
                                ),
                              ),

                              SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                              MiscRegularInputFieldTemplate(
                                key: _key5, 
                                labelText: 'Username', 
                                type: TextInputType.text, 
                                labelTextStyle: TextStyle(
                                  // fontSize: SizeConfig.safeBlockHorizontal * 4,
                                  fontSize: ScreenUtil().setSp(14, allowFontScalingSelf: true),
                                  fontWeight: FontWeight.w400, 
                                  color: Colors.grey,
                                ),
                              ),

                              SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                              MiscRegularInputFieldTemplate(
                                key: _key6, 
                                labelText: 'Password', 
                                type: TextInputType.text, 
                                labelTextStyle: TextStyle(
                                  // fontSize: SizeConfig.safeBlockHorizontal * 4,
                                  fontSize: ScreenUtil().setSp(14, allowFontScalingSelf: true),
                                  fontWeight: FontWeight.w400, 
                                  color: Colors.grey,
                                ), 
                                obscureText: true,
                              ),

                              SizedBox(height: SizeConfig.blockSizeVertical * 5,),

                              MiscRegularButtonTemplate(
                                buttonText: 'Next', 
                                buttonTextStyle: TextStyle(
                                  // fontSize: SizeConfig.safeBlockHorizontal * 5,
                                  fontSize: ScreenUtil().setSp(16, allowFontScalingSelf: true),
                                  fontWeight: FontWeight.bold, 
                                  color: Color(0xffffffff),
                                ),
                                onPressed: () async{
                                  bool validEmail = false;
                                  validEmail = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(_key4.currentState.controller.text );

                                  if(_key1.currentState.controller.text == '' || _key2.currentState.controller.text == '' ||
                                    _key4.currentState.controller.text == '' || _key5.currentState.controller.text == '' || _key6.currentState.controller.text == ''){
                                    await showDialog(context: context, builder: (build) => MiscRegularAlertDialog(title: 'Error', content: 'Please complete the form before submitting.', confirmText: 'OK',),);
                                  }else if(!validEmail){
                                    await showDialog(context: context, builder: (build) => MiscRegularAlertDialog(title: 'Error', content: 'Invalid email address. Please try again.', confirmText: 'OK',),);
                                  }else if(!_key3.currentState.valid){
                                    await showDialog(context: context, builder: (build) => MiscRegularAlertDialog(title: 'Error', content: 'Invalid phone number. Please try again.', confirmText: 'OK',),);
                                  }else{
                                    APIRegularAccountRegistration account = APIRegularAccountRegistration(
                                      firstName: _key1.currentState.controller.text, 
                                      lastName: _key2.currentState.controller.text,
                                      phoneNumber: _key3.currentState.controller.text,
                                      email: _key4.currentState.controller.text,
                                      username: _key5.currentState.controller.text,
                                      password: _key6.currentState.controller.text,
                                    );

                                    context.showLoaderOverlay();
                                    String result = await apiRegularRegistration(account);
                                    context.hideLoaderOverlay();

                                    if(result == 'Success'){
                                      final sharedPrefs = await SharedPreferences.getInstance();
                                      String verificationCode = sharedPrefs.getString('regular-verification-code');
                                      Navigator.pushNamed(context, '/regular/verify-email', arguments: verificationCode);
                                    }else{
                                      await showDialog(context: context, builder: (build) => MiscRegularAlertDialog(title: 'Error', content: result));
                                    }
                                  }

                                }, 
                                width: SizeConfig.screenWidth / 2, 
                                // height: SizeConfig.blockSizeVertical * 7,
                                height: ScreenUtil().setHeight(45),
                                buttonColor: Color(0xff04ECFF),
                              ),

                              SizedBox(height: SizeConfig.blockSizeVertical * 3,),

                              RichText(
                                text: TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: 'Already have an account? ', 
                                      style: TextStyle(
                                        // fontSize: SizeConfig.safeBlockHorizontal * 4,
                                        fontSize: ScreenUtil().setSp(16, allowFontScalingSelf: true),
                                        color: Color(0xff000000),
                                      ),
                                    ),

                                    TextSpan(
                                      text: 'Login', 
                                      style: TextStyle(
                                        // fontSize: SizeConfig.safeBlockHorizontal * 4,
                                        fontSize: ScreenUtil().setSp(16, allowFontScalingSelf: true),
                                        color: Color(0xff04ECFF),
                                      ),
                                      recognizer: TapGestureRecognizer()
                                      ..onTap = (){
                                        Navigator.pushNamed(context, '/regular/login');
                                      }
                                    ),
                                  ],
                                ),
                              ),
                              
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  Column(
                    children: [
                      SizedBox(height: SizeConfig.blockSizeVertical * 2,),
                      
                      Align(
                        alignment: Alignment.topLeft, 
                        child: IconButton(
                          onPressed: (){
                            Navigator.pop(context);
                          }, 
                          icon: Icon(
                            Icons.arrow_back, 
                            color: Color(0xffffffff), 
                            // size: SizeConfig.blockSizeVertical * 5,
                            size: ScreenUtil().setHeight(30),
                          ),
                        ),
                      ),

                    ],
                  ),

                ],
              ),
            ),
          ),

        ),
      ),
    );
  }
}