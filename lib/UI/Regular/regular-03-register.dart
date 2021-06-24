import 'package:facesbyplaces/API/Regular/01-Start/api-start-regular-02-registration.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-01-regular-input-field.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-06-regular-button.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:loader_overlay/loader_overlay.dart';
// ignore: import_of_legacy_library_into_null_safe
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
  Widget build(BuildContext context){
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
            body: SafeArea(
              bottom: false,
              child: SingleChildScrollView(
                child: Container(
                  height: SizeConfig.screenHeight,
                  width: SizeConfig.screenWidth,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    image: DecorationImage(fit: BoxFit.cover, image: AssetImage('assets/icons/background2.png'), colorFilter: ColorFilter.srgbToLinearGamma(),),
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: SizeConfig.screenHeight! / 6,
                        decoration: const BoxDecoration(image: const DecorationImage(fit: BoxFit.cover, image: const AssetImage('assets/icons/regular-background.png'),),),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: IconButton(
                            icon: Icon(Icons.arrow_back, color: Color(0xffFFFFFF), size: SizeConfig.blockSizeVertical! * 3.65,),
                            onPressed: (){
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ),

                      SizedBox(height: SizeConfig.blockSizeVertical! * 5.51),

                      Container(
                        padding: EdgeInsets.only(left: SizeConfig.blockSizeVertical! * 6.06, right: SizeConfig.blockSizeVertical! * 6.06),
                        child: Column(
                          children: [
                            MiscRegularInputFieldTemplate(
                              key: _key1,
                              labelText: 'First Name',
                              type: TextInputType.name,
                              labelTextStyle: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.64, fontFamily: 'NexaRegular', color: const Color(0xff000000),),
                            ),

                            MiscRegularInputFieldTemplate(
                              key: _key2,
                              labelText: 'Last Name',
                              type: TextInputType.name,
                              labelTextStyle: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.64, fontFamily: 'NexaRegular', color: const Color(0xff000000),),
                            ),

                            MiscRegularPhoneNumberTemplate(
                              key: _key3,
                              labelText: 'Mobile #',
                              type: TextInputType.phone,
                              labelTextStyle: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.64, fontFamily: 'NexaRegular', color: const Color(0xff000000),
                              ),
                            ),

                            MiscRegularInputFieldTemplate(
                              key: _key4,
                              labelText: 'Email Address',
                              type: TextInputType.emailAddress,
                              labelTextStyle: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.64, fontFamily: 'NexaRegular', color: const Color(0xff000000),),
                            ),

                            MiscRegularInputFieldTemplate(
                              key: _key5,
                              labelText: 'Username',
                              type: TextInputType.text,
                              labelTextStyle: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.64, fontFamily: 'NexaRegular', color: const Color(0xff000000),),
                            ),

                            MiscRegularInputFieldTemplate(
                              key: _key6,
                              labelText: 'Password',
                              type: TextInputType.text,
                              labelTextStyle: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.64, fontFamily: 'NexaRegular', color: const Color(0xff000000),),
                              obscureText: true,
                            ),
                          ],
                        ),
                      ),
                      
                      Spacer(),

                      MiscRegularButtonTemplate(
                        buttonText: 'Next',
                        buttonTextStyle: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 3.16, fontFamily: 'NexaBold', color: const Color(0xffffffff),),
                        height: SizeConfig.blockSizeVertical! * 7.04,
                        width: SizeConfig.blockSizeHorizontal! * 55,
                        buttonColor: const Color(0xff04ECFF),
                        onPressed: () async{
                          bool validEmail = false;
                          validEmail = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(_key4.currentState!.controller.text);

                          if(_key1.currentState!.controller.text == '' || _key2.currentState!.controller.text == '' || _key3.currentState!.controller.text == '' || _key4.currentState!.controller.text == '' || _key5.currentState!.controller.text == '' || _key6.currentState!.controller.text == ''){
                            await showDialog(
                              context: context,
                              builder: (_) => AssetGiffyDialog(
                                description: Text('Please complete the form before submitting.', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.87, fontFamily: 'NexaRegular',),),
                                title: Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 3.87, fontFamily: 'NexaRegular',),),
                                image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                entryAnimation: EntryAnimation.DEFAULT,
                                buttonOkColor: const Color(0xffff0000),
                                onlyOkButton: true,
                                onOkButtonPressed: (){
                                  Navigator.pop(context, true);
                                },
                              ),
                            );
                          }else if(!validEmail){
                            await showDialog(
                              context: context,
                              builder: (_) => AssetGiffyDialog(
                                description: Text('Invalid email address. Please try again.', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.87, fontFamily: 'NexaRegular',),),
                                title: Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 3.87, fontFamily: 'NexaRegular',),),
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
                            APIRegularAccountRegistration account = APIRegularAccountRegistration(firstName: _key1.currentState!.controller.text, lastName: _key2.currentState!.controller.text, phoneNumber: _key3.currentState!.controller.text, email: _key4.currentState!.controller.text, username: _key5.currentState!.controller.text, password: _key6.currentState!.controller.text,);

                            context.loaderOverlay.show();
                            String result = await apiRegularRegistration(account: account);
                            context.loaderOverlay.hide();

                            if(result == 'Success'){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => RegularVerifyEmail()));
                            }else{
                              await showDialog(
                                context: context,
                                builder: (_) => AssetGiffyDialog(
                                  title: Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 3.87, fontFamily: 'NexaRegular',),),
                                  image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                  description: Text('$result', textAlign: TextAlign.center,),
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

                      Spacer(),

                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Already have an account? ', 
                              style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.64, fontFamily: 'NexaRegular', color: const Color(0xff000000),),
                            ),

                            TextSpan(
                              text: 'Login',
                              style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.64, fontFamily: 'NexaRegular', color: const Color(0xff04ECFF),),
                              recognizer: TapGestureRecognizer()
                              ..onTap = (){
                                Navigator.pushNamed(context, '/regular/login');
                              },
                            ),
                          ],
                        ),
                      ),
                      
                      Spacer(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}