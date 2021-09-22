// ignore_for_file: file_names
import 'package:facesbyplaces/API/BLM/01-Start/api_start_blm_02_registration.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-01-blm-input-field.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-06-blm-button.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:loader_overlay/loader_overlay.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'blm_04_verify_email.dart';

class BLMRegister extends StatelessWidget{
  BLMRegister({Key? key}) : super(key: key);
  final GlobalKey<MiscBLMInputFieldTemplateState> _key1 = GlobalKey<MiscBLMInputFieldTemplateState>();
  final GlobalKey<MiscBLMInputFieldTemplateState> _key2 = GlobalKey<MiscBLMInputFieldTemplateState>();
  final GlobalKey<MiscBLMPhoneNumberTemplateState> _key3 = GlobalKey<MiscBLMPhoneNumberTemplateState>();
  final GlobalKey<MiscBLMInputFieldTemplateState> _key4 = GlobalKey<MiscBLMInputFieldTemplateState>();
  final GlobalKey<MiscBLMInputFieldTemplateState> _key5 = GlobalKey<MiscBLMInputFieldTemplateState>();
  final GlobalKey<MiscBLMInputFieldTemplateState> _key6 = GlobalKey<MiscBLMInputFieldTemplateState>();

  @override
  Widget build(BuildContext context){
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
                physics: const ClampingScrollPhysics(),
                child: Container(
                  height: SizeConfig.screenHeight,
                  decoration: const BoxDecoration(
                    color: Color(0xffffffff),
                    image: DecorationImage(fit: BoxFit.cover, image: AssetImage('assets/icons/background2.png'), colorFilter: ColorFilter.srgbToLinearGamma(),),
                  ),
                ),
              ),

              LayoutBuilder(
                builder: (context, constraint){
                  return SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: constraint.maxHeight),
                      child: IntrinsicHeight(
                        child: SafeArea(
                          child: Column(
                            children: [
                              Container(
                                height: SizeConfig.screenHeight! / 6,
                                decoration: const BoxDecoration(image: DecorationImage(fit: BoxFit.cover, image: AssetImage('assets/icons/background-blm.png'),),),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: IconButton(
                                    icon: const Icon(Icons.arrow_back, color: Color(0xffFFFFFF), size: 35),
                                    onPressed: (){
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                              ),

                              const SizedBox(height: 10,),

                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 40),
                                child: Column(
                                  children: [
                                    MiscBLMInputFieldTemplate(
                                      key: _key1,
                                      labelText: 'Your Name',
                                      type: TextInputType.name,
                                      labelTextStyle: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xff000000),),
                                    ),

                                    MiscBLMInputFieldTemplate(
                                      key: _key2,
                                      labelText: 'Last Name',
                                      type: TextInputType.name,
                                      labelTextStyle: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xff000000),),
                                    ),

                                    MiscBLMPhoneNumberTemplate(
                                      key: _key3,
                                      labelText: 'Mobile #',
                                      type: TextInputType.phone,
                                      labelTextStyle: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xff000000),),
                                    ),

                                    MiscBLMInputFieldTemplate(
                                      key: _key4,
                                      labelText: 'Email Address',
                                      type: TextInputType.emailAddress,
                                      labelTextStyle: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xff000000),),
                                    ),

                                    MiscBLMInputFieldTemplate(
                                      key: _key5,
                                      labelText: 'Username',
                                      type: TextInputType.text,
                                      labelTextStyle: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xff000000),),
                                    ),

                                    MiscBLMInputFieldTemplate(
                                      key: _key6,
                                      labelText: 'Password',
                                      type: TextInputType.text,
                                      labelTextStyle: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xff000000),),
                                      obscureText: true,
                                    ),
                                  ],
                                ),
                              ),

                              Expanded(child: Container()),
                              
                              const SizedBox(height: 50,),

                              MiscBLMButtonTemplate(
                                buttonText: 'Next',
                                buttonTextStyle: const TextStyle(fontSize: 24, fontFamily: 'NexaBold', color: Color(0xffffffff),),
                                width: SizeConfig.screenWidth! / 2,
                                height: 50,
                                buttonColor: const Color(0xff000000),
                                onPressed: () async{
                                  bool validEmail = false;
                                  validEmail = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(_key4.currentState!.controller.text);

                                  if(_key1.currentState!.controller.text == '' || _key2.currentState!.controller.text == '' || _key3.currentState!.controller.text == '' || _key4.currentState!.controller.text == '' || _key5.currentState!.controller.text == '' || _key6.currentState!.controller.text == ''){
                                    await showDialog(
                                      context: context,
                                      builder: (_) => AssetGiffyDialog(
                                        title: const Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontFamily: 'NexaRegular',),),
                                        description: const Text('Please complete the form before submitting.', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular',),),
                                        image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                        entryAnimation: EntryAnimation.DEFAULT,
                                        buttonOkColor: const Color(0xffff0000),
                                        onlyOkButton: true,
                                        onOkButtonPressed: (){
                                          Navigator.pop(context, true);
                                        },
                                      ),
                                    );
                                  }else if (!validEmail){
                                    await showDialog(
                                      context: context,
                                      builder: (_) => AssetGiffyDialog(
                                        title: const Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontFamily: 'NexaRegular',),),
                                        description: const Text('Invalid email address. Please try again.', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular',),),
                                        image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                        entryAnimation: EntryAnimation.DEFAULT,
                                        buttonOkColor: const Color(0xffff0000),
                                        onlyOkButton: true,
                                        onOkButtonPressed: (){
                                          Navigator.pop(context, true);
                                        },
                                      ),
                                    );
                                  }else{
                                    APIBLMAccountRegistration account = APIBLMAccountRegistration(firstName: _key1.currentState!.controller.text, lastName: _key2.currentState!.controller.text, phoneNumber: _key3.currentState!.controller.text, email: _key4.currentState!.controller.text, username: _key5.currentState!.controller.text, password: _key6.currentState!.controller.text,);

                                    context.loaderOverlay.show();
                                    String result = await apiBLMRegistration(account: account);
                                    context.loaderOverlay.hide();

                                    if(result == 'Success'){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => BLMVerifyEmail()));
                                    }else{
                                      await showDialog(
                                        context: context,
                                        builder: (_) => AssetGiffyDialog(
                                          title: const Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontFamily: 'NexaRegular',),),
                                          description: Text(result, textAlign: TextAlign.center, style: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular',),),
                                          image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                          entryAnimation: EntryAnimation.DEFAULT,
                                          buttonOkColor: const Color(0xffff0000),
                                          onlyOkButton: true,
                                          onOkButtonPressed: (){
                                            Navigator.pop(context, true);
                                          },
                                        ),
                                      );
                                    }
                                  }
                                },
                              ),

                              const SizedBox(height: 50,),

                              RichText(
                                text: TextSpan(
                                  children: <TextSpan>[
                                    const TextSpan(
                                      text: 'Already have an account? ',
                                      style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xff000000),),
                                    ),

                                    TextSpan(
                                      text: 'Login',
                                      style: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xff04ECFF),),
                                      recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.pushNamed(context, '/blm/login');
                                      },
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 50,),
                            ],
                          ),
                        ),
                      ),
                    )
                  );
                }
              ),
            ],
          ),
        ),
      ),
    );
  }
}