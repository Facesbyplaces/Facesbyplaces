import 'package:facesbyplaces/API/BLM/10-Settings-User/api-settings-user-blm-03-show-other-details-status.dart';
import 'package:facesbyplaces/API/BLM/13-Show-User/api-show-user-blm-02-show-user-posts.dart';
import 'package:facesbyplaces/UI/Home/BLM/09-Settings-User/home-settings-user-02-user-update-details.dart';
import 'package:facesbyplaces/UI/Home/BLM/09-Settings-User/home-settings-user-03-change-password.dart';
import 'package:facesbyplaces/UI/Home/BLM/09-Settings-User/home-settings-user-04-other-details.dart';
import 'package:facesbyplaces/API/BLM/13-Show-User/api-show-user-blm-03-show-user-memorials.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/material.dart';
import '../../ui-01-get-started.dart';
import 'misc-02-blm-dialog.dart';
import 'misc-04-blm-manage-memorial.dart';
import 'misc-05-blm-post.dart';
import 'misc-07-blm-button.dart';
import 'misc-14-blm-empty-display.dart';


class MiscBLMUserProfileDetailsDraggable extends StatefulWidget {
  final int userId;
  MiscBLMUserProfileDetailsDraggable({this.userId});

  @override
  MiscBLMUserProfileDetailsDraggableState createState() => MiscBLMUserProfileDetailsDraggableState(userId: userId);
}

class MiscBLMUserProfileDetailsDraggableState extends State<MiscBLMUserProfileDetailsDraggable> {
  final int userId;
  MiscBLMUserProfileDetailsDraggableState({this.userId});

  double height;
  Offset position;
  int currentIndex = 0;
  List<Widget> children;

  @override
  void initState(){
    super.initState();
    height = SizeConfig.screenHeight;
    position = Offset(0.0, height - 100);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: Draggable(
        feedback: draggable(),
        onDraggableCanceled: (Velocity velocity, Offset offset){
          if(offset.dy > 10 && offset.dy < (SizeConfig.screenHeight - 100)){
            setState(() {
              position = offset;
            });
          }
        },
        child: draggable(),
        childWhenDragging: Container(),
        axis: Axis.vertical,
      ),
    );
  }

  draggable(){
    return Material(
      color: Colors.transparent,
      child: Container(
        width: SizeConfig.screenWidth,
        height: SizeConfig.screenHeight,
        padding: EdgeInsets.only(left: 20.0, right: 20.0),
        decoration: BoxDecoration(
          color: Color(0xffffffff),
          borderRadius: BorderRadius.only(topLeft: Radius.circular(100)),
        ),
        child: Column(
          children: [

            SizedBox(height: SizeConfig.blockSizeVertical * 10,),

            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMUserUpdateDetails(userId: userId,)));
              },
              child: Container(
                height: SizeConfig.blockSizeVertical * 10,
                color: Color(0xffffffff),
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                child: Column(
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Text('Update Details',
                          style: TextStyle(
                            fontSize: SizeConfig.safeBlockHorizontal * 4,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff000000),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: SizeConfig.blockSizeVertical * 1,),

                    Expanded(
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text('Update your account details',
                          style: TextStyle(
                            fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                            fontWeight: FontWeight.w300,
                            color: Color(0xffBDC3C7),
                          ),
                        ),
                      ),
                    ),

                    Divider(height: SizeConfig.blockSizeVertical * 2, color: Color(0xff888888),)
                  ],
                ),
              ),
            ),

            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMUserChangePassword(userId: userId,)));
              },
              child: Container(
                height: SizeConfig.blockSizeVertical * 10,
                color: Color(0xffffffff),
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                child: Column(
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Text('Password',
                          style: TextStyle(
                            fontSize: SizeConfig.safeBlockHorizontal * 4,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff000000),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: SizeConfig.blockSizeVertical * 1,),

                    Expanded(
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text('Change your login password',
                          style: TextStyle(
                            fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                            fontWeight: FontWeight.w300,
                            color: Color(0xffBDC3C7),
                          ),
                        ),
                      ),
                    ),

                    Divider(height: SizeConfig.blockSizeVertical * 2, color: Color(0xff888888),)
                  ],
                ),
              ),
            ),

            GestureDetector(
              onTap: () async{
                context.showLoaderOverlay();
                APIBLMShowOtherDetailsStatus result = await apiBLMShowOtherDetailsStatus(userId: userId);
                context.hideLoaderOverlay();

                Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMUserOtherDetails(userId: userId, toggleBirthdate: result.hideBirthdate, toggleBirthplace: result.hideBirthplace, toggleAddress: result.hideAddress, toggleEmail: result.hideEmail, toggleNumber: result.hidePhoneNumber)));
              },
              child: Container(
                height: SizeConfig.blockSizeVertical * 10,
                color: Color(0xffffffff),
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                child: Column(
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Text('Other Info',
                          style: TextStyle(
                            fontSize: SizeConfig.safeBlockHorizontal * 4,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff000000),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: SizeConfig.blockSizeVertical * 1,),

                    Expanded(
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text('Optional informations you can share',
                          style: TextStyle(
                            fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                            fontWeight: FontWeight.w300,
                            color: Color(0xffBDC3C7),
                          ),
                        ),
                      ),
                    ),

                    Divider(height: SizeConfig.blockSizeVertical * 2, color: Color(0xff888888),)
                  ],
                ),
              ),
            ),

            Container(
              height: SizeConfig.blockSizeVertical * 10,
              color: Color(0xffffffff),
              padding: EdgeInsets.only(left: 20.0, right: 20.0),
              child: Column(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text('Privacy Settings',
                        style: TextStyle(
                          fontSize: SizeConfig.safeBlockHorizontal * 4,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff000000),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: SizeConfig.blockSizeVertical * 1,),

                  Expanded(
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text('Control what others see',
                        style: TextStyle(
                          fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                          fontWeight: FontWeight.w300,
                          color: Color(0xffBDC3C7),
                        ),
                      ),
                    ),
                  ),

                  Divider(height: SizeConfig.blockSizeVertical * 2, color: Color(0xff888888),),
                ]
              ),
            ),

            Expanded(child: Container(),),

            MiscBLMButtonTemplate(
              buttonText: 'Logout',
              buttonTextStyle: TextStyle(
                fontSize: SizeConfig.safeBlockHorizontal * 5, 
                fontWeight: FontWeight.bold, 
                color: Color(0xffffffff),
              ), 
              onPressed: () async{

                bool logoutResult = await showDialog(context: (context), builder: (build) => MiscBLMConfirmDialog(title: 'Log out', content: 'Are you sure you want to log out from this account?', confirmColor_1: Color(0xff000000), confirmColor_2: Color(0xff888888),));

                if(logoutResult){
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => UIGetStarted()), (route) => false);
                }

              }, 
              width: SizeConfig.screenWidth / 2, 
              height: SizeConfig.blockSizeVertical * 7, 
              buttonColor: Color(0xff04ECFF),
            ),

            SizedBox(height: SizeConfig.blockSizeVertical * 2,),
            
            Text('V.1.1.0', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, fontWeight: FontWeight.bold, color: Color(0xff888888),),),

            Expanded(child: Container(),),

          ],
        ),
      ),
    );
  }
}


