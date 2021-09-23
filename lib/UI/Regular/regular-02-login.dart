// ignore_for_file: file_names
import 'package:facesbyplaces/API/Regular/01-Start/api_start_regular_01_login.dart';
import 'package:facesbyplaces/API/Regular/01-Start/api_start_regular_05_sign_in_with_facebook.dart';
import 'package:facesbyplaces/API/Regular/01-Start/api_start_regular_07_sign_in_with_apple.dart';
import 'package:facesbyplaces/API/Regular/01-Start/api_start_regular_11_google_authentication.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc_01_regular_input_field.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc_06_regular_button.dart';
import 'package:facesbyplaces/UI/Regular/regular-06-password-reset-email.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:firebase_auth/firebase_auth.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../ui-01-get-started.dart';

class RegularLogin extends StatefulWidget{
  const RegularLogin({Key? key}) : super(key: key);

  @override
  RegularLoginState createState() => RegularLoginState();
}

class RegularLoginState extends State<RegularLogin>{
  final GlobalKey<MiscRegularInputFieldTemplateState> _key1 = GlobalKey<MiscRegularInputFieldTemplateState>();
  final GlobalKey<MiscRegularInputFieldTemplateState> _key2 = GlobalKey<MiscRegularInputFieldTemplateState>();

  @override
  Widget build(BuildContext context){
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
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: IconButton(
                                    icon: const Icon(Icons.arrow_back, color: Color(0xff000000), size: 35),
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
                                            bool apiResult = await apiRegularSignInWithFacebook(firstName: '${profile.name}', lastName: '',email: email, username: email, facebookId: token.token, image: image);
                                            context.loaderOverlay.hide();

                                            if(apiResult == true){
                                              final OAuthCredential credential = FacebookAuthProvider.credential(token.token);
                                              await FirebaseAuth.instance.signInWithCredential(credential);
                                              final sharedPrefs = await SharedPreferences.getInstance();
                                              sharedPrefs.setBool('regular-social-app-session', true);
                                              Navigator.pushReplacementNamed(context, '/home/regular');
                                            }else{
                                              await showDialog(
                                                context: context,
                                                builder: (_) => AssetGiffyDialog(
                                                  title: const Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontFamily: 'NexaRegular'),),
                                                  description: const Text('Invalid email or password. Please try again.', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular'),),
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
                                              bool apiResult = await apiRegularSignInWithFacebook(firstName: '${profile.name}', lastName: '', email: email, username: email, facebookId: result.accessToken!.token, image: image,);
                                              context.loaderOverlay.hide();

                                              if(apiResult == false){
                                                await fb.logOut();
                                              }else{
                                                final OAuthCredential credential = FacebookAuthProvider.credential(token.token);
                                                await FirebaseAuth.instance.signInWithCredential(credential);
                                                final sharedPrefs = await SharedPreferences.getInstance();
                                                sharedPrefs.setBool('regular-social-app-session', true);
                                                Navigator.pushReplacementNamed(context, '/home/regular');
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
                                        style: ElevatedButton.styleFrom(primary: const Color(0xffFFFFFF), shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10),),),),
                                        child: Center(child: Image.asset('assets/icons/google.png',),),
                                        onPressed: () async{
                                          User? user = await RegularGoogleAuthentication.signInWithGoogle(context: context);

                                          if(user != null){
                                            final sharedPrefs = await SharedPreferences.getInstance();
                                            sharedPrefs.setBool('regular-social-app-session', true);
                                            Navigator.pushReplacementNamed(context, '/home/regular');
                                          }
                                        },
                                      ),
                                    ),

                                    const Spacer(),

