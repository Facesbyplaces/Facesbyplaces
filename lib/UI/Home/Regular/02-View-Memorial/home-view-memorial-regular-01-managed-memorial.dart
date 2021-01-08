import 'package:facesbyplaces/UI/Home/Regular/04-Create-Post/home-create-post-regular-01-create-post.dart';
import 'package:facesbyplaces/UI/Home/Regular/08-Settings-Memorial/home-settings-memorial-regular-01-memorial-settings.dart';
import 'package:facesbyplaces/API/Regular/03-View-Memorial/api-view-memorial-regular-01-show-profile-post.dart';
import 'package:facesbyplaces/API/Regular/03-View-Memorial/api-view-memorial-regular-02-show-memorial-details.dart';
import 'package:facesbyplaces/API/Regular/03-View-Memorial/api-view-memorial-regular-03-show-switch-status.dart';
import 'package:facesbyplaces/UI/Home/Regular/08-Settings-Memorial/home-settings-memorial-regular-08-memorial-settings-with-hidden.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-13-regular-post.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-14-regular-message.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/Configurations/date-conversion.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'home-view-memorial-regular-03-connection-list.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:path_provider/path_provider.dart';
import 'package:timeago/timeago.dart' as timeago;
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
  int numberOfTagged;
  List<String> taggedFirstName;
  List<String> taggedLastName;
  List<String> taggedImage;
  List<int> taggedId;

  RegularProfilePosts({this.userId, this.postId, this.memorialId, this.memorialName, this.timeCreated, this.postBody, this.profileImage, this.imagesOrVideos, this.managed, this.joined, this.numberOfComments, this.numberOfLikes, this.likeStatus, this.numberOfTagged, this.taggedFirstName, this.taggedLastName, this.taggedImage, this.taggedId,});
}

class HomeRegularProfile extends StatefulWidget{
  final int memorialId;
  final String relationship;
  final bool managed;
  HomeRegularProfile({this.memorialId, this.relationship, this.managed,});

  HomeRegularProfileState createState() => HomeRegularProfileState(memorialId: memorialId, relationship: relationship, managed: managed);
}

class HomeRegularProfileState extends State<HomeRegularProfile> with WidgetsBindingObserver{
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

