// import 'package:better_player/better_player.dart';
import 'package:facesbyplaces/API/Regular/13-Show-User/api-show-user-regular-02-show-user-posts.dart';
import 'package:facesbyplaces/API/Regular/13-Show-User/api-show-user-regular-03-show-user-memorials.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
// import 'package:mime/mime.dart';
// import 'package:sliding_up_panel/sliding_up_panel.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:loader_overlay/loader_overlay.dart';
// import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/material.dart';
import 'misc-03-regular-manage-memorial.dart';
// import 'misc-04-regular-post.dart';

class MiscRegularUserProfileDraggableSwitchTabs extends StatefulWidget{
  final int userId;
  MiscRegularUserProfileDraggableSwitchTabs({required this.userId});

  MiscRegularUserProfileDraggableSwitchTabsState createState() => MiscRegularUserProfileDraggableSwitchTabsState(userId: userId);
}

class MiscRegularUserProfileDraggableSwitchTabsState extends State<MiscRegularUserProfileDraggableSwitchTabs>{
  final int userId;
  MiscRegularUserProfileDraggableSwitchTabsState({required this.userId});

  int currentIndex = 0;
  List<Widget> children = [];

  @override
  void initState(){
    super.initState();
    children = [MiscRegularDraggablePost(userId: userId,), MiscRegularDraggableMemorials(userId: userId,)];
  }

  @override
  Widget build(BuildContext context){
    SizeConfig.init(context);
    return Container();
    // return SlidingUpPanel(
    //   onPanelOpened: (){
    //     setState(() {
    //       print('Opened!');
    //     });
    //   },
    //   maxHeight: SizeConfig.screenHeight! / 1.5,
    //   header: Container(
    //     alignment: Alignment.center,
    //     width: SizeConfig.screenWidth,
    //     height: 70,
    //     child: DefaultTabController(
    //       length: 2,
    //       initialIndex: currentIndex,
    //       child: TabBar(
    //         isScrollable: false,
    //         labelColor: Color(0xff04ECFF),
    //         unselectedLabelColor: Color(0xffCDEAEC),
    //         indicatorColor: Color(0xff04ECFF),
    //         onTap: (int number){
    //           setState(() {
    //             currentIndex = number;
    //             print('The currentIndex is $currentIndex');
    //           });
    //         },
    //         tabs: [

    //           Container(
    //             width: SizeConfig.screenWidth! / 2.5,
    //             child: Center(
    //               child: Text('Post',
    //                 style: TextStyle(
    //                   fontSize: 16,
    //                   fontWeight: FontWeight.w400,
    //                 ),
    //               ),
    //             ),
    //           ),

    //           Container(
    //             width: SizeConfig.screenWidth! / 2.5,
    //             child: Center(
    //               child: Text('Memorials',
    //                 style: TextStyle(
    //                   fontSize: 16,
    //                   fontWeight: FontWeight.w400,
    //                 ),
    //               ),
    //             ),
    //           ),

    //         ],
    //       ),
    //     ),
    //     decoration: BoxDecoration(
    //       color: Color(0xffffffff),
    //       borderRadius: BorderRadius.only(
    //         topLeft: Radius.circular(50.0),
    //         topRight: Radius.circular(50.0),
    //       ),
    //     ),
    //   ),
    //   borderRadius: BorderRadius.only(
    //     topLeft: Radius.circular(50.0),
    //     topRight: Radius.circular(50.0),
    //   ),
    //   panel: Column(
    //     children: [
    //       Container(width: SizeConfig.screenWidth, height: 70,), // SERVES AS THE SPACE FOR THE CONTENT TO BE SHOW

    //       Expanded(
    //         child: Container(
    //           child: IndexedStack(
    //             index: currentIndex,
    //             children: children,
    //           ),
    //         ),
    //       ),

    //     ],
    //   ),
    //   collapsed: Container(
    //     decoration: BoxDecoration(
    //       color: Color(0xffffffff),
    //       borderRadius: BorderRadius.only(
    //         topLeft: Radius.circular(50.0),
    //         topRight: Radius.circular(50.0),
    //       ),
    //     ),
    //   ),
    // );
  }
}

class RegularMiscDraggablePost{
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

  RegularMiscDraggablePost({required this.userId, required this.postId, required this.memorialId, required this.memorialName, required this.timeCreated, required this.postBody, required this.profileImage, required this.imagesOrVideos, required this.managed, required this.joined, required this.numberOfLikes, required this.numberOfComments, required this.likeStatus, required this.numberOfTagged, required this.taggedFirstName, required this.taggedLastName, required this.taggedImage, required this.taggedId});
}

class MiscRegularDraggablePost extends StatefulWidget{
  final int userId;
  MiscRegularDraggablePost({required this.userId});

  MiscRegularDraggablePostState createState() => MiscRegularDraggablePostState(userId: userId);
}

class MiscRegularDraggablePostState extends State<MiscRegularDraggablePost>{
  final int userId;
  MiscRegularDraggablePostState({required this.userId});
  
