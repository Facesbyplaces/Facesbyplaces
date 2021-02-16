import 'package:facesbyplaces/API/BLM/03-View-Memorial/api-view-memorial-blm-01-show-memorial-details.dart';
import 'package:facesbyplaces/API/BLM/03-View-Memorial/api-view-memorial-blm-02-show-profile-post.dart';
import 'package:facesbyplaces/UI/Home/BLM/05-Donate/home-donate-blm-01-donate.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-13-blm-dropdown.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-14-blm-empty-display.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-05-blm-post.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-09-blm-message.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:full_screen_menu/full_screen_menu.dart';
import 'home-view-memorial-blm-03-connection-list.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:maps/maps.dart';

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

class HomeBLMMemorialProfile extends StatefulWidget{
  final int memorialId;
  final String pageType;
  final bool newJoin;
  HomeBLMMemorialProfile({this.memorialId, this.pageType, this.newJoin});

  HomeBLMMemorialProfileState createState() => HomeBLMMemorialProfileState(memorialId: memorialId, pageType: pageType, newJoin: newJoin);
}

class HomeBLMMemorialProfileState extends State<HomeBLMMemorialProfile>{
  final int memorialId;
  final String pageType;
  final bool newJoin;
  HomeBLMMemorialProfileState({this.memorialId, this.pageType, this.newJoin});

  RefreshController refreshController = RefreshController(initialRefresh: true);
  TextEditingController controller = TextEditingController();
  List<BLMProfilePosts> posts;
  Future showProfile;
  int itemRemaining;
  GlobalKey dataKey;
  int postCount;
  bool empty;
  bool join;
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
      itemRemaining = newValue.blmItemsRemaining;
      postCount = newValue.blmFamilyMemorialList.length;

      List<String> newList1 = [];
      List<String> newList2 = [];
      List<String> newList3 = [];
      List<int> newList4 = [];

