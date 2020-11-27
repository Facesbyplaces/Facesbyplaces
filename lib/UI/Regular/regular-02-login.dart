import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-06-regular-input-field.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-07-regular-button.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-08-regular-dialog.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-10-regular-background.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/API/Regular/api-01-regular-login.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class RegularLogin extends StatelessWidget {

  final GlobalKey<MiscRegularInputFieldTemplateState> _key1 = GlobalKey<MiscRegularInputFieldTemplateState>();
  final GlobalKey<MiscRegularInputFieldTemplateState> _key2 = GlobalKey<MiscRegularInputFieldTemplateState>();

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
          body: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Stack(
              children: [

                Container(height: SizeConfig.screenHeight, child: MiscRegularBackgroundTemplate(image: AssetImage('assets/icons/background2.png'),),),

                Container(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0),
                  height: SizeConfig.screenHeight,
                  child: Column(
                    children: [

                      SizedBox(height: SizeConfig.blockSizeVertical * 5,),

                      Align(alignment: Alignment.centerLeft, child: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back, color: Color(0xff000000), size: SizeConfig.blockSizeVertical * 5),),),

                      SizedBox(height: SizeConfig.blockSizeVertical * 3,),

                      Container(padding: EdgeInsets.only(left: 20.0), alignment: Alignment.centerLeft, child: Text('Login', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 7, fontWeight: FontWeight.bold, color: Color(0xff000000),),),),

                      SizedBox(height: SizeConfig.blockSizeVertical * 3,),

                      Padding(
                        padding: EdgeInsets.only(left: 20.0, right: 20.0,),
                        child: Row(
                          children: [
                            Expanded(child: MiscRegularButtonSignInWithTemplate(buttonText: 'Facebook', buttonColor: Color(0xff3A559F), buttonTextStyle: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, fontWeight: FontWeight.w300, color: Color(0xffffffff)), onPressed: (){}, width: SizeConfig.screenWidth / 1.5, height: SizeConfig.blockSizeVertical * 7,),),

                            SizedBox(width: SizeConfig.blockSizeHorizontal * 10,),

                            Expanded(
                              child: MiscRegularButtonSignInWithTemplate(buttonText: 'Google', buttonColor: Color(0xffF5F5F5), buttonTextStyle: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, fontWeight: FontWeight.w300, color: Color(0xff000000)), onPressed: (){}, width: SizeConfig.screenWidth / 1.5, height: SizeConfig.blockSizeVertical * 7, image: 'assets/icons/google.png'),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: SizeConfig.blockSizeVertical * 5,),

                      Center(child: Text('or log in with email', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, fontWeight: FontWeight.w300, color: Color(0xff000000),),),),

                      SizedBox(height: SizeConfig.blockSizeVertical * 5,),

                      Padding(padding: EdgeInsets.only(left: 20.0, right: 20.0), child: MiscRegularInputFieldTemplate(key: _key1, labelText: 'Email Address', type: TextInputType.emailAddress,),),

                      SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                      Padding(padding: EdgeInsets.only(left: 20.0, right: 20.0), child: MiscRegularInputFieldTemplate(key: _key2, labelText: 'Password', type: TextInputType.text, obscureText: true,),),

                      SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                      Align(alignment: Alignment.centerRight, child: Text('Forgot Password?', style: TextStyle(decoration: TextDecoration.underline, fontSize: SizeConfig.safeBlockHorizontal * 3.5, fontWeight: FontWeight.w400,),),),

                      Expanded(child: Container(),),

                      MiscRegularButtonTemplate(
                        buttonText: 'Login', 
                        buttonTextStyle: TextStyle(
                          fontSize: SizeConfig.safeBlockHorizontal * 5, 
                          fontWeight: FontWeight.bold, 
                          color: Color(0xffffffff),
                        ), 
                        onPressed: () async{
                          
                          bool validEmail = false;
                          validEmail = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(_key1.currentState.controller.text );

                          if(_key1.currentState.controller.text == '' || _key2.currentState.controller.text == ''){
                            await showDialog(context: context, builder: (build) => MiscRegularAlertDialog(title: 'Error', content: 'Please complete the form before submitting.', confirmText: 'OK',),);
                          }else if(!validEmail){
                            await showDialog(context: context, builder: (build) => MiscRegularAlertDialog(title: 'Error', content: 'Invalid email address. Please try again.', confirmText: 'OK',),);
                          }else{

                            context.showLoaderOverlay();
                            bool result = await apiRegularLogin(_key1.currentState.controller.text, _key2.currentState.controller.text);
                            context.hideLoaderOverlay();

                            if(result){
                              Navigator.pushReplacementNamed(context, '/home/regular');
                            }else{
                              await showDialog(context: context, builder: (build) => MiscRegularAlertDialog(title: 'Error', content: 'Invalid email or password. Please try again.'));
                            }
                          }
                          
                        }, 
                        width: SizeConfig.screenWidth / 2, 
                        height: SizeConfig.blockSizeVertical * 7, 
                        buttonColor: Color(0xff4EC9D4),
                      ),

                      SizedBox(height: SizeConfig.blockSizeVertical * 5,),

                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Don\'t have an Account? ', 
                              style: TextStyle(
                                fontSize: SizeConfig.safeBlockHorizontal * 4,
                                color: Color(0xff000000),
                              ),
                            ),

                            TextSpan(
                              text: 'Sign Up', 
                              style: TextStyle(
                                fontSize: SizeConfig.safeBlockHorizontal * 4,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff4EC9D4),
                              ),
                              recognizer: TapGestureRecognizer()
                              ..onTap = (){
                                Navigator.pushNamed(context, '/regular/regular-03-register');
                              }
                            ),

                          ],
                        ),
                      ),

                      SizedBox(height: SizeConfig.blockSizeVertical * 1,),

                      GestureDetector(
                        onTap: (){
                          Navigator.pushReplacementNamed(context, '/home/regular');
                        },
                        child: Text('Sign in as Guest',
                          style: TextStyle(
                            fontSize: SizeConfig.safeBlockHorizontal * 4,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff4EC9D4),
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),

                      SizedBox(height: SizeConfig.blockSizeVertical * 1,),

                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Connect    /    ', 
                              style: TextStyle(
                                fontSize: SizeConfig.safeBlockHorizontal * 4,
                                fontWeight: FontWeight.w300,
                                color: Color(0xff888888),
                              ),
                            ),

                            TextSpan(
                              text: 'Remember    /    ',
                              style: TextStyle(
                                fontSize: SizeConfig.safeBlockHorizontal * 4,
                                fontWeight: FontWeight.w300,
                                color: Color(0xff888888),
                              ),
                            ),

                            TextSpan(
                              text: 'Honor',
                              style: TextStyle(
                                fontSize: SizeConfig.safeBlockHorizontal * 4,
                                fontWeight: FontWeight.w300,
                                color: Color(0xff888888),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: SizeConfig.blockSizeVertical * 2,),
                      
                    ],
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

