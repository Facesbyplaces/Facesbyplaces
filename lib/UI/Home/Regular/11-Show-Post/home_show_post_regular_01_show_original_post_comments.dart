// import 'package:facesbyplaces/API/Regular/02-Main/api_main_regular_02_show_user_information.dart';
// import 'package:facesbyplaces/API/Regular/12-Show-Post/api_show_post_regular_01_show_original_post.dart';
// import 'package:facesbyplaces/API/Regular/12-Show-Post/api_show_post_regular_02_show_post_comments.dart';
// import 'package:facesbyplaces/API/Regular/12-Show-Post/api_show_post_regular_03_show_comment_replies.dart';
// import 'package:facesbyplaces/API/Regular/12-Show-Post/api_show_post_regular_04_show_comment_or_reply_like_status.dart';
// import 'package:facesbyplaces/API/Regular/12-Show-Post/api_show_post_regular_06_add_comment.dart';
// import 'package:facesbyplaces/API/Regular/12-Show-Post/api_show_post_regular_07_add_reply.dart';
// import 'package:facesbyplaces/API/Regular/12-Show-Post/api_show_post_regular_08_comment_reply_like_or_unlike.dart';
// import 'package:facesbyplaces/API/Regular/12-Show-Post/api_show_post_regular_09_delete_comment.dart';
// import 'package:facesbyplaces/API/Regular/12-Show-Post/api_show_post_regular_10_edit_comment.dart';
// import 'package:facesbyplaces/API/Regular/12-Show-Post/api_show_post_regular_11_delete_reply.dart';
// import 'package:facesbyplaces/API/Regular/12-Show-Post/api_show_post_regular_12_edit_reply.dart';
// import 'package:facesbyplaces/UI/Home/BLM/02-View-Memorial/home_view_memorial_blm_01_managed_memorial.dart';
// import 'package:facesbyplaces/UI/Home/BLM/02-View-Memorial/home_view_memorial_blm_02_profile_memorial.dart';
// import 'package:facesbyplaces/UI/Home/Regular/02-View-Memorial/home_view_memorial_regular_01_managed_memorial.dart';
// import 'package:facesbyplaces/UI/Home/Regular/02-View-Memorial/home_view_memorial_regular_02_profile_memorial.dart';
// import 'package:facesbyplaces/UI/Home/Regular/02-View-Memorial/home_view_memorial_regular_04_maps.dart';
// import 'package:facesbyplaces/UI/Home/Regular/06-Report/home_report_regular_01_report.dart';
// import 'package:facesbyplaces/UI/Home/Regular/12-Show-User/home_show_user_regular_01_user.dart';
// import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc_03_regular_dropdown.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
// import 'package:facesbyplaces/Configurations/size_configuration.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:keyboard_attachable/keyboard_attachable.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:loader_overlay/loader_overlay.dart';
// import 'package:extended_image/extended_image.dart';
// import 'package:better_player/better_player.dart';
// import 'package:timeago/timeago.dart' as timeago;
// import 'package:flutter/services.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/gestures.dart';
// import 'package:dialog/dialog.dart';
// import 'package:mime/mime.dart';
// import 'package:misc/misc.dart';
// import 'dart:ui';

// class RegularOriginalComment{
//   final int commentId;
//   final int postId;
//   final int userId;
//   final String commentBody;
//   final String createdAt;
//   final String firstName;
//   final String lastName;
//   final dynamic image;
//   final bool commentLikes;
//   final int commentNumberOfLikes;
//   final int userAccountType;
//   final List<RegularOriginalReply> listOfReplies;
//   const RegularOriginalComment({required this.commentId, required this.postId, required this.userId, required this.commentBody, required this.createdAt, required this.firstName, required this.lastName, required this.image, required this.commentLikes, required this.commentNumberOfLikes, required this.userAccountType, required this.listOfReplies});
// }

// class RegularOriginalReply{
//   final int replyId;
//   final int commentId;
//   final int userId;
//   final String replyBody;
//   final String createdAt;
//   final String firstName;
//   final String lastName;
//   final dynamic image;
//   final bool replyLikes;
//   final int replyNumberOfLikes;
//   final int userAccountType;
//   const RegularOriginalReply({required this.replyId, required this.commentId, required this.userId, required this.replyBody, required this.createdAt, required this.firstName, required this.lastName, required this.image, required this.replyLikes, required this.replyNumberOfLikes, required this.userAccountType});
// }

// class HomeRegularShowOriginalPostComments extends StatefulWidget{
//   final int postId;
//   const HomeRegularShowOriginalPostComments({Key? key, required this.postId}) : super(key: key);

//   @override
//   HomeRegularShowOriginalPostCommentsState createState() => HomeRegularShowOriginalPostCommentsState();
// }

// class HomeRegularShowOriginalPostCommentsState extends State<HomeRegularShowOriginalPostComments>{
//   ValueNotifier<List<RegularOriginalComment>> comments = ValueNotifier<List<RegularOriginalComment>>([]);
//   ValueNotifier<List<RegularOriginalReply>> replies = ValueNotifier<List<RegularOriginalReply>>([]);
//   GlobalKey profileKey = GlobalKey<HomeRegularShowOriginalPostCommentsState>();
//   CarouselController buttonCarouselController = CarouselController();
//   TextEditingController controller = TextEditingController(text: '');
//   ValueNotifier<bool> isGuestLoggedIn = ValueNotifier<bool>(true);
//   Future<APIRegularShowOriginalPostMain>? showOriginalPost;
//   ScrollController scrollController = ScrollController();
//   ValueNotifier<int> count = ValueNotifier<int>(0);
//   List<List<int>> repliesNumberOfLikes = [];
//   List<int> commentsNumberOfLikes = [];
//   List<List<bool>> repliesLikes = [];
//   List<bool> commentsLikes = [];
//   String currentUserImage = '';
//   String pageName = '';
//   int currentAccountType = 1;
//   int currentCommentId = 1;
//   int repliesRemaining = 1;
//   int numberOfComments = 0;
//   bool pressedLike = false;
//   int numberOfReplies = 0;
//   int itemRemaining = 1;
//   bool isComment = true;
//   int numberOfLikes = 0;
//   bool likePost = false;
//   int? currentUserId;
//   int likesCount = 0;
//   int page1 = 1;
//   int page2 = 1;

//   @override
//   void initState(){
//     super.initState();
//     isGuest();
//     likesCount = numberOfLikes;
//   }

//   void isGuest() async{
//     final sharedPrefs = await SharedPreferences.getInstance();
//     bool regularSession = sharedPrefs.getBool('regular-user-session') ?? false;
//     bool blmSession = sharedPrefs.getBool('blm-user-session') ?? false;

//     if(regularSession == true || blmSession == true){
//       isGuestLoggedIn.value = false;
//     }
    
//     if(isGuestLoggedIn.value != true){
//       showOriginalPost = getOriginalPost(widget.postId);
//       getOriginalPostInformation();
//       getProfilePicture();
//       onLoading();
//       scrollController.addListener((){
//         if(scrollController.position.pixels == scrollController.position.maxScrollExtent){
//           if(itemRemaining != 0){
//             onLoading();
//           }else{
//             ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No more comments to show'), duration: Duration(seconds: 1), backgroundColor: Color(0xff4EC9D4),),);
//           }
//         }
//       });
//     }
//   }

//   Future<void> onRefresh() async{
//     onLoading();
//   }

//   void getOriginalPostInformation() async{
//     var originalPostInformation = await apiRegularShowOriginalPost(postId: widget.postId);
//     numberOfLikes = originalPostInformation.almPost.showOriginalPostNumberOfLikes;
//     numberOfComments = originalPostInformation.almPost.showOriginalPostNumberOfComments;
//     likePost = originalPostInformation.almPost.showOriginalPostLikeStatus;
//     pageName = originalPostInformation.almPost.showOriginalPostPage.showOriginalPostPageName;
//   }

//   void getProfilePicture() async{
//     var getProfilePicture = await apiRegularShowProfileInformation();
//     currentUserImage = getProfilePicture.showProfileInformationImage;
//     currentUserId = getProfilePicture.showProfileInformationUserId;
//     currentAccountType = getProfilePicture.showProfileInformationAccountType;
//   }

//   void onLoading() async{
//     if(itemRemaining != 0){
//       context.loaderOverlay.show();
//       var newValue1 = await apiRegularShowListOfComments(postId: widget.postId, page: page1);
//       itemRemaining = newValue1.almItemsRemaining;
//       count.value = count.value + newValue1.almCommentsList.length;

//       for(int i = 0; i < newValue1.almCommentsList.length; i++){
//         var commentLikeStatus = await apiRegularShowCommentOrReplyLikeStatus(commentableType: 'Comment', commentableId: newValue1.almCommentsList[i].showListOfCommentsCommentId);
//         commentsLikes.add(commentLikeStatus.showCommentOrReplyLikeStatus);
//         commentsNumberOfLikes.add(commentLikeStatus.showCommentOrReplyNumberOfLikes);

//         if(repliesRemaining != 0){
//           var newValue2 = await apiRegularShowListOfReplies(postId: newValue1.almCommentsList[i].showListOfCommentsCommentId, page: page2);

//           List<bool> newRepliesLikes = [];
//           List<int> newRepliesNumberOfLikes = [];
//           List<int> newReplyId = [];

//           for(int j = 0; j < newValue2.almRepliesList.length; j++){
//             var replyLikeStatus = await apiRegularShowCommentOrReplyLikeStatus(commentableType: 'Reply', commentableId: newValue2.almRepliesList[j].showListOfRepliesReplyId);
//             newRepliesLikes.add(replyLikeStatus.showCommentOrReplyLikeStatus);
//             newRepliesNumberOfLikes.add(replyLikeStatus.showCommentOrReplyNumberOfLikes);
//             newReplyId.add(newValue2.almRepliesList[j].showListOfRepliesReplyId);

//             replies.value.add(
//               RegularOriginalReply(
//                 replyId: newValue2.almRepliesList[j].showListOfRepliesReplyId,
//                 commentId: newValue2.almRepliesList[j].showListOfRepliesCommentId,
//                 userId: newValue2.almRepliesList[j].showListOfRepliesUser.showListRepliesUserUserId,
//                 replyBody: newValue2.almRepliesList[j].showListOfRepliesReplyBody,
//                 createdAt: newValue2.almRepliesList[j].showListOfRepliesCreatedAt,
//                 firstName: newValue2.almRepliesList[j].showListOfRepliesUser.showListRepliesUserFirstName,
//                 lastName: newValue2.almRepliesList[j].showListOfRepliesUser.showListRepliesUserLastName,
//                 replyLikes: replyLikeStatus.showCommentOrReplyLikeStatus,
//                 replyNumberOfLikes: replyLikeStatus.showCommentOrReplyNumberOfLikes,
//                 image: newValue2.almRepliesList[j].showListOfRepliesUser.showListRepliesUserImage,
//                 userAccountType: newValue2.almRepliesList[j].showListOfRepliesUser.showListOfCommentsUserAccountType,
//               ),
//             );
//           }

//           repliesLikes.add(newRepliesLikes);
//           repliesNumberOfLikes.add(newRepliesNumberOfLikes);
//           repliesRemaining = newValue2.almItemsRemaining;
//           page2++;
//         }

//         repliesRemaining = 1;
//         page2 = 1;

//         comments.value.add(
//           RegularOriginalComment(
//             commentId: newValue1.almCommentsList[i].showListOfCommentsCommentId,
//             postId: newValue1.almCommentsList[i].showListOfCommentsPostId,
//             userId: newValue1.almCommentsList[i].showListOfCommentsUser.showListOfCommentsUserId,
//             commentBody: newValue1.almCommentsList[i].showListOfCommentsCommentBody,
//             createdAt: newValue1.almCommentsList[i].showListOfCommentsCreatedAt,
//             firstName: newValue1.almCommentsList[i].showListOfCommentsUser.showListOfCommentsUserFirstName,
//             lastName: newValue1.almCommentsList[i].showListOfCommentsUser.showListOfCommentsUserLastName,
//             image: newValue1.almCommentsList[i].showListOfCommentsUser.showListOfCommentsUserImage,
//             commentLikes: commentLikeStatus.showCommentOrReplyLikeStatus,
//             commentNumberOfLikes: commentLikeStatus.showCommentOrReplyNumberOfLikes,
//             listOfReplies: replies.value,
//             userAccountType: newValue1.almCommentsList[i].showListOfCommentsUser.showListOfCommentsUserAccountType,
//           ),
//         );
//         replies.value = [];
//       }

//       if(mounted){
//         page1++;
//       }

//       context.loaderOverlay.hide();
//     }
//   }

//   Future<APIRegularShowOriginalPostMain> getOriginalPost(postId) async{
//     return await apiRegularShowOriginalPost(postId: postId);
//   }

//   @override
//   Widget build(BuildContext context){
//     SizeConfig.init(context);
//     return WillPopScope(
//       onWillPop: () async{
//         return Navigator.canPop(context);
//       },
//       child: GestureDetector(
//         onTap: (){
//           FocusNode currentFocus = FocusScope.of(context);
//           if(!currentFocus.hasPrimaryFocus){
//             currentFocus.unfocus();
//           }
//         },
//         child: ValueListenableBuilder(
//           valueListenable: isGuestLoggedIn,
//           builder: (_, bool isGuestLoggedInListener, __) => ValueListenableBuilder(
//             valueListenable: count,
//             builder: (_, int countListener, __) => ValueListenableBuilder(
//               valueListenable: comments,
//               builder: (_, List<RegularOriginalComment> commentsListener, __) => ValueListenableBuilder(
//                 valueListenable: replies,
//                 builder: (_, List<RegularOriginalReply> repliesListener, __) => Scaffold(
//                   appBar: AppBar(
//                     backgroundColor: const Color(0xff04ECFF),
//                     title: const Text('Post', style: TextStyle(fontSize: 26, fontFamily: 'NexaRegular', color: Color(0xffffffff),),),
//                     centerTitle: false,
//                     leading: IconButton(
//                       icon: const Icon(Icons.arrow_back, color: Color(0xffffffff), size: 35),
//                       onPressed: (){
//                         Navigator.pop(context, numberOfComments);
//                       },
//                     ),
//                     actions: [
//                       MiscRegularDropDownTemplate(postId: widget.postId, likePost: likePost, likesCount: likesCount, reportType: 'Post', pageType: 'Alm', pageName: pageName),
//                     ],
//                   ),
//                   backgroundColor: const Color(0xffffffff),
//                   body: Stack(
//                     children: [
//                       isGuestLoggedInListener
//                       ? const SizedBox(height: 0,)
//                       : IgnorePointer(
//                         ignoring: isGuestLoggedInListener,
//                         child: FutureBuilder<APIRegularShowOriginalPostMain>(
//                           future: showOriginalPost,
//                           builder: (context, originalPost){
//                             if(originalPost.hasData){
//                               return SafeArea(
//                                 child: FooterLayout(
//                                   footer: showKeyboard(),
//                                   child: RefreshIndicator(
//                                     onRefresh: onRefresh,
//                                     child: CustomScrollView(
//                                       physics: const ClampingScrollPhysics(),
//                                       controller: scrollController,
//                                       slivers: <Widget>[
//                                         SliverToBoxAdapter(
//                                           child: Column(
//                                             key: profileKey,
//                                             children: [
//                                               Container(
//                                                 padding: const EdgeInsets.only(left: 20.0, right: 20.0),
//                                                 height: 80,
//                                                 child: Row(
//                                                   children: [
//                                                     GestureDetector(
//                                                       child: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageProfileImage != ''
//                                                       ? CircleAvatar(
//                                                         backgroundColor: const Color(0xff888888),
//                                                         foregroundImage: NetworkImage(originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageProfileImage),
//                                                       )
//                                                       : const CircleAvatar(
//                                                         backgroundColor: Color(0xff888888),
//                                                         foregroundImage: AssetImage('assets/icons/app-icon.png'),
//                                                       ),
//                                                       onTap: () async{
//                                                         if(originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPagePageType == 'Memorial'){
//                                                           if(originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageManage == true || originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageFamOrFriends == true){
//                                                             Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularProfile(memorialId: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageId, relationship: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageRelationship, managed: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageManage, newlyCreated: false,),),);
//                                                           }else{
//                                                             Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularMemorialProfile(memorialId: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageId, pageType: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPagePageType, newJoin: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageFollower,),),);
//                                                           }
//                                                         }else{
//                                                           if(originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageManage == true || originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageFamOrFriends == true){
//                                                             Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMProfile(memorialId: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageId, relationship: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageRelationship, managed: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageManage,newlyCreated: false,),),);
//                                                           }else{
//                                                             Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMMemorialProfile(memorialId: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageId, pageType: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPagePageType, newJoin: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageFollower,),),);
//                                                           }
//                                                         }
//                                                       },
//                                                     ),

//                                                     Expanded(
//                                                       child: Padding(
//                                                         padding: const EdgeInsets.only(left: 10.0),
//                                                         child: GestureDetector(
//                                                           child: Column(
//                                                             children: [
//                                                               Expanded(
//                                                                 child: Align(
//                                                                   alignment: Alignment.bottomLeft,
//                                                                   child: Text(originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageName,
//                                                                     overflow: TextOverflow.ellipsis,
//                                                                     style: const TextStyle(fontSize: 22, fontFamily: 'NexaBold', color: Color(0xff000000),),
//                                                                   ),
//                                                                 ),
//                                                               ),

//                                                               Expanded(
//                                                                 child: Align(
//                                                                   alignment: Alignment.topLeft,
//                                                                   child: Text(timeago.format(DateTime.parse(originalPost.data!.almPost.showOriginalPostCreatedAt),),
//                                                                     maxLines: 1,
//                                                                     style: const TextStyle(fontSize: 18, fontFamily: 'NexaBold', color: Color(0xffBDC3C7),),
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                             ],
//                                                           ),
//                                                           onTap: () async{
//                                                             if(originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPagePageType == 'Memorial'){
//                                                               if(originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageManage == true || originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageFamOrFriends == true){
//                                                                 Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularProfile(memorialId: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageId, relationship: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageRelationship, managed: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageManage, newlyCreated: false,),),);
//                                                               }else{
//                                                                 Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularMemorialProfile(memorialId: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageId, pageType: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPagePageType, newJoin: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageFollower,),),);
//                                                               }
//                                                             }else{
//                                                               if(originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageManage == true || originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageFamOrFriends == true){
//                                                                 Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMProfile(memorialId: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageId, relationship: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageRelationship, managed: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageManage, newlyCreated: false,),),);
//                                                               }else{
//                                                                 Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMMemorialProfile(memorialId: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageId, pageType: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPagePageType, newJoin: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageFollower,),));
//                                                               }
//                                                             }
//                                                           },
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),

//                                               Container(
//                                                 padding: const EdgeInsets.only(left: 20.0, right: 20.0),
//                                                 alignment: Alignment.centerLeft,
//                                                 child: Text(originalPost.data!.almPost.showOriginalPostBody, style: const TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xff000000),),),
//                                               ),

//                                               originalPost.data!.almPost.showOriginalPostImagesOrVideos.isNotEmpty
//                                               ? Column(
//                                                 children: [
//                                                   const SizedBox(height: 20),

//                                                   SizedBox(
//                                                     child: ((){
//                                                       if(originalPost.data!.almPost.showOriginalPostImagesOrVideos.length == 1){
//                                                         return GestureDetector(
//                                                           onTap: (){
//                                                             showGeneralDialog(
//                                                               context: context,
//                                                               transitionDuration: const Duration(milliseconds: 0),
//                                                               barrierDismissible: true,
//                                                               barrierLabel: 'Dialog',
//                                                               pageBuilder: (_, __, ___){
//                                                                 return Scaffold(
//                                                                   backgroundColor: Colors.black12.withOpacity(0.7),
//                                                                   body: SizedBox.expand(
//                                                                     child: SafeArea(
//                                                                       child: Column(
//                                                                         children: [
//                                                                           Container(
//                                                                             alignment: Alignment.centerRight,
//                                                                             padding: const EdgeInsets.only(right: 20.0),
//                                                                             child: GestureDetector(
//                                                                               child: CircleAvatar(radius: 20, backgroundColor: const Color(0xff000000).withOpacity(0.8), child: const Icon(Icons.close_rounded, color: Color(0xffffffff),),),
//                                                                               onTap: (){
//                                                                                 Navigator.pop(context);
//                                                                               },
//                                                                             ),
//                                                                           ),

//                                                                           const SizedBox(height: 10,),

//                                                                           Expanded(
//                                                                             child: ((){
//                                                                               if(lookupMimeType(originalPost.data!.almPost.showOriginalPostImagesOrVideos[0])?.contains('video') == true){
//                                                                                 return BetterPlayer.network('${originalPost.data!.almPost.showOriginalPostImagesOrVideos[0]}',
//                                                                                   betterPlayerConfiguration: BetterPlayerConfiguration(
//                                                                                     placeholder: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 16 / 9),
//                                                                                     placeholderOnTop: false,
//                                                                                     deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
//                                                                                     aspectRatio: 16 / 9,
//                                                                                     fit: BoxFit.contain,
//                                                                                   ),
//                                                                                 );
//                                                                               }else{
//                                                                                 return ExtendedImage.network(
//                                                                                   originalPost.data!.almPost.showOriginalPostImagesOrVideos[0],
//                                                                                   fit: BoxFit.contain,
//                                                                                   loadStateChanged: (ExtendedImageState loading){
//                                                                                     if(loading.extendedImageLoadState == LoadState.loading || loading.extendedImageLoadState == LoadState.failed){
//                                                                                       return Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,);
//                                                                                     }
//                                                                                   },
//                                                                                   mode: ExtendedImageMode.gesture,
//                                                                                 );
//                                                                               }
//                                                                             }()),
//                                                                           ),

//                                                                           const SizedBox(height: 85,),
//                                                                         ],
//                                                                       ),
//                                                                     ),
//                                                                   ),
//                                                                 );
//                                                               },
//                                                             );
//                                                           },
//                                                           child: ((){
//                                                             if(lookupMimeType(originalPost.data!.almPost.showOriginalPostImagesOrVideos[0])?.contains('video') == true){
//                                                               return BetterPlayer.network('${originalPost.data!.almPost.showOriginalPostImagesOrVideos[0]}',
//                                                                 betterPlayerConfiguration: BetterPlayerConfiguration(
//                                                                   placeholder: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 16 / 9),
//                                                                   aspectRatio: 16 / 9,
//                                                                   fit: BoxFit.contain,
//                                                                   controlsConfiguration: const BetterPlayerControlsConfiguration(showControls: false,),
//                                                                 ),
//                                                               );
//                                                             }else{
//                                                               return CachedNetworkImage(
//                                                                 fit: BoxFit.cover,
//                                                                 imageUrl: originalPost.data!.almPost.showOriginalPostImagesOrVideos[0],
//                                                                 placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
//                                                                 errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
//                                                               );
//                                                             }
//                                                           }()),
//                                                         );
//                                                       }else if(originalPost.data!.almPost.showOriginalPostImagesOrVideos.length == 2){
//                                                         return StaggeredGridView.countBuilder(
//                                                           staggeredTileBuilder: (int index) => const StaggeredTile.count(2, 2),
//                                                           physics: const NeverScrollableScrollPhysics(),
//                                                           padding: EdgeInsets.zero,
//                                                           crossAxisSpacing: 4.0,
//                                                           mainAxisSpacing: 4.0,
//                                                           crossAxisCount: 4,
//                                                           shrinkWrap: true,
//                                                           itemCount: 2,
//                                                           itemBuilder: (BuildContext context, int index) => GestureDetector(
//                                                             child: ((){
//                                                               if(lookupMimeType(originalPost.data!.almPost.showOriginalPostImagesOrVideos[index])?.contains('video') == true){
//                                                                 return BetterPlayer.network('${originalPost.data!.almPost.showOriginalPostImagesOrVideos[index]}',
//                                                                   betterPlayerConfiguration: BetterPlayerConfiguration(
//                                                                     placeholder: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 16 / 9),
//                                                                     controlsConfiguration: const BetterPlayerControlsConfiguration(showControls: false,),
//                                                                     aspectRatio: 16 / 9,
//                                                                     fit: BoxFit.contain,
//                                                                   ),
//                                                                 );
//                                                               }else{
//                                                                 return CachedNetworkImage(
//                                                                   fit: BoxFit.cover,
//                                                                   imageUrl: originalPost.data!.almPost.showOriginalPostImagesOrVideos[index],
//                                                                   placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
//                                                                   errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
//                                                                 );
//                                                               }
//                                                             }()),
//                                                             onTap: (){
//                                                               showGeneralDialog(
//                                                                 context: context,
//                                                                 transitionDuration: const Duration(milliseconds: 0),
//                                                                 barrierDismissible: true,
//                                                                 barrierLabel: 'Dialog',
//                                                                 pageBuilder: (_, __, ___){
//                                                                   return Scaffold(
//                                                                     backgroundColor: Colors.black12.withOpacity(0.7),
//                                                                     body: SizedBox.expand(
//                                                                       child: SafeArea(
//                                                                         child: Column(
//                                                                           children: [
//                                                                             Container(
//                                                                               alignment: Alignment.centerRight,
//                                                                               padding: const EdgeInsets.only(right: 20.0),
//                                                                               child: GestureDetector(
//                                                                                 child: CircleAvatar(radius: 20, backgroundColor: const Color(0xff000000).withOpacity(0.8), child: const Icon(Icons.close_rounded, color: Color(0xffffffff),),),
//                                                                                 onTap: (){
//                                                                                   Navigator.pop(context);
//                                                                                 },
//                                                                               ),
//                                                                             ),

//                                                                             const SizedBox(height: 10,),

