// import 'package:facesbyplaces/API/Regular/02-Main/api-main-regular-04-03-home-post-tab.dart';
// // import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-04-regular-post.dart';
// // import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
// import 'package:facesbyplaces/Configurations/size_configuration.dart';
// // import 'package:cached_network_image/cached_network_image.dart';
// // import 'package:pull_to_refresh/pull_to_refresh.dart';
// import 'package:loader_overlay/loader_overlay.dart';
// // import 'package:better_player/better_player.dart';
// // import 'package:timeago/timeago.dart' as timeago;
// import 'package:flutter/material.dart';
// // import 'package:mime/mime.dart';

// class RegularMainPagesPosts{
//   int userId;
//   int postId;
//   int memorialId;
//   String memorialName;
//   String timeCreated;
//   String postBody;
//   dynamic profileImage;
//   List<dynamic> imagesOrVideos;
//   bool managed;
//   bool joined;
//   int numberOfLikes;
//   int numberOfComments;
//   bool likeStatus;
//   int numberOfTagged;
//   List<String> taggedFirstName;
//   List<String> taggedLastName;
//   List<String> taggedImage;
//   List<int> taggedId;
//   String pageType;
//   bool famOrFriends;
//   String relationship;

//   RegularMainPagesPosts({
//     required this.userId, 
//     required this.postId, 
//     required this.memorialId, 
//     required this.memorialName, 
//     required this.timeCreated, 
//     required this.postBody, 
//     required this.profileImage, 
//     required this.imagesOrVideos, 
//     required this.managed,
//     required this.joined,
//     required this.numberOfLikes,
//     required this.numberOfComments,
//     required this.likeStatus,
//     required this.numberOfTagged, 
//     required this.taggedFirstName, 
//     required this.taggedLastName, 
//     required this.taggedImage, 
//     required this.taggedId,
//     required this.pageType, 
//     required this.famOrFriends, 
//     required this.relationship,
//   });
// }

// class HomeRegularPostTab extends StatefulWidget{

//   HomeRegularPostTabState createState() => HomeRegularPostTabState();
// }

// class HomeRegularPostTabState extends State<HomeRegularPostTab>{
  
//   // RefreshController refreshController = RefreshController(initialRefresh: true);
//   List<RegularMainPagesPosts> posts = [];
//   int itemRemaining = 1;
//   int page = 1;
//   int count = 0;

//   // void onRefresh() async{
//   //   await Future.delayed(Duration(milliseconds: 1000));
//   //   refreshController.refreshCompleted();
//   // }

//   void onLoading() async{
//     if(itemRemaining != 0){
//       context.showLoaderOverlay();
//       var newValue = await apiRegularHomePostTab(page: page);
//       context.hideLoaderOverlay();

//       itemRemaining = newValue.almItemsRemaining;
//       count = count + newValue.familyMemorialList.length;

//       for(int i = 0; i < newValue.familyMemorialList.length; i++){
//         List<String> newList1 = [];
//         List<String> newList2 = [];
//         List<String> newList3 = [];
//         List<int> newList4 = [];

//         for(int j = 0; j < newValue.familyMemorialList[i].homeTabPostPostTagged.length; j++){
//           newList1.add(newValue.familyMemorialList[i].homeTabPostPostTagged[j].homeTabPostTabTaggedFirstName);
//           newList2.add(newValue.familyMemorialList[i].homeTabPostPostTagged[j].homeTabPostTabTaggedLastName);
//           newList3.add(newValue.familyMemorialList[i].homeTabPostPostTagged[j].homeTabPostTabTaggedImage);
//           newList4.add(newValue.familyMemorialList[i].homeTabPostPostTagged[j].homeTabPostTabTaggedId);
//         }

//         posts.add(
//           RegularMainPagesPosts(
//             userId: newValue.familyMemorialList[i].homeTabPostPage.homeTabPostPagePageCreator.homeTabPostPageCreatorId, 
//             postId: newValue.familyMemorialList[i].homeTabPostId,
//             memorialId: newValue.familyMemorialList[i].homeTabPostPage.homeTabPostPageId,
//             timeCreated: newValue.familyMemorialList[i].homeTabPostCreateAt,
//             memorialName: newValue.familyMemorialList[i].homeTabPostPage.homeTabPostPageName,
//             postBody: newValue.familyMemorialList[i].homeTabPostBody,
//             profileImage: newValue.familyMemorialList[i].homeTabPostPage.homeTabPostPageProfileImage,
//             imagesOrVideos: newValue.familyMemorialList[i].homeTabPostImagesOrVideos,
//             managed: newValue.familyMemorialList[i].homeTabPostPage.homeTabPostPageManage,
//             joined: newValue.familyMemorialList[i].homeTabPostPage.homeTabPostPageFollower,
//             numberOfComments: newValue.familyMemorialList[i].homeTabPostNumberOfComments,
//             numberOfLikes: newValue.familyMemorialList[i].homeTabPostNumberOfLikes,
//             likeStatus: newValue.familyMemorialList[i].homeTabPostLikeStatus,
//             numberOfTagged: newValue.familyMemorialList[i].homeTabPostPostTagged.length,
//             taggedFirstName: newList1,
//             taggedLastName: newList2,
//             taggedImage: newList3,
//             taggedId: newList4,
            
