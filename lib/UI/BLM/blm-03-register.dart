import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-01-blm-input-field.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-02-blm-dialog.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-07-blm-button.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-08-blm-background.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/API/BLM/api-02-blm-registration.dart';
import 'package:facesbyplaces/Bloc/bloc-01-bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class BLMRegister extends StatelessWidget{

  final GlobalKey<MiscBLMInputFieldTemplateState> _key1 = GlobalKey<MiscBLMInputFieldTemplateState>();
  final GlobalKey<MiscBLMInputFieldTemplateState> _key2 = GlobalKey<MiscBLMInputFieldTemplateState>();
  final GlobalKey<MiscBLMInputFieldTemplateState> _key3 = GlobalKey<MiscBLMInputFieldTemplateState>();
  final GlobalKey<MiscBLMInputFieldTemplateState> _key4 = GlobalKey<MiscBLMInputFieldTemplateState>();
  final GlobalKey<MiscBLMInputFieldTemplateState> _key5 = GlobalKey<MiscBLMInputFieldTemplateState>();
  final GlobalKey<MiscBLMInputFieldTemplateState> _key6 = GlobalKey<MiscBLMInputFieldTemplateState>();

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider<BlocShowLoading>(create: (BuildContext context) => BlocShowLoading(),),
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
                return ((){
                  switch(loading){
                    case false: return Stack(
                      children: [

                        SingleChildScrollView(physics: NeverScrollableScrollPhysics(), child: Container(height: SizeConfig.screenHeight, child: MiscBLMBackgroundTemplate(image: AssetImage('assets/icons/background2.png'),),),),

                        Container(height: SizeConfig.screenHeight / 6, decoration: BoxDecoration(image: DecorationImage(fit: BoxFit.cover, image: AssetImage('assets/icons/background-blm.png'),),),),

                        Column(
                          children: [
                            SizedBox(height: SizeConfig.screenHeight / 6,),

                            Expanded(
                              child: Container(
                                child: SingleChildScrollView(
                                  physics: ClampingScrollPhysics(),
                                  padding: EdgeInsets.only(left: 20.0, right: 20.0,),
                                  child: Column(
                                    children: [
                                
                                      MiscBLMInputFieldTemplate(key: _key1, labelText: 'Your Name', type: TextInputType.text, labelTextStyle: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, fontWeight: FontWeight.w400, color: Colors.grey)),
                                      
                                      SizedBox(height: SizeConfig.blockSizeVertical * 2,),
                                      
                                      MiscBLMInputFieldTemplate(key: _key2, labelText: 'Last Name', type: TextInputType.text, labelTextStyle: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, fontWeight: FontWeight.w400, color: Colors.grey)),

                                      SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                                      MiscBLMInputFieldTemplate(key: _key3, labelText: 'Mobile #', type: TextInputType.phone, labelTextStyle: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, fontWeight: FontWeight.w400, color: Colors.grey)),

                                      SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                                      MiscBLMInputFieldTemplate(key: _key4, labelText: 'Email Address', type: TextInputType.emailAddress, labelTextStyle: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, fontWeight: FontWeight.w400, color: Colors.grey)),

                                      SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                                      MiscBLMInputFieldTemplate(key: _key5, labelText: 'Username', type: TextInputType.text, labelTextStyle: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, fontWeight: FontWeight.w400, color: Colors.grey)),

                                      SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                                      MiscBLMInputFieldTemplate(key: _key6, labelText: 'Password', type: TextInputType.text, labelTextStyle: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, fontWeight: FontWeight.w400, color: Colors.grey), obscureText: true,),

                                      SizedBox(height: SizeConfig.blockSizeVertical * 5,),

                                      MiscBLMButtonTemplate(
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
                                            await showDialog(context: (context), builder: (build) => MiscBLMAlertDialog(title: 'Error', content: 'Please complete the form before submitting.', confirmText: 'OK',),);
                                          }else if(!validEmail){
                                            await showDialog(context: (context), builder: (build) => MiscBLMAlertDialog(title: 'Error', content: 'Invalid email address. Please try again.', confirmText: 'OK',),);
                                          }else{

                                            APIBLMAccountRegistration account = APIBLMAccountRegistration(
                                              firstName: _key1.currentState.controller.text, 
                                              lastName: _key2.currentState.controller.text,
                                              phoneNumber: _key3.currentState.controller.text,
                                              email: _key4.currentState.controller.text,
                                              username: _key5.currentState.controller.text,
                                              password: _key6.currentState.controller.text,
                                            );

                                            context.bloc<BlocShowLoading>().modify(true);
                                            bool result = await apiBLMRegistration(account);
                                            context.bloc<BlocShowLoading>().modify(false);

                                            if(result){
                                              Navigator.pushNamed(context, '/blm/blm-04-verify-email');
                                            }else{
                                              await showDialog(context: (context), builder: (build) => MiscBLMAlertDialog(title: 'Error', content: 'Something went wrong. Please try again.'));
                                            }
                                          }
                                        }, 
                                        width: SizeConfig.screenWidth / 2, 
                                        height: SizeConfig.blockSizeVertical * 7, 
                                        buttonColor: Color(0xff000000),
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
                                                Navigator.pushNamed(context, '/blm/blm-02-login');
                                              }
                                            ),
                                          ],
                                        ),
                                      ),

                                    ],
                                  ),
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
                    ); break;
                    case true: return Container(height: SizeConfig.screenHeight, child: Center(child: Container(child: SpinKitThreeBounce(color: Color(0xff000000), size: 50.0,), color: Color(0xffffffff),),)); break;
                  }
                }());
              },
            ),
          ),
        ),
      ),
    );
  }
}