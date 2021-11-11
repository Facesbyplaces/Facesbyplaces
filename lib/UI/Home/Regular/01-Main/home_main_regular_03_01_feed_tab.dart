// import 'package:facesbyplaces/API/Regular/02-Main/api_main_regular_04_01_home_feed_tab.dart';
// import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc_02_regular_post.dart';
// import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc_02_blm_post.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
// import 'package:facesbyplaces/Configurations/size_configuration.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:loader_overlay/loader_overlay.dart';
// import 'package:better_player/better_player.dart';
// import 'package:timeago/timeago.dart' as timeago;
// import 'package:flutter/material.dart';
// import 'package:dialog/dialog.dart';
// import 'package:mime/mime.dart';
// import 'package:misc/misc.dart';

// class RegularMainPagesFeeds{
//   final int userId;
//   final int postId;
//   final int memorialId;
//   final String memorialName;
//   final String timeCreated;
//   final String postBody;
//   final dynamic profileImage;
//   final List<dynamic> imagesOrVideos;
//   final bool managed;
//   final bool joined;
//   final int numberOfLikes;
//   final int numberOfComments;
//   final bool likeStatus;
//   final int numberOfTagged;
//   final List<String> taggedFirstName;
//   final List<String> taggedLastName;
//   final List<String> taggedImage;
//   final List<int> taggedId;
//   final String pageType;
//   final bool famOrFriends;
//   final String relationship;
//   final String location;
//   final double latitude;
//   final double longitude;
//   const RegularMainPagesFeeds({required this.userId, required this.postId, required this.memorialId, required this.memorialName, required this.timeCreated, required this.postBody, required this.profileImage, required this.imagesOrVideos, required this.managed, required this.joined, required this.numberOfComments, required this.numberOfLikes, required this.likeStatus, required this.numberOfTagged, required this.taggedFirstName, required this.taggedLastName, required this.taggedImage, required this.taggedId, required this.pageType, required this.famOrFriends, required this.relationship, required this.location, required this.latitude, required this.longitude});
// }

// class HomeRegularFeedTab extends StatefulWidget{
//   const HomeRegularFeedTab({Key? key}) : super(key: key);

//   @override
//   HomeRegularFeedTabState createState() => HomeRegularFeedTabState();
// }

// class HomeRegularFeedTabState extends State<HomeRegularFeedTab>{
//   ValueNotifier<List<RegularMainPagesFeeds>> feeds = ValueNotifier<List<RegularMainPagesFeeds>>([]);
//   ValueNotifier<bool> isGuestLoggedIn = ValueNotifier<bool>(false);
//   ScrollController scrollController = ScrollController();
//   ValueNotifier<int> count = ValueNotifier<int>(0);
//   int itemRemaining = 1;
//   int page = 1;

//   @override
//   void initState(){
//     super.initState();
//     isGuest();
//     scrollController.addListener((){ // SHOWS WHEN THE USER HAS REACHED THE BOTTOM OF THE LIST
//       if(scrollController.position.pixels == scrollController.position.maxScrollExtent){
//         if(itemRemaining != 0){
//           onLoading();
//         }else{
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text('No more feeds to show'),
//               duration: Duration(seconds: 1),
//               backgroundColor: Color(0xff4EC9D4),
//             ),
//           );
//         }
//       }
//     });
//   }

//   Future<void> onRefresh() async{ // PULL TO REFRESH FUNCTIONALITY
//     page = 1;
//     itemRemaining = 1;
//     count.value = 0;
//     feeds.value = [];
//     onLoading();
//   }

//   void isGuest() async{ // CHECKS IF THE USER IS A GUEST
//     final sharedPrefs = await SharedPreferences.getInstance();
//     isGuestLoggedIn.value = sharedPrefs.getBool('user-guest-session') ?? false;

//     if(isGuestLoggedIn.value != true){
//       onLoading();
//     }
//   }

//   void onLoading() async{ // FETCHING THE DATA
//     if(itemRemaining != 0){
//       context.loaderOverlay.show();
//       var newValue = await apiRegularHomeFeedTab(page: page).onError((error, stackTrace){
//         context.loaderOverlay.hide();
//         showDialog(
//           context: context,
//           builder: (context) => CustomDialog(
//             image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
//             title: 'Error',
//             description: 'Error: $error.',
//             okButtonColor: const Color(0xfff44336), // RED
//             includeOkButton: true,
//           ),
//         );
//         throw Exception('$error');
//       });
//       context.loaderOverlay.hide();

//       itemRemaining = newValue.almItemsRemaining;
//       count.value = count.value + newValue.almFamilyMemorialList.length;

//       for(int i = 0; i < newValue.almFamilyMemorialList.length; i++){
//         List<String> newList1 = [];
//         List<String> newList2 = [];
//         List<String> newList3 = [];
//         List<int> newList4 = [];
//         for(int j = 0; j < newValue.almFamilyMemorialList[i].homeTabFeedPostTagged.length; j++){
//           newList1.add(newValue.almFamilyMemorialList[i].homeTabFeedPostTagged[j].homeTabFeedTaggedFirstName);
//           newList2.add(newValue.almFamilyMemorialList[i].homeTabFeedPostTagged[j].homeTabFeedTaggedLastName);
//           newList3.add(newValue.almFamilyMemorialList[i].homeTabFeedPostTagged[j].homeTabFeedTaggedImage);
//           newList4.add(newValue.almFamilyMemorialList[i].homeTabFeedPostTagged[j].homeTabFeedTaggedId);
//         }

