import 'package:cached_network_image/cached_network_image.dart';
import 'package:facesbyplaces/API/BLM/api-66-blm-show-original-post.dart';
import 'package:facesbyplaces/API/BLM/api-67-blm-post-like-or-unlike.dart';
import 'package:facesbyplaces/Configurations/date-conversion.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-15-blm-dropdown.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';

class HomeBLMShowOriginalPost extends StatefulWidget{
  final int postId;
  final bool likeStatus;
  final int numberOfLikes;
  HomeBLMShowOriginalPost({this.postId, this.likeStatus, this.numberOfLikes});

  @override
  HomeBLMShowOriginalPostState createState() => HomeBLMShowOriginalPostState(postId: postId, likeStatus: likeStatus, numberOfLikes: numberOfLikes);
}

class HomeBLMShowOriginalPostState extends State<HomeBLMShowOriginalPost>{
  final int postId;
  final bool likeStatus;
  final int numberOfLikes;
  HomeBLMShowOriginalPostState({this.postId, this.likeStatus, this.numberOfLikes});

  Future showOriginalPost;
  bool likePost;
  bool pressedLike;
  int likesCount;

  void initState(){
    super.initState();
    pressedLike = false;
    likePost = likeStatus;
    likesCount = numberOfLikes;
    showOriginalPost = getOriginalPost(postId);
  }

  Future<APIBLMShowOriginalPostMainMain> getOriginalPost(postId) async{
    return await apiBLMShowOriginalPost(postId);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
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
            title: Text('Post', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xffffffff)),),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Color(0xffffffff),), 
              onPressed: (){
                Navigator.popAndPushNamed(context, '/home/blm');
              },
            ),
          ),
          body: Container(
            padding: EdgeInsets.all(5.0),
            height: SizeConfig.screenHeight,
            child: FutureBuilder<APIBLMShowOriginalPostMainMain>(
              future: showOriginalPost,
              builder: (context, originalPost){
                if(originalPost.hasData){
                  return Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 10.0, right: 10.0,),
                        decoration: BoxDecoration(
                          color: Color(0xffffffff),
                          borderRadius: BorderRadius.all(Radius.circular(15),),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: Offset(0, 0)
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Container(
                              height: SizeConfig.blockSizeVertical * 10,
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () async{
                                      
                                    },
                                    child: CircleAvatar(backgroundColor: Color(0xff888888), backgroundImage: originalPost.data.post.page.profileImage != null ? NetworkImage(originalPost.data.post.page.profileImage) : AssetImage('assets/icons/app-icon.png')),
                                  ),
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.only(left: 10.0),
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: Align(alignment: Alignment.bottomLeft,
                                              child: Text(originalPost.data.post.page.name,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: SizeConfig.safeBlockHorizontal * 4,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xff000000),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Align(
                                              alignment: Alignment.topLeft,
                                              child: Text(convertDate(originalPost.data.post.createAt),
                                                maxLines: 1,
                                                style: TextStyle(
                                                  fontSize: SizeConfig.safeBlockHorizontal * 3,
                                                  fontWeight: FontWeight.w400,
                                                  color: Color(0xffaaaaaa)
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  MiscBLMDropDownTemplate(userId: originalPost.data.post.page.id, postId: postId,),
                                ],
                              ),
                            ),

                            Container(alignment: Alignment.centerLeft, child: Text(originalPost.data.post.body),),

                            originalPost.data.post.imagesOrVideos != null
                            ? Container(
                              height: SizeConfig.blockSizeVertical * 50,
                              child: ((){
                                if(originalPost.data.post.imagesOrVideos != null){
                                  return Container(
                                    child: CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      imageUrl: originalPost.data.post.imagesOrVideos[0],
                                      placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                                      errorWidget: (context, url, error) => Center(child: Icon(Icons.error),),
                                    ),
                                  );
                                }else{
                                  return Container(height: 0,);
                                }
                              }()),
                            )
                            : Container(
                              color: Colors.red,
                              height: 0,
                            ),

                            Container(
                              height: SizeConfig.blockSizeVertical * 10,
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () async{
                                      setState(() {
                                        likePost = !likePost;

                                        if(likePost == true){
                                          pressedLike = true;
                                          likesCount++;
                                        }else{
                                          pressedLike = false;
                                          likesCount--;
                                        }
                                      });

                                      await apiBLMLikeOrUnlikePost(postId: postId, like: likePost);

                                    },
                                    child: Row(
                                      children: [
                                        likePost == true
                                        ? Icon(Icons.favorite, color: Color(0xffE74C3C),)
                                        : Icon(Icons.favorite_border_outlined, color: Color(0xffE74C3C),),

                                        SizedBox(width: SizeConfig.blockSizeHorizontal * 1,),

                                        Text('$likesCount', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),),

                                      ],
                                    ),
                                  ),

                                  SizedBox(width: SizeConfig.blockSizeHorizontal * 2,),

                                  GestureDetector(
                                    onTap: (){},
                                    child: Row(
                                      children: [
                                        Image.asset('assets/icons/comment_logo.png', width: SizeConfig.blockSizeHorizontal * 5, height: SizeConfig.blockSizeVertical * 5,),

                                        SizedBox(width: SizeConfig.blockSizeHorizontal * 1,),

                                        Text('${originalPost.data.post.numberOfComments}', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () async{
                                        await FlutterShare.share(
                                          title: 'Share',
                                          text: 'Share the link',
                                          linkUrl: 'http://fbp.dev1.koda.ws/api/v1/posts/$postId',
                                          chooserTitle: 'Share link'
                                        );
                                      },
                                      child: Align(alignment: Alignment.centerRight, child: Image.asset('assets/icons/share_logo.png', width: SizeConfig.blockSizeHorizontal * 13, height: SizeConfig.blockSizeVertical * 13,),),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          ],
                        ),
                      ),

                      Flexible(child: Container(color: Colors.transparent,),),
                    ],
                  );
                }else if(originalPost.hasError){
                  return Container(child: Center(child: Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),),));
                }else{
                  return Container(child: Center(child: Container(child: SpinKitThreeBounce(color: Color(0xff000000), size: 50.0,), color: Color(0xffffffff),),),);
                }
              }
            ),
          ),
        ),
      ),
    );
  }
}