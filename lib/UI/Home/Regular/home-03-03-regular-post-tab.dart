// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-13-regular-post.dart';
// import 'package:facesbyplaces/API/Regular/api-07-03-regular-home-post-tab.dart';
// import 'package:facesbyplaces/Configurations/size_configuration.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:flutter/material.dart';

// class HomeRegularPostTab extends StatefulWidget{

//   @override
//   HomeRegularPostTabState createState() => HomeRegularPostTabState();
// }

// class HomeRegularPostTabState extends State<HomeRegularPostTab>{

//   void initState(){
//     super.initState();
//     apiRegularHomePostTab(1);
//   }

//   @override
//   Widget build(BuildContext context) {
//     SizeConfig.init(context);
//     return FutureBuilder<APIRegularHomeTabPostMain>(
//       future: apiRegularHomePostTab(1),
//       builder: (context, postTab){
//         if(postTab.hasData){
//           if(postTab.data.familyMemorialList.length != 0){
//             return Container(
//               height: SizeConfig.screenHeight - SizeConfig.blockSizeVertical * 13 - AppBar().preferredSize.height,
//               child: ListView.separated(
//                 physics: ClampingScrollPhysics(),
//                 padding: EdgeInsets.all(10.0),
//                 itemCount: postTab.data.familyMemorialList.length,
//                 separatorBuilder: (context, index) => Divider(height: 0, color: Colors.transparent),
//                 itemBuilder: (context, index){
//                   return Column(
//                     children: [
//                       MiscRegularPost(
//                         userId: postTab.data.familyMemorialList[index].page.id,
//                         postId: postTab.data.familyMemorialList[index].id,
//                         memorialId: postTab.data.familyMemorialList[index].page.id,
//                         memorialName: postTab.data.familyMemorialList[index].page.name,
//                         profileImage: postTab.data.familyMemorialList[index].page.profileImage,
//                         contents: [
//                           Column(
//                             children: [
//                               Align(
//                                 alignment: Alignment.topLeft,
//                                 child: RichText(
//                                   maxLines: 4,
//                                   overflow: TextOverflow.clip,
//                                   textAlign: TextAlign.left,
//                                   text: TextSpan(
//                                     text: postTab.data.familyMemorialList[index].body,
//                                     style: TextStyle(
//                                       fontWeight: FontWeight.w300,
//                                       color: Color(0xff000000),
//                                     ),
//                                   ),
//                                 ),
//                               ),

//                               SizedBox(height: SizeConfig.blockSizeVertical * 1,),
//                             ],
//                           ),

//                           postTab.data.familyMemorialList[index].imagesOrVideos != null
//                           ? Container(
//                             height: SizeConfig.blockSizeHorizontal * 50,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.all(Radius.circular(5.0)),
//                             ),
//                             child: CachedNetworkImage(
//                               imageUrl: postTab.data.familyMemorialList[index].imagesOrVideos[0],
//                               placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
//                               errorWidget: (context, url, error) => Icon(Icons.error),
//                             ),
//                           )
//                           : Container(height: 0,),
//                         ],
//                       ),

//                       SizedBox(height: SizeConfig.blockSizeVertical * 1,),
//                     ],
//                   );
//                 }
//               ),
//             );
//           }else{
//             return Center(child: Text('Post is empty.', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),));
//           }
//         }else if(postTab.hasError){
//           return Center(child: Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),),);
//         }else{
//           return Container(child: Center(child: Container(child: SpinKitThreeBounce(color: Color(0xff000000), size: 50.0,), color: Color(0xffffffff),),),);
//         }
//       },
//     );
//   }
// }



import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-13-regular-post.dart';
import 'package:facesbyplaces/API/Regular/api-07-01-regular-home-feed-tab.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter/material.dart';

class HomeRegularPostTab extends StatefulWidget{

  HomeRegularPostTabState createState() => HomeRegularPostTabState();
}

class HomeRegularPostTabState extends State<HomeRegularPostTab>{

  int page = 1;
  int itemRemaining = 1;
  List<String> items = ["1", "2", "3", "4", "5", "6", "7", "8"];
  List<Widget> feeds = [];
  RefreshController refreshController = RefreshController(initialRefresh: true);

  void initState(){
    super.initState();
    onLoading();
  }

  String convertDate(String input){
    DateTime dateTime = DateTime.parse(input);

    final y = dateTime.year.toString().padLeft(4, '0');
    final m = dateTime.month.toString().padLeft(2, '0');
    final d = dateTime.day.toString().padLeft(2, '0');
    return '$d/$m/$y';
  }

  void onRefresh() async{
    await Future.delayed(Duration(milliseconds: 1000));
    refreshController.refreshCompleted();
  }

  void onLoading() async{
    if(itemRemaining != 0){
      var newValue = await apiRegularHomeFeedTab(page);
      itemRemaining = newValue.itemsRemaining;
      feeds.add(Column(
        children: [
          MiscRegularPost(
            userId: newValue.familyMemorialList[0].page.id,
            postId: newValue.familyMemorialList[0].id,
            memorialId: newValue.familyMemorialList[0].page.id,
            memorialName: newValue.familyMemorialList[0].page.name,
            profileImage: newValue.familyMemorialList[0].page.profileImage,
            timeCreated: convertDate(newValue.familyMemorialList[0].createAt),
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
                        text: newValue.familyMemorialList[0].body,
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


              newValue.familyMemorialList[0].imagesOrVideos != null
              ? Container(
                height: SizeConfig.blockSizeHorizontal * 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(newValue.familyMemorialList[0].imagesOrVideos[0]),
                  ),
                ),
              )
              : Container(height: 0,),
            ],
          ),

          SizedBox(height: SizeConfig.blockSizeVertical * 1,),
        ],
      ));
      if(mounted)
      setState(() {});
      
      refreshController.loadComplete();
    }else{
      refreshController.loadNoData();
    }
  }


  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Container(
      height: SizeConfig.screenHeight,
      child: SmartRefresher(
        enablePullDown: false,
        enablePullUp: true,
        header: MaterialClassicHeader(),
        footer: CustomFooter(
          loadStyle: LoadStyle.ShowWhenLoading,
          builder: (BuildContext context, LoadStatus mode){
            Widget body ;
            if(mode == LoadStatus.idle){
              body =  Text('Pull up load', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
            }
            else if(mode == LoadStatus.loading){
              body =  CircularProgressIndicator();
            }
            else if(mode == LoadStatus.failed){
              body = Text('Load Failed! Click retry!', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
            }
            else if(mode == LoadStatus.canLoading){
              body = Text('Release to load more', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
              page++;
            }
            else{
              body = Text('No more feed.', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
            }
            return Container(
              height: 55.0,
              child: Center(child:body),
            );
          },
        ),
        controller: refreshController,
        onRefresh: onRefresh,
        onLoading: onLoading,
        child: ListView.separated(
          padding: EdgeInsets.all(10.0),
          shrinkWrap: true,
          itemBuilder: (c, i) => feeds[i],
          separatorBuilder: (c, i) => Divider(height: SizeConfig.blockSizeVertical * 2, color: Colors.transparent),
          itemCount: feeds.length,
        ),
      )
    );
  }
}