//                                                                             Expanded(
//                                                                               child: CarouselSlider(
//                                                                                 carouselController: buttonCarouselController,
//                                                                                 items: List.generate(
//                                                                                   originalPost.data!.almPost.showOriginalPostImagesOrVideos.length, (next) => ((){
//                                                                                     if(lookupMimeType(originalPost.data!.almPost.showOriginalPostImagesOrVideos[next])?.contains('video') == true){
//                                                                                       return BetterPlayer.network('${originalPost.data!.almPost.showOriginalPostImagesOrVideos[index]}',
//                                                                                         betterPlayerConfiguration: BetterPlayerConfiguration(
//                                                                                           placeholder: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 16 / 9),
//                                                                                           deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
//                                                                                           autoDispose: false,
//                                                                                           aspectRatio: 16 / 9,
//                                                                                           fit: BoxFit.contain,
//                                                                                         ),
//                                                                                       );
//                                                                                     }else{
//                                                                                       return ExtendedImage.network(
//                                                                                         originalPost.data!.almPost.showOriginalPostImagesOrVideos[next],
//                                                                                         fit: BoxFit.contain,
//                                                                                         loadStateChanged: (ExtendedImageState loading){
//                                                                                           if(loading.extendedImageLoadState == LoadState.loading || loading.extendedImageLoadState == LoadState.failed){
//                                                                                             return Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,);
//                                                                                           }
//                                                                                         },
//                                                                                         mode: ExtendedImageMode.gesture,
//                                                                                       );
//                                                                                     }
//                                                                                   }()),
//                                                                                 ),
//                                                                                 options: CarouselOptions(
//                                                                                   autoPlay: false,
//                                                                                   enlargeCenterPage: true,
//                                                                                   aspectRatio: 1,
//                                                                                   viewportFraction: 1,
//                                                                                   initialPage: index,
//                                                                                 ),
//                                                                               ),
//                                                                             ),

//                                                                             Row(
//                                                                               mainAxisAlignment: MainAxisAlignment.center,
//                                                                               children: [
//                                                                                 IconButton(
//                                                                                   onPressed: () => buttonCarouselController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.linear),
//                                                                                   icon: const Icon(Icons.arrow_back_rounded, color: Color(0xffffffff),),
//                                                                                 ),
//                                                                                 IconButton(
//                                                                                   onPressed: () => buttonCarouselController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.linear),
//                                                                                   icon: const Icon(Icons.arrow_forward_rounded, color: Color(0xffffffff),),
//                                                                                 ),
//                                                                               ],
//                                                                             ),

//                                                                             const SizedBox(height: 85,),
//                                                                           ],
//                                                                         ),
//                                                                       ),
//                                                                     ),
//                                                                   );
//                                                                 },
//                                                               );
//                                                             },
//                                                           ),
//                                                         );
//                                                       }else{
//                                                         return StaggeredGridView.countBuilder(
//                                                           staggeredTileBuilder: (int index) => StaggeredTile.count(2, index.isEven ? 1 : 2),
//                                                           physics: const NeverScrollableScrollPhysics(),
//                                                           padding: EdgeInsets.zero,
//                                                           crossAxisSpacing: 4.0,
//                                                           mainAxisSpacing: 4.0,
//                                                           crossAxisCount: 4,
//                                                           shrinkWrap: true,
//                                                           itemCount: 3,
//                                                           itemBuilder: (BuildContext context, int index) => GestureDetector(
//                                                             child: ((){
//                                                               if(index != 1){
//                                                                 return lookupMimeType(originalPost.data!.almPost.showOriginalPostImagesOrVideos[index])?.contains('video') == true 
//                                                                 ? BetterPlayer.network('${originalPost.data!.almPost.showOriginalPostImagesOrVideos[index]}',
//                                                                   betterPlayerConfiguration: BetterPlayerConfiguration(
//                                                                     placeholder: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 16 / 9),
//                                                                     controlsConfiguration: const BetterPlayerControlsConfiguration(showControls: false,),
//                                                                     aspectRatio: 16 / 9,
//                                                                     fit: BoxFit.contain,
//                                                                   ),
//                                                                 )
//                                                                 : CachedNetworkImage(
//                                                                   fit: BoxFit.cover,
//                                                                   imageUrl: originalPost.data!.almPost.showOriginalPostImagesOrVideos[index],
//                                                                   placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
//                                                                   errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
//                                                                 );
//                                                               }else{
//                                                                 return ((){
//                                                                   if(originalPost.data!.almPost.showOriginalPostImagesOrVideos.length - 3 > 0){
//                                                                     if(lookupMimeType(originalPost.data!.almPost.showOriginalPostImagesOrVideos[index])?.contains('video') == true){
//                                                                       return Stack(
//                                                                         fit: StackFit.expand,
//                                                                         children: [
//                                                                           BetterPlayer.network('${originalPost.data!.almPost.showOriginalPostImagesOrVideos[index]}',
//                                                                             betterPlayerConfiguration: BetterPlayerConfiguration(
//                                                                               placeholder: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 16 / 9),
//                                                                               controlsConfiguration: const BetterPlayerControlsConfiguration(showControls: false,),
//                                                                               aspectRatio: 16 / 9,
//                                                                               fit: BoxFit.contain,
//                                                                             ),
//                                                                           ),

//                                                                           Container(color: const Color(0xff000000).withOpacity(0.5),),

//                                                                           Center(
//                                                                             child: CircleAvatar(
//                                                                               radius: 25,
//                                                                               backgroundColor: const Color(0xffffffff).withOpacity(.5),
//                                                                               child: Text('${originalPost.data!.almPost.showOriginalPostImagesOrVideos.length - 3}', style: const TextStyle(fontSize: 32, fontFamily: 'NexaBold', color: Color(0xffFFFFFF),),),
//                                                                             ),
//                                                                           ),
//                                                                         ],
//                                                                       );
//                                                                     }else{
//                                                                       return Stack(
//                                                                         fit: StackFit.expand,
//                                                                         children: [
//                                                                           CachedNetworkImage(
//                                                                             fit: BoxFit.cover,
//                                                                             imageUrl: originalPost.data!.almPost.showOriginalPostImagesOrVideos[index],
//                                                                             placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
//                                                                             errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
//                                                                           ),

//                                                                           Container(color: const Color(0xff000000).withOpacity(0.5),),

//                                                                           Center(
//                                                                             child: CircleAvatar(
//                                                                               radius: 25,
//                                                                               backgroundColor: const Color(0xffffffff).withOpacity(.5),
//                                                                               child: Text('${originalPost.data!.almPost.showOriginalPostImagesOrVideos.length - 3}', style: const TextStyle(fontSize: 32, fontFamily: 'NexaBold', color: Color(0xffFFFFFF),),),
//                                                                             ),
//                                                                           ),
//                                                                         ],
//                                                                       );
//                                                                     }
//                                                                   }else{
//                                                                     if(lookupMimeType(originalPost.data!.almPost.showOriginalPostImagesOrVideos[index])?.contains('video') == true){
//                                                                       return BetterPlayer.network('${originalPost.data!.almPost.showOriginalPostImagesOrVideos[index]}',
//                                                                         betterPlayerConfiguration: BetterPlayerConfiguration(
//                                                                           placeholder: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 16 / 9),
//                                                                           controlsConfiguration: const BetterPlayerControlsConfiguration(showControls: false,),
//                                                                           aspectRatio: 16 / 9,
//                                                                           fit: BoxFit.contain,
//                                                                         ),
//                                                                       );
//                                                                     }else{
//                                                                       return CachedNetworkImage(
//                                                                         fit: BoxFit.cover,
//                                                                         imageUrl: originalPost.data!.almPost.showOriginalPostImagesOrVideos[index],
//                                                                         placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
//                                                                         errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
//                                                                       );
//                                                                     }
//                                                                   }
//                                                                 }());
//                                                               }
//                                                             }()),
//                                                             onTap: (){
//                                                               showGeneralDialog(
//                                                                 context: context,
//                                                                 transitionDuration: const Duration(milliseconds: 0),
//                                                                 barrierDismissible: true,
//                                                                 barrierLabel: 'Dialog',
//                                                                 pageBuilder: (_, __, ___){
//                                                                   return Scaffold(
//                                                                     backgroundColor: Colors.black12.withOpacity(0.7),
//                                                                     body: SizedBox.expand(
//                                                                       child: SafeArea(
//                                                                         child: Column(
//                                                                           children: [
//                                                                             Container(
//                                                                               alignment: Alignment.centerRight,
//                                                                               padding: const EdgeInsets.only(right: 20.0),
//                                                                               child: GestureDetector(
//                                                                                 child: CircleAvatar(radius: 20, backgroundColor: const Color(0xff000000).withOpacity(0.8), child: const Icon(Icons.close_rounded, color: Color(0xffffffff),),),
//                                                                                 onTap: (){
//                                                                                   Navigator.pop(context);
//                                                                                 },
//                                                                               ),
//                                                                             ),
                                                                            
//                                                                             const SizedBox(height: 10,),

//                                                                             Expanded(
//                                                                               child: CarouselSlider(
//                                                                                 carouselController: buttonCarouselController,
//                                                                                 items: List.generate(
//                                                                                   originalPost.data!.almPost.showOriginalPostImagesOrVideos.length, (next) => ((){
//                                                                                     if(lookupMimeType(originalPost.data!.almPost.showOriginalPostImagesOrVideos[next])?.contains('video') == true){
//                                                                                       return BetterPlayer.network('${originalPost.data!.almPost.showOriginalPostImagesOrVideos[next]}',
//                                                                                         betterPlayerConfiguration: BetterPlayerConfiguration(
//                                                                                           placeholder: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 16 / 9),
//                                                                                           deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
//                                                                                           autoDispose: false,
//                                                                                           aspectRatio: 16 / 9,
//                                                                                           fit: BoxFit.contain,
//                                                                                         ),
//                                                                                       );
//                                                                                     }else{
//                                                                                       return ExtendedImage.network(
//                                                                                         originalPost.data!.almPost.showOriginalPostImagesOrVideos[next],
//                                                                                         fit: BoxFit.contain,
//                                                                                         loadStateChanged: (ExtendedImageState loading){
//                                                                                           if(loading.extendedImageLoadState == LoadState.loading || loading.extendedImageLoadState == LoadState.failed){
//                                                                                             return Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,);
//                                                                                           }
//                                                                                         },
//                                                                                         mode: ExtendedImageMode.gesture,
//                                                                                       );
//                                                                                     }
//                                                                                   }()),
//                                                                                 ),
//                                                                                 options: CarouselOptions(
//                                                                                   autoPlay: false,
//                                                                                   enlargeCenterPage: true,
//                                                                                   aspectRatio: 1,
//                                                                                   viewportFraction: 1,
//                                                                                   initialPage: index,
//                                                                                 ),
//                                                                               ),
//                                                                             ),

//                                                                             Row(
//                                                                               mainAxisAlignment: MainAxisAlignment.center,
//                                                                               children: [
//                                                                                 IconButton(
//                                                                                   onPressed: () => buttonCarouselController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.linear),
//                                                                                   icon: const Icon(Icons.arrow_back_rounded, color: Color(0xffffffff),),
//                                                                                 ),
//                                                                                 IconButton(
//                                                                                   onPressed: () => buttonCarouselController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.linear),
//                                                                                   icon: const Icon(Icons.arrow_forward_rounded, color: Color(0xffffffff),),
//                                                                                 ),
//                                                                               ],
//                                                                             ),

//                                                                             const SizedBox(height: 85,),
//                                                                           ],
//                                                                         ),
//                                                                       ),
//                                                                     ),
//                                                                   );
//                                                                 },
//                                                               );
//                                                             },
//                                                           ),
//                                                         );
//                                                       }
//                                                     }()),
//                                                   ),

//                                                   const SizedBox(height: 20),
//                                                 ],
//                                               )
//                                               : Container(color: const Color(0xffff0000), height: 0,),

//                                               originalPost.data!.almPost.showOriginalPostPostTagged.isNotEmpty
//                                               ? Column(
//                                                 children: [
//                                                   const SizedBox(height: 10),

//                                                   Container(
//                                                     alignment: Alignment.centerLeft,
//                                                     padding: const EdgeInsets.only(left: 20.0, right: 20.0),
//                                                     child: RichText(
//                                                       text: TextSpan(
//                                                         children: [
//                                                           const TextSpan(style: TextStyle(fontSize: 16, fontFamily: 'NexaRegular', color: Color(0xff888888)), text: 'with '),

//                                                           TextSpan(
//                                                             children: List.generate(
//                                                               originalPost.data!.almPost.showOriginalPostPostTagged.length, (index) => TextSpan(
//                                                                 style: const TextStyle(fontSize: 18, fontFamily: 'NexaBold', color: Color(0xff000000),),
//                                                                 children: <TextSpan>[
//                                                                   TextSpan(text: originalPost.data!.almPost.showOriginalPostPostTagged[index].showOriginalPostTaggedFirstName + ' ' + originalPost.data!.almPost.showOriginalPostPostTagged[index].showOriginalPostTaggedLastName,
//                                                                   recognizer: TapGestureRecognizer()
//                                                                     ..onTap = (){
//                                                                       Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularUserProfile(userId: originalPost.data!.almPost.showOriginalPostPostTagged[index].showOriginalPostTaggedId, accountType: originalPost.data!.almPost.showOriginalPostPostTagged[index].showOriginalPostAccountType)));
//                                                                     },
//                                                                   ),
//                                                                   index < originalPost.data!.almPost.showOriginalPostPostTagged.length - 1 ? const TextSpan(text: ', ') : const TextSpan(text: ''),
//                                                                 ],
//                                                               ),
//                                                             ),
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ],
//                                               )
//                                               : const SizedBox(height: 0,),

//                                               originalPost.data!.almPost.showOriginalPostLocation != ''
//                                               ? Column(
//                                                 children: [
//                                                   const SizedBox(height: 10,),

//                                                   Padding(
//                                                     padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                                                     child: Row(
//                                                       crossAxisAlignment: CrossAxisAlignment.center,
//                                                       children: [
//                                                         const Icon(Icons.place, color: Color(0xff888888)),

//                                                         Expanded(
//                                                           child: GestureDetector(
//                                                             child: Text(originalPost.data!.almPost.showOriginalPostLocation, style: const TextStyle(fontSize: 18, fontFamily: 'NexaBold', color: Color(0xff000000),),),
//                                                             onTap: (){
//                                                               Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularMaps(latitude: originalPost.data!.almPost.showOriginalPostLatitude, longitude: originalPost.data!.almPost.showOriginalPostLongitude, isMemorial: false, memorialName: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageName, memorialImage: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageProfileImage,)));
//                                                             },
//                                                           ),  
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   ),
//                                                 ],
//                                               )
//                                               : const SizedBox(height: 0,),

//                                               Container(
//                                                 height: 40,
//                                                 padding: const EdgeInsets.symmetric(horizontal: 10.0),
//                                                 child: Row(
//                                                   mainAxisAlignment: MainAxisAlignment.end,
//                                                   children: [
//                                                     Row(
//                                                       children: [
//                                                         likePost == true
//                                                         ? const FaIcon(FontAwesomeIcons.heart, color: Color(0xffE74C3C),)
//                                                         : const FaIcon(FontAwesomeIcons.heart, color: Color(0xff000000),),

//                                                         const SizedBox(width: 10,),

//                                                         Text('$numberOfLikes', style: const TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xffBDC3C7),),),
//                                                       ],
//                                                     ),

//                                                     const SizedBox(width: 40,),

//                                                     Row(
//                                                       children: [
//                                                         const FaIcon(FontAwesomeIcons.comment, color: Color(0xff000000),),

//                                                         const SizedBox(width: 10,),

//                                                         Text('$numberOfComments', style: const TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xffBDC3C7),),),
//                                                       ],
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),

//                                         SliverToBoxAdapter(
//                                           child: Column(
//                                             children: [
//                                               Column(
//                                                 children: List.generate(commentsListener.length, (i) => ListTile(
//                                                   visualDensity: const VisualDensity(vertical: 4.0),
//                                                   leading: commentsListener[i].image != ''
//                                                   ? CircleAvatar(
//                                                     backgroundColor: const Color(0xff888888),
//                                                     foregroundImage: NetworkImage(commentsListener[i].image),
//                                                   )
//                                                   : const CircleAvatar(
//                                                     backgroundColor: Color(0xff888888),
//                                                     foregroundImage: AssetImage('assets/icons/user-placeholder.png'),
//                                                   ),
//                                                   title: Row(
//                                                     children: [
//                                                       Expanded(
//                                                         child: currentUserId == commentsListener[i].userId && currentAccountType == commentsListener[i].userAccountType
//                                                         ? const Text('You', style: TextStyle(fontSize: 20, fontFamily: 'NexaBold', color: Color(0xff000000),),)
//                                                         : Text('${commentsListener[i].firstName} ${commentsListener[i].lastName}', style: const TextStyle(fontSize: 20, fontFamily: 'NexaBold', color: Color(0xff000000),),),
//                                                       ),

//                                                       Expanded(
//                                                         child: Align(
//                                                           alignment: Alignment.centerRight,
//                                                           child: TextButton.icon(
//                                                             onPressed: () async{
//                                                               if(commentsLikes[i] == true){
//                                                                 commentsLikes[i] = false;
//                                                                 commentsNumberOfLikes[i]--;

//                                                                 await apiRegularLikeOrUnlikeCommentReply(commentableType: 'Comment', commentableId: commentsListener[i].commentId, likeStatus: false);
//                                                               }else{
//                                                                 commentsLikes[i] = true;
//                                                                 commentsNumberOfLikes[i]++;

//                                                                 await apiRegularLikeOrUnlikeCommentReply(commentableType: 'Comment', commentableId: commentsListener[i].commentId, likeStatus: true);
//                                                               }
//                                                             },
//                                                             icon: commentsLikes[i] == true
//                                                             ? const FaIcon(FontAwesomeIcons.solidHeart, color: Color(0xffE74C3C),)
//                                                             : const FaIcon(FontAwesomeIcons.heart, color: Color(0xff888888),),
//                                                             label: Text('${commentsNumberOfLikes[i]}', style: const TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xffBDC3C7),),),
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                   subtitle: Column(
//                                                     children: [
//                                                       Row(
//                                                         children: [
//                                                           Expanded(
//                                                             child: Container(
//                                                               padding: const EdgeInsets.all(10.0),
//                                                               child: Text(commentsListener[i].commentBody, style: const TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xffFFFFFF),),),
//                                                               decoration: const BoxDecoration(color: Color(0xff4EC9D4), borderRadius: BorderRadius.all(Radius.circular(10.0)),),
//                                                             ),
//                                                           ),
//                                                         ],
//                                                       ),

//                                                       const SizedBox(height: 5,),

//                                                       Row(
//                                                         children: [
//                                                           Text(timeago.format(DateTime.parse(commentsListener[i].createdAt)), style: const TextStyle(fontSize: 18, fontFamily: 'NexaRegular', color: Color(0xff000000),),),

//                                                           const SizedBox(width: 20,),

//                                                           GestureDetector(
//                                                             child: const Text('Reply', style: TextStyle(fontSize: 18, fontFamily: 'NexaRegular', color: Color(0xff000000),),),
//                                                             onTap: () async{
//                                                               if(controller.text != ''){
//                                                                 controller.clear();
//                                                               }

//                                                               isComment = false;
//                                                               currentCommentId = commentsListener[i].commentId;

//                                                               await showModalBottomSheet(context: context, builder: (context) => showKeyboard(
//                                                                 isReply: true, 
//                                                                 toReply: commentsListener[i].commentBody, 
//                                                                 replyFrom: '${commentsListener[i].firstName}' '${commentsListener[i].lastName}')
//                                                               );
//                                                             },
//                                                           ),
//                                                         ],
//                                                       ),
                                                      
//                                                       const SizedBox(height: 20,),

//                                                       commentsListener[i].listOfReplies.isNotEmpty
//                                                       ? Column(
//                                                         children: List.generate(commentsListener[i].listOfReplies.length, (index) => ListTile(
//                                                           contentPadding: EdgeInsets.zero,
//                                                           visualDensity: const VisualDensity(vertical: 4.0),
//                                                           leading: commentsListener[i].listOfReplies[index].image != ''
//                                                           ? CircleAvatar(
//                                                             backgroundColor: const Color(0xff888888),
//                                                             foregroundImage: NetworkImage(commentsListener[i].listOfReplies[index].image),
//                                                           )
//                                                           : const CircleAvatar(
//                                                             backgroundColor: Color(0xff888888),
//                                                             foregroundImage: AssetImage('assets/icons/user-placeholder.png'),
//                                                           ),
//                                                           title: Row(
//                                                             children: [
//                                                               Expanded(
//                                                                 child: currentUserId == commentsListener[i].listOfReplies[index].userId && currentAccountType == commentsListener[i].listOfReplies[index].userAccountType
//                                                                 ? const Text('You', style: TextStyle(fontSize: 20, fontFamily: 'NexaBold', color: Color(0xff000000),),)
//                                                                 : Text(commentsListener[i].listOfReplies[index].firstName + ' ' + commentsListener[i].listOfReplies[index].lastName, style: const TextStyle(fontSize: 20, fontFamily: 'NexaBold', color: Color(0xff000000)),),
//                                                               ),

//                                                               Expanded(
//                                                                 child: Align(
//                                                                   alignment: Alignment.centerRight,
//                                                                   child: TextButton.icon(
//                                                                     onPressed: () async{
//                                                                       if(repliesLikes[i][index] == true){
//                                                                         repliesLikes[i][index] = false;
//                                                                         repliesNumberOfLikes[i][index]--;

//                                                                         await apiRegularLikeOrUnlikeCommentReply(commentableType: 'Reply', commentableId: commentsListener[i].listOfReplies[index].replyId, likeStatus: false);
//                                                                       }else{
//                                                                         repliesLikes[i][index] = true;
//                                                                         repliesNumberOfLikes[i][index]++;

//                                                                         await apiRegularLikeOrUnlikeCommentReply(commentableType: 'Reply', commentableId: commentsListener[i].listOfReplies[index].replyId, likeStatus: true);
//                                                                       }
//                                                                     },
//                                                                     icon: repliesLikes[i][index] == true
//                                                                     ? const FaIcon(FontAwesomeIcons.solidHeart, color: Color(0xffE74C3C),)
//                                                                     : const FaIcon(FontAwesomeIcons.heart, color: Color(0xff888888),),
//                                                                     label: Text('${repliesNumberOfLikes[i][index]}', style: const TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xffBDC3C7),),),
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                             ],
//                                                           ),
//                                                           subtitle: Column(
//                                                             children: [
//                                                               Row(
//                                                                 children: [
//                                                                   Expanded(
//                                                                     child: Container(
//                                                                       padding: const EdgeInsets.all(10.0),
//                                                                       child: Text(commentsListener[i].listOfReplies[index].replyBody, style: const TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xffFFFFFF),),),
//                                                                       decoration: const BoxDecoration(color: Color(0xff4EC9D4), borderRadius: BorderRadius.all(Radius.circular(10.0)),),
//                                                                     ),
//                                                                   ),
//                                                                 ],
//                                                               ),

//                                                               const SizedBox(height: 5,),

//                                                               Row(
//                                                                 children: [
//                                                                   Text(timeago.format(DateTime.parse(commentsListener[i].listOfReplies[index].createdAt),), style: const TextStyle(fontSize: 18, fontFamily: 'NexaRegular', color: Color(0xff000000),),),

//                                                                   const SizedBox(width: 40,),

//                                                                   GestureDetector(
//                                                                     child: const Text('Reply', style: TextStyle(fontSize: 18, fontFamily: 'NexaRegular', color: Color(0xff000000),),),
//                                                                     onTap: () async{
//                                                                       if(controller.text != ''){
//                                                                         controller.clear();
//                                                                       }

//                                                                       controller.text = commentsListener[i].firstName + ' ' + commentsListener[i].lastName + ' ';
//                                                                       isComment = false;
//                                                                       currentCommentId = commentsListener[i].commentId;

//                                                                       await showModalBottomSheet(context: context, builder: (context) => showKeyboard(isReply: true, toReply: commentsListener[i].listOfReplies[index].replyBody, replyFrom: '${commentsListener[i].listOfReplies[index].firstName} ${commentsListener[i].listOfReplies[index].lastName}'));
//                                                                     },
//                                                                   ),
//                                                                 ],
//                                                               ),
//                                                             ],
//                                                           ),
//                                                           onTap: (){
//                                                             Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularUserProfile(userId: commentsListener[i].listOfReplies[index].userId, accountType: currentAccountType,),),);
//                                                           },
//                                                           onLongPress: () async{
//                                                             if(currentUserId == commentsListener[i].listOfReplies[index].userId && currentAccountType == commentsListener[i].listOfReplies[index].userAccountType){
//                                                               await showMaterialModalBottomSheet(
//                                                                 context: context,
//                                                                 builder: (context) => SafeArea(
//                                                                   top: false,
//                                                                   child: Column(
//                                                                     mainAxisSize: MainAxisSize.min,
//                                                                     children: <Widget>[
//                                                                       ListTile(
//                                                                         title: const Text('Edit'),
//                                                                         leading: const Icon(Icons.edit),
//                                                                         onTap: () async{
//                                                                           controller.text = controller.text + commentsListener[i].listOfReplies[index].replyBody;
//                                                                           await showModalBottomSheet(
//                                                                             context: context,
//                                                                             builder: (context) => showKeyboardEdit(isEdit: false, editId: commentsListener[i].listOfReplies[index].replyId),
//                                                                           );
//                                                                         },
//                                                                       ),
//                                                                       ListTile(
//                                                                         title: const Text('Delete'),
//                                                                         leading: const Icon(Icons.delete),
//                                                                         onTap: () async{
//                                                                           context.loaderOverlay.show();
//                                                                           await apiRegularDeleteReply(replyId: commentsListener[i].listOfReplies[index].replyId);
//                                                                           context.loaderOverlay.hide();

//                                                                           controller.clear();
//                                                                           itemRemaining = 1;
//                                                                           repliesRemaining = 1;
//                                                                           comments.value = [];
//                                                                           replies.value = [];
//                                                                           numberOfReplies = 0;
//                                                                           page1 = 1;
//                                                                           page2 = 1;
//                                                                           count.value = 0;
//                                                                           commentsLikes = [];
//                                                                           commentsNumberOfLikes = [];
//                                                                           repliesLikes = [];
//                                                                           repliesNumberOfLikes = [];
//                                                                           isComment = true;
//                                                                           numberOfLikes = 0;
//                                                                           numberOfComments = 0;
//                                                                           getOriginalPostInformation();
//                                                                           onLoading();
//                                                                           Navigator.pop(context);
//                                                                         },
//                                                                       )
//                                                                     ],
//                                                                   ),
//                                                                 ),
//                                                               );
//                                                             }else{
//                                                               await showMaterialModalBottomSheet(
//                                                                 context: context,
//                                                                 builder: (context) => SafeArea(
//                                                                   top: false,
//                                                                   child: Column(
//                                                                     mainAxisSize: MainAxisSize.min,
//                                                                     children: <Widget>[
//                                                                       ListTile(
//                                                                         title: const Text('Report'),
//                                                                         leading: const Icon(Icons.edit),
//                                                                         onTap: (){
//                                                                           Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularReport(postId: widget.postId, reportType: 'Post')));
//                                                                         },
//                                                                       ),
//                                                                     ],
//                                                                   ),
//                                                                 ),
//                                                               );
//                                                             }
//                                                           },
//                                                         ),),
//                                                       )
//                                                       : const SizedBox(height: 0,),
//                                                     ],
//                                                   ),
//                                                   onTap: (){
//                                                     Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularUserProfile(userId: commentsListener[i].userId, accountType: commentsListener[i].userAccountType,)));
//                                                   },
//                                                   onLongPress: () async{
//                                                     if(currentUserId == commentsListener[i].userId && currentAccountType == commentsListener[i].userAccountType){
//                                                       await showMaterialModalBottomSheet(
//                                                         context: context,
//                                                         builder: (context) => SafeArea(
//                                                           top: false,
//                                                           child: Column(
//                                                             mainAxisSize: MainAxisSize.min,
//                                                             children: <Widget>[
//                                                               ListTile(
//                                                                 title: const Text('Edit'),
//                                                                 leading: const Icon(Icons.edit),
//                                                                 onTap: () async {
//                                                                   controller.text = controller.text + commentsListener[i].commentBody;
//                                                                   await showModalBottomSheet(
//                                                                     context: context,
//                                                                     builder: (context) => showKeyboardEdit(isEdit: true, editId: commentsListener[i].commentId),
//                                                                   );
//                                                                 },
//                                                               ),

