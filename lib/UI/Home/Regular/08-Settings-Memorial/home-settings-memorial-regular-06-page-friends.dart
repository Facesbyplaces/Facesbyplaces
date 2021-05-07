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

  const RegularShowFriendsSettings({required this.userId, required this.firstName, required this.lastName, required this.image, required this.relationship, required this.accountType});
}

class HomeRegularPageFriends extends StatefulWidget{
  final int memorialId;
  final String memorialName;
  final bool switchFamily;
  final bool switchFriends;
  final bool switchFollowers;

  const HomeRegularPageFriends({required this.memorialId, required this.memorialName, required this.switchFamily, required this.switchFriends, required this.switchFollowers});

  HomeRegularPageFriendsState createState() => HomeRegularPageFriendsState(memorialId: memorialId, memorialName: memorialName, switchFamily: switchFamily, switchFriends: switchFriends, switchFollowers: switchFollowers);
}

class HomeRegularPageFriendsState extends State<HomeRegularPageFriends>{
  final int memorialId;
  final String memorialName;
  final bool switchFamily;
  final bool switchFriends;
  final bool switchFollowers;

  HomeRegularPageFriendsState({required this.memorialId, required this.memorialName, required this.switchFamily, required this.switchFriends, required this.switchFollowers});

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
            const SnackBar(
              content: const Text('No more users to show'),
              duration: const Duration(seconds: 1),
              backgroundColor: const Color(0xff4EC9D4),
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
      context.loaderOverlay.show();
      var newValue = await apiRegularShowFriendsSettings(memorialId: memorialId, page: page);
      context.loaderOverlay.hide();

      friendsItemsRemaining = newValue.almItemsRemaining;

      for(int i = 0; i < newValue.almFriendsList.length; i++){
        friends.add(
          ListTile(
            leading: newValue.almFriendsList[i].showFriendsSettingsUser.showFriendsSettingsDetailsImage != '' ? CircleAvatar(backgroundColor: Color(0xff888888), backgroundImage: NetworkImage('${newValue.almFriendsList[i].showFriendsSettingsUser.showFriendsSettingsDetailsImage}')) : const CircleAvatar(backgroundColor: const Color(0xff888888), backgroundImage: const AssetImage('assets/icons/app-icon.png'),),
            title: Text('${newValue.almFriendsList[i].showFriendsSettingsUser.showFriendsSettingsDetailsFirstName} ${newValue.almFriendsList[i].showFriendsSettingsUser.showFriendsSettingsDetailsLastName}'),
            subtitle: Text('${newValue.almFriendsList[i].showFriendsSettingsUser.showFriendsSettingsDetailsEmail}'),
            trailing: MaterialButton(
              minWidth: SizeConfig.screenWidth! / 3.5,
              padding: EdgeInsets.zero,
              textColor: const Color(0xffffffff),
              splashColor: const Color(0xff04ECFF),
              onPressed: () async{
                bool confirmation = await showDialog(
                  context: context,
                  builder: (_) => 
                    AssetGiffyDialog(
                    image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                    title: const Text('Confirm', textAlign: TextAlign.center, style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                    entryAnimation: EntryAnimation.DEFAULT,
                    description: const Text('Are you sure you want to remove this user?',
                      textAlign: TextAlign.center,
                    ),
                    onlyOkButton: false,
                    onOkButtonPressed: () async{
                      Navigator.pop(context, true);
                    },
                    onCancelButtonPressed: () {
                      Navigator.pop(context, false);
                    },
                  )
                );

                if(confirmation){
                  context.loaderOverlay.show();
                  String result = await apiRegularDeleteMemorialFriendsOrFamily(memorialId: memorialId, userId: newValue.almFriendsList[i].showFriendsSettingsUser.showFriendsSettingsDetailsId, accountType: newValue.almFriendsList[i].showFriendsSettingsUser.showFriendsSettingsDetailsAccountType);
                  context.loaderOverlay.hide();

                  if(result != 'Success'){
                    await showDialog(
                      context: context,
                      builder: (_) => 
                        AssetGiffyDialog(
                        image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                        title: const Text('Error', textAlign: TextAlign.center, style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                        entryAnimation: EntryAnimation.DEFAULT,
                        description: Text('Error: $result.',
                          textAlign: TextAlign.center,
                        ),
                        onlyOkButton: true,
                        buttonOkColor: const Color(0xffff0000),
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
                        title: const Text('Success', textAlign: TextAlign.center, style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                        entryAnimation: EntryAnimation.DEFAULT,
                        description: const Text('Successfully removed the user from the list.',
                          textAlign: TextAlign.center,
                        ),
                        onlyOkButton: true,
                        onOkButtonPressed: () {
                          friends = [];
                          friendsItemsRemaining = 1;
                          page = 1; 
                          onLoading();

                          Navigator.pop(context, true);
                        },
                      )
                    );
                  }
                }

              },
              child: const Text('Remove', style: const TextStyle(fontSize: 14,),),
              height: 40,
              shape: const StadiumBorder(
                side: const BorderSide(color: const Color(0xffE74C3C)),
              ),
              color: const Color(0xffE74C3C),
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
        backgroundColor: const Color(0xff04ECFF),
        title: const Text('Page Friends', style: const TextStyle(fontSize: 16, color: const Color(0xffffffff)),),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, 
          color: const Color(0xffffffff),
        ), 
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        actions: [
          GestureDetector(
            onTap: (){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeRegularSearchUser(isFamily: false, memorialId: memorialId, memorialName: memorialName, switchFamily: switchFamily, switchFriends: switchFriends, switchFollowers: switchFollowers)));
            },
            child: const Center(child: const Text('Add Friends', style: const TextStyle(fontSize: 16, color: const Color(0xffffffff)),),),
          ),
        ],
      ),
      body: Container(
        width: SizeConfig.screenWidth,
        child: RefreshIndicator(
          onRefresh: onRefresh,
          child: ListView.separated(
            controller: scrollController,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
            physics: const ClampingScrollPhysics(),
            itemCount: friends.length,
            separatorBuilder: (c, i) => const Divider(height: 10, color: Colors.transparent),
            itemBuilder: (c, i) => friends[i],
          )
        ),
      ),
    );
  }
}