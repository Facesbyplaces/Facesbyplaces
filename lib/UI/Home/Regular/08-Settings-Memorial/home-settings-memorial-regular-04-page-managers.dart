import 'package:facesbyplaces/API/Regular/09-Settings-Memorial/api-settings-memorial-regular-09-show-admin-settings.dart';
import 'package:facesbyplaces/API/Regular/09-Settings-Memorial/api-settings-memorial-regular-15-add-admin.dart';
import 'package:facesbyplaces/API/Regular/09-Settings-Memorial/api-settings-memorial-regular-16-remove-admin.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-02-regular-dialog.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:loader_overlay/loader_overlay.dart';
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
        await showDialog(context: (context), builder: (build) => MiscRegularAlertDialog(title: 'Error', content: 'Something went wrong. Please try again.'));
      }else{
        adminItemsRemaining = newValue.adminItemsRemaining;

        for(int i = 0; i < newValue.adminList.length; i++){
          adminList.add(
            RegularShowAdminSettings(
              userId: newValue.adminList[i].user.id,
              firstName: newValue.adminList[i].user.firstName,
              lastName: newValue.adminList[i].user.lastName,
              image: newValue.adminList[i].user.image,
              relationship: newValue.adminList[i].relationship,
              email: newValue.adminList[i].user.email,
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

      familyItemsRemaining = newValue.familyItemsRemaining;

      for(int i = 0; i < newValue.familyList.length; i++){
        familyList.add(
          RegularShowAdminSettings(
            userId: newValue.familyList[i].user.id,
            firstName: newValue.familyList[i].user.firstName,
            lastName: newValue.familyList[i].user.lastName,
            image: newValue.familyList[i].user.image,
            relationship: newValue.familyList[i].relationship,
            email: newValue.familyList[i].user.email,
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
        title:  Text('Memorial Settings', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xffffffff),),),
        centerTitle: true,
          leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
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
                            radius: SizeConfig.blockSizeVertical * 5, 
                            backgroundColor: Color(0xff888888), 
                            backgroundImage: adminList[i].image != null ? NetworkImage(adminList[i].image) : AssetImage('assets/icons/app-icon.png'),
                          ),

                          SizedBox(width: SizeConfig.blockSizeHorizontal * 3,),

                          Expanded(
                            child: Container(
                              child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(adminList[i].firstName + ' ' + adminList[i].lastName, style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, fontWeight: FontWeight.bold, color: Color(0xff000000)),),

                                Text(adminList[i].relationship, style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 3.5, color: Color(0xff888888)),),
                              ],
                            ),
                            ),
                          ),

                          SizedBox(width: SizeConfig.blockSizeHorizontal * 3,),

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
                            child: Text('Remove', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 3.5,),),
                            height: SizeConfig.blockSizeVertical * 5,
                            shape: StadiumBorder(
                              side: BorderSide(color: Color(0xffE74C3C)),
                            ),
                              color: Color(0xffE74C3C),
                          ),

                        ],
                      ),
                    );
                  },
                  separatorBuilder: (c, i) => Divider(height: SizeConfig.blockSizeVertical * 1, color: Colors.transparent),
                  itemCount: adminList.length,
                ),
              ),
            ),

            SizedBox(height: SizeConfig.blockSizeVertical * 2,),

            Padding(padding: EdgeInsets.only(left: 20.0,), child: Text('Family', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 3.5, color: Color(0xff888888)),),),

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
                            radius: SizeConfig.blockSizeVertical * 5, 
                            backgroundColor: Color(0xff888888), 
                            backgroundImage: familyList[i].image != null ? NetworkImage(familyList[i].image) : AssetImage('assets/icons/app-icon.png'),
                          ),

                          SizedBox(width: SizeConfig.blockSizeHorizontal * 3,),

                          Expanded(
                            child: Container(
                              child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(familyList[i].firstName + ' ' + familyList[i].lastName, style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, fontWeight: FontWeight.bold, color: Color(0xff000000)),),

                                Text(familyList[i].relationship, style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 3.5, color: Color(0xff888888)),),
                                
                              ],
                            ),
                            ),
                          ),

                          SizedBox(width: SizeConfig.blockSizeHorizontal * 3,),

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
                            child: Text('Make Manager', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 3.5,),),
                            height: SizeConfig.blockSizeVertical * 5,
                            shape: StadiumBorder(
                              side: BorderSide(color: Color(0xff04ECFF)),
                            ),
                              color: Color(0xff04ECFF),
                          ),

                        ],
                      ),
                    );
                    
                  },
                  separatorBuilder: (c, i) => Divider(height: SizeConfig.blockSizeVertical * 1, color: Colors.transparent),
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

