// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:facesbyplaces/API/Regular/12-Show-Post/api-show-post-regular-01-show-original-post.dart';
// import 'package:facesbyplaces/API/Regular/12-Show-Post/api-show-post-regular-02-post-like-or-unlike.dart';
// import 'package:facesbyplaces/UI/Home/Regular/12-Show-User/home-show-user-regular-01-user.dart';
// import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-04-regular-dropdown.dart';
// import 'package:facesbyplaces/Configurations/size_configuration.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
// import 'package:full_screen_menu/full_screen_menu.dart';
// import 'home-show-post-regular-02-show-comments.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:flutter_share/flutter_share.dart';
// import 'package:timeago/timeago.dart' as timeago;
// import 'package:flutter/material.dart';

// class HomeRegularShowOriginalPost extends StatefulWidget{
//   final int postId;
//   final bool likeStatus;
//   final int numberOfLikes;
//   HomeRegularShowOriginalPost({this.postId, this.likeStatus, this.numberOfLikes});

//   @override
//   HomeRegularShowOriginalPostState createState() => HomeRegularShowOriginalPostState(postId: postId, likeStatus: likeStatus, numberOfLikes: numberOfLikes);
// }

// class HomeRegularShowOriginalPostState extends State<HomeRegularShowOriginalPost>{
//   final int postId;
//   final bool likeStatus;
//   final int numberOfLikes;
//   HomeRegularShowOriginalPostState({this.postId, this.likeStatus, this.numberOfLikes});

//   Future showOriginalPost;
//   bool likePost;
//   bool pressedLike;
//   int likesCount;

//   CarouselController buttonCarouselController = CarouselController();

//   void initState(){
//     super.initState();
//     pressedLike = false;
//     likePost = likeStatus;
//     likesCount = numberOfLikes;
//     showOriginalPost = getOriginalPost(postId);
//   }

//   Future<APIRegularShowOriginalPostMainMain> getOriginalPost(postId) async{
//     return await apiRegularShowOriginalPost(postId: postId);
//   }

//   @override
//   Widget build(BuildContext context) {
//     SizeConfig.init(context);
//     return WillPopScope(
//       onWillPop: () async{
//         return Navigator.canPop(context);
//       },
//       child: GestureDetector(
//         onTap: (){
//           FocusNode currentFocus = FocusScope.of(context);
//           if(!currentFocus.hasPrimaryFocus){
//             currentFocus.unfocus();
//           }
//         },
//         child: Scaffold(
//           appBar: AppBar(
//             backgroundColor: Color(0xff04ECFF),
//             title: Text('Post', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xffffffff)),),
//             centerTitle: true,
//             leading: IconButton(
//               icon: Icon(Icons.arrow_back, color: Color(0xffffffff),), 
//               onPressed: (){
//                 Navigator.pop(context);
//               },
//             ),
//           ),
//           body: SingleChildScrollView(
//             physics: ClampingScrollPhysics(),
//             child: Container(
//             padding: EdgeInsets.all(5.0),
//             height: SizeConfig.screenHeight,
//             child: FutureBuilder<APIRegularShowOriginalPostMainMain>(
//               future: showOriginalPost,
//               builder: (context, originalPost){
//                 if(originalPost.hasData){
//                   return Column(
//                     children: [
//                       Container(
//                         padding: EdgeInsets.only(left: 10.0, right: 10.0,),
//                         decoration: BoxDecoration(
//                           color: Color(0xffffffff),
//                           borderRadius: BorderRadius.all(Radius.circular(15),),
//                           boxShadow: <BoxShadow>[
//                             BoxShadow(
//                               color: Colors.grey.withOpacity(0.5),
//                               spreadRadius: 1,
//                               blurRadius: 5,
//                               offset: Offset(0, 0)
//                             ),
//                           ],
//                         ),
//                         child: Column(
//                           children: [
//                             Container(
//                               height: SizeConfig.blockSizeVertical * 10,
//                               child: Row(
//                                 children: [
//                                   GestureDetector(
//                                     onTap: () async{
                                      
