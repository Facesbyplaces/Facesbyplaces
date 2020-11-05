import 'package:facesbyplaces/API/BLM/api-01-blm-login.dart';
import 'package:facesbyplaces/Bloc/bloc-01-bloc.dart';
import 'package:facesbyplaces/UI/Miscellaneous/misc-01-input-field.dart';
import 'package:facesbyplaces/UI/Miscellaneous/misc-02-dialog.dart';
import 'package:facesbyplaces/UI/Miscellaneous/misc-07-button.dart';
import 'package:facesbyplaces/UI/Miscellaneous/misc-08-background.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class BLMLogin extends StatelessWidget {

  final GlobalKey<MiscInputFieldTemplateState> _key1 = GlobalKey<MiscInputFieldTemplateState>();
  final GlobalKey<MiscInputFieldTemplateState> _key2 = GlobalKey<MiscInputFieldTemplateState>();

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider<BlocShowLoading>(
          create: (BuildContext context) => BlocShowLoading(),
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
            body: BlocBuilder<BlocShowLoading, bool>(
              builder: (context, state){
                return ((){
                  switch(state){
                    case false: return SingleChildScrollView(
                      physics: ClampingScrollPhysics(),
                      child: Stack(
                        children: [

                          Container(height: SizeConfig.screenHeight, child: MiscBackgroundTemplate(image: AssetImage('assets/icons/background2.png'),),),

                          Container(
                            padding: EdgeInsets.only(left: 20.0, right: 20.0),
                            height: SizeConfig.screenHeight,
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
                                      Expanded(child: MiscButtonSignInWithTemplate(buttonText: 'Facebook', buttonColor: Color(0xff3A559F), buttonTextStyle: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, fontWeight: FontWeight.w300, color: Color(0xffffffff)), onPressed: (){}, width: SizeConfig.screenWidth / 1.5, height: SizeConfig.blockSizeVertical * 7,),),

                                      SizedBox(width: SizeConfig.blockSizeHorizontal * 10,),

                                      Expanded(child: MiscButtonSignInWithTemplate(buttonText: 'Google', buttonColor: Color(0xffF5F5F5), buttonTextStyle: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, fontWeight: FontWeight.w300, color: Color(0xff000000)), onPressed: (){}, width: SizeConfig.screenWidth / 1.5, height: SizeConfig.blockSizeVertical * 7, image: 'assets/icons/google.png'),),
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

                                Expanded(child: Container(),),

                                MiscButtonTemplate(
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
                                      await showDialog(context: (context), builder: (build) => MiscAlertDialog(title: 'Error', content: 'Please complete the form before submitting.', confirmText: 'OK',),);
                                    }else if(!validEmail){
                                      await showDialog(context: (context), builder: (build) => MiscAlertDialog(title: 'Error', content: 'Invalid email address. Please try again.', confirmText: 'OK',),);
                                    }else{

                                      context.bloc<BlocShowLoading>().modify(true);

                                      bool result = await apiBLMLogin(_key1.currentState.controller.text, _key2.currentState.controller.text);

                                      context.bloc<BlocShowLoading>().modify(false);

                                      if(result){
                                        
                                        await showDialog(context: (context), builder: (build) => MiscAlertDialog(title: 'Success', content: 'Successfully logged in.', color: Colors.green,));

                                        Navigator.pushReplacementNamed(context, '/home/');

                                      }else{
                                        await showDialog(context: (context), builder: (build) => MiscAlertDialog(title: 'Error', content: 'Invalid email or password. Please try again.'));
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
                                          Navigator.pushNamed(context, '/blm/blm-03-register');
                                        }
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(height: SizeConfig.blockSizeVertical * 1,),

                                GestureDetector(
                                  onTap: (){
                                    Navigator.pushReplacementNamed(context, '/home/');
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

                                SizedBox(height: SizeConfig.blockSizeVertical * 2,),
                                
                              ],
                            ),
                          ),

                        ],
                      ),
                    ); break;
                    case true: return Container(height: SizeConfig.screenHeight, child: Center(child: Container(child: SpinKitThreeBounce(color: Color(0xff000000), size: 50.0,), color: Color(0xffffffff),),)); break;
                  }
                }());
              }
            ),
          ),
        ),
      ),
    );
  }
}