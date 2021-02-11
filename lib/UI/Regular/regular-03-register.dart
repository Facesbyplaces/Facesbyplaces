import 'package:facesbyplaces/API/Regular/01-Start/api-start-regular-02-registration.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-01-regular-input-field.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-07-regular-button.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-08-regular-background.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
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
          body: Container(
            height: SizeConfig.screenHeight,
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
                                fontSize: 14,
                                fontWeight: FontWeight.w400, 
                                color: Colors.grey,
                              ),
                            ),
                            
                            SizedBox(height: 20),
                            
                            MiscRegularInputFieldTemplate(
                              key: _key2, 
                              labelText: 'Last Name', 
                              type: TextInputType.name, 
                              labelTextStyle: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey,
                              ),
                            ),

                            SizedBox(height: 20),
                            
                            MiscRegularPhoneNumberTemplate(
                              key: _key3, 
                              labelText: 'Mobile #', 
                              type: TextInputType.phone, 
                              labelTextStyle: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400, 
                                color: Colors.grey,
                              ),
                            ),

                            SizedBox(height: 20),

                            MiscRegularInputFieldTemplate(
                              key: _key4, 
                              labelText: 'Email Address', 
                              type: TextInputType.emailAddress, 
                              labelTextStyle: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400, 
                                color: Colors.grey,
                              ),
                            ),

                            SizedBox(height: 20),

                            MiscRegularInputFieldTemplate(
                              key: _key5, 
                              labelText: 'Username', 
                              type: TextInputType.text, 
                              labelTextStyle: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400, 
                                color: Colors.grey,
                              ),
                            ),

                            SizedBox(height: 20),

                            MiscRegularInputFieldTemplate(
                              key: _key6, 
                              labelText: 'Password', 
                              type: TextInputType.text, 
                              labelTextStyle: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400, 
                                color: Colors.grey,
                              ), 
                              obscureText: true,
                            ),

                            SizedBox(height: 40),

                            MiscRegularButtonTemplate(
                              buttonText: 'Next', 
                              buttonTextStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold, 
                                color: Color(0xffffffff),
                              ),
                              onPressed: () async{
                                bool validEmail = false;
                                validEmail = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(_key4.currentState.controller.text );

                                if(_key1.currentState.controller.text == '' || _key2.currentState.controller.text == '' || _key4.currentState.controller.text == '' || _key5.currentState.controller.text == '' || _key6.currentState.controller.text == ''){
                                  await showDialog(
                                    context: context,
                                    builder: (_) => 
                                      AssetGiffyDialog(
                                      image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                      title: Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                                      entryAnimation: EntryAnimation.DEFAULT,
                                      description: Text('Please complete the form before submitting.',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(),
                                      ),
                                      onlyOkButton: true,
                                      buttonOkColor: Colors.red,
                                      onOkButtonPressed: () {
                                        Navigator.pop(context, true);
                                      },
                                    )
                                  );
                                }else if(!validEmail){
                                  await showDialog(
                                    context: context,
                                    builder: (_) => 
                                      AssetGiffyDialog(
                                      image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                      title: Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                                      entryAnimation: EntryAnimation.DEFAULT,
                                      description: Text('Invalid email address. Please try again.',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(),
                                      ),
                                      onlyOkButton: true,
                                      buttonOkColor: Colors.red,
                                      onOkButtonPressed: () {
                                        Navigator.pop(context, true);
                                      },
                                    )
                                  );
                                }else if(!_key3.currentState.valid){
                                  await showDialog(
                                    context: context,
                                    builder: (_) => 
                                      AssetGiffyDialog(
                                      image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                      title: Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                                      entryAnimation: EntryAnimation.DEFAULT,
                                      description: Text('Invalid phone number. Please try again.',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(),
                                      ),
                                      onlyOkButton: true,
                                      buttonOkColor: Colors.red,
                                      onOkButtonPressed: () {
                                        Navigator.pop(context, true);
                                      },
                                    )
                                  );
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
                                  String result = await apiRegularRegistration(account: account);
                                  context.hideLoaderOverlay();

                                  if(result == 'Success'){
                                    final sharedPrefs = await SharedPreferences.getInstance();
                                    String verificationCode = sharedPrefs.getString('regular-verification-code');
                                    Navigator.pushNamed(context, '/regular/verify-email', arguments: verificationCode);
                                  }else{
                                    await showDialog(
                                      context: context,
                                      builder: (_) => 
                                        AssetGiffyDialog(
                                        image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                        title: Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                                        entryAnimation: EntryAnimation.DEFAULT,
                                        description: Text('$result',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(),
                                        ),
                                        onlyOkButton: true,
                                        buttonOkColor: Colors.red,
                                        onOkButtonPressed: () {
                                          Navigator.pop(context, true);
                                        },
                                      )
                                    );
                                  }
                                }

                              }, 
                              width: SizeConfig.screenWidth / 2, 
                              height: 45,
                              buttonColor: Color(0xff04ECFF),
                            ),

                            SizedBox(height: 25),

                            RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'Already have an account? ', 
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xff000000),
                                    ),
                                  ),

                                  TextSpan(
                                    text: 'Login', 
                                    style: TextStyle(
                                      fontSize: 16,
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

                            SizedBox(height: 20),
                            
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                Column(
                  children: [
                    SizedBox(height: 20),
                    
                    Align(
                      alignment: Alignment.topLeft, 
                      child: IconButton(
                        onPressed: (){
                          Navigator.pop(context);
                        }, 
                        icon: Icon(
                          Icons.arrow_back, 
                          color: Color(0xffffffff), 
                          size: 30,
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
    );
  }
}