import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-14-regular-message.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-13-regular-post.dart';
import 'package:facesbyplaces/API/Regular/03-View-Memorial/api-view-memorial-regular-01-show-profile-post.dart';
import 'package:facesbyplaces/API/Regular/03-View-Memorial/api-view-memorial-regular-02-show-memorial-details.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/Configurations/date-conversion.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'home-view-memorial-regular-03-connection-list.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter/material.dart';

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

class HomeRegularMemorialProfile extends StatefulWidget{
  final int memorialId;
  final bool newJoin;
  HomeRegularMemorialProfile({this.memorialId, this.newJoin});

  HomeRegularMemorialProfileState createState() => HomeRegularMemorialProfileState(memorialId: memorialId, newJoin: newJoin);
}

class HomeRegularMemorialProfileState extends State<HomeRegularMemorialProfile>{
  final int memorialId;
  final bool newJoin;
  HomeRegularMemorialProfileState({this.memorialId, this.newJoin});

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
                      if(profile.data.memorial.memorialBackgroundImage == null || profile.data.memorial.memorialBackgroundImage == ''){
                        return Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,);
                      }else{
                        return CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: profile.data.memorial.memorialBackgroundImage,
                          placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                          errorWidget: (context, url, error) => Center(child: Icon(Icons.error),),
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
                                profile.data.memorial.memorialName,
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
                                    child: Text('${profile.data.memorial.memorialFollowersCount}',
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
                              if(profile.data.memorial.memorialDetails.description != '' || profile.data.memorial.memorialDetails.description != null){
                                return Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.only(left: 20.0, right: 20.0),
                                  child: Text(profile.data.memorial.memorialDetails.description,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: SizeConfig.safeBlockHorizontal * 4,
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

                            SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                            Container(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: (){
                                        Navigator.pushNamed(context, '/home/regular/donation');
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
                                        await FlutterShare.share(
                                          title: 'Share',
                                          text: 'Share the link',
                                          linkUrl: 'https://flutter.dev/',
                                          chooserTitle: 'Share link'
                                        );
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
                                      Text(profile.data.memorial.memorialDetails.birthPlace,
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
                                      Text(convertDate(profile.data.memorial.memorialDetails.dob),
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
                                      Text(convertDate(profile.data.memorial.memorialDetails.rip),
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
                                        onTap: (){},
                                        child: Text(profile.data.memorial.memorialDetails.cemetery,
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

                                          Text(profile.data.memorial.memorialPostsCount.toString(),
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

                                          Text(profile.data.memorial.memorialFamilyCount.toString(),
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

                                          Text(profile.data.memorial.memorialFriendsCount.toString(),
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

                                          Text('${profile.data.memorial.memorialFollowersCount}',
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

                                profile.data.memorial.memorialImagesOrVideos != null
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
                                            child: ((){
                                              if(profile.data.memorial.memorialImagesOrVideos[index] == null || profile.data.memorial.memorialImagesOrVideos[index] == ''){
                                                return Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,);
                                              }else{
                                                return CachedNetworkImage(
                                                  fit: BoxFit.cover,
                                                  imageUrl: profile.data.memorial.memorialImagesOrVideos[index],
                                                  placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                                                  errorWidget: (context, url, error) => Center(child: Icon(Icons.error),),
                                                );
                                              }
                                            }()),
                                          );
                                        }, 
                                        separatorBuilder: (context, index){
                                          return SizedBox(width: SizeConfig.blockSizeHorizontal * 2,);
                                        },
                                        itemCount: profile.data.memorial.memorialImagesOrVideos.length,
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
                                    return Container(height: 55.0, child: Center(child: body),);
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
                                          child: ((){
                                            if(posts[i].imagesOrVideos[0] == null || posts[i].imagesOrVideos[0] == ''){
                                              return Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,);
                                            }else{
                                              return CachedNetworkImage(
                                                fit: BoxFit.cover,
                                                imageUrl: posts[i].imagesOrVideos[0],
                                                placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                                                errorWidget: (context, url, error) => Center(child: Icon(Icons.error),),
                                              );
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
                                  backgroundImage: AssetImage('assets/icons/app-icon.png'),
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