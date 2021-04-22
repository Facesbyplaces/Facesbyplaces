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
  int userAccountType;
  List<RegularOriginalReply> listOfReplies;

  RegularOriginalComment({required this.commentId, required this.postId, required this.userId, required this.commentBody, required this.createdAt, required this.firstName, required this.lastName, required this.image, required this.commentLikes, required this.commentNumberOfLikes, required this.userAccountType, required this.listOfReplies});
}

class RegularOriginalReply{
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
  int userAccountType;

  RegularOriginalReply({required this.replyId, required this.commentId, required this.userId, required this.replyBody, required this.createdAt, required this.firstName, required this.lastName, required this.image, required this.replyLikes, required this.replyNumberOfLikes, required this.userAccountType});
}

class HomeRegularShowOriginalPostComments extends StatefulWidget{
  final int postId;
  HomeRegularShowOriginalPostComments({required this.postId});

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
              SnackBar(
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
          context.showLoaderOverlay();
          var newValue2 = await apiRegularShowListOfReplies(postId: newValue1.almCommentsList[i].showListOfCommentsCommentId, page: page2);
          context.hideLoaderOverlay();

          List<bool> newRepliesLikes = [];
          List<int> newRepliesNumberOfLikes = [];
          List<int> newReplyId = [];

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
              MiscRegularDropDownTemplate(postId: postId, likePost: likePost, likesCount: likesCount, reportType: 'Post', pageType: 'Alm'),
            ],
          ),
          backgroundColor: Color(0xffffffff),
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
                            physics: ClampingScrollPhysics(),
                            controller: scrollController,
                            slivers: <Widget>[
                              SliverToBoxAdapter(
                                child: Column(
                                  key: profileKey,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.only(left: 20.0, right: 20.0),
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
                                              backgroundColor: Color(0xff888888),
                                              backgroundImage: NetworkImage(originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageProfileImage),
                                            )
                                            : CircleAvatar(
                                              backgroundColor: Color(0xff888888),
                                              backgroundImage: AssetImage('assets/icons/app-icon.png'),
                                            )
                                          ),
                                          Expanded(
                                            child: Container(
                                              padding: EdgeInsets.only(left: 10.0),
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
                                                        child: Text(timeago.format(DateTime.parse(originalPost.data!.almPost.showOriginalPostCreatedAt)),
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
                                      child: Text(originalPost.data!.almPost.showOriginalPostBody),
                                    ),

                                    originalPost.data!.almPost.showOriginalPostImagesOrVideos.isNotEmpty
                                    ? Column(
                                      children: [
                                        SizedBox(height: 20),

                                        Container(
                                          child: ((){
                                            if(originalPost.data!.almPost.showOriginalPostImagesOrVideos.length == 1){
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
                                                                  padding: EdgeInsets.only(right: 20.0),
                                                                  child: GestureDetector(
                                                                    onTap: (){
                                                                      Navigator.pop(context);
                                                                    },
                                                                    child: CircleAvatar(
                                                                      radius: 20,
                                                                      backgroundColor: Color(0xff000000).withOpacity(0.8),
                                                                      child: Icon(Icons.close_rounded, color: Color(0xffffffff),),
                                                                    ),
                                                                  ),
                                                                ),

                                                                SizedBox(height: 10,),

                                                                Expanded(
                                                                  child: ((){
                                                                    if(lookupMimeType(originalPost.data!.almPost.showOriginalPostImagesOrVideos[0])?.contains('video') == true){
                                                                      return BetterPlayer.network('${originalPost.data!.almPost.showOriginalPostImagesOrVideos[0]}',
                                                                        betterPlayerConfiguration: BetterPlayerConfiguration(
                                                                          aspectRatio: 1,
                                                                        ),
                                                                      );
                                                                    }else{
                                                                      return CachedNetworkImage(
                                                                        fit: BoxFit.cover,
                                                                        imageUrl: originalPost.data!.almPost.showOriginalPostImagesOrVideos[0],
                                                                        placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                                                                        errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                                      );
                                                                    }
                                                                  }()),
                                                                ),

                                                                SizedBox(height: 85,),

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
                                                      betterPlayerConfiguration: BetterPlayerConfiguration(
                                                        aspectRatio: 16 / 9,
                                                        controlsConfiguration: BetterPlayerControlsConfiguration(
                                                          showControls: false,
                                                        ),
                                                      ),
                                                    );
                                                  }else{
                                                    return CachedNetworkImage(
                                                      fit: BoxFit.cover,
                                                      imageUrl: originalPost.data!.almPost.showOriginalPostImagesOrVideos[0],
                                                      placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                                                      errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                    );
                                                  }
                                                }()),
                                              );
                                            }else if(originalPost.data!.almPost.showOriginalPostImagesOrVideos.length == 2){
                                              return StaggeredGridView.countBuilder(
                                                padding: EdgeInsets.zero,
                                                shrinkWrap: true,
                                                physics: NeverScrollableScrollPhysics(),
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
                                                                    padding: EdgeInsets.only(right: 20.0),
                                                                    child: GestureDetector(
                                                                      onTap: (){
                                                                        Navigator.pop(context);
                                                                      },
                                                                      child: CircleAvatar(
                                                                        radius: 20,
                                                                        backgroundColor: Color(0xff000000).withOpacity(0.8),
                                                                        child: Icon(Icons.close_rounded, color: Color(0xffffffff),),
                                                                      ),
                                                                    ),
                                                                  ),

                                                                  SizedBox(height: 10,),

                                                                  Expanded(
                                                                    child: CarouselSlider(
                                                                      carouselController: buttonCarouselController,
                                                                      items: List.generate(originalPost.data!.almPost.showOriginalPostImagesOrVideos.length, (next) =>
                                                                        ((){
                                                                          if(lookupMimeType(originalPost.data!.almPost.showOriginalPostImagesOrVideos[next])?.contains('video') == true){
                                                                            return BetterPlayer.network('${originalPost.data!.almPost.showOriginalPostImagesOrVideos[index]}',
                                                                              betterPlayerConfiguration: BetterPlayerConfiguration(
                                                                                autoDispose: false,
                                                                                aspectRatio: 1,
                                                                              ),
                                                                            );
                                                                          }else{
                                                                            return CachedNetworkImage(
                                                                              fit: BoxFit.cover,
                                                                              imageUrl: originalPost.data!.almPost.showOriginalPostImagesOrVideos[next],
                                                                              placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
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
                                                                        onPressed: () => buttonCarouselController.previousPage(duration: Duration(milliseconds: 300), curve: Curves.linear),
                                                                        icon: Icon(Icons.arrow_back_rounded, color: Color(0xffffffff),),
                                                                      ),

                                                                      IconButton(
                                                                        onPressed: () => buttonCarouselController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.linear),
                                                                        icon: Icon(Icons.arrow_forward_rounded, color: Color(0xffffffff),),
                                                                      ),
                                                                    ],
                                                                  ),

                                                                  SizedBox(height: 85,),

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
                                                        betterPlayerConfiguration: BetterPlayerConfiguration(
                                                          aspectRatio: 16 / 9,
                                                          controlsConfiguration: BetterPlayerControlsConfiguration(
                                                            showControls: false,
                                                          ),
                                                        ),
                                                      );
                                                    }else{
                                                      return CachedNetworkImage(
                                                        fit: BoxFit.cover,
                                                        imageUrl: originalPost.data!.almPost.showOriginalPostImagesOrVideos[index],
                                                        placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                                                        errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                      );
                                                    }
                                                  }()),
                                                ),
                                                staggeredTileBuilder: (int index) => StaggeredTile.count(2, 2),
                                                mainAxisSpacing: 4.0,
                                                crossAxisSpacing: 4.0,
                                              );
                                            }else{
                                              return StaggeredGridView.countBuilder(
                                                padding: EdgeInsets.zero,
                                                shrinkWrap: true,
                                                physics: NeverScrollableScrollPhysics(),
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
                                                                    padding: EdgeInsets.only(right: 20.0),
                                                                    child: GestureDetector(
                                                                      onTap: (){
                                                                        Navigator.pop(context);
                                                                      },
                                                                      child: CircleAvatar(
                                                                        radius: 20,
                                                                        backgroundColor: Color(0xff000000).withOpacity(0.8),
                                                                        child: Icon(Icons.close_rounded, color: Color(0xffffffff),),
                                                                      ),
                                                                    ),
                                                                  ),

                                                                  SizedBox(height: 10,),

                                                                  Expanded(
                                                                    child: CarouselSlider(
                                                                      carouselController: buttonCarouselController,
                                                                      items: List.generate(originalPost.data!.almPost.showOriginalPostImagesOrVideos.length, (next) =>
                                                                        ((){
                                                                          if(lookupMimeType(originalPost.data!.almPost.showOriginalPostImagesOrVideos[next])?.contains('video') == true){
                                                                            return BetterPlayer.network('${originalPost.data!.almPost.showOriginalPostImagesOrVideos[next]}',
                                                                              betterPlayerConfiguration: BetterPlayerConfiguration(
                                                                                autoDispose: false,
                                                                                aspectRatio: 1,
                                                                              ),
                                                                            );
                                                                          }else{
                                                                            return CachedNetworkImage(
                                                                              fit: BoxFit.cover,
                                                                              imageUrl: originalPost.data!.almPost.showOriginalPostImagesOrVideos[next],
                                                                              placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
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
                                                                        onPressed: () => buttonCarouselController.previousPage(duration: Duration(milliseconds: 300), curve: Curves.linear),
                                                                        icon: Icon(Icons.arrow_back_rounded, color: Color(0xffffffff),),
                                                                      ),

                                                                      IconButton(
                                                                        onPressed: () => buttonCarouselController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.linear),
                                                                        icon: Icon(Icons.arrow_forward_rounded, color: Color(0xffffffff),),
                                                                      ),
                                                                    ],
                                                                  ),

                                                                  SizedBox(height: 85,),

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
                                                        betterPlayerConfiguration: BetterPlayerConfiguration(
                                                          aspectRatio: 16 / 9,
                                                          controlsConfiguration: BetterPlayerControlsConfiguration(
                                                            showControls: false,
                                                          ),
                                                        ),
                                                      )
                                                      : CachedNetworkImage(
                                                        fit: BoxFit.cover,
                                                        imageUrl: originalPost.data!.almPost.showOriginalPostImagesOrVideos[index],
                                                        placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
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
                                                                  betterPlayerConfiguration: BetterPlayerConfiguration(
                                                                    aspectRatio: 16 / 9,
                                                                    controlsConfiguration: BetterPlayerControlsConfiguration(
                                                                      showControls: false,
                                                                    ),
                                                                  ),
                                                                ),

                                                                Container(color: Colors.black.withOpacity(0.5),),

                                                                Center(
                                                                  child: CircleAvatar(
                                                                    radius: 25,
                                                                    backgroundColor: Color(0xffffffff).withOpacity(.5),
                                                                    child: Text(
                                                                      '${originalPost.data!.almPost.showOriginalPostImagesOrVideos.length - 3}',
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
                                                              fit: StackFit.expand,
                                                              children: [
                                                                CachedNetworkImage(
                                                                  fit: BoxFit.cover,
                                                                  imageUrl: originalPost.data!.almPost.showOriginalPostImagesOrVideos[index],
                                                                  placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                                                                  errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                                ),

                                                                Container(color: Colors.black.withOpacity(0.5),),

                                                                Center(
                                                                  child: CircleAvatar(
                                                                    radius: 25,
                                                                    backgroundColor: Color(0xffffffff).withOpacity(.5),
                                                                    child: Text(
                                                                      '${originalPost.data!.almPost.showOriginalPostImagesOrVideos.length - 3}',
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
                                                          if(lookupMimeType(originalPost.data!.almPost.showOriginalPostImagesOrVideos[index])?.contains('video') == true){
                                                            return BetterPlayer.network('${originalPost.data!.almPost.showOriginalPostImagesOrVideos[index]}',
                                                              betterPlayerConfiguration: BetterPlayerConfiguration(
                                                                aspectRatio: 16 / 9,
                                                                controlsConfiguration: BetterPlayerControlsConfiguration(
                                                                  showControls: false,
                                                                ),
                                                              ),
                                                            );
                                                          }else{
                                                            return CachedNetworkImage(
                                                              fit: BoxFit.cover,
                                                              imageUrl: originalPost.data!.almPost.showOriginalPostImagesOrVideos[index],
                                                              placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
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

                                        SizedBox(height: 20),

                                      ],
                                    )
                                    : Container(color: Colors.red, height: 0,),

                                    originalPost.data!.almPost.showOriginalPostPostTagged.length != 0
                                    ? Column(
                                      children: [
                                        SizedBox(height: 10),

                                        Container(
                                          alignment: Alignment.centerLeft,
                                          padding: EdgeInsets.only(left: 20.0, right: 20.0),
                                          child: RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  style: TextStyle(color: Color(0xff888888)),
                                                  text: 'with '
                                                ),

                                                TextSpan(
                                                  children: List.generate(originalPost.data!.almPost.showOriginalPostPostTagged.length,
                                                    (index) => 
                                                    TextSpan(
                                                      style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xff000000)),
                                                      children: <TextSpan>[
                                                        TextSpan(
                                                          text: originalPost.data!.almPost.showOriginalPostPostTagged[index].showOriginalPostTaggedFirstName + ' ' + originalPost.data!.almPost.showOriginalPostPostTagged[index].showOriginalPostTaggedLastName,
                                                          recognizer: TapGestureRecognizer()
                                                          ..onTap = (){
                                                            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularUserProfile(userId: originalPost.data!.almPost.showOriginalPostPostTagged[index].showOriginalPostTaggedId, accountType: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPagePageCreator.showOriginalPostPageCreatorAccountType)));
                                                          }
                                                        ),

                                                        index < originalPost.data!.almPost.showOriginalPostPostTagged.length - 1
                                                        ? TextSpan(text: ', ')
                                                        : TextSpan(text: ''),
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
                                      padding: EdgeInsets.only(left: 10.0, right: 10.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [

                                          Row(
                                            children: [
                                              FaIcon(FontAwesomeIcons.heart, color: Color(0xff000000),),

                                              SizedBox(width: 10,),

                                              Text('$numberOfLikes', style: TextStyle(fontSize: 16, color: Color(0xff000000),),),

                                            ],
                                          ),

                                          SizedBox(width: 40,),

                                          Row(
                                            children: [
                                              FaIcon(FontAwesomeIcons.comment, color: Color(0xff000000),),

                                              SizedBox(width: 10,),

                                              Text('$numberOfComments', style: TextStyle(fontSize: 16, color: Color(0xff000000),),),
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
                                                          await apiRegularDeleteComment(commentId: comments[i].commentId);
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
                                                        title: Text('Report'),
                                                        leading: Icon(Icons.edit),
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
                                          visualDensity: VisualDensity(vertical: 4.0),
                                          leading: CircleAvatar(
                                            backgroundImage: NetworkImage(comments[i].image),
                                            backgroundColor: Color(0xff888888),
                                          ),
                                          title: Row(
                                            children: [
                                              Expanded(
                                                child: currentUserId == comments[i].userId && currentAccountType == comments[i].userAccountType
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
                                                    icon: commentsLikes[i] == true ? FaIcon(FontAwesomeIcons.solidHeart, color: Color(0xffE74C3C),) : FaIcon(FontAwesomeIcons.heart, color: Colors.grey,),
                                                    label: Text('${commentsNumberOfLikes[i]}', style: TextStyle(fontSize: 16, color: Color(0xff000000),),),
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
                                                                    await apiRegularDeleteReply(replyId: comments[i].listOfReplies[index].replyId);
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
                                                                  title: Text('Report'),
                                                                  leading: Icon(Icons.edit),
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
                                                      backgroundColor: Color(0xff888888),
                                                    ),
                                                    title: Row(
                                                      children: [
                                                        Expanded(
                                                          child: currentUserId == comments[i].listOfReplies[index].userId && currentAccountType == comments[i].listOfReplies[index].userAccountType
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
                                                              icon: repliesLikes[i][index] == true ? FaIcon(FontAwesomeIcons.solidHeart, color: Color(0xffE74C3C),) : FaIcon(FontAwesomeIcons.heart, color: Colors.grey,),
                                                              label: Text('${repliesNumberOfLikes[i][index]}', style: TextStyle(fontSize: 16, color: Color(0xff000000),),),
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

                                    SizedBox(height: (SizeConfig.screenHeight! - kToolbarHeight) / 3.5,),

                                    Image.asset('assets/icons/app-icon.png', height: 250, width: 250,),

                                    SizedBox(height: 45,),

                                    Text('Comment is empty', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xffB1B1B1),),),

                                    SizedBox(height: (SizeConfig.screenHeight! - 85 - kToolbarHeight) / 3.5,),
                                  ],
                                ),
                              ),

                            ],
                          ),
                        ),
                      );
                    }else if(originalPost.hasError){
                      return MiscRegularErrorMessageTemplate();
                    }else{
                      return Container(height: SizeConfig.screenHeight, child: Center(child: Container(child: SpinKitThreeBounce(color: Color(0xff000000), size: 50.0,), color: Color(0xffffffff),),),);
                    }
                  }
                ),
              ),

              isGuestLoggedIn
              ? BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: MiscRegularLoginToContinue(),
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
                  context.showLoaderOverlay();
                  await apiRegularAddComment(postId: postId, commentBody: controller.text);
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
                  apiRegularAddReply(commentId: currentCommentId, replyBody: controller.text);
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
                  context.showLoaderOverlay();
                  await apiRegularEditComment(commentId: editId, commentBody: controller.text);
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
                  await apiRegularEditReply(replyId: editId, replyBody: controller.text);
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