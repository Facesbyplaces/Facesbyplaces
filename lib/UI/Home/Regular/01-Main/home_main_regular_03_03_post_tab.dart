import 'package:facesbyplaces/API/Regular/02-Main/api_main_regular_04_03_home_post_tab.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc_02_regular_post.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:better_player/better_player.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/material.dart';
import 'package:dialog/dialog.dart';
import 'package:loader/loader.dart';
import 'package:mime/mime.dart';

class HomeRegularPostTab extends StatefulWidget{
  const HomeRegularPostTab({Key? key}) : super(key: key);

  @override
  HomeRegularPostTabState createState() => HomeRegularPostTabState();
}

class HomeRegularPostTabState extends State<HomeRegularPostTab> with AutomaticKeepAliveClientMixin<HomeRegularPostTab>{
  Future<List<APIRegularHomeTabPostExtended>>? showListOfPosts;
  ValueNotifier<bool> isGuestLoggedIn = ValueNotifier<bool>(false);
  ScrollController scrollController = ScrollController();
  ValueNotifier<int> lengthOfPosts = ValueNotifier<int>(0);
  int page1 = 1;
  ValueNotifier<bool> loaded = ValueNotifier<bool>(false);
  bool updatedPostsData = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState(){
    super.initState();
    isGuest();
    scrollController.addListener((){ // SHOWS WHEN THE USER HAS REACHED THE BOTTOM OF THE LIST
      if(scrollController.position.pixels == scrollController.position.maxScrollExtent){
        if(loaded.value){
          page1 = 1; // RESET BACK TO ONE FOR PAGINATION OF THE API
          showListOfPosts = getListOfPosts(page: page1);

          if(updatedPostsData){
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                elevation: 0,
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
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No more posts to show.'), elevation: 0, duration: Duration(seconds: 1), backgroundColor: Color(0xff4EC9D4),),);
          }
        }
      }
    });
  }

  Future<void> onRefresh() async{ // PULL TO REFRESH FUNCTIONALITY
    page1 = 1;
    loaded.value = false;
    updatedPostsData = false;
    lengthOfPosts.value = 0;
    showListOfPosts = getListOfPosts(page: page1);
  }

  void isGuest() async{ // CHECKS IF THE USER IS A GUEST
    final sharedPrefs = await SharedPreferences.getInstance();
    isGuestLoggedIn.value = sharedPrefs.getBool('user-guest-session') ?? false;

    if(isGuestLoggedIn.value != true){
      showListOfPosts = getListOfPosts(page: page1);
    }
  }

