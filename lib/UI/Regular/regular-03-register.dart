import 'package:facesbyplaces/UI/Miscellaneous/misc-01-input-field.dart';
import 'package:facesbyplaces/UI/Miscellaneous/misc-02-dialog.dart';
import 'package:facesbyplaces/UI/Miscellaneous/misc-07-button.dart';
import 'package:facesbyplaces/UI/Miscellaneous/misc-08-background.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class RegularRegister extends StatelessWidget{

  final GlobalKey<MiscInputFieldTemplateState> _key1 = GlobalKey<MiscInputFieldTemplateState>();
  final GlobalKey<MiscInputFieldTemplateState> _key2 = GlobalKey<MiscInputFieldTemplateState>();
  final GlobalKey<MiscInputFieldTemplateState> _key3 = GlobalKey<MiscInputFieldTemplateState>();
  final GlobalKey<MiscInputFieldTemplateState> _key4 = GlobalKey<MiscInputFieldTemplateState>();
  final GlobalKey<MiscInputFieldTemplateState> _key5 = GlobalKey<MiscInputFieldTemplateState>();
  final GlobalKey<MiscInputFieldTemplateState> _key6 = GlobalKey<MiscInputFieldTemplateState>();

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

              SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                child: Container(height: SizeConfig.screenHeight, child: MiscBackgroundTemplate(image: AssetImage('assets/icons/background2.png'),),),
              ),

              Container(height: SizeConfig.screenHeight / 6, decoration: BoxDecoration(image: DecorationImage(fit: BoxFit.cover, image: AssetImage('assets/icons/regular-background.png'),),),),

              Column(
                children: [
                  SizedBox(height: SizeConfig.screenHeight / 6),

                  Expanded(
                    child: SingleChildScrollView(
                      physics: ClampingScrollPhysics(),
                      padding: EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Column(
                        children: [

                          MiscInputFieldTemplate(key: _key1, labelText: 'Your Name', type: TextInputType.text, labelTextStyle: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, fontWeight: FontWeight.w400, color: Colors.grey)),
                          
                          SizedBox(height: SizeConfig.blockSizeVertical * 2,),
                          
                          MiscInputFieldTemplate(key: _key2, labelText: 'Last Name', type: TextInputType.text, labelTextStyle: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, fontWeight: FontWeight.w400, color: Colors.grey)),

                          SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                          MiscInputFieldTemplate(key: _key3, labelText: 'Mobile #', type: TextInputType.phone, labelTextStyle: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, fontWeight: FontWeight.w400, color: Colors.grey)),

                          SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                          MiscInputFieldTemplate(key: _key4, labelText: 'Email Address', type: TextInputType.emailAddress, labelTextStyle: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, fontWeight: FontWeight.w400, color: Colors.grey)),

                          SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                          MiscInputFieldTemplate(key: _key5, labelText: 'Username', type: TextInputType.text, labelTextStyle: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, fontWeight: FontWeight.w400, color: Colors.grey)),

                          SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                          MiscInputFieldTemplate(key: _key6, labelText: 'Password', type: TextInputType.text, labelTextStyle: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, fontWeight: FontWeight.w400, color: Colors.grey), obscureText: true,),

                          SizedBox(height: SizeConfig.blockSizeVertical * 10,),

                          MiscButtonTemplate(
                            buttonText: 'Next', 
                            buttonTextStyle: TextStyle(
                              fontSize: SizeConfig.safeBlockHorizontal * 5, 
                              fontWeight: FontWeight.bold, 
                              color: Color(0xffffffff),
                            ), 
                            onPressed: () async{
                              bool validEmail = false;
                              validEmail = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(_key4.currentState.controller.text );

                              if(_key1.currentState.controller.text == '' || _key2.currentState.controller.text == '' || _key3.currentState.controller.text == '' ||
                                _key4.currentState.controller.text == '' || _key5.currentState.controller.text == '' || _key6.currentState.controller.text == ''){
                                await showDialog(context: (context), builder: (build) => MiscAlertDialog(title: 'Error', content: 'Please complete the form before submitting.', confirmText: 'OK',),);
                              }else if(!validEmail){
                                await showDialog(context: (context), builder: (build) => MiscAlertDialog(title: 'Error', content: 'Invalid email address. Please try again.', confirmText: 'OK',),);
                              }else{
                                Navigator.pushNamed(context, '/regular/regular-04-verify-email');
                              }

                            }, 
                            width: SizeConfig.screenWidth / 2, 
                            height: SizeConfig.blockSizeVertical * 7, 
                            buttonColor: Color(0xff04ECFF),
                          ),

                          SizedBox(height: SizeConfig.blockSizeVertical * 3,),

                          RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'Already have an account? ', 
                                  style: TextStyle(
                                    fontSize: SizeConfig.safeBlockHorizontal * 4,
                                    color: Color(0xff000000),
                                  ),
                                ),

                                TextSpan(
                                  text: 'Login', 
                                  style: TextStyle(
                                    fontSize: SizeConfig.safeBlockHorizontal * 4,
                                    color: Color(0xff04ECFF),
                                  ),
                                  recognizer: TapGestureRecognizer()
                                  ..onTap = (){
                                    Navigator.pushNamed(context, '/regular/regular-02-login');
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
                  Align(alignment: Alignment.topLeft, child: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back, color: Color(0xffffffff), size: SizeConfig.blockSizeVertical * 5,),),),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}