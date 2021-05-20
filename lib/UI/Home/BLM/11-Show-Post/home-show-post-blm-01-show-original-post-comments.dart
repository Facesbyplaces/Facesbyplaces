import 'package:facesbyplaces/API/BLM/02-Main/api-main-blm-02-show-user-information.dart';
import 'package:facesbyplaces/API/BLM/12-Show-Post/api-show-post-blm-01-show-original-post.dart';
import 'package:facesbyplaces/API/BLM/12-Show-Post/api-show-post-blm-02-show-post-comments.dart';
import 'package:facesbyplaces/API/BLM/12-Show-Post/api-show-post-blm-03-show-comment-replies.dart';
import 'package:facesbyplaces/API/BLM/12-Show-Post/api-show-post-blm-04-show-comment-or-reply-like-status.dart';
import 'package:facesbyplaces/API/BLM/12-Show-Post/api-show-post-blm-06-add-comment.dart';
import 'package:facesbyplaces/API/BLM/12-Show-Post/api-show-post-blm-07-add-reply.dart';
import 'package:facesbyplaces/API/BLM/12-Show-Post/api-show-post-blm-08-comment-reply-like-or-unlike.dart';
import 'package:facesbyplaces/API/BLM/12-Show-Post/api-show-post-blm-09-delete-comment.dart';
import 'package:facesbyplaces/API/BLM/12-Show-Post/api-show-post-blm-10-edit-comment.dart';
import 'package:facesbyplaces/API/BLM/12-Show-Post/api-show-post-blm-11-delete-reply.dart';
import 'package:facesbyplaces/API/BLM/12-Show-Post/api-show-post-blm-12-edit-reply.dart';
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
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
  const HomeBLMShowOriginalPostComments({required this.postId});

  @override
  HomeBLMShowOriginalPostCommentsState createState() => HomeBLMShowOriginalPostCommentsState(postId: postId);
}

class HomeBLMShowOriginalPostCommentsState extends State<HomeBLMShowOriginalPostComments>{
  final int postId;
  HomeBLMShowOriginalPostCommentsState({required this.postId});

  ScrollController scrollController = ScrollController();
  TextEditingController controller = TextEditingController(text: '');
  ValueNotifier<List<BLMOriginalComment>> comments = ValueNotifier<List<BLMOriginalComment>>([]);
  ValueNotifier<List<BLMOriginalReply>> replies = ValueNotifier<List<BLMOriginalReply>>([]);
  ValueNotifier<int> count = ValueNotifier<int>(0);
  ValueNotifier<bool> isGuestLoggedIn = ValueNotifier<bool>(true);
  int itemRemaining = 1;
  int repliesRemaining = 1;
  int page1 = 1;
  int numberOfReplies = 0;
  int page2 = 1;
  List<bool> commentsLikes = [];
  List<int> commentsNumberOfLikes = [];
  bool isComment = true;
  List<List<bool>> repliesLikes = [];
  List<List<int>> repliesNumberOfLikes = [];
  int currentCommentId = 1;
  String currentUserImage = '';
  int? currentUserId;
  int currentAccountType = 1;
  int numberOfLikes = 0;
  int numberOfComments = 0;
  GlobalKey profileKey = GlobalKey<HomeBLMShowOriginalPostCommentsState>();
  int maxLines = 2;

