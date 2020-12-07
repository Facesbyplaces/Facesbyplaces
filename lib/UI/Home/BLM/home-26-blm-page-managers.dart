import 'package:facesbyplaces/API/BLM/api-28-blm-page-managers.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class HomeBLMPageManagers extends StatefulWidget{
  final int memorialId;
  HomeBLMPageManagers({this.memorialId});

  HomeBLMPageManagersState createState() => HomeBLMPageManagersState(memorialId: memorialId);
}

class HomeBLMPageManagersState extends State<HomeBLMPageManagers>{
  final int memorialId;
  HomeBLMPageManagersState({this.memorialId});

  String convertDate(String input){
    DateTime dateTime = DateTime.parse(input);

    final y = dateTime.year.toString().padLeft(4, '0');
    final m = dateTime.month.toString().padLeft(2, '0');
    final d = dateTime.day.toString().padLeft(2, '0');
    return '$d/$m/$y';
  }

  Future pageManagers;

  void initState(){
    super.initState();
    pageManagers = getPageManagers();
  }

  Future<APIBLMSettingFamilyManagers> getPageManagers() async{
    return await apiBLMSettingFamilyManagers(memorialId, 1);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return WillPopScope(
      onWillPop: () async{
        return Navigator.canPop(context);
      },
      child: GestureDetector(
        onTap: (){
          FocusNode currentFocus = FocusScope.of(context);
          if(!currentFocus.hasPrimaryFocus){
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xff04ECFF),
            title: Text('Page Managers', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xffffffff)),),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Color(0xffffffff),), 
              onPressed: (){
                Navigator.pop(context);
              },
            ),
          ),
          body: FutureBuilder<APIBLMSettingFamilyManagers>(
            future: pageManagers,
            builder: (context, pageManager){
              if(pageManager.hasData){
                return Container(
                  height: SizeConfig.screenHeight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ListView.separated(
                          physics: ClampingScrollPhysics(),
                          itemBuilder: (context, index){
                            return Container(
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
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Danielle Roberts', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, fontWeight: FontWeight.bold, color: Color(0xff000000)),),
                                        // Text(pageManager.data.familyList[index].user.firstName, style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, fontWeight: FontWeight.bold, color: Color(0xff000000)),),

                                        Text('Mother', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 3.5, color: Color(0xff888888)),),
                                      ],
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
                          },
                          separatorBuilder: (context, index){
                            return Divider(height: SizeConfig.blockSizeVertical * 2,);
                          },
                          itemCount: 4,
                        ),
                      ),

                      SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                      Padding(padding: EdgeInsets.only(left: 20.0,), child: Text('Family', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 3.5, color: Color(0xff888888)),),),

                      Expanded(
                        child: ListView.separated(
                          physics: ClampingScrollPhysics(),
                          itemBuilder: (context, index){
                            return Container(
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
                                        Text('Danielle Roberts', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, fontWeight: FontWeight.bold, color: Color(0xff000000)),),

                                        Text('Mother', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 3.5, color: Color(0xff888888)),),
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
                          },
                          separatorBuilder: (context, index){
                            return Divider(height: SizeConfig.blockSizeVertical * 2,);
                          },
                          itemCount: 4,
                        ),
                      ),
                    ],
                  ),
                );
              }else if(pageManager.hasError){
                return Container(height: SizeConfig.screenHeight, child: Center(child: Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),),));
              }else{
                return Container(height: SizeConfig.screenHeight, child: Center(child: Container(child: SpinKitThreeBounce(color: Color(0xff000000), size: 50.0,), color: Color(0xffffffff),),),);
              }
            },
          ),


          // body: Container(
          //   height: SizeConfig.screenHeight,
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       Expanded(
          //         child: ListView.separated(
          //           physics: ClampingScrollPhysics(),
          //           itemBuilder: (context, index){
          //             return Container(
          //               padding: EdgeInsets.all(10.0),
          //               child: Row(
          //                 children: [
          //                   CircleAvatar(
          //                     maxRadius: SizeConfig.blockSizeVertical * 5,
          //                     backgroundColor: Color(0xff888888),
          //                     backgroundImage: AssetImage('assets/icons/graveyard.png'),
          //                   ),

          //                   SizedBox(width: SizeConfig.blockSizeHorizontal * 3,),

          //                   Expanded(
          //                     child: Column(
          //                       crossAxisAlignment: CrossAxisAlignment.start,
          //                       children: [
          //                         Text('Danielle Roberts', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, fontWeight: FontWeight.bold, color: Color(0xff000000)),),

          //                         Text('Mother', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 3.5, color: Color(0xff888888)),),
          //                       ],
          //                     ),
          //                   ),

          //                   SizedBox(width: SizeConfig.blockSizeHorizontal * 3,),

          //                   MaterialButton(
          //                     minWidth: SizeConfig.screenWidth / 3.5,
          //                     padding: EdgeInsets.zero,
          //                     textColor: Color(0xffffffff),
          //                     splashColor: Color(0xff04ECFF),
          //                     onPressed: () async{

          //                     },
          //                     child: Text('Remove', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 3.5,),),
          //                     height: SizeConfig.blockSizeVertical * 5,
          //                     shape: StadiumBorder(
          //                       side: BorderSide(color: Color(0xffE74C3C)),
          //                     ),
          //                       color: Color(0xffE74C3C),
          //                   ),
  

          //                 ],
          //               ),
          //             );
          //           },
          //           separatorBuilder: (context, index){
          //             return Divider(height: SizeConfig.blockSizeVertical * 2,);
          //           },
          //           itemCount: 4,
          //         ),
          //       ),

          //       SizedBox(height: SizeConfig.blockSizeVertical * 2,),

          //       Padding(padding: EdgeInsets.only(left: 20.0,), child: Text('Family', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 3.5, color: Color(0xff888888)),),),

          //       Expanded(
          //         child: ListView.separated(
          //           physics: ClampingScrollPhysics(),
          //           itemBuilder: (context, index){
          //             return Container(
          //               padding: EdgeInsets.all(10.0),
          //               child: Row(
          //                 children: [
          //                   CircleAvatar(
          //                     maxRadius: SizeConfig.blockSizeVertical * 5,
          //                     backgroundColor: Color(0xff888888),
          //                     backgroundImage: AssetImage('assets/icons/graveyard.png'),
          //                   ),

          //                   SizedBox(width: SizeConfig.blockSizeHorizontal * 3,),

          //                   Expanded(
          //                     child: Container(
          //                       child: Column(
          //                       crossAxisAlignment: CrossAxisAlignment.start,
          //                       children: [
          //                         Text('Danielle Roberts', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, fontWeight: FontWeight.bold, color: Color(0xff000000)),),

          //                         Text('Mother', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 3.5, color: Color(0xff888888)),),
          //                       ],
          //                     ),
          //                     ),
          //                   ),

          //                   SizedBox(width: SizeConfig.blockSizeHorizontal * 3,),

          //                   MaterialButton(
          //                     minWidth: SizeConfig.screenWidth / 3.5,
          //                     padding: EdgeInsets.zero,
          //                     textColor: Color(0xffffffff),
          //                     splashColor: Color(0xff04ECFF),
          //                     onPressed: () async{

          //                     },
          //                     child: Text('Make Manager', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 3.5,),),
          //                     height: SizeConfig.blockSizeVertical * 5,
          //                     shape: StadiumBorder(
          //                       side: BorderSide(color: Color(0xff04ECFF)),
          //                     ),
          //                       color: Color(0xff04ECFF),
          //                   ),
  
          //                 ],
          //               ),
          //             );
          //           },
          //           separatorBuilder: (context, index){
          //             return Divider(height: SizeConfig.blockSizeVertical * 2,);
          //           },
          //           itemCount: 4,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ),
      ),
    );
  }
}