//             famOrFriends: newValue.familyMemorialList[i].homeTabPostPage.homeTabPostPageFamOrFriends,
//             pageType: newValue.familyMemorialList[i].homeTabPostPage.homeTabPostPagePageType,
//             relationship: newValue.familyMemorialList[i].homeTabPostPage.homeTabPostPageRelationship,
//           ),
//         );
//       }

//       if(mounted)
//       setState(() {});
//       page++;
      
//       // refreshController.loadComplete();
//     }else{
//       // refreshController.loadNoData();
//     }
//   }

//   void initState(){
//     super.initState();
//     onLoading();
//   }

//   @override
//   Widget build(BuildContext context) {
//     SizeConfig.init(context);
//     return Container(
//       width: SizeConfig.screenWidth,
//       child: count != 0
//       ? Container()
//       // ? SmartRefresher(
//       //   enablePullDown: true,
//       //   enablePullUp: true,
//       //   header: MaterialClassicHeader(
//       //     color: Color(0xffffffff),
//       //     backgroundColor: Color(0xff4EC9D4),
//       //   ),
//       //   footer: CustomFooter(
//       //     loadStyle: LoadStyle.ShowWhenLoading,
//       //     builder: (BuildContext context, LoadStatus mode){
//       //       Widget body = Container();
//       //       if(mode == LoadStatus.loading){
//       //         body = CircularProgressIndicator();
//       //       }
//       //       return Center(child: body);
//       //     },
//       //   ),
//       //   controller: refreshController,
//       //   onRefresh: onRefresh,
//       //   onLoading: onLoading,
//       //   child: ListView.separated(
//       //     padding: EdgeInsets.all(10.0),
//       //     physics: ClampingScrollPhysics(),
//       //     shrinkWrap: true,
//       //     itemBuilder: (c, i) {
//       //       return MiscRegularPost(
//       //         userId: posts[i].userId,
//       //         postId: posts[i].postId,
//       //         memorialId: posts[i].memorialId,
//       //         memorialName: posts[i].memorialName,
//       //         timeCreated: timeago.format(DateTime.parse(posts[i].timeCreated)),
//       //         managed: posts[i].managed,
//       //         joined: posts[i].joined,
//       //         profileImage: posts[i].profileImage,
//       //         numberOfComments: posts[i].numberOfComments,
//       //         numberOfLikes: posts[i].numberOfLikes,
//       //         likeStatus: posts[i].likeStatus,
//       //         numberOfTagged: posts[i].numberOfTagged,
//       //         taggedFirstName: posts[i].taggedFirstName,
//       //         taggedLastName: posts[i].taggedLastName,
//       //         taggedId: posts[i].taggedId,
              
//       //         relationship: posts[i].relationship,
//       //         pageType: posts[i].pageType,
//       //         famOrFriends: posts[i].famOrFriends,
//       //         contents: [

//       //           Container(alignment: Alignment.centerLeft, child: Text(posts[i].postBody, overflow: TextOverflow.ellipsis, maxLines: 5,),),

//       //           posts[i].imagesOrVideos != []
//       //           ? Column(
//       //             children: [
//       //               SizedBox(height: 20),

