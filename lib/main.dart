import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'UI/Home/Regular/01-Main/home-main-regular-01-home.dart';
import 'UI/Home/Regular/03-Create-Memorial/home-create-memorial-regular-01-create-memorial.dart';
import 'UI/Home/Regular/03-Create-Memorial/home-create-memorial-regular-02-create-memorial.dart';
import 'UI/Home/Regular/03-Create-Memorial/home-create-memorial-regular-03-create-memorial.dart';
import 'UI/Home/Regular/04-Create-Post/home-create-post-regular-01-create-post.dart';
import 'UI/Home/Regular/04-Create-Post/home-create-post-regular-02-01-create-post-location.dart';
import 'UI/Home/Regular/04-Create-Post/home-create-post-regular-02-02-create-post-user.dart';
import 'UI/Home/Regular/05-Donate/home-donate-regular-01-donate.dart';
import 'UI/Home/Regular/05-Donate/home-donate-regular-02-paypal-screen.dart';
import 'UI/Home/Regular/07-Search/home-search-regular-01-search.dart';
import 'UI/Home/Regular/09-Settings-User/home-settings-user-regular-01-user-details.dart';
import 'UI/Home/Regular/10-Settings-Notifications/home-settings-notifications-regular-01-notification-settings.dart';
import 'UI/Home/BLM/01-Main/home-main-blm-01-home.dart';
import 'UI/Home/BLM/02-View-Memorial/home-view-memorial-blm-01-managed-memorial.dart';
import 'UI/Home/BLM/03-Create-Memorial/home-create-memorial-blm-01-create-memorial.dart';
import 'UI/Home/BLM/03-Create-Memorial/home-create-memorial-blm-02-create-memorial.dart';
import 'UI/Home/BLM/03-Create-Memorial/home-create-memorial-blm-03-create-memorial.dart';
import 'UI/Home/BLM/04-Create-Post/home-create-post-blm-01-create-post.dart';
import 'UI/Home/BLM/04-Create-Post/home-create-post-blm-02-01-create-post-location.dart';
import 'UI/Home/BLM/04-Create-Post/home-create-post-blm-02-02-create-post-user.dart';
import 'UI/Home/BLM/05-Donate/home-donate-blm-01-donate.dart';
import 'UI/Home/BLM/05-Donate/home-donate-blm-02-paypal-screen.dart';
import 'UI/Home/BLM/07-Search/home-search-blm-01-search.dart';
import 'UI/Home/BLM/09-Settings-User/home-settings-user-01-user-details.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter/material.dart';
import 'UI/Regular/regular-01-join.dart';
import 'UI/Regular/regular-02-login.dart';
import 'UI/Regular/regular-03-register.dart';
import 'UI/Regular/regular-04-verify-email.dart';
import 'UI/Regular/regular-05-upload-photo.dart';
import 'UI/BLM/blm-01-join.dart';
import 'UI/BLM/blm-02-login.dart';
import 'UI/BLM/blm-03-register.dart';
import 'UI/BLM/blm-04-verify-email.dart';
import 'UI/BLM/blm-05-upload-photo.dart';
import 'UI/ui-01-get-started.dart';
import 'UI/ui-02-login.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  final sharedPrefs = await SharedPreferences.getInstance();
  final blmSession = sharedPrefs.getBool('blm-user-session') ?? false;
  final regularSession = sharedPrefs.getBool('regular-user-session') ?? false;

  print('The blm session is $blmSession');
  print('The regular session is $regularSession');

  runApp(
     RefreshConfiguration(
         headerBuilder: () => WaterDropHeader(),        // Configure the default header indicator. If you have the same header indicator for each page, you need to set this
         footerBuilder:  () => ClassicFooter(),        // Configure default bottom indicator
         headerTriggerDistance: 80.0,        // header trigger refresh trigger distance
        //  springDescription:SpringDescription(stiffness: 170, damping: 16, mass: 1.9),         // custom spring back animate,the props meaning see the flutter api
         maxOverScrollExtent :100, //The maximum dragging range of the head. Set this property if a rush out of the view area occurs
         maxUnderScrollExtent:0, // Maximum dragging range at the bottom
         enableScrollWhenRefreshCompleted: true, //This property is incompatible with PageView and TabBarView. If you need TabBarView to slide left and right, you need to set it to true.
         enableLoadingWhenFailed : true, //In the case of load failure, users can still trigger more loads by gesture pull-up.
         hideFooterWhenNotFull: false, // Disable pull-up to load more functionality when Viewport is less than one screen
         enableBallisticLoad: true, // trigger load more by BallisticScrollActivity
        child: GlobalLoaderOverlay(
      useDefaultLoading: false,
      overlayWidget: Container(
        color: Colors.grey,
        child: Center(
          child: SpinKitThreeBounce(color: Color(0xff000000), size: 50.0,),
        ),
      ),
      child: MaterialApp(
        title: 'Faces by Places',
        home: ((){
          if(blmSession){
            return HomeBLMScreen();
          }else if(regularSession){
            return HomeRegularScreen();
          }else{
            return UIGetStarted();
          }
        }()),
        builder: (context, widget) => ResponsiveWrapper.builder(
          BouncingScrollWrapper.builder(context, widget),
          maxWidth: 1200,
          minWidth: 450,
          defaultScale: true,
          breakpoints: [
            ResponsiveBreakpoint.resize(450, name: MOBILE),
            ResponsiveBreakpoint.autoScale(800, name: TABLET),
            ResponsiveBreakpoint.autoScale(1000, name: TABLET),
            ResponsiveBreakpoint.resize(1200, name: DESKTOP),
            ResponsiveBreakpoint.autoScale(2460, name: "4K"),
          ],
          background: Container(color: Color(0xFFF5F5F5))
        ),
        // initialRoute: '/start',
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
          '/blm/verify-email': (BuildContext context) => BLMVerifyEmail(),
          '/blm/upload-photo': (BuildContext context) => BLMUploadPhoto(), // BLM START

          '/regular/join': (BuildContext context) => RegularJoin(),
          '/regular/login': (BuildContext context) => RegularLogin(),
          '/regular/register': (BuildContext context) => RegularRegister(),
          '/regular/verify-email': (BuildContext context) => RegularVerifyEmail(),
          '/regular/upload-photo': (BuildContext context) => RegularUploadPhoto(), // ALM START

          '/home/blm': (BuildContext context) => HomeBLMScreen(),
          '/home/blm/donation': (BuildContext context) => HomeBLMUserDonate(),
          '/home/blm/create-post': (BuildContext context) => HomeBLMCreatePost(),
          '/home/blm/create-post-user': (BuildContext context) => HomeBLMCreatePostSearchUser(),
          '/home/blm/create-post-location': (BuildContext context) => HomeBLMCreatePostSearchLocation(),
          '/home/blm/create-memorial': (BuildContext context) => HomeBLMCreateMemorial1(),
          '/home/blm/create-memorial-2': (BuildContext context) => HomeBLMCreateMemorial2(),
          '/home/blm/create-memorial-3': (BuildContext context) => HomeBLMCreateMemorial3(),
          '/home/blm/search': (BuildContext context) => HomeBLMSearch(),
          '/home/blm/donation-paypal': (BuildContext context) => HomeBLMPaypal(),
          '/home/blm/profile-settings': (BuildContext context) => HomeBLMUserProfileDetails(),
          '/home/blm/managed-profile': (BuildContext context) => HomeBLMProfile(), // BLM HOME SCREEN

          '/home/regular': (BuildContext context) => HomeRegularScreen(),
          '/home/regular/create-post': (BuildContext context) => HomeRegularCreatePost(),
          '/home/regular/create-post-user': (BuildContext context) => HomeRegularCreatePostSearchUser(),
          '/home/regular/create-post-location': (BuildContext context) => HomeRegularCreatePostSearchLocation(),
          '/home/regular/create-memorial': (BuildContext context) => HomeRegularCreateMemorial1(),
          '/home/regular/create-memorial-2': (BuildContext context) => HomeRegularCreateMemorial2(),
          '/home/regular/create-memorial-3': (BuildContext context) => HomeRegularCreateMemorial3(),
          '/home/regular/notification-settings': (BuildContext context) => HomeRegularNotificationSettings(),
          '/home/regular/donation': (BuildContext context) => HomeRegularUserDonate(),
          '/home/regular/donation-paypal': (BuildContext context) => HomeRegularPaypal(),
          '/home/regular/search': (BuildContext context) => HomeRegularSearch(),
          '/home/regular/profile-settings': (BuildContext context) => HomeRegularUserProfileDetails(), // ALM HOME SCREEN

        },
      ),
    ),
     ),

    
  );
}