//                                     },
//                                     child: CircleAvatar(backgroundColor: Color(0xff888888), backgroundImage: originalPost.data.post.page.profileImage != null ? NetworkImage(originalPost.data.post.page.profileImage) : AssetImage('assets/icons/app-icon.png')),
//                                   ),
//                                   Expanded(
//                                     child: Container(
//                                       padding: EdgeInsets.only(left: 10.0),
//                                       child: Column(
//                                         children: [
//                                           Expanded(
//                                             child: Align(alignment: Alignment.bottomLeft,
//                                               child: Text(originalPost.data.post.page.name,
//                                                 overflow: TextOverflow.ellipsis,
//                                                 style: TextStyle(
//                                                   fontSize: SizeConfig.safeBlockHorizontal * 4,
//                                                   fontWeight: FontWeight.bold,
//                                                   color: Color(0xff000000),
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                           Expanded(
//                                             child: Align(
//                                               alignment: Alignment.topLeft,
//                                               child: Text(timeago.format(DateTime.parse(originalPost.data.post.createAt)),
//                                                 maxLines: 1,
//                                                 style: TextStyle(
//                                                   fontSize: SizeConfig.safeBlockHorizontal * 3,
//                                                   fontWeight: FontWeight.w400,
//                                                   color: Color(0xffaaaaaa)
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                   MiscRegularDropDownTemplate(postId: postId, reportType: 'Post',),
//                                 ],
//                               ),
//                             ),

//                             Container(alignment: Alignment.centerLeft, child: Text(originalPost.data.post.body),),

//                             originalPost.data.post.imagesOrVideos != null
//                             ? Container(
//                               height: SizeConfig.blockSizeVertical * 30,
//                               child: ((){
//                                 if(originalPost.data.post.imagesOrVideos != null){
//                                   if(originalPost.data.post.imagesOrVideos.length == 1){
//                                     return Container(
//                                       child: CachedNetworkImage(
//                                         fit: BoxFit.cover,
//                                         imageUrl: originalPost.data.post.imagesOrVideos[0],
//                                         placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
//                                         errorWidget: (context, url, error) => Center(child: Icon(Icons.error),),
//                                       ),
//                                     );
//                                   }else if(originalPost.data.post.imagesOrVideos.length == 2){
//                                     return StaggeredGridView.countBuilder(
//                                       padding: EdgeInsets.zero,
//                                       physics: NeverScrollableScrollPhysics(),
//                                       crossAxisCount: 4,
//                                       itemCount: 2,
//                                       itemBuilder: (BuildContext context, int index) => 
//                                         GestureDetector(
//                                           onTap: () async{
//                                             FullScreenMenu.show(
//                                               context,
//                                               backgroundColor: Color(0xff888888),
//                                               items: [
//                                                 Center(
//                                                   child: Container(
//                                                     height: SizeConfig.screenHeight - SizeConfig.blockSizeVertical * 30,
//                                                     child: CarouselSlider(
//                                                       items: List.generate(
//                                                         originalPost.data.post.imagesOrVideos.length, (next) =>
//                                                         CachedNetworkImage(
//                                                           fit: BoxFit.cover,
//                                                           imageUrl: originalPost.data.post.imagesOrVideos[next],
//                                                           placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
//                                                           errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
//                                                         ),
//                                                       ),
//                                                       options: CarouselOptions(
//                                                         autoPlay: false,
//                                                         enlargeCenterPage: true,
//                                                         viewportFraction: 0.9,
//                                                         aspectRatio: 2.0,
//                                                         initialPage: 2,
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ],
//                                             );
//                                           },
//                                           child: CachedNetworkImage(
//                                             fit: BoxFit.cover,
//                                             imageUrl: originalPost.data.post.imagesOrVideos[index],
//                                             placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
//                                             errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
//                                           ),
//                                         ),
//                                       staggeredTileBuilder: (int index) => StaggeredTile.count(2, 2),
//                                       mainAxisSpacing: 4.0,
//                                       crossAxisSpacing: 4.0,
//                                     );
//                                   }else{
//                                     return Container(
//                                       child: StaggeredGridView.countBuilder(
//                                         padding: EdgeInsets.zero,
//                                         physics: NeverScrollableScrollPhysics(),
//                                         crossAxisCount: 4,
//                                         itemCount: 3,
//                                         itemBuilder: (BuildContext context, int index) => 
//                                         GestureDetector(
//                                           onTap: () async{
//                                             FullScreenMenu.show(
//                                               context,
//                                               backgroundColor: Color(0xff888888),
//                                               items: [
//                                                 Center(
//                                                   child: Container(
//                                                     height: SizeConfig.screenHeight - SizeConfig.blockSizeVertical * 30,
//                                                     child: CarouselSlider(
//                                                       items: List.generate(
//                                                         originalPost.data.post.imagesOrVideos.length, (next) =>
//                                                         CachedNetworkImage(
//                                                           fit: BoxFit.cover,
//                                                           imageUrl: originalPost.data.post.imagesOrVideos[next],
//                                                           placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
//                                                           errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
//                                                         ),
//                                                       ),
//                                                       options: CarouselOptions(
//                                                         autoPlay: false,
//                                                         enlargeCenterPage: true,
//                                                         viewportFraction: 0.9,
//                                                         aspectRatio: 2.0,
//                                                         initialPage: 2,
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ],
//                                             );
//                                           },
//                                           child: CachedNetworkImage(
//                                             fit: BoxFit.cover,
//                                             imageUrl: originalPost.data.post.imagesOrVideos[index],
//                                             placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
//                                             errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
//                                           ),
//                                         ),
//                                         staggeredTileBuilder: (int index) => StaggeredTile.count(2, index.isEven ? 1 : 2),
//                                         mainAxisSpacing: 4.0,
//                                         crossAxisSpacing: 4.0,
//                                       ),
//                                     );
//                                   }
//                                 }else{
//                                   return Container(height: 0,);
//                                 }
//                               }()),
//                             )
//                             : Container(
//                               color: Colors.red,
//                               height: 0,
//                             ),

