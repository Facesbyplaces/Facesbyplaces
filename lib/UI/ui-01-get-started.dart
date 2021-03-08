import 'package:facesbyplaces/API/Regular/01-Start/api-start-regular-11-push-notifications.dart';

import 'Home/Regular/02-View-Memorial/home-view-memorial-regular-02-profile-memorial.dart';
import 'Home/Regular/11-Show-Post/home-show-post-regular-01-show-original-post-comments.dart';
import 'Home/BLM/02-View-Memorial/home-view-memorial-blm-02-profile-memorial.dart';
import 'Home/BLM/11-Show-Post/home-show-post-blm-01-show-original-post-comments.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'Miscellaneous/Start/misc-01-start-button.dart';
import 'Miscellaneous/Start/misc-02-start-background.dart';
import 'package:overlay_support/overlay_support.dart';
import 'Regular/regular-07-password-reset.dart';
import 'BLM/blm-07-password-reset.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:io';

const double pi = 3.1415926535897932;

class PushNotificationService {
  final FirebaseMessaging fcm;

  PushNotificationService(this.fcm);

  Future initialise() async {
    if (Platform.isIOS) {
      // fcm.requestNotificationPermissions(IosNotificationSettings());
      fcm.requestPermission();
    }

    // String token = await fcm.getToken();
    String token = (await fcm.getToken())!;
    print("FirebaseMessaging token: $token");

    // bool newResult = await apiRegularNewNotifications(deviceToken: token, title: 'Sample title - FacesbyPlaces', body: 'Sample body - FacesbyPlaces');

    // print('The notification result is $newResult');

    // fcm.configure(
    //   onMessage: (Map<String, dynamic> message) async {
    //     print("onMessage notification: $message");
    //     showSimpleNotification(
    //       Container(child: Text(message['notification']['body'])),
    //       position: NotificationPosition.top,
    //     );
    //   },
    //   onLaunch: (Map<String, dynamic> message) async {
    //     print("onLaunch notification: $message");
    //     showSimpleNotification(
    //       Container(child: Text(message['notification']['body'])),
    //       position: NotificationPosition.top,
    //     );
    //   },
    //   onResume: (Map<String, dynamic> message) async {
    //     print("onResume notification: $message");
    //     showSimpleNotification(
    //       Container(child: Text(message['notification']['body'])),
    //       position: NotificationPosition.top,
    //     );
    //   },
    // );
  }
}

class UIGetStarted extends StatefulWidget{
  
  UIGetStartedState createState() => UIGetStartedState();
}

class UIGetStartedState extends State<UIGetStarted>{

  StreamSubscription<Map>? streamSubscription;
  static final FirebaseMessaging _firebaseMessaging = firebaseMessaging;
  final pushNotificationService = PushNotificationService(_firebaseMessaging);

