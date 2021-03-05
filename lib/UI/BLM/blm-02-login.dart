import 'dart:io';

import 'package:facesbyplaces/API/BLM/01-Start/api-start-blm-01-login.dart';
import 'package:facesbyplaces/API/BLM/01-Start/api-start-blm-05-sign-in-with-facebook.dart';
import 'package:facesbyplaces/API/BLM/01-Start/api-start-blm-06-sign-in-with-google.dart';
import 'package:facesbyplaces/API/BLM/01-Start/api-start-blm-07-sign-in-with-apple.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-01-blm-input-field.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-06-blm-button.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-07-blm-background.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import '../ui-01-get-started.dart';
import 'blm-06-password-reset-email.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';

class BLMLogin extends StatefulWidget{

  BLMLoginState createState() => BLMLoginState();
}

class BLMLoginState extends State<BLMLogin>{

  final GlobalKey<MiscBLMInputFieldTemplateState> _key1 = GlobalKey<MiscBLMInputFieldTemplateState>();
  final GlobalKey<MiscBLMInputFieldTemplateState> _key2 = GlobalKey<MiscBLMInputFieldTemplateState>();

  BranchUniversalObject buo;
  BranchLinkProperties lp;

  void initBranchReferences(){
    buo = BranchUniversalObject(
      canonicalIdentifier: 'FacesbyPlaces',
      title: 'FacesbyPlaces Link',
      imageUrl: 'https://i.picsum.photos/id/866/200/300.jpg?hmac=rcadCENKh4rD6MAp6V_ma-AyWv641M4iiOpe1RyFHeI',
      contentDescription: 'FacesbyPlaces link to the app',
      keywords: ['FacesbyPlaces', 'Link', 'App'],
      publiclyIndex: true,
      locallyIndex: true,
      contentMetadata: BranchContentMetaData()
        ..addCustomMetadata('custom_string', 'fbp-link')
        ..addCustomMetadata('reset-type', 'Blm')
    );

    lp = BranchLinkProperties(
        channel: 'facebook',
        feature: 'sharing',
        stage: 'new share',
      tags: ['one', 'two', 'three']
    );
    lp.addControlParam('url', 'https://4n5z1.test-app.link/qtdaGGTx3cb?bnc_validate=true');
  }

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

              SingleChildScrollView(physics: NeverScrollableScrollPhysics(), child: Container(height: SizeConfig.screenHeight, child: MiscBLMBackgroundTemplate(image: AssetImage('assets/icons/background2.png'),),),),

              Container(
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                height: SizeConfig.screenHeight,
                child: SingleChildScrollView(
                  physics: ClampingScrollPhysics(),
                  child: Column(
                    children: [

                      SizedBox(height: 40),

                      Align(alignment: Alignment.centerLeft, child: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back, color: Color(0xff000000), size: 30,),),),

                      SizedBox(height: 25),

                      Container(padding: EdgeInsets.only(left: 20.0), alignment: Alignment.centerLeft, child: Text('Login', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xff000000),),),),

                      SizedBox(height: 25),