//                             originalPost.data.post.postTagged.length != 0
//                             ? Row(
//                               children: [
//                                 Text('with'),

//                                 Container(
//                                   child: Wrap(
//                                     spacing: 5.0,
//                                     children: List.generate(
//                                       originalPost.data.post.postTagged.length,
//                                       (index) => GestureDetector(
//                                         onTap: (){
//                                           Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularUserProfile(userId: originalPost.data.post.postTagged[index].taggedId)));
//                                         },
//                                         child: RichText(
//                                           text: TextSpan(
//                                             style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xff000000)),
//                                             children: <TextSpan>[
//                                               TextSpan(text: originalPost.data.post.postTagged[index].taggedFirstName,),

//                                               TextSpan(text: ' '),

//                                               TextSpan(text: originalPost.data.post.postTagged[index].taggedLastName,),

//                                               index < originalPost.data.post.postTagged.length - 1
//                                               ? TextSpan(text: ',')
//                                               : TextSpan(text: ''),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   padding: EdgeInsets.only(left: 5.0, right: 5.0,), 
//                                   alignment: Alignment.centerLeft,
//                                 ),
//                               ],
//                             )
//                             : Container(height: 0,),

//                             Container(
//                               height: SizeConfig.blockSizeVertical * 10,
//                               child: Row(
//                                 children: [
//                                   GestureDetector(
//                                     onTap: () async{
//                                       setState(() {
//                                         likePost = !likePost;

//                                         if(likePost == true){
//                                           pressedLike = true;
//                                           likesCount++;
//                                         }else{
//                                           pressedLike = false;
//                                           likesCount--;
//                                         }
//                                       });

//                                       await apiRegularLikeOrUnlikePost(postId: postId, like: likePost);

//                                     },
//                                     child: Row(
//                                       children: [
//                                         likePost == true
//                                         ? Icon(Icons.favorite, color: Color(0xffE74C3C),)
//                                         : Icon(Icons.favorite_border_outlined, color: Color(0xffE74C3C),),

//                                         SizedBox(width: SizeConfig.blockSizeHorizontal * 1,),

//                                         Text('$likesCount', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),),
//                                       ],
//                                     ),
//                                   ),

//                                   SizedBox(width: SizeConfig.blockSizeHorizontal * 2,),

//                                   GestureDetector(
//                                     onTap: (){
//                                       Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularShowCommentsList(postId: postId, numberOfLikes: likesCount, numberOfComments: originalPost.data.post.numberOfComments,)));
//                                     },
//                                     child: Row(
//                                       children: [
//                                         Image.asset('assets/icons/comment_logo.png', width: SizeConfig.blockSizeHorizontal * 5, height: SizeConfig.blockSizeVertical * 5,),

//                                         SizedBox(width: SizeConfig.blockSizeHorizontal * 1,),

//                                         Text('${originalPost.data.post.numberOfComments}', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),),
//                                       ],
//                                     ),
//                                   ),
//                                   Expanded(
//                                     child: GestureDetector(
//                                       onTap: () async{
//                                         await FlutterShare.share(
//                                           title: 'Share',
//                                           text: 'Share the link',
//                                           linkUrl: 'http://fbp.dev1.koda.ws/api/v1/posts/$postId',
//                                           chooserTitle: 'Share link'
//                                         );
//                                       },
//                                       child: Align(alignment: Alignment.centerRight, child: Image.asset('assets/icons/share_logo.png', width: SizeConfig.blockSizeHorizontal * 13, height: SizeConfig.blockSizeVertical * 13,),),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),