  // RefreshController refreshController = RefreshController(initialRefresh: true);
  List<RegularMiscDraggablePost> posts = [];
  int itemRemaining = 1;
  int page = 1;
  int count = 0;

  void initState(){
    super.initState();
    onLoading();
  }

  // void onRefresh() async{
  //   await Future.delayed(Duration(milliseconds: 1000));
  //   refreshController.refreshCompleted();
  // }

  void onLoading() async{
    if(itemRemaining != 0){
      context.showLoaderOverlay();

      var newValue = await apiRegularShowUserPosts(userId: userId, page: page);
      itemRemaining = newValue.almItemsRemaining;
      count = count + newValue.almFamilyMemorialList.length;

      for(int i = 0; i < newValue.almFamilyMemorialList.length; i++){
        List<String> newList1 = [];
        List<String> newList2 = [];
        List<String> newList3 = [];
        List<int> newList4 = [];

        for(int j = 0; j < newValue.almFamilyMemorialList[i].showUsersPostsPostTagged.length; j++){
          newList1.add(newValue.almFamilyMemorialList[i].showUsersPostsPostTagged[j].showUsersPostsTaggedFirstName);
          newList2.add(newValue.almFamilyMemorialList[i].showUsersPostsPostTagged[j].showUsersPostsTaggedLastName);
          newList3.add(newValue.almFamilyMemorialList[i].showUsersPostsPostTagged[j].showUsersPostsTaggedImage);
          newList4.add(newValue.almFamilyMemorialList[i].showUsersPostsPostTagged[j].showUsersPostsTaggedId);
        }

        posts.add(
          RegularMiscDraggablePost(
            userId: newValue.almFamilyMemorialList[i].showUsersPostsPage.showUsersPostsPagePageCreator.showUsersPostsPageCreatorId,
            postId: newValue.almFamilyMemorialList[i].showUsersPostsId,
            memorialId: newValue.almFamilyMemorialList[i].showUsersPostsPage.showUsersPostsPageId,
            timeCreated: newValue.almFamilyMemorialList[i].showUsersPostsCreatedAt,
            memorialName: newValue.almFamilyMemorialList[i].showUsersPostsPage.showUsersPostsPageName,
            postBody: newValue.almFamilyMemorialList[i].showUsersPostsBody,
            profileImage: newValue.almFamilyMemorialList[i].showUsersPostsPage.showUsersPostsPageProfileImage,
            imagesOrVideos: newValue.almFamilyMemorialList[i].showUsersPostsImagesOrVideos,
            managed: newValue.almFamilyMemorialList[i].showUsersPostsPage.showUsersPostsPageManage,
            joined: newValue.almFamilyMemorialList[i].showUsersPostsPage.showUsersPostsPageFollower,
            numberOfComments: newValue.almFamilyMemorialList[i].showUsersPostsNumberOfComments,
            numberOfLikes: newValue.almFamilyMemorialList[i].showUsersPostsNumberOfLikes,
            likeStatus: newValue.almFamilyMemorialList[i].showUsersPostsLikeStatus,
            numberOfTagged: newValue.almFamilyMemorialList[i].showUsersPostsPostTagged.length,
            taggedFirstName: newList1,
            taggedLastName: newList2,
            taggedImage: newList3,
            taggedId: newList4,
          ),    
        );
      }

      if(mounted)
      setState(() {});
      page++;
      
      // refreshController.loadComplete();
      context.hideLoaderOverlay();
    }else{
      // refreshController.loadNoData();
    }
  }


  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Container(
      width: SizeConfig.screenWidth,
      child: count != 0
      ? Container()
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

      //         famOrFriends: false,
      //         pageType: 'Alm',
      //         relationship: 'Relationship',
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

              SizedBox(height: (SizeConfig.screenHeight! / 1.5) / 3,),

              Image.asset('assets/icons/app-icon.png', height: 250, width: 250,),

              SizedBox(height: 45,),

              Text('Post is empty', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xffB1B1B1),),),

              SizedBox(height: (SizeConfig.screenHeight! / 1.5) / 3,),
            ],
          ),
        ),
      ),
    );
  }
}

class MiscRegularDraggableMemorials extends StatefulWidget{
  final int userId;
  MiscRegularDraggableMemorials({required this.userId});

  MiscRegularDraggableMemorialsState createState() => MiscRegularDraggableMemorialsState(userId: userId);
}

class MiscRegularDraggableMemorialsState extends State<MiscRegularDraggableMemorials>{
  final int userId;
  MiscRegularDraggableMemorialsState({required this.userId});

  // RefreshController refreshController = RefreshController(initialRefresh: true);
  List<Widget> finalMemorials = [];
  int ownedItemsRemaining = 1;
  int followedItemsRemaining = 1;
  int page1 = 1;
  int page2 = 1;
  bool flag1 = false;
  int count = 0;

  void initState(){
    super.initState();
    addMemorials1();
    onLoading();
  }
  
  // void onRefresh() async{
  //   await Future.delayed(Duration(milliseconds: 1000));
  //   refreshController.refreshCompleted();
  // }

