import 'package:facesbyplaces/API/BLM/13-Show-User/api_show_user_blm_02_show_user_posts.dart';
import 'package:facesbyplaces/API/BLM/13-Show-User/api_show_user_blm_03_show_user_memorials.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:better_player/better_player.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/material.dart';
import 'package:dialog/dialog.dart';
import 'package:loader/loader.dart';
import 'package:mime/mime.dart';

import 'misc_01_blm_manage_memorial.dart';
import 'misc_02_blm_post.dart';

class MiscBLMDraggablePost extends StatefulWidget{
  final int userId;
  final int accountType;
  const MiscBLMDraggablePost({Key? key, required this.userId, required this.accountType}) : super(key: key);

  @override
  MiscBLMDraggablePostState createState() => MiscBLMDraggablePostState();
}

class MiscBLMDraggablePostState extends State<MiscBLMDraggablePost>{
  Future<List<APIBLMShowUsersPostsExtended>>? showListOfUserPosts;
  ScrollController scrollController = ScrollController();
  ValueNotifier<int> lengthOfUserPosts = ValueNotifier<int>(0);
  int page1 = 1;
  ValueNotifier<bool> loaded = ValueNotifier<bool>(false);
  bool updatedUserPostsData = false;

  @override
  void initState(){
    super.initState();
    showListOfUserPosts = getListOfUserPosts(page: page1);
    scrollController.addListener((){
      if(scrollController.position.pixels == scrollController.position.maxScrollExtent){
        if(loaded.value){
          page1 = 1; // RESET BACK TO ONE FOR PAGINATION OF THE API
          showListOfUserPosts = getListOfUserPosts(page: page1);

          if(updatedUserPostsData){
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('New posts available. Reload to view.'), 
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
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No more posts to show.'), duration: Duration(seconds: 1), backgroundColor: Color(0xff4EC9D4),),);
          }
        }
      }
    });
  }

  Future<void> onRefresh() async{
    page1 = 1;
    loaded.value = false;
    updatedUserPostsData = false;
    lengthOfUserPosts.value = 0;
    showListOfUserPosts = getListOfUserPosts(page: page1);
  }

