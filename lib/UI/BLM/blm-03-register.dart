import 'package:facesbyplaces/API/BLM/01-Start/api-start-blm-02-registration.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-01-blm-input-field.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-06-blm-button.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-07-blm-background.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'blm-04-verify-email.dart';

class BLMRegister extends StatelessWidget{

  final GlobalKey<MiscBLMInputFieldTemplateState> _key1 = GlobalKey<MiscBLMInputFieldTemplateState>();
  final GlobalKey<MiscBLMInputFieldTemplateState> _key2 = GlobalKey<MiscBLMInputFieldTemplateState>();
  final GlobalKey<MiscBLMPhoneNumberTemplateState> _key3 = GlobalKey<MiscBLMPhoneNumberTemplateState>();
  final GlobalKey<MiscBLMInputFieldTemplateState> _key4 = GlobalKey<MiscBLMInputFieldTemplateState>();
  final GlobalKey<MiscBLMInputFieldTemplateState> _key5 = GlobalKey<MiscBLMInputFieldTemplateState>();
  final GlobalKey<MiscBLMInputFieldTemplateState> _key6 = GlobalKey<MiscBLMInputFieldTemplateState>();

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

              SingleChildScrollView(physics: const NeverScrollableScrollPhysics(), child: Container(height: SizeConfig.screenHeight, child: const MiscBLMBackgroundTemplate(image: const AssetImage('assets/icons/background2.png'),),),),

              Container(height: SizeConfig.screenHeight! / 6, decoration: const BoxDecoration(image: const DecorationImage(fit: BoxFit.cover, image: const AssetImage('assets/icons/background-blm.png'),),),),

              Column(
                children: [
                  SizedBox(height: SizeConfig.screenHeight! / 6,),

                  Expanded(
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0,),
                      child: Column(
                        children: [
                    
                          MiscBLMInputFieldTemplate(key: _key1, labelText: 'Your Name', type: TextInputType.name, labelTextStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: const Color(0xff888888))),
                          
                          const SizedBox(height: 20,),
                          
                          MiscBLMInputFieldTemplate(key: _key2, labelText: 'Last Name', type: TextInputType.name, labelTextStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: const Color(0xff888888))),

                          const SizedBox(height: 20,),

                          MiscBLMPhoneNumberTemplate(key: _key3, labelText: 'Mobile #', type: TextInputType.phone, labelTextStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: const Color(0xff888888))),

                          const SizedBox(height: 20,),

                          MiscBLMInputFieldTemplate(key: _key4, labelText: 'Email Address', type: TextInputType.emailAddress, labelTextStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: const Color(0xff888888))),

                          const SizedBox(height: 20,),

                          MiscBLMInputFieldTemplate(key: _key5, labelText: 'Username', type: TextInputType.text, labelTextStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: const Color(0xff888888))),

                          const SizedBox(height: 20,),

                          MiscBLMInputFieldTemplate(key: _key6, labelText: 'Password', type: TextInputType.text, labelTextStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: const Color(0xff888888)), obscureText: true,),

                          const SizedBox(height: 40,),

                          MiscBLMButtonTemplate(
                            buttonText: 'Next', 
                            buttonTextStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold, 
                              color: const Color(0xffffffff),
                            ),
                            width: SizeConfig.screenWidth! / 2,
                            height: 45,
                            buttonColor: const Color(0xff000000),
                            onPressed: () async{
                              bool validEmail = false;
                              validEmail = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(_key4.currentState!.controller.text );

                              if(_key1.currentState!.controller.text == '' || _key2.currentState!.controller.text == '' || _key3.currentState!.controller.text == '' || _key4.currentState!.controller.text == '' || _key5.currentState!.controller.text == '' || _key6.currentState!.controller.text == ''){
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

                                APIBLMAccountRegistration account = APIBLMAccountRegistration(
                                  firstName: _key1.currentState!.controller.text, 
                                  lastName: _key2.currentState!.controller.text,
                                  phoneNumber: _key3.currentState!.controller.text,
                                  email: _key4.currentState!.controller.text,
                                  username: _key5.currentState!.controller.text,
                                  password: _key6.currentState!.controller.text,
                                );

                                context.loaderOverlay.show();
                                String result = await apiBLMRegistration(account: account);
                                context.loaderOverlay.hide();

                                if(result == 'Success'){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => BLMVerifyEmail()));
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

                          const SizedBox(height: 25,),

                          RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                const TextSpan(
                                  text: 'Already have an account? ', 
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: const Color(0xff000000),
                                  ),
                                ),

                                TextSpan(
                                  text: 'Login', 
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: const Color(0xff04ECFF),
                                  ),
                                  recognizer: TapGestureRecognizer()
                                  ..onTap = (){
                                    Navigator.pushNamed(context, '/blm/login');
                                  }
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 10,),

                        ],
                      ),
                    ),
                  ),
                ],
              ),

              Column(
                children: [
                  const SizedBox(height: 20,),
                  
                  Align(
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
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}