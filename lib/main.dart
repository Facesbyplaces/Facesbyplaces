import 'UI/Home/Regular/01-Main/home_main_regular_01_home.dart';
import 'UI/Home/Regular/03-Create-Memorial/home_create_memorial_regular_01_create_memorial.dart';
import 'UI/Home/Regular/04-Create-Post/home_create_post_regular_02_01_create_post_location.dart';
import 'UI/Home/Regular/07-Search/home_search_regular_01_search.dart';
import 'UI/Home/BLM/01-Main/home_main_blm_01_home.dart';
import 'UI/Home/BLM/03-Create-Memorial/home_create_memorial_blm_01_create_memorial.dart';
import 'UI/Home/BLM/04-Create-Post/home_create_post_blm_02_01_create_post_location.dart';
import 'UI/Home/BLM/07-Search/home_search_blm_01_search.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'UI/Regular/regular_01_join.dart';
import 'UI/Regular/regular_02_login.dart';
import 'UI/Regular/regular_03_register.dart';
import 'UI/Regular/regular_05_upload_photo.dart';
import 'UI/BLM/blm_01_join.dart';
import 'UI/BLM/blm_02_login.dart';
import 'UI/BLM/blm_03_register.dart';
import 'UI/BLM/blm_05_upload_photo.dart';
import 'UI/ui_01_get_started.dart';
import 'UI/ui_02_login.dart';
import 'package:loader/loader.dart';
import 'dart:async';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void main() async{

  // debugProfileBuildsEnabled = true;
  // debugRepaintRainbowEnabled = true;
  // debugRepaintTextRainbowEnabled = true;

  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey =  'pk_test_51JF87VLLSR5xZm4pkKAGeRgKbp66uS2FJjo915T2971ILVjs5eQieiVD0Oi3bB6nV0WUJcDqx95uqY7puKVyI22u00fQNVPcpB';
  Stripe.merchantIdentifier = 'merchant.com.facesbyplaces.facesbyplaces';
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await Firebase.initializeApp();

  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  final sharedPrefs = await SharedPreferences.getInstance();
  final blmSession = sharedPrefs.getBool('blm-user-session') ?? false;
  final regularSession = sharedPrefs.getBool('regular-user-session') ?? false;

  runApp(
    RepaintBoundary(
      child: GlobalLoaderOverlay(
        useDefaultLoading: false,
        overlayWidget: const Center(child: CustomLoaderThreeDots(),),
        overlayOpacity: 0.5,
        overlayColor: Colors.white,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Faces by Places',
          home: ((){
            if(blmSession){
              return const HomeBLMScreen();
            }else if(regularSession){
              return const HomeRegularScreen();
            }else{
              return const UIGetStarted();
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
            primaryColor: const Color(0xFF000000),
            cardColor: const Color(0xffffffff),
          ),
          routes: <String, WidgetBuilder>{ // NAMED ROUTES USED FOR NAVIGATING
            '/start': (BuildContext context) => const UIGetStarted(),
            '/login': (BuildContext context) => const UILogin01(), // START

            '/blm/join': (BuildContext context) => const BLMJoin(),
            '/blm/login': (BuildContext context) => BLMLogin(),
            '/blm/register': (BuildContext context) => BLMRegister(),
            '/blm/upload-photo': (BuildContext context) => const BLMUploadPhoto(), // BLM START

            '/regular/join': (BuildContext context) => const RegularJoin(),
            '/regular/login': (BuildContext context) => const RegularLogin(),
            '/regular/register': (BuildContext context) => RegularRegister(),
            '/regular/upload-photo': (BuildContext context) => const RegularUploadPhoto(), // ALM START

            '/home/blm': (BuildContext context) => const HomeBLMScreen(),
            '/home/blm/create-post-location': (BuildContext context) => const HomeBLMCreatePostSearchLocation(),
            '/home/blm/create-memorial': (BuildContext context) => const HomeBLMCreateMemorial1(),
            '/home/blm/search': (BuildContext context) => const HomeBLMSearch(), // BLM HOME SCREEN

            '/home/regular': (BuildContext context) => const HomeRegularScreen(),
            '/home/regular/create-post-location': (BuildContext context) => const HomeRegularCreatePostSearchLocation(),
            '/home/regular/create-memorial': (BuildContext context) => const HomeRegularCreateMemorial1(),
            '/home/regular/search': (BuildContext context) => const HomeRegularSearch(), // ALM HOME SCREEN
          },
        ),
      ),
    ),
  );
}