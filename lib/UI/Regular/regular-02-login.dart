import 'package:facesbyplaces/API/Regular/01-Start/api-start-regular-01-login.dart';
import 'package:facesbyplaces/API/Regular/01-Start/api-start-regular-06-sign-in-google.dart';
import 'package:facesbyplaces/API/Regular/01-Start/api-start-regular-05-sign-in-with-facebook.dart';
import 'package:facesbyplaces/API/Regular/01-Start/api-start-regular-07-sign-in-with-apple.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-01-regular-input-field.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-07-regular-button.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-02-regular-dialog.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-08-regular-background.dart';
import 'package:facesbyplaces/UI/Regular/regular-06-password-reset-email.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
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

class RegularLoginState extends State<RegularLogin>{

  final GlobalKey<MiscRegularInputFieldTemplateState> _key1 = GlobalKey<MiscRegularInputFieldTemplateState>();
  final GlobalKey<MiscRegularInputFieldTemplateState> _key2 = GlobalKey<MiscRegularInputFieldTemplateState>();


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

              SingleChildScrollView(physics: NeverScrollableScrollPhysics(), child: Container(height: SizeConfig.screenHeight, child: MiscRegularBackgroundTemplate(image: AssetImage('assets/icons/background2.png'),),),),

              ContainerResponsive(
                height: SizeConfig.screenHeight,
                width: SizeConfig.screenWidth,
                alignment: Alignment.center,
                child: ContainerResponsive(
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
                                  height: ScreenUtil().setHeight(45),
                                ),
                              ),

                              SizedBox(width: SizeConfig.blockSizeHorizontal * 10,),

                              Expanded(
                                child: MiscRegularButtonSignInWithTemplate(
                                  buttonText: 'Google', 
                                  buttonColor: Color(0xffF5F5F5),
                                  buttonTextStyle: TextStyle(
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
                                    
                                  }, 
                                  width: SizeConfig.screenWidth / 1.5, 
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


                            bool result = await apiRegularSignInWithApple(userIdentification: credential.userIdentifier, identityToken: credential.identityToken);

                            if(result == true){
                              Navigator.pushReplacementNamed(context, '/home/regular');
                            }else{
                              await showDialog(context: context, builder: (build) => MiscRegularAlertDialog(title: 'Error', content: 'Invalid email or password. Please try again.'));
                            }

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

                        SizedBox(height: ScreenUtil().setHeight(20)),

                        GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => RegularPasswordResetEmail()));
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

                        SizedBox(height: ScreenUtil().setHeight(20)),

                        MiscRegularButtonTemplate(
                          buttonText: 'Login', 
                          buttonTextStyle: TextStyle(
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
                              bool result = await apiRegularLogin(email: _key1.currentState.controller.text, password: _key2.currentState.controller.text);
                              context.hideLoaderOverlay();

                              if(result){
                                Navigator.pushReplacementNamed(context, '/home/regular');
                              }else{
                                await showDialog(context: context, builder: (build) => MiscRegularAlertDialog(title: 'Error', content: 'Invalid email, password or type of account. Please try again.'));
                              }
                            }
                            
                          }, 
                          width: SizeConfig.screenWidth / 2, 
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
                                  fontSize: ScreenUtil().setSp(16, allowFontScalingSelf: true),
                                  color: Color(0xff000000),
                                ),
                              ),

                              TextSpan(
                                text: 'Sign Up', 
                                style: TextStyle(
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
                          onTap: () async{
                            Navigator.pushReplacementNamed(context, '/home/regular');
                          },
                          child: Text('Sign in as Guest',
                            style: TextStyle(
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
                                  fontSize: ScreenUtil().setSp(16, allowFontScalingSelf: true),
                                  fontWeight: FontWeight.w300,
                                  color: Color(0xff888888),
                                ),
                              ),

                              TextSpan(
                                text: 'Remember    /    ',
                                style: TextStyle(
                                  fontSize: ScreenUtil().setSp(16, allowFontScalingSelf: true),
                                  fontWeight: FontWeight.w300,
                                  color: Color(0xff888888),
                                ),
                              ),

                              TextSpan(
                                text: 'Honor',
                                style: TextStyle(
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