import 'package:facesbyplaces/API/Regular/02-Main/api-main-regular-04-03-home-post-tab.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-04-regular-post.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:better_player/better_player.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';

class RegularMainPagesPosts{
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
  const RegularMainPagesPosts({required this.userId, required this.postId, required this.memorialId, required this.memorialName, required this.timeCreated, required this.postBody, required this.profileImage, required this.imagesOrVideos, required this.managed, required this.joined, required this.numberOfLikes, required this.numberOfComments, required this.likeStatus, required this.numberOfTagged, required this.taggedFirstName, required this.taggedLastName, required this.taggedImage, required this.taggedId, required this.pageType, required this.famOrFriends, required this.relationship,});
}

class HomeRegularPostTab extends StatefulWidget{

  HomeRegularPostTabState createState() => HomeRegularPostTabState();
}

class HomeRegularPostTabState extends State<HomeRegularPostTab>{
  
  ScrollController scrollController = ScrollController();
  ValueNotifier<int> count = ValueNotifier<int>(0);
  List<RegularMainPagesPosts> posts = [];
  bool isGuestLoggedIn = true;
  int itemRemaining = 1;
  int page = 1;

  void initState(){
    super.initState();
    isGuest();
    scrollController.addListener((){
      if(scrollController.position.pixels == scrollController.position.maxScrollExtent){
        if(itemRemaining != 0){
          onLoading();
        }else{
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('No more posts to show'),
              duration: const Duration(seconds: 1),
              backgroundColor: const Color(0xff4EC9D4),
            ),
          );
        }
      }
    });
  }

  void isGuest() async{
    final sharedPrefs = await SharedPreferences.getInstance();
    isGuestLoggedIn = sharedPrefs.getBool('user-guest-session') ?? false;
    if(isGuestLoggedIn != true){
      onLoading();
    }
  }

  Future<void> onRefresh() async{
    page = 1;
    count.value = 0;
    itemRemaining = 1;
    posts = [];
    onLoading();
  }

  void onLoading() async{
    if(itemRemaining != 0){
      context.loaderOverlay.show();
      var newValue = await apiRegularHomePostTab(page: page);
      context.loaderOverlay.hide();

      itemRemaining = newValue.almItemsRemaining;
      count.value = count.value + newValue.familyMemorialList.length;

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
            timeCreated: newValue.familyMemorialList[i].homeTabPostCreatedAt,
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
      page++;
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    print('Post tab rebuild!');
    return ValueListenableBuilder(
      valueListenable: count,
      builder: (_, int countListener, __) => Container(
        width: SizeConfig.screenWidth,
        child: countListener != 0
        ? RefreshIndicator(
          onRefresh: onRefresh,
          child: ListView.separated(
            controller: scrollController,
            padding: const EdgeInsets.all(10.0),
            physics: const ClampingScrollPhysics(),
            itemCount: countListener,
            separatorBuilder: (c, i) => const Divider(height: 10, color: Colors.transparent),
            itemBuilder: (c, i) {
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
                                  fit: BoxFit.contain,
                                ),
                              );
                            }else{
                              return CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl: posts[i].imagesOrVideos[0],
                                placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
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
                                    fit: BoxFit.contain,
                                  ),
                                )
                                : CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  imageUrl: posts[i].imagesOrVideos[index],
                                  placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                  errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
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
                                      fit: BoxFit.contain,
                                    ),
                                  )
                                  : CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl: posts[i].imagesOrVideos[index],
                                    placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                    errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                  );
                                }else{
                                  return ((){
                                    if(posts[i].imagesOrVideos.length - 3 > 0){
                                      if(lookupMimeType(posts[i].imagesOrVideos[index])?.contains('video') == true){
                                        return Stack(
                                          fit: StackFit.expand,
                                          children: [
                                            BetterPlayer.network('${posts[i].imagesOrVideos[index]}',
                                              betterPlayerConfiguration: const BetterPlayerConfiguration(
                                                controlsConfiguration: const BetterPlayerControlsConfiguration(
                                                  showControls: false,
                                                ),
                                                aspectRatio: 16 / 9,
                                                fit: BoxFit.contain,
                                              ),
                                            ),

                                            Container(color: const Color(0xff000000).withOpacity(0.5),),

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
                                          fit: StackFit.expand,
                                          children: [
                                            CachedNetworkImage(
                                              fit: BoxFit.cover,
                                              imageUrl: posts[i].imagesOrVideos[index],
                                              placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                              errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                            ),

                                            Container(color: const Color(0xff000000).withOpacity(0.5),),

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
                                            fit: BoxFit.contain,
                                          ),
                                        );
                                      }else{
                                        return CachedNetworkImage(
                                          fit: BoxFit.cover,
                                          imageUrl: posts[i].imagesOrVideos[index],
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
                  : Container(height: 0),
                ],
              );
            }
          ),
        )
        : SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                SizedBox(height: (SizeConfig.screenHeight! - 85 - kToolbarHeight) / 3.5,),

                Image.asset('assets/icons/app-icon.png', height: 250, width: 250,),

                const SizedBox(height: 45,),

                const Text('Post is empty', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: const Color(0xffB1B1B1),),),

                SizedBox(height: (SizeConfig.screenHeight! - 85 - kToolbarHeight) / 3.5,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}