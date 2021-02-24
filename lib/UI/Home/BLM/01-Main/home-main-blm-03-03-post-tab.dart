import 'package:better_player/better_player.dart';
import 'package:facesbyplaces/API/BLM/02-Main/api-main-blm-04-03-home-post-tab.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-05-blm-post.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mime/mime.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/material.dart';

class BLMMainPagesPosts{
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

  BLMMainPagesPosts({this.userId, this.postId, this.memorialId, this.memorialName, this.timeCreated, this.postBody, this.profileImage, this.imagesOrVideos, this.managed, this.joined, this.numberOfLikes, this.numberOfComments, this.likeStatus, this.numberOfTagged, this.taggedFirstName, this.taggedLastName, this.taggedImage, this.taggedId, this.pageType, this.famOrFriends, this.relationship});
}

class HomeBLMPostTab extends StatefulWidget{

  HomeBLMPostTabState createState() => HomeBLMPostTabState();
}

class HomeBLMPostTabState extends State<HomeBLMPostTab>{
  
  RefreshController refreshController = RefreshController(initialRefresh: true);
  List<BLMMainPagesPosts> posts;
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

      var newValue = await apiBLMHomePostTab(page: page);
      itemRemaining = newValue.blmItemsRemaining;
      count = count + newValue.blmFamilyMemorialList.length;

