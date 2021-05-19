import 'package:facesbyplaces/UI/Home/BLM/02-View-Memorial/home-view-memorial-blm-01-managed-memorial.dart';
import 'package:facesbyplaces/UI/Home/BLM/02-View-Memorial/home-view-memorial-blm-02-profile-memorial.dart';
import 'package:facesbyplaces/UI/Home/Regular/02-View-Memorial/home-view-memorial-regular-01-managed-memorial.dart';
import 'package:facesbyplaces/UI/Home/Regular/02-View-Memorial/home-view-memorial-regular-02-profile-memorial.dart';
import 'package:facesbyplaces/UI/Home/Regular/11-Show-Post/home-show-post-regular-01-show-original-post-comments.dart';
import 'package:facesbyplaces/UI/Home/Regular/12-Show-User/home-show-user-regular-01-user.dart';
import 'package:facesbyplaces/API/Regular/12-Show-Post/api-show-post-regular-05-post-like-or-unlike.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../../Configurations/size_configuration.dart';
import 'misc-11-regular-dropdown.dart';

class MiscRegularPost extends StatefulWidget {
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

  const MiscRegularPost(
      {required Key key,
      required this.contents,
      required this.userId,
      required this.postId,
      required this.memorialId,
      required this.profileImage,
      this.memorialName = '',
      this.timeCreated = '',
      required this.managed,
      required this.joined,
      required this.numberOfComments,
      required this.numberOfLikes,
      required this.likeStatus,
      required this.numberOfTagged,
      required this.taggedFirstName,
      required this.taggedLastName,
      required this.taggedId,
      required this.pageType,
      required this.famOrFriends,
      required this.relationship})
      : super(key: key);

  MiscRegularPostState createState() => MiscRegularPostState();
}

class MiscRegularPostState extends State<MiscRegularPost> {
  bool likePost = false;
  int likesCount = 0;
  int commentsCount = 0;

