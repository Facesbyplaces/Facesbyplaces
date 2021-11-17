import 'package:facesbyplaces/API/Regular/08-Search/api_search_regular_02_search_suggested.dart';
import 'package:facesbyplaces/API/Regular/08-Search/api_search_regular_03_search_nearby.dart';
import 'package:facesbyplaces/API/Regular/08-Search/api_search_regular_01_search_posts.dart';
import 'package:facesbyplaces/API/Regular/08-Search/api_search_regular_04_search_blm.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc_01_regular_manage_memorial.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc_02_regular_post.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc_02_blm_post.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:better_player/better_player.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/material.dart';
import 'package:loader/loader.dart';
import 'package:dialog/dialog.dart';
import 'package:mime/mime.dart';
import 'package:misc/misc.dart';
import 'dart:ui';

class HomeRegularPost extends StatefulWidget{
  final String keyword;
  final int newToggle;
  final double latitude;
  final double longitude;
  final String currentLocation;
  const HomeRegularPost({Key? key, required this.keyword, required this.newToggle, required this.latitude, required this.longitude, required this.currentLocation}) : super(key: key);

  @override
  HomeRegularPostState createState() => HomeRegularPostState();
}

class HomeRegularPostState extends State<HomeRegularPost>{
  ValueNotifier<bool> isGuestLoggedIn = ValueNotifier<bool>(true);
  ValueNotifier<bool> onSearch = ValueNotifier<bool>(false);
  ValueNotifier<String> searchKey = ValueNotifier<String>('');
  TextEditingController controller = TextEditingController();
  ValueNotifier<int> toggle = ValueNotifier<int>(0);

  Future<List<APIRegularSearchPostExtended>>? showListOfSearchPosts;
  ScrollController scrollController1 = ScrollController();
  ValueNotifier<int> lengthOfSearchPosts = ValueNotifier<int>(0);
  ValueNotifier<bool> loaded1 = ValueNotifier<bool>(false);
  bool updatedSearchPostsData = false;
  int page1 = 1;

  Future<List<APIRegularSearchSuggestedExtended>>? showListOfSearchSuggested;
  ScrollController scrollController2 = ScrollController();
  ValueNotifier<int> lengthOfSearchSuggested = ValueNotifier<int>(0);
  ValueNotifier<bool> loaded2 = ValueNotifier<bool>(false);
  bool updatedSearchSuggestedData = false;
  int page2 = 1;

  Future<List<APIRegularSearchNearbyExtended>>? showListOfSearchNearby;
  ScrollController scrollController3 = ScrollController();
  ValueNotifier<int> lengthOfSearchNearby = ValueNotifier<int>(0);
  ValueNotifier<bool> loaded3 = ValueNotifier<bool>(false);
  bool updatedSearchNearbyData = false;
  int page3 = 1;

  Future<List<APIRegularSearchBLMMemorialExtended>>? showListOfSearchBLM;
  ScrollController scrollController4 = ScrollController();
  ValueNotifier<int> lengthOfSearchBLM = ValueNotifier<int>(0);
  ValueNotifier<bool> loaded4 = ValueNotifier<bool>(false);
  bool updatedSearchBLMData = false;
  int page4 = 1;

