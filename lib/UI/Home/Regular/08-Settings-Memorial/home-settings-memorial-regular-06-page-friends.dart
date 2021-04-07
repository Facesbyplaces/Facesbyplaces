import 'package:facesbyplaces/API/Regular/09-Settings-Memorial/api-settings-memorial-regular-05-show-friends-settings.dart';
import 'package:facesbyplaces/API/Regular/09-Settings-Memorial/api-settings-memorial-regular-13-remove-friends-or-family.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'home-settings-memorial-regular-07-search-user-settings.dart';
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

  RegularShowFriendsSettings({required this.userId, required this.firstName, required this.lastName, required this.image, required this.relationship, required this.accountType});
}

class HomeRegularPageFriends extends StatefulWidget{
  final int memorialId;
  HomeRegularPageFriends({required this.memorialId});

  HomeRegularPageFriendsState createState() => HomeRegularPageFriendsState(memorialId: memorialId);
}

class HomeRegularPageFriendsState extends State<HomeRegularPageFriends>{
  final int memorialId;
  HomeRegularPageFriendsState({required this.memorialId});

  ScrollController scrollController = ScrollController();
  int friendsItemsRemaining = 1;
  List<Widget> friends = [];
  int page = 1;

  void initState(){
    super.initState();
    onLoading();
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        if(friendsItemsRemaining != 0){
          setState(() {
            onLoading();
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
      onLoading();
    });
  }

  void onLoading() async{
    if(friendsItemsRemaining != 0){
      context.showLoaderOverlay();
      var newValue = await apiRegularShowFriendsSettings(memorialId: memorialId, page: page);
      context.hideLoaderOverlay();

      friendsItemsRemaining = newValue.almItemsRemaining;

      for(int i = 0; i < newValue.almFriendsList.length; i++){
        friends.add(
          ListTile(
            leading: CircleAvatar(backgroundColor: Color(0xff888888), backgroundImage: NetworkImage('${newValue.almFriendsList[i].showFriendsSettingsUser.showFriendsSettingsDetailsImage}'),),
            title: Text('${newValue.almFriendsList[i].showFriendsSettingsUser.showFriendsSettingsDetailsFirstName} ${newValue.almFriendsList[i].showFriendsSettingsUser.showFriendsSettingsDetailsLastName}'),
            subtitle: Text('${newValue.almFriendsList[i].showFriendsSettingsUser.showFriendsSettingsDetailsEmail}'),
            trailing: MaterialButton(
              minWidth: SizeConfig.screenWidth! / 3.5,
              padding: EdgeInsets.zero,
              textColor: Color(0xffffffff),
              splashColor: Color(0xff04ECFF),
              onPressed: () async{
                context.showLoaderOverlay();
                bool result = await apiRegularDeleteMemorialFriendsOrFamily(memorialId: memorialId, userId: newValue.almFriendsList[i].showFriendsSettingsUser.showFriendsSettingsDetailsId, accountType: newValue.almFriendsList[i].showFriendsSettingsUser.showFriendsSettingsDetailsAccountType);
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
                page = 1; 
                onLoading();
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
              Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularSearchUser(isFamily: false, memorialId: memorialId,)));
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
    );
  }
}


