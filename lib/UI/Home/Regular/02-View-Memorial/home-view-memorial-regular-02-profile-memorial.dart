import 'package:facesbyplaces/API/Regular/02-Main/api-main-regular-04-02-02-follow-page.dart';
import 'package:facesbyplaces/API/Regular/03-View-Memorial/api-view-memorial-regular-02-show-profile-post.dart';
import 'package:facesbyplaces/API/Regular/03-View-Memorial/api-view-memorial-regular-01-show-memorial-details.dart';
import 'package:facesbyplaces/UI/Home/Regular/05-Donate/home-donate-regular-01-donate.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-04-regular-post.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-08-regular-message.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-11-regular-dropdown.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'home-view-memorial-regular-03-connection-list.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:better_player/better_player.dart';
import 'package:timeago/timeago.dart' as timeago;
// ignore: import_of_legacy_library_into_null_safe
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'dart:ui';

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

  const RegularProfilePosts({required this.userId, required this.postId, required this.memorialId, required this.memorialName, required this.timeCreated, required this.postBody, required this.profileImage, required this.imagesOrVideos, required this.managed, required this.joined, required this.numberOfComments, required this.numberOfLikes, required this.likeStatus, required this.numberOfTagged, required this.taggedFirstName, required this.taggedLastName, required this.taggedImage, required this.taggedId, required this.pageType, required this.famOrFriends, required this.relationship});
}

class HomeRegularMemorialProfile extends StatefulWidget{
  final int memorialId;
  final String pageType;
  final bool newJoin;
  HomeRegularMemorialProfile({required this.memorialId, required this.pageType, required this.newJoin});

  HomeRegularMemorialProfileState createState() => HomeRegularMemorialProfileState();
}

