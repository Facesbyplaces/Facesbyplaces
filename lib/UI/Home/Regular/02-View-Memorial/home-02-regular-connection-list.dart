import 'package:facesbyplaces/API/Regular/api-23-regular-connection-list-family.dart';
import 'package:facesbyplaces/API/Regular/api-24-regular-connection-list-friends.dart';
import 'package:facesbyplaces/API/Regular/api-25-regular-connection-list-followers.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter/material.dart';

class RegularConnectionListItem{
  final String firstName;
  final String lastName;
  final String image;

  RegularConnectionListItem({this.firstName, this.lastName, this.image});
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
  int page;
  int toggle;

  void onRefresh() async{
    await Future.delayed(Duration(milliseconds: 1000));
    refreshController.refreshCompleted();
  }

  void onLoading1() async{
    if(itemRemaining1 != 0){

      context.showLoaderOverlay();
      var newValue = await apiRegularConnectionListFamily(memorialId, page);
      context.hideLoaderOverlay();

      itemRemaining1 = newValue.itemsRemaining;

      for(int i = 0; i < newValue.familyList.length; i++){
        listsFamily.add(
          RegularConnectionListItem(
            firstName: newValue.familyList[i].user.firstName,
            lastName: newValue.familyList[i].user.lastName,
            image: newValue.familyList[i].user.image,
          ),    
        );
      }

      if(mounted)
      setState(() {});
      
      refreshController.loadComplete();
      
    }else{
      refreshController.loadNoData();
    }
  }

  void onLoading2() async{
    if(itemRemaining2 != 0){
      context.showLoaderOverlay();
      var newValue = await apiRegularConnectionListFriends(memorialId, page);
      context.hideLoaderOverlay();

      itemRemaining2 = newValue.itemsRemaining;

      for(int i = 0; i < newValue.friendsList.length; i++){
        listsFriends.add(
          RegularConnectionListItem(
            firstName: newValue.friendsList[i].user.firstName,
            lastName: newValue.friendsList[i].user.lastName,
            image: newValue.friendsList[i].user.image,
          ),    
        );
      }

      if(mounted)
      setState(() {});
      
      refreshController.loadComplete();
      
    }else{
      refreshController.loadNoData();
    }
  }

  void onLoading3() async{
    if(itemRemaining3 != 0){
      context.showLoaderOverlay();
      var newValue = await apiRegularConnectionListFollowers(memorialId, page);
      context.hideLoaderOverlay();

      itemRemaining3 = newValue.itemsRemaining;

      for(int i = 0; i < newValue.followersList.length; i++){
        listsFriends.add(
          RegularConnectionListItem(
            firstName: newValue.followersList[i].user.firstName,
            lastName: newValue.followersList[i].user.lastName,
            image: newValue.followersList[i].user.image,
          ),    
        );
      }

      if(mounted)
      setState(() {});
      
      refreshController.loadComplete();
      
    }else{
      refreshController.loadNoData();
    }
  }

