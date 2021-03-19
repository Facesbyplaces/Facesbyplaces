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
        // adminList.add(
        //   RegularShowAdminSettings(
        //     userId: newValue.almAdminList[i].showAdminsSettingsUser.showAdminsSettingsUserId,
        //     firstName: newValue.almAdminList[i].showAdminsSettingsUser.showAdminsSettingsUserFirstName,
        //     lastName: newValue.almAdminList[i].showAdminsSettingsUser.showAdminsSettingsUserLastName,
        //     image: newValue.almAdminList[i].showAdminsSettingsUser.showAdminsSettingsUserImage,
        //     relationship: newValue.almAdminList[i].showAdminsSettingsRelationship,
        //     email: newValue.almAdminList[i].showAdminsSettingsUser.showAdminsSettingsUserEmail,
        //   ),
        // );
      }
    }


    if(mounted)
    setState(() {});
    page1++;
  }

  void onLoading2() async{
    
    if(familyItemsRemaining != 0){
      context.showLoaderOverlay();
      var newValue = await apiRegularShowAdminSettings(memorialId: memorialId, page: page2);
      context.hideLoaderOverlay();

      familyItemsRemaining = newValue.almFamilyItemsRemaining;

      for(int i = 0; i < newValue.almFamilyList.length; i++){
        // familyList.add(
        //   RegularShowAdminSettings(
        //     userId: newValue.almFamilyList[i].showAdminsSettingsUser.showAdminsSettingsUserId,
        //     firstName: newValue.almFamilyList[i].showAdminsSettingsUser.showAdminsSettingsUserFirstName,
        //     lastName: newValue.almFamilyList[i].showAdminsSettingsUser.showAdminsSettingsUserLastName,
        //     image: newValue.almFamilyList[i].showAdminsSettingsUser.showAdminsSettingsUserImage,
        //     relationship: newValue.almFamilyList[i].showAdminsSettingsRelationship,
        //     email: newValue.almFamilyList[i].showAdminsSettingsUser.showAdminsSettingsUserEmail,
        //   ),
        // );
        managers.add(
          ListTile(
            leading: CircleAvatar(backgroundColor: Color(0xff888888), backgroundImage: NetworkImage('${newValue.almAdminList[i].showAdminsSettingsUser.showAdminsSettingsUserImage}'),),
            title: Text('${newValue.almAdminList[i].showAdminsSettingsUser.showAdminsSettingsUserFirstName} ${newValue.almAdminList[i].showAdminsSettingsUser.showAdminsSettingsUserLastName}'),
            subtitle: Text('${newValue.almAdminList[i].showAdminsSettingsUser.showAdminsSettingsUserEmail}'),
          ),
        );
      }
    }
      if(mounted)
      setState(() {});
      page2++;
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
      // body: Column(
      //   crossAxisAlignment: CrossAxisAlignment.start,
      //   children: [
      //     Expanded(
      //       child: Container(),
      //       // child: SmartRefresher(
      //       //   enablePullDown: true,
      //       //   enablePullUp: true,
      //       //   header: MaterialClassicHeader(
      //       //     color: Color(0xffffffff),
      //       //     backgroundColor: Color(0xff4EC9D4),
      //       //   ),
      //       //   footer: CustomFooter(
      //       //     loadStyle: LoadStyle.ShowWhenLoading,
      //       //     builder: (BuildContext context, LoadStatus mode){
      //       //       Widget body = Container();
      //       //       if(mode == LoadStatus.loading){
      //       //         body = CircularProgressIndicator();
      //       //       }
      //       //       return Center(child: body);
      //       //     },
      //       //   ),
      //       //   controller: refreshController,
      //       //   onRefresh: onRefresh,
      //       //   onLoading: onLoading1,
      //       //   child: ListView.separated(
      //       //     physics: ClampingScrollPhysics(),
      //       //     itemBuilder: (c, i) {
      //       //       return Container(
      //       //         padding: EdgeInsets.all(10.0),
      //       //         child: Row(
      //       //           children: [
      //       //             CircleAvatar(
      //       //               radius: 40,
      //       //               backgroundColor: Color(0xff888888), 
      //       //               backgroundImage: NetworkImage(adminList[i].image),
      //       //             ),

      //       //             SizedBox(width: 25,),

      //       //             Expanded(
      //       //               child: Container(
      //       //                 child: Column(
      //       //                 crossAxisAlignment: CrossAxisAlignment.start,
      //       //                 children: [
      //       //                   Text(adminList[i].firstName + ' ' + adminList[i].lastName, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xff000000)),),

      //       //                   Text(adminList[i].relationship, style: TextStyle(fontSize: 12, color: Color(0xff888888)),),
      //       //                 ],
      //       //               ),
      //       //               ),
      //       //             ),

      //       //             SizedBox(width: 25,),

      //       //             MaterialButton(
      //       //               minWidth: SizeConfig.screenWidth! / 3.5,
      //       //               padding: EdgeInsets.zero,
      //       //               textColor: Color(0xffffffff),
      //       //               splashColor: Color(0xffE74C3C),
      //       //               onPressed: () async{
      //       //                 context.showLoaderOverlay();
      //       //                 await apiRegularDeleteMemorialAdmin(pageType: 'Memorial', pageId: memorialId, userId: adminList[i].userId);
      //       //                 context.hideLoaderOverlay();

      //       //                 adminList = [];
      //       //                 familyList = [];
      //       //                 adminItemsRemaining = 1;
      //       //                 familyItemsRemaining = 1;
      //       //                 page1 = 1;
      //       //                 page2 = 1;
      //       //                 onLoading1();
      //       //                 onLoading2();
      //       //               },
      //       //               child: Text('Remove', style: TextStyle(fontSize: 14,),),
      //       //               height: 40,
      //       //               shape: StadiumBorder(
      //       //                 side: BorderSide(color: Color(0xffE74C3C)),
      //       //               ),
      //       //                 color: Color(0xffE74C3C),
      //       //             ),

      //       //           ],
      //       //         ),
      //       //       );
      //       //     },
      //       //     separatorBuilder: (c, i) => Divider(height: 10, color: Colors.transparent),
      //       //     itemCount: adminList.length,
      //       //   ),
      //       // ),
      //     ),

      //     SizedBox(height: 20,),

      //     Padding(padding: EdgeInsets.only(left: 20.0,), child: Text('Family', style: TextStyle(fontSize: 14, color: Color(0xff888888)),),),

      //     Expanded(
      //       child: Container(),
      //       // child: SmartRefresher(
      //       //   enablePullDown: true,
      //       //   enablePullUp: true,
      //       //   header: MaterialClassicHeader(
      //       //     color: Color(0xffffffff),
      //       //     backgroundColor: Color(0xff4EC9D4),
      //       //   ),
      //       //   footer: CustomFooter(
      //       //     loadStyle: LoadStyle.ShowWhenLoading,
      //       //     builder: (BuildContext context, LoadStatus mode){
      //       //       Widget body = Container();
      //       //       if(mode == LoadStatus.loading){
      //       //         body = CircularProgressIndicator();
      //       //       }
      //       //       return Center(child: body);
      //       //     },
      //       //   ),
      //       //   controller: refreshController,
      //       //   onRefresh: onRefresh,
      //       //   onLoading: onLoading2,
      //       //   child: ListView.separated(
      //       //     physics: ClampingScrollPhysics(),
      //       //     itemBuilder: (c, i) {
      //       //       return Container(
      //       //         padding: EdgeInsets.all(10.0),
      //       //         child: Row(
      //       //           children: [

      //       //             CircleAvatar(
      //       //               radius: 40,
      //       //               backgroundColor: Color(0xff888888), 
      //       //               backgroundImage: NetworkImage(familyList[i].image),
      //       //             ),

      //       //             SizedBox(width: 25,),

      //       //             Expanded(
      //       //               child: Container(
      //       //                 child: Column(
      //       //                   crossAxisAlignment: CrossAxisAlignment.start,
      //       //                   children: [
      //       //                     Text(familyList[i].firstName + ' ' + familyList[i].lastName, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xff000000)),),

      //       //                     Text(familyList[i].relationship, style: TextStyle(fontSize: 12, color: Color(0xff888888)),),
                                
      //       //                   ],
      //       //                 ),
      //       //               ),
      //       //             ),

      //       //             SizedBox(width: 25,),

      //       //             MaterialButton(
      //       //               minWidth: SizeConfig.screenWidth! / 3.5,
      //       //               padding: EdgeInsets.zero,
      //       //               textColor: Color(0xffffffff),
      //       //               splashColor: Color(0xff04ECFF),
      //       //               onPressed: () async{
      //       //                 context.showLoaderOverlay();
      //       //                 await apiRegularAddMemorialAdmin(pageType: 'Memorial', pageId: memorialId, userId: familyList[i].userId);
      //       //                 context.hideLoaderOverlay();

      //       //                 adminList = [];
      //       //                 familyList = [];
      //       //                 adminItemsRemaining = 1;
      //       //                 familyItemsRemaining = 1;
      //       //                 page1 = 1;
      //       //                 page2 = 1;
      //       //                 onLoading1();
      //       //                 onLoading2();
      //       //               },
      //       //               child: Text('Make Manager', style: TextStyle(fontSize: 14,),),
      //       //               height: 40,
      //       //               shape: StadiumBorder(
      //       //                 side: BorderSide(color: Color(0xff04ECFF)),
      //       //               ),
      //       //                 color: Color(0xff04ECFF),
      //       //             ),

      //       //           ],
      //       //         ),
      //       //       );
                  
      //       //     },
      //       //     separatorBuilder: (c, i) => Divider(height: 10, color: Colors.transparent),
      //       //     itemCount: familyList.length,
      //       //   ),
      //       // ),
      //     ),
      //   ],
      // ),
    );
  }
}