//                                                               ListTile(
//                                                                 title: const Text('Delete'),
//                                                                 leading: const Icon(Icons.delete),
//                                                                 onTap: () async{
//                                                                   context.loaderOverlay.show();
//                                                                   await apiRegularDeleteComment(commentId: commentsListener[i].commentId);
//                                                                   context.loaderOverlay.hide();

//                                                                   controller.clear();
//                                                                   itemRemaining = 1;
//                                                                   repliesRemaining = 1;
//                                                                   comments.value = [];
//                                                                   replies.value = [];
//                                                                   numberOfReplies = 0;
//                                                                   page1 = 1;
//                                                                   page2 = 1;
//                                                                   count.value = 0;
//                                                                   commentsLikes = [];
//                                                                   commentsNumberOfLikes = [];
//                                                                   repliesLikes = [];
//                                                                   repliesNumberOfLikes = [];
//                                                                   isComment = true;
//                                                                   numberOfLikes = 0;
//                                                                   numberOfComments = 0;
//                                                                   getOriginalPostInformation();
//                                                                   onLoading();
//                                                                   Navigator.pop(context);
//                                                                 },
//                                                               )
//                                                             ],
//                                                           ),
//                                                         ),
//                                                       );
//                                                     }else{
//                                                       await showMaterialModalBottomSheet(
//                                                         context: context,
//                                                         builder: (context) => SafeArea(
//                                                           top: false,
//                                                           child: Column(
//                                                             mainAxisSize: MainAxisSize.min,
//                                                             children: <Widget>[
//                                                               ListTile(
//                                                                 title: const Text('Report'),
//                                                                 leading: const Icon(Icons.edit),
//                                                                 onTap: (){
//                                                                   Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularReport(postId: widget.postId, reportType: 'Post')));
//                                                                 },
//                                                               ),
//                                                             ],
//                                                           ),
//                                                         ),
//                                                       );
//                                                     }
//                                                   },
//                                                 ),
//                                               ),
//                                             )
//                                           ],
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                               );
//                             }else if(originalPost.hasError) {
//                               return const MiscErrorMessageTemplate();
//                             }else{
//                               return const SizedBox(height: 0,);
//                             }
//                           },
//                         ),
//                       ),
//                       isGuestLoggedInListener
//                       ? BackdropFilter(filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0), child: const MiscLoginToContinue(),)
//                       : const SizedBox(height: 0),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   showKeyboard({bool isReply = false, String toReply = '',  String replyFrom = ''}){
//     return SafeArea(
//       top: false,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20.0,),
//         child: isReply == true
//         ? SizedBox(
//           height: 200,
//           child: Column(
//             children: [
//               Expanded(
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: SingleChildScrollView(
//                         padding: const EdgeInsets.only(top: 10.0),
//                         physics: const ClampingScrollPhysics(),
//                         child: Align(
//                           alignment: Alignment.topLeft,
//                           child: RichText(
//                             text: TextSpan(
//                               children: <TextSpan>[
//                                 const TextSpan(text: 'Replying to ', style: TextStyle(color: Color(0xff888888,), fontSize: 24, fontFamily: 'NexaRegular',),),

//                                 TextSpan(text: '$replyFrom\n', style: const TextStyle(color: Color(0xff000000), fontSize: 24, fontFamily: 'NexaRegular', fontWeight: FontWeight.bold)),

//                                 TextSpan(text: toReply, style: const TextStyle(color: Color(0xff000000), fontSize: 24, fontFamily: 'NexaRegular',),),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),

//                     Align(
//                       alignment: Alignment.topRight,
//                       child: IconButton(
//                         icon: const Icon(Icons.close),
//                         onPressed: (){
//                           Navigator.pop(context);
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               Row(
//                 children: [
//                   currentUserImage != ''
//                   ? CircleAvatar(
//                     backgroundColor: const Color(0xff888888),
//                     foregroundImage: NetworkImage(currentUserImage),
//                   )
//                   : const CircleAvatar(
//                     backgroundColor: Color(0xff888888),
//                     foregroundImage: AssetImage('assets/icons/user-placeholder.png'),
//                   ),

//                   Expanded(
//                     child: Padding(
//                       padding: const EdgeInsets.all(10.0),
//                       child: TextFormField(
//                         controller: controller,
//                         style: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xffFFFFFF),),
//                         keyboardType: TextInputType.text,
//                         cursorColor: const Color(0xffFFFFFF),
//                         maxLines: 2,
//                         decoration: const InputDecoration(
//                           filled: true,
//                           labelText: 'Say something...',
//                           fillColor: Color(0xffBDC3C7),
//                           floatingLabelBehavior: FloatingLabelBehavior.never,
//                           labelStyle: TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xffFFFFFF),),
//                           border: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffBDC3C7),), borderRadius: BorderRadius.all(Radius.circular(10)),),
//                           focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffBDC3C7),), borderRadius: BorderRadius.all(Radius.circular(10)),),
//                         ),
//                       ),
//                     ),
//                   ),

//                   GestureDetector(
//                     child: const Text('Post', style: TextStyle(fontSize: 24, fontFamily: 'NexaBold', color: Color(0xff2F353D),),),
//                     onTap: () async{
//                       if(controller.text == ''){
//                         await showDialog(
//                           context: context,
//                           builder: (context) => CustomDialog(
//                             image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
//                             title: 'Error',
//                             description: 'Please input a comment.',
//                             okButtonColor: const Color(0xfff44336), // RED
//                             includeOkButton: true,
//                           ),
//                         );
//                       }else if(isComment == true && controller.text != ''){
//                         context.loaderOverlay.show();
//                         await apiRegularAddComment(postId: widget.postId, commentBody: controller.text);
//                         context.loaderOverlay.hide();

//                         controller.clear();
//                         itemRemaining = 1;
//                         repliesRemaining = 1;
//                         comments.value = [];
//                         replies.value = [];
//                         numberOfReplies = 0;
//                         page1 = 1;
//                         page2 = 1;
//                         count.value = 0;
//                         commentsLikes = [];
//                         commentsNumberOfLikes = [];
//                         repliesLikes = [];
//                         repliesNumberOfLikes = [];
//                         isComment = true;
//                         numberOfLikes = 0;
//                         numberOfComments = 0;
//                         getOriginalPostInformation();
//                         onLoading();
//                       }else{
//                         context.loaderOverlay.show();
//                         await apiRegularAddReply(commentId: currentCommentId, replyBody: controller.text);
//                         context.loaderOverlay.hide();

//                         controller.clear();
//                         itemRemaining = 1;
//                         repliesRemaining = 1;
//                         comments.value = [];
//                         replies.value = [];
//                         numberOfReplies = 0;
//                         page1 = 1;
//                         page2 = 1;
//                         count.value = 0;
//                         commentsLikes = [];
//                         commentsNumberOfLikes = [];
//                         repliesLikes = [];
//                         repliesNumberOfLikes = [];
//                         isComment = true;
//                         numberOfLikes = 0;
//                         numberOfComments = 0;
//                         getOriginalPostInformation();
//                         onLoading();
//                       }
//                     },
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         )
//         : Row(
//           children: [
//             currentUserImage != ''
//             ? CircleAvatar(
//               backgroundColor: const Color(0xff888888),
//               foregroundImage: NetworkImage(currentUserImage),
//             )
//             : const CircleAvatar(
//               backgroundColor: Color(0xff888888),
//               foregroundImage: AssetImage('assets/icons/user-placeholder.png'),
//             ),
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.all(10.0),
//                 child: TextFormField(
//                   controller: controller,
//                   cursorColor: const Color(0xffFFFFFF),
//                   maxLines: 2,
//                   keyboardType: TextInputType.text,
//                   style: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xffFFFFFF),),
//                   decoration: const InputDecoration(
//                     filled: true,
//                     fillColor: Color(0xffBDC3C7),
//                     labelText: 'Say something...',
//                     floatingLabelBehavior: FloatingLabelBehavior.never,
//                     labelStyle: TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xffFFFFFF),),
//                     border: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffBDC3C7),), borderRadius: BorderRadius.all(Radius.circular(10)),),
//                     focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffBDC3C7),), borderRadius: BorderRadius.all(Radius.circular(10)),),
//                   ),
//                 ),
//               ),
//             ),

//             GestureDetector(
//               child: const Text('Post', style: TextStyle(fontSize: 24, fontFamily: 'NexaBold', color: Color(0xff2F353D),),),
//               onTap: () async{
//                 if(controller.text == ''){
//                   await showDialog(
//                     context: context,
//                     builder: (context) => CustomDialog(
//                       image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
//                       title: 'Error',
//                       description: 'Please input a comment.',
//                       okButtonColor: const Color(0xfff44336), // RED
//                       includeOkButton: true,
//                     ),
//                   );
//                 }else if(isComment == true && controller.text != ''){
//                   context.loaderOverlay.show();
//                   await apiRegularAddComment(postId: widget.postId, commentBody: controller.text);
//                   context.loaderOverlay.hide();

//                   controller.clear();
//                   itemRemaining = 1;
//                   repliesRemaining = 1;
//                   comments.value = [];
//                   replies.value = [];
//                   numberOfReplies = 0;
//                   page1 = 1;
//                   page2 = 1;
//                   count.value = 0;
//                   commentsLikes = [];
//                   commentsNumberOfLikes = [];
//                   repliesLikes = [];
//                   repliesNumberOfLikes = [];
//                   isComment = true;
//                   numberOfLikes = 0;
//                   numberOfComments = 0;
//                   getOriginalPostInformation();
//                   onLoading();
//                 }else{
//                   context.loaderOverlay.show();
//                   await apiRegularAddReply(commentId: currentCommentId, replyBody: controller.text);
//                   context.loaderOverlay.hide();

//                   controller.clear();
//                   itemRemaining = 1;
//                   repliesRemaining = 1;
//                   comments.value = [];
//                   replies.value = [];
//                   numberOfReplies = 0;
//                   page1 = 1;
//                   page2 = 1;
//                   count.value = 0;
//                   commentsLikes = [];
//                   commentsNumberOfLikes = [];
//                   repliesLikes = [];
//                   repliesNumberOfLikes = [];
//                   isComment = true;
//                   numberOfLikes = 0;
//                   numberOfComments = 0;
//                   getOriginalPostInformation();
//                   onLoading();
//                 }
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   showKeyboardEdit({required bool isEdit, required int editId}){
//     // isEdit - TRUE (COMMENT) | FALSE (REPLY)
//     return SafeArea(
//       top: false,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20.0,),
//         child: Row(
//           children: [
//             currentUserImage != ''
//             ? CircleAvatar(
//               backgroundColor: const Color(0xff888888),
//               foregroundImage: NetworkImage(currentUserImage),
//             )
//             : const CircleAvatar(
//               backgroundColor: Color(0xff888888),
//               foregroundImage: AssetImage('assets/icons/user-placeholder.png'),
//             ),

//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.all(10.0),
//                 child: TextFormField(
//                   controller: controller,
//                   cursorColor: const Color(0xffFFFFFF),
//                   maxLines: 2,
//                   keyboardType: TextInputType.text,
//                   style: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xffFFFFFF),),
//                   decoration: const InputDecoration(
//                     filled: true,
//                     fillColor: Color(0xffBDC3C7),
//                     labelText: 'Say something...',
//                     floatingLabelBehavior: FloatingLabelBehavior.never,
//                     labelStyle: TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xffFFFFFF),),
//                     border: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffBDC3C7),), borderRadius: BorderRadius.all(Radius.circular(10)),),
//                     focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffBDC3C7),), borderRadius: BorderRadius.all(Radius.circular(10)),),
//                   ),
//                 ),
//               ),
//             ),

//             GestureDetector(
//               child: const Text('Post', style: TextStyle(fontSize: 24, fontFamily: 'NexaBold', color: Color(0xff2F353D),),),
//               onTap: () async{
//                 if(controller.text == ''){
//                   await showDialog(
//                     context: context,
//                     builder: (context) => CustomDialog(
//                       image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
//                       title: 'Error',
//                       description: 'Please input a comment.',
//                       okButtonColor: const Color(0xfff44336), // RED
//                       includeOkButton: true,
//                     ),
//                   );
//                 }else if(isEdit == true){
//                   context.loaderOverlay.show();
//                   await apiRegularEditComment(commentId: editId, commentBody: controller.text);
//                   context.loaderOverlay.hide();

//                   controller.clear();
//                   itemRemaining = 1;
//                   repliesRemaining = 1;
//                   comments.value = [];
//                   replies.value = [];
//                   numberOfReplies = 0;
//                   page1 = 1;
//                   page2 = 1;
//                   count.value = 0;
//                   commentsLikes = [];
//                   commentsNumberOfLikes = [];
//                   repliesLikes = [];
//                   repliesNumberOfLikes = [];
//                   isComment = true;
//                   numberOfLikes = 0;
//                   numberOfComments = 0;
//                   getOriginalPostInformation();
//                   onLoading();
//                 }else{
//                   context.loaderOverlay.show();
//                   await apiRegularEditReply(replyId: editId, replyBody: controller.text);
//                   context.loaderOverlay.hide();

//                   controller.clear();
//                   itemRemaining = 1;
//                   repliesRemaining = 1;
//                   comments.value = [];
//                   replies.value = [];
//                   numberOfReplies = 0;
//                   page1 = 1;
//                   page2 = 1;
//                   count.value = 0;
//                   commentsLikes = [];
//                   commentsNumberOfLikes = [];
//                   repliesLikes = [];
//                   repliesNumberOfLikes = [];
//                   isComment = true;
//                   numberOfLikes = 0;
//                   numberOfComments = 0;
//                   getOriginalPostInformation();
//                   onLoading();
//                 }
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// ================================================================================================================================================================================================================

// import 'package:facesbyplaces/API/Regular/02-Main/api_main_regular_02_show_user_information.dart';
// import 'package:facesbyplaces/API/Regular/12-Show-Post/api_show_post_regular_01_show_original_post.dart';
// import 'package:facesbyplaces/API/Regular/12-Show-Post/api_show_post_regular_02_show_post_comments.dart';
// import 'package:facesbyplaces/API/Regular/12-Show-Post/api_show_post_regular_03_show_comment_replies.dart';
// import 'package:facesbyplaces/API/Regular/12-Show-Post/api_show_post_regular_04_show_comment_or_reply_like_status.dart';
// import 'package:facesbyplaces/API/Regular/12-Show-Post/api_show_post_regular_06_add_comment.dart';
// import 'package:facesbyplaces/API/Regular/12-Show-Post/api_show_post_regular_07_add_reply.dart';
// import 'package:facesbyplaces/API/Regular/12-Show-Post/api_show_post_regular_08_comment_reply_like_or_unlike.dart';
// import 'package:facesbyplaces/API/Regular/12-Show-Post/api_show_post_regular_09_delete_comment.dart';
// import 'package:facesbyplaces/API/Regular/12-Show-Post/api_show_post_regular_10_edit_comment.dart';
// import 'package:facesbyplaces/API/Regular/12-Show-Post/api_show_post_regular_11_delete_reply.dart';
// import 'package:facesbyplaces/API/Regular/12-Show-Post/api_show_post_regular_12_edit_reply.dart';
// import 'package:facesbyplaces/UI/Home/BLM/02-View-Memorial/home_view_memorial_blm_01_managed_memorial.dart';
// import 'package:facesbyplaces/UI/Home/BLM/02-View-Memorial/home_view_memorial_blm_02_profile_memorial.dart';
// import 'package:facesbyplaces/UI/Home/Regular/02-View-Memorial/home_view_memorial_regular_01_managed_memorial.dart';
// import 'package:facesbyplaces/UI/Home/Regular/02-View-Memorial/home_view_memorial_regular_02_profile_memorial.dart';
// import 'package:facesbyplaces/UI/Home/Regular/02-View-Memorial/home_view_memorial_regular_04_maps.dart';
// import 'package:facesbyplaces/UI/Home/Regular/06-Report/home_report_regular_01_report.dart';
// import 'package:facesbyplaces/UI/Home/Regular/12-Show-User/home_show_user_regular_01_user.dart';
// import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc_03_regular_dropdown.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
// import 'package:facesbyplaces/Configurations/size_configuration.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:keyboard_attachable/keyboard_attachable.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:loader_overlay/loader_overlay.dart';
// import 'package:extended_image/extended_image.dart';
// import 'package:better_player/better_player.dart';
// import 'package:timeago/timeago.dart' as timeago;
// import 'package:flutter/services.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/gestures.dart';
// import 'package:dialog/dialog.dart';
// import 'package:loader/loader.dart';
// import 'package:mime/mime.dart';
// import 'package:misc/misc.dart';
// import 'dart:ui';

// class RegularOriginalComment{
//   final int commentId;
//   final int postId;
//   final int userId;
//   final String commentBody;
//   final String createdAt;
//   final String firstName;
//   final String lastName;
//   final dynamic image;
//   final bool commentLikes;
//   final int commentNumberOfLikes;
//   final int userAccountType;
//   final List<RegularOriginalReply> listOfReplies;
//   const RegularOriginalComment({required this.commentId, required this.postId, required this.userId, required this.commentBody, required this.createdAt, required this.firstName, required this.lastName, required this.image, required this.commentLikes, required this.commentNumberOfLikes, required this.userAccountType, required this.listOfReplies});
// }

// class RegularOriginalReply{
//   final int replyId;
//   final int commentId;
//   final int userId;
//   final String replyBody;
//   final String createdAt;
//   final String firstName;
//   final String lastName;
//   final dynamic image;
//   final bool replyLikes;
//   final int replyNumberOfLikes;
//   final int userAccountType;
//   const RegularOriginalReply({required this.replyId, required this.commentId, required this.userId, required this.replyBody, required this.createdAt, required this.firstName, required this.lastName, required this.image, required this.replyLikes, required this.replyNumberOfLikes, required this.userAccountType});
// }

// class HomeRegularShowOriginalPostComments extends StatefulWidget{
//   final int postId;
//   const HomeRegularShowOriginalPostComments({Key? key, required this.postId}) : super(key: key);

//   @override
//   HomeRegularShowOriginalPostCommentsState createState() => HomeRegularShowOriginalPostCommentsState();
// }

// class HomeRegularShowOriginalPostCommentsState extends State<HomeRegularShowOriginalPostComments>{
//   ValueNotifier<List<RegularOriginalComment>> comments = ValueNotifier<List<RegularOriginalComment>>([]);
//   ValueNotifier<List<RegularOriginalReply>> replies = ValueNotifier<List<RegularOriginalReply>>([]);
//   GlobalKey profileKey = GlobalKey<HomeRegularShowOriginalPostCommentsState>();
//   CarouselController buttonCarouselController = CarouselController();
//   TextEditingController controller = TextEditingController(text: '');
//   ValueNotifier<bool> isGuestLoggedIn = ValueNotifier<bool>(true);
//   Future<APIRegularShowOriginalPostMain>? showOriginalPost;
//   Future<APIRegularShowListOfComments>? showListOfComments;
//   ScrollController scrollController = ScrollController();
//   ValueNotifier<int> count = ValueNotifier<int>(0);
//   List<List<int>> repliesNumberOfLikes = [];
//   List<int> commentsNumberOfLikes = [];
//   List<List<bool>> repliesLikes = [];
//   List<bool> commentsLikes = [];
//   String currentUserImage = '';
//   String pageName = '';
//   int currentAccountType = 1;
//   int currentCommentId = 1;
//   int repliesRemaining = 1;
//   int numberOfComments = 0;
//   bool pressedLike = false;
//   int numberOfReplies = 0;
//   int itemRemaining = 1;
//   bool isComment = true;
//   int numberOfLikes = 0;
//   bool likePost = false;
//   int? currentUserId;
//   int likesCount = 0;
//   int page1 = 1;
//   int page2 = 1;

//   @override
//   void initState(){
//     super.initState();
//     isGuest();
//     likesCount = numberOfLikes;
//   }

//   void isGuest() async{
//     final sharedPrefs = await SharedPreferences.getInstance();
//     bool regularSession = sharedPrefs.getBool('regular-user-session') ?? false;
//     bool blmSession = sharedPrefs.getBool('blm-user-session') ?? false;

//     if(regularSession == true || blmSession == true){
//       isGuestLoggedIn.value = false;
//     }
    
//     if(isGuestLoggedIn.value != true){
//       showOriginalPost = getOriginalPost(widget.postId);
//       // showListOfComments = getListOfComments(postId: widget.postId, page: page1);
//       getOriginalPostInformation();
//       getProfilePicture();
//       // onLoading();
//       scrollController.addListener((){
//         if(scrollController.position.pixels == scrollController.position.maxScrollExtent){
//           if(itemRemaining != 0){
//             // onLoading();
//           }else{
//             ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No more comments to show'), duration: Duration(seconds: 1), backgroundColor: Color(0xff4EC9D4),),);
//           }
//         }
//       });
//     }
//   }

//   // Future<void> onRefresh() async{
//   //   // onLoading();
//   //   print('refreshed');
//   //   setState(() {});
//   // }

//   Future<void> onRefresh() async{
//     // onLoading();
//     print('refreshed');
//     showOriginalPost = getOriginalPost(widget.postId);
//     getListOfComments();
//     getShowCommentOrReplyLikeStatus(commentableType: 'Comment', commentId: listOfComments.data!.almCommentsList[i].showListOfCommentsCommentId),
//     setState(() {});
//   }


//   void getOriginalPostInformation() async{
//     var originalPostInformation = await apiRegularShowOriginalPost(postId: widget.postId);
//     numberOfLikes = originalPostInformation.almPost.showOriginalPostNumberOfLikes;
//     numberOfComments = originalPostInformation.almPost.showOriginalPostNumberOfComments;
//     likePost = originalPostInformation.almPost.showOriginalPostLikeStatus;
//     pageName = originalPostInformation.almPost.showOriginalPostPage.showOriginalPostPageName;
//   }

//   void getProfilePicture() async{
//     var getProfilePicture = await apiRegularShowProfileInformation();
//     currentUserImage = getProfilePicture.showProfileInformationImage;
//     currentUserId = getProfilePicture.showProfileInformationUserId;
//     currentAccountType = getProfilePicture.showProfileInformationAccountType;
//   }

//   // void onLoading() async{
//   //   if(itemRemaining != 0){
//   //     context.loaderOverlay.show();
//   //     var newValue1 = await apiRegularShowListOfComments(postId: widget.postId, page: page1);
//   //     itemRemaining = newValue1.almItemsRemaining;
//   //     count.value = count.value + newValue1.almCommentsList.length;

//   //     for(int i = 0; i < newValue1.almCommentsList.length; i++){
//   //       var commentLikeStatus = await apiRegularShowCommentOrReplyLikeStatus(commentableType: 'Comment', commentableId: newValue1.almCommentsList[i].showListOfCommentsCommentId);
//   //       commentsLikes.add(commentLikeStatus.showCommentOrReplyLikeStatus);
//   //       commentsNumberOfLikes.add(commentLikeStatus.showCommentOrReplyNumberOfLikes);

//   //       if(repliesRemaining != 0){
//   //         var newValue2 = await apiRegularShowListOfReplies(postId: newValue1.almCommentsList[i].showListOfCommentsCommentId, page: page2);

//   //         List<bool> newRepliesLikes = [];
//   //         List<int> newRepliesNumberOfLikes = [];
//   //         List<int> newReplyId = [];

//   //         for(int j = 0; j < newValue2.almRepliesList.length; j++){
//   //           var replyLikeStatus = await apiRegularShowCommentOrReplyLikeStatus(commentableType: 'Reply', commentableId: newValue2.almRepliesList[j].showListOfRepliesReplyId);
//   //           newRepliesLikes.add(replyLikeStatus.showCommentOrReplyLikeStatus);
//   //           newRepliesNumberOfLikes.add(replyLikeStatus.showCommentOrReplyNumberOfLikes);
//   //           newReplyId.add(newValue2.almRepliesList[j].showListOfRepliesReplyId);

//   //           replies.value.add(
//   //             RegularOriginalReply(
//   //               replyId: newValue2.almRepliesList[j].showListOfRepliesReplyId,
//   //               commentId: newValue2.almRepliesList[j].showListOfRepliesCommentId,
//   //               userId: newValue2.almRepliesList[j].showListOfRepliesUser.showListRepliesUserUserId,
//   //               replyBody: newValue2.almRepliesList[j].showListOfRepliesReplyBody,
//   //               createdAt: newValue2.almRepliesList[j].showListOfRepliesCreatedAt,
//   //               firstName: newValue2.almRepliesList[j].showListOfRepliesUser.showListRepliesUserFirstName,
//   //               lastName: newValue2.almRepliesList[j].showListOfRepliesUser.showListRepliesUserLastName,
//   //               replyLikes: replyLikeStatus.showCommentOrReplyLikeStatus,
//   //               replyNumberOfLikes: replyLikeStatus.showCommentOrReplyNumberOfLikes,
//   //               image: newValue2.almRepliesList[j].showListOfRepliesUser.showListRepliesUserImage,
//   //               userAccountType: newValue2.almRepliesList[j].showListOfRepliesUser.showListOfCommentsUserAccountType,
//   //             ),
//   //           );
//   //         }

//   //         repliesLikes.add(newRepliesLikes);
//   //         repliesNumberOfLikes.add(newRepliesNumberOfLikes);
//   //         repliesRemaining = newValue2.almItemsRemaining;
//   //         page2++;
//   //       }

//   //       repliesRemaining = 1;
//   //       page2 = 1;

//   //       comments.value.add(
//   //         RegularOriginalComment(
//   //           commentId: newValue1.almCommentsList[i].showListOfCommentsCommentId,
//   //           postId: newValue1.almCommentsList[i].showListOfCommentsPostId,
//   //           userId: newValue1.almCommentsList[i].showListOfCommentsUser.showListOfCommentsUserId,
//   //           commentBody: newValue1.almCommentsList[i].showListOfCommentsCommentBody,
//   //           createdAt: newValue1.almCommentsList[i].showListOfCommentsCreatedAt,
//   //           firstName: newValue1.almCommentsList[i].showListOfCommentsUser.showListOfCommentsUserFirstName,
//   //           lastName: newValue1.almCommentsList[i].showListOfCommentsUser.showListOfCommentsUserLastName,
//   //           image: newValue1.almCommentsList[i].showListOfCommentsUser.showListOfCommentsUserImage,
//   //           commentLikes: commentLikeStatus.showCommentOrReplyLikeStatus,
//   //           commentNumberOfLikes: commentLikeStatus.showCommentOrReplyNumberOfLikes,
//   //           listOfReplies: replies.value,
//   //           userAccountType: newValue1.almCommentsList[i].showListOfCommentsUser.showListOfCommentsUserAccountType,
//   //         ),
//   //       );
//   //       replies.value = [];
//   //     }

//   //     if(mounted){
//   //       page1++;
//   //     }

//   //     context.loaderOverlay.hide();
//   //   }
//   // }

//   Future<APIRegularShowOriginalPostMain> getOriginalPost(postId) async{
//     return await apiRegularShowOriginalPost(postId: postId);
//   }

//   Future<APIRegularShowListOfComments> getListOfComments() async{
//     APIRegularShowListOfComments? newValue;
//     while(itemRemaining != 0){
//       newValue = await apiRegularShowListOfComments(postId: widget.postId, page: page1);
//       page1++;
//       itemRemaining = newValue.almItemsRemaining;
//     }

//     page1 = 0;
//     return newValue!;
//   }

//   Future<APIRegularShowCommentOrReplyLikeStatus> getShowCommentOrReplyLikeStatus({required String commentableType, required int commentId}) async{
//     APIRegularShowCommentOrReplyLikeStatus? newValue;
//     newValue = await apiRegularShowCommentOrReplyLikeStatus(commentableType: commentableType, commentableId: commentId);

//     if(commentableType == 'Comment'){
//       commentsLikes.add(newValue.showCommentOrReplyLikeStatus);
//       commentsNumberOfLikes.add(newValue.showCommentOrReplyNumberOfLikes);
//     }

//     return newValue;
//   } 

//   Future<APIRegularShowListOfReplies> getListOfReplies({required int commentId}) async{
//     APIRegularShowListOfReplies? newValue;
//     while(repliesRemaining != 0){
//       newValue = await apiRegularShowListOfReplies(postId: commentId, page: page2);
//       page2++;
//       repliesRemaining = newValue.almItemsRemaining;
//     }

//     page2 = 0;
//     return newValue!;
//   }

//   @override
//   Widget build(BuildContext context){
//     SizeConfig.init(context);
//     return WillPopScope(
//       onWillPop: () async{
//         return Navigator.canPop(context);
//       },
//       child: GestureDetector(
//         onTap: (){
//           FocusNode currentFocus = FocusScope.of(context);
//           if(!currentFocus.hasPrimaryFocus){
//             currentFocus.unfocus();
//           }
//         },
//         child: ValueListenableBuilder(
//           valueListenable: isGuestLoggedIn,
//           builder: (_, bool isGuestLoggedInListener, __) => ValueListenableBuilder(
//             valueListenable: count,
//             builder: (_, int countListener, __) => ValueListenableBuilder(
//               valueListenable: comments,
//               builder: (_, List<RegularOriginalComment> commentsListener, __) => ValueListenableBuilder(
//                 valueListenable: replies,
//                 builder: (_, List<RegularOriginalReply> repliesListener, __) => Scaffold(
//                   appBar: AppBar(
//                     backgroundColor: const Color(0xff04ECFF),
//                     title: const Text('Post', style: TextStyle(fontSize: 26, fontFamily: 'NexaRegular', color: Color(0xffffffff),),),
//                     centerTitle: false,
//                     leading: IconButton(
//                       icon: const Icon(Icons.arrow_back, color: Color(0xffffffff), size: 35),
//                       onPressed: (){
//                         Navigator.pop(context, numberOfComments);
//                       },
//                     ),
//                     actions: [
//                       MiscRegularDropDownTemplate(postId: widget.postId, likePost: likePost, likesCount: likesCount, reportType: 'Post', pageType: 'Alm', pageName: pageName),
//                     ],
//                   ),
//                   backgroundColor: const Color(0xffffffff),
//                   body: Stack(
//                     children: [
//                       isGuestLoggedInListener
//                       ? const SizedBox(height: 0,)

//                                               // child: FutureBuilder<APIRegularShowOriginalPostMain>(
//                         //   future: showOriginalPost,
//                         //   builder: (context, originalPost){
//                         //     if(originalPost.connectionState != ConnectionState.done){
//                         //       return const Center(child: CustomLoader(),);
//                         //     }
//                         //     else if(originalPost.hasData){
//                         //       // return SafeArea(
//                         //       //   child: FooterLayout(
//                         //       //     footer: showKeyboard(),
//                         //       //     child: RefreshIndicator(
//                         //       //       onRefresh: onRefresh,
//                         //       //       child: 
//                         //       //     ),
//                         //       //   ),
//                         //       // );
//                         //     }else if(originalPost.hasError) {
//                         //       return const MiscErrorMessageTemplate();
//                         //     }else{
//                         //       return const SizedBox(height: 0,);
//                         //     }
//                         //   },
//                         // ),
//                       : IgnorePointer(
//                         ignoring: isGuestLoggedInListener,
//                         child: SafeArea(
//                           child: FooterLayout(
//                             footer: showKeyboard(),
//                             child: RefreshIndicator(
//                               onRefresh: onRefresh,
//                               child: FutureBuilder<APIRegularShowOriginalPostMain>(
//                                 future: showOriginalPost,
//                                 builder: (context, originalPost){
//                                   if(originalPost.connectionState != ConnectionState.done){
//                                     return const Center(child: CustomLoader(),);
//                                   }
//                                   else if(originalPost.hasError){
//                                     return const MiscErrorMessageTemplate();
//                                   }
//                                   else if(originalPost.hasData){
//                                     return CustomScrollView(
//                                       physics: const ClampingScrollPhysics(),
//                                       controller: scrollController,
//                                       slivers: <Widget>[
//                                         SliverToBoxAdapter(
//                                           child: Column(
//                                             key: profileKey,
//                                             children: [
//                                               Container(
//                                                 padding: const EdgeInsets.only(left: 20.0, right: 20.0),
//                                                 height: 80,
//                                                 child: Row(
//                                                   children: [
//                                                     GestureDetector(
//                                                       child: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageProfileImage != ''
//                                                       ? CircleAvatar(
//                                                         backgroundColor: const Color(0xff888888),
//                                                         foregroundImage: NetworkImage(originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageProfileImage),
//                                                       )
//                                                       : const CircleAvatar(
//                                                         backgroundColor: Color(0xff888888),
//                                                         foregroundImage: AssetImage('assets/icons/app-icon.png'),
//                                                       ),
//                                                       onTap: () async{
//                                                         if(originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPagePageType == 'Memorial'){
//                                                           if(originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageManage == true || originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageFamOrFriends == true){
//                                                             Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularProfile(memorialId: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageId, relationship: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageRelationship, managed: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageManage, newlyCreated: false,),),);
//                                                           }else{
//                                                             Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularMemorialProfile(memorialId: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageId, pageType: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPagePageType, newJoin: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageFollower,),),);
//                                                           }
//                                                         }else{
//                                                           if(originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageManage == true || originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageFamOrFriends == true){
//                                                             Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMProfile(memorialId: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageId, relationship: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageRelationship, managed: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageManage,newlyCreated: false,),),);
//                                                           }else{
//                                                             Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMMemorialProfile(memorialId: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageId, pageType: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPagePageType, newJoin: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageFollower,),),);
//                                                           }
//                                                         }
//                                                       },
//                                                     ),

//                                                     Expanded(
//                                                       child: Padding(
//                                                         padding: const EdgeInsets.only(left: 10.0),
//                                                         child: GestureDetector(
//                                                           child: Column(
//                                                             children: [
//                                                               Expanded(
//                                                                 child: Align(
//                                                                   alignment: Alignment.bottomLeft,
//                                                                   child: Text(originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageName,
//                                                                     overflow: TextOverflow.ellipsis,
//                                                                     style: const TextStyle(fontSize: 22, fontFamily: 'NexaBold', color: Color(0xff000000),),
//                                                                   ),
//                                                                 ),
//                                                               ),

//                                                               Expanded(
//                                                                 child: Align(
//                                                                   alignment: Alignment.topLeft,
//                                                                   child: Text(timeago.format(DateTime.parse(originalPost.data!.almPost.showOriginalPostCreatedAt),),
//                                                                     maxLines: 1,
//                                                                     style: const TextStyle(fontSize: 18, fontFamily: 'NexaBold', color: Color(0xffBDC3C7),),
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                             ],
//                                                           ),
//                                                           onTap: () async{
//                                                             if(originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPagePageType == 'Memorial'){
//                                                               if(originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageManage == true || originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageFamOrFriends == true){
//                                                                 Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularProfile(memorialId: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageId, relationship: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageRelationship, managed: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageManage, newlyCreated: false,),),);
//                                                               }else{
//                                                                 Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularMemorialProfile(memorialId: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageId, pageType: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPagePageType, newJoin: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageFollower,),),);
//                                                               }
//                                                             }else{
//                                                               if(originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageManage == true || originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageFamOrFriends == true){
//                                                                 Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMProfile(memorialId: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageId, relationship: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageRelationship, managed: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageManage, newlyCreated: false,),),);
//                                                               }else{
//                                                                 Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMMemorialProfile(memorialId: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageId, pageType: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPagePageType, newJoin: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageFollower,),));
//                                                               }
//                                                             }
//                                                           },
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),