// import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-04-blm-manage-memorial.dart';
// import 'package:facesbyplaces/API/BLM/api-07-02-blm-home-memorials-tab.dart';
// import 'package:facesbyplaces/Configurations/size_configuration.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';
// import 'package:loader_overlay/loader_overlay.dart';
// import 'package:flutter/material.dart';

// class HomeBLMManageTab extends StatefulWidget{

//   HomeBLMManageTabState createState() => HomeBLMManageTabState();
// }

// class HomeBLMManageTabState extends State<HomeBLMManageTab>{

//   RefreshController refreshController = RefreshController(initialRefresh: true);
//   // List<BLMMainPagesMemorials> memorialsFamily = [];
//   // List<BLMMainPagesMemorials> memorialsFriends = [];
//   // int blmFamilyItemsRemaining = 1;
//   // int blmFriendsItemsRemaining = 1;
//   int itemsRemaining = 1;
//   int page = 1;

//   void initState(){
//     super.initState();
//     onLoading1();
//     onLoading2();
//   }

//   void onRefresh() async{
//     await Future.delayed(Duration(milliseconds: 1000));
//     refreshController.refreshCompleted();
//   }

//   void onLoading1() async{
//     if(blmFamilyItemsRemaining != 0){
//       context.showLoaderOverlay();
//       var newValue = await apiBLMHomeMemorialsTab(page);
//       blmFamilyItemsRemaining = newValue.familyMemorialList.blmFamilyItemsRemaining;