  void initState() {
    super.initState();
    likePost = widget.likeStatus;
    likesCount = widget.numberOfLikes;
    commentsCount = widget.numberOfComments;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return GestureDetector(
      onTap: () async{
        final returnValue = await Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularShowOriginalPostComments(postId: widget.postId)));
        print('The return value is $returnValue');
        commentsCount = int.parse(returnValue.toString());
        setState(() {
          print('Refreshed!');
        });
      },
      child: Container(
        padding: const EdgeInsets.only(
          left: 10.0,
          right: 10.0,
        ),
        decoration: BoxDecoration(
          color: const Color(0xffffffff),
          borderRadius: const BorderRadius.all(
            Radius.circular(15),
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: const Color(0xff888888).withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 0)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ListTile(
              onTap: () {
                if (widget.pageType == 'Memorial') {
                  if (widget.managed == true || widget.famOrFriends == true) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomeRegularProfile(
                                  memorialId: widget.memorialId,
                                  relationship: widget.relationship,
                                  managed: widget.managed,
                                  newlyCreated: false,
                                )));
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomeRegularMemorialProfile(
                                  memorialId: widget.memorialId,
                                  pageType: widget.pageType,
                                  newJoin: widget.joined,
                                )));
                  }
                } else {
                  if (widget.managed == true || widget.famOrFriends == true) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomeBLMProfile(
                                  memorialId: widget.memorialId,
                                  relationship: widget.relationship,
                                  managed: widget.managed,
                                  newlyCreated: false,
                                )));
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomeBLMMemorialProfile(
                                  memorialId: widget.memorialId,
                                  pageType: widget.pageType,
                                  newJoin: widget.joined,
                                )));
                  }
                }
              },
              contentPadding: EdgeInsets.zero,
              leading: widget.profileImage != ''
                  ? CircleAvatar(
                      backgroundColor: const Color(0xff888888),
                      foregroundImage: NetworkImage(widget.profileImage),
                      backgroundImage:
                          const AssetImage('assets/icons/app-icon.png'),
                    )
                  : const CircleAvatar(
                      backgroundColor: const Color(0xff888888),
                      foregroundImage:
                          const AssetImage('assets/icons/app-icon.png'),
                    ),
              title: Text(
                widget.memorialName,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: SizeConfig.blockSizeVertical! * 2.64,
                  fontFamily: 'NexaBold',
                  color: const Color(0xff000000),
                ),
              ),
              subtitle: Text(
                widget.timeCreated,
                maxLines: 1,
                style: TextStyle(
                  fontSize: SizeConfig.blockSizeVertical! * 1.56,
                  fontFamily: 'NexaRegular',
                  color: const Color(0xffB1B1B1),
                ),
              ),
              trailing: MiscRegularDropDownTemplate(
                postId: widget.postId,
                likePost: likePost,
                likesCount: likesCount,
                reportType: 'Post',
                pageType: widget.pageType,
              ),
            ),
            Column(
              children: widget.contents,
            ),
            widget.numberOfTagged != 0
                ? Column(
                    children: [
                      const SizedBox(height: 10),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: RichText(
                            text: TextSpan(
                              children: [
                                const TextSpan(
                                    style: const TextStyle(
                                        color: const Color(0xff888888)),
                                    text: 'with '),
                                TextSpan(
                                  children: List.generate(
                                    widget.numberOfTagged,
                                    (index) => TextSpan(
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: const Color(0xff000000)),
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: widget.taggedFirstName[index],
                                          ),
                                          TextSpan(text: ' '),
                                          TextSpan(
                                            text: widget.taggedLastName[index],
                                          ),
                                          index < widget.numberOfTagged - 1
                                              ? const TextSpan(text: ', ')
                                              : const TextSpan(text: ''),
                                        ],
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        HomeRegularUserProfile(
                                                            userId:
                                                                widget.taggedId[
                                                                    index],
                                                            accountType:
                                                                widget.pageType ==
                                                                        'BLM'
                                                                    ? 1
                                                                    : 2)));
                                          }),
                                  ),
                                ),
                              ],
                            ),
                          ))
                    ],
                  )
                : Container(
                    height: 0,
                  ),
            Row(
              children: [
                TextButton.icon(
                  onPressed: () async {
                    setState(() {
                      likePost = !likePost;

                      if (likePost == true) {
                        likesCount++;
                      } else {
                        likesCount--;
                      }
                    });

                    await apiRegularLikeOrUnlikePost(
                        postId: widget.postId, like: likePost);
                  },
                  icon: likePost == true
                      ? const FaIcon(
                          FontAwesomeIcons.solidHeart,
                          color: const Color(0xffE74C3C),
                        )
                      : const FaIcon(
                          FontAwesomeIcons.heart,
                          color: const Color(0xff888888),
                        ),
                  label: Text(
                    '$likesCount',
                    style: TextStyle(
                      fontSize: SizeConfig.blockSizeVertical! * 2.11,
                      fontFamily: 'NexaRegular',
                      color: const Color(0xff000000),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                TextButton.icon(
                  onPressed: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                HomeRegularShowOriginalPostComments(
                                    postId: widget.postId)));
                  },
                  icon: const FaIcon(FontAwesomeIcons.solidComment, color: const Color(0xff4EC9D4),),
                  label: Text('$commentsCount',  style: TextStyle(
                    fontSize: SizeConfig.blockSizeVertical! * 2.11,
                    fontFamily: 'NexaRegular',
                    color: const Color(0xff000000),
                  ),),
                ),
                IconButton(
                  alignment: Alignment.centerRight,
                  splashColor: Colors.transparent,
                  icon: const CircleAvatar(
                    backgroundColor: const Color(0xff4EC9D4),
                    child: const Icon(Icons.share_rounded,
                        color: const Color(0xffffffff)),
                  ),
                  onPressed: () async {
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
                          ..addCustomMetadata(
                              'link-number-of-likes', likesCount)
                          ..addCustomMetadata(
                              'link-type-of-account', 'Memorial'));

                    BranchLinkProperties lp = BranchLinkProperties(
                        feature: 'sharing',
                        stage: 'new share',
                        tags: ['one', 'two', 'three']);
                    lp.addControlParam('url',
                        'https://4n5z1.test-app.link/qtdaGGTx3cb?bnc_validate=true');

                    FlutterBranchSdk.setIdentity('alm-share-link');

                    BranchResponse response = await FlutterBranchSdk.showShareSheet(
                        buo: buo,
                        linkProperties: lp,
                        messageText: 'FacesbyPlaces App',
                        androidMessageTitle:
                            'FacesbyPlaces - Create a memorial page for loved ones by sharing stories, special events and photos of special occasions. Keeping their memories alive for generations',
                        androidSharingTitle:
                            'FacesbyPlaces - Create a memorial page for loved ones by sharing stories, special events and photos of special occasions. Keeping their memories alive for generations');

                    if (response.success) {
                      await showDialog(
                          context: context,
                          builder: (_) => AssetGiffyDialog(
                                image: Image.asset(
                                  'assets/icons/cover-icon.png',
                                  fit: BoxFit.cover,
                                ),
                                title: Text(
                                  'Success',
                                  textAlign: TextAlign.center,
                                  style:  TextStyle(
                                      fontSize: SizeConfig.blockSizeVertical! * 3.87,
                                      fontFamily: 'NexaRegular'),
                                ),
                                entryAnimation: EntryAnimation.DEFAULT,
                                description: Text(
                                  'Successfully shared the link.',
                                  textAlign: TextAlign.center,
                                  style:  TextStyle(
                                      fontSize: SizeConfig.blockSizeVertical! * 2.87,
                                      fontFamily: 'NexaRegular'
                                  ),
                                ),
                                onlyOkButton: true,
                                onOkButtonPressed: () {
                                  Navigator.pop(context, true);
                                },
                              ));
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
