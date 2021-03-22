import 'package:facesbyplaces/API/BLM/09-Settings-Memorial/api-settings-memorial-blm-03-show-admin-settings.dart';
import 'package:facesbyplaces/API/BLM/09-Settings-Memorial/api-settings-memorial-blm-09-add-admin.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter/material.dart';

class BLMShowAdminSettings{
  final int userId;
  final String firstName;
  final String lastName;
  final String image;
  final String relationship;
  final String email;

  BLMShowAdminSettings({required this.userId, required this.firstName, required this.lastName, required this.image, required this.relationship, required this.email});
}

class HomeBLMPageManagers extends StatefulWidget{
  final int memorialId;
  HomeBLMPageManagers({required this.memorialId});

  HomeBLMPageManagersState createState() => HomeBLMPageManagersState(memorialId: memorialId);
}

class HomeBLMPageManagersState extends State<HomeBLMPageManagers>{
  final int memorialId;
  HomeBLMPageManagersState({required this.memorialId});

  ScrollController scrollController = ScrollController();
  List<Widget> managers = [];
  List<BLMShowAdminSettings> adminList = [];
  List<BLMShowAdminSettings> familyList = [];
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

  void onLoading() async{
    if(flag1 == false){
      onLoading1();
    }else{
      onLoading2();
    }
  }


  Future<void> onRefresh() async{
    if(adminItemsRemaining == 0 && flag1 == false){
      addManagers2();
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
      Padding(padding: EdgeInsets.only(left: 20.0,), child: Text('Admin', style: TextStyle(fontSize: 14, color: Color(0xff888888)),),),
    );
  }

  void addManagers2(){
    managers.add(
      Padding(padding: EdgeInsets.only(left: 20.0,), child: Text('Family', style: TextStyle(fontSize: 14, color: Color(0xff888888)),),),
    );
  }

  void onLoading1() async{
    if(adminItemsRemaining != 0){
      context.showLoaderOverlay();
      var newValue = await apiBLMShowAdminSettings(memorialId: memorialId, page: page1);
      context.hideLoaderOverlay();

      adminItemsRemaining = newValue.blmAdminItemsRemaining;

      for(int i = 0; i < newValue.blmAdminList.length; i++){
        managers.add(
          ListTile(
            leading: CircleAvatar(backgroundColor: Color(0xff888888), backgroundImage: NetworkImage('${newValue.blmAdminList[i].showAdminsSettingsUser.showAdminsSettingsUserImage}'),),
            title: Text('${newValue.blmAdminList[i].showAdminsSettingsUser.showAdminsSettingsUserFirstName} ${newValue.blmAdminList[i].showAdminsSettingsUser.showAdminsSettingsUserLastName}'),
            subtitle: Text('${newValue.blmAdminList[i].showAdminsSettingsUser.showAdminsSettingsUserEmail}'),
            trailing: MaterialButton(
              minWidth: SizeConfig.screenWidth! / 3.5,
              padding: EdgeInsets.zero,
              textColor: Color(0xffffffff),
              splashColor: Color(0xff04ECFF),
              onPressed: () async{
                context.showLoaderOverlay();
                await apiBLMAddMemorialAdmin(pageType: 'Blm', pageId: memorialId, userId: familyList[i].userId);
                context.hideLoaderOverlay();

                adminList = [];
                familyList = [];
                adminItemsRemaining = 1;
                familyItemsRemaining = 1;
                page1 = 1;
                page2 = 1;
                onLoading1();
                onLoading2();
              },
              child: Text('Make Manager', style: TextStyle(fontSize: 14,),),
              height: 40,
              shape: StadiumBorder(
                side: BorderSide(color: Color(0xff04ECFF)),
              ),
                color: Color(0xff04ECFF),
            ),
          ),
        );
      }

      if(mounted)
      setState(() {});
      page1++;
    }
  }

  void onLoading2() async{
    
    if(familyItemsRemaining != 0){
      context.showLoaderOverlay();
      var newValue = await apiBLMShowAdminSettings(memorialId: memorialId, page: page2);
      context.hideLoaderOverlay();

      familyItemsRemaining = newValue.blmFamilyItemsRemaining;

      for(int i = 0; i < newValue.blmFamilyList.length; i++){
        managers.add(
          ListTile(
            leading: CircleAvatar(backgroundColor: Color(0xff888888), backgroundImage: NetworkImage('${newValue.blmFamilyList[i].showAdminsSettingsUser.showAdminsSettingsUserImage}'),),
            title: Text('${newValue.blmFamilyList[i].showAdminsSettingsUser.showAdminsSettingsUserFirstName} ${newValue.blmFamilyList[i].showAdminsSettingsUser.showAdminsSettingsUserLastName}'),
            subtitle: Text('${newValue.blmFamilyList[i].showAdminsSettingsUser.showAdminsSettingsUserEmail}'),
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
        backgroundColor: Color(0xff04ECFF),
        title:  Text('Memorial Settings', style: TextStyle(fontSize: 16, color: Color(0xffffffff),),),
        centerTitle: true,
          leading: IconButton(
          icon: Icon(Icons.arrow_back),
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
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
            physics: ClampingScrollPhysics(),
            itemCount: managers.length,
            separatorBuilder: (c, i) => Divider(height: 10, color: Colors.transparent),
            itemBuilder: (c, i) => managers[i],
          )
        ),
      ),
    );
  }
}