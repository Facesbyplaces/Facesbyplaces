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

              SingleChildScrollView(physics: NeverScrollableScrollPhysics(), child: Container(height: SizeConfig.screenHeight, child: MiscRegularBackgroundTemplate(image: AssetImage('assets/icons/background2.png'),),),),

              Container(
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                height: SizeConfig.screenHeight,
                child: SingleChildScrollView(
                  physics: ClampingScrollPhysics(),
                    child: Column(
                    
                    children: [

                      SizedBox(height: 40),

                      Align(
                        alignment: Alignment.centerLeft, 
                        child: IconButton(
                          onPressed: (){
                            Navigator.pop(context);
                          }, 
                          icon: Icon(
                            Icons.arrow_back, 
                            color: Color(0xff000000), 
                            size: 30,
                          ),
                        ),
                      ),

                      SizedBox(height: 25),

                      Container(
                        padding: EdgeInsets.only(left: 20.0), 
                        alignment: Alignment.centerLeft, 
                        child: Text(
                          'Login', 
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold, 
                            color: Color(0xff000000),
                          ),
                        ),
                      ),

                      SizedBox(height: 25),

                      Padding(
                        padding: EdgeInsets.only(left: 20.0, right: 20.0,),
                        child: Row(
                          children: [
                            Expanded(
                              child: MiscRegularButtonSignInWithTemplate(
                                buttonText: 'Facebook', 
                                buttonColor: Color(0xff3A559F), 
                                buttonTextStyle: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300, 
                                  color: Color(0xffffffff),
                                ),
                                width: SizeConfig.screenWidth! / 1.5, 
                                height: 45,
                                onPressed: () async{

                                  final fb = FacebookLogin(debug: true);

                                  // await fb.logOut();
                                  // print('facebook logout'); // TO LOGOUT THE FACEBOOK ACCOUNT FOR TESTING

                                  bool isLoggedIn = await fb.isLoggedIn;

                                  print('The value of isLoggedIn in facebook is $isLoggedIn');

                                  if(isLoggedIn == true){
                                    context.showLoaderOverlay();

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
                                    context.hideLoaderOverlay();

                                    if(apiResult == true){
                                      Navigator.pushReplacementNamed(context, '/home/regular');
                                    }else{
                                      // await showOkAlertDialog(
                                      //   context: context,
                                      //   title: 'Error',
                                      //   message: 'Invalid email or password. Please try again.',
                                      // );
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

                                    final email = (await fb.getUserEmail())!;
                                    final profile = (await fb.getUserProfile())!;
                                    final image = (await fb.getProfileImageUrl(width: 50, height: 50))!;

                                    if(result.status != FacebookLoginStatus.cancel){
                                      context.showLoaderOverlay();
                                      
                                      bool apiResult = await apiRegularSignInWithFacebook(
                                        firstName: '${profile.name}',
                                        lastName: '',
                                        email: email, 
                                        username: email,
                                        facebookId: result.accessToken!.token,
                                        image: image,
                                      );
                                      context.hideLoaderOverlay();

                                      if(apiResult == false){
                                        await fb.logOut();
                                      }else{
                                        Navigator.pushReplacementNamed(context, '/home/regular');
                                      }
                                    }
                                  }

                                }, 
                              ),
                            ),

                            SizedBox(width: 50),

                            Expanded(
                              child: MiscRegularButtonSignInWithTemplate(
                                buttonText: 'Google', 
                                buttonColor: Color(0xffF5F5F5),
                                buttonTextStyle: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300, 
                                  color: Color(0xff000000),
                                ),
                                width: SizeConfig.screenWidth! / 1.5, 
                                height: 45,
                                image: 'assets/icons/google.png',
                                onPressed: () async {

                                  User? user = await RegularGoogleAuthentication.signInWithGoogle(context: context);

                                  if (user != null) {
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


                                  // ==========================================================================


                                  // GoogleSignIn googleSignIn = GoogleSignIn(
                                  //   scopes: [
                                  //     'profile',
                                  //     'email',
                                  //     'openid'
                                  //   ],
                                  // );

                                  // // await googleSignIn.signOut();
                                  // // print('google logout'); // TO LOGOUT THE GOOGLE ACCOUNT FOR TESTING

                                  // bool isLoggedIn = await googleSignIn.isSignedIn();

                                  // print('The value of isLoggedIn is $isLoggedIn');

                                  // if(isLoggedIn == true){
                                  //   context.showLoaderOverlay();
                                  //   GoogleSignInAccount? accountSignedIn = await googleSignIn.signInSilently();
                                  //   GoogleSignInAuthentication? auth = await googleSignIn.currentUser!.authentication;

                                  //   print('Start here');

                                  //   FirebaseAuth authorization = FirebaseAuth.instance;
                                  //   // String newResult = authorization.currentUser!.refreshToken;
                                  //   print('The refresh token is ${authorization.currentUser!.refreshToken}');
                                  //   print('The refresh token length is ${authorization.currentUser!.refreshToken!.length}');
                                  //   print('The display name is ${authorization.currentUser!.displayName}');

                                  //   // print('The current user is $newResult');
                                  //   // print('The current user length is ${newResult.length}');

                                  //   print('The accountSignIn xzcvoiuasdfoiu is ${accountSignedIn!.displayName}');
                                  //   print('The accountSignIn is ${accountSignedIn.email}');
                                  //   print('The accountSignIn is ${accountSignedIn.id}');
                                  //   print('The accountSignIn is ${accountSignedIn.photoUrl}');

                                  //   var value1 = await accountSignedIn.authHeaders;
                                  //   var value2 = await accountSignedIn.authentication;

                                  //   print('The value1 is $value1');
                                  //   print('The value2 is ${value2.accessToken}');
                                  //   print('The value2 is ${value2.idToken}');
                                  //   print('The length of id token is ${value2.idToken!.length}');
                                  //   print('The value2 is ${value2.serverAuthCode}');

                                  //   print('The auth is ${auth.accessToken}');
                                  //   print('The auth is ${auth.idToken}');
                                  //   print('The auth is ${auth.serverAuthCode}');
                                    
                                  //   bool result = await apiRegularSignInWithGoogle(
                                  //     firstName: accountSignedIn.displayName!, 
                                  //     lastName: '', 
                                  //     email: accountSignedIn.email, 
                                  //     username: accountSignedIn.email,
                                  //     googleId: auth.idToken!,
                                  //     // googleId: value2.idToken!,
                                  //     image: accountSignedIn.photoUrl!,
                                  //   );
                                  //   context.hideLoaderOverlay();

                                  //   if(result == true){
                                  //     Navigator.pushReplacementNamed(context, '/home/regular');
                                  //   }else{
                                  //     await showDialog(
                                  //       context: context,
                                  //       builder: (_) => 
                                  //         AssetGiffyDialog(
                                  //         image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                  //         title: Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                                  //         entryAnimation: EntryAnimation.DEFAULT,
                                  //         description: Text('Invalid email or password. Please try again.',
                                  //           textAlign: TextAlign.center,
                                  //           style: TextStyle(),
                                  //         ),
                                  //         onlyOkButton: true,
                                  //         buttonOkColor: Colors.red,
                                  //         onOkButtonPressed: () {
                                  //           Navigator.pop(context, true);
                                  //         },
                                  //       )
                                  //     );
                                  //   }
                                  // }else{
                                  //   GoogleSignInAccount? accountSignedIn = await googleSignIn.signIn();
                                  //   GoogleSignInAuthentication? auth = await googleSignIn.currentUser!.authentication;

                                  //   print('Start here');

                                  //   FirebaseAuth authorization = FirebaseAuth.instance;
                                  //   print('The refresh token is ${authorization.currentUser!.refreshToken}');
                                  //   print('The refresh token length is ${authorization.currentUser!.refreshToken!.length}');
                                  //   print('The display name is ${authorization.currentUser!.displayName}');

                                  //   // String newResult = await authorization.currentUser!.getIdToken();

                                  //   // print('The current user is $newResult');
                                  //   // print('The current user length is ${newResult.length}');

                                  //   print('The accountSignIn sample is ${accountSignedIn!.displayName}');
                                  //   print('The accountSignIn is ${accountSignedIn.email}');
                                  //   print('The accountSignIn is ${accountSignedIn.id}');
                                  //   print('The accountSignIn is ${accountSignedIn.photoUrl}');
                                  //   // print('The accountSignIn is ${accountSignedIn.authHeaders}');
                                  //   // print('The accountSignIn is ${accountSignedIn.authentication}');

                                  //   var value1 = await accountSignedIn.authHeaders;
                                  //   var value2 = await accountSignedIn.authentication;

                                  //   print('The value1 is $value1');
                                  //   print('The value2 is ${value2.accessToken}');
                                  //   print('The value2 is ${value2.idToken}');
                                  //   print('The length of id token is ${value2.idToken!.length}');
                                  //   print('The value2 is ${value2.serverAuthCode}');

                                  //   print('The auth is ${auth.accessToken}');
                                  //   print('The auth is ${auth.idToken}');
                                  //   print('The auth is ${auth.serverAuthCode}');

                                  //   context.showLoaderOverlay();
                                  //   bool result = await apiRegularSignInWithGoogle(
                                  //     firstName: accountSignedIn.displayName!, 
                                  //     lastName: '',
                                  //     email: accountSignedIn.email, 
                                  //     username: accountSignedIn.email,
                                  //     googleId: auth.idToken!,
                                  //     // googleId: value2.idToken!,
                                  //     image: accountSignedIn.photoUrl!,
                                  //   );
                                  //   context.hideLoaderOverlay();

                                  //   if(result == true){
                                  //     Navigator.pushReplacementNamed(context, '/home/regular');
                                  //   }else{
                                  //     await showDialog(
                                  //       context: context,
                                  //       builder: (_) => 
                                  //         AssetGiffyDialog(
                                  //         image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                  //         title: Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                                  //         entryAnimation: EntryAnimation.DEFAULT,
                                  //         description: Text('Invalid email or password. Please try again.',
                                  //           textAlign: TextAlign.center,
                                  //           style: TextStyle(),
                                  //         ),
                                  //         onlyOkButton: true,
                                  //         buttonOkColor: Colors.red,
                                  //         onOkButtonPressed: () {
                                  //           Navigator.pop(context, true);
                                  //         },
                                  //       )
                                  //     );
                                  //   }
                                  // }
                                  
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 40),

                      SignInWithAppleButton(
                        onPressed: () async {
                          AuthorizationCredentialAppleID credential = await SignInWithApple.getAppleIDCredential(
                            scopes: [
                              AppleIDAuthorizationScopes.email,
                              AppleIDAuthorizationScopes.fullName,
                            ],
                          );

                          context.showLoaderOverlay();
                          bool result = await apiRegularSignInWithApple(userIdentification: credential.userIdentifier!, identityToken: credential.identityToken!);
                          context.hideLoaderOverlay();

                          if(result == true){
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
                      ),

                      SizedBox(height: 40),

                      Center(
                        child: Text('or log in with email', 
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w300, 
                            color: Color(0xff000000),
                          ),
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.only(left: 20.0, right: 20.0), 
                        child: MiscRegularInputFieldTemplate(
                          key: _key1, 
                          labelText: 'Email Address', 
                          type: TextInputType.emailAddress,
                        ),
                      ),

                      SizedBox(height: 20),

                      Padding(
                        padding: EdgeInsets.only(left: 20.0, right: 20.0), 
                        child: MiscRegularInputFieldTemplate(
                          key: _key2, 
                          labelText: 'Password', 
                          type: TextInputType.text, 
                          obscureText: true,
                        ),
                      ),

                      SizedBox(height: 20),

                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => RegularPasswordResetEmail()));
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

                      MiscRegularButtonTemplate(
                        buttonText: 'Login', 
                        buttonTextStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold, 
                          color: Color(0xffffffff),
                        ),
                        width: SizeConfig.screenWidth! / 2, 
                        height: 45,
                        buttonColor: Color(0xff4EC9D4),
                        onPressed: () async{
                          
                          bool validEmail = false;
                          validEmail = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(_key1.currentState!.controller.text );

                          if(_key1.currentState!.controller.text == '' || _key2.currentState!.controller.text == ''){
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

                            String deviceToken = '';
                            final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
                            final pushNotificationService = PushNotificationService(_firebaseMessaging);
                            pushNotificationService.initialise();
                            deviceToken = (await pushNotificationService.fcm.getToken())!;

                            print('The device token is $deviceToken');
                            
                            bool result = await apiRegularLogin(email: _key1.currentState!.controller.text, password: _key2.currentState!.controller.text, deviceToken: deviceToken);
                            
                            context.hideLoaderOverlay();

                            if(result){
                              Navigator.pushReplacementNamed(context, '/home/regular');
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
                                Navigator.pushNamed(context, '/regular/register');
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
                          Navigator.pushReplacementNamed(context, '/home/regular');
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

                      SizedBox(height: 10),

                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Connect    /    ', 
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                                color: Color(0xff888888),
                              ),
                            ),

                            TextSpan(
                              text: 'Remember    /    ',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                                color: Color(0xff888888),
                              ),
                            ),

                            TextSpan(
                              text: 'Honor',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                                color: Color(0xff888888),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 20),
                      
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
      ),
    );
  }
}