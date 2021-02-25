import 'package:facesbyplaces/API/Regular/02-Main/api-main-regular-04-03-home-post-tab.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-05-regular-post.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:better_player/better_player.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';

class RegularMainPagesPosts{
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

  RegularMainPagesPosts({
    this.userId, 
    this.postId, 
    this.memorialId, 
    this.memorialName, 
    this.timeCreated, 
    this.postBody, 
    this.profileImage, 
    this.imagesOrVideos, 
    this.managed,
    this.joined,
    this.numberOfLikes,
    this.numberOfComments,
    this.likeStatus,
    this.numberOfTagged, 
    this.taggedFirstName, 
    this.taggedLastName, 
    this.taggedImage, 
    this.taggedId,
    this.pageType, 
    this.famOrFriends, 
    this.relationship,
  });
}

class HomeRegularPostTab extends StatefulWidget{

  HomeRegularPostTabState createState() => HomeRegularPostTabState();
}

class HomeRegularPostTabState extends State<HomeRegularPostTab>{
  
  RefreshController refreshController = RefreshController(initialRefresh: true);
  List<RegularMainPagesPosts> posts;
  int itemRemaining;
  int page;
  int count;

  void initState(){
    super.initState();
    itemRemaining = 1;
    posts = [];
    page = 1;
    count = 0;
    onLoading();
  }

  void onRefresh() async{
    await Future.delayed(Duration(milliseconds: 1000));
    refreshController.refreshCompleted();
  }

