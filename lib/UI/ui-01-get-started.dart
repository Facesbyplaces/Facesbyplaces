import 'Home/Regular/02-View-Memorial/home-view-memorial-regular-02-profile-memorial.dart';
import 'Home/Regular/11-Show-Post/home-show-post-regular-01-show-original-post-comments.dart';
import 'Home/BLM/02-View-Memorial/home-view-memorial-blm-02-profile-memorial.dart';
import 'Home/BLM/11-Show-Post/home-show-post-blm-01-show-original-post-comments.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Miscellaneous/Start/misc-01-image-regular.dart';
import 'Regular/regular-07-password-reset.dart';
import 'BLM/blm-07-password-reset.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:io';

import 'ui-02-login.dart';

const double pi = 3.1415926535897932;

class PushNotificationService {
  final FirebaseMessaging fcm;

  PushNotificationService(this.fcm);

  Future initialise() async {
    if (Platform.isIOS) {
      fcm.requestPermission();
    }

    String token = (await fcm.getToken())!;
    print("FirebaseMessaging token: $token");

    NotificationSettings settings = await fcm.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');

    fcm.getInitialMessage();

    FirebaseMessaging.onMessage.listen((message) {
      print('Got a message whilst in the foreground!');
      print('Message data: $message');
      print('Message data: ${message.data}');
      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });

    Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
      await Firebase.initializeApp();
      print("Handling a background message: ${message.messageId}");
    }

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      print('Pressed!');
      print('The message on pressed is ${event.data}');
      print('The message on pressed is $event');
    });
  }
}

class UIGetStarted extends StatefulWidget{
  const UIGetStarted();
  
  UIGetStartedState createState() => UIGetStartedState();
}

class UIGetStartedState extends State<UIGetStarted>{

  StreamSubscription<Map>? streamSubscription;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  void listenDeepLinkData(){
    print('The start of deep linking');
    streamSubscription = FlutterBranchSdk.initSession().listen((data) {
      if((data.containsKey("+clicked_branch_link") && data["+clicked_branch_link"] == true) && (data.containsKey("link-category") && data["link-category"] == 'Post')){
        initUnitSharePost(postId: data['link-post-id'], likeStatus: data['link-like-status'], numberOfLikes: data['link-number-of-likes'], pageType: data['link-type-of-account']);
      }else if((data.containsKey("+clicked_branch_link") && data["+clicked_branch_link"] == true) && (data.containsKey("link-category") && data["link-category"] == 'Memorial')){
        initUnitShareMemorial(memorialId: data['link-memorial-id'], pageType: data['link-type-of-account'], follower: false);
      }else if (data.containsKey("+clicked_branch_link") && data["+clicked_branch_link"] == true){
        initUnit(resetType: data["reset-type"]);
      }
    }, onError: (error) {
      PlatformException platformException = error as PlatformException;
      print('InitSession error: ${platformException.code} - ${platformException.message}');
    });
  }

  initUnit({required String resetType}) async{
    bool login = await FlutterBranchSdk.isUserIdentified();

    if(login){
      var value1 = await FlutterBranchSdk.getLatestReferringParams();

      if(resetType == 'Regular'){
        Navigator.push(context, MaterialPageRoute(builder: (context) => RegularPasswordReset(resetToken: value1['reset_password_token'],)));
      }else{
        Navigator.push(context, MaterialPageRoute(builder: (context) => BLMPasswordReset(resetToken: value1['reset_password_token'],)));
      }
    }
  }


