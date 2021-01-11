import 'package:facesbyplaces/API/Regular/02-Main/api-main-regular-04-02-00-home-memorials-tab.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-01-regular-manage-memorial.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-19-regular-empty-display.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter/material.dart';

class RegularMainPagesMemorials{
  int memorialId;
  String memorialName;
  String memorialDescription;
  bool managed;
  bool joined;
  String pageType;

  RegularMainPagesMemorials({this.memorialId, this.memorialName, this.memorialDescription, this.managed, this.joined, this.pageType});
}

class HomeRegularManageTab extends StatefulWidget{

  HomeRegularManageTabState createState() => HomeRegularManageTabState();
}

class HomeRegularManageTabState extends State<HomeRegularManageTab>{

  RefreshController refreshController = RefreshController(initialRefresh: true);
  List<Widget> finalMemorials;
  int memorialFamilyItemsRemaining;
  int memorialFriendsItemsRemaining;
  int page1;
  int page2;
  bool flag1;
  int count;

  int blmFamilyItemsRemaining;
  int blmFriendsItemsRemaining;

  void initState(){
    super.initState();
    finalMemorials = [];
    memorialFamilyItemsRemaining = 1;
    memorialFriendsItemsRemaining = 1;
    page1 = 1;
    page2 = 1;
    count = 0;
    flag1 = false;

    blmFamilyItemsRemaining = 1;
    blmFriendsItemsRemaining = 1;

    addMemorials1();
    onLoading();
  }

  
  void onRefresh() async{
    await Future.delayed(Duration(milliseconds: 1000));
    refreshController.refreshCompleted();
  }

