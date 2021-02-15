import 'package:facesbyplaces/API/Regular/09-Settings-Memorial/api-settings-memorial-regular-03-show-admin-settings.dart';
import 'package:facesbyplaces/API/Regular/09-Settings-Memorial/api-settings-memorial-regular-09-add-admin.dart';
import 'package:facesbyplaces/API/Regular/09-Settings-Memorial/api-settings-memorial-regular-10-remove-admin.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:flutter/material.dart';

class RegularShowAdminSettings{
  final int userId;
  final String firstName;
  final String lastName;
  final String image;
  final String relationship;
  final String email;

  RegularShowAdminSettings({this.userId, this.firstName, this.lastName, this.image, this.relationship, this.email});
}

class HomeRegularPageManagers extends StatefulWidget{
  final int memorialId;
  HomeRegularPageManagers({this.memorialId});

  HomeRegularPageManagersState createState() => HomeRegularPageManagersState(memorialId: memorialId);
}

class HomeRegularPageManagersState extends State<HomeRegularPageManagers>{
  final int memorialId;
  HomeRegularPageManagersState({this.memorialId});

  RefreshController refreshController = RefreshController(initialRefresh: true);
  List<RegularShowAdminSettings> adminList;
  List<RegularShowAdminSettings> familyList;
  int adminItemsRemaining;
  int familyItemsRemaining;
  int page1;
  int page2;

  void onRefresh() async{
    await Future.delayed(Duration(milliseconds: 1000));
    refreshController.refreshCompleted();
  }

  void onLoading1() async{
    if(adminItemsRemaining != 0){
      context.showLoaderOverlay();
      var newValue = await apiRegularShowAdminSettings(memorialId: memorialId, page: page1);
      context.hideLoaderOverlay();

      if(newValue == null){
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
      }else{
        adminItemsRemaining = newValue.almAdminItemsRemaining;

        for(int i = 0; i < newValue.almAdminList.length; i++){
          adminList.add(
            RegularShowAdminSettings(
              userId: newValue.almAdminList[i].showAdminsSettingsUser.showAdminsSettingsUserId,
              firstName: newValue.almAdminList[i].showAdminsSettingsUser.showAdminsSettingsUserFirstName,
              lastName: newValue.almAdminList[i].showAdminsSettingsUser.showAdminsSettingsUserLastName,
              image: newValue.almAdminList[i].showAdminsSettingsUser.showAdminsSettingsUserImage,
              relationship: newValue.almAdminList[i].showAdminsSettingsRelationship,
              email: newValue.almAdminList[i].showAdminsSettingsUser.showAdminsSettingsUserEmail,
            ),
          );
        }

        if(mounted)
        setState(() {});
        page1++;
        
        refreshController.loadComplete();
      }

      
    }else{
      refreshController.loadNoData();
    }
  }

  void onLoading2() async{
    
    if(familyItemsRemaining != 0){
      context.showLoaderOverlay();
      var newValue = await apiRegularShowAdminSettings(memorialId: memorialId, page: page2);
      context.hideLoaderOverlay();

      familyItemsRemaining = newValue.almFamilyItemsRemaining;

      for(int i = 0; i < newValue.almFamilyList.length; i++){
        familyList.add(
          RegularShowAdminSettings(
            userId: newValue.almFamilyList[i].showAdminsSettingsUser.showAdminsSettingsUserId,
            firstName: newValue.almFamilyList[i].showAdminsSettingsUser.showAdminsSettingsUserFirstName,
            lastName: newValue.almFamilyList[i].showAdminsSettingsUser.showAdminsSettingsUserLastName,
            image: newValue.almFamilyList[i].showAdminsSettingsUser.showAdminsSettingsUserImage,
            relationship: newValue.almFamilyList[i].showAdminsSettingsRelationship,
            email: newValue.almFamilyList[i].showAdminsSettingsUser.showAdminsSettingsUserEmail,
          ),
        );
      }

      if(mounted)
      setState(() {});
      page2++;
      
      refreshController.loadComplete();
    }else{
      refreshController.loadNoData();
    }
  }


