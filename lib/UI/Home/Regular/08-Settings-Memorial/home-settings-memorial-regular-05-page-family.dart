import 'package:facesbyplaces/API/Regular/09-Settings-Memorial/api-settings-memorial-regular-04-show-family-settings.dart';
import 'package:facesbyplaces/API/Regular/09-Settings-Memorial/api-settings-memorial-regular-13-remove-friends-or-family.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'home-settings-memorial-regular-07-search-user-settings.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:flutter/material.dart';

class RegularShowFamilySettings{
  final int userId;
  final String firstName;
  final String lastName;
  final String image;
  final String relationship;
  final int accountType;

  RegularShowFamilySettings({required this.userId, required this.firstName, required this.lastName, required this.image, required this.relationship, required this.accountType});
}

class HomeRegularPageFamily extends StatefulWidget{
  final int memorialId;
  HomeRegularPageFamily({required this.memorialId});

  HomeRegularPageFamilyState createState() => HomeRegularPageFamilyState(memorialId: memorialId);
}

class HomeRegularPageFamilyState extends State<HomeRegularPageFamily>{
  final int memorialId;
  HomeRegularPageFamilyState({required this.memorialId});

  RefreshController refreshController = RefreshController(initialRefresh: true);
  List<RegularShowFamilySettings> familyList = [];
  int familyItemsRemaining = 1;
  int page = 1;

  void onRefresh() async{
    await Future.delayed(Duration(milliseconds: 1000));
    refreshController.refreshCompleted();
  }

  void onLoading1() async{
    if(familyItemsRemaining != 0){
      context.showLoaderOverlay();
      var newValue = await apiRegularShowFamilySettings(memorialId: memorialId, page: page);
      context.hideLoaderOverlay();

      familyItemsRemaining = newValue.almItemsRemaining;

      for(int i = 0; i < newValue.almFamilyList.length; i++){
        familyList.add(
          RegularShowFamilySettings(
            userId: newValue.almFamilyList[i].showFamilySettingsUser.showFamilySettingsDetailsId,
            firstName: newValue.almFamilyList[i].showFamilySettingsUser.showFamilySettingsDetailsFirstName,
            lastName: newValue.almFamilyList[i].showFamilySettingsUser.showFamilySettingsDetailsLastName,
            image: newValue.almFamilyList[i].showFamilySettingsUser.showFamilySettingsDetailsImage,
            relationship: newValue.almFamilyList[i].showFamilySettingsRelationship,
            accountType: newValue.almFamilyList[i].showFamilySettingsUser.showFamilySettingsDetailsAccountType,
          ),
        );
      }

      refreshController.loadComplete();

    //   if(newValue !=)){
    //     await showDialog(
    //       context: context,
    //       builder: (_) => 
    //         AssetGiffyDialog(
    //         image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
    //         title: Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
    //         entryAnimation: EntryAnimation.DEFAULT,
    //         description: Text('Something went wrong. Please try again.',
    //           textAlign: TextAlign.center,
    //           style: TextStyle(),
    //         ),
    //         onlyOkButton: true,
    //         buttonOkColor: Colors.red,
    //         onOkButtonPressed: () {
    //           Navigator.pop(context, true);
    //         },
    //       )
    //     );
    //   }else{
    //     familyItemsRemaining = newValue.almItemsRemaining;

    //     for(int i = 0; i < newValue.almFamilyList.length; i++){
    //       familyList.add(
    //         RegularShowFamilySettings(
    //           userId: newValue.almFamilyList[i].showFamilySettingsUser.showFamilySettingsDetailsId,
    //           firstName: newValue.almFamilyList[i].showFamilySettingsUser.showFamilySettingsDetailsFirstName,
    //           lastName: newValue.almFamilyList[i].showFamilySettingsUser.showFamilySettingsDetailsLastName,
    //           image: newValue.almFamilyList[i].showFamilySettingsUser.showFamilySettingsDetailsImage,
    //           relationship: newValue.almFamilyList[i].showFamilySettingsRelationship,
    //           accountType: newValue.almFamilyList[i].showFamilySettingsUser.showFamilySettingsDetailsAccountType,
    //         ),
    //       );
    //     }

    //     if(mounted)
    //     setState(() {});
    //     page++;
        
    //     refreshController.loadComplete();
    //   }

    }else{
      refreshController.loadNoData();
    }
  }

  void initState(){
    super.initState();
    onLoading1();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff04ECFF),
        title: Text('Page Family', style: TextStyle(fontSize: 16, color: Color(0xffffffff)),),
        centerTitle: true,
        leading: IconButton(icon: Icon(Icons.arrow_back, color: Color(0xffffffff),), onPressed: (){Navigator.pop(context);},),
        actions: [
          GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularSearchUser(isFamily: true, memorialId: memorialId,)));
            },
            child: Center(child: Text('Add Family', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xffffffff),),),),
          ),
        ],
      ),
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: MaterialClassicHeader(
          color: Color(0xffffffff),
          backgroundColor: Color(0xff4EC9D4),
        ),
        footer: CustomFooter(
          loadStyle: LoadStyle.ShowWhenLoading,
          builder: (BuildContext context, LoadStatus mode){
            Widget body = Container();
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
                    maxRadius: 40,
                    backgroundColor: Color(0xff888888),
                    backgroundImage: NetworkImage(familyList[i].image),
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
                    minWidth: SizeConfig.screenWidth! / 3.5,
                    padding: EdgeInsets.zero,
                    textColor: Color(0xffffffff),
                    splashColor: Color(0xff04ECFF),
                    onPressed: () async{
                      context.showLoaderOverlay();
                      bool result = await apiRegularDeleteMemorialFriendsOrFamily(memorialId: memorialId, userId: familyList[i].userId, accountType: familyList[i].accountType);
                      context.hideLoaderOverlay();

                      if(result == true){
                        await showDialog(
                          context: context,
                          builder: (_) => 
                            AssetGiffyDialog(
                            image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                            title: Text('Success', textAlign: TextAlign.center, style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                            entryAnimation: EntryAnimation.DEFAULT,
                            description: Text('Successfully removed a user from Family list.',
                              textAlign: TextAlign.center,
                              style: TextStyle(),
                            ),
                            onlyOkButton: true,
                            buttonOkColor: Colors.green,
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
                      }

                      familyItemsRemaining = 1;
                      familyList = [];
                      page = 1;
                      onLoading1();
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
          itemCount: familyList.length,
        ),
      ),
    );
  }
}