//                                               Container(
//                                                 padding: const EdgeInsets.only(left: 20.0, right: 20.0),
//                                                 alignment: Alignment.centerLeft,
//                                                 child: Text(originalPost.data!.almPost.showOriginalPostBody, style: const TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xff000000),),),
//                                               ),

//                                               originalPost.data!.almPost.showOriginalPostImagesOrVideos.isNotEmpty
//                                               ? Column(
//                                                 children: [
//                                                   const SizedBox(height: 20),

//                                                   SizedBox(
//                                                     child: ((){
//                                                       if(originalPost.data!.almPost.showOriginalPostImagesOrVideos.length == 1){
//                                                         return GestureDetector(
//                                                           onTap: (){
//                                                             showGeneralDialog(
//                                                               context: context,
//                                                               transitionDuration: const Duration(milliseconds: 0),
//                                                               barrierDismissible: true,
//                                                               barrierLabel: 'Dialog',
//                                                               pageBuilder: (_, __, ___){
//                                                                 return Scaffold(
//                                                                   backgroundColor: Colors.black12.withOpacity(0.7),
//                                                                   body: SizedBox.expand(
//                                                                     child: SafeArea(
//                                                                       child: Column(
//                                                                         children: [
//                                                                           Container(
//                                                                             alignment: Alignment.centerRight,
//                                                                             padding: const EdgeInsets.only(right: 20.0),
//                                                                             child: GestureDetector(
//                                                                               child: CircleAvatar(radius: 20, backgroundColor: const Color(0xff000000).withOpacity(0.8), child: const Icon(Icons.close_rounded, color: Color(0xffffffff),),),
//                                                                               onTap: (){
//                                                                                 Navigator.pop(context);
//                                                                               },
//                                                                             ),
//                                                                           ),

//                                                                           const SizedBox(height: 10,),

//                                                                           Expanded(
//                                                                             child: ((){
//                                                                               if(lookupMimeType(originalPost.data!.almPost.showOriginalPostImagesOrVideos[0])?.contains('video') == true){
//                                                                                 return BetterPlayer.network('${originalPost.data!.almPost.showOriginalPostImagesOrVideos[0]}',
//                                                                                   betterPlayerConfiguration: BetterPlayerConfiguration(
//                                                                                     placeholder: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 16 / 9),
//                                                                                     placeholderOnTop: false,
//                                                                                     deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
//                                                                                     aspectRatio: 16 / 9,
//                                                                                     fit: BoxFit.contain,
//                                                                                   ),
//                                                                                 );
//                                                                               }else{
//                                                                                 return ExtendedImage.network(
//                                                                                   originalPost.data!.almPost.showOriginalPostImagesOrVideos[0],
//                                                                                   fit: BoxFit.contain,
//                                                                                   loadStateChanged: (ExtendedImageState loading){
//                                                                                     if(loading.extendedImageLoadState == LoadState.loading || loading.extendedImageLoadState == LoadState.failed){
//                                                                                       return Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,);
//                                                                                     }
//                                                                                   },
//                                                                                   mode: ExtendedImageMode.gesture,
//                                                                                 );
//                                                                               }
//                                                                             }()),
//                                                                           ),

//                                                                           const SizedBox(height: 85,),
//                                                                         ],
//                                                                       ),
//                                                                     ),
//                                                                   ),
//                                                                 );
//                                                               },
//                                                             );
//                                                           },
//                                                           child: ((){
//                                                             if(lookupMimeType(originalPost.data!.almPost.showOriginalPostImagesOrVideos[0])?.contains('video') == true){
//                                                               return BetterPlayer.network('${originalPost.data!.almPost.showOriginalPostImagesOrVideos[0]}',
//                                                                 betterPlayerConfiguration: BetterPlayerConfiguration(
//                                                                   placeholder: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 16 / 9),
//                                                                   aspectRatio: 16 / 9,
//                                                                   fit: BoxFit.contain,
//                                                                   controlsConfiguration: const BetterPlayerControlsConfiguration(showControls: false,),
//                                                                 ),
//                                                               );
//                                                             }else{
//                                                               return CachedNetworkImage(
//                                                                 fit: BoxFit.cover,
//                                                                 imageUrl: originalPost.data!.almPost.showOriginalPostImagesOrVideos[0],
//                                                                 placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
//                                                                 errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
//                                                               );
//                                                             }
//                                                           }()),
//                                                         );
//                                                       }else if(originalPost.data!.almPost.showOriginalPostImagesOrVideos.length == 2){
//                                                         return StaggeredGridView.countBuilder(
//                                                           staggeredTileBuilder: (int index) => const StaggeredTile.count(2, 2),
//                                                           physics: const NeverScrollableScrollPhysics(),
//                                                           padding: EdgeInsets.zero,
//                                                           crossAxisSpacing: 4.0,
//                                                           mainAxisSpacing: 4.0,
//                                                           crossAxisCount: 4,
//                                                           shrinkWrap: true,
//                                                           itemCount: 2,
//                                                           itemBuilder: (BuildContext context, int index) => GestureDetector(
//                                                             child: ((){
//                                                               if(lookupMimeType(originalPost.data!.almPost.showOriginalPostImagesOrVideos[index])?.contains('video') == true){
//                                                                 return BetterPlayer.network('${originalPost.data!.almPost.showOriginalPostImagesOrVideos[index]}',
//                                                                   betterPlayerConfiguration: BetterPlayerConfiguration(
//                                                                     placeholder: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 16 / 9),
//                                                                     controlsConfiguration: const BetterPlayerControlsConfiguration(showControls: false,),
//                                                                     aspectRatio: 16 / 9,
//                                                                     fit: BoxFit.contain,
//                                                                   ),
//                                                                 );
//                                                               }else{
//                                                                 return CachedNetworkImage(
//                                                                   fit: BoxFit.cover,
//                                                                   imageUrl: originalPost.data!.almPost.showOriginalPostImagesOrVideos[index],
//                                                                   placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
//                                                                   errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
//                                                                 );
//                                                               }
//                                                             }()),
//                                                             onTap: (){
//                                                               showGeneralDialog(
//                                                                 context: context,
//                                                                 transitionDuration: const Duration(milliseconds: 0),
//                                                                 barrierDismissible: true,
//                                                                 barrierLabel: 'Dialog',
//                                                                 pageBuilder: (_, __, ___){
//                                                                   return Scaffold(
//                                                                     backgroundColor: Colors.black12.withOpacity(0.7),
//                                                                     body: SizedBox.expand(
//                                                                       child: SafeArea(
//                                                                         child: Column(
//                                                                           children: [
//                                                                             Container(
//                                                                               alignment: Alignment.centerRight,
//                                                                               padding: const EdgeInsets.only(right: 20.0),
//                                                                               child: GestureDetector(
//                                                                                 child: CircleAvatar(radius: 20, backgroundColor: const Color(0xff000000).withOpacity(0.8), child: const Icon(Icons.close_rounded, color: Color(0xffffffff),),),
//                                                                                 onTap: (){
//                                                                                   Navigator.pop(context);
//                                                                                 },
//                                                                               ),
//                                                                             ),

//                                                                             const SizedBox(height: 10,),

//                                                                             Expanded(
//                                                                               child: CarouselSlider(
//                                                                                 carouselController: buttonCarouselController,
//                                                                                 items: List.generate(
//                                                                                   originalPost.data!.almPost.showOriginalPostImagesOrVideos.length, (next) => ((){
//                                                                                     if(lookupMimeType(originalPost.data!.almPost.showOriginalPostImagesOrVideos[next])?.contains('video') == true){
//                                                                                       return BetterPlayer.network('${originalPost.data!.almPost.showOriginalPostImagesOrVideos[index]}',
//                                                                                         betterPlayerConfiguration: BetterPlayerConfiguration(
//                                                                                           placeholder: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 16 / 9),
//                                                                                           deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
//                                                                                           autoDispose: false,
//                                                                                           aspectRatio: 16 / 9,
//                                                                                           fit: BoxFit.contain,
//                                                                                         ),
//                                                                                       );
//                                                                                     }else{
//                                                                                       return ExtendedImage.network(
//                                                                                         originalPost.data!.almPost.showOriginalPostImagesOrVideos[next],
//                                                                                         fit: BoxFit.contain,
//                                                                                         loadStateChanged: (ExtendedImageState loading){
//                                                                                           if(loading.extendedImageLoadState == LoadState.loading || loading.extendedImageLoadState == LoadState.failed){
//                                                                                             return Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,);
//                                                                                           }
//                                                                                         },
//                                                                                         mode: ExtendedImageMode.gesture,
//                                                                                       );
//                                                                                     }
//                                                                                   }()),
//                                                                                 ),
//                                                                                 options: CarouselOptions(
//                                                                                   autoPlay: false,
//                                                                                   enlargeCenterPage: true,
//                                                                                   aspectRatio: 1,
//                                                                                   viewportFraction: 1,
//                                                                                   initialPage: index,
//                                                                                 ),
//                                                                               ),
//                                                                             ),

//                                                                             Row(
//                                                                               mainAxisAlignment: MainAxisAlignment.center,
//                                                                               children: [
//                                                                                 IconButton(
//                                                                                   onPressed: () => buttonCarouselController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.linear),
//                                                                                   icon: const Icon(Icons.arrow_back_rounded, color: Color(0xffffffff),),
//                                                                                 ),
//                                                                                 IconButton(
//                                                                                   onPressed: () => buttonCarouselController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.linear),
//                                                                                   icon: const Icon(Icons.arrow_forward_rounded, color: Color(0xffffffff),),
//                                                                                 ),
//                                                                               ],
//                                                                             ),

//                                                                             const SizedBox(height: 85,),
//                                                                           ],
//                                                                         ),
//                                                                       ),
//                                                                     ),
//                                                                   );
//                                                                 },
//                                                               );
//                                                             },
//                                                           ),
//                                                         );
//                                                       }else{
//                                                         return StaggeredGridView.countBuilder(
//                                                           staggeredTileBuilder: (int index) => StaggeredTile.count(2, index.isEven ? 1 : 2),
//                                                           physics: const NeverScrollableScrollPhysics(),
//                                                           padding: EdgeInsets.zero,
//                                                           crossAxisSpacing: 4.0,
//                                                           mainAxisSpacing: 4.0,
//                                                           crossAxisCount: 4,
//                                                           shrinkWrap: true,
//                                                           itemCount: 3,
//                                                           itemBuilder: (BuildContext context, int index) => GestureDetector(
//                                                             child: ((){
//                                                               if(index != 1){
//                                                                 return lookupMimeType(originalPost.data!.almPost.showOriginalPostImagesOrVideos[index])?.contains('video') == true 
//                                                                 ? BetterPlayer.network('${originalPost.data!.almPost.showOriginalPostImagesOrVideos[index]}',
//                                                                   betterPlayerConfiguration: BetterPlayerConfiguration(
//                                                                     placeholder: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 16 / 9),
//                                                                     controlsConfiguration: const BetterPlayerControlsConfiguration(showControls: false,),
//                                                                     aspectRatio: 16 / 9,
//                                                                     fit: BoxFit.contain,
//                                                                   ),
//                                                                 )
//                                                                 : CachedNetworkImage(
//                                                                   fit: BoxFit.cover,
//                                                                   imageUrl: originalPost.data!.almPost.showOriginalPostImagesOrVideos[index],
//                                                                   placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
//                                                                   errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
//                                                                 );
//                                                               }else{
//                                                                 return ((){
//                                                                   if(originalPost.data!.almPost.showOriginalPostImagesOrVideos.length - 3 > 0){
//                                                                     if(lookupMimeType(originalPost.data!.almPost.showOriginalPostImagesOrVideos[index])?.contains('video') == true){
//                                                                       return Stack(
//                                                                         fit: StackFit.expand,
//                                                                         children: [
//                                                                           BetterPlayer.network('${originalPost.data!.almPost.showOriginalPostImagesOrVideos[index]}',
//                                                                             betterPlayerConfiguration: BetterPlayerConfiguration(
//                                                                               placeholder: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 16 / 9),
//                                                                               controlsConfiguration: const BetterPlayerControlsConfiguration(showControls: false,),
//                                                                               aspectRatio: 16 / 9,
//                                                                               fit: BoxFit.contain,
//                                                                             ),
//                                                                           ),

//                                                                           Container(color: const Color(0xff000000).withOpacity(0.5),),

//                                                                           Center(
//                                                                             child: CircleAvatar(
//                                                                               radius: 25,
//                                                                               backgroundColor: const Color(0xffffffff).withOpacity(.5),
//                                                                               child: Text('${originalPost.data!.almPost.showOriginalPostImagesOrVideos.length - 3}', style: const TextStyle(fontSize: 32, fontFamily: 'NexaBold', color: Color(0xffFFFFFF),),),
//                                                                             ),
//                                                                           ),
//                                                                         ],
//                                                                       );
//                                                                     }else{
//                                                                       return Stack(
//                                                                         fit: StackFit.expand,
//                                                                         children: [
//                                                                           CachedNetworkImage(
//                                                                             fit: BoxFit.cover,
//                                                                             imageUrl: originalPost.data!.almPost.showOriginalPostImagesOrVideos[index],
//                                                                             placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
//                                                                             errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
//                                                                           ),

//                                                                           Container(color: const Color(0xff000000).withOpacity(0.5),),

//                                                                           Center(
//                                                                             child: CircleAvatar(
//                                                                               radius: 25,
//                                                                               backgroundColor: const Color(0xffffffff).withOpacity(.5),
//                                                                               child: Text('${originalPost.data!.almPost.showOriginalPostImagesOrVideos.length - 3}', style: const TextStyle(fontSize: 32, fontFamily: 'NexaBold', color: Color(0xffFFFFFF),),),
//                                                                             ),
//                                                                           ),
//                                                                         ],
//                                                                       );
//                                                                     }
//                                                                   }else{
//                                                                     if(lookupMimeType(originalPost.data!.almPost.showOriginalPostImagesOrVideos[index])?.contains('video') == true){
//                                                                       return BetterPlayer.network('${originalPost.data!.almPost.showOriginalPostImagesOrVideos[index]}',
//                                                                         betterPlayerConfiguration: BetterPlayerConfiguration(
//                                                                           placeholder: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 16 / 9),
//                                                                           controlsConfiguration: const BetterPlayerControlsConfiguration(showControls: false,),
//                                                                           aspectRatio: 16 / 9,
//                                                                           fit: BoxFit.contain,
//                                                                         ),
//                                                                       );
//                                                                     }else{
//                                                                       return CachedNetworkImage(
//                                                                         fit: BoxFit.cover,
//                                                                         imageUrl: originalPost.data!.almPost.showOriginalPostImagesOrVideos[index],
//                                                                         placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
//                                                                         errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
//                                                                       );
//                                                                     }
//                                                                   }
//                                                                 }());
//                                                               }
//                                                             }()),
//                                                             onTap: (){
//                                                               showGeneralDialog(
//                                                                 context: context,
//                                                                 transitionDuration: const Duration(milliseconds: 0),
//                                                                 barrierDismissible: true,
//                                                                 barrierLabel: 'Dialog',
//                                                                 pageBuilder: (_, __, ___){
//                                                                   return Scaffold(
//                                                                     backgroundColor: Colors.black12.withOpacity(0.7),
//                                                                     body: SizedBox.expand(
//                                                                       child: SafeArea(
//                                                                         child: Column(
//                                                                           children: [
//                                                                             Container(
//                                                                               alignment: Alignment.centerRight,
//                                                                               padding: const EdgeInsets.only(right: 20.0),
//                                                                               child: GestureDetector(
//                                                                                 child: CircleAvatar(radius: 20, backgroundColor: const Color(0xff000000).withOpacity(0.8), child: const Icon(Icons.close_rounded, color: Color(0xffffffff),),),
//                                                                                 onTap: (){
//                                                                                   Navigator.pop(context);
//                                                                                 },
//                                                                               ),
//                                                                             ),
                                                                            
//                                                                             const SizedBox(height: 10,),

