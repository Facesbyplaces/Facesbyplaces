// ignore_for_file: file_names
import 'package:facesbyplaces/API/BLM/09-Settings-Memorial/api_settings_memorial_blm_04_show_family_settings.dart';
import 'package:facesbyplaces/API/BLM/09-Settings-Memorial/api_settings_memorial_blm_13_remove_friends_or_family.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'home-settings-memorial-blm-07-search-user-settings.dart';
import 'package:loader_overlay/loader_overlay.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:flutter/material.dart';

class HomeBLMPageFamily extends StatefulWidget{
  final int memorialId;
  final String memorialName;
  final bool switchFamily;
  final bool switchFriends;
  final bool switchFollowers;
  const HomeBLMPageFamily({Key? key, required this.memorialId, required this.memorialName, required this.switchFamily, required this.switchFriends, required this.switchFollowers,}) : super(key: key);

  @override
  HomeBLMPageFamilyState createState() => HomeBLMPageFamilyState();
}

class HomeBLMPageFamilyState extends State<HomeBLMPageFamily>{
  ScrollController scrollController = ScrollController();
  ValueNotifier<int> count = ValueNotifier<int>(0);
  int familyItemsRemaining = 1;
  List<Widget> family = [];
  int page = 1;

  @override
  void initState(){
    super.initState();
    onLoading();
    scrollController.addListener((){
      if(scrollController.position.pixels == scrollController.position.maxScrollExtent){
        if(familyItemsRemaining != 0){
          onLoading();
        }else{
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
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
    count.value = 0;
    familyItemsRemaining = 1;
    family = [];
    page = 1;
    onLoading();
  }

  void onLoading() async{
    if(familyItemsRemaining != 0){
      context.loaderOverlay.show();
      var newValue = await apiBLMShowFamilySettings(memorialId: widget.memorialId, page: page).onError((error, stackTrace){
        context.loaderOverlay.hide();
        showDialog(
          context: context,
          builder: (_) => AssetGiffyDialog(
            description: Text('Error: $error.', textAlign: TextAlign.center, style: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular'),),
            title: const Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontFamily: 'NexaRegular'),),
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

      familyItemsRemaining = newValue.blmItemsRemaining;
      count.value = count.value + newValue.blmFamilyList.length;

      for(int i = 0; i < newValue.blmFamilyList.length; i++){
        family.add(
          ListTile(
            leading: newValue.blmFamilyList[i].showFamilySettingsUser.showFamilySettingsDetailsImage != ''
            ? CircleAvatar(
              backgroundColor: const Color(0xff888888),
              foregroundImage: NetworkImage(newValue.blmFamilyList[i].showFamilySettingsUser.showFamilySettingsDetailsImage),
            )
            : const CircleAvatar(
              backgroundColor: Color(0xff888888),
              foregroundImage: AssetImage('assets/icons/user-placeholder.png',),
            ),
            title: Text('${newValue.blmFamilyList[i].showFamilySettingsUser.showFamilySettingsDetailsFirstName} ${newValue.blmFamilyList[i].showFamilySettingsUser.showFamilySettingsDetailsLastName}',
              style: const TextStyle(
                fontSize: 20,
                fontFamily: 'NexaBold',
                color: Color(0xff000000),
              ),
            ),
            subtitle: Text(newValue.blmFamilyList[i].showFamilySettingsRelationship,
              style: const TextStyle(
                fontSize: 16,
                fontFamily: 'NexaRegular',
                color: Color(0xffBDC3C7),
              ),
            ),
            trailing: MaterialButton(
              minWidth: SizeConfig.screenWidth! / 3.5,
              padding: EdgeInsets.zero,
              textColor: const Color(0xffffffff),
              splashColor: const Color(0xff04ECFF),
              child: const Text('Remove', style: TextStyle(fontSize: 20, fontFamily: 'HelveticaRegular', color: Color(0xffffffff),),),
              height: 40,
              shape: const StadiumBorder(side: BorderSide(color: Color(0xffE74C3C),),),
              color: const Color(0xffE74C3C),
              onPressed: () async{
                bool confirmation = await showDialog(
                  context: context,
                  builder: (_) => AssetGiffyDialog(
                    description: const Text('Are you sure you want to remove this user?', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular',),),
                    title: const Text('Confirm', textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontFamily: 'NexaRegular'),),
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
                  String result = await apiBLMDeleteMemorialFriendsOrFamily(memorialId: widget.memorialId, userId: newValue.blmFamilyList[i].showFamilySettingsUser.showFamilySettingsDetailsId, accountType: newValue.blmFamilyList[i].showFamilySettingsUser.showFamilySettingsDetailsAccountType);
                  context.loaderOverlay.hide();

                  if(result != 'Success'){
                    await showDialog(
                      context: context,
                      builder: (_) => AssetGiffyDialog(
                        description: Text('Error: $result.', textAlign: TextAlign.center, style: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular',),),
                        title: const Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontFamily: 'NexaRegular'),),
                        image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                        buttonOkColor: const Color(0xffff0000),
                        entryAnimation: EntryAnimation.DEFAULT,
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
                        description: const Text('Successfully removed the user from the list.', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular'),),
                        title: const Text('Success', textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontFamily: 'NexaRegular'),),
                        image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                        entryAnimation: EntryAnimation.DEFAULT,
                        onlyOkButton: true,
                        onOkButtonPressed: (){
                          family = [];
                          familyItemsRemaining = 1;
                          page = 1;
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
          title: const Text('Family', style: TextStyle(fontSize: 26, fontFamily: 'NexaRegular', color: Color(0xffffffff),),),
          centerTitle: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xffffffff), size: 35,),
            onPressed: (){
              Navigator.pop(context);
            },
          ),
          actions: [
            GestureDetector(
              child: const Center(child: Text('Add Family', style: TextStyle(fontSize: 26, fontFamily: 'NexaRegular', color: Color(0xffffffff),),),),
              onTap: (){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeBLMSearchUser(isFamily: true, memorialId: widget.memorialId, memorialName: widget.memorialName, switchFamily: widget.switchFamily, switchFriends: widget.switchFriends, switchFollowers: widget.switchFollowers)));
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
              itemBuilder: (c, i) => family[i],
              itemCount: family.length,
            ),
          )
          : SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: (SizeConfig.screenHeight! - 85 - kToolbarHeight) / 3.5,),

                Image.asset('assets/icons/app-icon.png', height: 250, width: 250,),

                const SizedBox(height: 45,),

                const Text('Family list is empty', style: TextStyle(fontSize: 36, fontFamily: 'NexaBold', color: Color(0xffB1B1B1),),),

                SizedBox(height: (SizeConfig.screenHeight! - 85 - kToolbarHeight) / 3.5,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}