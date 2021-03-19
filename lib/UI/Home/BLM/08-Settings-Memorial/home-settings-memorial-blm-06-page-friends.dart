import 'package:facesbyplaces/API/BLM/09-Settings-Memorial/api-settings-memorial-blm-05-show-friends-settings.dart';
import 'package:facesbyplaces/API/BLM/09-Settings-Memorial/api-settings-memorial-blm-13-remove-friends-or-family.dart';
// import 'package:facesbyplaces/API/BLM/09-Settings-Memorial/api-settings-memorial-blm-13-remove-friends-or-family.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'home-settings-memorial-blm-07-search-user-settings.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:loader_overlay/loader_overlay.dart';
// import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:flutter/material.dart';

class BLMShowFriendsSettings{
  final int userId;
  final String firstName;
  final String lastName;
  final String image;
  final String relationship;
  final int accountType;

  BLMShowFriendsSettings({required this.userId, required this.firstName, required this.lastName, required this.image, required this.relationship, required this.accountType});
}

class HomeBLMPageFriends extends StatefulWidget{
  final int memorialId;
  HomeBLMPageFriends({required this.memorialId});

  HomeBLMPageFriendsState createState() => HomeBLMPageFriendsState(memorialId: memorialId);
}

class HomeBLMPageFriendsState extends State<HomeBLMPageFriends>{
  final int memorialId;
  HomeBLMPageFriendsState({required this.memorialId});

  ScrollController scrollController = ScrollController();
  List<BLMShowFriendsSettings> friendsList = [];
  int friendsItemsRemaining = 1;
  List<Widget> friends = [];
  int page = 1;