class HomeRegularMemorialProfileState extends State<HomeRegularMemorialProfile>{
  GlobalKey profileKey = GlobalKey<HomeRegularMemorialProfileState>();
  ValueNotifier<bool> showFloatingButton = ValueNotifier<bool>(false);
  CarouselController buttonCarouselController = CarouselController();
  GlobalKey dataKey = GlobalKey<HomeRegularMemorialProfileState>();
  ValueNotifier<bool> isGuestLoggedIn = ValueNotifier<bool>(false);
  TextEditingController controller = TextEditingController();
  ScrollController scrollController = ScrollController();
  ValueNotifier<bool> join = ValueNotifier<bool>(false);
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
    showProfile = getProfileInformation(widget.memorialId);
    isGuest();
    join.value = widget.newJoin;
    onLoading();
    scrollController.addListener(() {
      if(postCount.value != 0){
        if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
          showFloatingButton.value = true;
        }else{
          showFloatingButton.value = false;
        }
      }
    });
  }

  void isGuest() async{
    final sharedPrefs = await SharedPreferences.getInstance();
    isGuestLoggedIn.value = sharedPrefs.getBool('user-guest-session') ?? true;
  }

  Future<void> onRefresh() async{
    onLoading();
  }

  void onLoading() async{
    if(itemRemaining != 0){
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
          ),
        );
      }

      if(mounted)
        page++;
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
          ..addCustomMetadata('link-type-of-account', widget.pageType)
    );

    lp = BranchLinkProperties(
        feature: 'sharing',
        stage: 'new share',
        tags: ['one', 'two', 'three']
    );
    lp!.addControlParam('url', 'https://4n5z1.test-app.link/qtdaGGTx3cb?bnc_validate=true');
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    print('Regular profile screen rebuild!');
    return ValueListenableBuilder(
      valueListenable: showFloatingButton,
      builder: (_, bool showFloatingButtonListener, __) => ValueListenableBuilder(
        valueListenable: isGuestLoggedIn,
        builder: (_, bool isGuestLoggedInListener, __) => ValueListenableBuilder(
          valueListenable: postCount,
          builder: (_, int postCountListener, __) => ValueListenableBuilder(
            valueListenable: join,
            builder: (_, bool joinListener, __) => Scaffold(
              // backgroundColor: const Color(0xffffffff),
              body: SafeArea(
                bottom: false,
                child: Stack(
                  children: [
                    IgnorePointer(
                      ignoring: isGuestLoggedInListener,
                      child: FutureBuilder<APIRegularShowMemorialMain>(
                          future: showProfile,
                          builder: (context, profile){
                            if(profile.hasData){
                              return RefreshIndicator(
                                onRefresh: onRefresh,
                                child: CustomScrollView(
                                  physics: const ClampingScrollPhysics(),
                                  controller: scrollController,
                                  slivers: <Widget>[
                                    SliverToBoxAdapter(
                                      child: Column(
                                        key: profileKey,
                                        children: [
                                          Stack(
                                            children: [

                                              Container(
                                                height: SizeConfig.screenHeight! / 3,
                                                width: SizeConfig.screenWidth,
                                                child: ((){
                                                  if(profile.data!.almMemorial.showMemorialBackgroundImage == ''){
                                                    return Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,);
                                                  }else{
                                                    return CachedNetworkImage(
                                                      fit: BoxFit.cover,
                                                      imageUrl: profile.data!.almMemorial.showMemorialBackgroundImage,
                                                      placeholder: (context, url) => const Center(child: const CircularProgressIndicator(),),
                                                      errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                    );
                                                  }
                                                }()),
                                              ),

                                              Column(
                                                children: [
                                                  GestureDetector( // BACKGROUND IMAGE FOR ZOOMING IN
                                                    onTap: (){
                                                      showGeneralDialog(
                                                        context: context,
                                                        barrierDismissible: true,
                                                        barrierLabel: 'Dialog',
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
                                                                        onTap: (){
                                                                          Navigator.pop(context);
                                                                        },
                                                                        child: CircleAvatar(
                                                                          radius: 20,
                                                                          backgroundColor: const Color(0xff000000).withOpacity(0.8),
                                                                          child: const Icon(Icons.close_rounded, color: const Color(0xffffffff),),
                                                                        ),
                                                                      ),
                                                                    ),

                                                                    const SizedBox(height: 20,),

                                                                    Expanded(
                                                                        child: CachedNetworkImage(
                                                                          fit: BoxFit.contain,
                                                                          imageUrl: profile.data!.almMemorial.showMemorialBackgroundImage,
                                                                          placeholder: (context, url) => const Center(child: const CircularProgressIndicator(),),
                                                                          errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 1.0,),
                                                                        )
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
                                                    child: Container(height: SizeConfig.screenHeight! / 3.5, color: Colors.transparent,),
                                                  ),

                                                  Container(
                                                    width: SizeConfig.screenWidth,
                                                    decoration: const BoxDecoration(
                                                      borderRadius: const BorderRadius.only(topLeft: const Radius.circular(20), topRight: const Radius.circular(20)),
                                                      color: const Color(0xffffffff),
                                                    ),
                                                    child: Column(
                                                      children: [

                                                        const SizedBox(height: 120,),

                                                        Center(
                                                          child: Text(
                                                            profile.data!.almMemorial.showMemorialName,
                                                            textAlign: TextAlign.center,
                                                            maxLines: 5,
                                                            overflow: TextOverflow.clip,
                                                            style: TextStyle(
                                                              fontSize: SizeConfig
                                                                  .blockSizeVertical! *
                                                                  2.64,
                                                              fontFamily: 'NexaBold',
                                                              color: const Color(0xff000000),
                                                            ),
                                                          ),
                                                        ),

                                                        const SizedBox(height: 20,),

                                                        TextButton.icon(
                                                          onPressed: (){
                                                            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularConnectionList(memorialId: widget.memorialId, newToggle: 2)));
                                                          },
                                                          icon: const CircleAvatar(radius: 15, backgroundColor: const Color(0xffE67E22), child: const Icon(Icons.card_giftcard, color: const Color(0xffffffff), size: 18,),),
                                                          label: Text('${profile.data!.almMemorial.showMemorialFollowersCount}',
                                                            style: TextStyle(
                                                              fontSize: SizeConfig
                                                                  .blockSizeVertical! *
                                                                  2.11,
                                                              fontFamily: 'NexaBold',
                                                              color: const Color(0xff2F353D),
                                                            ),
                                                          ),
                                                        ),

                                                        const SizedBox(height: 20,),

                                                        Column(
                                                          children: [
                                                            GestureDetector(
                                                              onTap: (){
                                                                showGeneralDialog(
                                                                  context: context,
                                                                  barrierDismissible: true,
                                                                  barrierLabel: 'Dialog',
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
                                                                                  onTap: (){
                                                                                    Navigator.pop(context);
                                                                                  },
                                                                                  child: CircleAvatar(
                                                                                    radius: 20,
                                                                                    backgroundColor: const Color(0xff000000).withOpacity(0.8),
                                                                                    child: const Icon(Icons.close_rounded, color: const Color(0xffffffff),),
                                                                                  ),
                                                                                ),
                                                                              ),

                                                                              const SizedBox(height: 10,),

                                                                              Expanded(
                                                                                child: ((){
                                                                                  if(lookupMimeType(profile.data!.almMemorial.showMemorialImagesOrVideos[0])?.contains('video') == true){
                                                                                    return BetterPlayer.network('${profile.data!.almMemorial.showMemorialImagesOrVideos[0]}',
                                                                                      betterPlayerConfiguration: const BetterPlayerConfiguration(
                                                                                        deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
                                                                                        aspectRatio: 16 / 9,
                                                                                        fit: BoxFit.contain,
                                                                                      ),
                                                                                    );
                                                                                  }else{
                                                                                    return CachedNetworkImage(
                                                                                      fit: BoxFit.contain,
                                                                                      imageUrl: profile.data!.almMemorial.showMemorialImagesOrVideos[0],
                                                                                      placeholder: (context, url) => const Center(child: const CircularProgressIndicator(),),
                                                                                      errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 1.0,),
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
                                                              child: ((){
                                                                if(profile.data!.almMemorial.showMemorialImagesOrVideos.isNotEmpty){
                                                                  if(lookupMimeType(profile.data!.almMemorial.showMemorialImagesOrVideos[0])?.contains('video') == true){
                                                                    return BetterPlayer.network('${profile.data!.almMemorial.showMemorialImagesOrVideos[0]}',
                                                                      betterPlayerConfiguration: const BetterPlayerConfiguration(
                                                                        aspectRatio: 16 / 9,
                                                                        fit: BoxFit.contain,
                                                                        controlsConfiguration: const BetterPlayerControlsConfiguration(
                                                                          showControls: false,
                                                                        ),
                                                                      ),
                                                                    );
                                                                  }else{
                                                                    return Container(height: 0,);
                                                                  }
                                                                }else{
                                                                  return Container(height: 0,);
                                                                }
                                                              }()),
                                                            ),

                                                            const SizedBox(height: 20,),

                                                            ((){
                                                              if(profile.data!.almMemorial.showMemorialDetails.showMemorialDetailsDescription != ''){
                                                                return Container(
                                                                  alignment: Alignment.center,
                                                                  padding: EdgeInsets.only(left: 20.0, right: 20.0),
                                                                  child: Text(profile.data!.almMemorial.showMemorialDetails.showMemorialDetailsDescription,
                                                                    textAlign: TextAlign.center,
                                                                    style: TextStyle(
                                                                      fontSize: SizeConfig
                                                                          .blockSizeVertical! *
                                                                          2.11,
                                                                      fontFamily: 'NexaRegular',
                                                                      color: const Color(0xff000000),
                                                                    ),
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
                                                              Expanded(
                                                                child: profile.data!.almMemorial.showMemorialDetails.showMemorialAcceptDonations == true
                                                                    ? GestureDetector(
                                                                  onTap: (){
                                                                    Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularUserDonate(pageType: widget.pageType, pageId: widget.memorialId, pageName: profile.data!.almMemorial.showMemorialName)));
                                                                  },
                                                                  child: const CircleAvatar(
                                                                    radius: 25,
                                                                    backgroundColor: const Color(0xffE67E22),
                                                                    child: const Icon(Icons.card_giftcard, color: const Color(0xffffffff), size: 25,),
                                                                  ),
                                                                )
                                                                    : Container(),
                                                              ),
                                                              Expanded(
                                                                flex: 2,
                                                                child: Padding(
                                                                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                                                                  child: MaterialButton(
                                                                    padding: EdgeInsets.zero,
                                                                    onPressed: () async{

                                                                      // setState(() {
                                                                      //   join = !join;
                                                                      // });
                                                                      join.value = !join.value;

                                                                      print('The value of join is $join');

                                                                      if(join.value == true){
                                                                        profile.data!.almMemorial.showMemorialFollowersCount++;
                                                                      }else{
                                                                        profile.data!.almMemorial.showMemorialFollowersCount--;
                                                                      }

                                                                      context.loaderOverlay.show();
                                                                      bool result = await apiRegularModifyFollowPage(pageType: widget.pageType, pageId: widget.memorialId, follow: join.value);
                                                                      context.loaderOverlay.hide();

                                                                      if(result){
                                                                        await showDialog(
                                                                            context: context,
                                                                            builder: (_) =>
                                                                                AssetGiffyDialog(
                                                                                  image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                                                                  title: Text('Success', textAlign: TextAlign.center,  style: TextStyle(
                                                                                      fontSize:
                                                                                      SizeConfig.blockSizeVertical! * 3.16,
                                                                                      fontFamily: 'NexaRegular'),),
                                                                                  entryAnimation: EntryAnimation.DEFAULT,
                                                                                  description: Text(join.value != true
                                                                                      ? 'Successfully unfollowed the page. You will no longer receive notifications from this page.'
                                                                                      : 'Successfully followed the page. You will receive notifications from this page.',
                                                                                    textAlign: TextAlign.center,
                                                                                    style: TextStyle(
                                                                                        fontSize:
                                                                                        SizeConfig.blockSizeVertical! * 2.87,
                                                                                        fontFamily: 'NexaRegular'),
                                                                                  ),
                                                                                  onlyOkButton: true,
                                                                                  onOkButtonPressed: () {
                                                                                    Navigator.pop(context, true);
                                                                                  },
                                                                                )
                                                                        );
                                                                      }else{
                                                                        await showDialog(
                                                                            context: context,
                                                                            builder: (_) =>
                                                                                AssetGiffyDialog(
                                                                                  image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                                                                  title: Text(
                                                                                    'Error',
                                                                                    textAlign: TextAlign.center,
                                                                                    style: TextStyle(
                                                                                        fontSize:
                                                                                        SizeConfig.blockSizeVertical! * 3.16,
                                                                                        fontFamily: 'NexaRegular'),
                                                                                  ),
                                                                                  entryAnimation: EntryAnimation.DEFAULT,
                                                                                  description: Text(
                                                                                    'Something went wrong. Please try again.',
                                                                                    textAlign: TextAlign.center,
                                                                                    style: TextStyle(
                                                                                        fontSize:
                                                                                        SizeConfig.blockSizeVertical! * 2.87,
                                                                                        fontFamily: 'NexaRegular'),
                                                                                  ),
                                                                                  onlyOkButton: true,
                                                                                  buttonOkColor: const Color(0xffff0000),
                                                                                  onOkButtonPressed: () {
                                                                                    Navigator.pop(context, true);
                                                                                  },
                                                                                )
                                                                        );
                                                                      }
                                                                    },
                                                                    child: Text(
                                                                      joinListener ? 'Unjoin' : 'Join',
                                                                      style: TextStyle(
                                                                        fontSize: SizeConfig
                                                                            .blockSizeVertical! *
                                                                            2.64,
                                                                        fontFamily: 'NexaBold',
                                                                        color: const Color(
                                                                            0xffFFFFFF),
                                                                      ),
                                                                    ),
                                                                    minWidth: SizeConfig.screenWidth! / 2,
                                                                    height: 45,
                                                                    shape: const StadiumBorder(),
                                                                    color: joinListener
                                                                        ? const Color(0xff888888)
                                                                        : const Color(0xff04ECFF),
                                                                  ),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child: GestureDetector(
                                                                  onTap: () async{
                                                                    initBranchShare();

                                                                    FlutterBranchSdk.setIdentity('alm-share-link');

                                                                    BranchResponse response = await FlutterBranchSdk.showShareSheet(
                                                                        buo: buo!,
                                                                        linkProperties: lp!,
                                                                        messageText: 'FacesbyPlaces App',
                                                                        androidMessageTitle: 'FacesbyPlaces - Create a memorial page for loved ones by sharing stories, special events and photos of special occasions. Keeping their memories alive for generations',
                                                                        androidSharingTitle: 'FacesbyPlaces - Create a memorial page for loved ones by sharing stories, special events and photos of special occasions. Keeping their memories alive for generations'
                                                                    );

                                                                    if (response.success) {
                                                                      print('Link generated: ${response.result}');
                                                                    } else {
                                                                      FlutterBranchSdk.logout();
                                                                      print('Error : ${response.errorCode} - ${response.errorMessage}');
                                                                    }
                                                                  },
                                                                  child: const CircleAvatar(
                                                                    radius: 25,
                                                                    backgroundColor: const Color(0xff3498DB),
                                                                    child: const Icon(Icons.share, color: const Color(0xffffffff), size: 25,),
                                                                  ),
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
                                                                  Image.asset('assets/icons/prayer_logo.png', height: 25,),
                                                                  const SizedBox(width: 20,),
                                                                  Text('Roman Catholic',
                                                                    style: TextStyle(
                                                                      fontSize: SizeConfig
                                                                          .blockSizeVertical! *
                                                                          1.76,
                                                                      fontFamily: 'NexaRegular',
                                                                      color: const Color(
                                                                          0xff000000),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),

                                                              const SizedBox(height: 20,),

                                                              Row(
                                                                children: [
                                                                  const Icon(Icons.place, color: const Color(0xff000000), size: 25,),
                                                                  const SizedBox(width: 20,),
                                                                  Text(profile.data!.almMemorial.showMemorialDetails.showMemorialDetailsBirthPlace,
                                                                    style: TextStyle(
                                                                      fontSize: SizeConfig
                                                                          .blockSizeVertical! *
                                                                          1.76,
                                                                      fontFamily: 'NexaRegular',
                                                                      color: const Color(
                                                                          0xff000000),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),

                                                              const SizedBox(height: 20,),

                                                              Row(
                                                                children: [
                                                                  const Icon(Icons.star, color: const Color(0xff000000), size: 25,),
                                                                  const SizedBox(width: 20,),
                                                                  Text(profile.data!.almMemorial.showMemorialDetails.showMemorialDetailsDob,
                                                                    style: TextStyle(
                                                                      fontSize: SizeConfig
                                                                          .blockSizeVertical! *
                                                                          1.76,
                                                                      fontFamily: 'NexaRegular',
                                                                      color: const Color(
                                                                          0xff000000),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),

                                                              const SizedBox(height: 20,),

                                                              Row(
                                                                children: [
                                                                  Image.asset('assets/icons/grave_logo.png', height: 25,),
                                                                  const SizedBox(width: 20,),
                                                                  Text(profile.data!.almMemorial.showMemorialDetails.showMemorialDetailsRip,
                                                                    style: TextStyle(
                                                                      fontSize: SizeConfig
                                                                          .blockSizeVertical! *
                                                                          1.76,
                                                                      fontFamily: 'NexaRegular',
                                                                      color: const Color(
                                                                          0xff000000),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),

                                                              const SizedBox(height: 20,),

                                                              Row(
                                                                children: [
                                                                  Image.asset('assets/icons/grave_logo.png', height: 25,),
                                                                  const SizedBox(width: 20,),
                                                                  GestureDetector(
                                                                    onTap: () async{
                                                                      // final launcher = const GoogleMapsLauncher();
                                                                      // await launcher.launch(
                                                                      //   geoPoint: GeoPoint(0.0, 0.0),
                                                                      // );
                                                                    },
                                                                    child: Text(profile.data!.almMemorial.showMemorialDetails.showMemorialDetailsCemetery,
                                                                      style: TextStyle(
                                                                        fontSize: SizeConfig
                                                                            .blockSizeVertical! *
                                                                            1.76,
                                                                        fontFamily: 'NexaRegular',
                                                                        color: const Color(
                                                                            0xff3498DB),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),

                                                        const SizedBox(height: 20,),

                                                        Container(
                                                          height: 50.0,
                                                          child: Row(
                                                            children: [
                                                              Expanded(
                                                                child: GestureDetector(
                                                                  onTap: (){
                                                                    Scrollable.ensureVisible(dataKey.currentContext!);
                                                                  },
                                                                  child: Column(
                                                                    children: [
                                                                      Text('${profile.data!.almMemorial.showMemorialPostsCount}',
                                                                        style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.64,
                                                                          fontFamily: 'NexaBold',
                                                                          color: const Color(0xff000000),
                                                                        ),
                                                                      ),

                                                                      Text('Post',
                                                                        style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 1.76,
                                                                          fontFamily:'NexaRegular',
                                                                          color: const Color(0xff677375),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),

                                                              Container(width: 5, color: const Color(0xffeeeeee),),

                                                              Expanded(
                                                                child: GestureDetector(
                                                                  onTap: (){
                                                                    Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularConnectionList(memorialId: widget.memorialId, newToggle: 0)));
                                                                  },
                                                                  child: Column(
                                                                    children: [
                                                                      Text('${profile.data!.almMemorial.showMemorialFamilyCount}',
                                                                        style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.64,
                                                                          fontFamily: 'NexaBold',
                                                                          color: const Color(0xff000000),
                                                                        ),
                                                                      ),

                                                                      Text('Family',
                                                                        style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 1.76,
                                                                          fontFamily:'NexaRegular',
                                                                          color: const Color(0xff677375),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),

                                                              Container(width: 5, color: const Color(0xffeeeeee),),

                                                              Expanded(
                                                                child: GestureDetector(
                                                                  onTap: (){
                                                                    Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularConnectionList(memorialId: widget.memorialId, newToggle: 1)));
                                                                  },
                                                                  child: Column(
                                                                    children: [
                                                                      Text('${profile.data!.almMemorial.showMemorialFriendsCount}',
                                                                        style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.64,
                                                                          fontFamily: 'NexaBold',
                                                                          color: const Color(0xff000000),
                                                                        ),
                                                                      ),

                                                                      Text('Friends',
                                                                        style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 1.76,
                                                                          fontFamily:'NexaRegular',
                                                                          color: const Color(0xff677375),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),

                                                              Container(width: 5, color: const Color(0xffeeeeee),),

                                                              Expanded(
                                                                child: GestureDetector(
                                                                  onTap: (){
                                                                    Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularConnectionList(memorialId: widget.memorialId, newToggle: 2)));
                                                                  },
                                                                  child: Column(
                                                                    children: [
                                                                      Text('${profile.data!.almMemorial.showMemorialFollowersCount}',
                                                                        style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.64,
                                                                          fontFamily: 'NexaBold',
                                                                          color: const Color(0xff000000),
                                                                        ),
                                                                      ),

                                                                      Text('Joined',
                                                                        style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 1.76,
                                                                          fontFamily:'NexaRegular',
                                                                          color: const Color(0xff677375),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
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
                                                              padding: const EdgeInsets.only(left: 20.0),
                                                              alignment: Alignment.centerLeft,
                                                              child: Text('Post',
                                                                style: TextStyle(
                                                                  fontSize: SizeConfig
                                                                      .blockSizeVertical! *
                                                                      2.64,
                                                                  fontFamily:
                                                                  'NexaBold',
                                                                  color: const Color(
                                                                      0xff000000),
                                                                ),
                                                              ),
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
                                                                    physics: const ClampingScrollPhysics(),
                                                                    scrollDirection: Axis.horizontal,
                                                                    separatorBuilder: (context, index){
                                                                      return const SizedBox(width: 20);
                                                                    },
                                                                    itemCount: profile.data!.almMemorial.showMemorialImagesOrVideos.length,
                                                                    itemBuilder: (context, index){
                                                                      return GestureDetector(
                                                                        onTap: (){
                                                                          showGeneralDialog(
                                                                            context: context,
                                                                            barrierDismissible: true,
                                                                            barrierLabel: 'Dialog',
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
                                                                                            onTap: (){
                                                                                              Navigator.pop(context);
                                                                                            },
                                                                                            child: CircleAvatar(
                                                                                              radius: 20,
                                                                                              backgroundColor: const Color(0xff000000).withOpacity(0.8),
                                                                                              child: const Icon(Icons.close_rounded, color: const Color(0xffffffff),),
                                                                                            ),
                                                                                          ),
                                                                                        ),

                                                                                        const SizedBox(height: 10,),

                                                                                        Expanded(
                                                                                          child: CarouselSlider(
                                                                                            carouselController: buttonCarouselController,
                                                                                            items: List.generate(profile.data!.almMemorial.showMemorialImagesOrVideos.length, (next) =>
                                                                                            ((){
                                                                                              if(lookupMimeType(profile.data!.almMemorial.showMemorialImagesOrVideos[next])?.contains('video') == true){
                                                                                                return BetterPlayer.network('${profile.data!.almMemorial.showMemorialImagesOrVideos[index]}',
                                                                                                  betterPlayerConfiguration: const BetterPlayerConfiguration(
                                                                                                    deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
                                                                                                    autoDispose: false,
                                                                                                    aspectRatio: 16 / 9,
                                                                                                    fit: BoxFit.contain,
                                                                                                  ),
                                                                                                );
                                                                                              }else{
                                                                                                return CachedNetworkImage(
                                                                                                  fit: BoxFit.contain,
                                                                                                  imageUrl: profile.data!.almMemorial.showMemorialImagesOrVideos[next],
                                                                                                  placeholder: (context, url) => const Center(child: const CircularProgressIndicator(),),
                                                                                                  errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 1.0,),
                                                                                                );
                                                                                              }
                                                                                            }()),
                                                                                            ),
                                                                                            options: CarouselOptions(
                                                                                              autoPlay: false,
                                                                                              enlargeCenterPage: true,
                                                                                              aspectRatio: 1,
                                                                                              viewportFraction: 1,
                                                                                              initialPage: index,
                                                                                            ),
                                                                                          ),
                                                                                        ),

                                                                                        Row(
                                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                                          children: [
                                                                                            IconButton(
                                                                                              onPressed: () => buttonCarouselController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.linear),
                                                                                              icon: const Icon(Icons.arrow_back_rounded, color: const Color(0xffffffff),),
                                                                                            ),

                                                                                            IconButton(
                                                                                              onPressed: () => buttonCarouselController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.linear),
                                                                                              icon: const Icon(Icons.arrow_forward_rounded, color: const Color(0xffffffff),),
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
                                                                          if(lookupMimeType(profile.data!.almMemorial.showMemorialImagesOrVideos[index])?.contains('video') == true){
                                                                            return Container(
                                                                              width: 100,
                                                                              height: 100,
                                                                              child: BetterPlayer.network('${profile.data!.almMemorial.showMemorialImagesOrVideos[index]}',
                                                                                betterPlayerConfiguration: const BetterPlayerConfiguration(
                                                                                  aspectRatio: 16 / 9,
                                                                                  fit: BoxFit.contain,
                                                                                  controlsConfiguration: const BetterPlayerControlsConfiguration(
                                                                                    showControls: false,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            );
                                                                          }else{
                                                                            return Container(
                                                                              width: 100,
                                                                              height: 100,
                                                                              child: CachedNetworkImage(
                                                                                fit: BoxFit.cover,
                                                                                imageUrl: profile.data!.almMemorial.showMemorialImagesOrVideos[index],
                                                                                placeholder: (context, url) => const Center(child: const CircularProgressIndicator(),),
                                                                                errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
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
                                                  child: GestureDetector(
                                                    onTap:(){
                                                      Navigator.pop(context);
                                                    },
                                                    child: Row(
                                                        children: [
                                                          Icon(
                                                            Icons.arrow_back,
                                                            color: const Color(0xffffffff),
                                                            size: SizeConfig.blockSizeVertical! * 3.65,
                                                          ),
                                                          Text(
                                                            'Back',
                                                            style: TextStyle(
                                                                fontSize: SizeConfig.blockSizeVertical! * 3.16,
                                                                color: Color(0xffFFFFFF),
                                                                fontFamily: 'NexaRegular'),
                                                          ),
                                                          Expanded(
                                                            child: Align(
                                                              alignment: Alignment.centerRight,
                                                              child: MiscRegularDropDownMemorialTemplate(memorialName: profile.data!.almMemorial.showMemorialName, memorialId: widget.memorialId, pageType: widget.pageType, reportType: 'Memorial',),
                                                            ),
                                                          ),
                                                        ]
                                                    )
                                                  ),
                                                ),
                                              ),

                                              Positioned(
                                                top: SizeConfig.screenHeight! / 5,
                                                child: Container(
                                                  height: 160,
                                                  width: SizeConfig.screenWidth,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      GestureDetector(
                                                        onTap: (){
                                                          showGeneralDialog(
                                                            context: context,
                                                            barrierDismissible: true,
                                                            barrierLabel: 'Dialog',
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
                                                                            onTap: (){
                                                                              Navigator.pop(context);
                                                                            },
                                                                            child: CircleAvatar(
                                                                              radius: 20,
                                                                              backgroundColor: const Color(0xff000000).withOpacity(0.8),
                                                                              child: const Icon(Icons.close_rounded, color: const Color(0xffffffff),),
                                                                            ),
                                                                          ),
                                                                        ),

                                                                        const SizedBox(height: 20,),

                                                                        Expanded(
                                                                            child: CachedNetworkImage(
                                                                              fit: BoxFit.contain,
                                                                              imageUrl: profile.data!.almMemorial.showMemorialProfileImage,
                                                                              placeholder: (context, url) => const Center(child: const CircularProgressIndicator(),),
                                                                              errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 1.0,),
                                                                            )
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
                                                        child: CircleAvatar(
                                                          radius: 100,
                                                          backgroundColor: const Color(0xff04ECFF),
                                                          child: Padding(
                                                              padding: const EdgeInsets.all(5),
                                                              child: profile.data!.almMemorial.showMemorialProfileImage != ''
                                                                  ? CircleAvatar(
                                                                radius: 100,
                                                                backgroundColor: const Color(0xff888888),
                                                                foregroundImage: NetworkImage(profile.data!.almMemorial.showMemorialProfileImage),
                                                                backgroundImage: const AssetImage('assets/icons/app-icon.png'),
                                                              )
                                                                  : const CircleAvatar(
                                                                radius: 100,
                                                                backgroundColor: const Color(0xff888888),
                                                                foregroundImage: const AssetImage('assets/icons/app-icon.png'),
                                                              )
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
                                                posts.length,
                                                    (i) => Padding(
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
                                                                    placeholder: (context, url) => const Center(child: const CircularProgressIndicator(),),
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
                                                                        placeholder: (context, url) => const Center(child: const CircularProgressIndicator(),),
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
                                                                                  placeholder: (context, url) => const Center(child: const CircularProgressIndicator(),),
                                                                                  errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                                                ),

                                                                                Container(color: const Color(0xff000000).withOpacity(0.5),),

                                                                                Center(
                                                                                  child: CircleAvatar(
                                                                                    radius: 25,
                                                                                    backgroundColor: const Color(0xffffffff).withOpacity(.5),
                                                                                    child: Text(
                                                                                      '${posts[i].imagesOrVideos.length - 3}',
                                                                                      style: TextStyle(
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

                                          Center(
                                            child: Text(
                                              'Post is empty',
                                              style: TextStyle(
                                                fontSize: SizeConfig.blockSizeVertical! * 3.52,
                                                fontFamily: 'NexaBold',
                                                color: const Color(0xffB1B1B1),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 40,),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }else if(profile.hasError){
                              return MiscRegularErrorMessageTemplate();
                            }else{
                              return Container(height: SizeConfig.screenHeight, child: Center(child: Container(child: const SpinKitThreeBounce(color: const Color(0xff000000), size: 50.0,), color: const Color(0xffffffff),),),);
                            }
                          }
                      ),
                    ),

                    isGuestLoggedInListener
                        ? BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                      child: const MiscRegularLoginToContinue(),
                    )
                        : Container(height: 0),
                  ],
                ),
              ),
              floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
              floatingActionButton: Visibility(
                visible: showFloatingButtonListener,
                child: FloatingActionButton(
                  backgroundColor: const Color(0xff4EC9D4,),
                  child: const Icon(
                    Icons.arrow_upward_rounded,
                    color: const Color(0xffffffff),
                  ),
                  onPressed: (){
                    Scrollable.ensureVisible(profileKey.currentContext!);
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}