class MiscBLMUserProfileDraggableSwitchTabs extends StatefulWidget {
  final int userId;
  MiscBLMUserProfileDraggableSwitchTabs({this.userId});

  @override
  MiscBLMUserProfileDraggableSwitchTabsState createState() => MiscBLMUserProfileDraggableSwitchTabsState(userId: userId);
}

class MiscBLMUserProfileDraggableSwitchTabsState extends State<MiscBLMUserProfileDraggableSwitchTabs> {
  final int userId;
  MiscBLMUserProfileDraggableSwitchTabsState({this.userId});

  double height;
  Offset position;
  int currentIndex = 0;
  List<Widget> children;

  @override
  void initState(){
    super.initState();
    height = SizeConfig.screenHeight;
    position = Offset(0.0, height - 100);
    children = [MiscBLMDraggablePost(userId: userId,), MiscBLMDraggableMemorials(userId: userId,)];
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Positioned(
      left: position.dx,
      top: position.dy - SizeConfig.blockSizeVertical * 10,
      child: Draggable(
        feedback: draggable(),
        onDraggableCanceled: (Velocity velocity, Offset offset){
          if(offset.dy > 100 && offset.dy < (SizeConfig.screenHeight - 100)){
            setState(() {
              position = offset;
            });
          }
        },
        child: draggable(),
        childWhenDragging: Container(),
        axis: Axis.vertical,
      ),
    );
  }

