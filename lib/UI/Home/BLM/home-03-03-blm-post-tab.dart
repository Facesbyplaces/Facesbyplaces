import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-05-blm-post.dart';
import 'package:facesbyplaces/API/BLM/api-07-03-blm-home-post-tab.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/Configurations/date-conversion.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:loader_overlay/loader_overlay.dart';
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

  BLMMainPagesPosts({this.userId, this.postId, this.memorialId, this.memorialName, this.timeCreated, this.postBody, this.profileImage, this.imagesOrVideos});
}

class HomeBLMPostTab extends StatefulWidget{

  HomeBLMPostTabState createState() => HomeBLMPostTabState();
}

class HomeBLMPostTabState extends State<HomeBLMPostTab>{
  
  RefreshController refreshController = RefreshController(initialRefresh: true);
  List<BLMMainPagesPosts> posts = [];
  int itemRemaining = 1;
  int page = 1;

  void initState(){
    super.initState();
    onLoading();
  }

  void onRefresh() async{
    await Future.delayed(Duration(milliseconds: 1000));
    refreshController.refreshCompleted();
  }

  void onLoading() async{
    if(itemRemaining != 0){
      context.showLoaderOverlay();

      var newValue = await apiBLMHomePostTab(page);
      itemRemaining = newValue.itemsRemaining;

      for(int i = 0; i < newValue.familyMemorialList.length; i++){
        posts.add(BLMMainPagesPosts(
          userId: newValue.familyMemorialList[i].page.pageCreator.id, 
          postId: newValue.familyMemorialList[i].id,
          memorialId: newValue.familyMemorialList[i].page.id,
          timeCreated: newValue.familyMemorialList[i].createAt,
          memorialName: newValue.familyMemorialList[i].page.name,
          postBody: newValue.familyMemorialList[i].body,
          profileImage: newValue.familyMemorialList[i].page.profileImage,
          imagesOrVideos: newValue.familyMemorialList[i].page.imagesOrVideos,
          ),    
        );
      }

      if(mounted)
      setState(() {});
      
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
      height: SizeConfig.screenHeight,
      child: SmartRefresher(
        enablePullDown: false,
        enablePullUp: true,
        header: MaterialClassicHeader(),
        footer: CustomFooter(
          loadStyle: LoadStyle.ShowWhenLoading,
          builder: (BuildContext context, LoadStatus mode){
            Widget body;
            if(mode == LoadStatus.idle){
              body =  Text('Pull up load.', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
            }
            else if(mode == LoadStatus.loading){
              body =  CircularProgressIndicator();
            }
            else if(mode == LoadStatus.failed){
              body = Text('Load Failed! Please try again.', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
            }
            else if(mode == LoadStatus.canLoading){
              body = Text('Release to load more.', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
              page++;
            }
            else{
              body = Text('No more post.', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
            }
            return Container(height: 55.0, child: Center(child: body),);
          },
        ),
        controller: refreshController,
        onRefresh: onRefresh,
        onLoading: onLoading,
        child: ListView.separated(
          padding: EdgeInsets.all(10.0),
          shrinkWrap: true,
          itemBuilder: (c, i) {
            var container = GestureDetector(
              onTap: (){
                Navigator.pushNamed(context, '/home/blm/home-31-blm-show-original-post');
              },
              child: Container(
                child: MiscBLMPost(
                  userId: posts[i].userId,
                  postId: posts[i].postId,
                  memorialId: posts[i].memorialId,
                  memorialName: posts[i].memorialName,
                  timeCreated: convertDate(posts[i].timeCreated),
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
                              text: posts[i].postBody,
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

                    posts[i].imagesOrVideos != null
                    ? Container(
                      height: SizeConfig.blockSizeHorizontal * 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: posts[i].imagesOrVideos[0],
                        placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    )
                    : Container(height: 0,),
                  ],
                ),
              ),
            );

            return container;
            
          },
          separatorBuilder: (c, i) => Divider(height: SizeConfig.blockSizeVertical * 2, color: Colors.transparent),
          itemCount: posts.length,
        ),
      )
    );
  }
}


