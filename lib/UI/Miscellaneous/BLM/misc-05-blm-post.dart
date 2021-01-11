import 'package:facesbyplaces/API/BLM/12-Show-Post/api-show-post-blm-02-post-like-or-unlike.dart';
import 'package:facesbyplaces/UI/Home/BLM/02-View-Memorial/home-view-memorial-blm-01-managed-memorial.dart';
import 'package:facesbyplaces/UI/Home/BLM/02-View-Memorial/home-view-memorial-blm-02-profile-memorial.dart';
import 'package:facesbyplaces/UI/Home/BLM/09-Settings-User/home-settings-user-02-user-update-details.dart';
import 'package:facesbyplaces/UI/Home/BLM/09-Settings-User/home-settings-user-03-change-password.dart';
import 'package:facesbyplaces/API/BLM/10-Settings-User/api-settings-user-blm-11-show-other-details-status.dart';
import 'package:facesbyplaces/UI/Home/BLM/09-Settings-User/home-settings-user-04-other-details.dart';
import 'package:facesbyplaces/UI/Home/BLM/11-Show-Post/home-show-post-blm-01-show-original-post.dart';
import 'package:facesbyplaces/UI/Home/BLM/11-Show-Post/home-show-post-blm-02-view-comments.dart';
import 'package:facesbyplaces/UI/Home/BLM/12-Show-User/home-show-user-blm-01-blm-user.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter/material.dart';
import '../../ui-01-get-started.dart';
import 'misc-02-blm-dialog.dart';
import 'misc-04-blm-extra.dart';
import 'misc-07-blm-button.dart';
import 'misc-15-blm-dropdown.dart';


class MiscBLMUserProfileDetailsDraggable extends StatefulWidget {
  final int userId;
  MiscBLMUserProfileDetailsDraggable({this.userId});

  @override
  MiscBLMUserProfileDetailsDraggableState createState() => MiscBLMUserProfileDetailsDraggableState(userId: userId);
}

class MiscBLMUserProfileDetailsDraggableState extends State<MiscBLMUserProfileDetailsDraggable> {
  final int userId;
  MiscBLMUserProfileDetailsDraggableState({this.userId});

  double height;
  Offset position;
  int currentIndex = 0;
  List<Widget> children;

