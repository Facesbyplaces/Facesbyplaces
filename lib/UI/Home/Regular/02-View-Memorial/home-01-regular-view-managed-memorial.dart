import 'package:facesbyplaces/UI/Home/Regular/Create-Post/home-09-01-regular-create-post.dart';
import 'package:facesbyplaces/UI/Home/Regular/Settings-Memorial/home-09-regular-memorial-settings.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-13-regular-post.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-14-regular-message.dart';
import 'package:facesbyplaces/API/Regular/api-53-regular-show-profile.dart';
import 'package:facesbyplaces/API/Regular/api-54-show-memorial.dart';
import 'package:facesbyplaces/API/Regular/api-55-regular-show-switch-status.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/Configurations/date-conversion.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:path_provider/path_provider.dart';
import 'home-02-regular-connection-list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:typed_data';
import 'dart:async';
import 'dart:io';

class RegularRelationshipItemPost{

  final String name;
  final File image;
  final int memorialId;
  
  const RegularRelationshipItemPost({this.name, this.image, this.memorialId});
}

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

  RegularProfilePosts({this.userId, this.postId, this.memorialId, this.memorialName, this.timeCreated, this.postBody, this.profileImage, this.imagesOrVideos, this.managed, this.joined, this.numberOfComments, this.numberOfLikes, this.likeStatus});
}

class HomeRegularProfile extends StatefulWidget{
  final int memorialId;
  HomeRegularProfile({this.memorialId});

  HomeRegularProfileState createState() => HomeRegularProfileState(memorialId: memorialId);
}

class HomeRegularProfileState extends State<HomeRegularProfile> with WidgetsBindingObserver{
  final int memorialId;
  HomeRegularProfileState({this.memorialId});

  RefreshController refreshController = RefreshController(initialRefresh: true);
  TextEditingController controller = TextEditingController();
  List<RegularProfilePosts> posts;
  Future showProfile;
  GlobalKey dataKey;
  int itemRemaining;
  int postCount;
  bool empty;
  int page;

  String category;
  BranchUniversalObject buo;
  BranchLinkProperties lp;
  BranchContentMetaData metadata;

  void onRefresh() async{
    await Future.delayed(Duration(milliseconds: 1000));
    refreshController.refreshCompleted();
  }  

  void onLoading() async{
    if(itemRemaining != 0){
      var newValue = await apiRegularProfilePost(memorialId, page);
      itemRemaining = newValue.itemsRemaining;
      postCount = newValue.familyMemorialList.length;

      for(int i = 0; i < newValue.familyMemorialList.length; i++){
        posts.add(RegularProfilePosts(
          userId: newValue.familyMemorialList[i].page.pageCreator.id, 
          postId: newValue.familyMemorialList[i].id,
          memorialId: newValue.familyMemorialList[i].page.id,
          timeCreated: newValue.familyMemorialList[i].createAt,
          memorialName: newValue.familyMemorialList[i].page.name,
          postBody: newValue.familyMemorialList[i].body,
          profileImage: newValue.familyMemorialList[i].page.profileImage,
          imagesOrVideos: newValue.familyMemorialList[i].page.imagesOrVideos,
          
          managed: newValue.familyMemorialList[i].page.manage,
          joined: newValue.familyMemorialList[i].page.follower,
          numberOfComments: newValue.familyMemorialList[i].numberOfComments,
          numberOfLikes: newValue.familyMemorialList[i].numberOfLikes,
          likeStatus: newValue.familyMemorialList[i].likeStatus,  
          ),
        );
      }

      if(mounted)
      setState(() {});
      
      refreshController.loadComplete();
    }else{
      refreshController.loadNoData();
    }
  }

