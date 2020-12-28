import 'package:facesbyplaces/API/BLM/api-65-blm-sign-in-with-facebook.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-01-blm-input-field.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-02-blm-dialog.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-07-blm-button.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-08-blm-background.dart';
import 'package:facesbyplaces/API/BLM/api-64-blm-sign-in-with-google.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/API/BLM/api-01-blm-login.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

import 'blm-06-password-reset.dart';

// import 'blm-06-password-reset.dart';


class BLMLogin extends StatefulWidget{

  BLMLoginState createState() => BLMLoginState();
}

class BLMLoginState extends State<BLMLogin> with WidgetsBindingObserver{

  final GlobalKey<MiscBLMInputFieldTemplateState> _key1 = GlobalKey<MiscBLMInputFieldTemplateState>();
  final GlobalKey<MiscBLMInputFieldTemplateState> _key2 = GlobalKey<MiscBLMInputFieldTemplateState>();

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
      Navigator.push(context, PageRouteBuilder(pageBuilder: (__, _, ___) => BLMPasswordReset()));
    }
  }


  void initDeepLink(){
    buo = BranchUniversalObject(
      canonicalIdentifier: 'password-reset-blm-account',
      title: 'Password Reset for BLM Accounts',
      imageUrl: 'assets/icons/app-icon.png',
      contentDescription: 'Password reset request for BLM accounts',
      keywords: ['Password', 'Reset', 'BLM'],
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
    ResponsiveWidgets.init(context,
      height: SizeConfig.screenHeight,
      width: SizeConfig.screenWidth,
    );
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

              Container(height: SizeConfig.screenHeight, child: MiscBLMBackgroundTemplate(image: AssetImage('assets/icons/background2.png'),),),

              ContainerResponsive(
                height: SizeConfig.screenHeight,
                width: SizeConfig.screenWidth,
                alignment: Alignment.center,
                child: ContainerResponsive(
                  // padding: EdgeInsetsResponsive.only(left: 10.0, right: 10.0),
                  // width: SizeConfig.screenHeight,
                  width: SizeConfig.screenWidth,
                  heightResponsive: false,
                  widthResponsive: true,
                  alignment: Alignment.center,
                  child: Container(
                    padding: EdgeInsets.only(left: 20.0, right: 20.0),
                    height: SizeConfig.screenHeight,
                    child: SingleChildScrollView(
                      physics: ClampingScrollPhysics(),
                      child: Column(
                        children: [

                          SizedBox(height: SizeConfig.blockSizeVertical * 5,),

                          Align(alignment: Alignment.centerLeft, child: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back, color: Color(0xff000000), size: ScreenUtil().setHeight(30),),),),

                          SizedBox(height: SizeConfig.blockSizeVertical * 3,),

                          Container(padding: EdgeInsets.only(left: 20.0), alignment: Alignment.centerLeft, child: Text('Login', style: TextStyle(fontSize: ScreenUtil().setSp(26, allowFontScalingSelf: true), fontWeight: FontWeight.bold, color: Color(0xff000000),),),),

                          SizedBox(height: SizeConfig.blockSizeVertical * 3,),

                          Padding(
                            padding: EdgeInsets.only(left: 20.0, right: 20.0,),

                            child: Row(
                              children: [
                                Expanded(
                                  child: MiscBLMButtonSignInWithTemplate(
                                    buttonText: 'Facebook', 
                                    buttonColor: Color(0xff3A559F), 
                                    buttonTextStyle: TextStyle(
                                      // fontSize: SizeConfig.safeBlockHorizontal * 4,
                                      fontSize: ScreenUtil().setSp(14, allowFontScalingSelf: true),
                                      fontWeight: FontWeight.w300, 
                                      color: Color(0xffffffff),
                                    ), 
                                    onPressed: () async{
                                      final fb = FacebookLogin();



                                      // await fb.logOut();
                                      // print('heheheheh');


                                      bool isLoggedIn = await fb.isLoggedIn;

                                      print('The value of isLoggedIn is $isLoggedIn');

                                      if(isLoggedIn == true){
                                        context.showLoaderOverlay();

                                        FacebookUserProfile profile = await fb.getUserProfile();
                                        String email = await fb.getUserEmail();
                                        String image = await fb.getProfileImageUrl(width: 50, height: 50);
                                        FacebookAccessToken token = await fb.accessToken;

                                        print('The access token is ${token.token}');

                                        bool apiResult = await apiBLMSignInWithFacebook(
                                          firstName: profile.firstName.toString(), 
                                          lastName: profile.lastName.toString(), 
                                          email: email, 
                                          username: email,
                                          facebookId: token.token,
                                          image: image
                                        );
                                        context.hideLoaderOverlay();

                                        print('The value of result is $apiResult');

                                        if(apiResult == true){
                                          Navigator.pushReplacementNamed(context, '/home/blm');
                                        }else{
                                          await showDialog(context: context, builder: (build) => MiscBLMAlertDialog(title: 'Error', content: 'Invalid email or password. Please try again.'));
                                        }

                                      }else{
                                        // Log in
                                        final result = await fb.logIn(permissions: [
                                          FacebookPermission.publicProfile,
                                          FacebookPermission.email,
                                          FacebookPermission.userFriends,
                                        ]);

                                        print('The result status is ${result.status}');
                                        print('The result access token is ${result.accessToken.token}');
                                        print('The result error is ${result.error}');

                                        context.showLoaderOverlay();


                                        final email = await fb.getUserEmail();
                                        final profile = await fb.getUserProfile();
                                        final image = await fb.getProfileImageUrl(width: 50, height: 50);

                                        print('The email is $email');
                                        print('The firstName is ${profile.firstName}');
                                        print('The lastName is ${profile.lastName}');
                                        print('The image is $image');

                                        
                                        bool apiResult = await apiBLMSignInWithFacebook(
                                          firstName: profile.firstName.toString(), 
                                          lastName: profile.lastName.toString(), 
                                          email: email, 
                                          username: email,
                                          facebookId: result.accessToken.token,
                                          image: image,
                                        );
                                        context.hideLoaderOverlay();

                                        print('The apiResult is $apiResult');

                                        if(apiResult == false){
                                          await fb.logOut();
                                        }else{
                                          Navigator.pushReplacementNamed(context, '/home/blm');
                                        }
                                      }
                                    }, 
                                    width: SizeConfig.screenWidth / 1.5, 
                                    // height: SizeConfig.blockSizeVertical * 7,
                                    height: ScreenUtil().setHeight(45),
                                  ),
                                ),

                                SizedBox(width: SizeConfig.blockSizeHorizontal * 10,),

                                Expanded(
                                  child: MiscBLMButtonSignInWithTemplate(
                                    buttonText: 'Google', 
                                    buttonColor: Color(0xffF5F5F5), 
                                    buttonTextStyle: TextStyle(
                                      // fontSize: SizeConfig.safeBlockHorizontal * 4, 
                                      fontSize: ScreenUtil().setSp(14, allowFontScalingSelf: true),
                                      fontWeight: FontWeight.w300, 
                                      color: Color(0xff000000),
                                    ), 
                                    onPressed: () async{
                                      // GoogleSignIn googleSignIn = GoogleSignIn(
                                      //   scopes: [
                                      //     'profile',
                                      //     'email',
                                      //     'openid'
                                      //   ],
                                      // );

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
                                
                                      // context.showLoaderOverlay();
                                      // bool result = await apiBLMSignInWithGoogle(
                                      //   firstName: value.displayName, 
                                      //   lastName: value.displayName, 
                                      //   email: value.email, 
                                      //   username: value.email,
                                      //   googleId: auth.idToken,
                                      // );
                                      // context.hideLoaderOverlay();

                                      // print('The result is $result');

                                      // if(result){
                                      //   Navigator.pushReplacementNamed(context, '/home/blm');
                                      // }else{
                                      //   await showDialog(context: (context), builder: (build) => MiscBLMAlertDialog(title: 'Error', content: 'Something went wrong. Please try again.'));
                                      // }




                                    GoogleSignIn googleSignIn = GoogleSignIn(
                                        scopes: [
                                          'profile',
                                          'email',
                                          'openid'
                                        ],
                                      );

                                      // await googleSignIn.signOut();

                                      // print('google logout');

                                      bool isLoggedIn = await googleSignIn.isSignedIn();

                                      print('The value is $isLoggedIn');

                                      if(isLoggedIn == true){
                                        context.showLoaderOverlay();
                                        var accountSignedIn = await googleSignIn.signInSilently();
                                        var authHeaders = await googleSignIn.currentUser.authHeaders;
                                        var auth = await googleSignIn.currentUser.authentication;


                                        print('The auth is ${auth.accessToken}}');
                                        print('The auth is ${auth.idToken}');
                                        print('The auth is ${auth.serverAuthCode}');

                                        print('The auth headers is $authHeaders');

                                        print('The client id is ${googleSignIn.clientId}');


                                        print('The headers is $authHeaders');

                                        
                                        bool result = await apiBLMSignInWithGoogle(
                                          firstName: accountSignedIn.displayName, 
                                          // lastName: accountSignedIn.displayName,
                                          lastName: '', 
                                          email: accountSignedIn.email, 
                                          username: accountSignedIn.email,
                                          googleId: auth.idToken,
                                          image: accountSignedIn.photoUrl,
                                        );
                                        context.hideLoaderOverlay();

                                        print('The value of result is $result');
                                        print('The value is ${accountSignedIn.authHeaders}');

                                        if(result == true){
                                          Navigator.pushReplacementNamed(context, '/home/blm');
                                        }else{
                                          await showDialog(context: context, builder: (build) => MiscBLMAlertDialog(title: 'Error', content: 'Invalid email or password. Please try again.'));
                                        }

                                      }else{
                                        GoogleSignInAccount signIn = await googleSignIn.signIn();
                                        var authHeaders = await googleSignIn.currentUser.authHeaders;
                                        var auth = await googleSignIn.currentUser.authentication;

                                        print('The auth is ${auth.accessToken}}');
                                        print('The auth is ${auth.idToken}');
                                        print('The auth is ${auth.serverAuthCode}');

                                        print('The auth headers is $authHeaders');

                                        print('The client id is ${googleSignIn.clientId}');


                                        print('The headers is $authHeaders');

                                        context.showLoaderOverlay();
                                        

                                        bool result = await apiBLMSignInWithGoogle(
                                          firstName: signIn.displayName, 
                                          // lastName: signIn.displayName, 
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
                                          await showDialog(context: context, builder: (build) => MiscBLMAlertDialog(title: 'Error', content: 'Invalid email or password. Please try again.'));
                                        }
                                      }

                                    }, 
                                    width: SizeConfig.screenWidth / 1.5, 
                                    // height: SizeConfig.blockSizeVertical * 7,
                                    height: ScreenUtil().setHeight(45),
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
                            height: ScreenUtil().setHeight(45),
                          ),

                          SizedBox(height: SizeConfig.blockSizeVertical * 5,),

                          Center(child: Text('or log in with email', style: TextStyle(fontSize: ScreenUtil().setSp(14, allowFontScalingSelf: true), fontWeight: FontWeight.w300, color: Color(0xff000000),),),),

                          Padding(padding: EdgeInsets.only(left: 20.0, right: 20.0), child: MiscBLMInputFieldTemplate(key: _key1, labelText: 'Email Address', type: TextInputType.emailAddress,),),

                          SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                          Padding(padding: EdgeInsets.only(left: 20.0, right: 20.0), child: MiscBLMInputFieldTemplate(key: _key2, labelText: 'Password', type: TextInputType.text, obscureText: true,),),

                          // SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                          SizedBox(height: ScreenUtil().setHeight(20)),

                          GestureDetector(
                            onTap: () async{

                              // String email = await showDialog(context: (context), builder: (build) => MiscBLMAlertInputEmailDialog(title: 'Email', content: 'Invalid email or password. Please try again.'));

                              // DateTime date = DateTime.now();
                              // String id = date.toString().replaceAll('-', '').replaceAll(' ', '').replaceAll(':', '').replaceAll('.', '');
                              // FlutterBranchSdk.setIdentity('id-$id');
                              // context.showLoaderOverlay();

                              // bool result = await generateLink(email);
                              // context.hideLoaderOverlay();

                              // print('The result is $result');


                              String email = await showDialog(context: (context), builder: (build) => MiscBLMAlertInputEmailDialog(title: 'Email', content: 'Invalid email or password. Please try again.'));

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
                                  await showDialog(context: context, builder: (build) => MiscBLMAlertDialog(title: 'Success', content: response.result, color: Colors.green,));
                                } else {
                                  await showDialog(context: context, builder: (build) => MiscBLMAlertDialog(title: 'Error', content: 'Something went wrong. Please try again.'));
                                }

                              }


                            },
                            child: Align(
                              alignment: Alignment.centerRight, 
                              child: Text('Forgot Password?', 
                              style: TextStyle(
                                decoration: TextDecoration.underline, 
                                fontSize: ScreenUtil().setSp(14, allowFontScalingSelf: true),
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

                          // Expanded(child: Container(),),

                          SizedBox(height: ScreenUtil().setHeight(20)),

                          MiscBLMButtonTemplate(
                            buttonText: 'Login', 
                            buttonTextStyle: TextStyle(
                              // fontSize: SizeConfig.safeBlockHorizontal * 5,
                              fontSize: ScreenUtil().setSp(16, allowFontScalingSelf: true),
                              fontWeight: FontWeight.bold, 
                              color: Color(0xffffffff),
                            ), 
                            onPressed: () async{
                              bool validEmail = false;
                              validEmail = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(_key1.currentState.controller.text );

                              if(_key1.currentState.controller.text == '' || _key2.currentState.controller.text == ''){
                                await showDialog(context: (context), builder: (build) => MiscBLMAlertDialog(title: 'Error', content: 'Please complete the form before submitting.', confirmText: 'OK',),);
                              }else if(!validEmail){
                                await showDialog(context: (context), builder: (build) => MiscBLMAlertDialog(title: 'Error', content: 'Invalid email address. Please try again.', confirmText: 'OK',),);
                              }else{

                                context.showLoaderOverlay();
                                bool result = await apiBLMLogin(_key1.currentState.controller.text, _key2.currentState.controller.text);
                                context.hideLoaderOverlay();

                                if(result){
                                  Navigator.pushReplacementNamed(context, '/home/blm');
                                }else{
                                  await showDialog(context: (context), builder: (build) => MiscBLMAlertDialog(title: 'Error', content: 'Invalid email or password. Please try again.'));
                                }
                              }
                            }, 
                            width: SizeConfig.screenWidth / 2, 
                            // height: SizeConfig.blockSizeVertical * 7, 
                            height: ScreenUtil().setHeight(45),
                            buttonColor: Color(0xff4EC9D4),
                          ),

                          SizedBox(height: SizeConfig.blockSizeVertical * 5,),

                          RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'Don\'t have an Account? ', 
                                  style: TextStyle(
                                    // fontSize: SizeConfig.safeBlockHorizontal * 4,
                                    fontSize: ScreenUtil().setSp(16, allowFontScalingSelf: true),
                                    color: Color(0xff000000),
                                  ),
                                ),

                                TextSpan(
                                  text: 'Sign Up', 
                                  style: TextStyle(
                                    // fontSize: SizeConfig.safeBlockHorizontal * 4,
                                    fontSize: ScreenUtil().setSp(16, allowFontScalingSelf: true),
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

                          SizedBox(height: SizeConfig.blockSizeVertical * 1,),

                          GestureDetector(
                            onTap: (){
                              Navigator.pushReplacementNamed(context, '/home/blm');
                            },
                            child: Text('Sign in as Guest',
                              style: TextStyle(
                                // fontSize: SizeConfig.safeBlockHorizontal * 4,
                                fontSize: ScreenUtil().setSp(16, allowFontScalingSelf: true),
                                fontWeight: FontWeight.bold,
                                color: Color(0xff4EC9D4),
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),

                          SizedBox(height: SizeConfig.blockSizeVertical * 2,),
                          
                        ],
                      ),
                    ),
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