import 'package:facesbyplaces/API/BLM/03-View-Memorial/api_view_memorial_blm_01_show_memorial_details.dart';
import 'package:facesbyplaces/API/BLM/03-View-Memorial/api_view_memorial_blm_02_show_profile_post.dart';
import 'package:facesbyplaces/API/BLM/03-View-Memorial/api_view_memorial_blm_03_show_switch_status.dart';
import 'package:facesbyplaces/UI/Home/BLM/01-Main/home_main_blm_02_home_extended.dart';
import 'package:facesbyplaces/UI/Home/BLM/04-Create-Post/home_create_post_blm_01_create_post.dart';
import 'package:facesbyplaces/UI/Home/BLM/08-Settings-Memorial/home_settings_memorial_blm_01_memorial_settings.dart';
import 'package:facesbyplaces/UI/Home/BLM/08-Settings-Memorial/home_settings_memorial_blm_08_memorial_settings_with_hidden.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc_02_blm_post.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'home_view_memorial_blm_03_connection_list.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:better_player/better_player.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mime/mime.dart';
import 'package:misc/misc.dart';
import 'dart:async';

class BLMProfilePosts{
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
  const BLMProfilePosts({required this.userId, required this.postId, required this.memorialId, required this.memorialName, required this.timeCreated, required this.postBody, required this.profileImage, required this.imagesOrVideos, required this.managed, required this.joined, required this.numberOfLikes, required this.numberOfComments, required this.likeStatus, required this.numberOfTagged, required this.taggedFirstName, required this.taggedLastName, required this.taggedImage, required this.taggedId, required this.pageType, required this.famOrFriends, required this.relationship, required this.location, required this.latitude, required this.longitude});
}

class HomeBLMProfile extends StatefulWidget{
  final int memorialId;
  final String relationship;
  final bool managed;
  final bool newlyCreated;
  const HomeBLMProfile({Key? key, required this.memorialId, required this.relationship, required this.managed, required this.newlyCreated}) : super(key: key);

  @override
  HomeBLMProfileState createState() => HomeBLMProfileState();
}

class HomeBLMProfileState extends State<HomeBLMProfile>{
  ValueNotifier<bool> showFloatingButton = ValueNotifier<bool>(false);
  CarouselController buttonCarouselController = CarouselController();
  TextEditingController controller = TextEditingController();
  GlobalKey profileKey = GlobalKey<HomeBLMProfileState>();
  ScrollController scrollController = ScrollController();
  GlobalKey dataKey = GlobalKey<HomeBLMProfileState>();
  ValueNotifier<int> postCount = ValueNotifier<int>(0);
  Future<APIBLMShowMemorialMain>? showProfile;
  List<BLMProfilePosts> posts = [];
  BranchUniversalObject? buo;
  BranchLinkProperties? lp;
  int itemRemaining = 1;
  bool empty = true;
  int page = 1;

  @override
  void initState(){
    super.initState();
    onLoading();
    showProfile = getProfileInformation(widget.memorialId);
    scrollController.addListener((){
      if(postCount.value != 0){
        if (scrollController.position.pixels == scrollController.position.maxScrollExtent){
          showFloatingButton.value = true;
        }else{
          showFloatingButton.value = false;
        }
      }
    });
  }

