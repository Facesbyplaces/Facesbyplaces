import 'package:facesbyplaces/API/BLM/02-Main/api-main-blm-04-02-00-home-memorials-tab.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-03-blm-manage-memorial.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter/material.dart';

class BLMMainPagesMemorials{
  int blmId;
  String blmName;
  String blmDescription;
  bool managed;
  bool joined;
  String pageType;

  BLMMainPagesMemorials({required this.blmId, required this.blmName, required this.blmDescription, required this.managed, required this.joined, required this.pageType});
}

class HomeBLMManageTab extends StatefulWidget{

  HomeBLMManageTabState createState() => HomeBLMManageTabState();
}

class HomeBLMManageTabState extends State<HomeBLMManageTab>{

  // RefreshController refreshController = RefreshController(initialRefresh: true);
  List<Widget> finalMemorials = [];
  int blmFamilyItemsRemaining = 1;
  int blmFriendsItemsRemaining = 1;
  int memorialFamilyItemsRemaining = 1;
  int memorialFriendsItemsRemaining = 1;
  int page1 = 1;
  int page2 = 1;
  bool flag1 = false;
  int count = 0;

  void initState(){
    super.initState();
    addMemorials1();
    onLoading();
  }

  // void onRefresh() async{
  //   await Future.delayed(Duration(milliseconds: 1000));
  //   refreshController.refreshCompleted();
  // }

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

      blmFamilyItemsRemaining = newValue.blmFamilyMemorialList.blmHomeTabMemorialFamilyItemsRemaining;
      count = count + newValue.blmFamilyMemorialList.blmHomeTabMemorialPage.length;

      for(int i = 0; i < newValue.blmFamilyMemorialList.blmHomeTabMemorialPage.length; i++){
        finalMemorials.add(
          MiscBLMManageMemorialTab(
            index: i,
            memorialName: newValue.blmFamilyMemorialList.blmHomeTabMemorialPage[i].blmHomeTabMemorialPageName,
            description: newValue.blmFamilyMemorialList.blmHomeTabMemorialPage[i].blmHomeTabMemorialPageDetails.blmHomeTabMemorialPageDetailsDescription,
            image: newValue.blmFamilyMemorialList.blmHomeTabMemorialPage[i].blmHomeTabMemorialPageProfileImage,
            memorialId: newValue.blmFamilyMemorialList.blmHomeTabMemorialPage[i].blmHomeTabMemorialPageId,
            managed: newValue.blmFamilyMemorialList.blmHomeTabMemorialPage[i].blmHomeTabMemorialPageManage,
            follower: newValue.blmFamilyMemorialList.blmHomeTabMemorialPage[i].blmHomeTabMemorialPageFollower,
            famOrFriends: newValue.blmFamilyMemorialList.blmHomeTabMemorialPage[i].blmHomeTabMemorialPageFamOrFriends,
            pageType: newValue.blmFamilyMemorialList.blmHomeTabMemorialPage[i].blmHomeTabMemorialPagePageType,
            relationship: newValue.blmFamilyMemorialList.blmHomeTabMemorialPage[i].blmHomeTabMemorialPageRelationship,
          ),
        );
      }

