// ignore_for_file: file_names
import 'package:facesbyplaces/API/BLM/09-Settings-Memorial/api_settings_memorial_blm_03_show_admin_settings.dart';
import 'package:facesbyplaces/API/BLM/09-Settings-Memorial/api_settings_memorial_blm_09_add_admin.dart';
import 'package:facesbyplaces/API/BLM/09-Settings-Memorial/api_settings_memorial_blm_10_remove_admin.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:loader_overlay/loader_overlay.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:flutter/material.dart';

class BLMShowAdminSettings{
  final int userId;
  final String firstName;
  final String lastName;
  final String image;
  final String relationship;
  final String email;
  const BLMShowAdminSettings({required this.userId, required this.firstName, required this.lastName, required this.image, required this.relationship, required this.email});
}

class HomeBLMPageManagers extends StatefulWidget{
  final int memorialId;
  const HomeBLMPageManagers({Key? key, required this.memorialId}) : super(key: key);

  @override
  HomeBLMPageManagersState createState() => HomeBLMPageManagersState();
}

class HomeBLMPageManagersState extends State<HomeBLMPageManagers>{
  ScrollController scrollController = ScrollController();
  ValueNotifier<int> count = ValueNotifier<int>(0);
  List<Widget> managers = [];
  int adminItemsRemaining = 1;
  int familyItemsRemaining = 1;
  int page1 = 1;
  int page2 = 1;
  bool flag1 = false;

