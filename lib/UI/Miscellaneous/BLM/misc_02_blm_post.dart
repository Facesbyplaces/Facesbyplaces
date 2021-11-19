import 'package:facesbyplaces/UI/Home/BLM/02-View-Memorial/home_view_memorial_blm_01_managed_memorial.dart';
import 'package:facesbyplaces/UI/Home/BLM/02-View-Memorial/home_view_memorial_blm_02_profile_memorial.dart';
import 'package:facesbyplaces/UI/Home/BLM/11-Show-Post/home_show_post_blm_01_show_original_post_comments.dart';
import 'package:facesbyplaces/UI/Home/Regular/02-View-Memorial/home_view_memorial_regular_01_managed_memorial.dart';
import 'package:facesbyplaces/UI/Home/Regular/02-View-Memorial/home_view_memorial_regular_02_profile_memorial.dart';
import 'package:facesbyplaces/API/BLM/12-Show-Post/api_show_post_blm_05_post_like_or_unlike.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:dialog/dialog.dart';
import 'misc_03_blm_dropdown.dart';

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
  final String pageType;
  final bool famOrFriends;
  final String relationship;
  final String location;
  final double latitude;
  final double longitude;
  final bool isGuest;
  const MiscBLMPost({required Key key, required this.contents, required this.userId, required this.postId, required this.memorialId, required this.profileImage, this.memorialName = '', this.timeCreated = '', required this.managed, required this.joined, required this.numberOfComments, required this.numberOfLikes, required this.likeStatus, required this.numberOfTagged, required this.taggedFirstName, required this.taggedLastName, required this.taggedId, required this.pageType, required this.famOrFriends, required this.relationship, required this.location, required this.latitude, required this.longitude, required this.isGuest}) : super(key: key);

  @override
  MiscBLMPostState createState() => MiscBLMPostState();
}

class MiscBLMPostState extends State<MiscBLMPost>{
  ValueNotifier<bool> likePost = ValueNotifier<bool>(false);
  ValueNotifier<int> commentsCount = ValueNotifier<int>(0);
  int likesCount = 0;

  @override
  void initState(){
    super.initState();
    likePost.value = widget.likeStatus;
    likesCount = widget.numberOfLikes;
    commentsCount.value = widget.numberOfComments;
  }

