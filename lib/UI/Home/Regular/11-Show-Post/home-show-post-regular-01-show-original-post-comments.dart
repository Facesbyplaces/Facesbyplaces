import 'package:facesbyplaces/API/Regular/02-Main/api-main-regular-02-show-user-information.dart';
import 'package:facesbyplaces/API/Regular/12-Show-Post/api-show-post-regular-01-show-original-post.dart';
import 'package:facesbyplaces/API/Regular/12-Show-Post/api-show-post-regular-02-show-post-comments.dart';
import 'package:facesbyplaces/API/Regular/12-Show-Post/api-show-post-regular-03-show-comment-replies.dart';
import 'package:facesbyplaces/API/Regular/12-Show-Post/api-show-post-regular-04-show-comment-or-reply-like-status.dart';
import 'package:facesbyplaces/API/Regular/12-Show-Post/api-show-post-regular-06-add-comment.dart';
import 'package:facesbyplaces/API/Regular/12-Show-Post/api-show-post-regular-07-add-reply.dart';
import 'package:facesbyplaces/API/Regular/12-Show-Post/api-show-post-regular-08-comment-reply-like-or-unlike.dart';
import 'package:facesbyplaces/API/Regular/12-Show-Post/api-show-post-regular-09-delete-comment.dart';
import 'package:facesbyplaces/API/Regular/12-Show-Post/api-show-post-regular-10-edit-comment.dart';
import 'package:facesbyplaces/API/Regular/12-Show-Post/api-show-post-regular-11-delete-reply.dart';
import 'package:facesbyplaces/API/Regular/12-Show-Post/api-show-post-regular-12-edit-reply.dart';
import 'package:facesbyplaces/UI/Home/BLM/02-View-Memorial/home-view-memorial-blm-01-managed-memorial.dart';
import 'package:facesbyplaces/UI/Home/BLM/02-View-Memorial/home-view-memorial-blm-02-profile-memorial.dart';
import 'package:facesbyplaces/UI/Home/Regular/02-View-Memorial/home-view-memorial-regular-01-managed-memorial.dart';
import 'package:facesbyplaces/UI/Home/Regular/02-View-Memorial/home-view-memorial-regular-02-profile-memorial.dart';
import 'package:facesbyplaces/UI/Home/Regular/06-Report/home-report-regular-01-report.dart';
import 'package:facesbyplaces/UI/Home/Regular/12-Show-User/home-show-user-regular-01-user.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-08-regular-message.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-11-regular-dropdown.dart';
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
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:mime/mime.dart';
import 'dart:ui';

class RegularOriginalComment{
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
  final List<RegularOriginalReply> listOfReplies;

  const RegularOriginalComment({required this.commentId, required this.postId, required this.userId, required this.commentBody, required this.createdAt, required this.firstName, required this.lastName, required this.image, required this.commentLikes, required this.commentNumberOfLikes, required this.userAccountType, required this.listOfReplies});
}

class RegularOriginalReply{
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

  const RegularOriginalReply({required this.replyId, required this.commentId, required this.userId, required this.replyBody, required this.createdAt, required this.firstName, required this.lastName, required this.image, required this.replyLikes, required this.replyNumberOfLikes, required this.userAccountType});
}

class HomeRegularShowOriginalPostComments extends StatefulWidget{
  final int postId;
  const HomeRegularShowOriginalPostComments({required this.postId});

  @override
  HomeRegularShowOriginalPostCommentsState createState() => HomeRegularShowOriginalPostCommentsState(postId: postId);
}

class HomeRegularShowOriginalPostCommentsState extends State<HomeRegularShowOriginalPostComments>{
  final int postId;
  HomeRegularShowOriginalPostCommentsState({required this.postId});

  ScrollController scrollController = ScrollController();
  TextEditingController controller = TextEditingController(text: '');
  List<RegularOriginalComment> comments = [];
  List<RegularOriginalReply> replies = [];
  int itemRemaining = 1;
  int repliesRemaining = 1;
  int page1 = 1;
  int count = 0;
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
  GlobalKey profileKey = GlobalKey<HomeRegularShowOriginalPostCommentsState>();

  Future<APIRegularShowOriginalPostMain>? showOriginalPost;
  bool likePost = false;
  bool pressedLike = false;
  int likesCount = 0;
  bool isGuestLoggedIn = true;
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

