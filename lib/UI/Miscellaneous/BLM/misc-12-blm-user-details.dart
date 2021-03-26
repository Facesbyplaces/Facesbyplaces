import 'package:facesbyplaces/API/BLM/13-Show-User/api-show-user-blm-02-show-user-posts.dart';
import 'package:facesbyplaces/API/BLM/13-Show-User/api-show-user-blm-03-show-user-memorials.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:better_player/better_player.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'misc-03-blm-manage-memorial.dart';
import 'misc-04-blm-post.dart';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';

class BLMMiscDraggablePost{
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

  BLMMiscDraggablePost({required this.userId, required this.postId, required this.memorialId, required this.memorialName, required this.timeCreated, required this.postBody, required this.profileImage, required this.imagesOrVideos, required this.managed, required this.joined, required this.numberOfLikes, required this.numberOfComments, required this.likeStatus, required this.numberOfTagged, required this.taggedFirstName, required this.taggedLastName, required this.taggedImage, required this.taggedId, required this.pageType, required this.famOrFriends, required this.relationship});
}

class MiscBLMDraggablePost extends StatefulWidget{
  final int userId;
  MiscBLMDraggablePost({required this.userId});

  MiscBLMDraggablePostState createState() => MiscBLMDraggablePostState(userId: userId);
}

class MiscBLMDraggablePostState extends State<MiscBLMDraggablePost>{
  final int userId;
  MiscBLMDraggablePostState({required this.userId});
  
