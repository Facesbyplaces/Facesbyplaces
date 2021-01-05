import 'package:facesbyplaces/API/BLM/02-Main/api-main-blm-02-show-user-information.dart';
import 'package:facesbyplaces/API/BLM/12-Show-Post/api-show-post-blm-03-show-post-comments.dart';
import 'package:facesbyplaces/API/BLM/12-Show-Post/api-show-post-blm-04-show-comment-replies.dart';
import 'package:facesbyplaces/API/BLM/12-Show-Post/api-show-post-blm-05-add-comment.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-16-blm-empty-display.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/material.dart';

class BLMOriginalComment{
  int commentId;
  int postId;
  int userId;
  String commentBody;
  String createdAt;
  String firstName;
  String lastName;
  dynamic image;
  List<BLMOriginalReply> listOfReplies;

  BLMOriginalComment({this.commentId, this.postId, this.userId, this.commentBody, this.createdAt, this.firstName, this.lastName, this.image, this.listOfReplies});
}

class BLMOriginalReply{
  int replyId;
  int commentId;
  int userId;
  String replyBody;
  String createdAt;
  String firstName;
  String lastName;
  dynamic image;

  BLMOriginalReply({this.replyId, this.commentId, this.userId, this.replyBody, this.createdAt, this.firstName, this.lastName, this.image});
}

class HomeBLMShowCommentsList extends StatefulWidget{
  final int postId;
  final int userId;
  final int numberOfLikes;
  final int numberOfComments;
  HomeBLMShowCommentsList({this.postId, this.userId, this.numberOfLikes, this.numberOfComments});

  @override
  HomeBLMShowCommentsListState createState() => HomeBLMShowCommentsListState(postId: postId, userId: userId, numberOfLikes: numberOfLikes, numberOfComments: numberOfComments);
}

class HomeBLMShowCommentsListState extends State<HomeBLMShowCommentsList>{
  final int postId;
  final int userId;
  final int numberOfLikes;
  final int numberOfComments;
  HomeBLMShowCommentsListState({this.postId, this.userId, this.numberOfLikes, this.numberOfComments});

  RefreshController refreshController = RefreshController(initialRefresh: true);
  static TextEditingController controller = TextEditingController();
  List<BLMOriginalComment> comments;
  List<BLMOriginalReply> replies;
  Future showOriginalPost;
  int itemRemaining;
  int repliesRemaining;
  int page1;
  int count;
  int numberOfReplies;
  int page2;
  static Future<APIBLMShowProfileInformation> currentUser;
  int replyToComment;
  int replyToReply;
  

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
    replyToComment = 0;
    replyToReply = 0;
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
      var newValue1 = await apiBLMShowListOfComments(postId: postId, page: page1);
      context.hideLoaderOverlay();
      itemRemaining = newValue1.itemsRemaining;
      count = count + newValue1.commentsList.length;

