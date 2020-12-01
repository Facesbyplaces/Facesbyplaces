import 'package:cached_network_image/cached_network_image.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-13-regular-post.dart';
import 'package:facesbyplaces/API/Regular/api-07-03-regular-home-post-tab.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';

class HomeRegularPostTab extends StatefulWidget{

  @override
  HomeRegularPostTabState createState() => HomeRegularPostTabState();
}

class HomeRegularPostTabState extends State<HomeRegularPostTab>{

  void initState(){
    super.initState();
    apiRegularHomePostTab(1);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return FutureBuilder<APIRegularHomeTabPostMain>(
      future: apiRegularHomePostTab(1),
      builder: (context, postTab){
        if(postTab.hasData){
          if(postTab.data.familyMemorialList.length != 0){
            return Container(
              height: SizeConfig.screenHeight - SizeConfig.blockSizeVertical * 13 - AppBar().preferredSize.height,
              child: ListView.separated(
                physics: ClampingScrollPhysics(),
                padding: EdgeInsets.all(10.0),
                itemCount: postTab.data.familyMemorialList.length,
                separatorBuilder: (context, index) => Divider(height: 0, color: Colors.transparent),
                itemBuilder: (context, index){
                  return Column(
                    children: [
                      MiscRegularPost(
                        userId: postTab.data.familyMemorialList[index].page.id,
                        postId: postTab.data.familyMemorialList[index].id,
                        memorialId: postTab.data.familyMemorialList[index].page.id,
                        memorialName: postTab.data.familyMemorialList[index].page.name,
                        profileImage: postTab.data.familyMemorialList[index].page.profileImage,
                        contents: [
                          Column(
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: RichText(
                                  maxLines: 4,
                                  overflow: TextOverflow.clip,
                                  textAlign: TextAlign.left,
                                  text: TextSpan(
                                    text: postTab.data.familyMemorialList[index].body,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      color: Color(0xff000000),
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(height: SizeConfig.blockSizeVertical * 1,),
                            ],
                          ),

                          postTab.data.familyMemorialList[index].imagesOrVideos != null
                          ? Container(
                            height: SizeConfig.blockSizeHorizontal * 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                            ),
                            child: CachedNetworkImage(
                              imageUrl: postTab.data.familyMemorialList[index].imagesOrVideos[0],
                              placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                              errorWidget: (context, url, error) => Icon(Icons.error),
                            ),
                          )
                          : Container(height: 0,),
                        ],
                      ),

                      SizedBox(height: SizeConfig.blockSizeVertical * 1,),
                    ],
                  );
                }
              ),
            );
          }else{
            return Center(child: Text('Post is empty.', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),));
          }
        }else if(postTab.hasError){
          return Center(child: Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),),);
        }else{
          return Container(child: Center(child: Container(child: SpinKitThreeBounce(color: Color(0xff000000), size: 50.0,), color: Color(0xffffffff),),),);
        }
      },
    );
  }
}




// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-13-regular-post.dart';
// import 'package:facesbyplaces/API/Regular/api-07-03-regular-home-post-tab.dart';
// import 'package:facesbyplaces/Configurations/size_configuration.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:flutter/material.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';

// class HomeRegularPostTab extends StatefulWidget{

//   @override
//   HomeRegularPostTabState createState() => HomeRegularPostTabState();
// }

// class HomeRegularPostTabState extends State<HomeRegularPostTab>{

  
//   // RefreshController refreshController = RefreshController(initialRefresh: true);
//   int page;
//   bool isLoading;
//   int count;

//  List<String> items = ["1", "2", "3", "4", "5", "6", "7", "8"];
//  List<Widget> posts = [];
//   RefreshController _refreshController = RefreshController(initialRefresh: true);

//   void _onRefresh() async{
//     // monitor network fetch
//     await Future.delayed(Duration(milliseconds: 1000));

//     setState(() {
//       page++;
//     });
//     // if failed,use refreshFailed()
//     _refreshController.refreshCompleted();
//   }

//   void _onLoading() async{
//     // monitor network fetch
//     // await Future.delayed(Duration(milliseconds: 1000));

//     APIRegularHomeTabPostMain newValue = await apiRegularHomePostTab(page);

//     print('The memorial name is ${newValue.familyMemorialList[0].page.name}');
//     print('The memorial name is ${newValue.familyMemorialList[1].page.name}');

