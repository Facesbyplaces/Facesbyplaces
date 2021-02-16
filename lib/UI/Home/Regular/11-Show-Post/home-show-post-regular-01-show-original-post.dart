import 'package:facesbyplaces/API/Regular/12-Show-Post/api-show-post-regular-01-show-original-post.dart';
import 'package:facesbyplaces/API/Regular/12-Show-Post/api-show-post-regular-05-post-like-or-unlike.dart';
import 'package:facesbyplaces/UI/Home/BLM/02-View-Memorial/home-view-memorial-blm-01-managed-memorial.dart';
import 'package:facesbyplaces/UI/Home/BLM/02-View-Memorial/home-view-memorial-blm-02-profile-memorial.dart';
import 'package:facesbyplaces/UI/Home/Regular/02-View-Memorial/home-view-memorial-regular-01-managed-memorial.dart';
import 'package:facesbyplaces/UI/Home/Regular/02-View-Memorial/home-view-memorial-regular-02-profile-memorial.dart';
import 'package:facesbyplaces/UI/Home/Regular/12-Show-User/home-show-user-regular-01-user.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-13-regular-dropdown.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:full_screen_menu/full_screen_menu.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'home-show-post-regular-02-show-comments.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
  bool isLoggedIn;
  BranchUniversalObject buo;
  BranchLinkProperties lp;

  void initBranchShare(){
    buo = BranchUniversalObject(
      canonicalIdentifier: 'FacesbyPlaces',
      title: 'FacesbyPlaces Link',
      imageUrl: 'https://i.picsum.photos/id/866/200/300.jpg?hmac=rcadCENKh4rD6MAp6V_ma-AyWv641M4iiOpe1RyFHeI',
      contentDescription: 'FacesbyPlaces link to the app',
      keywords: ['FacesbyPlaces', 'Share', 'Link'],
      publiclyIndex: true,
      locallyIndex: true,
      contentMetadata: BranchContentMetaData()
        ..addCustomMetadata('link-category', 'Post')
        ..addCustomMetadata('link-post-id', postId)
        ..addCustomMetadata('link-like-status', likePost)
        ..addCustomMetadata('link-number-of-likes', likesCount)
        ..addCustomMetadata('link-type-of-account', 'Memorial')
    );

    lp = BranchLinkProperties(
      feature: 'sharing',
      stage: 'new share',
      tags: ['one', 'two', 'three']
    );
    lp.addControlParam('url', 'https://4n5z1.test-app.link/qtdaGGTx3cb?bnc_validate=true');
  }


  void initState(){
    super.initState();
    isLoggedIn = true;
    getUserSession();
    pressedLike = false;
    likePost = likeStatus;
    likesCount = numberOfLikes;
    showOriginalPost = getOriginalPost(postId);
  }

  Future<APIRegularShowOriginalPostMain> getOriginalPost(postId) async{
    return await apiRegularShowOriginalPost(postId: postId);
  }
  
  void getUserSession() async{
    final sharedPrefs = await SharedPreferences.getInstance();
    String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
    String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
    String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

    if(getAccessToken == 'empty' || getUID == 'empty' || getClient == 'empty'){
      isLoggedIn = false;
    }

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
            title: Text('Post', style: TextStyle(fontSize: 16, color: Color(0xffffffff)),),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Color(0xffffffff),), 
              onPressed: (){
                Navigator.pop(context);
              },
            ),
          ),
          body: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Container(
              padding: EdgeInsets.all(5.0),
              height: SizeConfig.screenHeight - kToolbarHeight - 50,
              child: FutureBuilder<APIRegularShowOriginalPostMain>(
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
                                height: 80,
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () async{
                                        if(originalPost.data.almPost.showOriginalPostPage.showOriginalPostPagePageType == 'Memorial'){
                                          if(originalPost.data.almPost.showOriginalPostPage.showOriginalPostPageManage == true || originalPost.data.almPost.showOriginalPostPage.showOriginalPostPageFamOrFriends == true){
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularProfile(memorialId: originalPost.data.almPost.showOriginalPostPage.showOriginalPostPageId, relationship: originalPost.data.almPost.showOriginalPostPage.showOriginalPostPageRelationship, managed: originalPost.data.almPost.showOriginalPostPage.showOriginalPostPageManage)));
                                          }else{
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularMemorialProfile(memorialId: originalPost.data.almPost.showOriginalPostPage.showOriginalPostPageId, pageType: originalPost.data.almPost.showOriginalPostPage.showOriginalPostPagePageType, newJoin: originalPost.data.almPost.showOriginalPostPage.showOriginalPostPageFollower,)));
                                          }
                                        }else{
                                          if(originalPost.data.almPost.showOriginalPostPage.showOriginalPostPageManage == true || originalPost.data.almPost.showOriginalPostPage.showOriginalPostPageFamOrFriends == true){
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMProfile(memorialId: originalPost.data.almPost.showOriginalPostPage.showOriginalPostPageId, relationship: originalPost.data.almPost.showOriginalPostPage.showOriginalPostPageRelationship, managed: originalPost.data.almPost.showOriginalPostPage.showOriginalPostPageManage)));
                                          }else{
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMMemorialProfile(memorialId: originalPost.data.almPost.showOriginalPostPage.showOriginalPostPageId, pageType: originalPost.data.almPost.showOriginalPostPage.showOriginalPostPagePageType, newJoin: originalPost.data.almPost.showOriginalPostPage.showOriginalPostPageFollower,)));
                                          }
                                        }
                                      },
                                      child: CircleAvatar(backgroundColor: Color(0xff888888), backgroundImage: originalPost.data.almPost.showOriginalPostPage.showOriginalPostPageProfileImage != null ? NetworkImage(originalPost.data.almPost.showOriginalPostPage.showOriginalPostPageProfileImage) : AssetImage('assets/icons/app-icon.png')),
                                    ),
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.only(left: 10.0),
                                        child: GestureDetector(
                                          onTap: (){
                                            if(originalPost.data.almPost.showOriginalPostPage.showOriginalPostPagePageType == 'Memorial'){
                                              if(originalPost.data.almPost.showOriginalPostPage.showOriginalPostPageManage == true || originalPost.data.almPost.showOriginalPostPage.showOriginalPostPageFamOrFriends == true){
                                                Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularProfile(memorialId: originalPost.data.almPost.showOriginalPostPage.showOriginalPostPageId, relationship: originalPost.data.almPost.showOriginalPostPage.showOriginalPostPageRelationship, managed: originalPost.data.almPost.showOriginalPostPage.showOriginalPostPageManage)));
                                              }else{
                                                Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularMemorialProfile(memorialId: originalPost.data.almPost.showOriginalPostPage.showOriginalPostPageId, pageType: originalPost.data.almPost.showOriginalPostPage.showOriginalPostPagePageType, newJoin: originalPost.data.almPost.showOriginalPostPage.showOriginalPostPageFollower,)));
                                              }
                                            }else{
                                              if(originalPost.data.almPost.showOriginalPostPage.showOriginalPostPageManage == true || originalPost.data.almPost.showOriginalPostPage.showOriginalPostPageFamOrFriends == true){
                                                Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMProfile(memorialId: originalPost.data.almPost.showOriginalPostPage.showOriginalPostPageId, relationship: originalPost.data.almPost.showOriginalPostPage.showOriginalPostPageRelationship, managed: originalPost.data.almPost.showOriginalPostPage.showOriginalPostPageManage)));
                                              }else{
                                                Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMMemorialProfile(memorialId: originalPost.data.almPost.showOriginalPostPage.showOriginalPostPageId, pageType: originalPost.data.almPost.showOriginalPostPage.showOriginalPostPagePageType, newJoin: originalPost.data.almPost.showOriginalPostPage.showOriginalPostPageFollower,)));
                                              }
                                            }
                                          },
                                          child: Column(
                                            children: [
                                              Expanded(
                                                child: Align(alignment: Alignment.bottomLeft,
                                                  child: Text(originalPost.data.almPost.showOriginalPostPage.showOriginalPostPageName,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold,
                                                      color: Color(0xff000000),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Align(
                                                  alignment: Alignment.topLeft,
                                                  child: Text(timeago.format(DateTime.parse(originalPost.data.almPost.showOriginalPostCreateAt)),
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                      fontSize: 14,
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
                                    ),
                                    MiscRegularDropDownTemplate(postId: postId, likePost: likePost, likesCount: likesCount, reportType: 'Post',),
                                  ],
                                ),
                              ),

                              Container(alignment: Alignment.centerLeft, child: Text(originalPost.data.almPost.showOriginalPostBody),),

                              originalPost.data.almPost.showOriginalPostImagesOrVideos != null
                              ? Container(
                                height: 240,
                                child: ((){
                                  if(originalPost.data.almPost.showOriginalPostImagesOrVideos != null){
                                    if(originalPost.data.almPost.showOriginalPostImagesOrVideos.length == 1){
                                      return Container(
                                        child: CachedNetworkImage(
                                          fit: BoxFit.cover,
                                          imageUrl: originalPost.data.almPost.showOriginalPostImagesOrVideos[0],
                                          placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                                          errorWidget: (context, url, error) => Center(child: Icon(Icons.error),),
                                        ),
                                      );
                                    }else if(originalPost.data.almPost.showOriginalPostImagesOrVideos.length == 2){
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
                                                      height: SizeConfig.screenHeight - 240,
                                                      child: CarouselSlider(
                                                        items: List.generate(
                                                          originalPost.data.almPost.showOriginalPostImagesOrVideos.length, (next) =>
                                                          CachedNetworkImage(
                                                            fit: BoxFit.cover,
                                                            imageUrl: originalPost.data.almPost.showOriginalPostImagesOrVideos[next],
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
                                              imageUrl: originalPost.data.almPost.showOriginalPostImagesOrVideos[index],
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
                                                      height: SizeConfig.screenHeight - 240,
                                                      child: CarouselSlider(
                                                        items: List.generate(
                                                          originalPost.data.almPost.showOriginalPostImagesOrVideos.length, (next) =>
                                                          CachedNetworkImage(
                                                            fit: BoxFit.cover,
                                                            imageUrl: originalPost.data.almPost.showOriginalPostImagesOrVideos[next],
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
                                            child: ((){
                                              if(index != 1){
                                                return CachedNetworkImage(
                                                  fit: BoxFit.cover,
                                                  imageUrl: originalPost.data.almPost.showOriginalPostImagesOrVideos[index],
                                                  placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                                                  errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                );
                                              }else{
                                                return originalPost.data.almPost.showOriginalPostImagesOrVideos.length - 3 == 0
                                                ? CachedNetworkImage(
                                                  fit: BoxFit.cover,
                                                  imageUrl: originalPost.data.almPost.showOriginalPostImagesOrVideos[index],
                                                  placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                                                  errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                )
                                                : Stack(
                                                  children: [
                                                    CachedNetworkImage(
                                                      fit: BoxFit.cover,
                                                      imageUrl: originalPost.data.almPost.showOriginalPostImagesOrVideos[index],
                                                      placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                                                      errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                    ),

                                                    Container(color: Colors.black.withOpacity(0.5),),

                                                    Center(
                                                      child: CircleAvatar(
                                                        radius: 25,
                                                        backgroundColor: Color(0xffffffff).withOpacity(.5),
                                                        child: Text(
                                                          '${originalPost.data.almPost.showOriginalPostImagesOrVideos.length - 3}',
                                                          style: TextStyle(
                                                            fontSize: 40,
                                                            fontWeight: FontWeight.bold,
                                                            color: Color(0xffffffff),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              }
                                            }()),
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
                              : Container(color: Colors.red, height: 0,),

                              originalPost.data.almPost.showOriginalPostPostTagged.length != 0
                              ? Row(
                                children: [
                                  Text('with'),

                                  Container(
                                    child: Wrap(
                                      direction: Axis.vertical,
                                      spacing: 5.0,
                                      children: List.generate(
                                        originalPost.data.almPost.showOriginalPostPostTagged.length,
                                        (index) => GestureDetector(
                                          onTap: (){
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularUserProfile(userId: originalPost.data.almPost.showOriginalPostPostTagged[index].showOriginalPostTaggedId)));
                                          },
                                          child: RichText(
                                            text: TextSpan(
                                              style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xff000000)),
                                              children: <TextSpan>[
                                                TextSpan(text: originalPost.data.almPost.showOriginalPostPostTagged[index].showOriginalPostTaggedFirstName,),

                                                TextSpan(text: ' '),

                                                TextSpan(text: originalPost.data.almPost.showOriginalPostPostTagged[index].showOriginalPostTaggedLastName,),

                                                index < originalPost.data.almPost.showOriginalPostPostTagged.length - 1
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

                              isLoggedIn == true
                              ? Container(
                                height: 80,
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

                                          SizedBox(width: 10,),

                                          Text('$likesCount', style: TextStyle(fontSize: 16, color: Color(0xff000000),),),
                                        ],
                                      ),
                                    ),

                                    SizedBox(width: 20,),

                                    GestureDetector(
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularShowCommentsList(postId: postId, userId: originalPost.data.almPost.showOriginalPostPage.showOriginalPostPageId)));
                                      },
                                      child: Row(
                                        children: [
                                          Image.asset('assets/icons/comment_logo.png', width: 25, height: 25,),

                                          SizedBox(width: 10,),

                                          Text('${originalPost.data.almPost.showOriginalPostNumberOfComments}', style: TextStyle(fontSize: 16, color: Color(0xff000000),),),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () async{
                                          initBranchShare();

                                          FlutterBranchSdk.setIdentity('alm-share-link');

                                          BranchResponse response = await FlutterBranchSdk.showShareSheet(
                                            buo: buo,
                                            linkProperties: lp,
                                            messageText: 'FacesbyPlaces App',
                                            androidMessageTitle: 'FacesbyPlaces - Create a memorial page for loved ones by sharing stories, special events and photos of special occasions. Keeping their memories alive for generations',
                                            androidSharingTitle: 'FacesbyPlaces - Create a memorial page for loved ones by sharing stories, special events and photos of special occasions. Keeping their memories alive for generations'
                                          );

                                          if (response.success) {
                                            print('Link generated: ${response.result}');
                                          } else {
                                            FlutterBranchSdk.logout();
                                            print('Error : ${response.errorCode} - ${response.errorMessage}');
                                          }
                                        },
                                        child: Align(alignment: Alignment.centerRight, child: Image.asset('assets/icons/share_logo.png', width: 50, height: 50,),),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                              : Container(
                                height: 80,
                                child: GestureDetector(
                                  onTap: (){
                                    Navigator.pushReplacementNamed(context, '/regular/login');
                                  },
                                  child: Center(
                                    child: Text('Login or sign up to continue.', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold),),
                                  ),
                                ),
                              ),

                            ],
                          ),
                        ),
                      ],
                    );
                  }else if(originalPost.hasError){
                    return Container(child: Center(child: Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: Color(0xff000000),),),));
                  }else{
                    return Container(child: Center(child: Container(child: SpinKitThreeBounce(color: Color(0xff000000), size: 50.0,), color: Color(0xffffffff),),),);
                  }
                }
              ),
            ),
          ),
        ),
      ),
    );
  }
}