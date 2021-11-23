import 'package:facesbyplaces/API/Regular/01-Start/api_start_regular_02_registration.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'regular_04_verify_email.dart';
import 'package:dialog/dialog.dart';
import 'package:misc/misc.dart';

class RegularRegister extends StatelessWidget{
  RegularRegister({Key? key}) : super(key: key);
  final GlobalKey<MiscInputFieldTemplateState> _key1 = GlobalKey<MiscInputFieldTemplateState>();
  final GlobalKey<MiscInputFieldTemplateState> _key2 = GlobalKey<MiscInputFieldTemplateState>();
  final GlobalKey<MiscPhoneNumberTemplateState> _key3 = GlobalKey<MiscPhoneNumberTemplateState>();
  final GlobalKey<MiscInputFieldTemplateState> _key4 = GlobalKey<MiscInputFieldTemplateState>();
  final GlobalKey<MiscInputFieldTemplateState> _key5 = GlobalKey<MiscInputFieldTemplateState>();
  final GlobalKey<MiscInputFieldTemplateState> _key6 = GlobalKey<MiscInputFieldTemplateState>();
  final _formKey = GlobalKey<FormState>();

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
            body: Stack(
              children: [
                SingleChildScrollView(
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
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  Container(
                                    height: SizeConfig.screenHeight! / 6,
                                    decoration: const BoxDecoration(image: DecorationImage(fit: BoxFit.cover, image: AssetImage('assets/icons/regular-background.png'),),),
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

                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 40),
                                    child: Column(
                                      children: [
                                        MiscInputFieldTemplate(
                                          key: _key1,
                                          labelText: 'First Name',
                                          type: TextInputType.name,
                                        ),

                                        MiscInputFieldTemplate(
                                          key: _key2,
                                          labelText: 'Last Name',
                                          type: TextInputType.name,
                                        ),

                                        MiscPhoneNumberTemplate(
                                          key: _key3,
                                          labelText: 'Mobile #',
                                          type: TextInputType.phone,
                                        ),

                                        MiscInputFieldTemplate(
                                          key: _key4,
                                          labelText: 'Email Address',
                                          type: TextInputType.emailAddress,
                                        ),

                                        MiscInputFieldTemplate(
                                          key: _key5,
                                          labelText: 'Username',
                                          type: TextInputType.text,
                                        ),

                                        MiscInputFieldTemplate(
                                          key: _key6,
                                          labelText: 'Password',
                                          type: TextInputType.text,
                                          obscureText: true,
                                        ),
                                      ],
                                    ),
                                  ),

                                  const Expanded(child: SizedBox()),
                                  
                                  const SizedBox(height: 50,),

                                  MiscButtonTemplate(
                                    buttonText: 'Next',
                                    buttonTextStyle: const TextStyle(fontSize: 24, fontFamily: 'NexaBold', color: Color(0xffffffff),),
                                    width: SizeConfig.screenWidth! / 2,
                                    height: 50,
                                    buttonColor: const Color(0xff04ECFF),
                                    onPressed: () async{
                                      bool validEmail = false;
                                      validEmail = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(_key4.currentState!.controller.text);

                                      if(!(_formKey.currentState!.validate())){
                                        await showDialog(
                                          context: context,
                                          builder: (context) => CustomDialog(
                                            image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                            title: 'Error',
                                            description: 'Please complete the form before submitting.',
                                            okButtonColor: const Color(0xfff44336), // RED
                                            includeOkButton: true,
                                          ),
                                        );
                                      }else if(!validEmail){
                                        await showDialog(
                                          context: context,
                                          builder: (context) => CustomDialog(
                                            image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                            title: 'Error',
                                            description: 'Invalid email address. Please try again.',
                                            okButtonColor: const Color(0xfff44336), // RED
                                            includeOkButton: true,
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
                                            builder: (context) => CustomDialog(
                                              image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                              title: 'Error',
                                              description: result,
                                              okButtonColor: const Color(0xfff44336), // RED
                                              includeOkButton: true,
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
                                          ..onTap = (){
                                            Navigator.pushNamed(context, '/regular/login');
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
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}