  void onLoading() async{
    if(itemRemaining != 0){
      context.showLoaderOverlay();
      var newValue = await apiRegularHomePostTab(page: page);
      context.hideLoaderOverlay();

      itemRemaining = newValue.almItemsRemaining;
      count = count + newValue.familyMemorialList.length;

      for(int i = 0; i < newValue.familyMemorialList.length; i++){
        List<String> newList1 = [];
        List<String> newList2 = [];
        List<String> newList3 = [];
        List<int> newList4 = [];

        for(int j = 0; j < newValue.familyMemorialList[i].homeTabPostPostTagged.length; j++){
          newList1.add(newValue.familyMemorialList[i].homeTabPostPostTagged[j].homeTabPostTabTaggedFirstName);
          newList2.add(newValue.familyMemorialList[i].homeTabPostPostTagged[j].homeTabPostTabTaggedLastName);
          newList3.add(newValue.familyMemorialList[i].homeTabPostPostTagged[j].homeTabPostTabTaggedImage);
          newList4.add(newValue.familyMemorialList[i].homeTabPostPostTagged[j].homeTabPostTabTaggedId);
        }

        posts.add(
          RegularMainPagesPosts(
            userId: newValue.familyMemorialList[i].homeTabPostPage.homeTabPostPagePageCreator.homeTabPostPageCreatorId, 
            postId: newValue.familyMemorialList[i].homeTabPostId,
            memorialId: newValue.familyMemorialList[i].homeTabPostPage.homeTabPostPageId,
            timeCreated: newValue.familyMemorialList[i].homeTabPostCreateAt,
            memorialName: newValue.familyMemorialList[i].homeTabPostPage.homeTabPostPageName,
            postBody: newValue.familyMemorialList[i].homeTabPostBody,
            profileImage: newValue.familyMemorialList[i].homeTabPostPage.homeTabPostPageProfileImage,
            imagesOrVideos: newValue.familyMemorialList[i].homeTabPostImagesOrVideos,
            managed: newValue.familyMemorialList[i].homeTabPostPage.homeTabPostPageManage,
            joined: newValue.familyMemorialList[i].homeTabPostPage.homeTabPostPageFollower,
            numberOfComments: newValue.familyMemorialList[i].homeTabPostNumberOfComments,
            numberOfLikes: newValue.familyMemorialList[i].homeTabPostNumberOfLikes,
            likeStatus: newValue.familyMemorialList[i].homeTabPostLikeStatus,
            numberOfTagged: newValue.familyMemorialList[i].homeTabPostPostTagged.length,
            taggedFirstName: newList1,
            taggedLastName: newList2,
            taggedImage: newList3,
            taggedId: newList4,
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
      height: SizeConfig.screenHeight - 85 - kToolbarHeight,
      width: SizeConfig.screenWidth,
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
          shrinkWrap: true,
          itemBuilder: (c, i) {
            return MiscRegularPost(
              userId: posts[i].userId,
              postId: posts[i].postId,
              memorialId: posts[i].memorialId,
              memorialName: posts[i].memorialName,
              timeCreated: timeago.format(DateTime.parse(posts[i].timeCreated)),
              managed: posts[i].managed,
              joined: posts[i].joined,
              profileImage: posts[i].profileImage,
              numberOfComments: posts[i].numberOfComments,
              numberOfLikes: posts[i].numberOfLikes,
              likeStatus: posts[i].likeStatus,
              numberOfTagged: posts[i].numberOfTagged,
              taggedFirstName: posts[i].taggedFirstName,
              taggedLastName: posts[i].taggedLastName,
              taggedId: posts[i].taggedId,
              contents: [

                Container(alignment: Alignment.centerLeft, child: Text(posts[i].postBody, overflow: TextOverflow.ellipsis, maxLines: 5,),),

                SizedBox(height: 20),

                posts[i].imagesOrVideos != null
                ? Container(
                  height: 250, 
                  child: ((){
                    if(posts[i].imagesOrVideos != null){
                      if(posts[i].imagesOrVideos.length == 1){
                        if(lookupMimeType(posts[i].imagesOrVideos[0]).contains('video') == true){
                          return Container(
                            child: Stack(
                              children: [
                                BetterPlayer.network('${posts[i].imagesOrVideos[0]}',
                                  betterPlayerConfiguration: BetterPlayerConfiguration(
                                    controlsConfiguration: BetterPlayerControlsConfiguration(
                                      showControls: false,
                                    ),
                                    aspectRatio: 16 / 9,
                                  ),
                                ),

                                Center(
                                  child: CircleAvatar(
                                    backgroundColor: Color(0xff00000000),
                                    child: Icon(Icons.play_arrow_rounded, color: Color(0xffffffff),),
                                  ),
                                ),
                                
                              ],
                            ),
                            height: 250,
                          );
                        }else{
                          return Container(
                            child: CachedNetworkImage(
                              fit: BoxFit.contain,
                              height: 250,
                              width: 250,
                              imageUrl: posts[i].imagesOrVideos[0],
                              placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                              errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 1.0,),
                            ),
                          );
                        }
                      }else if(posts[i].imagesOrVideos.length == 2){
                        return StaggeredGridView.countBuilder(
                          padding: EdgeInsets.zero,
                          physics: NeverScrollableScrollPhysics(),
                          crossAxisCount: 4,
                          itemCount: 2,
                          itemBuilder: (BuildContext context, int index) =>  
                            lookupMimeType(posts[i].imagesOrVideos[index]).contains('video') == true
                            ? Container(
                              child: Stack(
                                children: [
                                BetterPlayer.network('${posts[i].imagesOrVideos[index]}',
                                  betterPlayerConfiguration: BetterPlayerConfiguration(
                                    controlsConfiguration: BetterPlayerControlsConfiguration(
                                      showControls: false,
                                    ),
                                    aspectRatio: 16 / 9,
                                  ),
                                ),

                                  Center(
                                    child: CircleAvatar(
                                      backgroundColor: Color(0xff00000000),
                                      child: Icon(Icons.play_arrow_rounded, color: Color(0xffffffff),),
                                    ),
                                  ),
                                  
                                ],
                              ),
                              height: 250,
                            )
                            : CachedNetworkImage(
                              fit: BoxFit.contain,
                              height: 250,
                              width: 250,
                              imageUrl: posts[i].imagesOrVideos[index],
                              placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                              errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 1.0,),
                            ),
                          staggeredTileBuilder: (int index) => StaggeredTile.count(2, 2),
                          mainAxisSpacing: 4.0,
                          crossAxisSpacing: 4.0,
                        );
                      }else{
                        return StaggeredGridView.countBuilder(
                          padding: EdgeInsets.zero,
                          physics: NeverScrollableScrollPhysics(),
                          crossAxisCount: 4,
                          itemCount: 3,
                          itemBuilder: (BuildContext context, int index) => 
                          ((){
                            if(index != 1){
                              return lookupMimeType(posts[i].imagesOrVideos[index]).contains('video') == true
                              ? Container(
                                child: Stack(
                                  children: [
                                    BetterPlayer.network(
                                      '${posts[i].imagesOrVideos[index]}',
                                      betterPlayerConfiguration: BetterPlayerConfiguration(
                                        controlsConfiguration: BetterPlayerControlsConfiguration(
                                          showControls: false,
                                        ),
                                        aspectRatio: 16 / 9,
                                      ),
                                    ),

                                    Center(
                                      child: CircleAvatar(
                                        backgroundColor: Color(0xff00000000),
                                        child: Icon(Icons.play_arrow_rounded, color: Color(0xffffffff),),
                                      ),
                                    ),
                                    
                                  ],
                                ),
                                height: 250,
                              )
                              : CachedNetworkImage(
                                fit: BoxFit.contain,
                                height: 250,
                                width: 250,
                                imageUrl: posts[i].imagesOrVideos[index],
                                placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                                errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 1.0,),
                              );
                              
                            }else{
                              return ((){
                                if(posts[i].imagesOrVideos.length - 3 > 0){
                                  if(lookupMimeType(posts[i].imagesOrVideos[index]).contains('video') == true){
                                    return Stack(
                                      children: [
                                        Container(
                                          child: Stack(
                                            children: [
                                              BetterPlayer.network(
                                                '${posts[i].imagesOrVideos[index]}',
                                                betterPlayerConfiguration: BetterPlayerConfiguration(
                                                  controlsConfiguration: BetterPlayerControlsConfiguration(
                                                    showControls: false,
                                                  ),
                                                  aspectRatio: 16 / 9,
                                                ),
                                              ),

                                              Center(
                                                child: CircleAvatar(
                                                  backgroundColor: Color(0xff00000000),
                                                  child: Icon(Icons.play_arrow_rounded, color: Color(0xffffffff),),
                                                ),
                                              ),
                                              
                                            ],
                                          ),
                                          height: 250,
                                        ),

                                        Container(color: Colors.black.withOpacity(0.5),),

                                        Center(
                                          child: CircleAvatar(
                                            radius: 25,
                                            backgroundColor: Color(0xffffffff).withOpacity(.5),
                                            child: Text(
                                              '${posts[i].imagesOrVideos.length - 3}',
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
                                  }else{
                                    return Stack(
                                      children: [
                                        CachedNetworkImage(
                                          fit: BoxFit.contain,
                                          height: 250,
                                          width: 250,
                                          imageUrl: posts[i].imagesOrVideos[index],
                                          placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                                          errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 1.0,),
                                        ),

                                        Container(color: Colors.black.withOpacity(0.5),),

                                        Center(
                                          child: CircleAvatar(
                                            radius: 25,
                                            backgroundColor: Color(0xffffffff).withOpacity(.5),
                                            child: Text(
                                              '${posts[i].imagesOrVideos.length - 3}',
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
                                }else{
                                  if(lookupMimeType(posts[i].imagesOrVideos[index]).contains('video') == true){
                                    return Container(
                                      child: Stack(
                                        children: [
                                          BetterPlayer.network('${posts[i].imagesOrVideos[index]}',
                                            betterPlayerConfiguration: BetterPlayerConfiguration(
                                              controlsConfiguration: BetterPlayerControlsConfiguration(
                                                showControls: false,
                                              ),
                                              aspectRatio: 16 / 9,
                                            ),
                                          ),

                                          Center(
                                            child: CircleAvatar(
                                              backgroundColor: Color(0xff00000000),
                                              child: Icon(Icons.play_arrow_rounded, color: Color(0xffffffff),),
                                            ),
                                          ),
                                          
                                        ],
                                      ),
                                      height: 250,
                                    );
                                  }else{
                                    return CachedNetworkImage(
                                      fit: BoxFit.contain,
                                      height: 250,
                                      width: 250,
                                      imageUrl: posts[i].imagesOrVideos[index],
                                      placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                                      errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 1.0,),
                                    );
                                  }
                                }
                              }());
                            }
                          }()),
                          staggeredTileBuilder: (int index) => StaggeredTile.count(2, index.isEven ? 1 : 2),
                          mainAxisSpacing: 4.0,
                          crossAxisSpacing: 4.0,
                        );
                      }
                    }else{
                      return Container(height: 0,);
                    }
                  }()),
                )
                : Container(height: 0),
              ]
            );
          },
          separatorBuilder: (c, i) => Divider(height: 20, color: Colors.transparent),
          itemCount: posts.length,
        ),
      )
      : SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              SizedBox(height: (SizeConfig.screenHeight - 85 - kToolbarHeight) / 3.5,),

              Image.asset('assets/icons/app-icon.png', height: 250, width: 250,),

              SizedBox(height: 45,),

              Text('Post is empty', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xffB1B1B1),),),

              SizedBox(height: (SizeConfig.screenHeight - 85 - kToolbarHeight) / 3.5,),
            ],
          ),
        ),
      ),
    );
  }
}


