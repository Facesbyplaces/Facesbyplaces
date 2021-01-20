import 'dart:async';

import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter/services.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'BLM/blm-07-password-reset.dart';
import 'Home/BLM/02-View-Memorial/home-view-memorial-blm-02-profile-memorial.dart';
import 'Home/BLM/11-Show-Post/home-show-post-blm-01-show-original-post.dart';
import 'Home/Regular/02-View-Memorial/home-view-memorial-regular-02-profile-memorial.dart';
import 'Home/Regular/11-Show-Post/home-show-post-regular-01-show-original-post.dart';
import 'Miscellaneous/Start/misc-01-start-button.dart';
import 'Miscellaneous/Start/misc-02-start-background.dart';
import 'package:flutter/material.dart';

import 'Regular/regular-07-password-reset.dart';

const double pi = 3.1415926535897932;

// class UIGetStarted extends StatelessWidget {
class UIGetStarted extends StatefulWidget{
  
  UIGetStartedState createState() => UIGetStartedState();
}

class UIGetStartedState extends State<UIGetStarted>{

  StreamSubscription<Map> streamSubscription;

  void listenDeepLinkData(){
    streamSubscription = FlutterBranchSdk.initSession().listen((data) {
      if((data.containsKey("+clicked_branch_link") && data["+clicked_branch_link"] == true) && (data.containsKey("link-category") && data["link-category"] == 'Post')){
        print('The link category is ${data['link-category']}');
        print('The link category is ${data['link-post-id']}');
        print('The link category is ${data['link-like-status']}');
        print('The link category is ${data['link-number-of-likes']}');
        print('The link category is ${data['link-type-of-account']}');
        initUnitSharePost(postId: data['link-post-id'], likeStatus: data['link-like-status'], numberOfLikes: data['link-number-of-likes'], pageType: data['link-type-of-account']);
      }else if((data.containsKey("+clicked_branch_link") && data["+clicked_branch_link"] == true) && (data.containsKey("link-category") && data["link-category"] == 'Memorial')){
        print('The link category is ${data['link-category']}');
        print('The link category is ${data['link-memorial-id']}');
        print('The link category is ${data['link-type-of-account']}');
        initUnitShareMemorial(memorialId: data['link-memorial-id'], pageType: data['link-type-of-account'], follower: false);
      }else if (data.containsKey("+clicked_branch_link") && data["+clicked_branch_link"] == true){
        initUnit(resetType: data["reset-type"]);
      }
    }, onError: (error) {
      PlatformException platformException = error as PlatformException;
      print('InitSession error: ${platformException.code} - ${platformException.message}');
    });
  }

  initUnit({String resetType}) async{
    bool login = await FlutterBranchSdk.isUserIdentified();

    print('The value of isUserIdentified for login is $login');

    if(login){
      var value1 = await FlutterBranchSdk.getLatestReferringParams();
      var value2 = await FlutterBranchSdk.getFirstReferringParams();

      print('The value of getLatestReferringParams is $value1');
      print('The value of getFirstReferringParams is $value2');

      print('The token of the link is ${value1['reset_password_token']}');
      print('The reset type is $resetType');

      // print('The token is ${value1['token']}');

      // Navigator.push(context, MaterialPageRoute(builder: (context) => RegularPasswordReset()));
      if(resetType == 'Regular'){
        FlutterBranchSdk.logout();
        Navigator.push(context, MaterialPageRoute(builder: (context) => RegularPasswordReset(resetToken: value1['reset_password_token'],)));
      }else{
        Navigator.push(context, MaterialPageRoute(builder: (context) => BLMPasswordReset(resetToken: value1['reset_password_token'],)));
      }
    }
  }


