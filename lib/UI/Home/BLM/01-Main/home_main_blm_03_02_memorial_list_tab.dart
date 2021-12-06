import 'package:facesbyplaces/API/BLM/02-Main/api_main_blm_04_02_00_home_memorials_tab.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc_01_blm_manage_memorial.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:loader/loader.dart';
import 'package:dialog/dialog.dart';

class HomeBLMManageTab extends StatefulWidget{
  const HomeBLMManageTab({Key? key}) : super(key: key);

  @override
  HomeBLMManageTabState createState() => HomeBLMManageTabState();
}

class HomeBLMManageTabState extends State<HomeBLMManageTab> with AutomaticKeepAliveClientMixin<HomeBLMManageTab>{
  Future<List<Widget>>? showListOfMemorials;
  ValueNotifier<bool> isGuestLoggedIn = ValueNotifier<bool>(false);
  ScrollController scrollController = ScrollController();
  ValueNotifier<int> lengthOfMemorials = ValueNotifier<int>(0);
  ValueNotifier<bool> loaded = ValueNotifier<bool>(false);
  ValueNotifier<int> flag = ValueNotifier<int>(0);
  bool updatedMemorialsData = false;
  int page1 = 1;
  bool added = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState(){
    super.initState();
    isGuest();
    scrollController.addListener((){
      if(scrollController.position.pixels == scrollController.position.maxScrollExtent){
        if(loaded.value){
          page1 = 1; // RESET BACK TO ONE FOR PAGINATION OF THE API
          showListOfMemorials = getListOfMemorials(page: page1);

          if(updatedMemorialsData){
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                elevation: 0,
                content: const Text('New memorials available. Reload to view.'), 
                duration: const Duration(seconds: 3), backgroundColor: const Color(0xff4EC9D4),
                action: SnackBarAction(
                  label: 'Reload',
                  onPressed: (){
                    onRefresh();
                  },
                  textColor: Colors.blue,
                ),
              ),
            );
          }else{
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No more memorials to show.'), elevation: 0, duration: Duration(seconds: 1), backgroundColor: Color(0xff4EC9D4),),);
          }
        }
      }
    });
  }

  Future<void> onRefresh() async{
    page1 = 1;
    loaded.value = false;
    updatedMemorialsData = false;
    lengthOfMemorials.value = 0;
    showListOfMemorials = getListOfMemorials(page: page1);
  }

  void isGuest() async{
    final sharedPrefs = await SharedPreferences.getInstance();
    isGuestLoggedIn.value = sharedPrefs.getBool('user-guest-session') ?? false;

    if(isGuestLoggedIn.value != true){
      showListOfMemorials = getListOfMemorials(page: page1);
    }
  }

  Future<List<Widget>> getListOfMemorials({required int page}) async{
    List<Widget> memorials = [];
    APIBLMHomeTabMemorialMain? newValue;

    memorials.add(
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
                  Navigator.pushNamed(context, '/home/blm/create-memorial');
                },
              ),
            ),
          ],
        ),
      ),
    );

    do{
      newValue = await apiBLMHomeMemorialsTab(page: page).onError((error, stackTrace){
        showDialog(
          context: context,
          builder: (context) => CustomDialog(
            image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
            title: 'Error',
            description: 'Something went wrong. Please try again.',
            okButtonColor: const Color(0xfff44336), // RED
            includeOkButton: true,
          ),
        );
        throw Exception('$error');
      });

      for(int i = 0; i < newValue.blmFamilyMemorialList.memorialHomeTabMemorialPage.length; i++){
        memorials.add(
          MiscBLMManageMemorialTab(
            memorialName: newValue.blmFamilyMemorialList.memorialHomeTabMemorialPage[i].blmHomeTabMemorialPageName,
            description: newValue.blmFamilyMemorialList.memorialHomeTabMemorialPage[i].blmHomeTabMemorialPageDetails.blmHomeTabMemorialPageDetailsDescription,
            image: newValue.blmFamilyMemorialList.memorialHomeTabMemorialPage[i].blmHomeTabMemorialPageProfileImage,
            memorialId: newValue.blmFamilyMemorialList.memorialHomeTabMemorialPage[i].blmHomeTabMemorialPageId,
            managed: newValue.blmFamilyMemorialList.memorialHomeTabMemorialPage[i].blmHomeTabMemorialPageManage,
            follower: newValue.blmFamilyMemorialList.memorialHomeTabMemorialPage[i].blmHomeTabMemorialPageFollower,
            famOrFriends: newValue.blmFamilyMemorialList.memorialHomeTabMemorialPage[i].blmHomeTabMemorialPageFamOrFriends,
            pageType: newValue.blmFamilyMemorialList.memorialHomeTabMemorialPage[i].blmHomeTabMemorialPagePageType,
            relationship: newValue.blmFamilyMemorialList.memorialHomeTabMemorialPage[i].blmHomeTabMemorialPageRelationship,
            isGuest: isGuestLoggedIn.value,
          ),
        );
      }

      for(int i = 0; i < newValue.blmFamilyMemorialList.blmHomeTabMemorialPage.length; i++){
        memorials.add(
          MiscBLMManageMemorialTab(
            memorialName: newValue.blmFamilyMemorialList.blmHomeTabMemorialPage[i].blmHomeTabMemorialPageName,
            description: newValue.blmFamilyMemorialList.blmHomeTabMemorialPage[i].blmHomeTabMemorialPageDetails.blmHomeTabMemorialPageDetailsDescription,
            image: newValue.blmFamilyMemorialList.blmHomeTabMemorialPage[i].blmHomeTabMemorialPageProfileImage,
            memorialId: newValue.blmFamilyMemorialList.blmHomeTabMemorialPage[i].blmHomeTabMemorialPageId,
            managed: newValue.blmFamilyMemorialList.blmHomeTabMemorialPage[i].blmHomeTabMemorialPageManage,
            follower: newValue.blmFamilyMemorialList.blmHomeTabMemorialPage[i].blmHomeTabMemorialPageFollower,
            famOrFriends: newValue.blmFamilyMemorialList.blmHomeTabMemorialPage[i].blmHomeTabMemorialPageFamOrFriends,
            pageType: newValue.blmFamilyMemorialList.blmHomeTabMemorialPage[i].blmHomeTabMemorialPagePageType,
            relationship: newValue.blmFamilyMemorialList.blmHomeTabMemorialPage[i].blmHomeTabMemorialPageRelationship,
            isGuest: isGuestLoggedIn.value,
          ),
        );
      }

      memorials.add(
        Container(
          height: 80,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          color: const Color(0xffeeeeee),
          child: const Align(alignment: Alignment.centerLeft, child: Text('My Friends', style: TextStyle(fontSize: 26, fontFamily: 'NexaBold', color: Color(0xff000000),),),),
        ),
      );

      for(int i = 0; i < newValue.blmFriendsMemorialList.memorialHomeTabMemorialPage.length; i++){
        memorials.add(
          MiscBLMManageMemorialTab(
            memorialName: newValue.blmFriendsMemorialList.memorialHomeTabMemorialPage[i].blmHomeTabMemorialPageName,
            description: newValue.blmFriendsMemorialList.memorialHomeTabMemorialPage[i].blmHomeTabMemorialPageDetails.blmHomeTabMemorialPageDetailsDescription,
            image: newValue.blmFriendsMemorialList.memorialHomeTabMemorialPage[i].blmHomeTabMemorialPageProfileImage,
            memorialId: newValue.blmFriendsMemorialList.memorialHomeTabMemorialPage[i].blmHomeTabMemorialPageId,
            managed: newValue.blmFriendsMemorialList.memorialHomeTabMemorialPage[i].blmHomeTabMemorialPageManage,
            follower: newValue.blmFriendsMemorialList.memorialHomeTabMemorialPage[i].blmHomeTabMemorialPageFollower,
            famOrFriends: newValue.blmFriendsMemorialList.memorialHomeTabMemorialPage[i].blmHomeTabMemorialPageFamOrFriends,
            pageType: newValue.blmFriendsMemorialList.memorialHomeTabMemorialPage[i].blmHomeTabMemorialPagePageType,
            relationship: newValue.blmFriendsMemorialList.memorialHomeTabMemorialPage[i].blmHomeTabMemorialPageRelationship,
            isGuest: isGuestLoggedIn.value,
          ),
        );
      }

      for(int i = 0; i < newValue.blmFriendsMemorialList.blmHomeTabMemorialPage.length; i++){
        memorials.add(
          MiscBLMManageMemorialTab(
            memorialName: newValue.blmFriendsMemorialList.blmHomeTabMemorialPage[i].blmHomeTabMemorialPageName,
            description: newValue.blmFriendsMemorialList.blmHomeTabMemorialPage[i].blmHomeTabMemorialPageDetails.blmHomeTabMemorialPageDetailsDescription,
            image: newValue.blmFriendsMemorialList.blmHomeTabMemorialPage[i].blmHomeTabMemorialPageProfileImage,
            memorialId: newValue.blmFriendsMemorialList.blmHomeTabMemorialPage[i].blmHomeTabMemorialPageId,
            managed: newValue.blmFriendsMemorialList.blmHomeTabMemorialPage[i].blmHomeTabMemorialPageManage,
            follower: newValue.blmFriendsMemorialList.blmHomeTabMemorialPage[i].blmHomeTabMemorialPageFollower,
            famOrFriends: newValue.blmFriendsMemorialList.blmHomeTabMemorialPage[i].blmHomeTabMemorialPageFamOrFriends,
            pageType: newValue.blmFriendsMemorialList.blmHomeTabMemorialPage[i].blmHomeTabMemorialPagePageType,
            relationship: newValue.blmFriendsMemorialList.blmHomeTabMemorialPage[i].blmHomeTabMemorialPageRelationship,
            isGuest: isGuestLoggedIn.value,
          ),
        );
      }

      if(newValue.blmFamilyMemorialList.memorialHomeTabMemorialFamilyItemsRemaining != 0 || newValue.blmFamilyMemorialList.blmHomeTabMemorialFamilyItemsRemaining != 0 ||
      newValue.blmFriendsMemorialList.memorialHomeTabMemorialFriendsItemsRemaining != 0 || newValue.blmFriendsMemorialList.blmHomeTabMemorialFriendsItemsRemaining != 0
      ){
        page++;
      }else if(lengthOfMemorials.value > 0 && memorials.length > lengthOfMemorials.value){
        updatedMemorialsData = true;
      }
    }while(newValue.blmFamilyMemorialList.memorialHomeTabMemorialFamilyItemsRemaining != 0 || newValue.blmFamilyMemorialList.blmHomeTabMemorialFamilyItemsRemaining != 0 ||
      newValue.blmFriendsMemorialList.memorialHomeTabMemorialFriendsItemsRemaining != 0 || newValue.blmFriendsMemorialList.blmHomeTabMemorialFriendsItemsRemaining != 0
    );
    
    if(memorials.length == 2){ // NO DATA FROM THE SERVER EXCEPT FOR THE TWO WIDGETS (MY FAMILY AND MY FRIENDS) AND NEEDS TO BE EMPTY
      lengthOfMemorials.value = 0;
    }else{
      lengthOfMemorials.value = memorials.length;
    }

    page1 = page;
    loaded.value = true;
    
    return memorials;
  }

  @override
  Widget build(BuildContext context){
    super.build(context);
    SizeConfig.init(context);
    return ValueListenableBuilder(
      valueListenable: isGuestLoggedIn,
      builder: (_, bool isGuestLoggedInListener, __) => ValueListenableBuilder(
        valueListenable: lengthOfMemorials,
        builder: (_, int lengthOfMemorialsListener, __) => ValueListenableBuilder(
          valueListenable: loaded,
          builder: (_, bool loadedListener, __) => ValueListenableBuilder(
            valueListenable: flag,
            builder: (_, int flagListener, __) => SafeArea(
              child: RefreshIndicator(
                onRefresh: onRefresh,
                child: FutureBuilder<List<Widget>>(
                  future: showListOfMemorials,
                  builder: (context, memorials){
                    if(memorials.connectionState == ConnectionState.done){
                      if(loadedListener && lengthOfMemorialsListener == 0){
                        return SingleChildScrollView(
                          physics: const ClampingScrollPhysics(),
                          child: Align(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(height: (SizeConfig.screenHeight! - 85 - kToolbarHeight) / 3.5,),

                                Image.asset('assets/icons/app-icon.png', height: 200, width: 200,),

                                const SizedBox(height: 45,),

                                const Text('Memorial is empty', style: TextStyle(fontSize: 36, fontFamily: 'NexaBold', color: Color(0xffB1B1B1),),),

                                SizedBox(height: (SizeConfig.screenHeight! - 85 - kToolbarHeight) / 3.5,),
                              ],
                            ),
                          ),
                        );
                      }else{
                        return ListView.separated(
                          controller: scrollController,
                          separatorBuilder: (c, i) => const Divider(height: 10, color: Colors.transparent),
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                          physics: const ClampingScrollPhysics(),
                          itemCount: memorials.data!.length,
                          itemBuilder: (c, i){
                            return memorials.data![i];
                          }
                        );
                      }
                    }else if(memorials.connectionState == ConnectionState.none || memorials.connectionState == ConnectionState.waiting){
                      return const Center(child: CustomLoaderThreeDots(),);
                    }
                    else if(memorials.hasError){
                      return Center(
                        child: MaterialButton(
                          onPressed: (){
                            isGuest();
                          },
                          child: const Text('Refresh', style: TextStyle(color: Color(0xffffffff))),
                          color: const Color(0xff4EC9D4),
                        ),
                      );
                    }else{
                      return const SizedBox(height: 0,);
                    }
                  }
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}