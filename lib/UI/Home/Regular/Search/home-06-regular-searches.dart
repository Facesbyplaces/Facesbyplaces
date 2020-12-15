import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-01-regular-manage-memorial.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-13-regular-post.dart';
import 'package:facesbyplaces/API/Regular/api-26-regular-search-suggested.dart';
import 'package:facesbyplaces/API/Regular/api-27-regular-search-nearby.dart';
import 'package:facesbyplaces/API/Regular/api-28-regular-search-posts.dart';
import 'package:facesbyplaces/API/Regular/api-29-regular-search-blm.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/Configurations/date-conversion.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-19-regular-empty-display.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
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

  RegularSearchMainPosts({this.userId, this.postId, this.memorialId, this.memorialName, this.timeCreated, this.postBody, this.profileImage, this.imagesOrVideos});
}

class RegularSearchMainSuggested{
  int memorialId;
  String memorialName;
  String memorialDescription;
  bool joined;

  RegularSearchMainSuggested({this.memorialId, this.memorialName, this.memorialDescription, this.joined});
}

class RegularSearchMainNearby{
  int memorialId;
  String memorialName;
  String memorialDescription;
  bool joined;

  RegularSearchMainNearby({this.memorialId, this.memorialName, this.memorialDescription, this.joined});
}

class RegularSearchMainBLM{
  int memorialId;
  String memorialName;
  String memorialDescription;
  bool joined;

  RegularSearchMainBLM({this.memorialId, this.memorialName, this.memorialDescription, this.joined});
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
      var newValue = await apiRegularSearchPosts(keyword, page1);
      postItemRemaining = newValue.itemsRemaining;
      tabCount1 = tabCount1 + newValue.familyMemorialList.length;

