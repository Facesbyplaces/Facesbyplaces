import 'package:facesbyplaces/UI/Home/Regular/02-View-Memorial/home-view-memorial-regular-01-managed-memorial.dart';
import 'package:facesbyplaces/UI/Home/Regular/02-View-Memorial/home-view-memorial-regular-02-profile-memorial.dart';
import 'package:facesbyplaces/API/Regular/12-Show-Post/api-show-post-regular-02-post-like-or-unlike.dart';
import 'package:facesbyplaces/UI/Home/Regular/11-Show-Post/home-show-post-regular-01-show-original-post.dart';
import 'package:facesbyplaces/UI/Home/Regular/11-Show-Post/home-show-post-regular-02-show-comments.dart';
import 'package:facesbyplaces/UI/Home/Regular/12-Show-User/home-show-user-regular-01-user.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'misc-04-regular-dropdown.dart';

class MiscRegularPost extends StatefulWidget{
  final List<Widget> contents;
  final int userId;
  final int postId;
  final int memorialId;
  final dynamic profileImage;
  final String memorialName;
  final String timeCreated;
  final bool managed;
  final bool joined;
  final int numberOfComments;
  final int numberOfLikes;
  final bool likeStatus;
  final int numberOfTagged;
  final List<String> taggedFirstName;
  final List<String> taggedLastName;
  final List<int> taggedId;

  MiscRegularPost({this.contents, this.userId, this.postId, this.memorialId, this.profileImage, this.memorialName = '', this.timeCreated = '', this.managed, this.joined, this.numberOfComments, this.numberOfLikes, this.likeStatus, this.numberOfTagged, this.taggedFirstName, this.taggedLastName, this.taggedId});

  MiscRegularPostState createState() => MiscRegularPostState(contents: contents, userId: userId, postId: postId, memorialId: memorialId, profileImage: profileImage, memorialName: memorialName, timeCreated: timeCreated, managed: managed, joined: joined, numberOfComments: numberOfComments, numberOfLikes: numberOfLikes, likeStatus: likeStatus, numberOfTagged: numberOfTagged, taggedFirstName: taggedFirstName, taggedLastName: taggedLastName, taggedId: taggedId);
}

class MiscRegularPostState extends State<MiscRegularPost> with WidgetsBindingObserver{
  final List<Widget> contents;
  final int userId;
  final int postId;
  final int memorialId;
  final dynamic profileImage;
  final String memorialName;
  final String timeCreated;
  final bool managed;
  final bool joined;
  final int numberOfComments;
  final int numberOfLikes;
  final bool likeStatus;
  final int numberOfTagged;
  final List<String> taggedFirstName;
  final List<String> taggedLastName;
  final List<int> taggedId;

  MiscRegularPostState({this.contents, this.userId, this.postId, this.memorialId, this.profileImage, this.memorialName = '', this.timeCreated = '', this.managed, this.joined, this.numberOfComments, this.numberOfLikes, this.likeStatus, this.numberOfTagged, this.taggedFirstName, this.taggedLastName, this.taggedId});

  Future profileFollowing;
  bool likePost;
  bool pressedLike;
  int likesCount;

  String category;
  BranchUniversalObject buo;
  BranchLinkProperties lp;
  BranchContentMetaData metadata;

  void initState(){
    super.initState();
    likePost = likeStatus;
    pressedLike = false;
    likesCount = numberOfLikes;
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
      title: 'FacesbyPlace Post',
      imageUrl: 'assets/icons/app-icon.png',
      contentDescription: 'FacesbyPlaces post shared.',
      keywords: ['FacesbyPlaces', 'Share', 'Post'],
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
    lp.addControlParam('url', 'https://29cft.test-app.link/suCwfzCi6bb');
  }

