import 'package:facesbyplaces/UI/Home/Regular/02-View-Memorial/home-view-memorial-regular-01-managed-memorial.dart';
import 'package:facesbyplaces/UI/Home/Regular/02-View-Memorial/home-view-memorial-regular-02-profile-memorial.dart';
import 'package:facesbyplaces/UI/Home/BLM/02-View-Memorial/home-view-memorial-blm-01-managed-memorial.dart';
import 'package:facesbyplaces/UI/Home/BLM/02-View-Memorial/home-view-memorial-blm-02-profile-memorial.dart';
import 'package:facesbyplaces/UI/Home/BLM/12-Show-User/home-show-user-blm-01-user.dart';
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
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-12-blm-dropdown.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:keyboard_attachable/keyboard_attachable.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:full_screen_menu/full_screen_menu.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:better_player/better_player.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'dart:ui';

class BLMOriginalComment{
  int commentId;
  int postId;
  int userId;
  String commentBody;
  String createdAt;
  String firstName;
  String lastName;
  dynamic image;
  bool commentLikes;
  int commentNumberOfLikes;
  List<BLMOriginalReply> listOfReplies;

  BLMOriginalComment({this.commentId, this.postId, this.userId, this.commentBody, this.createdAt, this.firstName, this.lastName, this.image, this.commentLikes, this.commentNumberOfLikes, this.listOfReplies});
}

class BLMOriginalReply{
  int replyId;
  int commentId;
  int userId;
  String replyBody;
  String createdAt;
  String firstName;
  String lastName;
  dynamic image;
  bool replyLikes;
  int replyNumberOfLikes;

  BLMOriginalReply({this.replyId, this.commentId, this.userId, this.replyBody, this.createdAt, this.firstName, this.lastName, this.image, this.replyLikes, this.replyNumberOfLikes});
}

class HomeBLMShowOriginalPostComments extends StatefulWidget{
  final int postId;
  final int userId;
  HomeBLMShowOriginalPostComments({this.postId, this.userId});

  @override
  HomeBLMShowOriginalPostCommentsState createState() => HomeBLMShowOriginalPostCommentsState(postId: postId, userId: userId);
}

class HomeBLMShowOriginalPostCommentsState extends State<HomeBLMShowOriginalPostComments>{
  final int postId;
  final int userId;
  HomeBLMShowOriginalPostCommentsState({this.postId, this.userId});

  RefreshController refreshController = RefreshController(initialRefresh: true);
  TextEditingController controller = TextEditingController();
  ScrollController _scrollController = ScrollController();
  List<BLMOriginalComment> comments;
  List<BLMOriginalReply> replies;
  int itemRemaining;
  int repliesRemaining;
  int page1;
  int count;
  int numberOfReplies;
  int page2;
  List<bool> commentsLikes;
  List<int> commentsNumberOfLikes;
  bool isComment;
  List<List<bool>> repliesLikes;
  List<List<int>> repliesNumberOfLikes;
  int currentCommentId;
  String currentUserImage;
  int numberOfLikes;
  int numberOfComments;
  GlobalKey profileKey = GlobalKey<HomeBLMShowOriginalPostCommentsState>();
  
  void onRefresh() async{
    await Future.delayed(Duration(milliseconds: 1000));
    refreshController.refreshCompleted();
  }

  void getOriginalPostInformation() async{
    var originalPostInformation = await apiBLMShowOriginalPost(postId: postId);
    numberOfLikes = originalPostInformation.blmPost.showOriginalPostNumberOfLikes;
    numberOfComments = originalPostInformation.blmPost.showOriginalPostNumberOfComments;
  }

  void getProfilePicture() async{
    var getProfilePicture = await apiBLMShowProfileInformation();
    currentUserImage = getProfilePicture.showProfileInformationImage;
  }

