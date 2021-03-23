import 'package:facesbyplaces/UI/Home/BLM/02-View-Memorial/home-view-memorial-blm-01-managed-memorial.dart';
import 'package:facesbyplaces/UI/Home/BLM/02-View-Memorial/home-view-memorial-blm-02-profile-memorial.dart';
import 'package:facesbyplaces/UI/Home/Regular/02-View-Memorial/home-view-memorial-regular-01-managed-memorial.dart';
import 'package:facesbyplaces/UI/Home/Regular/02-View-Memorial/home-view-memorial-regular-02-profile-memorial.dart';
import 'package:facesbyplaces/UI/Home/Regular/11-Show-Post/home-show-post-regular-01-show-original-post-comments.dart';
import 'package:facesbyplaces/UI/Home/Regular/12-Show-User/home-show-user-regular-01-user.dart';
import 'package:facesbyplaces/API/Regular/12-Show-Post/api-show-post-regular-05-post-like-or-unlike.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'misc-12-regular-dropdown.dart';

class MiscRegularPost extends StatefulWidget{
  final List<Widget> contents;
  final int userId;
  final int postId;
  final int memorialId;
  final String profileImage;
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

  MiscRegularPost({required this.contents, required this.userId, required this.postId, required this.memorialId, required this.profileImage, required this.memorialName, this.timeCreated = '', required this.managed, required this.joined, required this.numberOfComments, required this.numberOfLikes, required this.likeStatus, required this.numberOfTagged, required this.taggedFirstName, required this.taggedLastName, required this.taggedId, required this.pageType, required this.famOrFriends, required this.relationship});

  MiscRegularPostState createState() => MiscRegularPostState(contents: contents, userId: userId, postId: postId, memorialId: memorialId, profileImage: profileImage, memorialName: memorialName, timeCreated: timeCreated, managed: managed, joined: joined, numberOfComments: numberOfComments, numberOfLikes: numberOfLikes, likeStatus: likeStatus, numberOfTagged: numberOfTagged, taggedFirstName: taggedFirstName, taggedLastName: taggedLastName, taggedId: taggedId, pageType: pageType, famOrFriends: famOrFriends, relationship: relationship);
}

class MiscRegularPostState extends State<MiscRegularPost> with WidgetsBindingObserver{
  final List<Widget> contents;
  final int userId;
  final int postId;
  final int memorialId;
  final String profileImage;
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

  MiscRegularPostState({required this.contents, required this.userId, required this.postId, required this.memorialId, required this.profileImage, required this.memorialName, this.timeCreated = '', required this.managed, required this.joined, required this.numberOfComments, required this.numberOfLikes, required this.likeStatus, required this.numberOfTagged, required this.taggedFirstName, required this.taggedLastName, required this.taggedId, required this.pageType, required this.famOrFriends, required this.relationship});

  BranchUniversalObject? buo;
  BranchLinkProperties? lp;

  bool likePost = false;
  bool pressedLike = false;
  int likesCount = 0;

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
    lp!.addControlParam('url', 'https://4n5z1.test-app.link/qtdaGGTx3cb?bnc_validate=true');
  }


  void initState(){
    super.initState();
    likePost = likeStatus;
    likesCount = numberOfLikes;
  }

  @override
  Widget build(BuildContext context){
    SizeConfig.init(context);
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularShowOriginalPostComments(postId: postId)));
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
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ListTile(
              onTap: (){
                if(pageType == 'Memorial'){
                  if(managed == true || famOrFriends == true){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularProfile(memorialId: memorialId, relationship: relationship, managed: managed, newlyCreated: false,)));
                  }else{
                    Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularMemorialProfile(memorialId: memorialId, pageType: pageType, newJoin: joined,)));
                  }
                }else{
                  if(managed == true || famOrFriends == true){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMProfile(memorialId: memorialId, relationship: relationship, managed: managed, newlyCreated: false,)));
                  }else{
                    Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMMemorialProfile(memorialId: memorialId, pageType: pageType, newJoin: joined,)));
                  }
                }
              },
              contentPadding: EdgeInsets.zero,
              leading: profileImage != '' ? CircleAvatar(backgroundColor: Color(0xff888888), backgroundImage: NetworkImage(profileImage)) : CircleAvatar(backgroundColor: Color(0xff888888), backgroundImage: AssetImage('assets/icons/app-icon.png')),
              title: Text(memorialName, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xff000000),),),
              subtitle: Text(timeCreated, maxLines: 1, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Color(0xffaaaaaa),),),
              trailing: MiscRegularDropDownTemplate(postId: postId, likePost: likePost, likesCount: likesCount, reportType: 'Post', pageType: pageType,),
            ),

            Column(children: contents,),

            numberOfTagged != 0
            ? Column(
              children: [
                SizedBox(height: 10),

                Align(
                  alignment: Alignment.centerLeft,
                  child: RichText(
                    text: TextSpan(
                      
                      children: [
                        TextSpan(
                          style: TextStyle(color: Color(0xff888888)),
                          text: 'with '
                        ),

                        TextSpan(
                          children: List.generate(numberOfTagged, 
                            (index) => TextSpan(
                              style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xff000000)),
                              children: <TextSpan>[
                                TextSpan(text: taggedFirstName[index],),

                                TextSpan(text: ' '),

                                TextSpan(text: taggedLastName[index],),

                                index < numberOfTagged - 1
                                ? TextSpan(text: ', ')
                                : TextSpan(text: ''),
                              ],
                              recognizer: TapGestureRecognizer()
                              ..onTap = (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularUserProfile(userId: taggedId[index], accountType: pageType == 'BLM' ? 1 : 2)));
                              }
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                )

              ],
            )
            : Container(height: 0,),

            Row(
              children: [
                TextButton.icon(
                  onPressed: () async{
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
                  icon: likePost == true ? FaIcon(FontAwesomeIcons.solidHeart, color: Color(0xffE74C3C),) : FaIcon(FontAwesomeIcons.heart, color: Colors.grey,),
                  label: Text('$numberOfComments', style: TextStyle(fontSize: 14, color: Color(0xff000000),),),
                ),

                SizedBox(width: 20),

                TextButton.icon(
                  onPressed: () async{
                    Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularShowOriginalPostComments(postId: postId)));
                  },
                  icon: FaIcon(FontAwesomeIcons.solidComment, color: Color(0xff4EC9D4),),
                  label: Text('$numberOfComments', style: TextStyle(fontSize: 14, color: Color(0xff000000),),),
                ),

                Expanded(child: Container(),),

                IconButton(
                  alignment: Alignment.centerRight,
                  splashColor: Colors.transparent,
                  icon: CircleAvatar(backgroundColor: Color(0xff4EC9D4), child: Icon(Icons.share_rounded, color: Color(0xffffffff)),),
                  onPressed: () async{
                    initBranchShare();

                    FlutterBranchSdk.setIdentity('alm-share-link');

                    BranchResponse response = await FlutterBranchSdk.showShareSheet(
                      buo: buo!,
                      linkProperties: lp!,
                      messageText: 'FacesbyPlaces App',
                      androidMessageTitle: 'FacesbyPlaces - Create a memorial page for loved ones by sharing stories, special events and photos of special occasions. Keeping their memories alive for generations',
                      androidSharingTitle: 'FacesbyPlaces - Create a memorial page for loved ones by sharing stories, special events and photos of special occasions. Keeping their memories alive for generations'
                    );

                    if (response.success) {
                      print('The post id is $postId');
                    } else {
                      FlutterBranchSdk.logout();
                    }
                  },
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}

