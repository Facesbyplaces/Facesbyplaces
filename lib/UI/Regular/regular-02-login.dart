import 'package:facesbyplaces/API/Regular/01-Start/api-start-regular-01-login.dart';
import 'package:facesbyplaces/API/Regular/01-Start/api-start-regular-05-sign-in-with-facebook.dart';
import 'package:facesbyplaces/API/Regular/01-Start/api-start-regular-07-sign-in-with-apple.dart';
import 'package:facesbyplaces/API/Regular/01-Start/api-start-regular-12-google-authentication.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-01-regular-input-field.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-06-regular-button.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-07-regular-background.dart';
import 'package:facesbyplaces/UI/Regular/regular-06-password-reset-email.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:auth_buttons/auth_buttons.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../ui-01-get-started.dart';

class RegularLogin extends StatefulWidget{

  RegularLoginState createState() => RegularLoginState();
}

class RegularLoginState extends State<RegularLogin>{

  final GlobalKey<MiscRegularInputFieldTemplateState> _key1 = GlobalKey<MiscRegularInputFieldTemplateState>();
  final GlobalKey<MiscRegularInputFieldTemplateState> _key2 = GlobalKey<MiscRegularInputFieldTemplateState>();

  @override
  Widget build(BuildContext context) {
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
                    child: const MiscRegularBackgroundTemplate(image: const AssetImage('assets/icons/background2.png'),),
                  ),
                ), // BACKGROUND IMAGE

                SingleChildScrollView(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  physics: const ClampingScrollPhysics(),
                  child: Column(
                    children: [

                      const SizedBox(height: 40),

                      Align(
                        alignment: Alignment.centerLeft, 
                        child: IconButton(
                          onPressed: (){
                            Navigator.pop(context);
                          }, 
                          icon: const Icon(
                            Icons.arrow_back, 
                            color: const Color(0xff000000), 
                            size: 30,
                          ),
                        ),
                      ),

                      const SizedBox(height: 25),

                      Container(
                        padding: const EdgeInsets.only(left: 20.0), 
                        alignment: Alignment.centerLeft, 
                        child: const Text('Login',
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold, 
                            color: const Color(0xff000000),
                          ),
                        ),
                      ),

                      const SizedBox(height: 25),

                      FacebookAuthButton(
                        style: AuthButtonStyle(
                          height: 44,
                          width: SizeConfig.screenWidth,
                        ),
                        onPressed: () async{

                          final fb = FacebookLogin(debug: true);
                          bool isLoggedIn = await fb.isLoggedIn;

                          if(isLoggedIn == true){
                            context.loaderOverlay.show();

                            FacebookUserProfile profile = (await fb.getUserProfile())!;
                            String email = (await fb.getUserEmail())!;
                            String image = (await fb.getProfileImageUrl(width: 50, height: 50))!;
                            FacebookAccessToken token = (await fb.accessToken)!;

                            bool apiResult = await apiRegularSignInWithFacebook(
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
                              Navigator.pushReplacementNamed(context, '/home/regular');
                            }else{
                              await showDialog(
                                context: context,
                                builder: (_) => 
                                  AssetGiffyDialog(
                                  image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                  title: const Text('Error', textAlign: TextAlign.center, style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                                  entryAnimation: EntryAnimation.DEFAULT,
                                  description: const Text('Invalid email or password. Please try again.',
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

                          }else{
                            final result = await fb.logIn(permissions: [
                              FacebookPermission.publicProfile,
                              FacebookPermission.email,
                              FacebookPermission.userFriends,
                            ]);

                            context.loaderOverlay.show();

                            final email = (await fb.getUserEmail())!;
                            final profile = (await fb.getUserProfile())!;
                            final image = (await fb.getProfileImageUrl(width: 50, height: 50))!;
                            FacebookAccessToken token = (await fb.accessToken)!;

                            if(result.status != FacebookLoginStatus.cancel){  
                              bool apiResult = await apiRegularSignInWithFacebook(
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
                                Navigator.pushReplacementNamed(context, '/home/regular');
                              }
                            }
                          }

                        },
                      ),

                      const SizedBox(height: 25),

                      GoogleAuthButton(
                        style: AuthButtonStyle(
                          splashColor: const Color(0xffffffff),
                          height: 44,
                        ),
                        onPressed: () async{
                          User? user = await RegularGoogleAuthentication.signInWithGoogle(context: context);
                          
                          if (user != null) {
                            Navigator.pushReplacementNamed(context, '/home/regular');
                          }
                        },
                      ),

                      const SizedBox(height: 25),

                      SignInWithAppleButton(
                        onPressed: () async {
                          AuthorizationCredentialAppleID credential = await SignInWithApple.getAppleIDCredential(
                            scopes: [
                              AppleIDAuthorizationScopes.email,
                              AppleIDAuthorizationScopes.fullName,
                            ],
                            webAuthenticationOptions: WebAuthenticationOptions( 
                              clientId: 'com.app.facesbyplaces',
                              redirectUri: Uri.parse('https://com.app.facesbyplaces.glitch.me/callbacks/sign_in_with_apple'),
                            ),
                          );
                          final oAuthProvider = OAuthProvider('apple.com');
                          final newCredentials = oAuthProvider.credential(idToken: credential.identityToken, accessToken: credential.authorizationCode);

                          print('The newCredentials is $newCredentials');
                          // final credential = oAuthProvider.getCredential(idToken: credential.identityToken, accessToken: credential.authorizationCode,);

                          context.loaderOverlay.show();
                          bool result = await apiRegularSignInWithApple(userIdentification: credential.userIdentifier!, identityToken: credential.identityToken!);
                          context.loaderOverlay.hide();

                          if(result == true){
                            // final OAuthCredential cred = FacebookAuthProvider.credential('${credential.identityToken}');
                            // await FirebaseAuth.instance.signInWithCredential(cred);
                            Navigator.pushReplacementNamed(context, '/home/regular');
                          }else{
                            await showDialog(
                              context: context,
                              builder: (_) => 
                                AssetGiffyDialog(
                                image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                title: const Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                                entryAnimation: EntryAnimation.DEFAULT,
                                description: const Text('Invalid email or password. Please try again.',
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
                        },
                      ),

                      const SizedBox(height: 40),

                      const Center(
                        child: const Text('or log in with email', 
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w300, 
                            color: const Color(0xff000000),
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20.0), 
                        child: MiscRegularInputFieldTemplate(
                          key: _key1, 
                          labelText: 'Email Address', 
                          type: TextInputType.emailAddress,
                        ),
                      ),

                      // Form(
                      //   key: formKey,
                      //   child: TextFormField(
                      //     controller: controller,
                      //     keyboardType: TextInputType.emailAddress,
                      //     cursorColor: Color(0xff000000),
                      //     decoration: InputDecoration(
                      //       alignLabelWithHint: true,
                      //       labelText: 'Email Address', 
                      //       labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey),
                      //       focusedBorder: UnderlineInputBorder(
                      //         borderSide: BorderSide(
                      //           color: Color(0xff000000),
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),

                      const SizedBox(height: 20),

                      Padding(
                        padding: EdgeInsets.only(left: 20.0, right: 20.0), 
                        child: MiscRegularInputFieldTemplate(
                          key: _key2, 
                          labelText: 'Password', 
                          type: TextInputType.text, 
                          obscureText: true,
                        ),
                      ),

                      const SizedBox(height: 20),

                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => RegularPasswordResetEmail()));
                        },
                        child: Align(
                          alignment: Alignment.centerRight, 
                          child: const Text('Forgot Password?', 
                            style: const TextStyle(
                              decoration: TextDecoration.underline,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      MiscRegularButtonTemplate(
                        buttonText: 'Login', 
                        buttonTextStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold, 
                          color: const Color(0xffffffff),
                        ),
                        width: SizeConfig.screenWidth! / 2, 
                        height: 45,
                        buttonColor: const Color(0xff4EC9D4),
                        onPressed: () async{
                          
                          bool validEmail = false;
                          validEmail = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(_key1.currentState!.controller.text );

                          if(_key1.currentState!.controller.text == '' || _key2.currentState!.controller.text == ''){
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
                            context.loaderOverlay.show();

                            String deviceToken = '';
                            final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
                            final pushNotificationService = PushNotificationService(_firebaseMessaging);
                            pushNotificationService.initialise();
                            deviceToken = (await pushNotificationService.fcm.getToken())!;
                            String result = await apiRegularLogin(email: _key1.currentState!.controller.text, password: _key2.currentState!.controller.text, deviceToken: deviceToken);

                            context.loaderOverlay.hide();

                            print('The result is $result');

                            if(result == 'Success'){
                              Navigator.pushReplacementNamed(context, '/home/regular');
                            }else{
                              await showDialog(
                                context: context,
                                builder: (_) => 
                                  AssetGiffyDialog(
                                  image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                  title: const Text('Error', textAlign: TextAlign.center, style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                                  entryAnimation: EntryAnimation.DEFAULT,
                                  description: Text('Error: $result',
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

                      const SizedBox(height: 40),

                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            const TextSpan(
                              text: 'Don\'t have an Account? ', 
                              style: const TextStyle(
                                fontSize: 16,
                                color: const Color(0xff000000),
                              ),
                            ),

                            TextSpan(
                              text: 'Sign Up', 
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xff4EC9D4),
                              ),
                              recognizer: TapGestureRecognizer()
                              ..onTap = (){
                                Navigator.pushNamed(context, '/regular/register');
                              }
                            ),

                          ],
                        ),
                      ),

                      const SizedBox(height: 10),

                      GestureDetector(
                        onTap: () async{
                          final sharedPrefs = await SharedPreferences.getInstance();
                          sharedPrefs.setBool('user-guest-session', true);
                          Navigator.pushReplacementNamed(context, '/home/regular');
                        },
                        child: const Text('Sign in as Guest',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xff4EC9D4),
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      RichText(
                        text: const TextSpan(
                          children: <TextSpan>[
                            const TextSpan(
                              text: 'Connect    /    ', 
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                                color: const Color(0xff888888),
                              ),
                            ),

                            const TextSpan(
                              text: 'Remember    /    ',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                                color: const Color(0xff888888),
                              ),
                            ),

                            const TextSpan(
                              text: 'Honor',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                                color: const Color(0xff888888),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),
                      
                    ],
                  ),
                ),
              ],
            ),
          )
        ),
      ),
    );
  }
}