import 'package:facesbyplaces/API/Regular/09-Settings-Memorial/api_settings_memorial_regular_05_show_friends_settings.dart';
import 'package:facesbyplaces/API/Regular/09-Settings-Memorial/api_settings_memorial_regular_13_remove_friends_or_family.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'home_settings_memorial_regular_07_search_user_settings.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter/material.dart';
import 'package:loader/loader.dart';
import 'package:dialog/dialog.dart';

class HomeRegularPageFriends extends StatefulWidget{
  final int memorialId;
  final String memorialName;
  final bool switchFamily;
  final bool switchFriends;
  final bool switchFollowers;
  const HomeRegularPageFriends({Key? key, required this.memorialId, required this.memorialName, required this.switchFamily, required this.switchFriends, required this.switchFollowers}) : super(key: key);

  @override
  HomeRegularPageFriendsState createState() => HomeRegularPageFriendsState();
}

class HomeRegularPageFriendsState extends State<HomeRegularPageFriends>{
  Future<List<APIRegularShowFriendsSettingsExtended>>? showListOfFriends;
  ScrollController scrollController = ScrollController();
  ValueNotifier<int> lengthOfFriends = ValueNotifier<int>(0);
  int page1 = 1;
  ValueNotifier<bool> loaded = ValueNotifier<bool>(false);
  bool updatedFriendsData = false;

  Future<void> onRefresh() async{ // PULL TO REFRESH FUNCTIONALITY
    page1 = 1;
    loaded.value = false;
    updatedFriendsData = false;
    lengthOfFriends.value = 0;
    showListOfFriends = getListOfFriends(page: page1);
  }

  @override
  void initState(){
    super.initState();
    showListOfFriends = getListOfFriends(page: page1);
    scrollController.addListener((){ // SHOWS WHEN THE USER HAS REACHED THE BOTTOM OF THE LIST
      if(scrollController.position.pixels == scrollController.position.maxScrollExtent){
        if(loaded.value){
          page1 = 1; // RESET BACK TO ONE FOR PAGINATION OF THE API
          showListOfFriends = getListOfFriends(page: page1);

          if(updatedFriendsData){
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                elevation: 0,
                content: const Text('New friends available. Reload to view.'), 
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
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No more friends to show.'), elevation: 0, duration: Duration(seconds: 1), backgroundColor: Color(0xff4EC9D4),),);
          }
        }
      }
    });
  }