  @override
  void initState(){
    super.initState();
    isGuest();
    toggle.value = widget.newToggle;

    scrollController1.addListener((){ // SHOWS WHEN THE USER HAS REACHED THE BOTTOM OF THE LIST
      if(scrollController1.position.pixels == scrollController1.position.maxScrollExtent){
        if(loaded1.value){
          page1 = 1; // RESET BACK TO ONE FOR PAGINATION OF THE API
          showListOfSearchPosts = searchListOfPosts(page: page1);

          if(updatedSearchPostsData){
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('New posts available. Reload to view.'), 
                duration: const Duration(seconds: 3), backgroundColor: const Color(0xff4EC9D4),
                action: SnackBarAction(
                  label: 'Reload',
                  onPressed: (){
                    onRefresh1();
                  },
                  textColor: Colors.blue,
                ),
              ),
            );
          }else{
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No more posts to show.'), duration: Duration(seconds: 1), backgroundColor: Color(0xff4EC9D4),),);
          }
        }
      }
    });

    scrollController2.addListener((){
      if(scrollController2.position.pixels == scrollController2.position.maxScrollExtent){
        if(loaded2.value){
          page2 = 1; // RESET BACK TO ONE FOR PAGINATION OF THE API
          showListOfSearchSuggested = searchListOfSuggested(page: page2);

          if(updatedSearchSuggestedData){
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('New suggested memorials available. Reload to view.'), 
                duration: const Duration(seconds: 3), backgroundColor: const Color(0xff4EC9D4),
                action: SnackBarAction(
                  label: 'Reload',
                  onPressed: (){
                    onRefresh2();
                  },
                  textColor: Colors.blue,
                ),
              ),
            );
          }else{
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No more suggested memorials to show.'), duration: Duration(seconds: 1), backgroundColor: Color(0xff4EC9D4),),);
          }
        }
      }
    });

    scrollController3.addListener((){
      if(scrollController3.position.pixels == scrollController3.position.maxScrollExtent){
        if(loaded3.value){
          page3 = 1; // RESET BACK TO ONE FOR PAGINATION OF THE API
          showListOfSearchNearby = searchListOfNearby(page: page3);

          if(updatedSearchNearbyData){
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('New nearby memorials available. Reload to view.'), 
                duration: const Duration(seconds: 3), backgroundColor: const Color(0xff4EC9D4),
                action: SnackBarAction(
                  label: 'Reload',
                  onPressed: (){
                    onRefresh3();
                  },
                  textColor: Colors.blue,
                ),
              ),
            );
          }else{
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No more nearby memorials to show.'), duration: Duration(seconds: 1), backgroundColor: Color(0xff4EC9D4),),);
          }
        }
      }
    });

    scrollController4.addListener((){
      if(scrollController4.position.pixels == scrollController4.position.maxScrollExtent){
        if(loaded4.value){
          page4 = 1; // RESET BACK TO ONE FOR PAGINATION OF THE API
          showListOfSearchBLM = searchListOfBLM(page: page4);

          if(updatedSearchBLMData){
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('New BLM memorials available. Reload to view.'), 
                duration: const Duration(seconds: 3), backgroundColor: const Color(0xff4EC9D4),
                action: SnackBarAction(
                  label: 'Reload',
                  onPressed: (){
                    onRefresh4();
                  },
                  textColor: Colors.blue,
                ),
              ),
            );
          }else{
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No more BLM memorials to show.'), duration: Duration(seconds: 1), backgroundColor: Color(0xff4EC9D4),),);
          }
        }
      }
    });
  }

  void isGuest() async{
    final sharedPrefs = await SharedPreferences.getInstance();
    isGuestLoggedIn.value = sharedPrefs.getBool('user-guest-session') ?? false;

    if(isGuestLoggedIn.value != true){
      showListOfSearchPosts = searchListOfPosts(page: page1);
      showListOfSearchSuggested = searchListOfSuggested(page: page2);
      showListOfSearchNearby = searchListOfNearby(page: page3);
      showListOfSearchBLM = searchListOfBLM(page: page4);
    }
  }

  Future<void> onRefresh1() async{ // PULL TO REFRESH FUNCTIONALITY
    page1 = 1;
    loaded1.value = false;
    updatedSearchPostsData = false;
    lengthOfSearchPosts.value = 0;
    showListOfSearchPosts = searchListOfPosts(page: page1);
  }

  Future<void> onRefresh2() async{
    page2 = 1;
    loaded2.value = false;
    updatedSearchSuggestedData = false;
    lengthOfSearchSuggested.value = 0;
    showListOfSearchSuggested = searchListOfSuggested(page: page2);
  }

  Future<void> onRefresh3() async{
    page3 = 1;
    loaded3.value = false;
    updatedSearchNearbyData = false;
    lengthOfSearchNearby.value = 0;
    showListOfSearchNearby = searchListOfNearby(page: page3);
  }

  Future<void> onRefresh4() async{
    page4 = 1;
    loaded4.value = false;
    updatedSearchBLMData = false;
    lengthOfSearchBLM.value = 0;
    showListOfSearchBLM = searchListOfBLM(page: page4);
  }

  Future<List<APIRegularSearchPostExtended>> searchListOfPosts({required int page}) async{
    APIRegularSearchPostMain? newValue;
    List<APIRegularSearchPostExtended> listOfSearchPosts = [];

    do{
      newValue = await apiRegularSearchPosts(keywords: widget.keyword, page: page).onError((error, stackTrace){
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
      listOfSearchPosts.addAll(newValue.almSearchPostList);

      if(newValue.almItemsRemaining != 0){
        page++;
      }else if(lengthOfSearchPosts.value > 0 && listOfSearchPosts.length > lengthOfSearchPosts.value){
        updatedSearchPostsData = true;
      }
    }while(newValue.almItemsRemaining != 0);

    lengthOfSearchPosts.value = listOfSearchPosts.length; // COMPARISON FOR NEXT PAGINATION & NUMBER OF FEEDS
    page1 = page;
    loaded1.value = true;
    
    return listOfSearchPosts;
  }

  Future<List<APIRegularSearchSuggestedExtended>> searchListOfSuggested({required int page}) async{
    APIRegularSearchSuggestedMain? newValue;
    List<APIRegularSearchSuggestedExtended> listOfSearchSuggested = [];

    do{
      newValue = await apiRegularSearchSuggested(page: page).onError((error, stackTrace){
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
      listOfSearchSuggested.addAll(newValue.almSearchSuggestedPages);

      if(newValue.almItemsRemaining != 0){
        page++;
      }else if(lengthOfSearchSuggested.value > 0 && listOfSearchSuggested.length > lengthOfSearchSuggested.value){
        updatedSearchSuggestedData = true;
      }
    }while(newValue.almItemsRemaining != 0);

    lengthOfSearchSuggested.value = listOfSearchSuggested.length; // COMPARISON FOR NEXT PAGINATION & NUMBER OF FEEDS
    page2 = page;
    loaded2.value = true;
    
    return listOfSearchSuggested;
  }

  Future<List<APIRegularSearchNearbyExtended>> searchListOfNearby({required int page}) async{
    APIRegularSearchNearbyMain? newValue;
    List<APIRegularSearchNearbyExtended> listOfSearchNearby = [];

    do{
      newValue = await apiRegularSearchNearby(page: page, latitude: widget.latitude, longitude: widget.longitude).onError((error, stackTrace){
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
      listOfSearchNearby.addAll(newValue.blmList);
      listOfSearchNearby.addAll(newValue.memorialList);

      if(newValue.blmItemsRemaining != 0 || newValue.memorialItemsRemaining != 0){
        page++;
      }else if(lengthOfSearchNearby.value > 0 && listOfSearchNearby.length > lengthOfSearchNearby.value){
        updatedSearchNearbyData = true;
      }
    }while(newValue.blmItemsRemaining != 0 || newValue.memorialItemsRemaining != 0);

    lengthOfSearchNearby.value = listOfSearchNearby.length; // COMPARISON FOR NEXT PAGINATION & NUMBER OF FEEDS
    page3 = page;
    loaded3.value = true;
    
    return listOfSearchNearby;
  }

  Future<List<APIRegularSearchBLMMemorialExtended>> searchListOfBLM({required int page}) async{
    APIRegularSearchBLMMemorialMain? newValue;
    List<APIRegularSearchBLMMemorialExtended> listOfSearchBLM = [];

    do{
      newValue = await apiRegularSearchBLM(page: page, keywords: widget.keyword).onError((error, stackTrace){
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
      listOfSearchBLM.addAll(newValue.blmMemorialList);

      if(newValue.blmItemsRemaining != 0){
        page++;
      }else if(lengthOfSearchBLM.value > 0 && listOfSearchBLM.length > lengthOfSearchBLM.value){
        updatedSearchBLMData = true;
      }
    }while(newValue.blmItemsRemaining != 0);

    lengthOfSearchBLM.value = listOfSearchBLM.length; // COMPARISON FOR NEXT PAGINATION & NUMBER OF FEEDS
    page4 = page;
    loaded4.value = true;
    
    return listOfSearchBLM;
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
            valueListenable: isGuestLoggedIn,
            builder: (_, bool isGuestLoggedInListener, __) => ValueListenableBuilder(
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
                                  keyboardType: TextInputType.text,
                                  controller: controller,
                                  style: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xffB1B1B1),),
                                  decoration: InputDecoration(
                                    enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color(0xffffffff)), borderRadius: BorderRadius.all(Radius.circular(25)),),
                                    focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color(0xffffffff)), borderRadius: BorderRadius.all(Radius.circular(25)),),
                                    border: const OutlineInputBorder(borderSide: BorderSide(color: Color(0xffffffff)), borderRadius: BorderRadius.all(Radius.circular(25)),),
                                    hintStyle: const TextStyle(fontSize: 22, fontFamily: 'NexaRegular', color: Color(0xffB1B1B1),),
                                    contentPadding: const EdgeInsets.all(15.0),
                                    focusColor: const Color(0xffffffff),
                                    fillColor: const Color(0xffffffff),
                                    hintText: 'Search Memorial',
                                    filled: true,
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
                                  onChanged: (search){
                                    if(search == ''){
                                      onSearch.value = false;
                                      searchKey.value = '';
                                    }
                                  },
                                  onFieldSubmitted: (search){
                                    if(search == ''){
                                      onSearch.value = false;
                                      searchKey.value = '';
                                    }else{
                                      onSearch.value = true;
                                      searchKey.value = controller.text;
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
                  body: Container(
                    height: SizeConfig.screenHeight,
                    width: SizeConfig.screenWidth,
                    decoration: const BoxDecoration(color: Color(0xffffffff), image: DecorationImage(fit: BoxFit.cover, image: AssetImage('assets/icons/background2.png'), colorFilter: ColorFilter.srgbToLinearGamma(),),),
                    child: Column(
                      children: [
                        IgnorePointer(
                          ignoring: isGuestLoggedInListener,
                          child: Container(
                            alignment: Alignment.center,
                            height: 55,
                            color: const Color(0xffffffff),
                            child: DefaultTabController(
                              length: 4,
                              child: TabBar(
                                isScrollable: true,
                                labelColor: const Color(0xff04ECFF),
                                unselectedLabelColor: const Color(0xff000000),
                                indicatorColor: const Color(0xff04ECFF),
                                tabs: const [
                                  Center(child: Text('Post', style: TextStyle(fontSize: 22, fontFamily: 'NexaRegular'),),),

                                  Center(child: Text('Suggested', style: TextStyle(fontSize: 22, fontFamily: 'NexaRegular'),),),

                                  Center(child: Text('Nearby', style: TextStyle(fontSize: 22, fontFamily: 'NexaRegular'),),),

                                  Center(child: Text('BLM', style: TextStyle(fontSize: 22, fontFamily: 'NexaRegular'),),),
                                ],
                                onTap: (int number){
                                  toggle.value = number;

                                  if(onSearchListener){
                                    onSearch.value = true;
                                    searchKey.value = controller.text;
                                  }
                                },
                              ),
                            ),
                          ),
                        ),

                        SizedBox(
                          child: ((){
                            switch (toggleListener){
                              case 0: return const SizedBox(height: 20,);
                              case 1: return const SizedBox(height: 20,);
                              case 2: return SizedBox(
                                height: 40,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    children: [
                                      const SizedBox(width: 20,),

                                      const Icon(Icons.location_pin, color: Color(0xff979797),),

                                      const SizedBox(width: 20,),

                                      ((){
                                        if(widget.currentLocation != ''){
                                          return Text(widget.currentLocation, style: const TextStyle(fontSize: 16, fontFamily: 'NexaRegular'),);
                                        }else{
                                          return const Text('', style: TextStyle(color: Color(0xff000000), fontSize: 12,),);
                                        }
                                      }()),
                                    ],
                                  ),
                                ),
                              );
                              case 3: return SizedBox(
                                height: 40,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    children: [
                                      const SizedBox(width: 20,),

                                      const Icon(Icons.location_pin, color: Color(0xff979797),),

                                      const SizedBox(width: 20,),

                                      ((){
                                        if(widget.currentLocation != ''){
                                          return Text(widget.currentLocation, style: const TextStyle(fontSize: 16, fontFamily: 'NexaRegular'),);
                                        }else{
                                          return const Text('', style: TextStyle(color: Color(0xff000000),fontSize: 12,),);
                                        }
                                      }()),
                                    ],
                                  ),
                                ),
                              );
                            }
                          }()),
                        ),

                        Expanded(
                          child: Container(
                            child: isGuestLoggedInListener
                            ? BackdropFilter(filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0), child: const MiscLoginToContinue(),)
                            : ((){
                              switch (toggleListener){
                                case 0: return searchPostExtended(onSearch: onSearchListener, searchKey: searchKeyListener);
                                case 1: return searchSuggestedExtended(onSearch: onSearchListener, searchKey: searchKeyListener);
                                case 2: return searchNearbyExtended(onSearch: onSearchListener, searchKey: searchKeyListener);
                                case 3: return searchBLMExtended(onSearch: onSearchListener, searchKey: searchKeyListener);
                              }
                            }()),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  searchPostExtended({required bool onSearch, required String searchKey}){
    return ValueListenableBuilder(
      valueListenable: lengthOfSearchPosts,
      builder: (_, int lengthOfSearchPostsListener, __) => ValueListenableBuilder(
        valueListenable: loaded1,
        builder: (_, bool loaded1Listener, __) => SafeArea(
          child: RefreshIndicator(
            onRefresh: onRefresh1,
            child: FutureBuilder<List<APIRegularSearchPostExtended>>(
              future: showListOfSearchPosts,
              builder: (context, searchPosts){
                if(searchPosts.connectionState == ConnectionState.done){
                  if(loaded1Listener && lengthOfSearchPostsListener == 0){
                    return SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: (SizeConfig.screenHeight! - 55 - kToolbarHeight) / 4,),
                          
                          Image.asset('assets/icons/app-icon.png', height: 200, width: 200,),

                          const SizedBox(height: 45,),

                          const Text('Post is empty', style: TextStyle(fontSize: 36, fontFamily: 'NexaBold', color: Color(0xffB1B1B1),),),

                          SizedBox(height: (SizeConfig.screenHeight! - 55 - kToolbarHeight) / 4,),
                        ],
                      ),
                    );
                  }else{
                    return !onSearch
                    ? ListView.separated(
                      controller: scrollController1,
                      separatorBuilder: (c, i) => const Divider(height: 10, color: Colors.transparent),
                      physics: const ClampingScrollPhysics(),
                      padding: const EdgeInsets.all(10.0),
                      itemCount: lengthOfSearchPostsListener,
                      itemBuilder: (c, i){
                        return searchPosts.data![i].searchPostPage.searchPostPagePageType == 'Blm'
                        ? MiscBLMPost(
                          key: ValueKey('$i'),
                          userId: searchPosts.data![i].searchPostPage.searchPostPagePageCreator.searchPostPageCreatorId,
                          postId: searchPosts.data![i].searchPostId,
                          memorialId: searchPosts.data![i].searchPostPage.searchPostPageId,
                          memorialName: searchPosts.data![i].searchPostPage.searchPostPageName,
                          timeCreated: timeago.format(DateTime.parse(searchPosts.data![i].searchPostCreatedAt)),
                          managed: searchPosts.data![i].searchPostPage.searchPostPageManage,
                          joined: searchPosts.data![i].searchPostPage.searchPostPageFollower,
                          profileImage: searchPosts.data![i].searchPostPage.searchPostPageProfileImage,
                          numberOfComments: searchPosts.data![i].searchPostNumberOfComments,
                          numberOfLikes: searchPosts.data![i].searchPostNumberOfLikes,
                          likeStatus: searchPosts.data![i].searchPostLikeStatus,
                          numberOfTagged: searchPosts.data![i].searchPostPostTagged.length,
                          taggedFirstName: ((){
                            List<String> firstName = [];
                            for(int j = 0; j < searchPosts.data![i].searchPostPostTagged.length; j++){
                              firstName.add(searchPosts.data![i].searchPostPostTagged[j].searchPostTaggedFirstName);
                            }
                            return firstName;
                          }()),
                          taggedLastName: ((){
                            List<String> lastName = [];
                            for(int j = 0; j < searchPosts.data![i].searchPostPostTagged.length; j++){
                              lastName.add(searchPosts.data![i].searchPostPostTagged[j].searchPostTaggedLastName);
                            }
                            return lastName;
                          }()),
                          taggedId: ((){
                            List<int> id = [];
                            for(int j = 0; j < searchPosts.data![i].searchPostPostTagged.length; j++){
                              id.add(searchPosts.data![i].searchPostPostTagged[j].searchPostTaggedId);
                            }
                            return id;
                          }()),
                          pageType: searchPosts.data![i].searchPostPage.searchPostPagePageType,
                          famOrFriends: searchPosts.data![i].searchPostPage.searchPostPageFamOrFriends,
                          relationship: searchPosts.data![i].searchPostPage.searchPostPageRelationship,
                          location: searchPosts.data![i].searchPostLocation,
                          latitude: searchPosts.data![i].searchPostLatitude,
                          longitude: searchPosts.data![i].searchPostLongitude,
                          contents: [
                            Align(alignment: Alignment.centerLeft, child: Text(searchPosts.data![i].searchPostBody, overflow: TextOverflow.ellipsis, maxLines: 5, style: const TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xff000000),),),),
                                
                            searchPosts.data![i].searchPostImagesOrVideos.isNotEmpty
                            ? Column(
                              children: [
                                const SizedBox(height: 20),
                                
                                SizedBox(
                                  child: ((){
                                    if(searchPosts.data![i].searchPostImagesOrVideos.length == 1){
                                      if(lookupMimeType(searchPosts.data![i].searchPostImagesOrVideos[0])?.contains('video') == true){
                                        return BetterPlayer.network('${searchPosts.data![i].searchPostImagesOrVideos[0]}',
                                          betterPlayerConfiguration: BetterPlayerConfiguration(
                                            placeholder: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 16 / 9),
                                            controlsConfiguration: const BetterPlayerControlsConfiguration(showControls: false,),
                                            aspectRatio: 16 / 9,
                                            fit: BoxFit.contain,
                                          ),
                                        );
                                      }else{
                                        return CachedNetworkImage(
                                          fit: BoxFit.cover,
                                          imageUrl: searchPosts.data![i].searchPostImagesOrVideos[0],
                                          placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                          errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                        );
                                      }
                                    }else if(searchPosts.data![i].searchPostImagesOrVideos.length == 2){
                                      return StaggeredGridView.countBuilder(
                                        staggeredTileBuilder:(int index) => const StaggeredTile.count(2, 2),
                                        physics: const NeverScrollableScrollPhysics(),
                                        padding: EdgeInsets.zero,
                                        crossAxisSpacing: 4.0,
                                        mainAxisSpacing: 4.0,
                                        crossAxisCount: 4,
                                        shrinkWrap: true,
                                        itemCount: 2,
                                        itemBuilder: (BuildContext context, int index) => lookupMimeType(searchPosts.data![i].searchPostImagesOrVideos[index])?.contains('video') == true
                                        ? BetterPlayer.network('${searchPosts.data![i].searchPostImagesOrVideos[index]}',
                                            betterPlayerConfiguration: BetterPlayerConfiguration(placeholder: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 16 / 9),
                                            controlsConfiguration: const BetterPlayerControlsConfiguration(showControls: false,),
                                            aspectRatio: 16 / 9,
                                            fit: BoxFit.contain,
                                          ),
                                        )
                                        : CachedNetworkImage(
                                          fit: BoxFit.cover, 
                                          imageUrl: searchPosts.data![i].searchPostImagesOrVideos[index],
                                          placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                          errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,scale: 1.0,),
                                        ),
                                      );
                                    }else{
                                      return StaggeredGridView.countBuilder(
                                        staggeredTileBuilder: (int index) => StaggeredTile.count(2, index.isEven ? 1 : 2),
                                        physics: const NeverScrollableScrollPhysics(),
                                        padding: EdgeInsets.zero,
                                        crossAxisSpacing: 4.0,
                                        mainAxisSpacing: 4.0,
                                        crossAxisCount: 4,
                                        shrinkWrap: true,
                                        itemCount: 3,
                                        itemBuilder: (BuildContext context, int index) => 
                                        ((){
                                          if(index != 1){
                                            return lookupMimeType(searchPosts.data![i].searchPostImagesOrVideos[index])?.contains('video') == true
                                            ? BetterPlayer.network('${searchPosts.data![i].searchPostImagesOrVideos[index]}',
                                              betterPlayerConfiguration: BetterPlayerConfiguration(
                                                placeholder: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 16 / 9),
                                                controlsConfiguration: const BetterPlayerControlsConfiguration(showControls: false,),
                                                aspectRatio: 16 / 9,
                                                fit: BoxFit.contain,
                                              ),
                                            )
                                            : CachedNetworkImage(
                                              fit: BoxFit.cover,
                                              imageUrl: searchPosts.data![i].searchPostImagesOrVideos[index],
                                              placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                              errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                            );
                                          }else{
                                            return ((){
                                              if(searchPosts.data![i].searchPostImagesOrVideos.length - 3 > 0){
                                                if(lookupMimeType(searchPosts.data![i].searchPostImagesOrVideos[index])?.contains('video') == true){
                                                  return Stack(
                                                    fit: StackFit.expand,
                                                    children: [
                                                      BetterPlayer.network('${searchPosts.data![i].searchPostImagesOrVideos[index]}',
                                                        betterPlayerConfiguration: BetterPlayerConfiguration(
                                                          placeholder: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 16 / 9),
                                                          controlsConfiguration: const BetterPlayerControlsConfiguration(showControls: false,),
                                                          aspectRatio: 16 / 9,
                                                          fit: BoxFit.contain,
                                                        ),
                                                      ),

                                                      Container(color: const Color(0xff000000).withOpacity(0.5),),

                                                      Center(
                                                        child: CircleAvatar(
                                                          radius: 25,
                                                          backgroundColor: const Color(0xffffffff).withOpacity(.5),
                                                          child: Text('${searchPosts.data![i].searchPostImagesOrVideos.length - 3}', style: const TextStyle(fontSize: 32, fontFamily: 'NexaBold', color: Color(0xffFFFFFF),),),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                }else{
                                                  return Stack(
                                                    fit: StackFit.expand,
                                                    children: [
                                                      CachedNetworkImage(
                                                        fit: BoxFit.cover,
                                                        imageUrl: searchPosts.data![i].searchPostImagesOrVideos[index],
                                                        placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                        errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                      ),

                                                      Container(color: const Color(0xff000000).withOpacity(0.5),),
                                                      
                                                      Center(
                                                        child: CircleAvatar(
                                                          radius: 25,
                                                          backgroundColor: const Color(0xffffffff).withOpacity(.5),
                                                          child: Text('${searchPosts.data![i].searchPostImagesOrVideos.length - 3}', style: const TextStyle(fontSize: 32, fontFamily: 'NexaBold', color: Color(0xffFFFFFF),),),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                }
                                              }else{
                                                if(lookupMimeType(searchPosts.data![i].searchPostImagesOrVideos[index])?.contains('video') == true) {
                                                  return BetterPlayer.network('${searchPosts.data![i].searchPostImagesOrVideos[index]}',
                                                    betterPlayerConfiguration: BetterPlayerConfiguration(
                                                      placeholder: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 16 / 9),
                                                      controlsConfiguration: const BetterPlayerControlsConfiguration(showControls: false,),
                                                      aspectRatio: 16 / 9,
                                                      fit: BoxFit.contain,
                                                    ),
                                                  );
                                                }else{
                                                  return CachedNetworkImage(
                                                    fit: BoxFit.cover,
                                                    imageUrl: searchPosts.data![i].searchPostImagesOrVideos[index],
                                                    placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                    errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                  );
                                                }
                                              }
                                            }());
                                          }
                                        }()),
                                      );
                                    }
                                  }()),
                                ),
                              ],
                            )
                            : const SizedBox(height: 0),
                          ],
                        )
                        : MiscRegularPost(
                          key: ValueKey('$i'),
                          userId: searchPosts.data![i].searchPostPage.searchPostPagePageCreator.searchPostPageCreatorId,
                          postId: searchPosts.data![i].searchPostId,
                          memorialId: searchPosts.data![i].searchPostPage.searchPostPageId,
                          memorialName: searchPosts.data![i].searchPostPage.searchPostPageName,
                          timeCreated: timeago.format(DateTime.parse(searchPosts.data![i].searchPostCreatedAt)),
                          managed: searchPosts.data![i].searchPostPage.searchPostPageManage,
                          joined: searchPosts.data![i].searchPostPage.searchPostPageFollower,
                          profileImage: searchPosts.data![i].searchPostPage.searchPostPageProfileImage,
                          numberOfComments: searchPosts.data![i].searchPostNumberOfComments,
                          numberOfLikes: searchPosts.data![i].searchPostNumberOfLikes,
                          likeStatus: searchPosts.data![i].searchPostLikeStatus,
                          numberOfTagged: searchPosts.data![i].searchPostPostTagged.length,
                          taggedFirstName: ((){
                            List<String> firstName = [];
                            for(int j = 0; j < searchPosts.data![i].searchPostPostTagged.length; j++){
                              firstName.add(searchPosts.data![i].searchPostPostTagged[j].searchPostTaggedFirstName);
                            }
                            return firstName;
                          }()),
                          taggedLastName: ((){
                            List<String> lastName = [];
                            for(int j = 0; j < searchPosts.data![i].searchPostPostTagged.length; j++){
                              lastName.add(searchPosts.data![i].searchPostPostTagged[j].searchPostTaggedLastName);
                            }
                            return lastName;
                          }()),
                          taggedId: ((){
                            List<int> id = [];
                            for(int j = 0; j < searchPosts.data![i].searchPostPostTagged.length; j++){
                              id.add(searchPosts.data![i].searchPostPostTagged[j].searchPostTaggedId);
                            }
                            return id;
                          }()),
                          pageType: searchPosts.data![i].searchPostPage.searchPostPagePageType,
                          famOrFriends: searchPosts.data![i].searchPostPage.searchPostPageFamOrFriends,
                          relationship: searchPosts.data![i].searchPostPage.searchPostPageRelationship,
                          location: searchPosts.data![i].searchPostLocation,
                          latitude: searchPosts.data![i].searchPostLatitude,
                          longitude: searchPosts.data![i].searchPostLongitude,
                          contents: [
                            Align(alignment: Alignment.centerLeft, child: Text(searchPosts.data![i].searchPostBody, overflow: TextOverflow.ellipsis, maxLines: 5, style: const TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xff000000),),),),
                                
                            searchPosts.data![i].searchPostImagesOrVideos.isNotEmpty
                            ? Column(
                              children: [
                                const SizedBox(height: 20),
                                
                                SizedBox(
                                  child: ((){
                                    if(searchPosts.data![i].searchPostImagesOrVideos.length == 1){
                                      if(lookupMimeType(searchPosts.data![i].searchPostImagesOrVideos[0])?.contains('video') == true){
                                        return BetterPlayer.network('${searchPosts.data![i].searchPostImagesOrVideos[0]}',
                                          betterPlayerConfiguration: BetterPlayerConfiguration(
                                            placeholder: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 16 / 9),
                                            controlsConfiguration: const BetterPlayerControlsConfiguration(showControls: false,),
                                            aspectRatio: 16 / 9,
                                            fit: BoxFit.contain,
                                          ),
                                        );
                                      }else{
                                        return CachedNetworkImage(
                                          fit: BoxFit.cover,
                                          imageUrl: searchPosts.data![i].searchPostImagesOrVideos[0],
                                          placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                          errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                        );
                                      }
                                    }else if(searchPosts.data![i].searchPostImagesOrVideos.length == 2){
                                      return StaggeredGridView.countBuilder(
                                        staggeredTileBuilder:(int index) => const StaggeredTile.count(2, 2),
                                        physics: const NeverScrollableScrollPhysics(),
                                        padding: EdgeInsets.zero,
                                        crossAxisSpacing: 4.0,
                                        mainAxisSpacing: 4.0,
                                        crossAxisCount: 4,
                                        shrinkWrap: true,
                                        itemCount: 2,
                                        itemBuilder: (BuildContext context, int index) => lookupMimeType(searchPosts.data![i].searchPostImagesOrVideos[index])?.contains('video') == true
                                        ? BetterPlayer.network('${searchPosts.data![i].searchPostImagesOrVideos[index]}',
                                            betterPlayerConfiguration: BetterPlayerConfiguration(placeholder: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 16 / 9),
                                            controlsConfiguration: const BetterPlayerControlsConfiguration(showControls: false,),
                                            aspectRatio: 16 / 9,
                                            fit: BoxFit.contain,
                                          ),
                                        )
                                        : CachedNetworkImage(
                                          fit: BoxFit.cover, 
                                          imageUrl: searchPosts.data![i].searchPostImagesOrVideos[index],
                                          placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                          errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,scale: 1.0,),
                                        ),
                                      );
                                    }else{
                                      return StaggeredGridView.countBuilder(
                                        staggeredTileBuilder: (int index) => StaggeredTile.count(2, index.isEven ? 1 : 2),
                                        physics: const NeverScrollableScrollPhysics(),
                                        padding: EdgeInsets.zero,
                                        crossAxisSpacing: 4.0,
                                        mainAxisSpacing: 4.0,
                                        crossAxisCount: 4,
                                        shrinkWrap: true,
                                        itemCount: 3,
                                        itemBuilder: (BuildContext context, int index) => 
                                        ((){
                                          if(index != 1){
                                            return lookupMimeType(searchPosts.data![i].searchPostImagesOrVideos[index])?.contains('video') == true
                                            ? BetterPlayer.network('${searchPosts.data![i].searchPostImagesOrVideos[index]}',
                                              betterPlayerConfiguration: BetterPlayerConfiguration(
                                                placeholder: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 16 / 9),
                                                controlsConfiguration: const BetterPlayerControlsConfiguration(showControls: false,),
                                                aspectRatio: 16 / 9,
                                                fit: BoxFit.contain,
                                              ),
                                            )
                                            : CachedNetworkImage(
                                              fit: BoxFit.cover,
                                              imageUrl: searchPosts.data![i].searchPostImagesOrVideos[index],
                                              placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                              errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                            );
                                          }else{
                                            return ((){
                                              if(searchPosts.data![i].searchPostImagesOrVideos.length - 3 > 0){
                                                if(lookupMimeType(searchPosts.data![i].searchPostImagesOrVideos[index])?.contains('video') == true){
                                                  return Stack(
                                                    fit: StackFit.expand,
                                                    children: [
                                                      BetterPlayer.network('${searchPosts.data![i].searchPostImagesOrVideos[index]}',
                                                        betterPlayerConfiguration: BetterPlayerConfiguration(
                                                          placeholder: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 16 / 9),
                                                          controlsConfiguration: const BetterPlayerControlsConfiguration(showControls: false,),
                                                          aspectRatio: 16 / 9,
                                                          fit: BoxFit.contain,
                                                        ),
                                                      ),

                                                      Container(color: const Color(0xff000000).withOpacity(0.5),),

                                                      Center(
                                                        child: CircleAvatar(
                                                          radius: 25,
                                                          backgroundColor: const Color(0xffffffff).withOpacity(.5),
                                                          child: Text('${searchPosts.data![i].searchPostImagesOrVideos.length - 3}', style: const TextStyle(fontSize: 32, fontFamily: 'NexaBold', color: Color(0xffFFFFFF),),),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                }else{
                                                  return Stack(
                                                    fit: StackFit.expand,
                                                    children: [
                                                      CachedNetworkImage(
                                                        fit: BoxFit.cover,
                                                        imageUrl: searchPosts.data![i].searchPostImagesOrVideos[index],
                                                        placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                        errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                      ),

                                                      Container(color: const Color(0xff000000).withOpacity(0.5),),
                                                      
                                                      Center(
                                                        child: CircleAvatar(
                                                          radius: 25,
                                                          backgroundColor: const Color(0xffffffff).withOpacity(.5),
                                                          child: Text('${searchPosts.data![i].searchPostImagesOrVideos.length - 3}', style: const TextStyle(fontSize: 32, fontFamily: 'NexaBold', color: Color(0xffFFFFFF),),),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                }
                                              }else{
                                                if(lookupMimeType(searchPosts.data![i].searchPostImagesOrVideos[index])?.contains('video') == true) {
                                                  return BetterPlayer.network('${searchPosts.data![i].searchPostImagesOrVideos[index]}',
                                                    betterPlayerConfiguration: BetterPlayerConfiguration(
                                                      placeholder: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 16 / 9),
                                                      controlsConfiguration: const BetterPlayerControlsConfiguration(showControls: false,),
                                                      aspectRatio: 16 / 9,
                                                      fit: BoxFit.contain,
                                                    ),
                                                  );
                                                }else{
                                                  return CachedNetworkImage(
                                                    fit: BoxFit.cover,
                                                    imageUrl: searchPosts.data![i].searchPostImagesOrVideos[index],
                                                    placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                    errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                  );
                                                }
                                              }
                                            }());
                                          }
                                        }()),
                                      );
                                    }
                                  }()),
                                ),
                              ],
                            )
                            : const SizedBox(height: 0),
                          ],
                        );
                      }
                    )
                    : ListView.separated( // ON SEARCH
                      controller: scrollController1,
                      physics: const ClampingScrollPhysics(),
                      padding: const EdgeInsets.all(10.0),
                      itemCount: lengthOfSearchPostsListener,
                      separatorBuilder: (c, i){
                        return searchPosts.data![i].searchPostPage.searchPostPageName.toUpperCase().contains(searchKey.toUpperCase())
                        ? const Divider(height: 10, color: Colors.transparent)
                        : const Divider(height: 0, color: Colors.transparent);
                      },
                      itemBuilder: (c, i){
                        return searchPosts.data![i].searchPostPage.searchPostPageName.toUpperCase().contains(searchKey.toUpperCase())
                        ? searchPosts.data![i].searchPostPage.searchPostPagePageType == 'Blm'
                        ? MiscBLMPost(
                          key: ValueKey('$i'),
                          userId: searchPosts.data![i].searchPostPage.searchPostPagePageCreator.searchPostPageCreatorId,
                          postId: searchPosts.data![i].searchPostId,
                          memorialId: searchPosts.data![i].searchPostPage.searchPostPageId,
                          memorialName: searchPosts.data![i].searchPostPage.searchPostPageName,
                          timeCreated: timeago.format(DateTime.parse(searchPosts.data![i].searchPostCreatedAt)),
                          managed: searchPosts.data![i].searchPostPage.searchPostPageManage,
                          joined: searchPosts.data![i].searchPostPage.searchPostPageFollower,
                          profileImage: searchPosts.data![i].searchPostPage.searchPostPageProfileImage,
                          numberOfComments: searchPosts.data![i].searchPostNumberOfComments,
                          numberOfLikes: searchPosts.data![i].searchPostNumberOfLikes,
                          likeStatus: searchPosts.data![i].searchPostLikeStatus,
                          numberOfTagged: searchPosts.data![i].searchPostPostTagged.length,
                          taggedFirstName: ((){
                            List<String> firstName = [];
                            for(int j = 0; j < searchPosts.data![i].searchPostPostTagged.length; j++){
                              firstName.add(searchPosts.data![i].searchPostPostTagged[j].searchPostTaggedFirstName);
                            }
                            return firstName;
                          }()),
                          taggedLastName: ((){
                            List<String> lastName = [];
                            for(int j = 0; j < searchPosts.data![i].searchPostPostTagged.length; j++){
                              lastName.add(searchPosts.data![i].searchPostPostTagged[j].searchPostTaggedLastName);
                            }
                            return lastName;
                          }()),
                          taggedId: ((){
                            List<int> id = [];
                            for(int j = 0; j < searchPosts.data![i].searchPostPostTagged.length; j++){
                              id.add(searchPosts.data![i].searchPostPostTagged[j].searchPostTaggedId);
                            }
                            return id;
                          }()),
                          pageType: searchPosts.data![i].searchPostPage.searchPostPagePageType,
                          famOrFriends: searchPosts.data![i].searchPostPage.searchPostPageFamOrFriends,
                          relationship: searchPosts.data![i].searchPostPage.searchPostPageRelationship,
                          location: searchPosts.data![i].searchPostLocation,
                          latitude: searchPosts.data![i].searchPostLatitude,
                          longitude: searchPosts.data![i].searchPostLongitude,
                          contents: [
                            Align(alignment: Alignment.centerLeft, child: Text(searchPosts.data![i].searchPostBody, overflow: TextOverflow.ellipsis, maxLines: 5, style: const TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xff000000),),),),
                                
                            searchPosts.data![i].searchPostImagesOrVideos.isNotEmpty
                            ? Column(
                              children: [
                                const SizedBox(height: 20),
                                
                                SizedBox(
                                  child: ((){
                                    if(searchPosts.data![i].searchPostImagesOrVideos.length == 1){
                                      if(lookupMimeType(searchPosts.data![i].searchPostImagesOrVideos[0])?.contains('video') == true){
                                        return BetterPlayer.network('${searchPosts.data![i].searchPostImagesOrVideos[0]}',
                                          betterPlayerConfiguration: BetterPlayerConfiguration(
                                            placeholder: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 16 / 9),
                                            controlsConfiguration: const BetterPlayerControlsConfiguration(showControls: false,),
                                            aspectRatio: 16 / 9,
                                            fit: BoxFit.contain,
                                          ),
                                        );
                                      }else{
                                        return CachedNetworkImage(
                                          fit: BoxFit.cover,
                                          imageUrl: searchPosts.data![i].searchPostImagesOrVideos[0],
                                          placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                          errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                        );
                                      }
                                    }else if(searchPosts.data![i].searchPostImagesOrVideos.length == 2){
                                      return StaggeredGridView.countBuilder(
                                        staggeredTileBuilder:(int index) => const StaggeredTile.count(2, 2),
                                        physics: const NeverScrollableScrollPhysics(),
                                        padding: EdgeInsets.zero,
                                        crossAxisSpacing: 4.0,
                                        mainAxisSpacing: 4.0,
                                        crossAxisCount: 4,
                                        shrinkWrap: true,
                                        itemCount: 2,
                                        itemBuilder: (BuildContext context, int index) => lookupMimeType(searchPosts.data![i].searchPostImagesOrVideos[index])?.contains('video') == true
                                        ? BetterPlayer.network('${searchPosts.data![i].searchPostImagesOrVideos[index]}',
                                            betterPlayerConfiguration: BetterPlayerConfiguration(placeholder: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 16 / 9),
                                            controlsConfiguration: const BetterPlayerControlsConfiguration(showControls: false,),
                                            aspectRatio: 16 / 9,
                                            fit: BoxFit.contain,
                                          ),
                                        )
                                        : CachedNetworkImage(
                                          fit: BoxFit.cover, 
                                          imageUrl: searchPosts.data![i].searchPostImagesOrVideos[index],
                                          placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                          errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,scale: 1.0,),
                                        ),
                                      );
                                    }else{
                                      return StaggeredGridView.countBuilder(
                                        staggeredTileBuilder: (int index) => StaggeredTile.count(2, index.isEven ? 1 : 2),
                                        physics: const NeverScrollableScrollPhysics(),
                                        padding: EdgeInsets.zero,
                                        crossAxisSpacing: 4.0,
                                        mainAxisSpacing: 4.0,
                                        crossAxisCount: 4,
                                        shrinkWrap: true,
                                        itemCount: 3,
                                        itemBuilder: (BuildContext context, int index) => 
                                        ((){
                                          if(index != 1){
                                            return lookupMimeType(searchPosts.data![i].searchPostImagesOrVideos[index])?.contains('video') == true
                                            ? BetterPlayer.network('${searchPosts.data![i].searchPostImagesOrVideos[index]}',
                                              betterPlayerConfiguration: BetterPlayerConfiguration(
                                                placeholder: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 16 / 9),
                                                controlsConfiguration: const BetterPlayerControlsConfiguration(showControls: false,),
                                                aspectRatio: 16 / 9,
                                                fit: BoxFit.contain,
                                              ),
                                            )
                                            : CachedNetworkImage(
                                              fit: BoxFit.cover,
                                              imageUrl: searchPosts.data![i].searchPostImagesOrVideos[index],
                                              placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                              errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                            );
                                          }else{
                                            return ((){
                                              if(searchPosts.data![i].searchPostImagesOrVideos.length - 3 > 0){
                                                if(lookupMimeType(searchPosts.data![i].searchPostImagesOrVideos[index])?.contains('video') == true){
                                                  return Stack(
                                                    fit: StackFit.expand,
                                                    children: [
                                                      BetterPlayer.network('${searchPosts.data![i].searchPostImagesOrVideos[index]}',
                                                        betterPlayerConfiguration: BetterPlayerConfiguration(
                                                          placeholder: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 16 / 9),
                                                          controlsConfiguration: const BetterPlayerControlsConfiguration(showControls: false,),
                                                          aspectRatio: 16 / 9,
                                                          fit: BoxFit.contain,
                                                        ),
                                                      ),

                                                      Container(color: const Color(0xff000000).withOpacity(0.5),),

                                                      Center(
                                                        child: CircleAvatar(
                                                          radius: 25,
                                                          backgroundColor: const Color(0xffffffff).withOpacity(.5),
                                                          child: Text('${searchPosts.data![i].searchPostImagesOrVideos.length - 3}', style: const TextStyle(fontSize: 32, fontFamily: 'NexaBold', color: Color(0xffFFFFFF),),),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                }else{
                                                  return Stack(
                                                    fit: StackFit.expand,
                                                    children: [
                                                      CachedNetworkImage(
                                                        fit: BoxFit.cover,
                                                        imageUrl: searchPosts.data![i].searchPostImagesOrVideos[index],
                                                        placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                        errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                      ),

                                                      Container(color: const Color(0xff000000).withOpacity(0.5),),
                                                      
                                                      Center(
                                                        child: CircleAvatar(
                                                          radius: 25,
                                                          backgroundColor: const Color(0xffffffff).withOpacity(.5),
                                                          child: Text('${searchPosts.data![i].searchPostImagesOrVideos.length - 3}', style: const TextStyle(fontSize: 32, fontFamily: 'NexaBold', color: Color(0xffFFFFFF),),),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                }
                                              }else{
                                                if(lookupMimeType(searchPosts.data![i].searchPostImagesOrVideos[index])?.contains('video') == true) {
                                                  return BetterPlayer.network('${searchPosts.data![i].searchPostImagesOrVideos[index]}',
                                                    betterPlayerConfiguration: BetterPlayerConfiguration(
                                                      placeholder: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 16 / 9),
                                                      controlsConfiguration: const BetterPlayerControlsConfiguration(showControls: false,),
                                                      aspectRatio: 16 / 9,
                                                      fit: BoxFit.contain,
                                                    ),
                                                  );
                                                }else{
                                                  return CachedNetworkImage(
                                                    fit: BoxFit.cover,
                                                    imageUrl: searchPosts.data![i].searchPostImagesOrVideos[index],
                                                    placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                    errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                  );
                                                }
                                              }
                                            }());
                                          }
                                        }()),
                                      );
                                    }
                                  }()),
                                ),
                              ],
                            )
                            : const SizedBox(height: 0),
                          ],
                        )
                        : MiscRegularPost(
                          key: ValueKey('$i'),
                          userId: searchPosts.data![i].searchPostPage.searchPostPagePageCreator.searchPostPageCreatorId,
                          postId: searchPosts.data![i].searchPostId,
                          memorialId: searchPosts.data![i].searchPostPage.searchPostPageId,
                          memorialName: searchPosts.data![i].searchPostPage.searchPostPageName,
                          timeCreated: timeago.format(DateTime.parse(searchPosts.data![i].searchPostCreatedAt)),
                          managed: searchPosts.data![i].searchPostPage.searchPostPageManage,
                          joined: searchPosts.data![i].searchPostPage.searchPostPageFollower,
                          profileImage: searchPosts.data![i].searchPostPage.searchPostPageProfileImage,
                          numberOfComments: searchPosts.data![i].searchPostNumberOfComments,
                          numberOfLikes: searchPosts.data![i].searchPostNumberOfLikes,
                          likeStatus: searchPosts.data![i].searchPostLikeStatus,
                          numberOfTagged: searchPosts.data![i].searchPostPostTagged.length,
                          taggedFirstName: ((){
                            List<String> firstName = [];
                            for(int j = 0; j < searchPosts.data![i].searchPostPostTagged.length; j++){
                              firstName.add(searchPosts.data![i].searchPostPostTagged[j].searchPostTaggedFirstName);
                            }
                            return firstName;
                          }()),
                          taggedLastName: ((){
                            List<String> lastName = [];
                            for(int j = 0; j < searchPosts.data![i].searchPostPostTagged.length; j++){
                              lastName.add(searchPosts.data![i].searchPostPostTagged[j].searchPostTaggedLastName);
                            }
                            return lastName;
                          }()),
                          taggedId: ((){
                            List<int> id = [];
                            for(int j = 0; j < searchPosts.data![i].searchPostPostTagged.length; j++){
                              id.add(searchPosts.data![i].searchPostPostTagged[j].searchPostTaggedId);
                            }
                            return id;
                          }()),
                          pageType: searchPosts.data![i].searchPostPage.searchPostPagePageType,
                          famOrFriends: searchPosts.data![i].searchPostPage.searchPostPageFamOrFriends,
                          relationship: searchPosts.data![i].searchPostPage.searchPostPageRelationship,
                          location: searchPosts.data![i].searchPostLocation,
                          latitude: searchPosts.data![i].searchPostLatitude,
                          longitude: searchPosts.data![i].searchPostLongitude,
                          contents: [
                            Align(alignment: Alignment.centerLeft, child: Text(searchPosts.data![i].searchPostBody, overflow: TextOverflow.ellipsis, maxLines: 5, style: const TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xff000000),),),),
                                
                            searchPosts.data![i].searchPostImagesOrVideos.isNotEmpty
                            ? Column(
                              children: [
                                const SizedBox(height: 20),
                                
                                SizedBox(
                                  child: ((){
                                    if(searchPosts.data![i].searchPostImagesOrVideos.length == 1){
                                      if(lookupMimeType(searchPosts.data![i].searchPostImagesOrVideos[0])?.contains('video') == true){
                                        return BetterPlayer.network('${searchPosts.data![i].searchPostImagesOrVideos[0]}',
                                          betterPlayerConfiguration: BetterPlayerConfiguration(
                                            placeholder: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 16 / 9),
                                            controlsConfiguration: const BetterPlayerControlsConfiguration(showControls: false,),
                                            aspectRatio: 16 / 9,
                                            fit: BoxFit.contain,
                                          ),
                                        );
                                      }else{
                                        return CachedNetworkImage(
                                          fit: BoxFit.cover,
                                          imageUrl: searchPosts.data![i].searchPostImagesOrVideos[0],
                                          placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                          errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                        );
                                      }
                                    }else if(searchPosts.data![i].searchPostImagesOrVideos.length == 2){
                                      return StaggeredGridView.countBuilder(
                                        staggeredTileBuilder:(int index) => const StaggeredTile.count(2, 2),
                                        physics: const NeverScrollableScrollPhysics(),
                                        padding: EdgeInsets.zero,
                                        crossAxisSpacing: 4.0,
                                        mainAxisSpacing: 4.0,
                                        crossAxisCount: 4,
                                        shrinkWrap: true,
                                        itemCount: 2,
                                        itemBuilder: (BuildContext context, int index) => lookupMimeType(searchPosts.data![i].searchPostImagesOrVideos[index])?.contains('video') == true
                                        ? BetterPlayer.network('${searchPosts.data![i].searchPostImagesOrVideos[index]}',
                                            betterPlayerConfiguration: BetterPlayerConfiguration(placeholder: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 16 / 9),
                                            controlsConfiguration: const BetterPlayerControlsConfiguration(showControls: false,),
                                            aspectRatio: 16 / 9,
                                            fit: BoxFit.contain,
                                          ),
                                        )
                                        : CachedNetworkImage(
                                          fit: BoxFit.cover, 
                                          imageUrl: searchPosts.data![i].searchPostImagesOrVideos[index],
                                          placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                          errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,scale: 1.0,),
                                        ),
                                      );
                                    }else{
                                      return StaggeredGridView.countBuilder(
                                        staggeredTileBuilder: (int index) => StaggeredTile.count(2, index.isEven ? 1 : 2),
                                        physics: const NeverScrollableScrollPhysics(),
                                        padding: EdgeInsets.zero,
                                        crossAxisSpacing: 4.0,
                                        mainAxisSpacing: 4.0,
                                        crossAxisCount: 4,
                                        shrinkWrap: true,
                                        itemCount: 3,
                                        itemBuilder: (BuildContext context, int index) => 
                                        ((){
                                          if(index != 1){
                                            return lookupMimeType(searchPosts.data![i].searchPostImagesOrVideos[index])?.contains('video') == true
                                            ? BetterPlayer.network('${searchPosts.data![i].searchPostImagesOrVideos[index]}',
                                              betterPlayerConfiguration: BetterPlayerConfiguration(
                                                placeholder: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 16 / 9),
                                                controlsConfiguration: const BetterPlayerControlsConfiguration(showControls: false,),
                                                aspectRatio: 16 / 9,
                                                fit: BoxFit.contain,
                                              ),
                                            )
                                            : CachedNetworkImage(
                                              fit: BoxFit.cover,
                                              imageUrl: searchPosts.data![i].searchPostImagesOrVideos[index],
                                              placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                              errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                            );
                                          }else{
                                            return ((){
                                              if(searchPosts.data![i].searchPostImagesOrVideos.length - 3 > 0){
                                                if(lookupMimeType(searchPosts.data![i].searchPostImagesOrVideos[index])?.contains('video') == true){
                                                  return Stack(
                                                    fit: StackFit.expand,
                                                    children: [
                                                      BetterPlayer.network('${searchPosts.data![i].searchPostImagesOrVideos[index]}',
                                                        betterPlayerConfiguration: BetterPlayerConfiguration(
                                                          placeholder: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 16 / 9),
                                                          controlsConfiguration: const BetterPlayerControlsConfiguration(showControls: false,),
                                                          aspectRatio: 16 / 9,
                                                          fit: BoxFit.contain,
                                                        ),
                                                      ),

                                                      Container(color: const Color(0xff000000).withOpacity(0.5),),

                                                      Center(
                                                        child: CircleAvatar(
                                                          radius: 25,
                                                          backgroundColor: const Color(0xffffffff).withOpacity(.5),
                                                          child: Text('${searchPosts.data![i].searchPostImagesOrVideos.length - 3}', style: const TextStyle(fontSize: 32, fontFamily: 'NexaBold', color: Color(0xffFFFFFF),),),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                }else{
                                                  return Stack(
                                                    fit: StackFit.expand,
                                                    children: [
                                                      CachedNetworkImage(
                                                        fit: BoxFit.cover,
                                                        imageUrl: searchPosts.data![i].searchPostImagesOrVideos[index],
                                                        placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                        errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                      ),

                                                      Container(color: const Color(0xff000000).withOpacity(0.5),),
                                                      
                                                      Center(
                                                        child: CircleAvatar(
                                                          radius: 25,
                                                          backgroundColor: const Color(0xffffffff).withOpacity(.5),
                                                          child: Text('${searchPosts.data![i].searchPostImagesOrVideos.length - 3}', style: const TextStyle(fontSize: 32, fontFamily: 'NexaBold', color: Color(0xffFFFFFF),),),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                }
                                              }else{
                                                if(lookupMimeType(searchPosts.data![i].searchPostImagesOrVideos[index])?.contains('video') == true) {
                                                  return BetterPlayer.network('${searchPosts.data![i].searchPostImagesOrVideos[index]}',
                                                    betterPlayerConfiguration: BetterPlayerConfiguration(
                                                      placeholder: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 16 / 9),
                                                      controlsConfiguration: const BetterPlayerControlsConfiguration(showControls: false,),
                                                      aspectRatio: 16 / 9,
                                                      fit: BoxFit.contain,
                                                    ),
                                                  );
                                                }else{
                                                  return CachedNetworkImage(
                                                    fit: BoxFit.cover,
                                                    imageUrl: searchPosts.data![i].searchPostImagesOrVideos[index],
                                                    placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                    errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                  );
                                                }
                                              }
                                            }());
                                          }
                                        }()),
                                      );
                                    }
                                  }()),
                                ),
                              ],
                            )
                            : const SizedBox(height: 0),
                          ],
                        )
                        : const SizedBox(height: 0);
                      }
                    );
                  }
                }
                else if(searchPosts.connectionState == ConnectionState.none || searchPosts.connectionState == ConnectionState.waiting){
                  return const Center(child: CustomLoader(),);
                }
                else if(searchPosts.hasError){
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
              },
            )
          ),
        ),
      ),
    );
  }

  searchSuggestedExtended({required bool onSearch, required String searchKey}){
    return ValueListenableBuilder(
      valueListenable: lengthOfSearchSuggested,
      builder: (_, int lengthOfSearchSuggestedListener, __) => ValueListenableBuilder(
        valueListenable: loaded2,
        builder: (_, bool loaded2Listener, __) => SafeArea(
          child: RefreshIndicator(
            onRefresh: onRefresh2,
            child: FutureBuilder<List<APIRegularSearchSuggestedExtended>>(
              future: showListOfSearchSuggested,
              builder: (context, searchSuggested){
                if(searchSuggested.connectionState == ConnectionState.done){
                  if(loaded2Listener && lengthOfSearchSuggestedListener == 0){
                    return SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: (SizeConfig.screenHeight! - 75 - kToolbarHeight) / 4,),

                          Image.asset('assets/icons/app-icon.png', height: 200, width: 200,),

                          const SizedBox(height: 45,),

                          const Text('Suggested is empty', style: TextStyle(fontSize: 36, fontFamily: 'NexaBold', color: Color(0xffB1B1B1),),),

                          SizedBox(height: (SizeConfig.screenHeight! - 75 - kToolbarHeight) / 4,),
                        ],
                      ),
                    );
                  }else{
                    return !onSearch
                    ? ListView.separated(
                      controller: scrollController2,
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                      physics: const ClampingScrollPhysics(),
                      itemCount: lengthOfSearchSuggestedListener,
                      separatorBuilder: (c, i) => const Divider(height: 10, color: Colors.transparent),
                      itemBuilder: (c, i) => MiscRegularManageMemorialTab(
                        index: i,
                        memorialName: searchSuggested.data![i].searchSuggestedPage.searchSuggestedPageName,
                        description: searchSuggested.data![i].searchSuggestedPage.searchSuggestedPageDetails.searchSuggestedPageDetailsDescription,
                        image: searchSuggested.data![i].searchSuggestedPage.searchSuggestedPageProfileImage,
                        memorialId: searchSuggested.data![i].searchSuggestedPage.searchSuggestedPageId,
                        managed: searchSuggested.data![i].searchSuggestedPage.searchSuggestedPageManage,
                        follower: searchSuggested.data![i].searchSuggestedPage.searchSuggestedPageFollower,
                        pageType: searchSuggested.data![i].searchSuggestedPage.searchSuggestedPagePageType,
                        relationship: searchSuggested.data![i].searchSuggestedPage.searchSuggestedPageRelationship,
                        famOrFriends: searchSuggested.data![i].searchSuggestedPage.searchSuggestedPageFamOrFriends,
                      ),
                    )
                    : ListView.separated( // ON SEARCH
                      controller: scrollController2,
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                      physics: const ClampingScrollPhysics(),
                      itemCount: lengthOfSearchSuggestedListener,
                      separatorBuilder: (c, i){
                        return searchSuggested.data![i].searchSuggestedPage.searchSuggestedPageName.toUpperCase().contains(searchKey.toUpperCase())
                        ? const Divider(height: 10, color: Colors.transparent)
                        : const Divider(height: 0, color: Colors.transparent);
                      },
                      itemBuilder: (c, i){
                        return searchSuggested.data![i].searchSuggestedPage.searchSuggestedPageName.toUpperCase().contains(searchKey.toUpperCase())
                        ? MiscRegularManageMemorialTab(
                          index: i,
                          memorialName: searchSuggested.data![i].searchSuggestedPage.searchSuggestedPageName,
                          description: searchSuggested.data![i].searchSuggestedPage.searchSuggestedPageDetails.searchSuggestedPageDetailsDescription,
                          image: searchSuggested.data![i].searchSuggestedPage.searchSuggestedPageProfileImage,
                          memorialId: searchSuggested.data![i].searchSuggestedPage.searchSuggestedPageId,
                          managed: searchSuggested.data![i].searchSuggestedPage.searchSuggestedPageManage,
                          follower: searchSuggested.data![i].searchSuggestedPage.searchSuggestedPageFollower,
                          pageType: searchSuggested.data![i].searchSuggestedPage.searchSuggestedPagePageType,
                          relationship: searchSuggested.data![i].searchSuggestedPage.searchSuggestedPageRelationship,
                          famOrFriends: searchSuggested.data![i].searchSuggestedPage.searchSuggestedPageFamOrFriends,
                        )
                        : const SizedBox(height: 0); 
                      }
                    );
                  }
                }else if(searchSuggested.connectionState == ConnectionState.none || searchSuggested.connectionState == ConnectionState.waiting){
                  return const Center(child: CustomLoader(),);
                }
                else if(searchSuggested.hasError){
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
              },
            ),
          ),
        ),
      ),
    );
  }

  searchNearbyExtended({required bool onSearch, required String searchKey}){
    return ValueListenableBuilder(
      valueListenable: lengthOfSearchNearby,
      builder: (_, int lengthOfSearchNearbyListener, __) => ValueListenableBuilder(
        valueListenable: loaded3,
        builder: (_, bool loaded3Listener, __) => SafeArea(
          child: RefreshIndicator(
            onRefresh: onRefresh3,
            child: FutureBuilder<List<APIRegularSearchNearbyExtended>>(
              future: showListOfSearchNearby,
              builder: (context, searchNearby){
                if(searchNearby.connectionState == ConnectionState.done){
                  if(loaded3Listener && lengthOfSearchNearbyListener == 0){
                    return SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: (SizeConfig.screenHeight! - 75 - kToolbarHeight) / 4,),

                          Image.asset('assets/icons/app-icon.png', height: 200, width: 200,),

                          const SizedBox(height: 45,),

                          const Text('Nearby is empty', style: TextStyle(fontSize: 36, fontFamily: 'NexaBold', color: Color(0xffB1B1B1),),),

                          SizedBox(height: (SizeConfig.screenHeight! - 75 - kToolbarHeight) / 4,),
                        ],
                      ),
                    );
                  }else{
                    return !onSearch
                    ? ListView.separated(
                      controller: scrollController3,
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                      physics: const ClampingScrollPhysics(),
                      itemCount: lengthOfSearchNearbyListener,
                      separatorBuilder: (c, i) => const Divider(height: 10, color: Colors.transparent),
                      itemBuilder: (c, i) => MiscRegularManageMemorialTab(
                        index: i,
                        memorialName: searchNearby.data![i].searchNearbyName,
                        description: searchNearby.data![i].searchNearbyDetails.searchNearbyPageDetailsDescription,
                        image: searchNearby.data![i].searchNearbyProfileImage,
                        memorialId: searchNearby.data![i].searchNearbyId,
                        managed: searchNearby.data![i].searchNearbyManage,
                        follower: searchNearby.data![i].searchNearbyFollower,
                        pageType: searchNearby.data![i].searchNearbyPageType,
                        relationship: searchNearby.data![i].searchNearbyRelationship,
                        famOrFriends: searchNearby.data![i].searchNearbyFamOrFriends,
                      ),
                    )
                    : ListView.separated( // ON SEARCH
                      controller: scrollController3,
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                      physics: const ClampingScrollPhysics(),
                      itemCount: lengthOfSearchNearbyListener,
                      separatorBuilder: (c, i){
                        return searchNearby.data![i].searchNearbyName.toUpperCase().contains(searchKey.toUpperCase())
                        ? const Divider(height: 10, color: Colors.transparent)
                        : const Divider(height: 0, color: Colors.transparent);
                      },
                      itemBuilder: (c, i){
                        return searchNearby.data![i].searchNearbyName.toUpperCase().contains(searchKey.toUpperCase())
                        ? MiscRegularManageMemorialTab(
                          index: i,
                          memorialName: searchNearby.data![i].searchNearbyName,
                          description: searchNearby.data![i].searchNearbyDetails.searchNearbyPageDetailsDescription,
                          image: searchNearby.data![i].searchNearbyProfileImage,
                          memorialId: searchNearby.data![i].searchNearbyId,
                          managed: searchNearby.data![i].searchNearbyManage,
                          follower: searchNearby.data![i].searchNearbyFollower,
                          pageType: searchNearby.data![i].searchNearbyPageType,
                          relationship: searchNearby.data![i].searchNearbyRelationship,
                          famOrFriends: searchNearby.data![i].searchNearbyFamOrFriends,
                        )
                        : const SizedBox(height: 0);
                      }
                    );
                  }
                }else if(searchNearby.connectionState == ConnectionState.none || searchNearby.connectionState == ConnectionState.waiting){
                  return const Center(child: CustomLoader(),);
                }
                else if(searchNearby.hasError){
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
              },
            ),
          ),
        ),
      ),
    );
  }

  searchBLMExtended({required bool onSearch, required String searchKey}){
    return ValueListenableBuilder(
      valueListenable: lengthOfSearchBLM,
      builder: (_, int lengthOfSearchBLMListener, __) => ValueListenableBuilder(
        valueListenable: loaded4,
        builder: (_, bool loaded4Listener, __) => SafeArea(
          child: RefreshIndicator(
            onRefresh: onRefresh4,
            child: FutureBuilder<List<APIRegularSearchBLMMemorialExtended>>(
              future: showListOfSearchBLM,
              builder: (context, searchBLM){
                if(searchBLM.connectionState == ConnectionState.done){
                  if(loaded4Listener && lengthOfSearchBLMListener == 0){
                    return SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: (SizeConfig.screenHeight! - 75 - kToolbarHeight) / 4,),

                          Image.asset('assets/icons/app-icon.png', height: 200, width: 200,),

                          const SizedBox(height: 45,),

                          const Text('BLM is empty', style: TextStyle(fontSize: 36, fontFamily: 'NexaBold', color: Color(0xffB1B1B1),),),

                          SizedBox(height: (SizeConfig.screenHeight! - 75 - kToolbarHeight) / 4,),
                        ],
                      ),
                    );
                  }else{
                    return !onSearch
                    ? ListView.separated(
                      controller: scrollController4,
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                      physics: const ClampingScrollPhysics(),
                      itemCount: lengthOfSearchBLMListener,
                      separatorBuilder: (c, i) => const Divider(height: 10, color: Colors.transparent),
                      itemBuilder: (c, i) => MiscRegularManageMemorialTab(
                        index: i,
                        memorialName: searchBLM.data![i].searchBLMMemorialPage.searchBLMMemorialPageName,
                        description: searchBLM.data![i].searchBLMMemorialPage.searchBLMMemorialPageDetails.searchBLMMemorialPageDetailsDescription,
                        image: searchBLM.data![i].searchBLMMemorialPage.searchBLMMemorialPageProfileImage,
                        memorialId: searchBLM.data![i].searchBLMMemorialPage.searchBLMMemorialPageId,
                        managed: searchBLM.data![i].searchBLMMemorialPage.searchBLMMemorialPageManage,
                        follower: searchBLM.data![i].searchBLMMemorialPage.searchBLMMemorialPageFollower,
                        pageType: searchBLM.data![i].searchBLMMemorialPage.searchBLMMemorialPagePageType,
                        relationship: searchBLM.data![i].searchBLMMemorialPage.searchBLMMemorialPageRelationship,
                        famOrFriends: searchBLM.data![i].searchBLMMemorialPage.searchBLMMemorialPageFamOrFriends,
                      ),
                    )
                    : ListView.separated(
                      controller: scrollController4,
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                      physics: const ClampingScrollPhysics(),
                      itemCount: lengthOfSearchBLMListener,
                      separatorBuilder: (c, i){
                        return searchBLM.data![i].searchBLMMemorialPage.searchBLMMemorialPageName.toUpperCase().contains(searchKey.toUpperCase())
                        ? const Divider(height: 10, color: Colors.transparent)
                        : const Divider(height: 0, color: Colors.transparent);
                      },
                      itemBuilder: (c, i){
                        return searchBLM.data![i].searchBLMMemorialPage.searchBLMMemorialPageName.toUpperCase().contains(searchKey.toUpperCase())
                        ? MiscRegularManageMemorialTab(
                          index: i,
                          memorialName: searchBLM.data![i].searchBLMMemorialPage.searchBLMMemorialPageName,
                          description: searchBLM.data![i].searchBLMMemorialPage.searchBLMMemorialPageDetails.searchBLMMemorialPageDetailsDescription,
                          image: searchBLM.data![i].searchBLMMemorialPage.searchBLMMemorialPageProfileImage,
                          memorialId: searchBLM.data![i].searchBLMMemorialPage.searchBLMMemorialPageId,
                          managed: searchBLM.data![i].searchBLMMemorialPage.searchBLMMemorialPageManage,
                          follower: searchBLM.data![i].searchBLMMemorialPage.searchBLMMemorialPageFollower,
                          pageType: searchBLM.data![i].searchBLMMemorialPage.searchBLMMemorialPagePageType,
                          relationship: searchBLM.data![i].searchBLMMemorialPage.searchBLMMemorialPageRelationship,
                          famOrFriends: searchBLM.data![i].searchBLMMemorialPage.searchBLMMemorialPageFamOrFriends,
                        )
                        : const SizedBox(height: 0);
                      },
                    );
                  }
                }else if(searchBLM.connectionState == ConnectionState.none || searchBLM.connectionState == ConnectionState.waiting){
                  return const Center(child: CustomLoader(),);
                }
                else if(searchBLM.hasError){
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
              },
            ),
          ),
        ),
      ),
    );
  }
}