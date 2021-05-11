import 'package:facesbyplaces/UI/Home/BLM/02-View-Memorial/home-view-memorial-blm-01-managed-memorial.dart';
import 'package:facesbyplaces/UI/Home/BLM/02-View-Memorial/home-view-memorial-blm-02-profile-memorial.dart';
import 'package:facesbyplaces/UI/Home/Regular/02-View-Memorial/home-view-memorial-regular-01-managed-memorial.dart';
import 'package:facesbyplaces/UI/Home/Regular/02-View-Memorial/home-view-memorial-regular-02-profile-memorial.dart';
import 'package:facesbyplaces/UI/Home/Regular/11-Show-Post/home-show-post-regular-01-show-original-post-comments.dart';
import 'package:facesbyplaces/UI/Home/Regular/12-Show-User/home-show-user-regular-01-user.dart';
import 'package:facesbyplaces/API/Regular/12-Show-Post/api-show-post-regular-05-post-like-or-unlike.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'misc-11-regular-dropdown.dart';

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

  const MiscRegularPost({required this.contents, required this.userId, required this.postId, required this.memorialId, required this.profileImage, required this.memorialName, this.timeCreated = '', required this.managed, required this.joined, required this.numberOfComments, required this.numberOfLikes, required this.likeStatus, required this.numberOfTagged, required this.taggedFirstName, required this.taggedLastName, required this.taggedId, required this.pageType, required this.famOrFriends, required this.relationship});

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

  bool likePost = false;
  // bool pressedLike = false;
  int likesCount = 0;

  void initState(){
    super.initState();
    // print("Regular rebuild for ${widget.key.toString()}");
    likePost = likeStatus;
    likesCount = numberOfLikes;
  }

  @override
  Widget build(BuildContext context){
    // print('Regular post screen rebuild!');
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularShowOriginalPostComments(postId: postId)));
      },
      child: Container(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0,),
        decoration: BoxDecoration(
          color: const Color(0xffffffff),
          borderRadius: const BorderRadius.all(Radius.circular(15),),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: const Color(0xff888888).withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 0)
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
              leading: profileImage != '' 
              ? CircleAvatar(
                backgroundColor: const Color(0xff888888), 
                foregroundImage: NetworkImage(profileImage),
                backgroundImage: const AssetImage('assets/icons/app-icon.png'),
              ) 
              : const CircleAvatar(
                backgroundColor: const Color(0xff888888), 
                foregroundImage: const AssetImage('assets/icons/app-icon.png'),
              ),
              title: Text(memorialName, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xff000000),),),
              subtitle: Text(timeCreated, maxLines: 1, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: const Color(0xffaaaaaa),),),
              trailing: MiscRegularDropDownTemplate(postId: postId, likePost: likePost, likesCount: likesCount, reportType: 'Post', pageType: pageType,),
            ),

            Column(children: contents,),

            numberOfTagged != 0
            ? Column(
              children: [
                const SizedBox(height: 10),

                Align(
                  alignment: Alignment.centerLeft,
                  child: RichText(
                    text: TextSpan(
                      
                      children: [
                        const TextSpan(
                          style: const TextStyle(color: const Color(0xff888888)),
                          text: 'with '
                        ),

                        TextSpan(
                          children: List.generate(numberOfTagged, 
                            (index) => TextSpan(
                              style: const TextStyle(fontWeight: FontWeight.bold, color: const Color(0xff000000)),
                              children: <TextSpan>[
                                TextSpan(text: taggedFirstName[index],),

                                TextSpan(text: ' '),

                                TextSpan(text: taggedLastName[index],),

                                index < numberOfTagged - 1
                                ? const TextSpan(text: ', ')
                                : const TextSpan(text: ''),
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
                        // pressedLike = true;
                        likesCount++;
                      }else{
                        // pressedLike = false;
                        likesCount--;
                      }
                    });

                    await apiRegularLikeOrUnlikePost(postId: postId, like: likePost);
                  },
                  icon: likePost == true ? const FaIcon(FontAwesomeIcons.solidHeart, color: const Color(0xffE74C3C),) : const FaIcon(FontAwesomeIcons.heart, color: const Color(0xff888888),),
                  label: Text('$likesCount', style: const TextStyle(fontSize: 14, color: const Color(0xff000000),),),
                ),

                const SizedBox(width: 20),

                TextButton.icon(
                  onPressed: () async{
                    Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularShowOriginalPostComments(postId: postId)));
                  },
                  icon: const FaIcon(FontAwesomeIcons.solidComment, color: const Color(0xff4EC9D4),),
                  label: Text('$numberOfComments', style: const TextStyle(fontSize: 14, color: const Color(0xff000000),),),
                ),

                Expanded(child: Container(),),

                IconButton(
                  alignment: Alignment.centerRight,
                  splashColor: Colors.transparent,
                  icon: const CircleAvatar(backgroundColor: const Color(0xff4EC9D4), child: const Icon(Icons.share_rounded, color: const Color(0xffffffff)),),
                  onPressed: () async{
                    
                    BranchUniversalObject buo = BranchUniversalObject(
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

                    BranchLinkProperties lp = BranchLinkProperties(
                        feature: 'sharing',
                        stage: 'new share',
                      tags: ['one', 'two', 'three']
                    );
                    lp.addControlParam('url', 'https://4n5z1.test-app.link/qtdaGGTx3cb?bnc_validate=true');

                    FlutterBranchSdk.setIdentity('alm-share-link');

                    BranchResponse response = await FlutterBranchSdk.showShareSheet(
                      buo: buo,
                      linkProperties: lp,
                      messageText: 'FacesbyPlaces App',
                      androidMessageTitle: 'FacesbyPlaces - Create a memorial page for loved ones by sharing stories, special events and photos of special occasions. Keeping their memories alive for generations',
                      androidSharingTitle: 'FacesbyPlaces - Create a memorial page for loved ones by sharing stories, special events and photos of special occasions. Keeping their memories alive for generations'
                    );

                    if(response.success){
                      await showDialog(
                        context: context,
                        builder: (_) => 
                          AssetGiffyDialog(
                          image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                          title: const Text('Success', textAlign: TextAlign.center, style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                          entryAnimation: EntryAnimation.DEFAULT,
                          description: const Text('Successfully shared the link.',
                            textAlign: TextAlign.center,
                          ),
                          onlyOkButton: true,
                          onOkButtonPressed: () {
                            Navigator.pop(context, true);
                          },
                        )
                      );
                    }else{
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