import 'package:facesbyplaces/API/Regular/09-Settings-Memorial/api-settings-memorial-regular-03-show-admin-settings.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter/material.dart';

class RegularShowAdminSettings{
  final int userId;
  final String firstName;
  final String lastName;
  final String image;
  final String relationship;
  final String email;

  RegularShowAdminSettings({required this.userId, required this.firstName, required this.lastName, required this.image, required this.relationship, required this.email});
}

class HomeRegularPageManagers extends StatefulWidget{
  final int memorialId;
  HomeRegularPageManagers({required this.memorialId});

  HomeRegularPageManagersState createState() => HomeRegularPageManagersState(memorialId: memorialId);
}

class HomeRegularPageManagersState extends State<HomeRegularPageManagers>{
  final int memorialId;
  HomeRegularPageManagersState({required this.memorialId});

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
      var newValue = await apiRegularShowAdminSettings(memorialId: memorialId, page: page1);
      context.hideLoaderOverlay();

      adminItemsRemaining = newValue.almAdminItemsRemaining;

      for(int i = 0; i < newValue.almAdminList.length; i++){
        managers.add(
          ListTile(
            leading: CircleAvatar(backgroundColor: Color(0xff888888), backgroundImage: NetworkImage('${newValue.almAdminList[i].showAdminsSettingsUser.showAdminsSettingsUserImage}'),),
            title: Text('${newValue.almAdminList[i].showAdminsSettingsUser.showAdminsSettingsUserFirstName} ${newValue.almAdminList[i].showAdminsSettingsUser.showAdminsSettingsUserLastName}'),
            subtitle: Text('${newValue.almAdminList[i].showAdminsSettingsUser.showAdminsSettingsUserEmail}'),
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
      var newValue = await apiRegularShowAdminSettings(memorialId: memorialId, page: page2);
      context.hideLoaderOverlay();

      familyItemsRemaining = newValue.almFamilyItemsRemaining;

      for(int i = 0; i < newValue.almFamilyList.length; i++){
        managers.add(
          ListTile(
            leading: CircleAvatar(backgroundColor: Color(0xff888888), backgroundImage: NetworkImage('${newValue.almAdminList[i].showAdminsSettingsUser.showAdminsSettingsUserImage}'),),
            title: Text('${newValue.almAdminList[i].showAdminsSettingsUser.showAdminsSettingsUserFirstName} ${newValue.almAdminList[i].showAdminsSettingsUser.showAdminsSettingsUserLastName}'),
            subtitle: Text('${newValue.almAdminList[i].showAdminsSettingsUser.showAdminsSettingsUserEmail}'),
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