  Future<APIRegularShowMemorialMain> getProfileInformation(int memorialId) async{
    return await apiRegularShowMemorial(memorialId: memorialId);
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
    initDeepLinkData();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void initDeepLinkData(){
    buo = BranchUniversalObject(
      canonicalIdentifier: 'flutter/branch',
      title: 'Flutter Branch Plugin',
      imageUrl: 'https://flutter.dev/assets/flutter-lockup-4cb0ee072ab312e59784d9fbf4fb7ad42688a7fdaea1270ccf6bbf4f34b7e03f.svg',
      contentDescription: 'Flutter Branch Description',
      keywords: ['Plugin', 'Branch', 'Flutter'],
      publiclyIndex: true,
      locallyIndex: true,
      contentMetadata: BranchContentMetaData()..addCustomMetadata('custom_string', 'abc')
          ..addCustomMetadata('custom_number', 12345)
          ..addCustomMetadata('custom_bool', true)
          ..addCustomMetadata('custom_list_number', [1,2,3,4,5 ])
          ..addCustomMetadata('custom_list_string', ['a', 'b', 'c']),
    );

    lp = BranchLinkProperties(
        channel: 'facebook',
        feature: 'sharing',
        stage: 'new share',
      tags: ['one', 'two', 'three']
    );
    lp.addControlParam('url2', 'https://29cft.test-app.link/mrY1OGhsjcb');
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
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: profile.data.memorial.backgroundImage,
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
                              child: Text(profile.data.memorial.name,
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
                                    child: Text('45',
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

                            ((){
                              if(profile.data.memorial.details.description != '' || profile.data.memorial.details.description != null){
                                return Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.only(left: 20.0, right: 20.0),
                                  child: Text(profile.data.memorial.details.description,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: SizeConfig.safeBlockHorizontal * 4,
                                      fontWeight: FontWeight.w300,
                                      color: Color(0xff000000),
                                    ),
                                  ),
                                );
                              }else if(profile.data.memorial.imagesOrVideos != null){
                                return Container(
                                  padding: EdgeInsets.only(left: 20.0, right: 20.0),
                                  child: Stack(
                                    children: [
                                      Container(
                                        height: SizeConfig.blockSizeHorizontal * 40,
                                        child: CachedNetworkImage(
                                          fit: BoxFit.cover,
                                          imageUrl: profile.data.memorial.imagesOrVideos,
                                          placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                                          errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                        ),
                                      ),

                                      Positioned(
                                        top: SizeConfig.blockSizeVertical * 7,
                                        left: SizeConfig.screenWidth / 2.8,
                                        child: Icon(Icons.play_arrow_rounded, color: Color(0xffffffff), size: SizeConfig.blockSizeVertical * 10,),
                                      ),
                                    ],
                                  ),
                                );
                              }else{
                                return Container(height: 0,);
                              }
                            }()),

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
                                          context.showLoaderOverlay();
                                          APIRegularShowSwitchStatus result = await apiRegularShowSwitchStatus(memorialId);
                                          context.hideLoaderOverlay();

                                          if(result.success){
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularMemorialSettings(memorialId: memorialId, switchFamily: result.family, switchFriends: result.friends, switchFollowers: result.followers,)));
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


                                          DateTime date = DateTime.now();
                                          String id = date.toString().replaceAll('-', '').replaceAll(' ', '').replaceAll(':', '').replaceAll('.', '') + 'id-share-alm-memorial';
                                          // FlutterBranchSdk.setIdentity('id-$id-share-memorial');
                                          FlutterBranchSdk.setIdentity(id);

                                          BranchResponse response =
                                              await FlutterBranchSdk.getShortUrl(buo: buo, linkProperties: lp);
                                          if (response.success) {
                                            print('Link generated: ${response.result}');
                                          } else {
                                              print('Error : ${response.errorCode} - ${response.errorMessage}');
                                          }

                                          BranchResponse shareResult = await FlutterBranchSdk.showShareSheet(
                                            buo: buo,
                                            linkProperties: lp,
                                            messageText: profile.data.memorial.name,
                                            androidMessageTitle: 'Share ${profile.data.memorial.name} memorial',
                                            androidSharingTitle: profile.data.memorial.name,
                                          );


                                          print('The value of deep link response is ${response.errorMessage}');
                                          print('The value of deep link response is ${response.errorCode}');
                                          print('The value of deep link response is ${response.result}');
                                          print('The value of deep link response is ${response.success}');

                                          if (response.success) {
                                            print('deep link showShareSheet Sucess');
                                          } else {
                                            print('deep link Error : ${response.errorCode} - ${response.errorMessage}');
                                          }

                                          print('The value of response is ${shareResult.errorMessage}');
                                          print('The value of response is ${shareResult.errorCode}');
                                          print('The value of response is ${shareResult.result}');
                                          print('The value of response is ${shareResult.success}');

                                          if (shareResult.success) {
                                            print('showShareSheet Sucess');
                                          } else {
                                            print('Error : ${shareResult.errorCode} - ${shareResult.errorMessage}');
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
                                      Text(profile.data.memorial.details.country,
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
                                      Text(convertDate(profile.data.memorial.details.dob),
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
                                      Text(convertDate(profile.data.memorial.details.rip),
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

                                          Text(profile.data.memorial.postsCount.toString(),
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

                                          Text(profile.data.memorial.familyCount.toString(),
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

                                          Text(profile.data.memorial.friendsCount.toString(),
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

                                          Text(profile.data.memorial.followersCount.toString(),
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

                                profile.data.memorial.imagesOrVideos != null
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
                                          return Container(
                                            width: SizeConfig.blockSizeVertical * 12,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              color: Color(0xff888888),
                                            ),
                                            child: CachedNetworkImage(
                                              fit: BoxFit.cover,
                                              imageUrl: profile.data.memorial.imagesOrVideos[index],
                                              placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                                              errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                            ),
                                          );
                                        }, 
                                        separatorBuilder: (context, index){
                                          return SizedBox(width: SizeConfig.blockSizeHorizontal * 2,);
                                        },
                                        itemCount: profile.data.memorial.imagesOrVideos.length,
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
                              height: SizeConfig.screenHeight / 1.5 - kToolbarHeight,
                              child: SmartRefresher(
                                enablePullDown: false,
                                enablePullUp: true,
                                header: MaterialClassicHeader(),
                                footer: CustomFooter(
                                  loadStyle: LoadStyle.ShowWhenLoading,
                                  builder: (BuildContext context, LoadStatus mode){
                                    Widget body;
                                    if(mode == LoadStatus.idle){
                                      body =  Text('Pull up load', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
                                    }
                                    else if(mode == LoadStatus.loading){
                                      body =  CircularProgressIndicator();
                                    }
                                    else if(mode == LoadStatus.failed){
                                      body = Text('Load Failed! Click retry!', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
                                    }
                                    else if(mode == LoadStatus.canLoading){
                                      body = Text('Release to load more', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
                                      page++;
                                    }
                                    else{
                                      body = Text('End of result.', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
                                    }
                                    return Container(height: 55.0, child: Center(child: body),
                                    );
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
                                      timeCreated: convertDate(posts[i].timeCreated),

                                      managed: posts[i].managed,
                                      joined: posts[i].joined,
                                      profileImage: posts[i].profileImage,
                                      numberOfComments: posts[i].numberOfComments,
                                      numberOfLikes: posts[i].numberOfLikes,
                                      likeStatus: posts[i].likeStatus,
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
                                            errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                          ),
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
                            : Container(
                              padding: EdgeInsets.all(10.0),
                              height: SizeConfig.screenHeight / 1.5 - kToolbarHeight,
                              child: Center(
                                child: Text('Post is empty.', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),)),
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
                            child: MaterialButton(
                              onPressed: () async{

                                final ByteData bytes = await rootBundle.load('assets/icons/graveyard.png');
                                final Uint8List list = bytes.buffer.asUint8List();

                                final tempDir = await getTemporaryDirectory();
                                final file = await new File('${tempDir.path}/regular-post-image.png').create();
                                file.writeAsBytesSync(list);

                                Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularCreatePost(name: profile.data.memorial.name, memorialId: profile.data.memorial.id)));

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
                            ),
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
                                  backgroundImage: CachedNetworkImageProvider(
                                    profile.data.memorial.profileImage,
                                    scale: 1.0,
                                  ),
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




