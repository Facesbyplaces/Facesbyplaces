// // import 'package:facesbyplaces/Configurations/size_configuration.dart';
// // import 'package:flutter/material.dart';

// // class HomeBLMConnectionListFamily extends StatefulWidget{

// //   HomeBLMConnectionListFamilyState createState() => HomeBLMConnectionListFamilyState();
// // }

// // class HomeBLMConnectionListFamilyState extends State<HomeBLMConnectionListFamily>{

// //   void initState(){
// //     super.initState();
// //     // apiBLMSearchPosts('');
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     SizeConfig.init(context);
// //     return Container(
// //       padding: EdgeInsets.all(10.0),
// //       child: GridView.count(
// //         physics: ClampingScrollPhysics(),
// //         crossAxisSpacing: 2,
// //         mainAxisSpacing: 20,
// //         crossAxisCount: 4,
// //         children: List.generate(5, (index) => Column(
// //           children: [
// //             Expanded(child: CircleAvatar(radius: SizeConfig.blockSizeVertical * 5, backgroundImage: AssetImage('assets/icons/graveyard.png'), backgroundColor: Color(0xff888888),),),

// //             Text('Family ${index + 1}', textAlign: TextAlign.center, overflow: TextOverflow.clip, maxLines: 1, style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 3.5)),
// //           ],
// //         ),),
// //       ),
// //     );
// //   }
// // }



// import 'package:facesbyplaces/API/BLM/api-29-blm-connection-list-family.dart';
// import 'package:facesbyplaces/Configurations/size_configuration.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';
// import 'package:loader_overlay/loader_overlay.dart';
// import 'package:flutter/material.dart';

// class BLMConnectionListFamily{
//   final String firstName;
//   final String lastName;
//   final String image;

//   BLMConnectionListFamily({this.firstName, this.lastName, this.image});
// }

// class HomeBLMConnectionListFamily extends StatefulWidget{
//   final int memorialId;
//   HomeBLMConnectionListFamily({this.memorialId});

//   HomeBLMConnectionListFamilyState createState() => HomeBLMConnectionListFamilyState(memorialId: memorialId);
// }

// class HomeBLMConnectionListFamilyState extends State<HomeBLMConnectionListFamily>{
//   final int memorialId;
//   HomeBLMConnectionListFamilyState({this.memorialId});
  
//   RefreshController refreshController = RefreshController(initialRefresh: true);
//   List<BLMConnectionListFamily> lists = [];
//   Future connectionListFamily;
//   int itemRemaining = 1;
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
//     if(itemRemaining != 0){
//       context.showLoaderOverlay();

//       var newValue = await apiBLMConnectionListFamily(memorialId, page);
//       itemRemaining = newValue.itemsRemaining;

//       for(int i = 0; i < newValue.familyList.length; i++){
//         lists.add(
//           BLMConnectionListFamily(
//             firstName: newValue.familyList[i].user.firstName,
//             lastName: newValue.familyList[i].user.lastName,
//             image: newValue.familyList[i].user.image,
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
//       height: SizeConfig.screenHeight,
//       child: SmartRefresher(
//         enablePullDown: false,
//         enablePullUp: true,
//         header: MaterialClassicHeader(),
//         footer: CustomFooter(
//           loadStyle: LoadStyle.ShowWhenLoading,
//           builder: (BuildContext context, LoadStatus mode){
//             Widget body;
//             if(mode == LoadStatus.idle){
//               body =  Text('Pull up load.', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
//             }
//             else if(mode == LoadStatus.loading){
//               body =  CircularProgressIndicator();
//             }
//             else if(mode == LoadStatus.failed){
//               body = Text('Load Failed! Please try again.', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
//             }
//             else if(mode == LoadStatus.canLoading){
//               body = Text('Release to load more.', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
//               page++;
//             }
//             else{
//               body = Text('No more post.', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
//             }
//             return Container(height: 55.0, child: Center(child: body),);
//           },
//         ),
//         controller: refreshController,
//         onRefresh: onRefresh,
//         onLoading: onLoading,
//         child: Container(
//           padding: EdgeInsets.all(10.0),
//           child: GridView.count(
//             physics: ClampingScrollPhysics(),
//             crossAxisSpacing: 2,
//             mainAxisSpacing: 20,
//             crossAxisCount: 4,
//             children: List.generate(lists.length, (index) => Column(
//               children: [
//                 Expanded(child: CircleAvatar(radius: SizeConfig.blockSizeVertical * 5, backgroundImage: AssetImage('assets/icons/graveyard.png'), backgroundColor: Color(0xff888888),),),

//                 Text('Family ${index + 1}', textAlign: TextAlign.center, overflow: TextOverflow.clip, maxLines: 1, style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 3.5)),
//                 // Text('${lists[index].firstName + ' ' + lists[index].lastName}', textAlign: TextAlign.center, overflow: TextOverflow.clip, maxLines: 1, style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 3.5)),
//               ],
//             ),),
//           ),
//         ),


//         // child: ListView.separated(
//         //   padding: EdgeInsets.all(10.0),
//         //   shrinkWrap: true,
//         //   itemBuilder: (c, i) {
//         //     var container = GestureDetector(
//         //       onTap: (){
//         //         Navigator.pushNamed(context, '/home/blm/home-31-blm-show-original-post');
//         //       },
//         //       child: Container(
//         //         // child: MiscBLMPost(
//         //         //   userId: lists[i].userId,
//         //         //   postId: posts[i].postId,
//         //         //   memorialId: posts[i].memorialId,
//         //         //   memorialName: posts[i].memorialName,
//         //         //   timeCreated: convertDate(posts[i].timeCreated),
//         //         //   contents: [
//         //         //     Column(
//         //         //       children: [
//         //         //         Align(
//         //         //           alignment: Alignment.topLeft,
//         //         //           child: RichText(
//         //         //             maxLines: 4,
//         //         //             overflow: TextOverflow.clip,
//         //         //             textAlign: TextAlign.left,
//         //         //             text: TextSpan(
//         //         //               text: posts[i].postBody,
//         //         //               style: TextStyle(
//         //         //                 fontWeight: FontWeight.w300,
//         //         //                 color: Color(0xff000000),
//         //         //               ),
//         //         //             ),
//         //         //           ),
//         //         //         ),
//         //         //         SizedBox(height: SizeConfig.blockSizeVertical * 1,),
//         //         //       ],
//         //         //     ),

//         //         //     posts[i].imagesOrVideos != null
//         //         //     ? Container(
//         //         //       height: SizeConfig.blockSizeHorizontal * 50,
//         //         //       decoration: BoxDecoration(
//         //         //         borderRadius: BorderRadius.all(Radius.circular(5.0)),
//         //         //       ),
//         //         //       child: CachedNetworkImage(
//         //         //         imageUrl: posts[i].imagesOrVideos[0],
//         //         //         placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
//         //         //         errorWidget: (context, url, error) => Icon(Icons.error),
//         //         //       ),
//         //         //     )
//         //         //     : Container(height: 0,),
//         //         //   ],
//         //         // ),
//         //       ),
//         //     );

//         //     return container;
            
//         //   },
//         //   separatorBuilder: (c, i) => Divider(height: SizeConfig.blockSizeVertical * 2, color: Colors.transparent),
//         //   itemCount: lists.length,
//         // ),
//       )
//     );
//   }
// }