  void initState(){
    super.initState();
    onLoading1();
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        if(friendsItemsRemaining != 0){
          setState(() {
            onLoading1();
          });
        }else{
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('No more users to show'),
              duration: Duration(seconds: 1),
              backgroundColor: Color(0xff4EC9D4),
            ),
          );
        }
      }
    });
  }

  Future<void> onRefresh() async{
    setState(() {
      onLoading1();
    });
  }

  void onLoading1() async{
    if(friendsItemsRemaining != 0){
      context.showLoaderOverlay();
      var newValue = await apiBLMShowFriendsSettings(memorialId: memorialId, page: page);
      context.hideLoaderOverlay();

      friendsItemsRemaining = newValue.blmItemsRemaining;

      for(int i = 0; i < newValue.blmFriendsList.length; i++){
        friends.add(
          ListTile(
            leading: CircleAvatar(backgroundColor: Color(0xff888888), backgroundImage: NetworkImage('${newValue.blmFriendsList[i].showFriendsSettingsUser.showFriendsSettingsDetailsImage}'),),
            title: Text('${newValue.blmFriendsList[i].showFriendsSettingsUser.showFriendsSettingsDetailsFirstName} ${newValue.blmFriendsList[i].showFriendsSettingsUser.showFriendsSettingsDetailsLastName}'),
            subtitle: Text('${newValue.blmFriendsList[i].showFriendsSettingsRelationship}'),
            trailing: MaterialButton(
              minWidth: SizeConfig.screenWidth! / 3.5,
              padding: EdgeInsets.zero,
              textColor: Color(0xffffffff),
              splashColor: Color(0xff04ECFF),
              onPressed: () async{
                context.showLoaderOverlay();
                bool result = await apiBLMDeleteMemorialFriendsOrFamily(memorialId: memorialId, userId: friendsList[i].userId, accountType: friendsList[i].accountType);
                context.hideLoaderOverlay();
                
                if(result == true){
                  await showOkAlertDialog(
                    context: context,
                    title: 'Success',
                    message: 'Successfully removed a user from Friends list.'
                  );
                }else{
                  await showOkAlertDialog(
                    context: context,
                    title: 'Error',
                    message: 'Something went wrong. Please try again.'
                  );
                }

                friendsItemsRemaining = 1;
                friendsList = [];
                page = 1;
                onLoading1();
              },
              child: Text('Remove', style: TextStyle(fontSize: 14,),),
              height: 40,
              shape: StadiumBorder(
                side: BorderSide(color: Color(0xffE74C3C)),
              ),
                color: Color(0xffE74C3C),
            ),
          ),
        );
      }

      if(mounted)
      setState(() {});
      page++;
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff04ECFF),
        title: Text('Page Friends', style: TextStyle(fontSize: 16, color: Color(0xffffffff)),),
        centerTitle: true,
        leading: IconButton(icon: Icon(Icons.arrow_back, color: Color(0xffffffff),), onPressed: (){Navigator.pop(context);},),
        actions: [
          GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMSearchUser(isFamily: false, memorialId: memorialId,)));
            },
            child: Center(child: Text('Add Friends', style: TextStyle(fontSize: 16, color: Color(0xffffffff)),),),
          ),
        ],
      ),
      body: Container(
        width: SizeConfig.screenWidth,
        child: RefreshIndicator(
          onRefresh: onRefresh,
          child: ListView.separated(
            controller: scrollController,
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
            physics: ClampingScrollPhysics(),
            itemCount: friends.length,
            separatorBuilder: (c, i) => Divider(height: 10, color: Colors.transparent),
            itemBuilder: (c, i) => friends[i],
          )
        ),
      ),
        // child: SmartRefresher(
        //   enablePullDown: true,
        //   enablePullUp: true,
        //   header: MaterialClassicHeader(
        //     color: Color(0xffffffff),
        //     backgroundColor: Color(0xff4EC9D4),
        //   ),
        //   footer: CustomFooter(
        //     loadStyle: LoadStyle.ShowWhenLoading,
        //     builder: (BuildContext context, LoadStatus mode){
        //       Widget body = Container();
        //       if(mode == LoadStatus.loading){
        //         body = CircularProgressIndicator();
        //       }
        //       return Center(child: body);
        //     },
        //   ),
        //   controller: refreshController,
        //   onRefresh: onRefresh,
        //   onLoading: onLoading1,
        //   child: ListView.separated(
        //     physics: ClampingScrollPhysics(),
        //     itemBuilder: (c, i) {
        //       return Container(
        //         padding: EdgeInsets.all(10.0),
        //         child: Row(
        //           children: [
        //             CircleAvatar(
        //               maxRadius: 40,
        //               backgroundColor: Color(0xff888888),
        //               // backgroundImage: friendsList[i].image != null ? NetworkImage(friendsList[i].image) : AssetImage('assets/icons/app-icon.png'),
        //               backgroundImage: NetworkImage(friendsList[i].image),
        //             ),

        //             SizedBox(width: 25,),

        //             Expanded(
        //               child: Container(
        //                 child: Column(
        //                   crossAxisAlignment: CrossAxisAlignment.start,
        //                   children: [
        //                     Text(friendsList[i].firstName + ' ' + friendsList[i].lastName, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xff000000)),),

        //                     Text(friendsList[i].relationship, style: TextStyle(fontSize: 12, color: Color(0xff888888)),),
        //                   ],
        //                 ),
        //               ),
        //             ),

        //             SizedBox(width: 25,),

        //             MaterialButton(
        //               minWidth: SizeConfig.screenWidth! / 3.5,
        //               padding: EdgeInsets.zero,
        //               textColor: Color(0xffffffff),
        //               splashColor: Color(0xff04ECFF),
        //               onPressed: () async{
        //                 context.showLoaderOverlay();
        //                 bool result = await apiBLMDeleteMemorialFriendsOrFamily(memorialId: memorialId, userId: friendsList[i].userId, accountType: friendsList[i].accountType);
        //                 context.hideLoaderOverlay();
                        
        //                 if(result == true){
        //                   await showDialog(
        //                     context: context,
        //                     builder: (_) => 
        //                       AssetGiffyDialog(
        //                       image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
        //                       title: Text('Success', textAlign: TextAlign.center, style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
        //                       entryAnimation: EntryAnimation.DEFAULT,
        //                       description: Text('Successfully removed a user from Friends list.',
        //                         textAlign: TextAlign.center,
        //                         style: TextStyle(),
        //                       ),
        //                       onlyOkButton: true,
        //                       buttonOkColor: Colors.green,
        //                       onOkButtonPressed: () {
        //                         Navigator.pop(context, true);
        //                       },
        //                     )
        //                   );
        //                 }else{
        //                   await showDialog(
        //                     context: context,
        //                     builder: (_) => 
        //                       AssetGiffyDialog(
        //                       image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
        //                       title: Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
        //                       entryAnimation: EntryAnimation.DEFAULT,
        //                       description: Text('Something went wrong. Please try again.',
        //                         textAlign: TextAlign.center,
        //                         style: TextStyle(),
        //                       ),
        //                       onlyOkButton: true,
        //                       buttonOkColor: Colors.red,
        //                       onOkButtonPressed: () {
        //                         Navigator.pop(context, true);
        //                       },
        //                     )
        //                   );
        //                 }

        //                 friendsItemsRemaining = 1;
        //                 friendsList = [];
        //                 page = 1;
        //                 onLoading1();
        //               },
        //               child: Text('Remove', style: TextStyle(fontSize: 14,),),
        //               height: 40,
        //               shape: StadiumBorder(
        //                 side: BorderSide(color: Color(0xffE74C3C)),
        //               ),
        //                 color: Color(0xffE74C3C),
        //             ),

        //           ],
        //         ),
        //       );
        //     },
        //     separatorBuilder: (c, i) => Divider(height: 10, color: Colors.transparent),
        //     itemCount: friendsList.length,
        //   ),
        // ),
    );
  }
}