  initUnitSharePost({required int postId, required bool likeStatus, required int numberOfLikes, required String pageType}) async{
    bool login = await FlutterBranchSdk.isUserIdentified();

    if(login){
      FlutterBranchSdk.logout();

      if(pageType == 'Blm'){
        Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMShowOriginalPostComments(postId: postId)));
      }else{
        Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularShowOriginalPostComments(postId: postId)));
      }
    }
  }

  initUnitShareMemorial({required int memorialId, required String pageType, required bool follower}) async{
    bool login = await FlutterBranchSdk.isUserIdentified();

    if(login){
      FlutterBranchSdk.logout();
      if(pageType == 'Blm'){
        Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMMemorialProfile(memorialId: memorialId, pageType: pageType, newJoin: follower,)));
      }else{
        Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularMemorialProfile(memorialId: memorialId, pageType: pageType, newJoin: follower,)));
      }
    }
  }

  void initState(){
    super.initState();
    var newMessage = PushNotificationService(_firebaseMessaging);
    newMessage.initialise();
    listenDeepLinkData();
  }

  @override
  void dispose() {
    streamSubscription!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return RepaintBoundary(
      child: Scaffold(
        body: Container(
          height: SizeConfig.screenHeight,
          child: Stack(
            children: [

              Stack(
                alignment: Alignment.topCenter,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      image: const DecorationImage(
                        fit: BoxFit.cover,
                        image: const AssetImage('assets/icons/background.png'),
                        colorFilter: const ColorFilter.srgbToLinearGamma(),
                      ),
                    ),
                  ),

                  Stack(
                    children: [
                      Container(
                        height: SizeConfig.screenHeight! / 2,
                        child: Stack(
                          children: [
                            Positioned(
                              left: 0,
                              child: Transform.rotate(
                                angle: -pi / 30,
                                child: const MiscStartImageRegularTemplate(),
                              ),
                            ),
                            Positioned(
                              top: (SizeConfig.screenHeight! / 2) / 4,
                              child: Transform.rotate(
                                angle: -pi / 30,
                                child: const MiscStartImageRegularTemplate(image: 'assets/icons/frontpage-image4.png'),
                              ),
                            ),
                            Positioned(
                              bottom: (SizeConfig.screenHeight! / 2) / 4,
                              child: const MiscStartImageRegularTemplate(image: 'assets/icons/frontpage-image5.png'),
                            ),
                            Positioned(
                              bottom: 0,
                              child: const MiscStartImageRegularTemplate(image: 'assets/icons/frontpage-image7.png'),
                            ),


                            Positioned(
                              left: SizeConfig.screenWidth! / 7.5,
                              child: Transform.rotate(
                                angle: pi / 30,
                                child: const MiscStartImageRegularTemplate(),
                              ),
                            ),
                            Positioned(
                              top: (SizeConfig.screenHeight! / 2) / 4,
                              left: SizeConfig.screenWidth! / 7.5,
                              child: Transform.rotate(
                                angle: 0,
                                child: const MiscStartImageRegularTemplate(image: 'assets/icons/frontpage-image7.png'),
                              ),
                            ),
                            Positioned(
                              bottom: (SizeConfig.screenHeight! / 2) / 4,
                              left: SizeConfig.screenWidth! / 7.5,
                              child: Transform.rotate(
                                angle: pi / 30,
                                child: const MiscStartImageRegularTemplate(image: 'assets/icons/frontpage-image4.png'),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: SizeConfig.screenWidth! / 7.5,
                              child: Transform.rotate(
                                angle: -pi / 80,
                                child: const MiscStartImageRegularTemplate(image: 'assets/icons/frontpage-image5.png'),
                              ),
                            ),


                            Positioned(
                              left: SizeConfig.screenWidth! / 3.5,
                              child: Transform.rotate(
                                angle: -pi / 30,
                                child: const MiscStartImageRegularTemplate(image: 'assets/icons/frontpage-image7.png'),
                              ),
                            ),
                            Positioned(
                              top: (SizeConfig.screenHeight! / 2) / 4,
                              left: SizeConfig.screenWidth! / 3.5,
                              child: Transform.rotate(
                                angle: 0,
                                child: const MiscStartImageRegularTemplate(image: 'assets/icons/frontpage-image5.png'),
                              ),
                            ),
                            Positioned(
                              bottom: (SizeConfig.screenHeight! / 2) / 4,
                              left: SizeConfig.screenWidth! / 3.5,
                              child: Transform.rotate(
                                angle: pi / 30,
                                child: const MiscStartImageRegularTemplate(),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: SizeConfig.screenWidth! / 3.5,
                              child: Transform.rotate(
                                angle: pi / 45,
                                child: const MiscStartImageRegularTemplate(image: 'assets/icons/frontpage-image4.png'),
                              ),
                            ),


                            Positioned(
                              right: SizeConfig.screenWidth! / 3,
                              child: Transform.rotate(
                                angle: -pi / 30,
                                child: const MiscStartImageRegularTemplate(image: 'assets/icons/frontpage-image4.png'),
                              ),
                            ),
                            Positioned(
                              top: (SizeConfig.screenHeight! / 2) / 4,
                              right: SizeConfig.screenWidth! / 3,
                              child: Transform.rotate(
                                angle: 0,
                                child: const MiscStartImageRegularTemplate(image: 'assets/icons/frontpage-image7.png'),
                              ),
                            ),
                            Positioned(
                              bottom: (SizeConfig.screenHeight! / 2) / 4,
                              right: SizeConfig.screenWidth! / 3,
                              child: Transform.rotate(
                                angle: pi / 30,
                                child: const MiscStartImageRegularTemplate(image: 'assets/icons/frontpage-image5.png'),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: SizeConfig.screenWidth! / 3,
                              child: Transform.rotate(
                                angle: pi / 50,
                                child: const MiscStartImageRegularTemplate(image: 'assets/icons/frontpage-image7.png'),
                              ),
                            ),


                            Positioned(
                              right: SizeConfig.screenWidth! / 4.5,
                              child: Transform.rotate(
                                angle: -pi / 30,
                                child: const MiscStartImageRegularTemplate(),
                              ),
                            ),
                            Positioned(
                              top: (SizeConfig.screenHeight! / 2) / 4,
                              right: SizeConfig.screenWidth! / 4.5,
                              child: Transform.rotate(
                                angle: 0,
                                child: const MiscStartImageRegularTemplate(image: 'assets/icons/frontpage-image4.png'),
                              ),
                            ),
                            Positioned(
                              bottom: (SizeConfig.screenHeight! / 2) / 4,
                              right: SizeConfig.screenWidth! / 4.5,
                              child: Transform.rotate(
                                angle: 0,
                                child: const MiscStartImageRegularTemplate(image: 'assets/icons/frontpage-image5.png'),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: SizeConfig.screenWidth! / 4.5,
                              child: Transform.rotate(
                                angle: -pi / 50,
                                child: const MiscStartImageRegularTemplate(image: 'assets/icons/frontpage-image7.png'),
                              ),
                            ),


                            Positioned(
                              right: SizeConfig.screenWidth! / 10,
                              child: Transform.rotate(
                                angle: -pi / 30,
                                child: const MiscStartImageRegularTemplate(image: 'assets/icons/frontpage-image7.png'),
                              ),
                            ),
                            Positioned(
                              top: (SizeConfig.screenHeight! / 2) / 4,
                              right: SizeConfig.screenWidth! / 10,
                              child: Transform.rotate(
                                angle: 0,
                                child: const MiscStartImageRegularTemplate(image: 'assets/icons/frontpage-image5.png'),
                              ),
                            ),
                            Positioned(
                              bottom: (SizeConfig.screenHeight! / 2) / 4,
                              right: SizeConfig.screenWidth! / 10,
                              child: Transform.rotate(
                                angle: -pi / 12,
                                child: const MiscStartImageRegularTemplate(),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: SizeConfig.screenWidth! / 10,
                              child: Transform.rotate(
                                angle: pi / 30,
                                child: const MiscStartImageRegularTemplate(image: 'assets/icons/frontpage-image4.png'),
                              ),
                            ),


                            Positioned(
                              right: -20,
                              child: Transform.rotate(
                                angle: 0,
                                child: const MiscStartImageRegularTemplate(image: 'assets/icons/frontpage-image4.png'),
                              ),
                            ),
                            Positioned(
                              top: (SizeConfig.screenHeight! / 2) / 4,
                              right: -20,
                              child: Transform.rotate(
                                angle: -pi / 30,
                                child: const MiscStartImageRegularTemplate(image: 'assets/icons/frontpage-image7.png'),
                              ),
                            ),
                            Positioned(
                              bottom: (SizeConfig.screenHeight! / 2) / 4,
                              right: -20,
                              child: Transform.rotate(
                                angle: -pi / 12,
                                child: const MiscStartImageRegularTemplate(image: 'assets/icons/frontpage-image4.png'),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: -20,
                              child: Transform.rotate(
                                angle: 0,
                                child: const MiscStartImageRegularTemplate(image: 'assets/icons/frontpage-image5.png'),
                              ),
                            ),

                          ],
                        ),
                      ),

                      Column(
                        children: [

                          Container(
                            height: SizeConfig.screenHeight! / 2,
                            child: Image.asset('assets/icons/logo.png', height: 200, width: 200,),
                          ),

                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [

                                const Center(child: const Text('FacesByPlaces.com', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xff04ECFF),),),),

                                const SizedBox(height: 20),

                                Padding(
                                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                                  child: const Center(
                                    child: const Text('Create a Memorial Page for Loved Ones by Sharing Stories, photos of Special Events & Occasions. Keeping their Memories alive for Generations', 
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'Roboto',
                                        color: const Color(0xffffffff),
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 50),

                                MaterialButton(
                                  padding: EdgeInsets.zero,
                                  child: const Text('Get Started', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xffffffff),),),
                                  minWidth: 200,
                                  height: 45,
                                  shape: const StadiumBorder(),
                                  color: const Color(0xff04ECFF),
                                  onPressed: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const UILogin01()));
                                  },
                                ),

                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}