  void initState(){
    super.initState();
    adminList = [];
    familyList = [];
    adminItemsRemaining = 1;
    familyItemsRemaining = 1;
    page1 = 1;
    page2 = 1;
    onLoading1();
    onLoading2();
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
        height: SizeConfig.screenHeight - kToolbarHeight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SmartRefresher(
                enablePullDown: true,
                enablePullUp: true,
                header: MaterialClassicHeader(
                  color: Color(0xffffffff),
                  backgroundColor: Color(0xff4EC9D4),
                ),
                footer: CustomFooter(
                  loadStyle: LoadStyle.ShowWhenLoading,
                  builder: (BuildContext context, LoadStatus mode){
                    Widget body;
                    if(mode == LoadStatus.loading){
                      body = CircularProgressIndicator();
                    }
                    return Center(child: body);
                  },
                ),
                controller: refreshController,
                onRefresh: onRefresh,
                onLoading: onLoading1,
                child: ListView.separated(
                  physics: ClampingScrollPhysics(),
                  itemBuilder: (c, i) {
                    return Container(
                      padding: EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: Color(0xff888888), 
                            backgroundImage: adminList[i].image != null ? NetworkImage(adminList[i].image) : AssetImage('assets/icons/app-icon.png'),
                          ),

                          SizedBox(width: 25,),

                          Expanded(
                            child: Container(
                              child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(adminList[i].firstName + ' ' + adminList[i].lastName, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xff000000)),),

                                Text(adminList[i].relationship, style: TextStyle(fontSize: 12, color: Color(0xff888888)),),
                              ],
                            ),
                            ),
                          ),

                          SizedBox(width: 25,),

                          MaterialButton(
                            minWidth: SizeConfig.screenWidth / 3.5,
                            padding: EdgeInsets.zero,
                            textColor: Color(0xffffffff),
                            splashColor: Color(0xffE74C3C),
                            onPressed: () async{
                              context.showLoaderOverlay();
                              await apiRegularDeleteMemorialAdmin(pageType: 'Memorial', pageId: memorialId, userId: adminList[i].userId);
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
                            child: Text('Remove', style: TextStyle(fontSize: 14,),),
                            height: 40,
                            shape: StadiumBorder(
                              side: BorderSide(color: Color(0xffE74C3C)),
                            ),
                              color: Color(0xffE74C3C),
                          ),

                        ],
                      ),
                    );
                  },
                  separatorBuilder: (c, i) => Divider(height: 10, color: Colors.transparent),
                  itemCount: adminList.length,
                ),
              ),
            ),

            SizedBox(height: 20,),

            Padding(padding: EdgeInsets.only(left: 20.0,), child: Text('Family', style: TextStyle(fontSize: 14, color: Color(0xff888888)),),),

            Expanded(
              child: SmartRefresher(
                enablePullDown: true,
                enablePullUp: true,
                header: MaterialClassicHeader(
                  color: Color(0xffffffff),
                  backgroundColor: Color(0xff4EC9D4),
                ),
                footer: CustomFooter(
                  loadStyle: LoadStyle.ShowWhenLoading,
                  builder: (BuildContext context, LoadStatus mode){
                    Widget body;
                    if(mode == LoadStatus.loading){
                      body = CircularProgressIndicator();
                    }
                    return Center(child: body);
                  },
                ),
                controller: refreshController,
                onRefresh: onRefresh,
                onLoading: onLoading2,
                child: ListView.separated(
                  physics: ClampingScrollPhysics(),
                  itemBuilder: (c, i) {
                    return Container(
                      padding: EdgeInsets.all(10.0),
                      child: Row(
                        children: [

                          CircleAvatar(
                            radius: 40,
                            backgroundColor: Color(0xff888888), 
                            backgroundImage: familyList[i].image != null ? NetworkImage(familyList[i].image) : AssetImage('assets/icons/app-icon.png'),
                          ),

                          SizedBox(width: 25,),

                          Expanded(
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(familyList[i].firstName + ' ' + familyList[i].lastName, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xff000000)),),

                                  Text(familyList[i].relationship, style: TextStyle(fontSize: 12, color: Color(0xff888888)),),
                                  
                                ],
                              ),
                            ),
                          ),

                          SizedBox(width: 25,),

                          MaterialButton(
                            minWidth: SizeConfig.screenWidth / 3.5,
                            padding: EdgeInsets.zero,
                            textColor: Color(0xffffffff),
                            splashColor: Color(0xff04ECFF),
                            onPressed: () async{
                              context.showLoaderOverlay();
                              await apiRegularAddMemorialAdmin(pageType: 'Memorial', pageId: memorialId, userId: familyList[i].userId);
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

                        ],
                      ),
                    );
                    
                  },
                  separatorBuilder: (c, i) => Divider(height: 10, color: Colors.transparent),
                  itemCount: familyList.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


