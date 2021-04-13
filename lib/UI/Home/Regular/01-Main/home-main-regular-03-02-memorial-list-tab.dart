import 'package:facesbyplaces/API/Regular/02-Main/api-main-regular-04-02-00-home-memorials-tab.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-03-regular-manage-memorial.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:flutter/material.dart';

class RegularMainPagesMemorials{
  int memorialId;
  String memorialName;
  String memorialDescription;
  bool managed;
  bool joined;
  String pageType;

  RegularMainPagesMemorials({required this.memorialId, required this.memorialName, required this.memorialDescription, required this.managed, required this.joined, required this.pageType});
}

class HomeRegularManageTab extends StatefulWidget{

  HomeRegularManageTabState createState() => HomeRegularManageTabState();
}

class HomeRegularManageTabState extends State<HomeRegularManageTab>{

  ScrollController scrollController = ScrollController();
  List<Widget> finalMemorials = [];
  int memorialFamilyItemsRemaining = 1;
  int memorialFriendsItemsRemaining = 1;
  int blmFamilyItemsRemaining = 1;
  int blmFriendsItemsRemaining = 1;
  bool isGuestLoggedIn = true;
  bool flag1 = false;
  int page1 = 1;
  int page2 = 1;
  int count = 0;

  void initState(){
    super.initState();
    isGuest();
  }

  void isGuest() async{
    final sharedPrefs = await SharedPreferences.getInstance();
    setState(() {
      isGuestLoggedIn = sharedPrefs.getBool('user-guest-session') ?? false;
    });
    if(isGuestLoggedIn != true){
      addMemorials1();
      onLoading();
      scrollController.addListener(() {
        if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
          if(blmFamilyItemsRemaining != 0 && memorialFamilyItemsRemaining != 0 && blmFamilyItemsRemaining != 0 && blmFriendsItemsRemaining != 0){
            setState(() {
              onLoading();
            });
          }else{
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('No more posts to show'),
                duration: Duration(seconds: 1),
                backgroundColor: Color(0xff4EC9D4),
              ),
            );
          }
        }
      });
    }
  }
  
  Future<void> onRefresh() async{
    if(blmFamilyItemsRemaining == 0 && memorialFamilyItemsRemaining == 0 && flag1 == false){
      setState(() {
        flag1 = true;
      });
      onLoading();
    }else{
      onLoading();
    }
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
      var newValue = await apiRegularHomeMemorialsTab(page: page1).onError((error, stackTrace) async{
        context.hideLoaderOverlay();
        await showDialog(
          context: context,
          builder: (_) => 
            AssetGiffyDialog(
            image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
            title: Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
            entryAnimation: EntryAnimation.DEFAULT,
            description: Text('Something went wrong. Please try again.',
              textAlign: TextAlign.center,
              style: TextStyle(),
            ),
            onlyOkButton: true,
            buttonOkColor: Colors.red,
            onOkButtonPressed: () {
              Navigator.pop(context, true);
            },
          )
        );
        return Future.error('Error occurred: $error');
      });
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
    }

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
    }

    if(mounted)
    setState(() {});
    page1++;

    if(blmFamilyItemsRemaining == 0 && memorialFamilyItemsRemaining == 0){
      addMemorials2();
    }
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
    }

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
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Container(
      width: SizeConfig.screenWidth,
      child: count != 0
      ? RefreshIndicator(
        onRefresh: onRefresh,
        child: ListView.separated(
          controller: scrollController,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
          physics: ClampingScrollPhysics(),
          itemCount: finalMemorials.length,
          separatorBuilder: (c, i) => Divider(height: 10, color: Colors.transparent),
          itemBuilder: (c, i) => finalMemorials[i],
        )
      )
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
