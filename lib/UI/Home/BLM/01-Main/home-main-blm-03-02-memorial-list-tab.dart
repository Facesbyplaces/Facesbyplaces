import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-04-blm-manage-memorial.dart';
import 'package:facesbyplaces/API/BLM/02-Main/api-main-blm-04-02-home-memorials-tab.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-16-blm-empty-display.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter/material.dart';
import 'package:responsive_widgets/responsive_widgets.dart';

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
  List<Widget> finalMemorials;
  int blmFamilyItemsRemaining;
  int blmFriendsItemsRemaining;
  int page1;
  int page2;
  bool flag1;
  int count;

  void initState(){
    super.initState();
    finalMemorials = [];
    blmFamilyItemsRemaining = 1;
    blmFriendsItemsRemaining = 1;
    page1 = 1;
    page2 = 1;
    count = 0;
    flag1 = false;
    addMemorials1();
    onLoading1();
  }

  void onRefresh() async{
    await Future.delayed(Duration(milliseconds: 1000));
    refreshController.refreshCompleted();
  }

  void addMemorials1(){
    finalMemorials.add(
      Container(
        height: SizeConfig.blockSizeVertical * 10,
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
        height: SizeConfig.blockSizeVertical * 10,
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
      var newValue = await apiBLMHomeMemorialsTab(page1);
      context.hideLoaderOverlay();

      blmFamilyItemsRemaining = newValue.familyMemorialList.blmFamilyItemsRemaining;
      count = count + newValue.familyMemorialList.blm.length;

      for(int i = 0; i < newValue.familyMemorialList.blm.length; i++){
        finalMemorials.add(
          MiscBLMManageMemorialTab(
            index: i,
            memorialId: newValue.familyMemorialList.blm[i].id, 
            memorialName: newValue.familyMemorialList.blm[i].name,
            description: newValue.familyMemorialList.blm[i].details.description,
            managed: newValue.familyMemorialList.blm[i].managed,
          ),
        );
      }

      print('The count is $count');

      if(mounted)
      setState(() {});
      page1++;

      if(blmFamilyItemsRemaining == 0){
        addMemorials2();
      }
      
      refreshController.loadComplete();
    }else{
      setState(() {
        flag1 = true;
      });
      
      refreshController.loadNoData();
    }
  }

  void onLoading2() async{

    if(blmFriendsItemsRemaining != 0){
      context.showLoaderOverlay();
      var newValue = await apiBLMHomeMemorialsTab(page2);
      context.hideLoaderOverlay();

      blmFriendsItemsRemaining = newValue.friendsMemorialList.blmFriendsItemsRemaining;
      count = count + newValue.familyMemorialList.blm.length;

      for(int i = 0; i < newValue.familyMemorialList.blm.length; i++){
        finalMemorials.add(
          MiscBLMManageMemorialTab(
            index: i,
            memorialId: newValue.friendsMemorialList.blm[i].id,
            memorialName: newValue.friendsMemorialList.blm[i].name,
            description: newValue.friendsMemorialList.blm[i].details.description,
            managed: newValue.familyMemorialList.blm[i].managed,
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
              body = Text('Pull up load', style: TextStyle(fontSize: ScreenUtil().setSp(14, allowFontScalingSelf: true), color: Color(0xff000000),),);
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
            child: MiscBLMEmptyDisplayTemplate(message: 'Memorial is empty',),
          ),
        ),
      ),
    );
  }
}


