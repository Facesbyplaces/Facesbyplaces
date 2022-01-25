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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'home_view_memorial_blm_03_connection_list.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:better_player/better_player.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/material.dart';
import 'package:dialog/dialog.dart';
import 'package:loader/loader.dart';
import 'package:mime/mime.dart';
import 'package:misc/misc.dart';
import 'dart:io';
import 'dart:ui';

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
  GlobalKey profileKey = GlobalKey<HomeBLMProfileState>();
  ValueNotifier<bool> showFloatingButton = ValueNotifier<bool>(false);
  CarouselController buttonCarouselController = CarouselController();
  GlobalKey dataKey = GlobalKey<HomeBLMProfileState>();
  ValueNotifier<bool> isGuestLoggedIn = ValueNotifier<bool>(false);
  TextEditingController controller = TextEditingController();
  ScrollController scrollController = ScrollController();
  ValueNotifier<bool> join = ValueNotifier<bool>(false);
  ValueNotifier<bool> filter = ValueNotifier<bool>(false);
  ValueNotifier<int> postCount = ValueNotifier<int>(0);
  Future<APIBLMShowMemorialMain>? showProfile;
  BranchUniversalObject? buo;
  BranchLinkProperties? lp;
  int itemRemaining = 1;
  bool empty = true;

  Future<List<APIBLMHomeProfilePostExtended>>? showListOfMemorialPosts;
  ValueNotifier<int> lengthOfMemorialPosts = ValueNotifier<int>(0);
  int page1 = 1;
  ValueNotifier<bool> loaded = ValueNotifier<bool>(false);
  bool updatedMemorialPostsData = false;

  String thumbnail = 'assets/icons/cover-icon.png';
  File thumbFile = File('');

  @override
  void initState(){
    super.initState();
    isGuest();
    scrollController.addListener((){ // SHOWS WHEN THE USER HAS REACHED THE BOTTOM OF THE LIST
      if(scrollController.position.pixels == scrollController.position.maxScrollExtent){
        if(loaded.value){
          page1 = 1; // RESET BACK TO ONE FOR PAGINATION OF THE API
          showListOfMemorialPosts = getListOfMemorialPosts(page: page1);

          if(updatedMemorialPostsData){
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

  void isGuest() async{
    final sharedPrefs = await SharedPreferences.getInstance();
    isGuestLoggedIn.value = sharedPrefs.getBool('user-guest-session') ?? true;

    showProfile = getProfileInformation(widget.memorialId);
    showListOfMemorialPosts = getListOfMemorialPosts(page: page1);
  }

  Future<void> onRefresh() async{
    page1 = 1;
    loaded.value = false;
    updatedMemorialPostsData = false;
    lengthOfMemorialPosts.value = 0;
    showListOfMemorialPosts = getListOfMemorialPosts(page: page1);
  }

  Future<List<APIBLMHomeProfilePostExtended>> getListOfMemorialPosts({required int page}) async{
    APIBLMHomeProfilePostMain? newValue;
    List<APIBLMHomeProfilePostExtended> listOfMemorialPosts = [];

    do{
      newValue = await apiBLMProfilePost(page: page, memorialId: widget.memorialId).onError((error, stackTrace){
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
      listOfMemorialPosts.addAll(newValue.blmFamilyMemorialList);

      if(newValue.blmItemsRemaining != 0){
        page++;
      }else if(lengthOfMemorialPosts.value > 0 && listOfMemorialPosts.length > lengthOfMemorialPosts.value){
        updatedMemorialPostsData = true;
      }
    }while(newValue.blmItemsRemaining != 0);

    lengthOfMemorialPosts.value = listOfMemorialPosts.length; // COMPARISON FOR NEXT PAGINATION & NUMBER OF POSTS
    page1 = page;
    loaded.value = true;
    
    return listOfMemorialPosts;
  }

  Future<APIBLMShowMemorialMain> getProfileInformation(int memorialId) async{
    context.loaderOverlay.show();
    APIBLMShowMemorialMain newValue = await apiBLMShowMemorial(memorialId: memorialId);
    context.loaderOverlay.hide();
    return newValue;
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
      ..addCustomMetadata('link-type-of-account', 'Memorial')
    );

    lp = BranchLinkProperties(feature: 'sharing', stage: 'new share', tags: ['one', 'two', 'three']);
    lp!.addControlParam('url', 'https://4n5z1.test-app.link/qtdaGGTx3cb?bnc_validate=true');
  }

  @override
  Widget build(BuildContext context){
    SizeConfig.init(context);
    return ValueListenableBuilder(
      valueListenable: showFloatingButton,
      builder: (_, bool showFloatingButtonListener, __) => ValueListenableBuilder(
        valueListenable: isGuestLoggedIn,
        builder: (_, bool isGuestLoggedInListener, __) => ValueListenableBuilder(
          valueListenable: postCount,
          builder: (_, int postCountListener, __) => ValueListenableBuilder(
            valueListenable: join,
            builder: (_, bool joinListener, __) => ValueListenableBuilder(
              valueListenable: lengthOfMemorialPosts,
              builder: (_, int lengthOfMemorialPostsListener, __) => ValueListenableBuilder(
                valueListenable: loaded,
                builder: (_, bool loadedListener, __) => ValueListenableBuilder(
                  valueListenable: filter,
                  builder: (_, bool filterListener, __) => Scaffold(
                    backgroundColor: const Color(0xffffffff),
                    body: Stack(
                      children: [
                        FutureBuilder<APIBLMShowMemorialMain>(
                          future: showProfile,
                          builder: (context, profile){
                            if(profile.hasData){
                              return RefreshIndicator(
                                onRefresh: onRefresh,
                                child: FutureBuilder<List<APIBLMHomeProfilePostExtended>>(
                                  future: showListOfMemorialPosts,
                                  builder: (context, posts){
                                    if(profile.connectionState == ConnectionState.done && posts.connectionState == ConnectionState.done){
                                      return CustomScrollView(
                                        physics: const ClampingScrollPhysics(),
                                        controller: scrollController,
                                        slivers: <Widget>[
                                          SliverToBoxAdapter(
                                            child: InkWell(
                                              onTap: (){
                                                if(isGuestLoggedInListener){
                                                  filter.value = true;
                                                }
                                              },
                                              child: IgnorePointer(
                                                ignoring: isGuestLoggedInListener,
                                                child: Column(
                                                  key: profileKey,
                                                  children: [
                                                    Stack(
                                                      children: [
                                                        SizedBox(
                                                          height: SizeConfig.screenHeight! / 3,
                                                          width: SizeConfig.screenWidth,
                                                          child: ((){
                                                            if(profile.data!.blmMemorial.memorialBackgroundImage == ''){
                                                              return Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,);
                                                            }else{
                                                              return CachedNetworkImage(
                                                                fit: BoxFit.cover,
                                                                imageUrl: profile.data!.blmMemorial.memorialBackgroundImage,
                                                                placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                                                errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                                              );
                                                            }
                                                          }()),
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
                                                                                  fit: BoxFit.contain,
                                                                                  imageUrl: profile.data!.blmMemorial.memorialBackgroundImage,
                                                                                  placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain,),
                                                                                  errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain),
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
                                                            ),

                                                            Container(
                                                              width: SizeConfig.screenWidth,
                                                              decoration: const BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)), color: Color(0xffffffff),),
                                                              child: Column(
                                                                children: [
                                                                  const SizedBox(height: 150,),

                                                                  Padding(
                                                                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                                                    child: Center(
                                                                      child: Text(profile.data!.blmMemorial.memorialName,
                                                                        style: const TextStyle(fontSize: 32, fontFamily: 'NexaBold', color: Color(0xff000000),),
                                                                        textAlign: TextAlign.center,
                                                                        overflow: TextOverflow.clip,
                                                                        maxLines: 10,
                                                                      ),
                                                                    ),
                                                                  ),

                                                                  const SizedBox(height: 20,),

                                                                  TextButton.icon(
                                                                    label: Text('${profile.data!.blmMemorial.memorialFollowersCount}', style: const TextStyle(fontSize: 20, fontFamily: 'NexaBold', color: Color(0xff2F353D),),),
                                                                    icon: CircleAvatar(radius: 20, backgroundColor: const Color(0xff000000), child: Image.asset('assets/icons/fist.png')),
                                                                    onPressed: (){
                                                                      Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMConnectionList(memorialId: widget.memorialId, newToggle: 2)));
                                                                    },
                                                                  ),

                                                                  const SizedBox(height: 20,),

                                                                  Column(
                                                                    children: [
                                                                      ((){
                                                                        if(profile.data!.blmMemorial.memorialImagesOrVideos.isNotEmpty){
                                                                          if(lookupMimeType(profile.data!.blmMemorial.memorialImagesOrVideos[0])?.contains('video') == true){
                                                                            return BetterPlayer.network('${profile.data!.blmMemorial.memorialImagesOrVideos[0]}',
                                                                              betterPlayerConfiguration: const BetterPlayerConfiguration(
                                                                                autoPlay: true,
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

                                                                      const SizedBox(height: 20,),

                                                                      ((){
                                                                        if(profile.data!.blmMemorial.memorialDetails.memorialDetailsDescription != ''){
                                                                          return Container(
                                                                            alignment: Alignment.center,
                                                                            padding: const EdgeInsets.symmetric(horizontal: 20.0,),
                                                                            child: Text(profile.data!.blmMemorial.memorialDetails.memorialDetailsDescription, textAlign: TextAlign.center, style: const TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xff000000),),),
                                                                          );
                                                                        }else{
                                                                          return const SizedBox(height: 0,);
                                                                        }
                                                                      }()),
                                                                    ],
                                                                  ),

                                                                  const SizedBox(height: 20,),

                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                    children: [
                                                                      Column(
                                                                        children: [
                                                                          const Text('Pins', style: TextStyle(fontSize: 20, fontFamily: 'NexaBold', color: Color(0xff000000),),),

                                                                          GestureDetector(
                                                                            child: const CircleAvatar(radius: 25, backgroundColor: Color(0xff3498DB), child: Icon(Icons.location_pin, color: Color(0xffffffff), size: 25,),),
                                                                            onTap: () async{
                                                                              await showDialog(
                                                                                context: context,
                                                                                builder: (context) => CustomDialog(
                                                                                  image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                                                                  title: 'Pins',
                                                                                  description: 'Pins functionality are still being created. ',
                                                                                  okButtonColor: const Color(0xff4caf50), // GREEN
                                                                                  includeOkButton: true,
                                                                                ),
                                                                              );
                                                                            },
                                                                          ),
                                                                        ],
                                                                      ),

                                                                      Column(
                                                                        children: [
                                                                          const Text('Manage', style: TextStyle(fontSize: 20, fontFamily: 'NexaBold', color: Color(0xff000000),),),

                                                                          GestureDetector(
                                                                            child: const CircleAvatar(radius: 25, backgroundColor: Color(0xff000000), child: Icon(Icons.manage_accounts, color: Color(0xffffffff), size: 25,),),
                                                                            onTap: () async{
                                                                              if(widget.managed == true){
                                                                                context.loaderOverlay.show();
                                                                                APIBLMShowSwitchStatus result = await apiBLMShowSwitchStatus(memorialId: widget.memorialId);
                                                                                context.loaderOverlay.hide();

                                                                                if(result.switchStatusSuccess){
                                                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMMemorialSettings(memorialId: widget.memorialId, memorialName: profile.data!.blmMemorial.memorialName, switchFamily: result.switchStatusFamily, switchFriends: result.switchStatusFriends, switchFollowers: result.switchStatusFollowers, newlyCreated: widget.newlyCreated),),);
                                                                                }
                                                                              }else{
                                                                                Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMMemorialSettingsWithHidden(memorialId: widget.memorialId, relationship: widget.relationship,),),);
                                                                              }
                                                                            },
                                                                          ),
                                                                        ],
                                                                      ),

                                                                      Column(
                                                                        children: [
                                                                          const Text('Share', style: TextStyle(fontSize: 20, fontFamily: 'NexaBold', color: Color(0xff000000),),),

                                                                          GestureDetector(
                                                                            child: const CircleAvatar(radius: 25, backgroundColor: Color(0xff3498DB), child: Icon(Icons.share, color: Color(0xffffffff), size: 25,),),
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

                                                                              if(response.success){
                                                                              }else{
                                                                                FlutterBranchSdk.logout();
                                                                                throw Exception('Error : ${response.errorCode} - ${response.errorMessage}');
                                                                              }
                                                                            },
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),

                                                                  const SizedBox(height: 20,),

                                                                  Padding(
                                                                    padding: const EdgeInsets.only(left: 20),
                                                                    child: Column(
                                                                      children: [
                                                                        Row(
                                                                          children: [
                                                                            const Icon(Icons.place, color: Color(0xff000000), size: 25,),

                                                                            const SizedBox(width: 20,),

                                                                            Flexible(child: Text(profile.data!.blmMemorial.memorialDetails.memorialDetailsCountry, style: const TextStyle(fontSize: 18, fontFamily: 'NexaRegular', color: Color(0xff000000),),),),
                                                                          ],
                                                                        ),

                                                                        const SizedBox(height: 20),

                                                                        Row(
                                                                          children: [
                                                                            Image.asset('assets/icons/grave_logo.png', height: 25,),

                                                                            const SizedBox(width: 20,),

                                                                            Flexible(child: Text(profile.data!.blmMemorial.memorialDetails.memorialDetailsRip, style: const TextStyle(fontSize: 18, fontFamily: 'NexaRegular', color: Color(0xff000000),),),),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),

                                                                  const SizedBox(height: 20,),

                                                                  SizedBox(
                                                                    height: 50.0,
                                                                    child: Row(
                                                                      children: [
                                                                        Expanded(
                                                                          child: GestureDetector(
                                                                            child: Column(
                                                                              children: [
                                                                                Text('${profile.data!.blmMemorial.memorialPostsCount}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xff000000),),),

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
                                                                                Text('${profile.data!.blmMemorial.memorialFamilyCount}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xff000000),),),

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
                                                                                Text('${profile.data!.blmMemorial.memorialFriendsCount}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xff000000),),),

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
                                                                                Text('${profile.data!.blmMemorial.memorialFollowersCount}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xff000000),),),

                                                                                const Text('Joined', style: TextStyle(fontSize: 16, fontFamily: 'NexaRegular', color: Color(0xff677375),),),
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
                                                                        padding: const EdgeInsets.only(left: 20.0),
                                                                        alignment: Alignment.centerLeft,
                                                                        child: const Text('Post', style: TextStyle(fontSize: 24, fontFamily: 'NexaBold', color: Color(0xff000000),),),
                                                                      ),

                                                                      const SizedBox(height: 20),

                                                                      profile.data!.blmMemorial.memorialImagesOrVideos.isNotEmpty
                                                                      ? Column(
                                                                        children: [
                                                                          Container(
                                                                            width: SizeConfig.screenWidth,
                                                                            height: 100,
                                                                            padding: const EdgeInsets.symmetric(horizontal: 20),
                                                                            child: ListView.separated(
                                                                              physics: const ClampingScrollPhysics(),
                                                                              scrollDirection: Axis.horizontal,
                                                                              separatorBuilder: (context, index){
                                                                                return const SizedBox(width: 20);
                                                                              },
                                                                              itemCount: profile.data!.blmMemorial.memorialImagesOrVideos.length,
                                                                              itemBuilder: (context, index){
                                                                                return GestureDetector(
                                                                                  child: ((){
                                                                                    if(lookupMimeType(profile.data!.blmMemorial.memorialImagesOrVideos[index])?.contains('video') == true){
                                                                                      return SizedBox(
                                                                                        width: 100,
                                                                                        height: 100,
                                                                                        child: BetterPlayer.network('${profile.data!.blmMemorial.memorialImagesOrVideos[index]}',
                                                                                          betterPlayerConfiguration: const BetterPlayerConfiguration(
                                                                                            overlay: Center(child: Icon(Icons.play_circle_fill, color: Color(0xffffffff))),
                                                                                            controlsConfiguration: BetterPlayerControlsConfiguration(showControls: false,),
                                                                                            aspectRatio: 16 / 9,
                                                                                            fit: BoxFit.contain,
                                                                                          ),
                                                                                        ),
                                                                                      );
                                                                                    }else{
                                                                                      return SizedBox(
                                                                                        width: 100,
                                                                                        height: 100,
                                                                                        child: CachedNetworkImage(
                                                                                          fit: BoxFit.cover,
                                                                                          imageUrl: profile.data!.blmMemorial.memorialImagesOrVideos[index],
                                                                                          placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                                                          errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
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

                                                                                                  const SizedBox(height: 10,),

                                                                                                  Expanded(
                                                                                                    child: CarouselSlider(
                                                                                                      carouselController: buttonCarouselController,
                                                                                                      items: List.generate(profile.data!.blmMemorial.memorialImagesOrVideos.length, (next) =>
                                                                                                        ((){
                                                                                                          if(lookupMimeType(profile.data!.blmMemorial.memorialImagesOrVideos[next])?.contains('video') == true){
                                                                                                            return BetterPlayer.network('${profile.data!.blmMemorial.memorialImagesOrVideos[index]}',
                                                                                                              betterPlayerConfiguration: const BetterPlayerConfiguration(
                                                                                                                aspectRatio: 16 / 9,
                                                                                                                fit: BoxFit.contain,
                                                                                                                autoDispose: false, // NEEDS TO BE FALSE SO THE VIDEO WOULD STILL PLAY CONTENT IN THE SLIDER IS CHANGED
                                                                                                              ),
                                                                                                            );
                                                                                                          }else{
                                                                                                            return CachedNetworkImage(
                                                                                                              fit: BoxFit.contain,
                                                                                                              imageUrl: profile.data!.blmMemorial.memorialImagesOrVideos[next],
                                                                                                              placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 1.0,),
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
                                                                const SizedBox(width: 10,),

                                                                MaterialButton(
                                                                  padding: const EdgeInsets.all(5),
                                                                  color: const Color(0xff04ECFF),
                                                                  onPressed: (){
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

                                                                Expanded(
                                                                  child: Align(
                                                                    alignment: Alignment.centerRight,
                                                                    child: widget.managed == true
                                                                    ? MaterialButton(
                                                                      padding: const EdgeInsets.all(5),
                                                                      color: const Color(0xff04ECFF),
                                                                      onPressed: (){
                                                                        Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMCreatePost(name: profile.data!.blmMemorial.memorialName, memorialId: profile.data!.blmMemorial.memorialId)));
                                                                      },
                                                                      child: const Text('Create Post', style: TextStyle(fontSize: 32, color: Color(0xffFFFFFF), fontFamily: 'NexaRegular'),),
                                                                    )
                                                                    : const SizedBox(height: 0,),
                                                                  ),
                                                                ),

                                                                const SizedBox(width: 10,),
                                                              ],
                                                            ),
                                                          ),
                                                        ),

                                                        Positioned(
                                                          top: SizeConfig.screenHeight! / 6,
                                                          child: SizedBox(
                                                            width: SizeConfig.screenWidth,
                                                            height: 250,
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: [
                                                                GestureDetector( // PROFILE PICTURE
                                                                  child: CircleAvatar(
                                                                    radius: 200,
                                                                    backgroundColor: const Color(0xff04ECFF),
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.all(5),
                                                                      child: profile.data!.blmMemorial.memorialProfileImage != ''
                                                                      ? CircleAvatar(
                                                                        radius: 200,
                                                                        backgroundColor: const Color(0xff888888),
                                                                        foregroundImage: NetworkImage(profile.data!.blmMemorial.memorialProfileImage),
                                                                        backgroundImage: const AssetImage('assets/icons/user-placeholder.png'),
                                                                      )
                                                                      : const CircleAvatar(
                                                                        radius: 200,
                                                                        backgroundColor: Color(0xff888888),
                                                                        foregroundImage: AssetImage('assets/icons/user-placeholder.png'),
                                                                      )
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
                                                                                      child: CircleAvatar(radius: 20, backgroundColor: const Color(0xff000000).withOpacity(0.8), child: const Icon(Icons.close_rounded, color: Color(0xffffffff),),),
                                                                                      onTap: (){
                                                                                        Navigator.pop(context);
                                                                                      },
                                                                                    ),
                                                                                  ),

                                                                                  const SizedBox(height: 20,),

                                                                                  Expanded(
                                                                                    child: CachedNetworkImage(
                                                                                      fit: BoxFit.contain,
                                                                                      imageUrl: profile.data!.blmMemorial.memorialProfileImage,
                                                                                      placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain,),
                                                                                      errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain,),
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
                                            ),
                                          ),

                                          SliverToBoxAdapter(
                                            key: dataKey,
                                            child: (()
                                              {
                                                if(loadedListener && lengthOfMemorialPostsListener == 0){
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
                                                  return Padding(
                                                    padding: const EdgeInsets.all(20.0),
                                                    child: Column(
                                                      children: [
                                                        Column(
                                                          children: List.generate(posts.data!.length, 
                                                            (i) => Padding(
                                                              padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                                                              child: MiscBLMPost(
                                                                key: ValueKey('$i'),
                                                                userId: posts.data![i].profilePostPage.profilePagePageCreator.profilePageCreatorId,
                                                                postId: posts.data![i].profilePostId,
                                                                memorialId: posts.data![i].profilePostPage.profilePageId,
                                                                memorialName: posts.data![i].profilePostPage.profilePageName,
                                                                timeCreated: timeago.format(DateTime.parse(posts.data![i].profilePostCreatedAt)),
                                                                managed: posts.data![i].profilePostPage.profilePageManage,
                                                                joined: posts.data![i].profilePostPage.profilePageFollower,
                                                                profileImage: posts.data![i].profilePostPage.profilePageProfileImage,
                                                                numberOfComments: posts.data![i].profilePostNumberOfComments,
                                                                numberOfLikes: posts.data![i].profilePostNumberOfLikes,
                                                                likeStatus: posts.data![i].profilePostLikeStatus,
                                                                numberOfTagged: posts.data![i].profilePostPostTagged.length,
                                                                taggedFirstName: ((){
                                                                  List<String> firstName = [];
                                                                  for(int j = 0; j < posts.data![i].profilePostPostTagged.length; j++){
                                                                    firstName.add(posts.data![i].profilePostPostTagged[j].profilePageTaggedFirstName);
                                                                  }
                                                                  return firstName;
                                                                }()),
                                                                taggedLastName: ((){
                                                                  List<String> lastName = [];
                                                                  for(int j = 0; j < posts.data![i].profilePostPostTagged.length; j++){
                                                                    lastName.add(posts.data![i].profilePostPostTagged[j].profilePageTaggedLastName);
                                                                  }
                                                                  return lastName;
                                                                }()),
                                                                taggedId: ((){
                                                                  List<int> id = [];
                                                                  for(int j = 0; j < posts.data![i].profilePostPostTagged.length; j++){
                                                                    id.add(posts.data![i].profilePostPostTagged[j].profilePageTaggedId);
                                                                  }
                                                                  return id;
                                                                }()),
                                                                pageType: posts.data![i].profilePostPage.profilePagePageType,
                                                                famOrFriends: posts.data![i].profilePostPage.profilePageFamOrFriends,
                                                                relationship: posts.data![i].profilePostPage.profilePageRelationship,
                                                                location: posts.data![i].homeProfilePostLocation,
                                                                latitude: posts.data![i].homeProfilePostLatitude,
                                                                longitude: posts.data![i].homeProfilePostLongitude,
                                                                isGuest: isGuestLoggedIn.value,
                                                                deletable: posts.data![i].profilePostDeletable,
                                                                contents: [
                                                                  Align(alignment: Alignment.centerLeft, child: Text(posts.data![i].profilePostBody, overflow: TextOverflow.ellipsis, maxLines: 5, style: const TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xff000000),),),),
                                                                      
                                                                  posts.data![i].profilePostImagesOrVideos.isNotEmpty
                                                                  ? Column(
                                                                    children: [
                                                                      const SizedBox(height: 20),
                                                                      
                                                                      SizedBox(
                                                                        child: ((){
                                                                          if(posts.data![i].profilePostImagesOrVideos.length == 1){
                                                                            if(lookupMimeType(posts.data![i].profilePostImagesOrVideos[0])?.contains('video') == true){
                                                                              return BetterPlayer.network('${posts.data![i].profilePostImagesOrVideos[0]}',
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
                                                                                imageUrl: posts.data![i].profilePostImagesOrVideos[0],
                                                                                placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                                                errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                                              );
                                                                            }
                                                                          }else if(posts.data![i].profilePostImagesOrVideos.length == 2){
                                                                            return StaggeredGridView.countBuilder(
                                                                              staggeredTileBuilder:(int index) => const StaggeredTile.count(2, 2),
                                                                              physics: const NeverScrollableScrollPhysics(),
                                                                              padding: EdgeInsets.zero,
                                                                              crossAxisSpacing: 4.0,
                                                                              mainAxisSpacing: 4.0,
                                                                              crossAxisCount: 4,
                                                                              shrinkWrap: true,
                                                                              itemCount: 2,
                                                                              itemBuilder: (BuildContext context, int index) => lookupMimeType(posts.data![i].profilePostImagesOrVideos[index])?.contains('video') == true
                                                                              ? BetterPlayer.network('${posts.data![i].profilePostImagesOrVideos[index]}',
                                                                                betterPlayerConfiguration: const BetterPlayerConfiguration(
                                                                                  overlay: Center(child: Icon(Icons.play_circle_fill, color: Color(0xffffffff))),
                                                                                  controlsConfiguration: BetterPlayerControlsConfiguration(showControls: false,),
                                                                                  aspectRatio: 16 / 9,
                                                                                  fit: BoxFit.contain,
                                                                                ),
                                                                              )
                                                                              : CachedNetworkImage(
                                                                                fit: BoxFit.cover, 
                                                                                imageUrl: posts.data![i].profilePostImagesOrVideos[index],
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
                                                                                  return lookupMimeType(posts.data![i].profilePostImagesOrVideos[index])?.contains('video') == true
                                                                                  ? BetterPlayer.network('${posts.data![i].profilePostImagesOrVideos[index]}',
                                                                                    betterPlayerConfiguration: const BetterPlayerConfiguration(
                                                                                      overlay: Center(child: Icon(Icons.play_circle_fill, color: Color(0xffffffff))),
                                                                                      controlsConfiguration: BetterPlayerControlsConfiguration(showControls: false,),
                                                                                      aspectRatio: 16 / 9,
                                                                                      fit: BoxFit.contain,
                                                                                    ),
                                                                                  )
                                                                                  : CachedNetworkImage(
                                                                                    fit: BoxFit.cover,
                                                                                    imageUrl: posts.data![i].profilePostImagesOrVideos[index],
                                                                                    placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                                                    errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                                                  );
                                                                                }else{
                                                                                  return ((){
                                                                                    if(posts.data![i].profilePostImagesOrVideos.length - 3 > 0){
                                                                                      if(lookupMimeType(posts.data![i].profilePostImagesOrVideos[index])?.contains('video') == true){
                                                                                        return Stack(
                                                                                          fit: StackFit.expand,
                                                                                          children: [
                                                                                            BetterPlayer.network('${posts.data![i].profilePostImagesOrVideos[index]}',
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
                                                                                                child: Text('${posts.data![i].profilePostImagesOrVideos.length - 3}', style: const TextStyle(fontSize: 32, fontFamily: 'NexaBold', color: Color(0xffFFFFFF),),),
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
                                                                                              imageUrl: posts.data![i].profilePostImagesOrVideos[index],
                                                                                              placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                                                              errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                                                            ),

                                                                                            Container(color: const Color(0xff000000).withOpacity(0.5),),
                                                                                            
                                                                                            Center(
                                                                                              child: CircleAvatar(
                                                                                                radius: 25,
                                                                                                backgroundColor: const Color(0xffffffff).withOpacity(.5),
                                                                                                child: Text('${posts.data![i].profilePostImagesOrVideos.length - 3}', style: const TextStyle(fontSize: 32, fontFamily: 'NexaBold', color: Color(0xffFFFFFF),),),
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        );
                                                                                      }
                                                                                    }else{
                                                                                      if(lookupMimeType(posts.data![i].profilePostImagesOrVideos[index])?.contains('video') == true) {
                                                                                        return BetterPlayer.network('${posts.data![i].profilePostImagesOrVideos[index]}',
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
                                                                                          imageUrl: posts.data![i].profilePostImagesOrVideos[index],
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
                                                              ),
                                                            ),
                                                          ),
                                                        ),

                                                        const SizedBox(height: 60,),
                                                      ],
                                                    ),
                                                  );
                                                }
                                              }
                                            ()),
                                          ),
                                        ],
                                      );
                                    }else if(profile.connectionState == ConnectionState.done && posts.connectionState == ConnectionState.none){
                                      return const Center(child: CustomLoaderThreeDots(),);
                                    }
                                    else if(profile.hasError && posts.hasError){
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
                              );
                            }else if(profile.hasError){
                              return const MiscErrorMessageTemplate();
                            }else{
                              return SizedBox(height: SizeConfig.screenHeight);
                            }
                          }
                        ),

                        filterListener
                        ? BackdropFilter(filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0), child: const MiscLoginToContinue(),)
                        : const SizedBox(height: 0),
                      ],
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
              ),
            ),
          ),
        ),
      ),
    );
  }
}