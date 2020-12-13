import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-04-blm-manage-memorial.dart';
import 'package:facesbyplaces/API/BLM/api-07-02-blm-home-memorials-tab.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter/material.dart';

class BLMMainPagesMemorials{
  int memorialId;
  String memorialName;
  String memorialDescription;
  bool managed;

  BLMMainPagesMemorials({this.memorialId, this.memorialName, this.memorialDescription, this.managed});
}

class HomeBLMManageTab extends StatefulWidget{

  HomeBLMManageTabState createState() => HomeBLMManageTabState();
}

class HomeBLMManageTabState extends State<HomeBLMManageTab>{

  RefreshController refreshController = RefreshController(initialRefresh: true);
  List<BLMMainPagesMemorials> memorialsFamily;
  List<BLMMainPagesMemorials> memorialsFriends;
  int blmFamilyItemsRemaining;
  int blmFriendsItemsRemaining;
  int page1;
  int page2;

  void initState(){
    super.initState();
    memorialsFamily = [];
    memorialsFriends = [];
    blmFamilyItemsRemaining = 1;
    blmFriendsItemsRemaining = 1;
    page1 = 1;
    page2 = 1;
    onLoading1();
    onLoading2();
  }

  void onRefresh() async{
    await Future.delayed(Duration(milliseconds: 1000));
    refreshController.refreshCompleted();
  }

  void onLoading1() async{
    
    if(blmFamilyItemsRemaining != 0){
      context.showLoaderOverlay();
      var newValue = await apiBLMHomeMemorialsTab(page1);
      context.hideLoaderOverlay();
      blmFamilyItemsRemaining = newValue.familyMemorialList.blmFamilyItemsRemaining;

      for(int i = 0; i < newValue.familyMemorialList.blm.length; i++){
        memorialsFamily.add(
          BLMMainPagesMemorials(
            memorialId: newValue.familyMemorialList.blm[i].id,
            memorialName: newValue.familyMemorialList.blm[i].name,
            memorialDescription: newValue.familyMemorialList.blm[i].details.description,
            managed: newValue.familyMemorialList.blm[i].managed,
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
    
    if(blmFriendsItemsRemaining != 0){
      context.showLoaderOverlay();
      var newValue = await apiBLMHomeMemorialsTab(page2);
      context.hideLoaderOverlay();
      blmFriendsItemsRemaining = newValue.friendsMemorialList.blmFriendsItemsRemaining;

      for(int i = 0; i < newValue.friendsMemorialList.blm.length; i++){
        memorialsFriends.add(
          BLMMainPagesMemorials(
            memorialId: newValue.friendsMemorialList.blm[i].id,
            memorialName: newValue.friendsMemorialList.blm[i].name,
            memorialDescription: newValue.friendsMemorialList.blm[i].details.description
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
                  child: GestureDetector(
                    onTap: (){
                      Navigator.pushNamed(context, '/home/blm/home-07-01-blm-create-memorial');
                    },
                    child: Align(alignment: Alignment.centerRight, child: Text('Create', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, fontWeight: FontWeight.bold, color: Color(0xff000000),),),),
                  ),
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
                    body = Text('Pull up load.', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
                  }
                  else if(mode == LoadStatus.loading){
                    body = CircularProgressIndicator();
                  }
                  else if(mode == LoadStatus.failed){
                    body = Text('Load Failed! Please try again.', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
                  }
                  else if(mode == LoadStatus.canLoading){
                    body = Text('Release to load more.', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
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
                  var container = MiscBLMManageMemorialTab(
                    index: i,
                    memorialId: memorialsFamily[i].memorialId, 
                    memorialName: memorialsFamily[i].memorialName, 
                    description: memorialsFamily[i].memorialDescription,
                    managed: memorialsFamily[i].managed
                  );

                  return container;
                  
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
                  return Container(height: 55.0, child: Center(child: body),);
                },
              ),
              controller: refreshController,
              onRefresh: onRefresh,
              onLoading: onLoading2,
              child: ListView.separated(
                padding: EdgeInsets.all(10.0),
                physics: ClampingScrollPhysics(),
                itemBuilder: (c, i) {
                  var container = MiscBLMManageMemorialTab(
                    index: i,
                    memorialId: memorialsFriends[i].memorialId, 
                    memorialName: memorialsFriends[i].memorialName, 
                    description: memorialsFriends[i].memorialDescription,
                  );

                  return container;
                },
                separatorBuilder: (c, i) => Divider(height: SizeConfig.blockSizeVertical * 2, color: Colors.transparent),
                itemCount: memorialsFriends.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


