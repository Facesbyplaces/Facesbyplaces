import 'package:facesbyplaces/API/BLM/01-Start/api_start_blm_01_login.dart';
import 'package:facesbyplaces/API/BLM/01-Start/api_start_blm_05_sign_in_with_facebook.dart';
import 'package:facesbyplaces/API/BLM/01-Start/api_start_blm_07_sign_in_with_apple.dart';
import 'package:facesbyplaces/API/BLM/01-Start/api_start_blm_11_google_authentication.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'blm_06_password_reset_email.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:dialog/dialog.dart';
import '../ui_01_get_started.dart';
import 'package:misc/misc.dart';

class BLMLogin extends StatelessWidget{
  BLMLogin({Key? key}) : super(key: key);
  final GlobalKey<MiscInputFieldTemplateState> _key1 = GlobalKey<MiscInputFieldTemplateState>();
  final GlobalKey<MiscInputFieldTemplateState> _key2 = GlobalKey<MiscInputFieldTemplateState>();
  final _formKey = GlobalKey<FormState>();

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
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: IconButton(
                                    icon: const Icon(Icons.arrow_back, color: Color(0xff000000), size: 35,),
                                    onPressed: (){
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),

                                const SizedBox(height: 30,),

                                Container(
                                  child: const Text('Log In', style: TextStyle(fontSize: 36, fontFamily: 'NexaBold', color: Color(0xff2F353D),),),
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
                                        style: ElevatedButton.styleFrom(primary: const Color(0xff3A559F), shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10),),),),
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
                                              final OAuthCredential credential = FacebookAuthProvider.credential(token.token);
                                              await FirebaseAuth.instance.signInWithCredential(credential);
                                              final sharedPrefs = await SharedPreferences.getInstance();
                                              sharedPrefs.setBool('blm-social-app-session', true);
                                              Navigator.pushReplacementNamed(context, '/home/blm');
                                            }else{
                                              await showDialog(
                                                context: context,
                                                builder: (context) => CustomDialog(
                                                  image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                                  title: 'Error',
                                                  description: 'Invalid email or password. Please try again.',
                                                  okButtonColor: const Color(0xfff44336), // RED
                                                  includeOkButton: true,
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
                                                final OAuthCredential credential = FacebookAuthProvider.credential(token.token);
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
                                        style: ElevatedButton.styleFrom(primary: const Color(0xffFFFFFF), shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10),),),),
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
                                        style: ElevatedButton.styleFrom(primary: const Color(0xff000000), shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10),),),),
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
                                              builder: (context) => CustomDialog(
                                                image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                                title: 'Error',
                                                description: 'Invalid email or password. Please try again.',
                                                okButtonColor: const Color(0xfff44336), // RED
                                                includeOkButton: true,
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

                                const Center(child: Text('or log in with email', style: TextStyle(fontSize: 24, color: Color(0xff000000), fontFamily: 'NexaRegular',),)),

                                const SizedBox(height: 50),

                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 40),
                                  child: MiscInputFieldTemplate(
                                    key: _key1,
                                    labelText: 'Email Address',
                                    type: TextInputType.emailAddress,
                                  ),
                                ),


                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 40),
                                  child: MiscInputFieldTemplate(
                                    key: _key2,
                                    labelText: 'Password',
                                    obscureText: true,
                                    type: TextInputType.text,
                                  ),
                                ),

                                const SizedBox(height: 20,),

                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 40),
                                  child: Row(
                                    children: [
                                      const Spacer(),

                                      GestureDetector(
                                        child: const Align(
                                          child: Text('Forgot Password?', style: TextStyle(color: Color(0xff2F353D), fontSize: 20, fontFamily: 'NexaRegular', decoration: TextDecoration.underline),),
                                          alignment: Alignment.centerRight,
                                        ),
                                        onTap: (){
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => BLMPasswordResetEmail()));
                                        },
                                      ),
                                    ],
                                  ),
                                ),

                                const Expanded(child: SizedBox(),),

                                const SizedBox(height: 30,),

                                MiscButtonTemplate(
                                  buttonText: 'Log In',
                                  buttonTextStyle: const TextStyle(fontSize: 24, color: Color(0xffffffff), fontFamily: 'NexaBold'),
                                  buttonColor: const Color(0xff4EC9D4),
                                  width: SizeConfig.screenWidth! / 2,
                                  height: 50,
                                  onPressed: () async{
                                    bool validEmail = false;
                                    validEmail = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(_key1.currentState!.controller.text);

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
                                      context.loaderOverlay.show();
                                      String deviceToken = '';
                                      final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
                                      final pushNotificationService = PushNotificationService(_firebaseMessaging, context);
                                      pushNotificationService.initialise();

                                      deviceToken = (await pushNotificationService.fcm.getToken().onError((error, stackTrace){
                                        context.loaderOverlay.hide();
                                        showDialog(
                                          context: context,
                                          builder: (context) => CustomDialog(
                                            image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                            title: 'Error',
                                            description: 'Something went wrong. Please check your internet connection.',
                                            okButtonColor: const Color(0xfff44336), // RED
                                            includeOkButton: true,
                                          ),
                                        );
                                      }))!;

                                      String result = await apiBLMLogin(email: _key1.currentState!.controller.text, password: _key2.currentState!.controller.text, deviceToken: deviceToken).onError((error, stackTrace){
                                        context.loaderOverlay.hide();
                                        showDialog(
                                          context: context,
                                          builder: (context) => CustomDialog(
                                            image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                            title: 'Error',
                                            description: 'Something went wrong. Please check your internet connection.',
                                            okButtonColor: const Color(0xfff44336), // RED
                                            includeOkButton: true,
                                          ),
                                        );
                                        throw Exception('Something went wrong. Please check your internet connection.');
                                      });
                                      context.loaderOverlay.hide();

                                      if(result == 'Success'){
                                        Navigator.pushReplacementNamed(context, '/home/blm');
                                      }else{
                                        await showDialog(
                                          context: context,
                                          builder: (context) => CustomDialog(
                                            image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                            title: 'Error',
                                            description: 'Error: $result',
                                            okButtonColor: const Color(0xfff44336), // RED
                                            includeOkButton: true,
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
                                        style: TextStyle(fontSize: 22, color: Color(0xff2F353D), fontFamily: 'NexaRegular',),
                                      ),

                                      TextSpan(
                                        text: 'Sign Up',
                                        style: const TextStyle(fontSize: 22, color: Color(0xff4EC9D4), fontFamily: 'NexaRegular'),
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
                                  child: const Text('Sign in as Guest', style: TextStyle(fontSize: 22, fontFamily: 'NexaRegular', color: Color(0xff4EC9D4), decoration: TextDecoration.underline,)),
                                  onTap: () async{
                                    final sharedPrefs = await SharedPreferences.getInstance();
                                    sharedPrefs.setBool('user-guest-session', true);
                                    // Navigator.pushReplacementNamed(context, '/home/blm');
                                    Navigator.pushReplacementNamed(context, '/home/blm/search');
                                  },
                                ),

                                const SizedBox(height: 10),
                              ],
                            ),
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