  @override
  void initState(){
    super.initState();
    addManagers1();
    onLoading();
    scrollController.addListener((){
      if(scrollController.position.pixels == scrollController.position.maxScrollExtent){
        if(adminItemsRemaining != 0 && familyItemsRemaining != 0){
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

  void onLoading() async{
    if(flag1 == false){
      onLoading1();
    }else{
      onLoading2();
    }
  }

  Future<void> onRefresh() async{
    if(adminItemsRemaining == 0 && flag1 == false){
      flag1 = true;
      onLoading1();
    }else{
      adminItemsRemaining = 1;
      familyItemsRemaining = 1;
      page1 = 1;
      page2 = 1;
      count.value = 0;
      flag1 = false;
      onLoading2();
    }
  }

  void addManagers1(){
    managers.add(const Padding(padding: EdgeInsets.only(left: 20.0,), child: Text('Admin', style: TextStyle(fontSize: 18, fontFamily: 'NexaRegular', color: Color(0xff9F9F9F),),),),);
  }

  void addManagers2(){
    managers.add(const Padding(padding: EdgeInsets.only(left: 20.0,), child: Text('Family', style: TextStyle(fontSize: 18, fontFamily: 'NexaRegular', color: Color(0xff9F9F9F),),),),);
  }

  void onLoading1() async{
    if(adminItemsRemaining != 0){
      context.loaderOverlay.show();
      var newValue = await apiBLMShowAdminSettings(memorialId: widget.memorialId, page: page1).onError((error, stackTrace){
        context.loaderOverlay.hide();
        showDialog(
          context: context,
          builder: (_) => AssetGiffyDialog(
            title: const Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontFamily: 'NexaRegular'),),
            description: Text('Error: $error.', textAlign: TextAlign.center, style: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular'),),
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

      adminItemsRemaining = newValue.blmAdminItemsRemaining;
      count.value = count.value + newValue.blmAdminList.length;

      for(int i = 0; i < newValue.blmAdminList.length; i++){
        managers.add(
          ListTile(
            leading: newValue.blmAdminList[i].showAdminsSettingsUser.showAdminsSettingsUserImage != ''
            ? CircleAvatar(
              maxRadius: 40,
              backgroundColor: const Color(0xff888888),
              foregroundImage: NetworkImage(newValue.blmAdminList[i].showAdminsSettingsUser.showAdminsSettingsUserImage),
            )
            : const CircleAvatar(
              maxRadius: 40,
              backgroundColor: Color(0xff888888),
              foregroundImage: AssetImage('assets/icons/user-placeholder.png'),
            ),
            title: Text('${newValue.blmAdminList[i].showAdminsSettingsUser.showAdminsSettingsUserFirstName} ${newValue.blmAdminList[i].showAdminsSettingsUser.showAdminsSettingsUserLastName}',
              style: const TextStyle(
                fontSize: 20,
                fontFamily: 'NexaBold',
                color: Color(0xff000000),
              ),
            ),
            subtitle: Text(newValue.blmAdminList[i].showAdminsSettingsUser.showAdminsSettingsUserEmail,
              style: const TextStyle(
                fontSize: 16,
                fontFamily: 'NexaRegular',
                color: Color(0xffBDC3C7),
              ),
            ),
            trailing: MaterialButton(
              child: const Text('Remove', style: TextStyle(fontSize: 20, fontFamily: 'HelveticaRegular', color: Color(0xffffffff),),),
              shape: const StadiumBorder(side: BorderSide(color: Color(0xffE74C3C),),),
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
                    title: const Text('Confirm', textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontFamily: 'NexaRegular',),),
                    description: const Text('Are you sure you want to remove this user?', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular'),),
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
                  String result = await apiBLMDeleteMemorialAdmin(pageType: 'Blm', pageId: widget.memorialId, userId: newValue.blmAdminList[i].showAdminsSettingsUser.showAdminsSettingsUserId);
                  context.loaderOverlay.hide();

                  if(result != 'Success'){
                    await showDialog(
                      context: context,
                      builder: (_) => AssetGiffyDialog(
                        description: Text('Error: $result.', textAlign: TextAlign.center, style: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular'),),
                        title: const Text('Error',textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontFamily: 'NexaRegular'),),
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
                        description: const Text('Successfully removed the user from the list.', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular'),),
                        title: const Text('Success', textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontFamily: 'NexaRegular',),),
                        image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                        entryAnimation: EntryAnimation.DEFAULT,
                        onlyOkButton: true,
                        onOkButtonPressed: (){
                          managers = [];
                          adminItemsRemaining = 1;
                          familyItemsRemaining = 1;
                          page1 = 1;
                          page2 = 1;
                          flag1 = false;
                          addManagers1();
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
      page1++;
    }

    if(adminItemsRemaining == 0){
      addManagers2();
      flag1 = true;
      onLoading();
    }
  }

  void onLoading2() async{
    if(familyItemsRemaining != 0){
      context.loaderOverlay.show();
      var newValue = await apiBLMShowAdminSettings(memorialId: widget.memorialId, page: page2);
      context.loaderOverlay.hide();

      familyItemsRemaining = newValue.blmFamilyItemsRemaining;
      count.value = count.value + newValue.blmFamilyList.length;

      for(int i = 0; i < newValue.blmFamilyList.length; i++){
        managers.add(
          ListTile(
            leading: newValue.blmFamilyList[i].showAdminsSettingsUser.showAdminsSettingsUserImage != ''
            ? CircleAvatar(
              maxRadius: 40,
              backgroundColor: const Color(0xff888888),
              foregroundImage: NetworkImage(newValue.blmFamilyList[i].showAdminsSettingsUser.showAdminsSettingsUserImage),
            )
            : const CircleAvatar(
              maxRadius: 40,
              backgroundColor: Color(0xff888888),
              foregroundImage: AssetImage('assets/icons/user-placeholder.png'),
            ),
            title: Text('${newValue.blmFamilyList[i].showAdminsSettingsUser.showAdminsSettingsUserFirstName} ${newValue.blmFamilyList[i].showAdminsSettingsUser.showAdminsSettingsUserLastName}',
              style: const TextStyle(
                fontSize: 20,
                fontFamily: 'NexaRegular',
                color: Color(0xffBDC3C7),
              ),
            ),
            subtitle: Text(newValue.blmFamilyList[i].showAdminsSettingsUser.showAdminsSettingsUserEmail,
              style: const TextStyle(
                fontSize: 16,
                fontFamily: 'NexaRegular',
                color: Color(0xffBDC3C7),
              ),
            ),
            trailing: MaterialButton(
              child: const Text('Make Manager', style: TextStyle(fontSize: 16, fontFamily: 'NexaRegular'),),
              shape: const StadiumBorder(side: BorderSide(color: Color(0xff04ECFF),),),
              minWidth: SizeConfig.screenWidth! / 3.5,
              splashColor: const Color(0xff04ECFF),
              textColor: const Color(0xffffffff),
              color: const Color(0xff04ECFF),
              padding: EdgeInsets.zero,
              height: 40,
              onPressed: () async{
                bool confirmation = await showDialog(
                  context: context,
                  builder: (_) => AssetGiffyDialog(
                    title: const Text('Confirm', textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontFamily: 'NexaRegular'),),
                    description: const Text('Are you sure you want to make this user a manager?', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular'),),
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
                  String result = await apiBLMAddMemorialAdmin(pageType: 'Blm', pageId: widget.memorialId, userId: newValue.blmFamilyList[i].showAdminsSettingsUser.showAdminsSettingsUserId);
                  context.loaderOverlay.hide();

                  if(result != 'Success'){
                    await showDialog(
                      context: context,
                      builder: (_) => AssetGiffyDialog(
                        title: const Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontFamily: 'NexaRegular'),),
                        description: Text('Error: $result.', textAlign: TextAlign.center, style: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular'),),
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
                        description: const Text('Successfully added as an admin.', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular'),),
                        title: const Text('Success', textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontFamily: 'NexaRegular'),),
                        image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                        entryAnimation: EntryAnimation.DEFAULT,
                        onlyOkButton: true,
                        onOkButtonPressed: (){
                          managers = [];
                          adminItemsRemaining = 1;
                          familyItemsRemaining = 1;
                          page1 = 1;
                          page2 = 1;
                          flag1 = false;
                          addManagers1();
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

    if(mounted) {
      page2++;
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
          title: const Text('Page Managers', style: TextStyle(fontSize: 26, fontFamily: 'NexaRegular', color: Color(0xffffffff),),),
          centerTitle: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back,size: 35,),
            onPressed: (){
              Navigator.pop(context);
            },
          ),
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
              itemBuilder: (c, i) => managers[i],
              itemCount: managers.length,
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

                const Text('Managers list is empty', style: TextStyle(fontSize: 36, fontFamily: 'NexaBold', color: Color(0xffB1B1B1),),),

                SizedBox(height: (SizeConfig.screenHeight! - 85 - kToolbarHeight) / 3.5,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}