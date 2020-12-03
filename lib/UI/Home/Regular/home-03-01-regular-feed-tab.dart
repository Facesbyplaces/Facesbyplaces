import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-13-regular-post.dart';
import 'package:facesbyplaces/API/Regular/api-07-01-regular-home-feed-tab.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter/material.dart';

class HomeRegularFeedTab extends StatefulWidget{

  HomeRegularFeedTabState createState() => HomeRegularFeedTabState();
}

class HomeRegularFeedTabState extends State<HomeRegularFeedTab>{

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