  draggable(){
    return Material(
      child: Container(
        width: SizeConfig.screenWidth,
        decoration: BoxDecoration(
          color: Color(0xffffffff),
          borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25),),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Color(0xffaaaaaa),
              offset: Offset(0, 0),
              blurRadius: 5.0
            ),
          ],
        ),
        child: Column(
          children: [

            Container(
              alignment: Alignment.center,
              width: SizeConfig.screenWidth,
              height: SizeConfig.blockSizeVertical * 8,
              child: DefaultTabController(
                length: 2,
                initialIndex: currentIndex,
                child: TabBar(
                  isScrollable: false,
                  labelColor: Color(0xff04ECFF),
                  unselectedLabelColor: Color(0xffCDEAEC),
                  indicatorColor: Color(0xff04ECFF),
                  onTap: (int number){
                    setState(() {
                      currentIndex = number;
                    });
                  },
                  tabs: [

                    Container(
                      width: SizeConfig.screenWidth / 2.5,
                      child: Center(
                        child: Text('Post',
                          style: TextStyle(
                            fontSize: SizeConfig.safeBlockHorizontal * 4,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),

                    Container(
                      width: SizeConfig.screenWidth / 2.5,
                      child: Center(
                        child: Text('Memorials',
                          style: TextStyle(
                            fontSize: SizeConfig.safeBlockHorizontal * 4,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ),

            Container(
              width: SizeConfig.screenWidth,
              height: (SizeConfig.screenHeight - position.dy),
              child: IndexedStack(
                index: currentIndex,
                children: children,
              ),
            ),

            SizedBox(height: SizeConfig.blockSizeVertical * 10,),
            
          ],
        ),
      ),
    );
  }
}



class BLMMiscDraggablePost{
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

  BLMMiscDraggablePost({this.userId, this.postId, this.memorialId, this.memorialName, this.timeCreated, this.postBody, this.profileImage, this.imagesOrVideos, this.managed, this.joined, this.numberOfLikes, this.numberOfComments, this.likeStatus, this.numberOfTagged, this.taggedFirstName, this.taggedLastName, this.taggedImage, this.taggedId});
}

class MiscBLMDraggablePost extends StatefulWidget{
  final int userId;
  MiscBLMDraggablePost({this.userId});

  MiscBLMDraggablePostState createState() => MiscBLMDraggablePostState(userId: userId);
}

class MiscBLMDraggablePostState extends State<MiscBLMDraggablePost>{
  final int userId;
  MiscBLMDraggablePostState({this.userId});
  
  RefreshController refreshController = RefreshController(initialRefresh: true);
  List<BLMMiscDraggablePost> posts;
  int itemRemaining;
  int page;
  int count;

  void initState(){
    super.initState();
    itemRemaining = 1;
    posts = [];
    page = 1;
    count = 0;
    onLoading();
  }

  void onRefresh() async{
    await Future.delayed(Duration(milliseconds: 1000));
    refreshController.refreshCompleted();
  }

  void onLoading() async{
    if(itemRemaining != 0){
      context.showLoaderOverlay();

      var newValue = await apiBLMShowUserPosts(userId: userId, page: page);
      itemRemaining = newValue.itemsRemaining;
      count = count + newValue.familyMemorialList.length;

      for(int i = 0; i < newValue.familyMemorialList.length; i++){
        List<String> newList1 = [];
        List<String> newList2 = [];
        List<String> newList3 = [];
        List<int> newList4 = [];

        for(int j = 0; j < newValue.familyMemorialList[i].postTagged.length; j++){
          newList1.add(newValue.familyMemorialList[i].postTagged[j].taggedFirstName);
          newList2.add(newValue.familyMemorialList[i].postTagged[j].taggedLastName);
          newList3.add(newValue.familyMemorialList[i].postTagged[j].taggedImage);
          newList4.add(newValue.familyMemorialList[i].postTagged[j].taggedId);
        }

        posts.add(BLMMiscDraggablePost(
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
          ),    
        );
      }

      if(mounted)
      setState(() {});
      page++;
      
      refreshController.loadComplete();
      context.hideLoaderOverlay();
    }else{
      refreshController.loadNoData();
    }
  }


  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    ResponsiveWidgets.init(context,
      height: SizeConfig.screenHeight,
      width: SizeConfig.screenWidth,
    );
    return Container(
      height: SizeConfig.screenHeight - SizeConfig.blockSizeVertical * 13 - AppBar().preferredSize.height,
      child: count != 0
      ? SmartRefresher(
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
      )
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
    );
  }
}

class MiscBLMDraggableMemorials extends StatefulWidget{
  final int userId;
  MiscBLMDraggableMemorials({this.userId});

  MiscBLMDraggableMemorialsState createState() => MiscBLMDraggableMemorialsState(userId: userId);
}

class MiscBLMDraggableMemorialsState extends State<MiscBLMDraggableMemorials>{
  final int userId;
  MiscBLMDraggableMemorialsState({this.userId});

  RefreshController refreshController = RefreshController(initialRefresh: true);
  List<Widget> finalMemorials;
  int blmFamilyItemsRemaining;
  int blmFriendsItemsRemaining;
  int page1;
  int page2;
  bool flag1;
  int count;

  void initState(){
    super.initState();
    finalMemorials = [];
    blmFamilyItemsRemaining = 1;
    blmFriendsItemsRemaining = 1;
    page1 = 1;
    page2 = 1;
    count = 0;
    flag1 = false;
    addMemorials1();
    onLoading();
  }

  
  void onRefresh() async{
    await Future.delayed(Duration(milliseconds: 1000));
    refreshController.refreshCompleted();
  }

  void addMemorials1(){
    finalMemorials.add(
      Container(
        height: 80,
        padding: EdgeInsets.only(left: 20.0, right: 20.0),
        color: Color(0xffeeeeee),
        child: Container(
          height: 80,
          padding: EdgeInsets.only(left: 20.0, right: 20.0),
          color: Color(0xffeeeeee),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text('Owned',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xff000000),
              ),
            ),
          ),
        ),
      ),
    );
  }


  void addMemorials2(){
    finalMemorials.add(
      Container(
        height: 80,
        padding: EdgeInsets.only(left: 20.0, right: 20.0),
        color: Color(0xffeeeeee),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text('Followed',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xff000000),
            ),
          ),
        ),
      ),
    );
  }


  void onLoading() async{

    if(flag1 == false){
      onLoading1();
    }else{
      onLoading2();
    }
  }

  void onLoading1() async{

    if(blmFamilyItemsRemaining != 0){
      context.showLoaderOverlay();
      var newValue = await apiBLMShowUserMemorials(userId: userId, page: page1);
      context.hideLoaderOverlay();

      count = count + newValue.owned.length;

      for(int i = 0; i < newValue.owned.length; i++){
        finalMemorials.add(
          MiscBLMManageMemorialTab(
            index: i,
            memorialName: newValue.owned[i].page.pageName,
            description: newValue.owned[i].page.pageDetails.description,
            image: newValue.owned[i].page.pageProfileImage,
            memorialId: newValue.owned[i].page.pageId, 
            managed: newValue.owned[i].page.pageManage,
            follower: newValue.owned[i].page.pageFollower,
            famOrFriends: newValue.owned[i].page.pageFamOrFriends,
            pageType: newValue.owned[i].page.pageType,
            relationship: newValue.owned[i].page.pageRelationship,
          ),
        );
      }

      if(mounted)
      setState(() {});
      page1++;

      if(blmFamilyItemsRemaining == 0){
        addMemorials2();
        setState(() {
          flag1 = true;
        });
        onLoading();
      }

      refreshController.loadComplete();
      
    }else{
      refreshController.loadNoData();
    }


    
  }

  void onLoading2() async{

    if(blmFriendsItemsRemaining != 0){
      context.showLoaderOverlay();
      var newValue = await apiBLMShowUserMemorials(page: page2);
      context.hideLoaderOverlay();

      count = count + newValue.followed.length;

      for(int i = 0; i < newValue.followed.length; i++){
        finalMemorials.add(
          MiscBLMManageMemorialTab(
            index: i,
            memorialName: newValue.followed[i].page.pageName,
            description: newValue.owned[i].page.pageDetails.description,
            image: newValue.followed[i].page.pageProfileImage,
            memorialId: newValue.followed[i].page.pageId, 
            managed: newValue.followed[i].page.pageManage,
            follower: newValue.followed[i].page.pageFollower,
            famOrFriends: newValue.followed[i].page.pageFamOrFriends,
            pageType: newValue.followed[i].page.pageType,
            relationship: newValue.followed[i].page.pageRelationship,
          ),
        );
      }

      if(mounted)
      setState(() {});
      page2++;

      refreshController.loadComplete();
    }else{
      refreshController.loadNoData();
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    ResponsiveWidgets.init(context,
      height: SizeConfig.screenHeight,
      width: SizeConfig.screenWidth,
    );
    return Container(
      child: count != 0
      ? SmartRefresher(
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
          physics: ClampingScrollPhysics(),
          itemBuilder: (c, i) {
            return finalMemorials[i];
          },
          separatorBuilder: (c, i) => Divider(height: SizeConfig.blockSizeVertical * 1, color: Colors.transparent),
          itemCount: finalMemorials.length,
        ),
      )
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
            child: MiscBLMEmptyDisplayTemplate(message: 'Memorial is empty',),
          ),
        ),
      ),
    );
  }
}