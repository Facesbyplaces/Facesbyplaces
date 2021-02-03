import 'package:facesbyplaces/API/Regular/02-Main/api-main-regular-04-02-00-home-memorials-tab.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-04-regular-manage-memorial.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-14-regular-empty-display.dart';
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

      memorialFamilyItemsRemaining = newValue.almFamilyMemorialList.memorialHomeTabMemorialFamilyItemsRemaining;
      count = count + newValue.almFamilyMemorialList.memorialHomeTabMemorialPage.length;

      for(int i = 0; i < newValue.almFamilyMemorialList.memorialHomeTabMemorialPage.length; i++){
        finalMemorials.add(
          MiscRegularManageMemorialTab(
            index: i,
            memorialName: newValue.almFamilyMemorialList.memorialHomeTabMemorialPage[i].blmHomeTabMemorialPageName,
            description: newValue.almFamilyMemorialList.memorialHomeTabMemorialPage[i].blmHomeTabMemorialPageDetails.blmHomeTabMemorialPageDetailsDescription,
            image: newValue.almFamilyMemorialList.memorialHomeTabMemorialPage[i].blmHomeTabMemorialPageProfileImage,
            memorialId: newValue.almFamilyMemorialList.memorialHomeTabMemorialPage[i].blmHomeTabMemorialPageId,
            managed: newValue.almFamilyMemorialList.memorialHomeTabMemorialPage[i].blmHomeTabMemorialPageManage,
            follower: newValue.almFamilyMemorialList.memorialHomeTabMemorialPage[i].blmHomeTabMemorialPageFollower,
            famOrFriends: newValue.almFamilyMemorialList.memorialHomeTabMemorialPage[i].blmHomeTabMemorialPageFamOrFriends,
            pageType: newValue.almFamilyMemorialList.memorialHomeTabMemorialPage[i].blmHomeTabMemorialPagePageType,
            relationship: newValue.almFamilyMemorialList.memorialHomeTabMemorialPage[i].blmHomeTabMemorialPageRelationship,
          ),
        );
      }

      if(mounted)
      setState(() {});
      page1++;
    }

    page1 = 1;

    if(blmFamilyItemsRemaining != 0){
      context.showLoaderOverlay();
      var newValue = await apiRegularHomeMemorialsTab(page: page1);
      context.hideLoaderOverlay();

      blmFamilyItemsRemaining = newValue.almFamilyMemorialList.blmHomeTabMemorialFamilyItemsRemaining;
      count = count + newValue.almFamilyMemorialList.blmHomeTabMemorialPage.length;

      for(int i = 0; i < newValue.almFamilyMemorialList.blmHomeTabMemorialPage.length; i++){
        finalMemorials.add(
          MiscRegularManageMemorialTab(
            index: i,
            memorialName: newValue.almFamilyMemorialList.blmHomeTabMemorialPage[i].blmHomeTabMemorialPageName,
            description: newValue.almFamilyMemorialList.blmHomeTabMemorialPage[i].blmHomeTabMemorialPageDetails.blmHomeTabMemorialPageDetailsDescription,
            image: newValue.almFamilyMemorialList.blmHomeTabMemorialPage[i].blmHomeTabMemorialPageProfileImage,
            memorialId: newValue.almFamilyMemorialList.blmHomeTabMemorialPage[i].blmHomeTabMemorialPageId,
            managed: newValue.almFamilyMemorialList.blmHomeTabMemorialPage[i].blmHomeTabMemorialPageManage,
            follower: newValue.almFamilyMemorialList.blmHomeTabMemorialPage[i].blmHomeTabMemorialPageFollower,
            famOrFriends: newValue.almFamilyMemorialList.blmHomeTabMemorialPage[i].blmHomeTabMemorialPageFamOrFriends,
            pageType: newValue.almFamilyMemorialList.blmHomeTabMemorialPage[i].blmHomeTabMemorialPagePageType,
            relationship: newValue.almFamilyMemorialList.blmHomeTabMemorialPage[i].blmHomeTabMemorialPageRelationship,
          ),
        );
      }

      if(mounted)
      setState(() {});
      page1++;

      if(blmFamilyItemsRemaining == 0){
        addMemorials2();
        setState(() {
          flag1 = true;
        });
        onLoading();
      } 
    }

    refreshController.loadComplete();
  }

  void onLoading2() async{

    if(memorialFriendsItemsRemaining != 0){
      context.showLoaderOverlay();
      var newValue = await apiRegularHomeMemorialsTab(page: page2);
      context.hideLoaderOverlay();

      memorialFriendsItemsRemaining = newValue.almFriendsMemorialList.memorialHomeTabMemorialFriendsItemsRemaining;
      count = count + newValue.almFriendsMemorialList.memorialHomeTabMemorialPage.length;

      for(int i = 0; i < newValue.almFriendsMemorialList.memorialHomeTabMemorialPage.length; i++){
        finalMemorials.add(
          MiscRegularManageMemorialTab(
            index: i,
            memorialName: newValue.almFriendsMemorialList.memorialHomeTabMemorialPage[i].blmHomeTabMemorialPageName,
            description: newValue.almFriendsMemorialList.memorialHomeTabMemorialPage[i].blmHomeTabMemorialPageDetails.blmHomeTabMemorialPageDetailsDescription,
            image: newValue.almFriendsMemorialList.memorialHomeTabMemorialPage[i].blmHomeTabMemorialPageProfileImage,
            memorialId: newValue.almFriendsMemorialList.memorialHomeTabMemorialPage[i].blmHomeTabMemorialPageId,
            managed: newValue.almFriendsMemorialList.memorialHomeTabMemorialPage[i].blmHomeTabMemorialPageManage,
            follower: newValue.almFriendsMemorialList.memorialHomeTabMemorialPage[i].blmHomeTabMemorialPageFollower,
            famOrFriends: newValue.almFriendsMemorialList.memorialHomeTabMemorialPage[i].blmHomeTabMemorialPageFamOrFriends,
            pageType: newValue.almFriendsMemorialList.memorialHomeTabMemorialPage[i].blmHomeTabMemorialPagePageType,
            relationship: newValue.almFriendsMemorialList.memorialHomeTabMemorialPage[i].blmHomeTabMemorialPageRelationship,
          ),
        );
      }

      if(mounted)
      setState(() {});
      page2++;
    }

    page2 = 1;

    if(blmFriendsItemsRemaining != 0){
      context.showLoaderOverlay();
      var newValue = await apiRegularHomeMemorialsTab(page: page2);
      context.hideLoaderOverlay();

      blmFriendsItemsRemaining = newValue.almFriendsMemorialList.blmHomeTabMemorialFriendsItemsRemaining;
      count = count + newValue.almFriendsMemorialList.blmHomeTabMemorialPage.length;

      for(int i = 0; i < newValue.almFriendsMemorialList.blmHomeTabMemorialPage.length; i++){
        finalMemorials.add(
          MiscRegularManageMemorialTab(
            index: i,
            memorialName: newValue.almFriendsMemorialList.blmHomeTabMemorialPage[i].blmHomeTabMemorialPageName,
            description: newValue.almFriendsMemorialList.blmHomeTabMemorialPage[i].blmHomeTabMemorialPageDetails.blmHomeTabMemorialPageDetailsDescription,
            image: newValue.almFriendsMemorialList.blmHomeTabMemorialPage[i].blmHomeTabMemorialPageProfileImage,
            memorialId: newValue.almFriendsMemorialList.blmHomeTabMemorialPage[i].blmHomeTabMemorialPageId,
            managed: newValue.almFriendsMemorialList.blmHomeTabMemorialPage[i].blmHomeTabMemorialPageManage,
            follower: newValue.almFriendsMemorialList.blmHomeTabMemorialPage[i].blmHomeTabMemorialPageFollower,
            famOrFriends: newValue.almFriendsMemorialList.blmHomeTabMemorialPage[i].blmHomeTabMemorialPageFamOrFriends,
            pageType: newValue.almFriendsMemorialList.blmHomeTabMemorialPage[i].blmHomeTabMemorialPagePageType,
            relationship: newValue.almFriendsMemorialList.blmHomeTabMemorialPage[i].blmHomeTabMemorialPageRelationship,
          ),
        );
      }

      if(mounted)
      setState(() {});
      page2++;
    }

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