                      Padding(
                        padding: EdgeInsets.only(left: 20.0, right: 20.0,),

                        child: Row(
                          children: [
                            Expanded(
                              child: MiscBLMButtonSignInWithTemplate(
                                buttonText: 'Facebook', 
                                buttonColor: Color(0xff3A559F), 
                                buttonTextStyle: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300, 
                                  color: Color(0xffffffff),
                                ), 
                                onPressed: () async{
                                  final fb = FacebookLogin();

                                  // await fb.logOut();
                                  // print('facebook logout'); // TO LOGOUT THE FACEBOOK ACCOUNT FOR TESTING

                                  bool isLoggedIn = await fb.isLoggedIn;

                                  if(isLoggedIn == true){
                                    context.showLoaderOverlay();

                                    FacebookUserProfile profile = await fb.getUserProfile();
                                    String email = await fb.getUserEmail();
                                    String image = await fb.getProfileImageUrl(width: 50, height: 50);
                                    FacebookAccessToken token = await fb.accessToken;

                                    bool apiResult = await apiBLMSignInWithFacebook(
                                      firstName: profile.firstName.toString(), 
                                      lastName: profile.lastName.toString(), 
                                      email: email, 
                                      username: email,
                                      facebookId: token.token,
                                      image: image
                                    );
                                    context.hideLoaderOverlay();

                                    if(apiResult == true){
                                      Navigator.pushReplacementNamed(context, '/home/blm');
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
                                            style: TextStyle(),
                                          ),
                                          onlyOkButton: true,
                                          buttonOkColor: Colors.red,
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

                                    final email = await fb.getUserEmail();
                                    final profile = await fb.getUserProfile();
                                    final image = await fb.getProfileImageUrl(width: 50, height: 50);

                                    if(result.status != FacebookLoginStatus.cancel){
                                      context.showLoaderOverlay();
                                      
                                      bool apiResult = await apiBLMSignInWithFacebook(
                                        firstName: profile.firstName.toString(), 
                                        lastName: profile.lastName.toString(), 
                                        email: email, 
                                        username: email,
                                        facebookId: result.accessToken.token,
                                        image: image,
                                      );
                                      context.hideLoaderOverlay();

                                      if(apiResult == false){
                                        await fb.logOut();
                                      }else{
                                        Navigator.pushReplacementNamed(context, '/home/blm');
                                      }
                                    }
                                  }
                                }, 
                                width: SizeConfig.screenWidth / 1.5, 
                                height: 45,
                              ),
                            ),

                            SizedBox(width: 50),

                            Expanded(
                              child: MiscBLMButtonSignInWithTemplate(
                                buttonText: 'Google', 
                                buttonColor: Color(0xffF5F5F5), 
                                buttonTextStyle: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300, 
                                  color: Color(0xff000000),
                                ), 
                                onPressed: () async{

                                GoogleSignIn googleSignIn = GoogleSignIn(
                                    scopes: [
                                      'profile',
                                      'email',
                                      'openid'
                                    ],
                                  );

                                  // await googleSignIn.signOut();
                                  // print('google logout'); // TO LOGOUT THE GOOGLE ACCOUNT FOR TESTING

                                  bool isLoggedIn = await googleSignIn.isSignedIn();

                                  if(isLoggedIn == true){
                                    context.showLoaderOverlay();
                                    var accountSignedIn = await googleSignIn.signInSilently();
                                    var auth = await googleSignIn.currentUser.authentication;
                                    
                                    bool result = await apiBLMSignInWithGoogle(
                                      firstName: accountSignedIn.displayName, 
                                      lastName: '', 
                                      email: accountSignedIn.email, 
                                      username: accountSignedIn.email,
                                      googleId: auth.idToken,
                                      image: accountSignedIn.photoUrl,
                                    );
                                    context.hideLoaderOverlay();

                                    if(result == true){
                                      Navigator.pushReplacementNamed(context, '/home/blm');
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
                                            style: TextStyle(),
                                          ),
                                          onlyOkButton: true,
                                          buttonOkColor: Colors.red,
                                          onOkButtonPressed: () {
                                            Navigator.pop(context, true);
                                          },
                                        )
                                      );
                                    }

                                  }else{
                                    GoogleSignInAccount signIn = await googleSignIn.signIn();
                                    var auth = await googleSignIn.currentUser.authentication;

                                    context.showLoaderOverlay();
                                    bool result = await apiBLMSignInWithGoogle(
                                      firstName: signIn.displayName, 
                                      lastName: '',
                                      email: signIn.email, 
                                      username: signIn.email,
                                      googleId: auth.idToken,
                                      image: signIn.photoUrl,
                                    );
                                    context.hideLoaderOverlay();

                                    if(result == true){
                                      Navigator.pushReplacementNamed(context, '/home/blm');
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
                                            style: TextStyle(),
                                          ),
                                          onlyOkButton: true,
                                          buttonOkColor: Colors.red,
                                          onOkButtonPressed: () {
                                            Navigator.pop(context, true);
                                          },
                                        )
                                      );
                                    }
                                  }

                                }, 
                                width: SizeConfig.screenWidth / 1.5, 
                                height: 45,
                                image: 'assets/icons/google.png',
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 40),

                      SignInWithAppleButton(
                        onPressed: () async {

                          final credential = await SignInWithApple.getAppleIDCredential(
                            scopes: [
                              AppleIDAuthorizationScopes.email,
                              AppleIDAuthorizationScopes.fullName,
                            ],
                          );

                          context.showLoaderOverlay();
                          bool result = await apiBLMSignInWithApple(userIdentification: credential.userIdentifier, identityToken: credential.identityToken);
                          context.hideLoaderOverlay();

                          if(result == true){
                            Navigator.pushReplacementNamed(context, '/home/blm');
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
                                  style: TextStyle(),
                                ),
                                onlyOkButton: true,
                                buttonOkColor: Colors.red,
                                onOkButtonPressed: () {
                                  Navigator.pop(context, true);
                                },
                              )
                            );
                          }

                        },
                        height: 45,
                      ),

                      SizedBox(height: 40),

                      Center(child: Text('or log in with email', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: Color(0xff000000),),),),

                      Padding(padding: EdgeInsets.only(left: 20.0, right: 20.0), child: MiscBLMInputFieldTemplate(key: _key1, labelText: 'Email Address', type: TextInputType.emailAddress,),),

                      SizedBox(height: 20),

                      Padding(padding: EdgeInsets.only(left: 20.0, right: 20.0), child: MiscBLMInputFieldTemplate(key: _key2, labelText: 'Password', type: TextInputType.text, obscureText: true,),),

                      SizedBox(height: 20),

                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => BLMPasswordResetEmail()));
                        },
                        child: Align(
                          alignment: Alignment.centerRight, 
                          child: Text('Forgot Password?', 
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 20),

                      MiscBLMButtonTemplate(
                        buttonText: 'Login', 
                        buttonTextStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold, 
                          color: Color(0xffffffff),
                        ), 
                        onPressed: () async{
                          bool validEmail = false;
                          validEmail = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(_key1.currentState.controller.text );

                          if(_key1.currentState.controller.text == '' || _key2.currentState.controller.text == ''){
                            await showDialog(
                              context: context,
                              builder: (_) => 
                                AssetGiffyDialog(
                                image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                title: Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                                entryAnimation: EntryAnimation.DEFAULT,
                                description: Text('Please complete the form before submitting.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(),
                                ),
                                onlyOkButton: true,
                                buttonOkColor: Colors.red,
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
                                title: Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                                entryAnimation: EntryAnimation.DEFAULT,
                                description: Text('Invalid email address. Please try again.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(),
                                ),
                                onlyOkButton: true,
                                buttonOkColor: Colors.red,
                                onOkButtonPressed: () {
                                  Navigator.pop(context, true);
                                },
                              )
                            );
                          }else{

                            context.showLoaderOverlay();

                            // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
                            // final pushNotificationService = PushNotificationService(_firebaseMessaging);
                            // pushNotificationService.initialise();
                            // String deviceToken = await pushNotificationService.fcm.getToken();

                            String deviceToken = '';

                            if(Platform.isIOS){
                              final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
                              final pushNotificationService = PushNotificationService(_firebaseMessaging);
                              pushNotificationService.initialise();
                              deviceToken = await pushNotificationService.fcm.getToken();
                            }
                            
                            bool result = await apiBLMLogin(email: _key1.currentState.controller.text, password: _key2.currentState.controller.text, deviceToken: deviceToken);
                            
                            context.hideLoaderOverlay();

                            if(result){
                              Navigator.pushReplacementNamed(context, '/home/blm');
                            }else{
                              await showDialog(
                                context: context,
                                builder: (_) => 
                                  AssetGiffyDialog(
                                  image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                  title: Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                                  entryAnimation: EntryAnimation.DEFAULT,
                                  description: Text('Invalid email, password or type of account. Please try again.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(),
                                  ),
                                  onlyOkButton: true,
                                  buttonOkColor: Colors.red,
                                  onOkButtonPressed: () {
                                    Navigator.pop(context, true);
                                  },
                                )
                              );
                            }
                          }
                        }, 
                        width: SizeConfig.screenWidth / 2, 
                        height: 45,
                        buttonColor: Color(0xff4EC9D4),
                      ),

                      SizedBox(height: 40),

                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Don\'t have an Account? ', 
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xff000000),
                              ),
                            ),

                            TextSpan(
                              text: 'Sign Up', 
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff4EC9D4),
                              ),
                              recognizer: TapGestureRecognizer()
                              ..onTap = (){
                                Navigator.pushNamed(context, '/blm/register');
                              }
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 10),

                      GestureDetector(
                        onTap: () async{
                          final sharedPrefs = await SharedPreferences.getInstance();
                          sharedPrefs.setBool('user-guest-session', true);
                          Navigator.pushReplacementNamed(context, '/home/blm');
                        },
                        child: Text('Sign in as Guest',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff4EC9D4),
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),

                      SizedBox(height: 20),
                      
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}