    setState(() {
      if(regularSession == true || blmSession == true){
        isGuestLoggedIn = false;
      }
    });
    
    if(isGuestLoggedIn != true){
      showOriginalPost = getOriginalPost(postId);
      getProfilePicture();
      getOriginalPostInformation();
      onLoading();
      scrollController.addListener(() {
        if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
          if(itemRemaining != 0){
            setState(() {
              onLoading();
            });
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
    setState(() {
      onLoading();
    });
  }

  void getOriginalPostInformation() async{
    var originalPostInformation = await apiRegularShowOriginalPost(postId: postId);
    numberOfLikes = originalPostInformation.almPost.showOriginalPostNumberOfLikes;
    numberOfComments = originalPostInformation.almPost.showOriginalPostNumberOfComments;
  }

  void getProfilePicture() async{
    var getProfilePicture = await apiRegularShowProfileInformation();
    currentUserImage = getProfilePicture.showProfileInformationImage;
    currentUserId = getProfilePicture.showProfileInformationUserId;
    currentAccountType = getProfilePicture.showProfileInformationAccountType;
  }

  void onLoading() async{
    
    if(itemRemaining != 0){
      var newValue1 = await apiRegularShowListOfComments(postId: postId, page: page1);
      itemRemaining = newValue1.almItemsRemaining;
      count = count + newValue1.almCommentsList.length;

      for(int i = 0; i < newValue1.almCommentsList.length; i++){
        var commentLikeStatus = await apiRegularShowCommentOrReplyLikeStatus(commentableType: 'Comment', commentableId: newValue1.almCommentsList[i].showListOfCommentsCommentId);
        commentsLikes.add(commentLikeStatus.showCommentOrReplyLikeStatus);
        commentsNumberOfLikes.add(commentLikeStatus.showCommentOrReplyNumberOfLikes);
        
        if(repliesRemaining != 0){
          context.loaderOverlay.show();
          var newValue2 = await apiRegularShowListOfReplies(postId: newValue1.almCommentsList[i].showListOfCommentsCommentId, page: page2);
          context.loaderOverlay.hide();

          const List<bool> newRepliesLikes = [];
          const List<int> newRepliesNumberOfLikes = [];
          const List<int> newReplyId = [];

          for(int j = 0; j < newValue2.almRepliesList.length; j++){

            var replyLikeStatus = await apiRegularShowCommentOrReplyLikeStatus(commentableType: 'Reply', commentableId: newValue2.almRepliesList[j].showListOfRepliesReplyId);
            newRepliesLikes.add(replyLikeStatus.showCommentOrReplyLikeStatus);
            newRepliesNumberOfLikes.add(replyLikeStatus.showCommentOrReplyNumberOfLikes);
            newReplyId.add(newValue2.almRepliesList[j].showListOfRepliesReplyId);

            replies.add(
              RegularOriginalReply(
                replyId: newValue2.almRepliesList[j].showListOfRepliesReplyId,
                commentId: newValue2.almRepliesList[j].showListOfRepliesCommentId,
                userId: newValue2.almRepliesList[j].showListOfRepliesUser.showListRepliesUserUserId,
                replyBody: newValue2.almRepliesList[j].showListOfRepliesReplyBody,
                createdAt: newValue2.almRepliesList[j].showListOfRepliesCreatedAt,
                firstName: newValue2.almRepliesList[j].showListOfRepliesUser.showListRepliesUserFirstName,
                lastName: newValue2.almRepliesList[j].showListOfRepliesUser.showListRepliesUserLastName,
                replyLikes: replyLikeStatus.showCommentOrReplyLikeStatus,
                replyNumberOfLikes: replyLikeStatus.showCommentOrReplyNumberOfLikes,
                image: newValue2.almRepliesList[j].showListOfRepliesUser.showListRepliesUserImage,
                userAccountType: newValue2.almRepliesList[j].showListOfRepliesUser.showListOfCommentsUserAccountType,
              ),
            );
          }

          repliesLikes.add(newRepliesLikes);
          repliesNumberOfLikes.add(newRepliesNumberOfLikes);
          repliesRemaining = newValue2.almItemsRemaining;
          page2++;
        }

        repliesRemaining = 1;
        page2 = 1;
        
        comments.add(
          RegularOriginalComment(
            commentId: newValue1.almCommentsList[i].showListOfCommentsCommentId,
            postId: newValue1.almCommentsList[i].showListOfCommentsPostId,
            userId: newValue1.almCommentsList[i].showListOfCommentsUser.showListOfCommentsUserId,
            commentBody: newValue1.almCommentsList[i].showListOfCommentsCommentBody,
            createdAt: newValue1.almCommentsList[i].showListOfCommentsCreatedAt,
            firstName: newValue1.almCommentsList[i].showListOfCommentsUser.showListOfCommentsUserFirstName,
            lastName: newValue1.almCommentsList[i].showListOfCommentsUser.showListOfCommentsUserLastName,
            image: newValue1.almCommentsList[i].showListOfCommentsUser.showListOfCommentsUserImage,
            commentLikes: commentLikeStatus.showCommentOrReplyLikeStatus,
            commentNumberOfLikes: commentLikeStatus.showCommentOrReplyNumberOfLikes,
            listOfReplies: replies,
            userAccountType: newValue1.almCommentsList[i].showListOfCommentsUser.showListOfCommentsUserAccountType,
          ),    
        );
        replies = [];
      }

      if(mounted)
      setState(() {});
      page1++;
      
    }
  }

  Future<APIRegularShowOriginalPostMain> getOriginalPost(postId) async{
    return await apiRegularShowOriginalPost(postId: postId);
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
          if(!currentFocus.hasPrimaryFocus){
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xff04ECFF),
            title: const Text('Post', style: const TextStyle(fontSize: 16, color: const Color(0xffffffff)),),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: const Color(0xffffffff),), 
              onPressed: (){
                Navigator.pop(context);
              },
            ),
            actions: [
              MiscRegularDropDownTemplate(postId: postId, likePost: likePost, likesCount: likesCount, reportType: 'Post', pageType: 'Alm'),
            ],
          ),
          backgroundColor: const Color(0xffffffff),
          body: Stack(
            children: [
              isGuestLoggedIn
              ? Container(height: 0,)
              : IgnorePointer(
                ignoring: isGuestLoggedIn,
                child: FutureBuilder<APIRegularShowOriginalPostMain>(
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
                                              if(originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPagePageType == 'Memorial'){
                                                if(originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageManage == true || originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageFamOrFriends == true){
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularProfile(memorialId: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageId, relationship: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageRelationship, managed: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageManage, newlyCreated: false,)));
                                                }else{
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularMemorialProfile(memorialId: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageId, pageType: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPagePageType, newJoin: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageFollower,)));
                                                }
                                              }else{
                                                if(originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageManage == true || originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageFamOrFriends == true){
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMProfile(memorialId: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageId, relationship: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageRelationship, managed: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageManage, newlyCreated: false,)));
                                                }else{
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMMemorialProfile(memorialId: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageId, pageType: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPagePageType, newJoin: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageFollower,)));
                                                }
                                              }
                                            },
                                            child: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageProfileImage != ''
                                            ? CircleAvatar(
                                              backgroundColor: const Color(0xff888888),
                                              backgroundImage: NetworkImage(originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageProfileImage),
                                            )
                                            : const CircleAvatar(
                                              backgroundColor: const Color(0xff888888),
                                              backgroundImage: const AssetImage('assets/icons/app-icon.png'),
                                            )
                                          ),
                                          Expanded(
                                            child: Container(
                                              padding: const EdgeInsets.only(left: 10.0),
                                              child: GestureDetector(
                                                onTap: () async{
                                                  if(originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPagePageType == 'Memorial'){
                                                    if(originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageManage == true || originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageFamOrFriends == true){
                                                      Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularProfile(memorialId: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageId, relationship: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageRelationship, managed: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageManage, newlyCreated: false,)));
                                                    }else{
                                                      Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularMemorialProfile(memorialId: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageId, pageType: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPagePageType, newJoin: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageFollower,)));
                                                    }
                                                  }else{
                                                    if(originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageManage == true || originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageFamOrFriends == true){
                                                      Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMProfile(memorialId: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageId, relationship: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageRelationship, managed: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageManage, newlyCreated: false,)));
                                                    }else{
                                                      Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMMemorialProfile(memorialId: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageId, pageType: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPagePageType, newJoin: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageFollower,)));
                                                    }
                                                  }
                                                },
                                                child: Column(
                                                  children: [
                                                    Expanded(
                                                      child: Align(alignment: Alignment.bottomLeft,
                                                        child: Text(originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageName,
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
                                                        child: Text(timeago.format(DateTime.parse(originalPost.data!.almPost.showOriginalPostCreatedAt)),
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
                                      padding: EdgeInsets.only(left: 20.0, right: 20.0),
                                      alignment: Alignment.centerLeft, 
                                      child: Text(originalPost.data!.almPost.showOriginalPostBody),
                                    ),

                                    originalPost.data!.almPost.showOriginalPostImagesOrVideos.isNotEmpty
                                    ? Column(
                                      children: [
                                        const SizedBox(height: 20),

                                        Container(
                                          child: ((){
                                            if(originalPost.data!.almPost.showOriginalPostImagesOrVideos.length == 1){
                                              return GestureDetector(
                                                onTap: (){
                                                  showGeneralDialog(
                                                    context: context,
                                                    barrierDismissible: true,
                                                    barrierLabel: 'Dialog',
                                                    transitionDuration: const Duration(milliseconds: 0),
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
                                                                    if(lookupMimeType(originalPost.data!.almPost.showOriginalPostImagesOrVideos[0])?.contains('video') == true){
                                                                      return BetterPlayer.network('${originalPost.data!.almPost.showOriginalPostImagesOrVideos[0]}',
                                                                        betterPlayerConfiguration: const BetterPlayerConfiguration(
                                                                          aspectRatio: 1,
                                                                        ),
                                                                      );
                                                                    }else{
                                                                      return CachedNetworkImage(
                                                                        fit: BoxFit.cover,
                                                                        imageUrl: originalPost.data!.almPost.showOriginalPostImagesOrVideos[0],
                                                                        placeholder: (context, url) => const Center(child: const CircularProgressIndicator(),),
                                                                        errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
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
                                                  if(lookupMimeType(originalPost.data!.almPost.showOriginalPostImagesOrVideos[0])?.contains('video') == true){
                                                    return BetterPlayer.network('${originalPost.data!.almPost.showOriginalPostImagesOrVideos[0]}',
                                                      betterPlayerConfiguration: const BetterPlayerConfiguration(
                                                        aspectRatio: 16 / 9,
                                                        controlsConfiguration: const BetterPlayerControlsConfiguration(
                                                          showControls: false,
                                                        ),
                                                      ),
                                                    );
                                                  }else{
                                                    return CachedNetworkImage(
                                                      fit: BoxFit.cover,
                                                      imageUrl: originalPost.data!.almPost.showOriginalPostImagesOrVideos[0],
                                                      placeholder: (context, url) => const Center(child: const CircularProgressIndicator(),),
                                                      errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                    );
                                                  }
                                                }()),
                                              );
                                            }else if(originalPost.data!.almPost.showOriginalPostImagesOrVideos.length == 2){
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
                                                      transitionDuration: const Duration(milliseconds: 0),
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
                                                                      items: List.generate(originalPost.data!.almPost.showOriginalPostImagesOrVideos.length, (next) =>
                                                                        ((){
                                                                          if(lookupMimeType(originalPost.data!.almPost.showOriginalPostImagesOrVideos[next])?.contains('video') == true){
                                                                            return BetterPlayer.network('${originalPost.data!.almPost.showOriginalPostImagesOrVideos[index]}',
                                                                              betterPlayerConfiguration: const BetterPlayerConfiguration(
                                                                                autoDispose: false,
                                                                                aspectRatio: 1,
                                                                              ),
                                                                            );
                                                                          }else{
                                                                            return CachedNetworkImage(
                                                                              fit: BoxFit.cover,
                                                                              imageUrl: originalPost.data!.almPost.showOriginalPostImagesOrVideos[next],
                                                                              placeholder: (context, url) => const Center(child: const CircularProgressIndicator(),),
                                                                              errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
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
                                                                        onPressed: () => buttonCarouselController.previousPage(duration:const  Duration(milliseconds: 300), curve: Curves.linear),
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
                                                    if(lookupMimeType(originalPost.data!.almPost.showOriginalPostImagesOrVideos[index])?.contains('video') == true){
                                                      return BetterPlayer.network('${originalPost.data!.almPost.showOriginalPostImagesOrVideos[index]}',
                                                        betterPlayerConfiguration: const BetterPlayerConfiguration(
                                                          aspectRatio: 16 / 9,
                                                          controlsConfiguration: const BetterPlayerControlsConfiguration(
                                                            showControls: false,
                                                          ),
                                                        ),
                                                      );
                                                    }else{
                                                      return CachedNetworkImage(
                                                        fit: BoxFit.cover,
                                                        imageUrl: originalPost.data!.almPost.showOriginalPostImagesOrVideos[index],
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
                                                      transitionDuration: const Duration(milliseconds: 0),
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
                                                                        child: const Icon(Icons.close_rounded, color:const  Color(0xffffffff),),
                                                                      ),
                                                                    ),
                                                                  ),

                                                                  const SizedBox(height: 10,),

                                                                  Expanded(
                                                                    child: CarouselSlider(
                                                                      carouselController: buttonCarouselController,
                                                                      items: List.generate(originalPost.data!.almPost.showOriginalPostImagesOrVideos.length, (next) =>
                                                                        ((){
                                                                          if(lookupMimeType(originalPost.data!.almPost.showOriginalPostImagesOrVideos[next])?.contains('video') == true){
                                                                            return BetterPlayer.network('${originalPost.data!.almPost.showOriginalPostImagesOrVideos[next]}',
                                                                              betterPlayerConfiguration: const BetterPlayerConfiguration(
                                                                                autoDispose: false,
                                                                                aspectRatio: 1,
                                                                              ),
                                                                            );
                                                                          }else{
                                                                            return CachedNetworkImage(
                                                                              fit: BoxFit.cover,
                                                                              imageUrl: originalPost.data!.almPost.showOriginalPostImagesOrVideos[next],
                                                                              placeholder: (context, url) => const Center(child: const CircularProgressIndicator(),),
                                                                              errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
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
                                                      return lookupMimeType(originalPost.data!.almPost.showOriginalPostImagesOrVideos[index])?.contains('video') == true
                                                      ? BetterPlayer.network('${originalPost.data!.almPost.showOriginalPostImagesOrVideos[index]}',
                                                        betterPlayerConfiguration: const BetterPlayerConfiguration(
                                                          aspectRatio: 16 / 9,
                                                          controlsConfiguration: const BetterPlayerControlsConfiguration(
                                                            showControls: false,
                                                          ),
                                                        ),
                                                      )
                                                      : CachedNetworkImage(
                                                        fit: BoxFit.cover,
                                                        imageUrl: originalPost.data!.almPost.showOriginalPostImagesOrVideos[index],
                                                        placeholder: (context, url) => const Center(child: const CircularProgressIndicator(),),
                                                        errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                      );
                                                    }else{
                                                      return ((){
                                                        if(originalPost.data!.almPost.showOriginalPostImagesOrVideos.length - 3 > 0){
                                                          if(lookupMimeType(originalPost.data!.almPost.showOriginalPostImagesOrVideos[index])?.contains('video') == true){
                                                            return Stack(
                                                              fit: StackFit.expand,
                                                              children: [
                                                                BetterPlayer.network('${originalPost.data!.almPost.showOriginalPostImagesOrVideos[index]}',
                                                                  betterPlayerConfiguration: const BetterPlayerConfiguration(
                                                                    aspectRatio: 16 / 9,
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
                                                                      '${originalPost.data!.almPost.showOriginalPostImagesOrVideos.length - 3}',
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
                                                                  imageUrl: originalPost.data!.almPost.showOriginalPostImagesOrVideos[index],
                                                                  placeholder: (context, url) => const Center(child: const CircularProgressIndicator(),),
                                                                  errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                                ),

                                                                Container(color: const Color(0xff000000).withOpacity(0.5),),

                                                                Center(
                                                                  child: CircleAvatar(
                                                                    radius: 25,
                                                                    backgroundColor: const Color(0xffffffff).withOpacity(.5),
                                                                    child: Text(
                                                                      '${originalPost.data!.almPost.showOriginalPostImagesOrVideos.length - 3}',
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
                                                          if(lookupMimeType(originalPost.data!.almPost.showOriginalPostImagesOrVideos[index])?.contains('video') == true){
                                                            return BetterPlayer.network('${originalPost.data!.almPost.showOriginalPostImagesOrVideos[index]}',
                                                              betterPlayerConfiguration: const BetterPlayerConfiguration(
                                                                aspectRatio: 16 / 9,
                                                                controlsConfiguration: const BetterPlayerControlsConfiguration(
                                                                  showControls: false,
                                                                ),
                                                              ),
                                                            );
                                                          }else{
                                                            return CachedNetworkImage(
                                                              fit: BoxFit.cover,
                                                              imageUrl: originalPost.data!.almPost.showOriginalPostImagesOrVideos[index],
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

                                    originalPost.data!.almPost.showOriginalPostPostTagged.length != 0
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
                                                  children: List.generate(originalPost.data!.almPost.showOriginalPostPostTagged.length,
                                                    (index) => 
                                                    TextSpan(
                                                      style: const TextStyle(fontWeight: FontWeight.bold, color: const Color(0xff000000)),
                                                      children: <TextSpan>[
                                                        TextSpan(
                                                          text: originalPost.data!.almPost.showOriginalPostPostTagged[index].showOriginalPostTaggedFirstName + ' ' + originalPost.data!.almPost.showOriginalPostPostTagged[index].showOriginalPostTaggedLastName,
                                                          recognizer: TapGestureRecognizer()
                                                          ..onTap = (){
                                                            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularUserProfile(userId: originalPost.data!.almPost.showOriginalPostPostTagged[index].showOriginalPostTaggedId, accountType: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPagePageCreator.showOriginalPostPageCreatorAccountType)));
                                                          }
                                                        ),

                                                        index < originalPost.data!.almPost.showOriginalPostPostTagged.length - 1
                                                        ? const TextSpan(text: ', ')
                                                        : const TextSpan(text: ''),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ),

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
                                              const FaIcon(FontAwesomeIcons.heart, color: const Color(0xff000000),),

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
                                child: count != 0
                                ? Column(
                                  children: [
                                    Column(
                                      children: List.generate(
                                        comments.length, (i) => ListTile(
                                          onTap: (){
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularUserProfile(userId: comments[i].userId, accountType: comments[i].userAccountType,)));
                                          },
                                          onLongPress: () async{
                                            if(currentUserId == comments[i].userId && currentAccountType == comments[i].userAccountType){
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
                                                          controller.text = controller.text + comments[i].commentBody;
                                                          await showModalBottomSheet(
                                                            context: context, 
                                                            builder: (context) => showKeyboardEdit(isEdit: true, editId: comments[i].commentId),
                                                          );
                                                        },
                                                      ),
                                                      ListTile(
                                                        title: const Text('Delete'),
                                                        leading: const Icon(Icons.delete),
                                                        onTap: () async{  
                                                          context.loaderOverlay.show();
                                                          await apiRegularDeleteComment(commentId: comments[i].commentId);
                                                          context.loaderOverlay.hide();

                                                          controller.clear();
                                                          itemRemaining = 1;
                                                          repliesRemaining = 1;
                                                          comments = [];
                                                          replies = [];
                                                          numberOfReplies = 0;
                                                          page1 = 1;
                                                          page2 = 1;
                                                          count = 0;
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
                                                          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularReport(postId: postId, reportType: 'Post')));
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
                                            backgroundImage: NetworkImage(comments[i].image),
                                            backgroundColor: const Color(0xff888888),
                                          ),
                                          title: Row(
                                            children: [
                                              Expanded(
                                                child: currentUserId == comments[i].userId && currentAccountType == comments[i].userAccountType
                                                ? const Text('You',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                )
                                                : Text('${comments[i].firstName}' + ' ' + '${comments[i].lastName}',
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

                                                        await apiRegularLikeOrUnlikeCommentReply(commentableType: 'Comment', commentableId: comments[i].commentId, likeStatus: false);
                                                      }else{
                                                        setState(() {
                                                          commentsLikes[i] = true;
                                                          commentsNumberOfLikes[i]++;
                                                        });

                                                        await apiRegularLikeOrUnlikeCommentReply(commentableType: 'Comment', commentableId: comments[i].commentId, likeStatus: true);
                                                      }
                                                    }, 
                                                    icon: commentsLikes[i] == true ? const FaIcon(FontAwesomeIcons.solidHeart, color: const Color(0xffE74C3C),) : const FaIcon(FontAwesomeIcons.heart, color: const Color(0xff888888),),
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
                                                        comments[i].commentBody,
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
                                                  Text(timeago.format(DateTime.parse(comments[i].createdAt))),

                                                  const SizedBox(width: 20,),

                                                  GestureDetector(
                                                    onTap: () async{
                                                      if(controller.text != ''){
                                                        controller.clear();
                                                      }

                                                      setState(() {
                                                        isComment = false;
                                                        currentCommentId = comments[i].commentId;
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

                                              comments[i].listOfReplies.length != 0
                                              ? Column(
                                                  children: List.generate(comments[i].listOfReplies.length, (index) => 
                                                  ListTile(
                                                    contentPadding: EdgeInsets.zero,
                                                    visualDensity: const VisualDensity(vertical: 4.0),
                                                    onTap: (){
                                                      Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularUserProfile(userId: comments[i].listOfReplies[index].userId, accountType: currentAccountType,)));
                                                    },
                                                    onLongPress: () async{
                                                      if(currentUserId == comments[i].listOfReplies[index].userId && currentAccountType == comments[i].listOfReplies[index].userAccountType){
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
                                                                    controller.text = controller.text + comments[i].listOfReplies[index].replyBody;
                                                                    await showModalBottomSheet(
                                                                      context: context, 
                                                                      builder: (context) => showKeyboardEdit(isEdit: false, editId: comments[i].listOfReplies[index].replyId),
                                                                    );
                                                                  },
                                                                ),
                                                                ListTile(
                                                                  title: const Text('Delete'),
                                                                  leading: const Icon(Icons.delete),
                                                                  onTap: () async{  
                                                                    context.loaderOverlay.show();
                                                                    await apiRegularDeleteReply(replyId: comments[i].listOfReplies[index].replyId);
                                                                    context.loaderOverlay.hide();

                                                                    controller.clear();
                                                                    itemRemaining = 1;
                                                                    repliesRemaining = 1;
                                                                    comments = [];
                                                                    replies = [];
                                                                    numberOfReplies = 0;
                                                                    page1 = 1;
                                                                    page2 = 1;
                                                                    count = 0;
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
                                                                    Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularReport(postId: postId, reportType: 'Post')));
                                                                  },
                                                                ),
                                                              ],
                                                            ),
                                                          )
                                                        );
                                                      }
                                                    },
                                                    leading: CircleAvatar(
                                                      backgroundImage: NetworkImage(comments[i].listOfReplies[index].image),
                                                      backgroundColor: const Color(0xff888888),
                                                    ),
                                                    title: Row(
                                                      children: [
                                                        Expanded(
                                                          child: currentUserId == comments[i].listOfReplies[index].userId && currentAccountType == comments[i].listOfReplies[index].userAccountType
                                                          ? const Text('You',
                                                            style: const TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          )
                                                          : Text(comments[i].listOfReplies[index].firstName + ' ' + comments[i].listOfReplies[index].lastName,
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

                                                                  await apiRegularLikeOrUnlikeCommentReply(commentableType: 'Reply', commentableId: comments[i].listOfReplies[index].replyId, likeStatus: false);
                                                                }else{
                                                                  setState(() {
                                                                    repliesLikes[i][index] = true;
                                                                    repliesNumberOfLikes[i][index]++;
                                                                  });

                                                                  await apiRegularLikeOrUnlikeCommentReply(commentableType: 'Reply', commentableId: comments[i].listOfReplies[index].replyId, likeStatus: true);
                                                                }
                                                              }, 
                                                              icon: repliesLikes[i][index] == true ? const FaIcon(FontAwesomeIcons.solidHeart, color: const Color(0xffE74C3C),) : const FaIcon(FontAwesomeIcons.heart, color: const Color(0xff888888),),
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
                                                                  comments[i].listOfReplies[index].replyBody,
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
                                                            Text(timeago.format(DateTime.parse(comments[i].listOfReplies[index].createdAt))),

                                                            const SizedBox(width: 40,),

                                                            GestureDetector(
                                                              onTap: () async{
                                                                if(controller.text != ''){
                                                                  controller.clear();
                                                                }

                                                                controller.text = comments[i].firstName + ' ' + comments[i].lastName + ' ';

                                                                setState(() {
                                                                  isComment = false;
                                                                  currentCommentId = comments[i].commentId;
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
                      return const MiscRegularErrorMessageTemplate();
                    }else{
                      return Container(height: SizeConfig.screenHeight, child: Center(child: Container(child: const SpinKitThreeBounce(color: const Color(0xff000000), size: 50.0,), color: const Color(0xffffffff),),),);
                    }
                  }
                ),
              ),

              isGuestLoggedIn
              ? BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: const MiscRegularLoginToContinue(),
              )
              : Container(height: 0),
            ],
          ),
        ),
      ),
    );
  }

  showKeyboard(){
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.only(left: 20.0, right: 20.0,),
        child: Row(
          children: [

            currentUserImage != ''
            ? CircleAvatar(
              backgroundColor: Color(0xff888888),
              backgroundImage: NetworkImage(currentUserImage),
            )
            : CircleAvatar(
              backgroundColor: Color(0xff888888),
              backgroundImage: AssetImage('assets/icons/app-icon.png'),
            ),

            Expanded(
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: TextFormField(
                  controller: controller,
                  cursorColor: Color(0xff000000),
                  maxLines: 2,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    fillColor: Color(0xffBDC3C7),
                    filled: true,
                    labelText: 'Say something...',
                    labelStyle: TextStyle(
                      fontSize: 14,
                      color: Color(0xffffffff),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xffBDC3C7),
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xffBDC3C7),
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
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
                      title: Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                      entryAnimation: EntryAnimation.DEFAULT,
                      description: Text('Please input a comment.',
                        textAlign: TextAlign.center,
                        style: TextStyle(),
                      ),
                      onlyOkButton: true,
                      buttonOkColor: Colors.red,
                      onOkButtonPressed: () {
                        Navigator.pop(context, true);
                      },
                    )
                  );
                }else if(isComment == true && controller.text != ''){
                  context.loaderOverlay.show();
                  await apiRegularAddComment(postId: postId, commentBody: controller.text);
                  context.loaderOverlay.hide();

                  controller.clear();
                  itemRemaining = 1;
                  repliesRemaining = 1;
                  comments = [];
                  replies = [];
                  numberOfReplies = 0;
                  page1 = 1;
                  page2 = 1;
                  count = 0;
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
                  apiRegularAddReply(commentId: currentCommentId, replyBody: controller.text);
                  context.loaderOverlay.hide();

                  controller.clear();
                  itemRemaining = 1;
                  repliesRemaining = 1;
                  comments = [];
                  replies = [];
                  numberOfReplies = 0;
                  page1 = 1;
                  page2 = 1;
                  count = 0;
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
              child: Text('Post',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold, 
                  color: Color(0xff000000),
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
        padding: EdgeInsets.only(left: 20.0, right: 20.0,),
        child: Row(
          children: [
            
            CircleAvatar(
              backgroundColor: Color(0xff888888), 
              backgroundImage: NetworkImage(currentUserImage),
            ),

            Expanded(
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: TextFormField(
                  controller: controller,
                  cursorColor: Color(0xff000000),
                  maxLines: 2,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    fillColor: Color(0xffBDC3C7),
                    filled: true,
                    labelText: 'Say something...',
                    labelStyle: TextStyle(
                      fontSize: 14,
                      color: Color(0xffffffff),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xffBDC3C7),
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xffBDC3C7),
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
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
                      title: Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                      entryAnimation: EntryAnimation.DEFAULT,
                      description: Text('Please input a comment.',
                        textAlign: TextAlign.center,
                        style: TextStyle(),
                      ),
                      onlyOkButton: true,
                      buttonOkColor: Colors.red,
                      onOkButtonPressed: () {
                        Navigator.pop(context, true);
                      },
                    )
                  );
                }else if(isEdit == true){
                  context.loaderOverlay.show();
                  await apiRegularEditComment(commentId: editId, commentBody: controller.text);
                  context.loaderOverlay.hide();

                  controller.clear();
                  itemRemaining = 1;
                  repliesRemaining = 1;
                  comments = [];
                  replies = [];
                  numberOfReplies = 0;
                  page1 = 1;
                  page2 = 1;
                  count = 0;
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
                  await apiRegularEditReply(replyId: editId, replyBody: controller.text);
                  context.loaderOverlay.hide();

                  controller.clear();
                  itemRemaining = 1;
                  repliesRemaining = 1;
                  comments = [];
                  replies = [];
                  numberOfReplies = 0;
                  page1 = 1;
                  page2 = 1;
                  count = 0;
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
              child: Text('Post',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold, 
                  color: Color(0xff000000),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}