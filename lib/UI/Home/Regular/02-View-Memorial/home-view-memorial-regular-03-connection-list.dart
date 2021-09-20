// ignore_for_file: file_names
import 'package:facesbyplaces/API/Regular/03-View-Memorial/api-view-memorial-regular-04-01-connection-list-family.dart';
import 'package:facesbyplaces/API/Regular/03-View-Memorial/api-view-memorial-regular-04-02-connection-list-friends.dart';
import 'package:facesbyplaces/API/Regular/03-View-Memorial/api-view-memorial-regular-04-03-connection-list-followers.dart';
import 'package:facesbyplaces/UI/Home/Regular/12-Show-User/home-show-user-regular-01-user.dart';
import 'package:facesbyplaces/UI/Home/BLM/12-Show-User/home-show-user-blm-01-user.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:loader_overlay/loader_overlay.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:flutter/material.dart';

class RegularConnectionListItem{
  final int id;
  final int accountType;
  final String firstName;
  final String lastName;
  final String image;
  final String relationship;
  const RegularConnectionListItem({required this.id, required this.accountType, required this.firstName, required this.lastName, required this.image, required this.relationship});
}

class HomeRegularConnectionList extends StatefulWidget{
  final int memorialId;
  final int newToggle;
  const HomeRegularConnectionList({required this.memorialId, required this.newToggle});

  HomeRegularConnectionListState createState() => HomeRegularConnectionListState();
}

class HomeRegularConnectionListState extends State<HomeRegularConnectionList>{
  ScrollController scrollController1 = ScrollController();
  ScrollController scrollController2 = ScrollController();
  ScrollController scrollController3 = ScrollController();
  List<RegularConnectionListItem> listsFamily = [];
  List<RegularConnectionListItem> listsFriends = [];
  List<RegularConnectionListItem> listsFollowers = [];
  List<RegularConnectionListItem> searches = [];
  ValueNotifier<bool> onSearch = ValueNotifier<bool>(false);
  ValueNotifier<int> toggle = ValueNotifier<int>(0);
  ValueNotifier<int> count1 = ValueNotifier<int>(0);
  ValueNotifier<int> count2 = ValueNotifier<int>(0);
  ValueNotifier<int> count3 = ValueNotifier<int>(0);
  ValueNotifier<int> count4 = ValueNotifier<int>(0);
  String searchKeyword = '';
  int itemRemaining1 = 1;
  int itemRemaining2 = 1;
  int itemRemaining3 = 1;
  int page1 = 1;
  int page2 = 1;
  int page3 = 1;

