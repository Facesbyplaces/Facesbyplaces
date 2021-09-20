// ignore_for_file: file_names
import 'package:facesbyplaces/API/BLM/01-Start/api-start-blm-01-login.dart';
import 'package:facesbyplaces/API/BLM/01-Start/api-start-blm-05-sign-in-with-facebook.dart';
import 'package:facesbyplaces/API/BLM/01-Start/api-start-blm-07-sign-in-with-apple.dart';
import 'package:facesbyplaces/API/BLM/01-Start/api-start-blm-11-google-authentication.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-01-blm-input-field.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-06-blm-button.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:firebase_auth/firebase_auth.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:giffy_dialog/giffy_dialog.dart';
import 'blm-06-password-reset-email.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import '../ui-01-get-started.dart';

class BLMLogin extends StatelessWidget{
  final GlobalKey<MiscBLMInputFieldTemplateState> _key1 = GlobalKey<MiscBLMInputFieldTemplateState>();
  final GlobalKey<MiscBLMInputFieldTemplateState> _key2 = GlobalKey<MiscBLMInputFieldTemplateState>();

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
          if (!currentFocus.hasPrimaryFocus){
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
                  decoration: BoxDecoration(
                    color: const Color(0xffffffff),
                    image: DecorationImage(fit: BoxFit.cover, image: const AssetImage('assets/icons/background2.png'), colorFilter: const ColorFilter.srgbToLinearGamma(),),
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
                              Align(
                                alignment: Alignment.centerLeft,
                                child: IconButton(
                                  icon: const Icon(Icons.arrow_back, color: const Color(0xff000000), size: 35,),
                                  onPressed: (){
                                    Navigator.pop(context);
                                  },
                                ),
                              ),

                              const SizedBox(height: 30,),

                              Container(
                                child: const Text('Log In', style: const TextStyle(fontSize: 36, fontFamily: 'NexaBold', color: const Color(0xff2F353D),),),
                                padding: const EdgeInsets.only(left: 40),
                                alignment: Alignment.centerLeft,
                              ),

                              const SizedBox(height: 30,),

                              Row(
                                children: [
                                  const Spacer(),

                                  SizedBox(
                                    height: 70,
                                    width: 70,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(primary: const Color(0xff3A559F), shape: const RoundedRectangleBorder(borderRadius: const BorderRadius.all(Radius.circular(10),),),),
                                      child: Center(child: Image.asset('assets/icons/Facebook2.png',),),
                                      onPressed: () async{
                                        final fb = FacebookLogin();
                                        bool isLoggedIn = await fb.isLoggedIn;

                                        if(isLoggedIn == true){
                                          context.loaderOverlay.show();
                                          FacebookUserProfile profile = (await fb.getUserProfile())!;
                                          String email = (await fb.getUserEmail())!;
                                          String image = (await fb.getProfileImageUrl(width: 50, height: 50))!;
                                          FacebookAccessToken token = (await fb.accessToken)!;
                                          bool apiResult = await apiBLMSignInWithFacebook(firstName: '${profile.name}', lastName: '', email: email, username: email, facebookId: token.token, image: image,);
                                          context.loaderOverlay.hide();

                                          if(apiResult == true){
                                            final OAuthCredential credential = FacebookAuthProvider.credential('${token.token}');
                                            await FirebaseAuth.instance.signInWithCredential(credential);
                                            final sharedPrefs = await SharedPreferences.getInstance();
                                            sharedPrefs.setBool('blm-social-app-session', true);
                                            Navigator.pushReplacementNamed(context, '/home/blm');
                                          }else{
                                            await showDialog(
                                              context: context,
                                              builder: (_) => AssetGiffyDialog(
                                                title: const Text('Error', textAlign: TextAlign.center, style: const TextStyle(fontSize: 32, fontFamily: 'NexaRegular'),),
                                                description: const Text('Invalid email or password. Please try again.', textAlign: TextAlign.center, style: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular'),),
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
                                        }else{
                                          final result = await fb.logIn(permissions: [FacebookPermission.publicProfile, FacebookPermission.email, FacebookPermission.userFriends,]);
                                          final email = (await fb.getUserEmail())!;
                                          final profile = (await fb.getUserProfile())!;
                                          final image = (await fb.getProfileImageUrl(width: 50, height: 50))!;
                                          FacebookAccessToken token = (await fb.accessToken)!;

                                          if(result.status != FacebookLoginStatus.cancel){
                                            context.loaderOverlay.show();
                                            bool apiResult = await apiBLMSignInWithFacebook(firstName: '${profile.name}', lastName: '', email: email, username: email, facebookId: result.accessToken!.token, image: image,);
                                            context.loaderOverlay.hide();

                                            if(apiResult == false){
                                              await fb.logOut();
                                            }else{
                                              final OAuthCredential credential = FacebookAuthProvider.credential('${token.token}');
                                              await FirebaseAuth.instance.signInWithCredential(credential);
                                              final sharedPrefs = await SharedPreferences.getInstance();
                                              sharedPrefs.setBool('blm-social-app-session', true);
                                              Navigator.pushReplacementNamed(context, '/home/blm');
                                            }
                                          }
                                        }
                                      },
                                    ),
                                  ),

                                  const Spacer(),

                                  SizedBox(
                                    height: 70,
                                    width: 70,
                                    child: ElevatedButton(
                                      child: Center(child: Image.asset('assets/icons/google.png',),),
                                      style: ElevatedButton.styleFrom(primary: const Color(0xffFFFFFF), shape: const RoundedRectangleBorder(borderRadius: const BorderRadius.all(Radius.circular(10),),),),
                                      onPressed: () async{
                                        User? user = await BLMGoogleAuthentication.signInWithGoogle(context: context);

                                        if (user != null) {
                                          final sharedPrefs = await SharedPreferences.getInstance();
                                          sharedPrefs.setBool('blm-social-app-session', true);
                                          Navigator.pushReplacementNamed(context, '/home/blm');
                                        }
                                      },
                                    ),
                                  ),

                                  const Spacer(),

                                  SizedBox(
                                    height: 70,
                                    width: 70,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(primary: const Color(0xff000000), shape: const RoundedRectangleBorder(borderRadius: const BorderRadius.all(Radius.circular(10),),),),
                                      child: Center(child: Image.asset('assets/icons/apple.png',),),
                                      onPressed: () async{
                                        AuthorizationCredentialAppleID credential = await SignInWithApple.getAppleIDCredential(
                                          scopes: [
                                            AppleIDAuthorizationScopes.email,
                                            AppleIDAuthorizationScopes.fullName,
                                          ],
                                        );

                                        context.loaderOverlay.show();
                                        bool result = await apiBLMSignInWithApple(userIdentification: credential.userIdentifier!, identityToken: credential.identityToken!);
                                        context.loaderOverlay.hide();

                                        if(result == true){
                                          final sharedPrefs = await SharedPreferences.getInstance();
                                          sharedPrefs.setBool('blm-social-app-session', true);
                                          Navigator.pushReplacementNamed(context, '/home/blm');
                                        }else{
                                          await showDialog(
                                            context: context,
                                            builder: (_) => AssetGiffyDialog(
                                              title: const Text('Error', textAlign: TextAlign.center, style: const TextStyle(fontSize: 32, fontFamily: 'NexaRegular',),),
                                              description: const Text('Invalid email or password. Please try again.', textAlign: TextAlign.center, style: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular',),),
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
                                      },
                                    ),
                                  ),

                                  const Spacer(),
                                ],
                              ),

                              const SizedBox(height: 50),

                              const Center(child: const Text('or log in with email', style: const TextStyle(fontSize: 24, color: const Color(0xff000000), fontFamily: 'NexaRegular',),)),

                              const SizedBox(height: 50),

                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 40),
                                child: MiscBLMInputFieldTemplate(
                                  key: _key1,
                                  labelText: 'Email Address',
                                  type: TextInputType.emailAddress,
                                  labelTextStyle: const TextStyle(fontSize: 24, color: const Color(0xff000000), fontFamily: 'NexaRegular',),
                                ),
                              ),


                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 40),
                                child: MiscBLMInputFieldTemplate(
                                  key: _key2,
                                  labelText: 'Password',
                                  obscureText: true,
                                  type: TextInputType.text,
                                  labelTextStyle: const TextStyle(fontSize: 24, color: const Color(0xff000000), fontFamily: 'NexaRegular',),
                                ),
                              ),

                              const SizedBox(height: 20,),

                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 40),
                                child: Row(
                                  children: [
                                    const Spacer(),

                                    GestureDetector(
                                      child: Align(
                                        child: const Text('Forgot Password?', style: const TextStyle(color: const Color(0xff2F353D), fontSize: 20, fontFamily: 'NexaRegular', decoration: TextDecoration.underline),),
                                        alignment: Alignment.centerRight,
                                      ),
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => BLMPasswordResetEmail()));
                                      },
                                    ),
                                  ],
                                ),
                              ),

                              Expanded(child: Container(),),

                              const SizedBox(height: 30,),

                              MiscBLMButtonTemplate(
                                buttonText: 'Log In',
                                buttonTextStyle: const TextStyle(fontSize: 24, color: const Color(0xffffffff), fontFamily: 'NexaBold'),
                                buttonColor: const Color(0xff4EC9D4),
                                width: SizeConfig.screenWidth! / 2,
                                height: 50,
                                onPressed: () async{
                                  bool validEmail = false;
                                  validEmail = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(_key1.currentState!.controller.text);

                                  if(_key1.currentState!.controller.text == '' || _key2.currentState!.controller.text == ''){
                                    await showDialog(
                                      context: context,
                                      builder: (_) => AssetGiffyDialog(
                                        title: const Text('Error', textAlign: TextAlign.center, style: const TextStyle(fontSize: 32, fontFamily: 'NexaRegular',),),
                                        description: const Text('Please complete the form before submitting.', textAlign: TextAlign.center, style: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular'),),
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
                                        title: const Text('Error', textAlign: TextAlign.center, style: const TextStyle(fontSize: 32, fontFamily: 'NexaRegular',),),
                                        description: const Text('Invalid email address. Please try again.', textAlign: TextAlign.center, style: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular',),),
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
                                    context.loaderOverlay.show();
                                    String deviceToken = '';
                                    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
                                    final pushNotificationService = PushNotificationService(_firebaseMessaging, context);
                                    pushNotificationService.initialise();
                                    deviceToken = (await pushNotificationService.fcm.getToken())!;
                                    String result = await apiBLMLogin(email: _key1.currentState!.controller.text, password: _key2.currentState!.controller.text, deviceToken: deviceToken);
                                    context.loaderOverlay.hide();

                                    if(result == 'Success'){
                                      Navigator.pushReplacementNamed(context, '/home/blm');
                                    }else{
                                      await showDialog(
                                        context: context,
                                        builder: (_) => AssetGiffyDialog(
                                          description: Text('Error: $result', textAlign: TextAlign.center, style: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular'),),
                                          title: const Text('Error', textAlign: TextAlign.center, style: const TextStyle(fontSize: 32, fontFamily: 'NexaRegular',),),
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

                              const SizedBox(height: 30,),

                              RichText(
                                text: TextSpan(
                                  children: <TextSpan>[
                                    const TextSpan(
                                      text: 'Don\'t have an Account? ',
                                      style: const TextStyle(fontSize: 22, color: const Color(0xff2F353D), fontFamily: 'NexaRegular',),
                                    ),

                                    TextSpan(
                                      text: 'Sign Up',
                                      style: const TextStyle(fontSize: 22, color: const Color(0xff4EC9D4), fontFamily: 'NexaRegular'),
                                      recognizer: TapGestureRecognizer()
                                      ..onTap = (){
                                        Navigator.pushNamed(context, '/blm/register');
                                      },
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 20,),

                              GestureDetector(
                                child: const Text('Sign in as Guest', style: const TextStyle(fontSize: 22, fontFamily: 'NexaRegular', color: const Color(0xff4EC9D4), decoration: TextDecoration.underline,)),
                                onTap: () async{
                                  final sharedPrefs = await SharedPreferences.getInstance();
                                  sharedPrefs.setBool('user-guest-session', true);
                                  Navigator.pushReplacementNamed(context, '/home/blm');
                                },
                              ),

                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                    ),
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