  void onLoading() async{
    if(itemRemaining != 0){
      context.loaderOverlay.show();
      var newValue = await apiBLMProfilePost(memorialId: widget.memorialId, page: page);
      itemRemaining = newValue.blmItemsRemaining;
      postCount.value = newValue.blmFamilyMemorialList.length;

      List<String> newList1 = [];
      List<String> newList2 = [];
      List<String> newList3 = [];
      List<int> newList4 = [];

      for(int i = 0; i < newValue.blmFamilyMemorialList.length; i++){
        for(int j = 0; j < newValue.blmFamilyMemorialList[i].profilePostPostTagged.length; j++){
          newList1.add(newValue.blmFamilyMemorialList[i].profilePostPostTagged[j].profilePageTaggedFirstName);
          newList2.add(newValue.blmFamilyMemorialList[i].profilePostPostTagged[j].profilePageTaggedLastName);
          newList3.add(newValue.blmFamilyMemorialList[i].profilePostPostTagged[j].profilePageTaggedImage);
          newList4.add(newValue.blmFamilyMemorialList[i].profilePostPostTagged[j].profilePageTaggedId);
        }

        posts.add(BLMProfilePosts(
          userId: newValue.blmFamilyMemorialList[i].profilePostPage.profilePagePageCreator.profilePageCreatorId, 
          postId: newValue.blmFamilyMemorialList[i].profilePostId,
          memorialId: newValue.blmFamilyMemorialList[i].profilePostPage.profilePageId,
          timeCreated: newValue.blmFamilyMemorialList[i].profilePostCreatedAt,
          memorialName: newValue.blmFamilyMemorialList[i].profilePostPage.profilePageName,
          postBody: newValue.blmFamilyMemorialList[i].profilePostBody,
          profileImage: newValue.blmFamilyMemorialList[i].profilePostPage.profilePageProfileImage,
          imagesOrVideos: newValue.blmFamilyMemorialList[i].profilePostImagesOrVideos,
          managed: newValue.blmFamilyMemorialList[i].profilePostPage.profilePageManage,
          joined: newValue.blmFamilyMemorialList[i].profilePostPage.profilePageFollower,
          numberOfComments: newValue.blmFamilyMemorialList[i].profilePostNumberOfComments,
          numberOfLikes: newValue.blmFamilyMemorialList[i].profilePostNumberOfLikes,
          likeStatus: newValue.blmFamilyMemorialList[i].profilePostLikeStatus,
          numberOfTagged: newValue.blmFamilyMemorialList[i].profilePostPostTagged.length,
          taggedFirstName: newList1,
          taggedLastName: newList2,
          taggedImage: newList3,
          taggedId: newList4,
          pageType: newValue.blmFamilyMemorialList[i].profilePostPage.profilePagePageType,
          famOrFriends: newValue.blmFamilyMemorialList[i].profilePostPage.profilePageFamOrFriends,
          relationship: newValue.blmFamilyMemorialList[i].profilePostPage.profilePageRelationship,
          location: newValue.blmFamilyMemorialList[i].homeProfilePostLocation,
          latitude: newValue.blmFamilyMemorialList[i].homeProfilePostLatitude,
          longitude: newValue.blmFamilyMemorialList[i].homeProfilePostLongitude,
          ),
        );
      }

      if(mounted){
        page++;
      }
      context.loaderOverlay.hide();
    }
  }

  void initBranchShare(){
    buo = BranchUniversalObject(
      canonicalIdentifier: 'FacesbyPlaces',
      title: 'FacesbyPlaces Link',
      contentDescription: 'FacesbyPlaces link to the app',
      keywords: ['FacesbyPlaces', 'Share', 'Link'],
      publiclyIndex: true,
      locallyIndex: true,
      contentMetadata: BranchContentMetaData()
      ..addCustomMetadata('link-category', 'Memorial')
      ..addCustomMetadata('link-memorial-id', widget.memorialId)
      ..addCustomMetadata('link-type-of-account', 'Blm')
    );

    lp = BranchLinkProperties(feature: 'sharing', stage: 'new share', tags: ['one', 'two', 'three']);
    lp!.addControlParam('url', 'https://4n5z1.test-app.link/qtdaGGTx3cb?bnc_validate=true');
  }

  Future<APIBLMShowMemorialMain> getProfileInformation(int memorialId) async{
    return await apiBLMShowMemorial(memorialId: memorialId);
  }

  Future<void> onRefresh() async{
    postCount.value = 0;
    itemRemaining = 1;
    posts = [];
    page = 1;
    onLoading();
  }

