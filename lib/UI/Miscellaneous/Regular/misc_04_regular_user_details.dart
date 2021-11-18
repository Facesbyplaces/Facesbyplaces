import 'package:facesbyplaces/API/Regular/13-Show-User/api_show_user_regular_02_show_user_posts.dart';
import 'package:facesbyplaces/API/Regular/13-Show-User/api_show_user_regular_03_show_user_memorials.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:better_player/better_player.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'misc_01_regular_manage_memorial.dart';
import 'package:flutter/material.dart';
import 'misc_02_regular_post.dart';
import 'package:mime/mime.dart';

class RegularMiscDraggablePost{
  final int userId;
  final int postId;
  final int memorialId;
  final String memorialName;
  final String timeCreated;
  final String postBody;
  final dynamic profileImage;
  final List<dynamic> imagesOrVideos;
  final bool managed;
  final bool joined;
  final int numberOfLikes;
  final int numberOfComments;
  final bool likeStatus;
  final int numberOfTagged;
  final List<String> taggedFirstName;
  final List<String> taggedLastName;
  final List<String> taggedImage;
  final List<int> taggedId;
  final String pageType;
  final bool famOrFriends;
  final String relationship;
  final String location;
  final double latitude;
  final double longitude;
  const RegularMiscDraggablePost({required this.userId, required this.postId, required this.memorialId, required this.memorialName, required this.timeCreated, required this.postBody, required this.profileImage, required this.imagesOrVideos, required this.managed, required this.joined, required this.numberOfLikes, required this.numberOfComments, required this.likeStatus, required this.numberOfTagged, required this.taggedFirstName, required this.taggedLastName, required this.taggedImage, required this.taggedId, required this.pageType, required this.famOrFriends, required this.relationship, required this.location, required this.latitude, required this.longitude});
}

class MiscRegularDraggablePost extends StatefulWidget{
  final int userId;
  final int accountType;
  const MiscRegularDraggablePost({Key? key, required this.userId, required this.accountType}) : super(key: key);

  @override
  MiscRegularDraggablePostState createState() => MiscRegularDraggablePostState();
}

class MiscRegularDraggablePostState extends State<MiscRegularDraggablePost>{
  ScrollController scrollController = ScrollController();
  ValueNotifier<int> count = ValueNotifier<int>(0);
  List<RegularMiscDraggablePost> posts = [];
  int itemRemaining = 1;
  int page = 1;

  @override
  void initState(){
    super.initState();
    onLoading();
    scrollController.addListener((){
      if(scrollController.position.pixels == scrollController.position.maxScrollExtent){
        if(itemRemaining != 0){
          onLoading();
        }else{
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No more posts to show'), duration: Duration(seconds: 1), backgroundColor: Color(0xff4EC9D4),),);
        }
      }
    });
  }

  Future<void> onRefresh() async{
    onLoading();
  }

