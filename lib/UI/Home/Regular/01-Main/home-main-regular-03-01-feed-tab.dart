import 'package:facesbyplaces/API/Regular/02-Main/api-main-regular-04-01-home-feed-tab.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-07-regular-button.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-05-regular-post.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-10-regular-image-display.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/material.dart';

class RegularMainPagesFeeds{
  int userId;
  int postId;
  int memorialId;
  String memorialName;
  String timeCreated;
  String postBody;
  dynamic profileImage;
  List<dynamic> imagesOrVideos;
  bool managed;
  bool joined;
  int numberOfLikes;
  int numberOfComments;
  bool likeStatus;
  int numberOfTagged;
  List<String> taggedFirstName;
  List<String> taggedLastName;
  List<String> taggedImage;
  List<int> taggedId;

  String pageType;
  bool famOrFriends;
  String relationship;

  RegularMainPagesFeeds({this.userId, this.postId, this.memorialId, this.memorialName, this.timeCreated, this.postBody, this.profileImage, this.imagesOrVideos, this.managed, this.joined, this.numberOfComments, this.numberOfLikes, this.likeStatus, this.numberOfTagged, this.taggedFirstName, this.taggedLastName, this.taggedImage, this.taggedId, this.pageType, this.famOrFriends, this.relationship});
}

class HomeRegularFeedTab extends StatefulWidget{

  HomeRegularFeedTabState createState() => HomeRegularFeedTabState();
}

class HomeRegularFeedTabState extends State<HomeRegularFeedTab>{
  
  RefreshController refreshController = RefreshController(initialRefresh: true);
  List<RegularMainPagesFeeds> feeds;
  int itemRemaining;
  int page;
  int count;

  void onRefresh() async{
    await Future.delayed(Duration(milliseconds: 1000));
    refreshController.refreshCompleted();
  }

  void onLoading() async{
    if(itemRemaining != 0){
      context.showLoaderOverlay();
      var newValue = await apiRegularHomeFeedTab(page: page);
      context.hideLoaderOverlay();
      itemRemaining = newValue.itemsRemaining;
      count = count + newValue.familyMemorialList.length;

      for(int i = 0; i < newValue.familyMemorialList.length; i++){
        List<String> newList1 = [];
        List<String> newList2 = [];
        List<String> newList3 = [];
        List<int> newList4 = [];
        for(int j = 0; j < newValue.familyMemorialList[i].postTagged.length; j++){
          newList1.add(newValue.familyMemorialList[i].postTagged[j].taggedFirstName);
          newList2.add(newValue.familyMemorialList[i].postTagged[j].taggedLastName);
          newList3.add(newValue.familyMemorialList[i].postTagged[j].taggedImage);
          newList4.add(newValue.familyMemorialList[i].postTagged[j].taggedId);
        }

        feeds.add(RegularMainPagesFeeds(
          userId: newValue.familyMemorialList[i].page.pageCreator.id, 
          postId: newValue.familyMemorialList[i].id,
          memorialId: newValue.familyMemorialList[i].page.id,
          timeCreated: newValue.familyMemorialList[i].createAt,
          memorialName: newValue.familyMemorialList[i].page.name,
          postBody: newValue.familyMemorialList[i].body,
          profileImage: newValue.familyMemorialList[i].page.profileImage,
          imagesOrVideos: newValue.familyMemorialList[i].imagesOrVideos,
          managed: newValue.familyMemorialList[i].page.manage,
          joined: newValue.familyMemorialList[i].page.follower,
          
          numberOfComments: newValue.familyMemorialList[i].numberOfComments,
          numberOfLikes: newValue.familyMemorialList[i].numberOfLikes,
          likeStatus: newValue.familyMemorialList[i].likeStatus,

          numberOfTagged: newValue.familyMemorialList[i].postTagged.length,
          taggedFirstName: newList1,
          taggedLastName: newList2,
          taggedImage: newList3,
          taggedId: newList4,

          pageType: newValue.familyMemorialList[i].page.pageType,
          famOrFriends: newValue.familyMemorialList[i].page.famOrFriends,
          relationship: newValue.familyMemorialList[i].page.relationship,
          ),    
        );
      }

      if(mounted)
      setState(() {});
      page++;
      
      refreshController.loadComplete();
    }else{
      refreshController.loadNoData();
    }
  }

