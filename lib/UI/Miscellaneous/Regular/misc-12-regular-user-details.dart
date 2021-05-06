import 'package:facesbyplaces/API/Regular/13-Show-User/api-show-user-regular-02-show-user-posts.dart';
import 'package:facesbyplaces/API/Regular/13-Show-User/api-show-user-regular-03-show-user-memorials.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:better_player/better_player.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'misc-03-regular-manage-memorial.dart';
import 'package:flutter/material.dart';
import 'misc-04-regular-post.dart';
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

  const RegularMiscDraggablePost({required this.userId, required this.postId, required this.memorialId, required this.memorialName, required this.timeCreated, required this.postBody, required this.profileImage, required this.imagesOrVideos, required this.managed, required this.joined, required this.numberOfLikes, required this.numberOfComments, required this.likeStatus, required this.numberOfTagged, required this.taggedFirstName, required this.taggedLastName, required this.taggedImage, required this.taggedId, required this.pageType, required this.famOrFriends, required this.relationship});
}

class MiscRegularDraggablePost extends StatefulWidget{
  final int userId;
  const MiscRegularDraggablePost({required this.userId});

  MiscRegularDraggablePostState createState() => MiscRegularDraggablePostState(userId: userId);
}

class MiscRegularDraggablePostState extends State<MiscRegularDraggablePost>{
  final int userId;
  MiscRegularDraggablePostState({required this.userId});
  
  ScrollController scrollController = ScrollController();
  List<RegularMiscDraggablePost> posts = [];
  int itemRemaining = 1;
  int page = 1;
  int count = 0;