  @override
  Widget build(BuildContext context){
    SizeConfig.init(context);
    return ValueListenableBuilder(
      valueListenable: showFloatingButton,
      builder: (_, bool showFloatingButtonListener, __) => ValueListenableBuilder(
        valueListenable: postCount,
        builder: (_, int postCountListener, __) => Scaffold(
          body: RefreshIndicator(
            onRefresh: onRefresh,
            child: CustomScrollView(
              physics: const ClampingScrollPhysics(),
              controller: scrollController,
              slivers: <Widget>[
                SliverToBoxAdapter(
                  child: FutureBuilder<APIBLMShowMemorialMain>(
                    future: showProfile,
                    builder: (context, profile){
                      if(profile.hasData){
                        return Column(
                          key: profileKey,
                          children: [
                            Stack(
                              children: [
                                SizedBox(
                                  height: SizeConfig.screenHeight! / 3,
                                  width: SizeConfig.screenWidth,
                                  child: CachedNetworkImage(
                                    errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                    placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                    imageUrl: profile.data!.blmMemorial.memorialBackgroundImage,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                
                                Column(
                                  children: [
                                    GestureDetector( // BACKGROUND IMAGE FOR ZOOMING IN
                                      child: Container(height: SizeConfig.screenHeight! / 3.5, color: Colors.transparent,),
                                      onTap: (){
                                        showGeneralDialog(
                                          context: context,
                                          barrierLabel: 'Dialog',
                                          barrierDismissible: true,
                                          transitionDuration: const Duration(milliseconds: 0),
                                          pageBuilder: (_, __, ___) {
                                            return Scaffold(
                                              backgroundColor: Colors.black12.withOpacity(0.7),
                                              body: SizedBox.expand(
                                                child: SafeArea(
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        padding: const EdgeInsets.only(right: 20.0),
                                                        alignment: Alignment.centerRight,
                                                        child: GestureDetector(
                                                          child: CircleAvatar(
                                                            child: const Icon(Icons.close_rounded, color: Color(0xffffffff),),
                                                            backgroundColor: const Color(0xff000000).withOpacity(0.8),
                                                            radius: 20,
                                                          ),
                                                          onTap: (){
                                                            Navigator.pop(context);
                                                          },
                                                        ),
                                                      ),

                                                      const SizedBox(height: 20,),

                                                      Expanded(
                                                        child: CachedNetworkImage(
                                                          errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 1.0,),
                                                          placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                          imageUrl: profile.data!.blmMemorial.memorialBackgroundImage,
                                                          fit: BoxFit.contain,
                                                        ),
                                                      ),

                                                      const SizedBox(height: 80,),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    ),

                                    Container(
                                      width: SizeConfig.screenWidth,
                                      decoration: const BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)), color: Color(0xffffffff),),
                                      child: Column(
                                        children: [
                                          const SizedBox(height: 150,),

                                          Center(
                                            child: Text(profile.data!.blmMemorial.memorialName,
                                            style: const TextStyle(fontSize: 26, fontFamily: 'NexaBold', color: Color(0xff000000),), textAlign: TextAlign.center, overflow: TextOverflow.clip, maxLines: 5,),
                                          ),

                                          const SizedBox(height: 20),

                                          TextButton.icon(
                                            label: Text('${profile.data!.blmMemorial.memorialFollowersCount}', style: const TextStyle(fontSize: 20, fontFamily: 'NexaBold', color: Color(0xff2F353D),),),
                                            icon: const CircleAvatar(radius: 15, backgroundColor: Color(0xff000000), child: CircleAvatar(radius: 10, backgroundColor: Colors.transparent, foregroundImage: AssetImage('assets/icons/fist.png'),),),
                                            onPressed: (){
                                              Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMConnectionList(memorialId: widget.memorialId, newToggle: 2)));
                                            },
                                          ),

                                          const SizedBox(height: 20,),

                                          Column(
                                            children: [
                                              GestureDetector(
                                                child: ((){
                                                  if(profile.data!.blmMemorial.memorialImagesOrVideos.isNotEmpty){
                                                    if(lookupMimeType(profile.data!.blmMemorial.memorialImagesOrVideos[0])?.contains('video') == true){
                                                      return BetterPlayer.network('${profile.data!.blmMemorial.memorialImagesOrVideos[0]}',
                                                        betterPlayerConfiguration: BetterPlayerConfiguration(
                                                          placeholder: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 16 / 9),
                                                          controlsConfiguration: const BetterPlayerControlsConfiguration(showControls: false,),
                                                          aspectRatio: 16 / 9,
                                                          fit: BoxFit.contain,
                                                        ),
                                                      );
                                                    }else{
                                                      return const SizedBox(height: 0,);
                                                    }
                                                  }else{
                                                    return const SizedBox(height: 0,);
                                                  }
                                                }()),
                                                onTap: (){
                                                  showGeneralDialog(
                                                    context: context,
                                                    barrierLabel: 'Dialog',
                                                    barrierDismissible: true,
                                                    transitionDuration: const Duration(milliseconds: 0),
                                                    pageBuilder: (_, __, ___) {
                                                      return Scaffold(
                                                        backgroundColor: Colors.black12.withOpacity(0.7),
                                                        body: SizedBox.expand(
                                                          child: SafeArea(
                                                            child: Column(
                                                              children: [
                                                                Container(
                                                                  padding: const EdgeInsets.only(right: 20.0),
                                                                  alignment: Alignment.centerRight,
                                                                  child: GestureDetector(
                                                                    child: CircleAvatar(radius: 20, backgroundColor: const Color(0xff000000).withOpacity(0.8), child: const Icon(Icons.close_rounded, color: Color(0xffffffff),),),
                                                                    onTap: (){
                                                                      Navigator.pop(context);
                                                                    },
                                                                  ),
                                                                ),

                                                                const SizedBox(height: 10,),

                                                                Expanded(
                                                                  child: ((){
                                                                    if(lookupMimeType(profile.data!.blmMemorial.memorialImagesOrVideos[0])?.contains('video') == true){
                                                                      return BetterPlayer.network('${profile.data!.blmMemorial.memorialImagesOrVideos[0]}',
                                                                        betterPlayerConfiguration: BetterPlayerConfiguration(
                                                                          placeholder: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 16 / 9),
                                                                          deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
                                                                          aspectRatio: 16 / 9,
                                                                          fit: BoxFit.contain,
                                                                        ),
                                                                      );
                                                                    }else{
                                                                      return CachedNetworkImage(
                                                                        errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 1.0,),
                                                                        placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                                        imageUrl: profile.data!.blmMemorial.memorialImagesOrVideos[0],
                                                                        fit: BoxFit.contain,
                                                                      );
                                                                    }
                                                                  }()),
                                                                ),

                                                                const SizedBox(height: 85,),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                },
                                              ),

                                              const SizedBox(height: 20,),

                                              ((){
                                                if(profile.data!.blmMemorial.memorialDetails.memorialDetailsDescription != ''){
                                                  return Container(
                                                    child: Text(profile.data!.blmMemorial.memorialDetails.memorialDetailsDescription, textAlign: TextAlign.center, style: const TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xff000000),),),
                                                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                                                    alignment: Alignment.center,
                                                  );
                                                }else{
                                                  return const SizedBox(height: 0,);
                                                }
                                              }()),
                                            ],
                                          ),

                                          const SizedBox(height: 20,),

                                          Row(
                                            children: [
                                              const Expanded(child: SizedBox(),),

                                              Expanded(
                                                flex: 2,
                                                child: Padding(
                                                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                                                  child: MaterialButton(
                                                    child: const Text('Manage', style: TextStyle(fontSize: 24, fontFamily: 'NexaBold', color: Color(0xffFFFFFF),),),
                                                    minWidth: SizeConfig.screenWidth! / 2,
                                                    color: const Color(0xff2F353D),
                                                    shape: const StadiumBorder(),
                                                    padding: EdgeInsets.zero,
                                                    height: 45,
                                                    onPressed: () async{
                                                      if(widget.managed == true){
                                                        context.loaderOverlay.show();
                                                        APIBLMShowSwitchStatus result = await apiBLMShowSwitchStatus(memorialId: widget.memorialId);
                                                        context.loaderOverlay.hide();

                                                        if(result.switchStatusSuccess){
                                                          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMMemorialSettings(memorialId: widget.memorialId, memorialName: profile.data!.blmMemorial.memorialName, switchFamily: result.switchStatusFamily, switchFriends: result.switchStatusFriends, switchFollowers: result.switchStatusFollowers,)));
                                                        }
                                                      }else{
                                                        Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMMemorialSettingsWithHidden(memorialId: widget.memorialId, relationship: widget.relationship,)));
                                                      }
                                                    },
                                                  ),
                                                ),
                                              ),

                                              Expanded(
                                                child: GestureDetector(
                                                  child: const CircleAvatar(radius: 25, backgroundColor: Color(0xff3498DB), child: Icon(Icons.share, color: Color(0xffffffff), size: 25,),),
                                                  onTap: () async{
                                                    initBranchShare();
                                                    FlutterBranchSdk.setIdentity('blm-share-link');

                                                    BranchResponse response = await FlutterBranchSdk.showShareSheet(
                                                      buo: buo!,
                                                      linkProperties: lp!,
                                                      messageText: 'FacesbyPlaces App',
                                                      androidMessageTitle: 'FacesbyPlaces - Create a memorial page for loved ones by sharing stories, special events and photos of special occasions. Keeping their memories alive for generations',
                                                      androidSharingTitle: 'FacesbyPlaces - Create a memorial page for loved ones by sharing stories, special events and photos of special occasions. Keeping their memories alive for generations',
                                                    );

                                                    if(response.success){
                                                    }else{
                                                      FlutterBranchSdk.logout();
                                                      throw Exception('Error : ${response.errorCode} - ${response.errorMessage}');
                                                    }
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),

                                          const SizedBox(height: 20),

                                          Padding(
                                            padding: const EdgeInsets.only(left: 20),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    const Icon(Icons.place, color: Color(0xff000000), size: 25,),

                                                    const SizedBox(width: 20,),

                                                    Text(profile.data!.blmMemorial.memorialDetails.memorialDetailsCountry, style: const TextStyle(fontSize: 18, fontFamily: 'NexaRegular', color: Color(0xff000000),),),
                                                  ],
                                                ),

                                                const SizedBox(height: 20),

                                                Row(
                                                  children: [
                                                    const Icon(Icons.star, color: Color(0xff000000), size: 25,),

                                                    const SizedBox(width: 20,),

                                                    Text(profile.data!.blmMemorial.memorialDetails.memorialDetailsDob, style: const TextStyle(fontSize: 18, fontFamily: 'NexaRegular', color: Color(0xff000000),),),
                                                  ],
                                                ),

                                                const SizedBox(height: 20),

                                                Row(
                                                  children: [
                                                    Image.asset('assets/icons/grave_logo.png', height: 25,),

                                                    const SizedBox(width: 20,),

                                                    Text(profile.data!.blmMemorial.memorialDetails.memorialDetailsRip, style: const TextStyle(fontSize: 18, fontFamily: 'NexaRegular', color: Color(0xff000000),),),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),

                                          const SizedBox(height: 20),

                                          SizedBox(
                                            height: 50.0,
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: GestureDetector(
                                                    child: Column(
                                                      children: [
                                                        Text('${profile.data!.blmMemorial.memorialPostsCount}', style: const TextStyle(fontSize: 20, fontFamily: 'NexaBold', color: Color(0xff000000),),),

                                                        const Text('Post', style: TextStyle(fontSize: 16, fontFamily: 'NexaRegular', color: Color(0xff677375),),),
                                                      ],
                                                    ),
                                                    onTap: (){
                                                      Scrollable.ensureVisible(dataKey.currentContext!);
                                                    },
                                                  ),
                                                ),

                                                Container(width: 5, color: const Color(0xffeeeeee),),

                                                Expanded(
                                                  child: GestureDetector(
                                                    child: Column(
                                                      children: [
                                                        Text('${profile.data!.blmMemorial.memorialFamilyCount}', style: const TextStyle(fontSize: 20, fontFamily: 'NexaBold', color: Color(0xff000000),),),

                                                        const Text('Family', style: TextStyle(fontSize: 16, fontFamily: 'NexaRegular', color: Color(0xff677375),),),
                                                      ],
                                                    ),
                                                    onTap: (){
                                                      Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMConnectionList(memorialId: widget.memorialId, newToggle: 0)));
                                                    },
                                                  ),
                                                ),

                                                Container(width: 5, color: const Color(0xffeeeeee),),

                                                Expanded(
                                                  child: GestureDetector(
                                                    child: Column(
                                                      children: [
                                                        Text('${profile.data!.blmMemorial.memorialFriendsCount}', style: const TextStyle(fontSize: 20, fontFamily: 'NexaBold', color: Color(0xff000000),),),

                                                        const Text('Friends', style: TextStyle(fontSize: 16, fontFamily: 'NexaRegular', color: Color(0xff677375),),),
                                                      ],
                                                    ),
                                                    onTap: (){
                                                      Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMConnectionList(memorialId: widget.memorialId, newToggle: 1)));
                                                    },
                                                  ),
                                                ),

                                                Container(width: 5, color: const Color(0xffeeeeee),),

                                                Expanded(
                                                  child: GestureDetector(
                                                    child: Column(
                                                      children: [
                                                        Text('${profile.data!.blmMemorial.memorialFollowersCount}', style: const TextStyle(fontSize: 20, fontFamily: 'NexaBold', color: Color(0xff000000),),),

                                                        const Text('Joined', style: TextStyle(fontSize: 16, fontFamily:'NexaRegular', color: Color(0xff677375),),),
                                                      ],
                                                    ),
                                                    onTap: (){
                                                      Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMConnectionList(memorialId: widget.memorialId, newToggle: 2)));
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          Container(height: 5, color: const Color(0xffffffff),),

                                          Container(height: 5, color: const Color(0xffeeeeee),),

                                          Column(
                                            children: [
                                              const SizedBox(height: 20,),

                                              Container(
                                                child: const Text('Post', style: TextStyle(fontSize: 24, fontFamily: 'NexaBold', color: Color(0xff000000),),),
                                                padding: const EdgeInsets.only(left: 20.0),
                                                alignment: Alignment.centerLeft,
                                              ),

                                              const SizedBox(height: 20,),

                                              profile.data!.blmMemorial.memorialImagesOrVideos.isNotEmpty
                                              ? Column(
                                                children: [
                                                  Container(
                                                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                                                    width: SizeConfig.screenWidth,
                                                    height: 100,
                                                    child: ListView.separated(
                                                      physics: const ClampingScrollPhysics(),
                                                      scrollDirection: Axis.horizontal,
                                                      separatorBuilder: (context, index){
                                                        return const SizedBox(width: 20);
                                                      },
                                                      itemCount: profile.data!.blmMemorial.memorialImagesOrVideos.length,
                                                      itemBuilder: (context, index){
                                                        return GestureDetector(
                                                          onTap: (){
                                                            showGeneralDialog(
                                                              context: context,
                                                              barrierLabel: 'Dialog',
                                                              barrierDismissible: true,
                                                              transitionDuration: const Duration(milliseconds: 0),
                                                              pageBuilder: (_, __, ___) {
                                                                return Scaffold(
                                                                  backgroundColor: Colors.black12.withOpacity(0.7),
                                                                  body: SizedBox.expand(
                                                                    child: SafeArea(
                                                                      child: Column(
                                                                        children: [
                                                                          Container(
                                                                            padding: const EdgeInsets.only(right: 20.0),
                                                                            alignment: Alignment.centerRight,
                                                                            child: GestureDetector(
                                                                              child: CircleAvatar(radius: 20, backgroundColor: const Color(0xff000000).withOpacity(0.8), child: const Icon(Icons.close_rounded, color: Color(0xffffffff),),),
                                                                              onTap: (){
                                                                                Navigator.pop(context);
                                                                              },
                                                                            ),
                                                                          ),

                                                                          const SizedBox(height: 10,),

                                                                          Expanded(
                                                                            child: CarouselSlider(
                                                                              carouselController: buttonCarouselController,
                                                                              items: List.generate(profile.data!.blmMemorial.memorialImagesOrVideos.length, (next) => ((){
                                                                                if(lookupMimeType(profile.data!.blmMemorial.memorialImagesOrVideos[next])?.contains('video') == true){
                                                                                  return BetterPlayer.network('${profile.data!.blmMemorial.memorialImagesOrVideos[index]}',
                                                                                    betterPlayerConfiguration: BetterPlayerConfiguration(
                                                                                      placeholder: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 16 / 9),
                                                                                      deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
                                                                                      autoDispose: false,
                                                                                      aspectRatio: 16 / 9,
                                                                                      fit: BoxFit.contain,
                                                                                    ),
                                                                                  );
                                                                                }else{
                                                                                  return CachedNetworkImage(
                                                                                    errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 1.0,),
                                                                                    placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                                                    imageUrl: profile.data!.blmMemorial.memorialImagesOrVideos[next],
                                                                                    fit: BoxFit.contain,
                                                                                  );
                                                                                }
                                                                              }()),),
                                                                              options: CarouselOptions(
                                                                                enlargeCenterPage: true,
                                                                                viewportFraction: 1,
                                                                                initialPage: index,
                                                                                autoPlay: false,
                                                                                aspectRatio: 1,
                                                                              ),
                                                                            ),
                                                                          ),

                                                                          Row(
                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                            children: [
                                                                              IconButton(
                                                                                onPressed: () => buttonCarouselController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.linear),
                                                                                icon: const Icon(Icons.arrow_back_rounded, color: Color(0xffffffff),),
                                                                              ),

                                                                              IconButton(
                                                                                onPressed: () => buttonCarouselController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.linear),
                                                                                icon: const Icon(Icons.arrow_forward_rounded, color: Color(0xffffffff),),
                                                                              ),
                                                                            ],
                                                                          ),

                                                                          const SizedBox(height: 85,),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            );
                                                          },
                                                          child: ((){
                                                            if(lookupMimeType(profile.data!.blmMemorial.memorialImagesOrVideos[index])?.contains('video') == true){
                                                              return SizedBox(
                                                                width: 100,
                                                                height: 100,
                                                                child: BetterPlayer.network('${profile.data!.blmMemorial.memorialImagesOrVideos[index]}',
                                                                  betterPlayerConfiguration: BetterPlayerConfiguration(
                                                                    placeholder: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 16 / 9),
                                                                    controlsConfiguration: const BetterPlayerControlsConfiguration(showControls: false,),
                                                                    aspectRatio: 1,
                                                                    fit: BoxFit.contain,
                                                                  ),
                                                                ),
                                                              );
                                                            }else{
                                                              return SizedBox(
                                                                height: 100,
                                                                width: 100,
                                                                child: CachedNetworkImage(
                                                                  errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                                  placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                                  imageUrl: profile.data!.blmMemorial.memorialImagesOrVideos[index],
                                                                  fit: BoxFit.cover,
                                                                ),
                                                              );
                                                            }
                                                          }()),
                                                        );
                                                      },
                                                    ),
                                                  ),

                                                  const SizedBox(height: 20),
                                                ],
                                              )
                                              : const SizedBox(height: 0,),
                                            ],
                                          ),

                                          Container(height: 5, color: const Color(0xffeeeeee),),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),

                                SafeArea(
                                  child: SizedBox(
                                    height: Size.fromHeight(AppBar().preferredSize.height).height + (Size.fromHeight(AppBar().preferredSize.height).height / 2),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 20.0),
                                            child: GestureDetector(
                                              onTap: (){
                                                if(widget.newlyCreated == true){
                                                  Route newRoute = MaterialPageRoute(builder: (context) => const HomeBLMScreenExtended(newToggleBottom: 1,),);
                                                  Navigator.pushAndRemoveUntil(context, newRoute, (route) => false);
                                                }else{
                                                  Navigator.pop(context);
                                                }
                                              },
                                              child: Row(
                                                children: const [
                                                  Icon(Icons.arrow_back, color: Color(0xffffffff), size: 35,),

                                                  Text('Back', style: TextStyle(fontSize: 32, color: Color(0xffFFFFFF), fontFamily: 'NexaRegular'),),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Align(
                                            alignment: Alignment.centerRight,
                                            child: widget.managed == true
                                            ? MaterialButton(
                                              child: const Text('Create Post', style: TextStyle(fontSize: 32, color: Color(0xffFFFFFF), fontFamily: 'NexaRegular'),),
                                              onPressed: () async{
                                                Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMCreatePost(name: profile.data!.blmMemorial.memorialName, memorialId: profile.data!.blmMemorial.memorialId)));
                                              },
                                            )
                                            : const SizedBox(height: 0,),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                Positioned(
                                  top: SizeConfig.screenHeight! / 5,
                                  child: SizedBox(
                                    width: SizeConfig.screenWidth,
                                    height: 160,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: (){
                                            showGeneralDialog(
                                              context: context,
                                              barrierLabel: 'Dialog',
                                              barrierDismissible: true,
                                              transitionDuration: const Duration(milliseconds: 0),
                                              pageBuilder: (_, __, ___) {
                                                return Scaffold(
                                                  backgroundColor: Colors.black12.withOpacity(0.7),
                                                  body: SizedBox.expand(
                                                    child: SafeArea(
                                                      child: Column(
                                                        children: [
                                                          Container(
                                                            alignment: Alignment.centerRight,
                                                            padding: const EdgeInsets.only(right: 20.0),
                                                            child: GestureDetector(
                                                              child: CircleAvatar(radius: 20, backgroundColor: const Color(0xff000000).withOpacity(0.8), child: const Icon(Icons.close_rounded, color: Color(0xffffffff),),),
                                                              onTap: (){
                                                                Navigator.pop(context);
                                                              },
                                                            ),
                                                          ),

                                                          const SizedBox(height: 20,),

                                                          Expanded(
                                                            child: CachedNetworkImage(
                                                              errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 1.0,),
                                                              placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                              imageUrl: profile.data!.blmMemorial.memorialProfileImage,
                                                              fit: BoxFit.contain,
                                                            ),
                                                          ),

                                                          const SizedBox(height: 80,),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                          child: CircleAvatar( // PROFILE IMAGE - PROFILE PICTURE
                                            backgroundColor: const Color(0xff04ECFF),
                                            radius: 100,
                                            child: Padding(
                                              padding: const EdgeInsets.all(5),
                                              child: profile.data!.blmMemorial.memorialProfileImage != ''
                                              ? CircleAvatar(
                                                radius: 100,
                                                backgroundColor: const Color(0xff888888),
                                                foregroundImage: NetworkImage(profile.data!.blmMemorial.memorialProfileImage),
                                                backgroundImage: const AssetImage('assets/icons/app-icon.png'),
                                              )
                                              : const CircleAvatar(
                                                radius: 100,
                                                backgroundColor: Color(0xff888888),
                                                foregroundImage: AssetImage('assets/icons/app-icon.png'),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      }else if(profile.hasError){
                        return const MiscErrorMessageTemplate();
                      }else{
                        return SizedBox(height: SizeConfig.screenHeight);
                      }
                    },
                  ),
                ),

                SliverToBoxAdapter(
                  key: dataKey,
                  child: postCountListener != 0
                  ? Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Column(
                          children: List.generate(
                            posts.length, (i) => Padding(
                              padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                              child: MiscBLMPost(
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
                                contents: [
                                  Align(alignment: Alignment.centerLeft, child: Text(posts[i].postBody, style: const TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xff000000),), overflow: TextOverflow.ellipsis, maxLines: 5,),),

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
                                                errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                imageUrl: posts[i].imagesOrVideos[0],
                                                fit: BoxFit.cover,
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
                                                errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                imageUrl: posts[i].imagesOrVideos[index],
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
                                                    errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                    placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                    imageUrl: posts[i].imagesOrVideos[index],
                                                    fit: BoxFit.cover,
                                                  );
                                                }else{
                                                  return ((){
                                                    if(posts[i].imagesOrVideos.length - 3 > 0){
                                                      if(lookupMimeType(posts[i].imagesOrVideos[index])?.contains('video') == true){
                                                        return Stack(
                                                          fit: StackFit.expand,
                                                          children: [
                                                            BetterPlayer.network('${posts[i].imagesOrVideos[index]}',
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
                                                                child: Text('${posts[i].imagesOrVideos.length - 3}', style: const TextStyle(fontSize: 32, fontFamily: 'NexaBold', color: Color(0xffFFFFFF),),),
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
                                                              imageUrl: posts[i].imagesOrVideos[index],
                                                              fit: BoxFit.cover,
                                                            ),

                                                            Container(color: const Color(0xff000000).withOpacity(0.5),),

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
                                                          errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                          placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                          imageUrl: posts[i].imagesOrVideos[index],
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
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 60,),
                      ],
                    ),
                  )
                  : Column(
                    children: [
                      const SizedBox(height: 40,),

                      Center(child: Image.asset('assets/icons/app-icon.png', height: 250, width: 250,),),

                      const SizedBox(height: 45,),

                      const Center(child: Text('Post is empty', style: TextStyle(fontSize: 36, fontFamily: 'NexaBold', color: Color(0xffB1B1B1),),),),

                      const SizedBox(height: 40,),
                    ],
                  ),
                ),
              ],
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Visibility(
            visible: showFloatingButtonListener,
            child: FloatingActionButton(
              backgroundColor: const Color(0xff4EC9D4,),
              child: const Icon(Icons.arrow_upward_rounded, color: Color(0xffffffff),),
              onPressed: (){
                Scrollable.ensureVisible(profileKey.currentContext!);
              },
            ),
          ),
        ),
      ),
    );
  }
}