  initUnitSharePost({int postId, bool likeStatus, int numberOfLikes, String pageType}) async{
    bool login = await FlutterBranchSdk.isUserIdentified();

    print('The post id is $postId');
    print('The likeStatus is $likeStatus');
    print('The post id is $numberOfLikes');
    print('The post id is $postId');

    if(login){
      FlutterBranchSdk.logout();

      if(pageType == 'Blm'){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeBLMShowOriginalPost(postId: postId, likeStatus: likeStatus, numberOfLikes: numberOfLikes,)));
      }else{
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeRegularShowOriginalPost(postId: postId, likeStatus: likeStatus, numberOfLikes: numberOfLikes,)));
      }
      
    }
  }

  initUnitShareMemorial({int memorialId, String pageType, bool follower}) async{
    bool login = await FlutterBranchSdk.isUserIdentified();

    if(login){
      FlutterBranchSdk.logout();
      // Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularMemorialProfile(memorialId: memorialId, pageType: pageType, newJoin: follower,)));

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
  void dispose() {
    streamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    ResponsiveWidgets.init(context,
      height: SizeConfig.screenHeight,
      width: SizeConfig.screenWidth,
      allowFontScaling: true,
    );
    return ResponsiveWidgets.builder(
      child: Scaffold(
        body: Stack(
          children: [

            ContainerResponsive(
              height: SizeConfig.screenHeight,
              width: SizeConfig.screenWidth,
              alignment: Alignment.center,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  MiscStartBackgroundTemplate(),

                  ContainerResponsive(
                    width: SizeConfig.screenWidth,
                    heightResponsive: false,
                    widthResponsive: true,
                    alignment: Alignment.topCenter,
                    child: Stack(
                      children: [
                        ContainerResponsive(
                          height: SizeConfig.screenHeight / 2,
                          heightResponsive: false,
                          widthResponsive: true,
                          child: Stack(
                            children: [
                              Positioned(
                                left: 0,
                                child: Transform.rotate(
                                  angle: -pi / 30,
                                  child: Container(
                                    padding: EdgeInsets.all(5),
                                    color: Color(0xffffffff),
                                    height: ScreenUtil().setHeight(100),
                                    child: Image.asset('assets/icons/frontpage-image3.png'),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: (SizeConfig.screenHeight / 2) / 4,
                                child: Transform.rotate(
                                  angle: -pi / 30,
                                  child: Container(
                                    padding: EdgeInsets.all(5),
                                    color: Color(0xffffffff),
                                    height: ScreenUtil().setHeight(100),
                                    child: Image.asset('assets/icons/frontpage-image4.png'),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: (SizeConfig.screenHeight / 2) / 4,
                                child: Container(
                                  padding: EdgeInsets.all(5),
                                  color: Color(0xffffffff),
                                  height: ScreenUtil().setHeight(100),
                                  child: Image.asset('assets/icons/frontpage-image5.png'),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                child: Container(
                                  padding: EdgeInsets.all(5),
                                  color: Color(0xffffffff),
                                  height: ScreenUtil().setHeight(100),
                                  child: Image.asset('assets/icons/frontpage-image7.png'),
                                ),
                              ),



                              Positioned(
                                left: SizeConfig.screenWidth / 7.5,
                                child: Transform.rotate(
                                  angle: pi / 30,
                                  child: Container(
                                    padding: EdgeInsets.all(5),
                                    color: Color(0xffffffff),
                                    height: ScreenUtil().setHeight(100),
                                    child: Image.asset('assets/icons/frontpage-image3.png'),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: (SizeConfig.screenHeight / 2) / 4,
                                left: SizeConfig.screenWidth / 7.5,
                                child: Transform.rotate(
                                  angle: 0,
                                  child: Container(
                                    padding: EdgeInsets.all(5),
                                    color: Color(0xffffffff),
                                    height: ScreenUtil().setHeight(100),
                                    child: Image.asset('assets/icons/frontpage-image7.png'),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: (SizeConfig.screenHeight / 2) / 4,
                                left: SizeConfig.screenWidth / 7.5,
                                child: Transform.rotate(
                                  angle: pi / 30,
                                  child: Container(
                                    padding: EdgeInsets.all(5),
                                    color: Color(0xffffffff),
                                    height: ScreenUtil().setHeight(100),
                                    child: Image.asset('assets/icons/frontpage-image4.png'),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                left: SizeConfig.screenWidth / 7.5,
                                child: Transform.rotate(
                                  angle: -pi / 80,
                                  child: Container(
                                    padding: EdgeInsets.all(5),
                                    color: Color(0xffffffff),
                                    height: ScreenUtil().setHeight(100),
                                    child: Image.asset('assets/icons/frontpage-image5.png'),
                                  ),
                                ),
                              ),

                              Positioned(
                                left: SizeConfig.screenWidth / 3.5,
                                child: Transform.rotate(
                                  angle: -pi / 30,
                                  child: Container(
                                    padding: EdgeInsets.all(5),
                                    color: Color(0xffffffff),
                                    height: ScreenUtil().setHeight(100),
                                    child: Image.asset('assets/icons/frontpage-image7.png'),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: (SizeConfig.screenHeight / 2) / 4,
                                left: SizeConfig.screenWidth / 3.5,
                                child: Transform.rotate(
                                  angle: 0,
                                  child: Container(
                                    padding: EdgeInsets.all(5),
                                    color: Color(0xffffffff),
                                    height: ScreenUtil().setHeight(100),
                                    child: Image.asset('assets/icons/frontpage-image5.png'),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: (SizeConfig.screenHeight / 2) / 4,
                                left: SizeConfig.screenWidth / 3.5,
                                child: Transform.rotate(
                                  angle: pi / 30,
                                  child: Container(
                                    padding: EdgeInsets.all(5),
                                    color: Color(0xffffffff),
                                    height: ScreenUtil().setHeight(100),
                                    child: Image.asset('assets/icons/frontpage-image3.png'),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                left: SizeConfig.screenWidth / 3.5,
                                child: Transform.rotate(
                                  angle: pi / 45,
                                  child: Container(
                                    padding: EdgeInsets.all(5),
                                    color: Color(0xffffffff),
                                    height: ScreenUtil().setHeight(100),
                                    child: Image.asset('assets/icons/frontpage-image4.png'),
                                  ),
                                ),
                              ),

                              Positioned(
                                right: SizeConfig.screenWidth / 3,
                                child: Transform.rotate(
                                  angle: -pi / 30,
                                  child: Container(
                                    padding: EdgeInsets.all(5),
                                    color: Color(0xffffffff),
                                    height: ScreenUtil().setHeight(100),
                                    child: Image.asset('assets/icons/frontpage-image4.png'),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: (SizeConfig.screenHeight / 2) / 4,
                                right: SizeConfig.screenWidth / 3,
                                child: Transform.rotate(
                                  angle: 0,
                                  child: Container(
                                    padding: EdgeInsets.all(5),
                                    color: Color(0xffffffff),
                                    height: ScreenUtil().setHeight(100),
                                    child: Image.asset('assets/icons/frontpage-image7.png'),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: (SizeConfig.screenHeight / 2) / 4,
                                right: SizeConfig.screenWidth / 3,
                                child: Transform.rotate(
                                  angle: pi / 30,
                                  child: Container(
                                    padding: EdgeInsets.all(5),
                                    color: Color(0xffffffff),
                                    height: ScreenUtil().setHeight(100),
                                    child: Image.asset('assets/icons/frontpage-image5.png'),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: SizeConfig.screenWidth / 3,
                                child: Transform.rotate(
                                  angle: pi / 50,
                                  child: Container(
                                    padding: EdgeInsets.all(5),
                                    color: Color(0xffffffff),
                                    height: ScreenUtil().setHeight(100),
                                    child: Image.asset('assets/icons/frontpage-image7.png'),
                                  ),
                                ),
                              ),

                              Positioned(
                                right: SizeConfig.screenWidth / 4.5,
                                child: Transform.rotate(
                                  angle: -pi / 30,
                                  child: Container(
                                    padding: EdgeInsets.all(5),
                                    color: Color(0xffffffff),
                                    height: ScreenUtil().setHeight(100),
                                    child: Image.asset('assets/icons/frontpage-image3.png'),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: (SizeConfig.screenHeight / 2) / 4,
                                right: SizeConfig.screenWidth / 4.5,
                                child: Transform.rotate(
                                  angle: 0,
                                  child: Container(
                                    padding: EdgeInsets.all(5),
                                    color: Color(0xffffffff),
                                    height: ScreenUtil().setHeight(100),
                                    child: Image.asset('assets/icons/frontpage-image4.png'),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: (SizeConfig.screenHeight / 2) / 4,
                                right: SizeConfig.screenWidth / 4.5,
                                child: Transform.rotate(
                                  angle: 0,
                                  child: Container(
                                    padding: EdgeInsets.all(5),
                                    color: Color(0xffffffff),
                                    height: ScreenUtil().setHeight(100),
                                    child: Image.asset('assets/icons/frontpage-image5.png'),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: SizeConfig.screenWidth / 4.5,
                                child: Transform.rotate(
                                  angle: -pi / 50,
                                  child: Container(
                                    padding: EdgeInsets.all(5),
                                    color: Color(0xffffffff),
                                    height: ScreenUtil().setHeight(100),
                                    child: Image.asset('assets/icons/frontpage-image7.png'),
                                  ),
                                ),
                              ),

                              Positioned(
                                right: SizeConfig.screenWidth / 10,
                                child: Transform.rotate(
                                  angle: -pi / 30,
                                  child: Container(
                                    padding: EdgeInsets.all(5),
                                    color: Color(0xffffffff),
                                    height: ScreenUtil().setHeight(100),
                                    child: Image.asset('assets/icons/frontpage-image7.png'),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: (SizeConfig.screenHeight / 2) / 4,
                                right: SizeConfig.screenWidth / 10,
                                child: Transform.rotate(
                                  angle: 0,
                                  child: Container(
                                    padding: EdgeInsets.all(5),
                                    color: Color(0xffffffff),
                                    height: ScreenUtil().setHeight(100),
                                    child: Image.asset('assets/icons/frontpage-image5.png'),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: (SizeConfig.screenHeight / 2) / 4,
                                right: SizeConfig.screenWidth / 10,
                                child: Transform.rotate(
                                  angle: -pi / 12,
                                  child: Container(
                                    padding: EdgeInsets.all(5),
                                    color: Color(0xffffffff),
                                    height: ScreenUtil().setHeight(100),
                                    child: Image.asset('assets/icons/frontpage-image3.png'),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: SizeConfig.screenWidth / 10,
                                child: Transform.rotate(
                                  angle: pi / 30,
                                  child: Container(
                                    padding: EdgeInsets.all(5),
                                    color: Color(0xffffffff),
                                    height: ScreenUtil().setHeight(100),
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
                                    height: ScreenUtil().setHeight(100),
                                    child: Image.asset('assets/icons/frontpage-image4.png'),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: (SizeConfig.screenHeight / 2) / 4,
                                right: -20,
                                child: Transform.rotate(
                                  angle: -pi / 30,
                                  child: Container(
                                    padding: EdgeInsets.all(5),
                                    color: Color(0xffffffff),
                                    height: ScreenUtil().setHeight(100),
                                    child: Image.asset('assets/icons/frontpage-image7.png'),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: (SizeConfig.screenHeight / 2) / 4,
                                right: -20,
                                child: Transform.rotate(
                                  angle: -pi / 12,
                                  child: Container(
                                    padding: EdgeInsets.all(5),
                                    color: Color(0xffffffff),
                                    height: ScreenUtil().setHeight(100),
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
                                    padding: EdgeInsets.all(5),
                                    color: Color(0xffffffff),
                                    height: ScreenUtil().setHeight(100),
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
                                height: SizeConfig.screenHeight / 2,
                                child: Image.asset('assets/icons/logo.png', height: 200, width: 200,),
                              ),

                              Expanded(
                                child: Column(
                                  children: [

                                    Expanded(child: Container(),),

                                    Center(child: Text('FacesByPlaces.com', style: TextStyle(fontSize: ScreenUtil().setSp(20, allowFontScalingSelf: true), fontWeight: FontWeight.bold, color: Color(0xff04ECFF),),),),

                                    SizedBox(height: ScreenUtil().setHeight(20)),

                                    Padding(
                                      padding: EdgeInsets.only(left: 20.0, right: 20.0),
                                      child: Center(
                                        child: Text('Create a Memorial Page for Loved Ones by Sharing Stories, photos of Special Events & Occasions. Keeping their Memories alive for Generations', 
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: ScreenUtil().setSp(16, allowFontScalingSelf: true),
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
                                        fontSize: ScreenUtil().setSp(14, allowFontScalingSelf: true),
                                        fontWeight: FontWeight.bold, 
                                        color: Color(0xffffffff),
                                      ), 
                                      onPressed: (){
                                        Navigator.pushNamed(context, '/login');
                                      }, 
                                      width: ScreenUtil().setWidth(200),
                                      height: ScreenUtil().setHeight(45),
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
                  ),
                ],
              ),
            ),
            
          ],
        ),
      ),
    );
  }
}