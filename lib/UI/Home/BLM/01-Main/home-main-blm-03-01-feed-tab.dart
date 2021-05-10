import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-04-blm-post.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-06-blm-button.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-09-blm-image-display.dart';
import 'package:facesbyplaces/API/BLM/02-Main/api-main-blm-04-01-home-feed-tab.dart';
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

  const BLMMainPagesFeeds({required this.userId, required this.postId, required this.memorialId, required this.memorialName, required this.timeCreated, required this.postBody, required this.profileImage, required this.imagesOrVideos, required this.managed, required this.joined, required this.numberOfLikes, required this.numberOfComments, required this.likeStatus, required this.numberOfTagged, required this.taggedFirstName, required this.taggedLastName, required this.taggedImage, required this.taggedId, required this.pageType, required this.famOrFriends, required this.relationship});
}

class HomeBLMFeedTab extends StatefulWidget{

  HomeBLMFeedTabState createState() => HomeBLMFeedTabState();
}

class HomeBLMFeedTabState extends State<HomeBLMFeedTab>{
  
  ScrollController scrollController = ScrollController();
  List<BLMMainPagesFeeds> feeds = [];
  bool isGuestLoggedIn = false;
  int itemRemaining = 1;
  int page = 1;
  int count = 0;

  void initState(){
    super.initState();
    isGuest();
  }

  Future<void> onRefresh() async{
    setState(() {
      onLoading();
    });
  }

