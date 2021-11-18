import 'package:facesbyplaces/API/BLM/08-Search/api_search_blm_01_search_posts.dart';
import 'package:facesbyplaces/API/BLM/08-Search/api_search_blm_04_search_blm.dart';
import 'package:facesbyplaces/API/BLM/08-Search/api_search_blm_03_search_nearby.dart';
import 'package:facesbyplaces/API/BLM/08-Search/api_search_blm_02_search_suggested.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc_01_blm_manage_memorial.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc_02_blm_post.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc_02_regular_post.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:better_player/better_player.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'package:misc/misc.dart';
import 'dart:ui';

class BLMSearchMainPosts{
  final int userId;
  final int postId;
  final int memorialId;
  final String memorialName;
  final String timeCreated;
  final String postBody;
  final dynamic profileImage;
  final List<dynamic> imagesOrVideos;
  final bool managed;
  final bool follower;
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
  const BLMSearchMainPosts({required this.userId, required this.postId, required this.memorialId, required this.memorialName, required this.timeCreated, required this.postBody, required this.profileImage, required this.imagesOrVideos, required this.managed, required this.follower, required this.numberOfLikes, required this.numberOfComments, required this.likeStatus, required this.numberOfTagged, required this.taggedFirstName, required this.taggedLastName, required this.taggedImage, required this.taggedId, required this.pageType, required this.famOrFriends, required this.relationship, required this.location, required this.latitude, required this.longitude});
}

class BLMSearchMainSuggested{
  final int memorialId;
  final String memorialName;
  final String memorialDescription;
  final String image;
  final bool managed;
  final bool follower;
  final String pageType;
  final bool famOrFriends;
  final String relationship;
  const BLMSearchMainSuggested({required this.memorialId, required this.memorialName, required this.memorialDescription, required this.image, required this.managed, required this.follower, required this.pageType, required this.famOrFriends, required this.relationship});
}

class BLMSearchMainNearby{
  final int memorialId;
  final String memorialName;
  final String memorialDescription;
  final String image;
  final bool managed;
  final bool follower;
  final String pageType;
  final bool famOrFriends;
  final String relationship;
  const BLMSearchMainNearby({required this.memorialId, required this.memorialName, required this.memorialDescription, required this.image, required this.managed, required this.follower, required this.pageType, required this.famOrFriends, required this.relationship});
}

class BLMSearchMainBLM{
  final int memorialId;
  final String memorialName;
  final String memorialDescription;
  final String image;
  final bool managed;
  final bool follower;
  final String pageType;
  final bool famOrFriends;
  final String relationship;
  const BLMSearchMainBLM({required this.memorialId, required this.memorialName, required this.memorialDescription, required this.image, required this.managed, required this.follower, required this.pageType, required this.famOrFriends, required this.relationship});
}

class HomeBLMPost extends StatefulWidget{
  final String keyword;
  final int newToggle;
  final double latitude;
  final double longitude;
  final String currentLocation;
  const HomeBLMPost({Key? key, required this.keyword, required this.newToggle, required this.latitude, required this.longitude, required this.currentLocation}) : super(key: key);

  @override
  HomeBLMPostState createState() => HomeBLMPostState();
}

class HomeBLMPostState extends State<HomeBLMPost>{
  ValueNotifier<int> toggle = ValueNotifier<int>(0);
  ValueNotifier<bool> isGuestLoggedIn = ValueNotifier<bool>(true);
  ValueNotifier<bool> onSearch = ValueNotifier<bool>(false);
  ValueNotifier<int> tabCount1 = ValueNotifier<int>(0);
  ValueNotifier<int> tabCount2 = ValueNotifier<int>(0);
  ValueNotifier<int> tabCount3 = ValueNotifier<int>(0);
  ValueNotifier<int> tabCount4 = ValueNotifier<int>(0);
  TextEditingController controller = TextEditingController();
  ScrollController scrollController1 = ScrollController();
  ScrollController scrollController2 = ScrollController();
  ScrollController scrollController3 = ScrollController();
  ScrollController scrollController4 = ScrollController();
  List<BLMSearchMainPosts> feeds = [];
  List<BLMSearchMainSuggested> suggested = [];
  List<BLMSearchMainNearby> nearby = [];
  List<BLMSearchMainBLM> blm = [];
  List<BLMSearchMainPosts> searchFeeds = [];
  List<BLMSearchMainSuggested> searchSuggested = [];
  List<BLMSearchMainNearby> searchNearby = [];
  List<BLMSearchMainBLM> searchBlm = [];
  int nearbyMemorialItemsRemaining = 1;
  int nearbyBlmItemsRemaining = 1;
  int suggestedItemRemaining = 1;
  int postItemRemaining = 1;
  int blmItemRemaining = 1;
  String searchKeyword = '';
  int page1 = 1;
  int page2 = 1;
  int page3 = 1;
  int page4 = 1;

  Future<void> onRefresh1() async{
    onLoading1();
  }

  Future<void> onRefresh2() async{
    onLoading2();
  }

  Future<void> onRefresh3() async{
    onLoading3();
  }

  Future<void> onRefresh4() async{
    onLoading4();
  }

