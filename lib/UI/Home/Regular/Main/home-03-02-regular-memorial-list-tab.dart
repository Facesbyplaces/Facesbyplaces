import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-01-regular-manage-memorial.dart';
import 'package:facesbyplaces/API/Regular/api-07-02-regular-home-memorials-tab.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter/material.dart';

class RegularMainPagesMemorials{
  int memorialId;
  String memorialName;
  String memorialDescription;

  RegularMainPagesMemorials({this.memorialId, this.memorialName, this.memorialDescription});
}


class HomeRegularManageTab extends StatefulWidget{

  HomeRegularManageTabState createState() => HomeRegularManageTabState();
}

class HomeRegularManageTabState extends State<HomeRegularManageTab>{

  RefreshController refreshController = RefreshController(initialRefresh: true);
  List<RegularMainPagesMemorials> memorialsFamily;
  List<RegularMainPagesMemorials> memorialsFriends;
  int memorialFamilyItemsRemaining;
  int memorialFriendsItemsRemaining;
  int page1;
  int page2;

  void initState(){
    super.initState();
    memorialsFamily = [];
    memorialsFriends = [];
    memorialFamilyItemsRemaining = 1;
    memorialFriendsItemsRemaining = 1;
    page1 = 1;
    page2 = 1;
    onLoading1();
  }

  
  void onRefresh() async{
    await Future.delayed(Duration(milliseconds: 1000));
    refreshController.refreshCompleted();
  }

  void onLoading1() async{
    if(memorialFamilyItemsRemaining != 0){
      context.showLoaderOverlay();
      var newValue = await apiRegularHomeMemorialsTab(page1);
      context.hideLoaderOverlay();

      memorialFamilyItemsRemaining = newValue.familyMemorialList.memorialFamilyItemsRemaining;

      for(int i = 0; i < newValue.familyMemorialList.memorial.length; i++){
        memorialsFamily.add(
          RegularMainPagesMemorials(
            memorialId: newValue.familyMemorialList.memorial[i].id,
            memorialName: newValue.familyMemorialList.memorial[i].name,
            memorialDescription: newValue.familyMemorialList.memorial[i].details.description
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
    if(memorialFriendsItemsRemaining != 0){
      context.showLoaderOverlay();
      var newValue = await apiRegularHomeMemorialsTab(page2);
      context.hideLoaderOverlay();

      memorialFriendsItemsRemaining = newValue.friendsMemorialList.memorialFriendsItemsRemaining;

      for(int i = 0; i < newValue.familyMemorialList.memorial.length; i++){
        memorialsFriends.add(
          RegularMainPagesMemorials(
            memorialId: newValue.friendsMemorialList.memorial[i].id,
            memorialName: newValue.friendsMemorialList.memorial[i].name,
            memorialDescription: newValue.friendsMemorialList.memorial[i].details.description
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

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Container(
      height: SizeConfig.screenHeight - SizeConfig.blockSizeVertical * 13 - AppBar().preferredSize.height,
      child: Column(
        children: [
          Container(
            height: SizeConfig.blockSizeVertical * 10,
            padding: EdgeInsets.only(left: 20.0, right: 20.0),
            color: Color(0xffeeeeee),
            child: Row(
              children: [
                Expanded(child: Align(alignment: Alignment.centerLeft, child: Text('My Family', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, fontWeight: FontWeight.bold, color: Color(0xff000000),),),),),
                
                Expanded(
                  child: GestureDetector(onTap: (){Navigator.pushNamed(context, '/home/regular/home-04-01-regular-create-memorial');},
                  child: Align(alignment: Alignment.centerRight, child: Text('Create', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, fontWeight: FontWeight.bold, color: Color(0xff000000),),),),),
                ),
              ],
            ),
          ),

          Expanded(
            child: SmartRefresher(
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
                    body = Text('No more memorials.', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
                  }
                  return Container(height: 55.0, child: Center(child: body),);
                },
              ),
              controller: refreshController,
              onRefresh: onRefresh,
              onLoading: onLoading1,
              child: ListView.separated(
                physics: ClampingScrollPhysics(),
                itemBuilder: (c, i) {
                  var container = MiscRegularManageMemorialTab(
                    index: i,
                    memorialId: memorialsFamily[i].memorialId, 
                    memorialName: memorialsFamily[i].memorialName, 
                    description: memorialsFamily[i].memorialDescription);

                  if(memorialsFamily.length != 0){
                    return container;
                  }else{
                    return Center(child: Text('Feed is empty.'),);
                  }
                  
                },
                separatorBuilder: (c, i) => Divider(height: SizeConfig.blockSizeVertical * 1, color: Colors.transparent),
                itemCount: memorialsFamily.length,
              ),
            ),
          ),

          Container(
            height: SizeConfig.blockSizeVertical * 10,
            padding: EdgeInsets.only(left: 20.0, right: 20.0),
            color: Color(0xffeeeeee),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('My Friends',
                style: TextStyle(
                  fontSize: SizeConfig.safeBlockHorizontal * 4,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff000000),
                ),
              ),
            ),
          ),

          Expanded(
            child: SmartRefresher(
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
                    body = Text('No more memorials.', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
                  }
                  return Container(
                    height: 55.0,
                    child: Center(child: body),
                  );
                },
              ),
              controller: refreshController,
              onRefresh: onRefresh,
              onLoading: onLoading2,
              child: ListView.separated(
                physics: ClampingScrollPhysics(),
                itemBuilder: (c, i) {
                  var container = MiscRegularManageMemorialTab(
                    index: i,
                    memorialId: memorialsFriends[i].memorialId, 
                    memorialName: memorialsFriends[i].memorialName, 
                    description: memorialsFriends[i].memorialDescription);

                  if(memorialsFriends.length != 0){
                    return container;
                  }else{
                    return Center(child: Text('Feed is empty.'),);
                  }
                  
                },
                separatorBuilder: (c, i) => Divider(height: SizeConfig.blockSizeVertical * 1, color: Colors.transparent),
                itemCount: memorialsFriends.length,
              ),
            ),
          ),          
        ],
      ),
    );
  }
}


