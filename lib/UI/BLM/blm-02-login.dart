import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/UI/Miscellaneous/misc-01-input-field.dart';
import 'package:facesbyplaces/UI/Miscellaneous/misc-07-button.dart';
import 'package:facesbyplaces/UI/Miscellaneous/misc-08-background.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class BLMLogin extends StatelessWidget {

  final GlobalKey<MiscInputFieldTemplateState> _key1 = GlobalKey<MiscInputFieldTemplateState>();
  final GlobalKey<MiscInputFieldTemplateState> _key2 = GlobalKey<MiscInputFieldTemplateState>();

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      body: Stack(
        children: [

          MiscBackgroundTemplate(image: AssetImage('assets/icons/background2.png'),),

          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(left: 20.0, right: 20.0),
              child: Column(
                children: [

                  SizedBox(height: SizeConfig.blockSizeVertical * 5,),

                  Align(alignment: Alignment.centerLeft, child: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back, color: Color(0xff000000), size: SizeConfig.blockSizeVertical * 5),),),

                  SizedBox(height: SizeConfig.blockSizeVertical * 3,),

                  Container(padding: EdgeInsets.only(left: 20.0), alignment: Alignment.centerLeft, child: Text('Login', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 8, fontWeight: FontWeight.bold, color: Color(0xff000000),),),),

                  SizedBox(height: SizeConfig.blockSizeVertical * 3,),

                  Padding(
                    padding: EdgeInsets.only(left: 20.0, right: 20.0,),

                    child: Row(
                      children: [
                        Expanded(child: MiscButtonSignInWithTemplate(buttonText: 'Facebook', buttonColor: Color(0xff3A559F), buttonTextStyle: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, fontWeight: FontWeight.w300, color: Color(0xffffffff)), onPressed: (){}, width: SizeConfig.screenWidth / 1.5, height: SizeConfig.blockSizeVertical * 8,),),

                        SizedBox(width: SizeConfig.blockSizeHorizontal * 10,),

                        Expanded(
                          child: MiscButtonSignInWithTemplate(buttonText: 'Google', buttonColor: Color(0xffF5F5F5), buttonTextStyle: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, fontWeight: FontWeight.w300, color: Color(0xff000000)), onPressed: (){}, width: SizeConfig.screenWidth / 1.5, height: SizeConfig.blockSizeVertical * 8, image: 'assets/icons/google.png'),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: SizeConfig.blockSizeVertical * 5,),

                  Center(child: Text('or log in with email', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, fontWeight: FontWeight.w300, color: Color(0xff000000),),),),

                  SizedBox(height: SizeConfig.blockSizeVertical * 5,),

                  Padding(padding: EdgeInsets.only(left: 20.0, right: 20.0), child: MiscInputFieldTemplate(key: _key1, labelText: 'Email Address', type: TextInputType.emailAddress,),),

                  SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                  Padding(padding: EdgeInsets.only(left: 20.0, right: 20.0), child: MiscInputFieldTemplate(key: _key2, labelText: 'Password', type: TextInputType.text, obscureText: true,),),

                  SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                  Align(alignment: Alignment.centerRight, child: Text('Forgot Password?', style: TextStyle(decoration: TextDecoration.underline, fontSize: SizeConfig.safeBlockHorizontal * 3.5, fontWeight: FontWeight.w400,),),),

                  SizedBox(height: SizeConfig.blockSizeVertical * 10,),

                  MiscButtonTemplate(buttonText: 'Login', buttonTextStyle: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 5, fontWeight: FontWeight.bold, color: Color(0xffffffff),), onPressed: (){Navigator.pushReplacementNamed(context, 'home/');}, width: SizeConfig.screenWidth / 2, height: SizeConfig.blockSizeVertical * 8, buttonColor: Color(0xff4EC9D4),),

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
                            color: Color(0xff85DBF1),
                          ),
                          recognizer: TapGestureRecognizer()
                          ..onTap = (){
                            Navigator.pushNamed(context, 'blm/blm-03-register');
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
    );
  }
}