                                    SizedBox(
                                      height: 70,
                                      width: 70,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          primary: const Color(0xff000000),
                                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10),),),
                                        ),
                                        child: Center(child: Image.asset('assets/icons/apple.png',),),
                                        onPressed: () async{
                                          AuthorizationCredentialAppleID credential = await SignInWithApple.getAppleIDCredential(
                                            scopes: [
                                              AppleIDAuthorizationScopes.email,
                                              AppleIDAuthorizationScopes.fullName,
                                            ],
                                            webAuthenticationOptions: WebAuthenticationOptions(clientId: 'com.puckproductions.facesbyplaces', redirectUri: Uri.parse('https://com.app.facesbyplaces.glitch.me/callbacks/sign_in_with_apple'),),
                                          );
                                          // final oAuthProvider = OAuthProvider('apple.com');
                                          // final newCredentials = oAuthProvider.credential(idToken: credential.identityToken, accessToken: credential.authorizationCode);

                                          context.loaderOverlay.show();
                                          bool result = await apiRegularSignInWithApple(userIdentification: credential.userIdentifier!, identityToken: credential.identityToken!);
                                          context.loaderOverlay.hide();

                                          if(result == true){
                                            final sharedPrefs = await SharedPreferences.getInstance();
                                            sharedPrefs.setBool('regular-social-app-session', true);
                                            Navigator.pushReplacementNamed(context, '/home/regular');
                                          }else{
                                            await showDialog(
                                              context: context,
                                              builder: (_) => AssetGiffyDialog(
                                                title: const Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontFamily: 'NexaRegular',),),
                                                description: const Text('Invalid email or password. Please try again.', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular',),),
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

                                const Center(child: Text('or log in with email', style: TextStyle(fontSize: 24, color: Color(0xff000000), fontFamily: 'NexaRegular',),),),

                                const SizedBox(height: 50),

                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 40),
                                  child: MiscRegularInputFieldTemplate(
                                    key: _key1,
                                    labelTextStyle: const TextStyle(fontSize: 24, color: Color(0xff000000), fontFamily: 'NexaRegular',),
                                    type: TextInputType.emailAddress,
                                    labelText: 'Email Address',
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 40),
                                  child: MiscRegularInputFieldTemplate(
                                    key: _key2,
                                    labelTextStyle: const TextStyle(fontSize: 24, color: Color(0xff000000), fontFamily: 'NexaRegular'),
                                    type: TextInputType.text,
                                    labelText: 'Password',
                                    obscureText: true,
                                  ),
                                ),

                                const SizedBox(height: 20,),

                                Container(
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
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => RegularPasswordResetEmail()));
                                        },
                                      ),
                                    ],
                                  ),
                                ),

                                Expanded(child: Container(),),

                                const SizedBox(height: 30,),

                                MiscRegularButtonTemplate(
                                  buttonText: 'Log In',
                                  buttonTextStyle: const TextStyle(fontSize: 24, color: Color(0xffffffff), fontFamily: 'NexaBold',),
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
                                          title: const Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontFamily: 'NexaRegular'),),
                                          description: const Text('Please complete the form before submitting.', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular'),),
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
                                          title: const Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontFamily: 'NexaRegular'),),
                                          description: const Text('Invalid email address. Please try again.', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular'),),
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
                                      String result = await apiRegularLogin(email: _key1.currentState!.controller.text, password: _key2.currentState!.controller.text, deviceToken: deviceToken);
                                      context.loaderOverlay.hide();

                                      if(result == 'Success'){
                                        Navigator.pushReplacementNamed(context, '/home/regular');
                                      }else{
                                        await showDialog(
                                          context: context,
                                          builder: (_) => AssetGiffyDialog(
                                            title: const Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontFamily: 'NexaRegular',),),
                                            description: Text('Error: $result', textAlign: TextAlign.center, style: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular',),),
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
                                        style: TextStyle(fontSize: 22, color: Color(0xff2F353D), fontFamily: 'NexaRegular',),
                                      ),

                                      TextSpan(
                                        text: 'Sign Up', 
                                        style: const TextStyle(fontSize: 22, color: Color(0xff4EC9D4), fontFamily: 'NexaRegular',), 
                                        recognizer: TapGestureRecognizer()
                                        ..onTap = (){
                                          Navigator.pushNamed(context, '/regular/register');
                                        },
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 20,),

                                GestureDetector(
                                  child: const Text('Sign in as Guest', style: TextStyle(fontSize: 22, fontFamily: 'NexaRegular', color: Color(0xff4EC9D4), decoration: TextDecoration.underline,),),
                                  onTap: () async{
                                    final sharedPrefs = await SharedPreferences.getInstance();
                                    sharedPrefs.setBool('user-guest-session', true);
                                    Navigator.pushReplacementNamed(context, '/home/regular');
                                  },
                                ),

                                const SizedBox(height: 20,),

                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 40),
                                  child: RichText(
                                    text: const TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(text: 'Connect  /  ', style: TextStyle(fontSize: 22, fontFamily: 'NexaRegular', color: Color(0xffBDC3C7),),),

                                        TextSpan(text: 'Remember  /  ', style: TextStyle(fontSize: 22, fontFamily: 'NexaRegular', color: Color(0xffBDC3C7),),),

                                        TextSpan(text: 'Honor', style: TextStyle(fontSize: 22, fontFamily: 'NexaRegular', color: Color(0xffBDC3C7),),),
                                      ],
                                    ),
                                  ),
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
      ),
    );
  }
}