import 'package:facesbyplaces/API/BLM/api-34-blm-show-friends-settings.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter/material.dart';
import 'home-29-blm-search-user-settings.dart';

class BLMShowFriendsSettings{
  final String firstName;
  final String lastName;
  final String image;
  final String relationship;

  BLMShowFriendsSettings({this.firstName, this.lastName, this.image, this.relationship});
}

class HomeBLMPageFriends extends StatefulWidget{
  final int memorialId;
  HomeBLMPageFriends({this.memorialId});

  HomeBLMPageFriendsState createState() => HomeBLMPageFriendsState(memorialId: memorialId);
}

class HomeBLMPageFriendsState extends State<HomeBLMPageFriends>{
  final int memorialId;
  HomeBLMPageFriendsState({this.memorialId});

  RefreshController refreshController = RefreshController(initialRefresh: true);
  List<BLMShowFriendsSettings> friendsList;
  int friendsItemsRemaining;
  int page;

  void onRefresh() async{
    await Future.delayed(Duration(milliseconds: 1000));
    refreshController.refreshCompleted();
  }

  void onLoading1() async{
    if(friendsItemsRemaining != 0){
      context.showLoaderOverlay();
      var newValue = await apiBLMShowFriendsSettings(memorialId, page);
      friendsItemsRemaining = newValue.itemsRemaining;

      for(int i = 0; i < newValue.friendsList.length; i++){
        friendsList.add(
          BLMShowFriendsSettings(
            firstName: newValue.friendsList[i].user.firstName,
            lastName: newValue.friendsList[i].user.lastName,
            image: newValue.friendsList[i].user.image,
          ),
        );
      }

      if(mounted)
      setState(() {});
      page++;
      
      refreshController.loadComplete();
      context.hideLoaderOverlay();
    }else{
      refreshController.loadNoData();
    }
  }

  void initState(){
    super.initState();
    onLoading1();
    friendsItemsRemaining = 1;
    friendsList = [];
    page = 1;
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
              Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMSearchUser(isFamily: false, memorialId: memorialId,)));
            },
            child: Center(child: Text('Add Friends', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xffffffff)),),),
          ),
        ],
      ),
      body: Container(
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
              }else{
                body = Text('End of list.', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
              }
              return Container(height: 55.0, child: Center(child: body),);
            },
          ),
          controller: refreshController,
          onRefresh: onRefresh,
          onLoading: onLoading1,
          child: ListView.separated(
            physics: ClampingScrollPhysics(),
            itemBuilder: (c, i) {
              var container = Container(
                padding: EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      maxRadius: SizeConfig.blockSizeVertical * 5,
                      backgroundColor: Color(0xff888888),
                      backgroundImage: AssetImage('assets/icons/graveyard.png'),
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

              return container;
              
            },
            separatorBuilder: (c, i) => Divider(height: SizeConfig.blockSizeVertical * 1, color: Colors.transparent),
            itemCount: friendsList.length,
          ),
        ),
      ),
    );
  }
}


