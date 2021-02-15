import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-07-blm-button.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-10-blm-image-display.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-05-blm-post.dart';
import 'package:facesbyplaces/API/BLM/02-Main/api-main-blm-04-01-home-feed-tab.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:timeago/timeago.dart' as timeago;
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

  BLMMainPagesFeeds({this.userId, this.postId, this.memorialId, this.memorialName, this.timeCreated, this.postBody, this.profileImage, this.imagesOrVideos, this.managed, this.joined, this.numberOfLikes, this.numberOfComments, this.likeStatus, this.numberOfTagged, this.taggedFirstName, this.taggedLastName, this.taggedImage, this.taggedId, this.pageType, this.famOrFriends, this.relationship});
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
    page = 1;
    itemRemaining = 1;
    count = 0;
    feeds = [];
    onLoading();
  }

  void onRefresh() async{
    await Future.delayed(Duration(milliseconds: 1000));
    refreshController.refreshCompleted();
  }

  void onLoading() async{
    if(itemRemaining != 0){
      context.showLoaderOverlay();
      var newValue = await apiBLMHomeFeedTab(page: page);
      context.hideLoaderOverlay();
      itemRemaining = newValue.blmItemsRemaining;
      count = newValue.blmFamilyMemorialList.length;

      for(int i = 0; i < newValue.blmFamilyMemorialList.length; i++){
        List<String> newList1 = [];
        List<String> newList2 = [];
        List<String> newList3 = [];
        List<int> newList4 = [];

        for(int j = 0; j < newValue.blmFamilyMemorialList[i].homeTabFeedPostTagged.length; j++){
          newList1.add(newValue.blmFamilyMemorialList[i].homeTabFeedPostTagged[j].homeTabFeedTaggedFirstName);
          newList2.add(newValue.blmFamilyMemorialList[i].homeTabFeedPostTagged[j].homeTabFeedTaggedLastName);
          newList3.add(newValue.blmFamilyMemorialList[i].homeTabFeedPostTagged[j].homeTabFeedTaggedImage);
          newList4.add(newValue.blmFamilyMemorialList[i].homeTabFeedPostTagged[j].homeTabFeedTaggedId);
        }

        feeds.add(
          BLMMainPagesFeeds(
            userId: newValue.blmFamilyMemorialList[i].homeTabFeedPage.homeTabFeedPagePageCreator.homeTabFeedPageCreatorId, 
            postId: newValue.blmFamilyMemorialList[i].homeTabFeedId,
            memorialId: newValue.blmFamilyMemorialList[i].homeTabFeedPage.homeTabFeedPageId,
            timeCreated: newValue.blmFamilyMemorialList[i].homeTabFeedCreatedAt,
            memorialName: newValue.blmFamilyMemorialList[i].homeTabFeedPage.homeTabFeedPageName,
            postBody: newValue.blmFamilyMemorialList[i].homeTabFeedBody,
            profileImage: newValue.blmFamilyMemorialList[i].homeTabFeedPage.homeTabFeedPageProfileImage,
            imagesOrVideos: newValue.blmFamilyMemorialList[i].homeTabFeedImagesOrVideos,
            managed: newValue.blmFamilyMemorialList[i].homeTabFeedPage.homeTabFeedPageManage,
            joined: newValue.blmFamilyMemorialList[i].homeTabFeedPage.homeTabFeedPageFollower,
            numberOfComments: newValue.blmFamilyMemorialList[i].homeTabFeedNumberOfComments,
            numberOfLikes: newValue.blmFamilyMemorialList[i].homeTabFeedNumberOfLikes,
            likeStatus: newValue.blmFamilyMemorialList[i].homeTabFeedLikeStatus,
            numberOfTagged: newValue.blmFamilyMemorialList[i].homeTabFeedPostTagged.length,
            taggedFirstName: newList1,
            taggedLastName: newList2,
            taggedImage: newList3,
            taggedId: newList4,
            pageType: newValue.blmFamilyMemorialList[i].homeTabFeedPage.homeTabFeedPagePageType,
            famOrFriends: newValue.blmFamilyMemorialList[i].homeTabFeedPage.homeTabFeedPageFamOrFriends,
            relationship: newValue.blmFamilyMemorialList[i].homeTabFeedPage.homeTabFeedPageRelationship,
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

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Container(
      height: SizeConfig.screenHeight - kToolbarHeight - 80,
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
            return MiscBLMPost(
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
                Container(alignment: Alignment.centerLeft, child: Text(feeds[i].postBody,),),

                SizedBox(height: 45,),

                feeds[i].imagesOrVideos != null
                ? Container(
                  height: 240,
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
                                          radius: 25,
                                          backgroundColor: Color(0xffffffff).withOpacity(.5),
                                          child: Text(
                                            '${feeds[i].imagesOrVideos.length - 3}',
                                            style: TextStyle(
                                              fontSize: 40,
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
          separatorBuilder: (c, i) => Divider(height: 20, color: Colors.transparent),
          itemCount: feeds.length,
        ),
      )
      : SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Column(
          children: [

            SizedBox(height: 45,),

            Align(
              alignment: Alignment.center,
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(text: 'Welcome to\n', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xff000000),),),

                    TextSpan(text: 'Faces by Places', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xff000000),),),
                  ],
                ),
              ),
            ),

            SizedBox(height: 25,),

            Container(
              width: SizeConfig.screenHeight,
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    top: 70,
                    child: MiscBLMImageDisplayFeedTemplate(frontSize: 65, backSize: 70,),
                  ),

                  Positioned(
                    right: 0,
                    top: 70,
                    child: MiscBLMImageDisplayFeedTemplate(frontSize: 65, backSize: 70, backgroundColor: Color(0xff04ECFF),),
                  ),

                  Positioned(
                    left: 50,
                    top: 50,
                    child: MiscBLMImageDisplayFeedTemplate(frontSize: 75, backSize: 80,),
                  ),

                  Positioned(
                    right: 50,
                    top: 50,
                    child: MiscBLMImageDisplayFeedTemplate(frontSize: 75, backSize: 80, backgroundColor: Color(0xff04ECFF),),
                  ),

                  Center(child: Image.asset('assets/icons/logo.png', height: 240, width: 240,),),
                ],
              ),
            ),

            SizedBox(height: 45,),

            Center(child: Text('Feed is empty', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xffB1B1B1),),),),

            SizedBox(height: 20,),

            Padding(padding: EdgeInsets.only(left: 20.0, right: 20.0), child: Center(child: Text('Create a memorial page for loved ones by sharing stories, special events and photos of special occasions. Keeping their memories alive for generations.', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: Color(0xff000000),),),),),

            SizedBox(height: 25,),

            MiscBLMButtonTemplate(
              buttonText: 'Create', 
              buttonTextStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold, 
                color: Color(0xffffffff),
              ), 
              onPressed: (){
                Navigator.pushNamed(context, '/home/blm/create-memorial');
              }, 
              width: SizeConfig.screenWidth / 2, 
              height: 45,
              buttonColor: Color(0xff000000),
            ),

            SizedBox(height: 20,),
            
          ],
        ),
      ),
    );
  }
}