      for(int i = 0; i < newValue1.commentsList.length; i++){
        print('The number of loops is $i');
        if(repliesRemaining != 0){
          context.showLoaderOverlay();
          var newValue2 = await apiBLMShowListOfReplies(postId: newValue1.commentsList[i].commentId, page: page2);
          context.hideLoaderOverlay();
          // numberOfReplies = newValue2.repliesList.length;
          print('The number of replies is ${newValue2.repliesList.length}');
          for(int j = 0; j < newValue2.repliesList.length; j++){
            replies.add(
              BLMOriginalReply(
                replyId: newValue2.repliesList[j].replyId,
                commentId: newValue2.repliesList[j].commentId,
                userId: newValue2.repliesList[j].user.userId,
                replyBody: newValue2.repliesList[j].replyBody,
                // createdAt: timeago.format(DateTime.parse(newValue2.repliesList[j].createdAt)),
                createdAt: newValue2.repliesList[j].createdAt,
                firstName: newValue2.repliesList[j].user.firstName,
                lastName: newValue2.repliesList[j].user.lastName,
                image: newValue2.repliesList[j].user.image,
              ),
            );

            print('The reply is ${newValue2.repliesList[j].replyBody}');
          }

          

          repliesRemaining = newValue2.itemsRemaining;
          page2++;
        }

        repliesRemaining = 1;
        page2 = 1;

        
        
        comments.add(
          BLMOriginalComment(
            commentId: newValue1.commentsList[i].commentId,
            postId: newValue1.commentsList[i].postId,
            userId: newValue1.commentsList[i].user.userId,
            commentBody: newValue1.commentsList[i].commentBody,
            createdAt: newValue1.commentsList[i].createdAt,
            firstName: newValue1.commentsList[i].user.firstName,
            lastName: newValue1.commentsList[i].user.lastName,
            image: newValue1.commentsList[i].user.image,
            listOfReplies: replies
          ),    
        );

        print('The length of replies is ${comments[i].listOfReplies.length}');

        // print('The reply body is ${comments[i].listOfReplies[0].replyBody}');

        // replies.clear();
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

  Future<APIBLMShowProfileInformation> getDrawerInformation() async{
    return await apiBLMShowProfileInformation();
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

                              Text(timeago.format(DateTime.parse(comments[i].createdAt))),

                              SizedBox(width: SizeConfig.blockSizeHorizontal * 5,),

                              GestureDetector(
                                onTap: (){
                                  setState(() {
                                    replyToComment = i;
                                  });
                                  print('The index of reply is $replyToComment');
                                },
                                child: Text('Reply',),
                              ),

                            ],
                          ),

                          SizedBox(height: SizeConfig.blockSizeVertical * 1,),

                          comments[i].listOfReplies.length != 0
                          ? Column(
                              children: List.generate(comments[i].listOfReplies.length, (index) => 
                              // MiscBLMShowReply(
                              //   currentUserId: userId,
                              //   userId: comments[i].listOfReplies[index].userId,
                              //   image: comments[i].listOfReplies[index].image,
                              //   firstName: comments[i].listOfReplies[index].firstName,
                              //   lastName: comments[i].listOfReplies[index].lastName,
                              //   commentBody: comments[i].listOfReplies[index].replyBody,
                              //   createdAt: comments[i].listOfReplies[index].createdAt,
                              //   numberOfLikes: 1,
                              // ),

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

                                        Icon(Icons.favorite_border_outlined, color: Color(0xffE74C3C),),

                                        SizedBox(width: SizeConfig.blockSizeHorizontal * 1,),

                                        Text('$numberOfLikes', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),),

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

                                      // Text(convertDate(createdAt)),
                                      Text(timeago.format(DateTime.parse(comments[i].listOfReplies[index].createdAt))),

                                      SizedBox(width: SizeConfig.blockSizeHorizontal * 5,),

                                      GestureDetector(
                                        onTap: (){
                                          setState(() {
                                            replyToReply = index;
                                          });
                                          print('The index of reply is $replyToComment');
                                        },
                                        child: 
                                        replyToReply == index
                                        ? Text('Reply', style: TextStyle(fontWeight: FontWeight.bold),)
                                        : Text('Reply',),
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
                  child: MiscBLMEmptyDisplayTemplate(message: 'Comment is empty',),
                ),
              ),
            ),
          ),
          bottomNavigationBar: Padding(
            padding: EdgeInsets.only(left: 20.0, right: 20.0,),
            child: Row(
              children: [
                
                FutureBuilder<APIBLMShowProfileInformation>(
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
                                // fillColor: Color(0xffBDC3C7),
                                // filled: true,
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
                                // focusedBorder: OutlineInputBorder(
                                //   borderSide: BorderSide(
                                //     color: Color(0xffBDC3C7),
                                //   ),
                                //   borderRadius: BorderRadius.all(Radius.circular(10)),
                                // ),
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

                    print('The post id is $postId');
                    print('The post id is ${controller.text}');

                    context.showLoaderOverlay();
                    bool result = await apiBLMAddComment(postId: postId, commentBody: controller.text);
                    context.hideLoaderOverlay();

                    controller.clear();

                    print('The result is $result');
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

