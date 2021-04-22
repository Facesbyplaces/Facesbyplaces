import 'package:facesbyplaces/API/BLM/08-Search/api-search-blm-01-search-posts.dart';
import 'package:facesbyplaces/API/BLM/08-Search/api-search-blm-04-search-blm.dart';
import 'package:facesbyplaces/API/BLM/08-Search/api-search-blm-03-search-nearby.dart';
import 'package:facesbyplaces/API/BLM/08-Search/api-search-blm-02-search-suggested.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-03-blm-manage-memorial.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-04-blm-post.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-07-blm-background.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-08-blm-message.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-04-regular-post.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:better_player/better_player.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'dart:ui';

class BLMSearchMainPosts{
  int userId;
  int postId;
  int memorialId;
  String memorialName;
  String timeCreated;
  String postBody;
  dynamic profileImage;
  List<dynamic> imagesOrVideos;
  bool managed;
  bool follower;
  int numberOfLikes;
  int numberOfComments;
  bool likeStatus;
  int numberOfTagged;
  List<String> taggedFirstName;
  List<String> taggedLastName;
  List<String> taggedImage;
  List<int> taggedId;
  String pageType;
  bool famOrFriends;
  String relationship;

  BLMSearchMainPosts({required this.userId, required this.postId, required this.memorialId, required this.memorialName, required this.timeCreated, required this.postBody, required this.profileImage, required this.imagesOrVideos, required this.managed, required this.follower, required this.numberOfLikes, required this.numberOfComments, required this.likeStatus, required this.numberOfTagged, required this.taggedFirstName, required this.taggedLastName, required this.taggedImage, required this.taggedId, required this.pageType, required this.famOrFriends, required this.relationship});
}

class BLMSearchMainSuggested{
  int memorialId;
  String memorialName;
  String memorialDescription;
  String image;
  bool managed;
  bool follower;
  String pageType;
  bool famOrFriends;
  String relationship;

  BLMSearchMainSuggested({required this.memorialId, required this.memorialName, required this.memorialDescription, required this.image, required this.managed, required this.follower, required this.pageType, required this.famOrFriends, required this.relationship});
}

class BLMSearchMainNearby{
  int memorialId;
  String memorialName;
  String memorialDescription;
  String image;
  bool managed;
  bool follower;
  String pageType;
  bool famOrFriends;
  String relationship;

  BLMSearchMainNearby({required this.memorialId, required this.memorialName, required this.memorialDescription, required this.image, required this.managed, required this.follower, required this.pageType, required this.famOrFriends, required this.relationship});
}

class BLMSearchMainBLM{
  int memorialId;
  String memorialName;
  String memorialDescription;
  String image;
  bool managed;
  bool follower;
  String pageType;
  bool famOrFriends;
  String relationship;

  BLMSearchMainBLM({required this.memorialId, required this.memorialName, required this.memorialDescription, required this.image, required this.managed, required this.follower, required this.pageType, required this.famOrFriends, required this.relationship});
}


class HomeBLMPost extends StatefulWidget{
  final String keyword;
  final int newToggle;
  final double latitude;
  final double longitude;
  final String currentLocation;
  HomeBLMPost({required this.keyword, required this.newToggle, required this.latitude, required this.longitude, required this.currentLocation});

  HomeBLMPostState createState() => HomeBLMPostState(keyword: keyword, newToggle: newToggle, latitude: latitude, longitude: longitude, currentLocation: currentLocation);
}

class HomeBLMPostState extends State<HomeBLMPost>{
  final String keyword;
  final int newToggle;
  final double latitude;
  final double longitude;
  final String currentLocation;
  HomeBLMPostState({required this.keyword, required this.newToggle, required this.latitude, required this.longitude, required this.currentLocation});

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
  bool onSearch = false;
  int postItemRemaining = 1;
  int suggestedItemRemaining = 1;
  int nearbyBlmItemsRemaining = 1;
  int nearbyMemorialItemsRemaining = 1;
  int blmItemRemaining = 1;
  int page1 = 1;
  int page2 = 1;
  int page3 = 1;
  int page4 = 1;
  int toggle = 0;
  int tabCount1 = 0;
  int tabCount2 = 0;
  int tabCount3 = 0;
  int tabCount4 = 0;
  bool isGuestLoggedIn = true;

  Future<void> onRefresh1() async{
    setState(() {
      onLoading1();
    });
  }

  Future<void> onRefresh2() async{
    setState(() {
      onLoading2();
    });
  }

  Future<void> onRefresh3() async{
    setState(() {
      onLoading3();
    });
  }

  Future<void> onRefresh4() async{
    setState(() {
      onLoading4();
    });
  }

