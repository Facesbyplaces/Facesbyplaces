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
                backgroundColor: Colors.black,
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
                            icon:  Icon(
                              Icons.arrow_back,
                              color:  Color(0xff000000),
                              size: SizeConfig.blockSizeVertical! * 3.65,
                            ),
                          ),
                        ),
                        SizedBox(height: SizeConfig.blockSizeVertical! * 3.65),
                        Container(
                          padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal! * 8.75),
                          alignment: Alignment.centerLeft,
                          child:  Text('Log In',
                            style:  TextStyle(
                              fontSize: SizeConfig.blockSizeVertical!*4.93,
                              fontFamily: 'NexaBold',
                              color:  Color(0xff2F353D),
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
                                                title:  Text('Error', textAlign: TextAlign.center, style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                                                entryAnimation: EntryAnimation.DEFAULT,
                                                description:  Text('Invalid email or password. Please try again.',
                                                  textAlign: TextAlign.center,
                                                  style:  TextStyle(
                                                      fontSize: SizeConfig.blockSizeVertical! * 2.87,
                                                      fontFamily: 'NexaRegular'
                                                  ),
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

                                    final email = (await fb.getUserEmail())!;
                                    final profile = (await fb.getUserProfile())!;
                                    final image = (await fb.getProfileImageUrl(width: 50, height: 50))!;
                                    FacebookAccessToken token = (await fb.accessToken)!;

                                    if(result.status != FacebookLoginStatus.cancel){
                                      context.loaderOverlay.show();
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
                                child: Center(
                                  child: Image.asset(
                                    'assets/icons/Facebook2.png',
                                  ),
                                ),
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
                                  User? user = await RegularGoogleAuthentication.signInWithGoogle(context: context);

                                  if (user != null) {
                                    Navigator.pushReplacementNamed(context, '/home/regular');
                                  }
                                },
                                child: Center(
                                  child: Image.asset(
                                    'assets/icons/google.png',
                                  ),
                                ),
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
                                              title: Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                                              entryAnimation: EntryAnimation.DEFAULT,
                                              description: Text('Invalid email or password. Please try again.',
                                                textAlign: TextAlign.center,
                                                style:  TextStyle(
                                                    fontSize: SizeConfig.blockSizeVertical! * 2.87,
                                                    fontFamily: 'NexaRegular'
                                                ),
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
                                child: Center(
                                  child: Image.asset(
                                    'assets/icons/apple.png',
                                  ),
                                ),
                              ),
                            ),
                            Spacer(),
                          ],
                        ),
                        SizedBox(height: SizeConfig.blockSizeVertical! * 5.11),
                        Center(
                          child:  Text('or log in with email',
                            style:  TextStyle(
                                fontSize: SizeConfig.blockSizeVertical! * 2.74,
                                color:  Color(0xff000000),
                                fontFamily: 'NexaRegular'
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal! * 8.75, right: SizeConfig.blockSizeHorizontal! * 8.75),
                          child: MiscRegularInputFieldTemplate(
                            key: _key1,
                            labelText: 'Email Address',
                            labelTextStyle: TextStyle(
                                fontSize: SizeConfig.blockSizeVertical! * 2.74,
                                color:  Color(0xff000000),
                                fontFamily: 'NexaRegular'
                            ),
                            type: TextInputType.emailAddress,
                          ),
                        ),
                        // SizedBox(height: SizeConfig.blockSizeVertical! * 2.29),
                        Padding(
                          padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal! * 8.75, right: SizeConfig.blockSizeHorizontal! * 8.75),
                          child: MiscRegularInputFieldTemplate(
                            key: _key2,
                            labelText: 'Password',
                            labelTextStyle: TextStyle(
                                fontSize: SizeConfig.blockSizeVertical! * 2.74,
                                color:  Color(0xff000000),
                                fontFamily: 'NexaRegular'
                            ),
                            type: TextInputType.text,
                            obscureText: true,
                          ),
                        ),
                        ///
                        ///
                        SizedBox(height: SizeConfig.blockSizeVertical! * 2.19),
                        Container(
                          padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal! * 8.75, right: SizeConfig.blockSizeHorizontal! * 8.75),
                          child: Row(
                            children: [
                              Spacer(),
                              GestureDetector(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => RegularPasswordResetEmail()));
                                },
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child:  Text('Forgot Password?',
                                    style:  TextStyle(
                                        decoration: TextDecoration.underline,
                                        color:  Color(0xff2F353D),
                                        fontSize: SizeConfig.blockSizeVertical! * 2.19,
                                        fontFamily: 'NexaRegular'
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        Spacer(),

                        MiscRegularButtonTemplate(
                          buttonText: 'Log In',
                          buttonTextStyle:  TextStyle(
                              fontSize: SizeConfig.blockSizeVertical! * 3.29,
                              color: const Color(0xffffffff),
                              fontFamily: 'NexaBold'
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
                                        title: Text('Error', textAlign: TextAlign.center, style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                                        entryAnimation: EntryAnimation.DEFAULT,
                                        description: Text('Please complete the form before submitting.',
                                          textAlign: TextAlign.center,
                                          style:  TextStyle(
                                              fontSize: SizeConfig.blockSizeVertical! * 2.87,
                                              fontFamily: 'NexaRegular'
                                          ),
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
                                        title: Text('Error', textAlign: TextAlign.center, style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                                        entryAnimation: EntryAnimation.DEFAULT,
                                        description: Text('Invalid email address. Please try again.',
                                          textAlign: TextAlign.center,
                                          style:  TextStyle(
                                              fontSize: SizeConfig.blockSizeVertical! * 2.87,
                                              fontFamily: 'NexaRegular'
                                          ),
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
                                          title:  Text('Error', textAlign: TextAlign.center, style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                                          entryAnimation: EntryAnimation.DEFAULT,
                                          description: Text('Error: $result',
                                            textAlign: TextAlign.center,
                                            style:  TextStyle(
                                                fontSize: SizeConfig.blockSizeVertical! * 2.87,
                                                fontFamily: 'NexaRegular'
                                            ),
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

                        SizedBox(height: SizeConfig.blockSizeVertical! * 3.29),

                        RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Don\'t have an Account? ',
                                style:  TextStyle(
                                    fontSize: SizeConfig.blockSizeVertical! * 2.74,
                                    color:  Color(0xff2F353D),
                                    fontFamily: 'NexaRegular'
                                ),
                              ),

                              TextSpan(
                                  text: 'Sign Up',
                                  style:  TextStyle(
                                      fontSize: SizeConfig.blockSizeVertical! * 2.74,
                                      color:  Color(0xff4EC9D4),
                                      fontFamily: 'NexaRegular'
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = (){
                                      Navigator.pushNamed(context, '/regular/register');
                                    }
                              ),

                            ],
                          ),
                        ),

                        SizedBox(height: SizeConfig.blockSizeVertical! * 2.00),

                        GestureDetector(
                          onTap: () async{
                            final sharedPrefs = await SharedPreferences.getInstance();
                            sharedPrefs.setBool('user-guest-session', true);
                            Navigator.pushReplacementNamed(context, '/home/regular');
                          },
                          child:  Text('Sign in as Guest',
                            style:  TextStyle(
                              fontSize: SizeConfig.blockSizeVertical! * 2.74,
                              fontFamily: 'NexaRegular',
                              color:  Color(0xff4EC9D4),
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),

                        SizedBox(height: SizeConfig.blockSizeVertical! * 2.00),

                        Container(
                          padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal! * 8.0, right: SizeConfig.blockSizeHorizontal! * 8.0),

                          child: RichText(
                            text:  TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'Connect  /  ',
                                  style:  TextStyle(
                                    fontSize: SizeConfig.blockSizeVertical! * 2.5,
                                    fontFamily: 'NexaRegular',
                                    color: const Color(0xffBDC3C7),
                                  ),
                                ),

                                TextSpan(
                                  text: 'Remember  /  ',
                                  style:  TextStyle(
                                    fontSize: SizeConfig.blockSizeVertical! * 2.5,
                                    fontFamily: 'NexaRegular',
                                    color: const Color(0xffBDC3C7),
                                  ),
                                ),

                                TextSpan(
                                  text: 'Honor',
                                  style:  TextStyle(
                                    fontSize: SizeConfig.blockSizeVertical! * 2.5,
                                    fontFamily: 'NexaRegular',
                                    color: const Color(0xffBDC3C7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: SizeConfig.blockSizeVertical! * 3.00),
                      ],
                    ),
                  ),
                )
            )
        ),
      ),
    );
  }
}