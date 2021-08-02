import 'package:facesbyplaces/API/Regular/03-View-Memorial/api-view-memorial-regular-02-show-profile-post.dart';
import 'package:facesbyplaces/API/Regular/03-View-Memorial/api-view-memorial-regular-01-show-memorial-details.dart';
import 'package:facesbyplaces/API/Regular/03-View-Memorial/api-view-memorial-regular-03-show-switch-status.dart';
import 'package:facesbyplaces/UI/Home/Regular/01-Main/home-main-regular-02-home-extended.dart';
import 'package:facesbyplaces/UI/Home/Regular/04-Create-Post/home-create-post-regular-01-create-post.dart';
import 'package:facesbyplaces/UI/Home/Regular/08-Settings-Memorial/home-settings-memorial-regular-01-memorial-settings.dart';
import 'package:facesbyplaces/UI/Home/Regular/08-Settings-Memorial/home-settings-memorial-regular-08-memorial-settings-with-hidden.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-04-regular-post.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-08-regular-message.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'home-view-memorial-regular-03-connection-list.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:better_player/better_player.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'dart:async';

class RegularProfilePosts{
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
  const RegularProfilePosts({required this.userId, required this.postId, required this.memorialId, required this.memorialName, required this.timeCreated, required this.postBody, required this.profileImage, required this.imagesOrVideos, required this.managed, required this.joined, required this.numberOfComments, required this.numberOfLikes, required this.likeStatus, required this.numberOfTagged, required this.taggedFirstName, required this.taggedLastName, required this.taggedImage, required this.taggedId, required this.pageType, required this.famOrFriends, required this.relationship, required this.location, required this.latitude, required this.longitude});
}

class HomeRegularProfile extends StatefulWidget{
  final int memorialId;
  final String relationship;
  final bool managed;
  final bool newlyCreated;
  HomeRegularProfile({required this.memorialId, required this.relationship, required this.managed, required this.newlyCreated});

  HomeRegularProfileState createState() => HomeRegularProfileState();
}

class HomeRegularProfileState extends State<HomeRegularProfile>{
  ValueNotifier<bool> showFloatingButton = ValueNotifier<bool>(false);
  CarouselController buttonCarouselController = CarouselController();
  GlobalKey profileKey = GlobalKey<HomeRegularProfileState>();
  TextEditingController controller = TextEditingController();
  GlobalKey dataKey = GlobalKey<HomeRegularProfileState>();
  ScrollController scrollController = ScrollController();
  ValueNotifier<int> postCount = ValueNotifier<int>(0);
  Future<APIRegularShowMemorialMain>? showProfile;
  List<RegularProfilePosts> posts = [];
  BranchUniversalObject? buo;
  BranchLinkProperties? lp;
  int itemRemaining = 1;
  bool empty = true;
  int page = 1;

  void initState(){
    super.initState();
    onLoading();
    showProfile = getProfileInformation(widget.memorialId);
    scrollController.addListener((){
      if(postCount.value != 0){
        if(scrollController.position.pixels == scrollController.position.maxScrollExtent){
          showFloatingButton.value = true;
        }else{
          showFloatingButton.value = false;
        }
      }
    });
  }

  Future<void> onRefresh() async{
    postCount.value = 0;
    itemRemaining = 1;
    posts = [];
    page = 1;
    onLoading();
  }

