import 'package:facesbyplaces/API/Regular/02-Main/api-main-regular-04-01-home-feed-tab.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-04-regular-post.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-06-regular-button.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-04-blm-post.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:better_player/better_player.dart';
import 'package:timeago/timeago.dart' as timeago;
// ignore: import_of_legacy_library_into_null_safe
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';

class RegularMainPagesFeeds{
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
  const RegularMainPagesFeeds({required this.userId, required this.postId, required this.memorialId, required this.memorialName, required this.timeCreated, required this.postBody, required this.profileImage, required this.imagesOrVideos, required this.managed, required this.joined, required this.numberOfComments, required this.numberOfLikes, required this.likeStatus, required this.numberOfTagged, required this.taggedFirstName, required this.taggedLastName, required this.taggedImage, required this.taggedId, required this.pageType, required this.famOrFriends, required this.relationship});
}

class HomeRegularFeedTab extends StatefulWidget{

  HomeRegularFeedTabState createState() => HomeRegularFeedTabState();
}

class HomeRegularFeedTabState extends State<HomeRegularFeedTab>{
  ValueNotifier<List<RegularMainPagesFeeds>> feeds = ValueNotifier<List<RegularMainPagesFeeds>>([]);
  ValueNotifier<bool> isGuestLoggedIn = ValueNotifier<bool>(false);
  ScrollController scrollController = ScrollController();
  ValueNotifier<int> count = ValueNotifier<int>(0);
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
              content: const Text('No more feeds to show'),
              duration: const Duration(seconds: 1),
              backgroundColor: const Color(0xff4EC9D4),
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
      var newValue = await apiRegularHomeFeedTab(page: page).onError((error, stackTrace){
        context.loaderOverlay.hide();
        showDialog(
          context: context,
          builder: (_) => AssetGiffyDialog(
          image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
          title: Text('Error',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 3.87, fontFamily: 'NexaRegular',),),
            entryAnimation: EntryAnimation.DEFAULT,
            description: Text('Error: $error.', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.87, fontFamily: 'NexaRegular',),),
            onlyOkButton: true,
            buttonOkColor: const Color(0xffff0000),
            onOkButtonPressed: (){
              Navigator.pop(context, true);
            },
          ),
        );
        throw Exception('$error');
      });
      context.loaderOverlay.hide();

      itemRemaining = newValue.almItemsRemaining;
      count.value = count.value + newValue.almFamilyMemorialList.length;

      for(int i = 0; i < newValue.almFamilyMemorialList.length; i++){
        List<String> newList1 = [];
        List<String> newList2 = [];
        List<String> newList3 = [];
        List<int> newList4 = [];
        for(int j = 0; j < newValue.almFamilyMemorialList[i].homeTabFeedPostTagged.length; j++){
          newList1.add(newValue.almFamilyMemorialList[i].homeTabFeedPostTagged[j].homeTabFeedTaggedFirstName);
          newList2.add(newValue.almFamilyMemorialList[i].homeTabFeedPostTagged[j].homeTabFeedTaggedLastName);
          newList3.add(newValue.almFamilyMemorialList[i].homeTabFeedPostTagged[j].homeTabFeedTaggedImage);
          newList4.add(newValue.almFamilyMemorialList[i].homeTabFeedPostTagged[j].homeTabFeedTaggedId);
        }

        feeds.value.add(
          RegularMainPagesFeeds(
            userId: newValue.almFamilyMemorialList[i].homeTabFeedPage.homeTabFeedPagePageCreator.homeTabFeedPageCreatorId,
            postId: newValue.almFamilyMemorialList[i].homeTabFeedId,
            memorialId: newValue.almFamilyMemorialList[i].homeTabFeedPage.homeTabFeedPageId,
            timeCreated: newValue.almFamilyMemorialList[i].homeTabFeedCreatedAt,
            memorialName: newValue.almFamilyMemorialList[i].homeTabFeedPage.homeTabFeedPageName,
            postBody: newValue.almFamilyMemorialList[i].homeTabFeedBody,
            profileImage: newValue.almFamilyMemorialList[i].homeTabFeedPage.homeTabFeedPageProfileImage,
            imagesOrVideos: newValue.almFamilyMemorialList[i].homeTabFeedImagesOrVideos,
            managed: newValue.almFamilyMemorialList[i].homeTabFeedPage.homeTabFeedPageManage,
            joined: newValue.almFamilyMemorialList[i].homeTabFeedPage.homeTabFeedPageFollower,
            numberOfComments: newValue.almFamilyMemorialList[i].homeTabFeedNumberOfComments,
            numberOfLikes: newValue.almFamilyMemorialList[i].homeTabFeedNumberOfLikes,
            likeStatus: newValue.almFamilyMemorialList[i].homeTabFeedLikeStatus,
            numberOfTagged: newValue.almFamilyMemorialList[i].homeTabFeedPostTagged.length,
            taggedFirstName: newList1,
            taggedLastName: newList2,
            taggedImage: newList3,
            taggedId: newList4,
            pageType: newValue.almFamilyMemorialList[i].homeTabFeedPage.homeTabFeedPagePageType,
            famOrFriends: newValue.almFamilyMemorialList[i].homeTabFeedPage.homeTabFeedPageFamOrFriends,
            relationship: newValue.almFamilyMemorialList[i].homeTabFeedPage.homeTabFeedPageRelationship,
          ),
        );
      }

      if(mounted)
      page++;
    }
  }

  @override
  Widget build(BuildContext context){
    SizeConfig.init(context);
    print('Feed tab rebuild!');
    return ValueListenableBuilder(
      valueListenable: isGuestLoggedIn,
      builder: (_, bool isGuestLoggedInListener, __) => ValueListenableBuilder(
        valueListenable: feeds,
        builder: (_, List<RegularMainPagesFeeds> feedsListener, __) => ValueListenableBuilder(
          valueListenable: count,
          builder: (_, int countListener, __) => countListener != 0
          ? RefreshIndicator(
            onRefresh: onRefresh,
            child: ListView.separated(
              controller: scrollController,
              padding: const EdgeInsets.all(10.0),
              physics: const ClampingScrollPhysics(),
              itemCount: countListener,
              separatorBuilder: (c, i) => const Divider(height: 10, color: Colors.transparent),
              itemBuilder: (c, i){
                return feedsListener[i].pageType == 'Blm'
                ? MiscBLMPost(
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
                  contents: [
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        feedsListener[i].postBody,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 5,
                      ),
                    ),
                        
                    feedsListener[i].imagesOrVideos.isNotEmpty
                    ? Column(
                      children: [
                        SizedBox(height: 20),
                        
                        Container(
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
                                  fit: BoxFit.cover,
                                  imageUrl: feedsListener[i].imagesOrVideos[0],
                                  placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                  errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                );
                              }
                            }else if(feedsListener[i].imagesOrVideos.length == 2){
                              return StaggeredGridView.countBuilder(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                crossAxisCount: 4,
                                itemCount: 2,
                                staggeredTileBuilder:(int index) => const StaggeredTile.count(2, 2),
                                mainAxisSpacing: 4.0,
                                crossAxisSpacing: 4.0,
                                itemBuilder: (BuildContext context, int index) => lookupMimeType(feedsListener[i].imagesOrVideos[index])?.contains('video') == true
                                ? BetterPlayer.network('${feedsListener[i].imagesOrVideos[index]}',
                                    betterPlayerConfiguration: BetterPlayerConfiguration(placeholder: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 16 / 9),
                                    controlsConfiguration: const BetterPlayerControlsConfiguration(showControls: false,),
                                    aspectRatio: 16 / 9,
                                    fit: BoxFit.contain,
                                  ),
                                )
                                : CachedNetworkImage(
                                  fit: BoxFit.cover, 
                                  imageUrl: feedsListener[i].imagesOrVideos[index],
                                  placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                  errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,scale: 1.0,),
                                ),
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
                                      fit: BoxFit.cover,
                                      imageUrl: feedsListener[i].imagesOrVideos[index],
                                      placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                      errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
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
                                                  radius: 25,
                                                  backgroundColor: const Color(0xffffffff).withOpacity(.5),
                                                  child: Text('${feedsListener[i].imagesOrVideos.length - 3}',
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
                                                imageUrl: feedsListener[i].imagesOrVideos[index],
                                                placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                              ),

                                              Container(color: const Color(0xff000000).withOpacity(0.5),),
                                              
                                              Center(
                                                child: CircleAvatar(
                                                  radius: 25,
                                                  backgroundColor: const Color(0xffffffff).withOpacity(.5),
                                                  child: Text('${feedsListener[i].imagesOrVideos.length - 3}',
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
                                        if(lookupMimeType(feedsListener[i].imagesOrVideos[index])?.contains('video') == true) {
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
                                            fit: BoxFit.cover,
                                            imageUrl: feedsListener[i].imagesOrVideos[index],
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
                  contents: [
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        feedsListener[i].postBody,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 5,
                        style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.11, fontFamily: 'NexaRegular', color: const Color(0xff000000),),
                      ),
                    ),
                    
                    feedsListener[i].imagesOrVideos.isNotEmpty
                    ? Column(
                      children: [
                        const SizedBox(height: 20),
                        Container(
                          child: ((){
                            if(feedsListener[i].imagesOrVideos.length == 1){
                              if(lookupMimeType(feedsListener[i].imagesOrVideos[0])?.contains('video') == true){
                                return BetterPlayer.network('${feedsListener[i].imagesOrVideos[0]}',
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
                                  imageUrl: feedsListener[i].imagesOrVideos[0],
                                  placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                  errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                );
                              }
                            }else if(feedsListener[i].imagesOrVideos.length == 2){
                              return StaggeredGridView.countBuilder(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                crossAxisCount: 4,
                                itemCount: 2,
                                staggeredTileBuilder: (int index) => const StaggeredTile.count(2, 2),
                                mainAxisSpacing: 4.0,
                                crossAxisSpacing: 4.0,
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
                                  fit: BoxFit.cover,
                                  imageUrl: feedsListener[i].imagesOrVideos[index],
                                  placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                  errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                ),
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
                                      fit: BoxFit.cover,
                                      imageUrl: feedsListener[i].imagesOrVideos[index],
                                      placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                      errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                    );
                                  }else{
                                    return ((){
                                      if(feedsListener[i].imagesOrVideos.length - 3 > 0){
                                        if (lookupMimeType(feedsListener[i].imagesOrVideos[index])?.contains('video') == true) {
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
                                                  radius: 25,
                                                  backgroundColor: const Color(0xffffffff).withOpacity(.5),
                                                  child: Text('${feedsListener[i].imagesOrVideos.length - 3}',
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
                                        } else {
                                          return Stack(
                                            fit: StackFit.expand,
                                            children: [
                                              CachedNetworkImage(
                                                fit: BoxFit.cover,
                                                imageUrl: feedsListener[i].imagesOrVideos[index],
                                                placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                              ),

                                              Container(color: const Color(0xff000000).withOpacity(0.5),),

                                              Center(
                                                child: CircleAvatar(
                                                  radius: 25,
                                                  backgroundColor: const Color(0xffffffff).withOpacity(.5),
                                                  child: Text('${feedsListener[i].imagesOrVideos.length - 3}',
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
                                            fit: BoxFit.cover,
                                            imageUrl: feedsListener[i].imagesOrVideos[index],
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
            child: Column(
              children: [
                const SizedBox(height: 45),

                Align(
                  alignment: Alignment.center,
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children:  <TextSpan>[
                        TextSpan(
                          text: 'Welcome to\n',
                          style: TextStyle(
                            fontSize: SizeConfig.blockSizeVertical! * 3.16,
                            fontFamily: 'NexaBold',
                            color: const Color(0xff2F353D),
                          ),
                        ),
                        TextSpan(
                          text: 'Faces by Places',
                          style:  TextStyle(
                            fontSize: SizeConfig.blockSizeVertical! * 3.16,
                            fontFamily: 'NexaBold',
                            color: const Color(0xff2F353D),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),

                Container(
                  padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal! * 2, right: SizeConfig.blockSizeHorizontal! * 2),
                  child: Image.asset('assets/icons/Welcome.png', width: SizeConfig.screenWidth, fit: BoxFit.cover,),
                ),

                SizedBox(height: SizeConfig.blockSizeVertical! * 4.04),

                Center(
                  child: Text('Feed is empty',
                    style: TextStyle(
                      fontSize: SizeConfig.blockSizeVertical! * 3.52,
                      fontFamily: 'NexaBold',
                      color: const Color(0xffB1B1B1),
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal! * 6, right: SizeConfig.blockSizeHorizontal! * 6),
                  child: Center(
                    child: Text('Create a memorial page for loved ones by sharing stories, special events and photos of special occasions. Keeping their memories alive for generations.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: SizeConfig.blockSizeVertical! * 2.64,
                        fontFamily: 'NexaRegular',
                        color: const Color(0xff2F353D),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20),

                isGuestLoggedInListener
                ? Container(height: 0,)
                : MiscRegularButtonTemplate(
                  buttonText: 'Create',
                  buttonTextStyle:  TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.64, fontFamily: 'NexaBold', color: const Color(0xffffffff),),
                  width: SizeConfig.screenWidth! / 2,
                  height: 45,
                  buttonColor: const Color(0xff04ECFF),
                  onPressed: (){
                    Navigator.pushNamed(context, '/home/regular/create-memorial');
                  },
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}