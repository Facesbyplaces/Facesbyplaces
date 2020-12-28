import 'package:facesbyplaces/API/Regular/api-62-regular-show-admin-settings.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter/material.dart';

class RegularShowAdminSettings{
  final String firstName;
  final String lastName;
  final String image;
  final String relationship;

  RegularShowAdminSettings({this.firstName, this.lastName, this.image, this.relationship});
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
  List<RegularShowAdminSettings> adminList = [];
  List<RegularShowAdminSettings> familyList = [];
  int adminItemsRemaining = 1;
  int familyItemsRemaining = 1;
  int page = 1;

  void initState(){
    super.initState();
    onLoading1();
    onLoading2();
  }

  void onRefresh() async{
    await Future.delayed(Duration(milliseconds: 1000));
    refreshController.refreshCompleted();
  }

  void onLoading1() async{
    if(adminItemsRemaining != 0){
      context.showLoaderOverlay();
      var newValue = await apiRegularShowAdminSettings(memorialId, page);
      adminItemsRemaining = newValue.adminItemsRemaining;

      for(int i = 0; i < newValue.adminList.length; i++){
        adminList.add(
          RegularShowAdminSettings(
            firstName: newValue.adminList[i].user.firstName,
            lastName: newValue.adminList[i].user.lastName,
            image: newValue.adminList[i].user.image,
            relationship: newValue.adminList[i].relationship,
          ),
        );
      }

      if(mounted)
      setState(() {});
      page++;
      
      refreshController.loadComplete();
      context.hideLoaderOverlay();
    }else{
      refreshController.loadNoData();
    }
  }

  void onLoading2() async{
    
    if(familyItemsRemaining != 0){
      context.showLoaderOverlay();
      var newValue = await apiRegularShowAdminSettings(memorialId, page);
      context.hideLoaderOverlay();
      familyItemsRemaining = newValue.familyItemsRemaining;

      for(int i = 0; i < newValue.familyList.length; i++){
        familyList.add(
          RegularShowAdminSettings(
            firstName: newValue.familyList[i].user.firstName,
            lastName: newValue.familyList[i].user.lastName,
            image: newValue.adminList[i].user.image,
            relationship: newValue.familyList[i].relationship
          ),
        );
      }

      if(mounted)
      setState(() {});
      page++;
      
      refreshController.loadComplete();
      
    }else{
      refreshController.loadNoData();
    }
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
                      body =  Text('Pull up load.', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
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
                    var container = Container(
                      padding: EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            maxRadius: SizeConfig.blockSizeVertical * 5,
                            backgroundColor: Color(0xff888888),
                            backgroundImage: AssetImage('assets/icons/graveyard.png'),
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
                            splashColor: Color(0xff04ECFF),
                            onPressed: () async{

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

                    return container;
                    
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
                enablePullDown: false,
                enablePullUp: true,
                header: MaterialClassicHeader(),
                footer: CustomFooter(
                  loadStyle: LoadStyle.ShowWhenLoading,
                  builder: (BuildContext context, LoadStatus mode){
                    Widget body ;
                    if(mode == LoadStatus.idle){
                      body =  Text('Pull up load.', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
                    }
                    else if(mode == LoadStatus.loading){
                      body =  CircularProgressIndicator();
                    }
                    else if(mode == LoadStatus.failed){
                      body = Text('Load Failed! Please try again.', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
                    }
                    else if(mode == LoadStatus.canLoading){
                      body = Text('Release to load more.', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
                      page++;
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
                    var container = Container(
                      padding: EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            maxRadius: SizeConfig.blockSizeVertical * 5,
                            backgroundColor: Color(0xff888888),
                            backgroundImage: AssetImage('assets/icons/graveyard.png'),
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

                    return container;
                    
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

