import 'package:facesbyplaces/API/BLM/02-Main/api-main-blm-04-03-home-post-tab.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-04-blm-post.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:better_player/better_player.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';

class BLMMainPagesPosts {
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

  const BLMMainPagesPosts(
      {required this.userId,
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
      required this.relationship});
}

class HomeBLMPostTab extends StatefulWidget {
  HomeBLMPostTabState createState() => HomeBLMPostTabState();
}

class HomeBLMPostTabState extends State<HomeBLMPostTab> {
  ScrollController scrollController = ScrollController();
  List<BLMMainPagesPosts> posts = [];
  bool isGuestLoggedIn = true;
  int itemRemaining = 1;
  int page = 1;
  ValueNotifier<int> count = ValueNotifier<int>(0);

  void initState() {
    super.initState();
    isGuest();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (itemRemaining != 0) {
          onLoading();
        } else {
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

  void isGuest() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    isGuestLoggedIn = sharedPrefs.getBool('user-guest-session') ?? false;

    if (isGuestLoggedIn != true) {
      onLoading();
    }
  }

  Future<void> onRefresh() async {
    onLoading();
  }

  void onLoading() async {
    if (itemRemaining != 0) {
      context.loaderOverlay.show();
      var newValue = await apiBLMHomePostTab(page: page);
      context.loaderOverlay.hide();

      itemRemaining = newValue.blmItemsRemaining;
      count.value = count.value + newValue.blmFamilyMemorialList.length;

      for (int i = 0; i < newValue.blmFamilyMemorialList.length; i++) {
        List<String> newList1 = [];
        List<String> newList2 = [];
        List<String> newList3 = [];
        List<int> newList4 = [];

        for (int j = 0;
            j < newValue.blmFamilyMemorialList[i].homeTabPostPostTagged.length;
            j++) {
          newList1.add(newValue.blmFamilyMemorialList[i]
              .homeTabPostPostTagged[j].homeTabPostTabTaggedFirstName);
          newList2.add(newValue.blmFamilyMemorialList[i]
              .homeTabPostPostTagged[j].homeTabPostTabTaggedLastName);
          newList3.add(newValue.blmFamilyMemorialList[i]
              .homeTabPostPostTagged[j].homeTabPostTabTaggedImage);
          newList4.add(newValue.blmFamilyMemorialList[i]
              .homeTabPostPostTagged[j].homeTabPostTabTaggedId);
        }

        posts.add(
          BLMMainPagesPosts(
            userId: newValue.blmFamilyMemorialList[i].homeTabPostPage
                .homeTabPostPagePageCreator.homeTabPostPageCreatorId,
            postId: newValue.blmFamilyMemorialList[i].homeTabPostId,
            memorialId: newValue
                .blmFamilyMemorialList[i].homeTabPostPage.homeTabPostPageId,
            timeCreated: newValue.blmFamilyMemorialList[i].homeTabPostCreatedAt,
            memorialName: newValue
                .blmFamilyMemorialList[i].homeTabPostPage.homeTabPostPageName,
            postBody: newValue.blmFamilyMemorialList[i].homeTabPostBody,
            profileImage: newValue.blmFamilyMemorialList[i].homeTabPostPage
                .homeTabPostPageProfileImage,
            imagesOrVideos:
                newValue.blmFamilyMemorialList[i].homeTabPostImagesOrVideos,
            managed: newValue
                .blmFamilyMemorialList[i].homeTabPostPage.homeTabPostPageManage,
            joined: newValue.blmFamilyMemorialList[i].homeTabPostPage
                .homeTabPostPageFollower,
            numberOfComments:
                newValue.blmFamilyMemorialList[i].homeTabPostNumberOfComments,
            numberOfLikes:
                newValue.blmFamilyMemorialList[i].homeTabPostNumberOfLikes,
            likeStatus: newValue.blmFamilyMemorialList[i].homeTabPostLikeStatus,
            numberOfTagged:
                newValue.blmFamilyMemorialList[i].homeTabPostPostTagged.length,
            taggedFirstName: newList1,
            taggedLastName: newList2,
            taggedImage: newList3,
            taggedId: newList4,
            pageType: newValue.blmFamilyMemorialList[i].homeTabPostPage
                .homeTabPostPagePageType,
            famOrFriends: newValue.blmFamilyMemorialList[i].homeTabPostPage
                .homeTabPostPageFamOrFriends,
            relationship: newValue.blmFamilyMemorialList[i].homeTabPostPage
                .homeTabPostPageRelationship,
          ),
        );
      }

      if (mounted) page++;
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    print('BLM Post tab screen rebuild!');
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
                    separatorBuilder: (c, i) =>
                        const Divider(height: 10, color: Colors.transparent),
                    itemBuilder: (c, i) {
                      return MiscBLMPost(
                        key: ValueKey('$i'),
                        userId: posts[i].userId,
                        postId: posts[i].postId,
                        memorialId: posts[i].memorialId,
                        memorialName: posts[i].memorialName,
                        timeCreated: timeago
                            .format(DateTime.parse(posts[i].timeCreated)),
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
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              posts[i].postBody,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 5,
                            ),
                          ),
                          posts[i].imagesOrVideos.isNotEmpty
                              ? Column(
                                  children: [
                                    const SizedBox(height: 20),
                                    Container(
                                      child: (() {
                                        if (posts[i].imagesOrVideos.length ==
                                            1) {
                                          if (lookupMimeType(posts[i]
                                                      .imagesOrVideos[0])
                                                  ?.contains('video') ==
                                              true) {
                                            return BetterPlayer.network(
                                              '${posts[i].imagesOrVideos[0]}',
                                              betterPlayerConfiguration:
                                                  const BetterPlayerConfiguration(
                                                controlsConfiguration:
                                                    const BetterPlayerControlsConfiguration(
                                                  showControls: false,
                                                ),
                                                aspectRatio: 16 / 9,
                                              ),
                                            );
                                          } else {
                                            return CachedNetworkImage(
                                              fit: BoxFit.cover,
                                              imageUrl:
                                                  posts[i].imagesOrVideos[0],
                                              placeholder: (context, url) =>
                                                  const Center(
                                                child:
                                                    const CircularProgressIndicator(),
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Image.asset(
                                                'assets/icons/cover-icon.png',
                                                fit: BoxFit.cover,
                                                scale: 1.0,
                                              ),
                                            );
                                          }
                                        } else if (posts[i]
                                                .imagesOrVideos
                                                .length ==
                                            2) {
                                          return StaggeredGridView.countBuilder(
                                            padding: EdgeInsets.zero,
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            crossAxisCount: 4,
                                            itemCount: 2,
                                            itemBuilder: (BuildContext context,
                                                    int index) =>
                                                lookupMimeType(posts[i]
                                                                    .imagesOrVideos[
                                                                index])
                                                            ?.contains(
                                                                'video') ==
                                                        true
                                                    ? BetterPlayer.network(
                                                        '${posts[i].imagesOrVideos[index]}',
                                                        betterPlayerConfiguration:
                                                            const BetterPlayerConfiguration(
                                                          controlsConfiguration:
                                                              const BetterPlayerControlsConfiguration(
                                                            showControls: false,
                                                          ),
                                                          aspectRatio: 16 / 9,
                                                        ),
                                                      )
                                                    : CachedNetworkImage(
                                                        fit: BoxFit.cover,
                                                        imageUrl: posts[i]
                                                                .imagesOrVideos[
                                                            index],
                                                        placeholder:
                                                            (context, url) =>
                                                                const Center(
                                                          child:
                                                              const CircularProgressIndicator(),
                                                        ),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            Image.asset(
                                                          'assets/icons/cover-icon.png',
                                                          fit: BoxFit.cover,
                                                          scale: 1.0,
                                                        ),
                                                      ),
                                            staggeredTileBuilder: (int index) =>
                                                const StaggeredTile.count(2, 2),
                                            mainAxisSpacing: 4.0,
                                            crossAxisSpacing: 4.0,
                                          );
                                        } else {
                                          return StaggeredGridView.countBuilder(
                                            padding: EdgeInsets.zero,
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            crossAxisCount: 4,
                                            itemCount: 3,
                                            staggeredTileBuilder: (int index) =>
                                                StaggeredTile.count(
                                                    2, index.isEven ? 1 : 2),
                                            mainAxisSpacing: 4.0,
                                            crossAxisSpacing: 4.0,
                                            itemBuilder: (BuildContext context,
                                                    int index) =>
                                                (() {
                                              if (index != 1) {
                                                return lookupMimeType(posts[i]
                                                                    .imagesOrVideos[
                                                                index])
                                                            ?.contains(
                                                                'video') ==
                                                        true
                                                    ? BetterPlayer.network(
                                                        '${posts[i].imagesOrVideos[index]}',
                                                        betterPlayerConfiguration:
                                                            const BetterPlayerConfiguration(
                                                          controlsConfiguration:
                                                              const BetterPlayerControlsConfiguration(
                                                            showControls: false,
                                                          ),
                                                          aspectRatio: 16 / 9,
                                                        ),
                                                      )
                                                    : CachedNetworkImage(
                                                        fit: BoxFit.cover,
                                                        imageUrl: posts[i]
                                                                .imagesOrVideos[
                                                            index],
                                                        placeholder:
                                                            (context, url) =>
                                                                const Center(
                                                          child:
                                                              const CircularProgressIndicator(),
                                                        ),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            Image.asset(
                                                          'assets/icons/cover-icon.png',
                                                          fit: BoxFit.cover,
                                                          scale: 1.0,
                                                        ),
                                                      );
                                              } else {
                                                return (() {
                                                  if (posts[i]
                                                              .imagesOrVideos
                                                              .length -
                                                          3 >
                                                      0) {
                                                    if (lookupMimeType(posts[i]
                                                                    .imagesOrVideos[
                                                                index])
                                                            ?.contains(
                                                                'video') ==
                                                        true) {
                                                      return Stack(
                                                        fit: StackFit.expand,
                                                        children: [
                                                          BetterPlayer.network(
                                                            '${posts[i].imagesOrVideos[index]}',
                                                            betterPlayerConfiguration:
                                                                const BetterPlayerConfiguration(
                                                              controlsConfiguration:
                                                                  const BetterPlayerControlsConfiguration(
                                                                showControls:
                                                                    false,
                                                              ),
                                                              aspectRatio:
                                                                  16 / 9,
                                                            ),
                                                          ),
                                                          Container(
                                                            color: const Color(
                                                                    0xff000000)
                                                                .withOpacity(
                                                                    0.5),
                                                          ),
                                                          Center(
                                                            child: CircleAvatar(
                                                              radius: 25,
                                                              backgroundColor:
                                                                  const Color(
                                                                          0xffffffff)
                                                                      .withOpacity(
                                                                          .5),
                                                              child: Text(
                                                                '${posts[i].imagesOrVideos.length - 3}',
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize: 40,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: const Color(
                                                                      0xffffffff),
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
                                                            imageUrl: posts[i]
                                                                    .imagesOrVideos[
                                                                index],
                                                            placeholder:
                                                                (context,
                                                                        url) =>
                                                                    const Center(
                                                              child:
                                                                  const CircularProgressIndicator(),
                                                            ),
                                                            errorWidget:
                                                                (context, url,
                                                                        error) =>
                                                                    Image.asset(
                                                              'assets/icons/cover-icon.png',
                                                              fit: BoxFit.cover,
                                                              scale: 1.0,
                                                            ),
                                                          ),
                                                          Container(
                                                            color: const Color(
                                                                    0xff000000)
                                                                .withOpacity(
                                                                    0.5),
                                                          ),
                                                          Center(
                                                            child: CircleAvatar(
                                                              radius: 25,
                                                              backgroundColor:
                                                                  const Color(
                                                                          0xffffffff)
                                                                      .withOpacity(
                                                                          .5),
                                                              child: Text(
                                                                '${posts[i].imagesOrVideos.length - 3}',
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize: 40,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: const Color(
                                                                      0xffffffff),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    }
                                                  } else {
                                                    if (lookupMimeType(posts[i]
                                                                    .imagesOrVideos[
                                                                index])
                                                            ?.contains(
                                                                'video') ==
                                                        true) {
                                                      return BetterPlayer
                                                          .network(
                                                        '${posts[i].imagesOrVideos[index]}',
                                                        betterPlayerConfiguration:
                                                            const BetterPlayerConfiguration(
                                                          controlsConfiguration:
                                                              const BetterPlayerControlsConfiguration(
                                                            showControls: false,
                                                          ),
                                                          aspectRatio: 16 / 9,
                                                        ),
                                                      );
                                                    } else {
                                                      return CachedNetworkImage(
                                                        fit: BoxFit.cover,
                                                        imageUrl: posts[i]
                                                                .imagesOrVideos[
                                                            index],
                                                        placeholder:
                                                            (context, url) =>
                                                                const Center(
                                                          child:
                                                              const CircularProgressIndicator(),
                                                        ),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            Image.asset(
                                                          'assets/icons/cover-icon.png',
                                                          fit: BoxFit.cover,
                                                          scale: 1.0,
                                                        ),
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
                    }),
              )
            : SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height:
                            (SizeConfig.screenHeight! - 85 - kToolbarHeight) /
                                3.5,
                      ),
                      Image.asset(
                        'assets/icons/app-icon.png',
                        height: 250,
                        width: 250,
                      ),
                      const SizedBox(
                        height: 45,
                      ),
                      Text(
                        'Post is empty',
                        style: TextStyle(
                          fontSize: SizeConfig.blockSizeVertical! * 3.52,
                          fontFamily: 'NexaBold',
                          color: const Color(0xffB1B1B1),
                        ),
                      ),
                      SizedBox(
                        height:
                            (SizeConfig.screenHeight! - 85 - kToolbarHeight) /
                                3.5,
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}