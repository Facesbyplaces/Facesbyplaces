import 'package:facesbyplaces/API/BLM/03-View-Memorial/api-view-memorial-blm-01-show-memorial-details.dart';
import 'package:facesbyplaces/API/BLM/03-View-Memorial/api-view-memorial-blm-02-show-profile-post.dart';
import 'package:facesbyplaces/API/BLM/03-View-Memorial/api-view-memorial-blm-03-show-switch-status.dart';
import 'package:facesbyplaces/UI/Home/BLM/01-Main/home-main-blm-02-home-extended.dart';
import 'package:facesbyplaces/UI/Home/BLM/04-Create-Post/home-create-post-blm-01-create-post.dart';
import 'package:facesbyplaces/UI/Home/BLM/08-Settings-Memorial/home-settings-memorial-blm-01-memorial-settings.dart';
import 'package:facesbyplaces/UI/Home/BLM/08-Settings-Memorial/home-settings-memorial-blm-08-memorial-settings-with-hidden.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-04-blm-post.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-08-blm-message.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'home-view-memorial-blm-03-connection-list.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:better_player/better_player.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'dart:async';

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

  BLMProfilePosts({required this.userId, required this.postId, required this.memorialId, required this.memorialName, required this.timeCreated, required this.postBody, required this.profileImage, required this.imagesOrVideos, required this.managed, required this.joined, required this.numberOfLikes, required this.numberOfComments, required this.likeStatus, required this.numberOfTagged, required this.taggedFirstName, required this.taggedLastName, required this.taggedImage, required this.taggedId, required this.pageType, required this.famOrFriends, required this.relationship});
}

class HomeBLMProfile extends StatefulWidget{
  final int memorialId;
  final String relationship;
  final bool managed;
  final bool newlyCreated;

  HomeBLMProfile({required this.memorialId, required this.relationship, required this.managed, required this.newlyCreated});

  HomeBLMProfileState createState() => HomeBLMProfileState(memorialId: memorialId, relationship: relationship, managed: managed, newlyCreated: newlyCreated);
}

class HomeBLMProfileState extends State<HomeBLMProfile>{
  final int memorialId;
  final String relationship;
  final bool managed;
  final bool newlyCreated;

  HomeBLMProfileState({required this.memorialId, required this.relationship, required this.managed, required this.newlyCreated});

  TextEditingController controller = TextEditingController();
  ScrollController scrollController = ScrollController();
  List<BLMProfilePosts> posts = [];
  Future<APIBLMShowMemorialMain>? showProfile;
  GlobalKey dataKey = GlobalKey<HomeBLMProfileState>();
  GlobalKey profileKey = GlobalKey<HomeBLMProfileState>();
  int itemRemaining = 1;
  int postCount = 0;
  bool empty = true;
  int page = 1;
  BranchUniversalObject? buo;
  BranchLinkProperties? lp;

  void initState(){
    super.initState();
    onLoading();
    showProfile = getProfileInformation(memorialId);
  }