  void onLoading() async{
    if(itemRemaining != 0){
      context.loaderOverlay.show();
      var newValue = await apiRegularProfilePost(memorialId: widget.memorialId, page: page);
      itemRemaining = newValue.almItemsRemaining;
      postCount.value = newValue.almFamilyMemorialList.length;

      List<String> newList1 = [];
      List<String> newList2 = [];
      List<String> newList3 = [];
      List<int> newList4 = [];

      for(int i = 0; i < newValue.almFamilyMemorialList.length; i++){
        for(int j = 0; j < newValue.almFamilyMemorialList[i].homeProfilePostTagged.length; j++){
          newList1.add(newValue.almFamilyMemorialList[i].homeProfilePostTagged[j].homeProfilePostTaggedFirstName);
          newList2.add(newValue.almFamilyMemorialList[i].homeProfilePostTagged[j].homeProfilePostTaggedLastName);
          newList3.add(newValue.almFamilyMemorialList[i].homeProfilePostTagged[j].homeProfilePostTaggedImage);
          newList4.add(newValue.almFamilyMemorialList[i].homeProfilePostTagged[j].homeProfilePostTaggedId);
        }

        posts.add(
          RegularProfilePosts(
            userId: newValue.almFamilyMemorialList[i].homeProfilePostPage.homeProfilePostPagePageCreator.homeProfilePostPageCreatorId,
            postId: newValue.almFamilyMemorialList[i].homeProfilePostId,
            memorialId: newValue.almFamilyMemorialList[i].homeProfilePostPage.homeProfilePostPageId,
            timeCreated: newValue.almFamilyMemorialList[i].homeProfilePostCreatedAt,
            memorialName: newValue.almFamilyMemorialList[i].homeProfilePostPage.homeProfilePostPageName,
            postBody: newValue.almFamilyMemorialList[i].homeProfilePostBody,
            profileImage: newValue.almFamilyMemorialList[i].homeProfilePostPage.homeProfilePostPageProfileImage,
            imagesOrVideos: newValue.almFamilyMemorialList[i].homeProfilePostImagesOrVideos,
            managed: newValue.almFamilyMemorialList[i].homeProfilePostPage.homeProfilePostPageManage,
            joined: newValue.almFamilyMemorialList[i].homeProfilePostPage.homeProfilePostPageFollower,
            numberOfComments: newValue.almFamilyMemorialList[i].homeProfilePostNumberOfComments,
            numberOfLikes: newValue.almFamilyMemorialList[i].homeProfilePostNumberOfLikes,
            likeStatus: newValue.almFamilyMemorialList[i].homeProfilePostLikeStatus,
            numberOfTagged: newValue.almFamilyMemorialList[i].homeProfilePostTagged.length,
            taggedFirstName: newList1,
            taggedLastName: newList2,
            taggedImage: newList3,
            taggedId: newList4,
            pageType: newValue.almFamilyMemorialList[i].homeProfilePostPage.homeProfilePostPagePageType,
            famOrFriends: newValue.almFamilyMemorialList[i].homeProfilePostPage.homeProfilePostPageFamOrFriends,
            relationship: newValue.almFamilyMemorialList[i].homeProfilePostPage.homeProfilePostPageRelationship,
            location: newValue.almFamilyMemorialList[i].homeProfilePostLocation,
            latitude: newValue.almFamilyMemorialList[i].homeProfilePostLatitude,
            longitude: newValue.almFamilyMemorialList[i].homeProfilePostLongitude,
          ),
        );
      }

      if(mounted)
      page++;
      context.loaderOverlay.hide();
    }
  }

  Future<APIRegularShowMemorialMain> getProfileInformation(int memorialId) async{
    return await apiRegularShowMemorial(memorialId: memorialId);
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
      ..addCustomMetadata('link-type-of-account', 'Memorial'),
    );

