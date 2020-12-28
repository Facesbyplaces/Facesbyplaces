


import 'package:facesbyplaces/API/Regular/api-70-regular-sign-in-google.dart';
import 'package:facesbyplaces/API/Regular/api-71-regular-sign-in-with-facebook.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-06-regular-input-field.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-07-regular-button.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-08-regular-dialog.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-10-regular-background.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/API/Regular/api-01-regular-login.dart';
// import 'package:facesbyplaces/UI/Regular/regular-06-password-reset.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class RegularLogin extends StatefulWidget{

  RegularLoginState createState() => RegularLoginState();
}

//  with WidgetsBindingObserver

class RegularLoginState extends State<RegularLogin>{

  final GlobalKey<MiscRegularInputFieldTemplateState> _key1 = GlobalKey<MiscRegularInputFieldTemplateState>();
  final GlobalKey<MiscRegularInputFieldTemplateState> _key2 = GlobalKey<MiscRegularInputFieldTemplateState>();

  // BranchUniversalObject buo;
  // BranchLinkProperties lp;
  // BranchContentMetaData metadata;

  // String token = '';
  // String requestResult = '';
  // DateTime idDate = DateTime.now();
  // DateTime date = DateTime.now();
  // StreamSubscription<Map> streamSubscription;

  // void didChangeAppLifecycleState(AppLifecycleState state) async{
  //   if(state == AppLifecycleState.resumed){
  //     // initUnit();
  //     listenDeepLinkData();
  //   }
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   String id = date.toString().replaceAll('-', '').replaceAll(' ', '').replaceAll(':', '').replaceAll('.', '') + 'id-alm-password-reset';
  //   FlutterBranchSdk.setIdentity('$id');
  //   initDeepLinkData();
  //   // initUnit();
  //   listenDeepLinkData();
  //   WidgetsBinding.instance.addObserver(this);
  // }

  // @override
  // void dispose() {
  //   streamSubscription.cancel();
  //   WidgetsBinding.instance.removeObserver(this);
  //   super.dispose();
  // }

  // // initUnit() async{
  // //   bool login = await FlutterBranchSdk.isUserIdentified();

  // //   if(login){
  // //     var value = await FlutterBranchSdk.getLatestReferringParams();

  // //     setState(() {
  // //       requestResult = '';
  // //     });

  // //     print('The value of value is $value');

  // //     // if(value['reset_password_token'] == null){
  // //     //   await showDialog(context: (context), builder: (build) => MiscRegularAlertDialog(title: 'Error', content: 'Something went wrong. Please try again.',));
  // //     // }else{
  // //     //   Navigator.push(context, PageRouteBuilder(pageBuilder: (__, _, ___) => RegularPasswordReset()));
  // //     // }
  // //   }
  // // }


  // void listenDeepLinkData() async {
  //   bool login = await FlutterBranchSdk.isUserIdentified();
  //   // var first = await FlutterBranchSdk.getFirstReferringParams();

  //   if(login == true){

  //     var value = await FlutterBranchSdk.getLatestReferringParams();

  //     setState(() {
  //       token = value['token'];
  //       requestResult = '';
  //     });

  //     print('The login is $login');
  //     print('The map value of value is $value');
  //     print('The value of token is ${value['token']}');
  //     print('The token is $token');

  //     streamSubscription = FlutterBranchSdk.initSession().listen((data) {
  //       if (data.containsKey("+clicked_branch_link") && data["+clicked_branch_link"] == true && data['custom_id'] == 'password-reset-alm-account') {
  //         print('Custom string: ${data['custom_id']}');
  //         // Navigator.push(context, PageRouteBuilder(pageBuilder: (__, _, ___) => RegularPasswordReset()));
  //       }
  //     }, onError: (error) {
  //       PlatformException platformException = error as PlatformException;
  //       print(
  //           'InitSession error: ${platformException.code} - ${platformException.message}');
  //     });

  //     print('The streamSubscription is $streamSubscription');
  //   }
  // }


  // void initDeepLinkData() {
  //   metadata = BranchContentMetaData()
  //     .addCustomMetadata('custom_string', 'abc')
  //     .addCustomMetadata('custom_number', 12345)
  //     .addCustomMetadata('custom_bool', true)
  //     .addCustomMetadata('custom_list_number', [1, 2, 3, 4, 5,],)
  //     .addCustomMetadata('custom_list_string', ['a', 'b', 'c']);