  Future<void> onRefresh() async{
    setState(() {
      onLoading();
    });
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
          timeCreated: newValue.blmFamilyMemorialList[i].profilePostCreatedAt,
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
    lp!.addControlParam('url', 'https://4n5z1.test-app.link/qtdaGGTx3cb?bnc_validate=true');
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: CustomScrollView(
          physics: ClampingScrollPhysics(),
          controller: scrollController,
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: FutureBuilder<APIBLMShowMemorialMain>(
                future: showProfile,
                builder: (context, profile){
                  if(profile.hasData){
                    return Column(
                      key: profileKey,
                      children: [
                        Stack(
                          children: [

                            Container(
                              height: SizeConfig.screenHeight! / 3,
                              width: SizeConfig.screenWidth,
                              child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl: profile.data!.blmMemorial.memorialBackgroundImage,
                                placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                                errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                              ),
                            ),

                            Column(
                              children: [

                                Container(height: SizeConfig.screenHeight! / 3.5, color: Colors.transparent,),

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
                                        child: Text(profile.data!.blmMemorial.memorialName,
                                          textAlign: TextAlign.center,
                                          maxLines: 5,
                                          overflow: TextOverflow.clip,
                                          style: TextStyle(
                                            fontSize: 20, 
                                            fontWeight: FontWeight.bold, 
                                            color: Color(0xff000000),
                                          ),
                                        ),
                                      ),

                                      SizedBox(height: 20),

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

                                            SizedBox(height: 20,),

                                            Expanded(
                                              child: Text('${profile.data!.blmMemorial.memorialFollowersCount}',
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

                                      Column(
                                        children: [
                                          ((){
                                            if(profile.data!.blmMemorial.memorialImagesOrVideos.isNotEmpty){
                                              return BetterPlayer.network('${profile.data!.blmMemorial.memorialImagesOrVideos[0]}',
                                                betterPlayerConfiguration: BetterPlayerConfiguration(
                                                  controlsConfiguration: BetterPlayerControlsConfiguration(
                                                    showControls: false,
                                                  ),
                                                  aspectRatio: 16 / 9,
                                                ),
                                              );
                                            }else{
                                              return Container(height: 0,);
                                            }
                                          }()),

                                          SizedBox(height: 20,),

                                          ((){
                                            if(profile.data!.blmMemorial.memorialDetails.memorialDetailsDescription != ''){
                                              return Container(
                                                alignment: Alignment.center,
                                                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                                                child: Text(profile.data!.blmMemorial.memorialDetails.memorialDetailsDescription,
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
                                                      APIBLMShowSwitchStatus result = await apiBLMShowSwitchStatus(memorialId: memorialId);
                                                      context.hideLoaderOverlay();

                                                      if(result.switchStatusSuccess){
                                                        Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMMemorialSettings(memorialId: memorialId, memorialName: profile.data!.blmMemorial.memorialName, switchFamily: result.switchStatusFamily, switchFriends: result.switchStatusFriends, switchFollowers: result.switchStatusFollowers,)));
                                                      }
                                                    }else{
                                                      Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMMemorialSettingsWithHidden(memorialId: memorialId, relationship: relationship,)));
                                                    }
                                                    
                                                  },
                                                  child: Text('Manage',
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight: FontWeight.bold,
                                                      color: Color(0xffffffff),
                                                    ),
                                                  ),
                                                  minWidth: SizeConfig.screenWidth! / 2,
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

                                                  FlutterBranchSdk.setIdentity('blm-share-link');

                                                  BranchResponse response = await FlutterBranchSdk.showShareSheet(
                                                    buo: buo!,
                                                    linkProperties: lp!,
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

                                      SizedBox(height: 20),

                                      Padding(
                                        padding: EdgeInsets.only(left: 20),
                                        child: Column(
                                          children: [

                                            Row(
                                              children: [
                                                Icon(Icons.place, color: Color(0xff000000), size: 25,),
                                                SizedBox(width: 20,),
                                                Expanded(
                                                  child: Text(profile.data!.blmMemorial.memorialDetails.memorialDetailsCountry,
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Color(0xff000000),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),

                                            SizedBox(height: 20),

                                            Row(
                                              children: [
                                                Icon(Icons.star, color: Color(0xff000000), size: 25,),
                                                SizedBox(width: 20,),
                                                Expanded(
                                                  child: Text(profile.data!.blmMemorial.memorialDetails.memorialDetailsDob,
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Color(0xff000000),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),

                                            SizedBox(height: 20),

                                            Row(
                                              children: [
                                                Image.asset('assets/icons/grave_logo.png', height: 25,),
                                                SizedBox(width: 20,),
                                                Expanded(
                                                  child: Text(profile.data!.blmMemorial.memorialDetails.memorialDetailsRip,
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Color(0xff000000),
                                                    ),
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
                                                  Scrollable.ensureVisible(dataKey.currentContext!);
                                                },
                                                child: Column(
                                                  children: [

                                                    Text('${profile.data!.blmMemorial.memorialPostsCount}',
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

                                                    Text('${profile.data!.blmMemorial.memorialFamilyCount}',
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
                                                    Text('${profile.data!.blmMemorial.memorialFriendsCount}',
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

                                                    Text('${profile.data!.blmMemorial.memorialFollowersCount}',
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

                                          profile.data!.blmMemorial.memorialImagesOrVideos.isNotEmpty
                                          ? Column(
                                            children: [
                                              Container(
                                                width: SizeConfig.screenWidth,
                                                height: 100,
                                                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                                                child: ListView.separated(
                                                  physics: ClampingScrollPhysics(),
                                                  scrollDirection: Axis.horizontal,
                                                  separatorBuilder: (context, index){
                                                    return SizedBox(width: 20);
                                                  },
                                                  itemCount: profile.data!.blmMemorial.memorialImagesOrVideos.length,
                                                  itemBuilder: (context, index){
                                                    return ((){
                                                      if(lookupMimeType(profile.data!.blmMemorial.memorialImagesOrVideos[index])?.contains('video') == true){
                                                        return Container(
                                                          width: 100,
                                                          height: 100,
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(10),
                                                            color: Color(0xff888888),
                                                          ),
                                                          child: BetterPlayer.network('${profile.data!.blmMemorial.memorialImagesOrVideos[0]}',
                                                            betterPlayerConfiguration: BetterPlayerConfiguration(
                                                              controlsConfiguration: BetterPlayerControlsConfiguration(
                                                                showControls: false,
                                                              ),
                                                              aspectRatio: 16 / 9,
                                                            ),
                                                          ),
                                                        );
                                                      }else{
                                                        return GestureDetector(
                                                          onTap: (){
                                                            showGeneralDialog(
                                                              context: context,
                                                              barrierColor: Colors.black12.withOpacity(0.7),
                                                              barrierDismissible: true,
                                                              barrierLabel: 'Dialog',
                                                              transitionDuration: Duration(milliseconds: 0),
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
                                                                            imageUrl: profile.data!.blmMemorial.memorialImagesOrVideos[index],
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
                                                              imageUrl: profile.data!.blmMemorial.memorialImagesOrVideos[index],
                                                              placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                                                              errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                    }());
                                                  },
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
                                              Route newRoute = MaterialPageRoute(builder: (context) => HomeBLMScreenExtended(newToggleBottom: 1,),);
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

                                            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMCreatePost(name: profile.data!.blmMemorial.memorialName, memorialId: profile.data!.blmMemorial.memorialId)));

                                          },
                                          shape: StadiumBorder(),
                                          color: Colors.green,
                                          splashColor: Colors.yellow,
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
                              top: SizeConfig.screenHeight! / 5,
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
                                          child: profile.data!.blmMemorial.memorialProfileImage != ''
                                          ? CircleAvatar(
                                            radius: 100,
                                            backgroundColor: Color(0xff888888),
                                            backgroundImage: NetworkImage(profile.data!.blmMemorial.memorialProfileImage),
                                          )
                                          : CircleAvatar(
                                            radius: 100,
                                            backgroundColor: Color(0xff888888),
                                            backgroundImage: AssetImage('assets/icons/app-icon.png'),
                                          )
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
                    return MiscBLMErrorMessageTemplate();
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

                              posts[i].imagesOrVideos.isNotEmpty
                              ? Column(
                                children: [
                                  SizedBox(height: 20),

                                  Container(
                                    child: ((){
                                      if(posts[i].imagesOrVideos.length == 1){
                                        if(lookupMimeType(posts[i].imagesOrVideos[0])?.contains('video') == true){
                                          return BetterPlayer.network('${posts[i].imagesOrVideos[0]}',
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
                                            imageUrl: posts[i].imagesOrVideos[0],
                                            placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                                            errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 1.0,),
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
                                            lookupMimeType(posts[i].imagesOrVideos[index])?.contains('video') == true
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
                                          staggeredTileBuilder: (int index) => StaggeredTile.count(2, index.isEven ? 1 : 2),
                                          mainAxisSpacing: 4.0,
                                          crossAxisSpacing: 4.0,
                                          itemBuilder: (BuildContext context, int index) => ((){
                                            if(index != 1){
                                              return lookupMimeType(posts[i].imagesOrVideos[index])?.contains('video') == true
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
                                                  if(lookupMimeType(posts[i].imagesOrVideos[index])?.contains('video') == true){
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
                                                          fit: BoxFit.fill,
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
                                                  if(lookupMimeType(posts[i].imagesOrVideos[index])?.contains('video') == true){
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
                                                      fit: BoxFit.fill,
                                                      imageUrl: posts[i].imagesOrVideos[index],
                                                      placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                                                      errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 1.0,),
                                                    );
                                                  }
                                                }
                                              }());
                                            }
                                          }()),
                                        );
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
                        Scrollable.ensureVisible(profileKey.currentContext!);
                      },
                      child: Icon(Icons.arrow_upward_rounded, color: Color(0xff4EC9D4,),),
                      minWidth: SizeConfig.screenWidth! / 2,
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
          ],
        ),
      ),
    );
  }
}