  void isGuest() async{
    final sharedPrefs = await SharedPreferences.getInstance();
    setState(() {
      isGuestLoggedIn = sharedPrefs.getBool('user-guest-session') ?? false;
    });
    if(isGuestLoggedIn != true){
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
                content: const Text('No more feeds to show'),
                duration: const Duration(seconds: 1),
                backgroundColor: const Color(0xff4EC9D4),
              ),
            );
          }
        }
      });
    }
  }

  void onLoading() async{
    if(itemRemaining != 0){
      context.loaderOverlay.show();
      var newValue = await apiBLMHomeFeedTab(page: page);
      context.loaderOverlay.hide();
      itemRemaining = newValue.blmItemsRemaining;
      count = newValue.blmFamilyMemorialList.length;

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

        feeds.add(
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
            numberOfComments: newValue.blmFamilyMemorialList[i].homeTabFeedNumberOfComments,
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
    return count != 0
    ? RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.separated(
        controller: scrollController,
        padding: const EdgeInsets.all(10.0),
        physics: const ClampingScrollPhysics(),
        itemCount: count,
        separatorBuilder: (c, i) => const Divider(height: 10, color: Colors.transparent),
        itemBuilder: (c, i) {
          return feeds[i].pageType == 'Blm'
          ? MiscBLMPost(
            userId: feeds[i].userId,
            postId: feeds[i].postId,
            memorialId: feeds[i].memorialId,
            memorialName: feeds[i].memorialName,
            timeCreated: timeago.format(DateTime.parse(feeds[i].timeCreated)),
            managed: feeds[i].managed,
            joined: feeds[i].joined,
            profileImage: feeds[i].profileImage,
            numberOfComments: feeds[i].numberOfComments,
            numberOfLikes: feeds[i].numberOfLikes,
            likeStatus: feeds[i].likeStatus,
            numberOfTagged: feeds[i].numberOfTagged,
            taggedFirstName: feeds[i].taggedFirstName,
            taggedLastName: feeds[i].taggedLastName,
            taggedId: feeds[i].taggedId,
            pageType: feeds[i].pageType,
            famOrFriends: feeds[i].famOrFriends,
            relationship: feeds[i].relationship,
            contents: [
              Container(alignment: Alignment.centerLeft, child: Text(feeds[i].postBody, overflow: TextOverflow.ellipsis, maxLines: 5,),),

              feeds[i].imagesOrVideos.isNotEmpty
              ? Column(
                children: [
                  const SizedBox(height: 20),

                  Container(
                    child: ((){
                      if(feeds[i].imagesOrVideos.length == 1){
                        if(lookupMimeType(feeds[i].imagesOrVideos[0])?.contains('video') == true){
                          return BetterPlayer.network('${feeds[i].imagesOrVideos[0]}',
                            betterPlayerConfiguration: const BetterPlayerConfiguration(
                              controlsConfiguration: const BetterPlayerControlsConfiguration(
                                showControls: false,
                              ),
                              aspectRatio: 16 / 9,
                            ),
                          );
                        }else{
                          return CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: feeds[i].imagesOrVideos[0],
                            placeholder: (context, url) => const Center(child: const CircularProgressIndicator(),),
                            errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                          );
                        }
                      }else if(feeds[i].imagesOrVideos.length == 2){
                        return StaggeredGridView.countBuilder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 4,
                          itemCount: 2,
                          itemBuilder: (BuildContext context, int index) =>  
                            lookupMimeType(feeds[i].imagesOrVideos[index])?.contains('video') == true
                            ? BetterPlayer.network('${feeds[i].imagesOrVideos[index]}',
                              betterPlayerConfiguration: const BetterPlayerConfiguration(
                                controlsConfiguration: const BetterPlayerControlsConfiguration(
                                  showControls: false,
                                ),
                                aspectRatio: 16 / 9,
                              ),
                            )
                            : CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: feeds[i].imagesOrVideos[index],
                              placeholder: (context, url) => const Center(child: const CircularProgressIndicator(),),
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
                              return lookupMimeType(feeds[i].imagesOrVideos[index])?.contains('video') == true
                              ? BetterPlayer.network('${feeds[i].imagesOrVideos[index]}',
                                betterPlayerConfiguration: const BetterPlayerConfiguration(
                                  controlsConfiguration: const BetterPlayerControlsConfiguration(
                                    showControls: false,
                                  ),
                                  aspectRatio: 16 / 9,
                                ),
                              )
                              : CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl: feeds[i].imagesOrVideos[index],
                                placeholder: (context, url) => const Center(child: const CircularProgressIndicator(),),
                                errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                              );
                            }else{
                              return ((){
                                if(feeds[i].imagesOrVideos.length - 3 > 0){
                                  if(lookupMimeType(feeds[i].imagesOrVideos[index])?.contains('video') == true){
                                    return Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        BetterPlayer.network('${feeds[i].imagesOrVideos[index]}',
                                          betterPlayerConfiguration: const BetterPlayerConfiguration(
                                            controlsConfiguration: const BetterPlayerControlsConfiguration(
                                              showControls: false,
                                            ),
                                            aspectRatio: 16 / 9,
                                          ),
                                        ),

                                        Container(color: const Color(0xff000000).withOpacity(0.5),),

                                        Center(
                                          child: CircleAvatar(
                                            radius: 25,
                                            backgroundColor: const Color(0xffffffff).withOpacity(.5),
                                            child: Text(
                                              '${feeds[i].imagesOrVideos.length - 3}',
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
                                          imageUrl: feeds[i].imagesOrVideos[index],
                                          placeholder: (context, url) => const Center(child: const CircularProgressIndicator(),),
                                          errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                        ),

                                        Container(color: const Color(0xff000000).withOpacity(0.5),),

                                        Center(
                                          child: CircleAvatar(
                                            radius: 25,
                                            backgroundColor: const Color(0xffffffff).withOpacity(.5),
                                            child: Text(
                                              '${feeds[i].imagesOrVideos.length - 3}',
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
                                  if(lookupMimeType(feeds[i].imagesOrVideos[index])?.contains('video') == true){
                                    return BetterPlayer.network('${feeds[i].imagesOrVideos[index]}',
                                      betterPlayerConfiguration: const BetterPlayerConfiguration(
                                        controlsConfiguration: const BetterPlayerControlsConfiguration(
                                          showControls: false,
                                        ),
                                        aspectRatio: 16 / 9,
                                      ),
                                    );
                                  }else{
                                    return CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      imageUrl: feeds[i].imagesOrVideos[index],
                                      placeholder: (context, url) => const Center(child: const CircularProgressIndicator(),),
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
            userId: feeds[i].userId,
            postId: feeds[i].postId,
            memorialId: feeds[i].memorialId,
            memorialName: feeds[i].memorialName,
            timeCreated: timeago.format(DateTime.parse(feeds[i].timeCreated)),
            managed: feeds[i].managed,
            joined: feeds[i].joined,
            profileImage: feeds[i].profileImage,
            numberOfComments: feeds[i].numberOfComments,
            numberOfLikes: feeds[i].numberOfLikes,
            likeStatus: feeds[i].likeStatus,
            numberOfTagged: feeds[i].numberOfTagged,
            taggedFirstName: feeds[i].taggedFirstName,
            taggedLastName: feeds[i].taggedLastName,
            taggedId: feeds[i].taggedId,
            pageType: feeds[i].pageType,
            famOrFriends: feeds[i].famOrFriends,
            relationship: feeds[i].relationship,
            contents: [
              Container(alignment: Alignment.centerLeft, child: Text(feeds[i].postBody, overflow: TextOverflow.ellipsis, maxLines: 5,),),

              feeds[i].imagesOrVideos.isNotEmpty
              ? Column(
                children: [
                  const SizedBox(height: 20),

                  Container(
                    child: ((){
                      if(feeds[i].imagesOrVideos.length == 1){
                        if(lookupMimeType(feeds[i].imagesOrVideos[0])?.contains('video') == true){
                          return BetterPlayer.network('${feeds[i].imagesOrVideos[0]}',
                            betterPlayerConfiguration: const BetterPlayerConfiguration(
                              controlsConfiguration: const BetterPlayerControlsConfiguration(
                                showControls: false,
                              ),
                              aspectRatio: 16 / 9,
                            ),
                          );
                        }else{
                          return CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: feeds[i].imagesOrVideos[0],
                            placeholder: (context, url) => const Center(child: const CircularProgressIndicator(),),
                            errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                          );
                        }
                      }else if(feeds[i].imagesOrVideos.length == 2){
                        return StaggeredGridView.countBuilder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 4,
                          itemCount: 2,
                          itemBuilder: (BuildContext context, int index) =>  
                            lookupMimeType(feeds[i].imagesOrVideos[index])?.contains('video') == true
                            ? BetterPlayer.network('${feeds[i].imagesOrVideos[index]}',
                              betterPlayerConfiguration: const BetterPlayerConfiguration(
                                controlsConfiguration: const BetterPlayerControlsConfiguration(
                                  showControls: false,
                                ),
                                aspectRatio: 16 / 9,
                              ),
                            )
                            : CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: feeds[i].imagesOrVideos[index],
                              placeholder: (context, url) => const Center(child: const CircularProgressIndicator(),),
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
                              return lookupMimeType(feeds[i].imagesOrVideos[index])?.contains('video') == true
                              ? BetterPlayer.network('${feeds[i].imagesOrVideos[index]}',
                                betterPlayerConfiguration: const BetterPlayerConfiguration(
                                  controlsConfiguration: const BetterPlayerControlsConfiguration(
                                    showControls: false,
                                  ),
                                  aspectRatio: 16 / 9,
                                ),
                              )
                              : CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl: feeds[i].imagesOrVideos[index],
                                placeholder: (context, url) => const Center(child: const CircularProgressIndicator(),),
                                errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                              );
                            }else{
                              return ((){
                                if(feeds[i].imagesOrVideos.length - 3 > 0){
                                  if(lookupMimeType(feeds[i].imagesOrVideos[index])?.contains('video') == true){
                                    return Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        BetterPlayer.network('${feeds[i].imagesOrVideos[index]}',
                                          betterPlayerConfiguration: const BetterPlayerConfiguration(
                                            controlsConfiguration: const BetterPlayerControlsConfiguration(
                                              showControls: false,
                                            ),
                                            aspectRatio: 16 / 9,
                                          ),
                                        ),

                                        Container(color: const Color(0xff000000).withOpacity(0.5),),

                                        Center(
                                          child: CircleAvatar(
                                            radius: 25,
                                            backgroundColor: const Color(0xffffffff).withOpacity(.5),
                                            child: Text(
                                              '${feeds[i].imagesOrVideos.length - 3}',
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
                                          imageUrl: feeds[i].imagesOrVideos[index],
                                          placeholder: (context, url) => const Center(child: const CircularProgressIndicator(),),
                                          errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                        ),

                                        Container(color: const Color(0xff000000).withOpacity(0.5),),

                                        Center(
                                          child: CircleAvatar(
                                            radius: 25,
                                            backgroundColor: const Color(0xffffffff).withOpacity(.5),
                                            child: Text(
                                              '${feeds[i].imagesOrVideos.length - 3}',
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
                                  if(lookupMimeType(feeds[i].imagesOrVideos[index])?.contains('video') == true){
                                    return BetterPlayer.network('${feeds[i].imagesOrVideos[index]}',
                                      betterPlayerConfiguration: const BetterPlayerConfiguration(
                                        controlsConfiguration: const BetterPlayerControlsConfiguration(
                                          showControls: false,
                                        ),
                                        aspectRatio: 16 / 9,
                                      ),
                                    );
                                  }else{
                                    return CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      imageUrl: feeds[i].imagesOrVideos[index],
                                      placeholder: (context, url) => const Center(child: const CircularProgressIndicator(),),
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

          const SizedBox(height: 45,),

          Align(
            alignment: Alignment.center,
            child: RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                children: const <TextSpan>[
                  const TextSpan(text: 'Welcome to\n', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: const Color(0xff000000),),),

                  const TextSpan(text: 'Faces by Places', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: const Color(0xff000000),),),
                ],
              ),
            ),
          ),

          const SizedBox(height: 25,),

          Container(
            width: SizeConfig.screenHeight,
            child: Stack(
              children: [
                const Positioned(
                  left: 0,
                  top: 70,
                  child: const MiscBLMImageDisplayFeedTemplate(frontSize: 65, backSize: 70,),
                ),

                const Positioned(
                  right: 0,
                  top: 70,
                  child: const MiscBLMImageDisplayFeedTemplate(frontSize: 65, backSize: 70, backgroundColor: const Color(0xff04ECFF),),
                ),

                const Positioned(
                  left: 50,
                  top: 50,
                  child: const MiscBLMImageDisplayFeedTemplate(frontSize: 75, backSize: 80,),
                ),

                const Positioned(
                  right: 50,
                  top: 50,
                  child: const MiscBLMImageDisplayFeedTemplate(frontSize: 75, backSize: 80, backgroundColor: const Color(0xff04ECFF),),
                ),

                Center(child: Image.asset('assets/icons/logo.png', height: 240, width: 240,),),
              ],
            ),
          ),

          const SizedBox(height: 45,),

          const Center(child: const Text('Feed is empty', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: const Color(0xffB1B1B1),),),),

          const SizedBox(height: 20,),

          const Padding(padding: const EdgeInsets.only(left: 20.0, right: 20.0), child: const Center(child: const Text('Create a memorial page for loved ones by sharing stories, special events and photos of special occasions. Keeping their memories alive for generations.', textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, color: const Color(0xff000000),),),),),

          const SizedBox(height: 25,),

          isGuestLoggedIn
          ? Container(height: 0,)
          : MiscBLMButtonTemplate(
            buttonText: 'Create', 
            buttonTextStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold, 
              color: const Color(0xffffffff),
            ), 
            onPressed: (){
              Navigator.pushNamed(context, '/home/blm/create-memorial');
            }, 
            width: SizeConfig.screenWidth! / 2, 
            height: 45,
            buttonColor: const Color(0xff000000),
          ),

          const SizedBox(height: 20,),
          
        ],
      ),
    );
  }
}