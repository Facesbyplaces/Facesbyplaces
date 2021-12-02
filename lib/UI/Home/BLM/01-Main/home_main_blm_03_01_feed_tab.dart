import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc_02_blm_post.dart';
import 'package:facesbyplaces/API/BLM/02-Main/api_main_blm_04_01_home_feed_tab.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc_02_regular_post.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:better_player/better_player.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/material.dart';
import 'package:dialog/dialog.dart';
import 'package:mime/mime.dart';
import 'package:misc/misc.dart';

class BLMMainPagesFeeds{
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
  const BLMMainPagesFeeds({required this.userId, required this.postId, required this.memorialId, required this.memorialName, required this.timeCreated, required this.postBody, required this.profileImage, required this.imagesOrVideos, required this.managed, required this.joined, required this.numberOfLikes, required this.numberOfComments, required this.likeStatus,required this.numberOfTagged, required this.taggedFirstName, required this.taggedLastName, required this.taggedImage, required this.taggedId, required this.pageType, required this.famOrFriends, required this.relationship, required this.location, required this.latitude, required this.longitude});
}

class HomeBLMFeedTab extends StatefulWidget{
  const HomeBLMFeedTab({Key? key}) : super(key: key);

  @override
  HomeBLMFeedTabState createState() => HomeBLMFeedTabState();
}

class HomeBLMFeedTabState extends State<HomeBLMFeedTab>{
  ValueNotifier<List<BLMMainPagesFeeds>> feeds = ValueNotifier<List<BLMMainPagesFeeds>>([]);
  ValueNotifier<bool> isGuestLoggedIn = ValueNotifier<bool>(false);
  ScrollController scrollController = ScrollController();
  ValueNotifier<int> count = ValueNotifier<int>(0);
  int itemRemaining = 1;
  int page = 1;