//       //               Container(
//       //                 child: ((){
//       //                   if(posts[i].imagesOrVideos != []){
//       //                     if(posts[i].imagesOrVideos.length == 1){
//       //                       if(lookupMimeType(posts[i].imagesOrVideos[0])?.contains('video') == true){
//       //                         return BetterPlayer.network('${posts[i].imagesOrVideos[0]}',
//       //                           betterPlayerConfiguration: BetterPlayerConfiguration(
//       //                             controlsConfiguration: BetterPlayerControlsConfiguration(
//       //                               showControls: false,
//       //                             ),
//       //                             aspectRatio: 16 / 9,
//       //                           ),
//       //                         );
//       //                       }else{
//       //                         return Container(
//       //                           child: CachedNetworkImage(
//       //                             fit: BoxFit.contain,
//       //                             imageUrl: posts[i].imagesOrVideos[0],
//       //                             placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
//       //                             errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 1.0,),
//       //                           ),
//       //                         );
//       //                       }
//       //                     }else if(posts[i].imagesOrVideos.length == 2){
//       //                       return StaggeredGridView.countBuilder(
//       //                         padding: EdgeInsets.zero,
//       //                         shrinkWrap: true,
//       //                         physics: NeverScrollableScrollPhysics(),
//       //                         crossAxisCount: 4,
//       //                         itemCount: 2,
//       //                         itemBuilder: (BuildContext context, int index) =>  
//       //                           lookupMimeType(posts[i].imagesOrVideos[index])?.contains('video') == true
//       //                           ? BetterPlayer.network('${posts[i].imagesOrVideos[index]}',
//       //                             betterPlayerConfiguration: BetterPlayerConfiguration(
//       //                               controlsConfiguration: BetterPlayerControlsConfiguration(
//       //                                 showControls: false,
//       //                               ),
//       //                               aspectRatio: 16 / 9,
//       //                             ),
//       //                           )
//       //                           : CachedNetworkImage(
//       //                             fit: BoxFit.contain,
//       //                             imageUrl: posts[i].imagesOrVideos[index],
//       //                             placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
//       //                             errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 1.0,),
//       //                           ),
//       //                         staggeredTileBuilder: (int index) => StaggeredTile.count(2, 2),
//       //                         mainAxisSpacing: 4.0,
//       //                         crossAxisSpacing: 4.0,
//       //                       );
//       //                     }else{
//       //                       return StaggeredGridView.countBuilder(
//       //                         padding: EdgeInsets.zero,
//       //                         shrinkWrap: true,
//       //                         physics: NeverScrollableScrollPhysics(),
//       //                         crossAxisCount: 4,
//       //                         itemCount: 3,
//       //                         itemBuilder: (BuildContext context, int index) => 
//       //                         ((){
//       //                           if(index != 1){
//       //                             return lookupMimeType(posts[i].imagesOrVideos[index])?.contains('video') == true
//       //                             ? BetterPlayer.network('${posts[i].imagesOrVideos[index]}',
//       //                               betterPlayerConfiguration: BetterPlayerConfiguration(
//       //                                 controlsConfiguration: BetterPlayerControlsConfiguration(
//       //                                   showControls: false,
//       //                                 ),
//       //                                 aspectRatio: 16 / 9,
//       //                               ),
//       //                             )
//       //                             : CachedNetworkImage(
//       //                               fit: BoxFit.contain,
//       //                               imageUrl: posts[i].imagesOrVideos[index],
//       //                               placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
//       //                               errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 1.0,),
//       //                             );
                                  
//       //                           }else{
//       //                             return ((){
//       //                               if(posts[i].imagesOrVideos.length - 3 > 0){
//       //                                 if(lookupMimeType(posts[i].imagesOrVideos[index])?.contains('video') == true){
//       //                                   return Stack(
//       //                                     children: [
//       //                                       BetterPlayer.network('${posts[i].imagesOrVideos[index]}',
//       //                                         betterPlayerConfiguration: BetterPlayerConfiguration(
//       //                                           controlsConfiguration: BetterPlayerControlsConfiguration(
//       //                                             showControls: false,
//       //                                           ),
//       //                                           aspectRatio: 16 / 9,
//       //                                         ),
//       //                                       ),

//       //                                       Container(color: Colors.black.withOpacity(0.5),),

//       //                                       Center(
//       //                                         child: CircleAvatar(
//       //                                           radius: 25,
//       //                                           backgroundColor: Color(0xffffffff).withOpacity(.5),
//       //                                           child: Text(
//       //                                             '${posts[i].imagesOrVideos.length - 3}',
//       //                                             style: TextStyle(
//       //                                               fontSize: 40,
//       //                                               fontWeight: FontWeight.bold,
//       //                                               color: Color(0xffffffff),
//       //                                             ),
//       //                                           ),
//       //                                         ),
//       //                                       ),
//       //                                     ],
//       //                                   );
//       //                                 }else{
//       //                                   return Stack(
//       //                                     children: [
//       //                                       CachedNetworkImage(
//       //                                         fit: BoxFit.contain,
//       //                                         imageUrl: posts[i].imagesOrVideos[index],
//       //                                         placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
//       //                                         errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 1.0,),
//       //                                       ),

//       //                                       Container(color: Colors.black.withOpacity(0.5),),

