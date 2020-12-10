import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-07-blm-button.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-10-blm-image-display.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-05-blm-post.dart';
import 'package:facesbyplaces/API/BLM/api-07-01-blm-home-feed-tab.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/Configurations/date-conversion.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter/material.dart';

class BLMMainPagesFeeds{
  int userId;
  int postId;
  int memorialId;
  String memorialName;
  String timeCreated;
  String postBody;
  dynamic profileImage;
  List<dynamic> imagesOrVideos;
  bool joined;

  BLMMainPagesFeeds({this.userId, this.postId, this.memorialId, this.memorialName, this.timeCreated, this.postBody, this.profileImage, this.imagesOrVideos, this.joined});
}

class HomeBLMFeedTab extends StatefulWidget{

  HomeBLMFeedTabState createState() => HomeBLMFeedTabState();
}

class HomeBLMFeedTabState extends State<HomeBLMFeedTab>{
  
  RefreshController refreshController = RefreshController(initialRefresh: true);
  List<BLMMainPagesFeeds> feeds;
  int itemRemaining;
  int page;
  int count;

  void initState(){
    super.initState();
    onLoading();
    page = 1;
    itemRemaining = 1;
    count = 0;
    feeds = [];
  }

  void onRefresh() async{
    await Future.delayed(Duration(milliseconds: 1000));
    refreshController.refreshCompleted();
  }

  void onLoading() async{
    if(itemRemaining != 0){
      context.showLoaderOverlay();
      var newValue = await apiBLMHomeFeedTab(page);
      itemRemaining = newValue.itemsRemaining;
      count = newValue.familyMemorialList.length;

      for(int i = 0; i < newValue.familyMemorialList.length; i++){
        feeds.add(BLMMainPagesFeeds(
          userId: newValue.familyMemorialList[i].page.pageCreator.id, 
          postId: newValue.familyMemorialList[i].id,
          memorialId: newValue.familyMemorialList[i].page.id,
          timeCreated: newValue.familyMemorialList[i].createAt,
          memorialName: newValue.familyMemorialList[i].page.name,
          postBody: newValue.familyMemorialList[i].body,
          profileImage: newValue.familyMemorialList[i].page.profileImage,
          imagesOrVideos: newValue.familyMemorialList[i].page.imagesOrVideos,
          joined: newValue.familyMemorialList[i].page.follower,
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

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Container(
      height: SizeConfig.screenHeight - SizeConfig.blockSizeVertical * 13 - AppBar().preferredSize.height,
      child: count != 0
      ? SmartRefresher(
        enablePullDown: false,
        enablePullUp: true,
        header: MaterialClassicHeader(),
        footer: CustomFooter(
          loadStyle: LoadStyle.ShowWhenLoading,
          builder: (BuildContext context, LoadStatus mode){
            Widget body;
            if(mode == LoadStatus.idle){
              body = Text('Pull up load.', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
            }
            else if(mode == LoadStatus.loading){
              body = CircularProgressIndicator();
            }
            else if(mode == LoadStatus.failed){
              body = Text('Load Failed! Please try again.', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
            }
            else if(mode == LoadStatus.canLoading){
              body = Text('Release to load more.', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
            }
            else{
              body = Text('No more feed.', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
            }
            return Container(height: 55.0, child: Center(child: body),);
          },
        ),
        controller: refreshController,
        onRefresh: onRefresh,
        onLoading: onLoading,
        child: ListView.separated(
          padding: EdgeInsets.all(10.0),
          physics: ClampingScrollPhysics(),
          itemBuilder: (c, i) {
            var container = Container(
              child: MiscBLMPost(
                userId: feeds[i].userId,
                postId: feeds[i].postId,
                memorialId: feeds[i].memorialId,
                memorialName: feeds[i].memorialName,
                timeCreated: convertDate(feeds[i].timeCreated),
                joined: feeds[i].joined,
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
                            text: feeds[i].postBody,
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

                  feeds[i].imagesOrVideos != null
                  ? Container(
                    height: SizeConfig.blockSizeHorizontal * 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: feeds[i].imagesOrVideos[0],
                      placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  )
                  : Container(height: 0,),
                ],
              ),
            );
            
            return container;
          },
          separatorBuilder: (c, i) => Divider(height: SizeConfig.blockSizeVertical * 2, color: Colors.transparent),
          itemCount: feeds.length,
        ),
      )
      : Column(
        children: [

          SizedBox(height: SizeConfig.blockSizeVertical * 5,),

          Align(
            alignment: Alignment.center,
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(text: 'Welcome to\n', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 5, fontWeight: FontWeight.bold, color: Color(0xff000000),),),

                  TextSpan(text: 'Faces by Places', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 5, fontWeight: FontWeight.bold, color: Color(0xff000000),),),
                ],
              ),
            ),
          ),

          SizedBox(height: SizeConfig.blockSizeVertical * 3,),

          Container(
            width: SizeConfig.screenWidth,
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  top: SizeConfig.blockSizeVertical * 8,
                  child: MiscBLMImageDisplayFeedTemplate(frontSize: SizeConfig.blockSizeVertical * 7.5, backSize: SizeConfig.blockSizeVertical * 8,),
                ),

                Positioned(
                  right: 0,
                  top: SizeConfig.blockSizeVertical * 8,
                  child: MiscBLMImageDisplayFeedTemplate(frontSize: SizeConfig.blockSizeVertical * 7.5, backSize: SizeConfig.blockSizeVertical * 8, backgroundColor: Color(0xff04ECFF),),
                ),

                Positioned(
                  left: SizeConfig.blockSizeHorizontal * 12,
                  top: SizeConfig.blockSizeVertical * 6,
                  child: MiscBLMImageDisplayFeedTemplate(frontSize: SizeConfig.blockSizeVertical * 9.5, backSize: SizeConfig.blockSizeVertical * 10,),
                ),

                Positioned(
                  right: SizeConfig.blockSizeHorizontal * 12,
                  top: SizeConfig.blockSizeVertical * 6,
                  child: MiscBLMImageDisplayFeedTemplate(frontSize: SizeConfig.blockSizeVertical * 9.5, backSize: SizeConfig.blockSizeVertical * 10, backgroundColor: Color(0xff04ECFF),),
                ),

                Center(child: Image.asset('assets/icons/logo.png', height: SizeConfig.blockSizeVertical * 30, width: SizeConfig.blockSizeVertical * 25,),),
              ],
            ),
          ),

          SizedBox(height: SizeConfig.blockSizeVertical * 5,),

          Center(child: Text('Feed is empty', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 5, fontWeight: FontWeight.bold, color: Color(0xffB1B1B1),),),),

          SizedBox(height: SizeConfig.blockSizeVertical * 2,),

          Padding(padding: EdgeInsets.only(left: 20.0, right: 20.0), child: Center(child: Text('Create a memorial page for loved ones by sharing stories, special events and photos of special occasions. Keeping their memories alive for generations.', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),),),),

          SizedBox(height: SizeConfig.blockSizeVertical * 3,),

          MiscBLMButtonTemplate(
            buttonText: 'Create', 
            buttonTextStyle: TextStyle(
              fontSize: SizeConfig.safeBlockHorizontal * 5, 
              fontWeight: FontWeight.bold, 
              color: Color(0xffffffff),
            ), 
            onPressed: (){
              Navigator.pushNamed(context, '/home/blm/home-07-01-blm-create-memorial');
            }, 
            width: SizeConfig.screenWidth / 2, 
            height: SizeConfig.blockSizeVertical * 7, 
            buttonColor: Color(0xff04ECFF),
          ),
          
        ],
      ),
    );
  }
}