  void onLoading1() async{
    if(postItemRemaining != 0){
      context.loaderOverlay.show();
      var newValue = await apiBLMSearchPosts(keywords: widget.keyword, page: page1);
      context.loaderOverlay.hide();

      postItemRemaining = newValue.blmItemsRemaining;
      tabCount1.value = tabCount1.value + newValue.blmSearchPostList.length;

      for(int i = 0; i < newValue.blmSearchPostList.length; i++){
        List<String> newList1 = [];
        List<String> newList2 = [];
        List<String> newList3 = [];
        List<int> newList4 = [];

        for(int j = 0; j < newValue.blmSearchPostList[i].searchPostPostTagged.length; j++){
          newList1.add(newValue.blmSearchPostList[i].searchPostPostTagged[j].searchPostTaggedFirstName);
          newList2.add(newValue.blmSearchPostList[i].searchPostPostTagged[j].searchPostTaggedLastName);
          newList3.add(newValue.blmSearchPostList[i].searchPostPostTagged[j].searchPostTaggedImage);
          newList4.add(newValue.blmSearchPostList[i].searchPostPostTagged[j].searchPostTaggedId);
        }
        
        feeds.add(
          BLMSearchMainPosts(
            userId: newValue.blmSearchPostList[i].searchPostPage.searchPostPagePageCreator.searchPostPageCreatorCreatorId, 
            postId: newValue.blmSearchPostList[i].searchPostPostId,
            memorialId: newValue.blmSearchPostList[i].searchPostPage.searchPostPagePageId,
            timeCreated: newValue.blmSearchPostList[i].searchPostCreatedAt,
            memorialName: newValue.blmSearchPostList[i].searchPostPage.searchPostPageName,
            postBody: newValue.blmSearchPostList[i].searchPostBody,
            profileImage: newValue.blmSearchPostList[i].searchPostPage.searchPostPageProfileImage,
            imagesOrVideos: newValue.blmSearchPostList[i].searchPostImagesOrVideos,
            managed: newValue.blmSearchPostList[i].searchPostPage.searchPostPageManage,
            follower: newValue.blmSearchPostList[i].searchPostPage.searchPostPageFollower,
            numberOfComments: newValue.blmSearchPostList[i].searchPostNumberOfComments,
            numberOfLikes: newValue.blmSearchPostList[i].searchPostNumberOfLikes,
            likeStatus: newValue.blmSearchPostList[i].searchPostLikeStatus,
            numberOfTagged: newValue.blmSearchPostList[i].searchPostPostTagged.length,
            taggedFirstName: newList1,
            taggedLastName: newList2,
            taggedImage: newList3,
            taggedId: newList4,
            pageType: newValue.blmSearchPostList[i].searchPostPage.searchPostPagePageType,
            famOrFriends: newValue.blmSearchPostList[i].searchPostPage.searchPostPageFamOrFriends,
            relationship: newValue.blmSearchPostList[i].searchPostPage.searchPostPageRelationship,
            location: newValue.blmSearchPostList[i].searchPostLocation,
            latitude: newValue.blmSearchPostList[i].searchPostLatitude,
            longitude: newValue.blmSearchPostList[i].searchPostLongitude,
          ),
        );
      }

      if(mounted){
        page1++;
      }
    }
  }

  void onLoading2() async{
    if(suggestedItemRemaining != 0){
      context.loaderOverlay.show();
      var newValue = await apiBLMSearchSuggested(page: page2);
      context.loaderOverlay.hide();

      suggestedItemRemaining = newValue.blmItemsRemaining;
      tabCount2.value = tabCount2.value + newValue.blmPages.length;

      for(int i = 0; i < newValue.blmPages.length; i++){
        suggested.add(
          BLMSearchMainSuggested(
            memorialId: newValue.blmPages[i].searchSuggestedPage.searchSuggestedPageId,
            memorialName: newValue.blmPages[i].searchSuggestedPage.searchSuggestedPageName,
            memorialDescription: newValue.blmPages[i].searchSuggestedPage.searchSuggestedPageDetails.searchSuggestedPageDetailsDescription,
            image: newValue.blmPages[i].searchSuggestedPage.searchSuggestedPageProfileImage,
            managed: newValue.blmPages[i].searchSuggestedPage.searchSuggestedPageManage,
            follower: newValue.blmPages[i].searchSuggestedPage.searchSuggestedPageFollower,
            pageType: newValue.blmPages[i].searchSuggestedPage.searchSuggestedPagePageType,
            famOrFriends: newValue.blmPages[i].searchSuggestedPage.searchSuggestedPageFamOrFriends,
            relationship: newValue.blmPages[i].searchSuggestedPage.searchSuggestedPageRelationship,
          ),    
        );
      }

      if(mounted) {
        page2++;
      }
    }
  }
 
  void onLoading3() async{
    if(nearbyBlmItemsRemaining != 0){
      context.loaderOverlay.show();
      var newValue = await apiBLMSearchNearby(page: page3, latitude: widget.latitude, longitude: widget.longitude);
      context.loaderOverlay.hide();

      nearbyBlmItemsRemaining = newValue.blmItemsRemaining;
      tabCount3.value = tabCount3.value + newValue.blmList.length;

      for(int i = 0; i < newValue.blmList.length; i++){
        nearby.add(
          BLMSearchMainNearby(
            memorialId: newValue.blmList[i].searchNearbyId,
            memorialName: newValue.blmList[i].searchNearbyName,
            memorialDescription: newValue.blmList[i].searchNearbyDetails.searchNearbyPageDetailsDescription,
            image: newValue.blmList[i].searchNearbyProfileImage,
            managed: newValue.blmList[i].searchNearbyManage,
            follower: newValue.blmList[i].searchNearbyFollower,
            pageType: newValue.blmList[i].searchNearbyPageType,
            famOrFriends: newValue.blmList[i].searchNearbyFamOrFriends,
            relationship: newValue.blmList[i].searchNearbyRelationship,
          ),    
        );
      }

      if(mounted){
        page3++;
      }
    }

    page3 = 1;
    
    if(nearbyMemorialItemsRemaining != 0){
      context.loaderOverlay.show();
      var newValue = await apiBLMSearchNearby(page: page3, latitude: widget.latitude, longitude: widget.longitude);
      context.loaderOverlay.hide();

      nearbyMemorialItemsRemaining = newValue.memorialItemsRemaining;
      tabCount3.value = tabCount3.value + newValue.memorialList.length;
      
      for(int i = 0; i < newValue.memorialList.length; i++){
        nearby.add(
          BLMSearchMainNearby(
            memorialId: newValue.memorialList[i].searchNearbyId,
            memorialName: newValue.memorialList[i].searchNearbyName,
            memorialDescription: newValue.memorialList[i].searchNearbyDetails.searchNearbyPageDetailsDescription,
            image: newValue.memorialList[i].searchNearbyProfileImage,
            managed: newValue.memorialList[i].searchNearbyManage,
            follower: newValue.memorialList[i].searchNearbyFollower,
            pageType: newValue.memorialList[i].searchNearbyPageType,
            famOrFriends: newValue.memorialList[i].searchNearbyFamOrFriends,
            relationship: newValue.memorialList[i].searchNearbyRelationship,
          ),    
        );
      }

      if(mounted){
        page3++;
      }
    }
  } 

  void onLoading4() async{
    if(blmItemRemaining != 0){
      context.loaderOverlay.show();
      var newValue = await apiBLMSearchBLM(page: page4, keywords: widget.keyword);
      context.loaderOverlay.hide();

      blmItemRemaining = newValue.blmItemsRemaining;
      tabCount4.value = tabCount4.value + newValue.blmMemorialList.length;

      for(int i = 0; i < newValue.blmMemorialList.length; i++){
        blm.add(
          BLMSearchMainBLM(
            memorialId: newValue.blmMemorialList[i].searchMemorialPage.searchMemorialId,
            memorialName: newValue.blmMemorialList[i].searchMemorialPage.searchMemorialName,
            memorialDescription: newValue.blmMemorialList[i].searchMemorialPage.searchMemorialDetails.searchMemorialPageDetailsDescription,
            image: newValue.blmMemorialList[i].searchMemorialPage.searchMemorialProfileImage,
            managed: newValue.blmMemorialList[i].searchMemorialPage.searchMemorialManage,
            follower: newValue.blmMemorialList[i].searchMemorialPage.searchMemorialFollower,
            pageType: newValue.blmMemorialList[i].searchMemorialPage.searchMemorialPageType,
            famOrFriends: newValue.blmMemorialList[i].searchMemorialPage.searchMemorialFamOrFriends,
            relationship: newValue.blmMemorialList[i].searchMemorialPage.searchMemorialRelationship,
          ),    
        );
      }

      if(mounted){
        page4++;
      }
    }
  }