//                           ],
//                         ),
//                       ),

//                       Flexible(child: Container(color: Colors.transparent,),),
//                     ],
//                   );
//                 }else if(originalPost.hasError){
//                   return Container(child: Center(child: Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),),));
//                 }else{
//                   return Container(child: Center(child: Container(child: SpinKitThreeBounce(color: Color(0xff000000), size: 50.0,), color: Color(0xffffffff),),),);
//                 }
//               }
//             ),
//           ),
//           ),
//         ),
//       ),
//     );
//   }
// }




import 'package:carousel_slider/carousel_slider.dart';
import 'package:facesbyplaces/API/Regular/12-Show-Post/api-show-post-regular-01-show-original-post.dart';
import 'package:facesbyplaces/API/Regular/12-Show-Post/api-show-post-regular-02-post-like-or-unlike.dart';
import 'package:facesbyplaces/UI/Home/Regular/12-Show-User/home-show-user-regular-01-user.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-04-regular-dropdown.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:full_screen_menu/full_screen_menu.dart';
import 'home-show-post-regular-02-show-comments.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:flutter_share/flutter_share.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/material.dart';

class HomeRegularShowOriginalPost extends StatefulWidget{
  final int postId;
  final bool likeStatus;
  final int numberOfLikes;
  HomeRegularShowOriginalPost({this.postId, this.likeStatus, this.numberOfLikes});

  @override
  HomeRegularShowOriginalPostState createState() => HomeRegularShowOriginalPostState(postId: postId, likeStatus: likeStatus, numberOfLikes: numberOfLikes);
}

class HomeRegularShowOriginalPostState extends State<HomeRegularShowOriginalPost>{
  final int postId;
  final bool likeStatus;
  final int numberOfLikes;
  HomeRegularShowOriginalPostState({this.postId, this.likeStatus, this.numberOfLikes});

  Future showOriginalPost;
  bool likePost;
  bool pressedLike;
  int likesCount;

  CarouselController buttonCarouselController = CarouselController();

  void initState(){
    super.initState();
    pressedLike = false;
    likePost = likeStatus;
    likesCount = numberOfLikes;
    showOriginalPost = getOriginalPost(postId);
  }

