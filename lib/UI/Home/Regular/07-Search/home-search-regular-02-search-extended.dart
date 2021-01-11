import 'package:facesbyplaces/API/Regular/08-Search/api-search-regular-01-search-suggested.dart';
import 'package:facesbyplaces/API/Regular/08-Search/api-search-regular-02-search-nearby.dart';
import 'package:facesbyplaces/API/Regular/08-Search/api-search-regular-03-search-posts.dart';
import 'package:facesbyplaces/API/Regular/08-Search/api-search-regular-04-search-blm.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-01-regular-manage-memorial.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-10-regular-background.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-13-regular-post.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-19-regular-empty-display.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/material.dart';

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

  RegularSearchMainPosts({this.userId, this.postId, this.memorialId, this.memorialName, this.timeCreated, this.postBody, this.profileImage, this.imagesOrVideos, this.managed, this.follower, this.numberOfLikes, this.numberOfComments, this.likeStatus, this.numberOfTagged, this.taggedFirstName, this.taggedLastName, this.taggedImage, this.taggedId});
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

  void onRefresh() async{
    await Future.delayed(Duration(milliseconds: 1000));
    refreshController.refreshCompleted();
  }

  void onLoading1() async{

    if(postItemRemaining != 0){
      var newValue = await apiRegularSearchPosts(keywords: keyword, page: page1);
      postItemRemaining = newValue.itemsRemaining;
      tabCount1 = tabCount1 + newValue.searchPostList.length;

      List<String> newList1 = [];
      List<String> newList2 = [];
      List<String> newList3 = [];
      List<int> newList4 = [];

      for(int i = 0; i < newValue.searchPostList.length; i++){
        for(int j = 0; j < newValue.searchPostList[i].postTagged.length; j++){
          newList1.add(newValue.searchPostList[i].postTagged[j].taggedFirstName);
          newList2.add(newValue.searchPostList[i].postTagged[j].taggedLastName);
          newList3.add(newValue.searchPostList[i].postTagged[j].taggedImage);
          newList4.add(newValue.searchPostList[i].postTagged[j].taggedId);
        }
        
        feeds.add(RegularSearchMainPosts(
          userId: newValue.searchPostList[i].page.pageCreator.creatorId, 
          postId: newValue.searchPostList[i].postId,
          memorialId: newValue.searchPostList[i].page.pageId,
          timeCreated: newValue.searchPostList[i].createAt,
          memorialName: newValue.searchPostList[i].page.name,
          postBody: newValue.searchPostList[i].body,
          profileImage: newValue.searchPostList[i].page.profileImage,
          imagesOrVideos: newValue.searchPostList[i].imagesOrVideos,

          managed: newValue.searchPostList[i].page.manage,
          follower: newValue.searchPostList[i].page.follower,
          numberOfComments: newValue.searchPostList[i].numberOfComments,
          numberOfLikes: newValue.searchPostList[i].numberOfLikes,
          likeStatus: newValue.searchPostList[i].likeStatus,

          numberOfTagged: newValue.searchPostList[i].postTagged.length,
          taggedFirstName: newList1,
          taggedLastName: newList2,
          taggedImage: newList3,
          taggedId: newList4,
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
      suggestedItemRemaining = newValue.itemsRemaining;
      tabCount2 = tabCount2 + newValue.pages.length;

      for(int i = 0; i < newValue.pages.length; i++){
        suggested.add(RegularSearchMainSuggested(
          memorialId: newValue.pages[i].page.id,
          memorialName: newValue.pages[i].page.name,
          memorialDescription: newValue.pages[i].page.details.description,
          image: newValue.pages[i].page.profileImage,
          managed: newValue.pages[i].page.manage,
          follower: newValue.pages[i].page.follower,
          pageType: newValue.pages[i].page.pageType,
          famOrFriends: newValue.pages[i].page.famOrFriends,
          relationship: newValue.pages[i].page.relationship,
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
        nearby.add(RegularSearchMainNearby(
          memorialId: newValue.blmList[i].id,
          memorialName: newValue.blmList[i].name,
          memorialDescription: newValue.blmList[i].details.description,
          image: newValue.blmList[i].profileImage,
          managed: newValue.blmList[i].manage,
          follower: newValue.blmList[i].follower,
          pageType: newValue.blmList[i].pageType,
          famOrFriends: newValue.blmList[i].famOrFriends,
          relationship: newValue.blmList[i].relationship,
          ),    
        );
      }

      if(mounted)
      setState(() {});
      page3++;
      
      refreshController.loadComplete();
    }
    else if(nearbyMemorialItemsRemaining != 0){

      var newValue = await apiRegularSearchNearby(page: page3, latitude: latitude, longitude: longitude);
      nearbyMemorialItemsRemaining = newValue.memorialItemsRemaining;
      tabCount3 = tabCount3 + newValue.memorialList.length;
      
      for(int i = 0; i < newValue.memorialList.length; i++){
        nearby.add(RegularSearchMainNearby(
          memorialId: newValue.memorialList[i].id,
          memorialName: newValue.memorialList[i].name,
          memorialDescription: newValue.memorialList[i].details.description,
          image: newValue.blmList[i].profileImage,
          managed: newValue.blmList[i].manage,
          follower: newValue.blmList[i].follower,
          pageType: newValue.blmList[i].pageType,
          famOrFriends: newValue.blmList[i].famOrFriends,
          relationship: newValue.blmList[i].relationship,
          ),    
        );
      }

      if(mounted)
      setState(() {});
      page3++;
      
      refreshController.loadComplete();
    }
    else{
      refreshController.loadNoData();
    }
  } 

  void onLoading4() async{
    if(blmItemRemaining != 0){
      var newValue = await apiRegularSearchBLM(keywords: keyword);
      blmItemRemaining = newValue.itemsRemaining;
      tabCount4 = tabCount4 + newValue.memorialList.length;

      for(int i = 0; i < newValue.memorialList.length; i++){
        blm.add(RegularSearchMainBLM(
          memorialId: newValue.memorialList[i].page.id,
          memorialName: newValue.memorialList[i].page.name,
          memorialDescription: newValue.memorialList[i].page.details.description,
          image: newValue.memorialList[i].page.profileImage,
          managed: newValue.memorialList[i].page.manage,
          follower: newValue.memorialList[i].page.follower,
          pageType: newValue.memorialList[i].page.pageType,
          famOrFriends: newValue.memorialList[i].page.famOrFriends,
          relationship: newValue.memorialList[i].page.relationship,
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

  void initState(){
    super.initState();
    toggle = newToggle;
    onLoading1();
    onLoading2();
    onLoading3();
    onLoading4();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    ResponsiveWidgets.init(context,
      height: SizeConfig.screenHeight,
      width: SizeConfig.screenWidth,
    );
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
                        fontSize: ScreenUtil().setSp(14, allowFontScalingSelf: true),
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
                    height: ScreenUtil().setHeight(55),
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
                                fontSize: ScreenUtil().setSp(14, allowFontScalingSelf: true),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),

                          Center(child: Text('Suggested',
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(14, allowFontScalingSelf: true),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),

                          Center(
                            child: Text('Nearby',
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(14, allowFontScalingSelf: true),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),

                          Center(
                            child: Text('BLM',
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(14, allowFontScalingSelf: true),
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
                        case 0: return Container(height: SizeConfig.blockSizeVertical * 2,); break;
                        case 1: return Container(height: SizeConfig.blockSizeVertical * 2,); break;
                        case 2: return 
                        Container(
                          height: SizeConfig.blockSizeVertical * 5,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                SizedBox(width: SizeConfig.blockSizeHorizontal * 2,),

                                Icon(Icons.location_pin, color: Color(0xff979797),),

                                SizedBox(width: SizeConfig.blockSizeHorizontal * 2,),

                                ((){
                                  if(currentLocation != null || currentLocation != ''){
                                    return Text(currentLocation, style: TextStyle(color: Color(0xff000000), fontSize: ScreenUtil().setSp(12, allowFontScalingSelf: true),),);
                                  }else{
                                    return Text('', style: TextStyle(color: Color(0xff000000), fontSize: ScreenUtil().setSp(12, allowFontScalingSelf: true),),);
                                  }
                                }()),
                              ],
                            ),
                          ),
                        ); break;
                        case 3: return 
                        Container(
                          height: SizeConfig.blockSizeVertical * 5,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                SizedBox(width: SizeConfig.blockSizeHorizontal * 2,),

                                Icon(Icons.location_pin, color: Color(0xff979797),),

                                SizedBox(width: SizeConfig.blockSizeHorizontal * 2,),

                                ((){
                                  if(currentLocation != null || currentLocation != ''){
                                    return Text(currentLocation, style: TextStyle(color: Color(0xff000000), fontSize: ScreenUtil().setSp(12, allowFontScalingSelf: true),),);
                                  }else{
                                    return Text('', style: TextStyle(color: Color(0xff000000), fontSize: ScreenUtil().setSp(12, allowFontScalingSelf: true),),);
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
      height: SizeConfig.screenHeight - SizeConfig.blockSizeVertical * 13 - AppBar().preferredSize.height,
      child: tabCount1 != 0
      ? SmartRefresher(
        enablePullDown: false,
        enablePullUp: true,
        header: MaterialClassicHeader(),
        footer: CustomFooter(
          loadStyle: LoadStyle.ShowWhenLoading,
          builder: (BuildContext context, LoadStatus mode){
            Widget body;
            if(mode == LoadStatus.idle){
              body =  Text('Pull up to load', style: TextStyle(fontSize: ScreenUtil().setSp(14, allowFontScalingSelf: true), color: Color(0xff000000),),);
            }
            else if(mode == LoadStatus.loading){
              body =  CircularProgressIndicator();
            }
            else if(mode == LoadStatus.failed){
              body = Text('Load Failed! Click retry!', style: TextStyle(fontSize: ScreenUtil().setSp(14, allowFontScalingSelf: true), color: Color(0xff000000),),);
            }
            else if(mode == LoadStatus.canLoading){
              body = Text('Release to load more', style: TextStyle(fontSize: ScreenUtil().setSp(14, allowFontScalingSelf: true), color: Color(0xff000000),),);
            }
            else{
              body = Text('No more feed.', style: TextStyle(fontSize: ScreenUtil().setSp(14, allowFontScalingSelf: true), color: Color(0xff000000),),);
            }
            return Container(height: 55.0, child: Center(child: body),);
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
              contents: [
                Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: RichText(
                        maxLines: 4,
                        overflow: TextOverflow.clip,
                        textAlign: TextAlign.left,
                        text: TextSpan(
                          text: feeds[i].postBody,
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            color: Color(0xff000000),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: SizeConfig.blockSizeVertical * 1,),
                  ],
                ),

                feeds[i].imagesOrVideos != null
                ? Container(
                  height: SizeConfig.blockSizeHorizontal * 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: feeds[i].imagesOrVideos[0],
                    placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                )
                : Container(height: 0,),
              ],
            );
          },
          separatorBuilder: (c, i) => Divider(height: SizeConfig.blockSizeVertical * 2, color: Colors.transparent),
          itemCount: feeds.length,
        ),
      )
      : ContainerResponsive(
        height: SizeConfig.screenHeight,
        width: SizeConfig.screenWidth,
        alignment: Alignment.center,
        child: ContainerResponsive(
          width: SizeConfig.screenWidth,
          height: SizeConfig.screenHeight + ScreenUtil().setHeight(55),
          heightResponsive: false,
          widthResponsive: true,
          alignment: Alignment.center,
          child: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: MiscRegularEmptyDisplayTemplate(message: 'Post is empty',),
          ),
        ),
      ),
    );
  }

  searchSuggestedExtended(){
    return Container(
      height: SizeConfig.screenHeight - SizeConfig.blockSizeVertical * 13 - AppBar().preferredSize.height,
      child: tabCount2 != 0
      ? SmartRefresher(
        enablePullDown: false,
        enablePullUp: true,
        header: MaterialClassicHeader(),
        footer: CustomFooter(
          loadStyle: LoadStyle.ShowWhenLoading,
          builder: (BuildContext context, LoadStatus mode){
            Widget body;
            if(mode == LoadStatus.idle){
              body = Text('Pull up to load', style: TextStyle(fontSize: ScreenUtil().setSp(14, allowFontScalingSelf: true), color: Color(0xff000000),),);
            }
            else if(mode == LoadStatus.loading){
              body = CircularProgressIndicator();
            }
            else if(mode == LoadStatus.failed){
              body = Text('Load Failed! Click retry!', style: TextStyle(fontSize: ScreenUtil().setSp(14, allowFontScalingSelf: true), color: Color(0xff000000),),);
            }
            else if(mode == LoadStatus.canLoading){
              body = Text('Release to load more', style: TextStyle(fontSize: ScreenUtil().setSp(14, allowFontScalingSelf: true), color: Color(0xff000000),),);
            }
            else{
              body = Text('No more feed.', style: TextStyle(fontSize: ScreenUtil().setSp(14, allowFontScalingSelf: true), color: Color(0xff000000),),);
            }
            return Container(height: 55.0, child: Center(child: body),);
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
          separatorBuilder: (c, i) => Divider(height: SizeConfig.blockSizeVertical * .5, color: Colors.transparent),
          itemCount: suggested.length,
        ),
      )
      : ContainerResponsive(
        height: SizeConfig.screenHeight,
        width: SizeConfig.screenWidth,
        alignment: Alignment.center,
        child: ContainerResponsive(
          width: SizeConfig.screenWidth,
          height: SizeConfig.screenHeight + ScreenUtil().setHeight(55),
          heightResponsive: false,
          widthResponsive: true,
          alignment: Alignment.center,
          child: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: MiscRegularEmptyDisplayTemplate(message: 'Suggested is empty',),
          ),
        ),
      ),
    );
  }

  searchNearbyExtended(){
    return Container(
      height: SizeConfig.screenHeight - SizeConfig.blockSizeVertical * 13 - AppBar().preferredSize.height,
      child: tabCount3 != 0
      ? SmartRefresher(
        enablePullDown: false,
        enablePullUp: true,
        header: MaterialClassicHeader(),
        footer: CustomFooter(
          loadStyle: LoadStyle.ShowWhenLoading,
          builder: (BuildContext context, LoadStatus mode){
            Widget body ;
            if(mode == LoadStatus.idle){
              body = Text('Pull up to load', style: TextStyle(fontSize: ScreenUtil().setSp(14, allowFontScalingSelf: true), color: Color(0xff000000),),);
            }
            else if(mode == LoadStatus.loading){
              body =  CircularProgressIndicator();
            }
            else if(mode == LoadStatus.failed){
              body = Text('Load Failed! Click retry!', style: TextStyle(fontSize: ScreenUtil().setSp(14, allowFontScalingSelf: true), color: Color(0xff000000),),);
            }
            else if(mode == LoadStatus.canLoading){
              body = Text('Release to load more', style: TextStyle(fontSize: ScreenUtil().setSp(14, allowFontScalingSelf: true), color: Color(0xff000000),),);
            }
            else{
              body = Text('No more feed.', style: TextStyle(fontSize: ScreenUtil().setSp(14, allowFontScalingSelf: true), color: Color(0xff000000),),);
            }
            return Container(height: 55.0, child: Center(child: body),);
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
          separatorBuilder: (c, i) => Divider(height: SizeConfig.blockSizeVertical * .5, color: Colors.transparent),
          itemCount: nearby.length,
        ),
      )
      : ContainerResponsive(
        height: SizeConfig.screenHeight,
        width: SizeConfig.screenWidth,
        alignment: Alignment.center,
        child: ContainerResponsive(
          width: SizeConfig.screenWidth,
          height: SizeConfig.screenHeight + ScreenUtil().setHeight(55),
          heightResponsive: false,
          widthResponsive: true,
          alignment: Alignment.center,
          child: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: MiscRegularEmptyDisplayTemplate(message: 'Nearby is empty',),
          ),
        ),
      ),
    );
  }

  searchBLMExtended(){
    return Container(
      height: SizeConfig.screenHeight - SizeConfig.blockSizeVertical * 13 - AppBar().preferredSize.height,
      child: tabCount4 != 0
      ? SmartRefresher(
        enablePullDown: false,
        enablePullUp: true,
        header: MaterialClassicHeader(),
        footer: CustomFooter(
          loadStyle: LoadStyle.ShowWhenLoading,
          builder: (BuildContext context, LoadStatus mode){
            Widget body ;
            if(mode == LoadStatus.idle){
              body = Text('Pull up to load', style: TextStyle(fontSize: ScreenUtil().setSp(14, allowFontScalingSelf: true), color: Color(0xff000000),),);
            }
            else if(mode == LoadStatus.loading){
              body =  CircularProgressIndicator();
            }
            else if(mode == LoadStatus.failed){
              body = Text('Load Failed! Click retry!', style: TextStyle(fontSize: ScreenUtil().setSp(14, allowFontScalingSelf: true), color: Color(0xff000000),),);
            }
            else if(mode == LoadStatus.canLoading){
              body = Text('Release to load more', style: TextStyle(fontSize: ScreenUtil().setSp(14, allowFontScalingSelf: true), color: Color(0xff000000),),);
            }
            else{
              body = Text('No more feed.', style: TextStyle(fontSize: ScreenUtil().setSp(14, allowFontScalingSelf: true), color: Color(0xff000000),),);
            }
            return Container(height: 55.0, child: Center(child: body),);
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
          separatorBuilder: (c, i) => Divider(height: SizeConfig.blockSizeVertical * .5, color: Colors.transparent),
          itemCount: blm.length,
        ),
      )
      : ContainerResponsive(
        height: SizeConfig.screenHeight,
        width: SizeConfig.screenWidth,
        alignment: Alignment.center,
        child: ContainerResponsive(
          width: SizeConfig.screenWidth,
          height: SizeConfig.screenHeight + ScreenUtil().setHeight(55),
          heightResponsive: false,
          widthResponsive: true,
          alignment: Alignment.center,
          child: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: MiscRegularEmptyDisplayTemplate(message: 'BLM is empty',),
          ),
        ),
      ),
    );
  }
}