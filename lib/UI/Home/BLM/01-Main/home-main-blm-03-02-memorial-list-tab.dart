import 'package:facesbyplaces/API/BLM/02-Main/api-main-blm-04-02-00-home-memorials-tab.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-04-blm-manage-memorial.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-16-blm-empty-display.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter/material.dart';

class BLMMainPagesMemorials{
  int blmId;
  String blmName;
  String blmDescription;
  bool managed;
  bool joined;
  String pageType;

  BLMMainPagesMemorials({this.blmId, this.blmName, this.blmDescription, this.managed, this.joined, this.pageType});
}

class HomeBLMManageTab extends StatefulWidget{

  HomeBLMManageTabState createState() => HomeBLMManageTabState();
}

class HomeBLMManageTabState extends State<HomeBLMManageTab>{

  RefreshController refreshController = RefreshController(initialRefresh: true);
  List<Widget> finalMemorials;
  int blmFamilyItemsRemaining;
  int blmFriendsItemsRemaining;
  int page1;
  int page2;
  bool flag1;
  int count;

  int memorialFamilyItemsRemaining;
  int memorialFriendsItemsRemaining;

  void initState(){
    super.initState();
    finalMemorials = [];
    blmFamilyItemsRemaining = 1;
    blmFriendsItemsRemaining = 1;
    page1 = 1;
    page2 = 1;
    count = 0;
    flag1 = false;
    
    memorialFamilyItemsRemaining = 1;
    memorialFriendsItemsRemaining = 1;

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
                  Navigator.pushNamed(context, '/home/blm/create-memorial');
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

    if(blmFamilyItemsRemaining != 0){
      context.showLoaderOverlay();
      var newValue = await apiBLMHomeMemorialsTab(page: page1);
      context.hideLoaderOverlay();

      blmFamilyItemsRemaining = newValue.familyMemorialList.blmFamilyItemsRemaining;
      count = count + newValue.familyMemorialList.blm.length;

      for(int i = 0; i < newValue.familyMemorialList.blm.length; i++){
        finalMemorials.add(
          MiscBLMManageMemorialTab(
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
      
    }

    page1 = 1;

    if(memorialFamilyItemsRemaining != 0){
      context.showLoaderOverlay();
      var newValue = await apiBLMHomeMemorialsTab(page: page1);
      context.hideLoaderOverlay();

      memorialFamilyItemsRemaining = newValue.familyMemorialList.memorialFamilyItemsRemaining;
      count = count + newValue.familyMemorialList.memorial.length;

      for(int i = 0; i < newValue.familyMemorialList.memorial.length; i++){
        finalMemorials.add(
          MiscBLMManageMemorialTab(
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

      if(memorialFamilyItemsRemaining == 0){
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
    
    // else{
    //   refreshController.loadNoData();
    // }

    // addMemorials2();
    // setState(() {
    //   flag1 = true;
    // });

    refreshController.loadComplete();

  }

  void onLoading2() async{

    if(blmFriendsItemsRemaining != 0){
      context.showLoaderOverlay();
      var newValue = await apiBLMHomeMemorialsTab(page: page2);
      context.hideLoaderOverlay();

      blmFriendsItemsRemaining = newValue.friendsMemorialList.blmFriendsItemsRemaining;
      count = count + newValue.friendsMemorialList.blm.length;

      for(int i = 0; i < newValue.friendsMemorialList.blm.length; i++){
        finalMemorials.add(
          MiscBLMManageMemorialTab(
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

    // print('The page is $page2');
    page2 = 1;

    if(memorialFriendsItemsRemaining != 0){
      context.showLoaderOverlay();
      var newValue = await apiBLMHomeMemorialsTab(page: page2);
      context.hideLoaderOverlay();

      memorialFriendsItemsRemaining = newValue.friendsMemorialList.memorialFriendsItemsRemaining;
      count = count + newValue.friendsMemorialList.memorial.length;

      print('The length of friends memorial is ${newValue.friendsMemorialList.memorial.length}');

      for(int i = 0; i < newValue.friendsMemorialList.memorial.length; i++){
        finalMemorials.add(
          MiscBLMManageMemorialTab(
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
            child: MiscBLMEmptyDisplayTemplate(message: 'Memorial is empty',),
          ),
        ),
      ),
    );
  }
}
