import 'package:facesbyplaces/API/Regular/03-View-Memorial/api_view_memorial_regular_04_01_connection_list_family.dart';
import 'package:facesbyplaces/API/Regular/03-View-Memorial/api_view_memorial_regular_04_02_connection_list_friends.dart';
import 'package:facesbyplaces/API/Regular/03-View-Memorial/api_view_memorial_regular_04_03_connection_list_followers.dart';
import 'package:facesbyplaces/UI/Home/Regular/12-Show-User/home_show_user_regular_01_user.dart';
import 'package:facesbyplaces/UI/Home/BLM/12-Show-User/home_show_user_blm_01_user.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:loader/loader.dart';
import 'package:dialog/dialog.dart';

class HomeRegularConnectionList extends StatefulWidget{
  final int memorialId;
  final int newToggle;
  const HomeRegularConnectionList({Key? key, required this.memorialId, required this.newToggle}) : super(key: key);

  @override
  HomeRegularConnectionListState createState() => HomeRegularConnectionListState();
}

class HomeRegularConnectionListState extends State<HomeRegularConnectionList>{
  ValueNotifier<String> searchKey = ValueNotifier<String>('');
  TextEditingController controller = TextEditingController();
  ValueNotifier<bool> onSearch = ValueNotifier<bool>(false);
  ValueNotifier<int> toggle = ValueNotifier<int>(0);

  Future<List<APIRegularConnectionListFamilyExtended>>? showListOfConnectionListFamily;
  ScrollController scrollController1 = ScrollController();
  ValueNotifier<int> lengthOfConnectionListFamily = ValueNotifier<int>(0);
  ValueNotifier<bool> loaded1 = ValueNotifier<bool>(false);
  bool updatedConnectionListFamilyData = false;
  int page1 = 1;

  Future<List<APIRegularConnectionListFriendsExtended>>? showListOfConnectionListFriends;
  ScrollController scrollController2 = ScrollController();
  ValueNotifier<int> lengthOfConnectionListFriends = ValueNotifier<int>(0);
  ValueNotifier<bool> loaded2 = ValueNotifier<bool>(false);
  bool updatedConnectionListFriendsData = false;
  int page2 = 1;

  Future<List<APIRegularConnectionListFollowersExtendedDetails>>? showListOfConnectionListFollowers;
  ScrollController scrollController3 = ScrollController();
  ValueNotifier<int> lengthOfConnectionListFollowers = ValueNotifier<int>(0);
  ValueNotifier<bool> loaded3 = ValueNotifier<bool>(false);
  bool updatedConnectionListFollowersData = false;
  int page3 = 1;

  @override
  void initState(){
    super.initState();
    toggle.value = widget.newToggle;
    showListOfConnectionListFamily = connectionListFamily(page: page1);
    showListOfConnectionListFriends = connectionListFriends(page: page2);
    showListOfConnectionListFollowers = connectionListFollowers(page: page3);
  }

  Future<void> onRefresh1() async{
    page1 = 1;
    loaded1.value = false;
    updatedConnectionListFamilyData = false;
    lengthOfConnectionListFamily.value = 0;
    showListOfConnectionListFamily = connectionListFamily(page: page1);
  }

  Future<void> onRefresh2() async{
    page2 = 1;
    loaded2.value = false;
    updatedConnectionListFriendsData = false;
    lengthOfConnectionListFriends.value = 0;
    showListOfConnectionListFriends = connectionListFriends(page: page2);
  }

  Future<void> onRefresh3() async{
    page3 = 1;
    loaded3.value = false;
    updatedConnectionListFollowersData = false;
    lengthOfConnectionListFollowers.value = 0;
    showListOfConnectionListFollowers = connectionListFollowers(page: page3);
  }

