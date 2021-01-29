import 'package:facesbyplaces/UI/Home/BLM/08-Settings-Memorial/home-settings-memorial-blm-08-memorial-settings-with-hidden.dart';
import 'package:facesbyplaces/UI/Home/BLM/04-Create-Post/home-create-post-blm-01-create-post.dart';
import 'package:facesbyplaces/UI/Home/BLM/08-Settings-Memorial/home-settings-memorial-blm-01-memorial-settings.dart';
import 'package:facesbyplaces/API/BLM/03-View-Memorial/api-view-memorial-blm-01-show-memorial-details.dart';
import 'package:facesbyplaces/API/BLM/03-View-Memorial/api-view-memorial-blm-02-show-profile-post.dart';
import 'package:facesbyplaces/API/BLM/03-View-Memorial/api-view-memorial-blm-03-show-switch-status.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-14-blm-empty-display.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-05-blm-post.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-09-blm-message.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:full_screen_menu/full_screen_menu.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:video_player/video_player.dart';
import 'home-view-memorial-blm-03-connection-list.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:path_provider/path_provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:async';
import 'dart:io';

class BLMRelationshipItemPost{

  final String name;
  final File image;
  final int memorialId;
  
  const BLMRelationshipItemPost({this.name, this.image, this.memorialId});
}

class BLMProfilePosts{
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

  BLMProfilePosts({this.userId, this.postId, this.memorialId, this.memorialName, this.timeCreated, this.postBody, this.profileImage, this.imagesOrVideos, this.managed, this.joined, this.numberOfLikes, this.numberOfComments, this.likeStatus, this.numberOfTagged, this.taggedFirstName, this.taggedLastName, this.taggedImage, this.taggedId, this.pageType, this.famOrFriends, this.relationship});
}

class HomeBLMProfile extends StatefulWidget{
  final int memorialId;
  final String relationship;
  final bool managed;
  HomeBLMProfile({this.memorialId, this.relationship, this.managed});

  HomeBLMProfileState createState() => HomeBLMProfileState(memorialId: memorialId, relationship: relationship, managed: managed);
}

class HomeBLMProfileState extends State<HomeBLMProfile> with WidgetsBindingObserver{
  final int memorialId;
  final String relationship;
  final bool managed;
  HomeBLMProfileState({this.memorialId, this.relationship, this.managed});

  RefreshController refreshController = RefreshController(initialRefresh: true);
  TextEditingController controller = TextEditingController();
  List<BLMProfilePosts> posts;
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
      var newValue = await apiBLMProfilePost(memorialId: memorialId, page: page);
      itemRemaining = newValue.itemsRemaining;
      postCount = newValue.familyMemorialList.length;

      List<String> newList1 = [];
      List<String> newList2 = [];
      List<String> newList3 = [];
      List<int> newList4 = [];

