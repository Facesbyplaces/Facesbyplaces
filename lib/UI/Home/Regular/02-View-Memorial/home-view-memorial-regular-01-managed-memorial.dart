import 'package:facesbyplaces/UI/Home/Regular/01-Main/home-main-regular-02-home-extended.dart';
import 'package:facesbyplaces/UI/Home/Regular/04-Create-Post/home-create-post-regular-01-create-post.dart';
import 'package:facesbyplaces/UI/Home/Regular/08-Settings-Memorial/home-settings-memorial-regular-08-memorial-settings-with-hidden.dart';
import 'package:facesbyplaces/UI/Home/Regular/08-Settings-Memorial/home-settings-memorial-regular-01-memorial-settings.dart';
import 'package:facesbyplaces/API/Regular/03-View-Memorial/api-view-memorial-regular-02-show-profile-post.dart';
import 'package:facesbyplaces/API/Regular/03-View-Memorial/api-view-memorial-regular-01-show-memorial-details.dart';
import 'package:facesbyplaces/API/Regular/03-View-Memorial/api-view-memorial-regular-03-show-switch-status.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-04-regular-post.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-08-regular-message.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'home-view-memorial-regular-03-connection-list.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:better_player/better_player.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'dart:async';

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
  final bool newlyCreated;

  HomeRegularProfile({this.memorialId, this.relationship, this.managed, this.newlyCreated});

  HomeRegularProfileState createState() => HomeRegularProfileState(memorialId: memorialId, relationship: relationship, managed: managed, newlyCreated: newlyCreated);
}

class HomeRegularProfileState extends State<HomeRegularProfile>{
  final int memorialId;
  final String relationship;
  final bool managed;
  final bool newlyCreated;

  HomeRegularProfileState({this.memorialId, this.relationship, this.managed, this.newlyCreated});

  RefreshController refreshController = RefreshController(initialRefresh: true);
  TextEditingController controller = TextEditingController();
  ScrollController scrollController = ScrollController();
  List<RegularProfilePosts> posts;
  Future<APIRegularShowMemorialMain> showProfile;
  GlobalKey dataKey;
  GlobalKey profileKey = GlobalKey<HomeRegularProfileState>();
  int itemRemaining;
  int postCount;
  bool empty;
  int page;
  BranchUniversalObject buo;
  BranchLinkProperties lp;

