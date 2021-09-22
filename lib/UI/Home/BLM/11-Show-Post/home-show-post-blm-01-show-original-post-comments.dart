// ignore_for_file: file_names
import 'package:facesbyplaces/API/BLM/02-Main/api_main_blm_02_show_user_information.dart';
import 'package:facesbyplaces/API/BLM/12-Show-Post/api_show_post_blm_01_show_original_post.dart';
import 'package:facesbyplaces/API/BLM/12-Show-Post/api_show_post_blm_02_show_post_comments.dart';
import 'package:facesbyplaces/API/BLM/12-Show-Post/api_show_post_blm_03_show_comment_replies.dart';
import 'package:facesbyplaces/API/BLM/12-Show-Post/api_show_post_blm_04_show_comment_or_reply_like_status.dart';
import 'package:facesbyplaces/API/BLM/12-Show-Post/api_show_post_blm_06_add_comment.dart';
import 'package:facesbyplaces/API/BLM/12-Show-Post/api_show_post_blm_07_add_reply.dart';
import 'package:facesbyplaces/API/BLM/12-Show-Post/api_show_post_blm_08_comment_reply_like_or_unlike.dart';
import 'package:facesbyplaces/API/BLM/12-Show-Post/api_show_post_blm_09_delete_comment.dart';
import 'package:facesbyplaces/API/BLM/12-Show-Post/api_show_post_blm_10_edit_comment.dart';
import 'package:facesbyplaces/API/BLM/12-Show-Post/api_show_post_blm_11_delete_reply.dart';
import 'package:facesbyplaces/API/BLM/12-Show-Post/api_show_post_blm_12_edit_reply.dart';
import 'package:facesbyplaces/UI/Home/BLM/02-View-Memorial/home-view-memorial-blm-04-maps.dart';
import 'package:facesbyplaces/UI/Home/BLM/06-Report/home-report-blm-01-report.dart';
import 'package:facesbyplaces/UI/Home/Regular/02-View-Memorial/home-view-memorial-regular-01-managed-memorial.dart';
import 'package:facesbyplaces/UI/Home/Regular/02-View-Memorial/home-view-memorial-regular-02-profile-memorial.dart';
import 'package:facesbyplaces/UI/Home/BLM/02-View-Memorial/home-view-memorial-blm-01-managed-memorial.dart';
import 'package:facesbyplaces/UI/Home/BLM/02-View-Memorial/home-view-memorial-blm-02-profile-memorial.dart';
import 'package:facesbyplaces/UI/Home/BLM/12-Show-User/home-show-user-blm-01-user.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-08-blm-message.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-11-blm-dropdown.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:keyboard_attachable/keyboard_attachable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:extended_image/extended_image.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:better_player/better_player.dart';
import 'package:timeago/timeago.dart' as timeago;
// ignore: import_of_legacy_library_into_null_safe
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'dart:ui';

class BLMOriginalComment{
  final int commentId;
  final int postId;
  final int userId;
  final String commentBody;
  final String createdAt;
  final String firstName;
  final String lastName;
  final dynamic image;
  final bool commentLikes;
  final int commentNumberOfLikes;
  final int userAccountType;
  final List<BLMOriginalReply> listOfReplies;
  const BLMOriginalComment({required this.commentId, required this.postId, required this.userId, required this.commentBody, required this.createdAt, required this.firstName, required this.lastName, required this.image, required this.commentLikes, required this.commentNumberOfLikes, required this.userAccountType, required this.listOfReplies});
}

class BLMOriginalReply{
  final int replyId;
  final int commentId;
  final int userId;
  final String replyBody;
  final String createdAt;
  final String firstName;
  final String lastName;
  final dynamic image;
  final bool replyLikes;
  final int replyNumberOfLikes;
  final int userAccountType;
  const BLMOriginalReply({required this.replyId, required this.commentId, required this.userId, required this.replyBody, required this.createdAt, required this.firstName, required this.lastName, required this.image, required this.replyLikes, required this.replyNumberOfLikes, required this.userAccountType});
}

class HomeBLMShowOriginalPostComments extends StatefulWidget{
  final int postId;
  const HomeBLMShowOriginalPostComments({Key? key, required this.postId}) : super(key: key);

  @override
  HomeBLMShowOriginalPostCommentsState createState() => HomeBLMShowOriginalPostCommentsState();
}

class HomeBLMShowOriginalPostCommentsState extends State<HomeBLMShowOriginalPostComments>{
  ValueNotifier<List<BLMOriginalComment>> comments = ValueNotifier<List<BLMOriginalComment>>([]);
  ValueNotifier<List<BLMOriginalReply>> replies = ValueNotifier<List<BLMOriginalReply>>([]);
  GlobalKey profileKey = GlobalKey<HomeBLMShowOriginalPostCommentsState>();
  CarouselController buttonCarouselController = CarouselController();
  TextEditingController controller = TextEditingController(text: '');
  ValueNotifier<bool> isGuestLoggedIn = ValueNotifier<bool>(true);
  ScrollController scrollController = ScrollController();
  Future<APIBLMShowOriginalPostMain>? showOriginalPost;
  ValueNotifier<int> count = ValueNotifier<int>(0);
  List<List<int>> repliesNumberOfLikes = [];
  List<int> commentsNumberOfLikes = [];
  List<List<bool>> repliesLikes = [];
  List<bool> commentsLikes = [];
  String currentUserImage = '';
  String pageName = '';
  int currentAccountType = 1;
  int currentCommentId = 1;
  int repliesRemaining = 1;
  int numberOfComments = 0;
  bool pressedLike = false;
  int numberOfReplies = 0;
  int itemRemaining = 1;
  bool isComment = true;
  bool likePost = false;
  int numberOfLikes = 0;
  int? currentUserId;
  int likesCount = 0;
  int page1 = 1;
  int page2 = 1;

  @override
  void initState(){
    super.initState();
    isGuest();
    likesCount = numberOfLikes;
  }

