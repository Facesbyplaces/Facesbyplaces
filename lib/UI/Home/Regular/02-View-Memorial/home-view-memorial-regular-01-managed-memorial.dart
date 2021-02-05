import 'package:facesbyplaces/UI/Home/Regular/08-Settings-Memorial/home-settings-memorial-regular-08-memorial-settings-with-hidden.dart';
import 'package:facesbyplaces/UI/Home/Regular/04-Create-Post/home-create-post-regular-01-create-post.dart';
import 'package:facesbyplaces/UI/Home/Regular/08-Settings-Memorial/home-settings-memorial-regular-01-memorial-settings.dart';
import 'package:facesbyplaces/API/Regular/03-View-Memorial/api-view-memorial-regular-02-show-profile-post.dart';
import 'package:facesbyplaces/API/Regular/03-View-Memorial/api-view-memorial-regular-01-show-memorial-details.dart';
import 'package:facesbyplaces/API/Regular/03-View-Memorial/api-view-memorial-regular-03-show-switch-status.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-05-regular-post.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-09-regular-message.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-14-regular-empty-display.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
// import 'package:responsive_widgets/responsive_widgets.dart';
import 'home-view-memorial-regular-03-connection-list.dart';
import 'package:full_screen_menu/full_screen_menu.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:path_provider/path_provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:typed_data';
import 'dart:async';
import 'dart:io';

class RegularProfilePosts{
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

  RegularProfilePosts({this.userId, this.postId, this.memorialId, this.memorialName, this.timeCreated, this.postBody, this.profileImage, this.imagesOrVideos, this.managed, this.joined, this.numberOfComments, this.numberOfLikes, this.likeStatus, this.numberOfTagged, this.taggedFirstName, this.taggedLastName, this.taggedImage, this.taggedId, this.pageType, this.famOrFriends, this.relationship});
}

class HomeRegularProfile extends StatefulWidget{
  final int memorialId;
  final String relationship;
  final bool managed;
  HomeRegularProfile({this.memorialId, this.relationship, this.managed,});

  HomeRegularProfileState createState() => HomeRegularProfileState(memorialId: memorialId, relationship: relationship, managed: managed);
}

class HomeRegularProfileState extends State<HomeRegularProfile>{
  final int memorialId;
  final String relationship;
  final bool managed;
  HomeRegularProfileState({this.memorialId, this.relationship, this.managed,});

  RefreshController refreshController = RefreshController(initialRefresh: true);
  TextEditingController controller = TextEditingController();
  List<RegularProfilePosts> posts;
  Future showProfile;
  GlobalKey dataKey;
  int itemRemaining;
  int postCount;
  bool empty;
  int page;
  BranchUniversalObject buo;
  BranchLinkProperties lp;
  VideoPlayerController videoPlayerController;

  void onRefresh() async{
    await Future.delayed(Duration(milliseconds: 1000));
    refreshController.refreshCompleted();
  }  