//                                                                             Expanded(
//                                                                               child: CarouselSlider(
//                                                                                 carouselController: buttonCarouselController,
//                                                                                 items: List.generate(
//                                                                                   originalPost.data!.almPost.showOriginalPostImagesOrVideos.length, (next) => ((){
//                                                                                     if(lookupMimeType(originalPost.data!.almPost.showOriginalPostImagesOrVideos[next])?.contains('video') == true){
//                                                                                       return BetterPlayer.network('${originalPost.data!.almPost.showOriginalPostImagesOrVideos[next]}',
//                                                                                         betterPlayerConfiguration: BetterPlayerConfiguration(
//                                                                                           placeholder: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 16 / 9),
//                                                                                           deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
//                                                                                           autoDispose: false,
//                                                                                           aspectRatio: 16 / 9,
//                                                                                           fit: BoxFit.contain,
//                                                                                         ),
//                                                                                       );
//                                                                                     }else{
//                                                                                       return ExtendedImage.network(
//                                                                                         originalPost.data!.almPost.showOriginalPostImagesOrVideos[next],
//                                                                                         fit: BoxFit.contain,
//                                                                                         loadStateChanged: (ExtendedImageState loading){
//                                                                                           if(loading.extendedImageLoadState == LoadState.loading || loading.extendedImageLoadState == LoadState.failed){
//                                                                                             return Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,);
//                                                                                           }
//                                                                                         },
//                                                                                         mode: ExtendedImageMode.gesture,
//                                                                                       );
//                                                                                     }
//                                                                                   }()),
//                                                                                 ),
//                                                                                 options: CarouselOptions(
//                                                                                   autoPlay: false,
//                                                                                   enlargeCenterPage: true,
//                                                                                   aspectRatio: 1,
//                                                                                   viewportFraction: 1,
//                                                                                   initialPage: index,
//                                                                                 ),
//                                                                               ),
//                                                                             ),

//                                                                             Row(
//                                                                               mainAxisAlignment: MainAxisAlignment.center,
//                                                                               children: [
//                                                                                 IconButton(
//                                                                                   onPressed: () => buttonCarouselController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.linear),
//                                                                                   icon: const Icon(Icons.arrow_back_rounded, color: Color(0xffffffff),),
//                                                                                 ),
//                                                                                 IconButton(
//                                                                                   onPressed: () => buttonCarouselController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.linear),
//                                                                                   icon: const Icon(Icons.arrow_forward_rounded, color: Color(0xffffffff),),
//                                                                                 ),
//                                                                               ],
//                                                                             ),

//                                                                             const SizedBox(height: 85,),
//                                                                           ],
//                                                                         ),
//                                                                       ),
//                                                                     ),
//                                                                   );
//                                                                 },
//                                                               );
//                                                             },
//                                                           ),
//                                                         );
//                                                       }
//                                                     }()),
//                                                   ),

//                                                   const SizedBox(height: 20),
//                                                 ],
//                                               )
//                                               : Container(color: const Color(0xffff0000), height: 0,),

//                                               originalPost.data!.almPost.showOriginalPostPostTagged.isNotEmpty
//                                               ? Column(
//                                                 children: [
//                                                   const SizedBox(height: 10),

//                                                   Container(
//                                                     alignment: Alignment.centerLeft,
//                                                     padding: const EdgeInsets.only(left: 20.0, right: 20.0),
//                                                     child: RichText(
//                                                       text: TextSpan(
//                                                         children: [
//                                                           const TextSpan(style: TextStyle(fontSize: 16, fontFamily: 'NexaRegular', color: Color(0xff888888)), text: 'with '),

//                                                           TextSpan(
//                                                             children: List.generate(
//                                                               originalPost.data!.almPost.showOriginalPostPostTagged.length, (index) => TextSpan(
//                                                                 style: const TextStyle(fontSize: 18, fontFamily: 'NexaBold', color: Color(0xff000000),),
//                                                                 children: <TextSpan>[
//                                                                   TextSpan(text: originalPost.data!.almPost.showOriginalPostPostTagged[index].showOriginalPostTaggedFirstName + ' ' + originalPost.data!.almPost.showOriginalPostPostTagged[index].showOriginalPostTaggedLastName,
//                                                                   recognizer: TapGestureRecognizer()
//                                                                     ..onTap = (){
//                                                                       Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularUserProfile(userId: originalPost.data!.almPost.showOriginalPostPostTagged[index].showOriginalPostTaggedId, accountType: originalPost.data!.almPost.showOriginalPostPostTagged[index].showOriginalPostAccountType)));
//                                                                     },
//                                                                   ),
//                                                                   index < originalPost.data!.almPost.showOriginalPostPostTagged.length - 1 ? const TextSpan(text: ', ') : const TextSpan(text: ''),
//                                                                 ],
//                                                               ),
//                                                             ),
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ],
//                                               )
//                                               : const SizedBox(height: 0,),

//                                               originalPost.data!.almPost.showOriginalPostLocation != ''
//                                               ? Column(
//                                                 children: [
//                                                   const SizedBox(height: 10,),

//                                                   Padding(
//                                                     padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                                                     child: Row(
//                                                       crossAxisAlignment: CrossAxisAlignment.center,
//                                                       children: [
//                                                         const Icon(Icons.place, color: Color(0xff888888)),

//                                                         Expanded(
//                                                           child: GestureDetector(
//                                                             child: Text(originalPost.data!.almPost.showOriginalPostLocation, style: const TextStyle(fontSize: 18, fontFamily: 'NexaBold', color: Color(0xff000000),),),
//                                                             onTap: (){
//                                                               Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularMaps(latitude: originalPost.data!.almPost.showOriginalPostLatitude, longitude: originalPost.data!.almPost.showOriginalPostLongitude, isMemorial: false, memorialName: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageName, memorialImage: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageProfileImage,)));
//                                                             },
//                                                           ),  
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   ),
//                                                 ],
//                                               )
//                                               : const SizedBox(height: 0,),

//                                               Container(
//                                                 height: 40,
//                                                 padding: const EdgeInsets.symmetric(horizontal: 10.0),
//                                                 child: Row(
//                                                   mainAxisAlignment: MainAxisAlignment.end,
//                                                   children: [
//                                                     Row(
//                                                       children: [
//                                                         likePost == true
//                                                         ? const FaIcon(FontAwesomeIcons.heart, color: Color(0xffE74C3C),)
//                                                         : const FaIcon(FontAwesomeIcons.heart, color: Color(0xff000000),),

//                                                         const SizedBox(width: 10,),

//                                                         Text('$numberOfLikes', style: const TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xffBDC3C7),),),
//                                                       ],
//                                                     ),

//                                                     const SizedBox(width: 40,),

//                                                     Row(
//                                                       children: [
//                                                         const FaIcon(FontAwesomeIcons.comment, color: Color(0xff000000),),

//                                                         const SizedBox(width: 10,),

//                                                         Text('$numberOfComments', style: const TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xffBDC3C7),),),
//                                                       ],
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),

//                                         SliverToBoxAdapter( // COMMENTS AND REPLIES
//                                           child: FutureBuilder<APIRegularShowListOfComments>(
//                                             future: getListOfComments(),
//                                             builder: (context, listOfComments){
//                                               if(listOfComments.connectionState != ConnectionState.done){
//                                                 return const Center(child: CustomLoader(),);
//                                               }
//                                               else if(listOfComments.hasError){
//                                                 return const MiscErrorMessageTemplate();
//                                               }
//                                               else if(listOfComments.hasData){
//                                                 return Column(
//                                                   children: List.generate(listOfComments.data!.almCommentsList.length, (i) => ListTile(
//                                                     visualDensity: const VisualDensity(vertical: 4.0),
//                                                     leading: listOfComments.data!.almCommentsList[i].showListOfCommentsUser.showListOfCommentsUserImage != ''
//                                                     ? CircleAvatar(
//                                                       backgroundColor: const Color(0xff888888),
//                                                       foregroundImage: NetworkImage(listOfComments.data!.almCommentsList[i].showListOfCommentsUser.showListOfCommentsUserImage),
//                                                     )
//                                                     : const CircleAvatar(
//                                                       backgroundColor: Color(0xff888888),
//                                                       foregroundImage: AssetImage('assets/icons/user-placeholder.png'),
//                                                     ),
//                                                     title: Row(
//                                                       children: [
//                                                         Expanded(
//                                                           child: currentUserId == listOfComments.data!.almCommentsList[i].showListOfCommentsUser.showListOfCommentsUserId && currentAccountType == listOfComments.data!.almCommentsList[i].showListOfCommentsUser.showListOfCommentsUserAccountType
//                                                           ? const Text('You', style: TextStyle(fontSize: 20, fontFamily: 'NexaBold', color: Color(0xff000000),),)
//                                                           : Text('${listOfComments.data!.almCommentsList[i].showListOfCommentsUser.showListOfCommentsUserFirstName} ${listOfComments.data!.almCommentsList[i].showListOfCommentsUser.showListOfCommentsUserLastName}', style: const TextStyle(fontSize: 20, fontFamily: 'NexaBold', color: Color(0xff000000),),),
//                                                         ),

//                                                         Expanded(
//                                                           child: Align(
//                                                             alignment: Alignment.centerRight,
//                                                             // child: TextButton.icon(
//                                                             //   onPressed: (){},
//                                                             //   icon: const FaIcon(FontAwesomeIcons.heart, color: Color(0xff888888),),
//                                                             //   label: const Text('0', style: TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xffBDC3C7),),),
//                                                             // ),
//                                                             child: FutureBuilder<APIRegularShowCommentOrReplyLikeStatus>(
//                                                               future: getShowCommentOrReplyLikeStatus(commentableType: 'Comment', commentId: listOfComments.data!.almCommentsList[i].showListOfCommentsCommentId),
//                                                               builder: (context, listOfCommentOrReplyLikeStatus){
//                                                                 if(listOfCommentOrReplyLikeStatus.connectionState != ConnectionState.done){
//                                                                   return const SizedBox(height: 0,);
//                                                                 }
//                                                                 else if(listOfCommentOrReplyLikeStatus.hasError){
//                                                                   return const SizedBox(height: 0,);
//                                                                 }
//                                                                 else if(listOfCommentOrReplyLikeStatus.hasData){
//                                                                   return TextButton.icon(
//                                                                     onPressed: () async{
//                                                                       // if(listOfCommentOrReplyLikeStatus.data!.showCommentOrReplyLikeStatus){
//                                                                       //   commentsLikes[i] = false;
//                                                                       //   commentsNumberOfLikes[i]--;

//                                                                       //   await apiRegularLikeOrUnlikeCommentReply(commentableType: 'Comment', commentableId: commentsListener[i].commentId, likeStatus: false);
//                                                                       // }else{
//                                                                       //   commentsLikes[i] = true;
//                                                                       //   commentsNumberOfLikes[i]++;

//                                                                       //   await apiRegularLikeOrUnlikeCommentReply(commentableType: 'Comment', commentableId: commentsListener[i].commentId, likeStatus: true);
//                                                                       // }

//                                                                       if(commentsLikes[i] == true){
//                                                                         commentsLikes[i] = false;
//                                                                         commentsNumberOfLikes[i]--;

//                                                                         await apiRegularLikeOrUnlikeCommentReply(commentableType: 'Comment', commentableId: commentsListener[i].commentId, likeStatus: false);
//                                                                       }else{
//                                                                         commentsLikes[i] = true;
//                                                                         commentsNumberOfLikes[i]++;

//                                                                         await apiRegularLikeOrUnlikeCommentReply(commentableType: 'Comment', commentableId: commentsListener[i].commentId, likeStatus: true);
//                                                                       }
//                                                                     },
//                                                                     icon: listOfCommentOrReplyLikeStatus.data!.showCommentOrReplyLikeStatus == true
//                                                                     ? const FaIcon(FontAwesomeIcons.solidHeart, color: Color(0xffE74C3C),)
//                                                                     : const FaIcon(FontAwesomeIcons.heart, color: Color(0xff888888),),
//                                                                     label: Text('${listOfCommentOrReplyLikeStatus.data!.showCommentOrReplyNumberOfLikes}', style: const TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xffBDC3C7),),),
//                                                                   );
//                                                                 }else{
//                                                                   return TextButton.icon(
//                                                                     onPressed: (){},
//                                                                     icon: const FaIcon(FontAwesomeIcons.heart, color: Color(0xff888888),),
//                                                                     label: const Text('0', style: TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xffBDC3C7),),),
//                                                                   );
//                                                                 }
//                                                               }
//                                                             ),
//                                                           )
//                                                         ),

//                                                         // Expanded(
//                                                         //   child: FutureBuilder<APIRegularShowCommentOrReplyLikeStatus>(
//                                                         //     future: getShowCommentOrReplyLikeStatus(commentableType: 'Comment', commentId: listOfComments.data!.almCommentsList[i].showListOfCommentsCommentId),
//                                                         //     builder: (context, listOfCommentOrReplyLikeStatus){
//                                                         //       // commentsLikes.add(listOfCommentOrReplyLikeStatus.data!.showCommentOrReplyLikeStatus);
//                                                         //       // commentsNumberOfLikes.add(listOfCommentOrReplyLikeStatus.data!.showCommentOrReplyNumberOfLikes);
//                                                         //       if(listOfCommentOrReplyLikeStatus.connectionState != ConnectionState.done){
//                                                         //         return const Center(child: CustomLoader(),);
//                                                         //       }
//                                                         //       if(listOfCommentOrReplyLikeStatus.hasError){
//                                                         //         return const SizedBox(height: 0,);
//                                                         //       }
//                                                         //       if(listOfCommentOrReplyLikeStatus.hasData){
//                                                         //         return Align(
//                                                         //           alignment: Alignment.centerRight,
//                                                         //           child: TextButton.icon(
//                                                         //             onPressed: () async{
//                                                         //               // if(listOfCommentOrReplyLikeStatus.data!.showCommentOrReplyLikeStatus){
//                                                         //               //   commentsLikes[i] = false;
//                                                         //               //   commentsNumberOfLikes[i]--;

//                                                         //               //   await apiRegularLikeOrUnlikeCommentReply(commentableType: 'Comment', commentableId: commentsListener[i].commentId, likeStatus: false);
//                                                         //               // }else{
//                                                         //               //   commentsLikes[i] = true;
//                                                         //               //   commentsNumberOfLikes[i]++;

//                                                         //               //   await apiRegularLikeOrUnlikeCommentReply(commentableType: 'Comment', commentableId: commentsListener[i].commentId, likeStatus: true);
//                                                         //               // }

//                                                         //               if(commentsLikes[i] == true){
//                                                         //                 commentsLikes[i] = false;
//                                                         //                 commentsNumberOfLikes[i]--;

//                                                         //                 await apiRegularLikeOrUnlikeCommentReply(commentableType: 'Comment', commentableId: commentsListener[i].commentId, likeStatus: false);
//                                                         //               }else{
//                                                         //                 commentsLikes[i] = true;
//                                                         //                 commentsNumberOfLikes[i]++;

//                                                         //                 await apiRegularLikeOrUnlikeCommentReply(commentableType: 'Comment', commentableId: commentsListener[i].commentId, likeStatus: true);
//                                                         //               }
//                                                         //             },
//                                                         //             icon: listOfCommentOrReplyLikeStatus.data!.showCommentOrReplyLikeStatus == true
//                                                         //             ? const FaIcon(FontAwesomeIcons.solidHeart, color: Color(0xffE74C3C),)
//                                                         //             : const FaIcon(FontAwesomeIcons.heart, color: Color(0xff888888),),
//                                                         //             label: Text('${commentsNumberOfLikes[i]}', style: const TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xffBDC3C7),),),
//                                                         //           ),
//                                                         //         );
//                                                         //       }else{
//                                                         //         return Align(
//                                                         //           alignment: Alignment.centerRight,
//                                                         //           child: TextButton.icon(
//                                                         //             onPressed: (){},
//                                                         //             icon: const FaIcon(FontAwesomeIcons.heart, color: Color(0xff888888),),
//                                                         //             label: const Text('0', style: TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xffBDC3C7),),),
//                                                         //           ),
//                                                         //         );
//                                                         //       }
//                                                         //     }
//                                                         //   ),
//                                                         // ),
//                                                       ],
//                                                     ),
//                                                     subtitle: Column(
//                                                       children: [
//                                                         Row(
//                                                           children: [
//                                                             Expanded(
//                                                               child: Container(
//                                                                 padding: const EdgeInsets.all(10.0),
//                                                                 child: Text(listOfComments.data!.almCommentsList[i].showListOfCommentsCommentBody, style: const TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xffFFFFFF),),),
//                                                                 decoration: const BoxDecoration(color: Color(0xff4EC9D4), borderRadius: BorderRadius.all(Radius.circular(10.0)),),
//                                                               ),
//                                                             ),
//                                                           ],
//                                                         ),

//                                                         const SizedBox(height: 5,),

//                                                         Row(
//                                                           children: [
//                                                             Text(timeago.format(DateTime.parse(listOfComments.data!.almCommentsList[i].showListOfCommentsCreatedAt)), style: const TextStyle(fontSize: 18, fontFamily: 'NexaRegular', color: Color(0xff000000),),),

//                                                             const SizedBox(width: 20,),

//                                                             GestureDetector(
//                                                               child: const Text('Reply', style: TextStyle(fontSize: 18, fontFamily: 'NexaRegular', color: Color(0xff000000),),),
//                                                               onTap: () async{
//                                                                 // if(controller.text != ''){
//                                                                 //   controller.clear();
//                                                                 // }

//                                                                 // isComment = false;
//                                                                 // currentCommentId = commentsListener[i].commentId;

//                                                                 // await showModalBottomSheet(context: context, builder: (context) => showKeyboard(
//                                                                 //   isReply: true, 
//                                                                 //   toReply: commentsListener[i].commentBody, 
//                                                                 //   replyFrom: '${commentsListener[i].firstName}' '${commentsListener[i].lastName}')
//                                                                 // );
//                                                               },
//                                                             ),
//                                                           ],
//                                                         ),
                                                        
//                                                         const SizedBox(height: 20,),

//                                                         FutureBuilder<APIRegularShowListOfReplies>(
//                                                           future: getListOfReplies(commentId: listOfComments.data!.almCommentsList[i].showListOfCommentsCommentId),
//                                                           builder: (context, listOfReplies){
//                                                             if(listOfReplies.connectionState != ConnectionState.done){
//                                                               return const SizedBox(height: 0,);
//                                                             }else if(listOfReplies.hasError){
//                                                               return const SizedBox(height: 0,);
//                                                             }
//                                                             else if(listOfReplies.hasData){
//                                                               return Column(
//                                                                 children: List.generate(listOfReplies.data!.almRepliesList.length, (index) => ListTile(
//                                                                   contentPadding: EdgeInsets.zero,
//                                                                   visualDensity: const VisualDensity(vertical: 4.0),
//                                                                   leading: listOfReplies.data!.almRepliesList[index].showListOfRepliesUser.showListRepliesUserImage != ''
//                                                                   ? CircleAvatar(
//                                                                     backgroundColor: const Color(0xff888888),
//                                                                     foregroundImage: NetworkImage(listOfReplies.data!.almRepliesList[index].showListOfRepliesUser.showListRepliesUserImage),
//                                                                   )
//                                                                   : const CircleAvatar(
//                                                                     backgroundColor: Color(0xff888888),
//                                                                     foregroundImage: AssetImage('assets/icons/user-placeholder.png'),
//                                                                   ),
//                                                                   title: Row(
//                                                                     children: [
//                                                                       Expanded(
//                                                                         child: currentUserId == listOfReplies.data!.almRepliesList[index].showListOfRepliesUser.showListRepliesUserUserId && currentAccountType == listOfReplies.data!.almRepliesList[index].showListOfRepliesUser.showListOfCommentsUserAccountType
//                                                                         ? const Text('You', style: TextStyle(fontSize: 20, fontFamily: 'NexaBold', color: Color(0xff000000),),)
//                                                                         : Text(listOfReplies.data!.almRepliesList[index].showListOfRepliesUser.showListRepliesUserFirstName + ' ' + listOfReplies.data!.almRepliesList[index].showListOfRepliesUser.showListRepliesUserLastName, style: const TextStyle(fontSize: 20, fontFamily: 'NexaBold', color: Color(0xff000000)),),
//                                                                       ),

//                                                                       Expanded(
//                                                                         child: FutureBuilder<APIRegularShowCommentOrReplyLikeStatus>(
//                                                                           future: getShowCommentOrReplyLikeStatus(commentableType: 'Reply', commentId: listOfReplies.data!.almRepliesList[index].showListOfRepliesReplyId),
//                                                                           builder: (context, listOfReplyLikeStatus){
//                                                                             if(listOfReplyLikeStatus.connectionState != ConnectionState.done){
//                                                                               return const SizedBox(height: 0,);
//                                                                             }else if(listOfReplyLikeStatus.hasError){
//                                                                               return const SizedBox(height: 0,);
//                                                                             }
//                                                                             else if(listOfReplyLikeStatus.hasData){
//                                                                               return Align(
//                                                                                 alignment: Alignment.centerRight,
//                                                                                 child: TextButton.icon(
//                                                                                   onPressed: () async{
//                                                                                     // if(commentsLikes[i] == true){
//                                                                                     //   commentsLikes[i] = false;
//                                                                                     //   commentsNumberOfLikes[i]--;

//                                                                                     //   await apiRegularLikeOrUnlikeCommentReply(commentableType: 'Comment', commentableId: commentsListener[i].commentId, likeStatus: false);
//                                                                                     // }else{
//                                                                                     //   commentsLikes[i] = true;
//                                                                                     //   commentsNumberOfLikes[i]++;

//                                                                                     //   await apiRegularLikeOrUnlikeCommentReply(commentableType: 'Comment', commentableId: commentsListener[i].commentId, likeStatus: true);
//                                                                                     // }
//                                                                                   },
//                                                                                   icon: listOfReplyLikeStatus.data!.showCommentOrReplyLikeStatus == true
//                                                                                   ? const FaIcon(FontAwesomeIcons.solidHeart, color: Color(0xffE74C3C),)
//                                                                                   : const FaIcon(FontAwesomeIcons.heart, color: Color(0xff888888),),
//                                                                                   label: Text('${listOfReplyLikeStatus.data!.showCommentOrReplyNumberOfLikes}', style: const TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xffBDC3C7),),),
//                                                                                 ),
//                                                                               );
//                                                                             }else{
//                                                                               return Align(
//                                                                                 alignment: Alignment.centerRight,
//                                                                                 child: TextButton.icon(
//                                                                                   onPressed: (){},
//                                                                                   icon: const FaIcon(FontAwesomeIcons.heart, color: Color(0xff888888),),
//                                                                                   label: const Text('0', style: TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xffBDC3C7),),),
//                                                                                 ),
//                                                                               );
//                                                                             }
//                                                                           }
//                                                                         ),
//                                                                       ),

//                                                                       // Expanded(
//                                                                       //   child: Align(
//                                                                       //     alignment: Alignment.centerRight,
//                                                                       //     child: TextButton.icon(
//                                                                       //       onPressed: () async{
//                                                                       //         // if(repliesLikes[i][index] == true){
//                                                                       //         //   repliesLikes[i][index] = false;
//                                                                       //         //   repliesNumberOfLikes[i][index]--;

//                                                                       //         //   await apiRegularLikeOrUnlikeCommentReply(commentableType: 'Reply', commentableId: commentsListener[i].listOfReplies[index].replyId, likeStatus: false);
//                                                                       //         // }else{
//                                                                       //         //   repliesLikes[i][index] = true;
//                                                                       //         //   repliesNumberOfLikes[i][index]++;

//                                                                       //         //   await apiRegularLikeOrUnlikeCommentReply(commentableType: 'Reply', commentableId: commentsListener[i].listOfReplies[index].replyId, likeStatus: true);
//                                                                       //         // }
//                                                                       //       },
//                                                                       //       icon: repliesLikes[i][index] == true
//                                                                       //       ? const FaIcon(FontAwesomeIcons.solidHeart, color: Color(0xffE74C3C),)
//                                                                       //       : const FaIcon(FontAwesomeIcons.heart, color: Color(0xff888888),),
//                                                                       //       label: Text('${repliesNumberOfLikes[i][index]}', style: const TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xffBDC3C7),),),
//                                                                       //     ),
//                                                                       //   ),
//                                                                       // ),
//                                                                     ],
//                                                                   ),
//                                                                   subtitle: Column(
//                                                                     children: [
//                                                                       Row(
//                                                                         children: [
//                                                                           Expanded(
//                                                                             child: Container(
//                                                                               padding: const EdgeInsets.all(10.0),
//                                                                               child: Text(listOfReplies.data!.almRepliesList[index].showListOfRepliesReplyBody, style: const TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xffFFFFFF),),),
//                                                                               decoration: const BoxDecoration(color: Color(0xff4EC9D4), borderRadius: BorderRadius.all(Radius.circular(10.0)),),
//                                                                             ),
//                                                                           ),
//                                                                         ],
//                                                                       ),

//                                                                       const SizedBox(height: 5,),

//                                                                       Row(
//                                                                         children: [
//                                                                           Text(timeago.format(DateTime.parse(listOfReplies.data!.almRepliesList[index].showListOfRepliesCreatedAt),), style: const TextStyle(fontSize: 18, fontFamily: 'NexaRegular', color: Color(0xff000000),),),

//                                                                           const SizedBox(width: 40,),

//                                                                           GestureDetector(
//                                                                             child: const Text('Reply', style: TextStyle(fontSize: 18, fontFamily: 'NexaRegular', color: Color(0xff000000),),),
//                                                                             onTap: () async{
//                                                                               // if(controller.text != ''){
//                                                                               //   controller.clear();
//                                                                               // }

//                                                                               // controller.text = commentsListener[i].firstName + ' ' + commentsListener[i].lastName + ' ';
//                                                                               // isComment = false;
//                                                                               // currentCommentId = commentsListener[i].commentId;