      for(int i = 0; i < newValue.blmFamilyMemorialList.length; i++){
        List<String> newList1 = [];
        List<String> newList2 = [];
        List<String> newList3 = [];
        List<int> newList4 = [];

        for(int j = 0; j < newValue.blmFamilyMemorialList[i].homeTabPostPostTagged.length; j++){
          newList1.add(newValue.blmFamilyMemorialList[i].homeTabPostPostTagged[j].homeTabPostTabTaggedFirstName);
          newList2.add(newValue.blmFamilyMemorialList[i].homeTabPostPostTagged[j].homeTabPostTabTaggedLastName);
          newList3.add(newValue.blmFamilyMemorialList[i].homeTabPostPostTagged[j].homeTabPostTabTaggedImage);
          newList4.add(newValue.blmFamilyMemorialList[i].homeTabPostPostTagged[j].homeTabPostTabTaggedId);
        }

        posts.add(BLMMainPagesPosts(
          userId: newValue.blmFamilyMemorialList[i].homeTabPostPage.homeTabPostPagePageCreator.homeTabPostPageCreatorId, 
          postId: newValue.blmFamilyMemorialList[i].homeTabPostId,
          memorialId: newValue.blmFamilyMemorialList[i].homeTabPostPage.homeTabPostPageId,
          timeCreated: newValue.blmFamilyMemorialList[i].homeTabPostCreatedAt,
          memorialName: newValue.blmFamilyMemorialList[i].homeTabPostPage.homeTabPostPageName,
          postBody: newValue.blmFamilyMemorialList[i].homeTabPostBody,
          profileImage: newValue.blmFamilyMemorialList[i].homeTabPostPage.homeTabPostPageProfileImage,
          imagesOrVideos: newValue.blmFamilyMemorialList[i].homeTabPostImagesOrVideos,
          managed: newValue.blmFamilyMemorialList[i].homeTabPostPage.homeTabPostPageManage,
          joined: newValue.blmFamilyMemorialList[i].homeTabPostPage.homeTabPostPageFollower,
          numberOfComments: newValue.blmFamilyMemorialList[i].homeTabPostNumberOfComments,
          numberOfLikes: newValue.blmFamilyMemorialList[i].homeTabPostNumberOfLikes,
          likeStatus: newValue.blmFamilyMemorialList[i].homeTabPostLikeStatus,
          numberOfTagged: newValue.blmFamilyMemorialList[i].homeTabPostPostTagged.length,
          taggedFirstName: newList1,
          taggedLastName: newList2,
          taggedImage: newList3,
          taggedId: newList4,
          pageType: newValue.blmFamilyMemorialList[i].homeTabPostPage.homeTabPostPagePageType,
          famOrFriends: newValue.blmFamilyMemorialList[i].homeTabPostPage.homeTabPostPageFamOrFriends,
          relationship: newValue.blmFamilyMemorialList[i].homeTabPostPage.homeTabPostPageRelationship,
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
          itemBuilder: (c, i) {
            return Container(
              child: MiscBLMPost(
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
                pageType: posts[i].pageType,
                famOrFriends: posts[i].famOrFriends,
                relationship: posts[i].relationship,
                contents: [
                  Container(alignment: Alignment.centerLeft, child: Text(posts[i].postBody, overflow: TextOverflow.ellipsis, maxLines: 5,),),

                  SizedBox(height: 45),

                  posts[i].imagesOrVideos != null
                                  ? Column(
                  children: [
                    SizedBox(height: 20),

                    Container(
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
                    ),
                  ],
                )
                : Container(height: 0),

                  // ? Container(
                  //   height: 240,
                  //   child: ((){
                  //     if(posts[i].imagesOrVideos != null){
                  //       if(posts[i].imagesOrVideos.length == 1){
                  //         return Container(
                  //           child: CachedNetworkImage(
                  //             fit: BoxFit.cover,
                  //             imageUrl: posts[i].imagesOrVideos[0],
                  //             placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                  //             errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                  //           ),
                  //         );
                  //       }else if(posts[i].imagesOrVideos.length == 2){
                  //         return StaggeredGridView.countBuilder(
                  //           padding: EdgeInsets.zero,
                  //           physics: NeverScrollableScrollPhysics(),
                  //           crossAxisCount: 4,
                  //           itemCount: 2,
                  //           itemBuilder: (BuildContext context, int index) => 
                  //             CachedNetworkImage(
                  //               fit: BoxFit.cover,
                  //               imageUrl: posts[i].imagesOrVideos[index],
                  //               placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                  //               errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                  //             ),
                  //           staggeredTileBuilder: (int index) => StaggeredTile.count(2, 2),
                  //           mainAxisSpacing: 4.0,
                  //           crossAxisSpacing: 4.0,
                  //         );
                  //       }else{
                  //         return Container(
                  //           child: StaggeredGridView.countBuilder(
                  //             padding: EdgeInsets.zero,
                  //             physics: NeverScrollableScrollPhysics(),
                  //             crossAxisCount: 4,
                  //             itemCount: 3,
                  //             itemBuilder: (BuildContext context, int index) => 
                  //               ((){
                  //                 if(index != 1){
                  //                   return CachedNetworkImage(
                  //                     fit: BoxFit.cover,
                  //                     imageUrl: posts[i].imagesOrVideos[index],
                  //                     placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                  //                     errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                  //                   );
                  //                 }else{
                  //                   return posts[i].imagesOrVideos.length - 3 == 0
                  //                   ? CachedNetworkImage(
                  //                     fit: BoxFit.cover,
                  //                     imageUrl: posts[i].imagesOrVideos[index],
                  //                     placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                  //                     errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                  //                   )
                  //                   : Stack(
                  //                     children: [
                  //                       CachedNetworkImage(
                  //                         fit: BoxFit.cover,
                  //                         imageUrl: posts[i].imagesOrVideos[index],
                  //                         placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                  //                         errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                  //                       ),

                  //                       Container(color: Colors.black.withOpacity(0.5),),

                  //                       Center(
                  //                         child: CircleAvatar(
                  //                           radius: 25,
                  //                           backgroundColor: Color(0xffffffff).withOpacity(.5),
                  //                           child: Text(
                  //                             '${posts[i].imagesOrVideos.length - 3}',
                  //                             style: TextStyle(
                  //                               fontSize: 40,
                  //                               fontWeight: FontWeight.bold,
                  //                               color: Color(0xffffffff),
                  //                             ),
                  //                           ),
                  //                         ),
                  //                       ),
                  //                     ],
                  //                   );
                  //                 }
                  //               }()),
                  //             staggeredTileBuilder: (int index) => StaggeredTile.count(2, index.isEven ? 1 : 2),
                  //             mainAxisSpacing: 4.0,
                  //             crossAxisSpacing: 4.0,
                  //           ),
                  //         );
                  //       }
                  //     }else{
                  //       return Container(height: 0,);
                  //     }
                  //   }()),
                  // )
                  // : Container(
                  //   color: Colors.red,
                  //   height: 0,
                  // ),
                ],
              ),
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