  Future<List<APIRegularHomeTabPostExtended>> getListOfPosts({required int page}) async{
    APIRegularHomeTabPostMain? newValue;
    List<APIRegularHomeTabPostExtended> listOfPosts = [];

    do{
      newValue = await apiRegularHomePostTab(page: page).onError((error, stackTrace){
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
      listOfPosts.addAll(newValue.familyMemorialList);

      if(newValue.almItemsRemaining != 0){
        page++;
      }else if(lengthOfPosts.value > 0 && listOfPosts.length > lengthOfPosts.value){
        updatedPostsData = true;
      }
    }while(newValue.almItemsRemaining != 0);

    lengthOfPosts.value = listOfPosts.length; // COMPARISON FOR NEXT PAGINATION & NUMBER OF POSTS
    page1 = page;
    loaded.value = true;
    
    return listOfPosts;
  }

  @override
  Widget build(BuildContext context){
    super.build(context);
    SizeConfig.init(context);
    return ValueListenableBuilder(
      valueListenable: lengthOfPosts,
      builder: (_, int lengthOfPostsListener, __) => ValueListenableBuilder(
        valueListenable: loaded,
        builder: (_, bool loadedListener, __) => SafeArea(
          child: RefreshIndicator(
            onRefresh: onRefresh,
            child: FutureBuilder<List<APIRegularHomeTabPostExtended>>(
              future: showListOfPosts,
              builder: (context, posts){
                if(posts.connectionState == ConnectionState.done){
                  if(loadedListener && lengthOfPostsListener == 0){
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
                      itemCount: lengthOfPostsListener,
                      itemBuilder: (c, i) {
                        return MiscRegularPost(
                          key: ValueKey('$i'),
                          userId: posts.data![i].homeTabPostPage.homeTabPostPagePageCreator.homeTabPostPageCreatorId,
                          postId: posts.data![i].homeTabPostId,
                          memorialId: posts.data![i].homeTabPostPage.homeTabPostPageId,
                          memorialName: posts.data![i].homeTabPostPage.homeTabPostPageName,
                          timeCreated: timeago.format(DateTime.parse(posts.data![i].homeTabPostCreatedAt)),
                          managed: posts.data![i].homeTabPostPage.homeTabPostPageManage,
                          joined: posts.data![i].homeTabPostPage.homeTabPostPageFollower,
                          profileImage: posts.data![i].homeTabPostPage.homeTabPostPageProfileImage,
                          numberOfComments: posts.data![i].homeTabPostNumberOfComments,
                          numberOfLikes: posts.data![i].homeTabPostNumberOfLikes,
                          likeStatus: posts.data![i].homeTabPostLikeStatus,
                          numberOfTagged: posts.data![i].homeTabPostPostTagged.length,
                          taggedFirstName: ((){
                            List<String> firstName = [];
                            for(int j = 0; j < posts.data![i].homeTabPostPostTagged.length; j++){
                              firstName.add(posts.data![i].homeTabPostPostTagged[j].homeTabPostTabTaggedFirstName);
                            }
                            return firstName;
                          }()),
                          taggedLastName: ((){
                            List<String> lastName = [];
                            for(int j = 0; j < posts.data![i].homeTabPostPostTagged.length; j++){
                              lastName.add(posts.data![i].homeTabPostPostTagged[j].homeTabPostTabTaggedLastName);
                            }
                            return lastName;
                          }()),
                          taggedId: ((){
                            List<int> id = [];
                            for(int j = 0; j < posts.data![i].homeTabPostPostTagged.length; j++){
                              id.add(posts.data![i].homeTabPostPostTagged[j].homeTabPostTabTaggedId);
                            }
                            return id;
                          }()),
                          pageType: posts.data![i].homeTabPostPage.homeTabPostPagePageType,
                          famOrFriends: posts.data![i].homeTabPostPage.homeTabPostPageFamOrFriends,
                          relationship: posts.data![i].homeTabPostPage.homeTabPostPageRelationship,
                          location: posts.data![i].homeTabPostLocation,
                          latitude: posts.data![i].homeTabPostLatitude,
                          longitude: posts.data![i].homeTabPostLongitude,
                          isGuest: isGuestLoggedIn.value,
                          deletable: posts.data![i].homeTabPostDeletable,
                          contents: [
                            Align(alignment: Alignment.centerLeft, child: Text(posts.data![i].homeTabPostBody, overflow: TextOverflow.ellipsis, maxLines: 5, style: const TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xff000000),),),),
                                
                            posts.data![i].homeTabPostImagesOrVideos.isNotEmpty
                            ? Column(
                              children: [
                                const SizedBox(height: 20),
                                
                                SizedBox(
                                  child: ((){
                                    if(posts.data![i].homeTabPostImagesOrVideos.length == 1){
                                      if(lookupMimeType(posts.data![i].homeTabPostImagesOrVideos[0])?.contains('video') == true){
                                        return BetterPlayer.network('${posts.data![i].homeTabPostImagesOrVideos[0]}',
                                          betterPlayerConfiguration: const BetterPlayerConfiguration(
                                            overlay: Center(child: Icon(Icons.play_circle_fill, color: Color(0xffffffff))),
                                            controlsConfiguration: BetterPlayerControlsConfiguration(showControls: false,),
                                            aspectRatio: 16 / 9,
                                            fit: BoxFit.contain,
                                          ),
                                        );
                                      }else{
                                        return CachedNetworkImage(
                                          fit: BoxFit.cover,
                                          imageUrl: posts.data![i].homeTabPostImagesOrVideos[0],
                                          placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                          errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                        );
                                      }
                                    }else if(posts.data![i].homeTabPostImagesOrVideos.length == 2){
                                      return StaggeredGridView.countBuilder(
                                        staggeredTileBuilder:(int index) => const StaggeredTile.count(2, 2),
                                        physics: const NeverScrollableScrollPhysics(),
                                        padding: EdgeInsets.zero,
                                        crossAxisSpacing: 4.0,
                                        mainAxisSpacing: 4.0,
                                        crossAxisCount: 4,
                                        shrinkWrap: true,
                                        itemCount: 2,
                                        itemBuilder: (BuildContext context, int index) => lookupMimeType(posts.data![i].homeTabPostImagesOrVideos[index])?.contains('video') == true
                                        ? BetterPlayer.network('${posts.data![i].homeTabPostImagesOrVideos[index]}',
                                          betterPlayerConfiguration: const BetterPlayerConfiguration(
                                            overlay: Center(child: Icon(Icons.play_circle_fill, color: Color(0xffffffff))),
                                            controlsConfiguration: BetterPlayerControlsConfiguration(showControls: false,),
                                            aspectRatio: 16 / 9,
                                            fit: BoxFit.contain,
                                          ),
                                        )
                                        : CachedNetworkImage(
                                          fit: BoxFit.cover, 
                                          imageUrl: posts.data![i].homeTabPostImagesOrVideos[index],
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
                                            return lookupMimeType(posts.data![i].homeTabPostImagesOrVideos[index])?.contains('video') == true
                                            ? BetterPlayer.network('${posts.data![i].homeTabPostImagesOrVideos[index]}',
                                              betterPlayerConfiguration: const BetterPlayerConfiguration(
                                                overlay: Center(child: Icon(Icons.play_circle_fill, color: Color(0xffffffff))),
                                                controlsConfiguration: BetterPlayerControlsConfiguration(showControls: false,),
                                                aspectRatio: 16 / 9,
                                                fit: BoxFit.contain,
                                              ),
                                            )
                                            : CachedNetworkImage(
                                              fit: BoxFit.cover,
                                              imageUrl: posts.data![i].homeTabPostImagesOrVideos[index],
                                              placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                              errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                            );
                                          }else{
                                            return ((){
                                              if(posts.data![i].homeTabPostImagesOrVideos.length - 3 > 0){
                                                if(lookupMimeType(posts.data![i].homeTabPostImagesOrVideos[index])?.contains('video') == true){
                                                  return Stack(
                                                    fit: StackFit.expand,
                                                    children: [
                                                      BetterPlayer.network('${posts.data![i].homeTabPostImagesOrVideos[index]}',
                                                        betterPlayerConfiguration: const BetterPlayerConfiguration(
                                                          overlay: Center(child: Icon(Icons.play_circle_fill, color: Color(0xffffffff))),
                                                          controlsConfiguration: BetterPlayerControlsConfiguration(showControls: false,),
                                                          aspectRatio: 16 / 9,
                                                          fit: BoxFit.contain,
                                                        ),
                                                      ),

                                                      Container(color: const Color(0xff000000).withOpacity(0.5),),

                                                      Center(
                                                        child: CircleAvatar(
                                                          radius: 25,
                                                          backgroundColor: const Color(0xffffffff).withOpacity(.5),
                                                          child: Text('${posts.data![i].homeTabPostImagesOrVideos.length - 3}', style: const TextStyle(fontSize: 32, fontFamily: 'NexaBold', color: Color(0xffFFFFFF),),),
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
                                                        imageUrl: posts.data![i].homeTabPostImagesOrVideos[index],
                                                        placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                        errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                      ),

                                                      Container(color: const Color(0xff000000).withOpacity(0.5),),
                                                      
                                                      Center(
                                                        child: CircleAvatar(
                                                          radius: 25,
                                                          backgroundColor: const Color(0xffffffff).withOpacity(.5),
                                                          child: Text('${posts.data![i].homeTabPostImagesOrVideos.length - 3}', style: const TextStyle(fontSize: 32, fontFamily: 'NexaBold', color: Color(0xffFFFFFF),),),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                }
                                              }else{
                                                if(lookupMimeType(posts.data![i].homeTabPostImagesOrVideos[index])?.contains('video') == true) {
                                                  return BetterPlayer.network('${posts.data![i].homeTabPostImagesOrVideos[index]}',
                                                    betterPlayerConfiguration: const BetterPlayerConfiguration(
                                                      overlay: Center(child: Icon(Icons.play_circle_fill, color: Color(0xffffffff))),
                                                      controlsConfiguration: BetterPlayerControlsConfiguration(showControls: false,),
                                                      aspectRatio: 16 / 9,
                                                      fit: BoxFit.contain,
                                                    ),
                                                  );
                                                }else{
                                                  return CachedNetworkImage(
                                                    fit: BoxFit.cover,
                                                    imageUrl: posts.data![i].homeTabPostImagesOrVideos[index],
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
                        isGuest();
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