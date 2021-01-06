import 'package:facesbyplaces/API/Regular/02-Main/api-main-regular-02-show-user-information.dart';
import 'package:facesbyplaces/API/Regular/12-Show-Post/api-show-post-regular-03-show-post-comments.dart';
import 'package:facesbyplaces/API/Regular/12-Show-Post/api-show-post-regular-04-show-comment-replies.dart';
import 'package:facesbyplaces/API/Regular/12-Show-Post/api-show-post-regular-05-add-comment.dart';
import 'package:facesbyplaces/API/Regular/12-Show-Post/api-show-post-regular-06-show-comment-or-reply-like-status.dart';
import 'package:facesbyplaces/API/Regular/12-Show-Post/api-show-post-regular-07-comment-reply-like-or-unlike.dart';
import 'package:facesbyplaces/API/Regular/12-Show-Post/api-show-post-regular-08-add-reply.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-19-regular-empty-display.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:timeago/timeago.dart' as timeago;
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
  bool commentLikes;
  int commentNumberOfLikes;
  List<RegularOriginalReply> listOfReplies;

  RegularOriginalComment({this.commentId, this.postId, this.userId, this.commentBody, this.createdAt, this.firstName, this.lastName, this.image, this.commentLikes, this.commentNumberOfLikes, this.listOfReplies});
}

class RegularOriginalReply{
  int replyId;
  int commentId;
  int userId;
  String replyBody;
  String createdAt;
  String firstName;
  String lastName;
  dynamic image;
  bool replyLikes;
  int replyNumberOfLikes;

  RegularOriginalReply({this.replyId, this.commentId, this.userId, this.replyBody, this.createdAt, this.firstName, this.lastName, this.image, this.replyLikes, this.replyNumberOfLikes});
}

class HomeRegularShowCommentsList extends StatefulWidget{
  final int postId;
  final int userId;
  final int numberOfLikes;
  final int numberOfComments;
  HomeRegularShowCommentsList({this.postId, this.userId, this.numberOfLikes, this.numberOfComments});

  @override
  HomeRegularShowCommentsListState createState() => HomeRegularShowCommentsListState(postId: postId, userId: userId, numberOfLikes: numberOfLikes, numberOfComments: numberOfComments);
}

class HomeRegularShowCommentsListState extends State<HomeRegularShowCommentsList>{
  final int postId;
  final int userId;
  final int numberOfLikes;
  final int numberOfComments;
 HomeRegularShowCommentsListState({this.postId, this.userId, this.numberOfLikes, this.numberOfComments});

  RefreshController refreshController = RefreshController(initialRefresh: true);
  static TextEditingController controller = TextEditingController();
  List<RegularOriginalComment> comments;
  List<RegularOriginalReply> replies;
  Future showOriginalPost;
  int itemRemaining;
  int repliesRemaining;
  int page1;
  int count;
  int numberOfReplies;
  int page2;
  Future<APIRegularShowProfileInformation> currentUser;
  List<bool> commentsLikes;
  List<int> commentsNumberOfLikes;
  bool isComment;
  int currentCommentId;
  List<List<bool>> repliesLikes;
  List<List<int>> repliesNumberOfLikes;

