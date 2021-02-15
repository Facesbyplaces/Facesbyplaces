import 'package:facesbyplaces/API/Regular/03-View-Memorial/api-view-memorial-regular-02-show-profile-post.dart';
import 'package:facesbyplaces/API/Regular/03-View-Memorial/api-view-memorial-regular-01-show-memorial-details.dart';
import 'package:facesbyplaces/API/Regular/02-Main/api-main-regular-04-02-02-follow-page.dart';
import 'package:facesbyplaces/UI/Home/Regular/05-Donate/home-donate-regular-01-donate.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-09-regular-message.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-05-regular-post.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-13-regular-dropdown.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-14-regular-empty-display.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'home-view-memorial-regular-03-connection-list.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:full_screen_menu/full_screen_menu.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:video_player/video_player.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:flutter/material.dart';
import 'package:maps/maps.dart';

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

class HomeRegularMemorialProfile extends StatefulWidget{
  final int memorialId;
  final String pageType;
  final bool newJoin;
  HomeRegularMemorialProfile({this.memorialId, this.pageType, this.newJoin});

  HomeRegularMemorialProfileState createState() => HomeRegularMemorialProfileState(memorialId: memorialId, pageType: pageType, newJoin: newJoin);
}

class HomeRegularMemorialProfileState extends State<HomeRegularMemorialProfile>{
  final int memorialId;
  final String pageType;
  final bool newJoin;
  HomeRegularMemorialProfileState({this.memorialId, this.pageType, this.newJoin});