  ScrollController scrollController = ScrollController();
  List<BLMMiscDraggablePost> posts = [];
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
            SnackBar(
              content: Text('No more posts to show'),
              duration: Duration(seconds: 1),
              backgroundColor: Color(0xff4EC9D4),
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
      context.showLoaderOverlay();
      var newValue = await apiBLMShowUserPosts(userId: userId, page: page);
      context.hideLoaderOverlay();

      itemRemaining = newValue.blmItemsRemaining;
      count = count + newValue.blmFamilyMemorialList.length;

      for(int i = 0; i < newValue.blmFamilyMemorialList.length; i++){
        List<String> newList1 = [];
        List<String> newList2 = [];
        List<String> newList3 = [];
        List<int> newList4 = [];

        for(int j = 0; j < newValue.blmFamilyMemorialList[i].showUsersPostsPostTagged.length; j++){
          newList1.add(newValue.blmFamilyMemorialList[i].showUsersPostsPostTagged[j].showUsersPostsTaggedFirstName);
          newList2.add(newValue.blmFamilyMemorialList[i].showUsersPostsPostTagged[j].showUsersPostsTaggedLastName);
          newList3.add(newValue.blmFamilyMemorialList[i].showUsersPostsPostTagged[j].showUsersPostsTaggedImage);
          newList4.add(newValue.blmFamilyMemorialList[i].showUsersPostsPostTagged[j].showUsersPostsTaggedId);
        }

        posts.add(BLMMiscDraggablePost(
          userId: newValue.blmFamilyMemorialList[i].showUsersPostsPage.showUsersPostsPagePageCreator.showUsersPostsPageCreatorId, 
          postId: newValue.blmFamilyMemorialList[i].showUsersPostsId,
          memorialId: newValue.blmFamilyMemorialList[i].showUsersPostsPage.showUsersPostsPageId,
          timeCreated: newValue.blmFamilyMemorialList[i].showUsersPostsCreatedAt,
          memorialName: newValue.blmFamilyMemorialList[i].showUsersPostsPage.showUsersPostsPageName,
          postBody: newValue.blmFamilyMemorialList[i].showUsersPostsBody,
          profileImage: newValue.blmFamilyMemorialList[i].showUsersPostsPage.showUsersPostsPageProfileImage,
          imagesOrVideos: newValue.blmFamilyMemorialList[i].showUsersPostsImagesOrVideos,
          managed: newValue.blmFamilyMemorialList[i].showUsersPostsPage.showUsersPostsPageManage,
          joined: newValue.blmFamilyMemorialList[i].showUsersPostsPage.showUsersPostsPageFollower,
          numberOfComments: newValue.blmFamilyMemorialList[i].showUsersPostsNumberOfComments,
          numberOfLikes: newValue.blmFamilyMemorialList[i].showUsersPostsNumberOfLikes,
          likeStatus: newValue.blmFamilyMemorialList[i].showUsersPostsLikeStatus,
          numberOfTagged: newValue.blmFamilyMemorialList[i].showUsersPostsPostTagged.length,
          taggedFirstName: newList1,
          taggedLastName: newList2,
          taggedImage: newList3,
          taggedId: newList4,
          pageType: newValue.blmFamilyMemorialList[i].showUsersPostsPage.showUsersPostsPagePageType,
          famOrFriends: newValue.blmFamilyMemorialList[i].showUsersPostsPage.showUsersPostsPageFamOrFriends,
          relationship: newValue.blmFamilyMemorialList[i].showUsersPostsPage.showUsersPostsPageRelationship,
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
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          physics: ClampingScrollPhysics(),
          itemCount: posts.length,
          separatorBuilder: (c, i) => Divider(height: 10, color: Colors.transparent),
          itemBuilder: (c, i){
            return MiscBLMPost(
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
          },
        )
      )
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

class MiscBLMDraggableMemorials extends StatefulWidget{
  final int userId;
  MiscBLMDraggableMemorials({required this.userId});

  MiscBLMDraggableMemorialsState createState() => MiscBLMDraggableMemorialsState(userId: userId);
}

class MiscBLMDraggableMemorialsState extends State<MiscBLMDraggableMemorials>{
  final int userId;
  MiscBLMDraggableMemorialsState({required this.userId});

  ScrollController scrollController = ScrollController();
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
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        if(ownedItemsRemaining != 0 && followedItemsRemaining != 0){
          setState(() {
            onLoading();
          });
        }else{
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('No more memorials to show'),
              duration: Duration(seconds: 1),
              backgroundColor: Color(0xff4EC9D4),
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
      var newValue = await apiBLMShowUserMemorials(userId: userId, page: page1);
      context.hideLoaderOverlay();

      ownedItemsRemaining = newValue.blmOwnedItemsRemaining;
      count = count + newValue.blmOwned.length;

      for(int i = 0; i < newValue.blmOwned.length; i++){
        finalMemorials.add(
          MiscBLMManageMemorialTab(
            index: i,
            memorialName: newValue.blmOwned[i].showUserMemorialsPage.showUserMemorialsPageName,
            description: newValue.blmOwned[i].showUserMemorialsPage.showUserMemorialsPageDetails.showUserMemorialsPageDetailsDescription,
            image: newValue.blmOwned[i].showUserMemorialsPage.showUserMemorialsPageProfileImage,
            memorialId: newValue.blmOwned[i].showUserMemorialsPage.showUserMemorialsPageId,
            managed: newValue.blmOwned[i].showUserMemorialsPage.showUserMemorialsPageManage,
            follower: newValue.blmOwned[i].showUserMemorialsPage.showUserMemorialsPageFollower,
            famOrFriends: newValue.blmOwned[i].showUserMemorialsPage.showUserMemorialsPageFamOrFriends,
            pageType: newValue.blmOwned[i].showUserMemorialsPage.showUserMemorialsPageType,
            relationship: newValue.blmOwned[i].showUserMemorialsPage.showUserMemorialsPageRelationship,
          ),
        );
      }

      if(mounted)
      setState(() {});
      page1++;

      if(ownedItemsRemaining == 0){
        addMemorials2();
      }
    }
  }

  void onLoading2() async{

    if(followedItemsRemaining != 0){
      context.showLoaderOverlay();
      var newValue = await apiBLMShowUserMemorials(userId: userId, page: page2);
      context.hideLoaderOverlay();

      followedItemsRemaining = newValue.blmFollowedItemsRemaining;
      count = count + newValue.blmFollowed.length;

      for(int i = 0; i < newValue.blmFollowed.length; i++){
        finalMemorials.add(
          MiscBLMManageMemorialTab(
            index: i,
            memorialName: newValue.blmFollowed[i].showUserMemorialsPage.showUserMemorialsPageName,
            description: newValue.blmFollowed[i].showUserMemorialsPage.showUserMemorialsPageDetails.showUserMemorialsPageDetailsDescription,
            image: newValue.blmFollowed[i].showUserMemorialsPage.showUserMemorialsPageProfileImage,
            memorialId: newValue.blmFollowed[i].showUserMemorialsPage.showUserMemorialsPageId,
            managed: newValue.blmFollowed[i].showUserMemorialsPage.showUserMemorialsPageManage,
            follower: newValue.blmFollowed[i].showUserMemorialsPage.showUserMemorialsPageFollower,
            famOrFriends: newValue.blmFollowed[i].showUserMemorialsPage.showUserMemorialsPageFamOrFriends,
            pageType: newValue.blmFollowed[i].showUserMemorialsPage.showUserMemorialsPageType,
            relationship: newValue.blmFollowed[i].showUserMemorialsPage.showUserMemorialsPageRelationship,
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
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
          physics: ClampingScrollPhysics(),
          itemCount: finalMemorials.length,
          separatorBuilder: (c, i) => Divider(height: 10, color: Colors.transparent),
          itemBuilder: (c, i) => finalMemorials[i],
        )
      )
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
