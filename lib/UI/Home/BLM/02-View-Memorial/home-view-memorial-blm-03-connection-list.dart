import 'package:facesbyplaces/API/BLM/03-View-Memorial/api-view-memorial-blm-04-01-connection-list-family.dart';
import 'package:facesbyplaces/API/BLM/03-View-Memorial/api-view-memorial-blm-04-02-connection-list-friends.dart';
import 'package:facesbyplaces/API/BLM/03-View-Memorial/api-view-memorial-blm-04-03-connection-list-follower.dart';
import 'package:facesbyplaces/UI/Home/Regular/12-Show-User/home-show-user-regular-01-user.dart';
import 'package:facesbyplaces/UI/Home/BLM/12-Show-User/home-show-user-blm-01-user.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter/material.dart';

class BLMConnectionListItem{
  final int id;
  final int accountType;
  final String firstName;
  final String lastName;
  final String image;
  final String relationship;

  BLMConnectionListItem({this.id, this.accountType, this.firstName, this.lastName, this.image, this.relationship});
}

class HomeBLMConnectionList extends StatefulWidget{
  final int memorialId;
  final int newToggle;
  HomeBLMConnectionList({this.memorialId, this.newToggle});

  HomeBLMConnectionListState createState() => HomeBLMConnectionListState(memorialId: memorialId, newToggle: newToggle);
}

class HomeBLMConnectionListState extends State<HomeBLMConnectionList>{
  final int memorialId;
  final int newToggle;
  HomeBLMConnectionListState({this.memorialId, this.newToggle});

  RefreshController refreshController = RefreshController(initialRefresh: true);
  List<BLMConnectionListItem> listsFamily;
  List<BLMConnectionListItem> listsFriends;
  List<BLMConnectionListItem> listsFollowers;
  List<BLMConnectionListItem> searches;
  bool onSearch;
  Future connectionListFamily;
  int itemRemaining1;
  int itemRemaining2;
  int itemRemaining3;
  int page1;
  int page2;
  int page3;
  int toggle;

  void onRefresh() async{
    await Future.delayed(Duration(milliseconds: 1000));
    refreshController.refreshCompleted();
  }

  void onLoading1() async{
    if(itemRemaining1 != 0){

      context.showLoaderOverlay();
      var newValue = await apiBLMConnectionListFamily(memorialId: memorialId, page: page1);
      context.hideLoaderOverlay();

      itemRemaining1 = newValue.blmItemsRemaining;

      for(int i = 0; i < newValue.blmFamilyList.length; i++){
        listsFamily.add(
          BLMConnectionListItem(
            id: newValue.blmFamilyList[i].connectionListFamilyUser.connectionListFamilyDetailsId,
            accountType: newValue.blmFamilyList[i].connectionListFamilyUser.connectionListFamilyAccountType,
            firstName: newValue.blmFamilyList[i].connectionListFamilyUser.connectionListFamilyDetailsFirstName,
            lastName: newValue.blmFamilyList[i].connectionListFamilyUser.connectionListFamilyDetailsLastName,
            image: newValue.blmFamilyList[i].connectionListFamilyUser.connectionListFamilyDetailsImage,
            relationship: newValue.blmFamilyList[i].connectionListFamilyRelationship,
          ),    
        );
      }

      if(mounted)
      setState(() {});
      page1++;
      
      refreshController.loadComplete();
      
    }else{
      refreshController.loadNoData();
    }
  }

  void onLoading2() async{
    if(itemRemaining2 != 0){
      context.showLoaderOverlay();
      var newValue = await apiBLMConnectionListFriends(memorialId: memorialId, page: page2);
      context.hideLoaderOverlay();

      itemRemaining2 = newValue.blmItemsRemaining;

      for(int i = 0; i < newValue.blmFriendsList.length; i++){
        listsFriends.add(
          BLMConnectionListItem(
            id: newValue.blmFriendsList[i].connectionListFriendsUser.connectionListFriendsDetailsId,
            accountType: newValue.blmFriendsList[i].connectionListFriendsUser.connectionListFriendsAccountType,
            firstName: newValue.blmFriendsList[i].connectionListFriendsUser.connectionListFriendsDetailsFirstName,
            lastName: newValue.blmFriendsList[i].connectionListFriendsUser.connectionListFriendsDetailsLastName,
            image: newValue.blmFriendsList[i].connectionListFriendsUser.connectionListFriendsDetailsImage,
          ),    
        );
      }

      if(mounted)
      setState(() {});
      page2++;
      
      refreshController.loadComplete();
      
    }else{
      refreshController.loadNoData();
    }
  }