//     posts.add(Column(
//       children: [
//         MiscRegularPost(
//           userId: newValue.familyMemorialList[0].page.id,
//           postId: newValue.familyMemorialList[0].id,
//           memorialId: newValue.familyMemorialList[0].page.id,
//           memorialName: newValue.familyMemorialList[0].page.name,
//           profileImage: newValue.familyMemorialList[0].page.profileImage,
//           contents: [
//             Column(
//               children: [
//                 Align(
//                   alignment: Alignment.topLeft,
//                   child: RichText(
//                     maxLines: 4,
//                     overflow: TextOverflow.clip,
//                     textAlign: TextAlign.left,
//                     text: TextSpan(
//                       text: newValue.familyMemorialList[0].body,
//                       style: TextStyle(
//                         fontWeight: FontWeight.w300,
//                         color: Color(0xff000000),
//                       ),
//                     ),
//                   ),
//                 ),

//                 SizedBox(height: SizeConfig.blockSizeVertical * 1,),
//               ],
//             ),

//             newValue.familyMemorialList[0].imagesOrVideos != null
//             ? Container(
//               height: SizeConfig.blockSizeHorizontal * 50,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.all(Radius.circular(5.0)),
//               ),
//               child: CachedNetworkImage(
//                 imageUrl: newValue.familyMemorialList[0].imagesOrVideos[0],
//                 placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
//                 errorWidget: (context, url, error) => Icon(Icons.error),
//               ),
//             )
//             : Container(height: 0,),
//           ],
//         ),

//         SizedBox(height: SizeConfig.blockSizeVertical * 1,),
//       ],
//     ));

//     posts.add(Column(
//       children: [
//         MiscRegularPost(
//           userId: newValue.familyMemorialList[1].page.id,
//           postId: newValue.familyMemorialList[1].id,
//           memorialId: newValue.familyMemorialList[1].page.id,
//           memorialName: newValue.familyMemorialList[1].page.name,
//           profileImage: newValue.familyMemorialList[1].page.profileImage,
//           contents: [
//             Column(
//               children: [
//                 Align(
//                   alignment: Alignment.topLeft,
//                   child: RichText(
//                     maxLines: 4,
//                     overflow: TextOverflow.clip,
//                     textAlign: TextAlign.left,
//                     text: TextSpan(
//                       text: newValue.familyMemorialList[1].body,
//                       style: TextStyle(
//                         fontWeight: FontWeight.w300,
//                         color: Color(0xff000000),
//                       ),
//                     ),
//                   ),
//                 ),

//                 SizedBox(height: SizeConfig.blockSizeVertical * 1,),
//               ],
//             ),

//             newValue.familyMemorialList[1].imagesOrVideos != null
//             ? Container(
//               height: SizeConfig.blockSizeHorizontal * 50,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.all(Radius.circular(5.0)),
//               ),
//               child: CachedNetworkImage(
//                 imageUrl: newValue.familyMemorialList[1].imagesOrVideos[1],
//                 placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
//                 errorWidget: (context, url, error) => Icon(Icons.error),
//               ),
//             )
//             : Container(height: 0,),
//           ],
//         ),

//         SizedBox(height: SizeConfig.blockSizeVertical * 1,),
//       ],
//     ));


//     // if failed,use loadFailed(),if no data return,use LoadNodata()
//     // items.add((items.length+1).toString());


//     // if(mounted)
//     // setState(() {

//     // });
//     _refreshController.loadComplete();
//   }

//   void initState(){
//     super.initState();
//     apiRegularHomePostTab(1);
//     page = 1;
//     isLoading = false;
//     count = 0;
//   }

//   @override
//   Widget build(BuildContext context) {
//     SizeConfig.init(context);
//     print('The length of posts is ${posts.length}');
//     return SmartRefresher(
//       enablePullDown: false,
//       enablePullUp: true,
//       header: MaterialClassicHeader(),
//       footer: CustomFooter(
//         builder: (BuildContext context,LoadStatus mode){
//           Widget body ;
//           if(mode==LoadStatus.idle){
//             body =  Text("pull up load");
//           }
//           else if(mode==LoadStatus.loading){
//             body =  CupertinoActivityIndicator();
//           }
//           else if(mode == LoadStatus.failed){
//             body = Text("Load Failed!Click retry!");
//           }
//           else if(mode == LoadStatus.canLoading){
//               body = Text("release to load more");
//           }
//           else{
//             body = Text("No more Data");
//           }
//           return Container(
//             height: 55.0,
//             child: Center(child:body),
//           );
//         },
//       ),
//       controller: _refreshController,
//       onRefresh: _onRefresh,
//       onLoading: _onLoading,
//       child: ListView.builder(
//         // itemBuilder: (c, i) => Card(child: Center(child: Text(items[i]))),