  void isGuest() async{
    final sharedPrefs = await SharedPreferences.getInstance();
    bool regularSession = sharedPrefs.getBool('regular-user-session') ?? false;
    bool blmSession = sharedPrefs.getBool('blm-user-session') ?? false;

    if(regularSession == true || blmSession == true){
      isGuestLoggedIn.value = false;
    }

    if(isGuestLoggedIn.value != true){
      showOriginalPost = getOriginalPost(widget.postId);
      getOriginalPostInformation();
      getProfilePicture();
      onLoading();
      scrollController.addListener((){
        if(scrollController.position.pixels == scrollController.position.maxScrollExtent){
          if(itemRemaining != 0){
            onLoading();
          }else{
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('No more comments to show'),
                duration: Duration(seconds: 1),
                backgroundColor: Color(0xff4EC9D4),
              ),
            );
          }
        }
      });
    }
  }

  Future<void> onRefresh() async{
    onLoading();
  }

  void getOriginalPostInformation() async{
    var originalPostInformation = await apiBLMShowOriginalPost(postId: widget.postId);
    numberOfLikes = originalPostInformation.blmPost.showOriginalPostNumberOfLikes;
    numberOfComments = originalPostInformation.blmPost.showOriginalPostNumberOfComments;
    likePost = originalPostInformation.blmPost.showOriginalPostLikeStatus;
  }

  void getProfilePicture() async{
    var getProfilePicture = await apiBLMShowProfileInformation();
    currentUserImage = getProfilePicture.showProfileInformationImage;
    currentUserId = getProfilePicture.showProfileInformationUserId;
    currentAccountType = getProfilePicture.showProfileInformationAccountType;
  }

  void onLoading() async{
    if(itemRemaining != 0){
      context.loaderOverlay.show();
      var newValue1 = await apiBLMShowListOfComments(postId: widget.postId, page: page1);
      itemRemaining = newValue1.blmItemsRemaining;
      count.value = count.value + newValue1.blmCommentsList.length;

      for(int i = 0; i < newValue1.blmCommentsList.length; i++){
        var commentLikeStatus = await apiBLMShowCommentOrReplyLikeStatus(commentableType: 'Comment', commentableId: newValue1.blmCommentsList[i].showListCommentsCommentId);
        commentsLikes.add(commentLikeStatus.showCommentOrReplyLikeStatus);
        commentsNumberOfLikes.add(commentLikeStatus.showCommentOrReplyNumberOfLikes);

        if(repliesRemaining != 0){
          var newValue2 = await apiBLMShowListOfReplies(postId: newValue1.blmCommentsList[i].showListCommentsCommentId, page: page2);

          List<bool> newRepliesLikes = [];
          List<int> newRepliesNumberOfLikes = [];
          List<int> newReplyId = [];

          for(int j = 0; j < newValue2.blmRepliesList.length; j++){
            var replyLikeStatus = await apiBLMShowCommentOrReplyLikeStatus(commentableType: 'Reply', commentableId: newValue2.blmRepliesList[j].showListRepliesReplyId);
            newRepliesLikes.add(replyLikeStatus.showCommentOrReplyLikeStatus);
            newRepliesNumberOfLikes.add(replyLikeStatus.showCommentOrReplyNumberOfLikes);
            newReplyId.add(newValue2.blmRepliesList[j].showListRepliesReplyId);

            replies.value.add(
              BLMOriginalReply(
                replyId: newValue2.blmRepliesList[j].showListRepliesReplyId,
                commentId: newValue2.blmRepliesList[j].showListRepliesCommentId,
                userId: newValue2.blmRepliesList[j].showListRepliesUser.showListRepliesUserUserId,
                replyBody: newValue2.blmRepliesList[j].showListRepliesReplyBody,
                createdAt: newValue2.blmRepliesList[j].showListRepliesCreatedAt,
                firstName: newValue2.blmRepliesList[j].showListRepliesUser.showListRepliesUserFirstName,
                lastName: newValue2.blmRepliesList[j].showListRepliesUser.showListRepliesUserLastName,
                replyLikes: replyLikeStatus.showCommentOrReplyLikeStatus,
                replyNumberOfLikes: replyLikeStatus.showCommentOrReplyNumberOfLikes,
                image: newValue2.blmRepliesList[j].showListRepliesUser.showListRepliesUserImage,
                userAccountType: newValue2.blmRepliesList[j].showListRepliesUser.showListRepliesUserAccountType,
              ),
            );
          }

          repliesLikes.add(newRepliesLikes);
          repliesNumberOfLikes.add(newRepliesNumberOfLikes);
          repliesRemaining = newValue2.blmItemsRemaining;
          page2++;
        }

        repliesRemaining = 1;
        page2 = 1;

        comments.value.add(
          BLMOriginalComment(
            commentId: newValue1.blmCommentsList[i].showListCommentsCommentId,
            postId: newValue1.blmCommentsList[i].showListCommentsPostId,
            userId: newValue1.blmCommentsList[i].showListCommentsUser.showListCommentsUserUserId,
            commentBody: newValue1.blmCommentsList[i].showListCommentsCommentBody,
            createdAt: newValue1.blmCommentsList[i].showListCommentsCreatedAt,
            firstName: newValue1.blmCommentsList[i].showListCommentsUser.showListCommentsUserFirstName,
            lastName: newValue1.blmCommentsList[i].showListCommentsUser.showListCommentsUserLastName,
            image: newValue1.blmCommentsList[i].showListCommentsUser.showListCommentsUserImage,
            commentLikes: commentLikeStatus.showCommentOrReplyLikeStatus,
            commentNumberOfLikes: commentLikeStatus.showCommentOrReplyNumberOfLikes,
            listOfReplies: replies.value,
            userAccountType: newValue1.blmCommentsList[i].showListCommentsUser.showListCommentsUserAccountType,
          ),
        );
        replies.value = [];
      }

      if(mounted){
        page1++;
      }
      context.loaderOverlay.hide();
    }
  }

  Future<APIBLMShowOriginalPostMain> getOriginalPost(postId) async{
    return await apiBLMShowOriginalPost(postId: postId);
  }

  @override
  Widget build(BuildContext context){
    SizeConfig.init(context);
    return WillPopScope(
      onWillPop: () async{
        return Navigator.canPop(context);
      },
      child: GestureDetector(
        onTap: (){
          FocusNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: ValueListenableBuilder(
          valueListenable: isGuestLoggedIn,
          builder: (_, bool isGuestLoggedInListener, __) => ValueListenableBuilder(
            valueListenable: count,
            builder: (_, int countListener, __) => ValueListenableBuilder(
              valueListenable: comments,
              builder: (_, List<BLMOriginalComment> commentsListener, __) => ValueListenableBuilder(
                valueListenable: replies,
                builder: (_, List<BLMOriginalReply> repliesListener, __) => Scaffold(
                  appBar: AppBar(
                    backgroundColor: const Color(0xff04ECFF),
                    title: const Text('Post', style: TextStyle(fontSize: 26, fontFamily: 'NexaRegular', color: Color(0xffffffff),),),
                    centerTitle: true,
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Color(0xffffffff), size: 35),
                      onPressed: (){
                        Navigator.pop(context, numberOfComments);
                      },
                    ),
                    actions: [
                      MiscBLMDropDownTemplate(
                        postId: widget.postId,
                        likePost: likePost,
                        likesCount: likesCount,
                        reportType: 'Post',
                        pageType: 'Blm',
                        pageName: pageName,
                      ),
                    ],
                  ),
                  backgroundColor: const Color(0xffffffff),
                  body: Stack(
                    children: [
                      isGuestLoggedInListener
                      ? Container(height: 0,)
                      : IgnorePointer(
                          ignoring: isGuestLoggedInListener,
                          child: FutureBuilder<APIBLMShowOriginalPostMain>(
                            future: showOriginalPost,
                            builder: (context, originalPost){
                            if(originalPost.hasData){
                              return FooterLayout(
                                footer: showKeyboard(),
                                child: RefreshIndicator(
                                  onRefresh: onRefresh,
                                  child: CustomScrollView(
                                    physics: const ClampingScrollPhysics(),
                                    controller: scrollController,
                                    slivers: <Widget>[
                                      SliverToBoxAdapter(
                                        child: Column(
                                          key: profileKey,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                                              height: 80,
                                              child: Row(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () async{
                                                      if(originalPost.data!.blmPost.showOriginalPostPage.showOriginalPostPagePageType == 'Memorial'){
                                                        if(originalPost.data!.blmPost.showOriginalPostPage.showOriginalPostPageManage == true || originalPost.data!.blmPost.showOriginalPostPage.showOriginalPostPageFamOrFriends == true) {
                                                          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularProfile(memorialId: originalPost.data!.blmPost.showOriginalPostPage.showOriginalPostPageId, relationship: originalPost.data!.blmPost.showOriginalPostPage.showOriginalPostPageRelationship, managed: originalPost.data!.blmPost.showOriginalPostPage.showOriginalPostPageManage, newlyCreated: false,),),);
                                                        }else{
                                                          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularMemorialProfile(memorialId: originalPost.data!.blmPost.showOriginalPostPage.showOriginalPostPageId, pageType: originalPost.data!.blmPost.showOriginalPostPage.showOriginalPostPagePageType, newJoin: originalPost.data!.blmPost.showOriginalPostPage.showOriginalPostPageFollower,),),);
                                                        }
                                                      }else{
                                                        if(originalPost.data!.blmPost.showOriginalPostPage.showOriginalPostPageManage == true || originalPost.data!.blmPost.showOriginalPostPage.showOriginalPostPageFamOrFriends == true){
                                                          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMProfile(memorialId: originalPost.data!.blmPost.showOriginalPostPage.showOriginalPostPageId, relationship: originalPost.data!.blmPost.showOriginalPostPage.showOriginalPostPageRelationship, managed: originalPost.data!.blmPost.showOriginalPostPage.showOriginalPostPageManage, newlyCreated: false,),),);
                                                        }else{
                                                          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMMemorialProfile(memorialId: originalPost.data!.blmPost.showOriginalPostPage.showOriginalPostPageId, pageType: originalPost.data!.blmPost.showOriginalPostPage.showOriginalPostPagePageType, newJoin: originalPost.data!.blmPost.showOriginalPostPage.showOriginalPostPageFollower,),),);
                                                        }
                                                      }
                                                    },
                                                    child: originalPost.data!.blmPost.showOriginalPostPage.showOriginalPostPageProfileImage != ''
                                                    ? CircleAvatar(
                                                      backgroundColor: const Color(0xff888888),
                                                      foregroundImage: NetworkImage(originalPost.data!.blmPost.showOriginalPostPage.showOriginalPostPageProfileImage),
                                                    )
                                                    : const CircleAvatar(
                                                      backgroundColor: Color(0xff888888),
                                                      foregroundImage: AssetImage('assets/icons/user-placeholder.png'),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      padding: const EdgeInsets.only(left: 10.0),
                                                      child: GestureDetector(
                                                        onTap: () async{
                                                          if(originalPost.data!.blmPost.showOriginalPostPage.showOriginalPostPagePageType == 'Memorial'){
                                                            if(originalPost.data!.blmPost.showOriginalPostPage.showOriginalPostPageManage == true || originalPost.data!.blmPost.showOriginalPostPage.showOriginalPostPageFamOrFriends == true){
                                                              Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularProfile(memorialId: originalPost.data!.blmPost.showOriginalPostPage.showOriginalPostPageId, relationship: originalPost.data!.blmPost.showOriginalPostPage.showOriginalPostPageRelationship, managed: originalPost.data!.blmPost.showOriginalPostPage.showOriginalPostPageManage, newlyCreated: false,),),);
                                                            }else{
                                                              Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularMemorialProfile(memorialId: originalPost.data!.blmPost.showOriginalPostPage.showOriginalPostPageId, pageType: originalPost.data!.blmPost.showOriginalPostPage.showOriginalPostPagePageType, newJoin: originalPost.data!.blmPost.showOriginalPostPage.showOriginalPostPageFollower,),),);
                                                            }
                                                          }else{
                                                            if(originalPost.data!.blmPost.showOriginalPostPage.showOriginalPostPageManage == true || originalPost.data!.blmPost.showOriginalPostPage.showOriginalPostPageFamOrFriends == true){
                                                              Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMProfile(memorialId: originalPost.data!.blmPost.showOriginalPostPage.showOriginalPostPageId, relationship: originalPost.data!.blmPost.showOriginalPostPage.showOriginalPostPageRelationship, managed: originalPost.data!.blmPost.showOriginalPostPage.showOriginalPostPageManage, newlyCreated: false,),),);
                                                            }else{
                                                              Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMMemorialProfile(memorialId: originalPost.data!.blmPost.showOriginalPostPage.showOriginalPostPageId, pageType: originalPost.data!.blmPost.showOriginalPostPage.showOriginalPostPagePageType, newJoin: originalPost.data!.blmPost.showOriginalPostPage.showOriginalPostPageFollower,),),);
                                                            }
                                                          }
                                                        },
                                                        child: Column(
                                                          children: [
                                                            Expanded(
                                                              child: Align(
                                                                alignment: Alignment.bottomLeft, 
                                                                child: Text(originalPost.data!.blmPost.showOriginalPostPage.showOriginalPostPageName,
                                                                  overflow: TextOverflow.ellipsis,
                                                                  style: const TextStyle(
                                                                    fontSize: 22,
                                                                    fontFamily: 'NexaBold',
                                                                    color: Color(0xff000000),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Align(
                                                                alignment: Alignment.topLeft,
                                                                child: Text(timeago.format(DateTime.parse(originalPost.data!.blmPost.showOriginalPostCreatedAt),),
                                                                  maxLines: 1, 
                                                                  style: const TextStyle(
                                                                    fontSize: 18,
                                                                    fontFamily: 'NexaBold',
                                                                    color: Color(0xffBDC3C7),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                                              alignment: Alignment.centerLeft,
                                              child: Text(originalPost.data!.blmPost.showOriginalPostBody, style: const TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xff000000),),),
                                            ),
                                            originalPost.data!.blmPost.showOriginalPostImagesOrVideos.isNotEmpty
                                            ? Column(
                                              children: [
                                                const SizedBox(height: 20),

                                                Container(
                                                  child: ((){
                                                    if(originalPost.data!.blmPost.showOriginalPostImagesOrVideos.length == 1){
                                                      return GestureDetector(
                                                        onTap: (){
                                                          showGeneralDialog(
                                                            context: context,
                                                            transitionDuration: const Duration(milliseconds: 0),
                                                            barrierDismissible: true,
                                                            barrierLabel: 'Dialog',
                                                            pageBuilder: (_, __, ___){
                                                              return Scaffold(
                                                                backgroundColor: Colors.black12.withOpacity(0.7),
                                                                body: SizedBox.expand(
                                                                  child: SafeArea(
                                                                    child: Column(
                                                                      children: [
                                                                        Container(
                                                                          alignment: Alignment.centerRight,
                                                                          padding: const EdgeInsets.only(right: 20.0),
                                                                          child: GestureDetector(
                                                                            child: CircleAvatar(radius: 20, backgroundColor: const Color(0xff000000).withOpacity(0.8), child: const Icon(Icons.close_rounded, color: Color(0xffffffff),),),
                                                                            onTap: (){
                                                                              Navigator.pop(context);
                                                                            },
                                                                          ),
                                                                        ),

                                                                        const SizedBox(height: 10,),

                                                                        Expanded(
                                                                          child: (() {
                                                                            if(lookupMimeType(originalPost.data!.blmPost.showOriginalPostImagesOrVideos[0])?.contains('video') == true){
                                                                              return BetterPlayer.network('${originalPost.data!.blmPost.showOriginalPostImagesOrVideos[0]}',
                                                                                betterPlayerConfiguration: BetterPlayerConfiguration(
                                                                                  placeholder: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 16 / 9),
                                                                                  deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
                                                                                  aspectRatio: 16 / 9,
                                                                                  fit: BoxFit.contain,
                                                                                ),
                                                                              );
                                                                            }else{
                                                                              return ExtendedImage.network(
                                                                                originalPost.data!.blmPost.showOriginalPostImagesOrVideos[0],
                                                                                fit: BoxFit.contain,
                                                                                loadStateChanged: (ExtendedImageState loading){
                                                                                  if(loading.extendedImageLoadState == LoadState.loading || loading.extendedImageLoadState == LoadState.failed){
                                                                                    return Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,);
                                                                                  }
                                                                                },
                                                                                mode: ExtendedImageMode.gesture,
                                                                              );
                                                                            }
                                                                          }()),
                                                                        ),
                                                                        
                                                                        const SizedBox(height: 85,),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          );
                                                        },
                                                        child: ((){
                                                          if(lookupMimeType(originalPost.data!.blmPost.showOriginalPostImagesOrVideos[0])?.contains('video') == true){
                                                            return BetterPlayer.network('${originalPost.data!.blmPost.showOriginalPostImagesOrVideos[0]}',
                                                              betterPlayerConfiguration: BetterPlayerConfiguration(
                                                                placeholder: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 16 / 9),
                                                                controlsConfiguration: const BetterPlayerControlsConfiguration(showControls: false,),
                                                                aspectRatio: 16 / 9,
                                                                fit: BoxFit.contain,
                                                              ),
                                                            );
                                                          }else{
                                                            return CachedNetworkImage(
                                                              fit: BoxFit.cover,
                                                              imageUrl: originalPost.data!.blmPost.showOriginalPostImagesOrVideos[0],
                                                              placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                              errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                            );
                                                          }
                                                        }()),
                                                      );
                                                    }else if(originalPost.data!.blmPost.showOriginalPostImagesOrVideos.length == 2){
                                                      return StaggeredGridView.countBuilder(
                                                        staggeredTileBuilder: (int index) => const StaggeredTile.count(2,2),
                                                        physics: const NeverScrollableScrollPhysics(),
                                                        padding: EdgeInsets.zero,
                                                        crossAxisSpacing: 4.0,
                                                        mainAxisSpacing: 4.0,
                                                        crossAxisCount: 4,
                                                        shrinkWrap: true,
                                                        itemCount: 2,
                                                        itemBuilder: (BuildContext context, int index) => GestureDetector(
                                                          child: (() {
                                                            if(lookupMimeType(originalPost.data!.blmPost.showOriginalPostImagesOrVideos[index])?.contains('video') == true){
                                                              return BetterPlayer.network('${originalPost.data!.blmPost.showOriginalPostImagesOrVideos[index]}',
                                                                betterPlayerConfiguration: BetterPlayerConfiguration(
                                                                  placeholder: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 16 / 9),
                                                                  aspectRatio: 16 / 9,
                                                                  fit: BoxFit.contain,
                                                                  controlsConfiguration: const BetterPlayerControlsConfiguration(showControls: false,),
                                                                ),
                                                              );
                                                            }else{
                                                              return CachedNetworkImage(
                                                                fit: BoxFit.cover,
                                                                imageUrl: originalPost.data!.blmPost.showOriginalPostImagesOrVideos[index],
                                                                placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                                errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                              );
                                                            }
                                                          }()),
                                                          onTap: (){
                                                            showGeneralDialog(
                                                              context: context,
                                                              barrierDismissible: true,
                                                              barrierLabel: 'Dialog',
                                                              transitionDuration: const Duration(milliseconds: 0),
                                                              pageBuilder: (_, __, ___){
                                                                return Scaffold(
                                                                  backgroundColor: Colors.black12.withOpacity(0.7),
                                                                  body: SizedBox.expand(
                                                                    child: SafeArea(
                                                                      child: Column(
                                                                        children: [
                                                                          Container(
                                                                            alignment: Alignment.centerRight,
                                                                            padding: const EdgeInsets.only(right: 20.0),
                                                                            child: GestureDetector(
                                                                              child: CircleAvatar(
                                                                                radius: 20,
                                                                                backgroundColor: const Color(0xff000000).withOpacity(0.8),
                                                                                child: const Icon(Icons.close_rounded, color: Color(0xffffffff),),
                                                                              ),
                                                                              onTap: (){
                                                                                Navigator.pop(context);
                                                                              },
                                                                            ),
                                                                          ),

                                                                          const SizedBox(height: 10,),

                                                                          Expanded(
                                                                            child: CarouselSlider(
                                                                              carouselController: buttonCarouselController,
                                                                              items: List.generate(
                                                                                originalPost.data!.blmPost.showOriginalPostImagesOrVideos.length, (next) => ((){
                                                                                  if(lookupMimeType(originalPost.data!.blmPost.showOriginalPostImagesOrVideos[next])?.contains('video') == true){
                                                                                    return BetterPlayer.network('${originalPost.data!.blmPost.showOriginalPostImagesOrVideos[index]}',
                                                                                      betterPlayerConfiguration: BetterPlayerConfiguration(
                                                                                        placeholder: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 16 / 9),
                                                                                        deviceOrientationsAfterFullScreen: [
                                                                                          DeviceOrientation.portraitUp
                                                                                        ],
                                                                                        autoDispose: false,
                                                                                        aspectRatio: 16 / 9,
                                                                                        fit: BoxFit.contain,
                                                                                      ),
                                                                                    );
                                                                                  }else{
                                                                                    return ExtendedImage.network(
                                                                                      originalPost.data!.blmPost.showOriginalPostImagesOrVideos[next],
                                                                                      fit: BoxFit.contain,
                                                                                      loadStateChanged: (ExtendedImageState loading){
                                                                                        if(loading.extendedImageLoadState == LoadState.loading || loading.extendedImageLoadState == LoadState.failed){
                                                                                          return Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,);
                                                                                        }
                                                                                      },
                                                                                      mode: ExtendedImageMode.gesture,
                                                                                    );
                                                                                  }
                                                                                }()),
                                                                              ),
                                                                              options: CarouselOptions(
                                                                                autoPlay: false,
                                                                                enlargeCenterPage: true,
                                                                                aspectRatio: 1,
                                                                                viewportFraction: 1,
                                                                                initialPage: index,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Row(
                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                            children: [
                                                                              IconButton(
                                                                                onPressed: () => buttonCarouselController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.linear),
                                                                                icon: const Icon(Icons.arrow_back_rounded, color: Color(0xffffffff),),
                                                                              ),
                                                                              IconButton(
                                                                                onPressed: () => buttonCarouselController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.linear),
                                                                                icon: const Icon(Icons.arrow_forward_rounded, color: Color(0xffffffff),),
                                                                              ),
                                                                            ],
                                                                          ),

                                                                          const SizedBox(height: 85,),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            );
                                                          },
                                                        ),
                                                      );
                                                    }else{
                                                      return StaggeredGridView.countBuilder(
                                                        staggeredTileBuilder: (int index) => StaggeredTile.count(2, index.isEven ? 1 : 2),
                                                        physics: const NeverScrollableScrollPhysics(),
                                                        padding: EdgeInsets.zero,
                                                        crossAxisSpacing: 4.0,
                                                        mainAxisSpacing: 4.0,
                                                        crossAxisCount: 4,
                                                        shrinkWrap: true,
                                                        itemCount: 3,
                                                        itemBuilder: (BuildContext context, int index) => GestureDetector(
                                                          child: ((){
                                                            if(index != 1){
                                                              return lookupMimeType(originalPost.data!.blmPost.showOriginalPostImagesOrVideos[index])?.contains('video') == true 
                                                              ? BetterPlayer.network('${originalPost.data!.blmPost.showOriginalPostImagesOrVideos[index]}',
                                                                betterPlayerConfiguration: BetterPlayerConfiguration(
                                                                  placeholder: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 16 / 9),
                                                                  controlsConfiguration: const BetterPlayerControlsConfiguration(showControls: false,),
                                                                  aspectRatio: 16 / 9,
                                                                  fit: BoxFit.contain,
                                                                ),
                                                              )
                                                              : CachedNetworkImage(
                                                                fit: BoxFit.cover,
                                                                imageUrl: originalPost.data!.blmPost.showOriginalPostImagesOrVideos[index],
                                                                placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                                errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                              );
                                                            }else{
                                                              return ((){
                                                                if(originalPost.data!.blmPost.showOriginalPostImagesOrVideos.length - 3 > 0){
                                                                  if(lookupMimeType(originalPost.data!.blmPost.showOriginalPostImagesOrVideos[index])?.contains('video') == true){
                                                                    return Stack(
                                                                      fit: StackFit.expand,
                                                                      children: [
                                                                        BetterPlayer.network('${originalPost.data!.blmPost.showOriginalPostImagesOrVideos[index]}',
                                                                          betterPlayerConfiguration: BetterPlayerConfiguration(
                                                                            placeholder: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 16 / 9),
                                                                            controlsConfiguration: const BetterPlayerControlsConfiguration(showControls: false,),
                                                                            aspectRatio: 16 / 9,
                                                                            fit: BoxFit.contain,
                                                                          ),
                                                                        ),

                                                                        Container(color: const Color(0xff000000).withOpacity(0.5),),

                                                                        Center(
                                                                          child: CircleAvatar(
                                                                            radius: 25,
                                                                            backgroundColor: const Color(0xffffffff).withOpacity(.5),
                                                                            child: Text('${originalPost.data!.blmPost.showOriginalPostImagesOrVideos.length - 3}', style: const TextStyle(fontSize: 32, fontFamily: 'NexaBold', color: Color(0xffFFFFFF),),),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    );
                                                                  }else{
                                                                    return Stack(
                                                                      fit: StackFit.expand,
                                                                      children: [
                                                                        CachedNetworkImage(
                                                                          fit: BoxFit.cover,
                                                                          imageUrl: originalPost.data!.blmPost.showOriginalPostImagesOrVideos[index],
                                                                          placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                                          errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                                        ),

                                                                        Container(color: const Color(0xff000000).withOpacity(0.5),),

                                                                        Center(
                                                                          child: CircleAvatar(
                                                                            radius: 25,
                                                                            backgroundColor: const Color(0xffffffff).withOpacity(.5),
                                                                            child: Text('${originalPost.data!.blmPost.showOriginalPostImagesOrVideos.length - 3}', style: const TextStyle(fontSize: 32, fontFamily: 'NexaBold', color: Color(0xffFFFFFF),),),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    );
                                                                  }
                                                                }else{
                                                                  if(lookupMimeType(originalPost.data!.blmPost.showOriginalPostImagesOrVideos[index])?.contains('video') == true){
                                                                    return BetterPlayer.network('${originalPost.data!.blmPost.showOriginalPostImagesOrVideos[index]}',
                                                                      betterPlayerConfiguration: BetterPlayerConfiguration(
                                                                        placeholder: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 16 / 9),
                                                                        controlsConfiguration: const BetterPlayerControlsConfiguration(showControls: false,),
                                                                        aspectRatio: 16 / 9,
                                                                        fit: BoxFit.contain,
                                                                      ),
                                                                    );
                                                                  }else{
                                                                    return CachedNetworkImage(
                                                                      fit: BoxFit.cover,
                                                                      imageUrl: originalPost.data!.blmPost.showOriginalPostImagesOrVideos[index],
                                                                      placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                                      errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                                    );
                                                                  }
                                                                }
                                                              }());
                                                            }
                                                          }()),
                                                          onTap: (){
                                                            showGeneralDialog(
                                                              context: context,
                                                              transitionDuration: const Duration(milliseconds: 0),
                                                              barrierDismissible: true,
                                                              barrierLabel: 'Dialog',
                                                              pageBuilder: (_, __, ___){
                                                                return Scaffold(
                                                                  backgroundColor: Colors.black12.withOpacity(0.7),
                                                                  body: SizedBox.expand(
                                                                    child: SafeArea(
                                                                      child: Column(
                                                                        children: [
                                                                          Container(
                                                                            alignment: Alignment.centerRight,
                                                                            padding: const EdgeInsets.only(right: 20.0),
                                                                            child: GestureDetector(
                                                                              child: CircleAvatar(radius: 20, backgroundColor: const Color(0xff000000).withOpacity(0.8), child: const Icon(Icons.close_rounded, color: Color(0xffffffff),),),
                                                                              onTap: (){
                                                                                Navigator.pop(context);
                                                                              },
                                                                            ),
                                                                          ),

                                                                          const SizedBox(height: 10,),

                                                                          Expanded(
                                                                            child: CarouselSlider(
                                                                              carouselController: buttonCarouselController,
                                                                              items: List.generate(
                                                                                originalPost.data!.blmPost.showOriginalPostImagesOrVideos.length, (next) => ((){
                                                                                  if(lookupMimeType(originalPost.data!.blmPost.showOriginalPostImagesOrVideos[next])?.contains('video') == true){
                                                                                    return BetterPlayer.network('${originalPost.data!.blmPost.showOriginalPostImagesOrVideos[next]}',
                                                                                      betterPlayerConfiguration: BetterPlayerConfiguration(
                                                                                        placeholder: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 16 / 9),
                                                                                        deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
                                                                                        autoDispose: false,
                                                                                        aspectRatio: 16 / 9,
                                                                                        fit: BoxFit.contain,
                                                                                      ),
                                                                                    );
                                                                                  }else{
                                                                                    return ExtendedImage.network(
                                                                                      originalPost.data!.blmPost.showOriginalPostImagesOrVideos[next],
                                                                                      fit: BoxFit.contain,
                                                                                      loadStateChanged: (ExtendedImageState loading){
                                                                                        if(loading.extendedImageLoadState == LoadState.loading || loading.extendedImageLoadState == LoadState.failed){
                                                                                          return Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,);
                                                                                        }
                                                                                      },
                                                                                      mode: ExtendedImageMode.gesture,
                                                                                    );
                                                                                  }
                                                                                }()),
                                                                              ),
                                                                              options: CarouselOptions(
                                                                                autoPlay: false,
                                                                                enlargeCenterPage: true,
                                                                                aspectRatio: 1,
                                                                                viewportFraction: 1,
                                                                                initialPage: index,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Row(
                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                            children: [
                                                                              IconButton(
                                                                                onPressed: () => buttonCarouselController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.linear),
                                                                                icon: const Icon(Icons.arrow_back_rounded, color: Color(0xffffffff),),
                                                                              ),
                                                                              IconButton(
                                                                                onPressed: () => buttonCarouselController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.linear),
                                                                                icon: const Icon(Icons.arrow_forward_rounded, color: Color(0xffffffff),),
                                                                              ),
                                                                            ],
                                                                          ),

                                                                          const SizedBox(height: 85,),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            );
                                                          },
                                                        ),
                                                      );
                                                    }
                                                  }()),
                                                ),
                                                const SizedBox( height: 20),
                                              ],
                                            )
                                            : Container(color: const Color(0xffff0000), height: 0,),

                                            originalPost.data!.blmPost.showOriginalPostPostTagged.isNotEmpty
                                            ? Column(
                                              children: [
                                                const SizedBox(height: 10),

                                                Container(
                                                  alignment: Alignment.centerLeft, 
                                                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                                                  child: RichText(
                                                    text: TextSpan(
                                                      children: [
                                                        const TextSpan(style: TextStyle(fontSize: 16, fontFamily: 'NexaRegular', color: Color(0xff888888)), text: 'with '),

                                                        TextSpan(
                                                          children: List.generate(
                                                            originalPost.data!.blmPost.showOriginalPostPostTagged.length, (index) => TextSpan(
                                                              style: const TextStyle(fontSize: 18, fontFamily: 'NexaBold', color: Color(0xff000000),),
                                                              children: <TextSpan>[
                                                                TextSpan(text: originalPost.data!.blmPost.showOriginalPostPostTagged[index].showOriginalPostTaggedFirstName + ' ' + originalPost.data!.blmPost.showOriginalPostPostTagged[index].showOriginalPostTaggedLastName,
                                                                recognizer: TapGestureRecognizer()
                                                                  ..onTap = (){
                                                                    Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMUserProfile(userId: originalPost.data!.blmPost.showOriginalPostPostTagged[index].showOriginalPostTaggedId, accountType: originalPost.data!.blmPost.showOriginalPostPostTagged[index].showOriginalPostAccountType)));
                                                                  }
                                                                ),
                                                                index < originalPost.data!.blmPost.showOriginalPostPostTagged.length - 1 ? const TextSpan(text: ', ') : const TextSpan(text: ''),
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
                                            : Container(height: 0,),

                                            originalPost.data!.blmPost.showOriginalPostLocation != ''
                                            ? Column(
                                              children: [
                                                const SizedBox(height: 10,),

                                                Padding(
                                                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                                                  child: Row(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      const Icon(Icons.place, color: Color(0xff888888)),

                                                      Expanded(
                                                        child: GestureDetector(
                                                          child: Text(originalPost.data!.blmPost.showOriginalPostLocation, style: const TextStyle(fontWeight: FontWeight.bold),),
                                                          onTap: (){
                                                            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMMaps(latitude: originalPost.data!.blmPost.showOriginalPostLatitude, longitude: originalPost.data!.blmPost.showOriginalPostLongitude, isMemorial: false, memorialName: originalPost.data!.blmPost.showOriginalPostPage.showOriginalPostPageName, memorialImage: originalPost.data!.blmPost.showOriginalPostPage.showOriginalPostPageProfileImage,)));
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            )
                                            : Container(height: 0,),

                                            Container(
                                              height: 40,
                                              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                                              child: Row(mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  Row(
                                                    children: [
                                                      likePost == true
                                                      ? const FaIcon(FontAwesomeIcons.peace, color: Color(0xffff0000),)
                                                      : const FaIcon(FontAwesomeIcons.peace, color: Color(0xff000000),),

                                                      const SizedBox(width: 10,),
                                                      
                                                      Text('$numberOfLikes', style: const TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xffBDC3C7),),),
                                                    ],
                                                  ),

                                                  const SizedBox(width: 40,),

                                                  Row(
                                                    children: [
                                                      const FaIcon(FontAwesomeIcons.comment, color: Color(0xff000000),),
                                                      
                                                      const SizedBox(width: 10,),

                                                      Text('$numberOfComments', style: const TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xffBDC3C7),),),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SliverToBoxAdapter(
                                        child: Column(
                                          children: [
                                            Column(
                                              children: List.generate(
                                                commentsListener.length, (i) => ListTile(
                                                  visualDensity: const VisualDensity(vertical: 4.0),
                                                  leading: commentsListener[i].image != ''
                                                  ? CircleAvatar(
                                                    backgroundColor: const Color(0xff888888),
                                                    foregroundImage: NetworkImage(commentsListener[i].image),
                                                  )
                                                  : const CircleAvatar(
                                                    backgroundColor: Color(0xff888888),
                                                    foregroundImage: AssetImage('assets/icons/user-placeholder.png'),
                                                  ),
                                                  title: Row(
                                                    children: [
                                                      Expanded(
                                                        child: currentUserId == commentsListener[i].userId && currentAccountType == commentsListener[i].userAccountType
                                                        ? const Text('You', style: TextStyle(fontSize: 20, fontFamily: 'NexaBold', color: Color(0xff000000),),)
                                                        : Text('${commentsListener[i].firstName}' '${commentsListener[i].lastName}', style: const TextStyle(fontSize: 20, fontFamily: 'NexaBold', color: Color(0xff000000),),),
                                                      ),

                                                      Expanded(
                                                        child: Align(
                                                          alignment: Alignment.centerRight,
                                                          child: TextButton.icon(
                                                            onPressed: () async {
                                                              if(commentsLikes[i] == true){
                                                                commentsLikes[i] = false;
                                                                commentsNumberOfLikes[i]--;

                                                                await apiBLMLikeOrUnlikeCommentReply(commentableType: 'Comment', commentableId: commentsListener[i].commentId, likeStatus: false);
                                                              }else{
                                                                commentsLikes[i] = true;
                                                                commentsNumberOfLikes[i]++;

                                                                await apiBLMLikeOrUnlikeCommentReply(commentableType: 'Comment', commentableId: commentsListener[i].commentId, likeStatus: true);
                                                              }
                                                            },
                                                            icon: commentsLikes[i] == true
                                                            ? const FaIcon(FontAwesomeIcons.peace, color: Color(0xffff0000),)
                                                            : const FaIcon(FontAwesomeIcons.peace, color: Color(0xff888888),),
                                                            label: Text('${commentsNumberOfLikes[i]}', style: const TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xffBDC3C7),),),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  subtitle: Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child: Container(
                                                              padding: const EdgeInsets.all(10.0),
                                                              child: Text(commentsListener[i].commentBody, style: const TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xffFFFFFF),),),
                                                              decoration: const BoxDecoration(color: Color(0xff4EC9D4), borderRadius: BorderRadius.all(Radius.circular(10.0)),),
                                                            ),
                                                          ),
                                                        ],
                                                      ),

                                                      const SizedBox(height: 5,),

                                                      Row(
                                                        children: [
                                                          Text(timeago.format(DateTime.parse(commentsListener[i].createdAt)), style: const TextStyle(fontSize: 18, fontFamily: 'NexaRegular', color: Color(0xff000000),),),

                                                          const SizedBox(width: 20,),

                                                          GestureDetector(
                                                            child: const Text('Reply', style: TextStyle(fontSize: 18, fontFamily: 'NexaRegular', color: Color(0xff000000),),),
                                                            onTap: () async{
                                                              if(controller.text != ''){
                                                                controller.clear();
                                                              }

                                                              isComment = false;
                                                              currentCommentId = commentsListener[i].commentId;

                                                              await showModalBottomSheet(context: context, builder: (context) => showKeyboard(isReply: true, toReply: commentsListener[i].commentBody, replyFrom: '${commentsListener[i].firstName}' '${commentsListener[i].lastName}'),);
                                                            },
                                                          ),
                                                        ],
                                                      ),

                                                      const SizedBox(height: 20,),
                                                          
                                                      commentsListener[i].listOfReplies.isNotEmpty
                                                      ? Column(
                                                          children: List.generate(commentsListener[i].listOfReplies.length,
                                                          (index) => ListTile(
                                                            contentPadding: EdgeInsets.zero, 
                                                            visualDensity: const VisualDensity(vertical: 4.0),
                                                            leading: commentsListener[i].listOfReplies[index].image != ''
                                                            ? CircleAvatar(
                                                              backgroundColor: const Color(0xff888888),
                                                              foregroundImage: NetworkImage(commentsListener[i].listOfReplies[index].image),
                                                            )
                                                            : const CircleAvatar(
                                                              backgroundColor: Color(0xff888888),
                                                              foregroundImage: AssetImage('assets/icons/user-placeholder.png'),
                                                            ),
                                                            title: Row(
                                                              children: [
                                                                Expanded(
                                                                  child: currentUserId == commentsListener[i].listOfReplies[index].userId && currentAccountType == commentsListener[i].listOfReplies[index].userAccountType
                                                                  ? const Text('You',
                                                                    style: TextStyle(
                                                                      fontSize: 20,
                                                                      fontFamily: 'NexaBold',
                                                                      color: Color(0xff000000),
                                                                    ),
                                                                  )
                                                                  : Text(commentsListener[i].listOfReplies[index].firstName + ' ' + commentsListener[i].listOfReplies[index].lastName,
                                                                    style: const TextStyle(
                                                                      fontSize: 20,
                                                                      fontFamily: 'NexaBold',
                                                                      color: Color(0xff000000),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child: Align(
                                                                    alignment: Alignment.centerRight,
                                                                    child: TextButton.icon(
                                                                      onPressed: () async{
                                                                        if(repliesLikes[i][index] == true){
                                                                          repliesLikes[i][index] = false;
                                                                          repliesNumberOfLikes[i][index]--;

                                                                          await apiBLMLikeOrUnlikeCommentReply(commentableType: 'Reply', commentableId: commentsListener[i].listOfReplies[index].replyId, likeStatus: false);
                                                                        }else{
                                                                          repliesLikes[i][index] = true;
                                                                          repliesNumberOfLikes[i][index]++;

                                                                          await apiBLMLikeOrUnlikeCommentReply(commentableType: 'Reply', commentableId: commentsListener[i].listOfReplies[index].replyId, likeStatus: true);
                                                                        }
                                                                      },
                                                                      icon: repliesLikes[i][index] == true
                                                                      ? const FaIcon(FontAwesomeIcons.peace, color: Color(0xffff0000),)
                                                                      : const FaIcon(FontAwesomeIcons.peace, color: Color(0xff888888),),
                                                                      label: Text('${repliesNumberOfLikes[i][index]}', style: const TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xffBDC3C7),),),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            subtitle: Column(
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child: Container(
                                                                        padding: const EdgeInsets.all(10.0),
                                                                        child: Text(commentsListener[i].listOfReplies[index].replyBody, style: const TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xffFFFFFF),),),
                                                                        decoration: const BoxDecoration(color: Color(0xff4EC9D4), borderRadius: BorderRadius.all(Radius.circular(10.0)),),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),

                                                                const SizedBox(height: 5,),

                                                                Row(
                                                                  children: [
                                                                    Text(timeago.format(DateTime.parse(commentsListener[i].listOfReplies[index].createdAt)),
                                                                      style: const TextStyle(
                                                                        fontSize: 18,
                                                                        fontFamily: 'NexaRegular',
                                                                        color: Color(0xff000000),
                                                                      ),
                                                                    ),

                                                                    const SizedBox(width: 40,),

                                                                    GestureDetector(
                                                                     child: const Text('Reply', style: TextStyle(fontSize: 18, fontFamily: 'NexaRegular', color: Color(0xff000000),),),
                                                                      onTap: () async{

                                                                        if(controller.text != ''){
                                                                          controller.clear();
                                                                        }

                                                                        controller.text = commentsListener[i].firstName + ' ' + commentsListener[i].lastName + ' ';
                                                                        isComment = false;
                                                                        currentCommentId = commentsListener[i].commentId;

                                                                        await showModalBottomSheet(context: context, builder: (context) => showKeyboard(isReply: true, toReply: commentsListener[i].listOfReplies[index].replyBody, replyFrom: '${commentsListener[i].listOfReplies[index].firstName}' '${commentsListener[i].listOfReplies[index].lastName}'),);
                                                                      },
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                            onTap: (){
                                                              Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMUserProfile(userId: commentsListener[i].listOfReplies[index].userId, accountType: currentAccountType,),),);
                                                            },
                                                            onLongPress: () async{
                                                              if(currentUserId == commentsListener[i].listOfReplies[index].userId && currentAccountType == commentsListener[i].listOfReplies[index].userAccountType){
                                                                await showMaterialModalBottomSheet(
                                                                  context: context,
                                                                  builder: (context) => SafeArea(
                                                                    top: false,
                                                                    child: Column(
                                                                      mainAxisSize: MainAxisSize.min,
                                                                      children: <Widget>[
                                                                        ListTile(
                                                                          title: const Text('Edit'),
                                                                          leading: const Icon(Icons.edit),
                                                                          onTap: () async{
                                                                            controller.text = controller.text + commentsListener[i].listOfReplies[index].replyBody;
                                                                            await showModalBottomSheet(context: context, builder: (context) => showKeyboardEdit(isEdit: false, editId: commentsListener[i].listOfReplies[index].replyId),);
                                                                          },
                                                                        ),
                                                                        ListTile(
                                                                          title: const Text('Delete'),
                                                                          leading: const Icon(Icons.delete),
                                                                          onTap: () async{
                                                                            context.loaderOverlay.show();
                                                                            await apiBLMDeleteReply(replyId: commentsListener[i].listOfReplies[index].replyId);
                                                                            context.loaderOverlay.hide();

                                                                            controller.clear();
                                                                            itemRemaining = 1;
                                                                            repliesRemaining = 1;
                                                                            comments.value = [];
                                                                            replies.value = [];
                                                                            numberOfReplies = 0;
                                                                            page1 = 1;
                                                                            page2 = 1;
                                                                            count.value = 0;
                                                                            commentsLikes = [];
                                                                            commentsNumberOfLikes = [];
                                                                            repliesLikes = [];
                                                                            repliesNumberOfLikes = [];
                                                                            isComment = true;
                                                                            numberOfLikes = 0;
                                                                            numberOfComments = 0;
                                                                            getOriginalPostInformation();
                                                                            onLoading();
                                                                            Navigator.pop(context);
                                                                          },
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                );
                                                              }else{
                                                                await showMaterialModalBottomSheet(
                                                                  context: context,
                                                                  builder: (context) => SafeArea(
                                                                    top: false,
                                                                    child: Column(
                                                                      mainAxisSize: MainAxisSize.min,
                                                                      children: <Widget>[
                                                                        ListTile(
                                                                          title: const Text('Report'),
                                                                          leading: const Icon(Icons.edit),
                                                                          onTap: (){
                                                                            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMReport(postId: widget.postId, reportType: 'Post')));
                                                                          },
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                );
                                                              }
                                                            },
                                                          ),
                                                        ),
                                                      )
                                                      : Container(height: 0,),
                                                    ],
                                                  ),
                                                  onTap: (){
                                                    Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMUserProfile(userId: commentsListener[i].userId, accountType: commentsListener[i].userAccountType,),),);
                                                  },
                                                  onLongPress: () async{
                                                    if(currentUserId == commentsListener[i].userId && currentAccountType == commentsListener[i].userAccountType){
                                                      await showMaterialModalBottomSheet(
                                                        context: context,
                                                        builder: (context) => SafeArea(
                                                          top: false,
                                                          child: Column(
                                                            mainAxisSize: MainAxisSize.min,
                                                            children: <Widget>[
                                                              ListTile(
                                                                title: const Text('Edit'),
                                                                leading: const Icon(Icons.edit),
                                                                onTap: () async{
                                                                  controller.text = controller.text + commentsListener[i].commentBody;
                                                                  await showModalBottomSheet(context: context, builder: (context) => showKeyboardEdit(isEdit: true, editId: commentsListener[i].commentId),);
                                                                },
                                                              ),
                                                              ListTile(
                                                                title: const Text('Delete'),
                                                                leading: const Icon(Icons.delete),
                                                                onTap: () async{
                                                                  context.loaderOverlay.show();
                                                                  await apiBLMDeleteComment(commentId: commentsListener[i].commentId);
                                                                  context.loaderOverlay.hide();

                                                                  controller.clear();
                                                                  itemRemaining = 1;
                                                                  repliesRemaining = 1;
                                                                  comments.value = [];
                                                                  replies.value = [];
                                                                  numberOfReplies = 0;
                                                                  page1 = 1;
                                                                  page2 = 1;
                                                                  count.value = 0;
                                                                  commentsLikes = [];
                                                                  commentsNumberOfLikes = [];
                                                                  repliesLikes = [];
                                                                  repliesNumberOfLikes = [];
                                                                  isComment = true;
                                                                  numberOfLikes = 0;
                                                                  numberOfComments = 0;
                                                                  getOriginalPostInformation();
                                                                  onLoading();
                                                                  Navigator.pop(context);
                                                                },
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    }else{
                                                      await showMaterialModalBottomSheet(
                                                        context: context,
                                                        builder: (context) => SafeArea(
                                                          top: false,
                                                          child: Column(
                                                            mainAxisSize: MainAxisSize.min,
                                                            children: <Widget>[
                                                              ListTile(
                                                                title: const Text('Report'),
                                                                leading: const Icon(Icons.edit),
                                                                onTap: (){
                                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMReport(postId: widget.postId, reportType: 'Post')));
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    }
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }else if(originalPost.hasError) {
                              return const MiscBLMErrorMessageTemplate();
                            }else{
                              return Container(height: 0);
                            }
                          },
                        ),
                      ),

                      isGuestLoggedInListener
                      ? BackdropFilter(filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0), child: const MiscBLMLoginToContinue(),)
                      : Container(height: 0),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  showKeyboard({bool isReply = false, String toReply = '',  String replyFrom = ''}){
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0,),
        child: isReply == true
        ? SizedBox(
          height: 200,
          child: Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.only(top: 10.0),
                        physics: const ClampingScrollPhysics(),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                const TextSpan(text: 'Replying to ', style: TextStyle(color: Color(0xff888888,), fontSize: 24, fontFamily: 'NexaRegular',)),

                                TextSpan(text: '$replyFrom\n', style: const TextStyle(color: Color(0xff000000), fontSize: 24, fontFamily: 'NexaRegular', fontWeight: FontWeight.bold)),

                                TextSpan(text: toReply, style: const TextStyle(color: Color(0xff000000), fontSize: 24, fontFamily: 'NexaRegular',)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: (){
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),

              Row(
                children: [
                  currentUserImage != ''
                  ? CircleAvatar(
                    backgroundColor: const Color(0xff888888),
                    foregroundImage: NetworkImage(currentUserImage),
                  )
                  : const CircleAvatar(
                    backgroundColor: Color(0xff888888),
                    foregroundImage: AssetImage('assets/icons/user-placeholder.png'),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        controller: controller,
                        style: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xffFFFFFF),),
                        cursorColor: const Color(0xff000000),
                        keyboardType: TextInputType.text,
                        maxLines: 2,
                        decoration: const InputDecoration(
                          filled: true,
                          labelText: 'Say something...',
                          fillColor: Color(0xffBDC3C7),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          labelStyle: TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xffFFFFFF),),
                          border: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffBDC3C7),), borderRadius: BorderRadius.all(Radius.circular(10)),),
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffBDC3C7),), borderRadius: BorderRadius.all(Radius.circular(10)),),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    child: const Text('Post', style: TextStyle(fontSize: 24, fontFamily: 'NexaBold', color: Color(0xff2F353D),),),
                    onTap: () async{
                      if(controller.text == ''){
                        await showDialog(
                          context: context,
                          builder: (_) => AssetGiffyDialog(
                            description: const Text('Please input a comment.', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular',),),
                            title: const Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontFamily: 'NexaRegular',),),
                            image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                            entryAnimation: EntryAnimation.DEFAULT,
                            buttonOkColor: const Color(0xffff0000),
                            onlyOkButton: true,
                            onOkButtonPressed: (){
                              Navigator.pop(context, true);
                            },
                          ),
                        );
                      }else if(isComment == true){
                        context.loaderOverlay.show();
                        await apiBLMAddComment(postId: widget.postId, commentBody: controller.text);
                        context.loaderOverlay.hide();

                        controller.clear();
                        itemRemaining = 1;
                        repliesRemaining = 1;
                        comments.value = [];
                        replies.value = [];
                        numberOfReplies = 0;
                        page1 = 1;
                        page2 = 1;
                        count.value = 0;
                        commentsLikes = [];
                        commentsNumberOfLikes = [];
                        repliesLikes = [];
                        repliesNumberOfLikes = [];
                        isComment = true;
                        numberOfLikes = 0;
                        numberOfComments = 0;
                        getOriginalPostInformation();
                        onLoading();
                      }else{
                        context.loaderOverlay.show();
                        apiBLMAddReply(commentId: currentCommentId, replyBody: controller.text);
                        context.loaderOverlay.hide();

                        controller.clear();
                        itemRemaining = 1;
                        repliesRemaining = 1;
                        comments.value = [];
                        replies.value = [];
                        numberOfReplies = 0;
                        page1 = 1;
                        page2 = 1;
                        count.value = 0;
                        commentsLikes = [];
                        commentsNumberOfLikes = [];
                        repliesLikes = [];
                        repliesNumberOfLikes = [];
                        isComment = true;
                        numberOfLikes = 0;
                        numberOfComments = 0;
                        getOriginalPostInformation();
                        onLoading();
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        )
        : Row(
          children: [
            currentUserImage != ''
            ? CircleAvatar(
              backgroundColor: const Color(0xff888888),
              foregroundImage: NetworkImage(currentUserImage),
            )
            : const CircleAvatar(
              backgroundColor: Color(0xff888888),
              foregroundImage: AssetImage('assets/icons/user-placeholder.png'),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  controller: controller,
                  cursorColor: const Color(0xff000000),
                  maxLines: 2,
                  keyboardType: TextInputType.text,
                  style: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xffFFFFFF),),
                  decoration: const InputDecoration(
                    filled: true,
                    labelText: 'Say something...',
                    fillColor: Color(0xffBDC3C7),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    labelStyle: TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xffFFFFFF),),
                    border: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffBDC3C7),), borderRadius: BorderRadius.all(Radius.circular(10)),),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffBDC3C7),), borderRadius: BorderRadius.all(Radius.circular(10)),),
                  ),
                ),
              ),
            ),
            GestureDetector(
              child: const Text('Post', style: TextStyle(fontSize: 24, fontFamily: 'NexaBold', color: Color(0xff2F353D),),),
              onTap: () async{
                if(controller.text == ''){
                  await showDialog(
                    context: context,
                    builder: (_) => AssetGiffyDialog(
                      description: const Text('Please input a comment.', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular',),),
                      title: const Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontFamily: 'NexaRegular',),),
                      image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                      entryAnimation: EntryAnimation.DEFAULT,
                      buttonOkColor: const Color(0xffff0000),
                      onlyOkButton: true,
                      onOkButtonPressed: (){
                        Navigator.pop(context, true);
                      },
                    ),
                  );
                }else if (isComment == true){
                  context.loaderOverlay.show();
                  await apiBLMAddComment(postId: widget.postId, commentBody: controller.text);
                  context.loaderOverlay.hide();

                  controller.clear();
                  itemRemaining = 1;
                  repliesRemaining = 1;
                  comments.value = [];
                  replies.value = [];
                  numberOfReplies = 0;
                  page1 = 1;
                  page2 = 1;
                  count.value = 0;
                  commentsLikes = [];
                  commentsNumberOfLikes = [];
                  repliesLikes = [];
                  repliesNumberOfLikes = [];
                  isComment = true;
                  numberOfLikes = 0;
                  numberOfComments = 0;
                  getOriginalPostInformation();
                  onLoading();
                }else{
                  context.loaderOverlay.show();
                  apiBLMAddReply(commentId: currentCommentId, replyBody: controller.text);
                  context.loaderOverlay.hide();

                  controller.clear();
                  itemRemaining = 1;
                  repliesRemaining = 1;
                  comments.value = [];
                  replies.value = [];
                  numberOfReplies = 0;
                  page1 = 1;
                  page2 = 1;
                  count.value = 0;
                  commentsLikes = [];
                  commentsNumberOfLikes = [];
                  repliesLikes = [];
                  repliesNumberOfLikes = [];
                  isComment = true;
                  numberOfLikes = 0;
                  numberOfComments = 0;
                  getOriginalPostInformation();
                  onLoading();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  showKeyboardEdit({required bool isEdit, required int editId}){
    // isEdit - TRUE (COMMENT) | FALSE (REPLY)
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 20.0,
          right: 20.0,
        ),
        child: Row(
          children: [
            currentUserImage != ''
            ? CircleAvatar(
              backgroundColor: const Color(0xff888888),
              foregroundImage: NetworkImage(currentUserImage),
            )
            : const CircleAvatar(
              backgroundColor: Color(0xff888888),
              foregroundImage: AssetImage('assets/icons/user-placeholder.png'),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  controller: controller,
                  cursorColor: const Color(0xff000000),
                  maxLines: 2,
                  keyboardType: TextInputType.text,
                  style: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xffFFFFFF),),
                  decoration: const InputDecoration(
                    filled: true,
                    labelText: 'Say something...',
                    fillColor: Color(0xffBDC3C7),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    labelStyle: TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xffFFFFFF),),
                    border: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffBDC3C7),), borderRadius: BorderRadius.all(Radius.circular(10)),),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffBDC3C7),), borderRadius: BorderRadius.all(Radius.circular(10)),),
                  ),
                ),
              ),
            ),
            GestureDetector(
              child: const Text('Post', style: TextStyle(fontSize: 24, fontFamily: 'NexaBold', color: Color(0xff2F353D),),),
              onTap: () async{
                if(controller.text == ''){
                  await showDialog(
                    context: context,
                    builder: (_) => AssetGiffyDialog(
                      description: const Text('Please input a comment.', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular'),),
                      title: const Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontFamily: 'NexaRegular'),),
                      image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                      entryAnimation: EntryAnimation.DEFAULT,
                      buttonOkColor: const Color(0xffff0000),
                      onlyOkButton: true,
                      onOkButtonPressed: (){
                        Navigator.pop(context, true);
                      },
                    ),
                  );
                }else if(isEdit == true){
                  context.loaderOverlay.show();
                  await apiBLMEditComment(commentId: editId, commentBody: controller.text);
                  context.loaderOverlay.hide();

                  controller.clear();
                  itemRemaining = 1;
                  repliesRemaining = 1;
                  comments.value = [];
                  replies.value = [];
                  numberOfReplies = 0;
                  page1 = 1;
                  page2 = 1;
                  count.value = 0;
                  commentsLikes = [];
                  commentsNumberOfLikes = [];
                  repliesLikes = [];
                  repliesNumberOfLikes = [];
                  isComment = true;
                  numberOfLikes = 0;
                  numberOfComments = 0;
                  getOriginalPostInformation();
                  onLoading();
                }else{
                  context.loaderOverlay.show();
                  await apiBLMEditReply(replyId: editId, replyBody: controller.text);
                  context.loaderOverlay.hide();

                  controller.clear();
                  itemRemaining = 1;
                  repliesRemaining = 1;
                  comments.value = [];
                  replies.value = [];
                  numberOfReplies = 0;
                  page1 = 1;
                  page2 = 1;
                  count.value = 0;
                  commentsLikes = [];
                  commentsNumberOfLikes = [];
                  repliesLikes = [];
                  repliesNumberOfLikes = [];
                  isComment = true;
                  numberOfLikes = 0;
                  numberOfComments = 0;
                  getOriginalPostInformation();
                  onLoading();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}