  void initState() {
    super.initState();
    toggle.value = widget.newToggle;
    onLoading1();
    onLoading2();
    onLoading3();
    scrollController1.addListener((){
      if(scrollController1.position.pixels == scrollController1.position.maxScrollExtent){
        if(itemRemaining1 != 0){
          onLoading1();
        }else{
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: const Text('No more connection list family to show'),
              duration: const Duration(seconds: 1),
              backgroundColor: const Color(0xff4EC9D4),
            ),
          );
        }
      }
    });
    scrollController2.addListener((){
      if(scrollController2.position.pixels == scrollController2.position.maxScrollExtent){
        if(itemRemaining2 != 0){
          onLoading1();
        }else{
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: const Text('No more connection list friends to show'),
              duration: const Duration(seconds: 1),
              backgroundColor: const Color(0xff4EC9D4),
            ),
          );
        }
      }
    });
    scrollController3.addListener((){
      if(scrollController3.position.pixels == scrollController3.position.maxScrollExtent){
        if(itemRemaining3 != 0){
          onLoading1();
        }else{
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: const Text('No more connection list followers to show'),
              duration: const Duration(seconds: 1),
              backgroundColor: const Color(0xff4EC9D4),
            ),
          );
        }
      }
    });
  }

  Future<void> onRefresh1() async{
    onLoading1();
  }

  Future<void> onRefresh2() async{
    onLoading2();
  }

  Future<void> onRefresh3() async{
    onLoading3();
  }

  void onLoading1() async{
    if(itemRemaining1 != 0){
      context.loaderOverlay.show();
      var newValue = await apiRegularConnectionListFamily(memorialId: widget.memorialId, page: page1).onError((error, stackTrace){
        context.loaderOverlay.hide();
        showDialog(
          context: context,
          builder: (_) => AssetGiffyDialog(
            title: const Text('Error', textAlign: TextAlign.center, style: const TextStyle(fontSize: 32, fontFamily: 'NexaRegular'),),
            description: Text('Error: $error.', textAlign: TextAlign.center, style: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular',),),
            image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
            entryAnimation: EntryAnimation.DEFAULT,
            buttonOkColor: const Color(0xffff0000),
            onlyOkButton: true,
            onOkButtonPressed: (){
              Navigator.pop(context, true);
              Navigator.pop(context, true);
            },
          ),
        );
        throw Exception('$error');
      });
      context.loaderOverlay.hide();

      itemRemaining1 = newValue.almItemsRemaining;
      count1.value = count1.value + newValue.almFamilyList.length;

      for(int i = 0; i < newValue.almFamilyList.length; i++){
        listsFamily.add(
          RegularConnectionListItem(
            id: newValue.almFamilyList[i].connectionListFamilyUser.connectionListFamilyDetailsId,
            accountType: newValue.almFamilyList[i].connectionListFamilyUser.connectionListFamilyAccountType,
            firstName: newValue.almFamilyList[i].connectionListFamilyUser.connectionListFamilyDetailsFirstName,
            lastName: newValue.almFamilyList[i].connectionListFamilyUser.connectionListFamilyDetailsLastName,
            image: newValue.almFamilyList[i].connectionListFamilyUser.connectionListFamilyDetailsImage,
            relationship: newValue.almFamilyList[i].connectionListFamilyRelationship,
          ),
        );
      }

      if (mounted)
      page1++;
    }
  }

  void onLoading2() async{
    if(itemRemaining2 != 0){
      context.loaderOverlay.show();
      var newValue = await apiRegularConnectionListFriends(memorialId: widget.memorialId, page: page2).onError((error, stackTrace){
        context.loaderOverlay.hide();
        showDialog(
          context: context,
          builder: (_) => AssetGiffyDialog(
            title: const Text('Error', textAlign: TextAlign.center, style: const TextStyle(fontSize: 32, fontFamily: 'NexaRegular'),),
            description: Text('Error: $error.', textAlign: TextAlign.center, style: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular',),),
            image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
            entryAnimation: EntryAnimation.DEFAULT,
            buttonOkColor: const Color(0xffff0000),
            onlyOkButton: true,
            onOkButtonPressed: (){
              Navigator.pop(context, true);
              Navigator.pop(context, true);
            },
          ),
        );
        throw Exception('$error');
      });
      context.loaderOverlay.hide();

      itemRemaining2 = newValue.almItemsRemaining;
      count2.value = count2.value + newValue.almFriendsList.length;

      for(int i = 0; i < newValue.almFriendsList.length; i++){
        listsFriends.add(
          RegularConnectionListItem(
            id: newValue.almFriendsList[i].connectionListFriendsUser.connectionListFriendsDetailsId,
            accountType: newValue.almFriendsList[i].connectionListFriendsUser.connectionListFriendsAccountType,
            firstName: newValue.almFriendsList[i].connectionListFriendsUser.connectionListFriendsDetailsFirstName,
            lastName: newValue.almFriendsList[i].connectionListFriendsUser.connectionListFriendsDetailsLastName,
            image: newValue.almFriendsList[i].connectionListFriendsUser.connectionListFriendsDetailsImage,
            relationship: 'Friend',
          ),
        );
      }

      if (mounted)
      page2++;
    }
  }

  void onLoading3() async{
    if(itemRemaining3 != 0){
      context.loaderOverlay.show();
      var newValue = await apiRegularConnectionListFollowers(memorialId: widget.memorialId, page: page3).onError((error, stackTrace){
        context.loaderOverlay.hide();
        showDialog(
          context: context,
          builder: (_) => AssetGiffyDialog(
            title: const Text('Error', textAlign: TextAlign.center, style: const TextStyle(fontSize: 32, fontFamily: 'NexaRegular'),),
            description: Text('Error: $error.', textAlign: TextAlign.center, style: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular',),),
            image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
            entryAnimation: EntryAnimation.DEFAULT,
            buttonOkColor: const Color(0xffff0000),
            onlyOkButton: true,
            onOkButtonPressed: (){
              Navigator.pop(context, true);
              Navigator.pop(context, true);
            },
          ),
        );
        throw Exception('$error');
      });
      context.loaderOverlay.hide();

      itemRemaining3 = newValue.almItemsRemaining;
      count3.value = count3.value + newValue.almFollowersList.length;

      for(int i = 0; i < newValue.almFollowersList.length; i++){
        listsFollowers.add(
          RegularConnectionListItem(
            id: newValue.almFollowersList[i].connectionListFollowersDetailsId,
            accountType: newValue.almFollowersList[i].connectionListFollowersAccountType,
            firstName: newValue.almFollowersList[i].connectionListFollowersDetailsFirstName,
            lastName: newValue.almFollowersList[i].connectionListFollowersDetailsLastName,
            image: newValue.almFollowersList[i].connectionListFollowersDetailsImage,
            relationship: 'Follower',
          ),
        );
      }

      if (mounted)
      page3++;
    }
  }

  @override
  Widget build(BuildContext context){
    SizeConfig.init(context);
    return WillPopScope(
      onWillPop: () async{
        return Navigator.canPop(context);
      },
      child: GestureDetector(
        onTap: (){
          FocusNode currentFocus = FocusScope.of(context);
          if(!currentFocus.hasPrimaryFocus){
            currentFocus.unfocus();
          }
        },
        child: ValueListenableBuilder(
          valueListenable: toggle,
          builder: (_, int toggleListener, __) => Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(70.0),
              child: AppBar(
                leading: Container(),
                backgroundColor: const Color(0xff04ECFF),
                flexibleSpace: Column(
                  children: [
                    const Spacer(),

                    Row(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back, color: const Color(0xffffffff), size: 35,),
                            onPressed: (){
                              Navigator.pop(context);
                            },
                          ),
                        ),

                        Expanded(
                          child: TextFormField(
                            style: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: const Color(0xff2F353D),),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(15.0),
                              focusColor: const Color(0xffffffff),
                              fillColor: const Color(0xffffffff),
                              filled: true,
                              hintText: ((){
                                switch (toggleListener){
                                  case 0: return 'Search Family';
                                  case 1: return 'Search Friends';
                                  case 2: return 'Search Followers';
                                }
                              }()),
                              enabledBorder: const OutlineInputBorder(borderSide: const BorderSide(color: const Color(0xffffffff)), borderRadius: const BorderRadius.all(Radius.circular(25)),),
                              focusedBorder: const OutlineInputBorder(borderSide: const BorderSide(color: const Color(0xffffffff)), borderRadius: const BorderRadius.all(Radius.circular(25)),),
                              border: const OutlineInputBorder(borderSide: const BorderSide(color: const Color(0xffffffff)), borderRadius: const BorderRadius.all(Radius.circular(25),),),
                              hintStyle: const TextStyle(fontSize: 22, fontFamily: 'NexaRegular', color: const Color(0xffB1B1B1),),
                              prefixIcon: const Icon(Icons.search, color: const Color(0xff888888)),
                            ),
                            onChanged: (search){
                              searchKeyword = search;

                              if(search == ''){
                                onSearch.value = false;
                                searches = [];
                                count4.value = searches.length;
                              }else{
                                onSearch.value = true;
                              }

                              if(onSearch.value == true){
                                if(toggle.value == 0){
                                  searches = listsFamily;
                                  count4.value = searches.length;
                                  if(searches.length != 0){
                                    for(int i = 0; i < listsFamily.length; i++){
                                      searches = searches.where((element) => element.firstName.toUpperCase().contains(searchKeyword.toUpperCase()) || element.lastName.toUpperCase().contains(searchKeyword.toUpperCase())).toList();
                                      count4.value = searches.length;
                                    }
                                  }
                                }else if(toggle.value == 1){
                                  searches = listsFriends;
                                  count4.value = searches.length;
                                  if(searches.length != 0){
                                    for(int i = 0; i < listsFriends.length; i++){
                                      searches = searches.where((element) => element.firstName.toUpperCase().contains(searchKeyword.toUpperCase()) || element.lastName.toUpperCase().contains(searchKeyword.toUpperCase())).toList();
                                      count4.value = searches.length;
                                    }
                                  }
                                }else if(toggle.value == 2){
                                  searches = listsFollowers;
                                  count4.value = searches.length;
                                  if(searches.length != 0){
                                    for(int i = 0; i < listsFollowers.length; i++){
                                      searches = searches.where((element) => element.firstName.toUpperCase().contains(searchKeyword.toUpperCase()) || element.lastName.toUpperCase().contains(searchKeyword.toUpperCase())).toList();
                                      count4.value = searches.length;
                                    }
                                  }
                                }
                              }
                            },
                          ),
                        ),

                        const SizedBox(width: 20,),
                      ],
                    ),

                    const SizedBox(height: 5,),
                  ],
                ),
              ),
            ),
            body: Column(
              children: [
                Container(
                  width: SizeConfig.screenWidth,
                  height: 70,
                  color: const Color(0xffffffff),
                  child: DefaultTabController(
                    initialIndex: toggleListener,
                    length: 3,
                    child: TabBar(
                      unselectedLabelColor: const Color(0xff2F353D),
                      indicatorSize: TabBarIndicatorSize.label,
                      indicatorColor: const Color(0xff04ECFF),
                      labelColor: const Color(0xff04ECFF),
                      indicatorWeight: 5,
                      onTap: (int number) {
                        toggle.value = number;
                        searches = [];

                        if(onSearch.value == true){
                          if(toggle.value == 0){
                            searches = listsFamily;
                            count4.value = searches.length;
                            if(searches.length != 0){
                              for(int i = 0; i < listsFamily.length; i++){
                                searches = searches.where((element) => element.firstName.toUpperCase().contains(searchKeyword.toUpperCase()) || element.lastName.toUpperCase().contains(searchKeyword.toUpperCase())).toList();
                                count4.value = searches.length;
                              }
                            }
                          }else if(toggle.value == 1){
                            searches = listsFriends;
                            count4.value = searches.length;
                            if(searches.length != 0){
                              for(int i = 0; i < listsFriends.length; i++){
                                searches = searches.where((element) => element.firstName.toUpperCase().contains(searchKeyword.toUpperCase()) || element.lastName.toUpperCase().contains(searchKeyword.toUpperCase())).toList();
                                count4.value = searches.length;
                              }
                            }
                          }else if(toggle.value == 2){
                            count4.value = 1;
                            searches = listsFollowers;
                            count4.value = searches.length;
                            if(searches.length != 0){
                              for(int i = 0; i < listsFollowers.length; i++){
                                searches = searches.where((element) => element.firstName.toUpperCase().contains(searchKeyword.toUpperCase()) || element.lastName.toUpperCase().contains(searchKeyword.toUpperCase())).toList();
                                count4.value = searches.length;
                              }
                            }
                          }
                        }
                      },
                      tabs: [
                        const Text('Family', style: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular',),),

                        const Text('Friends', style: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular',),),

                        const Text('Followers', style: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular',),),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Expanded(
                  child: ((){
                    switch (toggleListener){
                      case 0: return connectionListFamilyWidget();
                      case 1: return connectionListFriendsWidget();
                      case 2: return connectionListFollowersWidget();
                    }
                  }()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  connectionListFamilyWidget(){
    return ValueListenableBuilder(
      valueListenable: onSearch,
      builder: (_, bool onSearchListener, __) => ValueListenableBuilder(
        valueListenable: count1,
        builder: (_, int count1Listener, __) => ValueListenableBuilder(
          valueListenable: count4,
          builder: (_, int count4Listener, __) => RefreshIndicator(
            onRefresh: onRefresh1,
            child: GridView.count(
              controller: scrollController1,
              physics: const ClampingScrollPhysics(),
              padding: const EdgeInsets.all(10.0),
              crossAxisSpacing: 2,
              mainAxisSpacing: 20,
              crossAxisCount: 4,
              children: List.generate(
                onSearchListener ? count4Listener : count1Listener,
                (int index) => Column(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        child: ((){
                          if(onSearchListener){
                            if(searches[index].image != ''){
                              return CircleAvatar(
                                radius: 40,
                                backgroundColor: const Color(0xff888888),
                                foregroundImage: NetworkImage(searches[index].image),
                              );
                            }else{
                              return const CircleAvatar(
                                radius: 40,
                                backgroundColor: const Color(0xff888888),
                                foregroundImage: const AssetImage('assets/icons/user-placeholder.png'),
                              );
                            }
                          }else{
                            if(listsFamily[index].image != ''){
                              return CircleAvatar(
                                radius: 40,
                                backgroundColor: const Color(0xff888888),
                                foregroundImage: NetworkImage(listsFamily[index].image),
                              );
                            }else{
                              return const CircleAvatar(
                                radius: 40,
                                backgroundColor: const Color(0xff888888),
                                foregroundImage: const AssetImage('assets/icons/user-placeholder.png'),
                              );
                            }
                          }
                        }()),
                        onTap: (){
                          if(onSearchListener){
                            if(searches[index].accountType == 1){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMUserProfile(userId: searches[index].id, accountType: searches[index].accountType,)));
                            }else{
                              Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularUserProfile(userId: searches[index].id, accountType: searches[index].accountType)));
                            }
                          }else{
                            if(listsFamily[index].accountType == 1){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMUserProfile(userId: listsFamily[index].id, accountType: listsFamily[index].accountType)));
                            }else{
                              Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularUserProfile(userId: listsFamily[index].id, accountType: listsFamily[index].accountType)));
                            }
                          }
                        },
                      ),
                    ),

                    const SizedBox(height: 10),

                    onSearchListener
                    ? Text('${searches[index].firstName} ${searches[index].lastName}', 
                      style: const TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: const Color(0xff2F353D),),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.clip,
                      maxLines: 1,
                    )
                    : Text('${listsFamily[index].firstName} ${listsFamily[index].lastName}',
                      style: const TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: const Color(0xff2F353D),),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.clip,
                      maxLines: 1,
                    ),

                    Text('${listsFamily[index].relationship}',
                      style: const TextStyle(fontSize: 18, fontFamily: 'NexaRegular', color: const Color(0xffB1B1B1),),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.clip,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  connectionListFriendsWidget(){
    return ValueListenableBuilder(
      valueListenable: onSearch,
      builder: (_, bool onSearchListener, __) => ValueListenableBuilder(
        valueListenable: count2,
        builder: (_, int count2Listener, __) => ValueListenableBuilder(
          valueListenable: count4,
          builder: (_, int count4Listener, __) => RefreshIndicator(
            onRefresh: onRefresh2,
            child: GridView.count(
              controller: scrollController2,
              physics: const ClampingScrollPhysics(),
              padding: const EdgeInsets.all(10.0),
              crossAxisSpacing: 2,
              mainAxisSpacing: 20,
              crossAxisCount: 4,
              children: List.generate(
                onSearchListener ? count4Listener : count2Listener,
                (index) => Column(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        child: ((){
                          if(onSearchListener){
                            if(searches[index].image != ''){
                              return CircleAvatar(
                                radius: 40,
                                backgroundColor: const Color(0xff888888),
                                foregroundImage: NetworkImage(searches[index].image),
                              );
                            }else{
                              return const CircleAvatar(
                                radius: 40,
                                backgroundColor: const Color(0xff888888),
                                foregroundImage: const AssetImage('assets/icons/user-placeholder.png'),
                              );
                            }
                          }else{
                            if(listsFriends[index].image != ''){
                              return CircleAvatar(
                                radius: 40,
                                backgroundColor: const Color(0xff888888),
                                foregroundImage: NetworkImage(listsFriends[index].image),
                              );
                            }else{
                              return const CircleAvatar(
                                radius: 40,
                                backgroundColor: const Color(0xff888888),
                                foregroundImage: const AssetImage('assets/icons/user-placeholder.png'),
                              );
                            }
                          }
                        }()),
                        onTap: (){
                          if(onSearchListener){
                            if(searches[index].accountType == 1){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMUserProfile(userId: searches[index].id, accountType: searches[index].accountType)));
                            }else{
                              Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularUserProfile(userId: searches[index].id, accountType: searches[index].accountType)));
                            }
                          }else{
                            if(listsFriends[index].accountType == 1){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMUserProfile(userId: listsFriends[index].id, accountType: listsFriends[index].accountType)));
                            }else{
                              Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularUserProfile(userId: listsFriends[index].id, accountType: listsFriends[index].accountType)));
                            }
                          }
                        },
                      ),
                    ),

                    const SizedBox(height: 10),

                    onSearchListener
                    ? Text('${searches[index].firstName} ${searches[index].lastName}',
                      style: const TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: const Color(0xff2F353D),),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.clip,
                      maxLines: 1,
                    )
                    : Text('${listsFriends[index].firstName} ${listsFriends[index].lastName}',
                      style: const TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: const Color(0xff2F353D),),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.clip,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  connectionListFollowersWidget(){
    return ValueListenableBuilder(
      valueListenable: onSearch,
      builder: (_, bool onSearchListener, __) => ValueListenableBuilder(
        valueListenable: count3,
        builder: (_, int count3Listener, __) => ValueListenableBuilder(
          valueListenable: count4,
          builder: (_, int count4Listener, __) => RefreshIndicator(
            onRefresh: onRefresh3,
            child: GridView.count(
              controller: scrollController3,
              physics: const ClampingScrollPhysics(),
              padding: const EdgeInsets.all(10.0),
              crossAxisSpacing: 2,
              mainAxisSpacing: 20,
              crossAxisCount: 4,
              children: List.generate(
                onSearchListener ? count4Listener : count3Listener,
                (index) => Column(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: (){
                          if(onSearchListener){
                            if(searches[index].accountType == 1){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMUserProfile(userId: searches[index].id, accountType: searches[index].accountType)));
                            }else{
                              Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularUserProfile(userId: searches[index].id, accountType: searches[index].accountType)));
                            }
                          }else{
                            if(listsFollowers[index].accountType == 1){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMUserProfile(userId: listsFollowers[index].id, accountType: listsFollowers[index].accountType)));
                            }else{
                              Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularUserProfile(userId: listsFollowers[index].id, accountType: listsFollowers[index].accountType)));
                            }
                          }
                        },
                        child: ((){
                          if(onSearchListener){
                            if(searches[index].image != ''){
                              return CircleAvatar(
                                radius: 40,
                                backgroundColor: const Color(0xff888888),
                                foregroundImage: NetworkImage(searches[index].image),
                              );
                            }else{
                              return const CircleAvatar(
                                radius: 40,
                                backgroundColor: const Color(0xff888888),
                                foregroundImage: const AssetImage('assets/icons/user-placeholder.png'),
                              );
                            }
                          }else{
                            if(listsFollowers[index].image != ''){
                              return CircleAvatar(
                                radius: 40,
                                backgroundColor: const Color(0xff888888),
                                foregroundImage: NetworkImage(listsFollowers[index].image),
                              );
                            }else{
                              return const CircleAvatar(
                                radius: 40,
                                backgroundColor: const Color(0xff888888),
                                foregroundImage: const AssetImage('assets/icons/user-placeholder.png'),
                              );
                            }
                          }
                        }()),
                      ),
                    ),

                    const SizedBox(height: 10),

                    onSearchListener
                    ? Text('${searches[index].firstName} ${searches[index].lastName}',
                      style: const TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: const Color(0xff2F353D),),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.clip,
                      maxLines: 1,
                    )
                    : Text('${listsFollowers[index].firstName} ${listsFollowers[index].lastName}',
                      style: const TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: const Color(0xff2F353D),),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.clip,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}