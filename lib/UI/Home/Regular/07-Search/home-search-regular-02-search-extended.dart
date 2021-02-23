import 'package:facesbyplaces/API/Regular/08-Search/api-search-regular-02-search-suggested.dart';
import 'package:facesbyplaces/API/Regular/08-Search/api-search-regular-03-search-nearby.dart';
import 'package:facesbyplaces/API/Regular/08-Search/api-search-regular-01-search-posts.dart';
import 'package:facesbyplaces/API/Regular/08-Search/api-search-regular-04-search-blm.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-04-regular-manage-memorial.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-08-regular-background.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-05-regular-post.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-09-regular-message.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/material.dart';
import 'dart:ui';

class RegularSearchMainPosts{
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

  RegularSearchMainPosts({this.userId, this.postId, this.memorialId, this.memorialName, this.timeCreated, this.postBody, this.profileImage, this.imagesOrVideos, this.managed, this.follower, this.numberOfLikes, this.numberOfComments, this.likeStatus, this.numberOfTagged, this.taggedFirstName, this.taggedLastName, this.taggedImage, this.taggedId, this.pageType, this.famOrFriends, this.relationship});
}

class RegularSearchMainSuggested{
  int memorialId;
  String memorialName;
  String memorialDescription;
  String image;
  bool managed;
  bool follower;
  String pageType;
  bool famOrFriends;
  String relationship;

  RegularSearchMainSuggested({this.memorialId, this.memorialName, this.memorialDescription, this.image, this.managed, this.follower, this.pageType, this.famOrFriends, this.relationship});
}

class RegularSearchMainNearby{
  int memorialId;
  String memorialName;
  String memorialDescription;
  String image;
  bool managed;
  bool follower;
  String pageType;
  bool famOrFriends;
  String relationship;

  RegularSearchMainNearby({this.memorialId, this.memorialName, this.memorialDescription, this.image, this.managed, this.follower, this.pageType, this.famOrFriends, this.relationship});
}

class RegularSearchMainBLM{
  int memorialId;
  String memorialName;
  String memorialDescription;
  String image;
  bool managed;
  bool follower;
  String pageType;
  bool famOrFriends;
  String relationship;

  RegularSearchMainBLM({this.memorialId, this.memorialName, this.memorialDescription, this.image, this.managed, this.follower, this.pageType, this.famOrFriends, this.relationship});
}

class HomeRegularPost extends StatefulWidget{
  final String keyword;
  final int newToggle;
  final double latitude;
  final double longitude;
  final String currentLocation;
  HomeRegularPost({this.keyword, this.newToggle, this.latitude, this.longitude, this.currentLocation});

  HomeRegularPostState createState() => HomeRegularPostState(keyword: keyword, newToggle: newToggle, latitude: latitude, longitude: longitude, currentLocation: currentLocation);
}

class HomeRegularPostState extends State<HomeRegularPost>{
  final String keyword;
  final int newToggle;
  final double latitude;
  final double longitude;
  final String currentLocation;
  HomeRegularPostState({this.keyword, this.newToggle, this.latitude, this.longitude, this.currentLocation});
  
  RefreshController refreshController = RefreshController(initialRefresh: true);
  List<RegularSearchMainPosts> feeds = [];
  List<RegularSearchMainSuggested> suggested = [];
  List<RegularSearchMainNearby> nearby = [];
  List<RegularSearchMainBLM> blm = [];
  int postItemRemaining = 1;
  int suggestedItemRemaining = 1;
  int nearbyBlmItemsRemaining = 1;
  int nearbyMemorialItemsRemaining = 1;
  int blmItemRemaining = 1;
  int page1 = 1;
  int page2 = 1;
  int page3 = 1;
  int page4 = 1;
  int toggle;
  int tabCount1 = 0;
  int tabCount2 = 0;
  int tabCount3 = 0;
  int tabCount4 = 0;
  bool isGuestLoggedIn;

  void onRefresh() async{
    await Future.delayed(Duration(milliseconds: 1000));
    refreshController.refreshCompleted();
  }

