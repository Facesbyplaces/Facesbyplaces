import 'package:facesbyplaces/API/Regular/03-View-Memorial/api-view-memorial-regular-04-01-connection-list-family.dart';
import 'package:facesbyplaces/API/Regular/03-View-Memorial/api-view-memorial-regular-04-02-connection-list-friends.dart';
import 'package:facesbyplaces/API/Regular/03-View-Memorial/api-view-memorial-regular-04-03-connection-list-followers.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter/material.dart';

class RegularConnectionListItem{
  final String firstName;
  final String lastName;
  final String image;
  final String relationship;

  RegularConnectionListItem({this.firstName, this.lastName, this.image, this.relationship});
}

class HomeRegularConnectionList extends StatefulWidget{
  final int memorialId;
  final int newToggle;
  HomeRegularConnectionList({this.memorialId, this.newToggle});

  HomeRegularConnectionListState createState() => HomeRegularConnectionListState(memorialId: memorialId, newToggle: newToggle);
}

class HomeRegularConnectionListState extends State<HomeRegularConnectionList>{
  final int memorialId;
  final int newToggle;
  HomeRegularConnectionListState({this.memorialId, this.newToggle});

  RefreshController refreshController = RefreshController(initialRefresh: true);
  List<RegularConnectionListItem> listsFamily;
  List<RegularConnectionListItem> listsFriends;
  List<RegularConnectionListItem> listsFollowers;
  List<RegularConnectionListItem> searches;
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
      var newValue = await apiRegularConnectionListFamily(memorialId: memorialId, page: page1);
      context.hideLoaderOverlay();

      itemRemaining1 = newValue.almItemsRemaining;

      for(int i = 0; i < newValue.almFamilyList.length; i++){
        listsFamily.add(
          RegularConnectionListItem(
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
      
      refreshController.loadComplete();
      
    }else{
      refreshController.loadNoData();
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
            firstName: newValue.almFriendsList[i].connectionListFriendsUser.connectionListFriendsDetailsFirstName,
            lastName: newValue.almFriendsList[i].connectionListFriendsUser.connectionListFriendsDetailsLastName,
            image: newValue.almFriendsList[i].connectionListFriendsUser.connectionListFriendsDetailsImage,
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
      var newValue = await apiRegularConnectionListFollowers(memorialId: memorialId, page: page3);
      context.hideLoaderOverlay();

      itemRemaining3 = newValue.almItemsRemaining;

      for(int i = 0; i < newValue.almFollowersList.length; i++){
        listsFollowers.add(
          RegularConnectionListItem(
            firstName: newValue.almFollowersList[i].connectionListFollowersDetailsFirstName,
            lastName: newValue.almFollowersList[i].connectionListFollowersDetailsLastName,
            image: newValue.almFollowersList[i].connectionListFollowersDetailsImage,
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
                hintStyle: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4,),
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
                height: SizeConfig.blockSizeVertical * 8,
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
                            fontSize: SizeConfig.safeBlockHorizontal * 4,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),

                      Center(child: Text('Friends',
                          style: TextStyle(
                            fontSize: SizeConfig.safeBlockHorizontal * 4,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),

                      Center(
                        child: Text('Followers',
                          style: TextStyle(
                            fontSize: SizeConfig.safeBlockHorizontal * 4,
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
                onSearch
                ? Expanded(
                  child: CircleAvatar(
                    radius: SizeConfig.blockSizeVertical * 5,
                    backgroundColor: Color(0xff888888), 
                    backgroundImage: searches[index].image != null && searches[index].image != ''
                    ? NetworkImage(searches[index].image) 
                    : AssetImage('assets/icons/app-icon.png'),
                  ),
                )
                : Expanded(
                  child: CircleAvatar(
                    radius: SizeConfig.blockSizeVertical * 5,
                    backgroundColor: Color(0xff888888), 
                    backgroundImage: listsFamily[index].image != null && listsFamily[index].image != ''
                    ? NetworkImage(listsFamily[index].image) 
                    : AssetImage('assets/icons/app-icon.png'),
                  ),
                ),

                onSearch
                ? Text(searches[index].firstName.toString() + ' ' + searches[index].lastName.toString(), textAlign: TextAlign.center, overflow: TextOverflow.clip, maxLines: 1, style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 3.5))
                : Text(listsFamily[index].firstName.toString() + ' ' + listsFamily[index].lastName.toString(), textAlign: TextAlign.center, overflow: TextOverflow.clip, maxLines: 1, style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 3.5)),

                Text('${listsFamily[index].relationship}', textAlign: TextAlign.center, overflow: TextOverflow.clip, maxLines: 1, style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 3, color: Color(0xff888888))),
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
                onSearch
                ? Expanded(
                  child: CircleAvatar(
                    radius: SizeConfig.blockSizeVertical * 5,
                    backgroundColor: Color(0xff888888), 
                    backgroundImage: searches[index].image != null && searches[index].image != ''
                    ? NetworkImage(searches[index].image) 
                    : AssetImage('assets/icons/app-icon.png'),
                  ),
                )
                : Expanded(
                  child: CircleAvatar(
                    radius: SizeConfig.blockSizeVertical * 5,
                    backgroundColor: Color(0xff888888), 
                    backgroundImage: listsFriends[index].image != null && listsFriends[index].image != ''
                    ? NetworkImage(listsFriends[index].image) 
                    : AssetImage('assets/icons/app-icon.png'),
                  ),
                ),

                onSearch
                ? Text(searches[index].firstName.toString() + ' ' + searches[index].lastName.toString(), textAlign: TextAlign.center, overflow: TextOverflow.clip, maxLines: 1, style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 3.5))
                : Text(listsFriends[index].firstName.toString() + ' ' + listsFriends[index].lastName.toString(), textAlign: TextAlign.center, overflow: TextOverflow.clip, maxLines: 1, style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 3.5)),
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
                onSearch
                ? Expanded(
                  child: CircleAvatar(
                    radius: SizeConfig.blockSizeVertical * 5,
                    backgroundColor: Color(0xff888888), 
                    backgroundImage: searches[index].image != null && searches[index].image != ''
                    ? NetworkImage(searches[index].image) 
                    : AssetImage('assets/icons/app-icon.png'),
                  ),
                )
                : Expanded(
                  child: CircleAvatar(
                    radius: SizeConfig.blockSizeVertical * 5,
                    backgroundColor: Color(0xff888888), 
                    backgroundImage: listsFollowers[index].image != null && listsFollowers[index].image != ''
                    ? NetworkImage(listsFollowers[index].image) 
                    : AssetImage('assets/icons/app-icon.png'),
                  ),
                ),

                onSearch
                ? Text(searches[index].firstName.toString() + ' ' + searches[index].lastName.toString(), textAlign: TextAlign.center, overflow: TextOverflow.clip, maxLines: 1, style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 3.5))
                : Text(listsFollowers[index].firstName.toString() + ' ' + listsFollowers[index].lastName.toString(), textAlign: TextAlign.center, overflow: TextOverflow.clip, maxLines: 1, style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 3.5)),
              ],
            ),
          ),
        ),
      )
    );
  }
}