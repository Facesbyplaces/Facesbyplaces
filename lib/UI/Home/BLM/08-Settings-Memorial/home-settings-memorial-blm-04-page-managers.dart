import 'package:facesbyplaces/API/BLM/09-Settings-Memorial/api-settings-memorial-blm-03-show-admin-settings.dart';
import 'package:facesbyplaces/API/BLM/09-Settings-Memorial/api-settings-memorial-blm-09-add-admin.dart';
import 'package:facesbyplaces/API/BLM/09-Settings-Memorial/api-settings-memorial-blm-10-remove-admin.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:loader_overlay/loader_overlay.dart';
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
  const HomeBLMPageManagers({required this.memorialId});

  HomeBLMPageManagersState createState() => HomeBLMPageManagersState(memorialId: memorialId);
}

class HomeBLMPageManagersState extends State<HomeBLMPageManagers>{
  final int memorialId;
  HomeBLMPageManagersState({required this.memorialId});

  ScrollController scrollController = ScrollController();
  List<Widget> managers = [];
  int adminItemsRemaining = 1;
  int familyItemsRemaining = 1;
  int page1 = 1;
  int page2 = 1;
  bool flag1 = false;

  void initState(){
    super.initState();
    addManagers1();
    onLoading();
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        if(adminItemsRemaining != 0 && familyItemsRemaining != 0){
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

  void onLoading() async{
    if(flag1 == false){
      onLoading1();
    }else{
      onLoading2();
    }
  }

  Future<void> onRefresh() async{
    if(adminItemsRemaining == 0 && flag1 == false){
      setState(() {
        flag1 = true;
      });
      onLoading1();
    }else{
      onLoading2();
    }
  }

  void addManagers1(){
    managers.add(
      const Padding(padding: const EdgeInsets.only(left: 20.0,), child: const Text('Admin', style: const TextStyle(fontSize: 14, color: const Color(0xff888888)),),),
    );
  }

  void addManagers2(){
    managers.add(
      const Padding(padding: const EdgeInsets.only(left: 20.0,), child: const Text('Family', style: const TextStyle(fontSize: 14, color: const Color(0xff888888)),),),
    );
  }

  void onLoading1() async{
    if(adminItemsRemaining != 0){
      context.loaderOverlay.show();
      var newValue = await apiBLMShowAdminSettings(memorialId: memorialId, page: page1);
      context.loaderOverlay.hide();

      adminItemsRemaining = newValue.blmAdminItemsRemaining;

      for(int i = 0; i < newValue.blmAdminList.length; i++){
        managers.add(
          ListTile(
            leading: CircleAvatar(
              backgroundColor: const Color(0xff888888), 
              foregroundImage: NetworkImage('${newValue.blmAdminList[i].showAdminsSettingsUser.showAdminsSettingsUserImage}',),
              backgroundImage: const AssetImage('assets/icons/app-icon.png'),
            ),
            title: Text('${newValue.blmAdminList[i].showAdminsSettingsUser.showAdminsSettingsUserFirstName} ${newValue.blmAdminList[i].showAdminsSettingsUser.showAdminsSettingsUserLastName}'),
            subtitle: Text('${newValue.blmAdminList[i].showAdminsSettingsUser.showAdminsSettingsUserEmail}'),
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
                  String result = await apiBLMDeleteMemorialAdmin(pageType: 'Blm', pageId: memorialId, userId: newValue.blmAdminList[i].showAdminsSettingsUser.showAdminsSettingsUserId);
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
    }

    if(mounted)
    setState(() {});
    page1++;

    if(adminItemsRemaining == 0){
      addManagers2();
      flag1 = true;
      onLoading();
    }
  }

  void onLoading2() async{
    
    if(familyItemsRemaining != 0){
      context.loaderOverlay.show();
      var newValue = await apiBLMShowAdminSettings(memorialId: memorialId, page: page2);
      context.loaderOverlay.hide();

      familyItemsRemaining = newValue.blmFamilyItemsRemaining;

      for(int i = 0; i < newValue.blmFamilyList.length; i++){
        managers.add(
          ListTile(
            leading: CircleAvatar(
              backgroundColor: const Color(0xff888888), 
              foregroundImage: NetworkImage('${newValue.blmFamilyList[i].showAdminsSettingsUser.showAdminsSettingsUserImage}',),
              backgroundImage: const AssetImage('assets/icons/app-icon.png'),
            ),
            title: Text('${newValue.blmFamilyList[i].showAdminsSettingsUser.showAdminsSettingsUserFirstName} ${newValue.blmFamilyList[i].showAdminsSettingsUser.showAdminsSettingsUserLastName}'),
            subtitle: Text('${newValue.blmFamilyList[i].showAdminsSettingsUser.showAdminsSettingsUserEmail}'),
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
                    description: const Text('Are you sure you want to make this user a manager?',
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
                  String result = await apiBLMAddMemorialAdmin(pageType: 'Blm', pageId: memorialId, userId: newValue.blmFamilyList[i].showAdminsSettingsUser.showAdminsSettingsUserId);
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
                        description: const Text('Successfully added the user from the list.',
                          textAlign: TextAlign.center,
                        ),
                        onlyOkButton: true,
                        onOkButtonPressed: () {
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
                      )
                    );
                  }
                }
              },
              child: const Text('Make Manager', style: const TextStyle(fontSize: 14,),),
              height: 40,
              shape: const StadiumBorder(
                side: const BorderSide(color: const Color(0xff04ECFF)),
              ),
              color: const Color(0xff04ECFF),
            ),
          ),
        );
      }

      if(mounted)
      setState(() {});
      page2++; 
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff04ECFF),
        title: const Text('Memorial Settings', style: TextStyle(fontSize: 16, color: const Color(0xffffffff),),),
        centerTitle: true,
          leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        width: SizeConfig.screenWidth,
        child: RefreshIndicator(
          onRefresh: onRefresh,
          child: ListView.separated(
            controller: scrollController,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
            physics: const ClampingScrollPhysics(),
            itemCount: managers.length,
            separatorBuilder: (c, i) => const Divider(height: 10, color: Colors.transparent),
            itemBuilder: (c, i) => managers[i],
          )
        ),
      ),
    );
  }
}