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
          body: SafeArea(
            bottom: false,
            child: Container(
              height: SizeConfig.screenHeight,
              width: SizeConfig.screenWidth,
              decoration: BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/icons/background2.png'),
                  colorFilter: ColorFilter.srgbToLinearGamma(),
                ),
              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back, color: Color(0xff000000), size: SizeConfig.blockSizeVertical! * 3.65,),
                    ),
                  ),

                  SizedBox(height: SizeConfig.blockSizeVertical! * 3.65),

                  Container(
                    padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal! * 8.75),
                    alignment: Alignment.centerLeft,
                    child: Text('Log In',
                      style: TextStyle(
                        fontSize: SizeConfig.blockSizeVertical! * 4.93,
                        fontFamily: 'NexaBold',
                        color: Color(0xff2F353D),
                      ),
                    ),
                  ),

                  SizedBox(height: SizeConfig.blockSizeVertical! * 3.65),

                  Row(
                    children: [
                      Spacer(),

                      SizedBox(
                        width: 16.93 * SizeConfig.blockSizeHorizontal!,
                        height: 14.93 * SizeConfig.blockSizeHorizontal!,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xff3A559F),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                          ),
                          onPressed: () async{
                            final fb = FacebookLogin();
                            bool isLoggedIn = await fb.isLoggedIn;

                            if(isLoggedIn == true){
                              context.loaderOverlay.show();

                              FacebookUserProfile profile = (await fb.getUserProfile())!;
                              String email = (await fb.getUserEmail())!;
                              String image = (await fb.getProfileImageUrl(width: 50, height: 50))!;
                              FacebookAccessToken token = (await fb.accessToken)!;

                              bool apiResult = await apiBLMSignInWithFacebook(
                                firstName: '${profile.name}',
                                lastName: '',
                                email: email,
                                username: email,
                                facebookId: token.token,
                                image: image
                              );
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
                                    image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                    title: Text('Error',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 3.16, fontFamily: 'NexaRegular'),
                                    ),
                                    entryAnimation: EntryAnimation.DEFAULT,
                                    description: Text('Invalid email or password. Please try again.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.87, fontFamily: 'NexaRegular'),
                                    ),
                                    onlyOkButton: true,
                                    buttonOkColor: const Color(0xffff0000),
                                    onOkButtonPressed: () {
                                      Navigator.pop(context, true);
                                    },
                                  ),
                                );
                              }
                            }else{
                              final result = await fb.logIn(permissions: [
                                FacebookPermission.publicProfile,
                                FacebookPermission.email,
                                FacebookPermission.userFriends,
                              ]);

                              final email = (await fb.getUserEmail())!;
                              final profile = (await fb.getUserProfile())!;
                              final image = (await fb.getProfileImageUrl(width: 50, height: 50))!;
                              FacebookAccessToken token = (await fb.accessToken)!;

                              if(result.status != FacebookLoginStatus.cancel){
                                context.loaderOverlay.show();
                                bool apiResult = await apiBLMSignInWithFacebook(
                                  firstName: '${profile.name}',
                                  lastName: '',
                                  email: email,
                                  username: email,
                                  facebookId: result.accessToken!.token,
                                  image: image,
                                );
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
                          child: Center(child: Image.asset('assets/icons/Facebook2.png',),),
                        ),
                      ),

                      Spacer(),

                      SizedBox(
                        width: 14.93 * SizeConfig.blockSizeHorizontal!,
                        height: 14.93 * SizeConfig.blockSizeHorizontal!,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xffFFFFFF),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                          ),
                          onPressed: () async{
                            User? user = await BLMGoogleAuthentication.signInWithGoogle(context: context);

                            if (user != null) {
                              final sharedPrefs = await SharedPreferences.getInstance();
                              sharedPrefs.setBool('blm-social-app-session', true);
                              Navigator.pushReplacementNamed(context, '/home/blm');
                            }
                          },
                          child: Center(child: Image.asset('assets/icons/google.png',),),
                        ),
                      ),

                      Spacer(),

                      SizedBox(
                        width: 14.93 * SizeConfig.blockSizeHorizontal!,
                        height: 14.93 * SizeConfig.blockSizeHorizontal!,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xff000000),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                          ),
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
                                  image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                  title: Text('Error',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: SizeConfig.blockSizeVertical! * 3.16,
                                      fontFamily: 'NexaRegular',
                                    ),
                                  ),
                                  entryAnimation: EntryAnimation.DEFAULT,
                                  description: Text('Invalid email or password. Please try again.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: SizeConfig.blockSizeVertical! * 2.87,
                                      fontFamily: 'NexaRegular',
                                    ),
                                  ),
                                  onlyOkButton: true,
                                  buttonOkColor: const Color(0xffff0000),
                                  onOkButtonPressed: () {
                                    Navigator.pop(context, true);
                                  },
                                ),
                              );
                            }
                          },
                          child: Center(child: Image.asset('assets/icons/apple.png',),),
                        ),
                      ),

                      Spacer(),
                    ],
                  ),

                  SizedBox(height: SizeConfig.blockSizeVertical! * 5.11),

                  Center(
                    child: Text('or log in with email',
                      style: TextStyle(
                        fontSize: SizeConfig.blockSizeVertical! * 2.74,
                        color: Color(0xff000000),
                        fontFamily: 'NexaRegular',
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal! * 8.75, right: SizeConfig.blockSizeHorizontal! * 8.75),
                    child: MiscBLMInputFieldTemplate(
                      key: _key1,
                      labelText: 'Email Address',
                      labelTextStyle: TextStyle(
                        fontSize: SizeConfig.blockSizeVertical! * 2.74,
                        color: Color(0xff000000),
                        fontFamily: 'NexaRegular',
                      ),
                      type: TextInputType.emailAddress,
                    ),
                  ),

                  
                  Padding(
                    padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal! * 8.75, right: SizeConfig.blockSizeHorizontal! * 8.75),
                    child: MiscBLMInputFieldTemplate(
                      key: _key2,
                      labelText: 'Password',
                      labelTextStyle: TextStyle(
                        fontSize: SizeConfig.blockSizeVertical! * 2.74,
                        color: Color(0xff000000),
                        fontFamily: 'NexaRegular',
                      ),
                      type: TextInputType.text,
                      obscureText: true,
                    ),
                  ),

                  SizedBox(height: SizeConfig.blockSizeVertical! * 2.19),

                  Container(
                    padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal! * 8.75, right: SizeConfig.blockSizeHorizontal! * 8.75),
                    child: Row(
                      children: [
                        Spacer(),

                        GestureDetector(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text('Forgot Password?',
                              style: TextStyle(
                                color: Color(0xff2F353D),
                                fontSize: SizeConfig.blockSizeVertical! * 2.19,
                                fontFamily: 'NexaRegular',
                              ),
                            ),
                          ),
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => BLMPasswordResetEmail()));
                          },
                        ),
                      ],
                    ),
                  ),

                  Spacer(),

                  MiscBLMButtonTemplate(
                    buttonText: 'Log In',
                    buttonTextStyle: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 3.29, color: const Color(0xffffffff), fontFamily: 'NexaBold'),
                    width: SizeConfig.screenWidth! / 2,
                    height: 45,
                    buttonColor: const Color(0xff4EC9D4),
                    onPressed: () async{
                      bool validEmail = false;
                      validEmail = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(_key1.currentState!.controller.text);

                      if(_key1.currentState!.controller.text == '' || _key2.currentState!.controller.text == ''){
                        await showDialog(
                          context: context,
                          builder: (_) => AssetGiffyDialog(
                            image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                            title: Text('Error',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: SizeConfig.blockSizeVertical! * 3.16,
                                fontFamily: 'NexaRegular',
                              ),
                            ),
                            entryAnimation: EntryAnimation.DEFAULT,
                            description: Text('Please complete the form before submitting.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: SizeConfig.blockSizeVertical! * 2.87,
                                fontFamily: 'NexaRegular',
                              ),
                            ),
                            onlyOkButton: true,
                            buttonOkColor: const Color(0xffff0000),
                            onOkButtonPressed: (){
                              Navigator.pop(context, true);
                            },
                          ),
                        );
                      } else if(!validEmail){
                        await showDialog(
                          context: context,
                          builder: (_) => AssetGiffyDialog(
                            image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                            title: Text('Error',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: SizeConfig.blockSizeVertical! * 3.16,
                                fontFamily: 'NexaRegular',
                              ),
                            ),
                            entryAnimation: EntryAnimation.DEFAULT,
                            description: Text('Invalid email address. Please try again.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: SizeConfig.blockSizeVertical! * 2.87,
                                fontFamily: 'NexaRegular',
                              ),
                            ),
                            onlyOkButton: true,
                            buttonOkColor: const Color(0xffff0000),
                            onOkButtonPressed: (){
                              Navigator.pop(context, true);
                            },
                          ),
                        );
                      } else {
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
                              image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                              title: Text('Error',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: SizeConfig.blockSizeVertical! * 3.16,
                                  fontFamily: 'NexaRegular',
                                ),
                              ),
                              entryAnimation: EntryAnimation.DEFAULT,
                              description: Text('Error: $result',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.87, fontFamily: 'NexaRegular'),
                              ),
                              onlyOkButton: true,
                              buttonOkColor: const Color(0xffff0000),
                              onOkButtonPressed: (){
                                Navigator.pop(context, true);
                              },
                            ),
                          );
                        }
                      }
                    },
                  ),

                  SizedBox(height: SizeConfig.blockSizeVertical! * 3.29),

                  RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Don\'t have an Account? ',
                          style: TextStyle(
                            fontSize: SizeConfig.blockSizeVertical! * 2.74,
                            color: Color(0xff2F353D),
                            fontFamily: 'NexaRegular',
                          ),
                        ),
                        TextSpan(
                          text: 'Sign Up',
                          style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.74, color: Color(0xff4EC9D4), fontFamily: 'NexaRegular'),
                          recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushNamed(context, '/blm/register');
                          },
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: SizeConfig.blockSizeVertical! * 2.00),

                  GestureDetector(
                    onTap: () async{
                      final sharedPrefs = await SharedPreferences.getInstance();
                      sharedPrefs.setBool('user-guest-session', true);
                      Navigator.pushReplacementNamed(context, '/home/blm');
                    },
                    child: Text('Sign in as Guest',
                      style: TextStyle(
                        fontSize: SizeConfig.blockSizeVertical! * 2.74,
                        fontFamily: 'NexaRegular',
                        color: Color(0xff4EC9D4),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),

                  SizedBox(height: SizeConfig.blockSizeVertical! * 2.00),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}