  Future<List<APIBLMShowUsersPostsExtended>> getListOfUserPosts({required int page}) async{
    APIBLMShowUsersPostsMain? newValue;
    List<APIBLMShowUsersPostsExtended> listOfPosts = [];

    do{
      newValue = await apiBLMShowUserPosts(page: page, accountType: widget.accountType, userId: widget.userId).onError((error, stackTrace){
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
      listOfPosts.addAll(newValue.blmFamilyMemorialList);

      if(newValue.blmItemsRemaining != 0){
        page++;
      }else if(lengthOfUserPosts.value > 0 && listOfPosts.length > lengthOfUserPosts.value){
        updatedUserPostsData = true;
      }
    }while(newValue.blmItemsRemaining != 0);

    lengthOfUserPosts.value = listOfPosts.length; // COMPARISON FOR NEXT PAGINATION & NUMBER OF POSTS
    page1 = page;
    loaded.value = true;
    
    return listOfPosts;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return ValueListenableBuilder(
      valueListenable: lengthOfUserPosts,
      builder: (_, int lengthOfUserPostsListener, __) => ValueListenableBuilder(
        valueListenable: loaded,
        builder: (_, bool loadedListener, __) => SafeArea(
          child: RefreshIndicator(
            onRefresh: onRefresh,
            child: FutureBuilder<List<APIBLMShowUsersPostsExtended>>(
              future: showListOfUserPosts,
              builder: (context, posts){
                if(posts.connectionState == ConnectionState.done){
                  if(loadedListener && lengthOfUserPostsListener == 0){
                    return SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      child: Align(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: (SizeConfig.screenHeight! - 85 - kToolbarHeight) / 3.5,),

                            Image.asset('assets/icons/app-icon.png', height: 200, width: 200,),

                            const SizedBox(height: 45,),

                            const Text('Post is empty', style: TextStyle(fontSize: 36, fontFamily: 'NexaBold', color: Color(0xffB1B1B1),),),

                            SizedBox(height: (SizeConfig.screenHeight! - 85 - kToolbarHeight) / 3.5,),
                          ],
                        ),
                      ),
                    );
                  }else{
                    return ListView.separated(
                      controller: scrollController,
                      separatorBuilder: (c, i) => const Divider(height: 10, color: Colors.transparent),
                      physics: const ClampingScrollPhysics(),
                      padding: const EdgeInsets.all(10.0),
                      itemCount: lengthOfUserPostsListener,
                      itemBuilder: (c, i) {
                        return MiscBLMPost(
                          key: ValueKey('$i'),
                          userId: posts.data![i].showUsersPostsPage.showUsersPostsPagePageCreator.showUsersPostsPageCreatorId,
                          postId: posts.data![i].showUsersPostsId,
                          memorialId: posts.data![i].showUsersPostsPage.showUsersPostsPageId,
                          memorialName: posts.data![i].showUsersPostsPage.showUsersPostsPageName,
                          timeCreated: timeago.format(DateTime.parse(posts.data![i].showUsersPostsCreatedAt)),
                          managed: posts.data![i].showUsersPostsPage.showUsersPostsPageManage,
                          joined: posts.data![i].showUsersPostsPage.showUsersPostsPageFollower,
                          profileImage: posts.data![i].showUsersPostsPage.showUsersPostsPageProfileImage,
                          numberOfComments: posts.data![i].showUsersPostsNumberOfComments,
                          numberOfLikes: posts.data![i].showUsersPostsNumberOfLikes,
                          likeStatus: posts.data![i].showUsersPostsLikeStatus,
                          numberOfTagged: posts.data![i].showUsersPostsPostTagged.length,
                          taggedFirstName: ((){
                            List<String> firstName = [];
                            for(int j = 0; j < posts.data![i].showUsersPostsPostTagged.length; j++){
                              firstName.add(posts.data![i].showUsersPostsPostTagged[j].showUsersPostsTaggedFirstName);
                            }
                            return firstName;
                          }()),
                          taggedLastName: ((){
                            List<String> lastName = [];
                            for(int j = 0; j < posts.data![i].showUsersPostsPostTagged.length; j++){
                              lastName.add(posts.data![i].showUsersPostsPostTagged[j].showUsersPostsTaggedLastName);
                            }
                            return lastName;
                          }()),
                          taggedId: ((){
                            List<int> id = [];
                            for(int j = 0; j < posts.data![i].showUsersPostsPostTagged.length; j++){
                              id.add(posts.data![i].showUsersPostsPostTagged[j].showUsersPostsTaggedId);
                            }
                            return id;
                          }()),
                          pageType: posts.data![i].showUsersPostsPage.showUsersPostsPagePageType,
                          famOrFriends: posts.data![i].showUsersPostsPage.showUsersPostsPageFamOrFriends,
                          relationship: posts.data![i].showUsersPostsPage.showUsersPostsPageRelationship,
                          location: posts.data![i].showUsersPostsLocation,
                          latitude: posts.data![i].showUsersPostsLatitude,
                          longitude: posts.data![i].showUsersPostsLongitude,
                          isGuest: false,
                          contents: [
                            Align(alignment: Alignment.centerLeft, child: Text(posts.data![i].showUsersPostsBody, overflow: TextOverflow.ellipsis, maxLines: 5, style: const TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xff000000),),),),
                                
                            posts.data![i].showUsersPostsImagesOrVideos.isNotEmpty
                            ? Column(
                              children: [
                                const SizedBox(height: 20),
                                
                                SizedBox(
                                  child: ((){
                                    if(posts.data![i].showUsersPostsImagesOrVideos.length == 1){
                                      if(lookupMimeType(posts.data![i].showUsersPostsImagesOrVideos[0])?.contains('video') == true){
                                        return BetterPlayer.network('${posts.data![i].showUsersPostsImagesOrVideos[0]}',
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
                                          imageUrl: posts.data![i].showUsersPostsImagesOrVideos[0],
                                          placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                          errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                        );
                                      }
                                    }else if(posts.data![i].showUsersPostsImagesOrVideos.length == 2){
                                      return StaggeredGridView.countBuilder(
                                        staggeredTileBuilder:(int index) => const StaggeredTile.count(2, 2),
                                        physics: const NeverScrollableScrollPhysics(),
                                        padding: EdgeInsets.zero,
                                        crossAxisSpacing: 4.0,
                                        mainAxisSpacing: 4.0,
                                        crossAxisCount: 4,
                                        shrinkWrap: true,
                                        itemCount: 2,
                                        itemBuilder: (BuildContext context, int index) => lookupMimeType(posts.data![i].showUsersPostsImagesOrVideos[index])?.contains('video') == true
                                        ? BetterPlayer.network('${posts.data![i].showUsersPostsImagesOrVideos[index]}',
                                            betterPlayerConfiguration: BetterPlayerConfiguration(placeholder: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 16 / 9),
                                            controlsConfiguration: const BetterPlayerControlsConfiguration(showControls: false,),
                                            aspectRatio: 16 / 9,
                                            fit: BoxFit.contain,
                                          ),
                                        )
                                        : CachedNetworkImage(
                                          fit: BoxFit.cover, 
                                          imageUrl: posts.data![i].showUsersPostsImagesOrVideos[index],
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
                                            return lookupMimeType(posts.data![i].showUsersPostsImagesOrVideos[index])?.contains('video') == true
                                            ? BetterPlayer.network('${posts.data![i].showUsersPostsImagesOrVideos[index]}',
                                              betterPlayerConfiguration: BetterPlayerConfiguration(
                                                placeholder: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 16 / 9),
                                                controlsConfiguration: const BetterPlayerControlsConfiguration(showControls: false,),
                                                aspectRatio: 16 / 9,
                                                fit: BoxFit.contain,
                                              ),
                                            )
                                            : CachedNetworkImage(
                                              fit: BoxFit.cover,
                                              imageUrl: posts.data![i].showUsersPostsImagesOrVideos[index],
                                              placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                              errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                            );
                                          }else{
                                            return ((){
                                              if(posts.data![i].showUsersPostsImagesOrVideos.length - 3 > 0){
                                                if(lookupMimeType(posts.data![i].showUsersPostsImagesOrVideos[index])?.contains('video') == true){
                                                  return Stack(
                                                    fit: StackFit.expand,
                                                    children: [
                                                      BetterPlayer.network('${posts.data![i].showUsersPostsImagesOrVideos[index]}',
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
                                                          child: Text('${posts.data![i].showUsersPostsImagesOrVideos.length - 3}', style: const TextStyle(fontSize: 32, fontFamily: 'NexaBold', color: Color(0xffFFFFFF),),),
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
                                                        imageUrl: posts.data![i].showUsersPostsImagesOrVideos[index],
                                                        placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                        errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                      ),

                                                      Container(color: const Color(0xff000000).withOpacity(0.5),),
                                                      
                                                      Center(
                                                        child: CircleAvatar(
                                                          radius: 25,
                                                          backgroundColor: const Color(0xffffffff).withOpacity(.5),
                                                          child: Text('${posts.data![i].showUsersPostsImagesOrVideos.length - 3}', style: const TextStyle(fontSize: 32, fontFamily: 'NexaBold', color: Color(0xffFFFFFF),),),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                }
                                              }else{
                                                if(lookupMimeType(posts.data![i].showUsersPostsImagesOrVideos[index])?.contains('video') == true) {
                                                  return BetterPlayer.network('${posts.data![i].showUsersPostsImagesOrVideos[index]}',
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
                                                    imageUrl: posts.data![i].showUsersPostsImagesOrVideos[index],
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
                    );
                  }
                }else if(posts.connectionState == ConnectionState.none || posts.connectionState == ConnectionState.waiting){
                  return const Center(child: CustomLoaderThreeDots(),);
                }
                else if(posts.hasError){
                  return Center(
                    child: MaterialButton(
                      onPressed: (){
                        onRefresh();
                      },
                      child: const Text('Refresh', style: TextStyle(color: Color(0xffffffff))),
                      color: const Color(0xff4EC9D4),
                    ),
                  );
                }else{
                  return const SizedBox(height: 0,);
                }
              }
            ),
          ),
        ),
      ),
    );
  }
}

class MiscBLMDraggableMemorials extends StatefulWidget{
  final int userId;
  final int accountType;
  const MiscBLMDraggableMemorials({Key? key, required this.userId, required this.accountType}) : super(key: key);

  @override
  MiscBLMDraggableMemorialsState createState() => MiscBLMDraggableMemorialsState();
}

class MiscBLMDraggableMemorialsState extends State<MiscBLMDraggableMemorials>{
  Future<List<Widget>>? showListOfUserMemorials;
  ScrollController scrollController = ScrollController();
  ValueNotifier<int> lengthOfUserMemorials = ValueNotifier<int>(0);
  ValueNotifier<bool> loaded = ValueNotifier<bool>(false);
  ValueNotifier<int> flag = ValueNotifier<int>(0);
  bool updatedUserMemorialsData = false;
  int page1 = 1;
  bool added = false;

  @override
  void initState(){
    super.initState();
    showListOfUserMemorials = getListOfUserMemorials(page: page1);    
    scrollController.addListener((){
      if(scrollController.position.pixels == scrollController.position.maxScrollExtent){
        if(loaded.value){
          page1 = 1; // RESET BACK TO ONE FOR PAGINATION OF THE API
          showListOfUserMemorials = getListOfUserMemorials(page: page1);

          if(updatedUserMemorialsData){
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('New memorials available. Reload to view.'), 
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
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No more memorials to show.'), duration: Duration(seconds: 1), backgroundColor: Color(0xff4EC9D4),),);
          }
        }
      }
    });
  }

  Future<void> onRefresh() async{
    page1 = 1;
    loaded.value = false;
    updatedUserMemorialsData = false;
    lengthOfUserMemorials.value = 0;
    showListOfUserMemorials = getListOfUserMemorials(page: page1);
  }
  
  Future<List<Widget>> getListOfUserMemorials({required int page}) async{
    List<Widget> memorials = [];
    APIBLMShowUserMemorialsMain? newValue;

    memorials.add(
      Container(
        height: 80,
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        color: const Color(0xffeeeeee),
        child: const Align(alignment: Alignment.centerLeft, child: Text('Owned', style: TextStyle(fontSize: 26, fontFamily: 'NexaBold', color: Color(0xff2F353D),),),),
      ),
    );

    do{
      newValue = await apiBLMShowUserMemorials(page: page, accountType: widget.accountType, userId: widget.userId).onError((error, stackTrace){
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

      for(int i = 0; i < newValue.blmOwned.length; i++){
        memorials.add(
          MiscBLMManageMemorialTab(
            memorialName: newValue.blmOwned[i].showUserMemorialsPage.showUserMemorialsPageName,
            description: newValue.blmOwned[i].showUserMemorialsPage.showUserMemorialsPageDetails.showUserMemorialsPageDetailsDescription,
            image: newValue.blmOwned[i].showUserMemorialsPage.showUserMemorialsPageProfileImage,
            memorialId: newValue.blmOwned[i].showUserMemorialsPage.showUserMemorialsPageId,
            managed: newValue.blmOwned[i].showUserMemorialsPage.showUserMemorialsPageManage,
            follower: newValue.blmOwned[i].showUserMemorialsPage.showUserMemorialsPageFollower,
            famOrFriends: newValue.blmOwned[i].showUserMemorialsPage.showUserMemorialsPageFamOrFriends,
            pageType: newValue.blmOwned[i].showUserMemorialsPage.showUserMemorialsPageType,
            relationship: newValue.blmOwned[i].showUserMemorialsPage.showUserMemorialsPageRelationship,
            isGuest: false,
          ),
        );
      }

      memorials.add(
        Container(
          height: 80,
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          color: const Color(0xffeeeeee),
          child: const Align(alignment: Alignment.centerLeft, child: Text('Followed', style: TextStyle(fontSize: 26, fontFamily: 'NexaBold', color: Color(0xff2F353D),),),),
        ),
      );

      for(int i = 0; i < newValue.blmFollowed.length; i++){
        memorials.add(
          MiscBLMManageMemorialTab(
            memorialName: newValue.blmFollowed[i].showUserMemorialsPage.showUserMemorialsPageName,
            description: newValue.blmFollowed[i].showUserMemorialsPage.showUserMemorialsPageDetails.showUserMemorialsPageDetailsDescription,
            image: newValue.blmFollowed[i].showUserMemorialsPage.showUserMemorialsPageProfileImage,
            memorialId: newValue.blmFollowed[i].showUserMemorialsPage.showUserMemorialsPageId,
            managed: newValue.blmFollowed[i].showUserMemorialsPage.showUserMemorialsPageManage,
            follower: newValue.blmFollowed[i].showUserMemorialsPage.showUserMemorialsPageFollower,
            famOrFriends: newValue.blmFollowed[i].showUserMemorialsPage.showUserMemorialsPageFamOrFriends,
            pageType: newValue.blmFollowed[i].showUserMemorialsPage.showUserMemorialsPageType,
            relationship: newValue.blmFollowed[i].showUserMemorialsPage.showUserMemorialsPageRelationship,
            isGuest: false,
          ),
        );
      }

      if(newValue.blmOwnedItemsRemaining != 0 || newValue.blmFollowedItemsRemaining != 0){
        page++;
      }else if(lengthOfUserMemorials.value > 0 && memorials.length > lengthOfUserMemorials.value){
        updatedUserMemorialsData = true;
      }
    }while(newValue.blmOwnedItemsRemaining != 0 || newValue.blmFollowedItemsRemaining != 0);

    lengthOfUserMemorials.value = memorials.length; // COMPARISON FOR NEXT PAGINATION & NUMBER OF FEEDS
    page1 = page;
    loaded.value = true;
    
    return memorials;
  }


  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return ValueListenableBuilder(
      valueListenable: lengthOfUserMemorials,
      builder: (_, int lengthOfUserMemorialsListener, __) => ValueListenableBuilder(
        valueListenable: loaded,
        builder: (_, bool loadedListener, __) => ValueListenableBuilder(
          valueListenable: flag,
          builder: (_, int flagListener, __) => SafeArea(
            child: RefreshIndicator(
              onRefresh: onRefresh,
              child: FutureBuilder<List<Widget>>(
                future: showListOfUserMemorials,
                builder: (context, memorials){
                  if(memorials.connectionState == ConnectionState.done){
                    if(loadedListener && lengthOfUserMemorialsListener == 0){
                      return SingleChildScrollView(
                        physics: const ClampingScrollPhysics(),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: (SizeConfig.screenHeight! - 85 - kToolbarHeight) / 3.5,),

                            Image.asset('assets/icons/app-icon.png', height: 200, width: 200,),

                            const SizedBox(height: 45,),

                            const Text('Memorial is empty', style: TextStyle(fontSize: 36, fontFamily: 'NexaBold', color: Color(0xffB1B1B1),),),

                            SizedBox(height: (SizeConfig.screenHeight! - 85 - kToolbarHeight) / 3.5,),
                          ],
                        ),
                      );
                    }else{
                      return ListView.separated(
                        controller: scrollController,
                        separatorBuilder: (c, i) => const Divider(height: 10, color: Colors.transparent),
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                        physics: const ClampingScrollPhysics(),
                        itemCount: memorials.data!.length,
                        itemBuilder: (c, i){
                          return memorials.data![i];
                        }
                      );
                    }
                  }else if(memorials.connectionState == ConnectionState.none || memorials.connectionState == ConnectionState.waiting){
                    return const Center(child: CustomLoaderThreeDots(),);
                  }
                  else if(memorials.hasError){
                    return Center(
                      child: MaterialButton(
                        onPressed: (){
                          onRefresh();
                        },
                        child: const Text('Refresh', style: TextStyle(color: Color(0xffffffff))),
                        color: const Color(0xff4EC9D4),
                      ),
                    );
                  }else{
                    return const SizedBox(height: 0,);
                  }
                }
              ),
            ),
          ),
        ),
      ),
    );
  }
}