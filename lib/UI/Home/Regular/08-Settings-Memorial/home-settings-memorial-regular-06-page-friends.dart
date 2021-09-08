import 'package:facesbyplaces/API/Regular/09-Settings-Memorial/api-settings-memorial-regular-05-show-friends-settings.dart';
import 'package:facesbyplaces/API/Regular/09-Settings-Memorial/api-settings-memorial-regular-13-remove-friends-or-family.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'home-settings-memorial-regular-07-search-user-settings.dart';
import 'package:loader_overlay/loader_overlay.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:flutter/material.dart';

class HomeRegularPageFriends extends StatefulWidget{
  final int memorialId;
  final String memorialName;
  final bool switchFamily;
  final bool switchFriends;
  final bool switchFollowers;
  const HomeRegularPageFriends({required this.memorialId, required this.memorialName, required this.switchFamily, required this.switchFriends, required this.switchFollowers});

  HomeRegularPageFriendsState createState() => HomeRegularPageFriendsState();
}

class HomeRegularPageFriendsState extends State<HomeRegularPageFriends>{
  ScrollController scrollController = ScrollController();
  ValueNotifier<int> count = ValueNotifier<int>(0);
  int friendsItemsRemaining = 1;
  List<Widget> friends = [];
  int page = 1;

  void initState() {
    super.initState();
    onLoading();
    scrollController.addListener((){
      if(scrollController.position.pixels == scrollController.position.maxScrollExtent){
        if(friendsItemsRemaining != 0){
          onLoading();
        }else{
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: const Text('No more users to show'), duration: const Duration(seconds: 1), backgroundColor: const Color(0xff4EC9D4),),);
        }
      }
    });
  }

  Future<void> onRefresh() async{
    count.value = 0;
    friendsItemsRemaining = 1;
    friends = [];
    page = 1;
    onLoading();
  }

  void onLoading() async{
    if(friendsItemsRemaining != 0){
      context.loaderOverlay.show();
      var newValue = await apiRegularShowFriendsSettings(memorialId: widget.memorialId, page: page).onError((error, stackTrace){
        context.loaderOverlay.hide();
        showDialog(
          context: context,
          builder: (_) => AssetGiffyDialog(
            description: Text('Error: $error.', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular'),),
            title: Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontFamily: 'NexaRegular'),),
            image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
            entryAnimation: EntryAnimation.DEFAULT,
            buttonOkColor: const Color(0xffff0000),
            onlyOkButton: true,
            onOkButtonPressed: (){
              Navigator.pop(context, true);
              Navigator.pop(context, true);
            },
          ),
        );
        throw Exception('$error');
      });
      context.loaderOverlay.hide();

      friendsItemsRemaining = newValue.almItemsRemaining;
      count.value = count.value + newValue.almFriendsList.length;

      for(int i = 0; i < newValue.almFriendsList.length; i++){
        friends.add(
          ListTile(
            leading: newValue.almFriendsList[i].showFriendsSettingsUser.showFriendsSettingsDetailsImage != ''
            ? CircleAvatar(
              maxRadius: 40,
              backgroundColor: Color(0xff888888),
              foregroundImage: NetworkImage('${newValue.almFriendsList[i].showFriendsSettingsUser.showFriendsSettingsDetailsImage}',),
            )
            : const CircleAvatar(
              maxRadius: 40,
              backgroundColor: const Color(0xff888888),
              foregroundImage: const AssetImage('assets/icons/user-placeholder.png',),
            ),
            title: Text('${newValue.almFriendsList[i].showFriendsSettingsUser.showFriendsSettingsDetailsFirstName} ${newValue.almFriendsList[i].showFriendsSettingsUser.showFriendsSettingsDetailsLastName}',
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'NexaBold',
                color: const Color(0xff000000),
              ),
            ),
            subtitle: Text('${newValue.almFriendsList[i].showFriendsSettingsUser.showFriendsSettingsDetailsEmail}',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'NexaRegular',
                color: const Color(0xffBDC3C7),
              ),
            ),
            trailing: MaterialButton(
              child: Text('Remove', style: TextStyle(fontSize: 20, fontFamily: 'HelveticaRegular', color: const Color(0xffffffff),),),
              shape: const StadiumBorder(side: const BorderSide(color: const Color(0xffE74C3C)),),
              minWidth: SizeConfig.screenWidth! / 3.5,
              splashColor: const Color(0xff04ECFF),
              textColor: const Color(0xffffffff),
              color: const Color(0xffE74C3C),
              padding: EdgeInsets.zero,
              height: 40,
              onPressed: () async{
                bool confirmation = await showDialog(
                  context: context,
                  builder: (_) => AssetGiffyDialog(
                    description: Text('Are you sure you want to remove this user?', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular',),),
                    title: Text('Confirm', textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontFamily: 'NexaRegular',),),
                    image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                    entryAnimation: EntryAnimation.DEFAULT,
                    onlyOkButton: false,
                    onOkButtonPressed: () async{
                      Navigator.pop(context, true);
                    },
                    onCancelButtonPressed: (){
                      Navigator.pop(context, false);
                    },
                  ),
                );

                if(confirmation){
                  context.loaderOverlay.show();
                  String result = await apiRegularDeleteMemorialFriendsOrFamily(memorialId: widget.memorialId, userId: newValue.almFriendsList[i].showFriendsSettingsUser.showFriendsSettingsDetailsId, accountType: newValue.almFriendsList[i].showFriendsSettingsUser.showFriendsSettingsDetailsAccountType);
                  context.loaderOverlay.hide();

                  if(result != 'Success'){
                    await showDialog(
                      context: context,
                      builder: (_) => AssetGiffyDialog(
                        description: Text('Error: $result.', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular',),),
                        title: Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontFamily: 'NexaRegular',),),
                        image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                        entryAnimation: EntryAnimation.DEFAULT,
                        buttonOkColor: const Color(0xffff0000),
                        onlyOkButton: true,
                        onOkButtonPressed: (){
                          Navigator.pop(context, true);
                        },
                      ),
                    );
                  }else{
                    await showDialog(
                      context: context,
                      builder: (_) => AssetGiffyDialog(
                        description: Text('Successfully removed the user from the list.', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular',),),
                        title: Text('Success', textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontFamily: 'NexaRegular'),),
                        image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                        entryAnimation: EntryAnimation.DEFAULT,
                        onlyOkButton: true,
                        onOkButtonPressed: (){
                          friends = [];
                          friendsItemsRemaining = 1;
                          page = 1;
                          count.value = 0;
                          onLoading();

                          Navigator.pop(context, true);
                        },
                      ),
                    );
                  }
                }
              },
            ),
          ),
        );
      }
    }

    if(mounted)
    page++;
  }

  @override
  Widget build(BuildContext context){
    SizeConfig.init(context);
    return ValueListenableBuilder(
      valueListenable: count,
      builder: (_, int countListener, __) => Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff04ECFF),
          title: Text('Friends', style: TextStyle(fontSize: 26, fontFamily: 'NexaRegular', color: const Color(0xffffffff),),),
          centerTitle: false,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: const Color(0xffffffff), size: 35,),
            onPressed: (){
              Navigator.pop(context);
            },
          ),
          actions: [
            GestureDetector(
              child: Center(child: Text('Add Friends', style: TextStyle(fontSize: 26, fontFamily: 'NexaRegular', color: const Color(0xffffffff),),),),
              onTap: (){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeRegularSearchUser(isFamily: false, memorialId: widget.memorialId, memorialName: widget.memorialName, switchFamily: widget.switchFamily, switchFriends: widget.switchFriends, switchFollowers: widget.switchFollowers)));
              },
            ),
          ],
        ),
        body: Container(
          width: SizeConfig.screenWidth,
          child: countListener != 0
          ? RefreshIndicator(
            onRefresh: onRefresh,
            child: ListView.separated(
              controller: scrollController,
              separatorBuilder: (c, i) => const Divider(height: 10, color: Colors.transparent),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
              physics: const ClampingScrollPhysics(),
              itemBuilder: (c, i) => friends[i],
              itemCount: friends.length,
            ),
          )
          : SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: (SizeConfig.screenHeight! - 85 - kToolbarHeight) / 3.5,),

                Image.asset('assets/icons/app-icon.png', height: 250, width: 250,),

                const SizedBox(height: 45,),

                Text('Friends list is empty', style: TextStyle(fontSize: 36, fontFamily: 'NexaBold', color: const Color(0xffB1B1B1),),),

                SizedBox(height: (SizeConfig.screenHeight! - 85 - kToolbarHeight) / 3.5,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}