  //   buo = BranchUniversalObject(
  //     canonicalIdentifier: 'reset-password-${idDate.toString().replaceAll('-', '').replaceAll(' ', '').replaceAll(':', '').replaceAll('.', '')}',
  //     title: 'ChipinCauses',
  //     imageUrl:'',
  //     contentDescription: 'ChipinCauses Forgot Password',
  //     contentMetadata: BranchContentMetaData()
  //       ..addCustomMetadata('custom_string', 'abc')
  //       ..addCustomMetadata('custom_number', 12345)
  //       ..addCustomMetadata('custom_bool', true)
  //       ..addCustomMetadata('custom_list_number', [1, 2, 3, 4, 5])
  //       ..addCustomMetadata('custom_list_string', ['a', 'b', 'c']
  //     ),
  //     keywords: ['ChipinCauses', 'Password', 'Reset'],
  //     publiclyIndex: true,
  //     locallyIndex: true,
  //   );

  //   lp = BranchLinkProperties(
  //     channel: 'email',
  //     feature: 'sharing',
  //     stage: 'new share',
  //     campaign: 'xxxxx',
  //     tags: ['reset', 'password', 'email'],
  //   );

  //   lp.addControlParam('\$uri_redirect_mode', '1');
  // }

  // Future<bool> generateLink(String email) async {

  //   bool forgotPasswordResult;

  //   try{
  //     BranchResponse response = await FlutterBranchSdk.getShortUrl(buo: buo, linkProperties: lp);
  //     if(response.success){
  //       forgotPasswordResult = await apiHomeResetPassword(email: email, redirectLink: response.result);
  //     }
  //   }catch(e){
  //     setState(() {
  //       requestResult = 'Something went wrong. Please try again.';
  //     });
  //     forgotPasswordResult = false;
  //   }

  //   return forgotPasswordResult;
  // }


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

              Container(height: SizeConfig.screenHeight, child: MiscRegularBackgroundTemplate(image: AssetImage('assets/icons/background2.png'),),),

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

                        Container(
                          padding: EdgeInsets.only(left: 20.0), 
                          alignment: Alignment.centerLeft, 
                          child: Text(
                            'Login', 
                            style: TextStyle(
                              // fontSize: SizeConfig.safeBlockHorizontal * 7,
                              fontSize: ScreenUtil().setSp(26, allowFontScalingSelf: true),
                              fontWeight: FontWeight.bold, 
                              color: Color(0xff000000),
                            ),
                          ),
                        ),

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