//       //                                       Center(
//       //                                         child: CircleAvatar(
//       //                                           radius: 25,
//       //                                           backgroundColor: Color(0xffffffff).withOpacity(.5),
//       //                                           child: Text(
//       //                                             '${posts[i].imagesOrVideos.length - 3}',
//       //                                             style: TextStyle(
//       //                                               fontSize: 40,
//       //                                               fontWeight: FontWeight.bold,
//       //                                               color: Color(0xffffffff),
//       //                                             ),
//       //                                           ),
//       //                                         ),
//       //                                       ),
//       //                                     ],
//       //                                   );
//       //                                 }
//       //                               }else{
//       //                                 if(lookupMimeType(posts[i].imagesOrVideos[index])?.contains('video') == true){
//       //                                   return BetterPlayer.network('${posts[i].imagesOrVideos[index]}',
//       //                                     betterPlayerConfiguration: BetterPlayerConfiguration(
//       //                                       controlsConfiguration: BetterPlayerControlsConfiguration(
//       //                                         showControls: false,
//       //                                       ),
//       //                                       aspectRatio: 16 / 9,
//       //                                     ),
//       //                                   );
//       //                                 }else{
//       //                                   return CachedNetworkImage(
//       //                                     fit: BoxFit.contain,
//       //                                     imageUrl: posts[i].imagesOrVideos[index],
//       //                                     placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
//       //                                     errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 1.0,),
//       //                                   );
//       //                                 }
//       //                               }
//       //                             }());
//       //                           }
//       //                         }()),
//       //                         staggeredTileBuilder: (int index) => StaggeredTile.count(2, index.isEven ? 1 : 2),
//       //                         mainAxisSpacing: 4.0,
//       //                         crossAxisSpacing: 4.0,
//       //                       );
//       //                     }
//       //                   }else{
//       //                     return Container(height: 0,);
//       //                   }
//       //                 }()),
//       //               ),
                    
//       //             ],
//       //           )
//       //           : Container(height: 0),
//       //         ]
//       //       );
//       //     },
//       //     separatorBuilder: (c, i) => Divider(height: 20, color: Colors.transparent),
//       //     itemCount: posts.length,
//       //   ),
//       // )
//       : SingleChildScrollView(
//         physics: ClampingScrollPhysics(),
//         child: Container(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [

//               SizedBox(height: (SizeConfig.screenHeight! - 85 - kToolbarHeight) / 3.5,),

//               Image.asset('assets/icons/app-icon.png', height: 250, width: 250,),

//               SizedBox(height: 45,),

//               Text('Post is empty', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xffB1B1B1),),),

//               SizedBox(height: (SizeConfig.screenHeight! - 85 - kToolbarHeight) / 3.5,),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }




// ========================================================================================================================

import 'package:facesbyplaces/API/Regular/02-Main/api-main-regular-04-03-home-post-tab.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-04-regular-post.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:better_player/better_player.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';

class RegularMainPagesPosts{
  int userId;
  int postId;
  int memorialId;
  String memorialName;
  String timeCreated;
  String postBody;
  dynamic profileImage;
  List<dynamic> imagesOrVideos;
  bool managed;
  bool joined;
  int numberOfLikes;
  int numberOfComments;
  bool likeStatus;
  int numberOfTagged;
  List<String> taggedFirstName;
  List<String> taggedLastName;
  List<String> taggedImage;
  List<int> taggedId;
  String pageType;
  bool famOrFriends;
  String relationship;

  RegularMainPagesPosts({
    required this.userId, 
    required this.postId, 
    required this.memorialId, 
    required this.memorialName, 
    required this.timeCreated, 
    required this.postBody, 
    required this.profileImage, 
    required this.imagesOrVideos, 
    required this.managed,
    required this.joined,
    required this.numberOfLikes,
    required this.numberOfComments,
    required this.likeStatus,
    required this.numberOfTagged, 
    required this.taggedFirstName, 
    required this.taggedLastName, 
    required this.taggedImage, 
    required this.taggedId,
    required this.pageType, 
    required this.famOrFriends, 
    required this.relationship,
  });
}

class HomeRegularPostTab extends StatefulWidget{

  HomeRegularPostTabState createState() => HomeRegularPostTabState();
}

class HomeRegularPostTabState extends State<HomeRegularPostTab>{
  
  List<RegularMainPagesPosts> posts = [];
  int itemRemaining = 1;
  int page = 1;
  int count = 0;

  void initState(){
    super.initState();
    onLoading();
  }

  Future<void> onRefresh() async{
    setState(() {
      onLoading();
    });
  }