      if(mounted)
      setState(() {});
      page1++;
    }

    page1 = 1;

    if(memorialFamilyItemsRemaining != 0){
      context.showLoaderOverlay();
      var newValue = await apiBLMHomeMemorialsTab(page: page1);
      context.hideLoaderOverlay();

      memorialFamilyItemsRemaining = newValue.blmFamilyMemorialList.memorialHomeTabMemorialFamilyItemsRemaining;
      count = count + newValue.blmFamilyMemorialList.memorialHomeTabMemorialPage.length;

      for(int i = 0; i < newValue.blmFamilyMemorialList.memorialHomeTabMemorialPage.length; i++){
        finalMemorials.add(
          MiscBLMManageMemorialTab(
            index: i,
            memorialName: newValue.blmFamilyMemorialList.memorialHomeTabMemorialPage[i].blmHomeTabMemorialPageName,
            description: newValue.blmFamilyMemorialList.memorialHomeTabMemorialPage[i].blmHomeTabMemorialPageDetails.blmHomeTabMemorialPageDetailsDescription,
            image: newValue.blmFamilyMemorialList.memorialHomeTabMemorialPage[i].blmHomeTabMemorialPageProfileImage,
            memorialId: newValue.blmFamilyMemorialList.memorialHomeTabMemorialPage[i].blmHomeTabMemorialPageId,
            managed: newValue.blmFamilyMemorialList.memorialHomeTabMemorialPage[i].blmHomeTabMemorialPageManage,
            follower: newValue.blmFamilyMemorialList.memorialHomeTabMemorialPage[i].blmHomeTabMemorialPageFollower,
            famOrFriends: newValue.blmFamilyMemorialList.memorialHomeTabMemorialPage[i].blmHomeTabMemorialPageFamOrFriends,
            pageType: newValue.blmFamilyMemorialList.memorialHomeTabMemorialPage[i].blmHomeTabMemorialPagePageType,
            relationship: newValue.blmFamilyMemorialList.memorialHomeTabMemorialPage[i].blmHomeTabMemorialPageRelationship,
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

    // refreshController.loadComplete();

  }

  void onLoading2() async{

    if(blmFriendsItemsRemaining != 0){
      context.showLoaderOverlay();
      var newValue = await apiBLMHomeMemorialsTab(page: page2);
      context.hideLoaderOverlay();

      blmFriendsItemsRemaining = newValue.blmFriendsMemorialList.blmHomeTabMemorialFriendsItemsRemaining;
      count = count + newValue.blmFriendsMemorialList.blmHomeTabMemorialPage.length;

      for(int i = 0; i < newValue.blmFriendsMemorialList.blmHomeTabMemorialPage.length; i++){
        finalMemorials.add(
          MiscBLMManageMemorialTab(
            index: i,
            memorialName: newValue.blmFriendsMemorialList.blmHomeTabMemorialPage[i].blmHomeTabMemorialPageName,
            description: newValue.blmFriendsMemorialList.blmHomeTabMemorialPage[i].blmHomeTabMemorialPageDetails.blmHomeTabMemorialPageDetailsDescription,
            image: newValue.blmFriendsMemorialList.blmHomeTabMemorialPage[i].blmHomeTabMemorialPageProfileImage,
            memorialId: newValue.blmFriendsMemorialList.blmHomeTabMemorialPage[i].blmHomeTabMemorialPageId,
            managed: newValue.blmFriendsMemorialList.blmHomeTabMemorialPage[i].blmHomeTabMemorialPageManage,
            follower: newValue.blmFriendsMemorialList.blmHomeTabMemorialPage[i].blmHomeTabMemorialPageFollower,
            famOrFriends: newValue.blmFriendsMemorialList.blmHomeTabMemorialPage[i].blmHomeTabMemorialPageFamOrFriends,
            pageType: newValue.blmFriendsMemorialList.blmHomeTabMemorialPage[i].blmHomeTabMemorialPagePageType,
            relationship: newValue.blmFriendsMemorialList.blmHomeTabMemorialPage[i].blmHomeTabMemorialPageRelationship,
          ),
        );
      }

      if(mounted)
      setState(() {});
      page2++;
    }

    page2 = 1;

    if(memorialFriendsItemsRemaining != 0){
      context.showLoaderOverlay();
      var newValue = await apiBLMHomeMemorialsTab(page: page2);
      context.hideLoaderOverlay();

      memorialFriendsItemsRemaining = newValue.blmFriendsMemorialList.memorialHomeTabMemorialFriendsItemsRemaining;
      count = count + newValue.blmFriendsMemorialList.memorialHomeTabMemorialPage.length;

      for(int i = 0; i < newValue.blmFriendsMemorialList.memorialHomeTabMemorialPage.length; i++){
        finalMemorials.add(
          MiscBLMManageMemorialTab(
            index: i,
            memorialName: newValue.blmFriendsMemorialList.memorialHomeTabMemorialPage[i].blmHomeTabMemorialPageName,
            description: newValue.blmFriendsMemorialList.memorialHomeTabMemorialPage[i].blmHomeTabMemorialPageDetails.blmHomeTabMemorialPageDetailsDescription,
            image: newValue.blmFriendsMemorialList.memorialHomeTabMemorialPage[i].blmHomeTabMemorialPageProfileImage,
            memorialId: newValue.blmFriendsMemorialList.memorialHomeTabMemorialPage[i].blmHomeTabMemorialPageId,
            managed: newValue.blmFriendsMemorialList.memorialHomeTabMemorialPage[i].blmHomeTabMemorialPageManage,
            follower: newValue.blmFriendsMemorialList.memorialHomeTabMemorialPage[i].blmHomeTabMemorialPageFollower,
            famOrFriends: newValue.blmFriendsMemorialList.memorialHomeTabMemorialPage[i].blmHomeTabMemorialPageFamOrFriends,
            pageType: newValue.blmFriendsMemorialList.memorialHomeTabMemorialPage[i].blmHomeTabMemorialPagePageType,
            relationship: newValue.blmFriendsMemorialList.memorialHomeTabMemorialPage[i].blmHomeTabMemorialPageRelationship,
          ),
        );
      }

      if(mounted)
      setState(() {});
      page2++;
    }
    // refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Container(
      width: SizeConfig.screenWidth,
      child: count != 0
      ? Container()
      // ? SmartRefresher(
      //   enablePullDown: true,
      //   enablePullUp: true,
      //   header: MaterialClassicHeader(
      //     color: Color(0xffffffff),
      //     backgroundColor: Color(0xff4EC9D4),
      //   ),
      //   footer: CustomFooter(
      //     loadStyle: LoadStyle.ShowWhenLoading,
      //     builder: (BuildContext context, LoadStatus mode){
      //       Widget body = Container();
      //       if(mode == LoadStatus.loading){
      //         body = CircularProgressIndicator();
      //       }
      //       return Center(child: body);
      //     },
      //   ),
      //   controller: refreshController,
      //   onRefresh: onRefresh,
      //   onLoading: onLoading,
      //   child: ListView.separated(
      //     physics: ClampingScrollPhysics(),
      //     itemBuilder: (c, i) {
      //       return finalMemorials[i];
      //     },
      //     separatorBuilder: (c, i) => Divider(height: 10, color: Colors.transparent),
      //     itemCount: finalMemorials.length,
      //   ),
      // )
      : SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              SizedBox(height: (SizeConfig.screenHeight! - 85 - kToolbarHeight) / 3.5,),

              Image.asset('assets/icons/app-icon.png', height: 250, width: 250,),

              SizedBox(height: 45,),

              Text('Memorial is empty', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xffB1B1B1),),),

              SizedBox(height: (SizeConfig.screenHeight! - 85 - kToolbarHeight) / 3.5,),
            ],
          ),
        ),
      ),
    );
  }
}