  BetterPlayerController betterPlayerController1;
  BetterPlayerController betterPlayerController2;

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
    APIRegularShowMemorialMain newValue = await apiRegularShowMemorial(memorialId: memorialId);
    if(newValue.almMemorial.showMemorialImagesOrVideos != null){
      if(lookupMimeType(newValue.almMemorial.showMemorialImagesOrVideos[0]).contains('video') == true){
        BetterPlayerDataSource betterPlayerDataSource = BetterPlayerDataSource(BetterPlayerDataSourceType.network, '${newValue.almMemorial.showMemorialImagesOrVideos[0]}');
        betterPlayerController1 = BetterPlayerController(BetterPlayerConfiguration(aspectRatio: 16 / 9,), betterPlayerDataSource: betterPlayerDataSource);
        betterPlayerController2 = BetterPlayerController(
          BetterPlayerConfiguration(
            autoPlay: true,
            controlsConfiguration: BetterPlayerControlsConfiguration(
              showControls: false,
            ),
            aspectRatio: 1 / 2,
          ), 
          betterPlayerDataSource: betterPlayerDataSource, 
        );
      }
    }
    return newValue;
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
    onLoading();
    showProfile = getProfileInformation(memorialId);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      body: SmartRefresher(
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
        child: CustomScrollView(
          controller: scrollController,
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: FutureBuilder<APIRegularShowMemorialMain>(
                future: showProfile,
                builder: (context, profile){
                  if(profile.hasData){
                    return Column(
                      key: profileKey,
                      children: [
                        Stack(
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

                                      SizedBox(height: 150,),

                                      Center(
                                        child: Text(profile.data.almMemorial.showMemorialName,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold, 
                                            color: Color(0xff000000),
                                          ),
                                          maxLines: 5,
                                          overflow: TextOverflow.clip,
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
                                                backgroundColor: Color(0xff000000),
                                                child: CircleAvatar(
                                                  radius: 10,
                                                  backgroundColor: Colors.transparent,
                                                  backgroundImage: AssetImage('assets/icons/fist.png'),
                                                ),
                                              ),
                                            ),

                                            SizedBox(width: 10,),

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

                                      SizedBox(height: 20,),

                                      Column(
                                        children: [
                                          ((){
                                            if(profile.data.almMemorial.showMemorialImagesOrVideos != null){
                                              return Container(
                                                padding: EdgeInsets.only(left: 20.0, right: 20.0,),
                                                child: BetterPlayer(
                                                  controller: betterPlayerController1,
                                                ),
                                              );
                                            }else{
                                              return Container(height: 0,);
                                            }
                                          }()),

                                          SizedBox(height: 20,),

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
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold,
                                                      color: Color(0xffffffff),
                                                    ),
                                                  ),
                                                  minWidth: SizeConfig.screenWidth / 2,
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
                                                Icon(Icons.place, color: Color(0xff000000), size: 25,),
                                                SizedBox(width: 20,),
                                                Text(profile.data.almMemorial.showMemorialDetails.showMemorialDetailsCountry,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Color(0xff000000),
                                                  ),
                                                ),
                                              ],
                                            ),

                                            SizedBox(height: 20,),

                                            Row(
                                              children: [
                                                Icon(Icons.star, color: Color(0xff000000), size: 25,),
                                                SizedBox(width: 20,),
                                                Text(profile.data.almMemorial.showMemorialDetails.showMemorialDetailsDob,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Color(0xff000000),
                                                  ),
                                                ),
                                              ],
                                            ),

                                            SizedBox(height: 20,),

                                            Row(
                                              children: [
                                                Image.asset('assets/icons/grave_logo.png', height: 25,),
                                                SizedBox(width: 20,),
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

                                                    Text('${profile.data.almMemorial.showMemorialPostsCount}',
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
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularConnectionList(memorialId: memorialId, newToggle: 0)));
                                                },
                                                child: Column(
                                                  children: [

                                                    Text('${profile.data.almMemorial.showMemorialFamilyCount}',
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
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularConnectionList(memorialId: memorialId, newToggle: 1)));
                                                },
                                                child: Column(
                                                  children: [
                                                    Text('${profile.data.almMemorial.showMemorialFriendsCount}',
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
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularConnectionList(memorialId: memorialId, newToggle: 2)));
                                                },
                                                child: Column(
                                                  children: [
                                                    Text('${profile.data.almMemorial.showMemorialFollowersCount}',
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
                                          SizedBox(height: 20),

                                          Container(
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
                                                height: 100,
                                                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                                                child: ListView.separated(
                                                  physics: ClampingScrollPhysics(),
                                                  scrollDirection: Axis.horizontal,
                                                  itemBuilder: (context, index){
                                                    return ((){
                                                      if(lookupMimeType(profile.data.almMemorial.showMemorialImagesOrVideos[index]).contains('video') == true){
                                                        return Container(
                                                          child: BetterPlayer(
                                                            controller: betterPlayerController2,
                                                          ),
                                                          width: 100, 
                                                          height: 100,
                                                        );
                                                      }else{
                                                        return GestureDetector(
                                                          onTap: (){
                                                            showGeneralDialog(
                                                              context: context,
                                                              barrierColor: Colors.black12.withOpacity(0.7),
                                                              barrierDismissible: true,
                                                              barrierLabel: 'Dialog',
                                                              transitionDuration: Duration(milliseconds: 400),
                                                              pageBuilder: (_, __, ___) {
                                                                return SizedBox.expand(
                                                                  child: SafeArea(
                                                                    child: Column(
                                                                      children: [
                                                                        Container(
                                                                          height: 50,
                                                                          padding: EdgeInsets.only(right: 20.0),
                                                                          alignment: Alignment.centerRight,
                                                                          child: GestureDetector(
                                                                            onTap: (){
                                                                              Navigator.pop(context);
                                                                            },
                                                                            child: Icon(Icons.close_rounded, color: Color(0xffffffff), size: 30,),
                                                                          ),
                                                                        ),
                                                                        Expanded(
                                                                          child: CachedNetworkImage(
                                                                            fit: BoxFit.cover,
                                                                            imageUrl: profile.data.almMemorial.showMemorialImagesOrVideos[index],
                                                                            placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                                                                            errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            );
                                                          },
                                                          child: Container(
                                                            width: 100,
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
                                                      }
                                                    }());
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

                                    ],
                                  ),
                                ),
                              ],
                            ),

                            SafeArea(
                              child: Container(
                                height: Size.fromHeight(AppBar().preferredSize.height).height + (Size.fromHeight(AppBar().preferredSize.height).height / 2),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 20.0),
                                        child: GestureDetector(
                                          onTap: (){
                                            if(newlyCreated == true){
                                              Route newRoute = MaterialPageRoute(builder: (context) => HomeRegularScreenExtended(newToggleBottom: 1,),);
                                              Navigator.pushAndRemoveUntil(context, newRoute, (route) => false);
                                            }else{
                                              Navigator.pop(context);
                                            }
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

                                            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularCreatePost(name: profile.data.almMemorial.showMemorialName, memorialId: profile.data.almMemorial.showMemorialId)));

                                          },
                                          shape: StadiumBorder(),
                                          color: Colors.green,
                                          splashColor: Colors.yellow,
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
                            ),

                            Positioned(
                              top: SizeConfig.screenHeight / 5,
                              child: Container(
                                height: 160,
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

            SliverToBoxAdapter(
              child: postCount != 0
              ? Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Column(
                      children: List.generate(
                        posts.length, 
                        (i) => Padding(
                          padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                          child: MiscRegularPost(
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

                              posts[i].imagesOrVideos != null
                              ? Column(
                                children: [
                                  SizedBox(height: 20),
                                  
                                  Container(
                                    child: ((){
                                      if(posts[i].imagesOrVideos != null){
                                        if(posts[i].imagesOrVideos.length == 1){
                                          if(lookupMimeType(posts[i].imagesOrVideos[0]).contains('video') == true){
                                            return BetterPlayer.network('${posts[i].imagesOrVideos[0]}',
                                              betterPlayerConfiguration: BetterPlayerConfiguration(
                                                controlsConfiguration: BetterPlayerControlsConfiguration(
                                                  showControls: false,
                                                ),
                                                aspectRatio: 16 / 9,
                                              ),
                                            );
                                          }else{
                                            return Container(
                                              child: CachedNetworkImage(
                                                fit: BoxFit.contain,
                                                imageUrl: posts[i].imagesOrVideos[0],
                                                placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                                                errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 1.0,),
                                              ),
                                            );
                                          }
                                        }else if(posts[i].imagesOrVideos.length == 2){
                                          return StaggeredGridView.countBuilder(
                                            padding: EdgeInsets.zero,
                                            shrinkWrap: true,
                                            physics: NeverScrollableScrollPhysics(),
                                            crossAxisCount: 4,
                                            itemCount: 2,
                                            itemBuilder: (BuildContext context, int index) =>  
                                              lookupMimeType(posts[i].imagesOrVideos[index]).contains('video') == true
                                              ? BetterPlayer.network('${posts[i].imagesOrVideos[index]}',
                                                betterPlayerConfiguration: BetterPlayerConfiguration(
                                                  controlsConfiguration: BetterPlayerControlsConfiguration(
                                                    showControls: false,
                                                  ),
                                                  aspectRatio: 16 / 9,
                                                ),
                                              )
                                              : CachedNetworkImage(
                                                fit: BoxFit.contain,
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
                                            shrinkWrap: true,
                                            physics: NeverScrollableScrollPhysics(),
                                            crossAxisCount: 4,
                                            itemCount: 3,
                                            itemBuilder: (BuildContext context, int index) => 
                                            ((){
                                              if(index != 1){
                                                return lookupMimeType(posts[i].imagesOrVideos[index]).contains('video') == true
                                                ? BetterPlayer.network('${posts[i].imagesOrVideos[index]}',
                                                  betterPlayerConfiguration: BetterPlayerConfiguration(
                                                    controlsConfiguration: BetterPlayerControlsConfiguration(
                                                      showControls: false,
                                                    ),
                                                    aspectRatio: 16 / 9,
                                                  ),
                                                )
                                                : CachedNetworkImage(
                                                  fit: BoxFit.contain,
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
                                                          BetterPlayer.network('${posts[i].imagesOrVideos[index]}',
                                                            betterPlayerConfiguration: BetterPlayerConfiguration(
                                                              controlsConfiguration: BetterPlayerControlsConfiguration(
                                                                showControls: false,
                                                              ),
                                                              aspectRatio: 16 / 9,
                                                            ),
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
                                                      return BetterPlayer.network('${posts[i].imagesOrVideos[index]}',
                                                        betterPlayerConfiguration: BetterPlayerConfiguration(
                                                          controlsConfiguration: BetterPlayerControlsConfiguration(
                                                            showControls: false,
                                                          ),
                                                          aspectRatio: 16 / 9,
                                                        ),
                                                      );
                                                    }else{
                                                      return CachedNetworkImage(
                                                        fit: BoxFit.contain,
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
                            ],
                          ),
                        ),
                      ),
                    ),

                    MaterialButton(
                      padding: EdgeInsets.zero,
                      onPressed: () async{
                        Scrollable.ensureVisible(profileKey.currentContext);
                      },
                      child: Icon(Icons.arrow_upward_rounded, color: Color(0xff4EC9D4,),),
                      minWidth: SizeConfig.screenWidth / 2,
                      height: 45,
                      color: Color(0xffffffff),
                      shape: CircleBorder(),
                    ),

                    SizedBox(height: 20,),
                  ],
                ),
              )
              : Column(
                children: [

                  SizedBox(height: 40,),

                  Center(child: Image.asset('assets/icons/app-icon.png', height: 250, width: 250,),),

                  SizedBox(height: 45,),

                  Center(child: Text('Post is empty', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xffB1B1B1),),),),

                  SizedBox(height: 40,),

                ],
              ),
              
            ),
          ]
        ),
      ),
    );
  }
}