  void onLoading() async{
    if(itemRemaining != 0){
      context.showLoaderOverlay();
      var newValue = await apiRegularHomePostTab(page: page);
      context.hideLoaderOverlay();

      itemRemaining = newValue.almItemsRemaining;
      count = count + newValue.familyMemorialList.length;

      for(int i = 0; i < newValue.familyMemorialList.length; i++){
        List<String> newList1 = [];
        List<String> newList2 = [];
        List<String> newList3 = [];
        List<int> newList4 = [];

        for(int j = 0; j < newValue.familyMemorialList[i].homeTabPostPostTagged.length; j++){
          newList1.add(newValue.familyMemorialList[i].homeTabPostPostTagged[j].homeTabPostTabTaggedFirstName);
          newList2.add(newValue.familyMemorialList[i].homeTabPostPostTagged[j].homeTabPostTabTaggedLastName);
          newList3.add(newValue.familyMemorialList[i].homeTabPostPostTagged[j].homeTabPostTabTaggedImage);
          newList4.add(newValue.familyMemorialList[i].homeTabPostPostTagged[j].homeTabPostTabTaggedId);
        }

        posts.add(
          RegularMainPagesPosts(
            userId: newValue.familyMemorialList[i].homeTabPostPage.homeTabPostPagePageCreator.homeTabPostPageCreatorId, 
            postId: newValue.familyMemorialList[i].homeTabPostId,
            memorialId: newValue.familyMemorialList[i].homeTabPostPage.homeTabPostPageId,
            timeCreated: newValue.familyMemorialList[i].homeTabPostCreateAt,
            memorialName: newValue.familyMemorialList[i].homeTabPostPage.homeTabPostPageName,
            postBody: newValue.familyMemorialList[i].homeTabPostBody,
            profileImage: newValue.familyMemorialList[i].homeTabPostPage.homeTabPostPageProfileImage,
            imagesOrVideos: newValue.familyMemorialList[i].homeTabPostImagesOrVideos,
            managed: newValue.familyMemorialList[i].homeTabPostPage.homeTabPostPageManage,
            joined: newValue.familyMemorialList[i].homeTabPostPage.homeTabPostPageFollower,
            numberOfComments: newValue.familyMemorialList[i].homeTabPostNumberOfComments,
            numberOfLikes: newValue.familyMemorialList[i].homeTabPostNumberOfLikes,
            likeStatus: newValue.familyMemorialList[i].homeTabPostLikeStatus,
            numberOfTagged: newValue.familyMemorialList[i].homeTabPostPostTagged.length,
            taggedFirstName: newList1,
            taggedLastName: newList2,
            taggedImage: newList3,
            taggedId: newList4,
            
            famOrFriends: newValue.familyMemorialList[i].homeTabPostPage.homeTabPostPageFamOrFriends,
            pageType: newValue.familyMemorialList[i].homeTabPostPage.homeTabPostPagePageType,
            relationship: newValue.familyMemorialList[i].homeTabPostPage.homeTabPostPageRelationship,
          ),
        );
      }

      if(mounted)
      setState(() {});
      page++;
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Container(
      width: SizeConfig.screenWidth,
      child: count != 0
      ? RefreshIndicator(
        onRefresh: onRefresh,
        child: ListView.separated(
          padding: EdgeInsets.all(10.0),
          physics: ClampingScrollPhysics(),
          itemCount: count,
          separatorBuilder: (c, i) => Divider(height: 10, color: Colors.transparent),
          itemBuilder: (c, i) {
            return MiscRegularPost(
              userId: posts[i].userId,
              postId: posts[i].postId,
              memorialId: posts[i].memorialId,
              memorialName: posts[i].memorialName,
              timeCreated: timeago.format(DateTime.parse(posts[i].timeCreated)),
              managed: posts[i].managed,
              joined: posts[i].joined,
              profileImage: posts[i].profileImage,
              numberOfComments: posts[i].numberOfComments,
              numberOfLikes: posts[i].numberOfLikes,
              likeStatus: posts[i].likeStatus,
              numberOfTagged: posts[i].numberOfTagged,
              taggedFirstName: posts[i].taggedFirstName,
              taggedLastName: posts[i].taggedLastName,
              taggedId: posts[i].taggedId,
              pageType: posts[i].pageType,
              famOrFriends: posts[i].famOrFriends,
              relationship: posts[i].relationship,
              contents: [
                Container(alignment: Alignment.centerLeft, child: Text(posts[i].postBody, overflow: TextOverflow.ellipsis, maxLines: 5,),),

                posts[i].imagesOrVideos.isNotEmpty
                ? Column(
                  children: [
                    SizedBox(height: 20),

                    Container(
                      child: ((){
                        if(posts[i].imagesOrVideos.length == 1){
                          if(lookupMimeType(posts[i].imagesOrVideos[0])?.contains('video') == true){
                            return BetterPlayer.network('${posts[i].imagesOrVideos[0]}',
                              betterPlayerConfiguration: BetterPlayerConfiguration(
                                controlsConfiguration: BetterPlayerControlsConfiguration(
                                  showControls: false,
                                ),
                                aspectRatio: 16 / 9,
                              ),
                            );
                          }else{
                            return CachedNetworkImage(
                              fit: BoxFit.contain,
                              imageUrl: posts[i].imagesOrVideos[0],
                              placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                              errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 1.0,),
                            );
                          }
                        }else if(posts[i].imagesOrVideos.length == 2){
                          return StaggeredGridView.countBuilder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            crossAxisCount: 4,
                            itemCount: 2,
                            itemBuilder: (BuildContext context, int index) =>  
                              lookupMimeType(posts[i].imagesOrVideos[index])?.contains('video') == true
                              ? BetterPlayer.network('${posts[i].imagesOrVideos[index]}',
                                betterPlayerConfiguration: BetterPlayerConfiguration(
                                  controlsConfiguration: BetterPlayerControlsConfiguration(
                                    showControls: false,
                                  ),
                                  aspectRatio: 16 / 9,
                                ),
                              )
                              : CachedNetworkImage(
                                fit: BoxFit.contain,
                                imageUrl: posts[i].imagesOrVideos[index],
                                placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                                errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 1.0,),
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
                            itemBuilder: (BuildContext context, int index) => ((){
                              if(index != 1){
                                return lookupMimeType(posts[i].imagesOrVideos[index])?.contains('video') == true
                                ? BetterPlayer.network('${posts[i].imagesOrVideos[index]}',
                                  betterPlayerConfiguration: BetterPlayerConfiguration(
                                    controlsConfiguration: BetterPlayerControlsConfiguration(
                                      showControls: false,
                                    ),
                                    aspectRatio: 16 / 9,
                                  ),
                                )
                                : CachedNetworkImage(
                                  fit: BoxFit.contain,
                                  imageUrl: posts[i].imagesOrVideos[index],
                                  placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                                  errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 1.0,),
                                );
                              }else{
                                return ((){
                                  if(posts[i].imagesOrVideos.length - 3 > 0){
                                    if(lookupMimeType(posts[i].imagesOrVideos[index])?.contains('video') == true){
                                      return Stack(
                                        children: [
                                          BetterPlayer.network('${posts[i].imagesOrVideos[index]}',
                                            betterPlayerConfiguration: BetterPlayerConfiguration(
                                              controlsConfiguration: BetterPlayerControlsConfiguration(
                                                showControls: false,
                                              ),
                                              aspectRatio: 16 / 9,
                                            ),
                                          ),

                                          Container(color: Colors.black.withOpacity(0.5),),

                                          Center(
                                            child: CircleAvatar(
                                              radius: 25,
                                              backgroundColor: Color(0xffffffff).withOpacity(.5),
                                              child: Text(
                                                '${posts[i].imagesOrVideos.length - 3}',
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
                                            fit: BoxFit.fill,
                                            imageUrl: posts[i].imagesOrVideos[index],
                                            placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                                            errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 1.0,),
                                          ),

                                          Container(color: Colors.black.withOpacity(0.5),),

                                          Center(
                                            child: CircleAvatar(
                                              radius: 25,
                                              backgroundColor: Color(0xffffffff).withOpacity(.5),
                                              child: Text(
                                                '${posts[i].imagesOrVideos.length - 3}',
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
                                    if(lookupMimeType(posts[i].imagesOrVideos[index])?.contains('video') == true){
                                      return BetterPlayer.network('${posts[i].imagesOrVideos[index]}',
                                        betterPlayerConfiguration: BetterPlayerConfiguration(
                                          controlsConfiguration: BetterPlayerControlsConfiguration(
                                            showControls: false,
                                          ),
                                          aspectRatio: 16 / 9,
                                        ),
                                      );
                                    }else{
                                      return CachedNetworkImage(
                                        fit: BoxFit.fill,
                                        imageUrl: posts[i].imagesOrVideos[index],
                                        placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                                        errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 1.0,),
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
                : Container(height: 0),

              ],
            );
          }
        ),
      )
      // ? SmartRefresher(
      //   enablePullDown: true,
      //   enablePullUp: true,
      //   header: MaterialClassicHeader(
      //     color: Color(0xffffffff),
      //     backgroundColor: Color(0xff4EC9D4),
      //   ),
      //   footer: CustomFooter(
      //     loadStyle: LoadStyle.ShowWhenLoading,
      //     builder: (BuildContext context, LoadStatus mode){
      //       Widget body = Container();
      //       if(mode == LoadStatus.loading){
      //         body = CircularProgressIndicator();
      //       }
      //       return Center(child: body);
      //     },
      //   ),
      //   controller: refreshController,
      //   onRefresh: onRefresh,
      //   onLoading: onLoading,
      //   child: ListView.separated(
      //     padding: EdgeInsets.all(10.0),
      //     physics: ClampingScrollPhysics(),
      //     shrinkWrap: true,
      //     itemBuilder: (c, i) {
      //       return MiscRegularPost(
      //         userId: posts[i].userId,
      //         postId: posts[i].postId,
      //         memorialId: posts[i].memorialId,
      //         memorialName: posts[i].memorialName,
      //         timeCreated: timeago.format(DateTime.parse(posts[i].timeCreated)),
      //         managed: posts[i].managed,
      //         joined: posts[i].joined,
      //         profileImage: posts[i].profileImage,
      //         numberOfComments: posts[i].numberOfComments,
      //         numberOfLikes: posts[i].numberOfLikes,
      //         likeStatus: posts[i].likeStatus,
      //         numberOfTagged: posts[i].numberOfTagged,
      //         taggedFirstName: posts[i].taggedFirstName,
      //         taggedLastName: posts[i].taggedLastName,
      //         taggedId: posts[i].taggedId,
              
      //         relationship: posts[i].relationship,
      //         pageType: posts[i].pageType,
      //         famOrFriends: posts[i].famOrFriends,
      //         contents: [

      //           Container(alignment: Alignment.centerLeft, child: Text(posts[i].postBody, overflow: TextOverflow.ellipsis, maxLines: 5,),),

      //           posts[i].imagesOrVideos != []
      //           ? Column(
      //             children: [
      //               SizedBox(height: 20),

      //               Container(
      //                 child: ((){
      //                   if(posts[i].imagesOrVideos != []){
      //                     if(posts[i].imagesOrVideos.length == 1){
      //                       if(lookupMimeType(posts[i].imagesOrVideos[0])?.contains('video') == true){
      //                         return BetterPlayer.network('${posts[i].imagesOrVideos[0]}',
      //                           betterPlayerConfiguration: BetterPlayerConfiguration(
      //                             controlsConfiguration: BetterPlayerControlsConfiguration(
      //                               showControls: false,
      //                             ),
      //                             aspectRatio: 16 / 9,
      //                           ),
      //                         );
      //                       }else{
      //                         return Container(
      //                           child: CachedNetworkImage(
      //                             fit: BoxFit.contain,
      //                             imageUrl: posts[i].imagesOrVideos[0],
      //                             placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
      //                             errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 1.0,),
      //                           ),
      //                         );
      //                       }
      //                     }else if(posts[i].imagesOrVideos.length == 2){
      //                       return StaggeredGridView.countBuilder(
      //                         padding: EdgeInsets.zero,
      //                         shrinkWrap: true,
      //                         physics: NeverScrollableScrollPhysics(),
      //                         crossAxisCount: 4,
      //                         itemCount: 2,
      //                         itemBuilder: (BuildContext context, int index) =>  
      //                           lookupMimeType(posts[i].imagesOrVideos[index])?.contains('video') == true
      //                           ? BetterPlayer.network('${posts[i].imagesOrVideos[index]}',
      //                             betterPlayerConfiguration: BetterPlayerConfiguration(
      //                               controlsConfiguration: BetterPlayerControlsConfiguration(
      //                                 showControls: false,
      //                               ),
      //                               aspectRatio: 16 / 9,
      //                             ),
      //                           )
      //                           : CachedNetworkImage(
      //                             fit: BoxFit.contain,
      //                             imageUrl: posts[i].imagesOrVideos[index],
      //                             placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
      //                             errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 1.0,),
      //                           ),
      //                         staggeredTileBuilder: (int index) => StaggeredTile.count(2, 2),
      //                         mainAxisSpacing: 4.0,
      //                         crossAxisSpacing: 4.0,
      //                       );
      //                     }else{
      //                       return StaggeredGridView.countBuilder(
      //                         padding: EdgeInsets.zero,
      //                         shrinkWrap: true,
      //                         physics: NeverScrollableScrollPhysics(),
      //                         crossAxisCount: 4,
      //                         itemCount: 3,
      //                         itemBuilder: (BuildContext context, int index) => 
      //                         ((){
      //                           if(index != 1){
      //                             return lookupMimeType(posts[i].imagesOrVideos[index])?.contains('video') == true
      //                             ? BetterPlayer.network('${posts[i].imagesOrVideos[index]}',
      //                               betterPlayerConfiguration: BetterPlayerConfiguration(
      //                                 controlsConfiguration: BetterPlayerControlsConfiguration(
      //                                   showControls: false,
      //                                 ),
      //                                 aspectRatio: 16 / 9,
      //                               ),
      //                             )
      //                             : CachedNetworkImage(
      //                               fit: BoxFit.contain,
      //                               imageUrl: posts[i].imagesOrVideos[index],
      //                               placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
      //                               errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 1.0,),
      //                             );
                                  
      //                           }else{
      //                             return ((){
      //                               if(posts[i].imagesOrVideos.length - 3 > 0){
      //                                 if(lookupMimeType(posts[i].imagesOrVideos[index])?.contains('video') == true){
      //                                   return Stack(
      //                                     children: [
      //                                       BetterPlayer.network('${posts[i].imagesOrVideos[index]}',
      //                                         betterPlayerConfiguration: BetterPlayerConfiguration(
      //                                           controlsConfiguration: BetterPlayerControlsConfiguration(
      //                                             showControls: false,
      //                                           ),
      //                                           aspectRatio: 16 / 9,
      //                                         ),
      //                                       ),

      //                                       Container(color: Colors.black.withOpacity(0.5),),

      //                                       Center(
      //                                         child: CircleAvatar(
      //                                           radius: 25,
      //                                           backgroundColor: Color(0xffffffff).withOpacity(.5),
      //                                           child: Text(
      //                                             '${posts[i].imagesOrVideos.length - 3}',
      //                                             style: TextStyle(
      //                                               fontSize: 40,
      //                                               fontWeight: FontWeight.bold,
      //                                               color: Color(0xffffffff),
      //                                             ),
      //                                           ),
      //                                         ),
      //                                       ),
      //                                     ],
      //                                   );
      //                                 }else{
      //                                   return Stack(
      //                                     children: [
      //                                       CachedNetworkImage(
      //                                         fit: BoxFit.contain,
      //                                         imageUrl: posts[i].imagesOrVideos[index],
      //                                         placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
      //                                         errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 1.0,),
      //                                       ),

      //                                       Container(color: Colors.black.withOpacity(0.5),),

      //                                       Center(
      //                                         child: CircleAvatar(
      //                                           radius: 25,
      //                                           backgroundColor: Color(0xffffffff).withOpacity(.5),
      //                                           child: Text(
      //                                             '${posts[i].imagesOrVideos.length - 3}',
      //                                             style: TextStyle(
      //                                               fontSize: 40,
      //                                               fontWeight: FontWeight.bold,
      //                                               color: Color(0xffffffff),
      //                                             ),
      //                                           ),
      //                                         ),
      //                                       ),
      //                                     ],
      //                                   );
      //                                 }
      //                               }else{
      //                                 if(lookupMimeType(posts[i].imagesOrVideos[index])?.contains('video') == true){
      //                                   return BetterPlayer.network('${posts[i].imagesOrVideos[index]}',
      //                                     betterPlayerConfiguration: BetterPlayerConfiguration(
      //                                       controlsConfiguration: BetterPlayerControlsConfiguration(
      //                                         showControls: false,
      //                                       ),
      //                                       aspectRatio: 16 / 9,
      //                                     ),
      //                                   );
      //                                 }else{
      //                                   return CachedNetworkImage(
      //                                     fit: BoxFit.contain,
      //                                     imageUrl: posts[i].imagesOrVideos[index],
      //                                     placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
      //                                     errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 1.0,),
      //                                   );
      //                                 }
      //                               }
      //                             }());
      //                           }
      //                         }()),
      //                         staggeredTileBuilder: (int index) => StaggeredTile.count(2, index.isEven ? 1 : 2),
      //                         mainAxisSpacing: 4.0,
      //                         crossAxisSpacing: 4.0,
      //                       );
      //                     }
      //                   }else{
      //                     return Container(height: 0,);
      //                   }
      //                 }()),
      //               ),
                    
      //             ],
      //           )
      //           : Container(height: 0),
      //         ]
      //       );
      //     },
      //     separatorBuilder: (c, i) => Divider(height: 20, color: Colors.transparent),
      //     itemCount: posts.length,
      //   ),
      // )
      : SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              SizedBox(height: (SizeConfig.screenHeight! - 85 - kToolbarHeight) / 3.5,),

              Image.asset('assets/icons/app-icon.png', height: 250, width: 250,),

              SizedBox(height: 45,),

              Text('Post is empty', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xffB1B1B1),),),

              SizedBox(height: (SizeConfig.screenHeight! - 85 - kToolbarHeight) / 3.5,),
            ],
          ),
        ),
      ),
    );
  }
}