  void onLoading1() async{

    if(postItemRemaining != 0){
      context.showLoaderOverlay();
      var newValue = await apiBLMSearchPosts(keywords: keyword, page: page1);
      context.hideLoaderOverlay();
      postItemRemaining = newValue.blmItemsRemaining;
      tabCount1 = tabCount1 + newValue.blmSearchPostList.length;

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
          ),    
        );
      }

      if(mounted)
      setState(() {});
      page1++;
    }
  }

  void onLoading2() async{
    if(suggestedItemRemaining != 0){
      context.showLoaderOverlay();
      var newValue = await apiBLMSearchSuggested(page: page2);
      context.hideLoaderOverlay();
      suggestedItemRemaining = newValue.blmItemsRemaining;
      tabCount2 = tabCount2 + newValue.blmPages.length;

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

      if(mounted)
      setState(() {});
      page2++;
    }
  }
 
  void onLoading3() async{
    if(nearbyBlmItemsRemaining != 0){

      context.showLoaderOverlay();
      var newValue = await apiBLMSearchNearby(page: page3, latitude: latitude, longitude: longitude);
      context.hideLoaderOverlay();
      nearbyBlmItemsRemaining = newValue.blmItemsRemaining;
      tabCount3 = tabCount3 + newValue.blmList.length;

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

      if(mounted)
      setState(() {});
      page3++;
    }

    page3 = 1;
    
    if(nearbyMemorialItemsRemaining != 0){
      context.showLoaderOverlay();
      var newValue = await apiBLMSearchNearby(page: page3, latitude: latitude, longitude: longitude);
      context.hideLoaderOverlay();
      nearbyMemorialItemsRemaining = newValue.memorialItemsRemaining;
      tabCount3 = tabCount3 + newValue.memorialList.length;
      
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

      if(mounted)
      setState(() {});
      page3++;
    }
  } 

  void onLoading4() async{
    if(blmItemRemaining != 0){
      context.showLoaderOverlay();
      var newValue = await apiBLMSearchBLM(page: page4, keywords: keyword);
      context.hideLoaderOverlay();
      blmItemRemaining = newValue.blmItemsRemaining;
      tabCount4 = tabCount4 + newValue.blmMemorialList.length;

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

      if(mounted)
      setState(() {});
      page4++;
    }
  }

  void isGuest() async{
    final sharedPrefs = await SharedPreferences.getInstance();
    setState(() {
      isGuestLoggedIn = sharedPrefs.getBool('user-guest-session') ?? false;
    });
    if(isGuestLoggedIn != true){
      onLoading1();
      onLoading2();
      onLoading3();
      onLoading4();
      scrollController1.addListener(() {
        if (scrollController1.position.pixels == scrollController1.position.maxScrollExtent) {
          if(postItemRemaining != 0){
            setState(() {
              onLoading1();
            });
          }else{
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('No more posts to show'),
                duration: Duration(seconds: 1),
                backgroundColor: Color(0xff4EC9D4),
              ),
            );
          }
        }
      });
      scrollController2.addListener(() {
        if (scrollController2.position.pixels == scrollController2.position.maxScrollExtent) {
          if(suggestedItemRemaining != 0){
            setState(() {
              onLoading2();
            });
          }else{
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('No more suggested memorials to show'),
                duration: Duration(seconds: 1),
                backgroundColor: Color(0xff4EC9D4),
              ),
            );
          }
        }
      });
      scrollController3.addListener(() {
        if (scrollController3.position.pixels == scrollController3.position.maxScrollExtent) {
          if(nearbyBlmItemsRemaining != 0 && nearbyMemorialItemsRemaining != 0){
            setState(() {
              onLoading3();
            });
          }else{
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('No more nearby memorials to show'),
                duration: Duration(seconds: 1),
                backgroundColor: Color(0xff4EC9D4),
              ),
            );
          }
        }
      });
      scrollController4.addListener(() {
        if (scrollController4.position.pixels == scrollController4.position.maxScrollExtent) {
          if(nearbyBlmItemsRemaining != 0 && nearbyMemorialItemsRemaining != 0){
            setState(() {
              onLoading4();
            });
          }else{
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('No more BLM memorials to show'),
                duration: Duration(seconds: 1),
                backgroundColor: Color(0xff4EC9D4),
              ),
            );
          }
        }
      });
    }
  }

  void initState(){
    super.initState();
    isGuest();
    toggle = newToggle;
  }

  @override
  Widget build(BuildContext context) {
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
        child: Scaffold(
          appBar: AppBar(
            flexibleSpace: Row(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(icon: Icon(Icons.arrow_back, color: Color(0xffffffff),), onPressed: (){Navigator.pop(context);},),
                ),

                Expanded(
                  child: Container(
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      onChanged: (search){
                        if(search == ''){
                          onSearch = false;
                          searchFeeds = [];
                          searchSuggested = [];
                          searchNearby = [];
                          searchBlm = [];
                        }
                      },
                      onFieldSubmitted: (search){
                        if(search == ''){
                          setState(() {
                            onSearch = false;
                            searchFeeds = [];
                            searchSuggested = [];
                            searchNearby = [];
                            searchBlm = [];
                          });
                        }else{
                          if(toggle == 0){
                            for(int i = 0; i < feeds.length; i++){
                              if(feeds[i].memorialName.toUpperCase().contains(search.toUpperCase()) && onSearch == false){
                                print('The ${feeds[i].memorialName} contains $search');
                                searchFeeds.add(feeds[i]);
                              }
                            }
                          }else if(toggle == 1){
                            for(int i = 0; i < suggested.length; i++){
                              if(suggested[i].memorialName.toUpperCase().contains(search.toUpperCase()) && onSearch == false){
                                print('The ${suggested[i].memorialName} contains $search');
                                searchSuggested.add(suggested[i]);
                              }
                            }
                          }else if(toggle == 2){
                            for(int i = 0; i < nearby.length; i++){
                              if(nearby[i].memorialName.toUpperCase().contains(search.toUpperCase()) && onSearch == false){
                                print('The ${nearby[i].memorialName} contains $search');
                                searchNearby.add(nearby[i]);
                              }
                            }
                          }else if(toggle == 3){
                            for(int i = 0; i < blm.length; i++){
                              if(blm[i].memorialName.toUpperCase().contains(search.toUpperCase()) && onSearch == false){
                                print('The ${blm[i].memorialName} contains $search');
                                searchBlm.add(blm[i]);
                              }
                            }
                          }

                          setState(() {
                            onSearch = true;
                          });
                        }
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(15.0),
                        filled: true,
                        fillColor: Color(0xffffffff),
                        focusColor: Color(0xffffffff),
                        hintText: 'Search Memorial',
                        hintStyle: TextStyle(
                          fontSize: 14,
                        ),
                        prefixIcon: Icon(Icons.search, color: Colors.grey),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffffffff)),
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                        ),
                        enabledBorder:  OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffffffff)),
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                        ),
                        focusedBorder:  OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffffffff)),
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 20,),
              ],
            ),
            leading: Container(),
            backgroundColor: Color(0xff04ECFF),
          ),
          body: Stack(
            children: [
              SingleChildScrollView(physics: NeverScrollableScrollPhysics(), child: Container(height: SizeConfig.screenHeight, child: MiscBLMBackgroundTemplate(image: AssetImage('assets/icons/background2.png'),),),),

              Column(
                children: [

                  IgnorePointer(
                    ignoring: isGuestLoggedIn,
                    child: Container(
                      alignment: Alignment.center,
                      height: 55,
                      color: Color(0xffffffff),
                      child: DefaultTabController(
                        length: 4,
                        child: TabBar(
                          isScrollable: true,
                          labelColor: Color(0xff04ECFF),
                          unselectedLabelColor: Color(0xff000000),
                          indicatorColor: Color(0xff04ECFF),
                          onTap: (int number){
                            setState(() {
                              toggle = number;
                              searchFeeds = [];
                              searchSuggested = [];
                              searchNearby = [];
                              searchBlm = [];
                            });
                          },
                          tabs: [

                            Center(
                              child: Text('Post',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),

                            Center(
                              child: Text('Suggested',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),

                            Center(
                              child: Text('Nearby',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),

                            Center(
                              child: Text('BLM',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  Container(
                    child: ((){
                      switch(toggle){
                        case 0: return Container(height: 20,);
                        case 1: return Container(height: 20,);
                        case 2: return 
                        Container(
                          height: 40,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                SizedBox(width: 20,),

                                Icon(Icons.location_pin, color: Color(0xff979797),),

                                SizedBox(width: 20,),

                                ((){
                                  if(currentLocation != ''){
                                    return Text(currentLocation, style: TextStyle(color: Color(0xff000000), fontSize: 12),);
                                  }else{
                                    return Text('', style: TextStyle(color: Color(0xff000000), fontSize: 12,),);
                                  }
                                }()),
                              ],
                            ),
                          ),
                        );
                        case 3: return 
                        Container(
                          height: 40,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                SizedBox(width: 20,),

                                Icon(Icons.location_pin, color: Color(0xff979797),),

                                SizedBox(width: 20,),

                                ((){
                                  if(currentLocation != ''){
                                    return Text(currentLocation, style: TextStyle(color: Color(0xff000000), fontSize: 12,),);
                                  }else{
                                    return Text('', style: TextStyle(color: Color(0xff000000), fontSize: 12,),);
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
                    child: Container(
                      child: isGuestLoggedIn
                      ? BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                        child: MiscBLMLoginToContinue(),
                      )
                      : ((){
                        switch(toggle){
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
            ],
          ),
        ),
      ),
    );
  }

  searchPostExtended(){
    return tabCount1 != 0
    ? RefreshIndicator(
      onRefresh: onRefresh1,
      child: onSearch != true
      ? ListView.separated(
        controller: scrollController1,
        padding: EdgeInsets.all(10.0),
        physics: ClampingScrollPhysics(),
        itemCount: feeds.length,
        separatorBuilder: (c, i) => Divider(height: 10, color: Colors.transparent),
        itemBuilder: (c, i) {
          return feeds[i].pageType == 'Blm'
          ? MiscBLMPost(
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
            contents: [
              Container(alignment: Alignment.centerLeft, child: Text(feeds[i].postBody, overflow: TextOverflow.ellipsis, maxLines: 5,),),

              feeds[i].imagesOrVideos.isNotEmpty
              ? Column(
                children: [
                  SizedBox(height: 20),

                  Container(
                    child: ((){
                      if(feeds[i].imagesOrVideos.length == 1){
                        if(lookupMimeType(feeds[i].imagesOrVideos[0])?.contains('video') == true){
                          return BetterPlayer.network('${feeds[i].imagesOrVideos[0]}',
                            betterPlayerConfiguration: BetterPlayerConfiguration(
                              controlsConfiguration: BetterPlayerControlsConfiguration(
                                showControls: false,
                              ),
                              aspectRatio: 16 / 9,
                            ),
                          );
                        }else{
                          return CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: feeds[i].imagesOrVideos[0],
                            placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                            errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                          );
                        }
                      }else if(feeds[i].imagesOrVideos.length == 2){
                        return StaggeredGridView.countBuilder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          crossAxisCount: 4,
                          itemCount: 2,
                          itemBuilder: (BuildContext context, int index) =>  
                            lookupMimeType(feeds[i].imagesOrVideos[index])?.contains('video') == true
                            ? BetterPlayer.network('${feeds[i].imagesOrVideos[index]}',
                              betterPlayerConfiguration: BetterPlayerConfiguration(
                                controlsConfiguration: BetterPlayerControlsConfiguration(
                                  showControls: false,
                                ),
                                aspectRatio: 16 / 9,
                              ),
                            )
                            : CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: feeds[i].imagesOrVideos[index],
                              placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                              errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                            ),
                          staggeredTileBuilder: (int index) => StaggeredTile.count(2, 2),
                          mainAxisSpacing: 4.0,
                          crossAxisSpacing: 4.0,
                        );
                      }else{
                        return StaggeredGridView.countBuilder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          crossAxisCount: 4,
                          itemCount: 3,
                          staggeredTileBuilder: (int index) => StaggeredTile.count(2, index.isEven ? 1 : 2),
                          mainAxisSpacing: 4.0,
                          crossAxisSpacing: 4.0,
                          itemBuilder: (BuildContext context, int index) => ((){
                            if(index != 1){
                              return lookupMimeType(feeds[i].imagesOrVideos[index])?.contains('video') == true
                              ? BetterPlayer.network('${feeds[i].imagesOrVideos[index]}',
                                betterPlayerConfiguration: BetterPlayerConfiguration(
                                  controlsConfiguration: BetterPlayerControlsConfiguration(
                                    showControls: false,
                                  ),
                                  aspectRatio: 16 / 9,
                                ),
                              )
                              : CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl: feeds[i].imagesOrVideos[index],
                                placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
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
                                            controlsConfiguration: BetterPlayerControlsConfiguration(
                                              showControls: false,
                                            ),
                                            aspectRatio: 16 / 9,
                                          ),
                                        ),

                                        Container(color: Colors.black.withOpacity(0.5),),

                                        Center(
                                          child: CircleAvatar(
                                            radius: 25,
                                            backgroundColor: Color(0xffffffff).withOpacity(.5),
                                            child: Text(
                                              '${feeds[i].imagesOrVideos.length - 3}',
                                              style: TextStyle(
                                                fontSize: 40,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xffffffff),
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
                                          placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                                          errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                        ),

                                        Container(color: Colors.black.withOpacity(0.5),),

                                        Center(
                                          child: CircleAvatar(
                                            radius: 25,
                                            backgroundColor: Color(0xffffffff).withOpacity(.5),
                                            child: Text(
                                              '${feeds[i].imagesOrVideos.length - 3}',
                                              style: TextStyle(
                                                fontSize: 40,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xffffffff),
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
                                      betterPlayerConfiguration: BetterPlayerConfiguration(
                                        controlsConfiguration: BetterPlayerControlsConfiguration(
                                          showControls: false,
                                        ),
                                        aspectRatio: 16 / 9,
                                      ),
                                    );
                                  }else{
                                    return CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      imageUrl: feeds[i].imagesOrVideos[index],
                                      placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
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
            contents: [
              Container(alignment: Alignment.centerLeft, child: Text(feeds[i].postBody, overflow: TextOverflow.ellipsis, maxLines: 5,),),

              feeds[i].imagesOrVideos.isNotEmpty
              ? Column(
                children: [
                  SizedBox(height: 20),

                  Container(
                    child: ((){
                      if(feeds[i].imagesOrVideos.length == 1){
                        if(lookupMimeType(feeds[i].imagesOrVideos[0])?.contains('video') == true){
                          return BetterPlayer.network('${feeds[i].imagesOrVideos[0]}',
                            betterPlayerConfiguration: BetterPlayerConfiguration(
                              controlsConfiguration: BetterPlayerControlsConfiguration(
                                showControls: false,
                              ),
                              aspectRatio: 16 / 9,
                            ),
                          );
                        }else{
                          return CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: feeds[i].imagesOrVideos[0],
                            placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                            errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                          );
                        }
                      }else if(feeds[i].imagesOrVideos.length == 2){
                        return StaggeredGridView.countBuilder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          crossAxisCount: 4,
                          itemCount: 2,
                          itemBuilder: (BuildContext context, int index) =>  
                            lookupMimeType(feeds[i].imagesOrVideos[index])?.contains('video') == true
                            ? BetterPlayer.network('${feeds[i].imagesOrVideos[index]}',
                              betterPlayerConfiguration: BetterPlayerConfiguration(
                                controlsConfiguration: BetterPlayerControlsConfiguration(
                                  showControls: false,
                                ),
                                aspectRatio: 16 / 9,
                              ),
                            )
                            : CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: feeds[i].imagesOrVideos[index],
                              placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                              errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                            ),
                          staggeredTileBuilder: (int index) => StaggeredTile.count(2, 2),
                          mainAxisSpacing: 4.0,
                          crossAxisSpacing: 4.0,
                        );
                      }else{
                        return StaggeredGridView.countBuilder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          crossAxisCount: 4,
                          itemCount: 3,
                          staggeredTileBuilder: (int index) => StaggeredTile.count(2, index.isEven ? 1 : 2),
                          mainAxisSpacing: 4.0,
                          crossAxisSpacing: 4.0,
                          itemBuilder: (BuildContext context, int index) => ((){
                            if(index != 1){
                              return lookupMimeType(feeds[i].imagesOrVideos[index])?.contains('video') == true
                              ? BetterPlayer.network('${feeds[i].imagesOrVideos[index]}',
                                betterPlayerConfiguration: BetterPlayerConfiguration(
                                  controlsConfiguration: BetterPlayerControlsConfiguration(
                                    showControls: false,
                                  ),
                                  aspectRatio: 16 / 9,
                                ),
                              )
                              : CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl: feeds[i].imagesOrVideos[index],
                                placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
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
                                            controlsConfiguration: BetterPlayerControlsConfiguration(
                                              showControls: false,
                                            ),
                                            aspectRatio: 16 / 9,
                                          ),
                                        ),

                                        Container(color: Colors.black.withOpacity(0.5),),

                                        Center(
                                          child: CircleAvatar(
                                            radius: 25,
                                            backgroundColor: Color(0xffffffff).withOpacity(.5),
                                            child: Text(
                                              '${feeds[i].imagesOrVideos.length - 3}',
                                              style: TextStyle(
                                                fontSize: 40,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xffffffff),
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
                                          placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                                          errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                        ),

                                        Container(color: Colors.black.withOpacity(0.5),),

                                        Center(
                                          child: CircleAvatar(
                                            radius: 25,
                                            backgroundColor: Color(0xffffffff).withOpacity(.5),
                                            child: Text(
                                              '${feeds[i].imagesOrVideos.length - 3}',
                                              style: TextStyle(
                                                fontSize: 40,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xffffffff),
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
                                      betterPlayerConfiguration: BetterPlayerConfiguration(
                                        controlsConfiguration: BetterPlayerControlsConfiguration(
                                          showControls: false,
                                        ),
                                        aspectRatio: 16 / 9,
                                      ),
                                    );
                                  }else{
                                    return CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      imageUrl: feeds[i].imagesOrVideos[index],
                                      placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
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
      )
       : ListView.separated(
        controller: scrollController1,
        padding: EdgeInsets.all(10.0),
        physics: ClampingScrollPhysics(),
        itemCount: searchFeeds.length,
        separatorBuilder: (c, i) => Divider(height: 10, color: Colors.transparent),
        itemBuilder: (c, i) {
          return searchFeeds[i].pageType == 'Blm'
          ? MiscBLMPost(
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
            contents: [
              Container(alignment: Alignment.centerLeft, child: Text(searchFeeds[i].postBody, overflow: TextOverflow.ellipsis, maxLines: 5,),),

              searchFeeds[i].imagesOrVideos.isNotEmpty
              ? Column(
                children: [
                  SizedBox(height: 20),

                  Container(
                    child: ((){
                      if(searchFeeds[i].imagesOrVideos.length == 1){
                        if(lookupMimeType(searchFeeds[i].imagesOrVideos[0])?.contains('video') == true){
                          return BetterPlayer.network('${searchFeeds[i].imagesOrVideos[0]}',
                            betterPlayerConfiguration: BetterPlayerConfiguration(
                              controlsConfiguration: BetterPlayerControlsConfiguration(
                                showControls: false,
                              ),
                              aspectRatio: 16 / 9,
                            ),
                          );
                        }else{
                          return CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: searchFeeds[i].imagesOrVideos[0],
                            placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                            errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                          );
                        }
                      }else if(searchFeeds[i].imagesOrVideos.length == 2){
                        return StaggeredGridView.countBuilder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          crossAxisCount: 4,
                          itemCount: 2,
                          itemBuilder: (BuildContext context, int index) =>  
                            lookupMimeType(searchFeeds[i].imagesOrVideos[index])?.contains('video') == true
                            ? BetterPlayer.network('${searchFeeds[i].imagesOrVideos[index]}',
                              betterPlayerConfiguration: BetterPlayerConfiguration(
                                controlsConfiguration: BetterPlayerControlsConfiguration(
                                  showControls: false,
                                ),
                                aspectRatio: 16 / 9,
                              ),
                            )
                            : CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: searchFeeds[i].imagesOrVideos[index],
                              placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                              errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                            ),
                          staggeredTileBuilder: (int index) => StaggeredTile.count(2, 2),
                          mainAxisSpacing: 4.0,
                          crossAxisSpacing: 4.0,
                        );
                      }else{
                        return StaggeredGridView.countBuilder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          crossAxisCount: 4,
                          itemCount: 3,
                          staggeredTileBuilder: (int index) => StaggeredTile.count(2, index.isEven ? 1 : 2),
                          mainAxisSpacing: 4.0,
                          crossAxisSpacing: 4.0,
                          itemBuilder: (BuildContext context, int index) => ((){
                            if(index != 1){
                              return lookupMimeType(searchFeeds[i].imagesOrVideos[index])?.contains('video') == true
                              ? BetterPlayer.network('${searchFeeds[i].imagesOrVideos[index]}',
                                betterPlayerConfiguration: BetterPlayerConfiguration(
                                  controlsConfiguration: BetterPlayerControlsConfiguration(
                                    showControls: false,
                                  ),
                                  aspectRatio: 16 / 9,
                                ),
                              )
                              : CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl: searchFeeds[i].imagesOrVideos[index],
                                placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
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
                                            controlsConfiguration: BetterPlayerControlsConfiguration(
                                              showControls: false,
                                            ),
                                            aspectRatio: 16 / 9,
                                          ),
                                        ),

                                        Container(color: Colors.black.withOpacity(0.5),),

                                        Center(
                                          child: CircleAvatar(
                                            radius: 25,
                                            backgroundColor: Color(0xffffffff).withOpacity(.5),
                                            child: Text(
                                              '${searchFeeds[i].imagesOrVideos.length - 3}',
                                              style: TextStyle(
                                                fontSize: 40,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xffffffff),
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
                                          imageUrl: searchFeeds[i].imagesOrVideos[index],
                                          placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                                          errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                        ),

                                        Container(color: Colors.black.withOpacity(0.5),),

                                        Center(
                                          child: CircleAvatar(
                                            radius: 25,
                                            backgroundColor: Color(0xffffffff).withOpacity(.5),
                                            child: Text(
                                              '${searchFeeds[i].imagesOrVideos.length - 3}',
                                              style: TextStyle(
                                                fontSize: 40,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xffffffff),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                                }else{
                                  if(lookupMimeType(searchFeeds[i].imagesOrVideos[index])?.contains('video') == true){
                                    return BetterPlayer.network('${searchFeeds[i].imagesOrVideos[index]}',
                                      betterPlayerConfiguration: BetterPlayerConfiguration(
                                        controlsConfiguration: BetterPlayerControlsConfiguration(
                                          showControls: false,
                                        ),
                                        aspectRatio: 16 / 9,
                                      ),
                                    );
                                  }else{
                                    return CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      imageUrl: searchFeeds[i].imagesOrVideos[index],
                                      placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
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
            contents: [
              Container(alignment: Alignment.centerLeft, child: Text(searchFeeds[i].postBody, overflow: TextOverflow.ellipsis, maxLines: 5,),),

              searchFeeds[i].imagesOrVideos.isNotEmpty
              ? Column(
                children: [
                  SizedBox(height: 20),

                  Container(
                    child: ((){
                      if(searchFeeds[i].imagesOrVideos.length == 1){
                        if(lookupMimeType(searchFeeds[i].imagesOrVideos[0])?.contains('video') == true){
                          return BetterPlayer.network('${searchFeeds[i].imagesOrVideos[0]}',
                            betterPlayerConfiguration: BetterPlayerConfiguration(
                              controlsConfiguration: BetterPlayerControlsConfiguration(
                                showControls: false,
                              ),
                              aspectRatio: 16 / 9,
                            ),
                          );
                        }else{
                          return CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: searchFeeds[i].imagesOrVideos[0],
                            placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                            errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                          );
                        }
                      }else if(searchFeeds[i].imagesOrVideos.length == 2){
                        return StaggeredGridView.countBuilder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          crossAxisCount: 4,
                          itemCount: 2,
                          itemBuilder: (BuildContext context, int index) =>  
                            lookupMimeType(searchFeeds[i].imagesOrVideos[index])?.contains('video') == true
                            ? BetterPlayer.network('${searchFeeds[i].imagesOrVideos[index]}',
                              betterPlayerConfiguration: BetterPlayerConfiguration(
                                controlsConfiguration: BetterPlayerControlsConfiguration(
                                  showControls: false,
                                ),
                                aspectRatio: 16 / 9,
                              ),
                            )
                            : CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: searchFeeds[i].imagesOrVideos[index],
                              placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                              errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                            ),
                          staggeredTileBuilder: (int index) => StaggeredTile.count(2, 2),
                          mainAxisSpacing: 4.0,
                          crossAxisSpacing: 4.0,
                        );
                      }else{
                        return StaggeredGridView.countBuilder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          crossAxisCount: 4,
                          itemCount: 3,
                          staggeredTileBuilder: (int index) => StaggeredTile.count(2, index.isEven ? 1 : 2),
                          mainAxisSpacing: 4.0,
                          crossAxisSpacing: 4.0,
                          itemBuilder: (BuildContext context, int index) => ((){
                            if(index != 1){
                              return lookupMimeType(searchFeeds[i].imagesOrVideos[index])?.contains('video') == true
                              ? BetterPlayer.network('${searchFeeds[i].imagesOrVideos[index]}',
                                betterPlayerConfiguration: BetterPlayerConfiguration(
                                  controlsConfiguration: BetterPlayerControlsConfiguration(
                                    showControls: false,
                                  ),
                                  aspectRatio: 16 / 9,
                                ),
                              )
                              : CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl: searchFeeds[i].imagesOrVideos[index],
                                placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
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
                                            controlsConfiguration: BetterPlayerControlsConfiguration(
                                              showControls: false,
                                            ),
                                            aspectRatio: 16 / 9,
                                          ),
                                        ),

                                        Container(color: Colors.black.withOpacity(0.5),),

                                        Center(
                                          child: CircleAvatar(
                                            radius: 25,
                                            backgroundColor: Color(0xffffffff).withOpacity(.5),
                                            child: Text(
                                              '${searchFeeds[i].imagesOrVideos.length - 3}',
                                              style: TextStyle(
                                                fontSize: 40,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xffffffff),
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
                                          imageUrl: searchFeeds[i].imagesOrVideos[index],
                                          placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                                          errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                        ),

                                        Container(color: Colors.black.withOpacity(0.5),),

                                        Center(
                                          child: CircleAvatar(
                                            radius: 25,
                                            backgroundColor: Color(0xffffffff).withOpacity(.5),
                                            child: Text(
                                              '${searchFeeds[i].imagesOrVideos.length - 3}',
                                              style: TextStyle(
                                                fontSize: 40,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xffffffff),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                                }else{
                                  if(lookupMimeType(searchFeeds[i].imagesOrVideos[index])?.contains('video') == true){
                                    return BetterPlayer.network('${searchFeeds[i].imagesOrVideos[index]}',
                                      betterPlayerConfiguration: BetterPlayerConfiguration(
                                        controlsConfiguration: BetterPlayerControlsConfiguration(
                                          showControls: false,
                                        ),
                                        aspectRatio: 16 / 9,
                                      ),
                                    );
                                  }else{
                                    return CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      imageUrl: searchFeeds[i].imagesOrVideos[index],
                                      placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
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
      physics: ClampingScrollPhysics(),
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            SizedBox(height: (SizeConfig.screenHeight! - 55 - kToolbarHeight) / 4,),

            Image.asset('assets/icons/app-icon.png', height: 250, width: 250,),

            SizedBox(height: 45,),

            Text('Post is empty', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xffB1B1B1),),),

            SizedBox(height: (SizeConfig.screenHeight! - 55 - kToolbarHeight) / 4,),
          ],
        ),
      ),
    );
  }

  searchSuggestedExtended(){
    return tabCount2 != 0
    ? RefreshIndicator(
      onRefresh: onRefresh2,
      child: onSearch != true
      ? ListView.separated(
        controller: scrollController2,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
        physics: ClampingScrollPhysics(),
        itemCount: suggested.length,
        separatorBuilder: (c, i) => Divider(height: 10, color: Colors.transparent),
        itemBuilder: (c, i) => 
          MiscBLMManageMemorialTab(
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
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
        physics: ClampingScrollPhysics(),
        itemCount: searchSuggested.length,
        separatorBuilder: (c, i) => Divider(height: 10, color: Colors.transparent),
        itemBuilder: (c, i) => 
          MiscBLMManageMemorialTab(
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
      physics: ClampingScrollPhysics(),
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            SizedBox(height: (SizeConfig.screenHeight! - 75 - kToolbarHeight) / 4,),

            Image.asset('assets/icons/app-icon.png', height: 250, width: 250,),

            SizedBox(height: 45,),

            Text('Suggested is empty', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xffB1B1B1),),),

            SizedBox(height: (SizeConfig.screenHeight! - 75 - kToolbarHeight) / 4,),
          ],
        ),
      ),
    );
  }

  searchNearbyExtended(){
    return tabCount3 != 0
    ? RefreshIndicator(
      onRefresh: onRefresh3,
      child: onSearch != true
      ? ListView.separated(
        controller: scrollController3,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
        physics: ClampingScrollPhysics(),
        itemCount: nearby.length,
        separatorBuilder: (c, i) => Divider(height: 10, color: Colors.transparent),
        itemBuilder: (c, i) => 
          MiscBLMManageMemorialTab(
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
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
        physics: ClampingScrollPhysics(),
        itemCount: searchNearby.length,
        separatorBuilder: (c, i) => Divider(height: 10, color: Colors.transparent),
        itemBuilder: (c, i) => 
          MiscBLMManageMemorialTab(
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
      physics: ClampingScrollPhysics(),
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            SizedBox(height: (SizeConfig.screenHeight! - 75 - kToolbarHeight) / 4,),

            Image.asset('assets/icons/app-icon.png', height: 250, width: 250,),

            SizedBox(height: 45,),

            Text('Nearby is empty', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xffB1B1B1),),),

            SizedBox(height: (SizeConfig.screenHeight! - 75 - kToolbarHeight) / 4,),
          ],
        ),
      ),
    );
  }

  searchBLMExtended(){
    return tabCount4 != 0
    ? RefreshIndicator(
      onRefresh: onRefresh3,
      child: onSearch != true
      ? ListView.separated(
        controller: scrollController3,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
        physics: ClampingScrollPhysics(),
        itemCount: blm.length,
        separatorBuilder: (c, i) => Divider(height: 10, color: Colors.transparent),
        itemBuilder: (c, i) => 
        MiscBLMManageMemorialTab(
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
        controller: scrollController3,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
        physics: ClampingScrollPhysics(),
        itemCount: searchBlm.length,
        separatorBuilder: (c, i) => Divider(height: 10, color: Colors.transparent),
        itemBuilder: (c, i) => 
        MiscBLMManageMemorialTab(
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
      physics: ClampingScrollPhysics(),
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            SizedBox(height: (SizeConfig.screenHeight! - 75 - kToolbarHeight) / 4,),

            Image.asset('assets/icons/app-icon.png', height: 250, width: 250,),

            SizedBox(height: 45,),

            Text('BLM is empty', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xffB1B1B1),),),

            SizedBox(height: (SizeConfig.screenHeight! - 75 - kToolbarHeight) / 4,),
          ],
        ),
      ),
    );
  }
}