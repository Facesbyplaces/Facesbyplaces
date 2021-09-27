import 'package:facesbyplaces/API/Regular/02-Main/api_main_regular_04_02_00_home_memorials_tab.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc_01_regular_manage_memorial.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter/material.dart';

class RegularMainPagesMemorials{
  final int memorialId;
  final String memorialName;
  final String memorialDescription;
  final bool managed;
  final bool joined;
  final String pageType;
  const RegularMainPagesMemorials({required this.memorialId, required this.memorialName, required this.memorialDescription, required this.managed, required this.joined, required this.pageType});
}

class HomeRegularManageTab extends StatefulWidget{
  const HomeRegularManageTab({Key? key}) : super(key: key);

  @override
  HomeRegularManageTabState createState() => HomeRegularManageTabState();
}

class HomeRegularManageTabState extends State<HomeRegularManageTab>{
  ScrollController scrollController = ScrollController();
  ValueNotifier<int> count = ValueNotifier<int>(0);
  int memorialFriendsItemsRemaining = 1;
  int memorialFamilyItemsRemaining = 1;
  int blmFriendsItemsRemaining = 1;
  int blmFamilyItemsRemaining = 1;
  List<Widget> finalMemorials = [];
  bool isGuestLoggedIn = true;
  bool flag1 = false;
  int page1 = 1;
  int page2 = 1;

