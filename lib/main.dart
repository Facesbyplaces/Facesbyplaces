import 'package:shared_preferences/shared_preferences.dart';
import 'UI/Home/BLM/Main/home-01-blm-home.dart';
import 'UI/Home/BLM/Search/home-04-blm-search.dart';
import 'UI/Home/BLM/Search/home-05-blm-searches.dart';
import 'UI/Home/BLM/Create-Memorial/home-07-01-blm-create-memorial.dart';
import 'UI/Home/BLM/Create-Memorial/home-07-02-blm-create-memorial.dart';
import 'UI/Home/BLM/Create-Memorial/home-07-03-blm-create-memorial.dart';
import 'UI/Home/BLM/View-Memorial/home-08-blm-view-memorial.dart';
import 'UI/Home/BLM/Settings-Memorial/home-09-blm-memorial-settings.dart';
import 'UI/Home/BLM/Settings-Memorial/home-11-blm-page-details.dart';
import 'UI/Home/BLM/View-Memorial/home-12-blm-profile-memorial.dart';
import 'UI/Home/BLM/View-Memorial/home-13-blm-user-profile.dart';
import 'UI/Home/BLM/Settings-Memorial/home-14-blm-user-details.dart';
import 'UI/Home/BLM/Settings-Memorial/home-15-blm-change-password.dart';
import 'UI/Home/BLM/Settings-Memorial/home-16-blm-other-details.dart';
import 'UI/Home/BLM/Settings-Memorial/home-18-blm-user-update-details.dart';
import 'UI/Home/BLM/Create-Post/home-19-01-blm-create-post.dart';
import 'UI/Home/BLM/Create-Post/home-19-02-blm-create-post-search-location.dart';
import 'UI/Home/BLM/Create-Post/home-19-03-blm-create-post-search-user.dart';
import 'UI/Home/BLM/Donate/home-20-blm-donate.dart';
import 'UI/Home/BLM/Settings-Memorial/home-21-blm-update-memorial-page-image.dart';
import 'UI/Home/BLM/View-Memorial/home-22-blm-connection-list.dart';
import 'UI/Home/BLM/Report/home-24-blm-report.dart';
import 'UI/Home/BLM/Settings-Memorial/home-26-blm-page-managers.dart';
import 'UI/Home/BLM/Settings-Memorial/home-29-blm-search-user-settings.dart';
import 'UI/Home/BLM/Settings-Notifications/home-30-blm-notification-settings.dart';
import 'UI/Home/BLM/Show-Post/home-31-blm-show-original-post.dart';
import 'UI/Home/BLM/Donate/home-32-blm-paypal-screen.dart';
import 'UI/Home/Regular/Main/home-01-regular-home.dart';
import 'UI/Home/Regular/Create-Memorial/home-04-01-regular-create-memorial.dart';
import 'UI/Home/Regular/Create-Memorial/home-04-02-regular-create-memorial.dart';
import 'UI/Home/Regular/Create-Memorial/home-04-03-regular-create-memorial.dart';
import 'UI/Home/Regular/Search/home-05-regular-search.dart';
import 'UI/Home/Regular/Create-Post/home-09-01-regular-create-post.dart';
import 'UI/Home/Regular/home-12-regular-page-details.dart';
import 'UI/Home/Regular/home-14-regular-user-profile.dart';
import 'UI/Home/Regular/home-15-regular-user-details.dart';
import 'UI/Home/Regular/home-21-regular-report.dart';
import 'UI/Home/Regular/home-22-regular-donate.dart';
import 'UI/Home/Regular/home-23-regular-page-managers.dart';
import 'UI/Home/Regular/home-24-regular-page-family.dart';
import 'UI/Home/Regular/home-25-regular-page-friends.dart';
import 'UI/Home/Regular/home-26-regular-search-user.dart';
import 'UI/Home/Regular/home-27-regular-notification-settings.dart';
import 'UI/Home/Regular/home-28-regular-show-original-post.dart';
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
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  final sharedPrefs = await SharedPreferences.getInstance();
  final blmSession = sharedPrefs.getBool('blm-user-session') ?? false;
  final regularSession = sharedPrefs.getBool('regular-user-session') ?? false;

  runApp(
    GlobalLoaderOverlay(
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
        initialRoute: '/',
        theme: ThemeData(
          accentColor: Colors.red,
          cardColor: Colors.purple,
        ),
        routes: <String, WidgetBuilder>{
          '/ui-02-login': (BuildContext context) => UILogin01(),

          '/blm/blm-01-join': (BuildContext context) => BLMJoin(),
          '/blm/blm-02-login': (BuildContext context) => BLMLogin(),
          '/blm/blm-03-register': (BuildContext context) => BLMRegister(),
          '/blm/blm-04-verify-email': (BuildContext context) => BLMVerifyEmail(),
          '/blm/blm-05-upload-photo': (BuildContext context) => BLMUploadPhoto(),

          '/regular/regular-01-join': (BuildContext context) => RegularJoin(),
          '/regular/regular-02-login': (BuildContext context) => RegularLogin(),
          '/regular/regular-03-register': (BuildContext context) => RegularRegister(),
          '/regular/regular-04-verify-email': (BuildContext context) => RegularVerifyEmail(),
          '/regular/regular-05-upload-photo': (BuildContext context) => RegularUploadPhoto(),

          '/home/blm': (BuildContext context) => HomeBLMScreen(),
          '/home/blm/home-04-blm-search': (BuildContext context) => HomeBLMSearch(),
          '/home/blm/home-05-blm-post': (BuildContext context) => HomeBLMPost(),
          '/home/blm/home-07-01-blm-create-memorial': (BuildContext context) => HomeBLMCreateMemorial1(),
          '/home/blm/home-07-02-blm-create-memorial': (BuildContext context) => HomeBLMCreateMemorial2(),
          '/home/blm/home-07-03-blm-create-memorial': (BuildContext context) => HomeBLMCreateMemorial3(),
        
          '/home/blm/home-08-blm-memorial': (BuildContext context) => HomeBLMMemorialProfile(),
          '/home/blm/home-09-blm-memorial-settings': (BuildContext context) => HomeBLMMemorialSettings(),
          '/home/blm/home-11-blm-page-details': (BuildContext context) => HomeBLMPageDetails(),
          '/home/blm/home-12-blm-profile': (BuildContext context) => HomeBLMProfile(),
          '/home/blm/home-13-blm-user-profile': (BuildContext context) => HomeBLMUserProfile(),
          '/home/blm/home-14-blm-user-details': (BuildContext context) => HomeBLMUserProfileDetails(),
          '/home/blm/home-15-blm-change-password': (BuildContext context) => HomeBLMUserChangePassword(),
          '/home/blm/home-16-blm-other-details': (BuildContext context) => HomeBLMUserOtherDetails(),
          '/home/blm/home-18-blm-user-update-details': (BuildContext context) => HomeBLMUserUpdateDetails(),
          '/home/blm/home-19-blm-create-post': (BuildContext context) => HomeBLMCreatePost(),
          '/home/blm/home-19-02-blm-create-post': (BuildContext context) => HomeBLMCreatePostSearch(),
          '/home/blm/home-19-03-blm-create-post': (BuildContext context) => HomeBLMCreatePostSearchUser(),
          '/home/blm/home-19-03-regular-create-post': (BuildContext context) => HomeBLMCreatePostSearchUser(),
          '/home/blm/home-20-blm-donate': (BuildContext context) => HomeBLMUserDonate(),
          '/home/blm/home-21-blm-memorial-page-image': (BuildContext context) => HomeBLMMemorialPageImage(),
          '/home/blm/home-22-blm-connection-list': (BuildContext context) => HomeBLMConnectionList(),
          '/home/blm/home-24-blm-report': (BuildContext context) => HomeBLMReport(),
          '/home/blm/home-26-blm-page-managers': (BuildContext context) => HomeBLMPageManagers(),
          '/home/blm/home-29-blm-search-user': (BuildContext context) => HomeBLMSearchUser(),
          '/home/blm/home-30-blm-notification-settings': (BuildContext context) => HomeBLMNotificationSettings(),
          '/home/blm/home-31-blm-show-original-post': (BuildContext context) => HomeBLMShowOriginalPost(),
          '/home/blm/home-32-blm-paypal-screen': (BuildContext context) => HomeBLMPaypal(),
          
          
          '/home/regular': (BuildContext context) => HomeRegularScreen(),
          '/home/regular/home-04-01-regular-create-memorial': (BuildContext context) => HomeRegularCreateMemorial1(),
          '/home/regular/home-04-02-regular-create-memorial': (BuildContext context) => HomeRegularCreateMemorial2(),
          '/home/regular/home-04-03-regular-create-memorial': (BuildContext context) => HomeRegularCreateMemorial3(),
          '/home/regular/home-05-regular-search': (BuildContext context) => HomeRegularSearch(),
          'home/regular/home-09-regular-create-post': (BuildContext context) => HomeRegularCreatePost(),
          'home/regular/home-12-regular-page-details': (BuildContext context) => HomeRegularPageDetails(),
          'home/regular/home-14-regular-user-profile': (BuildContext context) => HomeRegularUserProfile(),
          'home/regular/home-15-regular-user-details': (BuildContext context) => HomeRegularUserProfileDetails(),
          'home/regular/home-21-regular-report': (BuildContext context) => HomeRegularReport(),
          'home/regular/home-22-regular-donate': (BuildContext context) => HomeRegularUserDonate(),
          'home/regular/home-23-regular-page-managers': (BuildContext context) => HomeRegularPageManagers(),
          'home/regular/home-24-regular-page-family': (BuildContext context) => HomeRegularPageFamily(),
          'home/regular/home-25-regular-page-friends': (BuildContext context) => HomeRegularPageFriends(),
          'home/regular/home-26-regular-search-user': (BuildContext context) => HomeRegularSearchUser(),
          'home/regular/home-27-regular-notification-settings': (BuildContext context) => HomeRegularNotificationSettings(),
          'home/regular/home-28-regular-show-original-post': (BuildContext context) => HomeRegularShowOriginalPost(),
          
        },
      ),
    ),
  );
}
