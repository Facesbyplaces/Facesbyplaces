import 'package:facesbyplaces/UI/Home/Regular/02-View-Memorial/home-view-memorial-regular-01-managed-memorial.dart';
import 'package:facesbyplaces/UI/Home/Regular/02-View-Memorial/home-view-memorial-regular-02-profile-memorial.dart';
import 'package:facesbyplaces/UI/Home/Regular/09-Settings-User/home-settings-user-regular-02-user-update-details.dart';
import 'package:facesbyplaces/UI/Home/Regular/09-Settings-User/home-settings-user-regular-03-change-password.dart';
import 'package:facesbyplaces/UI/Home/Regular/09-Settings-User/home-settings-user-regular-04-other-details.dart';
import 'package:facesbyplaces/API/Regular/10-Settings-User/api-settings-user-regular-11-show-other-details-status.dart';
import 'package:facesbyplaces/API/Regular/12-Show-Post/api-show-post-regular-02-post-like-or-unlike.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/UI/Home/Regular/11-Show-Post/home-show-post-regular-01-show-original-post.dart';
import 'package:facesbyplaces/UI/Home/Regular/11-Show-Post/home-show-post-regular-02-show-comments.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter/material.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import '../../ui-01-get-started.dart';
import 'misc-04-regular-dropdown.dart';
import 'misc-07-regular-button.dart';
import 'misc-08-regular-dialog.dart';

class MiscRegularPost extends StatefulWidget{
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

  MiscRegularPost({this.contents, this.userId, this.postId, this.memorialId, this.profileImage, this.memorialName = '', this.timeCreated = '', this.managed, this.joined, this.numberOfComments, this.numberOfLikes, this.likeStatus});

  MiscRegularPostState createState() => MiscRegularPostState(contents: contents, userId: userId, postId: postId, memorialId: memorialId, profileImage: profileImage, memorialName: memorialName, timeCreated: timeCreated, managed: managed, joined: joined, numberOfComments: numberOfComments, numberOfLikes: numberOfLikes, likeStatus: likeStatus);
}

class MiscRegularPostState extends State<MiscRegularPost> with WidgetsBindingObserver{
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

  MiscRegularPostState({this.contents, this.userId, this.postId, this.memorialId, this.profileImage, this.memorialName = '', this.timeCreated = '', this.managed, this.joined, this.numberOfComments, this.numberOfLikes, this.likeStatus});

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
    SizeConfig.init(context);
    ResponsiveWidgets.init(context,
      height: SizeConfig.screenHeight,
      width: SizeConfig.screenWidth,
    );
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularShowOriginalPost(postId: postId, likeStatus: likePost, numberOfLikes: likesCount,)));
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
              // height: SizeConfig.blockSizeVertical * 10,
              height: ScreenUtil().setHeight(65),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () async{

                      if(managed == true){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularProfile(memorialId: memorialId,)));
                      }else{
                        Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularMemorialProfile(memorialId: memorialId, newJoin: true)));
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
                  MiscRegularDropDownTemplate(userId: userId, postId: postId,),
                ],
              ),
            ),

            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                children: contents,
              ),
            ),

            Container(
              // height: SizeConfig.blockSizeVertical * 10,
              height: ScreenUtil().setHeight(65),
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

                      await apiRegularLikeOrUnlikePost(postId: postId, like: likePost);

                    },
                    child: Row(
                      children: [
                        likePost == true
                        ? Icon(Icons.favorite, color: Color(0xffE74C3C),)
                        : Icon(Icons.favorite_border_outlined, color: Color(0xffE74C3C),),

                        SizedBox(width: SizeConfig.blockSizeHorizontal * 1,),

                        Text('$likesCount', style: TextStyle(fontSize: ScreenUtil().setSp(14, allowFontScalingSelf: true), color: Color(0xff000000),),),

                      ],
                    ),
                  ),

                  SizedBox(width: SizeConfig.blockSizeHorizontal * 2,),

                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularShowCommentsList(postId: postId, numberOfLikes: likesCount, numberOfComments: numberOfComments,)));
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
                        String id = date.toString().replaceAll('-', '').replaceAll(' ', '').replaceAll(':', '').replaceAll('.', '') + 'id-share-alm-memorial';
                        // FlutterBranchSdk.setIdentity('id-$id-share-memorial');
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

class MiscRegularUserProfileDetailsDraggable extends StatefulWidget {
  final int userId;
  MiscRegularUserProfileDetailsDraggable({this.userId});

  @override
  MiscRegularUserProfileDetailsDraggableState createState() => MiscRegularUserProfileDetailsDraggableState(userId: userId);
}

class MiscRegularUserProfileDetailsDraggableState extends State<MiscRegularUserProfileDetailsDraggable> {
  final int userId;
  MiscRegularUserProfileDetailsDraggableState({this.userId});

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
                Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularUserUpdateDetails(userId: userId,)));
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
                Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularUserChangePassword(userId: userId,)));
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
                APIRegularShowOtherDetailsStatus result = await apiRegularShowOtherDetailsStatus(userId);
                context.hideLoaderOverlay();

                Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularUserOtherDetails(userId: userId, toggleBirthdate: result.hideBirthdate, toggleBirthplace: result.hideBirthplace, toggleAddress: result.hideAddress, toggleEmail: result.hideEmail, toggleNumber: result.hidePhoneNumber)));
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

            MiscRegularButtonTemplate(
              buttonText: 'Logout',
              buttonTextStyle: TextStyle(
                fontSize: SizeConfig.safeBlockHorizontal * 5, 
                fontWeight: FontWeight.bold, 
                color: Color(0xffffffff),
              ),
              onPressed: () async{

                bool logoutResult = await showDialog(context: (context), builder: (build) => MiscRegularConfirmDialog(title: 'Log out', content: 'Are you sure you want to log out from this account?', confirmColor_1: Color(0xff000000), confirmColor_2: Color(0xff888888),));

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