//         itemBuilder: (c, i) => posts.length == 0 ? Container() : posts[i],
//         itemExtent: 100.0,
//         itemCount: items.length,
//       ),
//     );
    
//     // return Container(
//     //   child: NotificationListener<ScrollNotification>(
//     //   onNotification: (ScrollNotification scrollInfo){
//     //     if(!isLoading && scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent){
//     //       if(count == 0){
//     //       // if(count > max){
//     //         print('The count is $count');
//     //         // print('The max is $max');
//     //         // newList.clear();

//     //         setState(() {
//     //           page++;
//     //           isLoading = true;
//     //         });
//     //       }else{
//     //         print('heheh');
//     //       }

//     //     }
//     //     return isLoading;
//     //   },
//     //   child: FutureBuilder<APIRegularHomeTabPostMain>(
//     //     future: apiRegularHomePostTab(page),
//     //     builder: (context, postTab){
//     //       count = postTab.data.itemsRemaining;
//     //       if(postTab.hasData){
//     //         if(postTab.data.familyMemorialList.length != 0){
//     //           return Container(
//     //             height: SizeConfig.screenHeight - SizeConfig.blockSizeVertical * 13 - AppBar().preferredSize.height,
//     //             child: ListView.separated(
//     //               physics: ClampingScrollPhysics(),
//     //               padding: EdgeInsets.all(10.0),
//     //               itemCount: postTab.data.familyMemorialList.length,
//     //               separatorBuilder: (context, index) => Divider(height: 0, color: Colors.transparent),
//     //               itemBuilder: (context, index){
//     //                 return Column(
//     //                   children: [
//     //                     MiscRegularPost(
//     //                       userId: postTab.data.familyMemorialList[index].page.id,
//     //                       postId: postTab.data.familyMemorialList[index].id,
//     //                       memorialId: postTab.data.familyMemorialList[index].page.id,
//     //                       memorialName: postTab.data.familyMemorialList[index].page.name,
//     //                       profileImage: postTab.data.familyMemorialList[index].page.profileImage,
//     //                       contents: [
//     //                         Column(
//     //                           children: [
//     //                             Align(
//     //                               alignment: Alignment.topLeft,
//     //                               child: RichText(
//     //                                 maxLines: 4,
//     //                                 overflow: TextOverflow.clip,
//     //                                 textAlign: TextAlign.left,
//     //                                 text: TextSpan(
//     //                                   text: postTab.data.familyMemorialList[index].body,
//     //                                   style: TextStyle(
//     //                                     fontWeight: FontWeight.w300,
//     //                                     color: Color(0xff000000),
//     //                                   ),
//     //                                 ),
//     //                               ),
//     //                             ),

//     //                             SizedBox(height: SizeConfig.blockSizeVertical * 1,),
//     //                           ],
//     //                         ),

//     //                         postTab.data.familyMemorialList[index].imagesOrVideos != null
//     //                         ? Container(
//     //                           height: SizeConfig.blockSizeHorizontal * 50,
//     //                           decoration: BoxDecoration(
//     //                             borderRadius: BorderRadius.all(Radius.circular(5.0)),
//     //                           ),
//     //                           child: CachedNetworkImage(
//     //                             imageUrl: postTab.data.familyMemorialList[index].imagesOrVideos[0],
//     //                             placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
//     //                             errorWidget: (context, url, error) => Icon(Icons.error),
//     //                           ),
//     //                         )
//     //                         : Container(height: 0,),
//     //                       ],
//     //                     ),

//     //                     SizedBox(height: SizeConfig.blockSizeVertical * 1,),
//     //                   ],
//     //                 );
//     //               }
//     //             ),
//     //           );
//     //         }else{
//     //           return Center(child: Text('Post is empty.', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),));
//     //         }
//     //       }else if(postTab.hasError){
//     //         return Center(child: Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),),);
//     //       }else{
//     //         return Container(child: Center(child: Container(child: SpinKitThreeBounce(color: Color(0xff000000), size: 50.0,), color: Color(0xffffffff),),),);
//     //       }
//     //     },
//     //   ),
//     // ),
//     // );
//   }
// }