  void onLoading() async{
    if(itemRemaining != 0){
      var newValue = await apiRegularProfilePost(memorialId: memorialId, page: page);

      itemRemaining = newValue.almItemsRemaining;
      postCount = newValue.almFamilyMemorialList.length;

      List<String> newList1 = [];
      List<String> newList2 = [];
      List<String> newList3 = [];
      List<int> newList4 = [];

      for(int i = 0; i < newValue.almFamilyMemorialList.length; i++){
        for(int j = 0; j < newValue.almFamilyMemorialList[i].homeProfilePostTagged.length; j++){
          newList1.add(newValue.almFamilyMemorialList[i].homeProfilePostTagged[j].homeProfilePostTaggedFirstName);
          newList2.add(newValue.almFamilyMemorialList[i].homeProfilePostTagged[j].homeProfilePostTaggedLastName);
          newList3.add(newValue.almFamilyMemorialList[i].homeProfilePostTagged[j].homeProfilePostTaggedImage);
          newList4.add(newValue.almFamilyMemorialList[i].homeProfilePostTagged[j].homeProfilePostTaggedId);
        }

        posts.add(
          RegularProfilePosts(
            userId: newValue.almFamilyMemorialList[i].homeProfilePostPage.homeProfilePostPagePageCreator.homeProfilePostPageCreatorId, 
            postId: newValue.almFamilyMemorialList[i].homeProfilePostId,
            memorialId: newValue.almFamilyMemorialList[i].homeProfilePostPage.homeProfilePostPageId,
            timeCreated: newValue.almFamilyMemorialList[i].homeProfilePostCreatedAt,
            memorialName: newValue.almFamilyMemorialList[i].homeProfilePostPage.homeProfilePostPageName,
            postBody: newValue.almFamilyMemorialList[i].homeProfilePostBody,
            profileImage: newValue.almFamilyMemorialList[i].homeProfilePostPage.homeProfilePostPageProfileImage,
            imagesOrVideos: newValue.almFamilyMemorialList[i].homeProfilePostImagesOrVideos,
            managed: newValue.almFamilyMemorialList[i].homeProfilePostPage.homeProfilePostPageManage,
            joined: newValue.almFamilyMemorialList[i].homeProfilePostPage.homeProfilePostPageFollower,
            numberOfComments: newValue.almFamilyMemorialList[i].homeProfilePostNumberOfComments,
            numberOfLikes: newValue.almFamilyMemorialList[i].homeProfilePostNumberOfLikes,
            likeStatus: newValue.almFamilyMemorialList[i].homeProfilePostLikeStatus,
            numberOfTagged: newValue.almFamilyMemorialList[i].homeProfilePostTagged.length,
            taggedFirstName: newList1,
            taggedLastName: newList2,
            taggedImage: newList3,
            taggedId: newList4,
            pageType: newValue.almFamilyMemorialList[i].homeProfilePostPage.homeProfilePostPagePageType,
            famOrFriends: newValue.almFamilyMemorialList[i].homeProfilePostPage.homeProfilePostPageFamOrFriends,
            relationship: newValue.almFamilyMemorialList[i].homeProfilePostPage.homeProfilePostPageRelationship,
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

  Future<APIRegularShowMemorialMain> getProfileInformation(int memorialId) async{
    return await apiRegularShowMemorial(memorialId: memorialId);
  }

  void initBranchShare(){
    buo = BranchUniversalObject(
      canonicalIdentifier: 'FacesbyPlaces',
      title: 'FacesbyPlaces Link',
      imageUrl: 'https://i.picsum.photos/id/866/200/300.jpg?hmac=rcadCENKh4rD6MAp6V_ma-AyWv641M4iiOpe1RyFHeI',
      contentDescription: 'FacesbyPlaces link to the app',
      keywords: ['FacesbyPlaces', 'Share', 'Link'],
      publiclyIndex: true,
      locallyIndex: true,
      contentMetadata: BranchContentMetaData()
        ..addCustomMetadata('link-category', 'Memorial')
        ..addCustomMetadata('link-memorial-id', memorialId)
        ..addCustomMetadata('link-type-of-account', 'Memorial')
    );

    lp = BranchLinkProperties(
      feature: 'sharing',
      stage: 'new share',
      tags: ['one', 'two', 'three']
    );
    lp.addControlParam('url', 'https://4n5z1.test-app.link/qtdaGGTx3cb?bnc_validate=true');
  }

  void initState(){
    super.initState();
    posts = [];
    itemRemaining = 1;
    postCount = 0;
    dataKey = GlobalKey();
    empty = true;
    page = 1;
    showProfile = getProfileInformation(memorialId);
    onLoading();
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    // ResponsiveWidgets.init(context,
    //   height: SizeConfig.screenHeight,
    //   width: SizeConfig.screenWidth,
    // );
    return Scaffold(
      backgroundColor: Color(0xffaaaaaa),
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: FutureBuilder<APIRegularShowMemorialMain>(
          future: showProfile,
          builder: (context, profile){
            if(profile.hasData){
              return Stack(
                children: [

                  Container(
                    height: SizeConfig.screenHeight / 3,
                    width: SizeConfig.screenWidth,
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: profile.data.almMemorial.showMemorialBackgroundImage,
                      placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                      errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                    ),
                  ),

                  Column(
                    children: [

                      Container(height: SizeConfig.screenHeight / 3.5, color: Colors.transparent,),

                      Container(
                        width: SizeConfig.screenWidth,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                          color: Color(0xffffffff),
                        ),
                        child: Column(
                          children: [

                            // SizedBox(height: ScreenUtil().setHeight(105)),
                            SizedBox(height: 105,),

                            Center(
                              child: Text(profile.data.almMemorial.showMemorialName,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  // fontSize: ScreenUtil().setSp(20, allowFontScalingSelf: true),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold, 
                                  color: Color(0xff000000),
                                ),
                                maxLines: 5,
                                overflow: TextOverflow.clip,
                              ),
                            ),

                            // SizedBox(height: ScreenUtil().setHeight(20)),
                            SizedBox(height: 20,),

                            Container(
                              width: SizeConfig.safeBlockHorizontal * 15,
                              height: SizeConfig.blockSizeVertical * 5,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: CircleAvatar(
                                      radius: SizeConfig.blockSizeVertical * 2,
                                      backgroundColor: Color(0xff000000),
                                      child: CircleAvatar(
                                        radius: SizeConfig.blockSizeVertical * 1,
                                        backgroundColor: Colors.transparent,
                                        backgroundImage: AssetImage('assets/icons/fist.png'),
                                      ),
                                    ),
                                  ),

                                  // SizedBox(width: ScreenUtil().setWidth(10)),
                                  SizedBox(height: 10,),

                                  Expanded(
                                    child: Text('${profile.data.almMemorial.showMemorialFollowersCount}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xff000000),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // SizedBox(height: ScreenUtil().setHeight(20)),
                            SizedBox(height: 20,),

                            Column(
                              children: [
                                ((){
                                  if(profile.data.almMemorial.showMemorialImagesOrVideos != null){
                                    videoPlayerController = VideoPlayerController.network(profile.data.almMemorial.showMemorialImagesOrVideos[0]);
                                    return Container(
                                      height: SizeConfig.blockSizeVertical * 34.5,
                                      child: profile.data.almMemorial.showMemorialImagesOrVideos == null 
                                      ? Icon(Icons.upload_rounded, color: Color(0xff888888), size: SizeConfig.blockSizeVertical * 20,)
                                      : GestureDetector(
                                        onTap: (){
                                          if(videoPlayerController.value.isPlaying){
                                            videoPlayerController.pause();
                                            print('Paused!');
                                          }else{
                                            videoPlayerController.play();
                                            print('Played!');
                                          }
                                        },
                                        child: AspectRatio(
                                          aspectRatio: videoPlayerController.value.aspectRatio,
                                          child: VideoPlayer(videoPlayerController),
                                        ),
                                      ),
                                    );
                                  }else{
                                    return Container(height: 0,);
                                  }
                                }()),

                                ((){
                                  if(profile.data.almMemorial.showMemorialDetails.showMemorialDetailsDescription != '' || profile.data.almMemorial.showMemorialDetails.showMemorialDetailsDescription != null){
                                    return Container(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.only(left: 20.0, right: 20.0),
                                      child: Text(profile.data.almMemorial.showMemorialDetails.showMemorialDetailsDescription,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w300,
                                          color: Color(0xff000000),
                                        ),
                                      ),
                                    );
                                  }else{
                                    return Container(height: 0,);
                                  }
                                }()),
                              ],
                            ),

                            // SizedBox(height: ScreenUtil().setHeight(20)),
                            SizedBox(height: 20,),

                            Container(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 10.0, right: 10.0),
                                      child: MaterialButton(
                                        padding: EdgeInsets.zero,
                                        onPressed: () async{
                                          if(managed == true){
                                            context.showLoaderOverlay();
                                            APIRegularShowSwitchStatus result = await apiRegularShowSwitchStatus(memorialId: memorialId);
                                            context.hideLoaderOverlay();

                                            if(result.showSwitchStatusSuccess){
                                              Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularMemorialSettings(memorialId: memorialId, memorialName: profile.data.almMemorial.showMemorialName, switchFamily: result.showSwitchStatusFamily, switchFriends: result.showSwitchStatusFriends, switchFollowers: result.showSwitchStatusFollowers,)));
                                            }
                                          }else{
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularMemorialSettingsWithHidden(memorialId: memorialId, relationship: relationship,)));
                                          }                                          
                                        },
                                        child: Text('Manage',
                                          style: TextStyle(
                                            // fontSize: ScreenUtil().setSp(16, allowFontScalingSelf: true),
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xffffffff),
                                          ),
                                        ),
                                        minWidth: SizeConfig.screenWidth / 2,
                                        // height: ScreenUtil().setHeight(45),
                                        height: 45,
                                        shape: StadiumBorder(),
                                        color: Color(0xff2F353D),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () async{
                                        initBranchShare();

                                        FlutterBranchSdk.setIdentity('alm-share-link');

                                        BranchResponse response = await FlutterBranchSdk.showShareSheet(
                                          buo: buo,
                                          linkProperties: lp,
                                          messageText: 'FacesbyPlaces App',
                                          androidMessageTitle: 'FacesbyPlaces - Create a memorial page for loved ones by sharing stories, special events and photos of special occasions. Keeping their memories alive for generations',
                                          androidSharingTitle: 'FacesbyPlaces - Create a memorial page for loved ones by sharing stories, special events and photos of special occasions. Keeping their memories alive for generations'
                                        );

                                        if (response.success) {
                                          print('Link generated: ${response.result}');
                                        } else {
                                          FlutterBranchSdk.logout();
                                          print('Error : ${response.errorCode} - ${response.errorMessage}');
                                        }

                                      },
                                      child: CircleAvatar(
                                        // radius: ScreenUtil().setHeight(25),
                                        radius: 25,
                                        backgroundColor: Color(0xff3498DB),
                                        child: Icon(Icons.share, color: Color(0xffffffff), size: 25,),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // SizedBox(height: ScreenUtil().setHeight(20)),
                            SizedBox(height: 20,),

                            Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: Column(
                                children: [

                                  Row(
                                    children: [
                                      Icon(Icons.place, color: Color(0xff000000), size: 25,),
                                      SizedBox(width: SizeConfig.blockSizeHorizontal * 2,),
                                      Text(profile.data.almMemorial.showMemorialDetails.showMemorialDetailsCountry,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Color(0xff000000),
                                        ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                                  Row(
                                    children: [
                                      Icon(Icons.star, color: Color(0xff000000), size: 25,),
                                      SizedBox(width: SizeConfig.blockSizeHorizontal * 2,),
                                      Text(profile.data.almMemorial.showMemorialDetails.showMemorialDetailsDob,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Color(0xff000000),
                                        ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                                  Row(
                                    children: [
                                      Image.asset('assets/icons/grave_logo.png', height: 25,),
                                      SizedBox(width: SizeConfig.blockSizeHorizontal * 2,),
                                      Text(profile.data.almMemorial.showMemorialDetails.showMemorialDetailsRip,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Color(0xff000000),
                                        ),
                                      ),
                                    ],
                                  ),

                                ],
                              ),
                            ),

                            SizedBox(height: 20),

                            Container(
                              height: 50.0,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: (){
                                        Scrollable.ensureVisible(dataKey.currentContext);
                                      },
                                      child: Column(
                                        children: [
                                          SizedBox(height: SizeConfig.blockSizeVertical * 1,),

                                          Text(profile.data.almMemorial.showMemorialPostsCount.toString(),
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xff000000),
                                            ),
                                          ),

                                          Text('Post',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w300,
                                              color: Color(0xffaaaaaa),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  
                                  Container(width: 2, color: Color(0xffeeeeee),),

                                  Expanded(
                                    child: GestureDetector(
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularConnectionList(memorialId: memorialId, newToggle: 0)));
                                      },
                                      child: Column(
                                        children: [
                                          SizedBox(height: SizeConfig.blockSizeVertical * 1,),

                                          Text('${profile.data.almMemorial.showMemorialFamilyCount}',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xff000000),
                                            ),
                                          ),

                                          Text('Family',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w300,
                                              color: Color(0xffaaaaaa),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  Container(width: 2, color: Color(0xffeeeeee),),

                                  Expanded(
                                    child: GestureDetector(
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularConnectionList(memorialId: memorialId, newToggle: 1)));
                                      },
                                      child: Column(
                                        children: [
                                          SizedBox(height: SizeConfig.blockSizeVertical * 1,),

                                          Text(profile.data.almMemorial.showMemorialFriendsCount.toString(),
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xff000000),
                                            ),
                                          ),

                                          Text('Friends',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w300,
                                              color: Color(0xffaaaaaa),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  Container(width: 2, color: Color(0xffeeeeee),),

                                  Expanded(
                                    child: GestureDetector(
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularConnectionList(memorialId: memorialId, newToggle: 2)));
                                      },
                                      child: Column(
                                        children: [
                                          SizedBox(height: SizeConfig.blockSizeVertical * 1,),

                                          Text(profile.data.almMemorial.showMemorialFollowersCount.toString(),
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xff000000),
                                            ),
                                          ),

                                          Text('Joined',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w300,
                                              color: Color(0xffaaaaaa),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Container(height: 2, color: Color(0xffffffff),),

                            Container(height: 5, color: Color(0xffeeeeee),),

                            Column(
                              children: [
                                SizedBox(height: 20),

                                Container(
                                  key: dataKey,
                                  padding: EdgeInsets.only(left: 20.0),
                                  alignment: Alignment.centerLeft,
                                  child: Text('Post',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff000000),
                                    ),
                                  ),
                                ),

                                SizedBox(height: 20),

                                profile.data.almMemorial.showMemorialImagesOrVideos != null
                                ? Column(
                                  children: [
                                    Container(
                                      width: SizeConfig.screenWidth,
                                      height: SizeConfig.blockSizeVertical * 12,
                                      padding: EdgeInsets.only(left: 20.0, right: 20.0),
                                      child: ListView.separated(
                                        physics: ClampingScrollPhysics(),
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index){
                                          return GestureDetector(
                                            onTap: (){
                                              FullScreenMenu.show(
                                                context,
                                                backgroundColor: Color(0xff888888),
                                                items: [
                                                  CachedNetworkImage(
                                                    fit: BoxFit.cover,
                                                    imageUrl: profile.data.almMemorial.showMemorialImagesOrVideos[index],
                                                    placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                                                    errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                  ),
                                                ],
                                              );
                                            },
                                            child: Container(
                                              width: SizeConfig.blockSizeVertical * 12,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                color: Color(0xff888888),
                                              ),
                                              child: CachedNetworkImage(
                                                fit: BoxFit.cover,
                                                imageUrl: profile.data.almMemorial.showMemorialImagesOrVideos[index],
                                                placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                                                errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                              ),
                                            ),
                                          );
                                        }, 
                                        separatorBuilder: (context, index){
                                          return SizedBox(width: 20);
                                        },
                                        itemCount: profile.data.almMemorial.showMemorialImagesOrVideos.length,
                                      ),
                                    ),

                                    SizedBox(height: 20),

                                  ],
                                )
                                : Container(height: 0,),
                              ],
                            ),

                            Container(height: 5, color: Color(0xffeeeeee),),

                            postCount != 0
                            ? Container(
                              padding: EdgeInsets.all(10.0),
                              height: SizeConfig.screenHeight,
                              child: SmartRefresher(
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
                                        ? Container(
                                          height: SizeConfig.blockSizeVertical * 30,
                                          child: ((){
                                            if(posts[i].imagesOrVideos != null){
                                              if(posts[i].imagesOrVideos.length == 1){
                                                return Container(
                                                  child: CachedNetworkImage(
                                                    fit: BoxFit.cover,
                                                    imageUrl: posts[i].imagesOrVideos[0],
                                                    placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                                                    errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                  ),
                                                );
                                              }else if(posts[i].imagesOrVideos.length == 2){
                                                return StaggeredGridView.countBuilder(
                                                  padding: EdgeInsets.zero,
                                                  physics: NeverScrollableScrollPhysics(),
                                                  crossAxisCount: 4,
                                                  itemCount: 2,
                                                  itemBuilder: (BuildContext context, int index) => 
                                                    CachedNetworkImage(
                                                      fit: BoxFit.cover,
                                                      imageUrl: posts[i].imagesOrVideos[index],
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
                                                            imageUrl: posts[i].imagesOrVideos[index],
                                                            placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                                                            errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                          );
                                                        }else{
                                                          return posts[i].imagesOrVideos.length - 3 == 0
                                                          ? CachedNetworkImage(
                                                            fit: BoxFit.cover,
                                                            imageUrl: posts[i].imagesOrVideos[index],
                                                            placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                                                            errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                          )
                                                          : Stack(
                                                            children: [
                                                              CachedNetworkImage(
                                                                fit: BoxFit.cover,
                                                                imageUrl: posts[i].imagesOrVideos[index],
                                                                placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                                                                errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                              ),

                                                              Container(color: Colors.black.withOpacity(0.5),),

                                                              Center(
                                                                child: CircleAvatar(
                                                                  radius: SizeConfig.blockSizeVertical * 3,
                                                                  backgroundColor: Color(0xffffffff).withOpacity(.5),
                                                                  child: Text(
                                                                    '${posts[i].imagesOrVideos.length - 3}',
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
                                  itemCount: posts.length,
                                ),
                              ),
                            )
                            // : ContainerResponsive(
                            //   height: SizeConfig.screenHeight,
                            //   width: SizeConfig.screenWidth,
                            //   alignment: Alignment.center,
                            //   child: ContainerResponsive(
                            //     width: SizeConfig.screenWidth,
                            //     heightResponsive: false,
                            //     widthResponsive: true,
                            //     alignment: Alignment.center,
                            //     child: SingleChildScrollView(
                            //       physics: ClampingScrollPhysics(),
                            //       child: MiscRegularEmptyDisplayTemplate(),
                            //     ),
                            //   ),
                            // ),
                            : SingleChildScrollView(
                              physics: ClampingScrollPhysics(),
                              child: MiscRegularEmptyDisplayTemplate(),
                            ),

                          ],
                        ),
                      ),
                    ],
                  ),

                  Container(
                    height: Size.fromHeight(AppBar().preferredSize.height).height + (Size.fromHeight(AppBar().preferredSize.height).height / 2),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 20.0),
                            child: GestureDetector(
                              onTap: (){
                                Navigator.pop(context);
                              },
                              child: Row(
                                children: [
                                  Icon(Icons.arrow_back, color: Color(0xffffffff),), 
                                  Text('Back',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xffffffff),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(right: 20.0),
                            alignment: Alignment.centerRight,
                            child: managed == true
                            ? MaterialButton(
                              onPressed: () async{

                                final ByteData bytes = await rootBundle.load('assets/icons/graveyard.png');
                                final Uint8List list = bytes.buffer.asUint8List();

                                final tempDir = await getTemporaryDirectory();
                                final file = await new File('${tempDir.path}/regular-post-image.png').create();
                                file.writeAsBytesSync(list);

                                Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularCreatePost(name: profile.data.almMemorial.showMemorialName, memorialId: profile.data.almMemorial.showMemorialId)));

                              },
                              shape: StadiumBorder(),
                              color: Colors.green,
                              splashColor: Colors.yellow,
                              // height: ScreenUtil().setHeight(45),
                              height: 45,
                              child: Text('Create Post',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xffffffff),
                                ),
                              ),
                            )
                            : Container(height: 0,),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Positioned(
                    top: SizeConfig.screenHeight / 5,
                    child: Container(
                      // height: ScreenUtil().setHeight(160),
                      height: 160,
                      width: SizeConfig.screenWidth,
                      child: Row(
                        children: [
                          Expanded(child: Container(),),
                          Expanded(
                            child: CircleAvatar(
                              radius: SizeConfig.blockSizeVertical * 12,
                              backgroundColor: Color(0xff04ECFF),
                              child: Padding(
                                padding: EdgeInsets.all(5),
                                child: CircleAvatar(
                                  radius: SizeConfig.blockSizeVertical * 12,
                                  backgroundColor: Color(0xff888888),
                                  backgroundImage: profile.data.almMemorial.showMemorialProfileImage != null ? NetworkImage(profile.data.almMemorial.showMemorialProfileImage) : AssetImage('assets/icons/app-icon.png'),
                                ),
                              ),
                            ),
                          ),
                          Expanded(child: Container(),),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }else if(profile.hasError){
              return MiscRegularErrorMessageTemplate();
            }else{
              return Container(height: SizeConfig.screenHeight, child: Center(child: Container(child: SpinKitThreeBounce(color: Color(0xff000000), size: 50.0,), color: Color(0xffffffff),),),);
            }
          },
        ),
      ),
    );
  }
}