      for(int i = 0; i < newValue.familyMemorialList.length; i++){
        feeds.add(RegularSearchMainPosts(
          userId: newValue.familyMemorialList[i].page.pageCreator.id, 
          postId: newValue.familyMemorialList[i].id,
          memorialId: newValue.familyMemorialList[i].page.id,
          timeCreated: newValue.familyMemorialList[i].createAt,
          memorialName: newValue.familyMemorialList[i].page.name,
          postBody: newValue.familyMemorialList[i].body,
          profileImage: newValue.familyMemorialList[i].page.profileImage,
          imagesOrVideos: newValue.familyMemorialList[i].page.imagesOrVideos,
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
      var newValue = await apiRegularSearchSuggested(page2);
      suggestedItemRemaining = newValue.itemsRemaining;
      tabCount2 = tabCount2 + newValue.pages.length;

      for(int i = 0; i < newValue.pages.length; i++){
        suggested.add(RegularSearchMainSuggested(
          memorialId: newValue.pages[i].id,
          memorialName: newValue.pages[i].page.name,
          memorialDescription: newValue.pages[i].page.details.description,
          joined: true
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

      var newValue = await apiRegularSearchNearby(page3, latitude, longitude);
      nearbyBlmItemsRemaining = newValue.blmItemsRemaining;
      tabCount3 = tabCount3 + newValue.blmList.length;

      for(int i = 0; i < newValue.blmList.length; i++){
        nearby.add(RegularSearchMainNearby(
          memorialId: newValue.blmList[i].id,
          memorialName: newValue.blmList[i].name,
          memorialDescription: newValue.blmList[i].details.description,
          joined: newValue.blmList[i].follower,
          ),    
        );
      }

      if(mounted)
      setState(() {});
      page3++;
      
      refreshController.loadComplete();
    }
    else if(nearbyMemorialItemsRemaining != 0){

      var newValue = await apiRegularSearchNearby(page3, latitude, longitude);
      nearbyMemorialItemsRemaining = newValue.memorialItemsRemaining;
      tabCount4 = tabCount4 + newValue.memorialList.length;

      for(int i = 0; i < newValue.memorialList.length; i++){
        nearby.add(RegularSearchMainNearby(
          memorialId: newValue.memorialList[i].id,
          memorialName: newValue.memorialList[i].name,
          memorialDescription: newValue.memorialList[i].details.description,
          joined: newValue.blmList[i].follower,
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
      var newValue = await apiRegularSearchBLM(keyword);
      blmItemRemaining = newValue.itemsRemaining;

      for(int i = 0; i < newValue.memorialList.length; i++){
        blm.add(RegularSearchMainBLM(
          memorialId: newValue.memorialList[i].id,
          memorialName: newValue.memorialList[i].name,
          memorialDescription: newValue.memorialList[i].details.description,
          joined: newValue.memorialList[i].follower,
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
                        fontSize: SizeConfig.safeBlockHorizontal * 4,
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
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Color(0xffffffff),), 
              onPressed: (){
                Navigator.pop(context);
              },
            ),
            backgroundColor: Color(0xff04ECFF),
          ),
          body: Container(
            decoration: BoxDecoration(image: DecorationImage(fit: BoxFit.cover, image: AssetImage('assets/icons/background2.png'), colorFilter: ColorFilter.srgbToLinearGamma(),),),
            child: Column(
              children: [

                Container(
                  alignment: Alignment.center,
                  width: SizeConfig.screenWidth,
                  height: SizeConfig.blockSizeVertical * 8,
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
                              fontSize: SizeConfig.safeBlockHorizontal * 4,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),

                        Center(child: Text('Suggested',
                            style: TextStyle(
                              fontSize: SizeConfig.safeBlockHorizontal * 4,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),

                        Center(
                          child: Text('Nearby',
                            style: TextStyle(
                              fontSize: SizeConfig.safeBlockHorizontal * 4,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),

                        Center(
                          child: Text('BLM',
                            style: TextStyle(
                              fontSize: SizeConfig.safeBlockHorizontal * 4,
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
                                  return Text(currentLocation, style: TextStyle(color: Color(0xff000000), fontSize: SizeConfig.safeBlockHorizontal * 3.5,),);
                                }else{
                                  Text('', style: TextStyle(color: Color(0xff000000), fontSize: SizeConfig.safeBlockHorizontal * 3.5,),);
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
                                  return Text(currentLocation, style: TextStyle(color: Color(0xff000000), fontSize: SizeConfig.safeBlockHorizontal * 3.5,),);
                                }else{
                                  Text('', style: TextStyle(color: Color(0xff000000), fontSize: SizeConfig.safeBlockHorizontal * 3.5,),);
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

              ],
            ),
          ),
        ),
      ),
    );
  }

  searchPostExtended(){
    return Container(
      height: SizeConfig.screenHeight,
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
              body =  Text('Pull up load', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
            }
            else if(mode == LoadStatus.loading){
              body =  CircularProgressIndicator();
            }
            else if(mode == LoadStatus.failed){
              body = Text('Load Failed! Click retry!', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
            }
            else if(mode == LoadStatus.canLoading){
              body = Text('Release to load more', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
            }
            else{
              body = Text('No more feed.', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
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
              timeCreated: convertDate(feeds[i].timeCreated),
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
      : MiscRegularEmptyDisplayTemplate(message: 'Post is empty',),
    );
  }

  searchSuggestedExtended(){
    return Container(
      height: SizeConfig.screenHeight,
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
              body = Text('Pull up load', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
            }
            else if(mode == LoadStatus.loading){
              body = CircularProgressIndicator();
            }
            else if(mode == LoadStatus.failed){
              body = Text('Load Failed! Click retry!', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
            }
            else if(mode == LoadStatus.canLoading){
              body = Text('Release to load more', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
            }
            else{
              body = Text('No more feed.', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
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
              memorialId: suggested[i].memorialId, 
              memorialName: suggested[i].memorialName, 
              description: suggested[i].memorialDescription,
              managed: suggested[i].joined,
            );
          },
          separatorBuilder: (c, i) => Divider(height: SizeConfig.blockSizeVertical * .5, color: Colors.transparent),
          itemCount: suggested.length,
        ),
      )
      : MiscRegularEmptyDisplayTemplate(message: 'Suggested is empty',),
    );
  }

  searchNearbyExtended(){
    return Container(
      height: SizeConfig.screenHeight,
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
              body =  Text('Pull up load', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
            }
            else if(mode == LoadStatus.loading){
              body =  CircularProgressIndicator();
            }
            else if(mode == LoadStatus.failed){
              body = Text('Load Failed! Click retry!', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
            }
            else if(mode == LoadStatus.canLoading){
              body = Text('Release to load more', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
            }
            else{
              body = Text('No more feed.', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
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
              memorialId: nearby[i].memorialId, 
              memorialName: nearby[i].memorialName, 
              description: nearby[i].memorialDescription,
              managed: nearby[i].joined,
            );
          },
          separatorBuilder: (c, i) => Divider(height: SizeConfig.blockSizeVertical * .5, color: Colors.transparent),
          itemCount: nearby.length,
        ),
      )
      : MiscRegularEmptyDisplayTemplate(message: 'Nearby is empty',),
    );
  }

  searchBLMExtended(){
    return Container(
      height: SizeConfig.screenHeight,
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
              body =  Text('Pull up load', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
            }
            else if(mode == LoadStatus.loading){
              body =  CircularProgressIndicator();
            }
            else if(mode == LoadStatus.failed){
              body = Text('Load Failed! Click retry!', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
            }
            else if(mode == LoadStatus.canLoading){
              body = Text('Release to load more', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
            }
            else{
              body = Text('No more feed.', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
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
              memorialId: blm[i].memorialId, 
              memorialName: blm[i].memorialName, 
              description: blm[i].memorialDescription,
              managed: blm[i].joined,
            );
          },
          separatorBuilder: (c, i) => Divider(height: SizeConfig.blockSizeVertical * .5, color: Colors.transparent),
          itemCount: blm.length,
        ),
      )
      : MiscRegularEmptyDisplayTemplate(message: 'BLM is empty',),
    );
  }
}