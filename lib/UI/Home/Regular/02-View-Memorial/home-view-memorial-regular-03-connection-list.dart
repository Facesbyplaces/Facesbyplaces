import 'package:facesbyplaces/API/Regular/03-View-Memorial/api-view-memorial-regular-04-01-connection-list-family.dart';
import 'package:facesbyplaces/API/Regular/03-View-Memorial/api-view-memorial-regular-04-02-connection-list-friends.dart';
import 'package:facesbyplaces/API/Regular/03-View-Memorial/api-view-memorial-regular-04-03-connection-list-followers.dart';
import 'package:facesbyplaces/UI/Home/Regular/12-Show-User/home-show-user-regular-01-user.dart';
import 'package:facesbyplaces/UI/Home/BLM/12-Show-User/home-show-user-blm-01-user.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter/material.dart';

class RegularConnectionListItem{
  final int id;
  final int accountType;
  final String firstName;
  final String lastName;
  final String image;
  final String relationship;

  RegularConnectionListItem({required this.id, required this.accountType, required this.firstName, required this.lastName, required this.image, required this.relationship});
}

class HomeRegularConnectionList extends StatefulWidget{
  final int memorialId;
  final int newToggle;
  HomeRegularConnectionList({required this.memorialId, required this.newToggle});

  HomeRegularConnectionListState createState() => HomeRegularConnectionListState(memorialId: memorialId, newToggle: newToggle);
}

class HomeRegularConnectionListState extends State<HomeRegularConnectionList>{
  final int memorialId;
  final int newToggle;
  HomeRegularConnectionListState({required this.memorialId, required this.newToggle});

  ScrollController scrollController1 = ScrollController();
  ScrollController scrollController2 = ScrollController();
  ScrollController scrollController3 = ScrollController();
  List<RegularConnectionListItem> listsFamily = [];
  List<RegularConnectionListItem> listsFriends = [];
  List<RegularConnectionListItem> listsFollowers = [];
  List<RegularConnectionListItem> searches = [];
  bool onSearch = false;
  int itemRemaining1 = 1;
  int itemRemaining2 = 1;
  int itemRemaining3 = 1;
  int page1 = 1;
  int page2 = 1;
  int page3 = 1;
  int toggle = 0;