  @override
  void initState(){
    super.initState();
    isGuest();
    scrollController.addListener((){
      if(scrollController.position.pixels == scrollController.position.maxScrollExtent){
        if(itemRemaining != 0){
          onLoading();
        }else{
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No more feeds to show'),
              duration: Duration(seconds: 1),
              backgroundColor: Color(0xff4EC9D4),
            ),
          );
        }
      }
    });
  }

  Future<void> onRefresh() async{
    page = 1;
    itemRemaining = 1;
    count.value = 0;
    feeds.value = [];
    onLoading();
  }

  void isGuest() async{
    final sharedPrefs = await SharedPreferences.getInstance();
    isGuestLoggedIn.value = sharedPrefs.getBool('user-guest-session') ?? false;

    if(isGuestLoggedIn.value != true){
      onLoading();
    }
  }

  void onLoading() async{
    if(itemRemaining != 0){
      context.loaderOverlay.show();
      var newValue = await apiBLMHomeFeedTab(page: page).onError((error, stackTrace){
        context.loaderOverlay.hide();
        showDialog(
          context: context,
          builder: (context) => CustomDialog(
            image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
            title: 'Error',
            description: 'Error: $error.',
            okButtonColor: const Color(0xfff44336), // RED
            includeOkButton: true,
          ),
        );
        throw Exception('$error');
      });
      context.loaderOverlay.hide();

      itemRemaining = newValue.blmItemsRemaining;
      count.value = count.value + newValue.blmFamilyMemorialList.length;

      for(int i = 0; i < newValue.blmFamilyMemorialList.length; i++){
        List<String> newList1 = [];
        List<String> newList2 = [];
        List<String> newList3 = [];
        List<int> newList4 = [];

        for(int j = 0; j < newValue.blmFamilyMemorialList[i].homeTabFeedPostTagged.length; j++){
          newList1.add(newValue.blmFamilyMemorialList[i].homeTabFeedPostTagged[j].homeTabFeedTaggedFirstName);
          newList2.add(newValue.blmFamilyMemorialList[i].homeTabFeedPostTagged[j].homeTabFeedTaggedLastName);
          newList3.add(newValue.blmFamilyMemorialList[i].homeTabFeedPostTagged[j].homeTabFeedTaggedImage);
          newList4.add(newValue.blmFamilyMemorialList[i].homeTabFeedPostTagged[j].homeTabFeedTaggedId);
        }

        feeds.value.add(
          BLMMainPagesFeeds(
            userId: newValue.blmFamilyMemorialList[i].homeTabFeedPage.homeTabFeedPagePageCreator.homeTabFeedPageCreatorId,
            postId: newValue.blmFamilyMemorialList[i].homeTabFeedId,
            memorialId: newValue.blmFamilyMemorialList[i].homeTabFeedPage.homeTabFeedPageId,
            timeCreated: newValue.blmFamilyMemorialList[i].homeTabFeedCreatedAt,
            memorialName: newValue.blmFamilyMemorialList[i].homeTabFeedPage.homeTabFeedPageName,
            postBody: newValue.blmFamilyMemorialList[i].homeTabFeedBody,
            profileImage: newValue.blmFamilyMemorialList[i].homeTabFeedPage.homeTabFeedPageProfileImage,
            imagesOrVideos: newValue.blmFamilyMemorialList[i].homeTabFeedImagesOrVideos,
            managed: newValue.blmFamilyMemorialList[i].homeTabFeedPage.homeTabFeedPageManage,
            joined: newValue.blmFamilyMemorialList[i].homeTabFeedPage.homeTabFeedPageFollower,
            numberOfComments:newValue.blmFamilyMemorialList[i].homeTabFeedNumberOfComments,
            numberOfLikes: newValue.blmFamilyMemorialList[i].homeTabFeedNumberOfLikes,
            likeStatus: newValue.blmFamilyMemorialList[i].homeTabFeedLikeStatus,
            numberOfTagged: newValue.blmFamilyMemorialList[i].homeTabFeedPostTagged.length,
            taggedFirstName: newList1,
            taggedLastName: newList2,
            taggedImage: newList3,
            taggedId: newList4,
            pageType: newValue.blmFamilyMemorialList[i].homeTabFeedPage.homeTabFeedPagePageType,
            famOrFriends: newValue.blmFamilyMemorialList[i].homeTabFeedPage.homeTabFeedPageFamOrFriends,
            relationship: newValue.blmFamilyMemorialList[i].homeTabFeedPage.homeTabFeedPageRelationship,
            location: newValue.blmFamilyMemorialList[i].homeTabFeedLocation,
            latitude: newValue.blmFamilyMemorialList[i].homeTabFeedLatitude,
            longitude: newValue.blmFamilyMemorialList[i].homeTabFeedLongitude,
          ),
        );
      }

      if(mounted){
        page++;
      }
    }
  }

  @override
  Widget build(BuildContext context){
    SizeConfig.init(context);
    return ValueListenableBuilder(
      valueListenable: isGuestLoggedIn,
      builder: (_, bool isGuestLoggedInListener, __) => ValueListenableBuilder(
        valueListenable: feeds,
        builder: (_, List<BLMMainPagesFeeds> feedsListener, __) => ValueListenableBuilder(
          valueListenable: count,
          builder: (_, int countListener, __) => countListener != 0
          ? SafeArea(
            child: RefreshIndicator(
              onRefresh: onRefresh,
              child: ListView.separated(
                controller: scrollController,
                separatorBuilder: (c, i) => const Divider(height: 10, color: Colors.transparent),
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.all(10.0),
                itemCount: countListener,
                itemBuilder: (c, i){
                  return feedsListener[i].pageType == 'Blm'
                  ? MiscBLMPost(
                    key: ValueKey('$i'),
                    userId: feedsListener[i].userId,
                    postId: feedsListener[i].postId,
                    memorialId: feedsListener[i].memorialId,
                    memorialName: feedsListener[i].memorialName,
                    timeCreated: timeago.format(DateTime.parse(
                    feedsListener[i].timeCreated)),
                    managed: feedsListener[i].managed,
                    joined: feedsListener[i].joined,
                    profileImage: feedsListener[i].profileImage,
                    numberOfComments: feedsListener[i].numberOfComments,
                    numberOfLikes: feedsListener[i].numberOfLikes,
                    likeStatus: feedsListener[i].likeStatus,
                    numberOfTagged: feedsListener[i].numberOfTagged,
                    taggedFirstName: feedsListener[i].taggedFirstName,
                    taggedLastName: feedsListener[i].taggedLastName,
                    taggedId: feedsListener[i].taggedId,
                    pageType: feedsListener[i].pageType,
                    famOrFriends: feedsListener[i].famOrFriends,
                    relationship: feedsListener[i].relationship,
                    location: feedsListener[i].location,
                    latitude: feedsListener[i].latitude,
                    longitude: feedsListener[i].longitude,
                    isGuest: isGuestLoggedIn.value,
                    contents: [
                      Align(alignment: Alignment.centerLeft, child: Text(feedsListener[i].postBody, overflow: TextOverflow.ellipsis, maxLines: 5, style: const TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xff000000),),),),

                      feedsListener[i].imagesOrVideos.isNotEmpty
                      ? Column(
                        children: [
                          const SizedBox(height: 20),

                          SizedBox(
                            child: ((){
                              if(feedsListener[i].imagesOrVideos.length == 1){
                                if(lookupMimeType(feedsListener[i].imagesOrVideos[0])?.contains('video') == true){
                                  return BetterPlayer.network('${feedsListener[i].imagesOrVideos[0]}',
                                    betterPlayerConfiguration: BetterPlayerConfiguration(
                                      placeholder: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 16 / 9),
                                      controlsConfiguration: const BetterPlayerControlsConfiguration(showControls: false,),
                                      aspectRatio: 16 / 9,
                                      fit: BoxFit.contain,
                                    ),
                                  );
                                }else{
                                  return CachedNetworkImage(
                                    errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                    placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                    imageUrl: feedsListener[i].imagesOrVideos[0],
                                    fit: BoxFit.cover,
                                  );
                                }
                              }else if(feedsListener[i].imagesOrVideos.length == 2){
                                return StaggeredGridView.countBuilder(
                                  staggeredTileBuilder: (int index) => const StaggeredTile.count(2, 2),
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.zero,
                                  crossAxisSpacing: 4.0,
                                  mainAxisSpacing: 4.0,
                                  crossAxisCount: 4,
                                  shrinkWrap: true,
                                  itemBuilder: (BuildContext context, int index) => lookupMimeType(feedsListener[i].imagesOrVideos[index])?.contains('video') == true
                                  ? BetterPlayer.network('${feedsListener[i].imagesOrVideos[index]}',
                                    betterPlayerConfiguration: BetterPlayerConfiguration(
                                      placeholder: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 16 / 9),
                                      controlsConfiguration: const BetterPlayerControlsConfiguration(showControls: false,),
                                      aspectRatio: 16 / 9,
                                      fit: BoxFit.contain,
                                    ),
                                  )
                                  : CachedNetworkImage(
                                    errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                    placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                    imageUrl: feedsListener[i].imagesOrVideos[index],
                                    fit: BoxFit.cover,
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
                                      return lookupMimeType(feedsListener[i].imagesOrVideos[index])?.contains('video') == true
                                      ? BetterPlayer.network('${feedsListener[i].imagesOrVideos[index]}',
                                        betterPlayerConfiguration: BetterPlayerConfiguration(
                                          placeholder: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 16 / 9),
                                          controlsConfiguration: const BetterPlayerControlsConfiguration(showControls: false,),
                                          aspectRatio: 16 / 9,
                                          fit: BoxFit.contain,
                                        ),
                                      )
                                      : CachedNetworkImage(
                                        errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                        placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                        imageUrl: feedsListener[i].imagesOrVideos[index],
                                        fit: BoxFit.cover,
                                      );
                                    }else{
                                      return ((){
                                        if(feedsListener[i].imagesOrVideos.length - 3 > 0){
                                          if(lookupMimeType(feedsListener[i].imagesOrVideos[index])?.contains('video') == true){
                                            return Stack(
                                              fit: StackFit.expand,
                                              children: [
                                                BetterPlayer.network('${feedsListener[i].imagesOrVideos[index]}',
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
                                                    child: Text('${feedsListener[i].imagesOrVideos.length - 3}', style: const TextStyle(fontSize: 32, fontFamily: 'NexaBold', color:  Color(0xffFFFFFF),),),
                                                    backgroundColor: const Color(0xffffffff).withOpacity(.5),
                                                    radius: 25,
                                                  ),
                                                ),
                                              ],
                                            );
                                          }else{
                                            return Stack(
                                              fit: StackFit.expand,
                                              children: [
                                                CachedNetworkImage(
                                                  errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                  placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                  imageUrl: feedsListener[i].imagesOrVideos[index],
                                                  fit: BoxFit.cover,
                                                ),

                                                Container(color: const Color(0xff000000).withOpacity(0.5),),

                                                Center(
                                                  child: CircleAvatar(
                                                    child: Text('${feedsListener[i].imagesOrVideos.length - 3}', style: const TextStyle(fontSize: 32, fontFamily: 'NexaBold', color: Color(0xffFFFFFF),),),
                                                    backgroundColor: const Color(0xffffffff).withOpacity(.5),
                                                    radius: 25,
                                                  ),
                                                ),
                                              ],
                                            );
                                          }
                                        }else{
                                          if(lookupMimeType(feedsListener[i].imagesOrVideos[index])?.contains('video') == true){
                                            return BetterPlayer.network('${feedsListener[i].imagesOrVideos[index]}',
                                              betterPlayerConfiguration: BetterPlayerConfiguration(
                                                placeholder: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 16 / 9),
                                                controlsConfiguration: const BetterPlayerControlsConfiguration(showControls: false,),
                                                aspectRatio: 16 / 9,
                                                fit: BoxFit.contain,
                                              ),
                                            );
                                          }else{
                                            return CachedNetworkImage(
                                              errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                              placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                              imageUrl: feedsListener[i].imagesOrVideos[index],
                                              fit: BoxFit.cover,
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
                    userId: feedsListener[i].userId,
                    postId: feedsListener[i].postId,
                    memorialId: feedsListener[i].memorialId,
                    memorialName: feedsListener[i].memorialName,
                    timeCreated: timeago.format(DateTime.parse(feedsListener[i].timeCreated)),
                    managed: feedsListener[i].managed,
                    joined: feedsListener[i].joined,
                    profileImage: feedsListener[i].profileImage,
                    numberOfComments: feedsListener[i].numberOfComments,
                    numberOfLikes: feedsListener[i].numberOfLikes,
                    likeStatus: feedsListener[i].likeStatus,
                    numberOfTagged: feedsListener[i].numberOfTagged,
                    taggedFirstName: feedsListener[i].taggedFirstName,
                    taggedLastName: feedsListener[i].taggedLastName,
                    taggedId: feedsListener[i].taggedId,
                    pageType: feedsListener[i].pageType,
                    famOrFriends: feedsListener[i].famOrFriends,
                    relationship: feedsListener[i].relationship,
                    location: feedsListener[i].location,
                    latitude: feedsListener[i].latitude,
                    longitude: feedsListener[i].longitude,
                    isGuest: isGuestLoggedIn.value,
                    contents: [
                      Align(alignment: Alignment.centerLeft, child: Text(feedsListener[i].postBody, overflow: TextOverflow.ellipsis, maxLines: 5, style: const TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xff000000),),),),

                      feedsListener[i].imagesOrVideos.isNotEmpty
                      ? Column(
                        children: [
                          const SizedBox(height: 20),

                          SizedBox(
                            child: ((){
                              if(feedsListener[i].imagesOrVideos.length == 1){
                                if(lookupMimeType(feedsListener[i].imagesOrVideos[0])?.contains('video') == true){
                                  return BetterPlayer.network('${feedsListener[i].imagesOrVideos[0]}',
                                    betterPlayerConfiguration: BetterPlayerConfiguration(
                                      placeholder: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 16 / 9),
                                      controlsConfiguration: const BetterPlayerControlsConfiguration(showControls: false,),
                                      aspectRatio: 16 / 9,
                                      fit: BoxFit.contain,
                                    ),
                                  );
                                }else{
                                  return CachedNetworkImage(
                                    errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                    placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                    imageUrl: feedsListener[i].imagesOrVideos[0],
                                    fit: BoxFit.cover,
                                  );
                                }
                              }else if(feedsListener[i].imagesOrVideos.length == 2){
                                return StaggeredGridView.countBuilder(
                                  staggeredTileBuilder: (int index) => const StaggeredTile.count(2, 2),
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.zero,
                                  crossAxisSpacing: 4.0,
                                  mainAxisSpacing: 4.0,
                                  crossAxisCount: 4,
                                  shrinkWrap: true,
                                  itemCount: 2,
                                  itemBuilder: (BuildContext context, int index) => lookupMimeType(feedsListener[i].imagesOrVideos[index])?.contains('video') == true
                                  ? BetterPlayer.network('${feedsListener[i].imagesOrVideos[index]}',
                                    betterPlayerConfiguration: BetterPlayerConfiguration(
                                      placeholder: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 16 / 9),
                                      controlsConfiguration: const BetterPlayerControlsConfiguration(showControls: false,),
                                      aspectRatio: 16 / 9,
                                      fit: BoxFit.contain,
                                    ),
                                  )
                                  : CachedNetworkImage(
                                    errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                    placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                    imageUrl: feedsListener[i].imagesOrVideos[index],
                                    fit: BoxFit.cover,
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
                                      return lookupMimeType(feedsListener[i].imagesOrVideos[index])?.contains('video') == true
                                      ? BetterPlayer.network('${feedsListener[i].imagesOrVideos[index]}',
                                        betterPlayerConfiguration: BetterPlayerConfiguration(
                                          placeholder: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 16 / 9),
                                          controlsConfiguration: const BetterPlayerControlsConfiguration(showControls: false,),
                                          aspectRatio: 16 / 9,
                                          fit: BoxFit.contain,
                                        ),
                                      )
                                      : CachedNetworkImage(
                                        errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                        placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                        imageUrl: feedsListener[i].imagesOrVideos[index],
                                        fit: BoxFit.cover,
                                      );
                                    }else{
                                      return ((){
                                        if(feedsListener[i].imagesOrVideos.length - 3 > 0){
                                          if(lookupMimeType(feedsListener[i].imagesOrVideos[index])?.contains('video') == true){
                                            return Stack(
                                              fit: StackFit.expand,
                                              children: [
                                                BetterPlayer.network('${feedsListener[i].imagesOrVideos[index]}',
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
                                                    child: Text('${feedsListener[i].imagesOrVideos.length - 3}', style: const TextStyle(fontSize: 32, fontFamily: 'NexaBold', color: Color(0xffFFFFFF),),),
                                                    backgroundColor: const Color(0xffffffff).withOpacity(.5),
                                                    radius: 25,
                                                  ),
                                                ),
                                              ],
                                            );
                                          }else{
                                            return Stack(
                                              fit: StackFit.expand,
                                              children: [
                                                CachedNetworkImage(
                                                  errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                  placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                  imageUrl: feedsListener[i].imagesOrVideos[index],
                                                  fit: BoxFit.cover,
                                                ),

                                                Container(color: const Color(0xff000000).withOpacity(0.5),),

                                                Center(
                                                  child: CircleAvatar(
                                                    child: Text('${feedsListener[i].imagesOrVideos.length - 3}', style: const TextStyle(fontSize: 32, fontFamily: 'NexaBold', color: Color(0xffFFFFFF),),),
                                                    backgroundColor: const Color(0xffffffff).withOpacity(.5),
                                                    radius: 25,
                                                  ),
                                                ),
                                              ],
                                            );
                                          }
                                        }else{
                                          if(lookupMimeType(feedsListener[i].imagesOrVideos[index])?.contains('video') == true){
                                            return BetterPlayer.network('${feedsListener[i].imagesOrVideos[index]}',
                                              betterPlayerConfiguration: BetterPlayerConfiguration(
                                                placeholder: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 16 / 9),
                                                controlsConfiguration: const BetterPlayerControlsConfiguration(showControls: false,),
                                                aspectRatio: 16 / 9,
                                                fit: BoxFit.contain,
                                              ),
                                            );
                                          }else{
                                            return CachedNetworkImage(
                                              errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                              placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                              imageUrl: feedsListener[i].imagesOrVideos[index],
                                              fit: BoxFit.cover,
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
              ),
            ),
          )
          : SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              children: [
                const SizedBox(height: 45,),

                Align(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      children: <TextSpan>[
                          TextSpan(text: 'Welcome to\n', style: TextStyle(fontSize: 32, fontFamily: 'NexaBold', color:  Color(0xff2F353D),),),

                          TextSpan(text: 'Faces by Places', style: TextStyle(fontSize: 32, fontFamily: 'NexaBold', color: Color(0xff2F353D),),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 25,),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Image.asset('assets/icons/Welcome-new.png', width: SizeConfig.screenWidth, fit: BoxFit.cover,),
                ),

                const SizedBox(height: 50,),

                const Center(child: Text('Feed is empty', style: TextStyle(fontSize: 36, fontFamily: 'NexaBold', color: Color(0xffB1B1B1),),),),

                const SizedBox(height: 20,),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Center(
                    child: Text('Create a memorial page for loved ones by sharing stories, special events and photos of special occasions. Keeping their memories alive for generations.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 26, fontFamily: 'NexaRegular', color: Color(0xff2F353D),),
                    ),
                  ),
                ),

                const SizedBox(height: 25,),

                isGuestLoggedInListener
                ? const SizedBox(height: 0,)
                : MiscButtonTemplate(
                  buttonText: 'Create',
                  buttonTextStyle: const TextStyle(fontSize: 24, fontFamily: 'NexaBold', color: Color(0xffffffff),),
                  buttonColor: const Color(0xff000000),
                  width: SizeConfig.screenWidth! / 2,
                  height: 50,
                  onPressed: (){
                    Navigator.pushNamed(context, '/home/blm/create-memorial');
                  },
                ),

                const SizedBox(height: 20,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}