  @override
  Widget build(BuildContext context){
    SizeConfig.init(context);
    ResponsiveWidgets.init(context,
      height: SizeConfig.screenHeight,
      width: SizeConfig.screenWidth,
    );
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularShowOriginalPost(postId: postId, likeStatus: likePost, numberOfLikes: likesCount,)));
      },
      child: Container(
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
              height: ScreenUtil().setHeight(65),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () async{

                      if(managed == true){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularProfile(memorialId: memorialId,)));
                      }else{
                        Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularMemorialProfile(memorialId: memorialId, newJoin: true)));
                      }
                      
                    },

                    child: CircleAvatar(backgroundColor: Color(0xff888888), backgroundImage: profileImage != null ? NetworkImage(profileImage) : AssetImage('assets/icons/app-icon.png')),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Column(
                        children: [
                          Expanded(
                            child: Align(alignment: Alignment.bottomLeft,
                              child: Text(memorialName,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: ScreenUtil().setSp(14, allowFontScalingSelf: true),
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff000000),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(timeCreated,
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: ScreenUtil().setSp(12, allowFontScalingSelf: true),
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
                  MiscRegularDropDownTemplate(postId: postId, reportType: 'Post',),
                ],
              ),
            ),

            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                children: contents,
              ),
            ),

                            // originalPost.data.post.imagesOrVideos != null
                            // ? Container(
                            //   // color: Colors.red,
                            //   // height: SizeConfig.blockSizeVertical * 50,
                            //   height: SizeConfig.blockSizeVertical * 30,
                            //   child: ((){
                            //     print('The length of images is ${originalPost.data.post.imagesOrVideos.length}');
                            //     if(originalPost.data.post.imagesOrVideos != null){
                            //       if(originalPost.data.post.imagesOrVideos.length == 1){
                            //         return Container(
                            //           child: CachedNetworkImage(
                            //             fit: BoxFit.cover,
                            //             imageUrl: originalPost.data.post.imagesOrVideos[0],
                            //             placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                            //             errorWidget: (context, url, error) => Center(child: Icon(Icons.error),),
                            //           ),
                            //         );
                            //       }else if(originalPost.data.post.imagesOrVideos.length == 2){
                            //         return StaggeredGridView.countBuilder(
                            //           padding: EdgeInsets.zero,
                            //           physics: NeverScrollableScrollPhysics(),
                            //           crossAxisCount: 4,
                            //           itemCount: 2,
                            //           itemBuilder: (BuildContext context, int index) => 
                            //             CachedNetworkImage(
                            //               fit: BoxFit.cover,
                            //               imageUrl: originalPost.data.post.imagesOrVideos[index],
                            //               placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                            //               errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                            //             ),
                            //           staggeredTileBuilder: (int index) => StaggeredTile.count(2, 2),
                            //           mainAxisSpacing: 4.0,
                            //           crossAxisSpacing: 4.0,
                            //         );
                            //       }else{
                            //         return Container(
                            //           child: StaggeredGridView.countBuilder(
                            //             padding: EdgeInsets.zero,
                            //             physics: NeverScrollableScrollPhysics(),
                            //             crossAxisCount: 4,
                            //             itemCount: 3,
                            //             itemBuilder: (BuildContext context, int index) => 
                            //             GestureDetector(
                            //               onTap: () async{
                            //                 FullScreenMenu.show(
                            //                   context,
                            //                   backgroundColor: Color(0xff888888),
                            //                   items: [
                            //                     Center(
                            //                       child: Container(
                            //                         height: SizeConfig.screenHeight - SizeConfig.blockSizeVertical * 30,
                            //                         child: CarouselSlider(
                            //                           items: List.generate(
                            //                             originalPost.data.post.imagesOrVideos.length, (next) =>
                            //                             CachedNetworkImage(
                            //                               fit: BoxFit.cover,
                            //                               imageUrl: originalPost.data.post.imagesOrVideos[next],
                            //                               placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                            //                               errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                            //                             ),
                            //                           ),
                            //                           options: CarouselOptions(
                            //                             autoPlay: false,
                            //                             enlargeCenterPage: true,
                            //                             viewportFraction: 0.9,
                            //                             aspectRatio: 2.0,
                            //                             initialPage: 2,
                            //                           ),
                            //                         ),
                            //                       ),
                            //                     ),
                            //                   ],
                            //                 );
                            //               },
                            //               child: CachedNetworkImage(
                            //                 fit: BoxFit.cover,
                            //                 imageUrl: originalPost.data.post.imagesOrVideos[index],
                            //                 placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                            //                 errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                            //               ),
                            //             ),
                            //             staggeredTileBuilder: (int index) => StaggeredTile.count(2, index.isEven ? 1 : 2),
                            //             mainAxisSpacing: 4.0,
                            //             crossAxisSpacing: 4.0,
                            //           ),
                            //         );
                            //       }
                            //     }else{
                            //       return Container(height: 0,);
                            //     }
                            //   }()),
                            // )
                            // : Container(
                            //   color: Colors.red,
                            //   height: 0,
                            // ),

            numberOfTagged != 0
            ? Row(
              children: [
                Text('with'),

                Container(
                  child: Wrap(
                    spacing: 5.0,
                    children: List.generate(
                      numberOfTagged,
                      (index) => GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularUserProfile(userId: taggedId[index])));
                        },
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xff000000)),
                            children: <TextSpan>[
                              TextSpan(text: taggedFirstName[index],),

                              TextSpan(text: ' '),

                              TextSpan(text: taggedLastName[index],),

                              index < numberOfTagged - 1
                              ? TextSpan(text: ',')
                              : TextSpan(text: ''),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  padding: EdgeInsets.only(left: 5.0, right: 5.0,), 
                  alignment: Alignment.centerLeft,
                ),
              ],
            )
            : Container(height: 0,),

            Container(
              height: ScreenUtil().setHeight(65),
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

                      await apiRegularLikeOrUnlikePost(postId: postId, like: likePost);

                    },
                    child: Row(
                      children: [
                        likePost == true
                        ? Icon(Icons.favorite, color: Color(0xffE74C3C),)
                        : Icon(Icons.favorite_border_outlined, color: Color(0xffE74C3C),),

                        SizedBox(width: SizeConfig.blockSizeHorizontal * 1,),

                        Text('$likesCount', style: TextStyle(fontSize: ScreenUtil().setSp(14, allowFontScalingSelf: true), color: Color(0xff000000),),),

                      ],
                    ),
                  ),

                  SizedBox(width: SizeConfig.blockSizeHorizontal * 2,),

                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularShowCommentsList(postId: postId, userId: userId, numberOfLikes: likesCount, numberOfComments: numberOfComments,)));
                    },
                    child: Row(
                      children: [
                        Image.asset('assets/icons/comment_logo.png', width: SizeConfig.blockSizeHorizontal * 5, height: SizeConfig.blockSizeVertical * 5,),

                        SizedBox(width: SizeConfig.blockSizeHorizontal * 1,),

                        Text('$numberOfComments', style: TextStyle(fontSize: ScreenUtil().setSp(14, allowFontScalingSelf: true), color: Color(0xff000000),),),
                      ],
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
                          messageText: 'FacesbyPlaces Post',
                          androidMessageTitle: 'New post from FacesbyPlaces. Click this link to view the post.',
                          androidSharingTitle: 'FacesbyPlaces Post',
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
                      child: Align(alignment: Alignment.centerRight, child: Image.asset('assets/icons/share_logo.png', width: SizeConfig.blockSizeHorizontal * 13, height: SizeConfig.blockSizeVertical * 13,),),
                    ),
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}