  void initState(){
    super.initState();
    itemRemaining = 1;
    feeds = [];
    page = 1;
    count = 0;
    onLoading();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    ResponsiveWidgets.init(context,
      height: SizeConfig.screenHeight,
      width: SizeConfig.screenWidth,
    );
    return Container(
      height: SizeConfig.screenHeight - SizeConfig.blockSizeVertical * 13 - AppBar().preferredSize.height,
      child: count != 0
      ? SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: MaterialClassicHeader(
          color: Color(0xffffffff),
          backgroundColor: Color(0xff4EC9D4),
        ),
        footer: CustomFooter(
          loadStyle: LoadStyle.ShowWhenLoading,
          builder: (BuildContext context, LoadStatus mode){
            Widget body;
            if(mode == LoadStatus.loading){
              body = CircularProgressIndicator();
            }
            return Center(child: body);
          },
        ),
        controller: refreshController,
        onRefresh: onRefresh,
        onLoading: onLoading,
        child: ListView.separated(
          padding: EdgeInsets.all(10.0),
          physics: ClampingScrollPhysics(),
          itemBuilder: (c, i) {
            return MiscRegularPost(
              userId: feeds[i].userId,
              postId: feeds[i].postId,
              memorialId: feeds[i].memorialId,
              memorialName: feeds[i].memorialName,
              timeCreated: timeago.format(DateTime.parse(feeds[i].timeCreated)),

              managed: feeds[i].managed,
              joined: feeds[i].joined,
              profileImage: feeds[i].profileImage,
              numberOfComments: feeds[i].numberOfComments,
              numberOfLikes: feeds[i].numberOfLikes,
              likeStatus: feeds[i].likeStatus,

              numberOfTagged: feeds[i].numberOfTagged,
              taggedFirstName: feeds[i].taggedFirstName,
              taggedLastName: feeds[i].taggedLastName,
              taggedId: feeds[i].taggedId,

              pageType: feeds[i].pageType,
              famOrFriends: feeds[i].famOrFriends,
              relationship: feeds[i].relationship,
              
              contents: [
                Container(alignment: Alignment.centerLeft, child: Text(feeds[i].postBody, overflow: TextOverflow.ellipsis, maxLines: 5,),),

                feeds[i].imagesOrVideos != null
                ? Container(
                  height: SizeConfig.blockSizeVertical * 30,
                  child: ((){
                    if(feeds[i].imagesOrVideos != null){
                      if(feeds[i].imagesOrVideos.length == 1){
                        return Container(
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: feeds[i].imagesOrVideos[0],
                            placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                            errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                          ),
                        );
                      }else if(feeds[i].imagesOrVideos.length == 2){
                        return StaggeredGridView.countBuilder(
                          padding: EdgeInsets.zero,
                          physics: NeverScrollableScrollPhysics(),
                          crossAxisCount: 4,
                          itemCount: 2,
                          itemBuilder: (BuildContext context, int index) => 
                            CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: feeds[i].imagesOrVideos[index],
                              placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                              errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                            ),
                          staggeredTileBuilder: (int index) => StaggeredTile.count(2, 2),
                          mainAxisSpacing: 4.0,
                          crossAxisSpacing: 4.0,
                        );
                      }else{
                        return Container(
                          child: StaggeredGridView.countBuilder(
                            padding: EdgeInsets.zero,
                            physics: NeverScrollableScrollPhysics(),
                            crossAxisCount: 4,
                            itemCount: 3,
                            itemBuilder: (BuildContext context, int index) => 
                              ((){
                                if(index != 1){
                                  return CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl: feeds[i].imagesOrVideos[index],
                                    placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                                    errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                  );
                                }else{
                                  return feeds[i].imagesOrVideos.length - 3 == 0
                                  ? CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl: feeds[i].imagesOrVideos[index],
                                    placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                                    errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                  )
                                  : Stack(
                                    children: [
                                      CachedNetworkImage(
                                        fit: BoxFit.cover,
                                        imageUrl: feeds[i].imagesOrVideos[index],
                                        placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                                        errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                      ),

                                      Container(color: Colors.black.withOpacity(0.5),),

                                      Center(
                                        child: CircleAvatar(
                                          radius: SizeConfig.blockSizeVertical * 3,
                                          backgroundColor: Color(0xffffffff).withOpacity(.5),
                                          child: Text(
                                            '${feeds[i].imagesOrVideos.length - 3}',
                                            style: TextStyle(
                                              fontSize: SizeConfig.safeBlockHorizontal * 7,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xffffffff),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }
                              }()),
                            staggeredTileBuilder: (int index) => StaggeredTile.count(2, index.isEven ? 1 : 2),
                            mainAxisSpacing: 4.0,
                            crossAxisSpacing: 4.0,
                          ),
                        );
                      }
                    }else{
                      return Container(height: 0,);
                    }
                  }()),
                )
                : Container(
                  color: Colors.red,
                  height: 0,
                ),
              ],
            );
            
          },
          separatorBuilder: (c, i) => Divider(height: SizeConfig.blockSizeVertical * 2, color: Colors.transparent),
          itemCount: feeds.length,
        ),
      )
      : ContainerResponsive(
        height: SizeConfig.screenHeight,
        width: SizeConfig.screenWidth,
        alignment: Alignment.center,
        child: ContainerResponsive(
          width: SizeConfig.screenWidth,
          heightResponsive: false,
          widthResponsive: true,
          alignment: Alignment.center,
          child: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Column(
              children: [

                SizedBox(height: ScreenUtil().setHeight(45)),

                Align(
                  alignment: Alignment.center,
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: <TextSpan>[

                        TextSpan(text: 'Welcome to\n', style: TextStyle(fontSize: ScreenUtil().setSp(20, allowFontScalingSelf: true), fontWeight: FontWeight.bold, color: Color(0xff000000),),),

                        TextSpan(text: 'Faces by Places', style: TextStyle(fontSize: ScreenUtil().setSp(20, allowFontScalingSelf: true), fontWeight: FontWeight.bold, color: Color(0xff000000),),),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: ScreenUtil().setHeight(25)),

                ContainerResponsive(
                  width: SizeConfig.screenHeight,
                  heightResponsive: false,
                  widthResponsive: true,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: SizeConfig.blockSizeVertical * 8,
                        child: MiscRegularImageDisplayFeedTemplate(frontSize: SizeConfig.blockSizeVertical * 7.5, backSize: SizeConfig.blockSizeVertical * 8,),
                      ),

                      Positioned(
                        right: 0,
                        top: SizeConfig.blockSizeVertical * 8,
                        child: MiscRegularImageDisplayFeedTemplate(frontSize: SizeConfig.blockSizeVertical * 7.5, backSize: SizeConfig.blockSizeVertical * 8, backgroundColor: Color(0xff04ECFF),),
                      ),

                      Positioned(
                        left: SizeConfig.blockSizeHorizontal * 12,
                        top: SizeConfig.blockSizeVertical * 6,
                        child: MiscRegularImageDisplayFeedTemplate(frontSize: SizeConfig.blockSizeVertical * 9.5, backSize: SizeConfig.blockSizeVertical * 10,),
                      ),

                      Positioned(
                        right: SizeConfig.blockSizeHorizontal * 12,
                        top: SizeConfig.blockSizeVertical * 6,
                        child: MiscRegularImageDisplayFeedTemplate(frontSize: SizeConfig.blockSizeVertical * 9.5, backSize: SizeConfig.blockSizeVertical * 10, backgroundColor: Color(0xff04ECFF),),
                      ),

                      Center(child: Image.asset('assets/icons/logo.png', height: SizeConfig.blockSizeVertical * 30, width: SizeConfig.blockSizeVertical * 25,),),
                    ],
                  ),
                ),

                SizedBox(height: ScreenUtil().setHeight(45)),

                Center(child: Text('Feed is empty', style: TextStyle(fontSize: ScreenUtil().setSp(20, allowFontScalingSelf: true), fontWeight: FontWeight.bold, color: Color(0xffB1B1B1),),),),

                SizedBox(height: ScreenUtil().setHeight(20)),

                Padding(padding: EdgeInsets.only(left: 20.0, right: 20.0), child: Center(child: Text('Create a memorial page for loved ones by sharing stories, special events and photos of special occasions. Keeping their memories alive for generations.', textAlign: TextAlign.center, style: TextStyle(fontSize: ScreenUtil().setSp(16, allowFontScalingSelf: true), color: Color(0xff000000),),),),),

                SizedBox(height: ScreenUtil().setHeight(25)),

                MiscRegularButtonTemplate(
                  buttonText: 'Create', 
                  buttonTextStyle: TextStyle(
                    fontSize: ScreenUtil().setSp(16, allowFontScalingSelf: true),
                    fontWeight: FontWeight.bold, 
                    color: Color(0xffffffff),
                  ), 
                  onPressed: (){
                    Navigator.pushNamed(context, '/home/regular/create-memorial');
                  }, 
                  width: SizeConfig.screenWidth / 2, 
                  height: ScreenUtil().setHeight(45),
                  buttonColor: Color(0xff04ECFF),
                ),

                SizedBox(height: ScreenUtil().setHeight(20)),
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}