  Future<APIBLMShowOriginalPostMain>? showOriginalPost;
  bool likePost = false;
  bool pressedLike = false;
  int likesCount = 0;
  CarouselController buttonCarouselController = CarouselController();

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
      showOriginalPost = getOriginalPost(postId);
      getProfilePicture();
      getOriginalPostInformation();
      onLoading();
      scrollController.addListener(() {
        if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
          if(itemRemaining != 0){
            onLoading();
          }else{
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: const Text('No more comments to show'),
                duration: const Duration(seconds: 1),
                backgroundColor: const Color(0xff4EC9D4),
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
    var originalPostInformation = await apiBLMShowOriginalPost(postId: postId);
    numberOfLikes = originalPostInformation.blmPost.showOriginalPostNumberOfLikes;
    numberOfComments = originalPostInformation.blmPost.showOriginalPostNumberOfComments;
  }

  void getProfilePicture() async{
    var getProfilePicture = await apiBLMShowProfileInformation();
    currentUserImage = getProfilePicture.showProfileInformationImage;
    currentUserId = getProfilePicture.showProfileInformationUserId;
    currentAccountType = getProfilePicture.showProfileInformationAccountType;
  }

  void onLoading() async{
    
    if(itemRemaining != 0){
      
      var newValue1 = await apiBLMShowListOfComments(postId: postId, page: page1);
      itemRemaining = newValue1.blmItemsRemaining;
      count.value = count.value + newValue1.blmCommentsList.length;

      for(int i = 0; i < newValue1.blmCommentsList.length; i++){
        
        var commentLikeStatus = await apiBLMShowCommentOrReplyLikeStatus(commentableType: 'Comment', commentableId: newValue1.blmCommentsList[i].showListCommentsCommentId);
        
        commentsLikes.add(commentLikeStatus.showCommentOrReplyLikeStatus);
        commentsNumberOfLikes.add(commentLikeStatus.showCommentOrReplyNumberOfLikes);
        
        if(repliesRemaining != 0){
          context.loaderOverlay.show();
          var newValue2 = await apiBLMShowListOfReplies(postId: newValue1.blmCommentsList[i].showListCommentsCommentId, page: page2);
          context.loaderOverlay.hide();

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

      if(mounted)
      page1++;
    }
  }

  Future<APIBLMShowOriginalPostMain> getOriginalPost(postId) async{
    return await apiBLMShowOriginalPost(postId: postId);
  }

  @override
  Widget build(BuildContext context){
    SizeConfig.init(context);
    print('Show original BLM post comments screen rebuild!');
    return WillPopScope(
      onWillPop: () async{
        return Navigator.canPop(context);
      },
      child: GestureDetector(
        onTap: (){
          FocusNode currentFocus = FocusScope.of(context);
          if(!currentFocus.hasPrimaryFocus){
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
                    title: const Text('Post', style: const TextStyle(fontSize: 16, color: const Color(0xffffffff)),),
                    centerTitle: true,
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back, color: const Color(0xffffffff),), 
                      onPressed: (){
                        Navigator.pop(context, numberOfComments);
                      },
                    ),
                    actions: [
                      MiscBLMDropDownTemplate(postId: postId, likePost: likePost, likesCount: likesCount, reportType: 'Post', pageType: 'Blm'),
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
                                    physics: ClampingScrollPhysics(),
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
                                                        if(originalPost.data!.blmPost.showOriginalPostPage.showOriginalPostPageManage == true || originalPost.data!.blmPost.showOriginalPostPage.showOriginalPostPageFamOrFriends == true){
                                                          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularProfile(memorialId: originalPost.data!.blmPost.showOriginalPostPage.showOriginalPostPageId, relationship: originalPost.data!.blmPost.showOriginalPostPage.showOriginalPostPageRelationship, managed: originalPost.data!.blmPost.showOriginalPostPage.showOriginalPostPageManage, newlyCreated: false,)));
                                                        }else{
                                                          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularMemorialProfile(memorialId: originalPost.data!.blmPost.showOriginalPostPage.showOriginalPostPageId, pageType: originalPost.data!.blmPost.showOriginalPostPage.showOriginalPostPagePageType, newJoin: originalPost.data!.blmPost.showOriginalPostPage.showOriginalPostPageFollower,)));
                                                        }
                                                      }else{
                                                        if(originalPost.data!.blmPost.showOriginalPostPage.showOriginalPostPageManage == true || originalPost.data!.blmPost.showOriginalPostPage.showOriginalPostPageFamOrFriends == true){
                                                          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMProfile(memorialId: originalPost.data!.blmPost.showOriginalPostPage.showOriginalPostPageId, relationship: originalPost.data!.blmPost.showOriginalPostPage.showOriginalPostPageRelationship, managed: originalPost.data!.blmPost.showOriginalPostPage.showOriginalPostPageManage, newlyCreated: false,)));
                                                        }else{
                                                          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMMemorialProfile(memorialId: originalPost.data!.blmPost.showOriginalPostPage.showOriginalPostPageId, pageType: originalPost.data!.blmPost.showOriginalPostPage.showOriginalPostPagePageType, newJoin: originalPost.data!.blmPost.showOriginalPostPage.showOriginalPostPageFollower,)));
                                                        }
                                                      }
                                                    },

                                                    child: originalPost.data!.blmPost.showOriginalPostPage.showOriginalPostPageProfileImage != ''
                                                    ? CircleAvatar(
                                                      backgroundColor: const Color(0xff888888),
                                                      foregroundImage: NetworkImage(originalPost.data!.blmPost.showOriginalPostPage.showOriginalPostPageProfileImage),
                                                      backgroundImage: const AssetImage('assets/icons/app-icon.png'),
                                                    )
                                                    : const CircleAvatar(
                                                      backgroundColor: const Color(0xff888888),
                                                      foregroundImage: const AssetImage('assets/icons/app-icon.png'),
                                                    )
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      padding: const EdgeInsets.only(left: 10.0),
                                                      child: GestureDetector(
                                                        onTap: () async{
                                                          if(originalPost.data!.blmPost.showOriginalPostPage.showOriginalPostPagePageType == 'Memorial'){
                                                            if(originalPost.data!.blmPost.showOriginalPostPage.showOriginalPostPageManage == true || originalPost.data!.blmPost.showOriginalPostPage.showOriginalPostPageFamOrFriends == true){
                                                              Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularProfile(memorialId: originalPost.data!.blmPost.showOriginalPostPage.showOriginalPostPageId, relationship: originalPost.data!.blmPost.showOriginalPostPage.showOriginalPostPageRelationship, managed: originalPost.data!.blmPost.showOriginalPostPage.showOriginalPostPageManage, newlyCreated: false,)));
                                                            }else{
                                                              Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularMemorialProfile(memorialId: originalPost.data!.blmPost.showOriginalPostPage.showOriginalPostPageId, pageType: originalPost.data!.blmPost.showOriginalPostPage.showOriginalPostPagePageType, newJoin: originalPost.data!.blmPost.showOriginalPostPage.showOriginalPostPageFollower,)));
                                                            }
                                                          }else{
                                                            if(originalPost.data!.blmPost.showOriginalPostPage.showOriginalPostPageManage == true || originalPost.data!.blmPost.showOriginalPostPage.showOriginalPostPageFamOrFriends == true){
                                                              Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMProfile(memorialId: originalPost.data!.blmPost.showOriginalPostPage.showOriginalPostPageId, relationship: originalPost.data!.blmPost.showOriginalPostPage.showOriginalPostPageRelationship, managed: originalPost.data!.blmPost.showOriginalPostPage.showOriginalPostPageManage, newlyCreated: false,)));
                                                            }else{
                                                              Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMMemorialProfile(memorialId: originalPost.data!.blmPost.showOriginalPostPage.showOriginalPostPageId, pageType: originalPost.data!.blmPost.showOriginalPostPage.showOriginalPostPagePageType, newJoin: originalPost.data!.blmPost.showOriginalPostPage.showOriginalPostPageFollower,)));
                                                            }
                                                          }
                                                        },
                                                        child: Column(
                                                          children: [
                                                            Expanded(
                                                              child: Align(alignment: Alignment.bottomLeft,
                                                                child: Text(originalPost.data!.blmPost.showOriginalPostPage.showOriginalPostPageName,
                                                                  overflow: TextOverflow.ellipsis,
                                                                  style: const TextStyle(
                                                                    fontSize: 16,
                                                                    fontWeight: FontWeight.bold,
                                                                    color: const Color(0xff000000),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Align(
                                                                alignment: Alignment.topLeft,
                                                                child: Text(timeago.format(DateTime.parse(originalPost.data!.blmPost.showOriginalPostCreatedAt)),
                                                                  maxLines: 1,
                                                                  style: const TextStyle(
                                                                    fontSize: 14,
                                                                    fontWeight: FontWeight.w400,
                                                                    color: const Color(0xffaaaaaa)
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
                                              child: Text(originalPost.data!.blmPost.showOriginalPostBody),
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
                                                            barrierDismissible: true,
                                                            barrierLabel: 'Dialog',
                                                            transitionDuration: Duration(milliseconds: 0),
                                                            pageBuilder: (_, __, ___) {
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
                                                                            onTap: (){
                                                                              Navigator.pop(context);
                                                                            },
                                                                            child: CircleAvatar(
                                                                              radius: 20,
                                                                              backgroundColor: const Color(0xff000000).withOpacity(0.8),
                                                                              child: const Icon(Icons.close_rounded, color: const Color(0xffffffff),),
                                                                            ),
                                                                          ),
                                                                        ),

                                                                        const SizedBox(height: 10,),

                                                                        Expanded(
                                                                          child: ((){
                                                                            if(lookupMimeType(originalPost.data!.blmPost.showOriginalPostImagesOrVideos[0])?.contains('video') == true){
                                                                              return BetterPlayer.network('${originalPost.data!.blmPost.showOriginalPostImagesOrVideos[0]}',
                                                                                betterPlayerConfiguration: const BetterPlayerConfiguration(
                                                                                  deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
                                                                                  aspectRatio: 16 / 9,
                                                                                  fit: BoxFit.contain,
                                                                                ),
                                                                              );
                                                                            }else{
                                                                              return CachedNetworkImage(
                                                                                fit: BoxFit.contain,
                                                                                imageUrl: originalPost.data!.blmPost.showOriginalPostImagesOrVideos[0],
                                                                                placeholder: (context, url) => const Center(child: const CircularProgressIndicator(),),
                                                                                errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 1.0,),
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
                                                              betterPlayerConfiguration: const BetterPlayerConfiguration(
                                                                aspectRatio: 16 / 9,
                                                                fit: BoxFit.contain,
                                                                controlsConfiguration: const BetterPlayerControlsConfiguration(
                                                                  showControls: false,
                                                                ),
                                                              ),
                                                            );
                                                          }else{
                                                            return CachedNetworkImage(
                                                              fit: BoxFit.cover,
                                                              imageUrl: originalPost.data!.blmPost.showOriginalPostImagesOrVideos[0],
                                                              placeholder: (context, url) => const Center(child: const CircularProgressIndicator(),),
                                                              errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                            );
                                                          }
                                                        }()),
                                                      );
                                                    }else if(originalPost.data!.blmPost.showOriginalPostImagesOrVideos.length == 2){
                                                      return StaggeredGridView.countBuilder(
                                                        padding: EdgeInsets.zero,
                                                        shrinkWrap: true,
                                                        physics: const NeverScrollableScrollPhysics(),
                                                        crossAxisCount: 4,
                                                        itemCount: 2,
                                                        itemBuilder: (BuildContext context, int index) =>
                                                        GestureDetector(
                                                          onTap: (){
                                                            showGeneralDialog(
                                                              context: context,
                                                              barrierDismissible: true,
                                                              barrierLabel: 'Dialog',
                                                              transitionDuration: Duration(milliseconds: 0),
                                                              pageBuilder: (_, __, ___) {
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
                                                                              onTap: (){
                                                                                Navigator.pop(context);
                                                                              },
                                                                              child: CircleAvatar(
                                                                                radius: 20,
                                                                                backgroundColor: const Color(0xff000000).withOpacity(0.8),
                                                                                child: const Icon(Icons.close_rounded, color: const Color(0xffffffff),),
                                                                              ),
                                                                            ),
                                                                          ),

                                                                          const SizedBox(height: 10,),

                                                                          Expanded(
                                                                            child: CarouselSlider(
                                                                              carouselController: buttonCarouselController,
                                                                              items: List.generate(originalPost.data!.blmPost.showOriginalPostImagesOrVideos.length, (next) =>
                                                                                ((){
                                                                                  if(lookupMimeType(originalPost.data!.blmPost.showOriginalPostImagesOrVideos[next])?.contains('video') == true){
                                                                                    return BetterPlayer.network('${originalPost.data!.blmPost.showOriginalPostImagesOrVideos[index]}',
                                                                                      betterPlayerConfiguration: const BetterPlayerConfiguration(
                                                                                        deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
                                                                                        autoDispose: false,
                                                                                        aspectRatio: 16 / 9,
                                                                                        fit: BoxFit.contain,
                                                                                      ),
                                                                                    );
                                                                                  }else{
                                                                                    return CachedNetworkImage(
                                                                                      fit: BoxFit.contain,
                                                                                      imageUrl: originalPost.data!.blmPost.showOriginalPostImagesOrVideos[next],
                                                                                      placeholder: (context, url) => const Center(child: const CircularProgressIndicator(),),
                                                                                      errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 1.0,),
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
                                                                                icon: const Icon(Icons.arrow_back_rounded, color: const Color(0xffffffff),),
                                                                              ),

                                                                              IconButton(
                                                                                onPressed: () => buttonCarouselController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.linear),
                                                                                icon: const Icon(Icons.arrow_forward_rounded, color: const Color(0xffffffff),),
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
                                                          child: ((){
                                                            if(lookupMimeType(originalPost.data!.blmPost.showOriginalPostImagesOrVideos[index])?.contains('video') == true){
                                                              return BetterPlayer.network('${originalPost.data!.blmPost.showOriginalPostImagesOrVideos[index]}',
                                                                betterPlayerConfiguration: const BetterPlayerConfiguration(
                                                                  aspectRatio: 16 / 9,
                                                                  fit: BoxFit.contain,
                                                                  controlsConfiguration: const BetterPlayerControlsConfiguration(
                                                                    showControls: false,
                                                                  ),
                                                                ),
                                                              );
                                                            }else{
                                                              return CachedNetworkImage(
                                                                fit: BoxFit.cover,
                                                                imageUrl: originalPost.data!.blmPost.showOriginalPostImagesOrVideos[index],
                                                                placeholder: (context, url) => const Center(child: const CircularProgressIndicator(),),
                                                                errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                              );
                                                            }
                                                          }()),
                                                        ),
                                                        staggeredTileBuilder: (int index) => const StaggeredTile.count(2, 2),
                                                        mainAxisSpacing: 4.0,
                                                        crossAxisSpacing: 4.0,
                                                      );
                                                    }else{
                                                      return StaggeredGridView.countBuilder(
                                                        padding: EdgeInsets.zero,
                                                        shrinkWrap: true,
                                                        physics: const NeverScrollableScrollPhysics(),
                                                        crossAxisCount: 4,
                                                        itemCount: 3,
                                                        staggeredTileBuilder: (int index) => StaggeredTile.count(2, index.isEven ? 1 : 2),
                                                        mainAxisSpacing: 4.0,
                                                        crossAxisSpacing: 4.0,
                                                        itemBuilder: (BuildContext context, int index) => 
                                                        GestureDetector(
                                                          onTap: (){
                                                            showGeneralDialog(
                                                              context: context,
                                                              barrierDismissible: true,
                                                              barrierLabel: 'Dialog',
                                                              transitionDuration: Duration(milliseconds: 0),
                                                              pageBuilder: (_, __, ___) {
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
                                                                              onTap: (){
                                                                                Navigator.pop(context);
                                                                              },
                                                                              child: CircleAvatar(
                                                                                radius: 20,
                                                                                backgroundColor: const Color(0xff000000).withOpacity(0.8),
                                                                                child: const Icon(Icons.close_rounded, color: const Color(0xffffffff),),
                                                                              ),
                                                                            ),
                                                                          ),

                                                                          SizedBox(height: 10,),

                                                                          Expanded(
                                                                            child: CarouselSlider(
                                                                              carouselController: buttonCarouselController,
                                                                              items: List.generate(originalPost.data!.blmPost.showOriginalPostImagesOrVideos.length, (next) =>
                                                                                ((){
                                                                                  if(lookupMimeType(originalPost.data!.blmPost.showOriginalPostImagesOrVideos[next])?.contains('video') == true){
                                                                                    return BetterPlayer.network('${originalPost.data!.blmPost.showOriginalPostImagesOrVideos[next]}',
                                                                                      betterPlayerConfiguration: const BetterPlayerConfiguration(
                                                                                        deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
                                                                                        autoDispose: false,
                                                                                        aspectRatio: 16 / 9,
                                                                                        fit: BoxFit.contain,
                                                                                      ),
                                                                                    );
                                                                                  }else{
                                                                                    return CachedNetworkImage(
                                                                                      fit: BoxFit.contain,
                                                                                      imageUrl: originalPost.data!.blmPost.showOriginalPostImagesOrVideos[next],
                                                                                      placeholder: (context, url) => const Center(child: const CircularProgressIndicator(),),
                                                                                      errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 1.0,),
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
                                                                                icon: const Icon(Icons.arrow_back_rounded, color: const Color(0xffffffff),),
                                                                              ),

                                                                              IconButton(
                                                                                onPressed: () => buttonCarouselController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.linear),
                                                                                icon: const Icon(Icons.arrow_forward_rounded, color: const Color(0xffffffff),),
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
                                                          child: ((){
                                                            if(index != 1){
                                                              return lookupMimeType(originalPost.data!.blmPost.showOriginalPostImagesOrVideos[index])?.contains('video') == true
                                                              ? BetterPlayer.network('${originalPost.data!.blmPost.showOriginalPostImagesOrVideos[index]}',
                                                                betterPlayerConfiguration: const BetterPlayerConfiguration(
                                                                  aspectRatio: 16 / 9,
                                                                  fit: BoxFit.contain,
                                                                  controlsConfiguration: const BetterPlayerControlsConfiguration(
                                                                    showControls: false,
                                                                  ),
                                                                ),
                                                              )
                                                              : CachedNetworkImage(
                                                                fit: BoxFit.cover,
                                                                imageUrl: originalPost.data!.blmPost.showOriginalPostImagesOrVideos[index],
                                                                placeholder: (context, url) => const Center(child: const CircularProgressIndicator(),),
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
                                                                          betterPlayerConfiguration: const BetterPlayerConfiguration(
                                                                            aspectRatio: 16 / 9,
                                                                            fit: BoxFit.contain,
                                                                            controlsConfiguration: const BetterPlayerControlsConfiguration(
                                                                              showControls: false,
                                                                            ),
                                                                          ),
                                                                        ),

                                                                        Container(color: const Color(0xff000000).withOpacity(0.5),),

                                                                        Center(
                                                                          child: CircleAvatar(
                                                                            radius: 25,
                                                                            backgroundColor: const Color(0xffffffff).withOpacity(.5),
                                                                            child: Text(
                                                                              '${originalPost.data!.blmPost.showOriginalPostImagesOrVideos.length - 3}',
                                                                              style: const TextStyle(
                                                                                fontSize: 40,
                                                                                fontWeight: FontWeight.bold,
                                                                                color: const Color(0xffffffff),
                                                                              ),
                                                                            ),
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
                                                                          placeholder: (context, url) => const Center(child: const CircularProgressIndicator(),),
                                                                          errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                                        ),

                                                                        Container(color: const Color(0xff000000).withOpacity(0.5),),

                                                                        Center(
                                                                          child: CircleAvatar(
                                                                            radius: 25,
                                                                            backgroundColor: const Color(0xffffffff).withOpacity(.5),
                                                                            child: Text(
                                                                              '${originalPost.data!.blmPost.showOriginalPostImagesOrVideos.length - 3}',
                                                                              style: const TextStyle(
                                                                                fontSize: 40,
                                                                                fontWeight: FontWeight.bold,
                                                                                color: const Color(0xffffffff),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    );
                                                                  }
                                                                }else{
                                                                  if(lookupMimeType(originalPost.data!.blmPost.showOriginalPostImagesOrVideos[index])?.contains('video') == true){
                                                                    return BetterPlayer.network('${originalPost.data!.blmPost.showOriginalPostImagesOrVideos[index]}',
                                                                      betterPlayerConfiguration: const BetterPlayerConfiguration(
                                                                        aspectRatio: 16 / 9,
                                                                        fit: BoxFit.contain,
                                                                        controlsConfiguration: const BetterPlayerControlsConfiguration(
                                                                          showControls: false,
                                                                        ),
                                                                      ),
                                                                    );
                                                                  }else{
                                                                    return CachedNetworkImage(
                                                                      fit: BoxFit.cover,
                                                                      imageUrl: originalPost.data!.blmPost.showOriginalPostImagesOrVideos[index],
                                                                      placeholder: (context, url) => const Center(child: const CircularProgressIndicator(),),
                                                                      errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                                    );
                                                                  }
                                                                }
                                                              }());
                                                            }
                                                          }()),
                                                        ),
                                                      );
                                                    }
                                                  }()),
                                                ),

                                                const SizedBox(height: 20),

                                              ],
                                            )
                                            : Container(color: const Color(0xffff0000), height: 0,),

                                            originalPost.data!.blmPost.showOriginalPostPostTagged.length != 0
                                            ? Column(
                                              children: [
                                                const SizedBox(height: 10),

                                                Container(
                                                  alignment: Alignment.centerLeft,
                                                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                                                  child: RichText(
                                                    text: TextSpan(
                                                      children: [
                                                        const TextSpan(
                                                          style: const TextStyle(color: const Color(0xff888888)),
                                                          text: 'with '
                                                        ),

                                                        TextSpan(
                                                          children: List.generate(originalPost.data!.blmPost.showOriginalPostPostTagged.length,
                                                            (index) => 
                                                            TextSpan(
                                                              style: const TextStyle(fontWeight: FontWeight.bold, color: const Color(0xff000000)),
                                                              children: <TextSpan>[
                                                                TextSpan(
                                                                  text: originalPost.data!.blmPost.showOriginalPostPostTagged[index].showOriginalPostTaggedFirstName + ' ' + originalPost.data!.blmPost.showOriginalPostPostTagged[index].showOriginalPostTaggedLastName,
                                                                  recognizer: TapGestureRecognizer()
                                                                  ..onTap = (){
                                                                    Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMUserProfile(userId: originalPost.data!.blmPost.showOriginalPostPostTagged[index].showOriginalPostTaggedId, accountType: originalPost.data!.blmPost.showOriginalPostPage.showOriginalPostPagePageCreator.showOriginalPostPageCreatorAccountType)));
                                                                  }
                                                                ),

                                                                index < originalPost.data!.blmPost.showOriginalPostPostTagged.length - 1
                                                                ? const TextSpan(text: ', ')
                                                                : const TextSpan(text: ''),
                                                              ],
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

                                            Container(
                                              height: 40,
                                              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [

                                                  Row(
                                                    children: [
                                                      const FaIcon(FontAwesomeIcons.peace, color: const Color(0xff000000),),

                                                      const SizedBox(width: 10,),

                                                      Text('$numberOfLikes', style: const TextStyle(fontSize: 16, color: const Color(0xff000000),),),

                                                    ],
                                                  ),

                                                  const SizedBox(width: 40,),

                                                  Row(
                                                    children: [
                                                      const FaIcon(FontAwesomeIcons.comment, color: const Color(0xff000000),),

                                                      const SizedBox(width: 10,),

                                                      Text('$numberOfComments', style: const TextStyle(fontSize: 16, color: const Color(0xff000000),),),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        )
                                      ),

                                      SliverToBoxAdapter(
                                        child: countListener != 0
                                        ? Column(
                                          children: [
                                            Column(
                                              children: List.generate(
                                                commentsListener.length, (i) => ListTile(
                                                  onTap: (){
                                                    Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMUserProfile(userId: commentsListener[i].userId, accountType: commentsListener[i].userAccountType,)));
                                                  },
                                                  onLongPress: () async{
                                                    if(currentUserId == commentsListener[i].userId && currentAccountType == commentsListener[i].userAccountType){
                                                      await showMaterialModalBottomSheet(
                                                        context: context, 
                                                        builder: (context) => 
                                                          SafeArea(
                                                          top: false,
                                                          child: Column(
                                                            mainAxisSize: MainAxisSize.min,
                                                            children: <Widget>[
                                                              ListTile(
                                                                title: const Text('Edit'),
                                                                leading: const Icon(Icons.edit),
                                                                onTap: () async{
                                                                  controller.text = controller.text + commentsListener[i].commentBody;
                                                                  await showModalBottomSheet(
                                                                    context: context, 
                                                                    builder: (context) => showKeyboardEdit(isEdit: true, editId: commentsListener[i].commentId),
                                                                  );
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
                                                                },
                                                              )
                                                            ],
                                                          ),
                                                        )
                                                      );
                                                    }else{
                                                      await showMaterialModalBottomSheet(
                                                        context: context, 
                                                        builder: (context) => 
                                                          SafeArea(
                                                          top: false,
                                                          child: Column(
                                                            mainAxisSize: MainAxisSize.min,
                                                            children: <Widget>[
                                                              ListTile(
                                                                title: const Text('Report'),
                                                                leading: const Icon(Icons.edit),
                                                                onTap: (){
                                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMReport(postId: postId, reportType: 'Post')));
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      );
                                                    }
                                                  },
                                                  visualDensity: const VisualDensity(vertical: 4.0),
                                                  leading: CircleAvatar(
                                                    backgroundColor: const Color(0xff888888),
                                                    foregroundImage: NetworkImage(commentsListener[i].image),
                                                    backgroundImage: const AssetImage('assets/icons/app-icon.png'),
                                                  ),
                                                  title: Row(
                                                    children: [
                                                      Expanded(
                                                        child: currentUserId == commentsListener[i].userId && currentAccountType == commentsListener[i].userAccountType
                                                        ? const Text('You',
                                                          style: const TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        )
                                                        : Text('${commentsListener[i].firstName}' + ' ' + '${commentsListener[i].lastName}',
                                                          style: const TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Align(
                                                          alignment: Alignment.centerRight,
                                                          child: TextButton.icon(
                                                            onPressed: () async{
                                                              if(commentsLikes[i] == true){
                                                                setState(() {
                                                                  commentsLikes[i] = false;
                                                                  commentsNumberOfLikes[i]--;
                                                                });

                                                                await apiBLMLikeOrUnlikeCommentReply(commentableType: 'Comment', commentableId: commentsListener[i].commentId, likeStatus: false);
                                                              }else{
                                                                setState(() {
                                                                  commentsLikes[i] = true;
                                                                  commentsNumberOfLikes[i]++;
                                                                });

                                                                await apiBLMLikeOrUnlikeCommentReply(commentableType: 'Comment', commentableId: commentsListener[i].commentId, likeStatus: true);
                                                              }
                                                            }, 
                                                            icon: commentsLikes[i] == true ? const FaIcon(FontAwesomeIcons.peace, color: const Color(0xffff0000),) : const FaIcon(FontAwesomeIcons.peace, color: const Color(0xff888888),),
                                                            label: Text('${commentsNumberOfLikes[i]}', style: const TextStyle(fontSize: 16, color: const Color(0xff000000),),),
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
                                                              child: Text(
                                                                commentsListener[i].commentBody,
                                                                style: const TextStyle(
                                                                  color: const Color(0xffffffff),
                                                                ),
                                                              ),
                                                              decoration: const BoxDecoration(
                                                                color: const Color(0xff4EC9D4),
                                                                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),

                                                      const SizedBox(height: 5,),

                                                      Row(
                                                        children: [

                                                          Text(timeago.format(DateTime.parse(commentsListener[i].createdAt))),

                                                          const SizedBox(width: 20,),

                                                          GestureDetector(
                                                            onTap: () async{
                                                              if(controller.text != ''){
                                                                controller.clear();
                                                              }

                                                              setState(() {
                                                                isComment = false;
                                                                currentCommentId = commentsListener[i].commentId;
                                                              });

                                                              await showModalBottomSheet(
                                                                context: context, 
                                                                builder: (context) => showKeyboard()
                                                              );
                                                            },
                                                            child: const Text('Reply',),
                                                          ),
                                                        ],
                                                      ),

                                                      const SizedBox(height: 20,),

                                                      commentsListener[i].listOfReplies.length != 0
                                                      ? Column(
                                                          children: List.generate(commentsListener[i].listOfReplies.length, (index) => 
                                                          ListTile(
                                                            contentPadding: EdgeInsets.zero,
                                                            visualDensity: const VisualDensity(vertical: 4.0),
                                                            onTap: (){
                                                              Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMUserProfile(userId: commentsListener[i].listOfReplies[index].userId, accountType: currentAccountType,)));
                                                            },
                                                            onLongPress: () async{
                                                              if(currentUserId == commentsListener[i].listOfReplies[index].userId && currentAccountType == commentsListener[i].listOfReplies[index].userAccountType){
                                                                await showMaterialModalBottomSheet(
                                                                  context: context, 
                                                                  builder: (context) => 
                                                                    SafeArea(
                                                                    top: false,
                                                                    child: Column(
                                                                      mainAxisSize: MainAxisSize.min,
                                                                      children: <Widget>[
                                                                        ListTile(
                                                                          title: const Text('Edit'),
                                                                          leading: const Icon(Icons.edit),
                                                                          onTap: () async{
                                                                            controller.text = controller.text + commentsListener[i].listOfReplies[index].replyBody;
                                                                            await showModalBottomSheet(
                                                                              context: context, 
                                                                              builder: (context) => showKeyboardEdit(isEdit: false, editId: commentsListener[i].listOfReplies[index].replyId),
                                                                            );
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
                                                                          },
                                                                        )
                                                                      ],
                                                                    ),
                                                                  )
                                                                );
                                                              }else{
                                                                await showMaterialModalBottomSheet(
                                                                  context: context, 
                                                                  builder: (context) => 
                                                                    SafeArea(
                                                                    top: false,
                                                                    child: Column(
                                                                      mainAxisSize: MainAxisSize.min,
                                                                      children: <Widget>[
                                                                        ListTile(
                                                                          title: const Text('Report'),
                                                                          leading: const Icon(Icons.edit),
                                                                          onTap: (){
                                                                            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMReport(postId: postId, reportType: 'Post')));
                                                                          },
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  )
                                                                );
                                                              }
                                                            },
                                                            leading: CircleAvatar(
                                                              backgroundColor: const Color(0xff888888),
                                                              foregroundImage: NetworkImage(commentsListener[i].listOfReplies[index].image),
                                                              backgroundImage: const AssetImage('assets/icons/app-icon.png'),
                                                            ),
                                                            title: Row(
                                                              children: [
                                                                Expanded(
                                                                  child: currentUserId == commentsListener[i].listOfReplies[index].userId && currentAccountType == commentsListener[i].listOfReplies[index].userAccountType
                                                                  ? const Text('You',
                                                                    style: const TextStyle(
                                                                      fontWeight: FontWeight.bold,
                                                                    ),
                                                                  )
                                                                  : Text(commentsListener[i].listOfReplies[index].firstName + ' ' + commentsListener[i].listOfReplies[index].lastName,
                                                                    style: const TextStyle(
                                                                      fontWeight: FontWeight.bold,
                                                                    ),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child: Align(
                                                                    alignment: Alignment.centerRight,
                                                                    child: TextButton.icon(
                                                                      onPressed: () async{
                                                                        if(repliesLikes[i][index] == true){
                                                                          setState(() {
                                                                            repliesLikes[i][index] = false;
                                                                            repliesNumberOfLikes[i][index]--;                                                      
                                                                          });

                                                                          await apiBLMLikeOrUnlikeCommentReply(commentableType: 'Reply', commentableId: commentsListener[i].listOfReplies[index].replyId, likeStatus: false);
                                                                        }else{
                                                                          setState(() {
                                                                            repliesLikes[i][index] = true;
                                                                            repliesNumberOfLikes[i][index]++;
                                                                          });

                                                                          await apiBLMLikeOrUnlikeCommentReply(commentableType: 'Reply', commentableId: commentsListener[i].listOfReplies[index].replyId, likeStatus: true);
                                                                        }
                                                                      }, 
                                                                      icon: repliesLikes[i][index] == true ? const FaIcon(FontAwesomeIcons.peace, color: const Color(0xffff0000),) : const FaIcon(FontAwesomeIcons.peace, color: const Color(0xff888888),),
                                                                      label: Text('${repliesNumberOfLikes[i][index]}', style: const TextStyle(fontSize: 16, color: const Color(0xff000000),),),
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
                                                                        child: Text(
                                                                          commentsListener[i].listOfReplies[index].replyBody,
                                                                          style: const TextStyle(
                                                                            color: const Color(0xffffffff),
                                                                          ),
                                                                        ),
                                                                        decoration: const BoxDecoration(
                                                                          color: const Color(0xff4EC9D4),
                                                                          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),

                                                                const SizedBox(height: 5,),

                                                                Row(
                                                                  children: [
                                                                    Text(timeago.format(DateTime.parse(commentsListener[i].listOfReplies[index].createdAt))),

                                                                    const SizedBox(width: 40,),

                                                                    GestureDetector(
                                                                      onTap: () async{
                                                                        if(controller.text != ''){
                                                                          controller.clear();
                                                                        }

                                                                        controller.text = commentsListener[i].firstName + ' ' + commentsListener[i].lastName + ' ';

                                                                        setState(() {
                                                                          isComment = false;
                                                                          currentCommentId = commentsListener[i].commentId;
                                                                        });

                                                                        await showModalBottomSheet(
                                                                          context: context, 
                                                                          builder: (context) => showKeyboard()
                                                                        );
                                                                      },
                                                                      child: const Text('Reply',),
                                                                    ),

                                                                  ],
                                                                ),
                                                              ],
                                                            )
                                                          ),
                                                        ),
                                                      )
                                                      : Container(height: 0,),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        )
                                        : Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [

                                            SizedBox(height: (SizeConfig.screenHeight! - kToolbarHeight) / 3.5,),

                                            Image.asset('assets/icons/app-icon.png', height: 250, width: 250,),

                                            const SizedBox(height: 45,),

                                            const Text('Comment is empty', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: const Color(0xffB1B1B1),),),

                                            SizedBox(height: (SizeConfig.screenHeight! - 85 - kToolbarHeight) / 3.5,),
                                          ],
                                        ),
                                      ),

                                    ],
                                  ),
                                ),
                              );
                            }else if(originalPost.hasError){
                              return MiscBLMErrorMessageTemplate();
                            }else{
                              return Container(height: SizeConfig.screenHeight, child: Center(child: Container(child: const SpinKitThreeBounce(color: const Color(0xff000000), size: 50.0,), color: const Color(0xffffffff),),),);
                            }
                          }
                        ),
                      ),

                      isGuestLoggedInListener
                      ? BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                        child: MiscBLMLoginToContinue(),
                      )
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

  showKeyboard(){
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0,),
        child: Row(
          children: [
            
            CircleAvatar(
              backgroundColor: const Color(0xff888888),
              foregroundImage: NetworkImage(currentUserImage),
              backgroundImage: const AssetImage('assets/icons/app-icon.png'),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  controller: controller,
                  cursorColor: const Color(0xff000000),
                  maxLines: 2,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    fillColor: const Color(0xffBDC3C7),
                    filled: true,
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    labelText: 'Say something...',
                    labelStyle: const TextStyle(
                      fontSize: 14,
                      color: const Color(0xffffffff),
                    ),
                    border: const OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: const Color(0xffBDC3C7),
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: const Color(0xffBDC3C7),
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                ),
              ),
            ),

            GestureDetector(
              onTap: () async{
                if(controller.text == ''){
                  await showDialog(
                    context: context,
                    builder: (_) => 
                      AssetGiffyDialog(
                      image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                      title: const Text('Error', textAlign: TextAlign.center, style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                      entryAnimation: EntryAnimation.DEFAULT,
                      description: const Text('Please input a comment.',
                        textAlign: TextAlign.center,
                      ),
                      onlyOkButton: true,
                      buttonOkColor: const Color(0xffff0000),
                      onOkButtonPressed: () {
                        Navigator.pop(context, true);
                      },
                    )
                  );
                }else if(isComment == true){
                  context.loaderOverlay.show();
                  await apiBLMAddComment(postId: postId, commentBody: controller.text);
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
              child: const Text('Post',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold, 
                  color: const Color(0xff000000),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  showKeyboardEdit({required bool isEdit, required int editId}){ // isEdit - TRUE (COMMENT) | FALSE (REPLY)
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0,),
        child: Row(
          children: [
            
            CircleAvatar(
              backgroundColor: const Color(0xff888888), 
              foregroundImage: NetworkImage(currentUserImage),
              backgroundImage: const AssetImage('assets/icons/app-icon.png'),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  controller: controller,
                  cursorColor: const Color(0xff000000),
                  maxLines: 2,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    fillColor: const Color(0xffBDC3C7),
                    filled: true,
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    labelText: 'Say something...',
                    labelStyle: const TextStyle(
                      fontSize: 14,
                      color: const Color(0xffffffff),
                    ),
                    border: const OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: const Color(0xffBDC3C7),
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: const Color(0xffBDC3C7),
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                ),
              ),
            ),

            GestureDetector(
              onTap: () async{
                if(controller.text == ''){
                  await showDialog(
                    context: context,
                    builder: (_) => 
                      AssetGiffyDialog(
                      image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                      title: const Text('Error', textAlign: TextAlign.center, style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                      entryAnimation: EntryAnimation.DEFAULT,
                      description: const Text('Please input a comment.',
                        textAlign: TextAlign.center,
                      ),
                      onlyOkButton: true,
                      buttonOkColor: const Color(0xffff0000),
                      onOkButtonPressed: () {
                        Navigator.pop(context, true);
                      },
                    )
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
              child: const Text('Post',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold, 
                  color: const Color(0xff000000),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}