//                                                                               // await showModalBottomSheet(context: context, builder: (context) => showKeyboard(isReply: true, toReply: commentsListener[i].listOfReplies[index].replyBody, replyFrom: '${commentsListener[i].listOfReplies[index].firstName} ${commentsListener[i].listOfReplies[index].lastName}'));
//                                                                             },
//                                                                           ),
//                                                                         ],
//                                                                       ),
//                                                                     ],
//                                                                   ),
//                                                                   onTap: (){
//                                                                     // Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularUserProfile(userId: commentsListener[i].listOfReplies[index].userId, accountType: currentAccountType,),),);
//                                                                   },
//                                                                   onLongPress: () async{
//                                                                     // if(currentUserId == commentsListener[i].listOfReplies[index].userId && currentAccountType == commentsListener[i].listOfReplies[index].userAccountType){
//                                                                     //   await showMaterialModalBottomSheet(
//                                                                     //     context: context,
//                                                                     //     builder: (context) => SafeArea(
//                                                                     //       top: false,
//                                                                     //       child: Column(
//                                                                     //         mainAxisSize: MainAxisSize.min,
//                                                                     //         children: <Widget>[
//                                                                     //           ListTile(
//                                                                     //             title: const Text('Edit'),
//                                                                     //             leading: const Icon(Icons.edit),
//                                                                     //             onTap: () async{
//                                                                     //               controller.text = controller.text + commentsListener[i].listOfReplies[index].replyBody;
//                                                                     //               await showModalBottomSheet(
//                                                                     //                 context: context,
//                                                                     //                 builder: (context) => showKeyboardEdit(isEdit: false, editId: commentsListener[i].listOfReplies[index].replyId),
//                                                                     //               );
//                                                                     //             },
//                                                                     //           ),
//                                                                     //           ListTile(
//                                                                     //             title: const Text('Delete'),
//                                                                     //             leading: const Icon(Icons.delete),
//                                                                     //             onTap: () async{
//                                                                     //               context.loaderOverlay.show();
//                                                                     //               await apiRegularDeleteReply(replyId: commentsListener[i].listOfReplies[index].replyId);
//                                                                     //               context.loaderOverlay.hide();

//                                                                     //               controller.clear();
//                                                                     //               itemRemaining = 1;
//                                                                     //               repliesRemaining = 1;
//                                                                     //               comments.value = [];
//                                                                     //               replies.value = [];
//                                                                     //               numberOfReplies = 0;
//                                                                     //               page1 = 1;
//                                                                     //               page2 = 1;
//                                                                     //               count.value = 0;
//                                                                     //               commentsLikes = [];
//                                                                     //               commentsNumberOfLikes = [];
//                                                                     //               repliesLikes = [];
//                                                                     //               repliesNumberOfLikes = [];
//                                                                     //               isComment = true;
//                                                                     //               numberOfLikes = 0;
//                                                                     //               numberOfComments = 0;
//                                                                     //               getOriginalPostInformation();
//                                                                     //               onLoading();
//                                                                     //               Navigator.pop(context);
//                                                                     //             },
//                                                                     //           )
//                                                                     //         ],
//                                                                     //       ),
//                                                                     //     ),
//                                                                     //   );
//                                                                     // }else{
//                                                                     //   await showMaterialModalBottomSheet(
//                                                                     //     context: context,
//                                                                     //     builder: (context) => SafeArea(
//                                                                     //       top: false,
//                                                                     //       child: Column(
//                                                                     //         mainAxisSize: MainAxisSize.min,
//                                                                     //         children: <Widget>[
//                                                                     //           ListTile(
//                                                                     //             title: const Text('Report'),
//                                                                     //             leading: const Icon(Icons.edit),
//                                                                     //             onTap: (){
//                                                                     //               Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularReport(postId: widget.postId, reportType: 'Post')));
//                                                                     //             },
//                                                                     //           ),
//                                                                     //         ],
//                                                                     //       ),
//                                                                     //     ),
//                                                                     //   );
//                                                                     // }
//                                                                   },
//                                                                   ),
//                                                                 ),
//                                                               );
//                                                             }else{
//                                                               return const SizedBox(height: 0,);
//                                                             }
//                                                           }
//                                                         ),

//                                                         // commentsListener[i].listOfReplies.isNotEmpty
//                                                         // ? Column(
//                                                         //   children: List.generate(commentsListener[i].listOfReplies.length, (index) => ListTile(
//                                                         //     contentPadding: EdgeInsets.zero,
//                                                         //     visualDensity: const VisualDensity(vertical: 4.0),
//                                                         //     leading: commentsListener[i].listOfReplies[index].image != ''
//                                                         //     ? CircleAvatar(
//                                                         //       backgroundColor: const Color(0xff888888),
//                                                         //       foregroundImage: NetworkImage(commentsListener[i].listOfReplies[index].image),
//                                                         //     )
//                                                         //     : const CircleAvatar(
//                                                         //       backgroundColor: Color(0xff888888),
//                                                         //       foregroundImage: AssetImage('assets/icons/user-placeholder.png'),
//                                                         //     ),
//                                                         //     title: Row(
//                                                         //       children: [
//                                                         //         Expanded(
//                                                         //           child: currentUserId == commentsListener[i].listOfReplies[index].userId && currentAccountType == commentsListener[i].listOfReplies[index].userAccountType
//                                                         //           ? const Text('You', style: TextStyle(fontSize: 20, fontFamily: 'NexaBold', color: Color(0xff000000),),)
//                                                         //           : Text(commentsListener[i].listOfReplies[index].firstName + ' ' + commentsListener[i].listOfReplies[index].lastName, style: const TextStyle(fontSize: 20, fontFamily: 'NexaBold', color: Color(0xff000000)),),
//                                                         //         ),

//                                                         //         Expanded(
//                                                         //           child: Align(
//                                                         //             alignment: Alignment.centerRight,
//                                                         //             child: TextButton.icon(
//                                                         //               onPressed: () async{
//                                                         //                 if(repliesLikes[i][index] == true){
//                                                         //                   repliesLikes[i][index] = false;
//                                                         //                   repliesNumberOfLikes[i][index]--;

//                                                         //                   await apiRegularLikeOrUnlikeCommentReply(commentableType: 'Reply', commentableId: commentsListener[i].listOfReplies[index].replyId, likeStatus: false);
//                                                         //                 }else{
//                                                         //                   repliesLikes[i][index] = true;
//                                                         //                   repliesNumberOfLikes[i][index]++;

//                                                         //                   await apiRegularLikeOrUnlikeCommentReply(commentableType: 'Reply', commentableId: commentsListener[i].listOfReplies[index].replyId, likeStatus: true);
//                                                         //                 }
//                                                         //               },
//                                                         //               icon: repliesLikes[i][index] == true
//                                                         //               ? const FaIcon(FontAwesomeIcons.solidHeart, color: Color(0xffE74C3C),)
//                                                         //               : const FaIcon(FontAwesomeIcons.heart, color: Color(0xff888888),),
//                                                         //               label: Text('${repliesNumberOfLikes[i][index]}', style: const TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xffBDC3C7),),),
//                                                         //             ),
//                                                         //           ),
//                                                         //         ),
//                                                         //       ],
//                                                         //     ),
//                                                         //     subtitle: Column(
//                                                         //       children: [
//                                                         //         Row(
//                                                         //           children: [
//                                                         //             Expanded(
//                                                         //               child: Container(
//                                                         //                 padding: const EdgeInsets.all(10.0),
//                                                         //                 child: Text(commentsListener[i].listOfReplies[index].replyBody, style: const TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xffFFFFFF),),),
//                                                         //                 decoration: const BoxDecoration(color: Color(0xff4EC9D4), borderRadius: BorderRadius.all(Radius.circular(10.0)),),
//                                                         //               ),
//                                                         //             ),
//                                                         //           ],
//                                                         //         ),

//                                                         //         const SizedBox(height: 5,),

//                                                         //         Row(
//                                                         //           children: [
//                                                         //             Text(timeago.format(DateTime.parse(commentsListener[i].listOfReplies[index].createdAt),), style: const TextStyle(fontSize: 18, fontFamily: 'NexaRegular', color: Color(0xff000000),),),

//                                                         //             const SizedBox(width: 40,),

//                                                         //             GestureDetector(
//                                                         //               child: const Text('Reply', style: TextStyle(fontSize: 18, fontFamily: 'NexaRegular', color: Color(0xff000000),),),
//                                                         //               onTap: () async{
//                                                         //                 if(controller.text != ''){
//                                                         //                   controller.clear();
//                                                         //                 }

//                                                         //                 controller.text = commentsListener[i].firstName + ' ' + commentsListener[i].lastName + ' ';
//                                                         //                 isComment = false;
//                                                         //                 currentCommentId = commentsListener[i].commentId;

//                                                         //                 await showModalBottomSheet(context: context, builder: (context) => showKeyboard(isReply: true, toReply: commentsListener[i].listOfReplies[index].replyBody, replyFrom: '${commentsListener[i].listOfReplies[index].firstName} ${commentsListener[i].listOfReplies[index].lastName}'));
//                                                         //               },
//                                                         //             ),
//                                                         //           ],
//                                                         //         ),
//                                                         //       ],
//                                                         //     ),
//                                                         //     onTap: (){
//                                                         //       Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularUserProfile(userId: commentsListener[i].listOfReplies[index].userId, accountType: currentAccountType,),),);
//                                                         //     },
//                                                         //     onLongPress: () async{
//                                                         //       if(currentUserId == commentsListener[i].listOfReplies[index].userId && currentAccountType == commentsListener[i].listOfReplies[index].userAccountType){
//                                                         //         await showMaterialModalBottomSheet(
//                                                         //           context: context,
//                                                         //           builder: (context) => SafeArea(
//                                                         //             top: false,
//                                                         //             child: Column(
//                                                         //               mainAxisSize: MainAxisSize.min,
//                                                         //               children: <Widget>[
//                                                         //                 ListTile(
//                                                         //                   title: const Text('Edit'),
//                                                         //                   leading: const Icon(Icons.edit),
//                                                         //                   onTap: () async{
//                                                         //                     controller.text = controller.text + commentsListener[i].listOfReplies[index].replyBody;
//                                                         //                     await showModalBottomSheet(
//                                                         //                       context: context,
//                                                         //                       builder: (context) => showKeyboardEdit(isEdit: false, editId: commentsListener[i].listOfReplies[index].replyId),
//                                                         //                     );
//                                                         //                   },
//                                                         //                 ),
//                                                         //                 ListTile(
//                                                         //                   title: const Text('Delete'),
//                                                         //                   leading: const Icon(Icons.delete),
//                                                         //                   onTap: () async{
//                                                         //                     context.loaderOverlay.show();
//                                                         //                     await apiRegularDeleteReply(replyId: commentsListener[i].listOfReplies[index].replyId);
//                                                         //                     context.loaderOverlay.hide();

//                                                         //                     controller.clear();
//                                                         //                     itemRemaining = 1;
//                                                         //                     repliesRemaining = 1;
//                                                         //                     comments.value = [];
//                                                         //                     replies.value = [];
//                                                         //                     numberOfReplies = 0;
//                                                         //                     page1 = 1;
//                                                         //                     page2 = 1;
//                                                         //                     count.value = 0;
//                                                         //                     commentsLikes = [];
//                                                         //                     commentsNumberOfLikes = [];
//                                                         //                     repliesLikes = [];
//                                                         //                     repliesNumberOfLikes = [];
//                                                         //                     isComment = true;
//                                                         //                     numberOfLikes = 0;
//                                                         //                     numberOfComments = 0;
//                                                         //                     getOriginalPostInformation();
//                                                         //                     onLoading();
//                                                         //                     Navigator.pop(context);
//                                                         //                   },
//                                                         //                 )
//                                                         //               ],
//                                                         //             ),
//                                                         //           ),
//                                                         //         );
//                                                         //       }else{
//                                                         //         await showMaterialModalBottomSheet(
//                                                         //           context: context,
//                                                         //           builder: (context) => SafeArea(
//                                                         //             top: false,
//                                                         //             child: Column(
//                                                         //               mainAxisSize: MainAxisSize.min,
//                                                         //               children: <Widget>[
//                                                         //                 ListTile(
//                                                         //                   title: const Text('Report'),
//                                                         //                   leading: const Icon(Icons.edit),
//                                                         //                   onTap: (){
//                                                         //                     Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularReport(postId: widget.postId, reportType: 'Post')));
//                                                         //                   },
//                                                         //                 ),
//                                                         //               ],
//                                                         //             ),
//                                                         //           ),
//                                                         //         );
//                                                         //       }
//                                                         //     },
//                                                         //   ),),
//                                                         // )
//                                                         // : const SizedBox(height: 0,),
//                                                       ],
//                                                     ),
//                                                     // onTap: (){
//                                                     //   Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularUserProfile(userId: commentsListener[i].userId, accountType: commentsListener[i].userAccountType,)));
//                                                     // },
//                                                     // onLongPress: () async{
//                                                     //   if(currentUserId == commentsListener[i].userId && currentAccountType == commentsListener[i].userAccountType){
//                                                     //     await showMaterialModalBottomSheet(
//                                                     //       context: context,
//                                                     //       builder: (context) => SafeArea(
//                                                     //         top: false,
//                                                     //         child: Column(
//                                                     //           mainAxisSize: MainAxisSize.min,
//                                                     //           children: <Widget>[
//                                                     //             ListTile(
//                                                     //               title: const Text('Edit'),
//                                                     //               leading: const Icon(Icons.edit),
//                                                     //               onTap: () async {
//                                                     //                 controller.text = controller.text + commentsListener[i].commentBody;
//                                                     //                 await showModalBottomSheet(
//                                                     //                   context: context,
//                                                     //                   builder: (context) => showKeyboardEdit(isEdit: true, editId: commentsListener[i].commentId),
//                                                     //                 );
//                                                     //               },
//                                                     //             ),

//                                                     //             ListTile(
//                                                     //               title: const Text('Delete'),
//                                                     //               leading: const Icon(Icons.delete),
//                                                     //               onTap: () async{
//                                                     //                 context.loaderOverlay.show();
//                                                     //                 await apiRegularDeleteComment(commentId: commentsListener[i].commentId);
//                                                     //                 context.loaderOverlay.hide();

