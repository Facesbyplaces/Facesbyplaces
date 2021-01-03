import 'package:facesbyplaces/API/Regular/02-Main/api-main-regular-02-show-user-information.dart';
import 'package:facesbyplaces/API/Regular/12-Show-Post/api-show-post-regular-03-show-post-comments.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-02-regular-bottom-sheet.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-19-regular-empty-display.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-20-regular-reply.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/Configurations/date-conversion.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter/material.dart';

class RegularOriginalComment{
  int commentId;
  int postId;
  int userId;
  String commentBody;
  String createdAt;
  String firstName;
  String lastName;
  dynamic image;

  RegularOriginalComment({this.commentId, this.postId, this.userId, this.commentBody, this.createdAt, this.firstName, this.lastName, this.image});
}

class RegularOriginalReply{
  int commentId;
  int postId;
  int userId;
  String commentBody;
  String createdAt;
  String firstName;
  String lastName;
  dynamic image;

  RegularOriginalReply({this.commentId, this.postId, this.userId, this.commentBody, this.createdAt, this.firstName, this.lastName, this.image});
}

class HomeRegularShowCommentsList extends StatefulWidget{
  final int postId;
  final int numberOfLikes;
  final int numberOfComments;
  HomeRegularShowCommentsList({this.postId, this.numberOfLikes, this.numberOfComments});

  @override
  HomeRegularShowCommentsListState createState() => HomeRegularShowCommentsListState(postId: postId, numberOfLikes: numberOfLikes, numberOfComments: numberOfComments);
}

class HomeRegularShowCommentsListState extends State<HomeRegularShowCommentsList>{
  final int postId;
  final int numberOfLikes;
  final int numberOfComments;
  HomeRegularShowCommentsListState({this.postId, this.numberOfLikes, this.numberOfComments});

  GlobalKey<MiscRegularBottomSheetCommentState> key1;
  RefreshController refreshController = RefreshController(initialRefresh: true);
  static TextEditingController controller = TextEditingController();
  List<RegularOriginalComment> comments;
  Future showOriginalPost;
  int itemRemaining;
  int page;
  int count;
  List<int> commentIds;
  int page2;
  static Future<APIRegularShowProfileInformation> currentUser;
  // static String userImage;
  // static String userImage = 'assets/icons/app-icon.png';

  void initState(){
    super.initState();
    // userImage = 'assets/icons/app-icon.png';
    key1 = GlobalKey<MiscRegularBottomSheetCommentState>();
    itemRemaining = 1;
    comments = [];
    commentIds = [];
    page = 1;
    count = 0;
    onLoading();
    currentUser = getDrawerInformation();
  }

  void onRefresh() async{
    await Future.delayed(Duration(milliseconds: 1000));
    refreshController.refreshCompleted();
  }

  void onLoading() async{
    if(itemRemaining != 0){
      context.showLoaderOverlay();
      var newValue = await apiRegularShowListOfComments(postId: postId, page: page);
      context.hideLoaderOverlay();
      itemRemaining = newValue.itemsRemaining;
      count = count + newValue.commentsList.length;

      for(int i = 0; i < newValue.commentsList.length; i++){
        comments.add(
          RegularOriginalComment(
            commentId: newValue.commentsList[i].commentId,
            postId: newValue.commentsList[i].postId,
            userId: newValue.commentsList[i].user.userId,
            commentBody: newValue.commentsList[i].commentBody,
            createdAt: newValue.commentsList[i].createdAt,
            firstName: newValue.commentsList[i].user.firstName,
            lastName: newValue.commentsList[i].user.lastName,
            image: newValue.commentsList[i].user.image,
          ),    
        );

        commentIds.add(newValue.commentsList[i].commentId,);
      }

      if(mounted)
      setState(() {});
      page++;
      
      refreshController.loadComplete();
    }else{
      refreshController.loadNoData();
    }
  }

  // void onLoadingReplies() async{
  //   if(itemRemaining != 0){
  //     context.showLoaderOverlay();
  //     var newValue = await apiRegularShowListOfReplies(commentId: commentId, page: page2);
  //     context.hideLoaderOverlay();
  //     itemRemaining = newValue.itemsRemaining;
  //     count = count + newValue.commentsList.length;

  //     for(int i = 0; i < newValue.commentsList.length; i++){
  //       // comments.add(
  //       //   RegularOriginalComment(
  //       //     commentId: newValue.commentsList[i].commentId,
  //       //     userId: newValue.commentsList[i].user.userId,
  //       //     commentBody: newValue.commentsList[i].commentBody,
  //       //     createdAt: newValue.commentsList[i].createdAt,
  //       //     firstName: newValue.commentsList[i].user.firstName,
  //       //     lastName: newValue.commentsList[i].user.lastName,
  //       //     image: newValue.commentsList[i].user.image,
  //       //   ),    
  //       // );
  //     }

  //     if(mounted)
  //     setState(() {});
  //     page++;
      
  //     refreshController.loadComplete();
  //   }else{
  //     refreshController.loadNoData();
  //   }
  // }

  

  Future<APIRegularShowProfileInformation> getDrawerInformation() async{
    return await apiRegularShowProfileInformation();
  }