  void initState(){
    super.initState();
    toggle = newToggle;
    onLoading1();
    onLoading2();
    onLoading3();
    scrollController1.addListener(() {
      if (scrollController1.position.pixels == scrollController1.position.maxScrollExtent) {
        if(itemRemaining1 != 0){
          setState(() {
            onLoading1();
          });
        }else{
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('No more connection list family to show'),
              duration: Duration(seconds: 1),
              backgroundColor: Color(0xff4EC9D4),
            ),
          );
        }
      }
    });
    scrollController2.addListener(() {
      if (scrollController2.position.pixels == scrollController2.position.maxScrollExtent) {
        if(itemRemaining2 != 0){
          setState(() {
            onLoading1();
          });
        }else{
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('No more connection list friends to show'),
              duration: Duration(seconds: 1),
              backgroundColor: Color(0xff4EC9D4),
            ),
          );
        }
      }
    });
    scrollController3.addListener(() {
      if (scrollController3.position.pixels == scrollController3.position.maxScrollExtent) {
        if(itemRemaining3 != 0){
          setState(() {
            onLoading1();
          });
        }else{
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('No more connection list followers to show'),
              duration: Duration(seconds: 1),
              backgroundColor: Color(0xff4EC9D4),
            ),
          );
        }
      }
    });
  }

  Future<void> onRefresh1() async{
    setState(() {
      onLoading1();
    });
  }

  Future<void> onRefresh2() async{
    setState(() {
      onLoading2();
    });
  }

  Future<void> onRefresh3() async{
    setState(() {
      onLoading3();
    });
  }

  void onLoading1() async{
    if(itemRemaining1 != 0){

      context.showLoaderOverlay();
      var newValue = await apiRegularConnectionListFamily(memorialId: memorialId, page: page1);
      context.hideLoaderOverlay();

      itemRemaining1 = newValue.almItemsRemaining;

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

      if(mounted)
      setState(() {});
      page1++;
    }
  }

  void onLoading2() async{
    if(itemRemaining2 != 0){
      context.showLoaderOverlay();
      var newValue = await apiRegularConnectionListFriends(memorialId: memorialId, page: page2);
      context.hideLoaderOverlay();

      itemRemaining2 = newValue.almItemsRemaining;

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

      if(mounted)
      setState(() {});
      page2++; 
    }
  }

  void onLoading3() async{
    if(itemRemaining3 != 0){
      context.showLoaderOverlay();
      var newValue = await apiRegularConnectionListFollowers(memorialId: memorialId, page: page3);
      context.hideLoaderOverlay();

      itemRemaining3 = newValue.almItemsRemaining;

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

      if(mounted)
      setState(() {});
      page3++; 
    }
  }

  @override
  Widget build(BuildContext context) {
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
        child: Scaffold(
          appBar: AppBar(
            title: TextFormField(
              onChanged: (search){
                if(toggle == 0){
                  for(int i = 0; i < listsFamily.length; i++){
                    if(listsFamily[i].firstName == search || listsFamily[i].lastName == search){
                      searches.add(listsFamily[i]);
                    }
                  }
                }else if(toggle == 1){
                  for(int i = 0; i < listsFriends.length; i++){
                    if(listsFriends[i].firstName == search || listsFriends[i].lastName == search){
                      searches.add(listsFriends[i]);
                    }
                  }
                }else if(toggle == 2){
                  for(int i = 0; i < listsFollowers.length; i++){
                    if(listsFollowers[i].firstName == search || listsFollowers[i].lastName == search){
                      searches.add(listsFollowers[i]);
                    }
                  }
                }

                if(search == ''){
                  setState(() {
                    onSearch = false;
                    searches = [];
                  });
                }else{
                  setState(() {
                    onSearch = true;
                  });
                }
              },
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(15.0),
                filled: true,
                fillColor: Color(0xffffffff),
                focusColor: Color(0xffffffff),
                hintText: ((){
                  switch(toggle){
                    case 0: return 'Search Family';
                    case 1: return 'Search Friends';
                    case 2: return 'Search Followers';
                  }
                }()),
                hintStyle: TextStyle(fontSize: 16,),
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xffffffff)),
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                ),
                enabledBorder:  OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xffffffff)),
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                ),
                focusedBorder:  OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xffffffff)),
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                ),
              ),
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Color(0xffffffff),), 
              onPressed: (){
                Navigator.pop(context);
              },
            ),
            backgroundColor: Color(0xff04ECFF),
          ),
          body: Column(
            children: [

              Container(
                alignment: Alignment.center,
                width: SizeConfig.screenWidth,
                height: 70,
                color: Color(0xffffffff),
                child: DefaultTabController(
                  initialIndex: toggle,
                  length: 3,
                  child: TabBar(
                    labelColor: Color(0xff04ECFF),
                    unselectedLabelColor: Color(0xff000000),
                    indicatorColor: Color(0xff04ECFF),
                    onTap: (int number){
                      setState(() {
                        toggle = number;
                      });
                    },
                    tabs: [

                      Center(
                        child: Text('Family',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),

                      Center(child: Text('Friends',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),

                      Center(
                        child: Text('Followers',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              ),

              Expanded(
                child: ((){
                  switch(toggle){
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
    );
  }

  connectionListFamilyWidget(){
    return RefreshIndicator(
      onRefresh: onRefresh1,
      child: GridView.count(
        controller: scrollController1,
        padding: EdgeInsets.all(10.0),
        physics: ClampingScrollPhysics(),
        crossAxisSpacing: 2,
        mainAxisSpacing: 20,
        crossAxisCount: 4,
        children: List.generate(
          onSearch ? searches.length : listsFamily.length, (int index) => 
          Column(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: (){
                    if(onSearch){
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
                  child: onSearch
                  ? CircleAvatar(
                    radius: 40,
                    backgroundColor: Color(0xff888888),
                    backgroundImage: NetworkImage(searches[index].image),
                  )
                  : CircleAvatar(
                    radius: 40,
                    backgroundColor: Color(0xff888888),
                    backgroundImage: NetworkImage(listsFamily[index].image),
                  ),
                ),
              ),

              onSearch
              ? Text('${searches[index].firstName} ${searches[index].lastName}', textAlign: TextAlign.center, overflow: TextOverflow.clip, maxLines: 1, style: TextStyle(fontSize: 14))
              : Text('${listsFamily[index].firstName} ${listsFamily[index].lastName}', textAlign: TextAlign.center, overflow: TextOverflow.clip, maxLines: 1, style: TextStyle(fontSize: 14)),

              Text('${listsFamily[index].relationship}', textAlign: TextAlign.center, overflow: TextOverflow.clip, maxLines: 1, style: TextStyle(fontSize: 12, color: Color(0xff888888))),
            ],
          ),
        ),
      ),
    );
  }

  connectionListFriendsWidget(){
    return RefreshIndicator(
      onRefresh: onRefresh2,
      child: GridView.count(
        controller: scrollController2,
        padding: EdgeInsets.all(10.0),
        physics: ClampingScrollPhysics(),
        crossAxisSpacing: 2,
        mainAxisSpacing: 20,
        crossAxisCount: 4,
        children: List.generate(onSearch ? searches.length : listsFriends.length, (index) =>           
          Column(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: (){
                    if(onSearch){
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
                  child: onSearch
                  ? CircleAvatar(
                    radius: 40,
                    backgroundColor: Color(0xff888888),
                    backgroundImage: NetworkImage(searches[index].image),
                  )
                  : CircleAvatar(
                    radius: 40,
                    backgroundColor: Color(0xff888888),
                    backgroundImage: NetworkImage(listsFriends[index].image),
                  ),
                ),
              ),

              onSearch
              ? Text('${searches[index].firstName} ${searches[index].lastName}', textAlign: TextAlign.center, overflow: TextOverflow.clip, maxLines: 1, style: TextStyle(fontSize: 14))
              : Text('${listsFriends[index].firstName} ${listsFriends[index].lastName}', textAlign: TextAlign.center, overflow: TextOverflow.clip, maxLines: 1, style: TextStyle(fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }

  connectionListFollowersWidget(){
    return RefreshIndicator(
      onRefresh: onRefresh3,
      child: GridView.count(
        controller: scrollController3,
        padding: EdgeInsets.all(10.0),
        physics: ClampingScrollPhysics(),
        crossAxisSpacing: 2,
        mainAxisSpacing: 20,
        crossAxisCount: 4,
        children: List.generate(onSearch ? searches.length : listsFollowers.length, (index) =>           
          Column(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: (){
                    if(onSearch){
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
                  child: onSearch
                  ? CircleAvatar(
                    radius: 40,
                    backgroundColor: Color(0xff888888),
                    backgroundImage: NetworkImage(searches[index].image),
                  )
                  : CircleAvatar(
                    radius: 40,
                    backgroundColor: Color(0xff888888),
                    backgroundImage: NetworkImage(listsFollowers[index].image),
                  ),
                ),
              ),

              onSearch
              ? Text('${searches[index].firstName} ${searches[index].lastName}', textAlign: TextAlign.center, overflow: TextOverflow.clip, maxLines: 1, style: TextStyle(fontSize: 14))
              : Text('${listsFollowers[index].firstName} ${listsFollowers[index].lastName}', textAlign: TextAlign.center, overflow: TextOverflow.clip, maxLines: 1, style: TextStyle(fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }
}