      for(int i = 0; i < newValue.familyMemorialList.length; i++){
        for(int j = 0; j < newValue.familyMemorialList[i].postTagged.length; j++){
          newList1.add(newValue.familyMemorialList[i].postTagged[j].taggedFirstName);
          newList2.add(newValue.familyMemorialList[i].postTagged[j].taggedLastName);
          newList3.add(newValue.familyMemorialList[i].postTagged[j].taggedImage);
          newList4.add(newValue.familyMemorialList[i].postTagged[j].taggedId);
        }

        posts.add(BLMProfilePosts(
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

  Future<APIBLMShowMemorialMain> getProfileInformation(int memorialId) async{
    return await apiBLMShowMemorial(memorialId: memorialId);
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
        ..addCustomMetadata('link-type-of-account', 'Blm')
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
    onLoading();
    showProfile = getProfileInformation(memorialId);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    ResponsiveWidgets.init(context,
      height: SizeConfig.screenHeight,
      width: SizeConfig.screenWidth,
    );
    return Scaffold(
      backgroundColor: Color(0xffaaaaaa),
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: FutureBuilder<APIBLMShowMemorialMain>(
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
                      imageUrl: profile.data.memorial.blmBackgroundImage,
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

                            SizedBox(height: SizeConfig.blockSizeVertical * 12,),

                            Center(
                              child: Text(profile.data.memorial.blmName,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: SizeConfig.safeBlockHorizontal * 5, 
                                  fontWeight: FontWeight.bold, 
                                  color: Color(0xff000000),
                                ),
                                maxLines: 5,
                                overflow: TextOverflow.clip,
                              ),
                            ),

                            SizedBox(height: SizeConfig.blockSizeVertical * 2,),

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

                                  SizedBox(width: SizeConfig.blockSizeHorizontal * 2,),

                                  Expanded(
                                    child: Text('${profile.data.memorial.blmFollowersCount}',
                                      style: TextStyle(
                                        fontSize: SizeConfig.safeBlockHorizontal * 4,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xff000000),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                            Column(
                              children: [
                                ((){
                                  if(profile.data.memorial.blmImagesOrVideos != null){
                                    videoPlayerController = VideoPlayerController.network(profile.data.memorial.blmImagesOrVideos[0]);
                                    return Container(
                                      height: SizeConfig.blockSizeVertical * 34.5,
                                      child: profile.data.memorial.blmImagesOrVideos == null 
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
                                  if(profile.data.memorial.blmDetails.description != '' || profile.data.memorial.blmDetails.description != null){
                                    return Container(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.only(left: 20.0, right: 20.0),
                                      child: Text(profile.data.memorial.blmDetails.description,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: ScreenUtil().setSp(16, allowFontScalingSelf: true),
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

                            SizedBox(height: SizeConfig.blockSizeVertical * 2,),

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
                                            APIBLMShowSwitchStatus result = await apiBLMShowSwitchStatus(memorialId: memorialId);
                                            context.hideLoaderOverlay();

                                            if(result.success){
                                              Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMMemorialSettings(memorialId: memorialId, memorialName: profile.data.memorial.blmName, switchFamily: result.family, switchFriends: result.friends, switchFollowers: result.followers,)));
                                            }
                                          }else{
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMMemorialSettingsWithHidden(memorialId: memorialId, relationship: relationship,)));
                                          }
                                          
                                        },
                                        child: Text('Manage',
                                          style: TextStyle(
                                            fontSize: SizeConfig.safeBlockHorizontal * 5,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xffffffff),
                                          ),
                                        ),
                                        minWidth: SizeConfig.screenWidth / 2,
                                        height: SizeConfig.blockSizeVertical * 7,
                                        shape: StadiumBorder(),
                                        color: Color(0xff2F353D),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () async{
                                        initBranchShare();

                                        FlutterBranchSdk.setIdentity('blm-share-link');

                                        BranchResponse response = await FlutterBranchSdk.showShareSheet(
                                          buo: buo,
                                          linkProperties: lp,
                                          messageText: 'FacesbyPlaces App',
                                          androidMessageTitle: 'FacesbyPlaces - Create a memorial page for loved ones by sharing stories, special events and photos of special occasions. Keeping their memories alive for generations',
                                          androidSharingTitle: 'FacesbyPlaces - Create a memorial page for loved ones by sharing stories, special events and photos of special occasions. Keeping their memories alive for generations'
                                        );

                                        if (response.success) {
                                          print('Link generated: ${response.result}');
                                          print('showShareSheet Sucess');
                                        } else {
                                          FlutterBranchSdk.logout();
                                          print('Error : ${response.errorCode} - ${response.errorMessage}');
                                        }
                                      },
                                      child: CircleAvatar(
                                        radius: SizeConfig.blockSizeVertical * 3,
                                        backgroundColor: Color(0xff3498DB),
                                        child: Icon(Icons.share, color: Color(0xffffffff), size: SizeConfig.blockSizeVertical * 3,),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                            Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: Column(
                                children: [

                                  Row(
                                    children: [
                                      Icon(Icons.place, color: Color(0xff000000), size: SizeConfig.blockSizeVertical * 3,),
                                      SizedBox(width: SizeConfig.blockSizeHorizontal * 2,),
                                      Text(profile.data.memorial.blmDetails.country,
                                        style: TextStyle(
                                          fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                                          color: Color(0xff000000),
                                        ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                                  Row(
                                    children: [
                                      Icon(Icons.star, color: Color(0xff000000), size: SizeConfig.blockSizeVertical * 3,),
                                      SizedBox(width: SizeConfig.blockSizeHorizontal * 2,),
                                      Text(profile.data.memorial.blmDetails.dob,
                                        style: TextStyle(
                                          fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                                          color: Color(0xff000000),
                                        ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                                  Row(
                                    children: [
                                      Image.asset('assets/icons/grave_logo.png', height: SizeConfig.blockSizeVertical * 3,),
                                      SizedBox(width: SizeConfig.blockSizeHorizontal * 2,),
                                      // Text(convertDate(profile.data.memorial.blmDetails.rip),
                                      Text(profile.data.memorial.blmDetails.rip,
                                        style: TextStyle(
                                          fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                                          color: Color(0xff000000),
                                        ),
                                      ),
                                    ],
                                  ),

                                ],
                              ),
                            ),

                            SizedBox(height: SizeConfig.blockSizeVertical * 2,),

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

                                          Text('${profile.data.memorial.blmPostsCount}',
                                            style: TextStyle(
                                              fontSize: SizeConfig.safeBlockHorizontal * 5,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xff000000),
                                            ),
                                          ),

                                          Text('Post',
                                            style: TextStyle(
                                              fontSize: SizeConfig.safeBlockHorizontal * 3,
                                              fontWeight: FontWeight.w300,
                                              color: Color(0xffaaaaaa),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  
                                  Container(width: SizeConfig.blockSizeHorizontal * .5, color: Color(0xffeeeeee),),

                                  Expanded(
                                    child: GestureDetector(
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMConnectionList(memorialId: memorialId, newToggle: 0)));
                                      },
                                      child: Column(
                                        children: [
                                          SizedBox(height: SizeConfig.blockSizeVertical * 1,),

                                          Text('${profile.data.memorial.blmFamilyCount}',
                                            style: TextStyle(
                                              fontSize: SizeConfig.safeBlockHorizontal * 5,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xff000000),
                                            ),
                                          ),

                                          Text('Family',
                                            style: TextStyle(
                                              fontSize: SizeConfig.safeBlockHorizontal * 3,
                                              fontWeight: FontWeight.w300,
                                              color: Color(0xffaaaaaa),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  Container(width: SizeConfig.blockSizeHorizontal * .5, color: Color(0xffeeeeee),),

                                  Expanded(
                                    child: GestureDetector(
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMConnectionList(memorialId: memorialId, newToggle: 1)));
                                      },
                                      child: Column(
                                        children: [
                                          SizedBox(height: SizeConfig.blockSizeVertical * 1,),

                                          Text('${profile.data.memorial.blmFriendsCount}',
                                            style: TextStyle(
                                              fontSize: SizeConfig.safeBlockHorizontal * 5,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xff000000),
                                            ),
                                          ),

                                          Text('Friends',
                                            style: TextStyle(
                                              fontSize: SizeConfig.safeBlockHorizontal * 3,
                                              fontWeight: FontWeight.w300,
                                              color: Color(0xffaaaaaa),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  Container(width: SizeConfig.blockSizeHorizontal * .5, color: Color(0xffeeeeee),),

                                  Expanded(
                                    child: GestureDetector(
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMConnectionList(memorialId: memorialId, newToggle: 2)));
                                      },
                                      child: Column(
                                        children: [
                                          SizedBox(height: SizeConfig.blockSizeVertical * 1,),

                                          Text('${profile.data.memorial.blmFollowersCount}',
                                            style: TextStyle(
                                              fontSize: SizeConfig.safeBlockHorizontal * 5,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xff000000),
                                            ),
                                          ),

                                          Text('Joined',
                                            style: TextStyle(
                                              fontSize: SizeConfig.safeBlockHorizontal * 3,
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

                            Container(height: SizeConfig.blockSizeVertical * .5, color: Color(0xffffffff),),

                            Container(height: SizeConfig.blockSizeVertical * .5, color: Color(0xffeeeeee),),

                            Column(
                              children: [
                                SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                                Container(
                                  key: dataKey,
                                  padding: EdgeInsets.only(left: 20.0),
                                  alignment: Alignment.centerLeft,
                                  child: Text('Post',
                                    style: TextStyle(
                                      fontSize: SizeConfig.safeBlockHorizontal * 5,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff000000),
                                    ),
                                  ),
                                ),

                                SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                                profile.data.memorial.blmImagesOrVideos != null
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
                                                    imageUrl: profile.data.memorial.blmImagesOrVideos[index],
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
                                                imageUrl: profile.data.memorial.blmImagesOrVideos[index],
                                                placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                                                errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                              ),
                                            ),
                                          );
                                        }, 
                                        separatorBuilder: (context, index){
                                          return SizedBox(width: SizeConfig.blockSizeHorizontal * 2,);
                                        },
                                        itemCount: profile.data.memorial.blmImagesOrVideos.length,
                                      ),
                                    ),

                                    SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                                  ],
                                )
                                : Container(height: 0,),
                              ],
                            ),

                            Container(height: SizeConfig.blockSizeVertical * .5, color: Color(0xffeeeeee),),

                            postCount != 0
                            ? Container(
                              padding: EdgeInsets.all(10.0),
                              // height: SizeConfig.screenHeight / 1.5 - kToolbarHeight,
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
                                    return MiscBLMPost(
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

                                        SizedBox(height: ScreenUtil().setHeight(45)),

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
                            // : Container(
                            //   padding: EdgeInsets.all(10.0),
                            //   height: SizeConfig.screenHeight / 1.5 - kToolbarHeight,
                            //   child: Center(
                            //     child: Text('Post is empty.', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),)),
                            //   ),
                            // ),
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
                                  child: MiscBLMEmptyDisplayTemplate(),
                                ),
                              ),
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
                                      fontSize: SizeConfig.safeBlockHorizontal * 5,
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
                                final file = await new File('${tempDir.path}/blm-post-image.png').create();
                                file.writeAsBytesSync(list);

                                Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMCreatePost(name: profile.data.memorial.blmName, memorialId: profile.data.memorial.blmId)));

                              },
                              shape: StadiumBorder(),
                              color: Colors.green,
                              splashColor: Colors.yellow,
                              child: Text('Create Post',
                                style: TextStyle(
                                  fontSize: SizeConfig.safeBlockHorizontal * 4,
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
                      height: SizeConfig.blockSizeVertical * 18,
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
                                  backgroundImage: profile.data.memorial.blmProfileImage != null ? NetworkImage(profile.data.memorial.blmProfileImage) : AssetImage('assets/icons/app-icon.png'),
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
              return MiscBLMErrorMessageTemplate();
            }else{
              return Container(height: SizeConfig.screenHeight, child: Center(child: Container(child: SpinKitThreeBounce(color: Color(0xff000000), size: 50.0,), color: Color(0xffffffff),),),);
            }
          },
        ),
      ),
    );
  }
}