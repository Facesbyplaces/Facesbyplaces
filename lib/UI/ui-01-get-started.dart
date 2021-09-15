import 'Home/Regular/02-View-Memorial/home-view-memorial-regular-02-profile-memorial.dart';
import 'Home/Regular/11-Show-Post/home-show-post-regular-01-show-original-post-comments.dart';
import 'Home/BLM/02-View-Memorial/home-view-memorial-blm-02-profile-memorial.dart';
import 'Home/BLM/11-Show-Post/home-show-post-blm-01-show-original-post-comments.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'Regular/regular-07-password-reset.dart';
import 'BLM/blm-07-password-reset.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'ui-02-login.dart';
import 'dart:async';

const double pi = 3.1415926535897932;

class PushNotificationService{
  final FirebaseMessaging fcm;
  final BuildContext context;

  PushNotificationService(this.fcm, this.context);

  Future initialise() async{
    String token = (await fcm.getToken())!;
    print("FirebaseMessaging token: $token");

    FirebaseMessaging.onMessage.listen((message) {
      print('Got a message whilst in the foreground!');
      print('Message data: $message');
      print('Message data: ${message.data}');
      print('Message data title: ${message.notification!.title}');
      print('Message data body: ${message.notification!.body}');
    });

    FirebaseMessaging.onMessageOpenedApp.listen((event) async{
      print('Pressed!');
      print('The message on pressed is $event');
      print('The message on pressed is ${event.data}');
      print('The message on pressed is ${event.data['dataID']}');
      print('The message on pressed is ${event.data['dataType']}');
      print('The message on pressed is ${event.notification!.title}');
      print('The message on pressed is ${event.notification!.body}');

      if(event.data['dataType'] == 'Post'){
        if(event.data['postType'] == 'Blm'){
          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMShowOriginalPostComments(postId: int.parse(event.data['dataID']))));
        }else{
          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularShowOriginalPostComments(postId: int.parse(event.data['dataID']))));
        }
      }else{
        if(event.data['dataType'] == 'Blm'){
          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMMemorialProfile(memorialId: int.parse(event.data['dataID']), pageType: event.data['dataType'], newJoin: false,)));
        }else{
          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularMemorialProfile(memorialId: int.parse(event.data['dataID']), pageType: event.data['dataType'], newJoin: false,)));
        }
      }
    });
  }
}

class UIGetStarted extends StatefulWidget{
  const UIGetStarted();

  UIGetStartedState createState() => UIGetStartedState();
}

class UIGetStartedState extends State<UIGetStarted>{
  // ignore: cancel_subscriptions
  StreamSubscription<Map>? streamSubscription;
  String token = '';

  void listenDeepLinkData(){
    print('The start of deep linking');
    streamSubscription = FlutterBranchSdk.initSession().listen((data){
      if((data.containsKey("+clicked_branch_link") && data["+clicked_branch_link"] == true) && (data.containsKey("link-category") && data["link-category"] == 'Post')){
        initUnitSharePost(postId: data['link-post-id'], likeStatus: data['link-like-status'], numberOfLikes: data['link-number-of-likes'], pageType: data['link-type-of-account']);
      }else if((data.containsKey("+clicked_branch_link") && data["+clicked_branch_link"] == true) && (data.containsKey("link-category") && data["link-category"] == 'Memorial')){
        initUnitShareMemorial(memorialId: data['link-memorial-id'], pageType: data['link-type-of-account'], follower: false);
      }else if(data.containsKey("+clicked_branch_link") && data["+clicked_branch_link"] == true){
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
    print('Shared post || User identified: $login || Post Type: $pageType');

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
    print('Shared memorial || User identified: $login || Memorial Type: $pageType');

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
    listenDeepLinkData();
  }

  @override
  void dispose(){
    streamSubscription!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    SizeConfig.init(context);
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraint){
          return SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraint.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    Container(
                      height: SizeConfig.screenHeight! / 2,
                      width: SizeConfig.screenWidth,
                      child: Stack(
                      fit: StackFit.expand,
                        children: [
                          Container(
                            child: Image.asset('assets/icons/Collage Image.png', fit: BoxFit.fill,),
                            color: const Color(0xff000000),
                          ),

                          Positioned(
                            child: Image.asset('assets/icons/logo.png', height: 200, width: 200,),
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      child: Container(
                        decoration: const BoxDecoration(image: const DecorationImage(fit: BoxFit.fill, image: const AssetImage('assets/icons/background.png'),),),
                        child: Column(
                          children: [
                            const SizedBox(height: 30),

                            const Center(child: const Text('FacesByPlaces.com', style: const TextStyle(fontSize: 28, color: const Color(0xff04ECFF), fontFamily: 'NexaBold',),),),

                            const SizedBox(height: 30),

                            Container(
                              padding: const EdgeInsets.only(left: 30, right: 30),
                              child: const Center(
                                child: const Text('Create a Memorial Page for Loved Ones by Sharing Stories, photos of Special Events & Occasions. Keeping their Memories alive for Generations',
                                  style: const TextStyle(fontSize: 22, fontFamily: 'NexaRegular', color: const Color(0xffffffff),),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),

                            const SizedBox(height: 50),

                            Expanded(child: Container(),),

                            const SizedBox(height: 50),

                            MaterialButton(
                              child: const Text('Get Started', style: TextStyle(fontSize: 24, color: const Color(0xffffffff), fontFamily: 'NexaBold',),),
                              minWidth: SizeConfig.screenWidth! / 1.5,
                              color: const Color(0xff04ECFF),
                              shape: const StadiumBorder(),
                              padding: EdgeInsets.zero,
                              height: 50,
                              onPressed: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const UILogin01()));
                              },
                            ),

                            const SizedBox(height: 50),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}