  void initState(){
    super.initState();
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
              content: const Text('No more posts to show'),
              duration: const Duration(seconds: 1),
              backgroundColor: const Color(0xff4EC9D4),
            ),
          );
        }
      }
    });
  }

  Future<void> onRefresh() async{
    setState(() {
      onLoading();
    });
  }

  void onLoading() async{
    if(itemRemaining != 0){
      context.loaderOverlay.show();
      var newValue = await apiRegularShowUserPosts(userId: userId, page: page);
      context.loaderOverlay.hide();

      itemRemaining = newValue.almItemsRemaining;
      count = count + newValue.almFamilyMemorialList.length;

      for(int i = 0; i < newValue.almFamilyMemorialList.length; i++){
        const List<String> newList1 = [];
        const List<String> newList2 = [];
        const List<String> newList3 = [];
        const List<int> newList4 = [];

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
          controller: scrollController,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          physics: const ClampingScrollPhysics(),
          itemCount: posts.length,
          separatorBuilder: (c, i) => const Divider(height: 10, color: Colors.transparent),
          itemBuilder: (c, i){
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
                    const SizedBox(height: 20),

                    Container(
                      child: ((){
                        if(posts[i].imagesOrVideos.length == 1){
                          if(lookupMimeType(posts[i].imagesOrVideos[0])?.contains('video') == true){
                            return BetterPlayer.network('${posts[i].imagesOrVideos[0]}',
                              betterPlayerConfiguration: const BetterPlayerConfiguration(
                                controlsConfiguration: const BetterPlayerControlsConfiguration(
                                  showControls: false,
                                ),
                                aspectRatio: 16 / 9,
                              ),
                            );
                          }else{
                            return CachedNetworkImage(
                              fit: BoxFit.contain,
                              imageUrl: posts[i].imagesOrVideos[0],
                              placeholder: (context, url) => const Center(child: const CircularProgressIndicator(),),
                              errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 1.0,),
                            );
                          }
                        }else if(posts[i].imagesOrVideos.length == 2){
                          return StaggeredGridView.countBuilder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 4,
                            itemCount: 2,
                            itemBuilder: (BuildContext context, int index) =>  
                              lookupMimeType(posts[i].imagesOrVideos[index])?.contains('video') == true
                              ? BetterPlayer.network('${posts[i].imagesOrVideos[index]}',
                                betterPlayerConfiguration: const BetterPlayerConfiguration(
                                  controlsConfiguration: const BetterPlayerControlsConfiguration(
                                    showControls: false,
                                  ),
                                  aspectRatio: 16 / 9,
                                ),
                              )
                              : CachedNetworkImage(
                                fit: BoxFit.contain,
                                imageUrl: posts[i].imagesOrVideos[index],
                                placeholder: (context, url) => const Center(child: const CircularProgressIndicator(),),
                                errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 1.0,),
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
                            itemBuilder: (BuildContext context, int index) => ((){
                              if(index != 1){
                                return lookupMimeType(posts[i].imagesOrVideos[index])?.contains('video') == true
                                ? BetterPlayer.network('${posts[i].imagesOrVideos[index]}',
                                  betterPlayerConfiguration: const BetterPlayerConfiguration(
                                    controlsConfiguration: const BetterPlayerControlsConfiguration(
                                      showControls: false,
                                    ),
                                    aspectRatio: 16 / 9,
                                  ),
                                )
                                : CachedNetworkImage(
                                  fit: BoxFit.contain,
                                  imageUrl: posts[i].imagesOrVideos[index],
                                  placeholder: (context, url) => const Center(child: const CircularProgressIndicator(),),
                                  errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 1.0,),
                                );
                              }else{
                                return ((){
                                  if(posts[i].imagesOrVideos.length - 3 > 0){
                                    if(lookupMimeType(posts[i].imagesOrVideos[index])?.contains('video') == true){
                                      return Stack(
                                        children: [
                                          BetterPlayer.network('${posts[i].imagesOrVideos[index]}',
                                            betterPlayerConfiguration: const BetterPlayerConfiguration(
                                              controlsConfiguration: const BetterPlayerControlsConfiguration(
                                                showControls: false,
                                              ),
                                              aspectRatio: 16 / 9,
                                            ),
                                          ),

                                          Container(color: Colors.black.withOpacity(0.5),),

                                          Center(
                                            child: CircleAvatar(
                                              radius: 25,
                                              backgroundColor: const Color(0xffffffff).withOpacity(.5),
                                              child: Text(
                                                '${posts[i].imagesOrVideos.length - 3}',
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
                                        children: [
                                          CachedNetworkImage(
                                            fit: BoxFit.fill,
                                            imageUrl: posts[i].imagesOrVideos[index],
                                            placeholder: (context, url) => const Center(child: const CircularProgressIndicator(),),
                                            errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 1.0,),
                                          ),

                                          Container(color: Colors.black.withOpacity(0.5),),

                                          Center(
                                            child: CircleAvatar(
                                              radius: 25,
                                              backgroundColor: const Color(0xffffffff).withOpacity(.5),
                                              child: Text(
                                                '${posts[i].imagesOrVideos.length - 3}',
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
                                    if(lookupMimeType(posts[i].imagesOrVideos[index])?.contains('video') == true){
                                      return BetterPlayer.network('${posts[i].imagesOrVideos[index]}',
                                        betterPlayerConfiguration: const BetterPlayerConfiguration(
                                          controlsConfiguration: const BetterPlayerControlsConfiguration(
                                            showControls: false,
                                          ),
                                          aspectRatio: 16 / 9,
                                        ),
                                      );
                                    }else{
                                      return CachedNetworkImage(
                                        fit: BoxFit.fill,
                                        imageUrl: posts[i].imagesOrVideos[index],
                                        placeholder: (context, url) => const Center(child: const CircularProgressIndicator(),),
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
          },
        )
      )
      : SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: (SizeConfig.screenHeight! / 1.5) / 3,),

              Image.asset('assets/icons/app-icon.png', height: 250, width: 250,),

              const SizedBox(height: 45,),

              const Text('Post is empty', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: const Color(0xffB1B1B1),),),

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
  const MiscRegularDraggableMemorials({required this.userId});

  MiscRegularDraggableMemorialsState createState() => MiscRegularDraggableMemorialsState(userId: userId);
}

class MiscRegularDraggableMemorialsState extends State<MiscRegularDraggableMemorials>{
  final int userId;
  MiscRegularDraggableMemorialsState({required this.userId});

  ScrollController scrollController = ScrollController();
  List<Widget> finalMemorials = [];
  int ownedItemsRemaining = 1;
  int followedItemsRemaining = 1;
  bool flag1 = false;
  int page1 = 1;
  int page2 = 1;
  int count = 0;

  void initState(){
    super.initState();
    addMemorials1();
    onLoading();
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        if(ownedItemsRemaining != 0 && followedItemsRemaining != 0){
          setState(() {
            onLoading();
          });
        }else{
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: const Text('No more memorials to show'),
              duration: const Duration(seconds: 1),
              backgroundColor: const Color(0xff4EC9D4),
            ),
          );
        }
      }
    });
  }

  Future<void> onRefresh() async{
    if(ownedItemsRemaining == 0 && followedItemsRemaining == 0 && flag1 == false){
      setState(() {
        flag1 = true;
      });
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
        child: const Align(
          alignment: Alignment.centerLeft,
          child: const Text('Owned',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: const Color(0xff000000),
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
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        color: const Color(0xffeeeeee),
        child: const Align(
          alignment: Alignment.centerLeft,
          child: const Text('Followed',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: const Color(0xff000000),
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
      context.loaderOverlay.show();
      var newValue = await apiRegularShowUserMemorials(userId: userId, page: page1);
      context.loaderOverlay.hide();

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
        flag1 = true;
        onLoading();
      }
    }
  }

  void onLoading2() async{
    if(followedItemsRemaining != 0){
      context.loaderOverlay.show();
      var newValue = await apiRegularShowUserMemorials(userId: userId, page: page2);
      context.loaderOverlay.hide();

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
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Container(
      height: SizeConfig.screenHeight! / 1.5,
      width: SizeConfig.screenWidth,
      child: count != 0
      ? RefreshIndicator(
        onRefresh: onRefresh,
        child: ListView.separated(
          controller: scrollController,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
          physics: const ClampingScrollPhysics(),
          itemCount: finalMemorials.length,
          separatorBuilder: (c, i) => const Divider(height: 10, color: Colors.transparent),
          itemBuilder: (c, i) => finalMemorials[i],
        )
      )
      : SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              SizedBox(height: (SizeConfig.screenHeight! / 1.5) / 3,),

              Image.asset('assets/icons/app-icon.png', height: 250, width: 250,),

              const SizedBox(height: 45,),

              const Text('Memorial is empty', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: const Color(0xffB1B1B1),),),

              SizedBox(height: (SizeConfig.screenHeight! / 1.5) / 3,),
            ],
          ),
        ),
      ),
    );
  }
}