        posts.add(RegularProfilePosts(
          userId: newValue.familyMemorialList[i].postPage.pageCreator.id, 
          postId: newValue.familyMemorialList[i].postId,
          memorialId: newValue.familyMemorialList[i].postPage.id,
          timeCreated: newValue.familyMemorialList[i].postCreatedAt,
          memorialName: newValue.familyMemorialList[i].postPage.name,
          postBody: newValue.familyMemorialList[i].postBody,
          profileImage: newValue.familyMemorialList[i].postPage.profileImage,
          imagesOrVideos: newValue.familyMemorialList[i].postImagesOrVideos,
          
          managed: newValue.familyMemorialList[i].postPage.manage,
          joined: newValue.familyMemorialList[i].postPage.follower,
          numberOfComments: newValue.familyMemorialList[i].postNumberOfComments,
          numberOfLikes: newValue.familyMemorialList[i].postNumberOfLikes,
          likeStatus: newValue.familyMemorialList[i].postLikeStatus,

          numberOfTagged: newValue.familyMemorialList[i].postTagged.length,
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
    ResponsiveWidgets.init(context,
      height: SizeConfig.screenHeight,
      width: SizeConfig.screenWidth,
    );
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
                      imageUrl: profile.data.memorial.memorialBackgroundImage,
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

                            SizedBox(height: ScreenUtil().setHeight(105)),

                            Center(
                              child: Text(profile.data.memorial.memorialName,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: ScreenUtil().setSp(20, allowFontScalingSelf: true),
                                  fontWeight: FontWeight.bold, 
                                  color: Color(0xff000000),
                                ),
                                maxLines: 5,
                                overflow: TextOverflow.clip,
                              ),
                            ),

                            SizedBox(height: ScreenUtil().setHeight(20)),

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

                                  SizedBox(width: ScreenUtil().setWidth(10)),

                                  Expanded(
                                    child: Text('${profile.data.memorial.memorialFollowersCount}',
                                      style: TextStyle(
                                        fontSize: ScreenUtil().setSp(16, allowFontScalingSelf: true),
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xff000000),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: ScreenUtil().setHeight(20)),

                            ((){
                              if(profile.data.memorial.memorialDetails.description != '' || profile.data.memorial.memorialDetails.description != null){
                                return Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.only(left: 20.0, right: 20.0),
                                  child: Text(profile.data.memorial.memorialDetails.description,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: ScreenUtil().setSp(16, allowFontScalingSelf: true),
                                      fontWeight: FontWeight.w300,
                                      color: Color(0xff000000),
                                    ),
                                  ),
                                );
                              }else if(profile.data.memorial.memorialImagesOrVideos != null){
                                return Container(
                                  padding: EdgeInsets.only(left: 20.0, right: 20.0),
                                  child: Stack(
                                    children: [
                                      Container(
                                        height: SizeConfig.blockSizeHorizontal * 40,
                                        child: CachedNetworkImage(
                                          fit: BoxFit.cover,
                                          imageUrl: profile.data.memorial.memorialImagesOrVideos[0],
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

                            SizedBox(height: ScreenUtil().setHeight(20)),

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
                                            APIRegularShowSwitchStatus result = await apiRegularShowSwitchStatus(memorialId);
                                            context.hideLoaderOverlay();

                                            if(result.success){
                                              Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularMemorialSettings(memorialId: memorialId, memorialName: profile.data.memorial.memorialName, switchFamily: result.family, switchFriends: result.friends, switchFollowers: result.followers,)));
                                            }
                                          }else{
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularMemorialSettingsWithHidden(memorialId: memorialId, relationship: relationship,)));
                                          }

                                          // context.showLoaderOverlay();
                                          // APIRegularShowSwitchStatus result = await apiRegularShowSwitchStatus(memorialId);
                                          // context.hideLoaderOverlay();

                                          // if(result.success){
                                          //   // if(managed == true){
                                          //   //   Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularMemorialSettings(memorialId: memorialId, switchFamily: result.family, switchFriends: result.friends, switchFollowers: result.followers,)));
                                          //   // }

                                          //   print('The value of manage is $managed');
                                          //   print('The value of famOrFriends is $famOrFriends');
                                          //   print('The value of relationship is $relationship');

                                            
                                          // }
                                          
                                        },
                                        child: Text('Manage',
                                          style: TextStyle(
                                            fontSize: ScreenUtil().setSp(16, allowFontScalingSelf: true),
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xffffffff),
                                          ),
                                        ),
                                        minWidth: SizeConfig.screenWidth / 2,
                                        height: ScreenUtil().setHeight(45),
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
                                            messageText: profile.data.memorial.memorialName,
                                            androidMessageTitle: 'Share ${profile.data.memorial.memorialName} memorial',
                                            androidSharingTitle: profile.data.memorial.memorialName,
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
                                        radius: ScreenUtil().setHeight(25),
                                        backgroundColor: Color(0xff3498DB),
                                        child: Icon(Icons.share, color: Color(0xffffffff), size: ScreenUtil().setHeight(25),),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: ScreenUtil().setHeight(20)),

                            Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: Column(
                                children: [

                                  Row(
                                    children: [
                                      Icon(Icons.place, color: Color(0xff000000), size: ScreenUtil().setHeight(25),),
                                      SizedBox(width: SizeConfig.blockSizeHorizontal * 2,),
                                      Text(profile.data.memorial.memorialDetails.country,
                                        style: TextStyle(
                                          fontSize: ScreenUtil().setSp(14, allowFontScalingSelf: true),
                                          color: Color(0xff000000),
                                        ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                                  Row(
                                    children: [
                                      Icon(Icons.star, color: Color(0xff000000), size: ScreenUtil().setHeight(25),),
                                      SizedBox(width: SizeConfig.blockSizeHorizontal * 2,),
                                      Text(convertDate(profile.data.memorial.memorialDetails.dob),
                                        style: TextStyle(
                                          fontSize: ScreenUtil().setSp(14, allowFontScalingSelf: true),
                                          color: Color(0xff000000),
                                        ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                                  Row(
                                    children: [
                                      Image.asset('assets/icons/grave_logo.png', height: ScreenUtil().setHeight(25),),
                                      SizedBox(width: SizeConfig.blockSizeHorizontal * 2,),
                                      Text(convertDate(profile.data.memorial.memorialDetails.rip),
                                        style: TextStyle(
                                          fontSize: ScreenUtil().setSp(14, allowFontScalingSelf: true),
                                          color: Color(0xff000000),
                                        ),
                                      ),
                                    ],
                                  ),

                                ],
                              ),
                            ),

                            SizedBox(height: ScreenUtil().setHeight(20)),

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

                                          Text(profile.data.memorial.memorialPostsCount.toString(),
                                            style: TextStyle(
                                              fontSize: ScreenUtil().setSp(20, allowFontScalingSelf: true),
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xff000000),
                                            ),
                                          ),

                                          Text('Post',
                                            style: TextStyle(
                                              fontSize: ScreenUtil().setSp(12, allowFontScalingSelf: true),
                                              fontWeight: FontWeight.w300,
                                              color: Color(0xffaaaaaa),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  
                                  Container(width: ScreenUtil().setHeight(2), color: Color(0xffeeeeee),),

                                  Expanded(
                                    child: GestureDetector(
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularConnectionList(memorialId: memorialId, newToggle: 0)));
                                      },
                                      child: Column(
                                        children: [
                                          SizedBox(height: SizeConfig.blockSizeVertical * 1,),

                                          Text('${profile.data.memorial.memorialFamilyCount}',
                                            style: TextStyle(
                                              fontSize: ScreenUtil().setSp(20, allowFontScalingSelf: true),
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xff000000),
                                            ),
                                          ),

                                          Text('Family',
                                            style: TextStyle(
                                              fontSize: ScreenUtil().setSp(12, allowFontScalingSelf: true),
                                              fontWeight: FontWeight.w300,
                                              color: Color(0xffaaaaaa),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  Container(width: ScreenUtil().setHeight(2), color: Color(0xffeeeeee),),

                                  Expanded(
                                    child: GestureDetector(
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularConnectionList(memorialId: memorialId, newToggle: 1)));
                                      },
                                      child: Column(
                                        children: [
                                          SizedBox(height: SizeConfig.blockSizeVertical * 1,),

                                          Text(profile.data.memorial.memorialFriendsCount.toString(),
                                            style: TextStyle(
                                              fontSize: ScreenUtil().setSp(20, allowFontScalingSelf: true),
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xff000000),
                                            ),
                                          ),

                                          Text('Friends',
                                            style: TextStyle(
                                              fontSize: ScreenUtil().setSp(12, allowFontScalingSelf: true),
                                              fontWeight: FontWeight.w300,
                                              color: Color(0xffaaaaaa),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  Container(width: ScreenUtil().setHeight(2), color: Color(0xffeeeeee),),

                                  Expanded(
                                    child: GestureDetector(
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularConnectionList(memorialId: memorialId, newToggle: 2)));
                                      },
                                      child: Column(
                                        children: [
                                          SizedBox(height: SizeConfig.blockSizeVertical * 1,),

                                          Text(profile.data.memorial.memorialFollowersCount.toString(),
                                            style: TextStyle(
                                              fontSize: ScreenUtil().setSp(20, allowFontScalingSelf: true),
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xff000000),
                                            ),
                                          ),

                                          Text('Joined',
                                            style: TextStyle(
                                              fontSize: ScreenUtil().setSp(12, allowFontScalingSelf: true),
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

                            Container(height: ScreenUtil().setHeight(2), color: Color(0xffffffff),),

                            Container(height: ScreenUtil().setHeight(5), color: Color(0xffeeeeee),),

                            Column(
                              children: [
                                SizedBox(height: ScreenUtil().setHeight(20)),

                                Container(
                                  key: dataKey,
                                  padding: EdgeInsets.only(left: 20.0),
                                  alignment: Alignment.centerLeft,
                                  child: Text('Post',
                                    style: TextStyle(
                                      fontSize: ScreenUtil().setSp(20, allowFontScalingSelf: true),
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff000000),
                                    ),
                                  ),
                                ),

                                SizedBox(height: ScreenUtil().setHeight(20)),

                                profile.data.memorial.memorialImagesOrVideos != null
                                ? Column(
                                  children: [
                                    Container(
                                      width: SizeConfig.screenWidth,
                                      // height: ScreenUtil().setHeight(110),
                                      height: SizeConfig.blockSizeVertical * 12,
                                      padding: EdgeInsets.only(left: 20.0, right: 20.0),
                                      child: ListView.separated(
                                        physics: ClampingScrollPhysics(),
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index){
                                          return Container(
                                            // width: ScreenUtil().setHeight(110),
                                            width: SizeConfig.blockSizeVertical * 12,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              color: Color(0xff888888),
                                            ),
                                            child: CachedNetworkImage(
                                              fit: BoxFit.cover,
                                              imageUrl: profile.data.memorial.memorialImagesOrVideos[index],
                                              placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                                              errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                            ),
                                          );
                                        }, 
                                        separatorBuilder: (context, index){
                                          return SizedBox(width: ScreenUtil().setHeight(20));
                                        },
                                        itemCount: profile.data.memorial.memorialImagesOrVideos.length,
                                      ),
                                    ),

                                    // SizedBox(height: SizeConfig.blockSizeVertical * 2,),
                                    SizedBox(height: ScreenUtil().setHeight(20)),

                                  ],
                                )
                                : Container(height: 0,),
                              ],
                            ),

                            Container(height: ScreenUtil().setHeight(5), color: Color(0xffeeeeee),),

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
                                      body = Text('Pull up to load', style: TextStyle(fontSize: ScreenUtil().setSp(14, allowFontScalingSelf: true), color: Color(0xff000000),),);
                                    }
                                    else if(mode == LoadStatus.loading){
                                      body =  CircularProgressIndicator();
                                    }
                                    else if(mode == LoadStatus.failed){
                                      body = Text('Load Failed! Click retry!', style: TextStyle(fontSize: ScreenUtil().setSp(14, allowFontScalingSelf: true), color: Color(0xff000000),),);
                                    }
                                    else if(mode == LoadStatus.canLoading){
                                      body = Text('Release to load more', style: TextStyle(fontSize: ScreenUtil().setSp(14, allowFontScalingSelf: true), color: Color(0xff000000),),);
                                    }
                                    else{
                                      body = Text('End of result.', style: TextStyle(fontSize: ScreenUtil().setSp(14, allowFontScalingSelf: true), color: Color(0xff000000),),);
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
                                      // timeCreated: convertDate(posts[i].timeCreated),
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
                                child: Text('Post is empty.', style: TextStyle(fontSize: ScreenUtil().setSp(14, allowFontScalingSelf: true), color: Color(0xff000000),)),
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
                                      fontSize: ScreenUtil().setSp(20, allowFontScalingSelf: true),
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

                                Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularCreatePost(name: profile.data.memorial.memorialName, memorialId: profile.data.memorial.memorialId)));

                              },
                              shape: StadiumBorder(),
                              color: Colors.green,
                              splashColor: Colors.yellow,
                              height: ScreenUtil().setHeight(45),
                              child: Text('Create Post',
                                style: TextStyle(
                                  fontSize: ScreenUtil().setSp(16, allowFontScalingSelf: true),
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
                      height: ScreenUtil().setHeight(160),
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
                                    profile.data.memorial.memorialProfileImage,
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