//       for(int i = 0; i < newValue.familyMemorialList.blm.length; i++){
//         memorialsFamily.add(
//           BLMMainPagesMemorials(
//             memorialId: newValue.familyMemorialList.blm[i].id,
//             memorialName: newValue.familyMemorialList.blm[i].name,
//             memorialDescription: newValue.familyMemorialList.blm[i].details.description
//           ),
//         );
//       }

//       if(mounted)
//       setState(() {});
      
//       refreshController.loadComplete();
//       context.hideLoaderOverlay();
//     }else{
//       refreshController.loadNoData();
//     }
//   }

//   void onLoading2() async{
//     context.showLoaderOverlay();
//     if(blmFriendsItemsRemaining != 0){
//       var newValue = await apiBLMHomeMemorialsTab(page);
//       blmFriendsItemsRemaining = newValue.friendsMemorialList.blmFriendsItemsRemaining;

//       for(int i = 0; i < newValue.friendsMemorialList.blm.length; i++){
//         memorialsFriends.add(
//           BLMMainPagesMemorials(
//             memorialId: newValue.friendsMemorialList.blm[i].id,
//             memorialName: newValue.friendsMemorialList.blm[i].name,
//             memorialDescription: newValue.friendsMemorialList.blm[i].details.description
//           ),
//         );
//       }

//       if(mounted)
//       setState(() {});
      
//       refreshController.loadComplete();
//       context.hideLoaderOverlay();
//     }else{
//       refreshController.loadNoData();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     SizeConfig.init(context);
//     return Container(
//       height: SizeConfig.screenHeight - SizeConfig.blockSizeVertical * 13 - AppBar().preferredSize.height,
//       child: Column(
//         children: [
//           Container(
//             height: SizeConfig.blockSizeVertical * 10,
//             padding: EdgeInsets.only(left: 20.0, right: 20.0),
//             color: Color(0xffeeeeee),
//             child: Row(
//               children: [
//                 Expanded(child: Align(alignment: Alignment.centerLeft, child: Text('My Family', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, fontWeight: FontWeight.bold, color: Color(0xff000000),),),),),
                
//                 Expanded(
//                   child: GestureDetector(
//                     onTap: (){
//                       Navigator.pushNamed(context, '/home/blm/home-07-01-blm-create-memorial');
//                   },
//                   child: Align(alignment: Alignment.centerRight, child: Text('Create', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, fontWeight: FontWeight.bold, color: Color(0xff000000),),),),),
//                 ),
//               ],
//             ),
//           ),

