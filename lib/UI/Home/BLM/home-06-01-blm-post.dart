// import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-05-blm-post.dart';
// import 'package:facesbyplaces/API/BLM/api-14-01-blm-search-posts.dart';
// import 'package:facesbyplaces/Configurations/size_configuration.dart';
// import 'package:facesbyplaces/Configurations/date-conversion.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';
// import 'package:flutter/material.dart';

// class BLMSearchMainPosts{
//   int userId;
//   int postId;
//   int memorialId;
//   String memorialName;
//   String timeCreated;
//   String postBody;
//   dynamic profileImage;
//   List<dynamic> imagesOrVideos;

//   BLMSearchMainPosts({this.userId, this.postId, this.memorialId, this.memorialName, this.timeCreated, this.postBody, this.profileImage, this.imagesOrVideos});
// }

// class HomeBLMPostExtended extends StatefulWidget{

//   HomeBLMPostExtendedState createState() => HomeBLMPostExtendedState();
// }

// class HomeBLMPostExtendedState extends State<HomeBLMPostExtended>{

//   RefreshController refreshController = RefreshController(initialRefresh: true);
//   List<BLMSearchMainPosts> feeds = [];
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
//       var newValue = await apiBLMSearchPosts('Country', page);
//       itemRemaining = newValue.itemsRemaining;

//       for(int i = 0; i < newValue.familyMemorialList.length; i++){
//         feeds.add(BLMSearchMainPosts(
//           userId: newValue.familyMemorialList[i].page.pageCreator.id, 
//           postId: newValue.familyMemorialList[i].id,
//           memorialId: newValue.familyMemorialList[i].page.id,
//           timeCreated: newValue.familyMemorialList[i].createAt,
//           memorialName: newValue.familyMemorialList[i].page.name,
//           postBody: newValue.familyMemorialList[i].body,
//           profileImage: newValue.familyMemorialList[i].page.profileImage,
//           imagesOrVideos: newValue.familyMemorialList[i].page.imagesOrVideos,
//           ),    
//         );
//       }

//       if(mounted)
//       setState(() {});
      
//       refreshController.loadComplete();
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
//             // return Container(height: SizeConfig.screenHeight - kToolbarHeight, child: Center(child: body),);
//           },
//         ),
//         controller: refreshController,
//         onRefresh: onRefresh,
//         onLoading: onLoading,
//         child: ListView.separated(
//           padding: EdgeInsets.all(10.0),
//           physics: ClampingScrollPhysics(),
//           itemBuilder: (c, i) {
//             var container = GestureDetector(
//               onTap: (){
//                 Navigator.pushNamed(context, '/home/blm/home-31-blm-show-original-post');
//               },
//               child: Container(
//                 child: MiscBLMPost(
//                   userId: feeds[i].userId,
//                   postId: feeds[i].postId,
//                   memorialId: feeds[i].memorialId,
//                   memorialName: feeds[i].memorialName,
//                   timeCreated: convertDate(feeds[i].timeCreated),
//                   contents: [
//                     Column(
//                       children: [
//                         Align(
//                           alignment: Alignment.topLeft,
//                           child: RichText(
//                             maxLines: 4,
//                             overflow: TextOverflow.clip,
//                             textAlign: TextAlign.left,
//                             text: TextSpan(
//                               text: feeds[i].postBody,
//                               style: TextStyle(
//                                 fontWeight: FontWeight.w300,
//                                 color: Color(0xff000000),
//                               ),
//                             ),
//                           ),
//                         ),

//                         SizedBox(height: SizeConfig.blockSizeVertical * 1,),
//                       ],
//                     ),

//                     feeds[i].imagesOrVideos != null
//                     ? Container(
//                       height: SizeConfig.blockSizeHorizontal * 50,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.all(Radius.circular(5.0)),
//                       ),
//                       child: CachedNetworkImage(
//                         imageUrl: feeds[i].imagesOrVideos[0],
//                         placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
//                         errorWidget: (context, url, error) => Icon(Icons.error),
//                       ),
//                     )
//                     : Container(height: 0,),
//                   ],
//                 ),
//               ),
//             );

//             if(feeds.length != 0){
//               return container;
//             }else{
//               return Center(child: Text('Feed is empty.'),);
//             }
            
//           },
//           separatorBuilder: (c, i) => Divider(height: SizeConfig.blockSizeVertical * 2, color: Colors.transparent),
//           itemCount: feeds.length,
//         ),
//       )
//     );
//   }
// }