      for(int i = 0; i < newValue.blmFamilyMemorialList.length; i++){
        for(int j = 0; j < newValue.blmFamilyMemorialList[i].profilePostPostTagged.length; j++){
          newList1.add(newValue.blmFamilyMemorialList[i].profilePostPostTagged[j].profilePageTaggedFirstName);
          newList2.add(newValue.blmFamilyMemorialList[i].profilePostPostTagged[j].profilePageTaggedLastName);
          newList3.add(newValue.blmFamilyMemorialList[i].profilePostPostTagged[j].profilePageTaggedImage);
          newList4.add(newValue.blmFamilyMemorialList[i].profilePostPostTagged[j].profilePageTaggedId);
        }

        posts.add(BLMProfilePosts(
          userId: newValue.blmFamilyMemorialList[i].profilePostPage.profilePagePageCreator.profilePageCreatorId, 
          postId: newValue.blmFamilyMemorialList[i].profilePostId,
          memorialId: newValue.blmFamilyMemorialList[i].profilePostPage.profilePageId,
          timeCreated: newValue.blmFamilyMemorialList[i].profilePostCreateAt,
          memorialName: newValue.blmFamilyMemorialList[i].profilePostPage.profilePageName,
          postBody: newValue.blmFamilyMemorialList[i].profilePostBody,
          profileImage: newValue.blmFamilyMemorialList[i].profilePostPage.profilePageProfileImage,
          imagesOrVideos: newValue.blmFamilyMemorialList[i].profilePostImagesOrVideos,
          managed: newValue.blmFamilyMemorialList[i].profilePostPage.profilePageManage,
          joined: newValue.blmFamilyMemorialList[i].profilePostPage.profilePageFollower,
          numberOfComments: newValue.blmFamilyMemorialList[i].profilePostNumberOfComments,
          numberOfLikes: newValue.blmFamilyMemorialList[i].profilePostNumberOfLikes,
          likeStatus: newValue.blmFamilyMemorialList[i].profilePostLikeStatus,
          numberOfTagged: newValue.blmFamilyMemorialList[i].profilePostPostTagged.length,
          taggedFirstName: newList1,
          taggedLastName: newList2,
          taggedImage: newList3,
          taggedId: newList4,
          pageType: newValue.blmFamilyMemorialList[i].profilePostPage.profilePagePageType,
          famOrFriends: newValue.blmFamilyMemorialList[i].profilePostPage.profilePageFamOrFriends,
          relationship: newValue.blmFamilyMemorialList[i].profilePostPage.profilePageRelationship,
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
    join = newJoin;
    posts = [];
    itemRemaining = 1;
    empty = true;
    page = 1;
    postCount = 0;
    dataKey = GlobalKey();
    onLoading();
    showProfile = getProfileInformation(memorialId);
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
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
                      imageUrl: profile.data.blmMemorial.memorialBackgroundImage,
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

                            SizedBox(height: 120,),

                            Center(
                              child: Text(
                                profile.data.blmMemorial.memorialName,
                                textAlign: TextAlign.center,
                                maxLines: 5,
                                overflow: TextOverflow.clip,
                                style: TextStyle(
                                  fontSize: 20, 
                                  fontWeight: FontWeight.bold, color: Color(0xff000000),
                                ),
                              ),
                            ),

                            SizedBox(height: 20,),

                            Container(
                              width: 100,
                              height: 40,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: CircleAvatar(
                                      radius: 15,
                                      backgroundColor: Color(0xffE67E22),
                                      child: Icon(Icons.card_giftcard, color: Color(0xffffffff), size: 15,),
                                    ),
                                  ),

                                  SizedBox(width: 20,),

                                  Expanded(
                                    child: Text('${profile.data.blmMemorial.memorialFollowersCount}',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff000000),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: 20,),

                            // Column(
                            //   children: [
                            //     ((){
                            //       if(profile.data.blmMemorial.memorialDetails.memorialDetailsDescription != '' || profile.data.blmMemorial.memorialDetails.memorialDetailsDescription != null){
                            //         return Container(
                            //           alignment: Alignment.center,
                            //           padding: EdgeInsets.only(left: 20.0, right: 20.0),
                            //           child: Text(profile.data.blmMemorial.memorialDetails.memorialDetailsDescription,
                            //             textAlign: TextAlign.center,
                            //             style: TextStyle(
                            //               fontSize: 16,
                            //               fontWeight: FontWeight.w300,
                            //               color: Color(0xff000000),
                            //             ),
                            //           ),
                            //         );
                            //       }else{
                            //         return Container(height: 0,);
                            //       }
                            //     }()),
                            //   ],
                            // ),

                            Column(
                              children: [
                                ((){
                                  if(profile.data.blmMemorial.memorialImagesOrVideos != null){
                                    videoPlayerController = VideoPlayerController.network(profile.data.blmMemorial.memorialImagesOrVideos[0]);
                                    return Container(
                                      height: 280,
                                      child: profile.data.blmMemorial.memorialImagesOrVideos == null 
                                      ? Icon(Icons.upload_rounded, color: Color(0xff888888), size: 80,)
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
                                  if(profile.data.blmMemorial.memorialDetails.memorialDetailsDescription != '' || profile.data.blmMemorial.memorialDetails.memorialDetailsDescription != null){
                                    return Container(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.only(left: 20.0, right: 20.0),
                                      // child: Text(profile.data.blmMemorial.showMemorialDetails.showMemorialDetailsDescription,
                                      child: Text(profile.data.blmMemorial.memorialDetails.memorialDetailsDescription,
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

                            SizedBox(height: 20,),

                            Container(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMUserDonate(pageType: pageType, pageId: memorialId,)));
                                      },
                                      child: CircleAvatar(
                                        radius: 25,
                                        backgroundColor: Color(0xffE67E22),
                                        child: Icon(Icons.card_giftcard, color: Color(0xffffffff), size: 25,),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 10.0, right: 10.0),
                                      child: MaterialButton(
                                        padding: EdgeInsets.zero,
                                        onPressed: () async{

                                          setState(() {
                                            join = !join;
                                          });
                                          
                                        },
                                        child: Text(
                                          join ? 'Unjoin' : 'Join',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xffffffff),
                                          ),
                                        ),
                                        minWidth: SizeConfig.screenWidth / 2,
                                        height: 45,
                                        shape: StadiumBorder(),
                                        color: join
                                        ? Color(0xff04ECFF)
                                        : Color(0xff888888),
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
                                        } else {
                                          FlutterBranchSdk.logout();
                                          print('Error : ${response.errorCode} - ${response.errorMessage}');
                                        }
                                      },
                                      child: CircleAvatar(
                                        radius: 25,
                                        backgroundColor: Color(0xff3498DB),
                                        child: Icon(Icons.share, color: Color(0xffffffff), size: 25,),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: 20,),

                            Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: Column(
                                children: [

                                  Row(
                                    children: [
                                      Image.asset('assets/icons/prayer_logo.png', height: 25,),
                                      SizedBox(width: 20,),
                                      Expanded(
                                        child: Text('Roman Catholic',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Color(0xff000000),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(height: 20,),

                                  Row(
                                    children: [
                                      Icon(Icons.place, color: Color(0xff000000), size: 25,),
                                      SizedBox(width: 20,),
                                      Expanded(
                                        child: Text(profile.data.blmMemorial.memorialDetails.memorialDetailsPrecinct,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Color(0xff000000),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(height: 20,),

                                  Row(
                                    children: [
                                      Icon(Icons.star, color: Color(0xff000000), size: 25,),
                                      SizedBox(width: 20,),
                                      Expanded(
                                        child: Text(profile.data.blmMemorial.memorialDetails.memorialDetailsDob,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Color(0xff000000),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(height: 20,),

                                  Row(
                                    children: [
                                      Image.asset('assets/icons/grave_logo.png', height: 25),
                                      SizedBox(width: 20,),
                                      Expanded(
                                        child: Text(profile.data.blmMemorial.memorialDetails.memorialDetailsRip,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Color(0xff000000),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(height: 20,),

                                  Row(
                                    children: [
                                      Image.asset('assets/icons/grave_logo.png', height: 25,),
                                      SizedBox(width: 20,),
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () async{
                                            final launcher = const GoogleMapsLauncher();
                                            await launcher.launch(
                                              geoPoint: GeoPoint(0.0, 0.0),
                                            );
                                          },
                                          child: Text(profile.data.blmMemorial.memorialDetails.memorialDetailsLocation,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Color(0xff3498DB),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  
                                ],
                              ),
                            ),

                            SizedBox(height: 20,),

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

                                          Text('${profile.data.blmMemorial.memorialPostsCount}',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xff000000),
                                            ),
                                          ),

                                          Text('Post',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w300,
                                              color: Color(0xffaaaaaa),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  
                                  Container(width: 5, color: Color(0xffeeeeee),),

                                  Expanded(
                                    child: GestureDetector(
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMConnectionList(memorialId: memorialId, newToggle: 0)));
                                      },
                                      child: Column(
                                        children: [

                                          Text('${profile.data.blmMemorial.memorialFamilyCount}',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xff000000),
                                            ),
                                          ),

                                          Text('Family',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w300,
                                              color: Color(0xffaaaaaa),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  Container(width: 5, color: Color(0xffeeeeee),),

                                  Expanded(
                                    child: GestureDetector(
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMConnectionList(memorialId: memorialId, newToggle: 1)));
                                      },
                                      child: Column(
                                        children: [
                                          Text('${profile.data.blmMemorial.memorialFriendsCount}',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xff000000),
                                            ),
                                          ),

                                          Text('Friends',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w300,
                                              color: Color(0xffaaaaaa),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  Container(width: 5, color: Color(0xffeeeeee),),

                                  Expanded(
                                    child: GestureDetector(
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMConnectionList(memorialId: memorialId, newToggle: 2)));
                                      },
                                      child: Column(
                                        children: [
                                          Text('${profile.data.blmMemorial.memorialFollowersCount}',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xff000000),
                                            ),
                                          ),

                                          Text('Joined',
                                            style: TextStyle(
                                              fontSize: 14,
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

                            Container(height: 5, color: Color(0xffffffff),),

                            Container(height: 5, color: Color(0xffeeeeee),),

                            Column(
                              children: [
                                SizedBox(height: 20,),

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

                                SizedBox(height: 20,),

                                profile.data.blmMemorial.memorialImagesOrVideos != null
                                ? Column(
                                  children: [
                                    Container(
                                      width: SizeConfig.screenWidth,
                                      height: 100,
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
                                                    imageUrl: profile.data.blmMemorial.memorialImagesOrVideos[index],
                                                    placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                                                    errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                  ),
                                                ],
                                              );
                                            },
                                            child: Container(
                                              width: 100,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                color: Color(0xff888888),
                                              ),
                                              child: CachedNetworkImage(
                                                imageUrl: profile.data.blmMemorial.memorialImagesOrVideos[index],
                                                placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                                                errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                              ),
                                            ),
                                          );
                                        }, 
                                        separatorBuilder: (context, index){
                                          return SizedBox(width: 20,);
                                        },
                                        itemCount: profile.data.blmMemorial.memorialImagesOrVideos.length,
                                      ),
                                    ),

                                    SizedBox(height: 20,),

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

                                        SizedBox(height: 45),

                                        posts[i].imagesOrVideos != null
                                        ? Container(
                                          height: 240,
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
                                                                  radius: 25,
                                                                  backgroundColor: Color(0xffffffff).withOpacity(.5),
                                                                  child: Text(
                                                                    '${posts[i].imagesOrVideos.length - 3}',
                                                                    style: TextStyle(
                                                                      fontSize: 60,
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
                                  itemCount: posts.length,
                                ),
                              ),
                            )
                            : SingleChildScrollView(
                              physics: ClampingScrollPhysics(),
                              child: MiscBLMEmptyDisplayTemplate(),
                            ),

                          ],
                        ),
                      ),
                    ],
                  ),

                  Container(
                    height: Size.fromHeight(AppBar().preferredSize.height).height + (Size.fromHeight(AppBar().preferredSize.height).height / 2),
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
                  
                  Container(
                    padding: EdgeInsets.only(right: 20.0),
                    height: Size.fromHeight(AppBar().preferredSize.height).height + (Size.fromHeight(AppBar().preferredSize.height).height / 2),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: MiscBLMDropDownMemorialTemplate(memorialName: profile.data.blmMemorial.memorialName, memorialId: memorialId, pageType: pageType, reportType: 'Blm',),
                    ),
                  ),

                  Positioned(
                    top: SizeConfig.screenHeight / 5,
                    child: Container(
                      height: 140,
                      width: SizeConfig.screenWidth,
                      child: Row(
                        children: [
                          Expanded(child: Container(),),
                          Expanded(
                            child: CircleAvatar(
                              radius: 100,
                              backgroundColor: Color(0xff04ECFF),
                              child: Padding(
                                padding: EdgeInsets.all(5),
                                child: CircleAvatar(
                                  radius: 100,
                                  backgroundColor: Color(0xff888888),
                                  backgroundImage: profile.data.blmMemorial.memorialProfileImage != null ? NetworkImage(profile.data.blmMemorial.memorialProfileImage) : AssetImage('assets/icons/app-icon.png'),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(),
                          ),
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