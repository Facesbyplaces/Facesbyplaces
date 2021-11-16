import 'package:facesbyplaces/API/Regular/02-Main/api_main_regular_04_02_00_home_memorials_tab.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc_01_regular_manage_memorial.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:loader/loader.dart';
import 'package:dialog/dialog.dart';

class HomeRegularManageTab extends StatefulWidget{
  const HomeRegularManageTab({Key? key}) : super(key: key);

  @override
  HomeRegularManageTabState createState() => HomeRegularManageTabState();
}

class HomeRegularManageTabState extends State<HomeRegularManageTab> with AutomaticKeepAliveClientMixin<HomeRegularManageTab>{
  Future<List<APIRegularHomeTabMemorialExtendedPage>>? showListOfMemorials;
  ValueNotifier<bool> isGuestLoggedIn = ValueNotifier<bool>(false);
  ScrollController scrollController = ScrollController();
  ValueNotifier<int> lengthOfMemorials = ValueNotifier<int>(0);
  ValueNotifier<bool> loaded = ValueNotifier<bool>(false);
  ValueNotifier<int> flag = ValueNotifier<int>(0);
  bool updatedMemorialsData = false;
  int page1 = 1;

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
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No more memorials to show.'), duration: Duration(seconds: 1), backgroundColor: Color(0xff4EC9D4),),);
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

  Future<List<APIRegularHomeTabMemorialExtendedPage>> getListOfMemorials({required int page}) async{
    APIRegularHomeTabMemorialMain? newValue;
    List<APIRegularHomeTabMemorialExtendedPage> listOfMemorials = [];

    do{
      newValue = await apiRegularHomeMemorialsTab(page: page).onError((error, stackTrace){
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
      listOfMemorials.addAll(newValue.almFamilyMemorialList.memorialHomeTabMemorialPage);
      listOfMemorials.addAll(newValue.almFamilyMemorialList.blmHomeTabMemorialPage);

      flag.value = listOfMemorials.length; // FOR IDENTIFYING THE MIDDLE OF THE LIST

      listOfMemorials.addAll(newValue.almFriendsMemorialList.memorialHomeTabMemorialPage);
      listOfMemorials.addAll(newValue.almFriendsMemorialList.blmHomeTabMemorialPage);

      if(newValue.almFamilyMemorialList.memorialHomeTabMemorialFamilyItemsRemaining != 0 || newValue.almFamilyMemorialList.blmHomeTabMemorialFamilyItemsRemaining != 0 ||
      newValue.almFriendsMemorialList.memorialHomeTabMemorialFriendsItemsRemaining != 0 || newValue.almFriendsMemorialList.blmHomeTabMemorialFriendsItemsRemaining != 0
      ){
        page++;
      }else if(lengthOfMemorials.value > 0 && listOfMemorials.length > lengthOfMemorials.value){
        updatedMemorialsData = true;
      }
    }while(newValue.almFamilyMemorialList.memorialHomeTabMemorialFamilyItemsRemaining != 0 || newValue.almFamilyMemorialList.blmHomeTabMemorialFamilyItemsRemaining != 0 ||
      newValue.almFriendsMemorialList.memorialHomeTabMemorialFriendsItemsRemaining != 0 || newValue.almFriendsMemorialList.blmHomeTabMemorialFriendsItemsRemaining != 0
    );

    lengthOfMemorials.value = listOfMemorials.length; // COMPARISON FOR NEXT PAGINATION & NUMBER OF FEEDS
    page1 = page;
    loaded.value = true;
    
    return listOfMemorials;
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
                child: FutureBuilder<List<APIRegularHomeTabMemorialExtendedPage>>(
                  future: showListOfMemorials,
                  builder: (context, memorials){
                    if(memorials.connectionState == ConnectionState.done){
                      if(loadedListener && lengthOfMemorialsListener == 0){
                        return SingleChildScrollView(
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
                        );
                      }else{
                        return ListView.separated(
                          controller: scrollController,
                          separatorBuilder: (c, i) => const Divider(height: 10, color: Colors.transparent),
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                          physics: const ClampingScrollPhysics(),
                          itemCount: lengthOfMemorialsListener + 1,
                          itemBuilder: (c, i){
                            if(i == 0){
                              return Container(
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
                              );
                            }else if((flagListener) == i){
                              return Container(
                                height: 80,
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                color: const Color(0xffeeeeee),
                                child: const Align(alignment: Alignment.centerLeft, child: Text('My Friends', style: TextStyle(fontSize: 26, fontFamily: 'NexaBold', color: Color(0xff000000),),),),
                              );
                            }else{
                              return MiscRegularManageMemorialTab(
                                index: i - 1,
                                memorialName: memorials.data![i - 1].blmHomeTabMemorialPageName,
                                description: memorials.data![i - 1].blmHomeTabMemorialPageDetails.blmHomeTabMemorialPageDetailsDescription,
                                image: memorials.data![i - 1].blmHomeTabMemorialPageProfileImage,
                                memorialId: memorials.data![i - 1].blmHomeTabMemorialPageId,
                                managed: memorials.data![i - 1].blmHomeTabMemorialPageManage,
                                follower: memorials.data![i - 1].blmHomeTabMemorialPageFollower,
                                famOrFriends: memorials.data![i - 1].blmHomeTabMemorialPageFamOrFriends,
                                pageType: memorials.data![i - 1].blmHomeTabMemorialPagePageType,
                                relationship: memorials.data![i - 1].blmHomeTabMemorialPageRelationship,
                              );
                            }
                          }
                        );
                      }
                    }else if(memorials.connectionState == ConnectionState.none){
                      return const Center(child: CustomLoader(),);
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