    lp = BranchLinkProperties(feature: 'sharing', stage: 'new share', tags: ['one', 'two', 'three']);
    lp!.addControlParam('url', 'https://4n5z1.test-app.link/qtdaGGTx3cb?bnc_validate=true');
  }

  @override
  Widget build(BuildContext context){
    SizeConfig.init(context);
    print('Regular profile screen rebuild!');
    return ValueListenableBuilder(
      valueListenable: showFloatingButton,
      builder: (_, bool showFloatingButtonListener, __) => ValueListenableBuilder(
        valueListenable: postCount,
        builder: (_, int postCountListener, __) => Scaffold(
          body: SafeArea(
            bottom: false,
            child: RefreshIndicator(
              onRefresh: onRefresh,
              child: CustomScrollView(
                physics: const ClampingScrollPhysics(),
                controller: scrollController,
                slivers: <Widget>[
                  SliverToBoxAdapter(
                    child: FutureBuilder<APIRegularShowMemorialMain>(
                      future: showProfile,
                      builder: (context, profile){
                        if(profile.hasData){
                          return Column(
                            key: profileKey,
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    height: SizeConfig.screenHeight! / 3,
                                    width: SizeConfig.screenWidth,
                                    child: CachedNetworkImage(
                                      errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                      placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                      imageUrl: profile.data!.almMemorial.showMemorialBackgroundImage,
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
                                            transitionDuration: const Duration(milliseconds: 0),
                                            barrierDismissible: true,
                                            barrierLabel: 'Dialog',
                                            pageBuilder: (_, __, ___){
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
                                                            child: CircleAvatar(radius: 20, backgroundColor: const Color(0xff000000).withOpacity(0.8), child: const Icon(Icons.close_rounded, color: const Color(0xffffffff),),),
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
                                                            imageUrl: profile.data!.almMemorial.showMemorialBackgroundImage,
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
                                        decoration: const BoxDecoration(borderRadius: const BorderRadius.only(topLeft: const Radius.circular(20), topRight: const Radius.circular(20),), color: const Color(0xffffffff),),
                                        child: Column(
                                          children: [
                                            const SizedBox(height: 150,),

                                            Center(
                                              child: Text(profile.data!.almMemorial.showMemorialName,
                                                style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.64, fontFamily: 'NexaBold', color: const Color(0xff000000),),
                                                textAlign: TextAlign.center,
                                                overflow: TextOverflow.clip,
                                                maxLines: 5,
                                              ),
                                            ),

                                            const SizedBox(height: 20,),

                                            TextButton.icon(
                                              label: Text('${profile.data!.almMemorial.showMemorialFollowersCount}', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.11, fontFamily: 'NexaBold', color: const Color(0xff2F353D),),),
                                              icon: const CircleAvatar(radius: 15, backgroundColor: const Color(0xffE67E22), child: const Icon(Icons.card_giftcard, color: const Color(0xffffffff), size: 18,),),
                                              onPressed: (){
                                                Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularConnectionList(memorialId: widget.memorialId, newToggle: 2)));
                                              },
                                            ),

                                            const SizedBox(height: 20,),

                                            Column(
                                              children: [
                                                GestureDetector(
                                                  child: ((){
                                                    if(profile.data!.almMemorial.showMemorialImagesOrVideos.isNotEmpty){
                                                      if(lookupMimeType(profile.data!.almMemorial.showMemorialImagesOrVideos[0])?.contains('video') == true){
                                                        return BetterPlayer.network('${profile.data!.almMemorial.showMemorialImagesOrVideos[0]}',
                                                          betterPlayerConfiguration: BetterPlayerConfiguration(
                                                            placeholder: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 16 / 9),
                                                            controlsConfiguration: const BetterPlayerControlsConfiguration(showControls: false,),
                                                            aspectRatio: 16 / 9,
                                                            fit: BoxFit.contain,
                                                          ),
                                                        );
                                                      }else{
                                                        return Container(height: 0,);
                                                      }
                                                    }else{
                                                      return Container(height: 0,);
                                                    }
                                                  }()),
                                                  onTap: (){
                                                    showGeneralDialog(
                                                      context: context,
                                                      transitionDuration: const Duration(milliseconds: 0),
                                                      barrierDismissible: true,
                                                      barrierLabel: 'Dialog',
                                                      pageBuilder: (_, __, ___){
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
                                                                      child: CircleAvatar(radius: 20, backgroundColor: const Color(0xff000000).withOpacity(0.8), child: const Icon(Icons.close_rounded, color: const Color(0xffffffff),),),
                                                                      onTap: (){
                                                                        Navigator.pop(context);
                                                                      },
                                                                    ),
                                                                  ),

                                                                  const SizedBox(height: 10,),
                                                                  
                                                                  Expanded(
                                                                    child: ((){
                                                                      if(lookupMimeType(profile.data!.almMemorial.showMemorialImagesOrVideos[0])?.contains('video') == true){
                                                                        return BetterPlayer.network('${profile.data!.almMemorial.showMemorialImagesOrVideos[0]}',
                                                                          betterPlayerConfiguration: BetterPlayerConfiguration(
                                                                            placeholder: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 16 / 9),
                                                                            deviceOrientationsAfterFullScreen: [
                                                                              DeviceOrientation.portraitUp
                                                                            ],
                                                                            aspectRatio: 16 / 9,
                                                                            fit: BoxFit.contain,
                                                                          ),
                                                                        );
                                                                      }else{
                                                                        return CachedNetworkImage(
                                                                          errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 1.0,),
                                                                          placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                                          imageUrl: profile.data!.almMemorial.showMemorialImagesOrVideos[0],
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
                                                  if(profile.data!.almMemorial.showMemorialDetails.showMemorialDetailsDescription != ''){
                                                    return Container(
                                                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                                                      alignment: Alignment.center,
                                                      child: Text(profile.data!.almMemorial.showMemorialDetails.showMemorialDetailsDescription,
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.11, fontFamily: 'NexaRegular', color: const Color(0xff000000),),
                                                      ),
                                                    );
                                                  }else{
                                                    return Container(height: 0,);
                                                  }
                                                }()),
                                              ],
                                            ),

                                            const SizedBox(height: 20,),

                                            Container(
                                              child: Row(
                                                children: [
                                                  Expanded(child: Container(),),

                                                  Expanded(
                                                    flex: 2,
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                                                      child: MaterialButton(
                                                        child: Text('Manage', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.64, fontFamily: 'NexaBold', color: const Color(0xffFFFFFF),),),
                                                        minWidth: SizeConfig.screenWidth! / 2,
                                                        color: const Color(0xff2F353D),
                                                        shape: const StadiumBorder(),
                                                        padding: EdgeInsets.zero,
                                                        height: 45,
                                                        onPressed: () async{
                                                          if(widget.managed == true){
                                                            context.loaderOverlay.show();
                                                            APIRegularShowSwitchStatus
                                                            result = await apiRegularShowSwitchStatus(memorialId: widget.memorialId);
                                                            context.loaderOverlay.hide();

                                                            if(result.showSwitchStatusSuccess){
                                                              Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularMemorialSettings(memorialId: widget.memorialId, memorialName: profile.data!.almMemorial.showMemorialName, switchFamily: result.showSwitchStatusFamily, switchFriends: result.showSwitchStatusFriends, switchFollowers: result.showSwitchStatusFollowers,),),);
                                                            }
                                                          }else{
                                                            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularMemorialSettingsWithHidden(memorialId: widget.memorialId, relationship: widget.relationship,),),);
                                                          }
                                                        },
                                                      ),
                                                    ),
                                                  ),

                                                  Expanded(
                                                    child: GestureDetector(
                                                      child: const CircleAvatar(radius: 25, backgroundColor: const Color(0xff3498DB), child: const Icon(Icons.share, color: const Color(0xffffffff), size: 25,),),
                                                      onTap: () async{
                                                        initBranchShare();
                                                        FlutterBranchSdk.setIdentity('alm-share-link');

                                                        BranchResponse response = await FlutterBranchSdk.showShareSheet(
                                                          buo: buo!,
                                                          linkProperties: lp!,
                                                          messageText: 'FacesbyPlaces App',
                                                          androidMessageTitle: 'FacesbyPlaces - Create a memorial page for loved ones by sharing stories, special events and photos of special occasions. Keeping their memories alive for generations',
                                                          androidSharingTitle: 'FacesbyPlaces - Create a memorial page for loved ones by sharing stories, special events and photos of special occasions. Keeping their memories alive for generations',
                                                        );

                                                        if(response.success){
                                                          print('Link generated: ${response.result}');
                                                        }else{
                                                          FlutterBranchSdk.logout();
                                                          print('Error : ${response.errorCode} - ${response.errorMessage}');
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            const SizedBox(height: 20,),

                                            Padding(
                                              padding: const EdgeInsets.only(left: 20),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      const Icon(Icons.place, color: const Color(0xff000000), size: 25,),

                                                      const SizedBox(width: 20,),

                                                      Text(
                                                        profile.data!.almMemorial.showMemorialDetails.showMemorialDetailsCountry,
                                                        style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 1.76, fontFamily: 'NexaRegular', color: const Color(0xff000000),),
                                                      ),
                                                    ],
                                                  ),

                                                  const SizedBox(height: 20,),

                                                  Row(
                                                    children: [
                                                      const Icon(Icons.star, color: const Color(0xff000000), size: 25,),

                                                      const SizedBox(width: 20,),

                                                      Text(profile.data!.almMemorial.showMemorialDetails.showMemorialDetailsDob, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 1.76, fontFamily: 'NexaRegular', color: const Color(0xff000000),),),
                                                    ],
                                                  ),

                                                  const SizedBox(height: 20,),

                                                  Row(
                                                    children: [
                                                      Image.asset('assets/icons/grave_logo.png', height: 25,),

                                                      const SizedBox(width: 20,),

                                                      Text(profile.data!.almMemorial.showMemorialDetails.showMemorialDetailsRip, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 1.76, fontFamily: 'NexaRegular', color: const Color(0xff000000),),),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),

                                            const SizedBox(height: 20),

                                            Container(
                                              height: 50.0,
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: GestureDetector(
                                                      child: Column(
                                                        children: [
                                                          Text('${profile.data!.almMemorial.showMemorialPostsCount}', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.64, fontFamily: 'NexaBold', color: const Color(0xff000000),),),

                                                          Text('Post', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 1.76, fontFamily:'NexaRegular', color: const Color(0xff677375),),),
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
                                                          Text('${profile.data!.almMemorial.showMemorialFamilyCount}', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.64, fontFamily: 'NexaBold', color: const Color(0xff000000),),),

                                                          Text('Family', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 1.76, fontFamily: 'NexaRegular', color: const Color(0xff677375),),),
                                                        ],
                                                      ),
                                                      onTap: (){
                                                        Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularConnectionList(memorialId: widget.memorialId, newToggle: 0,),),);
                                                      },
                                                    ),
                                                  ),

                                                  Container(width: 5, color: const Color(0xffeeeeee),),

                                                  Expanded(
                                                    child: GestureDetector(
                                                      child: Column(
                                                        children: [
                                                          Text('${profile.data!.almMemorial.showMemorialFriendsCount}', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.64, fontFamily: 'NexaBold', color: const Color(0xff000000),),),

                                                          Text('Friends', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 1.76, fontFamily: 'NexaRegular', color: const Color(0xff677375),),),
                                                        ],
                                                      ),
                                                      onTap: (){
                                                        Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularConnectionList(memorialId: widget.memorialId, newToggle: 1,),),);
                                                      },
                                                    ),
                                                  ),

                                                  Container(width: 5, color: const Color(0xffeeeeee),),

                                                  Expanded(
                                                    child: GestureDetector(
                                                      child: Column(
                                                        children: [
                                                          Text('${profile.data!.almMemorial.showMemorialFollowersCount}', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.64, fontFamily: 'NexaBold', color: const Color(0xff000000),),),

                                                          Text('Joined', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 1.76, fontFamily:'NexaRegular', color: const Color(0xff677375),),),
                                                        ],
                                                      ),
                                                      onTap: (){
                                                        Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularConnectionList(memorialId: widget.memorialId, newToggle: 2)));
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
                                                const SizedBox(height: 20),

                                                Container(
                                                  padding: const EdgeInsets.only(left: 20.0),
                                                  alignment: Alignment.centerLeft,
                                                  child: Text('Post', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.64, fontFamily: 'NexaBold', color: const Color(0xff000000),),),
                                                ),

                                                const SizedBox(height: 20),

                                                profile.data!.almMemorial.showMemorialImagesOrVideos.isNotEmpty
                                                ? Column(
                                                  children: [
                                                    Container(
                                                      width: SizeConfig.screenWidth,
                                                      height: 100,
                                                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                                                      child: ListView.separated(
                                                        itemCount: profile.data!.almMemorial.showMemorialImagesOrVideos.length,
                                                        physics: const ClampingScrollPhysics(),
                                                        separatorBuilder: (context, index){
                                                          return const SizedBox(width: 20);
                                                        },
                                                        scrollDirection: Axis.horizontal,
                                                        itemBuilder: (context, index){
                                                          return GestureDetector(
                                                            child: ((){
                                                              if(lookupMimeType(profile.data!.almMemorial.showMemorialImagesOrVideos[index])?.contains('video') == true){
                                                                return Container(
                                                                  width: 100,
                                                                  height: 100,
                                                                  child: BetterPlayer.network('${profile.data!.almMemorial.showMemorialImagesOrVideos[index]}',
                                                                    betterPlayerConfiguration: BetterPlayerConfiguration(
                                                                      placeholder: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 16 / 9),
                                                                      controlsConfiguration: const BetterPlayerControlsConfiguration(showControls: false,),
                                                                      aspectRatio: 16 / 9,
                                                                      fit: BoxFit.contain,
                                                                    ),
                                                                  ),
                                                                );
                                                              }else{
                                                                return Container(
                                                                  width: 100,
                                                                  height: 100,
                                                                  child: CachedNetworkImage(
                                                                    errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                                    placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                                    imageUrl: profile.data!.almMemorial.showMemorialImagesOrVideos[index],
                                                                    fit: BoxFit.cover,
                                                                  ),
                                                                );
                                                              }
                                                            }()),
                                                            onTap: (){
                                                              showGeneralDialog(
                                                                context: context,
                                                                transitionDuration: const Duration(milliseconds: 0),
                                                                barrierDismissible: true,
                                                                barrierLabel: 'Dialog',
                                                                pageBuilder: (_, __, ___){
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
                                                                                child: CircleAvatar(radius: 20, backgroundColor: const Color(0xff000000).withOpacity(0.8), child: const Icon(Icons.close_rounded, color: const Color(0xffffffff),),),
                                                                                onTap: (){
                                                                                  Navigator.pop(context);
                                                                                },
                                                                              ),
                                                                            ),

                                                                            const SizedBox(height: 10,),

                                                                            Expanded(
                                                                              child: CarouselSlider(
                                                                                carouselController: buttonCarouselController,
                                                                                items: List.generate(
                                                                                  profile.data!.almMemorial.showMemorialImagesOrVideos.length, (next) => 
                                                                                  ((){
                                                                                    if(lookupMimeType(profile.data!.almMemorial.showMemorialImagesOrVideos[next])?.contains('video') == true){
                                                                                      return BetterPlayer.network('${profile.data!.almMemorial.showMemorialImagesOrVideos[index]}',
                                                                                        betterPlayerConfiguration: BetterPlayerConfiguration(
                                                                                          placeholder: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 16 / 9),
                                                                                          deviceOrientationsAfterFullScreen: [
                                                                                            DeviceOrientation.portraitUp
                                                                                          ],
                                                                                          aspectRatio: 16 / 9,
                                                                                          fit: BoxFit.contain,
                                                                                          autoDispose: false,
                                                                                        ),
                                                                                      );
                                                                                    }else{
                                                                                      return CachedNetworkImage(
                                                                                        errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 1.0,),
                                                                                        placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                                                        imageUrl: profile.data!.almMemorial.showMemorialImagesOrVideos[next],
                                                                                        fit: BoxFit.contain,
                                                                                      );
                                                                                    }
                                                                                  }()),
                                                                                ),
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
                                                                                  icon: const Icon(Icons.arrow_back_rounded, color: const Color(0xffffffff), size: 25,),
                                                                                ),
                                                                                IconButton(
                                                                                  onPressed: () => buttonCarouselController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.linear),
                                                                                  icon: const Icon(Icons.arrow_forward_rounded, color: const Color(0xffffffff), size: 25,),
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
                                                          );
                                                        },
                                                      ),
                                                    ),

                                                    const SizedBox(height: 20),
                                                  ],
                                                )
                                                : Container(height: 0,),
                                              ],
                                            ),

                                            Container(height: 5, color: const Color(0xffeeeeee),),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SafeArea(
                                    child: Container(
                                      height: Size.fromHeight(AppBar().preferredSize.height).height + (Size.fromHeight(AppBar().preferredSize.height).height / 2),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding:
                                              const EdgeInsets.only(left: 20.0),
                                              child: GestureDetector(
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.arrow_back, color: const Color(0xffffffff), size: SizeConfig.blockSizeVertical! * 3.65,),

                                                    Text('Back', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 3.16, color: Color(0xffFFFFFF), fontFamily: 'NexaRegular'),),
                                                  ],
                                                ),
                                                onTap: (){
                                                  if(widget.newlyCreated == true){
                                                    Route newRoute = MaterialPageRoute(builder: (context) => HomeRegularScreenExtended(newToggleBottom: 1,),);
                                                    Navigator.pushAndRemoveUntil(context, newRoute, (route) => false);
                                                  }else{
                                                    Navigator.pop(context);
                                                  }
                                                },
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              padding: const EdgeInsets.only(right: 20.0),
                                              alignment: Alignment.centerRight,
                                              child: widget.managed == true
                                              ? GestureDetector(
                                                child: Text('Create Post', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 3.16, color: Color(0xffFFFFFF), fontFamily: 'NexaRegular'),),
                                                onTap: () async{
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularCreatePost(name: profile.data!.almMemorial.showMemorialName, memorialId: profile.data!.almMemorial.showMemorialId)));
                                                },
                                              )
                                              : Container(height: 0,),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: SizeConfig.screenHeight! / 5,
                                    child: Container(
                                      width: SizeConfig.screenWidth,
                                      height: 160,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                            child: CircleAvatar( // PROFILE IMAGE - PROFILE PICTURE
                                              radius: 100,
                                              backgroundColor: const Color(0xff000000),
                                              child: Padding(
                                                padding: const EdgeInsets.all(5),
                                                child: profile.data!.almMemorial.showMemorialProfileImage != ''
                                                ? CircleAvatar(
                                                  radius: 100,
                                                  backgroundColor: const Color(0xff888888),
                                                  foregroundImage: NetworkImage(profile.data!.almMemorial.showMemorialProfileImage),
                                                  backgroundImage: const AssetImage('assets/icons/app-icon.png'),)
                                                : const CircleAvatar(
                                                  radius: 100,
                                                  backgroundColor: const Color(0xff888888),
                                                  foregroundImage: const AssetImage('assets/icons/app-icon.png'),
                                                ),
                                              ),
                                            ),
                                            onTap: (){
                                              showGeneralDialog(
                                                context: context,
                                                transitionDuration: const Duration(milliseconds: 0),
                                                barrierDismissible: true,
                                                barrierLabel: 'Dialog',
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
                                                                child: CircleAvatar(radius: 20, backgroundColor: const Color(0xff000000).withOpacity(0.8), child: const Icon(Icons.close_rounded, color: const Color(0xffffffff),),),
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
                                                                imageUrl: profile.data!.almMemorial.showMemorialProfileImage,
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
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        }else if(profile.hasError){
                          return MiscRegularErrorMessageTemplate();
                        }else{
                          return Container(height: SizeConfig.screenHeight);
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
                                child: MiscRegularPost(
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
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text(posts[i].postBody,
                                        style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.11, fontFamily: 'NexaRegular', color: const Color(0xff000000),),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 5,
                                      ),
                                    ),

                                    posts[i].imagesOrVideos.isNotEmpty
                                    ? Column(
                                      children: [
                                        const SizedBox(height: 20),

                                        Container(
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
                                                staggeredTileBuilder: (int index) =>const StaggeredTile.count(2, 2),
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
                                                itemBuilder: (BuildContext context, int index) =>
                                                ((){
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
                                                                  child: Text('${posts[i].imagesOrVideos.length - 3}', style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: const Color(0xffffffff),),),
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
                                                                  child: Text('${posts[i].imagesOrVideos.length - 3}', style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: const Color(0xffffffff),),),
                                                                  backgroundColor: const Color(0xffffffff).withOpacity(.5),
                                                                  radius: 25,
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                        }
                                                      }else{
                                                        if (lookupMimeType(posts[i].imagesOrVideos[index])?.contains('video') == true){
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
                                    : Container(height: 0),
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

                        Center(child: Text('Post is empty', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 3.52, fontFamily: 'NexaBold', color: const Color(0xffB1B1B1),),),),

                        const SizedBox(height: 40,),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Visibility(
            visible: showFloatingButtonListener,
            child: FloatingActionButton(
              backgroundColor: const Color(0xff4EC9D4,),
              child: const Icon(Icons.arrow_upward_rounded, color: const Color(0xffffffff),),
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