  void addMemorials1(){
    finalMemorials.add(
      Container(
        height: 80,
        padding: EdgeInsets.only(left: 20.0, right: 20.0),
        color: Color(0xffeeeeee),
        child: Row(
          children: [
            Expanded(child: Align(alignment: Alignment.centerLeft, child: Text('My Family', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xff000000),),),),),
            
            Expanded(
              child: GestureDetector(
                onTap: (){
                  Navigator.pushNamed(context, '/home/regular/create-memorial');
                },
              child: Align(alignment: Alignment.centerRight, child: Text('Create', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xff000000),),),),),
            ),
          ],
        ),
      ),
    );
  }


  void addMemorials2(){
    finalMemorials.add(
      Container(
        height: 80,
        padding: EdgeInsets.only(left: 20.0, right: 20.0),
        color: Color(0xffeeeeee),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text('My Friends',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xff000000),
            ),
          ),
        ),
      ),
    );
  }


  void onLoading() async{

    if(flag1 == false){
      onLoading1();
    }else{
      onLoading2();
    }
  }

  void onLoading1() async{

    if(memorialFamilyItemsRemaining != 0){
      context.showLoaderOverlay();
      var newValue = await apiRegularHomeMemorialsTab(page: page1);
      context.hideLoaderOverlay();

      memorialFamilyItemsRemaining = newValue.familyMemorialList.memorialFamilyItemsRemaining;
      count = count + newValue.familyMemorialList.memorial.length;

      for(int i = 0; i < newValue.familyMemorialList.memorial.length; i++){
        finalMemorials.add(
          MiscRegularManageMemorialTab(
            index: i,
            memorialName: newValue.familyMemorialList.memorial[i].name,
            description: newValue.familyMemorialList.memorial[i].details.description,
            image: newValue.familyMemorialList.memorial[i].profileImage,
            memorialId: newValue.familyMemorialList.memorial[i].id, 
            managed: newValue.familyMemorialList.memorial[i].manage,
            follower: newValue.familyMemorialList.memorial[i].follower,
            famOrFriends: newValue.familyMemorialList.memorial[i].famOrFriends,
            pageType: newValue.familyMemorialList.memorial[i].pageType,
            relationship: newValue.familyMemorialList.memorial[i].relationship,
          ),
        );
      }

      if(mounted)
      setState(() {});
      page1++;

      // if(memorialFamilyItemsRemaining == 0){
      //   addMemorials2();
      //   setState(() {
      //     flag1 = true;
      //   });
      //   onLoading();
      // }

      // refreshController.loadComplete();
      
    }

    page1 = 1;

    if(blmFamilyItemsRemaining != 0){
      context.showLoaderOverlay();
      var newValue = await apiRegularHomeMemorialsTab(page: page1);
      context.hideLoaderOverlay();

      blmFamilyItemsRemaining = newValue.familyMemorialList.blmFamilyItemsRemaining;
      count = count + newValue.familyMemorialList.blm.length;

      for(int i = 0; i < newValue.familyMemorialList.blm.length; i++){
        finalMemorials.add(
          MiscRegularManageMemorialTab(
            index: i,
            memorialName: newValue.familyMemorialList.blm[i].name,
            description: newValue.familyMemorialList.blm[i].details.description,
            image: newValue.familyMemorialList.blm[i].profileImage,
            memorialId: newValue.familyMemorialList.blm[i].id, 
            managed: newValue.familyMemorialList.blm[i].manage,
            follower: newValue.familyMemorialList.blm[i].follower,
            famOrFriends: newValue.familyMemorialList.blm[i].famOrFriends,
            pageType: newValue.familyMemorialList.blm[i].pageType,
            relationship: newValue.familyMemorialList.blm[i].relationship,
          ),
        );
      }

      if(mounted)
      setState(() {});
      page1++;

      // if(blmFamilyItemsRemaining == 0){
      //   addMemorials2();
      //   setState(() {
      //     flag1 = true;
      //   });
      //   onLoading();
      // }

      // refreshController.loadComplete();

      if(blmFamilyItemsRemaining == 0){
        addMemorials2();
        setState(() {
          flag1 = true;
        });
        onLoading();
      }
      
    }
    
    
    // else{
    //   refreshController.loadNoData();
    // }



      refreshController.loadComplete();

  }

  void onLoading2() async{

    if(memorialFriendsItemsRemaining != 0){
      context.showLoaderOverlay();
      var newValue = await apiRegularHomeMemorialsTab(page: page2);
      context.hideLoaderOverlay();

      memorialFriendsItemsRemaining = newValue.friendsMemorialList.memorialFriendsItemsRemaining;
      count = count + newValue.friendsMemorialList.memorial.length;

      

      for(int i = 0; i < newValue.friendsMemorialList.memorial.length; i++){
        finalMemorials.add(
          MiscRegularManageMemorialTab(
            index: i,
            memorialName: newValue.friendsMemorialList.memorial[i].name,
            description: newValue.friendsMemorialList.memorial[i].details.description,
            image: newValue.friendsMemorialList.memorial[i].profileImage,
            memorialId: newValue.friendsMemorialList.memorial[i].id, 
            managed: newValue.friendsMemorialList.memorial[i].manage,
            follower: newValue.friendsMemorialList.memorial[i].follower,
            famOrFriends: newValue.friendsMemorialList.memorial[i].famOrFriends,
            pageType: newValue.friendsMemorialList.memorial[i].pageType,
            relationship: newValue.friendsMemorialList.memorial[i].relationship,
          ),
        );
      }

      if(mounted)
      setState(() {});
      page2++;

      // refreshController.loadComplete();
    }

    page2 = 1;

    if(blmFriendsItemsRemaining != 0){
      context.showLoaderOverlay();
      var newValue = await apiRegularHomeMemorialsTab(page: page2);
      context.hideLoaderOverlay();

      blmFriendsItemsRemaining = newValue.friendsMemorialList.blmFriendsItemsRemaining;
      count = count + newValue.friendsMemorialList.blm.length;

      for(int i = 0; i < newValue.friendsMemorialList.blm.length; i++){
        finalMemorials.add(
          MiscRegularManageMemorialTab(
            index: i,
            memorialName: newValue.friendsMemorialList.blm[i].name,
            description: newValue.friendsMemorialList.blm[i].details.description,
            image: newValue.friendsMemorialList.blm[i].profileImage,
            memorialId: newValue.friendsMemorialList.blm[i].id, 
            managed: newValue.friendsMemorialList.blm[i].manage,
            follower: newValue.friendsMemorialList.blm[i].follower,
            famOrFriends: newValue.friendsMemorialList.blm[i].famOrFriends,
            pageType: newValue.friendsMemorialList.blm[i].pageType,
            relationship: newValue.friendsMemorialList.blm[i].relationship,
          ),
        );
      }

      if(mounted)
      setState(() {});
      page2++;

      // refreshController.loadComplete();
    }
    
    // else{
    //   refreshController.loadNoData();
    // }

    refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    ResponsiveWidgets.init(context,
      height: SizeConfig.screenHeight,
      width: SizeConfig.screenWidth,
    );
    return Container(
      height: SizeConfig.screenHeight - SizeConfig.blockSizeVertical * 13 - AppBar().preferredSize.height,
      child: count != 0
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
              body = Text('No more memorials.', style: TextStyle(fontSize: ScreenUtil().setSp(14, allowFontScalingSelf: true), color: Color(0xff000000),),);
            }
            return Container(height: 55.0, child: Center(child: body),);
          },
        ),
        controller: refreshController,
        onRefresh: onRefresh,
        onLoading: onLoading,
        child: ListView.separated(
          physics: ClampingScrollPhysics(),
          itemBuilder: (c, i) {
            return finalMemorials[i];
          },
          separatorBuilder: (c, i) => Divider(height: SizeConfig.blockSizeVertical * 1, color: Colors.transparent),
          itemCount: finalMemorials.length,
        ),
      )
      : ContainerResponsive(
        height: SizeConfig.screenHeight,
        width: SizeConfig.screenWidth,
        alignment: Alignment.center,
        child: ContainerResponsive(
          width: SizeConfig.screenWidth,
          heightResponsive: false,
          widthResponsive: true,
          alignment: Alignment.center,
          child: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: MiscRegularEmptyDisplayTemplate(message: 'Memorial is empty',),
          ),
        ),
      ),
    );
  }
}