//         feeds.value.add(
//           RegularMainPagesFeeds(
//             userId: newValue.almFamilyMemorialList[i].homeTabFeedPage.homeTabFeedPagePageCreator.homeTabFeedPageCreatorId,
//             postId: newValue.almFamilyMemorialList[i].homeTabFeedId,
//             memorialId: newValue.almFamilyMemorialList[i].homeTabFeedPage.homeTabFeedPageId,
//             timeCreated: newValue.almFamilyMemorialList[i].homeTabFeedCreatedAt,
//             memorialName: newValue.almFamilyMemorialList[i].homeTabFeedPage.homeTabFeedPageName,
//             postBody: newValue.almFamilyMemorialList[i].homeTabFeedBody,
//             profileImage: newValue.almFamilyMemorialList[i].homeTabFeedPage.homeTabFeedPageProfileImage,
//             imagesOrVideos: newValue.almFamilyMemorialList[i].homeTabFeedImagesOrVideos,
//             managed: newValue.almFamilyMemorialList[i].homeTabFeedPage.homeTabFeedPageManage,
//             joined: newValue.almFamilyMemorialList[i].homeTabFeedPage.homeTabFeedPageFollower,
//             numberOfComments: newValue.almFamilyMemorialList[i].homeTabFeedNumberOfComments,
//             numberOfLikes: newValue.almFamilyMemorialList[i].homeTabFeedNumberOfLikes,
//             likeStatus: newValue.almFamilyMemorialList[i].homeTabFeedLikeStatus,
//             numberOfTagged: newValue.almFamilyMemorialList[i].homeTabFeedPostTagged.length,
//             taggedFirstName: newList1,
//             taggedLastName: newList2,
//             taggedImage: newList3,
//             taggedId: newList4,
//             pageType: newValue.almFamilyMemorialList[i].homeTabFeedPage.homeTabFeedPagePageType,
//             famOrFriends: newValue.almFamilyMemorialList[i].homeTabFeedPage.homeTabFeedPageFamOrFriends,
//             relationship: newValue.almFamilyMemorialList[i].homeTabFeedPage.homeTabFeedPageRelationship,
//             location: newValue.almFamilyMemorialList[i].homeTabFeedLocation,
//             latitude: newValue.almFamilyMemorialList[i].homeTabFeedLatitude,
//             longitude: newValue.almFamilyMemorialList[i].homeTabFeedLongitude,
//           ),
//         );
//       }