  void initState(){
    super.initState();
    itemRemaining = 1;
    repliesRemaining = 1;
    comments = [];
    replies = [];
    numberOfReplies = 0;
    page1 = 1;
    page2 = 1;
    count = 0;
    commentsLikes = [];
    commentsNumberOfLikes = [];
    repliesLikes = [];
    repliesNumberOfLikes = [];
    isComment = true;

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
      var newValue1 = await apiRegularShowListOfComments(postId: postId, page: page1);
      context.hideLoaderOverlay();
      itemRemaining = newValue1.itemsRemaining;
      count = count + newValue1.commentsList.length;

      for(int i = 0; i < newValue1.commentsList.length; i++){
        var commentLikeStatus = await apiRegularShowCommentOrReplyLikeStatus(commentableType: 'Comment', commentableId: newValue1.commentsList[i].commentId);
        commentsLikes.add(commentLikeStatus.likeStatus);
        commentsNumberOfLikes.add(commentLikeStatus.numberOfLikes);
        
        if(repliesRemaining != 0){
          context.showLoaderOverlay();
          var newValue2 = await apiRegularShowListOfReplies(postId: newValue1.commentsList[i].commentId, page: page2);
          context.hideLoaderOverlay();

          List<bool> newRepliesLikes = [];
          List<int> newRepliesNumberOfLikes = [];
          List<int> newReplyId = [];

          for(int j = 0; j < newValue2.repliesList.length; j++){

            var replyLikeStatus = await apiRegularShowCommentOrReplyLikeStatus(commentableType: 'Reply', commentableId: newValue2.repliesList[j].replyId);
            newRepliesLikes.add(replyLikeStatus.likeStatus);
            newRepliesNumberOfLikes.add(replyLikeStatus.numberOfLikes);
            newReplyId.add(newValue2.repliesList[j].replyId);

            replies.add(
              RegularOriginalReply(
                replyId: newValue2.repliesList[j].replyId,
                commentId: newValue2.repliesList[j].commentId,
                userId: newValue2.repliesList[j].user.userId,
                replyBody: newValue2.repliesList[j].replyBody,
                createdAt: newValue2.repliesList[j].createdAt,
                firstName: newValue2.repliesList[j].user.firstName,
                lastName: newValue2.repliesList[j].user.lastName,
                replyLikes: replyLikeStatus.likeStatus,
                replyNumberOfLikes: replyLikeStatus.numberOfLikes,
                image: newValue2.repliesList[j].user.image,
              ),
            );
          }

          repliesLikes.add(newRepliesLikes);
          repliesNumberOfLikes.add(newRepliesNumberOfLikes);

          repliesRemaining = newValue2.itemsRemaining;
          page2++;
        }

        repliesRemaining = 1;
        page2 = 1;
        
        comments.add(
          RegularOriginalComment(
            commentId: newValue1.commentsList[i].commentId,
            postId: newValue1.commentsList[i].postId,
            userId: newValue1.commentsList[i].user.userId,
            commentBody: newValue1.commentsList[i].commentBody,
            createdAt: newValue1.commentsList[i].createdAt,
            firstName: newValue1.commentsList[i].user.firstName,
            lastName: newValue1.commentsList[i].user.lastName,
            image: newValue1.commentsList[i].user.image,
            commentLikes: commentLikeStatus.likeStatus,
            commentNumberOfLikes: commentLikeStatus.numberOfLikes,
            listOfReplies: replies
          ),    
        );

        replies = [];
      
      }

      if(mounted)
      setState(() {});
      page1++;
      
      refreshController.loadComplete();
    }else{
      refreshController.loadNoData();
    }
  }

  Future<APIRegularShowProfileInformation> getDrawerInformation() async{
    return await apiRegularShowProfileInformation();
  }

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
            isComment = true;
            controller.clear();
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
                controller.clear();
                Navigator.pop(context);
              },
            ),
          ),
          body: count != 0
          ? Container(
            height: SizeConfig.screenHeight - SizeConfig.blockSizeVertical * 13 - AppBar().preferredSize.height,
            child: Column(
            children: [
              Container(
                height: SizeConfig.blockSizeVertical * 5,
                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [

                    Row(
                      children: [
                        Icon(Icons.favorite_border_outlined, color: Color(0xff000000),),

                        SizedBox(width: SizeConfig.blockSizeHorizontal * 1,),

                        Text('$numberOfLikes', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),),

                      ],
                    ),

                    SizedBox(width: SizeConfig.blockSizeHorizontal * 5,),

                    Row(
                      children: [
                        Icon(Icons.chat_bubble_outline_outlined, color: Color(0xff000000),),

                        SizedBox(width: SizeConfig.blockSizeHorizontal * 1,),

                        Text('$numberOfComments', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),),
                      ],
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

                                userId == comments[i].userId
                                ? Expanded(
                                  child: Text('You',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                                : Expanded(
                                  child: Text('${comments[i].firstName}' + ' ' + '${comments[i].lastName}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),

                                commentsLikes[i] == true
                                ? IconButton(
                                  icon: Icon(Icons.favorite, color: Color(0xffE74C3C),), 
                                  padding: EdgeInsets.zero,
                                  onPressed: () async{
                                    setState(() {
                                      commentsLikes[i] = false;
                                      commentsNumberOfLikes[i]--;
                                      
                                    });

                                    await apiRegularLikeOrUnlikeCommentReply(commentableType: 'Comment', commentableId: comments[i].commentId, likeStatus: false);
                                  },
                                )
                                : IconButton(
                                  icon: Icon(Icons.favorite_border_outlined, color: Color(0xffE74C3C),),
                                  padding: EdgeInsets.zero,
                                  onPressed: () async{
                                    setState(() {
                                      commentsLikes[i] = true;
                                      commentsNumberOfLikes[i]++;
                                    });

                                    await apiRegularLikeOrUnlikeCommentReply(commentableType: 'Comment', commentableId: comments[i].commentId, likeStatus: true);
                                  },
                                ),

                                Text('${commentsNumberOfLikes[i]}', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),),

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

                              Text(timeago.format(DateTime.parse(comments[i].createdAt))),

                              SizedBox(width: SizeConfig.blockSizeHorizontal * 5,),

                              GestureDetector(
                                onTap: () async{
                                  setState(() {
                                    isComment = false;
                                    currentCommentId = comments[i].commentId;
                                  });

                                  await showMaterialModalBottomSheet(
                                    expand: true,
                                    context: context,
                                    builder: (context) => Container(
                                      padding: EdgeInsets.all(20.0),
                                      child: TextFormField(
                                        controller: controller,
                                        cursorColor: Color(0xff000000),
                                        keyboardType: TextInputType.text,
                                        maxLines: 10,
                                        decoration: InputDecoration(
                                          labelText: 'Say something...',
                                          labelStyle: TextStyle(
                                            fontSize: 14,
                                            color: Color(0xffffffff),
                                          ),
                                          border: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.transparent,
                                            ),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.transparent,
                                            ),
                                          ),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.transparent,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                child: Text('Reply',),
                              ),

                            ],
                          ),

                          SizedBox(height: SizeConfig.blockSizeVertical * 1,),

                          comments[i].listOfReplies.length != 0
                          ? Column(
                              children: List.generate(comments[i].listOfReplies.length, (index) => 
                              Column(
                                children: [
                                  Container(
                                    height: SizeConfig.blockSizeVertical * 5,
                                    child: Row(
                                      children: [
                                        SizedBox(width: SizeConfig.blockSizeHorizontal * 12,),

                                        CircleAvatar(
                                          backgroundImage: comments[i].listOfReplies[index].image != null ? NetworkImage(comments[i].listOfReplies[index].image) : AssetImage('assets/icons/app-icon.png'),
                                          backgroundColor: Color(0xff888888),
                                        ),

                                        SizedBox(width: SizeConfig.blockSizeHorizontal * 1,),

                                        userId == comments[i].listOfReplies[index].userId
                                        ? Expanded(
                                          child: Text('You',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        )
                                        : Expanded(
                                          child: Text(comments[i].listOfReplies[index].firstName + ' ' + comments[i].listOfReplies[index].lastName,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),

                                        repliesLikes[i][index] == true
                                        ? IconButton(
                                          icon: Icon(Icons.favorite, color: Color(0xffE74C3C),), 
                                          padding: EdgeInsets.zero,
                                          onPressed: () async{
                                            setState(() {
                                              repliesLikes[i][index] = false;
                                              repliesNumberOfLikes[i][index]--;
                                              
                                            });
                                            await apiRegularLikeOrUnlikeCommentReply(commentableType: 'Reply', commentableId: comments[i].listOfReplies[index].replyId, likeStatus: false);
                                          },
                                        )
                                        : IconButton(
                                          icon: Icon(Icons.favorite_border_outlined, color: Color(0xffE74C3C),),
                                          padding: EdgeInsets.zero,
                                          onPressed: () async{
                                            setState(() {
                                              repliesLikes[i][index] = true;
                                              repliesNumberOfLikes[i][index]++;
                                            });
                                            await apiRegularLikeOrUnlikeCommentReply(commentableType: 'Reply', commentableId: comments[i].listOfReplies[index].replyId, likeStatus: true);
                                          },
                                        ),

                                        Text('${repliesNumberOfLikes[i][index]}', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),),

                                      ],
                                    ),
                                  ),

                                  Row(
                                    children: [
                                      SizedBox(width: SizeConfig.blockSizeHorizontal * 24,),

                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.all(10.0),
                                          child: Text(
                                            comments[i].listOfReplies[index].replyBody,
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

                                      SizedBox(width: SizeConfig.blockSizeHorizontal * 24,),

                                      Text(timeago.format(DateTime.parse(comments[i].listOfReplies[index].createdAt))),

                                      SizedBox(width: SizeConfig.blockSizeHorizontal * 5,),

                                      GestureDetector(
                                        onTap: () async{
                                          controller.text = comments[i].firstName + ' ' + comments[i].lastName + ' ';
                                          setState(() {
                                            isComment = false;
                                            currentCommentId = comments[i].commentId;
                                          });
                                          await showMaterialModalBottomSheet(
                                            expand: true,
                                            context: context,
                                            builder: (context) => Container(
                                              padding: EdgeInsets.all(20.0),
                                              child: TextFormField(
                                                controller: controller,
                                                cursorColor: Color(0xff000000),
                                                keyboardType: TextInputType.text,
                                                maxLines: 10,
                                                decoration: InputDecoration(
                                                  labelText: 'Say something...',
                                                  labelStyle: TextStyle(
                                                    fontSize: 14,
                                                    color: Color(0xffffffff),
                                                  ),
                                                  border: UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Colors.transparent,
                                                    ),
                                                  ),
                                                  focusedBorder: UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Colors.transparent,
                                                    ),
                                                  ),
                                                  enabledBorder: UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Colors.transparent,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                        child: Text('Reply',),
                                      ),

                                    ],
                                  ),

                                  SizedBox(height: SizeConfig.blockSizeVertical * 1,),

                                ],
                              ),
                            ),
                          )
                          : Container(
                            height: 0,
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
          bottomNavigationBar: Padding(
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
                      
                      onTap: () async{
                        await showMaterialModalBottomSheet(
                          expand: true,
                          context: context,
                          builder: (context) => Container(
                            padding: EdgeInsets.all(20.0),
                            child: TextFormField(
                              controller: controller,
                              cursorColor: Color(0xff000000),
                              keyboardType: TextInputType.text,
                              maxLines: 10,
                              decoration: InputDecoration(
                                labelText: 'Say something...',
                                labelStyle: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xffffffff),
                                ),
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                  ),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                  ),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      readOnly: true,
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
                  onTap: () async{
                    if(isComment == true){
                      context.showLoaderOverlay();
                      await apiRegularAddComment(postId: postId, commentBody: controller.text);
                      context.hideLoaderOverlay();

                      controller.clear();

                      itemRemaining = 1;
                      repliesRemaining = 1;
                      comments = [];
                      replies = [];
                      numberOfReplies = 0;
                      page1 = 1;
                      page2 = 1;
                      count = 0;
                      commentsLikes = [];
                      commentsNumberOfLikes = [];
                      repliesLikes = [];
                      repliesNumberOfLikes = [];
                      isComment = true;                 

                      onLoading();
                    }else{
                      context.showLoaderOverlay();
                      apiRegularAddReply(commentId: currentCommentId, replyBody: controller.text);
                      context.hideLoaderOverlay();

                      controller.clear();

                      itemRemaining = 1;
                      repliesRemaining = 1;
                      comments = [];
                      replies = [];
                      numberOfReplies = 0;
                      page1 = 1;
                      page2 = 1;
                      count = 0;
                      commentsLikes = [];
                      commentsNumberOfLikes = [];
                      repliesLikes = [];
                      repliesNumberOfLikes = [];
                      isComment = true;

                      onLoading();
                    }

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
          ),
        ),
      ),
    );
  }
}