//           Expanded(
//             child: SmartRefresher(
//               enablePullDown: false,
//               enablePullUp: true,
//               header: MaterialClassicHeader(),
//               footer: CustomFooter(
//                 loadStyle: LoadStyle.ShowWhenLoading,
//                 builder: (BuildContext context, LoadStatus mode){
//                   Widget body ;
//                   if(mode == LoadStatus.idle){
//                     body =  Text('Pull up load.', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
//                   }
//                   else if(mode == LoadStatus.loading){
//                     body =  CircularProgressIndicator();
//                   }
//                   else if(mode == LoadStatus.failed){
//                     body = Text('Load Failed! Please try again.', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
//                   }
//                   else if(mode == LoadStatus.canLoading){
//                     body = Text('Release to load more.', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
//                     page++;
//                   }
//                   else{
//                     body = Text('No more memorials.', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
//                   }
//                   return Container(height: 55.0, child: Center(child: body),);
//                 },
//               ),
//               controller: refreshController,
//               onRefresh: onRefresh,
//               onLoading: onLoading1,
//               child: ListView.separated(
//                 physics: ClampingScrollPhysics(),
//                 itemBuilder: (c, i) {
//                   var container = MiscBLMManageMemorialTab(
//                     index: i,
//                     memorialId: memorialsFamily[i].memorialId, 
//                     memorialName: memorialsFamily[i].memorialName, 
//                     description: memorialsFamily[i].memorialDescription,
//                   );

//                   return container;
                  
//                 },
//                 separatorBuilder: (c, i) => Divider(height: SizeConfig.blockSizeVertical * 1, color: Colors.transparent),
//                 itemCount: memorialsFamily.length,
//               ),
//             ),
//           ),

//           Container(
//             height: SizeConfig.blockSizeVertical * 10,
//             padding: EdgeInsets.only(left: 20.0, right: 20.0),
//             color: Color(0xffeeeeee),
//             child: Align(
//               alignment: Alignment.centerLeft,
//               child: Text('My Friends',
//                 style: TextStyle(
//                   fontSize: SizeConfig.safeBlockHorizontal * 4,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xff000000),
//                 ),
//               ),
//             ),
//           ),

//           Expanded(
//             child: SmartRefresher(
//               enablePullDown: false,
//               enablePullUp: true,
//               header: MaterialClassicHeader(),
//               footer: CustomFooter(
//                 loadStyle: LoadStyle.ShowWhenLoading,
//                 builder: (BuildContext context, LoadStatus mode){
//                   Widget body ;
//                   if(mode == LoadStatus.idle){
//                     body =  Text('Pull up load', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
//                   }
//                   else if(mode == LoadStatus.loading){
//                     body =  CircularProgressIndicator();
//                   }
//                   else if(mode == LoadStatus.failed){
//                     body = Text('Load Failed! Click retry!', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
//                   }
//                   else if(mode == LoadStatus.canLoading){
//                     body = Text('Release to load more', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
//                     page++;
//                   }
//                   else{
//                     body = Text('No more memorials.', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
//                   }
//                   return Container(height: 55.0, child: Center(child: body),);
//                 },
//               ),
//               controller: refreshController,
//               onRefresh: onRefresh,
//               onLoading: onLoading2,
//               child: ListView.separated(
//                 padding: EdgeInsets.all(10.0),
//                 physics: ClampingScrollPhysics(),
//                 itemBuilder: (c, i) {
//                   var container = MiscBLMManageMemorialTab(
//                     index: i,
//                     memorialId: memorialsFriends[i].memorialId, 
//                     memorialName: memorialsFriends[i].memorialName, 
//                     description: memorialsFriends[i].memorialDescription,
//                   );

//                   return container;
                  
//                 },
//                 separatorBuilder: (c, i) => Divider(height: SizeConfig.blockSizeVertical * 2, color: Colors.transparent),
//                 itemCount: memorialsFriends.length,
//               ),
//             ),
//           ),          
//         ],
//       ),
//     );
//   }
// }


