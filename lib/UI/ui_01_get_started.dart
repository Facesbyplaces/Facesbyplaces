import 'Home/Regular/02-View-Memorial/home_view_memorial_regular_02_profile_memorial.dart';
import 'Home/Regular/11-Show-Post/home_show_post_regular_01_show_original_post_comments.dart';
import 'Home/BLM/02-View-Memorial/home_view_memorial_blm_02_profile_memorial.dart';
import 'Home/BLM/11-Show-Post/home_show_post_blm_01_show_original_post_comments.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'Regular/regular_07_password_reset.dart';
import 'BLM/blm_07_password_reset.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

const double pi = 3.1415926535897932;

class PushNotificationService{
  final FirebaseMessaging fcm;
  final BuildContext context;
  PushNotificationService(this.fcm, this.context);

  Future initialise() async{
    (await fcm.getToken())!;

    FirebaseMessaging.onMessage.listen((message) {});

    FirebaseMessaging.onMessageOpenedApp.listen((event) async{
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
  const UIGetStarted({Key? key}) : super(key: key);

  @override
  UIGetStartedState createState() => UIGetStartedState();
}

class UIGetStartedState extends State<UIGetStarted>{
  // ignore: cancel_subscriptions
  StreamSubscription<Map>? streamSubscription;
  String token = '';

  void listenDeepLinkData(){
    streamSubscription = FlutterBranchSdk.initSession().listen((data){
      if((data.containsKey("+clicked_branch_link") && data["+clicked_branch_link"] == true) && (data.containsKey("link-category") && data["link-category"] == 'Post')){
        initUnitSharePost(postId: data['link-post-id'], likeStatus: data['link-like-status'], numberOfLikes: data['link-number-of-likes'], pageType: data['link-type-of-account']);
      }else if((data.containsKey("+clicked_branch_link") && data["+clicked_branch_link"] == true) && (data.containsKey("link-category") && data["link-category"] == 'Memorial')){
        initUnitShareMemorial(memorialId: data['link-memorial-id'], pageType: data['link-type-of-account'], follower: false);
      }else if(data.containsKey("+clicked_branch_link") && data["+clicked_branch_link"] == true){
        initUnit(resetType: data["reset-type"]);
      }
    },onError: (error){
      PlatformException platformException = error as PlatformException;
      throw Exception('InitSession error: ${platformException.code} - ${platformException.message}');
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

  @override
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
            physics: const ClampingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraint.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    Container(
                      color: Colors.red,
                      height: SizeConfig.screenHeight! / 2,
                      width: SizeConfig.screenWidth,
                      child: Stack(
                        children: [
                          Container(
                            height: SizeConfig.screenHeight! / 2,
                            width: SizeConfig.screenWidth,
                            child: Image.asset('assets/icons/Collage Image.png', fit: BoxFit.cover,),
                            color: const Color(0xff000000),
                          ),

                          Center(
                            child: Image.asset('assets/icons/logo.png', height: 200, width: 200,),
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      child: Container(
                        decoration: const BoxDecoration(image: DecorationImage(fit: BoxFit.fill, image: AssetImage('assets/icons/background.png'), colorFilter: ColorFilter.srgbToLinearGamma(),),),
                        child: Column(
                          children: [
                            const Center(child: Text('FacesByPlaces.com', style: TextStyle(fontSize: 28, color: Color(0xff04ECFF), fontFamily: 'NexaBold',),),),

                            const SizedBox(height: 30),

                            const Padding(
                              padding: EdgeInsets.only(left: 30, right: 30),
                              child: Center(
                                child: Text('Create a Memorial Page for Loved Ones by Sharing Stories, photos of Special Events & Occasions. Keeping their Memories alive for Generations',
                                  style: TextStyle(fontSize: 24, fontFamily: 'NexaBold', color: Color(0xffffffff),),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),

                            const SizedBox(height: 10),

                            const Expanded(child: SizedBox(),),

                            const SizedBox(height: 10),

                            MaterialButton(
                              child: const Text('Get Started', style: TextStyle(fontSize: 24, color: Color(0xffffffff), fontFamily: 'NexaBold',),),
                              minWidth: SizeConfig.screenWidth! / 1.5,
                              color: const Color(0xff04ECFF),
                              shape: const StadiumBorder(),
                              padding: EdgeInsets.zero,
                              height: 50,
                              onPressed: (){
                                Navigator.pushNamed(context, '/regular/login');
                              },
                            ),

                            const SizedBox(height: 10),

                            const Expanded(child: SizedBox(),),

                            const Text('Version: 1.74 / 1.0.0+13', style: TextStyle(fontSize: 14, color: Color(0xffffffff), fontFamily: 'NexaRegular'),),

                            const SizedBox(height: 10),
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