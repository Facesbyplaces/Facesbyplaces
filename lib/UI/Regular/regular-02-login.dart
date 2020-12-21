import 'package:facesbyplaces/API/Regular/api-71-regular-sign-in-with-facebook.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-06-regular-input-field.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-07-regular-button.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-08-regular-dialog.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-10-regular-background.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/API/Regular/api-01-regular-login.dart';
import 'package:facesbyplaces/UI/Regular/regular-06-password-reset.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';


class RegularLogin extends StatefulWidget{

  RegularLoginState createState() => RegularLoginState();
}

class RegularLoginState extends State<RegularLogin> with WidgetsBindingObserver{

  final GlobalKey<MiscRegularInputFieldTemplateState> _key1 = GlobalKey<MiscRegularInputFieldTemplateState>();
  final GlobalKey<MiscRegularInputFieldTemplateState> _key2 = GlobalKey<MiscRegularInputFieldTemplateState>();

  BranchUniversalObject buo;
  BranchLinkProperties lp;
  String link = '';

  void didChangeAppLifecycleState(AppLifecycleState state) async{
    if(state == AppLifecycleState.detached || state == AppLifecycleState.paused || state == AppLifecycleState.resumed || state == AppLifecycleState.inactive){
      initUnit();
    }
  }

  initUnit() async{
    bool login = await FlutterBranchSdk.isUserIdentified();

    print('The login is $login');

    if(login){
      Navigator.push(context, PageRouteBuilder(pageBuilder: (__, _, ___) => RegularPasswordReset()));
    }
  }


  void initDeepLink(){
    buo = BranchUniversalObject(
      canonicalIdentifier: 'password-reset-alm-account',
      title: 'Password Reset for ALM Accounts',
      imageUrl: 'assets/icons/app-icon.png',
      contentDescription: 'Password reset request for ALM accounts',
      keywords: ['Password', 'Reset', 'ALM'],
      publiclyIndex: true,
      locallyIndex: true,
      contentMetadata: BranchContentMetaData()..addCustomMetadata('custom_string', 'abc')
        ..addCustomMetadata('custom_number', 12345)
        ..addCustomMetadata('custom_bool', true)
        ..addCustomMetadata('custom_list_number', [1,2,3,4,5 ])
        ..addCustomMetadata('custom_list_string', ['a', 'b', 'c']),
    );

    lp = BranchLinkProperties(
        channel: 'email',
        feature: 'sharing',
        stage: 'new share',
      tags: ['one', 'two', 'three']
    );
    lp.addControlParam('url', 'https://29cft.test-app.link/suCwfzCi6bb');
  }