  void listenDeepLinkData(){
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
        FlutterBranchSdk.logout();
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
    pushNotificationService.initialise();
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
    return Scaffold(
      body: Container(
        height: SizeConfig.screenHeight,
        child: Stack(
          children: [

            Stack(
              alignment: Alignment.topCenter,
              children: [
                MiscStartBackgroundTemplate(),

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
                              child: Container(
                                padding: EdgeInsets.all(5),
                                color: Color(0xffffffff),
                                height: 100,
                                width: 100,
                                child: Image.asset('assets/icons/frontpage-image3.png'),
                              ),
                            ),
                          ),
                          Positioned(
                            top: (SizeConfig.screenHeight! / 2) / 4,
                            child: Transform.rotate(
                              angle: -pi / 30,
                              child: Container(
                                padding: EdgeInsets.all(5),
                                color: Color(0xffffffff),
                                height: 100,
                                width: 100,
                                child: Image.asset('assets/icons/frontpage-image4.png'),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: (SizeConfig.screenHeight! / 2) / 4,
                            child: Container(
                              padding: EdgeInsets.all(5),
                              color: Color(0xffffffff),
                              height: 100,
                              width: 100,
                              child: Image.asset('assets/icons/frontpage-image5.png'),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            child: Container(
                              padding: EdgeInsets.all(5),
                              color: Color(0xffffffff),
                              height: 100,
                              width: 100,
                              child: Image.asset('assets/icons/frontpage-image7.png'),
                            ),
                          ),


                          Positioned(
                            left: SizeConfig.screenWidth! / 7.5,
                            child: Transform.rotate(
                              angle: pi / 30,
                              child: Container(
                                color: Color(0xffffffff),
                                height: 100,
                                width: 100,
                                child: Image.asset('assets/icons/frontpage-image3.png',),
                              ),
                            ),
                          ),
                          Positioned(
                            top: (SizeConfig.screenHeight! / 2) / 4,
                            left: SizeConfig.screenWidth! / 7.5,
                            child: Transform.rotate(
                              angle: 0,
                              child: Container(
                                padding: EdgeInsets.all(5),
                                color: Color(0xffffffff),
                                height: 100,
                                width: 100,
                                child: Image.asset('assets/icons/frontpage-image7.png'),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: (SizeConfig.screenHeight! / 2) / 4,
                            left: SizeConfig.screenWidth! / 7.5,
                            child: Transform.rotate(
                              angle: pi / 30,
                              child: Container(
                                padding: EdgeInsets.all(5),
                                color: Color(0xffffffff),
                                height: 100,
                                width: 100,
                                child: Image.asset('assets/icons/frontpage-image4.png'),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: SizeConfig.screenWidth! / 7.5,
                            child: Transform.rotate(
                              angle: -pi / 80,
                              child: Container(
                                padding: EdgeInsets.all(5),
                                color: Color(0xffffffff),
                                height: 100,
                                width: 100,
                                child: Image.asset('assets/icons/frontpage-image5.png'),
                              ),
                            ),
                          ),


                          Positioned(
                            left: SizeConfig.screenWidth! / 3.5,
                            child: Transform.rotate(
                              angle: -pi / 30,
                              child: Container(
                                padding: EdgeInsets.all(5),
                                color: Color(0xffffffff),
                                height: 100,
                                width: 100,
                                child: Image.asset('assets/icons/frontpage-image7.png'),
                              ),
                            ),
                          ),
                          Positioned(
                            top: (SizeConfig.screenHeight! / 2) / 4,
                            left: SizeConfig.screenWidth! / 3.5,
                            child: Transform.rotate(
                              angle: 0,
                              child: Container(
                                padding: EdgeInsets.all(5),
                                color: Color(0xffffffff),
                                height: 100,
                                width: 100,
                                child: Image.asset('assets/icons/frontpage-image5.png'),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: (SizeConfig.screenHeight! / 2) / 4,
                            left: SizeConfig.screenWidth! / 3.5,
                            child: Transform.rotate(
                              angle: pi / 30,
                              child: Container(
                                padding: EdgeInsets.all(5),
                                color: Color(0xffffffff),
                                height: 100,
                                width: 100,
                                child: Image.asset('assets/icons/frontpage-image3.png'),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: SizeConfig.screenWidth! / 3.5,
                            child: Transform.rotate(
                              angle: pi / 45,
                              child: Container(
                                padding: EdgeInsets.all(5),
                                color: Color(0xffffffff),
                                height: 100,
                                width: 100,
                                child: Image.asset('assets/icons/frontpage-image4.png'),
                              ),
                            ),
                          ),


                          Positioned(
                            right: SizeConfig.screenWidth! / 3,
                            child: Transform.rotate(
                              angle: -pi / 30,
                              child: Container(
                                padding: EdgeInsets.all(5),
                                color: Color(0xffffffff),
                                height: 100,
                                width: 100,
                                child: Image.asset('assets/icons/frontpage-image4.png'),
                              ),
                            ),
                          ),
                          Positioned(
                            top: (SizeConfig.screenHeight! / 2) / 4,
                            right: SizeConfig.screenWidth! / 3,
                            child: Transform.rotate(
                              angle: 0,
                              child: Container(
                                padding: EdgeInsets.all(5),
                                color: Color(0xffffffff),
                                height: 100,
                                width: 100,
                                child: Image.asset('assets/icons/frontpage-image7.png'),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: (SizeConfig.screenHeight! / 2) / 4,
                            right: SizeConfig.screenWidth! / 3,
                            child: Transform.rotate(
                              angle: pi / 30,
                              child: Container(
                                padding: EdgeInsets.all(5),
                                color: Color(0xffffffff),
                                height: 100,
                                width: 100,
                                child: Image.asset('assets/icons/frontpage-image5.png'),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: SizeConfig.screenWidth! / 3,
                            child: Transform.rotate(
                              angle: pi / 50,
                              child: Container(
                                padding: EdgeInsets.all(5),
                                color: Color(0xffffffff),
                                height: 100,
                                width: 100,
                                child: Image.asset('assets/icons/frontpage-image7.png'),
                              ),
                            ),
                          ),


                          Positioned(
                            right: SizeConfig.screenWidth! / 4.5,
                            child: Transform.rotate(
                              angle: -pi / 30,
                              child: Container(
                                padding: EdgeInsets.all(5),
                                color: Color(0xffffffff),
                                height: 100,
                                width: 100,
                                child: Image.asset('assets/icons/frontpage-image3.png'),
                              ),
                            ),
                          ),
                          Positioned(
                            top: (SizeConfig.screenHeight! / 2) / 4,
                            right: SizeConfig.screenWidth! / 4.5,
                            child: Transform.rotate(
                              angle: 0,
                              child: Container(
                                padding: EdgeInsets.all(5),
                                color: Color(0xffffffff),
                                height: 100,
                                width: 100,
                                child: Image.asset('assets/icons/frontpage-image4.png'),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: (SizeConfig.screenHeight! / 2) / 4,
                            right: SizeConfig.screenWidth! / 4.5,
                            child: Transform.rotate(
                              angle: 0,
                              child: Container(
                                padding: EdgeInsets.all(5),
                                color: Color(0xffffffff),
                                height: 100,
                                width: 100,
                                child: Image.asset('assets/icons/frontpage-image5.png'),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: SizeConfig.screenWidth! / 4.5,
                            child: Transform.rotate(
                              angle: -pi / 50,
                              child: Container(
                                padding: EdgeInsets.all(5),
                                color: Color(0xffffffff),
                                height: 100,
                                width: 100,
                                child: Image.asset('assets/icons/frontpage-image7.png'),
                              ),
                            ),
                          ),


                          Positioned(
                            right: SizeConfig.screenWidth! / 10,
                            child: Transform.rotate(
                              angle: -pi / 30,
                              child: Container(
                                padding: EdgeInsets.all(5),
                                color: Color(0xffffffff),
                                height: 100,
                                width: 100,
                                child: Image.asset('assets/icons/frontpage-image7.png'),
                              ),
                            ),
                          ),
                          Positioned(
                            top: (SizeConfig.screenHeight! / 2) / 4,
                            right: SizeConfig.screenWidth! / 10,
                            child: Transform.rotate(
                              angle: 0,
                              child: Container(
                                padding: EdgeInsets.all(5),
                                color: Color(0xffffffff),
                                height: 100,
                                width: 100,
                                child: Image.asset('assets/icons/frontpage-image5.png'),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: (SizeConfig.screenHeight! / 2) / 4,
                            right: SizeConfig.screenWidth! / 10,
                            child: Transform.rotate(
                              angle: -pi / 12,
                              child: Container(
                                padding: EdgeInsets.all(5),
                                color: Color(0xffffffff),
                                height: 100,
                                width: 100,
                                child: Image.asset('assets/icons/frontpage-image3.png'),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: SizeConfig.screenWidth! / 10,
                            child: Transform.rotate(
                              angle: pi / 30,
                              child: Container(
                                padding: EdgeInsets.all(5),
                                color: Color(0xffffffff),
                                height: 100,
                                width: 100,
                                child: Image.asset('assets/icons/frontpage-image4.png'),
                              ),
                            ),
                          ),


                          Positioned(
                            right: -20,
                            child: Transform.rotate(
                              angle: 0,
                              child: Container(
                                padding: EdgeInsets.all(5),
                                color: Color(0xffffffff),
                                height: 100,
                                width: 100,
                                child: Image.asset('assets/icons/frontpage-image4.png'),
                              ),
                            ),
                          ),
                          Positioned(
                            top: (SizeConfig.screenHeight! / 2) / 4,
                            right: -20,
                            child: Transform.rotate(
                              angle: -pi / 30,
                              child: Container(
                                padding: EdgeInsets.all(5),
                                color: Color(0xffffffff),
                                height: 100,
                                width: 100,
                                child: Image.asset('assets/icons/frontpage-image7.png'),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: (SizeConfig.screenHeight! / 2) / 4,
                            right: -20,
                            child: Transform.rotate(
                              angle: -pi / 12,
                              child: Container(
                                color: Color(0xffffffff),
                                height: 100,
                                width: 100,
                                child: Image.asset('assets/icons/frontpage-image4.png'),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: -20,
                            child: Transform.rotate(
                              angle: 0,
                              child: Container(
                                color: Color(0xffffffff),
                                height: 100,
                                width: 100,
                                child: Image.asset('assets/icons/frontpage-image5.png'),
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),

                    Container(
                      child: Column(
                        children: [

                          Container(
                            height: SizeConfig.screenHeight! / 2,
                            child: Image.asset('assets/icons/logo.png', height: 200, width: 200,),
                          ),

                          Expanded(
                            child: Column(
                              children: [

                                Expanded(child: Container(),),

                                Center(child: Text('FacesByPlaces.com', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xff04ECFF),),),),

                                SizedBox(height: 20),

                                Padding(
                                  padding: EdgeInsets.only(left: 20.0, right: 20.0),
                                  child: Center(
                                    child: Text('Create a Memorial Page for Loved Ones by Sharing Stories, photos of Special Events & Occasions. Keeping their Memories alive for Generations', 
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'Roboto',
                                        color: Color(0xffffffff),
                                      ),
                                    ),
                                  ),
                                ),

                                Expanded(child: Container(),),

                                MiscStartButtonTemplate(
                                  buttonText: 'Get Started', 
                                  buttonTextStyle: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold, 
                                    color: Color(0xffffffff),
                                  ), 
                                  onPressed: (){
                                    Navigator.pushNamed(context, '/login');
                                  },
                                  width: 200,
                                  height: 45,
                                  buttonColor: Color(0xff04ECFF),
                                ),

                                Expanded(child: Container(),),

                              ],
                            ),
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
      ),
    );
  }
}