  void onLoading1() async{

    if(postItemRemaining != 0){
      var newValue = await apiRegularSearchPosts(keywords: keyword, page: page1);
      postItemRemaining = newValue.almItemsRemaining;
      tabCount1 = tabCount1 + newValue.almSearchPostList.length;

      for(int i = 0; i < newValue.almSearchPostList.length; i++){
        List<String> newList1 = [];
        List<String> newList2 = [];
        List<String> newList3 = [];
        List<int> newList4 = [];

        for(int j = 0; j < newValue.almSearchPostList[i].searchPostPostTagged.length; j++){
          newList1.add(newValue.almSearchPostList[i].searchPostPostTagged[j].searchPostTaggedFirstName);
          newList2.add(newValue.almSearchPostList[i].searchPostPostTagged[j].searchPostTaggedLastName);
          newList3.add(newValue.almSearchPostList[i].searchPostPostTagged[j].searchPostTaggedImage);
          newList4.add(newValue.almSearchPostList[i].searchPostPostTagged[j].searchPostTaggedId);
        }
        
        feeds.add(
          RegularSearchMainPosts(
            userId: newValue.almSearchPostList[i].searchPostPage.searchPostPagePageCreator.searchPostPageCreatorId, 
            postId: newValue.almSearchPostList[i].searchPostId,
            memorialId: newValue.almSearchPostList[i].searchPostPage.searchPostPageId,
            timeCreated: newValue.almSearchPostList[i].searchPostCreateAt,
            memorialName: newValue.almSearchPostList[i].searchPostPage.searchPostPageName,
            postBody: newValue.almSearchPostList[i].searchPostBody,
            profileImage: newValue.almSearchPostList[i].searchPostPage.searchPostPageProfileImage,
            imagesOrVideos: newValue.almSearchPostList[i].searchPostImagesOrVideos,
            managed: newValue.almSearchPostList[i].searchPostPage.searchPostPageManage,
            follower: newValue.almSearchPostList[i].searchPostPage.searchPostPageFollower,
            numberOfComments: newValue.almSearchPostList[i].searchPostNumberOfComments,
            numberOfLikes: newValue.almSearchPostList[i].searchPostNumberOfLikes,
            likeStatus: newValue.almSearchPostList[i].searchPostLikeStatus,
            numberOfTagged: newValue.almSearchPostList[i].searchPostPostTagged.length,
            taggedFirstName: newList1,
            taggedLastName: newList2,
            taggedImage: newList3,
            taggedId: newList4,
            pageType: newValue.almSearchPostList[i].searchPostPage.searchPostPagePageType,
            famOrFriends: newValue.almSearchPostList[i].searchPostPage.searchPostPageFamOrFriends,
            relationship: newValue.almSearchPostList[i].searchPostPage.searchPostPageRelationship,
          ),    
        );
      }

      if(mounted)
      setState(() {});
      page1++;
      
      refreshController.loadComplete();
    }else{
      refreshController.loadNoData();
    }
  }

  void onLoading2() async{
    if(suggestedItemRemaining != 0){
      var newValue = await apiRegularSearchSuggested(page: page2);
      suggestedItemRemaining = newValue.almItemsRemaining;
      tabCount2 = tabCount2 + newValue.almSearchSuggestedPages.length;

      for(int i = 0; i < newValue.almSearchSuggestedPages.length; i++){
        suggested.add(
          RegularSearchMainSuggested(
            memorialId: newValue.almSearchSuggestedPages[i].searchSuggestedPage.searchSuggestedPageId,
            memorialName: newValue.almSearchSuggestedPages[i].searchSuggestedPage.searchSuggestedPageName,
            memorialDescription: newValue.almSearchSuggestedPages[i].searchSuggestedPage.searchSuggestedPageDetails.searchSuggestedPageDetailsDescription,
            image: newValue.almSearchSuggestedPages[i].searchSuggestedPage.searchSuggestedPageProfileImage,
            managed: newValue.almSearchSuggestedPages[i].searchSuggestedPage.searchSuggestedPageManage,
            follower: newValue.almSearchSuggestedPages[i].searchSuggestedPage.searchSuggestedPageFollower,
            pageType: newValue.almSearchSuggestedPages[i].searchSuggestedPage.searchSuggestedPagePageType,
            famOrFriends: newValue.almSearchSuggestedPages[i].searchSuggestedPage.searchSuggestedPageFamOrFriends,
            relationship: newValue.almSearchSuggestedPages[i].searchSuggestedPage.searchSuggestedPageRelationship,
          ),    
        );
      }

      if(mounted)
      setState(() {});
      page2++;
      
      refreshController.loadComplete();
    }else{
      refreshController.loadNoData();
    }
  }
 