  @override
  void initState(){
    super.initState();
    height = SizeConfig.screenHeight;
    position = Offset(0.0, height - 100);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: Draggable(
        feedback: draggable(),
        onDraggableCanceled: (Velocity velocity, Offset offset){
          if(offset.dy > 10 && offset.dy < (SizeConfig.screenHeight - 100)){
            setState(() {
              position = offset;
            });
          }
        },
        child: draggable(),
        childWhenDragging: Container(),
        axis: Axis.vertical,
      ),
    );
  }

  draggable(){
    return Material(
      color: Colors.transparent,
      child: Container(
        width: SizeConfig.screenWidth,
        height: SizeConfig.screenHeight,
        padding: EdgeInsets.only(left: 20.0, right: 20.0),
        decoration: BoxDecoration(
          color: Color(0xffffffff),
          borderRadius: BorderRadius.only(topLeft: Radius.circular(100)),
        ),
        child: Column(
          children: [

            SizedBox(height: SizeConfig.blockSizeVertical * 10,),

            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMUserUpdateDetails(userId: userId,)));
              },
              child: Container(
                height: SizeConfig.blockSizeVertical * 10,
                color: Color(0xffffffff),
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                child: Column(
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Text('Update Details',
                          style: TextStyle(
                            fontSize: SizeConfig.safeBlockHorizontal * 4,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff000000),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: SizeConfig.blockSizeVertical * 1,),

                    Expanded(
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text('Update your account details',
                          style: TextStyle(
                            fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                            fontWeight: FontWeight.w300,
                            color: Color(0xffBDC3C7),
                          ),
                        ),
                      ),
                    ),

                    Divider(height: SizeConfig.blockSizeVertical * 2, color: Color(0xff888888),)
                  ],
                ),
              ),
            ),

            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMUserChangePassword(userId: userId,)));
              },
              child: Container(
                height: SizeConfig.blockSizeVertical * 10,
                color: Color(0xffffffff),
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                child: Column(
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Text('Password',
                          style: TextStyle(
                            fontSize: SizeConfig.safeBlockHorizontal * 4,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff000000),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: SizeConfig.blockSizeVertical * 1,),

                    Expanded(
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text('Change your login password',
                          style: TextStyle(
                            fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                            fontWeight: FontWeight.w300,
                            color: Color(0xffBDC3C7),
                          ),
                        ),
                      ),
                    ),

                    Divider(height: SizeConfig.blockSizeVertical * 2, color: Color(0xff888888),)
                  ],
                ),
              ),
            ),

            GestureDetector(
              onTap: () async{
                context.showLoaderOverlay();
                APIBLMShowOtherDetailsStatus result = await apiBLMShowOtherDetailsStatus(userId: userId);
                context.hideLoaderOverlay();

                Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMUserOtherDetails(userId: userId, toggleBirthdate: result.hideBirthdate, toggleBirthplace: result.hideBirthplace, toggleAddress: result.hideAddress, toggleEmail: result.hideEmail, toggleNumber: result.hidePhoneNumber)));
              },
              child: Container(
                height: SizeConfig.blockSizeVertical * 10,
                color: Color(0xffffffff),
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                child: Column(
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Text('Other Info',
                          style: TextStyle(
                            fontSize: SizeConfig.safeBlockHorizontal * 4,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff000000),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: SizeConfig.blockSizeVertical * 1,),

                    Expanded(
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text('Optional informations you can share',
                          style: TextStyle(
                            fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                            fontWeight: FontWeight.w300,
                            color: Color(0xffBDC3C7),
                          ),
                        ),
                      ),
                    ),

                    Divider(height: SizeConfig.blockSizeVertical * 2, color: Color(0xff888888),)
                  ],
                ),
              ),
            ),

            Container(
              height: SizeConfig.blockSizeVertical * 10,
              color: Color(0xffffffff),
              padding: EdgeInsets.only(left: 20.0, right: 20.0),
              child: Column(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text('Privacy Settings',
                        style: TextStyle(
                          fontSize: SizeConfig.safeBlockHorizontal * 4,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff000000),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: SizeConfig.blockSizeVertical * 1,),

                  Expanded(
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text('Control what others see',
                        style: TextStyle(
                          fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                          fontWeight: FontWeight.w300,
                          color: Color(0xffBDC3C7),
                        ),
                      ),
                    ),
                  ),

                  Divider(height: SizeConfig.blockSizeVertical * 2, color: Color(0xff888888),),
                ]
              ),
            ),

            Expanded(child: Container(),),

            MiscBLMButtonTemplate(
              buttonText: 'Logout',
              buttonTextStyle: TextStyle(
                fontSize: SizeConfig.safeBlockHorizontal * 5, 
                fontWeight: FontWeight.bold, 
                color: Color(0xffffffff),
              ), 
              onPressed: () async{

                bool logoutResult = await showDialog(context: (context), builder: (build) => MiscBLMConfirmDialog(title: 'Log out', content: 'Are you sure you want to log out from this account?', confirmColor_1: Color(0xff000000), confirmColor_2: Color(0xff888888),));

                if(logoutResult){
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => UIGetStarted()), (route) => false);
                }

              }, 
              width: SizeConfig.screenWidth / 2, 
              height: SizeConfig.blockSizeVertical * 7, 
              buttonColor: Color(0xff04ECFF),
            ),

            SizedBox(height: SizeConfig.blockSizeVertical * 2,),
            
            Text('V.1.1.0', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, fontWeight: FontWeight.bold, color: Color(0xff888888),),),

            Expanded(child: Container(),),

          ],
        ),
      ),
    );
  }
}


class MiscBLMUserProfileDraggableSwitchTabs extends StatefulWidget {

  @override
  MiscBLMUserProfileDraggableSwitchTabsState createState() => MiscBLMUserProfileDraggableSwitchTabsState();
}

class MiscBLMUserProfileDraggableSwitchTabsState extends State<MiscBLMUserProfileDraggableSwitchTabs> {

  double height;
  Offset position;
  int currentIndex = 0;
  List<Widget> children;