  Future<List<APIRegularShowFriendsSettingsExtended>> getListOfFriends({required int page}) async{
    APIRegularShowFriendsSettingsMain? newValue;
    List<APIRegularShowFriendsSettingsExtended> listOfFriends = [];

    do{
      newValue = await apiRegularShowFriendsSettings(memorialId: widget.memorialId, page: page).onError((error, stackTrace){
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
      listOfFriends.addAll(newValue.almFriendsList);

      if(newValue.almItemsRemaining != 0){
        page++;
      }else if(lengthOfFriends.value > 0 && listOfFriends.length > lengthOfFriends.value){
        updatedFriendsData = true;
      }
    }while(newValue.almItemsRemaining != 0);

    lengthOfFriends.value = listOfFriends.length; // COMPARISON FOR NEXT PAGINATION & NUMBER OF FEEDS
    page1 = page;
    loaded.value = true;
    
    return listOfFriends;
  }

  @override
  Widget build(BuildContext context){
    return ValueListenableBuilder(
      valueListenable: lengthOfFriends,
      builder: (_, int lengthOfFriendsListener, __) => ValueListenableBuilder(
        valueListenable: loaded,
        builder: (_, bool loadedListener, __) => Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xff04ECFF),
            title: const Text('Friends', style: TextStyle(fontSize: 26, fontFamily: 'NexaRegular', color: Color(0xffffffff),),),
            centerTitle: false,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Color(0xffffffff), size: 35,),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
            actions: [
              GestureDetector(
                child: const Center(child: Text('Add Friends', style: TextStyle(fontSize: 26, fontFamily: 'NexaRegular', color: Color(0xffffffff),),),),
                onTap: (){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeRegularSearchUser(isFamily: false, memorialId: widget.memorialId, memorialName: widget.memorialName, switchFamily: widget.switchFamily, switchFriends: widget.switchFriends, switchFollowers: widget.switchFollowers)));
                },
              ),
            ],
          ),
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: onRefresh,
              child: FutureBuilder<List<APIRegularShowFriendsSettingsExtended>>(
                future: showListOfFriends,
                builder: (context, friends){
                  if(friends.connectionState == ConnectionState.done){
                    if(loadedListener && lengthOfFriendsListener == 0){
                      return SingleChildScrollView(
                        physics: const ClampingScrollPhysics(),
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: (SizeConfig.screenHeight! - 85 - kToolbarHeight) / 3.5,),

                              Image.asset('assets/icons/app-icon.png', height: 200, width: 200,),

                              const SizedBox(height: 45,),

                              const Text('Friends list is empty', textAlign: TextAlign.center, style: TextStyle(fontSize: 36, fontFamily: 'NexaBold', color: Color(0xffB1B1B1),),),

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
                        itemCount: lengthOfFriendsListener,
                        itemBuilder: (c, i){
                          return ListTile(
                            leading: friends.data![i].showFriendsSettingsUser.showFriendsSettingsDetailsImage != ''
                            ? CircleAvatar(
                              maxRadius: 40,
                              backgroundColor: const Color(0xff888888),
                              foregroundImage: NetworkImage(friends.data![i].showFriendsSettingsUser.showFriendsSettingsDetailsImage,),
                            )
                            : const CircleAvatar(
                              maxRadius: 40,
                              backgroundColor: Color(0xff888888),
                              foregroundImage: AssetImage('assets/icons/user-placeholder.png',),
                            ),
                            title: Text('${friends.data![i].showFriendsSettingsUser.showFriendsSettingsDetailsFirstName} ${friends.data![i].showFriendsSettingsUser.showFriendsSettingsDetailsLastName}', style: const TextStyle(fontSize: 20, fontFamily: 'NexaBold', color: Color(0xff000000),),),
                            subtitle: Text(friends.data![i].showFriendsSettingsUser.showFriendsSettingsDetailsEmail, style: const TextStyle(fontSize: 16, fontFamily: 'NexaRegular', color: Color(0xffBDC3C7),),),
                            trailing: MaterialButton(
                              child: const Text('Remove', style: TextStyle(fontSize: 20, fontFamily: 'HelveticaRegular', color: Color(0xffffffff),),),
                              shape: const StadiumBorder(side: BorderSide(color: Color(0xffE74C3C)),),
                              minWidth: SizeConfig.screenWidth! / 3.5,
                              splashColor: const Color(0xff04ECFF),
                              textColor: const Color(0xffffffff),
                              color: const Color(0xffE74C3C),
                              padding: EdgeInsets.zero,
                              height: 40,
                              onPressed: () async{
                                bool confirmation = await showDialog(
                                  context: context,
                                  builder: (context) => CustomDialog(
                                    image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                    title: 'Confirm',
                                    description: 'Are you sure you want to remove this user?',
                                    includeOkButton: true,
                                    includeCancelButton: true,
                                  ),
                                );

                                if(confirmation){
                                  context.loaderOverlay.show();
                                  String result = await apiRegularDeleteMemorialFriendsOrFamily(memorialId: widget.memorialId, userId: friends.data![i].showFriendsSettingsUser.showFriendsSettingsDetailsId, accountType: friends.data![i].showFriendsSettingsUser.showFriendsSettingsDetailsAccountType);
                                  context.loaderOverlay.hide();

                                  if(result != 'Success'){
                                    await showDialog(
                                      context: context,
                                      builder: (context) => CustomDialog(
                                        image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                        title: 'Error',
                                        description: 'Error: $result.',
                                        okButtonColor: const Color(0xfff44336), // RED
                                        includeOkButton: true,
                                      ),
                                    );
                                  }else{
                                    await showDialog(
                                      context: context,
                                      builder: (context) => CustomDialog(
                                        image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                        title: 'Success',
                                        description: 'Successfully removed the user from the list.',
                                        okButtonColor: const Color(0xff4caf50), // GREEN
                                        includeOkButton: true,
                                        okButton: (){
                                          onRefresh();

                                          Navigator.pop(context, true);
                                        },
                                      ),
                                    );
                                  }
                                }
                              },
                            ),
                          );
                        },
                      );
                    }
                  }else if(friends.connectionState == ConnectionState.none || friends.connectionState == ConnectionState.waiting){
                    return const Center(child: CustomLoaderThreeDots(),);
                  }else if(friends.hasError){
                    return Center(
                      child: MaterialButton(
                        onPressed: (){
                          onRefresh();
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
          )
        ),
      ),
    );
  }
}