  Future<List<APIRegularConnectionListFamilyExtended>> connectionListFamily({required int page}) async{
    APIRegularConnectionListFamilyMain? newValue;
    List<APIRegularConnectionListFamilyExtended> listOfConnectionListFamily = [];

    do{
      newValue = await apiRegularConnectionListFamily(memorialId: widget.memorialId, page: page).onError((error, stackTrace){
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
      listOfConnectionListFamily.addAll(newValue.almFamilyList);

      if(newValue.almItemsRemaining != 0){
        page++;
      }else if(lengthOfConnectionListFamily.value > 0 && listOfConnectionListFamily.length > lengthOfConnectionListFamily.value){
        updatedConnectionListFamilyData = true;
      }
    }while(newValue.almItemsRemaining != 0);

    lengthOfConnectionListFamily.value = listOfConnectionListFamily.length; // COMPARISON FOR NEXT PAGINATION & NUMBER OF FEEDS
    page1 = page;
    loaded1.value = true;
    
    return listOfConnectionListFamily;
  }

  Future<List<APIRegularConnectionListFriendsExtended>> connectionListFriends({required int page}) async{
    APIRegularConnectionListFriendsMain? newValue;
    List<APIRegularConnectionListFriendsExtended> listOfConnectionListFriends = [];

    do{
      newValue = await apiRegularConnectionListFriends(memorialId: widget.memorialId, page: page).onError((error, stackTrace){
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
      listOfConnectionListFriends.addAll(newValue.almFriendsList);

      if(newValue.almItemsRemaining != 0){
        page++;
      }else if(lengthOfConnectionListFriends.value > 0 && listOfConnectionListFriends.length > lengthOfConnectionListFriends.value){
        updatedConnectionListFriendsData = true;
      }
    }while(newValue.almItemsRemaining != 0);

    lengthOfConnectionListFriends.value = listOfConnectionListFriends.length; // COMPARISON FOR NEXT PAGINATION & NUMBER OF FEEDS
    page2 = page;
    loaded2.value = true;
    
    return listOfConnectionListFriends;
  }

  Future<List<APIRegularConnectionListFollowersExtendedDetails>> connectionListFollowers({required int page}) async{
    APIRegularConnectionListFollowersMain? newValue;
    List<APIRegularConnectionListFollowersExtendedDetails> listOfConnectionListFollowers = [];

    do{
      newValue = await apiRegularConnectionListFollowers(memorialId: widget.memorialId, page: page).onError((error, stackTrace){
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
      listOfConnectionListFollowers.addAll(newValue.almFollowersList);

      if(newValue.almItemsRemaining != 0){
        page++;
      }else if(lengthOfConnectionListFollowers.value > 0 && listOfConnectionListFollowers.length > lengthOfConnectionListFollowers.value){
        updatedConnectionListFollowersData = true;
      }
    }while(newValue.almItemsRemaining != 0);

    lengthOfConnectionListFollowers.value = listOfConnectionListFollowers.length; // COMPARISON FOR NEXT PAGINATION & NUMBER OF FEEDS
    page3 = page;
    loaded3.value = true;
    
    return listOfConnectionListFollowers;
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
          builder: (_, int toggleListener, __) => ValueListenableBuilder(
            valueListenable: onSearch,
            builder: (_, bool onSearchListener, __) => ValueListenableBuilder(
              valueListenable: searchKey,
              builder: (_, String searchKeyListener, __) => Scaffold(
                appBar: PreferredSize(
                  preferredSize: const Size.fromHeight(70.0),
                  child: AppBar(
                    leading: const SizedBox(),
                    backgroundColor: const Color(0xff04ECFF),
                    flexibleSpace: Column(
                      children: [
                        const Spacer(),

                        Row(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: IconButton(
                                icon: const Icon(Icons.arrow_back, color: Color(0xffffffff), size: 35,),
                                onPressed: (){
                                  Navigator.pop(context);
                                },
                              ),
                            ),

                            Expanded(
                              child: TextFormField(
                                controller: controller,
                                style: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xff2F353D),),
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
                                  enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color(0xffffffff)), borderRadius: BorderRadius.all(Radius.circular(25)),),
                                  focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color(0xffffffff)), borderRadius: BorderRadius.all(Radius.circular(25)),),
                                  border: const OutlineInputBorder(borderSide: BorderSide(color: Color(0xffffffff)), borderRadius: BorderRadius.all(Radius.circular(25),),),
                                  hintStyle: const TextStyle(fontSize: 22, fontFamily: 'NexaRegular', color: Color(0xffB1B1B1),),
                                  prefixIcon: IconButton(
                                    icon: const Icon(Icons.search, color: Color(0xff888888), size: 35,),
                                    onPressed: () async{
                                      if(controller.text == ''){
                                        onSearch.value = false;
                                        searchKey.value = '';
                                      }else{
                                        onSearch.value = true;
                                        searchKey.value = controller.text;
                                      }
                                    },
                                  ),
                                ),
                                onFieldSubmitted: (search){
                                  if(search == ''){
                                    onSearch.value = false;
                                    searchKey.value = '';
                                  }else{
                                    onSearch.value = true;
                                    searchKey.value = controller.text;
                                  }
                                },
                                onChanged: (search){
                                  if(search == ''){
                                    onSearch.value = false;
                                    searchKey.value = '';
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
                        onTap: (int number){
                          toggle.value = number;

                          if(onSearchListener){
                            onSearch.value = true;
                            searchKey.value = controller.text;
                          }
                        },
                        tabs: const[
                          Text('Family', textAlign: TextAlign.center, overflow: TextOverflow.clip, style: TextStyle(fontSize: 20, fontFamily: 'NexaRegular',),),

                          Text('Friends', textAlign: TextAlign.center, overflow: TextOverflow.clip, style: TextStyle(fontSize: 20, fontFamily: 'NexaRegular',),),

                          Text('Followers', textAlign: TextAlign.center, overflow: TextOverflow.clip, style: TextStyle(fontSize: 20, fontFamily: 'NexaRegular',),),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Expanded(
                    child: ((){
                      switch (toggleListener){
                        case 0: return connectionListFamilyWidget(onSearch: onSearchListener, searchKey: searchKeyListener);
                        case 1: return connectionListFriendsWidget(onSearch: onSearchListener, searchKey: searchKeyListener);
                        case 2: return connectionListFollowersWidget(onSearch: onSearchListener, searchKey: searchKeyListener);
                      }
                    }()),
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

  connectionListFamilyWidget({required bool onSearch, required String searchKey}){
    return ValueListenableBuilder(
      valueListenable: lengthOfConnectionListFamily,
      builder: (_, int lengthOfConnectionListFamilyListener, __) => ValueListenableBuilder(
        valueListenable: loaded1,
        builder: (_, bool loaded1Listener, __) => SafeArea(
          child: RefreshIndicator(
            onRefresh: onRefresh1,
            child: FutureBuilder<List<APIRegularConnectionListFamilyExtended>>(
              future: showListOfConnectionListFamily,
              builder: (context, connectionListFamily){
                if(connectionListFamily.connectionState == ConnectionState.done){
                  if(loaded1Listener && lengthOfConnectionListFamilyListener == 0){
                    return SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: (SizeConfig.screenHeight! - 75 - kToolbarHeight) / 4,),

                          Image.asset('assets/icons/app-icon.png', height: 200, width: 200,),

                          const SizedBox(height: 45,),

                          const Text('Family list is empty', style: TextStyle(fontSize: 36, fontFamily: 'NexaBold', color: Color(0xffB1B1B1),),),

                          SizedBox(height: (SizeConfig.screenHeight! - 75 - kToolbarHeight) / 4,),
                        ],
                      ),
                    );
                  }else{
                    return !onSearch
                    ? GridView.count(
                      controller: scrollController1,
                      physics: const ClampingScrollPhysics(),
                      padding: const EdgeInsets.all(10.0),
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 20,
                      crossAxisCount: 4,
                      children: List.generate(
                        lengthOfConnectionListFamilyListener, (int index) => Column(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                child: CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  imageUrl: connectionListFamily.data![index].connectionListFamilyUser.connectionListFamilyDetailsImage,
                                  imageBuilder: (context, imageProvider){
                                    return CircleAvatar(
                                      radius: 40,
                                      backgroundColor: const Color(0xff888888),
                                      foregroundImage: NetworkImage(connectionListFamily.data![index].connectionListFamilyUser.connectionListFamilyDetailsImage),
                                      onForegroundImageError: (object, trace) => Image.asset('assets/icons/user-placeholder.png', fit: BoxFit.contain, scale: 1.0,),
                                    );
                                  },
                                  placeholder: (context, url) => Image.asset('assets/icons/user-placeholder.png', fit: BoxFit.cover, scale: 1.0,),
                                  errorWidget: (context, url, error) => Image.asset('assets/icons/user-placeholder.png', fit: BoxFit.contain, scale: 1.0,),
                                ),
                                onTap: (){
                                  if(connectionListFamily.data![index].connectionListFamilyUser.connectionListFamilyAccountType == 1){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMUserProfile(userId: connectionListFamily.data![index].connectionListFamilyUser.connectionListFamilyDetailsId, accountType: connectionListFamily.data![index].connectionListFamilyUser.connectionListFamilyAccountType)));
                                  }else{
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularUserProfile(userId: connectionListFamily.data![index].connectionListFamilyUser.connectionListFamilyDetailsId, accountType: connectionListFamily.data![index].connectionListFamilyUser.connectionListFamilyAccountType)));
                                  }
                                },
                              ),
                            ),

                            const SizedBox(height: 10),

                            Text('${connectionListFamily.data![index].connectionListFamilyUser.connectionListFamilyDetailsFirstName} ${connectionListFamily.data![index].connectionListFamilyUser.connectionListFamilyDetailsLastName}',
                              style: const TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xff2F353D),),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.clip,
                              maxLines: 1,
                            ),

                            Text(connectionListFamily.data![index].connectionListFamilyRelationship,
                              style: const TextStyle(fontSize: 18, fontFamily: 'NexaRegular', color: Color(0xffB1B1B1),),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.clip,
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),
                    )
                    : GridView.count(
                      controller: scrollController1,
                      physics: const ClampingScrollPhysics(),
                      padding: const EdgeInsets.all(10.0),
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 20,
                      crossAxisCount: 4,
                      children: List.generate(
                        lengthOfConnectionListFamilyListener, (int index){
                          return connectionListFamily.data![index].connectionListFamilyUser.connectionListFamilyDetailsFirstName.toUpperCase().contains(searchKey.toUpperCase()) ||
                          connectionListFamily.data![index].connectionListFamilyUser.connectionListFamilyDetailsLastName.toUpperCase().contains(searchKey.toUpperCase())
                          ? Column(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl: connectionListFamily.data![index].connectionListFamilyUser.connectionListFamilyDetailsImage,
                                    imageBuilder: (context, imageProvider){
                                      return CircleAvatar(
                                        radius: 40,
                                        backgroundColor: const Color(0xff888888),
                                        foregroundImage: NetworkImage(connectionListFamily.data![index].connectionListFamilyUser.connectionListFamilyDetailsImage),
                                        onForegroundImageError: (object, trace) => Image.asset('assets/icons/user-placeholder.png', fit: BoxFit.contain, scale: 1.0,),
                                      );
                                    },
                                    placeholder: (context, url) => Image.asset('assets/icons/user-placeholder.png', fit: BoxFit.cover, scale: 1.0,),
                                    errorWidget: (context, url, error) => Image.asset('assets/icons/user-placeholder.png', fit: BoxFit.contain, scale: 1.0,),
                                  ),
                                  onTap: (){
                                    if(connectionListFamily.data![index].connectionListFamilyUser.connectionListFamilyAccountType == 1){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMUserProfile(userId: connectionListFamily.data![index].connectionListFamilyUser.connectionListFamilyDetailsId, accountType: connectionListFamily.data![index].connectionListFamilyUser.connectionListFamilyAccountType)));
                                    }else{
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularUserProfile(userId: connectionListFamily.data![index].connectionListFamilyUser.connectionListFamilyDetailsId, accountType: connectionListFamily.data![index].connectionListFamilyUser.connectionListFamilyAccountType)));
                                    }
                                  },
                                ),
                              ),

                              const SizedBox(height: 10),

                              Text('${connectionListFamily.data![index].connectionListFamilyUser.connectionListFamilyDetailsFirstName} ${connectionListFamily.data![index].connectionListFamilyUser.connectionListFamilyDetailsLastName}',
                                style: const TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xff2F353D),),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.clip,
                                maxLines: 1,
                              ),

                              Text(connectionListFamily.data![index].connectionListFamilyRelationship,
                                style: const TextStyle(fontSize: 18, fontFamily: 'NexaRegular', color: Color(0xffB1B1B1),),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.clip,
                                maxLines: 1,
                              ),
                            ],
                          )
                          : const SizedBox(height: 0);
                        }
                      ),
                    );
                  }
                }else if(connectionListFamily.connectionState == ConnectionState.none || connectionListFamily.connectionState == ConnectionState.waiting){
                  return const Center(child: CustomLoaderThreeDots(),);
                }
                else if(connectionListFamily.hasError){
                  return Center(
                    child: MaterialButton(
                      onPressed: (){
                        onRefresh1();
                      },
                      child: const Text('Refresh', style: TextStyle(color: Color(0xffffffff))),
                      color: const Color(0xff4EC9D4),
                    ),
                  );
                }else{
                  return const SizedBox(height: 0,);
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  connectionListFriendsWidget({required bool onSearch, required String searchKey}){
    return ValueListenableBuilder(
      valueListenable: lengthOfConnectionListFriends,
      builder: (_, int lengthOfConnectionListFriendsListener, __) => ValueListenableBuilder(
        valueListenable: loaded2,
        builder: (_, bool loaded2Listener, __) => SafeArea(
          child: RefreshIndicator(
            onRefresh: onRefresh2,
            child: FutureBuilder<List<APIRegularConnectionListFriendsExtended>>(
              future: showListOfConnectionListFriends,
              builder: (context, connectionListFriends){
                if(connectionListFriends.connectionState == ConnectionState.done){
                  if(loaded2Listener && lengthOfConnectionListFriendsListener == 0){
                    return SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: (SizeConfig.screenHeight! - 75 - kToolbarHeight) / 4,),

                          Image.asset('assets/icons/app-icon.png', height: 200, width: 200,),

                          const SizedBox(height: 45,),

                          const Text('Friends list is empty', style: TextStyle(fontSize: 36, fontFamily: 'NexaBold', color: Color(0xffB1B1B1),),),

                          SizedBox(height: (SizeConfig.screenHeight! - 75 - kToolbarHeight) / 4,),
                        ],
                      ),
                    );
                  }else{
                    return !onSearch
                    ? GridView.count(
                      controller: scrollController2,
                      physics: const ClampingScrollPhysics(),
                      padding: const EdgeInsets.all(10.0),
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 20,
                      crossAxisCount: 4,
                      children: List.generate(
                        lengthOfConnectionListFriendsListener, (int index) => Column(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                child: CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  imageUrl: connectionListFriends.data![index].connectionListFriendsUser.connectionListFriendsDetailsImage,
                                  imageBuilder: (context, imageProvider){
                                    return CircleAvatar(
                                      radius: 40,
                                      backgroundColor: const Color(0xff888888),
                                      foregroundImage: NetworkImage(connectionListFriends.data![index].connectionListFriendsUser.connectionListFriendsDetailsImage),
                                      onForegroundImageError: (object, trace) => Image.asset('assets/icons/user-placeholder.png', fit: BoxFit.contain, scale: 1.0,),
                                    );
                                  },
                                  placeholder: (context, url) => Image.asset('assets/icons/user-placeholder.png', fit: BoxFit.cover, scale: 1.0,),
                                  errorWidget: (context, url, error) => Image.asset('assets/icons/user-placeholder.png', fit: BoxFit.contain, scale: 1.0,),
                                ),
                                onTap: (){
                                  if(connectionListFriends.data![index].connectionListFriendsUser.connectionListFriendsAccountType == 1){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMUserProfile(userId: connectionListFriends.data![index].connectionListFriendsUser.connectionListFriendsDetailsId, accountType: connectionListFriends.data![index].connectionListFriendsUser.connectionListFriendsAccountType)));
                                  }else{
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularUserProfile(userId: connectionListFriends.data![index].connectionListFriendsUser.connectionListFriendsDetailsId, accountType: connectionListFriends.data![index].connectionListFriendsUser.connectionListFriendsAccountType)));
                                  }
                                },
                              ),
                            ),

                            const SizedBox(height: 10),

                            Text('${connectionListFriends.data![index].connectionListFriendsUser.connectionListFriendsDetailsFirstName} ${connectionListFriends.data![index].connectionListFriendsUser.connectionListFriendsDetailsLastName}',
                              style: const TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xff2F353D),),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.clip,
                              maxLines: 1,
                            ),

                            Text(connectionListFriends.data![index].connectionListFriendsRelationship,
                              style: const TextStyle(fontSize: 18, fontFamily: 'NexaRegular', color: Color(0xffB1B1B1),),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.clip,
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),
                    )
                    : GridView.count(
                      controller: scrollController2,
                      physics: const ClampingScrollPhysics(),
                      padding: const EdgeInsets.all(10.0),
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 20,
                      crossAxisCount: 4,
                      children: List.generate(
                        lengthOfConnectionListFriendsListener, (int index){
                          return connectionListFriends.data![index].connectionListFriendsUser.connectionListFriendsDetailsFirstName.toUpperCase().contains(searchKey.toUpperCase()) ||
                          connectionListFriends.data![index].connectionListFriendsUser.connectionListFriendsDetailsLastName.toUpperCase().contains(searchKey.toUpperCase())
                          ? Column(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl: connectionListFriends.data![index].connectionListFriendsUser.connectionListFriendsDetailsImage,
                                    imageBuilder: (context, imageProvider){
                                      return CircleAvatar(
                                        radius: 40,
                                        backgroundColor: const Color(0xff888888),
                                        foregroundImage: NetworkImage(connectionListFriends.data![index].connectionListFriendsUser.connectionListFriendsDetailsImage),
                                        onForegroundImageError: (object, trace) => Image.asset('assets/icons/user-placeholder.png', fit: BoxFit.contain, scale: 1.0,),
                                      );
                                    },
                                    placeholder: (context, url) => Image.asset('assets/icons/user-placeholder.png', fit: BoxFit.cover, scale: 1.0,),
                                    errorWidget: (context, url, error) => Image.asset('assets/icons/user-placeholder.png', fit: BoxFit.contain, scale: 1.0,),
                                  ),
                                  onTap: (){
                                    if(connectionListFriends.data![index].connectionListFriendsUser.connectionListFriendsAccountType == 1){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMUserProfile(userId: connectionListFriends.data![index].connectionListFriendsUser.connectionListFriendsDetailsId, accountType: connectionListFriends.data![index].connectionListFriendsUser.connectionListFriendsAccountType)));
                                    }else{
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularUserProfile(userId: connectionListFriends.data![index].connectionListFriendsUser.connectionListFriendsDetailsId, accountType: connectionListFriends.data![index].connectionListFriendsUser.connectionListFriendsAccountType)));
                                    }
                                  },
                                ),
                              ),

                              const SizedBox(height: 10),

                              Text('${connectionListFriends.data![index].connectionListFriendsUser.connectionListFriendsDetailsFirstName} ${connectionListFriends.data![index].connectionListFriendsUser.connectionListFriendsDetailsLastName}',
                                style: const TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xff2F353D),),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.clip,
                                maxLines: 1,
                              ),

                              Text(connectionListFriends.data![index].connectionListFriendsRelationship,
                                style: const TextStyle(fontSize: 18, fontFamily: 'NexaRegular', color: Color(0xffB1B1B1),),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.clip,
                                maxLines: 1,
                              ),
                            ],
                          )
                          : const SizedBox(height: 0);
                        },
                      ),
                    );
                  }
                }else if(connectionListFriends.connectionState == ConnectionState.none || connectionListFriends.connectionState == ConnectionState.waiting){
                  return const Center(child: CustomLoaderThreeDots(),);
                }
                else if(connectionListFriends.hasError){
                  return Center(
                    child: MaterialButton(
                      onPressed: (){
                        onRefresh2();
                      },
                      child: const Text('Refresh', style: TextStyle(color: Color(0xffffffff))),
                      color: const Color(0xff4EC9D4),
                    ),
                  );
                }else{
                  return const SizedBox(height: 0,);
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  connectionListFollowersWidget({required bool onSearch, required String searchKey}){
    return ValueListenableBuilder(
      valueListenable: lengthOfConnectionListFollowers,
      builder: (_, int lengthOfConnectionListFollowersListener, __) => ValueListenableBuilder(
        valueListenable: loaded3,
        builder: (_, bool loaded3Listener, __) => SafeArea(
          child: RefreshIndicator(
            onRefresh: onRefresh3,
            child: FutureBuilder<List<APIRegularConnectionListFollowersExtendedDetails>>(
              future: showListOfConnectionListFollowers,
              builder: (context, connectionListFollowers){
                if(connectionListFollowers.connectionState == ConnectionState.done){
                  if(loaded3Listener && lengthOfConnectionListFollowersListener == 0){
                    return SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: (SizeConfig.screenHeight! - 75 - kToolbarHeight) / 4,),

                          Image.asset('assets/icons/app-icon.png', height: 200, width: 200,),

                          const SizedBox(height: 45,),

                          const Text('Followers list is empty', style: TextStyle(fontSize: 36, fontFamily: 'NexaBold', color: Color(0xffB1B1B1),),),

                          SizedBox(height: (SizeConfig.screenHeight! - 75 - kToolbarHeight) / 4,),
                        ],
                      ),
                    );
                  }else{
                    return !onSearch
                    ? GridView.count(
                      controller: scrollController3,
                      physics: const ClampingScrollPhysics(),
                      padding: const EdgeInsets.all(10.0),
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 20,
                      crossAxisCount: 4,
                      children: List.generate(
                        lengthOfConnectionListFollowersListener, (int index) => Column(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                child: CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  imageUrl: connectionListFollowers.data![index].connectionListFollowersDetailsImage,
                                  imageBuilder: (context, imageProvider){
                                    return CircleAvatar(
                                      radius: 40,
                                      backgroundColor: const Color(0xff888888),
                                      foregroundImage: NetworkImage(connectionListFollowers.data![index].connectionListFollowersDetailsImage),
                                      onForegroundImageError: (object, trace) => Image.asset('assets/icons/user-placeholder.png', fit: BoxFit.contain, scale: 1.0,),
                                    );
                                  },
                                  placeholder: (context, url) => Image.asset('assets/icons/user-placeholder.png', fit: BoxFit.cover, scale: 1.0,),
                                  errorWidget: (context, url, error) => Image.asset('assets/icons/user-placeholder.png', fit: BoxFit.contain, scale: 1.0,),
                                ),
                                onTap: (){
                                  if(connectionListFollowers.data![index].connectionListFollowersAccountType == 1){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMUserProfile(userId: connectionListFollowers.data![index].connectionListFollowersDetailsId, accountType: connectionListFollowers.data![index].connectionListFollowersAccountType)));
                                  }else{
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularUserProfile(userId: connectionListFollowers.data![index].connectionListFollowersDetailsId, accountType: connectionListFollowers.data![index].connectionListFollowersAccountType)));
                                  }
                                },
                              ),
                            ),

                            const SizedBox(height: 10),

                            Text('${connectionListFollowers.data![index].connectionListFollowersDetailsFirstName} ${connectionListFollowers.data![index].connectionListFollowersDetailsLastName}',
                              style: const TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xff2F353D),),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.clip,
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),
                    )
                    : GridView.count(
                      controller: scrollController3,
                      physics: const ClampingScrollPhysics(),
                      padding: const EdgeInsets.all(10.0),
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 20,
                      crossAxisCount: 4,
                      children: List.generate(
                        lengthOfConnectionListFollowersListener, (int index){
                          return connectionListFollowers.data![index].connectionListFollowersDetailsFirstName.toUpperCase().contains(searchKey.toUpperCase()) ||
                          connectionListFollowers.data![index].connectionListFollowersDetailsLastName.toUpperCase().contains(searchKey.toUpperCase())
                          ? Column(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl: connectionListFollowers.data![index].connectionListFollowersDetailsImage,
                                    imageBuilder: (context, imageProvider){
                                      return CircleAvatar(
                                        radius: 40,
                                        backgroundColor: const Color(0xff888888),
                                        foregroundImage: NetworkImage(connectionListFollowers.data![index].connectionListFollowersDetailsImage),
                                        onForegroundImageError: (object, trace) => Image.asset('assets/icons/user-placeholder.png', fit: BoxFit.contain, scale: 1.0,),
                                      );
                                    },
                                    placeholder: (context, url) => Image.asset('assets/icons/user-placeholder.png', fit: BoxFit.cover, scale: 1.0,),
                                    errorWidget: (context, url, error) => Image.asset('assets/icons/user-placeholder.png', fit: BoxFit.contain, scale: 1.0,),
                                  ),
                                  onTap: (){
                                    if(connectionListFollowers.data![index].connectionListFollowersAccountType == 1){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMUserProfile(userId: connectionListFollowers.data![index].connectionListFollowersDetailsId, accountType: connectionListFollowers.data![index].connectionListFollowersAccountType)));
                                    }else{
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularUserProfile(userId: connectionListFollowers.data![index].connectionListFollowersDetailsId, accountType: connectionListFollowers.data![index].connectionListFollowersAccountType)));
                                    }
                                  },
                                ),
                              ),

                              const SizedBox(height: 10),

                              Text('${connectionListFollowers.data![index].connectionListFollowersDetailsFirstName} ${connectionListFollowers.data![index].connectionListFollowersDetailsLastName}',
                                style: const TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xff2F353D),),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.clip,
                                maxLines: 1,
                              ),
                            ],
                          )
                          : const SizedBox(height: 0);
                        }
                      ),
                    );
                  }
                }else if(connectionListFollowers.connectionState == ConnectionState.none || connectionListFollowers.connectionState == ConnectionState.waiting){
                  return const Center(child: CustomLoaderThreeDots(),);
                }
                else if(connectionListFollowers.hasError){
                  return Center(
                    child: MaterialButton(
                      onPressed: (){
                        onRefresh3();
                      },
                      child: const Text('Refresh', style: TextStyle(color: Color(0xffffffff))),
                      color: const Color(0xff4EC9D4),
                    ),
                  );
                }else{
                  return const SizedBox(height: 0,);
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}