  @override
  Widget build(BuildContext context){
    SizeConfig.init(context);
    return ValueListenableBuilder(
      valueListenable: likePost,
      builder: (_, bool likePostListener, __) => ValueListenableBuilder(
        valueListenable: commentsCount,
        builder: (_, int commentsCountListener, __) => GestureDetector(
          onTap: () async{
            final returnValue = await Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMShowOriginalPostComments(postId: widget.postId)));
            commentsCount.value = int.parse(returnValue.toString());
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
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: widget.profileImage != ''
                  ? CircleAvatar(
                    backgroundColor: const Color(0xff888888),
                    foregroundImage: NetworkImage(widget.profileImage),
                    backgroundImage: const AssetImage('assets/icons/app-icon.png'),
                  )
                  : const CircleAvatar(
                    backgroundColor: Color(0xff888888),
                    foregroundImage: AssetImage('assets/icons/app-icon.png'),
                  ),
                  title: Text(widget.memorialName, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 26, fontFamily: 'NexaBold', color: Color(0xff000000),),),
                  subtitle: Text(widget.timeCreated, maxLines: 1, style: const TextStyle(fontSize: 16, fontFamily: 'NexaRegular', color: Color(0xffB1B1B1),),),
                  trailing: MiscBLMDropDownTemplate(postId: widget.postId, likePost: likePostListener, likesCount: likesCount, reportType: 'Post', pageType: widget.pageType, pageName: widget.memorialName),
                  onTap: (){
                    if(widget.pageType == 'Memorial'){
                      if(widget.managed == true || widget.famOrFriends == true){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularProfile(memorialId: widget.memorialId, relationship: widget.relationship, managed: widget.managed, newlyCreated: false,)));
                      }else{
                        Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularMemorialProfile(memorialId: widget.memorialId, pageType: widget.pageType, newJoin: widget.joined,)));
                      }
                    }else{
                      if(widget.managed == true || widget.famOrFriends == true){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMProfile(memorialId: widget.memorialId, relationship: widget.relationship, managed: widget.managed, newlyCreated: false,)));
                      }else{
                        Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMMemorialProfile(memorialId: widget.memorialId, pageType: widget.pageType, newJoin: widget.joined,)));
                      }
                    }
                  },
                ),

                Column(children: widget.contents,),

                widget.numberOfTagged != 0
                ? Column(
                  children: [
                    const SizedBox(height: 10),
                    
                    Align(
                      alignment: Alignment.centerLeft,
                      child: RichText(
                        text: TextSpan(
                          children: [
                            const TextSpan(style: TextStyle(fontSize: 16, fontFamily: 'NexaRegular', color: Color(0xff888888)), text: 'with ',),

                            TextSpan(
                              children: List.generate(widget.numberOfTagged, (index) => TextSpan(
                                style: const TextStyle(fontSize: 18, fontFamily: 'NexaBold', color: Color(0xff000000),),
                                  children: <TextSpan>[
                                    TextSpan(text: widget.taggedFirstName[index],),

                                    const TextSpan(text: ' '),

                                    TextSpan(text: widget.taggedLastName[index],),

                                    index < widget.numberOfTagged - 1 ? const TextSpan(text: ', ') : const TextSpan(text: ''),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
                : const SizedBox(height: 0,),

                widget.location != ''
                ? Column(
                  children: [
                    const SizedBox(height: 10,),

                    Row(
                      children: [
                        const Icon(Icons.place, color: Color(0xff888888)),

                        Expanded(child: Text(widget.location, style: const TextStyle(fontSize: 18, fontFamily: 'NexaBold', color: Color(0xff000000),),),),
                      ],
                    ),
                  ],
                )
                : const SizedBox(height: 0,),

                IgnorePointer(
                  ignoring: widget.isGuest,
                  child: Row(
                    children: [
                      TextButton.icon(
                        icon: likePostListener == true ? const FaIcon(FontAwesomeIcons.peace, color: Color(0xffff0000),) : const FaIcon(FontAwesomeIcons.peace, color: Color(0xff888888),),
                        label: Text('$likesCount', style: const TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xff000000),),),
                        onPressed: () async{
                          likePost.value = !likePost.value;

                          if(likePost.value == true){
                            likesCount++;
                          }else{
                            likesCount--;
                          }

                          await apiBLMLikeOrUnlikePost(postId: widget.postId, like: likePost.value);
                        },
                      ),

                      const SizedBox(width: 20),

                      TextButton.icon(
                        icon: const FaIcon(FontAwesomeIcons.solidComment, color: Color(0xff4EC9D4),),
                        label: Text('$commentsCountListener', style: const TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xff000000),),),
                        onPressed: () async{
                          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMShowOriginalPostComments(postId: widget.postId)));
                        },
                      ),

                      const Expanded(child: SizedBox(),),

                      IconButton(
                        alignment: Alignment.centerRight,
                        splashColor: Colors.transparent,
                        icon: const CircleAvatar(backgroundColor: Color(0xff4EC9D4), child: Icon(Icons.share_rounded, color: Color(0xffffffff),),),
                        onPressed: () async{
                          BranchUniversalObject buo = BranchUniversalObject(
                            canonicalIdentifier: 'FacesbyPlaces',
                            title: 'FacesbyPlaces Link',
                            contentDescription: 'FacesbyPlaces link to the app',
                            keywords: ['FacesbyPlaces', 'Share', 'Link'],
                            publiclyIndex: true,
                            locallyIndex: true,
                            contentMetadata: BranchContentMetaData()
                            ..addCustomMetadata('link-category', 'Post')
                            ..addCustomMetadata('link-post-id', widget.postId)
                            ..addCustomMetadata('link-like-status', likePost.value)
                            ..addCustomMetadata('link-number-of-likes', likesCount)
                            ..addCustomMetadata('link-type-of-account', 'Blm',
                            ),
                          );

                          BranchLinkProperties lp = BranchLinkProperties(feature: 'sharing', stage: 'new share', tags: ['one', 'two', 'three']);
                          lp.addControlParam('url','https://4n5z1.test-app.link/qtdaGGTx3cb?bnc_validate=true');

                          FlutterBranchSdk.setIdentity('blm-share-link');
                          BranchResponse response = await FlutterBranchSdk.showShareSheet(
                            buo: buo,
                            linkProperties: lp,
                            messageText: 'FacesbyPlaces App',
                            androidMessageTitle: 'FacesbyPlaces - Create a memorial page for loved ones by sharing stories, special events and photos of special occasions. Keeping their memories alive for generations',
                            androidSharingTitle: 'FacesbyPlaces - Create a memorial page for loved ones by sharing stories, special events and photos of special occasions. Keeping their memories alive for generations',
                          );

                          if(response.success){
                            await showDialog(
                              context: context,
                              builder: (context) => CustomDialog(
                                image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                title: 'Success',
                                description: 'Successfully shared the link.',
                                okButtonColor: const Color(0xff4caf50), // GREEN
                                includeOkButton: true,
                              ),
                            );
                          }else{
                            FlutterBranchSdk.logout();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}