  void initState(){
    super.initState();
    onLoading1();
    onLoading2();
    onLoading3();
    toggle = newToggle;
    listsFamily = [];
    listsFriends = [];
    listsFollowers = [];
    searches = [];
    onSearch = false;
    itemRemaining1 = 1;
    itemRemaining2 = 1;
    itemRemaining3 = 1;
    page = 1;
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
        enablePullDown: false,
        enablePullUp: true,
        header: MaterialClassicHeader(),
        footer: CustomFooter(
          loadStyle: LoadStyle.ShowWhenLoading,
          builder: (BuildContext context, LoadStatus mode){
            Widget body;
            if(mode == LoadStatus.idle){
              body = Text('Pull up load.', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
            }
            else if(mode == LoadStatus.loading){
              body = CircularProgressIndicator();
            }
            else if(mode == LoadStatus.failed){
              body = Text('Load Failed! Please try again.', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
            }
            else if(mode == LoadStatus.canLoading){
              body = Text('Release to load more.', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
              page++;
            }
            else{
              body = Text('No more list.', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
            }
            return Container(height: 55.0, child: Center(child: body),);
          },
        ),
        controller: refreshController,
        onRefresh: onRefresh,
        onLoading: onLoading1,
        child: Container(
          padding: EdgeInsets.all(10.0),
          child: GridView.count(
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
                      backgroundImage: ((){
                        if(searches[index].image.toString() == '' || searches[index].image.toString() == null){
                          return AssetImage('assets/icons/graveyard.png');
                        }else{
                          return CachedNetworkImageProvider(
                            searches[index].image.toString(),
                            scale: 1.0,
                          );
                        }
                      }()),
                    ),
                  )
                  : Expanded(
                    child: CircleAvatar(
                      radius: SizeConfig.blockSizeVertical * 5, 
                      backgroundColor: Color(0xff888888),
                      backgroundImage: ((){
                        if(listsFamily[index].image.toString() == '' || listsFamily[index].image.toString() == null){
                          return AssetImage('assets/icons/graveyard.png');
                        }else{
                          return CachedNetworkImageProvider(
                            listsFamily[index].image.toString(),
                            scale: 1.0,
                          );
                        }
                      }()),
                    ),
                  ),

                  onSearch
                  ? Text(searches[index].firstName.toString() + ' ' + searches[index].lastName.toString(), textAlign: TextAlign.center, overflow: TextOverflow.clip, maxLines: 1, style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 3.5))
                  : Text(listsFamily[index].firstName.toString() + ' ' + listsFamily[index].lastName.toString(), textAlign: TextAlign.center, overflow: TextOverflow.clip, maxLines: 1, style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 3.5)),
                ],
              ),
            ),
          ),
        ),
      )
    );
  }

  connectionListFriendsWidget(){
    return Container(
      child: SmartRefresher(
        enablePullDown: false,
        enablePullUp: true,
        header: MaterialClassicHeader(),
        footer: CustomFooter(
          loadStyle: LoadStyle.ShowWhenLoading,
          builder: (BuildContext context, LoadStatus mode){
            Widget body;
            if(mode == LoadStatus.idle){
              body =  Text('Pull up load.', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
            }
            else if(mode == LoadStatus.loading){
              body =  CircularProgressIndicator();
            }
            else if(mode == LoadStatus.failed){
              body = Text('Load Failed! Please try again.', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
            }
            else if(mode == LoadStatus.canLoading){
              body = Text('Release to load more.', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
              page++;
            }
            else{
              body = Text('No more post.', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
            }
            return Container(height: 55.0, child: Center(child: body),);
          },
        ),
        controller: refreshController,
        onRefresh: onRefresh,
        onLoading: onLoading2,
        child: Container(
          padding: EdgeInsets.all(10.0),
          child: GridView.count(
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
                      backgroundImage: ((){
                        if(searches[index].image.toString() == '' || searches[index].image.toString() == null){
                          return AssetImage('assets/icons/graveyard.png');
                        }else{
                          return CachedNetworkImageProvider(
                            searches[index].image.toString(),
                            scale: 1.0,
                          );
                        }
                      }()),
                    ),
                  )
                  : Expanded(
                    child: CircleAvatar(
                      radius: SizeConfig.blockSizeVertical * 5, 
                      backgroundColor: Color(0xff888888),
                      backgroundImage: ((){
                        if(listsFriends[index].image.toString() == '' || listsFriends[index].image.toString() == null){
                          return AssetImage('assets/icons/graveyard.png');
                        }else{
                          return CachedNetworkImageProvider(
                            listsFriends[index].image.toString(),
                            scale: 1.0,
                          );
                        }
                      }()),
                    ),
                  ),

                  onSearch
                  ? Text(searches[index].firstName.toString() + ' ' + searches[index].lastName.toString(), textAlign: TextAlign.center, overflow: TextOverflow.clip, maxLines: 1, style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 3.5))
                  : Text(listsFriends[index].firstName.toString() + ' ' + listsFriends[index].lastName.toString(), textAlign: TextAlign.center, overflow: TextOverflow.clip, maxLines: 1, style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 3.5)),
                ],
              ),
            ),
          ),
        ),
      )
    );
  }

  connectionListFollowersWidget(){
    return Container(
      child: SmartRefresher(
        enablePullDown: false,
        enablePullUp: true,
        header: MaterialClassicHeader(),
        footer: CustomFooter(
          loadStyle: LoadStyle.ShowWhenLoading,
          builder: (BuildContext context, LoadStatus mode){
            Widget body;
            if(mode == LoadStatus.idle){
              body =  Text('Pull up load.', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
            }
            else if(mode == LoadStatus.loading){
              body =  CircularProgressIndicator();
            }
            else if(mode == LoadStatus.failed){
              body = Text('Load Failed! Please try again.', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
            }
            else if(mode == LoadStatus.canLoading){
              body = Text('Release to load more.', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
              page++;
            }
            else{
              body = Text('No more post.', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
            }
            return Container(height: 55.0, child: Center(child: body),);
          },
        ),
        controller: refreshController,
        onRefresh: onRefresh,
        onLoading: onLoading3,
        child: Container(
          padding: EdgeInsets.all(10.0),
          child: GridView.count(
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
                      backgroundImage: ((){
                        if(searches[index].image.toString() == '' || searches[index].image.toString() == null){
                          return AssetImage('assets/icons/graveyard.png');
                        }else{
                          return CachedNetworkImageProvider(
                            searches[index].image.toString(),
                            scale: 1.0,
                          );
                        }
                      }()),
                    ),
                  )
                  : Expanded(
                    child: CircleAvatar(
                      radius: SizeConfig.blockSizeVertical * 5, 
                      backgroundColor: Color(0xff888888),
                      backgroundImage: ((){
                        if(listsFollowers[index].image.toString() == '' || listsFollowers[index].image.toString() == null){
                          return AssetImage('assets/icons/graveyard.png');
                        }else{
                          return CachedNetworkImageProvider(
                            listsFollowers[index].image.toString(),
                            scale: 1.0,
                          );
                        }
                      }()),
                    ),
                  ),

                  onSearch
                  ? Text(searches[index].firstName.toString() + ' ' + searches[index].lastName.toString(), textAlign: TextAlign.center, overflow: TextOverflow.clip, maxLines: 1, style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 3.5))
                  : Text(listsFollowers[index].firstName.toString() + ' ' + listsFollowers[index].lastName.toString(), textAlign: TextAlign.center, overflow: TextOverflow.clip, maxLines: 1, style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 3.5)),
                ],
              ),
            ),
          ),
        ),
      )
    );
  }

}