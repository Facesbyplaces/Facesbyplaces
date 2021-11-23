import 'package:facesbyplaces/API/Regular/09-Settings-Memorial/api_settings_memorial_regular_05_show_friends_settings.dart';
import 'package:facesbyplaces/API/Regular/09-Settings-Memorial/api_settings_memorial_regular_13_remove_friends_or_family.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'home_settings_memorial_regular_07_search_user_settings.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter/material.dart';
import 'package:dialog/dialog.dart';

class HomeRegularPageFriends extends StatefulWidget{
  final int memorialId;
  final String memorialName;
  final bool switchFamily;
  final bool switchFriends;
  final bool switchFollowers;
  const HomeRegularPageFriends({Key? key, required this.memorialId, required this.memorialName, required this.switchFamily, required this.switchFriends, required this.switchFollowers}) : super(key: key);

  @override
  HomeRegularPageFriendsState createState() => HomeRegularPageFriendsState();
}

class HomeRegularPageFriendsState extends State<HomeRegularPageFriends>{
  ScrollController scrollController = ScrollController();
  ValueNotifier<int> count = ValueNotifier<int>(0);
  int friendsItemsRemaining = 1;
  List<Widget> friends = [];
  int page = 1;

  @override
  void initState(){
    super.initState();
    onLoading();
    scrollController.addListener((){
      if(scrollController.position.pixels == scrollController.position.maxScrollExtent){
        if(friendsItemsRemaining != 0){
          onLoading();
        }else{
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No more users to show'), duration: Duration(seconds: 1), backgroundColor: Color(0xff4EC9D4),),);
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
          builder: (context) => CustomDialog(
            image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
            title: 'Error',
            description: 'Error: $error.',
            okButtonColor: const Color(0xfff44336), // RED
            includeOkButton: true,
            okButton: (){
              Navigator.pop(context, true);
              Navigator.pop(context, true);
            }
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
              backgroundColor: const Color(0xff888888),
              foregroundImage: NetworkImage(newValue.almFriendsList[i].showFriendsSettingsUser.showFriendsSettingsDetailsImage,),
            )
            : const CircleAvatar(
              maxRadius: 40,
              backgroundColor: Color(0xff888888),
              foregroundImage: AssetImage('assets/icons/user-placeholder.png',),
            ),
            title: Text('${newValue.almFriendsList[i].showFriendsSettingsUser.showFriendsSettingsDetailsFirstName} ${newValue.almFriendsList[i].showFriendsSettingsUser.showFriendsSettingsDetailsLastName}', style: const TextStyle(fontSize: 20, fontFamily: 'NexaBold', color: Color(0xff000000),),),
            subtitle: Text(newValue.almFriendsList[i].showFriendsSettingsUser.showFriendsSettingsDetailsEmail, style: const TextStyle(fontSize: 16, fontFamily: 'NexaRegular', color: Color(0xffBDC3C7),),),
            trailing: MaterialButton(
              child: const Text('Remove', style: TextStyle(fontSize: 20, fontFamily: 'HelveticaRegular', color: Color(0xffffffff),),),
              shape: const StadiumBorder(side: BorderSide(color: Color(0xffE74C3C)),),
              minWidth: SizeConfig.screenWidth! / 3.5,
              splashColor: const Color(0xff04ECFF),
              textColor: const Color(0xffffffff),
              color: const Color(0xffE74C3C),
              padding: EdgeInsets.zero,
              height: 40,
              onPressed: () async{
                bool confirmation = await showDialog(
                  context: context,
                  builder: (context) => CustomDialog(
                    image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                    title: 'Confirm',
                    description: 'Are you sure you want to remove this user?',
                    includeOkButton: true,
                    includeCancelButton: true,
                  ),
                );

                if(confirmation){
                  context.loaderOverlay.show();
                  String result = await apiRegularDeleteMemorialFriendsOrFamily(memorialId: widget.memorialId, userId: newValue.almFriendsList[i].showFriendsSettingsUser.showFriendsSettingsDetailsId, accountType: newValue.almFriendsList[i].showFriendsSettingsUser.showFriendsSettingsDetailsAccountType);
                  context.loaderOverlay.hide();

                  if(result != 'Success'){
                    await showDialog(
                      context: context,
                      builder: (context) => CustomDialog(
                        image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                        title: 'Error',
                        description: 'Error: $result.',
                        okButtonColor: const Color(0xfff44336), // RED
                        includeOkButton: true,
                      ),
                    );
                  }else{
                    await showDialog(
                      context: context,
                      builder: (context) => CustomDialog(
                        image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                        title: 'Success',
                        description: 'Successfully removed the user from the list.',
                        okButtonColor: const Color(0xff4caf50), // GREEN
                        includeOkButton: true,
                        okButton: (){
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

    if(mounted){
      page++;
    }
  }

  @override
  Widget build(BuildContext context){
    SizeConfig.init(context);
    return ValueListenableBuilder(
      valueListenable: count,
      builder: (_, int countListener, __) => Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff04ECFF),
          title: const Text('Friends', style: TextStyle(fontSize: 26, fontFamily: 'NexaRegular', color: Color(0xffffffff),),),
          centerTitle: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xffffffff), size: 35,),
            onPressed: (){
              Navigator.pop(context);
            },
          ),
          actions: [
            GestureDetector(
              child: const Center(child: Text('Add Friends', style: TextStyle(fontSize: 26, fontFamily: 'NexaRegular', color: Color(0xffffffff),),),),
              onTap: (){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeRegularSearchUser(isFamily: false, memorialId: widget.memorialId, memorialName: widget.memorialName, switchFamily: widget.switchFamily, switchFriends: widget.switchFriends, switchFollowers: widget.switchFollowers)));
              },
            ),
          ],
        ),
        body: SizedBox(
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

                Image.asset('assets/icons/app-icon.png', height: 200, width: 200,),

                const SizedBox(height: 45,),

                const Text('Friends list is empty', style: TextStyle(fontSize: 36, fontFamily: 'NexaBold', color: Color(0xffB1B1B1),),),

                SizedBox(height: (SizeConfig.screenHeight! - 85 - kToolbarHeight) / 3.5,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}