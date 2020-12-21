import 'UI/Home/BLM/Create-Memorial/home-07-01-blm-create-memorial.dart';
import 'UI/Home/BLM/Create-Post/home-19-01-blm-create-post.dart';
import 'UI/Home/BLM/Donate/home-20-blm-donate.dart';
import 'UI/Home/Regular/Create-Memorial/home-04-01-regular-create-memorial.dart';
import 'UI/Home/Regular/Create-Memorial/home-04-02-regular-create-memorial.dart';
import 'UI/Home/Regular/Create-Memorial/home-04-03-regular-create-memorial.dart';
import 'UI/Home/Regular/Create-Post/home-09-01-regular-create-post.dart';
import 'UI/Home/Regular/Create-Post/home-09-03-regular-create-post-user.dart';
import 'UI/Home/Regular/Donate/home-20-regular-donate.dart';
import 'UI/Home/Regular/Search/home-05-regular-search.dart';
import 'UI/Home/Regular/Settings-Notifications/home-01-regular-notification-settings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'UI/Home/BLM/Main/home-01-blm-home.dart';
import 'UI/Home/Regular/Donate/home-32-regular-paypal-screen.dart';
import 'UI/Home/Regular/01-Main/home-01-regular-home.dart';
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
          '/login': (BuildContext context) => UILogin01(),

          '/blm/join': (BuildContext context) => BLMJoin(),
          '/blm/login': (BuildContext context) => BLMLogin(),
          '/blm/register': (BuildContext context) => BLMRegister(),
          '/blm/verify-email': (BuildContext context) => BLMVerifyEmail(),
          '/blm/upload-photo': (BuildContext context) => BLMUploadPhoto(),

          '/regular/join': (BuildContext context) => RegularJoin(),
          '/regular/login': (BuildContext context) => RegularLogin(),
          '/regular/register': (BuildContext context) => RegularRegister(),
          '/regular/verify-email': (BuildContext context) => RegularVerifyEmail(),
          '/regular/upload-photo': (BuildContext context) => RegularUploadPhoto(),
          

          '/home/blm': (BuildContext context) => HomeBLMScreen(),
          '/home/blm/donation': (BuildContext context) => HomeBLMUserDonate(),
          '/home/blm/create-post': (BuildContext context) => HomeBLMCreatePost(),
          '/home/blm/create-memorial': (BuildContext context) => HomeBLMCreateMemorial1(),
          
          '/home/regular': (BuildContext context) => HomeRegularScreen(),
          '/home/regular/create-post': (BuildContext context) => HomeRegularCreatePost(),
          '/home/regular/create-post-user': (BuildContext context) => HomeRegularCreatePostSearchUser(),
          '/home/regular/create-memorial': (BuildContext context) => HomeRegularCreateMemorial1(),
          '/home/regular/create-memorial-2': (BuildContext context) => HomeRegularCreateMemorial2(),
          '/home/regular/create-memorial-3': (BuildContext context) => HomeRegularCreateMemorial3(),
          '/home/regular/notification-settings': (BuildContext context) => HomeRegularNotificationSettings(),
          '/home/regular/donation': (BuildContext context) => HomeRegularUserDonate(),
          '/home/regular/donation-paypal': (BuildContext context) => HomeRegularPaypal(),
          '/home/regular/search': (BuildContext context) => HomeRegularSearch(),

        },
      ),
    ),
  );
}