  void initState(){
    super.initState();
    initDeepLink();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
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
          body: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Stack(
              children: [

                Container(height: SizeConfig.screenHeight, child: MiscRegularBackgroundTemplate(image: AssetImage('assets/icons/background2.png'),),),

                Container(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0),
                  height: SizeConfig.screenHeight,
                  child: Column(
                    children: [

                      SizedBox(height: SizeConfig.blockSizeVertical * 5,),

                      Align(alignment: Alignment.centerLeft, child: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back, color: Color(0xff000000), size: SizeConfig.blockSizeVertical * 5),),),

                      SizedBox(height: SizeConfig.blockSizeVertical * 3,),

                      Container(padding: EdgeInsets.only(left: 20.0), alignment: Alignment.centerLeft, child: Text('Login', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 7, fontWeight: FontWeight.bold, color: Color(0xff000000),),),),

                      SizedBox(height: SizeConfig.blockSizeVertical * 3,),

                      Padding(
                        padding: EdgeInsets.only(left: 20.0, right: 20.0,),
                        child: Row(
                          children: [
                            Expanded(
                              child: MiscRegularButtonSignInWithTemplate(
                                buttonText: 'Facebook', 
                                buttonColor: Color(0xff3A559F), 
                                buttonTextStyle: TextStyle(
                                  fontSize: SizeConfig.safeBlockHorizontal * 4, 
                                  fontWeight: FontWeight.w300, 
                                  color: Color(0xffffffff),
                                ), 
                                onPressed: () async{

                                  final fb = FacebookLogin();

                                  // await fb.logOut();

                                  print('The value is ${fb.hashCode}');
                                  print('The value is ${fb.accessToken}');
                                  print('The value is ${fb.debug}');

                                  // Log in
                                  final result = await fb.logIn(permissions: [
                                    FacebookPermission.publicProfile,
                                    FacebookPermission.email,
                                    FacebookPermission.userFriends,
                                  ]);

                                  print('The result status is ${result.status}');
                                  print('The result access token is ${result.accessToken.token}');
                                  print('The result error is ${result.error}');


                                  final email = await fb.getUserEmail();
                                  final profile = await fb.getUserProfile();
                                  final image = await fb.getProfileImageUrl(width: 50, height: 50);

                                  print('The email is $email');
                                  print('The firstName is ${profile.firstName}');
                                  print('The lastName is ${profile.lastName}');
                                  print('The image is $image');

                                  context.showLoaderOverlay();
                                  bool apiResult = await apiRegularSignInWithFacebook(
                                    firstName: profile.firstName.toString(), 
                                    lastName: profile.lastName.toString(), 
                                    email: email, 
                                    username: email,
                                    facebookId: result.accessToken.token,
                                  );
                                  context.hideLoaderOverlay();

                                  print('The apiResult is $apiResult');



                                  // final result = await fb.logIn()

                                  // context.showLoaderOverlay();
                                  // bool result = await apiRegularSignInWithGoogle(
                                  //   firstName: value.displayName, 
                                  //   lastName: value.displayName, 
                                  //   email: value.email, 
                                  //   username: value.email,
                                  //   googleId: auth.idToken,
                                  // );
                                  // context.hideLoaderOverlay();


                                }, 
                                width: SizeConfig.screenWidth / 1.5, 
                                height: SizeConfig.blockSizeVertical * 7,
                              ),
                            ),

                            SizedBox(width: SizeConfig.blockSizeHorizontal * 10,),

                            Expanded(
                              child: MiscRegularButtonSignInWithTemplate(
                                buttonText: 'Google', 
                                buttonColor: Color(0xffF5F5F5), 
                                buttonTextStyle: TextStyle(
                                  fontSize: SizeConfig.safeBlockHorizontal * 4, 
                                  fontWeight: FontWeight.w300, 
                                  color: Color(0xff000000),
                                ), 
                                onPressed: () async {
                                  GoogleSignIn googleSignIn = GoogleSignIn(
                                    scopes: [
                                      'profile',
                                      'email',
                                      'openid'
                                    ],
                                  );

                                  

                                  bool isSignedIn = await googleSignIn.isSignedIn();

                                  print('The value is $isSignedIn');
                                  

                                  if(isSignedIn == true){

                                    // context.showLoaderOverlay();
                                    // bool result = await apiRegularLogin(_key1.currentState.controller.text, _key2.currentState.controller.text);
                                    // context.hideLoaderOverlay();

                                    // var accountSignedIn = await googleSignIn.signInSilently();
                                    // var authHeaders = await googleSignIn.currentUser.authHeaders;
                                    // var auth = await googleSignIn.currentUser.authentication;


                                    // print('The auth is ${auth.accessToken}}');
                                    // print('The auth is ${auth.idToken}');
                                    // print('The auth is ${auth.serverAuthCode}');

                                    // print('The auth headers is $authHeaders');

                                    // print('The client id is ${googleSignIn.clientId}');


                                    // print('The headers is $authHeaders');

                                    // context.showLoaderOverlay();
                                    // bool result = await apiRegularSignInWithGoogle(
                                    //   firstName: accountSignedIn.displayName, 
                                    //   lastName: accountSignedIn.displayName, 
                                    //   email: accountSignedIn.email, 
                                    //   username: accountSignedIn.email,
                                    //   googleId: auth.idToken,
                                    // );
                                    // context.hideLoaderOverlay();

                                    // print('The value of result is $result');
                                    // print('The value is ${accountSignedIn.authHeaders}');

                                  }

                                  // var value = await googleSignIn.signIn();
                                  // var value = await googleSignIn.signIn();

                                  // print('The value is ${value.email}');
                                  // print('The value is ${value.displayName}');
                                  // print('The value is ${value.id}');
                                  // print('The value is ${value.photoUrl}');

                                  // var header = await value.authHeaders;
                                  // var auth = await value.authentication;

                                  // print('The header is $header');
                                  // print('The auth is $auth');
                                  // print('The auth is ${auth.idToken}');
                                  // print('The server auth is ${auth.serverAuthCode}');
                                  // print('The access token is ${auth.accessToken}');
                            
                                  // context.showLoaderOverlay();
                                  // bool result = await apiRegularSignInWithGoogle(
                                  //   firstName: value.displayName, 
                                  //   lastName: value.displayName, 
                                  //   email: value.email, 
                                  //   username: value.email,
                                  //   googleId: auth.idToken,
                                  // );
                                  // context.hideLoaderOverlay();

                                  // // print('The result is $result');

                                  // if(result){
                                  //   Navigator.pushReplacementNamed(context, '/home/regular');
                                  // }else{
                                  //   await showDialog(context: context, builder: (build) => MiscRegularAlertDialog(title: 'Error', content: 'Something went wrong. Please try again.'));
                                  // }
                                  
                                }, 
                                width: SizeConfig.screenWidth / 1.5, 
                                height: SizeConfig.blockSizeVertical * 7, 
                                image: 'assets/icons/google.png',
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: SizeConfig.blockSizeVertical * 5,),

                      SignInWithAppleButton(
                        onPressed: () async {
                          final credential = await SignInWithApple.getAppleIDCredential(
                            scopes: [
                              AppleIDAuthorizationScopes.email,
                              AppleIDAuthorizationScopes.fullName,
                            ],
                          );

                          print(credential);

                          // Now send the credential (especially `credential.authorizationCode`) to your server to create a session
                          // after they have been validated with Apple (see `Integration` section for more information on how to do this)
                        },
                      ),

                      SizedBox(height: SizeConfig.blockSizeVertical * 5,),

                      Center(child: Text('or log in with email', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, fontWeight: FontWeight.w300, color: Color(0xff000000),),),),

                      Padding(padding: EdgeInsets.only(left: 20.0, right: 20.0), child: MiscRegularInputFieldTemplate(key: _key1, labelText: 'Email Address', type: TextInputType.emailAddress,),),

                      SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                      Padding(padding: EdgeInsets.only(left: 20.0, right: 20.0), child: MiscRegularInputFieldTemplate(key: _key2, labelText: 'Password', type: TextInputType.text, obscureText: true,),),

                      SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                      GestureDetector(
                        onTap: () async{

                          String email = await showDialog(context: (context), builder: (build) => MiscRegularAlertInputEmailDialog(title: 'Email', content: 'Invalid email or password. Please try again.'));

                          print('The value of email is $email');

                          if(email != null){
                            DateTime date = DateTime.now();
                            String id = date.toString().replaceAll('-', '').replaceAll(' ', '').replaceAll(':', '').replaceAll('.', '');
                            print('The id is $id');
                            FlutterBranchSdk.setIdentity('id-$id');

                            context.showLoaderOverlay();
                            BranchResponse response = await FlutterBranchSdk.getShortUrl(buo: buo, linkProperties: lp);
                            context.hideLoaderOverlay();

                            if (response.success) {
                              print('Link generated: ${response.result}');
                              setState(() {
                                link = response.result;
                              });
                              await showDialog(context: context, builder: (build) => MiscRegularAlertDialog(title: 'Success', content: response.result, color: Colors.green,));
                            } else {
                              await showDialog(context: context, builder: (build) => MiscRegularAlertDialog(title: 'Error', content: 'Something went wrong. Please try again.'));
                            }

                          }

                        },
                        child: Align(
                          alignment: Alignment.centerRight, 
                          child: Text('Forgot Password?', 
                            style: TextStyle(
                              decoration: TextDecoration.underline, 
                              fontSize: SizeConfig.safeBlockHorizontal * 3.5, 
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),

                      // Expanded(
                      //   child: Container(
                      //     child: IconButton(
                      //       icon: Icon(Icons.copy),
                      //       onPressed: (){
                      //         FlutterClipboard.copy(link).then(( value ) => print('copied'));
                      //       },
                      //     ),
                      //   ),
                      // ),

                      Expanded(child: Container(),),

                      MiscRegularButtonTemplate(
                        buttonText: 'Login', 
                        buttonTextStyle: TextStyle(
                          fontSize: SizeConfig.safeBlockHorizontal * 5, 
                          fontWeight: FontWeight.bold, 
                          color: Color(0xffffffff),
                        ), 
                        onPressed: () async{
                          
                          bool validEmail = false;
                          validEmail = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(_key1.currentState.controller.text );

                          if(_key1.currentState.controller.text == '' || _key2.currentState.controller.text == ''){
                            await showDialog(context: context, builder: (build) => MiscRegularAlertDialog(title: 'Error', content: 'Please complete the form before submitting.', confirmText: 'OK',),);
                          }else if(!validEmail){
                            await showDialog(context: context, builder: (build) => MiscRegularAlertDialog(title: 'Error', content: 'Invalid email address. Please try again.', confirmText: 'OK',),);
                          }else{

                            context.showLoaderOverlay();
                            bool result = await apiRegularLogin(_key1.currentState.controller.text, _key2.currentState.controller.text);
                            context.hideLoaderOverlay();

                            if(result){
                              Navigator.pushReplacementNamed(context, '/home/regular');
                            }else{
                              await showDialog(context: context, builder: (build) => MiscRegularAlertDialog(title: 'Error', content: 'Invalid email or password. Please try again.'));
                            }
                          }
                          
                        }, 
                        width: SizeConfig.screenWidth / 2, 
                        height: SizeConfig.blockSizeVertical * 7, 
                        buttonColor: Color(0xff4EC9D4),
                      ),

                      SizedBox(height: SizeConfig.blockSizeVertical * 5,),

                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Don\'t have an Account? ', 
                              style: TextStyle(
                                fontSize: SizeConfig.safeBlockHorizontal * 4,
                                color: Color(0xff000000),
                              ),
                            ),

                            TextSpan(
                              text: 'Sign Up', 
                              style: TextStyle(
                                fontSize: SizeConfig.safeBlockHorizontal * 4,
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

                      SizedBox(height: SizeConfig.blockSizeVertical * 1,),

                      GestureDetector(
                        onTap: (){
                          Navigator.pushReplacementNamed(context, '/home/regular');
                        },
                        child: Text('Sign in as Guest',
                          style: TextStyle(
                            fontSize: SizeConfig.safeBlockHorizontal * 4,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff4EC9D4),
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),

                      SizedBox(height: SizeConfig.blockSizeVertical * 1,),

                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Connect    /    ', 
                              style: TextStyle(
                                fontSize: SizeConfig.safeBlockHorizontal * 4,
                                fontWeight: FontWeight.w300,
                                color: Color(0xff888888),
                              ),
                            ),

                            TextSpan(
                              text: 'Remember    /    ',
                              style: TextStyle(
                                fontSize: SizeConfig.safeBlockHorizontal * 4,
                                fontWeight: FontWeight.w300,
                                color: Color(0xff888888),
                              ),
                            ),

                            TextSpan(
                              text: 'Honor',
                              style: TextStyle(
                                fontSize: SizeConfig.safeBlockHorizontal * 4,
                                fontWeight: FontWeight.w300,
                                color: Color(0xff888888),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: SizeConfig.blockSizeVertical * 2,),
                      
                    ],
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}