//       if(mounted){
//         page++;
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context){
//     SizeConfig.init(context);
//     return ValueListenableBuilder(
//       valueListenable: isGuestLoggedIn,
//       builder: (_, bool isGuestLoggedInListener, __) => ValueListenableBuilder(
//         valueListenable: feeds,
//         builder: (_, List<RegularMainPagesFeeds> feedsListener, __) => ValueListenableBuilder(
//           valueListenable: count,
//           builder: (_, int countListener, __) => countListener != 0
//           ? SafeArea(
//             child: RefreshIndicator(
//               onRefresh: onRefresh,
//               child: ListView.separated(
//                 controller: scrollController,
//                 separatorBuilder: (c, i) => const Divider(height: 10, color: Colors.transparent),
//                 physics: const ClampingScrollPhysics(),
//                 padding: const EdgeInsets.all(10.0),
//                 itemCount: countListener,
//                 itemBuilder: (c, i){
//                   return feedsListener[i].pageType == 'Blm'
//                   ? MiscBLMPost(
//                     key: ValueKey('$i'),
//                     userId: feedsListener[i].userId,
//                     postId: feedsListener[i].postId,
//                     memorialId: feedsListener[i].memorialId,
//                     memorialName: feedsListener[i].memorialName,
//                     timeCreated: timeago.format(DateTime.parse(feedsListener[i].timeCreated)),
//                     managed: feedsListener[i].managed,
//                     joined: feedsListener[i].joined,
//                     profileImage: feedsListener[i].profileImage,
//                     numberOfComments: feedsListener[i].numberOfComments,
//                     numberOfLikes: feedsListener[i].numberOfLikes,
//                     likeStatus: feedsListener[i].likeStatus,
//                     numberOfTagged: feedsListener[i].numberOfTagged,
//                     taggedFirstName: feedsListener[i].taggedFirstName,
//                     taggedLastName: feedsListener[i].taggedLastName,
//                     taggedId: feedsListener[i].taggedId,
//                     pageType: feedsListener[i].pageType,
//                     famOrFriends: feedsListener[i].famOrFriends,
//                     relationship: feedsListener[i].relationship,
//                     location: feedsListener[i].location,
//                     latitude: feedsListener[i].latitude,
//                     longitude: feedsListener[i].longitude,
//                     contents: [
//                       Align(alignment: Alignment.centerLeft, child: Text(feedsListener[i].postBody, overflow: TextOverflow.ellipsis, maxLines: 5, style: const TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xff000000),),),),
                          
//                       feedsListener[i].imagesOrVideos.isNotEmpty
//                       ? Column(
//                         children: [
//                           const SizedBox(height: 20),
                          
//                           SizedBox(
//                             child: ((){
//                               if(feedsListener[i].imagesOrVideos.length == 1){
//                                 if(lookupMimeType(feedsListener[i].imagesOrVideos[0])?.contains('video') == true){
//                                   return BetterPlayer.network('${feedsListener[i].imagesOrVideos[0]}',
//                                     betterPlayerConfiguration: BetterPlayerConfiguration(
//                                       placeholder: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 16 / 9),
//                                       controlsConfiguration: const BetterPlayerControlsConfiguration(showControls: false,),
//                                       aspectRatio: 16 / 9,
//                                       fit: BoxFit.contain,
//                                     ),
//                                   );
//                                 }else{
//                                   return CachedNetworkImage(
//                                     fit: BoxFit.cover,
//                                     imageUrl: feedsListener[i].imagesOrVideos[0],
//                                     placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
//                                     errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
//                                   );
//                                 }
//                               }else if(feedsListener[i].imagesOrVideos.length == 2){
//                                 return StaggeredGridView.countBuilder(
//                                   staggeredTileBuilder:(int index) => const StaggeredTile.count(2, 2),
//                                   physics: const NeverScrollableScrollPhysics(),
//                                   padding: EdgeInsets.zero,
//                                   crossAxisSpacing: 4.0,
//                                   mainAxisSpacing: 4.0,
//                                   crossAxisCount: 4,
//                                   shrinkWrap: true,
//                                   itemCount: 2,
//                                   itemBuilder: (BuildContext context, int index) => lookupMimeType(feedsListener[i].imagesOrVideos[index])?.contains('video') == true
//                                   ? BetterPlayer.network('${feedsListener[i].imagesOrVideos[index]}',
//                                       betterPlayerConfiguration: BetterPlayerConfiguration(placeholder: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 16 / 9),
//                                       controlsConfiguration: const BetterPlayerControlsConfiguration(showControls: false,),
//                                       aspectRatio: 16 / 9,
//                                       fit: BoxFit.contain,
//                                     ),
//                                   )
//                                   : CachedNetworkImage(
//                                     fit: BoxFit.cover, 
//                                     imageUrl: feedsListener[i].imagesOrVideos[index],
//                                     placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
//                                     errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,scale: 1.0,),
//                                   ),
//                                 );
//                               }else{
//                                 return StaggeredGridView.countBuilder(
//                                   staggeredTileBuilder: (int index) => StaggeredTile.count(2, index.isEven ? 1 : 2),
//                                   physics: const NeverScrollableScrollPhysics(),
//                                   padding: EdgeInsets.zero,
//                                   crossAxisSpacing: 4.0,
//                                   mainAxisSpacing: 4.0,
//                                   crossAxisCount: 4,
//                                   shrinkWrap: true,
//                                   itemCount: 3,
//                                   itemBuilder: (BuildContext context, int index) => 
//                                   ((){
//                                     if(index != 1){
//                                       return lookupMimeType(feedsListener[i].imagesOrVideos[index])?.contains('video') == true
//                                       ? BetterPlayer.network('${feedsListener[i].imagesOrVideos[index]}',
//                                         betterPlayerConfiguration: BetterPlayerConfiguration(
//                                           placeholder: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 16 / 9),
//                                           controlsConfiguration: const BetterPlayerControlsConfiguration(showControls: false,),
//                                           aspectRatio: 16 / 9,
//                                           fit: BoxFit.contain,
//                                         ),
//                                       )
//                                       : CachedNetworkImage(
//                                         fit: BoxFit.cover,
//                                         imageUrl: feedsListener[i].imagesOrVideos[index],
//                                         placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
//                                         errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
//                                       );
//                                     }else{
//                                       return ((){
//                                         if(feedsListener[i].imagesOrVideos.length - 3 > 0){
//                                           if(lookupMimeType(feedsListener[i].imagesOrVideos[index])?.contains('video') == true){
//                                             return Stack(
//                                               fit: StackFit.expand,
//                                               children: [
//                                                 BetterPlayer.network('${feedsListener[i].imagesOrVideos[index]}',
//                                                   betterPlayerConfiguration: BetterPlayerConfiguration(
//                                                     placeholder: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 16 / 9),
//                                                     controlsConfiguration: const BetterPlayerControlsConfiguration(showControls: false,),
//                                                     aspectRatio: 16 / 9,
//                                                     fit: BoxFit.contain,
//                                                   ),
//                                                 ),

//                                                 Container(color: const Color(0xff000000).withOpacity(0.5),),

//                                                 Center(
//                                                   child: CircleAvatar(
//                                                     radius: 25,
//                                                     backgroundColor: const Color(0xffffffff).withOpacity(.5),
//                                                     child: Text('${feedsListener[i].imagesOrVideos.length - 3}', style: const TextStyle(fontSize: 32, fontFamily: 'NexaBold', color: Color(0xffFFFFFF),),),
//                                                   ),
//                                                 ),
//                                               ],
//                                             );
//                                           }else{
//                                             return Stack(
//                                               fit: StackFit.expand,
//                                               children: [
//                                                 CachedNetworkImage(
//                                                   fit: BoxFit.cover,
//                                                   imageUrl: feedsListener[i].imagesOrVideos[index],
//                                                   placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
//                                                   errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
//                                                 ),

//                                                 Container(color: const Color(0xff000000).withOpacity(0.5),),
                                                
//                                                 Center(
//                                                   child: CircleAvatar(
//                                                     radius: 25,
//                                                     backgroundColor: const Color(0xffffffff).withOpacity(.5),
//                                                     child: Text('${feedsListener[i].imagesOrVideos.length - 3}', style: const TextStyle(fontSize: 32, fontFamily: 'NexaBold', color: Color(0xffFFFFFF),),),
//                                                   ),
//                                                 ),
//                                               ],
//                                             );
//                                           }
//                                         }else{
//                                           if(lookupMimeType(feedsListener[i].imagesOrVideos[index])?.contains('video') == true) {
//                                             return BetterPlayer.network('${feedsListener[i].imagesOrVideos[index]}',
//                                               betterPlayerConfiguration: BetterPlayerConfiguration(
//                                                 placeholder: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 16 / 9),
//                                                 controlsConfiguration: const BetterPlayerControlsConfiguration(showControls: false,),
//                                                 aspectRatio: 16 / 9,
//                                                 fit: BoxFit.contain,
//                                               ),
//                                             );
//                                           }else{
//                                             return CachedNetworkImage(
//                                               fit: BoxFit.cover,
//                                               imageUrl: feedsListener[i].imagesOrVideos[index],
//                                               placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
//                                               errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
//                                             );
//                                           }
//                                         }
//                                       }());
//                                     }
//                                   }()),
//                                 );
//                               }
//                             }()),
//                           ),
//                         ],
//                       )
//                       : const SizedBox(height: 0),
//                     ],
//                   )
//                   : MiscRegularPost(
//                     key: ValueKey('$i'),
//                     userId: feedsListener[i].userId,
//                     postId: feedsListener[i].postId,
//                     memorialId: feedsListener[i].memorialId,
//                     memorialName: feedsListener[i].memorialName,
//                     timeCreated: timeago.format(DateTime.parse(feedsListener[i].timeCreated)),
//                     managed: feedsListener[i].managed,
//                     joined: feedsListener[i].joined,
//                     profileImage: feedsListener[i].profileImage,
//                     numberOfComments: feedsListener[i].numberOfComments,
//                     numberOfLikes: feedsListener[i].numberOfLikes,
//                     likeStatus: feedsListener[i].likeStatus,
//                     numberOfTagged: feedsListener[i].numberOfTagged,
//                     taggedFirstName: feedsListener[i].taggedFirstName,
//                     taggedLastName: feedsListener[i].taggedLastName,
//                     taggedId: feedsListener[i].taggedId,
//                     pageType: feedsListener[i].pageType,
//                     famOrFriends: feedsListener[i].famOrFriends,
//                     relationship: feedsListener[i].relationship,
//                     location: feedsListener[i].location,
//                     latitude: feedsListener[i].latitude,
//                     longitude: feedsListener[i].longitude,
//                     contents: [
//                       Align(alignment: Alignment.centerLeft, child: Text(feedsListener[i].postBody, overflow: TextOverflow.ellipsis, maxLines: 5, style: const TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xff000000),),),),
                      
//                       feedsListener[i].imagesOrVideos.isNotEmpty
//                       ? Column(
//                         children: [
//                           const SizedBox(height: 20),

//                           SizedBox(
//                             child: ((){
//                               if(feedsListener[i].imagesOrVideos.length == 1){
//                                 if(lookupMimeType(feedsListener[i].imagesOrVideos[0])?.contains('video') == true){
//                                   return BetterPlayer.network('${feedsListener[i].imagesOrVideos[0]}',
//                                     betterPlayerConfiguration: BetterPlayerConfiguration(
//                                       placeholder: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 16 / 9),
//                                       controlsConfiguration: const BetterPlayerControlsConfiguration(showControls: false,),
//                                       aspectRatio: 16 / 9,
//                                       fit: BoxFit.contain,
//                                     ),
//                                   );
//                                 }else{
//                                   return CachedNetworkImage(
//                                     fit: BoxFit.cover,
//                                     imageUrl: feedsListener[i].imagesOrVideos[0],
//                                     placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
//                                     errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
//                                   );
//                                 }
//                               }else if(feedsListener[i].imagesOrVideos.length == 2){
//                                 return StaggeredGridView.countBuilder(
//                                   staggeredTileBuilder: (int index) => const StaggeredTile.count(2, 2),
//                                   physics: const NeverScrollableScrollPhysics(),
//                                   padding: EdgeInsets.zero,
//                                   crossAxisSpacing: 4.0,
//                                   mainAxisSpacing: 4.0,
//                                   crossAxisCount: 4,
//                                   shrinkWrap: true,
//                                   itemCount: 2,
//                                   itemBuilder: (BuildContext context, int index) => lookupMimeType(feedsListener[i].imagesOrVideos[index])?.contains('video') == true
//                                   ? BetterPlayer.network('${feedsListener[i].imagesOrVideos[index]}',
//                                     betterPlayerConfiguration: BetterPlayerConfiguration(
//                                       placeholder: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 16 / 9),
//                                       controlsConfiguration: const BetterPlayerControlsConfiguration(showControls: false,),
//                                       aspectRatio: 16 / 9,
//                                       fit: BoxFit.contain,
//                                     ),
//                                   )
//                                   : CachedNetworkImage(
//                                     fit: BoxFit.cover,
//                                     imageUrl: feedsListener[i].imagesOrVideos[index],
//                                     placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
//                                     errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
//                                   ),
//                                 );
//                               }else{
//                                 return StaggeredGridView.countBuilder(
//                                   staggeredTileBuilder: (int index) => StaggeredTile.count(2, index.isEven ? 1 : 2),
//                                   physics: const NeverScrollableScrollPhysics(),
//                                   padding: EdgeInsets.zero,
//                                   crossAxisSpacing: 4.0,
//                                   mainAxisSpacing: 4.0,
//                                   crossAxisCount: 4,
//                                   shrinkWrap: true,
//                                   itemCount: 3,
//                                   itemBuilder: (BuildContext context, int index) =>
//                                   ((){
//                                     if(index != 1){
//                                       return lookupMimeType(feedsListener[i].imagesOrVideos[index])?.contains('video') == true
//                                       ? BetterPlayer.network('${feedsListener[i].imagesOrVideos[index]}',
//                                         betterPlayerConfiguration: BetterPlayerConfiguration(
//                                           placeholder: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 16 / 9),
//                                           controlsConfiguration: const BetterPlayerControlsConfiguration(showControls: false,),
//                                           aspectRatio: 16 / 9,
//                                           fit: BoxFit.contain,
//                                         ),
//                                       )
//                                       : CachedNetworkImage(
//                                         fit: BoxFit.cover,
//                                         imageUrl: feedsListener[i].imagesOrVideos[index],
//                                         placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
//                                         errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
//                                       );
//                                     }else{
//                                       return ((){
//                                         if(feedsListener[i].imagesOrVideos.length - 3 > 0){
//                                           if(lookupMimeType(feedsListener[i].imagesOrVideos[index])?.contains('video') == true){
//                                             return Stack(
//                                               fit: StackFit.expand,
//                                               children: [
//                                                 BetterPlayer.network('${feedsListener[i].imagesOrVideos[index]}',
//                                                   betterPlayerConfiguration: BetterPlayerConfiguration(
//                                                     placeholder: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 16 / 9),
//                                                     controlsConfiguration: const BetterPlayerControlsConfiguration(showControls: false,),
//                                                     aspectRatio: 16 / 9,
//                                                     fit: BoxFit.contain,
//                                                   ),
//                                                 ),

//                                                 Container(color: const Color(0xff000000).withOpacity(0.5),),

//                                                 Center(
//                                                   child: CircleAvatar(
//                                                     radius: 25,
//                                                     backgroundColor: const Color(0xffffffff).withOpacity(.5),
//                                                     child: Text('${feedsListener[i].imagesOrVideos.length - 3}', style: const TextStyle(fontSize: 32, fontFamily: 'NexaBold', color: Color(0xffFFFFFF),),),
//                                                   ),
//                                                 ),
//                                               ],
//                                             );
//                                           }else{
//                                             return Stack(
//                                               fit: StackFit.expand,
//                                               children: [
//                                                 CachedNetworkImage(
//                                                   fit: BoxFit.cover,
//                                                   imageUrl: feedsListener[i].imagesOrVideos[index],
//                                                   placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
//                                                   errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
//                                                 ),

//                                                 Container(color: const Color(0xff000000).withOpacity(0.5),),

//                                                 Center(
//                                                   child: CircleAvatar(
//                                                     radius: 25,
//                                                     backgroundColor: const Color(0xffffffff).withOpacity(.5),
//                                                     child: Text('${feedsListener[i].imagesOrVideos.length - 3}', style: const TextStyle(fontSize: 32, fontFamily: 'NexaBold', color: Color(0xffFFFFFF),),),
//                                                   ),
//                                                 ),
//                                               ],
//                                             );
//                                           }
//                                         }else{
//                                           if(lookupMimeType(feedsListener[i].imagesOrVideos[index])?.contains('video') == true){
//                                             return BetterPlayer.network('${feedsListener[i].imagesOrVideos[index]}',
//                                               betterPlayerConfiguration: BetterPlayerConfiguration(
//                                                 placeholder: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 16 / 9),
//                                                 controlsConfiguration: const BetterPlayerControlsConfiguration(showControls: false,),
//                                                 aspectRatio: 16 / 9,
//                                                 fit: BoxFit.contain,
//                                               ),
//                                             );
//                                           }else{
//                                             return CachedNetworkImage(
//                                               fit: BoxFit.cover,
//                                               imageUrl: feedsListener[i].imagesOrVideos[index],
//                                               placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
//                                               errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
//                                             );
//                                           }
//                                         }
//                                       }());
//                                     }
//                                   }()),
//                                 );
//                               }
//                             }()),
//                           ),
//                         ],
//                       )
//                       : const SizedBox(height: 0),
//                     ],
//                   );
//                 }    
//               ),
//             ),
//           )
//           : SingleChildScrollView(
//             physics: const ClampingScrollPhysics(),
//             child: Column(
//               children: [
//                 const SizedBox(height: 45),

//                 Align(
//                   alignment: Alignment.center,
//                   child: RichText(
//                     textAlign: TextAlign.center,
//                     text: const TextSpan(
//                       children: <TextSpan>[
//                         TextSpan(
//                           text: 'Welcome to\n',
//                           style: TextStyle(fontSize: 32, fontFamily: 'NexaBold', color: Color(0xff2F353D),),
//                         ),

//                         TextSpan(
//                           text: 'Faces by Places',
//                           style: TextStyle(fontSize: 32, fontFamily: 'NexaBold', color: Color(0xff2F353D),),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
                
//                 const SizedBox(height: 20),

//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 20),
//                   child: Image.asset('assets/icons/Welcome-new.png', width: SizeConfig.screenWidth, fit: BoxFit.cover,),
//                 ),

//                 const SizedBox(height: 50,),

//                 const Text('Feed is empty', style: TextStyle(fontSize: 36, fontFamily: 'NexaBold', color: Color(0xffB1B1B1),),),

//                 const Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 40),
//                   child: Text('Create a memorial page for loved ones by sharing stories, special events and photos of special occasions. Keeping their memories alive for generations.',
//                     textAlign: TextAlign.center,
//                     style: TextStyle(fontSize: 26, fontFamily: 'NexaRegular', color: Color(0xff2F353D),),
//                   ),
//                 ),

//                 const SizedBox(height: 20),

//                 isGuestLoggedInListener
//                 ? const SizedBox(height: 0,)
//                 : MiscButtonTemplate(
//                   buttonTextStyle: const TextStyle(fontSize: 24, fontFamily: 'NexaBold', color: Color(0xffffffff),),
//                   buttonColor: const Color(0xff04ECFF),
//                   width: SizeConfig.screenWidth! / 2,
//                   buttonText: 'Create',
//                   height: 50,
//                   onPressed: (){
//                     Navigator.pushNamed(context, '/home/regular/create-memorial');
//                   },
//                 ),

//                 const SizedBox(height: 20),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }





import 'package:facesbyplaces/API/Regular/02-Main/api_main_regular_04_01_home_feed_tab.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc_02_regular_post.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc_02_blm_post.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:better_player/better_player.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/material.dart';
import 'package:loader/loader.dart';
import 'package:dialog/dialog.dart';
import 'package:mime/mime.dart';
import 'package:misc/misc.dart';

class HomeRegularFeedTab extends StatefulWidget{
  const HomeRegularFeedTab({Key? key}) : super(key: key);

  @override
  HomeRegularFeedTabState createState() => HomeRegularFeedTabState();
}

class HomeRegularFeedTabState extends State<HomeRegularFeedTab>{
  Future<List<APIRegularHomeTabFeedExtended>>? showListOfFeeds;
  ValueNotifier<bool> isGuestLoggedIn = ValueNotifier<bool>(false);
  ScrollController scrollController = ScrollController();
  ValueNotifier<int> lengthOfFeeds = ValueNotifier<int>(0);
  int page1 = 1;
  bool loaded = false;
  bool updatedFeedsData = false;

  @override
  void initState(){
    super.initState();
    isGuest();
    scrollController.addListener((){ // SHOWS WHEN THE USER HAS REACHED THE BOTTOM OF THE LIST
      if(scrollController.position.pixels == scrollController.position.maxScrollExtent){
        if(loaded){
          page1 = 1; // RESET BACK TO ONE FOR PAGINATION OF THE API
          showListOfFeeds = getListOfFeeds(page: page1);

          if(updatedFeedsData){
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('New feeds available. Reload to view.'), 
                duration: const Duration(seconds: 3), backgroundColor: const Color(0xff4EC9D4),
                action: SnackBarAction(
                  label: 'Reload',
                  onPressed: (){
                    onRefresh();
                  },
                  textColor: Colors.blue,
                ),
              ),
            );
          }else{
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No more feeds to show.'), duration: Duration(seconds: 1), backgroundColor: Color(0xff4EC9D4),),);
          }
        }
      }
    });
  }

  Future<void> onRefresh() async{ // PULL TO REFRESH FUNCTIONALITY
    page1 = 1;
    loaded = false;
    updatedFeedsData = false;
    lengthOfFeeds.value = 0;
    showListOfFeeds = getListOfFeeds(page: page1);
  }

  void isGuest() async{ // CHECKS IF THE USER IS A GUEST
    final sharedPrefs = await SharedPreferences.getInstance();
    isGuestLoggedIn.value = sharedPrefs.getBool('user-guest-session') ?? false;

    if(isGuestLoggedIn.value != true){
      showListOfFeeds = getListOfFeeds(page: page1);
    }
  }

  Future<List<APIRegularHomeTabFeedExtended>> getListOfFeeds({required int page}) async{
    APIRegularHomeTabFeedMain? newValue;
    List<APIRegularHomeTabFeedExtended> listOfFeeds = [];

    do{
      newValue = await apiRegularHomeFeedTab(page: page).onError((error, stackTrace){
        showDialog(
          context: context,
          builder: (context) => CustomDialog(
            image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
            title: 'Error',
            description: 'Something went wrong. Please try again.',
            okButtonColor: const Color(0xfff44336), // RED
            includeOkButton: true,
          ),
        );
        throw Exception('$error');
      });
      listOfFeeds.addAll(newValue.almFamilyMemorialList);

      if(newValue.almItemsRemaining != 0){
        page++;
      }else if(lengthOfFeeds.value > 0 && listOfFeeds.length > lengthOfFeeds.value){
        updatedFeedsData = true;
      }
    }while(newValue.almItemsRemaining != 0);

    lengthOfFeeds.value = listOfFeeds.length; // COMPARISON FOR NEXT PAGINATION & NUMBER OF FEEDS
    page1 = page;
    loaded = true;
    
    return listOfFeeds;
  }

  @override
  Widget build(BuildContext context){
    SizeConfig.init(context);
    return ValueListenableBuilder(
      valueListenable: isGuestLoggedIn,
      builder: (_, bool isGuestLoggedInListener, __) => ValueListenableBuilder(
        valueListenable: lengthOfFeeds,
        builder: (_, int lengthOfFeedsListener, __) => SafeArea(
          child: RefreshIndicator(
            onRefresh: onRefresh,
            child: FutureBuilder<List<APIRegularHomeTabFeedExtended>>(
              future: showListOfFeeds,
              builder: (context, feeds){
                if(feeds.connectionState != ConnectionState.done){
                  return const Center(child: CustomLoader(),);
                }
                else if(feeds.hasError){
                  return Center(
                    child: MaterialButton(
                      onPressed: (){
                        isGuest();
                      },
                      child: const Text('Refresh', style: TextStyle(color: Color(0xffffffff))),
                      color: const Color(0xff4EC9D4),
                    ),
                  );
                }
                else if(feeds.hasData){
                  return lengthOfFeedsListener != 0
                  // return feeds.data!.isNotEmpty
                  ? ListView.separated(
                    controller: scrollController,
                    separatorBuilder: (c, i) => const Divider(height: 10, color: Colors.transparent),
                    physics: const ClampingScrollPhysics(),
                    padding: const EdgeInsets.all(10.0),
                    itemCount: lengthOfFeedsListener,
                    itemBuilder: (c, i){
                      return feeds.data![i].homeTabFeedPage.homeTabFeedPagePageType == 'Blm'
                      ? MiscBLMPost(
                        key: ValueKey('$i'),
                        userId: feeds.data![i].homeTabFeedPage.homeTabFeedPagePageCreator.homeTabFeedPageCreatorId,
                        postId: feeds.data![i].homeTabFeedId,
                        memorialId: feeds.data![i].homeTabFeedPage.homeTabFeedPageId,
                        memorialName: feeds.data![i].homeTabFeedPage.homeTabFeedPageName,
                        timeCreated: timeago.format(DateTime.parse(feeds.data![i].homeTabFeedCreatedAt)),
                        managed: feeds.data![i].homeTabFeedPage.homeTabFeedPageManage,
                        joined: feeds.data![i].homeTabFeedPage.homeTabFeedPageFollower,
                        profileImage: feeds.data![i].homeTabFeedPage.homeTabFeedPageProfileImage,
                        numberOfComments: feeds.data![i].homeTabFeedNumberOfComments,
                        numberOfLikes: feeds.data![i].homeTabFeedNumberOfLikes,
                        likeStatus: feeds.data![i].homeTabFeedLikeStatus,
                        numberOfTagged: feeds.data![i].homeTabFeedPostTagged.length,
                        taggedFirstName: ((){
                          List<String> firstName = [];
                          for(int j = 0; j < feeds.data![i].homeTabFeedPostTagged.length; j++){
                            firstName.add(feeds.data![i].homeTabFeedPostTagged[j].homeTabFeedTaggedFirstName);
                          }
                          return firstName;
                        }()),
                        taggedLastName: ((){
                          List<String> lastName = [];
                          for(int j = 0; j < feeds.data![i].homeTabFeedPostTagged.length; j++){
                            lastName.add(feeds.data![i].homeTabFeedPostTagged[j].homeTabFeedTaggedLastName);
                          }
                          return lastName;
                        }()),
                        taggedId: ((){
                          List<int> id = [];
                          for(int j = 0; j < feeds.data![i].homeTabFeedPostTagged.length; j++){
                            id.add(feeds.data![i].homeTabFeedPostTagged[j].homeTabFeedTaggedId);
                          }
                          return id;
                        }()),
                        pageType: feeds.data![i].homeTabFeedPage.homeTabFeedPagePageType,
                        famOrFriends: feeds.data![i].homeTabFeedPage.homeTabFeedPageFamOrFriends,
                        relationship: feeds.data![i].homeTabFeedPage.homeTabFeedPageRelationship,
                        location: feeds.data![i].homeTabFeedLocation,
                        latitude: feeds.data![i].homeTabFeedLatitude,
                        longitude: feeds.data![i].homeTabFeedLongitude,
                        contents: [
                          Align(alignment: Alignment.centerLeft, child: Text(feeds.data![i].homeTabFeedBody, overflow: TextOverflow.ellipsis, maxLines: 5, style: const TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xff000000),),),),
                              
                          feeds.data![i].homeTabFeedImagesOrVideos.isNotEmpty
                          ? Column(
                            children: [
                              const SizedBox(height: 20),
                              
                              SizedBox(
                                child: ((){
                                  if(feeds.data![i].homeTabFeedImagesOrVideos.length == 1){
                                    if(lookupMimeType(feeds.data![i].homeTabFeedImagesOrVideos[0])?.contains('video') == true){
                                      return BetterPlayer.network('${feeds.data![i].homeTabFeedImagesOrVideos[0]}',
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
                                        imageUrl: feeds.data![i].homeTabFeedImagesOrVideos[0],
                                        placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                        errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                      );
                                    }
                                  }else if(feeds.data![i].homeTabFeedImagesOrVideos.length == 2){
                                    return StaggeredGridView.countBuilder(
                                      staggeredTileBuilder:(int index) => const StaggeredTile.count(2, 2),
                                      physics: const NeverScrollableScrollPhysics(),
                                      padding: EdgeInsets.zero,
                                      crossAxisSpacing: 4.0,
                                      mainAxisSpacing: 4.0,
                                      crossAxisCount: 4,
                                      shrinkWrap: true,
                                      itemCount: 2,
                                      itemBuilder: (BuildContext context, int index) => lookupMimeType(feeds.data![i].homeTabFeedImagesOrVideos[index])?.contains('video') == true
                                      ? BetterPlayer.network('${feeds.data![i].homeTabFeedImagesOrVideos[index]}',
                                          betterPlayerConfiguration: BetterPlayerConfiguration(placeholder: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 16 / 9),
                                          controlsConfiguration: const BetterPlayerControlsConfiguration(showControls: false,),
                                          aspectRatio: 16 / 9,
                                          fit: BoxFit.contain,
                                        ),
                                      )
                                      : CachedNetworkImage(
                                        fit: BoxFit.cover, 
                                        imageUrl: feeds.data![i].homeTabFeedImagesOrVideos[index],
                                        placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                        errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,scale: 1.0,),
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
                                      itemBuilder: (BuildContext context, int index) => 
                                      ((){
                                        if(index != 1){
                                          return lookupMimeType(feeds.data![i].homeTabFeedImagesOrVideos[index])?.contains('video') == true
                                          ? BetterPlayer.network('${feeds.data![i].homeTabFeedImagesOrVideos[index]}',
                                            betterPlayerConfiguration: BetterPlayerConfiguration(
                                              placeholder: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 16 / 9),
                                              controlsConfiguration: const BetterPlayerControlsConfiguration(showControls: false,),
                                              aspectRatio: 16 / 9,
                                              fit: BoxFit.contain,
                                            ),
                                          )
                                          : CachedNetworkImage(
                                            fit: BoxFit.cover,
                                            imageUrl: feeds.data![i].homeTabFeedImagesOrVideos[index],
                                            placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                            errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                          );
                                        }else{
                                          return ((){
                                            if(feeds.data![i].homeTabFeedImagesOrVideos.length - 3 > 0){
                                              if(lookupMimeType(feeds.data![i].homeTabFeedImagesOrVideos[index])?.contains('video') == true){
                                                return Stack(
                                                  fit: StackFit.expand,
                                                  children: [
                                                    BetterPlayer.network('${feeds.data![i].homeTabFeedImagesOrVideos[index]}',
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
                                                        child: Text('${feeds.data![i].homeTabFeedImagesOrVideos.length - 3}', style: const TextStyle(fontSize: 32, fontFamily: 'NexaBold', color: Color(0xffFFFFFF),),),
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
                                                      imageUrl: feeds.data![i].homeTabFeedImagesOrVideos[index],
                                                      placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                      errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                    ),

                                                    Container(color: const Color(0xff000000).withOpacity(0.5),),
                                                    
                                                    Center(
                                                      child: CircleAvatar(
                                                        radius: 25,
                                                        backgroundColor: const Color(0xffffffff).withOpacity(.5),
                                                        child: Text('${feeds.data![i].homeTabFeedImagesOrVideos.length - 3}', style: const TextStyle(fontSize: 32, fontFamily: 'NexaBold', color: Color(0xffFFFFFF),),),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              }
                                            }else{
                                              if(lookupMimeType(feeds.data![i].homeTabFeedImagesOrVideos[index])?.contains('video') == true) {
                                                return BetterPlayer.network('${feeds.data![i].homeTabFeedImagesOrVideos[index]}',
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
                                                  imageUrl: feeds.data![i].homeTabFeedImagesOrVideos[index],
                                                  placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                  errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                );
                                              }
                                            }
                                          }());
                                        }
                                      }()),
                                    );
                                  }
                                }()),
                              ),
                            ],
                          )
                          : const SizedBox(height: 0),
                        ],
                      )
                      : MiscRegularPost(
                        key: ValueKey('$i'),
                        userId: feeds.data![i].homeTabFeedPage.homeTabFeedPagePageCreator.homeTabFeedPageCreatorId,
                        postId: feeds.data![i].homeTabFeedId,
                        memorialId: feeds.data![i].homeTabFeedPage.homeTabFeedPageId,
                        memorialName: feeds.data![i].homeTabFeedPage.homeTabFeedPageName,
                        timeCreated: timeago.format(DateTime.parse(feeds.data![i].homeTabFeedCreatedAt)),
                        managed: feeds.data![i].homeTabFeedPage.homeTabFeedPageManage,
                        joined: feeds.data![i].homeTabFeedPage.homeTabFeedPageFollower,
                        profileImage: feeds.data![i].homeTabFeedPage.homeTabFeedPageProfileImage,
                        numberOfComments: feeds.data![i].homeTabFeedNumberOfComments,
                        numberOfLikes: feeds.data![i].homeTabFeedNumberOfLikes,
                        likeStatus: feeds.data![i].homeTabFeedLikeStatus,
                        numberOfTagged: feeds.data![i].homeTabFeedPostTagged.length,
                        taggedFirstName: ((){
                          List<String> firstName = [];
                          for(int j = 0; j < feeds.data![i].homeTabFeedPostTagged.length; j++){
                            firstName.add(feeds.data![i].homeTabFeedPostTagged[j].homeTabFeedTaggedFirstName);
                          }
                          return firstName;
                        }()),
                        taggedLastName: ((){
                          List<String> lastName = [];
                          for(int j = 0; j < feeds.data![i].homeTabFeedPostTagged.length; j++){
                            lastName.add(feeds.data![i].homeTabFeedPostTagged[j].homeTabFeedTaggedLastName);
                          }
                          return lastName;
                        }()),
                        taggedId: ((){
                          List<int> id = [];
                          for(int j = 0; j < feeds.data![i].homeTabFeedPostTagged.length; j++){
                            id.add(feeds.data![i].homeTabFeedPostTagged[j].homeTabFeedTaggedId);
                          }
                          return id;
                        }()),
                        pageType: feeds.data![i].homeTabFeedPage.homeTabFeedPagePageType,
                        famOrFriends: feeds.data![i].homeTabFeedPage.homeTabFeedPageFamOrFriends,
                        relationship: feeds.data![i].homeTabFeedPage.homeTabFeedPageRelationship,
                        location: feeds.data![i].homeTabFeedLocation,
                        latitude: feeds.data![i].homeTabFeedLatitude,
                        longitude: feeds.data![i].homeTabFeedLongitude,
                        contents: [
                          Align(alignment: Alignment.centerLeft, child: Text(feeds.data![i].homeTabFeedBody, overflow: TextOverflow.ellipsis, maxLines: 5, style: const TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xff000000),),),),
                              
                          feeds.data![i].homeTabFeedImagesOrVideos.isNotEmpty
                          ? Column(
                            children: [
                              const SizedBox(height: 20),
                              
                              SizedBox(
                                child: ((){
                                  if(feeds.data![i].homeTabFeedImagesOrVideos.length == 1){
                                    if(lookupMimeType(feeds.data![i].homeTabFeedImagesOrVideos[0])?.contains('video') == true){
                                      return BetterPlayer.network('${feeds.data![i].homeTabFeedImagesOrVideos[0]}',
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
                                        imageUrl: feeds.data![i].homeTabFeedImagesOrVideos[0],
                                        placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                        errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                      );
                                    }
                                  }else if(feeds.data![i].homeTabFeedImagesOrVideos.length == 2){
                                    return StaggeredGridView.countBuilder(
                                      staggeredTileBuilder:(int index) => const StaggeredTile.count(2, 2),
                                      physics: const NeverScrollableScrollPhysics(),
                                      padding: EdgeInsets.zero,
                                      crossAxisSpacing: 4.0,
                                      mainAxisSpacing: 4.0,
                                      crossAxisCount: 4,
                                      shrinkWrap: true,
                                      itemCount: 2,
                                      itemBuilder: (BuildContext context, int index) => lookupMimeType(feeds.data![i].homeTabFeedImagesOrVideos[index])?.contains('video') == true
                                      ? BetterPlayer.network('${feeds.data![i].homeTabFeedImagesOrVideos[index]}',
                                          betterPlayerConfiguration: BetterPlayerConfiguration(placeholder: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 16 / 9),
                                          controlsConfiguration: const BetterPlayerControlsConfiguration(showControls: false,),
                                          aspectRatio: 16 / 9,
                                          fit: BoxFit.contain,
                                        ),
                                      )
                                      : CachedNetworkImage(
                                        fit: BoxFit.cover, 
                                        imageUrl: feeds.data![i].homeTabFeedImagesOrVideos[index],
                                        placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                        errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,scale: 1.0,),
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
                                      itemBuilder: (BuildContext context, int index) => 
                                      ((){
                                        if(index != 1){
                                          return lookupMimeType(feeds.data![i].homeTabFeedImagesOrVideos[index])?.contains('video') == true
                                          ? BetterPlayer.network('${feeds.data![i].homeTabFeedImagesOrVideos[index]}',
                                            betterPlayerConfiguration: BetterPlayerConfiguration(
                                              placeholder: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 16 / 9),
                                              controlsConfiguration: const BetterPlayerControlsConfiguration(showControls: false,),
                                              aspectRatio: 16 / 9,
                                              fit: BoxFit.contain,
                                            ),
                                          )
                                          : CachedNetworkImage(
                                            fit: BoxFit.cover,
                                            imageUrl: feeds.data![i].homeTabFeedImagesOrVideos[index],
                                            placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                            errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                          );
                                        }else{
                                          return ((){
                                            if(feeds.data![i].homeTabFeedImagesOrVideos.length - 3 > 0){
                                              if(lookupMimeType(feeds.data![i].homeTabFeedImagesOrVideos[index])?.contains('video') == true){
                                                return Stack(
                                                  fit: StackFit.expand,
                                                  children: [
                                                    BetterPlayer.network('${feeds.data![i].homeTabFeedImagesOrVideos[index]}',
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
                                                        child: Text('${feeds.data![i].homeTabFeedImagesOrVideos.length - 3}', style: const TextStyle(fontSize: 32, fontFamily: 'NexaBold', color: Color(0xffFFFFFF),),),
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
                                                      imageUrl: feeds.data![i].homeTabFeedImagesOrVideos[index],
                                                      placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                      errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                    ),

                                                    Container(color: const Color(0xff000000).withOpacity(0.5),),
                                                    
                                                    Center(
                                                      child: CircleAvatar(
                                                        radius: 25,
                                                        backgroundColor: const Color(0xffffffff).withOpacity(.5),
                                                        child: Text('${feeds.data![i].homeTabFeedImagesOrVideos.length - 3}', style: const TextStyle(fontSize: 32, fontFamily: 'NexaBold', color: Color(0xffFFFFFF),),),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              }
                                            }else{
                                              if(lookupMimeType(feeds.data![i].homeTabFeedImagesOrVideos[index])?.contains('video') == true) {
                                                return BetterPlayer.network('${feeds.data![i].homeTabFeedImagesOrVideos[index]}',
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
                                                  imageUrl: feeds.data![i].homeTabFeedImagesOrVideos[index],
                                                  placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                  errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                );
                                              }
                                            }
                                          }());
                                        }
                                      }()),
                                    );
                                  }
                                }()),
                              ),
                            ],
                          )
                          : const SizedBox(height: 0),
                        ],
                      );
                    }
                  )
                  : SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: Column(
                      children: [
                        const SizedBox(height: 45),

                        Align(
                          alignment: Alignment.center,
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: const TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'Welcome to\n',
                                  style: TextStyle(fontSize: 32, fontFamily: 'NexaBold', color: Color(0xff2F353D),),
                                ),

                                TextSpan(
                                  text: 'Faces by Places',
                                  style: TextStyle(fontSize: 32, fontFamily: 'NexaBold', color: Color(0xff2F353D),),
                                ),
                              ],
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 20),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Image.asset('assets/icons/Welcome-new.png', width: SizeConfig.screenWidth, fit: BoxFit.cover,),
                        ),

                        const SizedBox(height: 50,),

                        const Text('Feed is empty', style: TextStyle(fontSize: 36, fontFamily: 'NexaBold', color: Color(0xffB1B1B1),),),

                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 40),
                          child: Text('Create a memorial page for loved ones by sharing stories, special events and photos of special occasions. Keeping their memories alive for generations.',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 26, fontFamily: 'NexaRegular', color: Color(0xff2F353D),),
                          ),
                        ),

                        const SizedBox(height: 20),

                        isGuestLoggedInListener
                        ? const SizedBox(height: 0,)
                        : MiscButtonTemplate(
                          buttonTextStyle: const TextStyle(fontSize: 24, fontFamily: 'NexaBold', color: Color(0xffffffff),),
                          buttonColor: const Color(0xff04ECFF),
                          width: SizeConfig.screenWidth! / 2,
                          buttonText: 'Create',
                          height: 50,
                          onPressed: (){
                            Navigator.pushNamed(context, '/home/regular/create-memorial');
                          },
                        ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  );
                }else{
                  return const SizedBox(height: 0,);
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}