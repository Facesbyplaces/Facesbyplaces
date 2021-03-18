// import 'package:firebase_messaging/firebase_messaging.dart';
import 'UI/Home/Regular/01-Main/home-main-regular-01-home.dart';
import 'UI/Home/Regular/03-Create-Memorial/home-create-memorial-regular-01-create-memorial.dart';
// import 'UI/Home/Regular/04-Create-Post/home-create-post-regular-01-create-post.dart';
import 'UI/Home/Regular/04-Create-Post/home-create-post-regular-02-01-create-post-location.dart';
import 'UI/Home/Regular/04-Create-Post/home-create-post-regular-02-02-create-post-user.dart';
// import 'UI/Home/Regular/05-Donate/home-donate-regular-01-donate.dart';
import 'UI/Home/Regular/05-Donate/home-donate-regular-02-paypal-screen.dart';
import 'UI/Home/Regular/07-Search/home-search-regular-01-search.dart';
// import 'UI/Home/Regular/09-Settings-User/home-settings-user-regular-01-user-details.dart';
// import 'UI/Home/Regular/10-Settings-Notifications/home-settings-notifications-regular-01-notification-settings.dart';
import 'UI/Home/BLM/01-Main/home-main-blm-01-home.dart';
// import 'UI/Home/BLM/02-View-Memorial/home-view-memorial-blm-01-managed-memorial.dart';
import 'UI/Home/BLM/03-Create-Memorial/home-create-memorial-blm-01-create-memorial.dart';
// import 'UI/Home/BLM/03-Create-Memorial/home-create-memorial-blm-02-create-memorial.dart';
// import 'UI/Home/BLM/04-Create-Post/home-create-post-blm-01-create-post.dart';
import 'UI/Home/BLM/04-Create-Post/home-create-post-blm-02-01-create-post-location.dart';
import 'UI/Home/BLM/04-Create-Post/home-create-post-blm-02-02-create-post-user.dart';
// import 'UI/Home/BLM/05-Donate/home-donate-blm-01-donate.dart';
import 'UI/Home/BLM/05-Donate/home-donate-blm-02-paypal-screen.dart';
import 'UI/Home/BLM/07-Search/home-search-blm-01-search.dart';
// import 'UI/Home/BLM/09-Settings-User/home-settings-user-01-user-details.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter_libphonenumber/flutter_libphonenumber.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter/material.dart';
import 'UI/Regular/regular-01-join.dart';
import 'UI/Regular/regular-02-login.dart';
import 'UI/Regular/regular-03-register.dart';
import 'UI/Regular/regular-05-upload-photo.dart';
import 'UI/BLM/blm-01-join.dart';
import 'UI/BLM/blm-02-login.dart';
import 'UI/BLM/blm-03-register.dart';
import 'UI/BLM/blm-05-upload-photo.dart';
import 'UI/ui-01-get-started.dart';
import 'UI/ui-02-login.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  // SharedPreferences.setMockInitialValues({});
  await Firebase.initializeApp();
  await FlutterLibphonenumber().init();

  final sharedPrefs = await SharedPreferences.getInstance();
  final blmSession = sharedPrefs.getBool('blm-user-session') ?? false;
  final regularSession = sharedPrefs.getBool('regular-user-session') ?? false;

  runApp(
     GlobalLoaderOverlay(
      useDefaultLoading: false,
      overlayWidget: Center(child: SpinKitThreeBounce(color: Color(0xff000000)),),
      overlayOpacity: 0.5,
      overlayColor: Colors.grey,
      child: MaterialApp(
        title: 'Faces by Places',
        // home: UIGetStarted(),
        home: ((){
          if(blmSession){
            return HomeBLMScreen();
          }else if(regularSession){
            return HomeRegularScreen();
          }else{
            return UIGetStarted();
          }
        }()),
        theme: ThemeData(
          accentColor: Color(0xff4EC9D4),
          cardColor: Color(0xffffffff),
        ),
        routes: <String, WidgetBuilder>{ // NAMED ROUTES USED FOR NAVIGATING
          '/start': (BuildContext context) => UIGetStarted(),
          '/login': (BuildContext context) => UILogin01(), // START

          '/blm/join': (BuildContext context) => BLMJoin(),
          '/blm/login': (BuildContext context) => BLMLogin(),
          '/blm/register': (BuildContext context) => BLMRegister(),
          // '/blm/verify-email': (BuildContext context) => BLMVerifyEmail(),
          '/blm/upload-photo': (BuildContext context) => BLMUploadPhoto(), // BLM START

          '/regular/join': (BuildContext context) => RegularJoin(),
          '/regular/login': (BuildContext context) => RegularLogin(),
          '/regular/register': (BuildContext context) => RegularRegister(),
          // '/regular/verify-email': (BuildContext context) => RegularVerifyEmail(),
          '/regular/upload-photo': (BuildContext context) => RegularUploadPhoto(), // ALM START

          '/home/blm': (BuildContext context) => HomeBLMScreen(),
          // '/home/blm/donation': (BuildContext context) => HomeBLMUserDonate(),
          // '/home/blm/create-post': (BuildContext context) => HomeBLMCreatePost(),
          '/home/blm/create-post-user': (BuildContext context) => HomeBLMCreatePostSearchUser(),
          '/home/blm/create-post-location': (BuildContext context) => HomeBLMCreatePostSearchLocation(),
          '/home/blm/create-memorial': (BuildContext context) => HomeBLMCreateMemorial1(),
          // '/home/blm/create-memorial-2': (BuildContext context) => HomeBLMCreateMemorial2(),
          // '/home/blm/create-memorial-3': (BuildContext context) => HomeBLMCreateMemorial3(),
          '/home/blm/search': (BuildContext context) => HomeBLMSearch(),
          '/home/blm/donation-paypal': (BuildContext context) => HomeBLMPaypal(),
          // '/home/blm/profile-settings': (BuildContext context) => HomeBLMUserProfileDetails(),
          // '/home/blm/managed-profile': (BuildContext context) => HomeBLMProfile(), // BLM HOME SCREEN

          '/home/regular': (BuildContext context) => HomeRegularScreen(),
          // '/home/regular/create-post': (BuildContext context) => HomeRegularCreatePost(),
          '/home/regular/create-post-user': (BuildContext context) => HomeRegularCreatePostSearchUser(),
          '/home/regular/create-post-location': (BuildContext context) => HomeRegularCreatePostSearchLocation(),
          '/home/regular/create-memorial': (BuildContext context) => HomeRegularCreateMemorial1(),
          // '/home/regular/create-memorial-2': (BuildContext context) => HomeRegularCreateMemorial2(),
          // '/home/regular/create-memorial-3': (BuildContext context) => HomeRegularCreateMemorial3(),
          // '/home/regular/notification-settings': (BuildContext context) => HomeRegularNotificationSettings(),
          // '/home/regular/donation': (BuildContext context) => HomeRegularUserDonate(),
          '/home/regular/donation-paypal': (BuildContext context) => HomeRegularPaypal(),
          '/home/regular/search': (BuildContext context) => HomeRegularSearch(),
          // '/home/regular/profile-settings': (BuildContext context) => HomeRegularUserProfileDetails(), // ALM HOME SCREEN

        },
      ),
    ),    
  );
}