  void onLoading() async{
    
    if(itemRemaining != 0){
      context.showLoaderOverlay();
      
      var newValue1 = await apiBLMShowListOfComments(postId: postId, page: page1);
      itemRemaining = newValue1.blmItemsRemaining;
      count = count + newValue1.blmCommentsList.length;

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

            replies.add(
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
        
        comments.add(
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
            listOfReplies: replies
          ),    
        );
        replies = [];
      }

      if(mounted)
      setState(() {});
      page1++;
      
      refreshController.loadComplete();
      context.hideLoaderOverlay();
    }else{
      refreshController.loadNoData();
    }
  }



  Future showOriginalPost;
  bool likePost;
  bool pressedLike;
  int likesCount;
  BranchUniversalObject buo;
  BranchLinkProperties lp;
  bool isGuestLoggedIn;

  void isGuest() async{
    final sharedPrefs = await SharedPreferences.getInstance();
    setState(() {
      isGuestLoggedIn = sharedPrefs.getBool('user-guest-session') ?? true;
    });
  }

  Future<APIBLMShowOriginalPostMain> getOriginalPost(postId) async{
    return await apiBLMShowOriginalPost(postId: postId);
  }

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
    isGuestLoggedIn = true;
    isGuest();
    pressedLike = false;
    likesCount = numberOfLikes;
    showOriginalPost = getOriginalPost(postId);
    getProfilePicture();

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
            backgroundColor: Color(0xff04ECFF),
            title: Text('Post', style: TextStyle(fontSize: 16, color: Color(0xffffffff)),),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Color(0xffffffff),), 
              onPressed: (){
                Navigator.pop(context);
              },
            ),
            actions: [
              MiscBLMDropDownTemplate(postId: postId, likePost: likePost, likesCount: likesCount, reportType: 'Post',),
            ],
          ),
          backgroundColor: Color(0xffffffff),
          body: FooterLayout(
            footer: showKeyboard(),
            child: SmartRefresher(
              enablePullDown: true,
              enablePullUp: true,
              header: MaterialClassicHeader(
                color: Color(0xffffffff),
                backgroundColor: Color(0xff4EC9D4),
              ),
              footer: CustomFooter(
                loadStyle: LoadStyle.ShowWhenLoading,
                builder: (BuildContext context, LoadStatus mode){
                  Widget body;
                  if(mode == LoadStatus.loading){
                    body = CircularProgressIndicator();
                  }
                  return Center(child: body);
                },
              ),
              controller: refreshController,
              onRefresh: onRefresh,
              onLoading: onLoading,
              child: CustomScrollView(
                controller: _scrollController,
                slivers: <Widget>[
                  SliverToBoxAdapter(
                    child: FutureBuilder<APIBLMShowOriginalPostMain>(
                      future: showOriginalPost,
                      builder: (context, originalPost){
                        if(originalPost.hasData){
                          return Column(
                            key: profileKey,
                            children: [
                              Container(
                                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                                height: 80,
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () async{
                                        if(originalPost.data.blmPost.showOriginalPostPage.showOriginalPostPagePageType == 'Memorial'){
                                          if(originalPost.data.blmPost.showOriginalPostPage.showOriginalPostPageManage == true || originalPost.data.blmPost.showOriginalPostPage.showOriginalPostPageFamOrFriends == true){
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularProfile(memorialId: originalPost.data.blmPost.showOriginalPostPage.showOriginalPostPageId, relationship: originalPost.data.blmPost.showOriginalPostPage.showOriginalPostPageRelationship, managed: originalPost.data.blmPost.showOriginalPostPage.showOriginalPostPageManage)));
                                          }else{
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularMemorialProfile(memorialId: originalPost.data.blmPost.showOriginalPostPage.showOriginalPostPageId, pageType: originalPost.data.blmPost.showOriginalPostPage.showOriginalPostPagePageType, newJoin: originalPost.data.blmPost.showOriginalPostPage.showOriginalPostPageFollower,)));
                                          }
                                        }else{
                                          if(originalPost.data.blmPost.showOriginalPostPage.showOriginalPostPageManage == true || originalPost.data.blmPost.showOriginalPostPage.showOriginalPostPageFamOrFriends == true){
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMProfile(memorialId: originalPost.data.blmPost.showOriginalPostPage.showOriginalPostPageId, relationship: originalPost.data.blmPost.showOriginalPostPage.showOriginalPostPageRelationship, managed: originalPost.data.blmPost.showOriginalPostPage.showOriginalPostPageManage)));
                                          }else{
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMMemorialProfile(memorialId: originalPost.data.blmPost.showOriginalPostPage.showOriginalPostPageId, pageType: originalPost.data.blmPost.showOriginalPostPage.showOriginalPostPagePageType, newJoin: originalPost.data.blmPost.showOriginalPostPage.showOriginalPostPageFollower,)));
                                          }
                                        }
                                      },
                                      child: CircleAvatar(backgroundColor: Color(0xff888888), backgroundImage: originalPost.data.blmPost.showOriginalPostPage.showOriginalPostPageProfileImage != null ? NetworkImage(originalPost.data.blmPost.showOriginalPostPage.showOriginalPostPageProfileImage) : AssetImage('assets/icons/app-icon.png')),
                                    ),
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.only(left: 10.0),
                                        child: GestureDetector(
                                          onTap: () async{
                                            if(originalPost.data.blmPost.showOriginalPostPage.showOriginalPostPagePageType == 'Memorial'){
                                              if(originalPost.data.blmPost.showOriginalPostPage.showOriginalPostPageManage == true || originalPost.data.blmPost.showOriginalPostPage.showOriginalPostPageFamOrFriends == true){
                                                Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularProfile(memorialId: originalPost.data.blmPost.showOriginalPostPage.showOriginalPostPageId, relationship: originalPost.data.blmPost.showOriginalPostPage.showOriginalPostPageRelationship, managed: originalPost.data.blmPost.showOriginalPostPage.showOriginalPostPageManage)));
                                              }else{
                                                Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularMemorialProfile(memorialId: originalPost.data.blmPost.showOriginalPostPage.showOriginalPostPageId, pageType: originalPost.data.blmPost.showOriginalPostPage.showOriginalPostPagePageType, newJoin: originalPost.data.blmPost.showOriginalPostPage.showOriginalPostPageFollower,)));
                                              }
                                            }else{
                                              if(originalPost.data.blmPost.showOriginalPostPage.showOriginalPostPageManage == true || originalPost.data.blmPost.showOriginalPostPage.showOriginalPostPageFamOrFriends == true){
                                                Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMProfile(memorialId: originalPost.data.blmPost.showOriginalPostPage.showOriginalPostPageId, relationship: originalPost.data.blmPost.showOriginalPostPage.showOriginalPostPageRelationship, managed: originalPost.data.blmPost.showOriginalPostPage.showOriginalPostPageManage)));
                                              }else{
                                                Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMMemorialProfile(memorialId: originalPost.data.blmPost.showOriginalPostPage.showOriginalPostPageId, pageType: originalPost.data.blmPost.showOriginalPostPage.showOriginalPostPagePageType, newJoin: originalPost.data.blmPost.showOriginalPostPage.showOriginalPostPageFollower,)));
                                              }
                                            }
                                          },
                                          child: Column(
                                            children: [
                                              Expanded(
                                                child: Align(alignment: Alignment.bottomLeft,
                                                  child: Text(originalPost.data.blmPost.showOriginalPostPage.showOriginalPostPageName,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold,
                                                      color: Color(0xff000000),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Align(
                                                  alignment: Alignment.topLeft,
                                                  child: Text(timeago.format(DateTime.parse(originalPost.data.blmPost.showOriginalPostCreateAt)),
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                      fontSize: 14,
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
                                  ],
                                ),
                              ),

                              Container(
                                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                                alignment: Alignment.centerLeft, 
                                child: Text(originalPost.data.blmPost.showOriginalPostBody),
                              ),

                              originalPost.data.blmPost.showOriginalPostImagesOrVideos != null
                              ? Column(
                                children: [
                                  SizedBox(height: 20),

                                  Container(
                                    child: ((){
                                      if(originalPost.data.blmPost.showOriginalPostImagesOrVideos != null){
                                        if(originalPost.data.blmPost.showOriginalPostImagesOrVideos.length == 1){
                                          if(lookupMimeType(originalPost.data.blmPost.showOriginalPostImagesOrVideos[0]).contains('video') == true){
                                            return Container(
                                              child: BetterPlayer.network(
                                                '${originalPost.data.blmPost.showOriginalPostImagesOrVideos[0]}',
                                                betterPlayerConfiguration: BetterPlayerConfiguration(
                                                  aspectRatio: 16 / 9,
                                                ),
                                              ),
                                            );
                                          }else{
                                            return Container(
                                              child: CachedNetworkImage(
                                                fit: BoxFit.contain,
                                                imageUrl: originalPost.data.blmPost.showOriginalPostImagesOrVideos[0],
                                                placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                                                errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 1.0,),
                                              ),
                                            );
                                          }
                                        }else if(originalPost.data.blmPost.showOriginalPostImagesOrVideos.length == 2){
                                          return StaggeredGridView.countBuilder(
                                            padding: EdgeInsets.zero,
                                            shrinkWrap: true,
                                            physics: NeverScrollableScrollPhysics(),
                                            crossAxisCount: 4,
                                            itemCount: 2,
                                            itemBuilder: (BuildContext context, int index) => 
                                              GestureDetector(
                                                onTap: () async{
                                                  FullScreenMenu.show(
                                                    context,
                                                    backgroundColor: Color(0xff888888),
                                                    items: [
                                                      Center(
                                                        child: Container(
                                                          child: CarouselSlider(
                                                            items: List.generate(
                                                              originalPost.data.blmPost.showOriginalPostImagesOrVideos.length, (next) =>
                                                              lookupMimeType(originalPost.data.blmPost.showOriginalPostImagesOrVideos[next]).contains('video') == true
                                                              ? Container(
                                                                child: BetterPlayer.network(
                                                                  '${originalPost.data.blmPost.showOriginalPostImagesOrVideos[next]}',
                                                                  betterPlayerConfiguration: BetterPlayerConfiguration(
                                                                    controlsConfiguration: BetterPlayerControlsConfiguration(
                                                                    ),
                                                                    aspectRatio: 16 / 9,
                                                                  ),
                                                                ),
                                                              )
                                                              : CachedNetworkImage(
                                                                fit: BoxFit.cover,
                                                                imageUrl: originalPost.data.blmPost.showOriginalPostImagesOrVideos[next],
                                                                placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                                                                errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                              ),
                                                            ),
                                                            options: CarouselOptions(
                                                              autoPlay: false,
                                                              enlargeCenterPage: true,
                                                              viewportFraction: 0.9,
                                                              aspectRatio: 2.0,
                                                              initialPage: 2,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                },
                                                child: lookupMimeType(originalPost.data.blmPost.showOriginalPostImagesOrVideos[index]).contains('video') == true
                                                ? Container(
                                                  child: Stack(
                                                    children: [
                                                    BetterPlayer.network('${originalPost.data.blmPost.showOriginalPostImagesOrVideos[index]}',
                                                      betterPlayerConfiguration: BetterPlayerConfiguration(
                                                        controlsConfiguration: BetterPlayerControlsConfiguration(
                                                          showControls: false
                                                        ),
                                                        aspectRatio: 16 / 9,
                                                      ),
                                                    ),

                                                    Center(
                                                      child: CircleAvatar(
                                                        backgroundColor: Color(0xff00000000),
                                                        child: Icon(Icons.play_arrow_rounded, color: Color(0xffffffff),),
                                                      ),
                                                    ),
                                                      
                                                    ],
                                                  ),
                                                  height: 250,
                                                )
                                                : CachedNetworkImage(
                                                  fit: BoxFit.cover,
                                                  imageUrl: originalPost.data.blmPost.showOriginalPostImagesOrVideos[index],
                                                  placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                                                  errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                ),

                                              ),
                                            staggeredTileBuilder: (int index) => StaggeredTile.count(2, 2),
                                            mainAxisSpacing: 4.0,
                                            crossAxisSpacing: 4.0,
                                          );
                                        }else{
                                          return Container(
                                            child: StaggeredGridView.countBuilder(
                                              padding: EdgeInsets.zero,
                                              physics: NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              crossAxisCount: 4,
                                              itemCount: 3,
                                              itemBuilder: (BuildContext context, int index) => 
                                              GestureDetector(
                                                onTap: () async{
                                                  FullScreenMenu.show(
                                                    context,
                                                    backgroundColor: Color(0xff888888),
                                                    items: [

                                                      Center(
                                                        child: Container(
                                                          child: CarouselSlider(
                                                            items: List.generate(
                                                              originalPost.data.blmPost.showOriginalPostImagesOrVideos.length, (next) =>
                                                              lookupMimeType(originalPost.data.blmPost.showOriginalPostImagesOrVideos[next]).contains('video') == true
                                                              ? Container(
                                                                child: BetterPlayer.network(
                                                                  '${originalPost.data.blmPost.showOriginalPostImagesOrVideos[next]}',
                                                                  betterPlayerConfiguration: BetterPlayerConfiguration(
                                                                    controlsConfiguration: BetterPlayerControlsConfiguration(
                                                                    ),
                                                                    aspectRatio: 16 / 9,
                                                                  ),
                                                                ),
                                                                height: 250,
                                                              )
                                                              : CachedNetworkImage(
                                                                fit: BoxFit.cover,
                                                                imageUrl: originalPost.data.blmPost.showOriginalPostImagesOrVideos[next],
                                                                placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                                                                errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                              ),
                                                            ),
                                                            options: CarouselOptions(
                                                              autoPlay: false,
                                                              enlargeCenterPage: true,
                                                              viewportFraction: 0.9,
                                                              aspectRatio: 2.0,
                                                              initialPage: 2,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                },
                                                child: ((){
                                                  if(index != 1){
                                                    return lookupMimeType(originalPost.data.blmPost.showOriginalPostImagesOrVideos[index]).contains('video') == true
                                                    ? Container(
                                                      child: Stack(
                                                        children: [
                                                          BetterPlayer.network(
                                                            '${originalPost.data.blmPost.showOriginalPostImagesOrVideos[index]}',
                                                            betterPlayerConfiguration: BetterPlayerConfiguration(
                                                              controlsConfiguration: BetterPlayerControlsConfiguration(
                                                                showControls: false,
                                                              ),
                                                              aspectRatio: 16 / 9,
                                                            ),
                                                          ),

                                                          Center(
                                                            child: CircleAvatar(
                                                              backgroundColor: Color(0xff00000000),
                                                              child: Icon(Icons.play_arrow_rounded, color: Color(0xffffffff),),
                                                            ),
                                                          ),
                                                          
                                                        ],
                                                      ),
                                                    )
                                                    : CachedNetworkImage(
                                                      fit: BoxFit.contain,
                                                      imageUrl: originalPost.data.blmPost.showOriginalPostImagesOrVideos[index],
                                                      placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                                                      errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 1.0,),
                                                    );
                                                  }else{
                                                    return ((){
                                                      if(originalPost.data.blmPost.showOriginalPostImagesOrVideos.length - 3 > 0){
                                                        if(lookupMimeType(originalPost.data.blmPost.showOriginalPostImagesOrVideos[0]).contains('video') == true){
                                                          return Stack(
                                                            children: [
                                                              Container(
                                                                child: Stack(
                                                                  children: [
                                                                    BetterPlayer.network(
                                                                      '${originalPost.data.blmPost.showOriginalPostImagesOrVideos[index]}',
                                                                      betterPlayerConfiguration: BetterPlayerConfiguration(
                                                                        controlsConfiguration: BetterPlayerControlsConfiguration(
                                                                          showControls: false,
                                                                        ),
                                                                        aspectRatio: 16 / 9,
                                                                      ),
                                                                    ),

                                                                    Center(
                                                                      child: CircleAvatar(
                                                                        backgroundColor: Color(0xff00000000),
                                                                        child: Icon(Icons.play_arrow_rounded, color: Color(0xffffffff),),
                                                                      ),
                                                                    ),
                                                                    
                                                                  ],
                                                                ),
                                                              ),

                                                              Container(color: Colors.black.withOpacity(0.5),),

                                                              Center(
                                                                child: CircleAvatar(
                                                                  radius: 25,
                                                                  backgroundColor: Color(0xffffffff).withOpacity(.5),
                                                                  child: Text(
                                                                    '${originalPost.data.blmPost.showOriginalPostImagesOrVideos.length - 3}',
                                                                    style: TextStyle(
                                                                      fontSize: 40,
                                                                      fontWeight: FontWeight.bold,
                                                                      color: Color(0xffffffff),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                        }else{
                                                          return Stack(
                                                            children: [
                                                              CachedNetworkImage(
                                                                fit: BoxFit.contain,
                                                                imageUrl: originalPost.data.blmPost.showOriginalPostImagesOrVideos[index],
                                                                placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                                                                errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 1.0,),
                                                              ),

                                                              Container(color: Colors.black.withOpacity(0.5),),

                                                              Center(
                                                                child: CircleAvatar(
                                                                  radius: 25,
                                                                  backgroundColor: Color(0xffffffff).withOpacity(.5),
                                                                  child: Text(
                                                                    '${originalPost.data.blmPost.showOriginalPostImagesOrVideos.length - 3}',
                                                                    style: TextStyle(
                                                                      fontSize: 40,
                                                                      fontWeight: FontWeight.bold,
                                                                      color: Color(0xffffffff),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                        }
                                                      }else{
                                                        if(lookupMimeType(originalPost.data.blmPost.showOriginalPostImagesOrVideos[0]).contains('video') == true){
                                                          return Container(
                                                            child: Stack(
                                                              children: [
                                                                BetterPlayer.network(
                                                                  '${originalPost.data.blmPost.showOriginalPostImagesOrVideos[index]}',
                                                                  betterPlayerConfiguration: BetterPlayerConfiguration(
                                                                    controlsConfiguration: BetterPlayerControlsConfiguration(
                                                                      showControls: false,
                                                                    ),
                                                                    aspectRatio: 16 / 9,
                                                                  ),
                                                                ),


                                                                Center(
                                                                  child: CircleAvatar(
                                                                    backgroundColor: Color(0xff00000000),
                                                                    child: Icon(Icons.play_arrow_rounded, color: Color(0xffffffff),),
                                                                  ),
                                                                ),
                                                                
                                                              ],
                                                            ),
                                                          );
                                                        }else{
                                                          return CachedNetworkImage(
                                                            fit: BoxFit.contain,
                                                            imageUrl: originalPost.data.blmPost.showOriginalPostImagesOrVideos[index],
                                                            placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                                                            errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 1.0,),
                                                          );
                                                        }
                                                      }
                                                    }());
                                                  }
                                                }()),
                                              ),
                                              staggeredTileBuilder: (int index) => StaggeredTile.count(2, index.isEven ? 1 : 2),
                                              mainAxisSpacing: 4.0,
                                              crossAxisSpacing: 4.0,
                                            ),
                                          );
                                        }
                                      }else{
                                        return Container(height: 0,);
                                      }
                                    }()),
                                  ),

                                  SizedBox(height: 20),

                                ],
                              )
                              : Container(color: Colors.red, height: 0,),

                              originalPost.data.blmPost.showOriginalPostPostTagged.length != 0
                              ? Column(
                                children: [
                                  SizedBox(height: 20),

                                  Row(
                                    children: [
                                      Text('with'),

                                      Container(
                                        child: Wrap(
                                          direction: Axis.vertical,
                                          spacing: 5.0,
                                          children: List.generate(
                                            originalPost.data.blmPost.showOriginalPostPostTagged.length,
                                            (index) => GestureDetector(
                                              onTap: (){
                                                Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMUserProfile(userId: originalPost.data.blmPost.showOriginalPostPostTagged[index].showOriginalPostTaggedId)));
                                              },
                                              child: RichText(
                                                text: TextSpan(
                                                  style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xff000000)),
                                                  children: <TextSpan>[
                                                    TextSpan(text: originalPost.data.blmPost.showOriginalPostPostTagged[index].showOriginalPostTaggedFirstName,),

                                                    TextSpan(text: ' '),

                                                    TextSpan(text: originalPost.data.blmPost.showOriginalPostPostTagged[index].showOriginalPostTaggedLastName,),

                                                    index < originalPost.data.blmPost.showOriginalPostPostTagged.length - 1
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

                                ],
                              )
                              : Container(height: 0,),

                              Container(
                                height: 40,
                                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [

                                    Row(
                                      children: [
                                        Icon(Icons.favorite_border_outlined, color: Color(0xff000000),),

                                        SizedBox(width: 10,),

                                        Text('$numberOfLikes', style: TextStyle(fontSize: 16, color: Color(0xff000000),),),

                                      ],
                                    ),

                                    SizedBox(width: 40,),

                                    Row(
                                      children: [
                                        Icon(Icons.chat_bubble_outline_outlined, color: Color(0xff000000),),

                                        SizedBox(width: 10,),

                                        Text('$numberOfComments', style: TextStyle(fontSize: 16, color: Color(0xff000000),),),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                            ],
                          );
                        }else if(originalPost.hasError){
                          return Container(child: Center(child: Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: Color(0xff000000),),),));
                        }else{
                          return Container(height: 0,);
                        }
                      }
                    ),
                  ),

                  SliverToBoxAdapter(
                    child: count != 0
                    ? Column(
                      children: [
                        Column(
                          children: List.generate(
                            comments.length, (i) => ListTile(
                              visualDensity: VisualDensity(vertical: 4.0),
                              leading: CircleAvatar(
                                backgroundImage: comments[i].image != null ? NetworkImage(comments[i].image) : AssetImage('assets/icons/app-icon.png'),
                                backgroundColor: Color(0xff888888),
                              ),
                              title: Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMUserProfile(userId: comments[i].userId)));
                                      },
                                      child: userId == comments[i].userId
                                      ? Text('You',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                      : Text('${comments[i].firstName}' + ' ' + '${comments[i].lastName}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: FlatButton.icon(
                                        shape: CircleBorder(),
                                        splashColor: Colors.transparent,
                                        onPressed: () async{
                                          if(commentsLikes[i] == true){
                                            setState(() {
                                              commentsLikes[i] = false;
                                              commentsNumberOfLikes[i]--;
                                            });

                                            await apiBLMLikeOrUnlikeCommentReply(commentableType: 'Comment', commentableId: comments[i].commentId, likeStatus: false);
                                          }else{
                                            setState(() {
                                              commentsLikes[i] = true;
                                              commentsNumberOfLikes[i]++;
                                            });

                                            await apiBLMLikeOrUnlikeCommentReply(commentableType: 'Comment', commentableId: comments[i].commentId, likeStatus: true);
                                          }
                                        }, 
                                        icon: commentsLikes[i] == true ? FaIcon(FontAwesomeIcons.peace, color: Colors.red,) : FaIcon(FontAwesomeIcons.peace, color: Colors.grey,),
                                        label: Text('${commentsNumberOfLikes[i]}', style: TextStyle(fontSize: 16, color: Color(0xff000000),),),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              subtitle: Column(
                                children: [
                                  GestureDetector(
                                    onLongPress: () async{
                                      await showMaterialModalBottomSheet(
                                        context: context, 
                                        builder: (context) => 
                                          SafeArea(
                                          top: false,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              ListTile(
                                                title: Text('Edit'),
                                                leading: Icon(Icons.edit),
                                                onTap: () async{
                                                  controller.text = controller.text + comments[i].commentBody;
                                                  await showModalBottomSheet(
                                                    context: context, 
                                                    builder: (context) => showKeyboardEdit(isEdit: true, editId: comments[i].commentId),
                                                  );
                                                },
                                              ),
                                              ListTile(
                                                title: Text('Delete'),
                                                leading: Icon(Icons.delete),
                                                onTap: () async{  
                                                  context.showLoaderOverlay();
                                                  await apiBLMDeleteComment(commentId: comments[i].commentId);
                                                  context.hideLoaderOverlay();

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
                                    },
                                    child: Row(
                                      children: [

                                        Expanded(
                                          child: Container(
                                            padding: EdgeInsets.all(10.0),
                                            child: Text(
                                              comments[i].commentBody,
                                              style: TextStyle(
                                                color: Color(0xffffffff),
                                              ),
                                            ),
                                            decoration: BoxDecoration(
                                              color: Color(0xff4EC9D4),
                                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  SizedBox(height: 5,),

                                  Row(
                                    children: [

                                      Text(timeago.format(DateTime.parse(comments[i].createdAt))),

                                      SizedBox(width: 20,),

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
                                        child: Text('Reply',),
                                      ),
                                    ],
                                  ),

                                  SizedBox(height: 20,),

                                  comments[i].listOfReplies.length != 0
                                  ? Column(
                                      children: List.generate(comments[i].listOfReplies.length, (index) => 
                                      ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        visualDensity: VisualDensity(vertical: 4.0),
                                        leading: CircleAvatar(
                                          backgroundImage: comments[i].listOfReplies[index].image != null ? NetworkImage(comments[i].listOfReplies[index].image) : AssetImage('assets/icons/app-icon.png'),
                                          backgroundColor: Color(0xff888888),
                                        ),
                                        title: Row(
                                          children: [
                                            Expanded(
                                              child: GestureDetector(
                                                onTap: (){
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMUserProfile(userId: comments[i].listOfReplies[index].userId)));
                                                },
                                                child: userId == comments[i].listOfReplies[index].userId
                                                ? Text('You',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                )
                                                : Text(comments[i].listOfReplies[index].firstName + ' ' + comments[i].listOfReplies[index].lastName,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Align(
                                                alignment: Alignment.centerRight,
                                                child: FlatButton.icon(
                                                  shape: CircleBorder(),
                                                  splashColor: Colors.transparent,
                                                  onPressed: () async{
                                                    if(repliesLikes[i][index] == true){
                                                      setState(() {
                                                        repliesLikes[i][index] = false;
                                                        repliesNumberOfLikes[i][index]--;                                                      
                                                      });

                                                      await apiBLMLikeOrUnlikeCommentReply(commentableType: 'Reply', commentableId: comments[i].listOfReplies[index].replyId, likeStatus: false);
                                                    }else{
                                                      setState(() {
                                                        repliesLikes[i][index] = true;
                                                        repliesNumberOfLikes[i][index]++;
                                                      });

                                                      await apiBLMLikeOrUnlikeCommentReply(commentableType: 'Reply', commentableId: comments[i].listOfReplies[index].replyId, likeStatus: true);
                                                    }
                                                  }, 
                                                  icon: repliesLikes[i][index] == true ? FaIcon(FontAwesomeIcons.peace, color: Colors.red,) : FaIcon(FontAwesomeIcons.peace, color: Colors.grey,),
                                                  label: Text('${repliesNumberOfLikes[i][index]}', style: TextStyle(fontSize: 16, color: Color(0xff000000),),),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        subtitle: Column(
                                          children: [
                                            GestureDetector(
                                              onLongPress: () async{
                                                print('Nice!');
                                                await showMaterialModalBottomSheet(
                                                  context: context, 
                                                  builder: (context) => 
                                                    SafeArea(
                                                    top: false,
                                                    child: Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: <Widget>[
                                                        ListTile(
                                                          title: Text('Edit'),
                                                          leading: Icon(Icons.edit),
                                                          onTap: () async{
                                                            controller.text = controller.text + comments[i].listOfReplies[index].replyBody;
                                                            await showModalBottomSheet(
                                                              context: context, 
                                                              builder: (context) => showKeyboardEdit(isEdit: false, editId: comments[i].listOfReplies[index].replyId),
                                                            );
                                                          },
                                                        ),
                                                        ListTile(
                                                          title: Text('Delete'),
                                                          leading: Icon(Icons.delete),
                                                          onTap: () async{  
                                                            context.showLoaderOverlay();
                                                            await apiBLMDeleteReply(replyId: comments[i].listOfReplies[index].replyId);
                                                            context.hideLoaderOverlay();

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
                                              },
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Container(
                                                      padding: EdgeInsets.all(10.0),
                                                      child: Text(
                                                        comments[i].listOfReplies[index].replyBody,
                                                        style: TextStyle(
                                                          color: Color(0xffffffff),
                                                        ),
                                                      ),
                                                      decoration: BoxDecoration(
                                                        color: Color(0xff4EC9D4),
                                                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            SizedBox(height: 5,),

                                            Row(
                                              children: [
                                                Text(timeago.format(DateTime.parse(comments[i].listOfReplies[index].createdAt))),

                                                SizedBox(width: 40,),

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
                                                  child: Text('Reply',),
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

                        SizedBox(height: (SizeConfig.screenHeight - kToolbarHeight) / 3.5,),

                        Image.asset('assets/icons/app-icon.png', height: 250, width: 250,),

                        SizedBox(height: 45,),

                        Text('Comment is empty', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xffB1B1B1),),),

                        SizedBox(height: (SizeConfig.screenHeight - 85 - kToolbarHeight) / 3.5,),
                      ],
                    ),
                  ),
                ],
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
        padding: EdgeInsets.only(left: 20.0, right: 20.0,),
        child: Row(
          children: [
            
            CircleAvatar(
              backgroundColor: Color(0xff888888), 
              backgroundImage: currentUserImage != null && currentUserImage != ''
              ? NetworkImage(currentUserImage)
              : AssetImage('assets/icons/app-icon.png'),
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
                if(isComment == true){
                  context.showLoaderOverlay();
                  await apiBLMAddComment(postId: postId, commentBody: controller.text);
                  context.hideLoaderOverlay();

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
                  context.showLoaderOverlay();
                  apiBLMAddReply(commentId: currentCommentId, replyBody: controller.text);
                  context.hideLoaderOverlay();

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

  showKeyboardEdit({bool isEdit, int editId}){ // isEdit - TRUE (COMMENT) | FALSE (REPLY)
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.only(left: 20.0, right: 20.0,),
        child: Row(
          children: [
            
            CircleAvatar(
              backgroundColor: Color(0xff888888), 
              backgroundImage: currentUserImage != null && currentUserImage != ''
              ? NetworkImage(currentUserImage)
              : AssetImage('assets/icons/app-icon.png'),
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
                if(isEdit == true){
                  context.showLoaderOverlay();
                  await apiBLMEditComment(commentId: editId, commentBody: controller.text);
                  context.hideLoaderOverlay();

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
                  context.showLoaderOverlay();
                  await apiBLMEditReply(replyId: editId, replyBody: controller.text);
                  context.hideLoaderOverlay();

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