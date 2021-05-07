import 'package:facesbyplaces/API/Regular/09-Settings-Memorial/api-settings-memorial-regular-04-show-family-settings.dart';
import 'package:facesbyplaces/API/Regular/09-Settings-Memorial/api-settings-memorial-regular-13-remove-friends-or-family.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'home-settings-memorial-regular-07-search-user-settings.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:flutter/material.dart';

class RegularShowFamilySettings{
  final int userId;
  final String firstName;
  final String lastName;
  final String image;
  final String relationship;
  final int accountType;

  const RegularShowFamilySettings({required this.userId, required this.firstName, required this.lastName, required this.image, required this.relationship, required this.accountType});
}

class HomeRegularPageFamily extends StatefulWidget{
  final int memorialId;
  final String memorialName;
  final bool switchFamily;
  final bool switchFriends;
  final bool switchFollowers;

  const HomeRegularPageFamily({required this.memorialId, required this.memorialName, required this.switchFamily, required this.switchFriends, required this.switchFollowers,});

  HomeRegularPageFamilyState createState() => HomeRegularPageFamilyState(memorialId: memorialId, memorialName: memorialName, switchFamily: switchFamily, switchFriends: switchFriends, switchFollowers: switchFollowers);
}

class HomeRegularPageFamilyState extends State<HomeRegularPageFamily>{
  final int memorialId;
  final String memorialName;
  final bool switchFamily;
  final bool switchFriends;
  final bool switchFollowers;

  HomeRegularPageFamilyState({required this.memorialId, required this.memorialName, required this.switchFamily, required this.switchFriends, required this.switchFollowers,});

  ScrollController scrollController = ScrollController();
  int familyItemsRemaining = 1;
  List<Widget> family = [];
  int page = 1;

  void initState(){
    super.initState();
    onLoading();
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        if(familyItemsRemaining != 0){
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
    if(familyItemsRemaining != 0){
      context.loaderOverlay.show();
      var newValue = await apiRegularShowFamilySettings(memorialId: memorialId, page: page);
      context.loaderOverlay.hide();

      familyItemsRemaining = newValue.almItemsRemaining;

      for(int i = 0; i < newValue.almFamilyList.length; i++){
        family.add(
          ListTile(
            leading: newValue.almFamilyList[i].showFamilySettingsUser.showFamilySettingsDetailsImage != '' ? CircleAvatar(backgroundColor: const Color(0xff888888), backgroundImage: NetworkImage('${newValue.almFamilyList[i].showFamilySettingsUser.showFamilySettingsDetailsImage}')) : const CircleAvatar(backgroundColor: const Color(0xff888888), backgroundImage: const AssetImage('assets/icons/app-icon.png'),),
            title: Text('${newValue.almFamilyList[i].showFamilySettingsUser.showFamilySettingsDetailsFirstName} ${newValue.almFamilyList[i].showFamilySettingsUser.showFamilySettingsDetailsLastName}'),
            subtitle: Text('${newValue.almFamilyList[i].showFamilySettingsUser.showFamilySettingsDetailsEmail}'),
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
                  String result = await apiRegularDeleteMemorialFriendsOrFamily(memorialId: memorialId, userId: newValue.almFamilyList[i].showFamilySettingsUser.showFamilySettingsDetailsId, accountType: newValue.almFamilyList[i].showFamilySettingsUser.showFamilySettingsDetailsAccountType);
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
                          family = [];
                          familyItemsRemaining = 1;
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
                side: const BorderSide(
                  color: const Color(0xffE74C3C),
                ),
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
        backgroundColor: const Color(0xff04ECFF),
        title: const Text('Page Family', style: const TextStyle(fontSize: 16, color: const Color(0xffffffff)),),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: const Color(0xffffffff),), 
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        actions: [
          GestureDetector(
            onTap: (){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeRegularSearchUser(isFamily: true, memorialId: memorialId, memorialName: memorialName, switchFamily: switchFamily, switchFriends: switchFriends, switchFollowers: switchFollowers)));
            },
            child: const Center(child: const Text('Add Family', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xffffffff),),),),
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
            itemCount: family.length,
            separatorBuilder: (c, i) => const Divider(height: 10, color: Colors.transparent),
            itemBuilder: (c, i) => family[i],
          )
        ),
      ),
    );
  }
}