//                                                     //                 controller.clear();
//                                                     //                 itemRemaining = 1;
//                                                     //                 repliesRemaining = 1;
//                                                     //                 comments.value = [];
//                                                     //                 replies.value = [];
//                                                     //                 numberOfReplies = 0;
//                                                     //                 page1 = 1;
//                                                     //                 page2 = 1;
//                                                     //                 count.value = 0;
//                                                     //                 commentsLikes = [];
//                                                     //                 commentsNumberOfLikes = [];
//                                                     //                 repliesLikes = [];
//                                                     //                 repliesNumberOfLikes = [];
//                                                     //                 isComment = true;
//                                                     //                 numberOfLikes = 0;
//                                                     //                 numberOfComments = 0;
//                                                     //                 getOriginalPostInformation();
//                                                     //                 onLoading();
//                                                     //                 Navigator.pop(context);
//                                                     //               },
//                                                     //             )
//                                                     //           ],
//                                                     //         ),
//                                                     //       ),
//                                                     //     );
//                                                     //   }else{
//                                                     //     await showMaterialModalBottomSheet(
//                                                     //       context: context,
//                                                     //       builder: (context) => SafeArea(
//                                                     //         top: false,
//                                                     //         child: Column(
//                                                     //           mainAxisSize: MainAxisSize.min,
//                                                     //           children: <Widget>[
//                                                     //             ListTile(
//                                                     //               title: const Text('Report'),
//                                                     //               leading: const Icon(Icons.edit),
//                                                     //               onTap: (){
//                                                     //                 Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularReport(postId: widget.postId, reportType: 'Post')));
//                                                     //               },
//                                                     //             ),
//                                                     //           ],
//                                                     //         ),
//                                                     //       ),
//                                                     //     );
//                                                     //   }
//                                                     // },
//                                                   ),
//                                                 ),
//                                                 );
//                                               }else{
//                                                 return const SizedBox(height: 0,);
//                                               }
//                                             }
//                                           ),
//                                         ),
//                                       ],
//                                     );
//                                   }else{
//                                     return const SizedBox(height: 0,);
//                                   }
//                                 },
//                               ),
//                             ),
//                           ),
//                         )
//                       ),
//                       isGuestLoggedInListener
//                       ? BackdropFilter(filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0), child: const MiscLoginToContinue(),)
//                       : const SizedBox(height: 0),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   showKeyboard({bool isReply = false, String toReply = '',  String replyFrom = ''}){
//     return SafeArea(
//       top: false,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20.0,),
//         child: isReply == true
//         ? SizedBox(
//           height: 200,
//           child: Column(
//             children: [
//               Expanded(
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: SingleChildScrollView(
//                         padding: const EdgeInsets.only(top: 10.0),
//                         physics: const ClampingScrollPhysics(),
//                         child: Align(
//                           alignment: Alignment.topLeft,
//                           child: RichText(
//                             text: TextSpan(
//                               children: <TextSpan>[
//                                 const TextSpan(text: 'Replying to ', style: TextStyle(color: Color(0xff888888,), fontSize: 24, fontFamily: 'NexaRegular',),),

//                                 TextSpan(text: '$replyFrom\n', style: const TextStyle(color: Color(0xff000000), fontSize: 24, fontFamily: 'NexaRegular', fontWeight: FontWeight.bold)),

//                                 TextSpan(text: toReply, style: const TextStyle(color: Color(0xff000000), fontSize: 24, fontFamily: 'NexaRegular',),),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),

//                     Align(
//                       alignment: Alignment.topRight,
//                       child: IconButton(
//                         icon: const Icon(Icons.close),
//                         onPressed: (){
//                           Navigator.pop(context);
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               Row(
//                 children: [
//                   currentUserImage != ''
//                   ? CircleAvatar(
//                     backgroundColor: const Color(0xff888888),
//                     foregroundImage: NetworkImage(currentUserImage),
//                   )
//                   : const CircleAvatar(
//                     backgroundColor: Color(0xff888888),
//                     foregroundImage: AssetImage('assets/icons/user-placeholder.png'),
//                   ),

//                   Expanded(
//                     child: Padding(
//                       padding: const EdgeInsets.all(10.0),
//                       child: TextFormField(
//                         controller: controller,
//                         style: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xffFFFFFF),),
//                         keyboardType: TextInputType.text,
//                         cursorColor: const Color(0xffFFFFFF),
//                         maxLines: 2,
//                         decoration: const InputDecoration(
//                           filled: true,
//                           labelText: 'Say something...',
//                           fillColor: Color(0xffBDC3C7),
//                           floatingLabelBehavior: FloatingLabelBehavior.never,
//                           labelStyle: TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xffFFFFFF),),
//                           border: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffBDC3C7),), borderRadius: BorderRadius.all(Radius.circular(10)),),
//                           focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffBDC3C7),), borderRadius: BorderRadius.all(Radius.circular(10)),),
//                         ),
//                       ),
//                     ),
//                   ),

//                   GestureDetector(
//                     child: const Text('Post', style: TextStyle(fontSize: 24, fontFamily: 'NexaBold', color: Color(0xff2F353D),),),
//                     onTap: () async{
//                       if(controller.text == ''){
//                         await showDialog(
//                           context: context,
//                           builder: (context) => CustomDialog(
//                             image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
//                             title: 'Error',
//                             description: 'Please input a comment.',
//                             okButtonColor: const Color(0xfff44336), // RED
//                             includeOkButton: true,
//                           ),
//                         );
//                       }else if(isComment == true && controller.text != ''){
//                         print('Here 1');
//                         context.loaderOverlay.show();
//                         await apiRegularAddComment(postId: widget.postId, commentBody: controller.text);
//                         context.loaderOverlay.hide();

//                         controller.clear();
//                         itemRemaining = 1;
//                         repliesRemaining = 1;
//                         comments.value = [];
//                         replies.value = [];
//                         numberOfReplies = 0;
//                         page1 = 1;
//                         page2 = 1;
//                         count.value = 0;
//                         commentsLikes = [];
//                         commentsNumberOfLikes = [];
//                         repliesLikes = [];
//                         repliesNumberOfLikes = [];
//                         isComment = true;
//                         numberOfLikes = 0;
//                         numberOfComments = 0;
//                         getOriginalPostInformation();
//                         // onLoading();
//                       }else{
//                         print('Here 2');
//                         context.loaderOverlay.show();
//                         await apiRegularAddReply(commentId: currentCommentId, replyBody: controller.text);
//                         context.loaderOverlay.hide();

//                         controller.clear();
//                         itemRemaining = 1;
//                         repliesRemaining = 1;
//                         comments.value = [];
//                         replies.value = [];
//                         numberOfReplies = 0;
//                         page1 = 1;
//                         page2 = 1;
//                         count.value = 0;
//                         commentsLikes = [];
//                         commentsNumberOfLikes = [];
//                         repliesLikes = [];
//                         repliesNumberOfLikes = [];
//                         isComment = true;
//                         numberOfLikes = 0;
//                         numberOfComments = 0;
//                         getOriginalPostInformation();
//                         // onLoading();
//                       }
//                     },
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         )
//         : Row(
//           children: [
//             currentUserImage != ''
//             ? CircleAvatar(
//               backgroundColor: const Color(0xff888888),
//               foregroundImage: NetworkImage(currentUserImage),
//             )
//             : const CircleAvatar(
//               backgroundColor: Color(0xff888888),
//               foregroundImage: AssetImage('assets/icons/user-placeholder.png'),
//             ),
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.all(10.0),
//                 child: TextFormField(
//                   controller: controller,
//                   cursorColor: const Color(0xffFFFFFF),
//                   maxLines: 2,
//                   keyboardType: TextInputType.text,
//                   style: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xffFFFFFF),),
//                   decoration: const InputDecoration(
//                     filled: true,
//                     fillColor: Color(0xffBDC3C7),
//                     labelText: 'Say something...',
//                     floatingLabelBehavior: FloatingLabelBehavior.never,
//                     labelStyle: TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xffFFFFFF),),
//                     border: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffBDC3C7),), borderRadius: BorderRadius.all(Radius.circular(10)),),
//                     focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffBDC3C7),), borderRadius: BorderRadius.all(Radius.circular(10)),),
//                   ),
//                 ),
//               ),
//             ),

//             GestureDetector(
//               child: const Text('Post', style: TextStyle(fontSize: 24, fontFamily: 'NexaBold', color: Color(0xff2F353D),),),
//               onTap: () async{
//                 if(controller.text == ''){
//                   await showDialog(
//                     context: context,
//                     builder: (context) => CustomDialog(
//                       image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
//                       title: 'Error',
//                       description: 'Please input a comment.',
//                       okButtonColor: const Color(0xfff44336), // RED
//                       includeOkButton: true,
//                     ),
//                   );
//                 }else if(isComment == true && controller.text != ''){
//                   print('Here 3');
//                   context.loaderOverlay.show();
//                   await apiRegularAddComment(postId: widget.postId, commentBody: controller.text);

//                   controller.clear();
//                   itemRemaining = 1;
//                   repliesRemaining = 1;
//                   comments.value = [];
//                   replies.value = [];
//                   numberOfReplies = 0; //
//                   page1 = 1;
//                   page2 = 1;
//                   count.value = 0; //
//                   commentsLikes = [];
//                   commentsNumberOfLikes = [];
//                   repliesLikes = [];
//                   repliesNumberOfLikes = [];
//                   isComment = true;
//                   numberOfLikes = 0;
//                   numberOfComments = 0;
//                   getOriginalPostInformation();
//                   // onLoading();

//                   context.loaderOverlay.hide();

//                   // controller.clear();
//                   // itemRemaining = 1;
//                   // repliesRemaining = 1;
//                   // comments.value = [];
//                   // replies.value = [];
//                   // numberOfReplies = 0;
//                   // page1 = 1;
//                   // page2 = 1;
//                   // count.value = 0;
//                   // commentsLikes = [];
//                   // commentsNumberOfLikes = [];
//                   // repliesLikes = [];
//                   // repliesNumberOfLikes = [];
//                   // isComment = true;
//                   // numberOfLikes = 0;
//                   // numberOfComments = 0;
//                   // getOriginalPostInformation();
//                   // onLoading();
//                 }else{
//                   print('Here 4');
//                   context.loaderOverlay.show();
//                   await apiRegularAddReply(commentId: currentCommentId, replyBody: controller.text);
//                   controller.clear();
//                   itemRemaining = 1;
//                   repliesRemaining = 1;
//                   comments.value = [];
//                   replies.value = [];
//                   numberOfReplies = 0;
//                   page1 = 1;
//                   page2 = 1;
//                   count.value = 0;
//                   commentsLikes = [];
//                   commentsNumberOfLikes = [];
//                   repliesLikes = [];
//                   repliesNumberOfLikes = [];
//                   isComment = true;
//                   numberOfLikes = 0;
//                   numberOfComments = 0;
//                   getOriginalPostInformation();
//                   // onLoading();
//                   context.loaderOverlay.hide();

//                   // controller.clear();
//                   // itemRemaining = 1;
//                   // repliesRemaining = 1;
//                   // comments.value = [];
//                   // replies.value = [];
//                   // numberOfReplies = 0;
//                   // page1 = 1;
//                   // page2 = 1;
//                   // count.value = 0;
//                   // commentsLikes = [];
//                   // commentsNumberOfLikes = [];
//                   // repliesLikes = [];
//                   // repliesNumberOfLikes = [];
//                   // isComment = true;
//                   // numberOfLikes = 0;
//                   // numberOfComments = 0;
//                   // getOriginalPostInformation();
//                   // onLoading();
//                 }
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   showKeyboardEdit({required bool isEdit, required int editId}){
//     // isEdit - TRUE (COMMENT) | FALSE (REPLY)
//     return SafeArea(
//       top: false,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20.0,),
//         child: Row(
//           children: [
//             currentUserImage != ''
//             ? CircleAvatar(
//               backgroundColor: const Color(0xff888888),
//               foregroundImage: NetworkImage(currentUserImage),
//             )
//             : const CircleAvatar(
//               backgroundColor: Color(0xff888888),
//               foregroundImage: AssetImage('assets/icons/user-placeholder.png'),
//             ),

//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.all(10.0),
//                 child: TextFormField(
//                   controller: controller,
//                   cursorColor: const Color(0xffFFFFFF),
//                   maxLines: 2,
//                   keyboardType: TextInputType.text,
//                   style: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xffFFFFFF),),
//                   decoration: const InputDecoration(
//                     filled: true,
//                     fillColor: Color(0xffBDC3C7),
//                     labelText: 'Say something...',
//                     floatingLabelBehavior: FloatingLabelBehavior.never,
//                     labelStyle: TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xffFFFFFF),),
//                     border: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffBDC3C7),), borderRadius: BorderRadius.all(Radius.circular(10)),),
//                     focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffBDC3C7),), borderRadius: BorderRadius.all(Radius.circular(10)),),
//                   ),
//                 ),
//               ),
//             ),

//             GestureDetector(
//               child: const Text('Post', style: TextStyle(fontSize: 24, fontFamily: 'NexaBold', color: Color(0xff2F353D),),),
//               onTap: () async{
//                 if(controller.text == ''){
//                   await showDialog(
//                     context: context,
//                     builder: (context) => CustomDialog(
//                       image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
//                       title: 'Error',
//                       description: 'Please input a comment.',
//                       okButtonColor: const Color(0xfff44336), // RED
//                       includeOkButton: true,
//                     ),
//                   );
//                 }else if(isEdit == true){
//                   context.loaderOverlay.show();
//                   await apiRegularEditComment(commentId: editId, commentBody: controller.text);
//                   context.loaderOverlay.hide();

//                   controller.clear();
//                   itemRemaining = 1;
//                   repliesRemaining = 1;
//                   comments.value = [];
//                   replies.value = [];
//                   numberOfReplies = 0;
//                   page1 = 1;
//                   page2 = 1;
//                   count.value = 0;
//                   commentsLikes = [];
//                   commentsNumberOfLikes = [];
//                   repliesLikes = [];
//                   repliesNumberOfLikes = [];
//                   isComment = true;
//                   numberOfLikes = 0;
//                   numberOfComments = 0;
//                   getOriginalPostInformation();
//                   // onLoading();
//                 }else{
//                   context.loaderOverlay.show();
//                   await apiRegularEditReply(replyId: editId, replyBody: controller.text);
//                   context.loaderOverlay.hide();

//                   controller.clear();
//                   itemRemaining = 1;
//                   repliesRemaining = 1;
//                   comments.value = [];
//                   replies.value = [];
//                   numberOfReplies = 0;
//                   page1 = 1;
//                   page2 = 1;
//                   count.value = 0;
//                   commentsLikes = [];
//                   commentsNumberOfLikes = [];
//                   repliesLikes = [];
//                   repliesNumberOfLikes = [];
//                   isComment = true;
//                   numberOfLikes = 0;
//                   numberOfComments = 0;
//                   getOriginalPostInformation();
//                   // onLoading();
//                 }
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


// ================================================================================================================================================================================================================

import 'package:facesbyplaces/API/Regular/02-Main/api_main_regular_02_show_user_information.dart';
import 'package:facesbyplaces/API/Regular/12-Show-Post/api_show_post_regular_01_show_original_post.dart';
import 'package:facesbyplaces/API/Regular/12-Show-Post/api_show_post_regular_02_show_post_comments.dart';
import 'package:facesbyplaces/API/Regular/12-Show-Post/api_show_post_regular_02_show_post_comments_2.dart';
import 'package:facesbyplaces/API/Regular/12-Show-Post/api_show_post_regular_03_show_comment_replies.dart';
import 'package:facesbyplaces/API/Regular/12-Show-Post/api_show_post_regular_03_show_comment_replies_2.dart';
import 'package:facesbyplaces/API/Regular/12-Show-Post/api_show_post_regular_04_show_comment_or_reply_like_status.dart';
import 'package:facesbyplaces/API/Regular/12-Show-Post/api_show_post_regular_06_add_comment.dart';
import 'package:facesbyplaces/API/Regular/12-Show-Post/api_show_post_regular_07_add_reply.dart';
import 'package:facesbyplaces/API/Regular/12-Show-Post/api_show_post_regular_08_comment_reply_like_or_unlike.dart';
import 'package:facesbyplaces/API/Regular/12-Show-Post/api_show_post_regular_09_delete_comment.dart';
import 'package:facesbyplaces/API/Regular/12-Show-Post/api_show_post_regular_10_edit_comment.dart';
import 'package:facesbyplaces/API/Regular/12-Show-Post/api_show_post_regular_11_delete_reply.dart';
import 'package:facesbyplaces/API/Regular/12-Show-Post/api_show_post_regular_12_edit_reply.dart';
import 'package:facesbyplaces/UI/Home/BLM/02-View-Memorial/home_view_memorial_blm_01_managed_memorial.dart';
import 'package:facesbyplaces/UI/Home/BLM/02-View-Memorial/home_view_memorial_blm_02_profile_memorial.dart';
import 'package:facesbyplaces/UI/Home/Regular/02-View-Memorial/home_view_memorial_regular_01_managed_memorial.dart';
import 'package:facesbyplaces/UI/Home/Regular/02-View-Memorial/home_view_memorial_regular_02_profile_memorial.dart';
import 'package:facesbyplaces/UI/Home/Regular/02-View-Memorial/home_view_memorial_regular_04_maps.dart';
import 'package:facesbyplaces/UI/Home/Regular/06-Report/home_report_regular_01_report.dart';
import 'package:facesbyplaces/UI/Home/Regular/12-Show-User/home_show_user_regular_01_user.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc_03_regular_dropdown.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:keyboard_attachable/keyboard_attachable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:extended_image/extended_image.dart';
import 'package:better_player/better_player.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:dialog/dialog.dart';
import 'package:loader/loader.dart';
import 'package:mime/mime.dart';
import 'package:misc/misc.dart';
import 'dart:async';
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
  const HomeRegularShowOriginalPostComments({Key? key, required this.postId}) : super(key: key);

  @override
  HomeRegularShowOriginalPostCommentsState createState() => HomeRegularShowOriginalPostCommentsState();
}

class HomeRegularShowOriginalPostCommentsState extends State<HomeRegularShowOriginalPostComments>{
  ValueNotifier<List<RegularOriginalComment>> comments = ValueNotifier<List<RegularOriginalComment>>([]);
  ValueNotifier<List<RegularOriginalReply>> replies = ValueNotifier<List<RegularOriginalReply>>([]);
  GlobalKey profileKey = GlobalKey<HomeRegularShowOriginalPostCommentsState>();
  CarouselController buttonCarouselController = CarouselController();
  TextEditingController controller = TextEditingController(text: '');
  ValueNotifier<bool> isGuestLoggedIn = ValueNotifier<bool>(true);
  Future<APIRegularShowOriginalPostMain>? showOriginalPost;
  Future<APIRegularShowListOfComments>? showListOfComments;
  ScrollController scrollController = ScrollController();
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
  int numberOfLikes = 0;
  bool likePost = false;
  int? currentUserId;
  int likesCount = 0;
  int page1 = 1;
  int page2 = 1;
  StreamController<APIRegularShowListOfCommentsDuplicate> streamControllerListOfComments = StreamController<APIRegularShowListOfCommentsDuplicate>();
  StreamController<APIRegularShowListOfRepliesDuplicate> streamControllerListOfReplies = StreamController<APIRegularShowListOfRepliesDuplicate>();
  Timer? timer;
  Stream<APIRegularShowListOfCommentsDuplicate>? stream;

  @override
  void initState(){
    super.initState();
    stream = streamControllerListOfComments.stream;
    // getListOfComments();
    isGuest();
    likesCount = numberOfLikes;
    // getListOfComments();
    timer = Timer.periodic(const Duration(seconds: 10), (Timer t) => getListOfComments());
    // timer = Timer.periodic(const Duration(seconds: 10), (Timer t) => getListOfReplies(commentId: 35));
    // stream!.listen((event) async{
    //   print('hereee');
    //   APIRegularShowListOfCommentsDuplicate newValue = await apiRegularShowListOfCommentsDuplicate(postId: widget.postId);
    //   streamControllerListOfComments.add(newValue);
    //   print('stream!');
    // });
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
      // onLoading();
      scrollController.addListener((){
        if(scrollController.position.pixels == scrollController.position.maxScrollExtent){
          if(itemRemaining != 0){
            // onLoading();
          }else{
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No more comments to show'), duration: Duration(seconds: 1), backgroundColor: Color(0xff4EC9D4),),);
          }
        }
      });
    }
  }

  // Future<void> onRefresh() async{
  //   // onLoading();
  //   print('refreshed');
  //   setState(() {});
  // }

  Future<void> onRefresh() async{
    print('refreshed');
    setState(() {});
  }


  void getOriginalPostInformation() async{
    var originalPostInformation = await apiRegularShowOriginalPost(postId: widget.postId);
    numberOfLikes = originalPostInformation.almPost.showOriginalPostNumberOfLikes;
    numberOfComments = originalPostInformation.almPost.showOriginalPostNumberOfComments;
    likePost = originalPostInformation.almPost.showOriginalPostLikeStatus;
    pageName = originalPostInformation.almPost.showOriginalPostPage.showOriginalPostPageName;
  }

  void getProfilePicture() async{
    var getProfilePicture = await apiRegularShowProfileInformation();
    currentUserImage = getProfilePicture.showProfileInformationImage;
    currentUserId = getProfilePicture.showProfileInformationUserId;
    currentAccountType = getProfilePicture.showProfileInformationAccountType;
  }

  Future<APIRegularShowOriginalPostMain> getOriginalPost(postId) async{
    return await apiRegularShowOriginalPost(postId: postId);
  }

  Stream<APIRegularShowListOfCommentsDuplicate> getListOfComments() async* {
    APIRegularShowListOfCommentsDuplicate newValue = await apiRegularShowListOfCommentsDuplicate(postId: widget.postId);
    // streamControllerListOfComments.add(newValue);
    print('stream here here');
    yield newValue;
  }

  getListOfReplies({required int commentId}) async{
    APIRegularShowListOfRepliesDuplicate newValue = await apiRegularShowListOfRepliesDuplicate(postId: commentId);
    streamControllerListOfReplies.add(newValue);
  }

  // Stream<APIRegularShowListOfRepliesDuplicate> getListOfReplies({required int commentId}){
  //   APIRegularShowListOfRepliesDuplicate? newValue;
  //   callFunction() async{
  //     newValue = await apiRegularShowListOfRepliesDuplicate(postId: commentId);
  //     print('hehehe');
  //   }

  //   callFunction();
    
  //   streamControllerListOfReplies.add(newValue!);
  //   return streamControllerListOfReplies.stream;
  // }

  Future<APIRegularShowCommentOrReplyLikeStatus> getShowCommentOrReplyLikeStatus({required String commentableType, required int commentId}) async{
    APIRegularShowCommentOrReplyLikeStatus? newValue;
    newValue = await apiRegularShowCommentOrReplyLikeStatus(commentableType: commentableType, commentableId: commentId);

    if(commentableType == 'Comment'){
      commentsLikes.add(newValue.showCommentOrReplyLikeStatus);
      commentsNumberOfLikes.add(newValue.showCommentOrReplyNumberOfLikes);
    }

    return newValue;
  } 

  // Future<APIRegularShowListOfReplies> getListOfReplies({required int commentId}) async{
  //   APIRegularShowListOfReplies? newValue;
  //   while(repliesRemaining != 0){
  //     newValue = await apiRegularShowListOfReplies(postId: commentId, page: page2);
  //     page2++;
  //     repliesRemaining = newValue.almItemsRemaining;
  //   }

  //   page2 = 0;
  //   return newValue!;
  // }

  @override
    void dispose(){
      streamControllerListOfComments.close();
      super.dispose();
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
        child: ValueListenableBuilder(
          valueListenable: isGuestLoggedIn,
          builder: (_, bool isGuestLoggedInListener, __) => ValueListenableBuilder(
            valueListenable: count,
            builder: (_, int countListener, __) => ValueListenableBuilder(
              valueListenable: comments,
              builder: (_, List<RegularOriginalComment> commentsListener, __) => ValueListenableBuilder(
                valueListenable: replies,
                builder: (_, List<RegularOriginalReply> repliesListener, __) => Scaffold(
                  appBar: AppBar(
                    backgroundColor: const Color(0xff04ECFF),
                    title: const Text('Post', style: TextStyle(fontSize: 26, fontFamily: 'NexaRegular', color: Color(0xffffffff),),),
                    centerTitle: false,
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Color(0xffffffff), size: 35),
                      onPressed: (){
                        Navigator.pop(context, numberOfComments);
                      },
                    ),
                    actions: [
                      MiscRegularDropDownTemplate(postId: widget.postId, likePost: likePost, likesCount: likesCount, reportType: 'Post', pageType: 'Alm', pageName: pageName),
                    ],
                  ),
                  backgroundColor: const Color(0xffffffff),
                  body: Stack(
                    children: [
                      isGuestLoggedInListener
                      ? const SizedBox(height: 0,)

                                              // child: FutureBuilder<APIRegularShowOriginalPostMain>(
                        //   future: showOriginalPost,
                        //   builder: (context, originalPost){
                        //     if(originalPost.connectionState != ConnectionState.done){
                        //       return const Center(child: CustomLoader(),);
                        //     }
                        //     else if(originalPost.hasData){
                        //       // return SafeArea(
                        //       //   child: FooterLayout(
                        //       //     footer: showKeyboard(),
                        //       //     child: RefreshIndicator(
                        //       //       onRefresh: onRefresh,
                        //       //       child: 
                        //       //     ),
                        //       //   ),
                        //       // );
                        //     }else if(originalPost.hasError) {
                        //       return const MiscErrorMessageTemplate();
                        //     }else{
                        //       return const SizedBox(height: 0,);
                        //     }
                        //   },
                        // ),
                      : IgnorePointer(
                        ignoring: isGuestLoggedInListener,
                        child: SafeArea(
                          child: FooterLayout(
                            footer: showKeyboard(),
                            child: RefreshIndicator(
                              onRefresh: onRefresh,
                              child: FutureBuilder<APIRegularShowOriginalPostMain>(
                                future: showOriginalPost,
                                builder: (context, originalPost){
                                  if(originalPost.connectionState != ConnectionState.done){
                                    return const Center(child: CustomLoader(),);
                                  }
                                  else if(originalPost.hasError){
                                    return const MiscErrorMessageTemplate();
                                  }
                                  else if(originalPost.hasData){
                                    return CustomScrollView(
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
                                                      child: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageProfileImage != ''
                                                      ? CircleAvatar(
                                                        backgroundColor: const Color(0xff888888),
                                                        foregroundImage: NetworkImage(originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageProfileImage),
                                                      )
                                                      : const CircleAvatar(
                                                        backgroundColor: Color(0xff888888),
                                                        foregroundImage: AssetImage('assets/icons/app-icon.png'),
                                                      ),
                                                      onTap: () async{
                                                        if(originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPagePageType == 'Memorial'){
                                                          if(originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageManage == true || originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageFamOrFriends == true){
                                                            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularProfile(memorialId: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageId, relationship: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageRelationship, managed: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageManage, newlyCreated: false,),),);
                                                          }else{
                                                            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularMemorialProfile(memorialId: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageId, pageType: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPagePageType, newJoin: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageFollower,),),);
                                                          }
                                                        }else{
                                                          if(originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageManage == true || originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageFamOrFriends == true){
                                                            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMProfile(memorialId: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageId, relationship: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageRelationship, managed: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageManage,newlyCreated: false,),),);
                                                          }else{
                                                            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMMemorialProfile(memorialId: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageId, pageType: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPagePageType, newJoin: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageFollower,),),);
                                                          }
                                                        }
                                                      },
                                                    ),

                                                    Expanded(
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(left: 10.0),
                                                        child: GestureDetector(
                                                          child: Column(
                                                            children: [
                                                              Expanded(
                                                                child: Align(
                                                                  alignment: Alignment.bottomLeft,
                                                                  child: Text(originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageName,
                                                                    overflow: TextOverflow.ellipsis,
                                                                    style: const TextStyle(fontSize: 22, fontFamily: 'NexaBold', color: Color(0xff000000),),
                                                                  ),
                                                                ),
                                                              ),

                                                              Expanded(
                                                                child: Align(
                                                                  alignment: Alignment.topLeft,
                                                                  child: Text(timeago.format(DateTime.parse(originalPost.data!.almPost.showOriginalPostCreatedAt),),
                                                                    maxLines: 1,
                                                                    style: const TextStyle(fontSize: 18, fontFamily: 'NexaBold', color: Color(0xffBDC3C7),),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          onTap: () async{
                                                            if(originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPagePageType == 'Memorial'){
                                                              if(originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageManage == true || originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageFamOrFriends == true){
                                                                Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularProfile(memorialId: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageId, relationship: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageRelationship, managed: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageManage, newlyCreated: false,),),);
                                                              }else{
                                                                Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularMemorialProfile(memorialId: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageId, pageType: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPagePageType, newJoin: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageFollower,),),);
                                                              }
                                                            }else{
                                                              if(originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageManage == true || originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageFamOrFriends == true){
                                                                Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMProfile(memorialId: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageId, relationship: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageRelationship, managed: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageManage, newlyCreated: false,),),);
                                                              }else{
                                                                Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMMemorialProfile(memorialId: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageId, pageType: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPagePageType, newJoin: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageFollower,),));
                                                              }
                                                            }
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              Container(
                                                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                                                alignment: Alignment.centerLeft,
                                                child: Text(originalPost.data!.almPost.showOriginalPostBody, style: const TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xff000000),),),
                                              ),

                                              originalPost.data!.almPost.showOriginalPostImagesOrVideos.isNotEmpty
                                              ? Column(
                                                children: [
                                                  const SizedBox(height: 20),

                                                  SizedBox(
                                                    child: ((){
                                                      if(originalPost.data!.almPost.showOriginalPostImagesOrVideos.length == 1){
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
                                                                            child: ((){
                                                                              if(lookupMimeType(originalPost.data!.almPost.showOriginalPostImagesOrVideos[0])?.contains('video') == true){
                                                                                return BetterPlayer.network('${originalPost.data!.almPost.showOriginalPostImagesOrVideos[0]}',
                                                                                  betterPlayerConfiguration: BetterPlayerConfiguration(
                                                                                    placeholder: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 16 / 9),
                                                                                    placeholderOnTop: false,
                                                                                    deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
                                                                                    aspectRatio: 16 / 9,
                                                                                    fit: BoxFit.contain,
                                                                                  ),
                                                                                );
                                                                              }else{
                                                                                return ExtendedImage.network(
                                                                                  originalPost.data!.almPost.showOriginalPostImagesOrVideos[0],
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
                                                            if(lookupMimeType(originalPost.data!.almPost.showOriginalPostImagesOrVideos[0])?.contains('video') == true){
                                                              return BetterPlayer.network('${originalPost.data!.almPost.showOriginalPostImagesOrVideos[0]}',
                                                                betterPlayerConfiguration: BetterPlayerConfiguration(
                                                                  placeholder: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 16 / 9),
                                                                  aspectRatio: 16 / 9,
                                                                  fit: BoxFit.contain,
                                                                  controlsConfiguration: const BetterPlayerControlsConfiguration(showControls: false,),
                                                                ),
                                                              );
                                                            }else{
                                                              return CachedNetworkImage(
                                                                fit: BoxFit.cover,
                                                                imageUrl: originalPost.data!.almPost.showOriginalPostImagesOrVideos[0],
                                                                placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                                errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                              );
                                                            }
                                                          }()),
                                                        );
                                                      }else if(originalPost.data!.almPost.showOriginalPostImagesOrVideos.length == 2){
                                                        return StaggeredGridView.countBuilder(
                                                          staggeredTileBuilder: (int index) => const StaggeredTile.count(2, 2),
                                                          physics: const NeverScrollableScrollPhysics(),
                                                          padding: EdgeInsets.zero,
                                                          crossAxisSpacing: 4.0,
                                                          mainAxisSpacing: 4.0,
                                                          crossAxisCount: 4,
                                                          shrinkWrap: true,
                                                          itemCount: 2,
                                                          itemBuilder: (BuildContext context, int index) => GestureDetector(
                                                            child: ((){
                                                              if(lookupMimeType(originalPost.data!.almPost.showOriginalPostImagesOrVideos[index])?.contains('video') == true){
                                                                return BetterPlayer.network('${originalPost.data!.almPost.showOriginalPostImagesOrVideos[index]}',
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
                                                                  imageUrl: originalPost.data!.almPost.showOriginalPostImagesOrVideos[index],
                                                                  placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                                  errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                                );
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
                                                                                  originalPost.data!.almPost.showOriginalPostImagesOrVideos.length, (next) => ((){
                                                                                    if(lookupMimeType(originalPost.data!.almPost.showOriginalPostImagesOrVideos[next])?.contains('video') == true){
                                                                                      return BetterPlayer.network('${originalPost.data!.almPost.showOriginalPostImagesOrVideos[index]}',
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
                                                                                        originalPost.data!.almPost.showOriginalPostImagesOrVideos[next],
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
                                                                return lookupMimeType(originalPost.data!.almPost.showOriginalPostImagesOrVideos[index])?.contains('video') == true 
                                                                ? BetterPlayer.network('${originalPost.data!.almPost.showOriginalPostImagesOrVideos[index]}',
                                                                  betterPlayerConfiguration: BetterPlayerConfiguration(
                                                                    placeholder: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 16 / 9),
                                                                    controlsConfiguration: const BetterPlayerControlsConfiguration(showControls: false,),
                                                                    aspectRatio: 16 / 9,
                                                                    fit: BoxFit.contain,
                                                                  ),
                                                                )
                                                                : CachedNetworkImage(
                                                                  fit: BoxFit.cover,
                                                                  imageUrl: originalPost.data!.almPost.showOriginalPostImagesOrVideos[index],
                                                                  placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
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
                                                                              child: Text('${originalPost.data!.almPost.showOriginalPostImagesOrVideos.length - 3}', style: const TextStyle(fontSize: 32, fontFamily: 'NexaBold', color: Color(0xffFFFFFF),),),
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
                                                                            placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                                            errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                                          ),

                                                                          Container(color: const Color(0xff000000).withOpacity(0.5),),

                                                                          Center(
                                                                            child: CircleAvatar(
                                                                              radius: 25,
                                                                              backgroundColor: const Color(0xffffffff).withOpacity(.5),
                                                                              child: Text('${originalPost.data!.almPost.showOriginalPostImagesOrVideos.length - 3}', style: const TextStyle(fontSize: 32, fontFamily: 'NexaBold', color: Color(0xffFFFFFF),),),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      );
                                                                    }
                                                                  }else{
                                                                    if(lookupMimeType(originalPost.data!.almPost.showOriginalPostImagesOrVideos[index])?.contains('video') == true){
                                                                      return BetterPlayer.network('${originalPost.data!.almPost.showOriginalPostImagesOrVideos[index]}',
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
                                                                        imageUrl: originalPost.data!.almPost.showOriginalPostImagesOrVideos[index],
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
                                                                                  originalPost.data!.almPost.showOriginalPostImagesOrVideos.length, (next) => ((){
                                                                                    if(lookupMimeType(originalPost.data!.almPost.showOriginalPostImagesOrVideos[next])?.contains('video') == true){
                                                                                      return BetterPlayer.network('${originalPost.data!.almPost.showOriginalPostImagesOrVideos[next]}',
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
                                                                                        originalPost.data!.almPost.showOriginalPostImagesOrVideos[next],
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

                                                  const SizedBox(height: 20),
                                                ],
                                              )
                                              : Container(color: const Color(0xffff0000), height: 0,),

                                              originalPost.data!.almPost.showOriginalPostPostTagged.isNotEmpty
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
                                                              originalPost.data!.almPost.showOriginalPostPostTagged.length, (index) => TextSpan(
                                                                style: const TextStyle(fontSize: 18, fontFamily: 'NexaBold', color: Color(0xff000000),),
                                                                children: <TextSpan>[
                                                                  TextSpan(text: originalPost.data!.almPost.showOriginalPostPostTagged[index].showOriginalPostTaggedFirstName + ' ' + originalPost.data!.almPost.showOriginalPostPostTagged[index].showOriginalPostTaggedLastName,
                                                                  recognizer: TapGestureRecognizer()
                                                                    ..onTap = (){
                                                                      Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularUserProfile(userId: originalPost.data!.almPost.showOriginalPostPostTagged[index].showOriginalPostTaggedId, accountType: originalPost.data!.almPost.showOriginalPostPostTagged[index].showOriginalPostAccountType)));
                                                                    },
                                                                  ),
                                                                  index < originalPost.data!.almPost.showOriginalPostPostTagged.length - 1 ? const TextSpan(text: ', ') : const TextSpan(text: ''),
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

                                              originalPost.data!.almPost.showOriginalPostLocation != ''
                                              ? Column(
                                                children: [
                                                  const SizedBox(height: 10,),

                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                                    child: Row(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        const Icon(Icons.place, color: Color(0xff888888)),

                                                        Expanded(
                                                          child: GestureDetector(
                                                            child: Text(originalPost.data!.almPost.showOriginalPostLocation, style: const TextStyle(fontSize: 18, fontFamily: 'NexaBold', color: Color(0xff000000),),),
                                                            onTap: (){
                                                              Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularMaps(latitude: originalPost.data!.almPost.showOriginalPostLatitude, longitude: originalPost.data!.almPost.showOriginalPostLongitude, isMemorial: false, memorialName: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageName, memorialImage: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageProfileImage,)));
                                                            },
                                                          ),  
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              )
                                              : const SizedBox(height: 0,),

                                              Container(
                                                height: 40,
                                                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        likePost == true
                                                        ? const FaIcon(FontAwesomeIcons.heart, color: Color(0xffE74C3C),)
                                                        : const FaIcon(FontAwesomeIcons.heart, color: Color(0xff000000),),

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

                                        SliverToBoxAdapter( // COMMENTS AND REPLIES
                                          child: StreamBuilder<APIRegularShowListOfCommentsDuplicate>(
                                            // stream: streamControllerListOfComments.stream,
                                            stream: getListOfComments(),
                                            builder: (context, listOfComments){
                                              if(listOfComments.hasData){
                                                return Column(
                                                  children: List.generate(listOfComments.data!.almCommentsList.length, (i) => ListTile(
                                                    visualDensity: const VisualDensity(vertical: 4.0),
                                                    leading: listOfComments.data!.almCommentsList[i].showListOfCommentsUser.showListOfCommentsUserImage != ''
                                                    ? CircleAvatar(
                                                      backgroundColor: const Color(0xff888888),
                                                      foregroundImage: NetworkImage(listOfComments.data!.almCommentsList[i].showListOfCommentsUser.showListOfCommentsUserImage),
                                                    )
                                                    : const CircleAvatar(
                                                      backgroundColor: Color(0xff888888),
                                                      foregroundImage: AssetImage('assets/icons/user-placeholder.png'),
                                                    ),
                                                    title: Row(
                                                      children: [
                                                        Expanded(
                                                          child: currentUserId == listOfComments.data!.almCommentsList[i].showListOfCommentsUser.showListOfCommentsUserId && currentAccountType == listOfComments.data!.almCommentsList[i].showListOfCommentsUser.showListOfCommentsUserAccountType
                                                          ? const Text('You', style: TextStyle(fontSize: 20, fontFamily: 'NexaBold', color: Color(0xff000000),),)
                                                          : Text('${listOfComments.data!.almCommentsList[i].showListOfCommentsUser.showListOfCommentsUserFirstName} ${listOfComments.data!.almCommentsList[i].showListOfCommentsUser.showListOfCommentsUserLastName}', style: const TextStyle(fontSize: 20, fontFamily: 'NexaBold', color: Color(0xff000000),),),
                                                        ),

                                                        Expanded(
                                                          child: Align(
                                                            alignment: Alignment.centerRight,
                                                            child: TextButton.icon(
                                                              onPressed: (){},
                                                              icon: const FaIcon(FontAwesomeIcons.heart, color: Color(0xff888888),),
                                                              label: const Text('0', style: TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xffBDC3C7),),),
                                                            ),
                                                          )
                                                        ),

                                                        // Expanded(
                                                        //   child: FutureBuilder<APIRegularShowCommentOrReplyLikeStatus>(
                                                        //     future: getShowCommentOrReplyLikeStatus(commentableType: 'Comment', commentId: listOfComments.data!.almCommentsList[i].showListOfCommentsCommentId),
                                                        //     builder: (context, listOfCommentOrReplyLikeStatus){
                                                        //       // commentsLikes.add(listOfCommentOrReplyLikeStatus.data!.showCommentOrReplyLikeStatus);
                                                        //       // commentsNumberOfLikes.add(listOfCommentOrReplyLikeStatus.data!.showCommentOrReplyNumberOfLikes);
                                                        //       if(listOfCommentOrReplyLikeStatus.connectionState != ConnectionState.done){
                                                        //         return const Center(child: CustomLoader(),);
                                                        //       }
                                                        //       if(listOfCommentOrReplyLikeStatus.hasError){
                                                        //         return const SizedBox(height: 0,);
                                                        //       }
                                                        //       if(listOfCommentOrReplyLikeStatus.hasData){
                                                        //         return Align(
                                                        //           alignment: Alignment.centerRight,
                                                        //           child: TextButton.icon(
                                                        //             onPressed: () async{
                                                        //               // if(listOfCommentOrReplyLikeStatus.data!.showCommentOrReplyLikeStatus){
                                                        //               //   commentsLikes[i] = false;
                                                        //               //   commentsNumberOfLikes[i]--;

                                                        //               //   await apiRegularLikeOrUnlikeCommentReply(commentableType: 'Comment', commentableId: commentsListener[i].commentId, likeStatus: false);
                                                        //               // }else{
                                                        //               //   commentsLikes[i] = true;
                                                        //               //   commentsNumberOfLikes[i]++;

                                                        //               //   await apiRegularLikeOrUnlikeCommentReply(commentableType: 'Comment', commentableId: commentsListener[i].commentId, likeStatus: true);
                                                        //               // }

                                                        //               if(commentsLikes[i] == true){
                                                        //                 commentsLikes[i] = false;
                                                        //                 commentsNumberOfLikes[i]--;

                                                        //                 await apiRegularLikeOrUnlikeCommentReply(commentableType: 'Comment', commentableId: commentsListener[i].commentId, likeStatus: false);
                                                        //               }else{
                                                        //                 commentsLikes[i] = true;
                                                        //                 commentsNumberOfLikes[i]++;

                                                        //                 await apiRegularLikeOrUnlikeCommentReply(commentableType: 'Comment', commentableId: commentsListener[i].commentId, likeStatus: true);
                                                        //               }
                                                        //             },
                                                        //             icon: listOfCommentOrReplyLikeStatus.data!.showCommentOrReplyLikeStatus == true
                                                        //             ? const FaIcon(FontAwesomeIcons.solidHeart, color: Color(0xffE74C3C),)
                                                        //             : const FaIcon(FontAwesomeIcons.heart, color: Color(0xff888888),),
                                                        //             label: Text('${commentsNumberOfLikes[i]}', style: const TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xffBDC3C7),),),
                                                        //           ),
                                                        //         );
                                                        //       }else{
                                                        //         return Align(
                                                        //           alignment: Alignment.centerRight,
                                                        //           child: TextButton.icon(
                                                        //             onPressed: (){},
                                                        //             icon: const FaIcon(FontAwesomeIcons.heart, color: Color(0xff888888),),
                                                        //             label: const Text('0', style: TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xffBDC3C7),),),
                                                        //           ),
                                                        //         );
                                                        //       }
                                                        //     }
                                                        //   ),
                                                        // ),
                                                      ],
                                                    ),
                                                    subtitle: Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                              child: Container(
                                                                padding: const EdgeInsets.all(10.0),
                                                                child: Text(listOfComments.data!.almCommentsList[i].showListOfCommentsCommentBody, style: const TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xffFFFFFF),),),
                                                                decoration: const BoxDecoration(color: Color(0xff4EC9D4), borderRadius: BorderRadius.all(Radius.circular(10.0)),),
                                                              ),
                                                            ),
                                                          ],
                                                        ),

                                                        const SizedBox(height: 5,),

                                                        Row(
                                                          children: [
                                                            Text(timeago.format(DateTime.parse(listOfComments.data!.almCommentsList[i].showListOfCommentsCreatedAt)), style: const TextStyle(fontSize: 18, fontFamily: 'NexaRegular', color: Color(0xff000000),),),

                                                            const SizedBox(width: 20,),

                                                            GestureDetector(
                                                              child: const Text('Reply', style: TextStyle(fontSize: 18, fontFamily: 'NexaRegular', color: Color(0xff000000),),),
                                                              onTap: () async{
                                                                // if(controller.text != ''){
                                                                //   controller.clear();
                                                                // }

                                                                // isComment = false;
                                                                // currentCommentId = commentsListener[i].commentId;

                                                                // await showModalBottomSheet(context: context, builder: (context) => showKeyboard(
                                                                //   isReply: true, 
                                                                //   toReply: commentsListener[i].commentBody, 
                                                                //   replyFrom: '${commentsListener[i].firstName}' '${commentsListener[i].lastName}')
                                                                // );
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                        
                                                        const SizedBox(height: 20,),

                                                        // StreamBuilder<APIRegularShowListOfRepliesDuplicate>(
                                                        //   // stream: getListOfReplies(commentId: listOfComments.data!.almCommentsList[i].showListOfCommentsCommentId),
                                                        //   stream: streamControllerListOfReplies.stream,
                                                        //   builder: (context, listOfReplies){
                                                        //     if(listOfReplies.hasData){
                                                        //       return Column(
                                                        //         children: List.generate(listOfReplies.data!.almRepliesList.length, (index) => ListTile(
                                                        //           contentPadding: EdgeInsets.zero,
                                                        //           visualDensity: const VisualDensity(vertical: 4.0),
                                                        //           leading: listOfReplies.data!.almRepliesList[index].showListOfRepliesUser.showListRepliesUserImage != ''
                                                        //             ? CircleAvatar(
                                                        //               backgroundColor: const Color(0xff888888),
                                                        //               foregroundImage: NetworkImage(listOfReplies.data!.almRepliesList[index].showListOfRepliesUser.showListRepliesUserImage),
                                                        //             )
                                                        //             : const CircleAvatar(
                                                        //               backgroundColor: Color(0xff888888),
                                                        //               foregroundImage: AssetImage('assets/icons/user-placeholder.png'),
                                                        //             ),
                                                        //             title: Row(
                                                        //               children: [
                                                        //                 Expanded(
                                                        //                   child: currentUserId == listOfReplies.data!.almRepliesList[index].showListOfRepliesUser.showListRepliesUserUserId && currentAccountType == listOfReplies.data!.almRepliesList[index].showListOfRepliesUser.showListOfCommentsUserAccountType
                                                        //                   ? const Text('You', style: TextStyle(fontSize: 20, fontFamily: 'NexaBold', color: Color(0xff000000),),)
                                                        //                   : Text(listOfReplies.data!.almRepliesList[index].showListOfRepliesUser.showListRepliesUserFirstName + ' ' + listOfReplies.data!.almRepliesList[index].showListOfRepliesUser.showListRepliesUserLastName, style: const TextStyle(fontSize: 20, fontFamily: 'NexaBold', color: Color(0xff000000)),),
                                                        //                 ),

                                                        //                 // Expanded(
                                                        //                 //   child: FutureBuilder<APIRegularShowCommentOrReplyLikeStatus>(
                                                        //                 //     future: getShowCommentOrReplyLikeStatus(commentableType: 'Reply', commentId: listOfReplies.data!.almRepliesList[index].showListOfRepliesReplyId),
                                                        //                 //     builder: (context, listOfReplyLikeStatus){
                                                        //                 //       if(listOfReplyLikeStatus.connectionState != ConnectionState.done){
                                                        //                 //         return const SizedBox(height: 0,);
                                                        //                 //       }else if(listOfReplyLikeStatus.hasError){
                                                        //                 //         return const SizedBox(height: 0,);
                                                        //                 //       }
                                                        //                 //       else if(listOfReplyLikeStatus.hasData){
                                                        //                 //         return Align(
                                                        //                 //           alignment: Alignment.centerRight,
                                                        //                 //           child: TextButton.icon(
                                                        //                 //             onPressed: () async{
                                                        //                 //               // if(commentsLikes[i] == true){
                                                        //                 //               //   commentsLikes[i] = false;
                                                        //                 //               //   commentsNumberOfLikes[i]--;

                                                        //                 //               //   await apiRegularLikeOrUnlikeCommentReply(commentableType: 'Comment', commentableId: commentsListener[i].commentId, likeStatus: false);
                                                        //                 //               // }else{
                                                        //                 //               //   commentsLikes[i] = true;
                                                        //                 //               //   commentsNumberOfLikes[i]++;

                                                        //                 //               //   await apiRegularLikeOrUnlikeCommentReply(commentableType: 'Comment', commentableId: commentsListener[i].commentId, likeStatus: true);
                                                        //                 //               // }
                                                        //                 //             },
                                                        //                 //             icon: listOfReplyLikeStatus.data!.showCommentOrReplyLikeStatus == true
                                                        //                 //             ? const FaIcon(FontAwesomeIcons.solidHeart, color: Color(0xffE74C3C),)
                                                        //                 //             : const FaIcon(FontAwesomeIcons.heart, color: Color(0xff888888),),
                                                        //                 //             label: Text('${listOfReplyLikeStatus.data!.showCommentOrReplyNumberOfLikes}', style: const TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xffBDC3C7),),),
                                                        //                 //           ),
                                                        //                 //         );
                                                        //                 //       }else{
                                                        //                 //         return Align(
                                                        //                 //           alignment: Alignment.centerRight,
                                                        //                 //           child: TextButton.icon(
                                                        //                 //             onPressed: (){},
                                                        //                 //             icon: const FaIcon(FontAwesomeIcons.heart, color: Color(0xff888888),),
                                                        //                 //             label: const Text('0', style: TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xffBDC3C7),),),
                                                        //                 //           ),
                                                        //                 //         );
                                                        //                 //       }
                                                        //                 //     }
                                                        //                 //   ),
                                                        //                 // ),

                                                        //                 // Expanded(
                                                        //                 //   child: Align(
                                                        //                 //     alignment: Alignment.centerRight,
                                                        //                 //     child: TextButton.icon(
                                                        //                 //       onPressed: () async{
                                                        //                 //         // if(repliesLikes[i][index] == true){
                                                        //                 //         //   repliesLikes[i][index] = false;
                                                        //                 //         //   repliesNumberOfLikes[i][index]--;

                                                        //                 //         //   await apiRegularLikeOrUnlikeCommentReply(commentableType: 'Reply', commentableId: commentsListener[i].listOfReplies[index].replyId, likeStatus: false);
                                                        //                 //         // }else{
                                                        //                 //         //   repliesLikes[i][index] = true;
                                                        //                 //         //   repliesNumberOfLikes[i][index]++;

                                                        //                 //         //   await apiRegularLikeOrUnlikeCommentReply(commentableType: 'Reply', commentableId: commentsListener[i].listOfReplies[index].replyId, likeStatus: true);
                                                        //                 //         // }
                                                        //                 //       },
                                                        //                 //       icon: repliesLikes[i][index] == true
                                                        //                 //       ? const FaIcon(FontAwesomeIcons.solidHeart, color: Color(0xffE74C3C),)
                                                        //                 //       : const FaIcon(FontAwesomeIcons.heart, color: Color(0xff888888),),
                                                        //                 //       label: Text('${repliesNumberOfLikes[i][index]}', style: const TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xffBDC3C7),),),
                                                        //                 //     ),
                                                        //                 //   ),
                                                        //                 // ),
                                                        //               ],
                                                        //             ),
                                                        //             subtitle: Column(
                                                        //               children: [
                                                        //                 Row(
                                                        //                   children: [
                                                        //                     Expanded(
                                                        //                       child: Container(
                                                        //                         padding: const EdgeInsets.all(10.0),
                                                        //                         child: Text(listOfReplies.data!.almRepliesList[index].showListOfRepliesReplyBody, style: const TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xffFFFFFF),),),
                                                        //                         decoration: const BoxDecoration(color: Color(0xff4EC9D4), borderRadius: BorderRadius.all(Radius.circular(10.0)),),
                                                        //                       ),
                                                        //                     ),
                                                        //                   ],
                                                        //                 ),

                                                        //                 const SizedBox(height: 5,),

                                                        //                 Row(
                                                        //                   children: [
                                                        //                     Text(timeago.format(DateTime.parse(listOfReplies.data!.almRepliesList[index].showListOfRepliesCreatedAt),), style: const TextStyle(fontSize: 18, fontFamily: 'NexaRegular', color: Color(0xff000000),),),

                                                        //                     const SizedBox(width: 40,),

                                                        //                     GestureDetector(
                                                        //                       child: const Text('Reply', style: TextStyle(fontSize: 18, fontFamily: 'NexaRegular', color: Color(0xff000000),),),
                                                        //                       onTap: () async{
                                                        //                         // if(controller.text != ''){
                                                        //                         //   controller.clear();
                                                        //                         // }

                                                        //                         // controller.text = commentsListener[i].firstName + ' ' + commentsListener[i].lastName + ' ';
                                                        //                         // isComment = false;
                                                        //                         // currentCommentId = commentsListener[i].commentId;

                                                        //                         // await showModalBottomSheet(context: context, builder: (context) => showKeyboard(isReply: true, toReply: commentsListener[i].listOfReplies[index].replyBody, replyFrom: '${commentsListener[i].listOfReplies[index].firstName} ${commentsListener[i].listOfReplies[index].lastName}'));
                                                        //                       },
                                                        //                     ),
                                                        //                   ],
                                                        //                 ),
                                                        //               ],
                                                        //             ),
                                                        //             onTap: (){
                                                        //               // Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularUserProfile(userId: commentsListener[i].listOfReplies[index].userId, accountType: currentAccountType,),),);
                                                        //             },
                                                        //             onLongPress: () async{
                                                        //               // if(currentUserId == commentsListener[i].listOfReplies[index].userId && currentAccountType == commentsListener[i].listOfReplies[index].userAccountType){
                                                        //               //   await showMaterialModalBottomSheet(
                                                        //               //     context: context,
                                                        //               //     builder: (context) => SafeArea(
                                                        //               //       top: false,
                                                        //               //       child: Column(
                                                        //               //         mainAxisSize: MainAxisSize.min,
                                                        //               //         children: <Widget>[
                                                        //               //           ListTile(
                                                        //               //             title: const Text('Edit'),
                                                        //               //             leading: const Icon(Icons.edit),
                                                        //               //             onTap: () async{
                                                        //               //               controller.text = controller.text + commentsListener[i].listOfReplies[index].replyBody;
                                                        //               //               await showModalBottomSheet(
                                                        //               //                 context: context,
                                                        //               //                 builder: (context) => showKeyboardEdit(isEdit: false, editId: commentsListener[i].listOfReplies[index].replyId),
                                                        //               //               );
                                                        //               //             },
                                                        //               //           ),
                                                        //               //           ListTile(
                                                        //               //             title: const Text('Delete'),
                                                        //               //             leading: const Icon(Icons.delete),
                                                        //               //             onTap: () async{
                                                        //               //               context.loaderOverlay.show();
                                                        //               //               await apiRegularDeleteReply(replyId: commentsListener[i].listOfReplies[index].replyId);
                                                        //               //               context.loaderOverlay.hide();

                                                        //               //               controller.clear();
                                                        //               //               itemRemaining = 1;
                                                        //               //               repliesRemaining = 1;
                                                        //               //               comments.value = [];
                                                        //               //               replies.value = [];
                                                        //               //               numberOfReplies = 0;
                                                        //               //               page1 = 1;
                                                        //               //               page2 = 1;
                                                        //               //               count.value = 0;
                                                        //               //               commentsLikes = [];
                                                        //               //               commentsNumberOfLikes = [];
                                                        //               //               repliesLikes = [];
                                                        //               //               repliesNumberOfLikes = [];
                                                        //               //               isComment = true;
                                                        //               //               numberOfLikes = 0;
                                                        //               //               numberOfComments = 0;
                                                        //               //               getOriginalPostInformation();
                                                        //               //               onLoading();
                                                        //               //               Navigator.pop(context);
                                                        //               //             },
                                                        //               //           )
                                                        //               //         ],
                                                        //               //       ),
                                                        //               //     ),
                                                        //               //   );
                                                        //               // }else{
                                                        //               //   await showMaterialModalBottomSheet(
                                                        //               //     context: context,
                                                        //               //     builder: (context) => SafeArea(
                                                        //               //       top: false,
                                                        //               //       child: Column(
                                                        //               //         mainAxisSize: MainAxisSize.min,
                                                        //               //         children: <Widget>[
                                                        //               //           ListTile(
                                                        //               //             title: const Text('Report'),
                                                        //               //             leading: const Icon(Icons.edit),
                                                        //               //             onTap: (){
                                                        //               //               Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularReport(postId: widget.postId, reportType: 'Post')));
                                                        //               //             },
                                                        //               //           ),
                                                        //               //         ],
                                                        //               //       ),
                                                        //               //     ),
                                                        //               //   );
                                                        //               // }
                                                        //             },
                                                        //           ),
                                                        //         ),
                                                        //       );
                                                        //     }else if(listOfReplies.hasError){
                                                        //       return const SizedBox(height: 0,);
                                                        //     }else{
                                                        //       return const SizedBox(height: 0,);
                                                        //     }
                                                        //   }
                                                        // ),
                                                      ],
                                                    ),
                                                    // onTap: (){
                                                    //   Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularUserProfile(userId: commentsListener[i].userId, accountType: commentsListener[i].userAccountType,)));
                                                    // },
                                                    // onLongPress: () async{
                                                    //   if(currentUserId == commentsListener[i].userId && currentAccountType == commentsListener[i].userAccountType){
                                                    //     await showMaterialModalBottomSheet(
                                                    //       context: context,
                                                    //       builder: (context) => SafeArea(
                                                    //         top: false,
                                                    //         child: Column(
                                                    //           mainAxisSize: MainAxisSize.min,
                                                    //           children: <Widget>[
                                                    //             ListTile(
                                                    //               title: const Text('Edit'),
                                                    //               leading: const Icon(Icons.edit),
                                                    //               onTap: () async {
                                                    //                 controller.text = controller.text + commentsListener[i].commentBody;
                                                    //                 await showModalBottomSheet(
                                                    //                   context: context,
                                                    //                   builder: (context) => showKeyboardEdit(isEdit: true, editId: commentsListener[i].commentId),
                                                    //                 );
                                                    //               },
                                                    //             ),

                                                    //             ListTile(
                                                    //               title: const Text('Delete'),
                                                    //               leading: const Icon(Icons.delete),
                                                    //               onTap: () async{
                                                    //                 context.loaderOverlay.show();
                                                    //                 await apiRegularDeleteComment(commentId: commentsListener[i].commentId);
                                                    //                 context.loaderOverlay.hide();

                                                    //                 controller.clear();
                                                    //                 itemRemaining = 1;
                                                    //                 repliesRemaining = 1;
                                                    //                 comments.value = [];
                                                    //                 replies.value = [];
                                                    //                 numberOfReplies = 0;
                                                    //                 page1 = 1;
                                                    //                 page2 = 1;
                                                    //                 count.value = 0;
                                                    //                 commentsLikes = [];
                                                    //                 commentsNumberOfLikes = [];
                                                    //                 repliesLikes = [];
                                                    //                 repliesNumberOfLikes = [];
                                                    //                 isComment = true;
                                                    //                 numberOfLikes = 0;
                                                    //                 numberOfComments = 0;
                                                    //                 getOriginalPostInformation();
                                                    //                 onLoading();
                                                    //                 Navigator.pop(context);
                                                    //               },
                                                    //             )
                                                    //           ],
                                                    //         ),
                                                    //       ),
                                                    //     );
                                                    //   }else{
                                                    //     await showMaterialModalBottomSheet(
                                                    //       context: context,
                                                    //       builder: (context) => SafeArea(
                                                    //         top: false,
                                                    //         child: Column(
                                                    //           mainAxisSize: MainAxisSize.min,
                                                    //           children: <Widget>[
                                                    //             ListTile(
                                                    //               title: const Text('Report'),
                                                    //               leading: const Icon(Icons.edit),
                                                    //               onTap: (){
                                                    //                 Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularReport(postId: widget.postId, reportType: 'Post')));
                                                    //               },
                                                    //             ),
                                                    //           ],
                                                    //         ),
                                                    //       ),
                                                    //     );
                                                    //   }
                                                    // },
                                                  ),
                                                ),
                                                );
                                              }else if(listOfComments.hasError){
                                                return const MiscErrorMessageTemplate();
                                              }else{
                                                return const SizedBox(height: 0,);
                                              }
                                            }
                                          ),
                                        ),
                                      ],
                                    );
                                  }else{
                                    return const SizedBox(height: 0,);
                                  }
                                },
                              ),
                            ),
                          ),
                        )
                      ),
                      isGuestLoggedInListener
                      ? BackdropFilter(filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0), child: const MiscLoginToContinue(),)
                      : const SizedBox(height: 0),
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
        padding: const EdgeInsets.symmetric(horizontal: 20.0,),
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
                                const TextSpan(text: 'Replying to ', style: TextStyle(color: Color(0xff888888,), fontSize: 24, fontFamily: 'NexaRegular',),),

                                TextSpan(text: '$replyFrom\n', style: const TextStyle(color: Color(0xff000000), fontSize: 24, fontFamily: 'NexaRegular', fontWeight: FontWeight.bold)),

                                TextSpan(text: toReply, style: const TextStyle(color: Color(0xff000000), fontSize: 24, fontFamily: 'NexaRegular',),),
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
                        keyboardType: TextInputType.text,
                        cursorColor: const Color(0xffFFFFFF),
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
                          builder: (context) => CustomDialog(
                            image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                            title: 'Error',
                            description: 'Please input a comment.',
                            okButtonColor: const Color(0xfff44336), // RED
                            includeOkButton: true,
                          ),
                        );
                      }else if(isComment == true && controller.text != ''){
                        print('Here 1');
                        context.loaderOverlay.show();
                        await apiRegularAddComment(postId: widget.postId, commentBody: controller.text);
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
                        // onLoading();
                      }else{
                        print('Here 2');
                        context.loaderOverlay.show();
                        await apiRegularAddReply(commentId: currentCommentId, replyBody: controller.text);
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
                        // onLoading();
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
                  cursorColor: const Color(0xffFFFFFF),
                  maxLines: 2,
                  keyboardType: TextInputType.text,
                  style: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xffFFFFFF),),
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Color(0xffBDC3C7),
                    labelText: 'Say something...',
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
                    builder: (context) => CustomDialog(
                      image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                      title: 'Error',
                      description: 'Please input a comment.',
                      okButtonColor: const Color(0xfff44336), // RED
                      includeOkButton: true,
                    ),
                  );
                }else if(isComment == true && controller.text != ''){
                  print('Here 3');
                  context.loaderOverlay.show();
                  await apiRegularAddComment(postId: widget.postId, commentBody: controller.text);

                  controller.clear();
                  itemRemaining = 1;
                  repliesRemaining = 1;
                  comments.value = [];
                  replies.value = [];
                  numberOfReplies = 0; //
                  page1 = 1;
                  page2 = 1;
                  count.value = 0; //
                  commentsLikes = [];
                  commentsNumberOfLikes = [];
                  repliesLikes = [];
                  repliesNumberOfLikes = [];
                  isComment = true;
                  numberOfLikes = 0;
                  numberOfComments = 0;
                  getOriginalPostInformation();
                  // onLoading();

                  context.loaderOverlay.hide();

                  // controller.clear();
                  // itemRemaining = 1;
                  // repliesRemaining = 1;
                  // comments.value = [];
                  // replies.value = [];
                  // numberOfReplies = 0;
                  // page1 = 1;
                  // page2 = 1;
                  // count.value = 0;
                  // commentsLikes = [];
                  // commentsNumberOfLikes = [];
                  // repliesLikes = [];
                  // repliesNumberOfLikes = [];
                  // isComment = true;
                  // numberOfLikes = 0;
                  // numberOfComments = 0;
                  // getOriginalPostInformation();
                  // onLoading();
                }else{
                  print('Here 4');
                  context.loaderOverlay.show();
                  await apiRegularAddReply(commentId: currentCommentId, replyBody: controller.text);
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
                  // onLoading();
                  context.loaderOverlay.hide();

                  // controller.clear();
                  // itemRemaining = 1;
                  // repliesRemaining = 1;
                  // comments.value = [];
                  // replies.value = [];
                  // numberOfReplies = 0;
                  // page1 = 1;
                  // page2 = 1;
                  // count.value = 0;
                  // commentsLikes = [];
                  // commentsNumberOfLikes = [];
                  // repliesLikes = [];
                  // repliesNumberOfLikes = [];
                  // isComment = true;
                  // numberOfLikes = 0;
                  // numberOfComments = 0;
                  // getOriginalPostInformation();
                  // onLoading();
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
        padding: const EdgeInsets.symmetric(horizontal: 20.0,),
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
                  cursorColor: const Color(0xffFFFFFF),
                  maxLines: 2,
                  keyboardType: TextInputType.text,
                  style: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xffFFFFFF),),
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Color(0xffBDC3C7),
                    labelText: 'Say something...',
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
                    builder: (context) => CustomDialog(
                      image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                      title: 'Error',
                      description: 'Please input a comment.',
                      okButtonColor: const Color(0xfff44336), // RED
                      includeOkButton: true,
                    ),
                  );
                }else if(isEdit == true){
                  context.loaderOverlay.show();
                  await apiRegularEditComment(commentId: editId, commentBody: controller.text);
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
                  // onLoading();
                }else{
                  context.loaderOverlay.show();
                  await apiRegularEditReply(replyId: editId, replyBody: controller.text);
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
                  // onLoading();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}