  void isGuest() async{
    final sharedPrefs = await SharedPreferences.getInstance();
    isGuestLoggedIn.value = sharedPrefs.getBool('user-guest-session') ?? false;

    if(isGuestLoggedIn.value != true){
      onLoading1();
      onLoading2();
      onLoading3();
      onLoading4();
    }
  }

  @override
  void initState(){
    super.initState();
    isGuest();
    toggle.value = widget.newToggle;
    scrollController1.addListener((){
      if(scrollController1.position.pixels == scrollController1.position.maxScrollExtent){
        if(postItemRemaining != 0){
          onLoading1();
        }else{
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No more posts to show'),
              duration: Duration(seconds: 1),
              backgroundColor: Color(0xff4EC9D4),
            ),
          );
        }
      }
    });
    scrollController2.addListener((){
      if(scrollController2.position.pixels == scrollController2.position.maxScrollExtent){
        if(suggestedItemRemaining != 0){
          onLoading2();
        }else{
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No more suggested memorials to show'),
              duration: Duration(seconds: 1),
              backgroundColor: Color(0xff4EC9D4),
            ),
          );
        }
      }
    });
    scrollController3.addListener((){
      if(scrollController3.position.pixels == scrollController3.position.maxScrollExtent){
        if(nearbyBlmItemsRemaining != 0 && nearbyMemorialItemsRemaining != 0){
          onLoading3();
        }else{
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No more nearby memorials to show'),
              duration: Duration(seconds: 1),
              backgroundColor: Color(0xff4EC9D4),
            ),
          );
        }
      }
    });
    scrollController4.addListener((){
      if(scrollController4.position.pixels == scrollController4.position.maxScrollExtent){
        if(nearbyBlmItemsRemaining != 0 && nearbyMemorialItemsRemaining != 0){
          onLoading4();
        }else{
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No more BLM memorials to show'),
              duration: Duration(seconds: 1),
              backgroundColor: Color(0xff4EC9D4),
            ),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context){
    SizeConfig.init(context);
    return WillPopScope(
      onWillPop: () async{
        return Navigator.canPop(context);
      },
      child: GestureDetector(
        onTap: (){
          FocusNode currentFocus = FocusScope.of(context);
          if(!currentFocus.hasPrimaryFocus){
            currentFocus.unfocus();
          }
        },
        child: ValueListenableBuilder(
          valueListenable: toggle,
          builder: (_, int toggleListener, __) => ValueListenableBuilder(
            valueListenable: isGuestLoggedIn,
            builder: (_, bool isGuestLoggedInListener, __) => ValueListenableBuilder(
              valueListenable: onSearch,
              builder: (_, bool onSearchListener, __) => Scaffold(
                backgroundColor: const Color(0xff04ECFF),
                appBar: PreferredSize(
                  preferredSize: const Size.fromHeight(70.0),
                  child: AppBar(
                    leading: const SizedBox(),
                    backgroundColor: const Color(0xff04ECFF),
                    flexibleSpace: Column(
                      children: [
                        const Spacer(),

                        Row(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: IconButton(
                                icon: const Icon(Icons.arrow_back, color:  Color(0xffffffff), size: 35,),
                                onPressed: (){
                                  Navigator.pop(context);
                                },
                              ),
                            ),

                            Expanded(
                              child: TextFormField(
                                keyboardType: TextInputType.text,
                                controller: controller,
                                style: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xffB1B1B1),),
                                decoration: InputDecoration(
                                  enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color(0xffffffff)), borderRadius: BorderRadius.all(Radius.circular(25)),),
                                  focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color(0xffffffff)), borderRadius: BorderRadius.all(Radius.circular(25)),),
                                  border: const OutlineInputBorder(borderSide: BorderSide(color: Color(0xffffffff)), borderRadius: BorderRadius.all(Radius.circular(25)),),
                                  hintStyle: const TextStyle(fontSize: 22, fontFamily: 'NexaRegular', color: Color(0xffB1B1B1),),
                                  contentPadding: const EdgeInsets.all(15.0),
                                  focusColor: const Color(0xffffffff),
                                  fillColor: const Color(0xffffffff),
                                  hintText: 'Search Memorial',
                                  filled: true,
                                  prefixIcon: IconButton(
                                    icon: const Icon(Icons.search, color: Color(0xff888888), size: 35,),
                                    onPressed: () async{
                                      if(controller.text == ''){
                                        onSearch.value = false;
                                        searchFeeds = [];
                                        searchSuggested = [];
                                        searchNearby = [];
                                        searchBlm = [];
                                      }else{
                                        onSearch.value = true;

                                        if(toggleListener == 0){
                                          for(int i = 0; i < feeds.length; i++){
                                            if(feeds[i].memorialName.toUpperCase().contains(controller.text.toUpperCase()) && onSearch.value == true){
                                              searchFeeds.add(feeds[i]);
                                            }
                                          }
                                        }else if(toggleListener == 1){
                                          for(int i = 0; i < suggested.length; i++) {
                                            if(suggested[i].memorialName.toUpperCase().contains(controller.text.toUpperCase()) && onSearch.value == true){
                                              searchSuggested.add(suggested[i]);
                                            }
                                          }
                                        }else if(toggleListener == 2){
                                          for(int i = 0; i < nearby.length; i++){
                                            if(nearby[i].memorialName.toUpperCase().contains(controller.text.toUpperCase()) && onSearch.value == true){
                                              searchNearby.add(nearby[i]);
                                            }
                                          }
                                        }else if(toggleListener == 3){
                                          for(int i = 0; i < blm.length; i++){
                                            if(blm[i].memorialName.toUpperCase().contains(controller.text.toUpperCase()) && onSearch.value == true) {
                                              searchBlm.add(blm[i]);
                                            }
                                          }
                                        }
                                      }
                                    },
                                  ),
                                ),
                                onChanged: (search){
                                  if(search == ''){
                                    onSearch.value = false;
                                    searchFeeds = [];
                                    searchSuggested = [];
                                    searchNearby = [];
                                    searchBlm = [];
                                  }
                                },
                                onFieldSubmitted: (search){
                                  searchKeyword = search;
                                  if(search == ''){
                                    onSearch.value = false;
                                    searchFeeds = [];
                                    searchSuggested = [];
                                    searchNearby = [];
                                    searchBlm = [];
                                  }else{
                                    onSearch.value = true;

                                    if(toggleListener == 0){
                                      for(int i = 0; i < feeds.length; i++){
                                        if(feeds[i].memorialName.toUpperCase().contains(search.toUpperCase()) && onSearch.value == true){
                                          searchFeeds.add(feeds[i]);
                                        }
                                      }
                                    }else if(toggleListener == 1){
                                      for(int i = 0; i < suggested.length; i++){
                                        if(suggested[i].memorialName.toUpperCase().contains(search.toUpperCase()) && onSearch.value == true){
                                          searchSuggested.add(suggested[i]);
                                        }
                                      }
                                    }else if(toggleListener == 2){
                                      for(int i = 0; i < nearby.length; i++){
                                        if(nearby[i].memorialName.toUpperCase().contains(search.toUpperCase()) && onSearch.value == true){
                                          searchNearby.add(nearby[i]);
                                        }
                                      }
                                    }else if(toggleListener == 3){
                                      for(int i = 0; i < blm.length; i++){
                                        if(blm[i].memorialName.toUpperCase().contains(search.toUpperCase()) && onSearch.value == true){
                                          searchBlm.add(blm[i]);
                                        }
                                      }
                                    }
                                  }
                                },
                              ),
                            ),

                            const SizedBox(width: 20,),
                          ],
                        ),

                        const SizedBox(height: 5,),
                      ],
                    ),
                  ),
                ),
                body: Container(
                  height: SizeConfig.screenHeight,
                  width: SizeConfig.screenWidth,
                  decoration: const BoxDecoration(color: Colors.white, image: DecorationImage(fit: BoxFit.cover, image: AssetImage('assets/icons/background2.png'), colorFilter: ColorFilter.srgbToLinearGamma(),),),
                  child: Column(
                    children: [
                      IgnorePointer(
                        ignoring: isGuestLoggedInListener,
                        child: Container(
                          color: const Color(0xffffffff),
                          alignment: Alignment.center,
                          height: 55,
                          child: DefaultTabController(
                            length: 4,
                            child: TabBar(
                              unselectedLabelColor: const Color(0xff000000),
                              indicatorColor: const Color(0xff04ECFF),
                              labelColor: const Color(0xff04ECFF),
                              isScrollable: true,
                              tabs: const [
                                Center(child: Text('Post', style: TextStyle(fontSize: 22, fontFamily: 'NexaRegular'),),),

                                Center(child: Text('Suggested', style: TextStyle(fontSize: 22, fontFamily: 'NexaRegular'),),),

                                Center(child: Text('Nearby', style: TextStyle(fontSize: 22, fontFamily: 'NexaRegular'),),),

                                Center(child: Text('BLM', style: TextStyle(fontSize: 22, fontFamily: 'NexaRegular'),),),
                              ],
                              onTap: (int number){
                                toggle.value = number;
                                searchFeeds = [];
                                searchSuggested = [];
                                searchNearby = [];
                                searchBlm = [];

                                if(onSearchListener == true){
                                  if(toggle.value == 0){
                                    for(int i = 0; i < feeds.length; i++){
                                      if(feeds[i].memorialName.toUpperCase().contains(searchKeyword.toUpperCase()) && onSearch.value == true){
                                        searchFeeds.add(feeds[i]);
                                      }
                                    }
                                  }else if(toggle.value == 1){
                                    for(int i = 0; i < suggested.length; i++){
                                      if(suggested[i].memorialName.toUpperCase().contains(searchKeyword.toUpperCase()) && onSearch.value == true){
                                        searchSuggested.add(suggested[i]);
                                      }
                                    }
                                  }else if(toggle.value == 2){
                                    for(int i = 0; i < nearby.length; i++){
                                      if(nearby[i].memorialName.toUpperCase().contains(searchKeyword.toUpperCase()) && onSearch.value == true){
                                        searchNearby.add(nearby[i]);
                                      }
                                    }
                                  }else if(toggle.value == 3){
                                    for(int i = 0; i < blm.length; i++){
                                      if(blm[i].memorialName.toUpperCase().contains(searchKeyword.toUpperCase()) && onSearch.value == true){
                                        searchBlm.add(blm[i]);
                                      }
                                    }
                                  }

                                  onSearch.value = true;
                                }
                              },
                            ),
                          ),
                        ),
                      ),

                      SizedBox(
                        child: ((){
                          switch(toggleListener){
                            case 0: return const SizedBox(height: 20,);
                            case 1: return const SizedBox(height: 20,);
                            case 2: return 
                            SizedBox(
                              height: 40,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: [
                                    const SizedBox(width: 20,),

                                    const Icon(Icons.location_pin, color: Color(0xff979797),),

                                    const SizedBox(width: 20,),

                                    ((){
                                      if(widget.currentLocation != ''){
                                        return Text(widget.currentLocation, style: const TextStyle(fontSize: 16, fontFamily: 'NexaRegular'),);
                                      }else{
                                        return const Text('', style: TextStyle(color: Color(0xff000000), fontSize: 12,),);
                                      }
                                    }()),
                                  ],
                                ),
                              ),
                            );
                            case 3: return
                            SizedBox(
                              height: 40,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: [
                                    const SizedBox(width: 20,),

                                    const Icon(Icons.location_pin, color: Color(0xff979797),),

                                    const SizedBox(width: 20,),

                                    ((){
                                      if(widget.currentLocation != ''){
                                        return Text(widget.currentLocation, style: const TextStyle(fontSize: 16, fontFamily: 'NexaRegular'),);
                                      }else{
                                        return const Text('', style: TextStyle(color: Color(0xff000000), fontSize: 12,),);
                                      }
                                    }()),
                                  ],
                                ),
                              ),
                            );
                          }
                        }()),
                      ),

                      Expanded(
                        child: SizedBox(
                          child: isGuestLoggedInListener 
                          ? BackdropFilter(filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0), child: const MiscLoginToContinue(),)
                          : ((){
                            switch(toggleListener){
                              case 0: return searchPostExtended();
                              case 1: return searchSuggestedExtended();
                              case 2: return searchNearbyExtended();
                              case 3: return searchBLMExtended();
                            }
                          }()),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  searchPostExtended(){
    return ValueListenableBuilder(
      valueListenable: tabCount1,
      builder: (_, int tabCount1Listener, __) => ValueListenableBuilder(
        valueListenable: onSearch,
        builder: (_, bool onSearchListener, __) => tabCount1Listener != 0
        ? RefreshIndicator(
          onRefresh: onRefresh1,
          child: onSearchListener != true
          ? ListView.separated(
            controller: scrollController1,
            separatorBuilder: (c, i) => const Divider(height: 10, color: Colors.transparent),
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.all(10.0),
            itemCount: feeds.length,
            itemBuilder: (c, i) {
              return feeds[i].pageType == 'Blm'
              ? MiscBLMPost(
                key: ValueKey('$i'),
                userId: feeds[i].userId,
                postId: feeds[i].postId,
                memorialId: feeds[i].memorialId,
                memorialName: feeds[i].memorialName,
                timeCreated: timeago.format(DateTime.parse(feeds[i].timeCreated)),
                managed: feeds[i].managed,
                joined: feeds[i].follower,
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
                location: feeds[i].location,
                latitude: feeds[i].latitude,
                longitude: feeds[i].longitude,
                contents: [
                  Align(alignment: Alignment.centerLeft, child: Text(feeds[i].postBody, overflow: TextOverflow.ellipsis, maxLines: 5, style: const TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xff000000),),),),

                  feeds[i].imagesOrVideos.isNotEmpty
                  ? Column(
                    children: [
                      const SizedBox(height: 20),

                      SizedBox(
                        child: ((){
                          if(feeds[i].imagesOrVideos.length == 1){
                            if(lookupMimeType(feeds[i].imagesOrVideos[0])?.contains('video') == true){
                              return BetterPlayer.network('${feeds[i].imagesOrVideos[0]}',
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
                                imageUrl: feeds[i].imagesOrVideos[0],
                                placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                              );
                            }
                          }else if(feeds[i].imagesOrVideos.length == 2){
                            return StaggeredGridView.countBuilder(
                              staggeredTileBuilder: (int index) => const StaggeredTile.count(2, 2),
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.zero,
                              crossAxisSpacing: 4.0,
                              mainAxisSpacing: 4.0,
                              crossAxisCount: 4,
                              shrinkWrap: true,
                              itemCount: 2,
                              itemBuilder: (BuildContext context, int index) => lookupMimeType(feeds[i].imagesOrVideos[index])?.contains('video') == true
                              ? BetterPlayer.network('${feeds[i].imagesOrVideos[index]}',
                                betterPlayerConfiguration: BetterPlayerConfiguration(
                                  placeholder: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 16 / 9),
                                  controlsConfiguration: const BetterPlayerControlsConfiguration(showControls: false,),
                                  aspectRatio: 16 / 9,
                                  fit: BoxFit.contain,
                                ),
                              )
                              : CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl: feeds[i].imagesOrVideos[index],
                                placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
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
                                  return lookupMimeType(feeds[i].imagesOrVideos[index])?.contains('video') == true
                                  ? BetterPlayer.network('${feeds[i].imagesOrVideos[index]}',
                                    betterPlayerConfiguration: BetterPlayerConfiguration(
                                      placeholder: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 16 / 9),
                                      controlsConfiguration: const BetterPlayerControlsConfiguration(showControls: false,),
                                      aspectRatio: 16 / 9,
                                      fit: BoxFit.contain,
                                    ),
                                  )
                                  : CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl: feeds[i].imagesOrVideos[index],
                                    placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
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
                                                child: Text('${feeds[i].imagesOrVideos.length - 3}', style: const TextStyle(fontSize: 32, fontFamily: 'NexaBold', color: Color(0xffFFFFFF),),),
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
                                              placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                              errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                            ),

                                            Container(color: const Color(0xff000000).withOpacity(0.5),),

                                            Center(
                                              child: CircleAvatar(
                                                radius: 25,
                                                backgroundColor: const Color(0xffffffff).withOpacity(.5),
                                                child: Text('${feeds[i].imagesOrVideos.length - 3}', style: const TextStyle(fontSize: 32, fontFamily: 'NexaBold', color: Color(0xffFFFFFF),),),
                                              ),
                                            ),
                                          ],
                                        );
                                      }
                                    }else{
                                      if(lookupMimeType(feeds[i].imagesOrVideos[index])?.contains('video') == true){
                                        return BetterPlayer.network('${feeds[i].imagesOrVideos[index]}',
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
                                          imageUrl: feeds[i].imagesOrVideos[index],
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
              )
              : MiscRegularPost(
                key: ValueKey('$i'),
                userId: feeds[i].userId,
                postId: feeds[i].postId,
                memorialId: feeds[i].memorialId,
                memorialName: feeds[i].memorialName,
                timeCreated: timeago.format(DateTime.parse(feeds[i].timeCreated)),
                managed: feeds[i].managed,
                joined: feeds[i].follower,
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
                location: feeds[i].location,
                latitude: feeds[i].latitude,
                longitude: feeds[i].longitude,
                isGuest: isGuestLoggedIn.value,
                contents: [
                  Align(alignment: Alignment.centerLeft, child: Text(feeds[i].postBody, overflow: TextOverflow.ellipsis, maxLines: 5, style: const TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xff000000),),),),

                  feeds[i].imagesOrVideos.isNotEmpty
                  ? Column(
                    children: [
                      const SizedBox(height: 20),

                      SizedBox(
                        child: ((){
                          if(feeds[i].imagesOrVideos.length == 1){
                            if(lookupMimeType(feeds[i].imagesOrVideos[0])?.contains('video') == true){
                              return BetterPlayer.network('${feeds[i].imagesOrVideos[0]}',
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
                                imageUrl: feeds[i].imagesOrVideos[0],
                                placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                              );
                            }
                          }else if(feeds[i].imagesOrVideos.length == 2){
                            return StaggeredGridView.countBuilder(
                              staggeredTileBuilder: (int index) => const StaggeredTile.count(2, 2),
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.zero,
                              crossAxisSpacing: 4.0,
                              mainAxisSpacing: 4.0,
                              crossAxisCount: 4,
                              shrinkWrap: true,
                              itemCount: 2,
                              itemBuilder: (BuildContext context, int index) => lookupMimeType(feeds[i].imagesOrVideos[index])?.contains('video') == true
                              ? BetterPlayer.network('${feeds[i].imagesOrVideos[index]}',
                                betterPlayerConfiguration: BetterPlayerConfiguration(
                                  placeholder: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 16 / 9),
                                  controlsConfiguration: const BetterPlayerControlsConfiguration(showControls: false,),
                                  aspectRatio: 16 / 9,
                                  fit: BoxFit.contain,
                                ),
                              )
                              : CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl: feeds[i].imagesOrVideos[index],
                                placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
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
                                  return lookupMimeType(feeds[i].imagesOrVideos[index])?.contains('video') == true
                                  ? BetterPlayer.network('${feeds[i].imagesOrVideos[index]}',
                                    betterPlayerConfiguration: BetterPlayerConfiguration(
                                      placeholder: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 16 / 9),
                                      controlsConfiguration: const BetterPlayerControlsConfiguration(showControls: false,),
                                      aspectRatio: 16 / 9,
                                      fit: BoxFit.contain,
                                    ),
                                  )
                                  : CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl: feeds[i].imagesOrVideos[index],
                                    placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
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
                                                child: Text('${feeds[i].imagesOrVideos.length - 3}', style: const TextStyle(fontSize: 32, fontFamily: 'NexaBold', color: Color(0xffFFFFFF),),),
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
                                              placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                              errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                            ),

                                            Container(color: const Color(0xff000000).withOpacity(0.5),),

                                            Center(
                                              child: CircleAvatar(
                                                radius: 25,
                                                backgroundColor: const Color(0xffffffff).withOpacity(.5),
                                                child: Text('${feeds[i].imagesOrVideos.length - 3}', style: const TextStyle(fontSize: 32, fontFamily: 'NexaBold', color: Color(0xffFFFFFF),),),
                                              ),
                                            ),
                                          ],
                                        );
                                      }
                                    }else{
                                      if(lookupMimeType(feeds[i].imagesOrVideos[index])?.contains('video') == true){
                                        return BetterPlayer.network('${feeds[i].imagesOrVideos[index]}',
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
                                          imageUrl: feeds[i].imagesOrVideos[index],
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
          )
          : ListView.separated(
            controller: scrollController1,
            padding: const EdgeInsets.all(10.0),
            physics: const ClampingScrollPhysics(),
            itemCount: searchFeeds.length,
            separatorBuilder: (c, i) => const Divider(height: 10, color: Colors.transparent),
            itemBuilder: (c, i) {
              return searchFeeds[i].pageType == 'Blm'
              ? MiscBLMPost(
                key: ValueKey('$i'),
                userId: searchFeeds[i].userId,
                postId: searchFeeds[i].postId,
                memorialId: searchFeeds[i].memorialId,
                memorialName: searchFeeds[i].memorialName,
                timeCreated: timeago.format(DateTime.parse(searchFeeds[i].timeCreated)),
                managed: searchFeeds[i].managed,
                joined: searchFeeds[i].follower,
                profileImage: searchFeeds[i].profileImage,
                numberOfComments: searchFeeds[i].numberOfComments,
                numberOfLikes: searchFeeds[i].numberOfLikes,
                likeStatus: searchFeeds[i].likeStatus,
                numberOfTagged: searchFeeds[i].numberOfTagged,
                taggedFirstName: searchFeeds[i].taggedFirstName,
                taggedLastName: searchFeeds[i].taggedLastName,
                taggedId: searchFeeds[i].taggedId,
                pageType: searchFeeds[i].pageType,
                famOrFriends: searchFeeds[i].famOrFriends,
                relationship: searchFeeds[i].relationship,
                location: searchFeeds[i].location,
                latitude: searchFeeds[i].latitude,
                longitude: searchFeeds[i].longitude,
                contents: [
                  Align(alignment: Alignment.centerLeft, child: Text(searchFeeds[i].postBody, overflow: TextOverflow.ellipsis, maxLines: 5, style: const TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xff000000),),),),

                  searchFeeds[i].imagesOrVideos.isNotEmpty
                  ? Column(
                    children: [
                      const SizedBox(height: 20),

                      SizedBox(
                        child: ((){
                          if(searchFeeds[i].imagesOrVideos.length == 1){
                            if(lookupMimeType(searchFeeds[i].imagesOrVideos[0])?.contains('video') == true){
                              return BetterPlayer.network('${searchFeeds[i].imagesOrVideos[0]}',
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
                                imageUrl: searchFeeds[i].imagesOrVideos[0],
                                placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                              );
                            }
                          }else if(searchFeeds[i].imagesOrVideos.length == 2){
                            return StaggeredGridView.countBuilder(
                              staggeredTileBuilder: (int index) => const StaggeredTile.count(2, 2),
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.zero,
                              crossAxisSpacing: 4.0,
                              mainAxisSpacing: 4.0,
                              crossAxisCount: 4,
                              shrinkWrap: true,
                              itemCount: 2,
                              itemBuilder: (BuildContext context, int index) => lookupMimeType(searchFeeds[i].imagesOrVideos[index])?.contains('video') == true
                              ? BetterPlayer.network('${searchFeeds[i].imagesOrVideos[index]}',
                                betterPlayerConfiguration: BetterPlayerConfiguration(
                                  placeholder: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 16 / 9),
                                  controlsConfiguration: const BetterPlayerControlsConfiguration(showControls: false,),
                                  aspectRatio: 16 / 9,
                                  fit: BoxFit.contain,
                                ),
                              )
                              : CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl: searchFeeds[i].imagesOrVideos[index],
                                placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
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
                                  return lookupMimeType(searchFeeds[i].imagesOrVideos[index])?.contains('video') == true
                                  ? BetterPlayer.network('${searchFeeds[i].imagesOrVideos[index]}',
                                    betterPlayerConfiguration: BetterPlayerConfiguration(
                                      placeholder: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 16 / 9),
                                      controlsConfiguration:const BetterPlayerControlsConfiguration(showControls: false,),
                                      aspectRatio: 16 / 9,
                                      fit: BoxFit.contain,
                                    ),
                                  )
                                  : CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl: searchFeeds[i].imagesOrVideos[index],
                                    placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                    errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                  );
                                }else{
                                  return ((){
                                    if(searchFeeds[i].imagesOrVideos.length - 3 > 0){
                                      if(lookupMimeType(searchFeeds[i].imagesOrVideos[index])?.contains('video') == true){
                                        return Stack(
                                          fit: StackFit.expand,
                                          children: [
                                            BetterPlayer.network('${searchFeeds[i].imagesOrVideos[index]}',
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
                                                child: Text('${searchFeeds[i].imagesOrVideos.length - 3}', style: const TextStyle(fontSize: 32, fontFamily: 'NexaBold', color: Color(0xffFFFFFF),),),
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
                                              imageUrl: searchFeeds[i].imagesOrVideos[index],
                                              placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                              errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                            ),

                                            Container(color: const Color(0xff000000).withOpacity(0.5),),

                                            Center(
                                              child: CircleAvatar(
                                                radius: 25,
                                                backgroundColor: const Color(0xffffffff).withOpacity(.5),
                                                child: Text('${searchFeeds[i].imagesOrVideos.length - 3}', style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Color(0xffffffff),),),
                                              ),
                                            ),
                                          ],
                                        );
                                      }
                                    }else{
                                      if(lookupMimeType(searchFeeds[i].imagesOrVideos[index])?.contains('video') == true){
                                        return BetterPlayer.network('${searchFeeds[i].imagesOrVideos[index]}',
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
                                          imageUrl: searchFeeds[i].imagesOrVideos[index],
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
              )
              : MiscRegularPost(
                key: ValueKey('$i'),
                userId: searchFeeds[i].userId,
                postId: searchFeeds[i].postId,
                memorialId: searchFeeds[i].memorialId,
                memorialName: searchFeeds[i].memorialName,
                timeCreated: timeago.format(DateTime.parse(searchFeeds[i].timeCreated)),
                managed: searchFeeds[i].managed,
                joined: searchFeeds[i].follower,
                profileImage: searchFeeds[i].profileImage,
                numberOfComments: searchFeeds[i].numberOfComments,
                numberOfLikes: searchFeeds[i].numberOfLikes,
                likeStatus: searchFeeds[i].likeStatus,
                numberOfTagged: searchFeeds[i].numberOfTagged,
                taggedFirstName: searchFeeds[i].taggedFirstName,
                taggedLastName: searchFeeds[i].taggedLastName,
                taggedId: searchFeeds[i].taggedId,
                pageType: searchFeeds[i].pageType,
                famOrFriends: searchFeeds[i].famOrFriends,
                relationship: searchFeeds[i].relationship,
                location: searchFeeds[i].location,
                latitude: searchFeeds[i].latitude,
                longitude: searchFeeds[i].longitude,
                isGuest: isGuestLoggedIn.value,
                contents: [
                  Align(alignment: Alignment.centerLeft, child: Text(searchFeeds[i].postBody, overflow: TextOverflow.ellipsis, maxLines: 5, style: const TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xff000000),),),),

                  searchFeeds[i].imagesOrVideos.isNotEmpty
                  ? Column(
                    children: [
                      const SizedBox(height: 20),

                      SizedBox(
                        child: ((){
                          if(searchFeeds[i].imagesOrVideos.length == 1){
                            if(lookupMimeType(searchFeeds[i].imagesOrVideos[0])?.contains('video') == true){
                              return BetterPlayer.network('${searchFeeds[i].imagesOrVideos[0]}',
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
                                imageUrl: searchFeeds[i].imagesOrVideos[0],
                                placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                              );
                            }
                          }else if(searchFeeds[i].imagesOrVideos.length == 2){
                            return StaggeredGridView.countBuilder(
                              staggeredTileBuilder: (int index) => const StaggeredTile.count(2, 2),
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.zero,
                              crossAxisSpacing: 4.0,
                              mainAxisSpacing: 4.0,
                              crossAxisCount: 4,
                              shrinkWrap: true,
                              itemCount: 2,
                              itemBuilder: (BuildContext context, int index) => lookupMimeType(searchFeeds[i].imagesOrVideos[index])?.contains('video') == true
                              ? BetterPlayer.network('${searchFeeds[i].imagesOrVideos[index]}',
                                betterPlayerConfiguration: BetterPlayerConfiguration(
                                  placeholder: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 16 / 9),
                                  controlsConfiguration: const BetterPlayerControlsConfiguration(showControls: false,),
                                  aspectRatio: 16 / 9,
                                  fit: BoxFit.contain,
                                ),
                              )
                              : CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl: searchFeeds[i].imagesOrVideos[index],
                                placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
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
                                  return lookupMimeType(searchFeeds[i].imagesOrVideos[index])?.contains('video') == true
                                  ? BetterPlayer.network('${searchFeeds[i].imagesOrVideos[index]}',
                                    betterPlayerConfiguration: BetterPlayerConfiguration(
                                      placeholder: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 16 / 9),
                                      controlsConfiguration: const BetterPlayerControlsConfiguration(showControls: false,),
                                      aspectRatio: 16 / 9,
                                      fit: BoxFit.contain,
                                    ),
                                  )
                                  : CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl: searchFeeds[i].imagesOrVideos[index],
                                    placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                    errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                  );
                                }else{
                                  return ((){
                                    if(searchFeeds[i].imagesOrVideos.length - 3 > 0){
                                      if(lookupMimeType(searchFeeds[i].imagesOrVideos[index])?.contains('video') == true){
                                        return Stack(
                                          fit: StackFit.expand,
                                          children: [
                                            BetterPlayer.network('${searchFeeds[i].imagesOrVideos[index]}',
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
                                                backgroundColor:const  Color(0xffffffff).withOpacity(.5),
                                                child: Text('${searchFeeds[i].imagesOrVideos.length - 3}', style: const TextStyle(fontSize: 32, fontFamily: 'NexaBold', color: Color(0xffFFFFFF),),),
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
                                              imageUrl: searchFeeds[i].imagesOrVideos[index],
                                              placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                              errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                            ),

                                            Container(color: const Color(0xff000000).withOpacity(0.5),),

                                            Center(
                                              child: CircleAvatar(
                                                radius: 25,
                                                backgroundColor: const Color(0xffffffff).withOpacity(.5),
                                                child: Text('${searchFeeds[i].imagesOrVideos.length - 3}', style: const TextStyle(fontSize: 32, fontFamily: 'NexaBold', color: Color(0xffFFFFFF),),),
                                              ),
                                            ),
                                          ],
                                        );
                                      }
                                    }else{
                                      if(lookupMimeType(searchFeeds[i].imagesOrVideos[index])?.contains('video') == true){
                                        return BetterPlayer.network('${searchFeeds[i].imagesOrVideos[index]}',
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
                                          imageUrl: searchFeeds[i].imagesOrVideos[index],
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
          ),
        )
        : SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: (SizeConfig.screenHeight! - 55 - kToolbarHeight) / 4,),

              Image.asset('assets/icons/app-icon.png', height: 200, width: 200,),

              const SizedBox(height: 45,),

              const Text('Post is empty', style: TextStyle(fontSize: 36, fontFamily: 'NexaBold', color: Color(0xffB1B1B1),),),

              SizedBox(height: (SizeConfig.screenHeight! - 55 - kToolbarHeight) / 4,),
            ],
          ),
        ),
      ),
    );
  }

  searchSuggestedExtended(){
    return ValueListenableBuilder(
      valueListenable: tabCount2,
      builder: (_, int tabCount2Listener, __) => ValueListenableBuilder(
        valueListenable: onSearch,
        builder: (_, bool onSearchListener, __) => tabCount2Listener != 0
        ? RefreshIndicator(
          onRefresh: onRefresh2,
          child: onSearchListener != true
          ? ListView.separated(
            controller: scrollController2,
            separatorBuilder: (c, i) => const Divider(height: 10, color: Colors.transparent),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
            physics: const ClampingScrollPhysics(),
            itemCount: suggested.length,
            itemBuilder: (c, i) => MiscBLMManageMemorialTab(
              index: i,
              memorialName: suggested[i].memorialName,
              description: suggested[i].memorialDescription,
              image: suggested[i].image,
              memorialId: suggested[i].memorialId,
              managed: suggested[i].managed,
              follower: suggested[i].follower,
              pageType: suggested[i].pageType,
              relationship: suggested[i].relationship,
              famOrFriends: suggested[i].famOrFriends,
            ),
          )
          : ListView.separated(
            controller: scrollController2,
            separatorBuilder: (c, i) => const Divider(height: 10, color: Colors.transparent),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
            physics: const ClampingScrollPhysics(),
            itemCount: searchSuggested.length,
            itemBuilder: (c, i) => MiscBLMManageMemorialTab(
              index: i,
              memorialName: searchSuggested[i].memorialName,
              description: searchSuggested[i].memorialDescription,
              image: searchSuggested[i].image,
              memorialId: searchSuggested[i].memorialId,
              managed: searchSuggested[i].managed,
              follower: searchSuggested[i].follower,
              pageType: searchSuggested[i].pageType,
              relationship: searchSuggested[i].relationship,
              famOrFriends: searchSuggested[i].famOrFriends,
            ),
          ),
        )
        : SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: (SizeConfig.screenHeight! - 75 - kToolbarHeight) / 4,),

              Image.asset('assets/icons/app-icon.png', height: 200, width: 200,),

              const SizedBox(height: 45,),

              const Text('Suggested is empty', style: TextStyle(fontSize: 36, fontFamily: 'NexaBold', color:Color(0xffB1B1B1),),),
              
              SizedBox(height: (SizeConfig.screenHeight! - 75 - kToolbarHeight) / 4,),
            ],
          ),
        ),
      ),
    );
  }

  searchNearbyExtended(){
  return ValueListenableBuilder(
    valueListenable: tabCount3,
    builder: (_, int tabCount3Listener, __) => ValueListenableBuilder(
      valueListenable: onSearch,
      builder: (_, bool onSearchListener, __) => tabCount3Listener != 0
      ? RefreshIndicator(
        onRefresh: onRefresh3,
        child: onSearchListener != true
        ? ListView.separated(
          controller: scrollController3,
          separatorBuilder: (c, i) => const Divider(height: 10, color: Colors.transparent),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
          physics: const ClampingScrollPhysics(),
          itemCount: nearby.length,
          itemBuilder: (c, i) => MiscBLMManageMemorialTab(
            index: i,
            memorialName: nearby[i].memorialName,
            description: nearby[i].memorialDescription,
            image: nearby[i].image,
            memorialId: nearby[i].memorialId,
            managed: nearby[i].managed,
            follower: nearby[i].follower,
            pageType: nearby[i].pageType,
            relationship: nearby[i].relationship,
            famOrFriends: nearby[i].famOrFriends,
          ),
        )
        : ListView.separated(
          controller: scrollController3,
          separatorBuilder: (c, i) => const Divider(height: 10, color: Colors.transparent),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
          physics: const ClampingScrollPhysics(),
          itemCount: searchNearby.length,
          itemBuilder: (c, i) => MiscBLMManageMemorialTab(
            index: i,
            memorialName: searchNearby[i].memorialName,
            description: searchNearby[i].memorialDescription,
            image: searchNearby[i].image,
            memorialId: searchNearby[i].memorialId,
            managed: searchNearby[i].managed,
            follower: searchNearby[i].follower,
            pageType: searchNearby[i].pageType,
            relationship: searchNearby[i].relationship,
            famOrFriends: searchNearby[i].famOrFriends,
          ),
        ),
      )
      : SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: (SizeConfig.screenHeight! - 75 - kToolbarHeight) / 4,),

            Image.asset('assets/icons/app-icon.png', height: 200, width: 200,),

            const SizedBox(height: 45,),

            const Text('Nearby is empty', style: TextStyle(fontSize: 36, fontFamily: 'NexaBold', color: Color(0xffB1B1B1),),),

            SizedBox(height: (SizeConfig.screenHeight! - 75 - kToolbarHeight) / 4,),
          ],
        ),
      ),
    ),
  );
  }

  searchBLMExtended(){
    return ValueListenableBuilder(
      valueListenable: tabCount4,
      builder: (_, int tabCount4Listener, __) => ValueListenableBuilder(
        valueListenable: onSearch,
        builder: (_, bool onSearchListener, __) => tabCount4Listener != 0
        ? RefreshIndicator(
          onRefresh: onRefresh4,
          child: onSearchListener != true
          ? ListView.separated(
            controller: scrollController4,
            separatorBuilder: (c, i) => const Divider(height: 10, color: Colors.transparent),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
            physics: const ClampingScrollPhysics(),
            itemCount: blm.length,
            itemBuilder: (c, i) => MiscBLMManageMemorialTab(
              index: i,
              memorialName: blm[i].memorialName,
              description: blm[i].memorialDescription,
              image: blm[i].image,
              memorialId: blm[i].memorialId,
              managed: blm[i].managed,
              follower: blm[i].follower,
              pageType: blm[i].pageType,
              relationship: blm[i].relationship,
              famOrFriends: blm[i].famOrFriends,
            ),
          )
          : ListView.separated(
            controller: scrollController4,
            separatorBuilder: (c, i) => const Divider(height: 10, color: Colors.transparent),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
            physics: const ClampingScrollPhysics(),
            itemCount: searchBlm.length,
            itemBuilder: (c, i) => MiscBLMManageMemorialTab(
              index: i,
              memorialName: searchBlm[i].memorialName,
              description: searchBlm[i].memorialDescription,
              image: searchBlm[i].image,
              memorialId: searchBlm[i].memorialId,
              managed: searchBlm[i].managed,
              follower: searchBlm[i].follower,
              pageType: searchBlm[i].pageType,
              relationship: searchBlm[i].relationship,
              famOrFriends: searchBlm[i].famOrFriends,
            ),
          ),
        )
        : SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: (SizeConfig.screenHeight! - 75 - kToolbarHeight) / 4,),

              Image.asset('assets/icons/app-icon.png', height: 200, width: 200,),

              const SizedBox(height: 45,),

              const Text('BLM is empty', style: TextStyle(fontSize: 36, fontFamily: 'NexaBold', color: Color(0xffB1B1B1),),),

              SizedBox(height: (SizeConfig.screenHeight! - 75 - kToolbarHeight) / 4,),
            ],
          ),
        ),
      ),
    );
  }
}