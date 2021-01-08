import 'package:facesbyplaces/API/BLM/09-Settings-Memorial/api-settings-memorial-blm-08-show-admin-settings.dart';
import 'package:facesbyplaces/API/BLM/09-Settings-Memorial/api-settings-memorial-blm-15-remove-admin.dart';
import 'package:facesbyplaces/API/BLM/09-Settings-Memorial/api-settings-memorial-blm-16-add-admin.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter/material.dart';

class BLMShowAdminSettings{
  final int userId;
  final String firstName;
  final String lastName;
  final String image;
  final String relationship;
  final String email;

  BLMShowAdminSettings({this.userId, this.firstName, this.lastName, this.image, this.relationship, this.email});
}

class HomeBLMPageManagers extends StatefulWidget{
  final int memorialId;
  HomeBLMPageManagers({this.memorialId});

  HomeBLMPageManagersState createState() => HomeBLMPageManagersState(memorialId: memorialId);
}

class HomeBLMPageManagersState extends State<HomeBLMPageManagers>{
  final int memorialId;
  HomeBLMPageManagersState({this.memorialId});

  RefreshController refreshController = RefreshController(initialRefresh: true);
  List<BLMShowAdminSettings> adminList;
  List<BLMShowAdminSettings> familyList;
  int adminItemsRemaining;
  int familyItemsRemaining;
  // int page;
  int page1;
  int page2;

  void onRefresh() async{
    await Future.delayed(Duration(milliseconds: 1000));
    refreshController.refreshCompleted();
  }

  void onLoading1() async{
    if(adminItemsRemaining != 0){
      context.showLoaderOverlay();
      var newValue = await apiBLMShowAdminSettings(memorialId: memorialId, page: page1);
      adminItemsRemaining = newValue.adminItemsRemaining;

      for(int i = 0; i < newValue.adminList.length; i++){
        adminList.add(
          BLMShowAdminSettings(
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
      context.hideLoaderOverlay();
    }else{
      refreshController.loadNoData();
    }
  }

  void onLoading2() async{
    
    if(familyItemsRemaining != 0){
      context.showLoaderOverlay();
      var newValue = await apiBLMShowAdminSettings(memorialId: memorialId, page: page2);
      context.hideLoaderOverlay();
      familyItemsRemaining = newValue.familyItemsRemaining;

      for(int i = 0; i < newValue.familyList.length; i++){
        familyList.add(
          BLMShowAdminSettings(
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
                enablePullDown: false,
                enablePullUp: true,
                header: MaterialClassicHeader(),
                footer: CustomFooter(
                  loadStyle: LoadStyle.ShowWhenLoading,
                  builder: (BuildContext context, LoadStatus mode){
                    Widget body ;
                    if(mode == LoadStatus.idle){
                      body = Text('Pull up to load.', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
                    }
                    else if(mode == LoadStatus.loading){
                      body =  CircularProgressIndicator();
                    }
                    else if(mode == LoadStatus.failed){
                      body = Text('Load Failed! Please try again.', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
                    }
                    else if(mode == LoadStatus.canLoading){
                      body = Text('Release to load more.', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
                    }else{
                      body = Text('End of list.', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
                    }
                    return Container(height: 55.0, child: Center(child: body),);
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
                          // CircleAvatar(
                          //   maxRadius: SizeConfig.blockSizeVertical * 5,
                          //   backgroundColor: Color(0xff888888),
                          //   backgroundImage: AssetImage('assets/icons/graveyard.png'),
                          // ),
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

                                // Text(adminList[i].email, style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 3.5, color: Color(0xff888888)),),

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
                              await apiBLMDeleteMemorialAdmin(pageType: 'Blm', pageId: memorialId, userId: adminList[i].userId);
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
                  // itemCount: 1,
                ),
              ),
            ),

            SizedBox(height: SizeConfig.blockSizeVertical * 2,),

            Padding(padding: EdgeInsets.only(left: 20.0,), child: Text('Family', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 3.5, color: Color(0xff888888)),),),

            Expanded(
              child: SmartRefresher(
                enablePullDown: false,
                enablePullUp: true,
                header: MaterialClassicHeader(),
                footer: CustomFooter(
                  loadStyle: LoadStyle.ShowWhenLoading,
                  builder: (BuildContext context, LoadStatus mode){
                    Widget body ;
                    if(mode == LoadStatus.idle){
                      body = Text('Pull up to load.', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
                    }
                    else if(mode == LoadStatus.loading){
                      body =  CircularProgressIndicator();
                    }
                    else if(mode == LoadStatus.failed){
                      body = Text('Load Failed! Please try again.', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
                    }
                    else if(mode == LoadStatus.canLoading){
                      body = Text('Release to load more.', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
                    }else{
                      body = Text('End of list.', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
                    }
                    return Container(height: 55.0, child: Center(child: body),);
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
                          // CircleAvatar(
                          //   maxRadius: SizeConfig.blockSizeVertical * 5,
                          //   backgroundColor: Color(0xff888888),
                          //   backgroundImage: AssetImage('assets/icons/graveyard.png'),
                          // ),

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

                                // Text(familyList[i].email, style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 3.5, color: Color(0xff888888)),),

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
                  // itemCount: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


