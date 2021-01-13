import 'package:facesbyplaces/API/Regular/09-Settings-Memorial/api-settings-memorial-regular-10-show-family-settings.dart';
import 'package:facesbyplaces/API/Regular/09-Settings-Memorial/api-settings-memorial-regular-18-remove-friends-or-family.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'home-settings-memorial-regular-07-search-user-settings.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter/material.dart';

class RegularShowFamilySettings{
  final int userId;
  final String firstName;
  final String lastName;
  final String image;
  final String relationship;
  final String email;

  RegularShowFamilySettings({this.userId, this.firstName, this.lastName, this.image, this.relationship, this.email});
}

class HomeRegularPageFamily extends StatefulWidget{
  final int memorialId;
  HomeRegularPageFamily({this.memorialId});

  HomeRegularPageFamilyState createState() => HomeRegularPageFamilyState(memorialId: memorialId);
}

class HomeRegularPageFamilyState extends State<HomeRegularPageFamily>{
  final int memorialId;
  HomeRegularPageFamilyState({this.memorialId});

  RefreshController refreshController = RefreshController(initialRefresh: true);
  List<RegularShowFamilySettings> familyList;
  int familyItemsRemaining;
  int page;

  void onRefresh() async{
    await Future.delayed(Duration(milliseconds: 1000));
    refreshController.refreshCompleted();
  }

  void onLoading1() async{
    if(familyItemsRemaining != 0){
      context.showLoaderOverlay();
      var newValue = await apiRegularShowFamilySettings(memorialId: memorialId, page: page);
      familyItemsRemaining = newValue.itemsRemaining;

      for(int i = 0; i < newValue.familyList.length; i++){
        familyList.add(
          RegularShowFamilySettings(
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
      page++;
      
      refreshController.loadComplete();
      context.hideLoaderOverlay();
    }else{
      refreshController.loadNoData();
    }
  }

  void initState(){
    super.initState();
    familyItemsRemaining = 1;
    familyList = [];
    page = 1;
    onLoading1();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff04ECFF),
        title: Text('Page Family', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xffffffff)),),
        centerTitle: true,
        leading: IconButton(icon: Icon(Icons.arrow_back, color: Color(0xffffffff),), onPressed: (){Navigator.pop(context);},),
        actions: [
          GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularSearchUser(isFamily: true, memorialId: memorialId,)));
            },
            child: Center(child: Text('Add Family', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xffffffff)),),),
          ),
        ],
      ),
      body: Container(
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
                      maxRadius: SizeConfig.blockSizeVertical * 5,
                      backgroundColor: Color(0xff888888), 
                      backgroundImage: familyList[i].image != null 
                      ? NetworkImage(familyList[i].image) 
                      : AssetImage('assets/icons/app-icon.png'),
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
                        await apiRegularDeleteMemorialFriendsOrFamily(memorialId: memorialId, userId: familyList[i].userId);
                        context.hideLoaderOverlay();

                        familyItemsRemaining = 1;
                        familyList = [];
                        page = 1;
                        onLoading1();
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
            itemCount: familyList.length,
          ),
        ),
      ),
    );
  }
}


