import 'package:facesbyplaces/UI/Home/BLM/02-View-Memorial/home-view-memorial-blm-01-managed-memorial.dart';
import 'package:facesbyplaces/UI/Home/BLM/02-View-Memorial/home-view-memorial-blm-02-profile-memorial.dart';
import 'package:facesbyplaces/UI/Home/BLM/11-Show-Post/home-show-post-blm-01-show-original-post-comments.dart';
import 'package:facesbyplaces/UI/Home/BLM/12-Show-User/home-show-user-blm-01-user.dart';
import 'package:facesbyplaces/UI/Home/Regular/02-View-Memorial/home-view-memorial-regular-01-managed-memorial.dart';
import 'package:facesbyplaces/UI/Home/Regular/02-View-Memorial/home-view-memorial-regular-02-profile-memorial.dart';
import 'package:facesbyplaces/API/BLM/12-Show-Post/api-show-post-blm-05-post-like-or-unlike.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'misc-11-blm-dropdown.dart';

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
  const MiscBLMPost({required Key key, required this.contents, required this.userId, required this.postId, required this.memorialId, required this.profileImage, this.memorialName = '', this.timeCreated = '', required this.managed, required this.joined, required this.numberOfComments, required this.numberOfLikes, required this.likeStatus, required this.numberOfTagged, required this.taggedFirstName, required this.taggedLastName, required this.taggedId, required this.pageType, required this.famOrFriends, required this.relationship, required this.location, required this.latitude, required this.longitude}) : super(key: key);

  MiscBLMPostState createState() => MiscBLMPostState();
}

class MiscBLMPostState extends State<MiscBLMPost>{
  bool likePost = false;
  int commentsCount = 0;
  int likesCount = 0;

  void initState(){
    super.initState();
    likePost = widget.likeStatus;
    likesCount = widget.numberOfLikes;
    commentsCount = widget.numberOfComments;
  }

  @override
  Widget build(BuildContext context){
    SizeConfig.init(context);
    return GestureDetector(
      onTap: () async{
        final returnValue = await Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMShowOriginalPostComments(postId: widget.postId)));
        print('The return value is $returnValue');
        commentsCount = int.parse(returnValue.toString());
        setState((){
          print('Refreshed!');
        });
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
                backgroundColor: const Color(0xff888888),
                foregroundImage: const AssetImage('assets/icons/app-icon.png'),
              ),
              title: Text(widget.memorialName, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.64, fontFamily: 'NexaBold', color: const Color(0xff000000),),),
              subtitle: Text(widget.timeCreated, maxLines: 1, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 1.56, fontFamily: 'NexaRegular', color: const Color(0xffB1B1B1),),),
              trailing: MiscBLMDropDownTemplate(postId: widget.postId, likePost: likePost, likesCount: likesCount, reportType: 'Post', pageType: widget.pageType, pageName: widget.memorialName),
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
                        const TextSpan(style: const TextStyle(color: const Color(0xff888888)), text: 'with ',),

                        TextSpan(
                          children: List.generate(widget.numberOfTagged, (index) => TextSpan(
                            style: const TextStyle(fontWeight: FontWeight.bold, color: const Color(0xff000000)),
                              children: <TextSpan>[
                                TextSpan(text: widget.taggedFirstName[index],),

                                const TextSpan(text: ' '),

                                TextSpan(text: widget.taggedLastName[index],),

                                index < widget.numberOfTagged - 1 ? const TextSpan(text: ', ') : const TextSpan(text: ''),
                              ],
                              recognizer: TapGestureRecognizer()
                              ..onTap = (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMUserProfile(userId: widget.taggedId[index], accountType: widget.pageType == 'BLM' ? 1 : 2)));
                              }
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
            : Container(height: 0,),

            Row(
              children: [
                TextButton.icon(
                  icon: likePost == true ? const FaIcon(FontAwesomeIcons.peace, color: const Color(0xffff0000),) : const FaIcon(FontAwesomeIcons.peace, color: const Color(0xff888888),),
                  label: Text('$likesCount', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.11, fontFamily: 'NexaRegular', color: const Color(0xff000000),),),
                  onPressed: () async{
                    setState((){
                      likePost = !likePost;

                      if(likePost == true){
                        likesCount++;
                      }else{
                        likesCount--;
                      }
                    });

                    await apiBLMLikeOrUnlikePost(postId: widget.postId, like: likePost);
                  },
                ),

                const SizedBox(width: 20),

                TextButton.icon(
                  icon: const FaIcon(FontAwesomeIcons.solidComment, color: const Color(0xff4EC9D4),),
                  label: Text('$commentsCount', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.11, fontFamily: 'NexaRegular', color: const Color(0xff000000),),),
                  onPressed: () async{
                    Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMShowOriginalPostComments(postId: widget.postId)));
                  },
                ),

                Expanded(child: Container(),),

                IconButton(
                  alignment: Alignment.centerRight,
                  splashColor: Colors.transparent,
                  icon: CircleAvatar(backgroundColor: const Color(0xff4EC9D4), child: const Icon(Icons.share_rounded, color: const Color(0xffffffff),),),
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
                      ..addCustomMetadata('link-like-status', likePost)
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
                        builder: (_) => AssetGiffyDialog(
                          description: Text('Successfully shared the link.', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.87, fontFamily: 'NexaRegular',),),
                          title: Text('Success', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 3.87, fontFamily: 'NexaRegular'),),
                          image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                          entryAnimation: EntryAnimation.DEFAULT,
                          onlyOkButton: true,
                          onOkButtonPressed: (){
                            Navigator.pop(context, true);
                          },
                        ),
                      );
                    }else{
                      FlutterBranchSdk.logout();
                      print('Error : ${response.errorCode} - ${response.errorMessage}');
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