  void addMemorials1(){
    finalMemorials.add(
      Container(
        height: 80,
        padding: EdgeInsets.only(left: 20.0, right: 20.0),
        color: Color(0xffeeeeee),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text('Owned',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xff000000),
            ),
          ),
        ),
      ),
    );
  }

  void addMemorials2(){
    finalMemorials.add(
      Container(
        height: 80,
        padding: EdgeInsets.only(left: 20.0, right: 20.0),
        color: Color(0xffeeeeee),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text('Followed',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xff000000),
            ),
          ),
        ),
      ),
    );
  }

  void onLoading() async{

    if(flag1 == false){
      onLoading1();
    }else{
      onLoading2();
    }
  }

  void onLoading1() async{

    if(ownedItemsRemaining != 0){
      context.showLoaderOverlay();
      var newValue = await apiRegularShowUserMemorials(userId: userId, page: page1);
      context.hideLoaderOverlay();

      ownedItemsRemaining = newValue.almOwnedItemsRemaining;
      count = count + newValue.almOwned.length;

      for(int i = 0; i < newValue.almOwned.length; i++){
        finalMemorials.add(
          MiscRegularManageMemorialTab(
            index: i,
            memorialName: newValue.almOwned[i].showUserMemorialsPage.showUserMemorialsPageName,
            description: newValue.almOwned[i].showUserMemorialsPage.showUserMemorialsPageDetails.showUserMemorialsPageDetailsDescription,
            image: newValue.almOwned[i].showUserMemorialsPage.showUserMemorialsPageProfileImage,
            memorialId: newValue.almOwned[i].showUserMemorialsPage.showUserMemorialsPageId,
            managed: newValue.almOwned[i].showUserMemorialsPage.showUserMemorialsPageManage,
            follower: newValue.almOwned[i].showUserMemorialsPage.showUserMemorialsPageFollower,
            famOrFriends: newValue.almOwned[i].showUserMemorialsPage.showUserMemorialsPageFamOrFriends,
            pageType: newValue.almOwned[i].showUserMemorialsPage.showUserMemorialsPageType,
            relationship: newValue.almOwned[i].showUserMemorialsPage.showUserMemorialsPageRelationship,
          ),
        );
      }

      if(mounted)
      setState(() {});
      page1++;

      if(ownedItemsRemaining == 0){
        addMemorials2();
        setState(() {
          flag1 = true;
        });
        onLoading();
      }

      // refreshController.loadComplete();
    }
  }

  void onLoading2() async{

    if(followedItemsRemaining != 0){
      context.showLoaderOverlay();
      var newValue = await apiRegularShowUserMemorials(userId: userId, page: page2);
      context.hideLoaderOverlay();

      followedItemsRemaining = newValue.almFollowedItemsRemaining;
      count = count + newValue.almFollowed.length;

      for(int i = 0; i < newValue.almFollowed.length; i++){
        finalMemorials.add(
          MiscRegularManageMemorialTab(
            index: i,
            memorialName: newValue.almFollowed[i].showUserMemorialsPage.showUserMemorialsPageName,
            description: newValue.almFollowed[i].showUserMemorialsPage.showUserMemorialsPageDetails.showUserMemorialsPageDetailsDescription,
            image: newValue.almFollowed[i].showUserMemorialsPage.showUserMemorialsPageProfileImage,
            memorialId: newValue.almFollowed[i].showUserMemorialsPage.showUserMemorialsPageId,
            managed: newValue.almFollowed[i].showUserMemorialsPage.showUserMemorialsPageManage,
            follower: newValue.almFollowed[i].showUserMemorialsPage.showUserMemorialsPageFollower,
            famOrFriends: newValue.almFollowed[i].showUserMemorialsPage.showUserMemorialsPageFamOrFriends,
            pageType: newValue.almFollowed[i].showUserMemorialsPage.showUserMemorialsPageType,
            relationship: newValue.almFollowed[i].showUserMemorialsPage.showUserMemorialsPageRelationship,
          ),
        );
      }

      if(mounted)
      setState(() {});
      page2++;

      // refreshController.loadComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Container(
      height: SizeConfig.screenHeight! / 1.5,
      width: SizeConfig.screenWidth,
      child: count != 0
      ? Container()
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
      //     physics: ClampingScrollPhysics(),
      //     itemBuilder: (c, i) {
      //       return finalMemorials[i];
      //     },
      //     separatorBuilder: (c, i) => Divider(height: 10, color: Colors.transparent),
      //     itemCount: finalMemorials.length,
      //   ),
      // )
      : SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              SizedBox(height: (SizeConfig.screenHeight! / 1.5) / 3,),

              Image.asset('assets/icons/app-icon.png', height: 250, width: 250,),

              SizedBox(height: 45,),

              Text('Memorial is empty', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xffB1B1B1),),),

              SizedBox(height: (SizeConfig.screenHeight! / 1.5) / 3,),
            ],
          ),
        ),
      ),
    );
  }
}