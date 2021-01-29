import 'package:facesbyplaces/UI/Home/BLM/02-View-Memorial/home-view-memorial-blm-01-managed-memorial.dart';
import 'package:facesbyplaces/UI/Home/BLM/02-View-Memorial/home-view-memorial-blm-02-profile-memorial.dart';
import 'package:facesbyplaces/UI/Home/Regular/02-View-Memorial/home-view-memorial-regular-01-managed-memorial.dart';
import 'package:facesbyplaces/UI/Home/Regular/02-View-Memorial/home-view-memorial-regular-02-profile-memorial.dart';
import 'package:facesbyplaces/API/Regular/12-Show-Post/api-show-post-regular-05-post-like-or-unlike.dart';
import 'package:facesbyplaces/UI/Home/Regular/11-Show-Post/home-show-post-regular-01-show-original-post.dart';
import 'package:facesbyplaces/UI/Home/Regular/11-Show-Post/home-show-post-regular-02-show-comments.dart';
import 'package:facesbyplaces/UI/Home/Regular/12-Show-User/home-show-user-regular-01-user.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'misc-13-regular-dropdown.dart';
import 'dart:async';

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
  final int numberOfTagged;
  final List<String> taggedFirstName;
  final List<String> taggedLastName;
  final List<int> taggedId;
  final String pageType;
  final bool famOrFriends;
  final String relationship;

  MiscRegularPost({this.contents, this.userId, this.postId, this.memorialId, this.profileImage, this.memorialName = '', this.timeCreated = '', this.managed, this.joined, this.numberOfComments, this.numberOfLikes, this.likeStatus, this.numberOfTagged, this.taggedFirstName, this.taggedLastName, this.taggedId, this.pageType, this.famOrFriends, this.relationship});

  MiscRegularPostState createState() => MiscRegularPostState(contents: contents, userId: userId, postId: postId, memorialId: memorialId, profileImage: profileImage, memorialName: memorialName, timeCreated: timeCreated, managed: managed, joined: joined, numberOfComments: numberOfComments, numberOfLikes: numberOfLikes, likeStatus: likeStatus, numberOfTagged: numberOfTagged, taggedFirstName: taggedFirstName, taggedLastName: taggedLastName, taggedId: taggedId, pageType: pageType, famOrFriends: famOrFriends, relationship: relationship);
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
  final int numberOfTagged;
  final List<String> taggedFirstName;
  final List<String> taggedLastName;
  final List<int> taggedId;
  final String pageType;
  final bool famOrFriends;
  final String relationship;

  MiscRegularPostState({this.contents, this.userId, this.postId, this.memorialId, this.profileImage, this.memorialName = '', this.timeCreated = '', this.managed, this.joined, this.numberOfComments, this.numberOfLikes, this.likeStatus, this.numberOfTagged, this.taggedFirstName, this.taggedLastName, this.taggedId, this.pageType, this.famOrFriends, this.relationship});

  Future profileFollowing;
  bool likePost;
  bool pressedLike;
  int likesCount;

  BranchUniversalObject buo;
  BranchLinkProperties lp;

  void initBranchShare(){
    buo = BranchUniversalObject(
      canonicalIdentifier: 'FacesbyPlaces',
      title: 'FacesbyPlaces Link',
      imageUrl: 'https://i.picsum.photos/id/866/200/300.jpg?hmac=rcadCENKh4rD6MAp6V_ma-AyWv641M4iiOpe1RyFHeI',
      contentDescription: 'FacesbyPlaces link to the app',
      keywords: ['FacesbyPlaces', 'Share', 'Link'],
      publiclyIndex: true,
      locallyIndex: true,
      contentMetadata: BranchContentMetaData()
        ..addCustomMetadata('link-category', 'Post')
        ..addCustomMetadata('link-post-id', postId)
        ..addCustomMetadata('link-like-status', likePost)
        ..addCustomMetadata('link-number-of-likes', likesCount)
        ..addCustomMetadata('link-type-of-account', 'Memorial')
    );

    lp = BranchLinkProperties(
        feature: 'sharing',
        stage: 'new share',
      tags: ['one', 'two', 'three']
    );
    lp.addControlParam('url', 'https://4n5z1.test-app.link/qtdaGGTx3cb?bnc_validate=true');
  }

  void initState(){
    super.initState();
    likePost = likeStatus;
    pressedLike = false;
    likesCount = numberOfLikes;
  }

  @override
  void dispose() {
    super.dispose();
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
              height: ScreenUtil().setHeight(65),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () async{

                      // if(managed == true){
                      //   Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularProfile(memorialId: memorialId,)));
                      // }else{
                      //   Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularMemorialProfile(memorialId: memorialId, newJoin: joined)));
                      // }

                      if(pageType == 'Memorial'){
                        if(managed == true || famOrFriends == true){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularProfile(memorialId: memorialId, relationship: relationship, managed: managed)));
                        }else{
                          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularMemorialProfile(memorialId: memorialId, pageType: pageType, newJoin: joined,)));
                        }
                      }else{
                        if(managed == true || famOrFriends == true){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMProfile(memorialId: memorialId, relationship: relationship, managed: managed)));
                        }else{
                          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMMemorialProfile(memorialId: memorialId, pageType: pageType, newJoin: joined,)));
                        }
                      }
                      
                    },

                    child: CircleAvatar(backgroundColor: Color(0xff888888), backgroundImage: profileImage != null ? NetworkImage(profileImage) : AssetImage('assets/icons/app-icon.png')),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(left: 10.0),
                      child: GestureDetector(
                        onTap: (){
                          if(pageType == 'Memorial'){
                            if(managed == true || famOrFriends == true){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularProfile(memorialId: memorialId, relationship: relationship, managed: managed)));
                            }else{
                              Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularMemorialProfile(memorialId: memorialId, pageType: pageType, newJoin: joined,)));
                            }
                          }else{
                            if(managed == true || famOrFriends == true){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMProfile(memorialId: memorialId, relationship: relationship, managed: managed)));
                            }else{
                              Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMMemorialProfile(memorialId: memorialId, pageType: pageType, newJoin: joined,)));
                            }
                          }
                        },
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
                  ),
                  MiscRegularDropDownTemplate(postId: postId, likePost: likePost, likesCount: likesCount, reportType: 'Post', pageType: pageType,),
                ],
              ),
            ),

            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                children: contents,
              ),
            ),

            SizedBox(height: ScreenUtil().setHeight(45)),

            numberOfTagged != 0
            ? Row(
              children: [
                Text('with'),

                Container(
                  child: Wrap(
                    direction: Axis.vertical,
                    spacing: 5.0,
                    children: List.generate(
                      numberOfTagged,
                      (index) => GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularUserProfile(userId: taggedId[index])));
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
                      Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularShowCommentsList(postId: postId, userId: userId, numberOfLikes: likesCount, numberOfComments: numberOfComments,)));
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
                        initBranchShare();

                        FlutterBranchSdk.setIdentity('alm-share-link');

                        BranchResponse response = await FlutterBranchSdk.showShareSheet(
                          buo: buo,
                          linkProperties: lp,
                          messageText: 'FacesbyPlaces App',
                          androidMessageTitle: 'FacesbyPlaces - Create a memorial page for loved ones by sharing stories, special events and photos of special occasions. Keeping their memories alive for generations',
                          androidSharingTitle: 'FacesbyPlaces - Create a memorial page for loved ones by sharing stories, special events and photos of special occasions. Keeping their memories alive for generations'
                        );

                        if (response.success) {
                          print('Link generated: ${response.result}');
                          print('showShareSheet Sucess');
                          print('The post id is $postId');
                        } else {
                          FlutterBranchSdk.logout();
                          print('Error : ${response.errorCode} - ${response.errorMessage}');
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