  Future<APIRegularShowOriginalPostMainMain> getOriginalPost(postId) async{
    return await apiRegularShowOriginalPost(postId: postId);
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
                Navigator.pop(context);
              },
            ),
          ),
          body: Container(
            padding: EdgeInsets.all(5.0),
            height: SizeConfig.screenHeight - AppBar().preferredSize.height,
            child: FutureBuilder<APIRegularShowOriginalPostMainMain>(
              future: showOriginalPost,
              builder: (context, originalPost){
                if(originalPost.hasData){
                  return ListView(
                    physics: ClampingScrollPhysics(),
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
                                              child: Text(timeago.format(DateTime.parse(originalPost.data.post.createAt)),
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
                                  MiscRegularDropDownTemplate(postId: postId, reportType: 'Post',),
                                ],
                              ),
                            ),

                            Container(alignment: Alignment.centerLeft, child: Text(originalPost.data.post.body),),

                            originalPost.data.post.imagesOrVideos != null
                            ? Container(
                              height: SizeConfig.blockSizeVertical * 30,
                              child: ((){
                                if(originalPost.data.post.imagesOrVideos != null){
                                  if(originalPost.data.post.imagesOrVideos.length == 1){
                                    return Container(
                                      child: CachedNetworkImage(
                                        fit: BoxFit.cover,
                                        imageUrl: originalPost.data.post.imagesOrVideos[0],
                                        placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                                        errorWidget: (context, url, error) => Center(child: Icon(Icons.error),),
                                      ),
                                    );
                                  }else if(originalPost.data.post.imagesOrVideos.length == 2){
                                    return StaggeredGridView.countBuilder(
                                      padding: EdgeInsets.zero,
                                      physics: NeverScrollableScrollPhysics(),
                                      crossAxisCount: 4,
                                      itemCount: 2,
                                      itemBuilder: (BuildContext context, int index) => 
                                        GestureDetector(
                                          onTap: () async{
                                            FullScreenMenu.show(
                                              context,
                                              backgroundColor: Color(0xff888888),
                                              items: [
                                                Center(
                                                  child: Container(
                                                    height: SizeConfig.screenHeight - SizeConfig.blockSizeVertical * 30,
                                                    child: CarouselSlider(
                                                      items: List.generate(
                                                        originalPost.data.post.imagesOrVideos.length, (next) =>
                                                        CachedNetworkImage(
                                                          fit: BoxFit.cover,
                                                          imageUrl: originalPost.data.post.imagesOrVideos[next],
                                                          placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                                                          errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                        ),
                                                      ),
                                                      options: CarouselOptions(
                                                        autoPlay: false,
                                                        enlargeCenterPage: true,
                                                        viewportFraction: 0.9,
                                                        aspectRatio: 2.0,
                                                        initialPage: 2,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                          child: CachedNetworkImage(
                                            fit: BoxFit.cover,
                                            imageUrl: originalPost.data.post.imagesOrVideos[index],
                                            placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                                            errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                          ),
                                        ),
                                      staggeredTileBuilder: (int index) => StaggeredTile.count(2, 2),
                                      mainAxisSpacing: 4.0,
                                      crossAxisSpacing: 4.0,
                                    );
                                  }else{
                                    return Container(
                                      child: StaggeredGridView.countBuilder(
                                        padding: EdgeInsets.zero,
                                        physics: NeverScrollableScrollPhysics(),
                                        crossAxisCount: 4,
                                        itemCount: 3,
                                        itemBuilder: (BuildContext context, int index) => 
                                        GestureDetector(
                                          onTap: () async{
                                            FullScreenMenu.show(
                                              context,
                                              backgroundColor: Color(0xff888888),
                                              items: [
                                                Center(
                                                  child: Container(
                                                    height: SizeConfig.screenHeight - SizeConfig.blockSizeVertical * 30,
                                                    child: CarouselSlider(
                                                      items: List.generate(
                                                        originalPost.data.post.imagesOrVideos.length, (next) =>
                                                        CachedNetworkImage(
                                                          fit: BoxFit.cover,
                                                          imageUrl: originalPost.data.post.imagesOrVideos[next],
                                                          placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                                                          errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                        ),
                                                      ),
                                                      options: CarouselOptions(
                                                        autoPlay: false,
                                                        enlargeCenterPage: true,
                                                        viewportFraction: 0.9,
                                                        aspectRatio: 2.0,
                                                        initialPage: 2,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                          child: CachedNetworkImage(
                                            fit: BoxFit.cover,
                                            imageUrl: originalPost.data.post.imagesOrVideos[index],
                                            placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                                            errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                          ),
                                        ),
                                        staggeredTileBuilder: (int index) => StaggeredTile.count(2, index.isEven ? 1 : 2),
                                        mainAxisSpacing: 4.0,
                                        crossAxisSpacing: 4.0,
                                      ),
                                    );
                                  }
                                }else{
                                  return Container(height: 0,);
                                }
                              }()),
                            )
                            : Container(
                              color: Colors.red,
                              height: 0,
                            ),

                            originalPost.data.post.postTagged.length != 0
                            ? Row(
                              children: [
                                Text('with'),

                                Container(
                                  child: Wrap(
                                    spacing: 5.0,
                                    children: List.generate(
                                      originalPost.data.post.postTagged.length,
                                      (index) => GestureDetector(
                                        onTap: (){
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularUserProfile(userId: originalPost.data.post.postTagged[index].taggedId)));
                                        },
                                        child: RichText(
                                          text: TextSpan(
                                            style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xff000000)),
                                            children: <TextSpan>[
                                              TextSpan(text: originalPost.data.post.postTagged[index].taggedFirstName,),

                                              TextSpan(text: ' '),

                                              TextSpan(text: originalPost.data.post.postTagged[index].taggedLastName,),

                                              index < originalPost.data.post.postTagged.length - 1
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

                                      await apiRegularLikeOrUnlikePost(postId: postId, like: likePost);

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
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularShowCommentsList(postId: postId, numberOfLikes: likesCount, numberOfComments: originalPost.data.post.numberOfComments,)));
                                    },
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
                                        // await FlutterShare.share(
                                        //   title: 'Share',
                                        //   text: 'Share the link',
                                        //   linkUrl: 'http://fbp.dev1.koda.ws/api/v1/posts/$postId',
                                        //   chooserTitle: 'Share link'
                                        // );
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

                      // Flexible(child: Container(color: Colors.transparent,),),
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