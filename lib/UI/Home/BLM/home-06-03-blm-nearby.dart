// import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-04-blm-manage-memorial.dart';
// import 'package:facesbyplaces/Configurations/size_configuration.dart';
// import 'package:facesbyplaces/API/BLM/api-26-blm-search-nearby.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';
// import 'package:flutter/material.dart';

// class BLMSearchMainNearby{
//   int memorialId;
//   String memorialName;
//   String memorialDescription;

//   BLMSearchMainNearby({this.memorialId, this.memorialName, this.memorialDescription});
// }


// class HomeBLMNearby extends StatefulWidget{

//   HomeBLMNearbyState createState() => HomeBLMNearbyState();
// }

// class HomeBLMNearbyState extends State<HomeBLMNearby>{

//   RefreshController refreshController = RefreshController(initialRefresh: true);
//   List<BLMSearchMainNearby> nearby = [];
//   int blmItemsRemaining = 1;
//   int memorialItemsRemaining = 1;
//   int page = 1;

//   void initState(){
//     super.initState();
//     onLoading();
//   }

//   void onRefresh() async{
//     await Future.delayed(Duration(milliseconds: 1000));
//     refreshController.refreshCompleted();
//   }

//   void onLoading() async{
//     final sharedPrefs = await SharedPreferences.getInstance();
//     double latitude = sharedPrefs.getDouble('blm-user-location-latitude');
//     double longitude = sharedPrefs.getDouble('blm-user-location-longitude');

//     print('the latitude is $latitude');
//     print('the longitude is $longitude');

//     if(blmItemsRemaining != 0){
//       var newValue = await apiBLMSearchNearby(page, latitude, longitude);
//       // var newValue = await apiBLMSearchNearby(page, 40.71, -100.23);
//       print('hereee!');

//       blmItemsRemaining = newValue.blmItemsRemaining;

//       for(int i = 0; i < newValue.blmList.length; i++){
//         nearby.add(BLMSearchMainNearby(
//           // memorialId: newValue.blmList[i].page.id,
//           memorialId: newValue.blmList[i].id,
//           memorialName: newValue.blmList[i].name,
//           memorialDescription: newValue.blmList[i].details.description,
//           ),    
//         );
//       }

//       if(mounted)
//       setState(() {});
      
//       refreshController.loadComplete();
//     }
//     else if(memorialItemsRemaining != 0){
//       var newValue = await apiBLMSearchNearby(page, latitude, longitude);
//       // var newValue = await apiBLMSearchNearby(page, 40.71, -100.23);
//       memorialItemsRemaining = newValue.memorialItemsRemaining;

//       for(int i = 0; i < newValue.memorialList.length; i++){
//         nearby.add(BLMSearchMainNearby(
//           memorialId: newValue.memorialList[i].id,
//           memorialName: newValue.memorialList[i].name,
//           memorialDescription: newValue.memorialList[i].details.description,
//           ),    
//         );
//       }

//       if(mounted)
//       setState(() {});
      
//       refreshController.loadComplete();
//     }
//     else{
//       refreshController.loadNoData();
//     }
//   }
 

//   @override
//   Widget build(BuildContext context) {
//     SizeConfig.init(context);
//     return Container(
//       height: SizeConfig.screenHeight,
//       child: SmartRefresher(
//         enablePullDown: false,
//         enablePullUp: true,
//         header: MaterialClassicHeader(),
//         footer: CustomFooter(
//           loadStyle: LoadStyle.ShowWhenLoading,
//           builder: (BuildContext context, LoadStatus mode){
//             Widget body ;
//             if(mode == LoadStatus.idle){
//               body =  Text('Pull up load', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
//             }
//             else if(mode == LoadStatus.loading){
//               body =  CircularProgressIndicator();
//             }
//             else if(mode == LoadStatus.failed){
//               body = Text('Load Failed! Click retry!', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
//             }
//             else if(mode == LoadStatus.canLoading){
//               body = Text('Release to load more', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
//               page++;
//             }
//             else{
//               body = Text('No more feed.', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
//             }
//             return Container(
//               height: 55.0,
//               child: Center(child :body),
//             );
//           },
//         ),
//         controller: refreshController,
//         onRefresh: onRefresh,
//         onLoading: onLoading,
//         child: ListView.separated(
//           physics: ClampingScrollPhysics(),
//           padding: EdgeInsets.all(10.0),
//           itemBuilder: (c, i) {

//             var container = MiscBLMManageMemorialTab(
//               index: i,
//               memorialId: nearby[i].memorialId, 
//               memorialName: nearby[i].memorialName, 
//               description: nearby[i].memorialDescription);

//             if(nearby.length != 0){
//               return container;
//             }else{
//               return Center(child: Text('Search is empty.'),);
//             }

//             // var container = MiscBLMManageMemorialTab(
//             //   index: i,
//             //   memorialId: nearby[i].memorialId, 
//             //   memorialName: nearby[i].memorialName, 
//             //   description: nearby[i].memorialDescription);

//             // if(nearby.length != 0){
//             //   return container;
//             // }else{
//             //   return Center(child: Text('Search is empty.'),);
//             // }

//             // return Container(height: SizeConfig.blockSizeVertical * 10,);
//           },
//           separatorBuilder: (c, i) => Divider(height: SizeConfig.blockSizeVertical * 2, color: Colors.transparent),
//           itemCount: nearby.length,
//           // itemCount: 4,
//         ),
//       )
//     );
//   }
// }