  void onLoading3() async{
    if(nearbyBlmItemsRemaining != 0){

      var newValue = await apiRegularSearchNearby(page: page3, latitude: latitude, longitude: longitude);
      nearbyBlmItemsRemaining = newValue.blmItemsRemaining;
      tabCount3 = tabCount3 + newValue.blmList.length;

      for(int i = 0; i < newValue.blmList.length; i++){
        nearby.add(
          RegularSearchMainNearby(
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

      var newValue = await apiRegularSearchNearby(page: page3, latitude: latitude, longitude: longitude);
      nearbyMemorialItemsRemaining = newValue.memorialItemsRemaining;
      tabCount3 = tabCount3 + newValue.memorialList.length;
      
      for(int i = 0; i < newValue.memorialList.length; i++){
        nearby.add(
          RegularSearchMainNearby(
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

    refreshController.loadComplete();
  } 

  void onLoading4() async{
    if(blmItemRemaining != 0){
      var newValue = await apiRegularSearchBLM(page: page4, keywords: keyword);
      blmItemRemaining = newValue.almItemsRemaining;
      tabCount4 = tabCount4 + newValue.almMemorialList.length;

      for(int i = 0; i < newValue.almMemorialList.length; i++){
        blm.add(
          RegularSearchMainBLM(
            memorialId: newValue.almMemorialList[i].searchBLMMemorialPage.searchBLMMemorialPageId,
            memorialName: newValue.almMemorialList[i].searchBLMMemorialPage.searchBLMMemorialPageName,
            memorialDescription: newValue.almMemorialList[i].searchBLMMemorialPage.searchBLMMemorialPageDetails.searchBLMMemorialPageDetailsDescription,
            image: newValue.almMemorialList[i].searchBLMMemorialPage.searchBLMMemorialPageProfileImage,
            managed: newValue.almMemorialList[i].searchBLMMemorialPage.searchBLMMemorialPageManage,
            follower: newValue.almMemorialList[i].searchBLMMemorialPage.searchBLMMemorialPageFollower,
            pageType: newValue.almMemorialList[i].searchBLMMemorialPage.searchBLMMemorialPagePageType,
            famOrFriends: newValue.almMemorialList[i].searchBLMMemorialPage.searchBLMMemorialPageFamOrFriends,
            relationship: newValue.almMemorialList[i].searchBLMMemorialPage.searchBLMMemorialPageRelationship,
          ),    
        );
      }

      if(mounted)
      setState(() {});
      page4++;
      
      refreshController.loadComplete();
    }else{
      refreshController.loadNoData();
    }
  }

  void isGuest() async{
    final sharedPrefs = await SharedPreferences.getInstance();
    setState(() {
      isGuestLoggedIn = sharedPrefs.getBool('user-guest-session') ?? false;
    });
    print('The value of guest login is $isGuestLoggedIn');
  }

  void initState(){
    super.initState();
    isGuestLoggedIn = false;
    isGuest();
    toggle = newToggle;
    onLoading1();
    onLoading2();
    onLoading3();
    onLoading4();
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
                Expanded(
                  flex: 2,
                  child: IconButton(icon: Icon(Icons.arrow_back, color: Color(0xffffffff),), onPressed: (){Navigator.pop(context);},),
                ),
                Container(
                  width: SizeConfig.screenWidth / 1.3,
                  child: TextFormField(
                    onChanged: (search){
                      
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
                Expanded(child: Container()),
              ],
            ),
            leading: Container(),
            backgroundColor: Color(0xff04ECFF),
          ),
          body: Stack(
            children: [
              SingleChildScrollView(child: Container(height: SizeConfig.screenHeight, child: MiscRegularBackgroundTemplate(image: AssetImage('assets/icons/background2.png'),),),),

              Column(
                children: [

                  Container(
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

                  Container(
                    child: ((){
                      switch(toggle){
                        case 0: return Container(height: 20,); break;
                        case 1: return Container(height: 20,); break;
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
                                  if(currentLocation != null || currentLocation != ''){
                                    return Text(currentLocation, style: TextStyle(color: Color(0xff000000), fontSize: 12,),);
                                  }else{
                                    return Text('', style: TextStyle(color: Color(0xff000000), fontSize: 12,),);
                                  }
                                }()),
                              ],
                            ),
                          ),
                        ); break;
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
                                  if(currentLocation != null || currentLocation != ''){
                                    return Text(currentLocation, style: TextStyle(color: Color(0xff000000), fontSize: 12,),);
                                  }else{
                                    return Text('', style: TextStyle(color: Color(0xff000000), fontSize: 12,),);
                                  }
                                }()),
                              ],
                            ),
                          ),
                        ); break;
                      }
                    }()),
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                      physics: isGuestLoggedIn ? NeverScrollableScrollPhysics() : ClampingScrollPhysics(),
                      child: Container(
                      child: ((){
                        switch(toggle){
                          case 0: return searchPostExtended(); break;
                          case 1: return searchSuggestedExtended(); break;
                          case 2: return searchNearbyExtended(); break;
                          case 3: return searchBLMExtended(); break;
                        }
                      }()),
                    ),
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
    return Container(
      height: SizeConfig.screenHeight - kToolbarHeight - 55,
      child: Stack(
        alignment: Alignment.center,
        children: [
          IgnorePointer(
            ignoring: isGuestLoggedIn,
            child: Container(
              child: tabCount1 != 0
              ? SmartRefresher(
                enablePullDown: true,
                enablePullUp: true,
                header: MaterialClassicHeader(
                  color: Color(0xffffffff),
                  backgroundColor: Color(0xff4EC9D4),
                ),
                footer: CustomFooter(
                  loadStyle: LoadStyle.ShowWhenLoading,
                  builder: (BuildContext context, LoadStatus mode){
                    Widget body;
                    if(mode == LoadStatus.loading){
                      body = CircularProgressIndicator();
                    }
                    return Center(child: body);
                  },
                ),
                controller: refreshController,
                onRefresh: onRefresh,
                onLoading: onLoading1,
                child: ListView.separated(
                  padding: EdgeInsets.all(10.0),
                  physics: ClampingScrollPhysics(),
                  itemBuilder: (c, i) {
                    return MiscRegularPost(
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

                        SizedBox(height: 45),

                        feeds[i].imagesOrVideos != null
                        ? Container(
                          height: 240,
                          child: ((){
                            if(feeds[i].imagesOrVideos != null){
                              if(feeds[i].imagesOrVideos.length == 1){
                                return Container(
                                  child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl: feeds[i].imagesOrVideos[0],
                                    placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                                    errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                  ),
                                );
                              }else if(feeds[i].imagesOrVideos.length == 2){
                                return StaggeredGridView.countBuilder(
                                  padding: EdgeInsets.zero,
                                  physics: NeverScrollableScrollPhysics(),
                                  crossAxisCount: 4,
                                  itemCount: 2,
                                  itemBuilder: (BuildContext context, int index) => 
                                    CachedNetworkImage(
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
                                return Container(
                                  child: StaggeredGridView.countBuilder(
                                    padding: EdgeInsets.zero,
                                    physics: NeverScrollableScrollPhysics(),
                                    crossAxisCount: 4,
                                    itemCount: 3,
                                    itemBuilder: (BuildContext context, int index) => 
                                      ((){
                                        if(index != 1){
                                          return CachedNetworkImage(
                                            fit: BoxFit.cover,
                                            imageUrl: feeds[i].imagesOrVideos[index],
                                            placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                                            errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                          );
                                        }else{
                                          return feeds[i].imagesOrVideos.length - 3 == 0
                                          ? CachedNetworkImage(
                                            fit: BoxFit.cover,
                                            imageUrl: feeds[i].imagesOrVideos[index],
                                            placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                                            errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                          )
                                          : Stack(
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
                                      }()),
                                    staggeredTileBuilder: (int index) => StaggeredTile.count(2, index.isEven ? 1 : 2),
                                    mainAxisSpacing: 4.0,
                                    crossAxisSpacing: 4.0,
                                  ),
                                );
                              }
                            }else{
                              return Container(height: 0,);
                            }
                          }()),
                        )
                        : Container(height: 0,),
                      ],
                    );
                  },
                  separatorBuilder: (c, i) => Divider(height: 20, color: Colors.transparent),
                  itemCount: feeds.length,
                ),
              )
              : SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      SizedBox(height: (SizeConfig.screenHeight - 55 - kToolbarHeight) / 4,),

                      Image.asset('assets/icons/app-icon.png', height: 250, width: 250,),

                      SizedBox(height: 45,),

                      Text('Post is empty', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xffB1B1B1),),),

                      SizedBox(height: (SizeConfig.screenHeight - 55 - kToolbarHeight) / 4,),
                    ],
                  ),
                ),
              ),
            ),
          ),

          isGuestLoggedIn
          ? BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: MiscRegularLoginToContinue(),
          )
          : Container(height: 0,),

        ],
      ),
    );
  }

  searchSuggestedExtended(){
    return Container(
      height: SizeConfig.screenHeight - kToolbarHeight - 75,
      child: Stack(
        alignment: Alignment.center,
        children: [
          IgnorePointer(
            ignoring: isGuestLoggedIn,
            child: Container(
              child: tabCount2 != 0
              ? SmartRefresher(
                enablePullDown: true,
                enablePullUp: true,
                header: MaterialClassicHeader(
                  color: Color(0xffffffff),
                  backgroundColor: Color(0xff4EC9D4),
                ),
                footer: CustomFooter(
                  loadStyle: LoadStyle.ShowWhenLoading,
                  builder: (BuildContext context, LoadStatus mode){
                    Widget body;
                    if(mode == LoadStatus.loading){
                      body = CircularProgressIndicator();
                    }
                    return Center(child: body);
                  },
                ),
                controller: refreshController,
                onRefresh: onRefresh,
                onLoading: onLoading2,
                child: ListView.separated(
                  physics: ClampingScrollPhysics(),
                  itemBuilder: (c, i) {
                    return MiscRegularManageMemorialTab(
                      index: i,
                      memorialName: suggested[i].memorialName,
                      description: suggested[i].memorialDescription,
                      image: suggested[i].image,
                      memorialId: suggested[i].memorialId,
                      managed: suggested[i].managed,
                      follower: suggested[i].follower,
                      pageType: suggested[i].pageType,
                      relationship: suggested[i].relationship,
                    );
                  },
                  separatorBuilder: (c, i) => Divider(height: 5, color: Colors.transparent),
                  itemCount: suggested.length,
                ),
              )
              : SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      SizedBox(height: (SizeConfig.screenHeight - 75 - kToolbarHeight) / 4,),

                      Image.asset('assets/icons/app-icon.png', height: 250, width: 250,),

                      SizedBox(height: 45,),

                      Text('Suggested is empty', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xffB1B1B1),),),

                      SizedBox(height: (SizeConfig.screenHeight - 75 - kToolbarHeight) / 4,),
                    ],
                  ),
                ),
              ),
            ),
          ),

          isGuestLoggedIn
          ? BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: MiscRegularLoginToContinue(),
          )
          : Container(height: 0,),

        ],
      ),
    );
  }

  searchNearbyExtended(){
    return Container(
      height: SizeConfig.screenHeight - kToolbarHeight - 75,
      child: Stack(
        alignment: Alignment.center,
        children: [
          IgnorePointer(
            ignoring: isGuestLoggedIn,
            child: Container(
              child: tabCount3 != 0
              ? SmartRefresher(
                enablePullDown: true,
                enablePullUp: true,
                header: MaterialClassicHeader(
                  color: Color(0xffffffff),
                  backgroundColor: Color(0xff4EC9D4),
                ),
                footer: CustomFooter(
                  loadStyle: LoadStyle.ShowWhenLoading,
                  builder: (BuildContext context, LoadStatus mode){
                    Widget body;
                    if(mode == LoadStatus.loading){
                      body = CircularProgressIndicator();
                    }
                    return Center(child: body);
                  },
                ),
                controller: refreshController,
                onRefresh: onRefresh,
                onLoading: onLoading3,
                child: ListView.separated(
                  physics: ClampingScrollPhysics(),
                  itemBuilder: (c, i) {
                    return MiscRegularManageMemorialTab(
                      index: i,
                      memorialName: nearby[i].memorialName,
                      description: nearby[i].memorialDescription,
                      image: nearby[i].image,
                      memorialId: nearby[i].memorialId,
                      managed: nearby[i].managed,
                      follower: nearby[i].follower,
                      pageType: nearby[i].pageType,
                      relationship: nearby[i].relationship,
                    );
                  },
                  separatorBuilder: (c, i) => Divider(height: 5, color: Colors.transparent),
                  itemCount: nearby.length,
                ),
              )
              : SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      SizedBox(height: (SizeConfig.screenHeight - 75 - kToolbarHeight) / 4,),

                      Image.asset('assets/icons/app-icon.png', height: 250, width: 250,),

                      SizedBox(height: 45,),

                      Text('Nearby is empty', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xffB1B1B1),),),

                      SizedBox(height: (SizeConfig.screenHeight - 75 - kToolbarHeight) / 4,),
                    ],
                  ),
                ),
              ),
            ),
          ),

          isGuestLoggedIn
          ? BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: MiscRegularLoginToContinue(),
          )
          : Container(height: 0,),
          
        ],
      ),
    );
  }

  searchBLMExtended(){
    return Container(
      height: SizeConfig.screenHeight - kToolbarHeight - 75,
      child: Stack(
        alignment: Alignment.center,
        children: [
          IgnorePointer(
            ignoring: isGuestLoggedIn,
            child: Container(
              child: tabCount4 != 0
              ? SmartRefresher(
                enablePullDown: true,
                enablePullUp: true,
                header: MaterialClassicHeader(
                  color: Color(0xffffffff),
                  backgroundColor: Color(0xff4EC9D4),
                ),
                footer: CustomFooter(
                  loadStyle: LoadStyle.ShowWhenLoading,
                  builder: (BuildContext context, LoadStatus mode){
                    Widget body;
                    if(mode == LoadStatus.loading){
                      body = CircularProgressIndicator();
                    }
                    return Center(child: body);
                  },
                ),
                controller: refreshController,
                onRefresh: onRefresh,
                onLoading: onLoading4,
                child: ListView.separated(
                  physics: ClampingScrollPhysics(),
                  itemBuilder: (c, i) {
                    return MiscRegularManageMemorialTab(
                      index: i,
                      memorialName: blm[i].memorialName,
                      description: blm[i].memorialDescription,
                      image: blm[i].image,
                      memorialId: blm[i].memorialId,
                      managed: blm[i].managed,
                      follower: blm[i].follower,
                      pageType: blm[i].pageType,
                      relationship: blm[i].relationship,
                    );
                  },
                  separatorBuilder: (c, i) => Divider(height: 5, color: Colors.transparent),
                  itemCount: blm.length,
                ),
              )
              : SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      SizedBox(height: (SizeConfig.screenHeight - 75 - kToolbarHeight) / 4,),

                      Image.asset('assets/icons/app-icon.png', height: 250, width: 250,),

                      SizedBox(height: 45,),

                      Text('BLM is empty', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xffB1B1B1),),),

                      SizedBox(height: (SizeConfig.screenHeight - 75 - kToolbarHeight) / 4,),
                    ],
                  ),
                ),
              ),
            ),
          ),

          isGuestLoggedIn
          ? BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: MiscRegularLoginToContinue(),
          )
          : Container(height: 0,),

        ],
      ),
    );
  }
}