  void onLoading3() async{
    if(itemRemaining3 != 0){
      context.showLoaderOverlay();
      var newValue = await apiBLMConnectionListFollowers(memorialId: memorialId, page: page3);
      context.hideLoaderOverlay();

      itemRemaining3 = newValue.blmItemsRemaining;

      for(int i = 0; i < newValue.blmFollowersList.length; i++){
        listsFollowers.add(
          BLMConnectionListItem(
            id: newValue.blmFollowersList[i].connectionListFollowersId,
            accountType: newValue.blmFollowersList[i].connectionListFollowersAccountType,
            firstName: newValue.blmFollowersList[i].connectionListFollowersFirstName,
            lastName: newValue.blmFollowersList[i].connectionListFollowersLastName,
            image: newValue.blmFollowersList[i].connectionListFollowersImage,
          ),    
        );
      }

      if(mounted)
      setState(() {});
      page3++;
      
      refreshController.loadComplete();
      
    }else{
      refreshController.loadNoData();
    }
  }

  void initState(){
    super.initState();
    toggle = newToggle;
    listsFamily = [];
    listsFriends = [];
    listsFollowers = [];
    searches = [];
    onSearch = false;
    itemRemaining1 = 1;
    itemRemaining2 = 1;
    itemRemaining3 = 1;
    page1 = 1;
    page2 = 1;
    page3 = 1;
    onLoading1();
    onLoading2();
    onLoading3();
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
                    case 0: return 'Search Family'; break;
                    case 1: return 'Search Friends'; break;
                    case 2: return 'Search Followers'; break;
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
                    case 0: return connectionListFamilyWidget(); break;
                    case 1: return connectionListFriendsWidget(); break;
                    case 2: return connectionListFollowersWidget(); break;
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
    return Container(
      child: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: MaterialClassicHeader(
          color: Color(0xffffffff),
          backgroundColor: Color(0xff4EC9D4),
        ),
        footer: CustomFooter(
          loadStyle: LoadStyle.ShowWhenLoading,
          builder: (BuildContext context, LoadStatus mode){
            Widget body;
            if(mode == LoadStatus.loading){
              body = CircularProgressIndicator();
            }
            return Center(child: body);
          },
        ),
        controller: refreshController,
        onRefresh: onRefresh,
        onLoading: onLoading1,
        child: GridView.count(
          padding: EdgeInsets.all(10.0),
          physics: ClampingScrollPhysics(),
          crossAxisSpacing: 2,
          mainAxisSpacing: 20,
          crossAxisCount: 4,
          children: List.generate(
            onSearch ? searches.length : listsFamily.length, (index) => Column(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: (){
                      if(onSearch){
                        if(searches[index].accountType == 1){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMUserProfile(userId: searches[index].id)));
                        }else{
                          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularUserProfile(userId: searches[index].id)));
                        }
                      }else{
                        if(listsFamily[index].accountType == 1){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMUserProfile(userId: listsFamily[index].id)));
                        }else{
                          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularUserProfile(userId: listsFamily[index].id)));
                        }
                      }
                    },
                    child: onSearch
                    ? CircleAvatar(
                      radius: 40,
                      backgroundColor: Color(0xff888888), 
                      backgroundImage: searches[index].image != null && searches[index].image != ''
                      ? NetworkImage(searches[index].image) 
                      : AssetImage('assets/icons/app-icon.png'),
                    )
                    : CircleAvatar(
                      radius: 40,
                      backgroundColor: Color(0xff888888), 
                      backgroundImage: listsFamily[index].image != null && listsFamily[index].image != ''
                      ? NetworkImage(listsFamily[index].image) 
                      : AssetImage('assets/icons/app-icon.png'),
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
      )
    );
  }

  connectionListFriendsWidget(){
    return Container(
      child: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: MaterialClassicHeader(
          color: Color(0xffffffff),
          backgroundColor: Color(0xff4EC9D4),
        ),
        footer: CustomFooter(
          loadStyle: LoadStyle.ShowWhenLoading,
          builder: (BuildContext context, LoadStatus mode){
            Widget body;
            if(mode == LoadStatus.loading){
              body = CircularProgressIndicator();
            }
            return Center(child: body);
          },
        ),
        controller: refreshController,
        onRefresh: onRefresh,
        onLoading: onLoading2,
        child: GridView.count(
          padding: EdgeInsets.all(10.0),
          physics: ClampingScrollPhysics(),
          crossAxisSpacing: 2,
          mainAxisSpacing: 20,
          crossAxisCount: 4,
          children: List.generate(
            onSearch ? searches.length : listsFriends.length, (index) => Column(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: (){
                      if(onSearch){
                        if(searches[index].accountType == 1){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMUserProfile(userId: searches[index].id)));
                        }else{
                          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularUserProfile(userId: searches[index].id)));
                        }
                      }else{
                        if(listsFriends[index].accountType == 1){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMUserProfile(userId: listsFriends[index].id)));
                        }else{
                          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularUserProfile(userId: listsFriends[index].id)));
                        }
                      }
                    },
                    child: onSearch
                    ? CircleAvatar(
                      radius: 40,
                      backgroundColor: Color(0xff888888), 
                      backgroundImage: searches[index].image != null && searches[index].image != ''
                      ? NetworkImage(searches[index].image) 
                      : AssetImage('assets/icons/app-icon.png'),
                    )
                    : CircleAvatar(
                      radius: 40,
                      backgroundColor: Color(0xff888888), 
                      backgroundImage: listsFriends[index].image != null && listsFriends[index].image != ''
                      ? NetworkImage(listsFriends[index].image) 
                      : AssetImage('assets/icons/app-icon.png'),
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
      )
    );
  }

  connectionListFollowersWidget(){
    return Container(
      child: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: MaterialClassicHeader(
          color: Color(0xffffffff),
          backgroundColor: Color(0xff4EC9D4),
        ),
        footer: CustomFooter(
          loadStyle: LoadStyle.ShowWhenLoading,
          builder: (BuildContext context, LoadStatus mode){
            Widget body;
            if(mode == LoadStatus.loading){
              body = CircularProgressIndicator();
            }
            return Center(child: body);
          },
        ),
        controller: refreshController,
        onRefresh: onRefresh,
        onLoading: onLoading3,
        child: GridView.count(
          padding: EdgeInsets.all(10.0),
          physics: ClampingScrollPhysics(),
          crossAxisSpacing: 2,
          mainAxisSpacing: 20,
          crossAxisCount: 4,
          children: List.generate(
            onSearch ? searches.length : listsFollowers.length, (index) => Column(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: (){
                      if(onSearch){
                        if(searches[index].accountType == 1){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMUserProfile(userId: searches[index].id)));
                        }else{
                          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularUserProfile(userId: searches[index].id)));
                        }
                      }else{
                        if(listsFollowers[index].accountType == 1){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMUserProfile(userId: listsFollowers[index].id)));
                        }else{
                          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularUserProfile(userId: listsFollowers[index].id)));
                        }
                      }
                    },
                    child: onSearch
                    ? CircleAvatar(
                      radius: 40,
                      backgroundColor: Color(0xff888888), 
                      backgroundImage: searches[index].image != null && searches[index].image != ''
                      ? NetworkImage(searches[index].image) 
                      : AssetImage('assets/icons/app-icon.png'),
                    )
                    : CircleAvatar(
                      radius: 40,
                      backgroundColor: Color(0xff888888), 
                      backgroundImage: listsFollowers[index].image != null && listsFollowers[index].image != ''
                      ? NetworkImage(listsFollowers[index].image) 
                      : AssetImage('assets/icons/app-icon.png'),
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
      )
    );
  }

}