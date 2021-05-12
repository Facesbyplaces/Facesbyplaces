import 'UI/Home/Regular/01-Main/home-main-regular-01-home.dart';
import 'UI/Home/Regular/03-Create-Memorial/home-create-memorial-regular-01-create-memorial.dart';
import 'UI/Home/Regular/04-Create-Post/home-create-post-regular-02-01-create-post-location.dart';
import 'UI/Home/Regular/04-Create-Post/home-create-post-regular-02-02-create-post-user.dart';
import 'UI/Home/Regular/05-Donate/home-donate-regular-02-paypal-screen.dart';
import 'UI/Home/Regular/07-Search/home-search-regular-01-search.dart';
import 'UI/Home/BLM/01-Main/home-main-blm-01-home.dart';
import 'UI/Home/BLM/03-Create-Memorial/home-create-memorial-blm-01-create-memorial.dart';
import 'UI/Home/BLM/04-Create-Post/home-create-post-blm-02-01-create-post-location.dart';
import 'UI/Home/BLM/04-Create-Post/home-create-post-blm-02-02-create-post-user.dart';
import 'UI/Home/BLM/05-Donate/home-donate-blm-02-paypal-screen.dart';
import 'UI/Home/BLM/07-Search/home-search-blm-01-search.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:firebase_core/firebase_core.dart';
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
import 'package:flutter/rendering.dart';
import 'UI/ui-03-newly-installed.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

void main() async{

  // debugProfileBuildsEnabled = true;
  // debugRepaintRainbowEnabled = true;
  // debugRepaintTextRainbowEnabled = true;

  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await Firebase.initializeApp();

  final sharedPrefs = await SharedPreferences.getInstance();
  final newlyInstalled = sharedPrefs.getBool('newly-installed') ?? true;
  final blmSession = sharedPrefs.getBool('blm-user-session') ?? false;
  final regularSession = sharedPrefs.getBool('regular-user-session') ?? false;

  runApp(
    RepaintBoundary(
      child: GlobalLoaderOverlay(
        useDefaultLoading: false,
        overlayWidget: const Center(child: const SpinKitThreeBounce(color: const Color(0xff000000)),),
        overlayOpacity: 0.5,
        overlayColor: Colors.grey,
        child: MaterialApp(
          // checkerboardRasterCacheImages: true,
          // showPerformanceOverlay: true,
          title: 'Faces by Places',
          home: ((){
            if(newlyInstalled){
              return UINewlyInstalled();
            }else{
              if(blmSession){
                return const HomeBLMScreen();
              }else if(regularSession){
                return const HomeRegularScreen();
              }else{
                return const UIGetStarted();
              }
            }
          }()),
          builder: (context, widget) => ResponsiveWrapper.builder(
            BouncingScrollWrapper.builder(context, widget!),
            maxWidth: 1200,
            minWidth: 450,
            defaultScale: true,
            breakpoints: [
              const ResponsiveBreakpoint.resize(450, name: MOBILE),
              const ResponsiveBreakpoint.autoScale(800, name: TABLET),
              const ResponsiveBreakpoint.autoScale(1000, name: TABLET),
              const ResponsiveBreakpoint.resize(1200, name: DESKTOP),
              const ResponsiveBreakpoint.autoScale(2460, name: "4K"),
            ],
            background: Container(color: const Color(0xFFF5F5F5))
          ),
          theme: ThemeData(
            primaryColor: Color(0xFF000000),
            accentColor: const Color(0xff4EC9D4),
            cardColor: const Color(0xffffffff),
          ),
          routes: <String, WidgetBuilder>{ // NAMED ROUTES USED FOR NAVIGATING
            '/start': (BuildContext context) => UIGetStarted(),
            '/login': (BuildContext context) => UILogin01(), // START

            '/blm/join': (BuildContext context) => BLMJoin(),
            '/blm/login': (BuildContext context) => BLMLogin(),
            '/blm/register': (BuildContext context) => BLMRegister(),
            '/blm/upload-photo': (BuildContext context) => BLMUploadPhoto(), // BLM START

            '/regular/join': (BuildContext context) => RegularJoin(),
            '/regular/login': (BuildContext context) => RegularLogin(),
            '/regular/register': (BuildContext context) => RegularRegister(),
            '/regular/upload-photo': (BuildContext context) => RegularUploadPhoto(), // ALM START

            '/home/blm': (BuildContext context) => HomeBLMScreen(),
            '/home/blm/create-post-user': (BuildContext context) => HomeBLMCreatePostSearchUser(),
            '/home/blm/create-post-location': (BuildContext context) => HomeBLMCreatePostSearchLocation(),
            '/home/blm/create-memorial': (BuildContext context) => HomeBLMCreateMemorial1(),
            '/home/blm/search': (BuildContext context) => HomeBLMSearch(),
            '/home/blm/donation-paypal': (BuildContext context) => HomeBLMPaypal(), // BLM HOME SCREEN

            '/home/regular': (BuildContext context) => HomeRegularScreen(),
            '/home/regular/create-post-user': (BuildContext context) => HomeRegularCreatePostSearchUser(),
            '/home/regular/create-post-location': (BuildContext context) => HomeRegularCreatePostSearchLocation(),
            '/home/regular/create-memorial': (BuildContext context) => HomeRegularCreateMemorial1(),
            '/home/regular/donation-paypal': (BuildContext context) => HomeRegularPaypal(),
            '/home/regular/search': (BuildContext context) => HomeRegularSearch(), // ALM HOME SCREEN

          },
        ),
      ),
    ),
  );
}