  RefreshController refreshController = RefreshController(initialRefresh: true);
  TextEditingController controller = TextEditingController();
  List<RegularProfilePosts> posts;
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
        ..addCustomMetadata('link-type-of-account', pageType)
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
        child: FutureBuilder<APIRegularShowMemorialMain>(
          future: showProfile,
          builder: (context, profile){
            if(profile.hasData){
              return Stack(
                children: [

                  Container(
                    height: SizeConfig.screenHeight / 3,
                    width: SizeConfig.screenWidth,
                    child: ((){
                      if(profile.data.almMemorial.showMemorialBackgroundImage == null || profile.data.almMemorial.showMemorialBackgroundImage == ''){
                        return Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,);
                      }else{
                        return CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: profile.data.almMemorial.showMemorialBackgroundImage,
                          placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                          errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                        );
                      }
                    }()),
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
                              child: Text(
                                profile.data.almMemorial.showMemorialName,
                                textAlign: TextAlign.center,
                                maxLines: 5,
                                overflow: TextOverflow.clip,
                                style: TextStyle(
                                  fontSize: SizeConfig.safeBlockHorizontal * 5, 
                                  fontWeight: FontWeight.bold, color: Color(0xff000000),
                                ),
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
                                      backgroundColor: Color(0xffE67E22),
                                      child: Icon(Icons.card_giftcard, color: Color(0xffffffff), size: SizeConfig.blockSizeVertical * 2,),
                                    ),
                                  ),

                                  SizedBox(width: SizeConfig.blockSizeHorizontal * 2,),

                                  Expanded(
                                    child: Text('${profile.data.almMemorial.showMemorialFollowersCount}',
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

                            SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                            Container(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularUserDonate(pageType: pageType, pageId: memorialId,)));
                                      },
                                      child: CircleAvatar(
                                        radius: SizeConfig.blockSizeVertical * 3,
                                        backgroundColor: Color(0xffE67E22),
                                        child: Icon(Icons.card_giftcard, color: Color(0xffffffff), size: SizeConfig.blockSizeVertical * 3,),
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

                                          context.showLoaderOverlay();
                                          bool result = await apiRegularModifyFollowPage(pageType: pageType, pageId: memorialId, follow: true);
                                          context.hideLoaderOverlay();

                                          if(result){
                                            Navigator.popAndPushNamed(context, '/home/regular');
                                          }else{
                                            await showDialog(
                                              context: context,
                                              builder: (_) => 
                                                AssetGiffyDialog(
                                                image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                                title: Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                                                entryAnimation: EntryAnimation.DEFAULT,
                                                description: Text('Something went wrong. Please try again.',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(),
                                                ),
                                                onlyOkButton: true,
                                                buttonOkColor: Colors.red,
                                                onOkButtonPressed: () {
                                                  Navigator.pop(context, true);
                                                },
                                              )
                                            );
                                          }
                                          
                                        },
                                        child: Text(
                                          join ? 'Unjoin' : 'Join',
                                          style: TextStyle(
                                            fontSize: SizeConfig.safeBlockHorizontal * 5,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xffffffff),
                                          ),
                                        ),
                                        minWidth: SizeConfig.screenWidth / 2,
                                        height: SizeConfig.blockSizeVertical * 7,
                                        shape: StadiumBorder(),
                                        color: join
                                        ? Color(0xff888888)
                                        : Color(0xff04ECFF),
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
                                      Image.asset('assets/icons/prayer_logo.png', height: SizeConfig.blockSizeVertical * 3,),
                                      SizedBox(width: SizeConfig.blockSizeHorizontal * 2,),
                                      Text('Roman Catholic',
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
                                      Icon(Icons.place, color: Color(0xff000000), size: SizeConfig.blockSizeVertical * 3,),
                                      SizedBox(width: SizeConfig.blockSizeHorizontal * 2,),
                                      Text(profile.data.almMemorial.showMemorialDetails.showMemorialDetailsBirthPlace,
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
                                      Text(profile.data.almMemorial.showMemorialDetails.showMemorialDetailsDob,
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
                                      Text(profile.data.almMemorial.showMemorialDetails.showMemorialDetailsRip,
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
                                      GestureDetector(
                                        onTap: () async{
                                          final launcher = const GoogleMapsLauncher();
                                          await launcher.launch(
                                            geoPoint: GeoPoint(0.0, 0.0),
                                          );
                                        },
                                        child: Text(profile.data.almMemorial.showMemorialDetails.showMemorialDetailsCemetery,
                                          style: TextStyle(
                                            fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                                            color: Color(0xff3498DB),
                                          ),
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

                                          Text(profile.data.almMemorial.showMemorialPostsCount.toString(),
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
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularConnectionList(memorialId: memorialId, newToggle: 0)));
                                      },
                                      child: Column(
                                        children: [
                                          SizedBox(height: SizeConfig.blockSizeVertical * 1,),

                                          Text(profile.data.almMemorial.showMemorialFamilyCount.toString(),
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
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularConnectionList(memorialId: memorialId, newToggle: 1)));
                                      },
                                      child: Column(
                                        children: [
                                          SizedBox(height: SizeConfig.blockSizeVertical * 1,),

                                          Text(profile.data.almMemorial.showMemorialFriendsCount.toString(),
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
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularConnectionList(memorialId: memorialId, newToggle: 2)));
                                      },
                                      child: Column(
                                        children: [
                                          SizedBox(height: SizeConfig.blockSizeVertical * 1,),

                                          Text('${profile.data.almMemorial.showMemorialFollowersCount}',
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
                                              child: ((){
                                                if(profile.data.almMemorial.showMemorialImagesOrVideos[index] == null || profile.data.almMemorial.showMemorialImagesOrVideos[index] == ''){
                                                  return Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,);
                                                }else{
                                                  return CachedNetworkImage(
                                                    fit: BoxFit.cover,
                                                    imageUrl: profile.data.almMemorial.showMemorialImagesOrVideos[index],
                                                    placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                                                    errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                  );
                                                }
                                              }()),
                                            ),
                                          );
                                        }, 
                                        separatorBuilder: (context, index){
                                          return SizedBox(width: SizeConfig.blockSizeHorizontal * 2,);
                                        },
                                        itemCount: profile.data.almMemorial.showMemorialImagesOrVideos.length,
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
                                        : Container(height: 0,),
                                      ],
                                    );
                                  },
                                  separatorBuilder: (c, i) => Divider(height: SizeConfig.blockSizeVertical * 2, color: Colors.transparent),
                                  itemCount: posts.length,
                                ),
                              ),
                            )
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
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        icon: Icon(Icons.arrow_back, color: Color(0xffffffff),), 
                        onPressed: (){
                          Navigator.pop(context);
                        },
                      ),

                    ),
                  ),

                  Container(
                    padding: EdgeInsets.only(right: 20.0),
                    height: Size.fromHeight(AppBar().preferredSize.height).height + (Size.fromHeight(AppBar().preferredSize.height).height / 2),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: MiscRegularDropDownMemorialTemplate(memorialName: profile.data.almMemorial.showMemorialName, memorialId: memorialId, pageType: pageType, reportType: 'Memorial',),
                    ),
                  ),

                  Positioned(
                    top: SizeConfig.screenHeight / 5,
                    child: Container(
                      height: SizeConfig.blockSizeVertical * 18,
                      width: SizeConfig.screenWidth,
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(),
                          ),
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
                          Expanded(
                            child: Container(
                              child: MiscRegularDropDownTemplate(postId: profile.data.almMemorial.showMemorialId, reportType: 'Memorial',),
                            ),
                          ),
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