  @override
  void initState(){
    super.initState();
    isGuest();
    scrollController.addListener((){
      if(scrollController.position.pixels == scrollController.position.maxScrollExtent){
        if(blmFamilyItemsRemaining != 0 && memorialFamilyItemsRemaining != 0 && blmFamilyItemsRemaining != 0 && blmFriendsItemsRemaining != 0){
          onLoading();
        }else{
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No more posts to show'),
              duration: Duration(seconds: 1),
              backgroundColor: Color(0xff4EC9D4),
            ),
          );
        }
      }
    });
  }

  void isGuest() async{
    final sharedPrefs = await SharedPreferences.getInstance();
    isGuestLoggedIn = sharedPrefs.getBool('user-guest-session') ?? false;

    if(isGuestLoggedIn != true){
      addMemorials1();
      onLoading();
    }
  }

  Future<void> onRefresh() async{
    if(blmFamilyItemsRemaining == 0 && memorialFamilyItemsRemaining == 0 && flag1 == false){
      flag1 = true;
      onLoading();
    }else{
      page1 = 1;
      page2 = 1;
      flag1 = false;
      count.value = 0;
      finalMemorials = [];
      memorialFamilyItemsRemaining = 1;
      memorialFriendsItemsRemaining = 1;
      blmFamilyItemsRemaining = 1;
      blmFriendsItemsRemaining = 1;
      addMemorials1();
      onLoading();
    }
  }

  void addMemorials1(){
    finalMemorials.add(
      Container(
        height: 80,
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        color: const Color(0xffeeeeee),
        child: Row(
          children: [
            const Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('My Family', style: TextStyle(fontSize: 26, fontFamily: 'NexaBold', color: Color(0xff000000),),),
              ),
            ),
            Expanded(
              child: GestureDetector(
                child: const Align(
                  alignment: Alignment.centerRight,
                  child: Text('Create', style: TextStyle(fontSize: 26, fontFamily: 'NexaBold', color: Color(0xff000000),),),
                ),
                onTap: (){
                  Navigator.pushNamed(context, '/home/regular/create-memorial');
                },
              ),
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
        padding: const EdgeInsets.symmetric(horizontal: 20),
        color: const Color(0xffeeeeee),
        child: const Align(alignment: Alignment.centerLeft, child: Text('My Friends', style: TextStyle(fontSize: 26, fontFamily: 'NexaBold', color: Color(0xff000000),),),),
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
      context.loaderOverlay.show();
      var newValue = await apiRegularHomeMemorialsTab(page: page1);
      context.loaderOverlay.hide();

      memorialFamilyItemsRemaining = newValue.almFamilyMemorialList.memorialHomeTabMemorialFamilyItemsRemaining;
      count.value = count.value + newValue.almFamilyMemorialList.memorialHomeTabMemorialPage.length;

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
          // MiscManageMemorialTab(
          //   index: i,
          //   memorialName: newValue.almFamilyMemorialList.memorialHomeTabMemorialPage[i].blmHomeTabMemorialPageName,
          //   description: newValue.almFamilyMemorialList.memorialHomeTabMemorialPage[i].blmHomeTabMemorialPageDetails.blmHomeTabMemorialPageDetailsDescription,
          //   image: newValue.almFamilyMemorialList.memorialHomeTabMemorialPage[i].blmHomeTabMemorialPageProfileImage,
          //   memorialId: newValue.almFamilyMemorialList.memorialHomeTabMemorialPage[i].blmHomeTabMemorialPageId,
          //   managed: newValue.almFamilyMemorialList.memorialHomeTabMemorialPage[i].blmHomeTabMemorialPageManage,
          //   follower: newValue.almFamilyMemorialList.memorialHomeTabMemorialPage[i].blmHomeTabMemorialPageFollower,
          //   famOrFriends: newValue.almFamilyMemorialList.memorialHomeTabMemorialPage[i].blmHomeTabMemorialPageFamOrFriends,
          //   pageType: newValue.almFamilyMemorialList.memorialHomeTabMemorialPage[i].blmHomeTabMemorialPagePageType,
          //   relationship: newValue.almFamilyMemorialList.memorialHomeTabMemorialPage[i].blmHomeTabMemorialPageRelationship,
          //   memorialOnPressed: () async{
          //     if(newValue.almFamilyMemorialList.memorialHomeTabMemorialPage[i].blmHomeTabMemorialPagePageType == 'Memorial'){
          //       if(newValue.almFamilyMemorialList.memorialHomeTabMemorialPage[i].blmHomeTabMemorialPageManage == true || newValue.almFamilyMemorialList.memorialHomeTabMemorialPage[i].blmHomeTabMemorialPageFamOrFriends == true){
          //         Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularProfile(memorialId: newValue.almFamilyMemorialList.memorialHomeTabMemorialPage[i].blmHomeTabMemorialPageId, relationship: newValue.almFamilyMemorialList.memorialHomeTabMemorialPage[i].blmHomeTabMemorialPageRelationship, managed: newValue.almFamilyMemorialList.memorialHomeTabMemorialPage[i].blmHomeTabMemorialPageManage, newlyCreated: false,)));
          //       }else{
          //         followButton.value = await Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularMemorialProfile(memorialId: widget.memorialId, pageType: widget.pageType, newJoin: followButtonListener,)));
          //       }
          //     }else{
          //       if(widget.managed == true || widget.famOrFriends == true){
          //         Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMProfile(memorialId: widget.memorialId, relationship: widget.relationship, managed: widget.managed, newlyCreated: false,)));
          //       }else{
          //         followButton.value = await Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMMemorialProfile(memorialId: widget.memorialId, pageType: widget.pageType, newJoin: followButtonListener,)));
          //       }
          //     }
          //   }
          // ),
        );
      }
    }

    if(blmFamilyItemsRemaining != 0){
      context.loaderOverlay.show();
      var newValue = await apiRegularHomeMemorialsTab(page: page1);
      context.loaderOverlay.hide();

      blmFamilyItemsRemaining = newValue.almFamilyMemorialList.blmHomeTabMemorialFamilyItemsRemaining;
      count.value = count.value + newValue.almFamilyMemorialList.blmHomeTabMemorialPage.length;

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

    if(mounted){
      page1++;
    }

    if(blmFamilyItemsRemaining == 0 && memorialFamilyItemsRemaining == 0){
      addMemorials2();
      flag1 = true;
      onLoading();
    }else{
      onLoading();
    }
  }

  void onLoading2() async{
    if(memorialFriendsItemsRemaining != 0){
      context.loaderOverlay.show();
      var newValue = await apiRegularHomeMemorialsTab(page: page2);
      context.loaderOverlay.hide();

      memorialFriendsItemsRemaining = newValue.almFriendsMemorialList.memorialHomeTabMemorialFriendsItemsRemaining;
      count.value = count.value + newValue.almFriendsMemorialList.memorialHomeTabMemorialPage.length;

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
      context.loaderOverlay.show();
      var newValue = await apiRegularHomeMemorialsTab(page: page2);
      context.loaderOverlay.hide();

      blmFriendsItemsRemaining = newValue.almFriendsMemorialList.blmHomeTabMemorialFriendsItemsRemaining;
      count.value = count.value + newValue.almFriendsMemorialList.blmHomeTabMemorialPage.length;

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
    }

    if(mounted){
      page2++;
    }

    if(blmFriendsItemsRemaining != 0 || memorialFriendsItemsRemaining != 0){
      onLoading();
    }
  }

  @override
  Widget build(BuildContext context){
    SizeConfig.init(context);
    return ValueListenableBuilder(
      valueListenable: count,
      builder: (_, int countListener, __) => SizedBox(
        width: SizeConfig.screenWidth,
        child: countListener != 0
        ? SafeArea(
          child: RefreshIndicator(
            onRefresh: onRefresh,
            child: ListView.separated(
              controller: scrollController,
              separatorBuilder: (c, i) => const Divider(height: 10, color: Colors.transparent),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
              itemBuilder: (c, i) => finalMemorials[i],
              physics: const ClampingScrollPhysics(),
              itemCount: finalMemorials.length,
            ),
          ),
        )
        : SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: (SizeConfig.screenHeight! - 85 - kToolbarHeight) / 3.5,),

              Image.asset('assets/icons/app-icon.png', height: 250, width: 250,),

              const SizedBox(height: 45,),

              const Text('Memorial is empty', style: TextStyle(fontSize: 36, fontFamily: 'NexaBold', color: Color(0xffB1B1B1),),),

              SizedBox(height: (SizeConfig.screenHeight! - 85 - kToolbarHeight) / 3.5,),
            ],
          ),
        ),
      ),
    );
  }
}