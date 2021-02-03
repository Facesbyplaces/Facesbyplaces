import 'package:facesbyplaces/API/Regular/09-Settings-Memorial/api-settings-memorial-regular-05-show-friends-settings.dart';
import 'package:facesbyplaces/API/Regular/09-Settings-Memorial/api-settings-memorial-regular-13-remove-friends-or-family.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'home-settings-memorial-regular-07-search-user-settings.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:flutter/material.dart';

class RegularShowFriendsSettings{
  final int userId;
  final String firstName;
  final String lastName;
  final String image;
  final String relationship;
  final int accountType;

  RegularShowFriendsSettings({this.userId, this.firstName, this.lastName, this.image, this.relationship, this.accountType});
}

class HomeRegularPageFriends extends StatefulWidget{
  final int memorialId;
  HomeRegularPageFriends({this.memorialId});

  HomeRegularPageFriendsState createState() => HomeRegularPageFriendsState(memorialId: memorialId);
}

class HomeRegularPageFriendsState extends State<HomeRegularPageFriends>{
  final int memorialId;
  HomeRegularPageFriendsState({this.memorialId});

  RefreshController refreshController = RefreshController(initialRefresh: true);
  List<RegularShowFriendsSettings> friendsList;
  int friendsItemsRemaining;
  int page;

  void onRefresh() async{
    await Future.delayed(Duration(milliseconds: 1000));
    refreshController.refreshCompleted();
  }

  void onLoading1() async{
    if(friendsItemsRemaining != 0){
      context.showLoaderOverlay();
      var newValue = await apiRegularShowFriendsSettings(memorialId: memorialId, page: page);
      context.hideLoaderOverlay();

      if(newValue == null){
        await showDialog(
          context: context,
          builder: (_) => 
            AssetGiffyDialog(
            image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
            title: Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
            entryAnimation: EntryAnimation.DEFAULT,
            description: Text('Something went wrong. Please try again.',
              textAlign: TextAlign.center,
              style: TextStyle(),
            ),
            onlyOkButton: true,
            buttonOkColor: Colors.red,
            onOkButtonPressed: () {
              Navigator.pop(context, true);
            },
          )
        );
      }else{
        friendsItemsRemaining = newValue.almItemsRemaining;

        for(int i = 0; i < newValue.almFriendsList.length; i++){
          friendsList.add(
            RegularShowFriendsSettings(
              userId: newValue.almFriendsList[i].showFriendsSettingsUser.showFriendsSettingsDetailsId,
              firstName: newValue.almFriendsList[i].showFriendsSettingsUser.showFriendsSettingsDetailsFirstName,
              lastName: newValue.almFriendsList[i].showFriendsSettingsUser.showFriendsSettingsDetailsLastName,
              image: newValue.almFriendsList[i].showFriendsSettingsUser.showFriendsSettingsDetailsImage,
              relationship: newValue.almFriendsList[i].showFriendsSettingsRelationship,
              accountType: newValue.almFriendsList[i].showFriendsSettingsUser.showFriendsSettingsDetailsAccountType,
            ),
          );
        }

        if(mounted)
        setState(() {});
        page++;
        
        refreshController.loadComplete();
      }
    }else{
      refreshController.loadNoData();
    }
  }

  void initState(){
    super.initState();
    friendsItemsRemaining = 1;
    friendsList = [];
    page = 1; 
    onLoading1();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff04ECFF),
        title: Text('Page Friends', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xffffffff)),),
        centerTitle: true,
        leading: IconButton(icon: Icon(Icons.arrow_back, color: Color(0xffffffff),), onPressed: (){Navigator.pop(context);},),
        actions: [
          GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularSearchUser(isFamily: false, memorialId: memorialId,)));
            },
            child: Center(child: Text('Add Friends', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xffffffff)),),),
          ),
        ],
      ),
      body: Container(
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
          child: ListView.separated(
            physics: ClampingScrollPhysics(),
            itemBuilder: (c, i) {
              return Container(
                padding: EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      maxRadius: SizeConfig.blockSizeVertical * 5,
                      backgroundColor: Color(0xff888888),
                      backgroundImage: friendsList[i].image != null ? NetworkImage(friendsList[i].image) : AssetImage('assets/icons/app-icon.png'),
                    ),

                    SizedBox(width: SizeConfig.blockSizeHorizontal * 3,),

                    Expanded(
                      child: Container(
                        child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(friendsList[i].firstName + ' ' + friendsList[i].lastName, style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, fontWeight: FontWeight.bold, color: Color(0xff000000)),),

                          Text(friendsList[i].relationship, style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 3.5, color: Color(0xff888888)),),
                        ],
                      ),
                      ),
                    ),

                    SizedBox(width: SizeConfig.blockSizeHorizontal * 3,),

                    MaterialButton(
                      minWidth: SizeConfig.screenWidth / 3.5,
                      padding: EdgeInsets.zero,
                      textColor: Color(0xffffffff),
                      splashColor: Color(0xff04ECFF),
                      onPressed: () async{
                        context.showLoaderOverlay();
                        bool result = await apiRegularDeleteMemorialFriendsOrFamily(memorialId: memorialId, userId: friendsList[i].userId, accountType: friendsList[i].accountType);
                        context.hideLoaderOverlay();

                        if(result == true){
                          await showDialog(
                            context: context,
                            builder: (_) => 
                              AssetGiffyDialog(
                              image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                              title: Text('Success', textAlign: TextAlign.center, style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                              entryAnimation: EntryAnimation.DEFAULT,
                              description: Text('Successfully removed a user from Friends list.',
                                textAlign: TextAlign.center,
                                style: TextStyle(),
                              ),
                              onlyOkButton: true,
                              buttonOkColor: Colors.green,
                              onOkButtonPressed: () {
                                Navigator.pop(context, true);
                              },
                            )
                          );
                        }else{
                          await showDialog(
                            context: context,
                            builder: (_) => 
                              AssetGiffyDialog(
                              image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                              title: Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                              entryAnimation: EntryAnimation.DEFAULT,
                              description: Text('Something went wrong. Please try again.',
                                textAlign: TextAlign.center,
                                style: TextStyle(),
                              ),
                              onlyOkButton: true,
                              buttonOkColor: Colors.red,
                              onOkButtonPressed: () {
                                Navigator.pop(context, true);
                              },
                            )
                          );
                        }

                        friendsItemsRemaining = 1;
                        friendsList = [];
                        page = 1; 
                        onLoading1();
                      },
                      child: Text('Remove', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 3.5,),),
                      height: SizeConfig.blockSizeVertical * 5,
                      shape: StadiumBorder(
                        side: BorderSide(color: Color(0xffE74C3C)),
                      ),
                        color: Color(0xffE74C3C),
                    ),

                  ],
                ),
              );
            },
            separatorBuilder: (c, i) => Divider(height: SizeConfig.blockSizeVertical * 1, color: Colors.transparent),
            itemCount: friendsList.length,
          ),
        ),
      ),
    );
  }
}