  Widget bottomSheet = Padding(
    padding: EdgeInsets.only(left: 20.0, right: 20.0,),
    child: Row(
      children: [
        
        FutureBuilder<APIRegularShowProfileInformation>(
          future: currentUser,
          builder: (context, user){
            if(user.hasData){
              return CircleAvatar(backgroundColor: Color(0xff888888), backgroundImage: NetworkImage(user.data.image));
            }else if(user.hasError){
              return CircleAvatar(backgroundColor: Color(0xff888888), backgroundImage: AssetImage('assets/icons/app-icon.png'));
            }
            else{
              return CircularProgressIndicator();
            }
          },
        ),

        Expanded(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: TextFormField(
              controller: controller,
              cursorColor: Color(0xff000000),
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                fillColor: Color(0xffBDC3C7),
                filled: true,
                labelText: 'Say something...',
                labelStyle: TextStyle(
                  fontSize: 14,
                  color: Color(0xffffffff),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xffBDC3C7),
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xffBDC3C7),
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),
          ),
        ),

        GestureDetector(
          onTap: (){
            controller.clear();
          },
          child: Text('Post',
            style: TextStyle(
              fontSize: SizeConfig.safeBlockHorizontal * 4,
              fontWeight: FontWeight.bold, 
              color: Color(0xff000000),
            ),
          ),
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    ResponsiveWidgets.init(context,
      height: SizeConfig.screenHeight,
      width: SizeConfig.screenWidth,
    );
    return WillPopScope(
      onWillPop: () async{
        return Navigator.canPop(context);
      },
      child: GestureDetector(
        onTap: (){
          FocusNode currentFocus = FocusScope.of(context);
          if(!currentFocus.hasPrimaryFocus){
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xff04ECFF),
            title: Text('Comments', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xffffffff)),),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Color(0xffffffff),), 
              onPressed: (){
                Navigator.pop(context);
              },
            ),
          ),
          body: count != 0
          ? Column(
            children: [
              Container(
                height: SizeConfig.blockSizeVertical * 5,
                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [

                    GestureDetector(
                      onTap: () async{
                        
                      },
                      child: Row(
                        children: [
                          Icon(Icons.favorite_border_outlined, color: Color(0xff000000),),

                          SizedBox(width: SizeConfig.blockSizeHorizontal * 1,),

                          Text('$numberOfLikes', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),),

                        ],
                      ),
                    ),

                    SizedBox(width: SizeConfig.blockSizeHorizontal * 5,),

                    GestureDetector(
                      onTap: (){
                        
                      },
                      child: Row(
                        children: [
                          Icon(Icons.chat_bubble_outline_outlined, color: Color(0xff000000),),

                          SizedBox(width: SizeConfig.blockSizeHorizontal * 1,),

                          Text('$numberOfComments', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SmartRefresher(
                  enablePullDown: false,
                  enablePullUp: true,
                  header: MaterialClassicHeader(),
                  footer: CustomFooter(
                    loadStyle: LoadStyle.ShowWhenLoading,
                    builder: (BuildContext context, LoadStatus mode){
                      Widget body;
                      if(mode == LoadStatus.idle){
                        body = Text('Pull up load', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
                      }
                      else if(mode == LoadStatus.loading){
                        body = CircularProgressIndicator();
                      }
                      else if(mode == LoadStatus.failed){
                        body = Text('Load Failed! Click retry!', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
                      }
                      else if(mode == LoadStatus.canLoading){
                        body = Text('Release to load more', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
                      }
                      else{
                        body = Text('End of conversation.', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
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
                      return Column(
                        children: [
                          Container(
                            height: SizeConfig.blockSizeVertical * 5,
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage: comments[i].image != null ? NetworkImage(comments[i].image) : AssetImage('assets/icons/app-icon.png'),
                                  backgroundColor: Color(0xff888888),
                                ),

                                SizedBox(width: SizeConfig.blockSizeHorizontal * 1,),

                                Expanded(
                                  child: Text(comments[i].firstName.toString() + ' ' + comments[i].lastName.toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),

                                Icon(Icons.favorite_border_outlined, color: Color(0xffE74C3C),),

                                SizedBox(width: SizeConfig.blockSizeHorizontal * 1,),

                                Text('0', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),),

                              ],
                            ),
                          ),

                          Row(
                            children: [
                              SizedBox(width: SizeConfig.blockSizeHorizontal * 12,),

                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.all(10.0),
                                  child: Text(
                                    comments[i].commentBody,
                                    style: TextStyle(
                                      color: Color(0xffffffff),
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    color: Color(0xff4EC9D4),
                                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: SizeConfig.blockSizeVertical * 1,),

                          Row(
                            children: [

                              SizedBox(width: SizeConfig.blockSizeHorizontal * 12,),

                              Text(convertDate(comments[i].createdAt)),

                              SizedBox(width: SizeConfig.blockSizeHorizontal * 5,),

                              Text('Reply',),

                            ],
                          ),

                          SizedBox(height: SizeConfig.blockSizeVertical * 1,),

                          Column(
                            children: List.generate(3, (index) => 
                              MiscRegularShowReply(
                                image: comments[i].image,
                                firstName: comments[i].firstName,
                                lastName: comments[i].lastName,
                                commentBody: comments[i].commentBody,
                                createdAt: comments[i].createdAt,
                                numberOfLikes: 1,
                              ),
                            ),
                          ),

                        ],
                      );
                    },
                    separatorBuilder: (c, i) => Divider(height: SizeConfig.blockSizeVertical * 2, color: Colors.transparent),
                    itemCount: comments.length,
                  ),
                ),
              ),
            ],
          )
          : SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: ContainerResponsive(
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
                child: MiscRegularEmptyDisplayTemplate(message: 'Comment is empty',),
              ),
            ),
          ),
          ),
        bottomSheet: bottomSheet,
        ),
      ),
    );
  }
}