  @override
  void initState(){
    super.initState();
    height = SizeConfig.screenHeight;
    position = Offset(0.0, height - 100);
    children = [MiscBLMDraggablePost(), MiscBLMDraggableMemorials()];
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Positioned(
      left: position.dx,
      top: position.dy - SizeConfig.blockSizeVertical * 10,
      child: Draggable(
        feedback: draggable(),
        onDraggableCanceled: (Velocity velocity, Offset offset){
          if(offset.dy > 100 && offset.dy < (SizeConfig.screenHeight - 100)){
            setState(() {
              position = offset;
            });
          }
        },
        child: draggable(),
        childWhenDragging: Container(),
        axis: Axis.vertical,
      ),
    );
  }

  draggable(){
    return Material(
      child: Container(
        width: SizeConfig.screenWidth,
        decoration: BoxDecoration(
          color: Color(0xffffffff),
          borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25),),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Color(0xffaaaaaa),
              offset: Offset(0, 0),
              blurRadius: 5.0
            ),
          ],
        ),
        child: Column(
          children: [

            Container(
              alignment: Alignment.center,
              width: SizeConfig.screenWidth,
              height: SizeConfig.blockSizeVertical * 8,
              child: DefaultTabController(
                length: 2,
                initialIndex: currentIndex,
                child: TabBar(
                  isScrollable: false,
                  labelColor: Color(0xff04ECFF),
                  unselectedLabelColor: Color(0xffCDEAEC),
                  indicatorColor: Color(0xff04ECFF),
                  onTap: (int number){
                    setState(() {
                      currentIndex = number;
                    });
                  },
                  tabs: [

                    Container(
                      width: SizeConfig.screenWidth / 2.5,
                      child: Center(
                        child: Text('Post',
                          style: TextStyle(
                            fontSize: SizeConfig.safeBlockHorizontal * 4,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),

                    Container(
                      width: SizeConfig.screenWidth / 2.5,
                      child: Center(
                        child: Text('Memorials',
                          style: TextStyle(
                            fontSize: SizeConfig.safeBlockHorizontal * 4,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ),

            Container(
              width: SizeConfig.screenWidth,
              height: (SizeConfig.screenHeight - position.dy),
              child: IndexedStack(
                index: currentIndex,
                children: children,
              ),
            ),

            SizedBox(height: SizeConfig.blockSizeVertical * 10,),
            
          ],
        ),
      ),
    );
  }
}


class MiscBLMDraggablePost extends StatelessWidget{

  @override
  Widget build(BuildContext context){
    SizeConfig.init(context);
    return ListView.builder(
      physics: ClampingScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.only(left: 10.0, right: 10.0),
      itemCount: 5,
      itemBuilder: (context, index){
        return Column(
          children: [
            Container(
              padding: EdgeInsets.all(10.0),
              height: SizeConfig.blockSizeVertical * 60,
              decoration: BoxDecoration(
                color: Color(0xffffffff),
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: (){
                          },
                          child: CircleAvatar(
                            backgroundImage: AssetImage('assets/icons/profile1.png'),
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Column(
                              children: [
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Text('Black Lives Matter',
                                      style: TextStyle(
                                        fontSize: SizeConfig.safeBlockHorizontal * 4,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff000000),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text('an hour ago',
                                      style: TextStyle(
                                        fontSize: SizeConfig.safeBlockHorizontal * 3,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xffaaaaaa)
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        MiscBLMDropDownTemplate(),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: RichText(
                            maxLines: 4,
                            overflow: TextOverflow.clip,
                            textAlign: TextAlign.left,
                            text: TextSpan(
                              text: 'He was someone who was easy to go with. We had a lot of memories together. '
                              'We\'ve been travelling all around the world together ever since we graduated college. We will surely miss you Will ❤️❤️❤️',
                              style: TextStyle(
                                fontWeight: FontWeight.w300,
                                color: Color(0xff000000),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: SizeConfig.blockSizeVertical * 1,),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: RichText(
                            maxLines: 1,
                            overflow: TextOverflow.clip,
                            textAlign: TextAlign.left,
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'with ',
                                  style: TextStyle(
                                    fontSize: SizeConfig.safeBlockHorizontal * 3,
                                    fontWeight: FontWeight.w300,
                                    color: Color(0xffaaaaaa),
                                  ),
                                ),

                                TextSpan(
                                  text: 'William Shaw & John Howard',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff000000),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage('assets/icons/blm2.png',),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(width: SizeConfig.blockSizeHorizontal * 2,),
                        
                        Expanded(
                          child: Column(
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: AssetImage('assets/icons/blm3.png',),
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(height: SizeConfig.blockSizeVertical * 1,),

                              Expanded(
                                child: Stack(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10.0),
                                        color: Color(0xff888888),
                                      ),
                                    ),

                                    Align(
                                      child: Text('+4',
                                        style: TextStyle(
                                          fontSize: SizeConfig.safeBlockHorizontal * 7,
                                          color: Color(0xffffffff),
                                        ),
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
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: (){},
                            child: Row(
                              children: [
                                Image.asset('assets/icons/peace_logo.png', width: SizeConfig.blockSizeHorizontal * 7, height: SizeConfig.blockSizeVertical * 7,),

                                SizedBox(width: SizeConfig.blockSizeHorizontal * 1,),

                                Text('24.3K',
                                  style: TextStyle(
                                    fontSize: SizeConfig.safeBlockHorizontal * 4,
                                    color: Color(0xff000000),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(width: SizeConfig.blockSizeHorizontal * 2,),

                        Expanded(
                          child: GestureDetector(
                            onTap: (){},
                            child: Row(
                              children: [
                                Image.asset('assets/icons/comment_logo.png', width: SizeConfig.blockSizeHorizontal * 7, height: SizeConfig.blockSizeVertical * 7,),

                                SizedBox(width: SizeConfig.blockSizeHorizontal * 1,),

                                Text('14.3K',
                                  style: TextStyle(
                                    fontSize: SizeConfig.safeBlockHorizontal * 4,
                                    color: Color(0xff000000),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: GestureDetector(
                            onTap: (){},
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Image.asset('assets/icons/share_logo.png', width: SizeConfig.blockSizeHorizontal * 13, height: SizeConfig.blockSizeVertical * 13,),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: SizeConfig.blockSizeVertical * 2,),
          ],
        );
      }
    );
  }
}


class MiscBLMDraggableMemorials extends StatelessWidget{

  @override
  Widget build(BuildContext context){
    return ListView.separated(
      physics: ClampingScrollPhysics(),
      itemCount: 5,
      itemBuilder: (context, index){
        if(index == 0){
          return Container(
            height: SizeConfig.blockSizeVertical * 10,
            padding: EdgeInsets.only(left: 20.0, right: 20.0),
            color: Color(0xffffffff),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Owned',
                style: TextStyle(
                  fontSize: SizeConfig.safeBlockHorizontal * 4,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff000000),
                ),
              ),
            ),
          );
        }else if(index == 3){
          return Container(
            height: SizeConfig.blockSizeVertical * 10,
            padding: EdgeInsets.only(left: 20.0, right: 20.0),
            color: Color(0xffffffff),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Followed',
                style: TextStyle(
                  fontSize: SizeConfig.safeBlockHorizontal * 4,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff000000),
                ),
              ),
            ),
          );
        }else{
          return MiscBLMUserProfileDraggableTabsList(index: index, tab: 0,);
        }
      },
      separatorBuilder: (context, index){
        return Divider(height: 1, color: Colors.grey,);
      },
    );
  }
}


class MiscBLMPost extends StatefulWidget{
  final List<Widget> contents;
  final int userId;
  final int postId;
  final int memorialId;
  final dynamic profileImage;
  final String memorialName;
  final String timeCreated;
  final bool managed;
  final bool joined;
  final int numberOfComments;
  final int numberOfLikes;
  final bool likeStatus;
  final int numberOfTagged;
  final List<String> taggedFirstName;
  final List<String> taggedLastName;
  final List<int> taggedId;

  MiscBLMPost({this.contents, this.userId, this.postId, this.memorialId, this.profileImage, this.memorialName = '', this.timeCreated = '', this.managed, this.joined, this.numberOfComments, this.numberOfLikes, this.likeStatus, this.numberOfTagged, this.taggedFirstName, this.taggedLastName, this.taggedId});

  MiscBLMPostState createState() => MiscBLMPostState(contents: contents, userId: userId, postId: postId, memorialId: memorialId, profileImage: profileImage, memorialName: memorialName, timeCreated: timeCreated, managed: managed, joined: joined, numberOfComments: numberOfComments, numberOfLikes: numberOfLikes, likeStatus: likeStatus, numberOfTagged: numberOfTagged, taggedFirstName: taggedFirstName, taggedLastName: taggedLastName, taggedId: taggedId);
}

class MiscBLMPostState extends State<MiscBLMPost> with WidgetsBindingObserver{

  final List<Widget> contents;
  final int userId;
  final int postId;
  final int memorialId;
  final dynamic profileImage;
  final String memorialName;
  final String timeCreated;
  final bool managed;
  final bool joined;
  final int numberOfComments;
  final int numberOfLikes;
  final bool likeStatus;
  final int numberOfTagged;
  final List<String> taggedFirstName;
  final List<String> taggedLastName;
  final List<int> taggedId;

  MiscBLMPostState({this.contents, this.userId, this.postId, this.memorialId, this.profileImage, this.memorialName = '', this.timeCreated = '', this.managed, this.joined, this.numberOfComments, this.numberOfLikes, this.likeStatus, this.numberOfTagged, this.taggedFirstName, this.taggedLastName, this.taggedId});

  Future profileFollowing;
  bool likePost;
  bool pressedLike;
  int likesCount;

  String category;
  BranchUniversalObject buo;
  BranchLinkProperties lp;
  BranchContentMetaData metadata;

  void initState(){
    super.initState();
    likePost = likeStatus;
    pressedLike = false;
    likesCount = numberOfLikes;
    initDeepLinkData();
    WidgetsBinding.instance.addObserver(this);
  }
  
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void initDeepLinkData(){
    buo = BranchUniversalObject(
      canonicalIdentifier: 'flutter/branch',
      title: 'FacesbyPlace Post',
      imageUrl: 'assets/icons/app-icon.png',
      contentDescription: 'FacesbyPlaces post shared.',
      keywords: ['FacesbyPlaces', 'Share', 'Post'],
      publiclyIndex: true,
      locallyIndex: true,
      contentMetadata: BranchContentMetaData()..addCustomMetadata('custom_string', 'abc')
          ..addCustomMetadata('custom_number', 12345)
          ..addCustomMetadata('custom_bool', true)
          ..addCustomMetadata('custom_list_number', [1,2,3,4,5 ])
          ..addCustomMetadata('custom_list_string', ['a', 'b', 'c']),
    );

    lp = BranchLinkProperties(
        channel: 'facebook',
        feature: 'sharing',
        stage: 'new share',
      tags: ['one', 'two', 'three']
    );
    lp.addControlParam('url', 'https://29cft.test-app.link/suCwfzCi6bb');
  }

  @override
  Widget build(BuildContext context){
    ResponsiveWidgets.init(context,
      height: SizeConfig.screenHeight,
      width: SizeConfig.screenWidth,
    );
    
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMShowOriginalPost(postId: postId, likeStatus: likePost, numberOfLikes: likesCount,)));
      },
      child: Container(
        padding: EdgeInsets.only(left: 10.0, right: 10.0,),
        decoration: BoxDecoration(
          color: Color(0xffffffff),
          borderRadius: BorderRadius.all(Radius.circular(15),),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 0)
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              height: ScreenUtil().setHeight(65),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () async{
                      if(managed == true){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMProfile(memorialId: memorialId,)));
                      }else{
                        Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMMemorialProfile(memorialId: memorialId, newJoin: true)));
                      }
                    },
                    child: CircleAvatar(backgroundColor: Color(0xff888888), backgroundImage: profileImage != null ? NetworkImage(profileImage) : AssetImage('assets/icons/app-icon.png')),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Column(
                        children: [
                          Expanded(
                            child: Align(alignment: Alignment.bottomLeft,
                              child: Text(memorialName,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: ScreenUtil().setSp(14, allowFontScalingSelf: true),
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff000000),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(timeCreated,
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: ScreenUtil().setSp(12, allowFontScalingSelf: true),
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xffaaaaaa)
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  MiscBLMDropDownTemplate(postId: postId, reportType: 'Post',),
                ],
              ),
            ),

            SizedBox(height: ScreenUtil().setHeight(5)),

            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                children: contents,
              ),
            ),

            SizedBox(height: ScreenUtil().setHeight(5)),

            numberOfTagged != 0
            ? Row(
              children: [
                Text('with'),

                Container(
                  child: Wrap(
                    spacing: 5.0,
                    children: List.generate(
                      numberOfTagged,
                      (index) => GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMUserProfile(userId: taggedId[index])));
                        },
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xff000000)),
                            children: <TextSpan>[
                              TextSpan(text: taggedFirstName[index],),

                              TextSpan(text: ' '),

                              TextSpan(text: taggedLastName[index],),

                              index < numberOfTagged - 1
                              ? TextSpan(text: ',')
                              : TextSpan(text: ''),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  padding: EdgeInsets.only(left: 5.0, right: 5.0,), 
                  alignment: Alignment.centerLeft,
                ),
              ],
            )
            : Container(height: 0,),

            Container(
              height: SizeConfig.blockSizeVertical * 10,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () async{

                      setState(() {
                        likePost = !likePost;

                        if(likePost == true){
                          pressedLike = true;
                          likesCount++;
                        }else{
                          pressedLike = false;
                          likesCount--;
                        }
                      });

                      await apiBLMLikeOrUnlikePost(postId: postId, like: likePost);

                      print('Test!');
                    },
                    child: Row(
                      children: [
                        likePost == true
                        ? FaIcon(FontAwesomeIcons.peace, color: Colors.red,)
                        : FaIcon(FontAwesomeIcons.peace, color: Colors.grey,),

                        SizedBox(width: SizeConfig.blockSizeHorizontal * 1,),

                        Text('$likesCount', style: TextStyle(fontSize: ScreenUtil().setSp(14, allowFontScalingSelf: true), color: Color(0xff000000),),),
                      ],
                    ),
                  ),

                  SizedBox(width: SizeConfig.blockSizeHorizontal * 2,),

                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMShowCommentsList(postId: postId, userId: userId, numberOfLikes: likesCount, numberOfComments: numberOfComments,)));
                    },
                    child: Row(
                      children: [
                        Image.asset('assets/icons/comment_logo.png', width: SizeConfig.blockSizeHorizontal * 5, height: SizeConfig.blockSizeVertical * 5,),

                        SizedBox(width: SizeConfig.blockSizeHorizontal * 1,),

                        Text('$numberOfComments', style: TextStyle(fontSize: ScreenUtil().setSp(14, allowFontScalingSelf: true), color: Color(0xff000000),),),
                      ],
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () async{
                        DateTime date = DateTime.now();
                        String id = date.toString().replaceAll('-', '').replaceAll(' ', '').replaceAll(':', '').replaceAll('.', '') + 'id-share-blm-memorial';
                        FlutterBranchSdk.setIdentity(id);

                        BranchResponse response =
                            await FlutterBranchSdk.getShortUrl(buo: buo, linkProperties: lp);
                        if (response.success) {
                          print('Link generated: ${response.result}');
                        } else {
                            print('Error : ${response.errorCode} - ${response.errorMessage}');
                        }

                        BranchResponse shareResult = await FlutterBranchSdk.showShareSheet(
                          buo: buo,
                          linkProperties: lp,
                          messageText: 'FacesbyPlaces Post',
                          androidMessageTitle: 'New post from FacesbyPlaces. Click this link to view the post.',
                          androidSharingTitle: 'FacesbyPlaces Post',
                        );


                        print('The value of deep link response is ${response.errorMessage}');
                        print('The value of deep link response is ${response.errorCode}');
                        print('The value of deep link response is ${response.result}');
                        print('The value of deep link response is ${response.success}');

                        if (response.success) {
                          print('deep link showShareSheet Sucess');
                        } else {
                          print('deep link Error : ${response.errorCode} - ${response.errorMessage}');
                        }

                        print('The value of response is ${shareResult.errorMessage}');
                        print('The value of response is ${shareResult.errorCode}');
                        print('The value of response is ${shareResult.result}');
                        print('The value of response is ${shareResult.success}');

                        if (shareResult.success) {
                          print('showShareSheet Sucess');
                        } else {
                          print('Error : ${shareResult.errorCode} - ${shareResult.errorMessage}');
                        }
                      },
                      child: Align(alignment: Alignment.centerRight, child: Image.asset('assets/icons/share_logo.png', width: SizeConfig.blockSizeHorizontal * 13, height: SizeConfig.blockSizeVertical * 13,),),
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