  void onLoading() async{
    if(itemRemaining != 0){
      context.loaderOverlay.show();
      var newValue = await apiRegularShowUserPosts(userId: widget.userId, accountType: widget.accountType, page: page);

      itemRemaining = newValue.almItemsRemaining;
      count.value = count.value + newValue.almFamilyMemorialList.length;

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
            pageType: newValue.almFamilyMemorialList[i].showUsersPostsPage.showUsersPostsPagePageType,
            famOrFriends: newValue.almFamilyMemorialList[i].showUsersPostsPage.showUsersPostsPageFamOrFriends,
            relationship: newValue.almFamilyMemorialList[i].showUsersPostsPage.showUsersPostsPageRelationship,
            location: newValue.almFamilyMemorialList[i].showUsersPostsLocation,
            latitude: newValue.almFamilyMemorialList[i].showUsersPostsLatitude,
            longitude: newValue.almFamilyMemorialList[i].showUsersPostsLongitude,
          ),
        );
      }

      if(mounted){
        page++;
      }
      
      context.loaderOverlay.hide();
    }
  }


  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return ValueListenableBuilder(
      valueListenable: count,
      builder: (_, int countListener, __) => SizedBox(
        width: SizeConfig.screenWidth,
        child: countListener != 0
        ? RefreshIndicator(
          onRefresh: onRefresh,
          child: ListView.separated(
            controller: scrollController,
            separatorBuilder: (c, i) => const Divider(height: 10, color: Colors.transparent),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            physics: const ClampingScrollPhysics(),
            itemCount: posts.length,
            itemBuilder: (c, i){
              return MiscRegularPost(
                key: ValueKey('$i'),
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
                location: posts[i].location,
                latitude: posts[i].latitude,
                longitude: posts[i].longitude,
                // isGuest: isGuestLoggedIn.value,
                isGuest: false,
                contents: [
                  Align(alignment: Alignment.centerLeft, child: Text(posts[i].postBody, overflow: TextOverflow.ellipsis, maxLines: 5, style: const TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xff000000),),),),

                  posts[i].imagesOrVideos.isNotEmpty
                  ? Column(
                    children: [
                      const SizedBox(height: 20),

                      SizedBox(
                        child: ((){
                          if(posts[i].imagesOrVideos.length == 1){
                            if(lookupMimeType(posts[i].imagesOrVideos[0])?.contains('video') == true){
                              return BetterPlayer.network('${posts[i].imagesOrVideos[0]}',
                                betterPlayerConfiguration: BetterPlayerConfiguration(
                                  placeholder: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 16 / 9),
                                  controlsConfiguration: const BetterPlayerControlsConfiguration(showControls: false,),
                                  aspectRatio: 16 / 9,
                                  fit: BoxFit.contain,
                                ),
                              );
                            }else{
                              return CachedNetworkImage(
                                errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 1.0,),
                                placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                imageUrl: posts[i].imagesOrVideos[0],
                                fit: BoxFit.contain,
                              );
                            }
                          }else if(posts[i].imagesOrVideos.length == 2){
                            return StaggeredGridView.countBuilder(
                              staggeredTileBuilder: (int index) => const StaggeredTile.count(2, 2),
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.zero,
                              crossAxisSpacing: 4.0,
                              mainAxisSpacing: 4.0,
                              crossAxisCount: 4,
                              shrinkWrap: true,
                              itemCount: 2,
                              itemBuilder: (BuildContext context, int index) => lookupMimeType(posts[i].imagesOrVideos[index])?.contains('video') == true
                              ? BetterPlayer.network('${posts[i].imagesOrVideos[index]}',
                                betterPlayerConfiguration: BetterPlayerConfiguration(
                                  placeholder: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 16 / 9),
                                  controlsConfiguration: const BetterPlayerControlsConfiguration(showControls: false,),
                                  aspectRatio: 16 / 9,
                                  fit: BoxFit.contain,
                                ),
                              )
                              : CachedNetworkImage(
                                errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 1.0,),
                                placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                imageUrl: posts[i].imagesOrVideos[index],
                                fit: BoxFit.contain,
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
                              itemBuilder: (BuildContext context, int index) => ((){
                                if(index != 1){
                                  return lookupMimeType(posts[i].imagesOrVideos[index])?.contains('video') == true
                                  ? BetterPlayer.network('${posts[i].imagesOrVideos[index]}',
                                    betterPlayerConfiguration: BetterPlayerConfiguration(
                                      placeholder: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 16 / 9),
                                      controlsConfiguration: const BetterPlayerControlsConfiguration(showControls: false,),
                                      aspectRatio: 16 / 9,
                                      fit: BoxFit.contain,
                                    ),
                                  )
                                  : CachedNetworkImage(
                                    errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 1.0,),
                                    placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                    imageUrl: posts[i].imagesOrVideos[index],
                                    fit: BoxFit.contain,
                                  );
                                }else{
                                  return ((){
                                    if(posts[i].imagesOrVideos.length - 3 > 0){
                                      if(lookupMimeType(posts[i].imagesOrVideos[index])?.contains('video') == true){
                                        return Stack(
                                          children: [
                                            BetterPlayer.network('${posts[i].imagesOrVideos[index]}',
                                              betterPlayerConfiguration: BetterPlayerConfiguration(
                                                placeholder: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 16 / 9),
                                                controlsConfiguration: const BetterPlayerControlsConfiguration(showControls: false,),
                                                aspectRatio: 16 / 9,
                                                fit: BoxFit.contain,
                                              ),
                                            ),

                                            Container(color: Colors.black.withOpacity(0.5),),

                                            Center(
                                              child: CircleAvatar(
                                                radius: 25,
                                                backgroundColor: const Color(0xffffffff).withOpacity(.5),
                                                child: Text('${posts[i].imagesOrVideos.length - 3}', style: const TextStyle(fontSize: 32, fontFamily: 'NexaBold', color: Color(0xffFFFFFF),),),
                                              ),
                                            ),
                                          ],
                                        );
                                      }else{
                                        return Stack(
                                          children: [
                                            CachedNetworkImage(
                                              errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 1.0,),
                                              placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                              imageUrl: posts[i].imagesOrVideos[index],
                                              fit: BoxFit.fill,
                                            ),

                                            Container(color: Colors.black.withOpacity(0.5),),

                                            Center(
                                              child: CircleAvatar(
                                                child: Text('${posts[i].imagesOrVideos.length - 3}', style: const TextStyle(fontSize: 32, fontFamily: 'NexaBold', color: Color(0xffFFFFFF),),),
                                                backgroundColor: const Color(0xffffffff).withOpacity(.5),
                                                radius: 25,
                                              ),
                                            ),
                                          ],
                                        );
                                      }
                                    }else{
                                      if(lookupMimeType(posts[i].imagesOrVideos[index])?.contains('video') == true){
                                        return BetterPlayer.network('${posts[i].imagesOrVideos[index]}',
                                          betterPlayerConfiguration: BetterPlayerConfiguration(
                                            placeholder: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 16 / 9),
                                            controlsConfiguration: const BetterPlayerControlsConfiguration(showControls: false,),
                                            aspectRatio: 16 / 9,
                                            fit: BoxFit.contain,
                                          ),
                                        );
                                      }else{
                                        return CachedNetworkImage(
                                          errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 1.0,),
                                          placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                          imageUrl: posts[i].imagesOrVideos[index],
                                          fit: BoxFit.fill,
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
            },
          )
        )
        : SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: (SizeConfig.screenHeight! / 1.5) / 3,),

              Image.asset('assets/icons/app-icon.png', height: 200, width: 200,),

              const SizedBox(height: 45,),

              const Text('Post is empty', style: TextStyle(fontSize: 36, fontFamily: 'NexaBold', color: Color(0xffB1B1B1),),),

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
  final int accountType;
  const MiscRegularDraggableMemorials({Key? key, required this.userId, required this.accountType}) : super(key: key);

  @override
  MiscRegularDraggableMemorialsState createState() => MiscRegularDraggableMemorialsState();
}

class MiscRegularDraggableMemorialsState extends State<MiscRegularDraggableMemorials>{
  ScrollController scrollController = ScrollController();
  ValueNotifier<int> count = ValueNotifier<int>(0);
  List<Widget> finalMemorials = [];
  int followedItemsRemaining = 1;
  int ownedItemsRemaining = 1;
  bool flag1 = false;
  int page1 = 1;
  int page2 = 1;

  @override
  void initState(){
    super.initState();
    addMemorials1();
    onLoading();
    scrollController.addListener((){
      if(scrollController.position.pixels == scrollController.position.maxScrollExtent){
        if(ownedItemsRemaining != 0 && followedItemsRemaining != 0){
          onLoading();
        }else{
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No more memorials to show'), duration: Duration(seconds: 1), backgroundColor: Color(0xff4EC9D4),),);
        }
      }
    });
  }

  Future<void> onRefresh() async{
    if(ownedItemsRemaining == 0 && followedItemsRemaining == 0 && flag1 == false){
      flag1 = true;
      onLoading();
    }else{
      onLoading();
    }
  }

  void addMemorials1(){
    finalMemorials.add(
      Container(
        height: 80,
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        color: const Color(0xffeeeeee),
        child: const Align(alignment: Alignment.centerLeft, child: Text('Owned', style: TextStyle(fontSize: 26, fontFamily: 'NexaBold', color: Color(0xff2F353D),),),),
      ),
    );
  }

  void addMemorials2(){
    finalMemorials.add(
      Container(
        height: 80,
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        color: const Color(0xffeeeeee),
        child: const Align(alignment: Alignment.centerLeft, child: Text('Followed', style: TextStyle(fontSize: 26, fontFamily: 'NexaBold', color: Color(0xff2F353D),),),),
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
      context.loaderOverlay.show();
      var newValue = await apiRegularShowUserMemorials(userId: widget.userId, accountType: widget.accountType, page: page1);

      ownedItemsRemaining = newValue.almOwnedItemsRemaining;
      count.value = count.value + newValue.almOwned.length;

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
            isGuest: false,
          ),
        );
      }

      if(mounted){
        page1++;
      }
      
      context.loaderOverlay.hide();

      if(ownedItemsRemaining == 0){
        addMemorials2();
        flag1 = true;
        onLoading();
      }
    }
  }

  void onLoading2() async{
    if(followedItemsRemaining != 0){
      context.loaderOverlay.show();
      var newValue = await apiRegularShowUserMemorials(userId: widget.userId, accountType: widget.accountType, page: page2);

      followedItemsRemaining = newValue.almFollowedItemsRemaining;
      count.value = count.value + newValue.almFollowed.length;

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
            isGuest: false,
          ),
        );
      }

      if(mounted){
        page2++;
      }
      
      context.loaderOverlay.hide();
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return ValueListenableBuilder(
      valueListenable: count,
      builder: (_, int countListener, __) => SizedBox(
        height: SizeConfig.screenHeight! / 1.5,
        width: SizeConfig.screenWidth,
        child: countListener != 0
        ? RefreshIndicator(
          onRefresh: onRefresh,
          child: ListView.separated(
            controller: scrollController,
            separatorBuilder: (c, i) => const Divider(height: 10, color: Colors.transparent),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
            itemBuilder: (c, i) => finalMemorials[i],
            physics: const ClampingScrollPhysics(),
            itemCount: finalMemorials.length,
          )
        )
        : SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: (SizeConfig.screenHeight! / 1.5) / 3,),

              Image.asset('assets/icons/app-icon.png', height: 200, width: 200,),

              const SizedBox(height: 45,),

              const Text('Memorial is empty', style: TextStyle(fontSize: 36, fontFamily: 'NexaBold', color: Color(0xffB1B1B1),),),

              SizedBox(height: (SizeConfig.screenHeight! / 1.5) / 3,),
            ],
          ),
        ),
      ),
    );
  }
}