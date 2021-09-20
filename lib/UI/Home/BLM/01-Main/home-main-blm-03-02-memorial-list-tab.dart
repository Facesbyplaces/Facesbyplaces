// ignore_for_file: file_names
import 'package:facesbyplaces/API/BLM/02-Main/api-main-blm-04-02-00-home-memorials-tab.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-03-blm-manage-memorial.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter/material.dart';

class BLMMainPagesMemorials{
  final int blmId;
  final String blmName;
  final String blmDescription;
  final bool managed;
  final bool joined;
  final String pageType;
  const BLMMainPagesMemorials({required this.blmId, required this.blmName, required this.blmDescription, required this.managed, required this.joined, required this.pageType});
}

class HomeBLMManageTab extends StatefulWidget{
  const HomeBLMManageTab();

  HomeBLMManageTabState createState() => HomeBLMManageTabState();
}

class HomeBLMManageTabState extends State<HomeBLMManageTab>{
  ScrollController scrollController = ScrollController();
  ValueNotifier<int> count = ValueNotifier<int>(0);
  List<Widget> finalMemorials = [];
  int blmFamilyItemsRemaining = 1;
  int blmFriendsItemsRemaining = 1;
  int memorialFamilyItemsRemaining = 1;
  int memorialFriendsItemsRemaining = 1;
  bool isGuestLoggedIn = true;
  bool flag1 = false;
  int page1 = 1;
  int page2 = 1;

  void initState(){
    super.initState();
    isGuest();
    scrollController.addListener((){
      if(scrollController.position.pixels == scrollController.position.maxScrollExtent){
        if(blmFamilyItemsRemaining != 0 && memorialFamilyItemsRemaining != 0 && blmFamilyItemsRemaining != 0 && blmFriendsItemsRemaining != 0){
          onLoading();
        }else{
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('No more posts to show'),
              duration: const Duration(seconds: 1),
              backgroundColor: const Color(0xff4EC9D4),
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
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('My Family', style: TextStyle(fontSize: 26, fontFamily: 'NexaBold', color: const Color(0xff000000),),),
              ),
            ),

            Expanded(
              child: GestureDetector(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text('Create', style: TextStyle(fontSize: 26, fontFamily: 'NexaBold', color: const Color(0xff000000),),),
                ),
                onTap: (){
                  Navigator.pushNamed(context, '/home/blm/create-memorial');
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
        child: Align(alignment: Alignment.centerLeft, child: Text('My Friends', style: TextStyle(fontSize: 26, fontFamily: 'NexaBold', color: const Color(0xff000000),),),),
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
      context.loaderOverlay.show();
      var newValue = await apiBLMHomeMemorialsTab(page: page1);
      context.loaderOverlay.hide();

      blmFamilyItemsRemaining = newValue.blmFamilyMemorialList.blmHomeTabMemorialFamilyItemsRemaining;
      count.value = count.value + newValue.blmFamilyMemorialList.blmHomeTabMemorialPage.length;

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
    }

    if(memorialFamilyItemsRemaining != 0){
      context.loaderOverlay.show();
      var newValue = await apiBLMHomeMemorialsTab(page: page1);
      context.loaderOverlay.hide();

      memorialFamilyItemsRemaining = newValue.blmFamilyMemorialList.memorialHomeTabMemorialFamilyItemsRemaining;
      count.value = count.value + newValue.blmFamilyMemorialList.memorialHomeTabMemorialPage.length;

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
      page1++;

      if(blmFamilyItemsRemaining == 0 && memorialFamilyItemsRemaining == 0){
        addMemorials2();
        flag1 = true;
        onLoading();
      }else{
        onLoading();
      }
    }
  }

  void onLoading2() async{
    if (blmFriendsItemsRemaining != 0){
      context.loaderOverlay.show();
      var newValue = await apiBLMHomeMemorialsTab(page: page2);
      context.loaderOverlay.hide();

      blmFriendsItemsRemaining = newValue.blmFriendsMemorialList.blmHomeTabMemorialFriendsItemsRemaining;
      count.value = count.value + newValue.blmFriendsMemorialList.blmHomeTabMemorialPage.length;

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
    }

    if(memorialFriendsItemsRemaining != 0){
      context.loaderOverlay.show();
      var newValue = await apiBLMHomeMemorialsTab(page: page2);
      context.loaderOverlay.hide();

      memorialFriendsItemsRemaining = newValue.blmFriendsMemorialList.memorialHomeTabMemorialFriendsItemsRemaining;
      count.value = count.value + newValue.blmFriendsMemorialList.memorialHomeTabMemorialPage.length;

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
    }

    if(mounted)
    page2++;

    if(blmFriendsItemsRemaining != 0 || memorialFriendsItemsRemaining != 0){
      onLoading();
    }
  }

  @override
  Widget build(BuildContext context){
    SizeConfig.init(context);
    return ValueListenableBuilder(
      valueListenable: count,
      builder: (_, int countListener, __) => Container(
        width: SizeConfig.screenWidth,
        child: countListener != 0
        ? SafeArea(
          child: RefreshIndicator(
            onRefresh: onRefresh,
            child: ListView.separated(
              controller: scrollController,
              separatorBuilder: (c, i) => const Divider(height: 10, color: Colors.transparent),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
              physics: const ClampingScrollPhysics(),
              itemCount: finalMemorials.length,
              itemBuilder: (c, i) => finalMemorials[i],
            ),
          ),
        )
        : SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: (SizeConfig.screenHeight! - 85 - kToolbarHeight) / 3.5,),

                Image.asset('assets/icons/app-icon.png', height: 250, width: 250,),

                const SizedBox(height: 45,),

                Text('Memorial is empty', style: TextStyle(fontSize: 36, fontFamily: 'NexaBold', color: const Color(0xffB1B1B1),),),

                SizedBox(height: (SizeConfig.screenHeight! - 85 - kToolbarHeight) / 3.5,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}