                                      bool apiResult = await apiRegularSignInWithFacebook(
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
                                        Navigator.pushReplacementNamed(context, '/home/regular');
                                      }else{
                                        await showDialog(context: context, builder: (build) => MiscRegularAlertDialog(title: 'Error', content: 'Invalid email or password. Please try again.'));
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

                                      
                                      bool apiResult = await apiRegularSignInWithFacebook(
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
                                        Navigator.pushReplacementNamed(context, '/home/regular');
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
                                child: MiscRegularButtonSignInWithTemplate(
                                  buttonText: 'Google', 
                                  buttonColor: Color(0xffF5F5F5),
                                  buttonTextStyle: TextStyle(
                                    // fontSize: SizeConfig.safeBlockHorizontal * 4,
                                    fontSize: ScreenUtil().setSp(14, allowFontScalingSelf: true),
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

                                      
                                      bool result = await apiRegularSignInWithGoogle(
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
                                        Navigator.pushReplacementNamed(context, '/home/regular');
                                      }else{
                                        await showDialog(context: context, builder: (build) => MiscRegularAlertDialog(title: 'Error', content: 'Invalid email or password. Please try again.'));
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
                                      

                                      bool result = await apiRegularSignInWithGoogle(
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
                                        Navigator.pushReplacementNamed(context, '/home/regular');
                                      }else{
                                        await showDialog(context: context, builder: (build) => MiscRegularAlertDialog(title: 'Error', content: 'Invalid email or password. Please try again.'));
                                      }
                                    }
                                    

                                    // if(isSignedIn == true){

                                    //   // context.showLoaderOverlay();
                                    //   // bool result = await apiRegularLogin(_key1.currentState.controller.text, _key2.currentState.controller.text);
                                    //   // context.hideLoaderOverlay();

                                    //   // var accountSignedIn = await googleSignIn.signInSilently();
                                    //   // var authHeaders = await googleSignIn.currentUser.authHeaders;
                                    //   // var auth = await googleSignIn.currentUser.authentication;


                                    //   // print('The auth is ${auth.accessToken}}');
                                    //   // print('The auth is ${auth.idToken}');
                                    //   // print('The auth is ${auth.serverAuthCode}');

                                    //   // print('The auth headers is $authHeaders');

                                    //   // print('The client id is ${googleSignIn.clientId}');


                                    //   // print('The headers is $authHeaders');

                                    //   // context.showLoaderOverlay();
                                    //   // bool result = await apiRegularSignInWithGoogle(
                                    //   //   firstName: accountSignedIn.displayName, 
                                    //   //   lastName: accountSignedIn.displayName, 
                                    //   //   email: accountSignedIn.email, 
                                    //   //   username: accountSignedIn.email,
                                    //   //   googleId: auth.idToken,
                                    //   // );
                                    //   // context.hideLoaderOverlay();

                                    //   // print('The value of result is $result');
                                    //   // print('The value is ${accountSignedIn.authHeaders}');

                                    // }

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

                            

                            print('The credential is $credential');
                            print('The credential is ${credential.authorizationCode}');
                            print('The credential is ${credential.email}');
                            print('The credential is ${credential.familyName}');
                            print('The credential is ${credential.givenName}');
                            print('The credential is ${credential.identityToken}');
                            print('The credential is ${credential.state}');
                            print('The credential is ${credential.userIdentifier}');

                            // Now send the credential (especially `credential.authorizationCode`) to your server to create a session
                            // after they have been validated with Apple (see `Integration` section for more information on how to do this)
                          },
                          height: ScreenUtil().setHeight(45),
                        ),

                        SizedBox(height: SizeConfig.blockSizeVertical * 5,),

                        Center(
                          child: Text('or log in with email', 
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(14, allowFontScalingSelf: true), 
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

                        SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                        Padding(padding: EdgeInsets.only(left: 20.0, right: 20.0), child: MiscRegularInputFieldTemplate(key: _key2, labelText: 'Password', type: TextInputType.text, obscureText: true,),),

                        // SizedBox(height: SizeConfig.blockSizeVertical * 2,),
                        SizedBox(height: ScreenUtil().setHeight(20)),

                        GestureDetector(
                          onTap: () async{

                            // FlutterBranchSdk.logout();
                            // print('heheheh');

                            // String email = await showDialog(context: (context), builder: (build) => MiscRegularAlertInputEmailDialog(title: 'Email', content: 'Input email address.'));

                            // print('The value of email is $email');

                            // if(email != null){
                            //   bool validEmail = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);

                            //   if(validEmail == true){
                            //     // DateTime date = DateTime.now();
                            //     // String id = date.toString().replaceAll('-', '').replaceAll(' ', '').replaceAll(':', '').replaceAll('.', '') + 'id-alm-password-reset';
                            //     // FlutterBranchSdk.setIdentity('$id');

                            //     context.showLoaderOverlay();
                            //     bool result = await generateLink(email);
                            //     context.hideLoaderOverlay();

                            //     if(result){
                            //       await showDialog(context: (context), builder: (build) => MiscRegularAlertDialog(title: 'Success', content: 'An email has been sent to $email containing instructions for resetting your password.', color: Colors.green,));
                            //     }else{
                            //       await showDialog(context: (context), builder: (build) => MiscRegularAlertDialog(title: 'Error', content: 'Something went wrong. Please try again.',));
                            //     }
                            //   } 
                            // }

                          },
                          child: Align(
                            alignment: Alignment.centerRight, 
                            child: Text('Forgot Password?', 
                              style: TextStyle(
                                decoration: TextDecoration.underline, 
                                // fontSize: SizeConfig.safeBlockHorizontal * 3.5,
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

                        MiscRegularButtonTemplate(
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
                              await showDialog(context: context, builder: (build) => MiscRegularAlertDialog(title: 'Error', content: 'Please complete the form before submitting.', confirmText: 'OK',),);
                            }else if(!validEmail){
                              await showDialog(context: context, builder: (build) => MiscRegularAlertDialog(title: 'Error', content: 'Invalid email address. Please try again.', confirmText: 'OK',),);
                            }else{

                              context.showLoaderOverlay();
                              bool result = await apiRegularLogin(_key1.currentState.controller.text, _key2.currentState.controller.text);
                              context.hideLoaderOverlay();

                              if(result){
                                FlutterBranchSdk.logout();
                                Navigator.pushReplacementNamed(context, '/home/regular');
                              }else{
                                await showDialog(context: context, builder: (build) => MiscRegularAlertDialog(title: 'Error', content: 'Invalid email or password. Please try again.'));
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
                              // fontSize: SizeConfig.safeBlockHorizontal * 4,
                              fontSize: ScreenUtil().setSp(16, allowFontScalingSelf: true),
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
                                  // fontSize: SizeConfig.safeBlockHorizontal * 4,
                                  fontSize: ScreenUtil().setSp(16, allowFontScalingSelf: true),
                                  fontWeight: FontWeight.w300,
                                  color: Color(0xff888888),
                                ),
                              ),

                              TextSpan(
                                text: 'Remember    /    ',
                                style: TextStyle(
                                  // fontSize: SizeConfig.safeBlockHorizontal * 4,
                                  fontSize: ScreenUtil().setSp(16, allowFontScalingSelf: true),
                                  fontWeight: FontWeight.w300,
                                  color: Color(0xff888888),
                                ),
                              ),

                              TextSpan(
                                text: 'Honor',
                                style: TextStyle(
                                  // fontSize: SizeConfig.safeBlockHorizontal * 4,
                                  fontSize: ScreenUtil().setSp(16, allowFontScalingSelf: true),
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



  // String token = '';
  // String requestResult = '';
  // BranchUniversalObject buo;
  // BranchLinkProperties lp;
  // String link = '';
  // StreamSubscription<Map> streamSubscription;

  // void didChangeAppLifecycleState(AppLifecycleState state) async{
  //   // if(state == AppLifecycleState.detached || state == AppLifecycleState.paused || state == AppLifecycleState.resumed || state == AppLifecycleState.inactive){
  //   if(state == AppLifecycleState.resumed){
  //     initDeepLink();
  //     listenDeepLinkData(context);
  //     setState(() {});
      
  //   }
  // }

  // void initDeepLink(){
  //   buo = BranchUniversalObject(
  //     canonicalIdentifier: 'password-reset-alm-account',
  //     title: 'Password Reset for ALM Accounts',
  //     imageUrl: 'assets/icons/app-icon.png',
  //     contentDescription: 'Password reset request for ALM accounts',
  //     keywords: ['Password', 'Reset', 'ALM'],
  //     publiclyIndex: true,
  //     locallyIndex: true,
  //     contentMetadata: BranchContentMetaData()..addCustomMetadata('custom_id', 'password-reset-alm-account')
  //       ..addCustomMetadata('custom_number', 12345)
  //       ..addCustomMetadata('custom_bool', true)
  //       ..addCustomMetadata('custom_list_number', [1,2,3,4,5 ])
  //       ..addCustomMetadata('custom_list_string', ['a', 'b', 'c']),
  //   );

  //   lp = BranchLinkProperties(
  //       channel: 'email',
  //       feature: 'sharing',
  //       stage: 'new share',
  //     tags: ['one', 'two', 'three']
  //   );
  //   // lp.addControlParam('url', 'https://29cft.test-app.link/suCwfzCi6bb');
  //   lp.addControlParam('url', 'https://29cft.app.link/suUQepVFocb?bnc_validate=true');
  //   // lp.addControlParam('\$uri_redirect_mode', '1');
  // }

  // void listenDeepLinkData(BuildContext context) async {
  //   bool login = await FlutterBranchSdk.isUserIdentified();
  //   // var first = await FlutterBranchSdk.getFirstReferringParams();

  //   if(login == true){

  //     var value = await FlutterBranchSdk.getLatestReferringParams();

  //     setState(() {
  //       token = value['token'];
  //       requestResult = '';
  //     });

  //     print('The login is $login');
  //     print('The map value of value is $value');
  //     print('The value of token is ${value['token']}');
  //     print('The token is $token');

  //     streamSubscription = FlutterBranchSdk.initSession().listen((data) {
  //       if (data.containsKey("+clicked_branch_link") && data["+clicked_branch_link"] == true && data['custom_id'] == 'password-reset-alm-account') {
  //         print('Custom string: ${data['custom_id']}');
  //         // Navigator.push(context, PageRouteBuilder(pageBuilder: (__, _, ___) => RegularPasswordReset()));
  //       }
  //     }, onError: (error) {
  //       PlatformException platformException = error as PlatformException;
  //       print(
  //           'InitSession error: ${platformException.code} - ${platformException.message}');
  //     });

  //     print('The streamSubscription is $streamSubscription');
  //   }
  // }


  // Future<bool> generateLink(String email) async {

  //   bool forgotPasswordResult;

  //   try{
  //     BranchResponse response = await FlutterBranchSdk.getShortUrl(buo: buo, linkProperties: lp);
  //     if(response.success){
  //       forgotPasswordResult = await apiHomeResetPassword(email: email, redirectLink: response.result);
  //     }
  //   }catch(e){
  //     setState(() {
  //       requestResult = 'Something went wrong. Please try again.';
  //     });
  //     forgotPasswordResult = false;
  //   }

  //   return forgotPasswordResult;
  // }

  // void initState(){
  //   super.initState();
  //   initDeepLink();
  //   // FlutterBranchSdk.registerView(buo: buo);
  //   listenDeepLinkData(context);
  //   WidgetsBinding.instance.addObserver(this);
  // }

  // @override
  // void dispose() {
  //   super.dispose();
  //   WidgetsBinding.instance.removeObserver(this);
  //   streamSubscription.cancel();
  // }
