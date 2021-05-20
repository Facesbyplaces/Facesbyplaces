import 'package:facesbyplaces/API/Regular/01-Start/api-start-regular-02-registration.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-01-regular-input-field.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-06-regular-button.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-07-regular-background.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'regular-04-verify-email.dart';

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
    return RepaintBoundary(
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
            body: Stack(
              children: [

                SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(), 
                  child: Container(
                    height: SizeConfig.screenHeight,
                    child: const MiscRegularBackgroundTemplate(
                      image: const AssetImage('assets/icons/background2.png'),
                    ),
                  ),
                ),

                Container(
                  height: SizeConfig.screenHeight! / 6, 
                  decoration: const BoxDecoration(
                    image: const DecorationImage(
                      fit: BoxFit.cover, 
                      image: const AssetImage('assets/icons/regular-background.png'),
                    ),
                  ),
                ),

                Column(
                  children: [
                    SizedBox(height: SizeConfig.screenHeight! / 6),

                    Expanded(
                      child: SingleChildScrollView(
                        physics: const ClampingScrollPhysics(),
                        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                        child: Column(
                          children: [

                            MiscRegularInputFieldTemplate(
                              key: _key1, 
                              labelText: 'Your Name', 
                              type: TextInputType.name, 
                              labelTextStyle: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w400, 
                                color: const Color(0xff888888),
                              ),
                            ),
                            
                            const SizedBox(height: 20),
                            
                            MiscRegularInputFieldTemplate(
                              key: _key2, 
                              labelText: 'Last Name', 
                              type: TextInputType.name, 
                              labelTextStyle: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xff888888),
                              ),
                            ),

                            const SizedBox(height: 20),
                            
                            MiscRegularPhoneNumberTemplate(
                              key: _key3, 
                              labelText: 'Mobile #', 
                              type: TextInputType.phone, 
                              labelTextStyle: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w400, 
                                color: const Color(0xff888888),
                              ),
                            ),

                            const SizedBox(height: 20),

                            MiscRegularInputFieldTemplate(
                              key: _key4, 
                              labelText: 'Email Address', 
                              type: TextInputType.emailAddress, 
                              labelTextStyle: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w400, 
                                color: const Color(0xff888888),
                              ),
                            ),

                            const SizedBox(height: 20),

                            MiscRegularInputFieldTemplate(
                              key: _key5, 
                              labelText: 'Username', 
                              type: TextInputType.text, 
                              labelTextStyle: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w400, 
                                color: const Color(0xff888888),
                              ),
                            ),

                            SizedBox(height: 20),

                            MiscRegularInputFieldTemplate(
                              key: _key6, 
                              labelText: 'Password', 
                              type: TextInputType.text, 
                              labelTextStyle: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w400, 
                                color: const Color(0xff888888),
                              ), 
                              obscureText: true,
                            ),

                            SizedBox(height: 40),

                            MiscRegularButtonTemplate(
                              buttonText: 'Next', 
                              buttonTextStyle: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold, 
                                color: const Color(0xffffffff),
                              ),
                              width: SizeConfig.screenWidth! / 2, 
                              height: 45,
                              buttonColor: const Color(0xff04ECFF),
                              onPressed: () async{
                                bool validEmail = false;
                                validEmail = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(_key4.currentState!.controller.text );

                                if(_key1.currentState!.controller.text == '' || _key2.currentState!.controller.text == '' || _key4.currentState!.controller.text == '' || _key5.currentState!.controller.text == '' || _key6.currentState!.controller.text == ''){
                                  await showDialog(
                                    context: context,
                                    builder: (_) => 
                                      AssetGiffyDialog(
                                      image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                      title: const Text('Error', textAlign: TextAlign.center, style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                                      entryAnimation: EntryAnimation.DEFAULT,
                                      description: const Text('Please complete the form before submitting.',
                                        textAlign: TextAlign.center,
                                      ),
                                      onlyOkButton: true,
                                      buttonOkColor: const Color(0xffff0000),
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
                                      title: const Text('Error', textAlign: TextAlign.center, style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                                      entryAnimation: EntryAnimation.DEFAULT,
                                      description: const Text('Invalid email address. Please try again.',
                                        textAlign: TextAlign.center,
                                      ),
                                      onlyOkButton: true,
                                      buttonOkColor: const Color(0xffff0000),
                                      onOkButtonPressed: () {
                                        Navigator.pop(context, true);
                                      },
                                    )
                                  );
                                }else{
                                  APIRegularAccountRegistration account = APIRegularAccountRegistration(
                                    firstName: _key1.currentState!.controller.text,
                                    lastName: _key2.currentState!.controller.text,
                                    phoneNumber: _key3.currentState!.controller.text,
                                    email: _key4.currentState!.controller.text,
                                    username: _key5.currentState!.controller.text,
                                    password: _key6.currentState!.controller.text,
                                  );

                                  context.loaderOverlay.show();
                                  String result = await apiRegularRegistration(account: account);
                                  context.loaderOverlay.hide();

                                  if(result == 'Success'){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => RegularVerifyEmail()));
                                  }else{
                                    await showDialog(
                                      context: context,
                                      builder: (_) => 
                                        AssetGiffyDialog(
                                        image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                        title: const Text('Error', textAlign: TextAlign.center, style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                                        entryAnimation: EntryAnimation.DEFAULT,
                                        description: Text('$result',
                                          textAlign: TextAlign.center,
                                        ),
                                        onlyOkButton: true,
                                        buttonOkColor: const Color(0xffff0000),
                                        onOkButtonPressed: () {
                                          Navigator.pop(context, true);
                                        },
                                      )
                                    );
                                  }
                                }
                              },
                            ),

                            SizedBox(height: 25),

                            RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  const TextSpan(
                                    text: 'Already have an account? ', 
                                    style: const TextStyle(
                                      fontSize: 20,
                                      color: const Color(0xff000000),
                                    ),
                                  ),

                                  TextSpan(
                                    text: 'Login', 
                                    style: const TextStyle(
                                      fontSize: 20,
                                      color: const Color(0xff04ECFF),
                                    ),
                                    recognizer: TapGestureRecognizer()
                                    ..onTap = (){
                                      Navigator.pushNamed(context, '/regular/login');
                                    }
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 20),
                            
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                Column(
                  children: [
                    const SizedBox(height: 20),
                    
                    SafeArea(
                      child: Align(
                        alignment: Alignment.topLeft, 
                        child: IconButton(
                          onPressed: (){
                            Navigator.pop(context);
                          }, 
                          icon: const Icon(
                            Icons.arrow_back, 
                            color: const Color(0xffffffff), 
                            size: 30,
                          ),
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