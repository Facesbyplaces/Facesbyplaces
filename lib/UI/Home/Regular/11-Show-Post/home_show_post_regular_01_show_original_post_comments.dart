import 'package:facesbyplaces/API/Regular/02-Main/api_main_regular_02_show_user_information.dart';
import 'package:facesbyplaces/API/Regular/12-Show-Post/api_show_post_regular_01_show_original_post.dart';
import 'package:facesbyplaces/API/Regular/12-Show-Post/api_show_post_regular_02_show_post_comments.dart';
import 'package:facesbyplaces/API/Regular/12-Show-Post/api_show_post_regular_03_show_comment_replies.dart';
import 'package:facesbyplaces/API/Regular/12-Show-Post/api_show_post_regular_04_show_comment_or_reply_like_status.dart';
import 'package:facesbyplaces/API/Regular/12-Show-Post/api_show_post_regular_06_add_comment.dart';
import 'package:facesbyplaces/API/Regular/12-Show-Post/api_show_post_regular_07_add_reply.dart';
import 'package:facesbyplaces/API/Regular/12-Show-Post/api_show_post_regular_09_delete_comment.dart';
import 'package:facesbyplaces/API/Regular/12-Show-Post/api_show_post_regular_10_edit_comment.dart';
import 'package:facesbyplaces/API/Regular/12-Show-Post/api_show_post_regular_11_delete_reply.dart';
import 'package:facesbyplaces/API/Regular/12-Show-Post/api_show_post_regular_12_edit_reply.dart';
import 'package:facesbyplaces/UI/Home/BLM/02-View-Memorial/home_view_memorial_blm_01_managed_memorial.dart';
import 'package:facesbyplaces/UI/Home/BLM/02-View-Memorial/home_view_memorial_blm_02_profile_memorial.dart';
import 'package:facesbyplaces/UI/Home/Regular/02-View-Memorial/home_view_memorial_regular_01_managed_memorial.dart';
import 'package:facesbyplaces/UI/Home/Regular/02-View-Memorial/home_view_memorial_regular_02_profile_memorial.dart';
import 'package:facesbyplaces/UI/Home/Regular/02-View-Memorial/home_view_memorial_regular_04_maps.dart';
import 'package:facesbyplaces/UI/Home/Regular/06-Report/home_report_regular_01_report.dart';
import 'package:facesbyplaces/UI/Home/Regular/12-Show-User/home_show_user_regular_01_user.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc_03_regular_dropdown.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:keyboard_attachable/keyboard_attachable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:extended_image/extended_image.dart';
import 'package:better_player/better_player.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:dialog/dialog.dart';
import 'package:loader/loader.dart';
import 'package:mime/mime.dart';
import 'package:misc/misc.dart';
import 'dart:ui';

class HomeRegularShowOriginalPostComments extends StatefulWidget{
  final int postId;
  const HomeRegularShowOriginalPostComments({Key? key, required this.postId}) : super(key: key);

  @override
  HomeRegularShowOriginalPostCommentsState createState() => HomeRegularShowOriginalPostCommentsState();
}

class HomeRegularShowOriginalPostCommentsState extends State<HomeRegularShowOriginalPostComments>{
  Future<List<APIRegularShowListOfCommentsExtended>>? showListOfComments;
  Future<List<APIRegularShowListOfRepliesExtended>>? showListOfReplies;
  CarouselController buttonCarouselController = CarouselController();
  TextEditingController controller = TextEditingController(text: '');
  ValueNotifier<String> currentUserImage = ValueNotifier<String>('');
  ValueNotifier<bool> isGuestLoggedIn = ValueNotifier<bool>(true);
  ValueNotifier<bool> isRefreshed = ValueNotifier<bool>(false);
  ValueNotifier<bool> filter = ValueNotifier<bool>(false);
  Future<APIRegularShowOriginalPostMain>? showOriginalPost;
  ScrollController scrollController = ScrollController();
  String pageName = '';
  int currentAccountType = 1;
  int numberOfComments = 0;
  int commentsRemaining = 1;
  int repliesRemaining = 1;
  int numberOfLikes = 0;
  bool likePost = false;
  int currentUserId = 0;
  int page1 = 1;
  int page2 = 1;
  bool loaded = false;
  int lengthOfComments = 0;
  bool updatedCommentsData = false;

  @override
  void initState(){
    super.initState();
    isGuest();
  }

  void isGuest() async{
    final sharedPrefs = await SharedPreferences.getInstance();
    bool regularSession = sharedPrefs.getBool('regular-user-session') ?? false;
    bool blmSession = sharedPrefs.getBool('blm-user-session') ?? false;

    if(regularSession == true || blmSession == true){
      isGuestLoggedIn.value = false;
    }

    showOriginalPost = getOriginalPost(widget.postId);
    showListOfComments = getListOfComments(page: page1);
    isRefreshed.value = true;
    getOriginalPostInformation();
    if(isGuestLoggedIn.value != true){
      getProfilePicture();
    }
    isRefreshed.value = false;

    scrollController.addListener((){
      if(scrollController.position.pixels == scrollController.position.maxScrollExtent){
        if(loaded){
          showListOfComments = getListOfComments(page: page1);

          if(updatedCommentsData){
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('New comments available. Reload to view.'), 
                duration: const Duration(seconds: 3), backgroundColor: const Color(0xff4EC9D4),
                action: SnackBarAction(
                  label: 'Reload',
                  onPressed: (){
                    onRefresh();
                  },
                  textColor: Colors.blue,
                ),
              ),
            );
          }else{
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No more comments to show.'), duration: Duration(seconds: 1), backgroundColor: Color(0xff4EC9D4),),);
          }
        }
      }
    });
  }

  Future<void> onRefresh() async{
    page1 = 1;
    page2 = 1;
    loaded = false;
    updatedCommentsData = false;
    lengthOfComments = 0;

    isRefreshed.value = true;
    getOriginalPostInformation();
    isRefreshed.value = false;
    commentsRemaining = 1;
    repliesRemaining = 1;
    showListOfComments = getListOfComments(page: page1);
  }

  void getOriginalPostInformation() async{
    var originalPostInformation = await apiRegularShowOriginalPost(postId: widget.postId);
    numberOfLikes = originalPostInformation.almPost.showOriginalPostNumberOfLikes;
    numberOfComments = originalPostInformation.almPost.showOriginalPostNumberOfComments;
    likePost = originalPostInformation.almPost.showOriginalPostLikeStatus;
    pageName = originalPostInformation.almPost.showOriginalPostPage.showOriginalPostPageName;
  }

  void getProfilePicture() async{
    var getProfilePicture = await apiRegularShowProfileInformation();
    currentUserImage.value = getProfilePicture.showProfileInformationImage;
    currentUserId = getProfilePicture.showProfileInformationUserId;
    currentAccountType = getProfilePicture.showProfileInformationAccountType;
  }

  Future<APIRegularShowOriginalPostMain> getOriginalPost(postId) async{
    return await apiRegularShowOriginalPost(postId: postId);
  }

  Future<List<APIRegularShowListOfCommentsExtended>> getListOfComments({required int page}) async{
    APIRegularShowListOfComments? newValue;
    List<APIRegularShowListOfCommentsExtended>? listOfComments = [];

    do{
      newValue = await apiRegularShowListOfComments(postId: widget.postId, page: page);
      listOfComments.addAll(newValue.almCommentsList);

      if(newValue.almItemsRemaining != 0){
        page++;
      }else if(lengthOfComments > 0 && listOfComments.length > lengthOfComments){
        updatedCommentsData = true;
      }
    }while(newValue.almItemsRemaining != 0);

    lengthOfComments = listOfComments.length;
    page1 = page;
    loaded = true;

    return listOfComments;
  }

  Future<List<APIRegularShowListOfRepliesExtended>> getListOfReplies({required int commentId, required int page}) async{
    APIRegularShowListOfReplies? newValue;
    List<APIRegularShowListOfRepliesExtended>? listOfReplies = [];

    do{
      newValue = await apiRegularShowListOfReplies(postId: commentId, page: page);
      listOfReplies.addAll(newValue.almRepliesList);

      if(newValue.almItemsRemaining != 0){
        page++;
      }
    }while(newValue.almItemsRemaining != 0);

    page2 = page;

    return listOfReplies;
  }

  Future<APIRegularShowCommentOrReplyLikeStatus> getCommentOrReplyStatus({required String commentableType, required int commentableId}) async{
    return await apiRegularShowCommentOrReplyLikeStatus(commentableType: commentableType, commentableId: commentableId);
  }

  @override
  Widget build(BuildContext context){
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
        child: ValueListenableBuilder(
          valueListenable: isGuestLoggedIn,
          builder: (_, bool isGuestLoggedInListener, __) => ValueListenableBuilder(
            valueListenable: isRefreshed,
            builder: (_, bool isRefreshedListener, __) => ValueListenableBuilder(
              valueListenable: currentUserImage,
              builder: (_, String currentUserImageListener, __) => ValueListenableBuilder(
                valueListenable: filter,
                builder: (_, bool filterListener, __) => Scaffold(
                  appBar: AppBar(
                    backgroundColor: const Color(0xff04ECFF),
                    title: const Text('Post', style: TextStyle(fontSize: 26, fontFamily: 'NexaRegular', color: Color(0xffffffff),),),
                    centerTitle: false,
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Color(0xffffffff), size: 35),
                      onPressed: (){
                        Navigator.pop(context, numberOfComments);
                      },
                    ),
                    actions: [
                      MiscRegularDropDownTemplate(postId: widget.postId, likePost: likePost, likesCount: numberOfLikes, reportType: 'Post', pageType: 'Alm', pageName: pageName),
                    ],
                  ),
                  floatingActionButton: updatedCommentsData
                  ? MaterialButton(
                    onPressed: (){
                      updatedCommentsData = false;
                      onRefresh();
                    },
                    child: const Text('Refresh'),
                    color: Colors.red,
                  )
                  : const SizedBox(height: 0,),
                  floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
                  backgroundColor: const Color(0xffffffff),
                  body: Stack(
                    children: [
                      SafeArea(
                        child: FooterLayout(
                          footer: showKeyboard(),
                          child: RefreshIndicator(
                            onRefresh: onRefresh,
                            child: FutureBuilder<APIRegularShowOriginalPostMain>(
                              future: showOriginalPost,
                              builder: (context, originalPost){
                                if(originalPost.connectionState != ConnectionState.done){
                                  return const Center(child: CustomLoaderThreeDots(),);
                                }
                                else if(originalPost.hasError){
                                  return const MiscErrorMessageTemplate();
                                }
                                else if(originalPost.hasData){
                                  return CustomScrollView(
                                    physics: const ClampingScrollPhysics(),
                                    controller: scrollController,
                                    slivers: <Widget>[
                                      SliverToBoxAdapter(
                                        child: InkWell(
                                          onTap: (){
                                            filter.value = true;
                                          },
                                          child: IgnorePointer(
                                            ignoring: isGuestLoggedInListener,
                                            child: Column(
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                                                  height: 80,
                                                  child: Row(
                                                    children: [
                                                      GestureDetector(
                                                        child: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageProfileImage != ''
                                                        ? CircleAvatar(
                                                          backgroundColor: const Color(0xff888888),
                                                          foregroundImage: NetworkImage(originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageProfileImage),
                                                        )
                                                        : const CircleAvatar(
                                                          backgroundColor: Color(0xff888888),
                                                          foregroundImage: AssetImage('assets/icons/app-icon.png'),
                                                        ),
                                                        onTap: () async{
                                                          if(originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPagePageType == 'Memorial'){
                                                            if(originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageManage == true || originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageFamOrFriends == true){
                                                              Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularProfile(memorialId: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageId, relationship: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageRelationship, managed: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageManage, newlyCreated: false,),),);
                                                            }else{
                                                              Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularMemorialProfile(memorialId: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageId, pageType: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPagePageType, newJoin: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageFollower,),),);
                                                            }
                                                          }else{
                                                            if(originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageManage == true || originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageFamOrFriends == true){
                                                              Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMProfile(memorialId: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageId, relationship: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageRelationship, managed: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageManage,newlyCreated: false,),),);
                                                            }else{
                                                              Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMMemorialProfile(memorialId: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageId, pageType: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPagePageType, newJoin: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageFollower,),),);
                                                            }
                                                          }
                                                        },
                                                      ),

                                                      Expanded(
                                                        child: Padding(
                                                          padding: const EdgeInsets.only(left: 10.0),
                                                          child: GestureDetector(
                                                            child: Column(
                                                              children: [
                                                                Expanded(
                                                                  child: Align(
                                                                    alignment: Alignment.bottomLeft,
                                                                    child: Text(originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageName,
                                                                      overflow: TextOverflow.ellipsis,
                                                                      style: const TextStyle(fontSize: 22, fontFamily: 'NexaBold', color: Color(0xff000000),),
                                                                    ),
                                                                  ),
                                                                ),

                                                                Expanded(
                                                                  child: Align(
                                                                    alignment: Alignment.topLeft,
                                                                    child: Text(timeago.format(DateTime.parse(originalPost.data!.almPost.showOriginalPostCreatedAt),),
                                                                      maxLines: 1,
                                                                      style: const TextStyle(fontSize: 18, fontFamily: 'NexaBold', color: Color(0xffBDC3C7),),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            onTap: () async{
                                                              if(originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPagePageType == 'Memorial'){
                                                                if(originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageManage == true || originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageFamOrFriends == true){
                                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularProfile(memorialId: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageId, relationship: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageRelationship, managed: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageManage, newlyCreated: false,),),);
                                                                }else{
                                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularMemorialProfile(memorialId: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageId, pageType: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPagePageType, newJoin: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageFollower,),),);
                                                                }
                                                              }else{
                                                                if(originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageManage == true || originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageFamOrFriends == true){
                                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMProfile(memorialId: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageId, relationship: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageRelationship, managed: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageManage, newlyCreated: false,),),);
                                                                }else{
                                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMMemorialProfile(memorialId: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageId, pageType: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPagePageType, newJoin: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageFollower,),));
                                                                }
                                                              }
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),

                                                Container(
                                                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                                                  alignment: Alignment.centerLeft,
                                                  child: Text(originalPost.data!.almPost.showOriginalPostBody, style: const TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xff000000),),),
                                                ),

                                                originalPost.data!.almPost.showOriginalPostImagesOrVideos.isNotEmpty
                                                ? Column(
                                                  children: [
                                                    const SizedBox(height: 20),

                                                    SizedBox(
                                                      child: ((){
                                                        if(originalPost.data!.almPost.showOriginalPostImagesOrVideos.length == 1){
                                                          return GestureDetector(
                                                            onTap: (){
                                                              showGeneralDialog(
                                                                context: context,
                                                                transitionDuration: const Duration(milliseconds: 0),
                                                                barrierDismissible: true,
                                                                barrierLabel: 'Dialog',
                                                                pageBuilder: (_, __, ___){
                                                                  return Scaffold(
                                                                    backgroundColor: Colors.black12.withOpacity(0.7),
                                                                    body: SizedBox.expand(
                                                                      child: SafeArea(
                                                                        child: Column(
                                                                          children: [
                                                                            Container(
                                                                              alignment: Alignment.centerRight,
                                                                              padding: const EdgeInsets.only(right: 20.0),
                                                                              child: GestureDetector(
                                                                                child: CircleAvatar(radius: 20, backgroundColor: const Color(0xff000000).withOpacity(0.8), child: const Icon(Icons.close_rounded, color: Color(0xffffffff),),),
                                                                                onTap: (){
                                                                                  Navigator.pop(context);
                                                                                },
                                                                              ),
                                                                            ),

                                                                            const SizedBox(height: 10,),

                                                                            Expanded(
                                                                              child: ((){
                                                                                if(lookupMimeType(originalPost.data!.almPost.showOriginalPostImagesOrVideos[0])?.contains('video') == true){
                                                                                  return BetterPlayer.network('${originalPost.data!.almPost.showOriginalPostImagesOrVideos[0]}',
                                                                                    betterPlayerConfiguration: BetterPlayerConfiguration(
                                                                                      placeholder: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 16 / 9),
                                                                                      placeholderOnTop: false,
                                                                                      deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
                                                                                      aspectRatio: 16 / 9,
                                                                                      fit: BoxFit.contain,
                                                                                    ),
                                                                                  );
                                                                                }else{
                                                                                  return ExtendedImage.network(
                                                                                    originalPost.data!.almPost.showOriginalPostImagesOrVideos[0],
                                                                                    fit: BoxFit.contain,
                                                                                    loadStateChanged: (ExtendedImageState loading){
                                                                                      if(loading.extendedImageLoadState == LoadState.loading || loading.extendedImageLoadState == LoadState.failed){
                                                                                        return Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,);
                                                                                      }
                                                                                    },
                                                                                    mode: ExtendedImageMode.gesture,
                                                                                  );
                                                                                }
                                                                              }()),
                                                                            ),

                                                                            const SizedBox(height: 85,),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  );
                                                                },
                                                              );
                                                            },
                                                            child: ((){
                                                              if(lookupMimeType(originalPost.data!.almPost.showOriginalPostImagesOrVideos[0])?.contains('video') == true){
                                                                return BetterPlayer.network('${originalPost.data!.almPost.showOriginalPostImagesOrVideos[0]}',
                                                                  betterPlayerConfiguration: BetterPlayerConfiguration(
                                                                    placeholder: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 16 / 9),
                                                                    aspectRatio: 16 / 9,
                                                                    fit: BoxFit.contain,
                                                                    controlsConfiguration: const BetterPlayerControlsConfiguration(showControls: false,),
                                                                  ),
                                                                );
                                                              }else{
                                                                return CachedNetworkImage(
                                                                  fit: BoxFit.cover,
                                                                  imageUrl: originalPost.data!.almPost.showOriginalPostImagesOrVideos[0],
                                                                  placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                                  errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                                );
                                                              }
                                                            }()),
                                                          );
                                                        }else if(originalPost.data!.almPost.showOriginalPostImagesOrVideos.length == 2){
                                                          return StaggeredGridView.countBuilder(
                                                            staggeredTileBuilder: (int index) => const StaggeredTile.count(2, 2),
                                                            physics: const NeverScrollableScrollPhysics(),
                                                            padding: EdgeInsets.zero,
                                                            crossAxisSpacing: 4.0,
                                                            mainAxisSpacing: 4.0,
                                                            crossAxisCount: 4,
                                                            shrinkWrap: true,
                                                            itemCount: 2,
                                                            itemBuilder: (BuildContext context, int index) => GestureDetector(
                                                              child: ((){
                                                                if(lookupMimeType(originalPost.data!.almPost.showOriginalPostImagesOrVideos[index])?.contains('video') == true){
                                                                  return BetterPlayer.network('${originalPost.data!.almPost.showOriginalPostImagesOrVideos[index]}',
                                                                    betterPlayerConfiguration: BetterPlayerConfiguration(
                                                                      placeholder: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 16 / 9),
                                                                      controlsConfiguration: const BetterPlayerControlsConfiguration(showControls: false,),
                                                                      aspectRatio: 16 / 9,
                                                                      fit: BoxFit.contain,
                                                                    ),
                                                                  );
                                                                }else{
                                                                  return CachedNetworkImage(
                                                                    fit: BoxFit.cover,
                                                                    imageUrl: originalPost.data!.almPost.showOriginalPostImagesOrVideos[index],
                                                                    placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                                    errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                                  );
                                                                }
                                                              }()),
                                                              onTap: (){
                                                                showGeneralDialog(
                                                                  context: context,
                                                                  transitionDuration: const Duration(milliseconds: 0),
                                                                  barrierDismissible: true,
                                                                  barrierLabel: 'Dialog',
                                                                  pageBuilder: (_, __, ___){
                                                                    return Scaffold(
                                                                      backgroundColor: Colors.black12.withOpacity(0.7),
                                                                      body: SizedBox.expand(
                                                                        child: SafeArea(
                                                                          child: Column(
                                                                            children: [
                                                                              Container(
                                                                                alignment: Alignment.centerRight,
                                                                                padding: const EdgeInsets.only(right: 20.0),
                                                                                child: GestureDetector(
                                                                                  child: CircleAvatar(radius: 20, backgroundColor: const Color(0xff000000).withOpacity(0.8), child: const Icon(Icons.close_rounded, color: Color(0xffffffff),),),
                                                                                  onTap: (){
                                                                                    Navigator.pop(context);
                                                                                  },
                                                                                ),
                                                                              ),

                                                                              const SizedBox(height: 10,),

                                                                              Expanded(
                                                                                child: CarouselSlider(
                                                                                  carouselController: buttonCarouselController,
                                                                                  items: List.generate(
                                                                                    originalPost.data!.almPost.showOriginalPostImagesOrVideos.length, (next) => ((){
                                                                                      if(lookupMimeType(originalPost.data!.almPost.showOriginalPostImagesOrVideos[next])?.contains('video') == true){
                                                                                        return BetterPlayer.network('${originalPost.data!.almPost.showOriginalPostImagesOrVideos[index]}',
                                                                                          betterPlayerConfiguration: BetterPlayerConfiguration(
                                                                                            placeholder: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 16 / 9),
                                                                                            deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
                                                                                            autoDispose: false,
                                                                                            aspectRatio: 16 / 9,
                                                                                            fit: BoxFit.contain,
                                                                                          ),
                                                                                        );
                                                                                      }else{
                                                                                        return ExtendedImage.network(
                                                                                          originalPost.data!.almPost.showOriginalPostImagesOrVideos[next],
                                                                                          fit: BoxFit.contain,
                                                                                          loadStateChanged: (ExtendedImageState loading){
                                                                                            if(loading.extendedImageLoadState == LoadState.loading || loading.extendedImageLoadState == LoadState.failed){
                                                                                              return Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,);
                                                                                            }
                                                                                          },
                                                                                          mode: ExtendedImageMode.gesture,
                                                                                        );
                                                                                      }
                                                                                    }()),
                                                                                  ),
                                                                                  options: CarouselOptions(
                                                                                    autoPlay: false,
                                                                                    enlargeCenterPage: true,
                                                                                    aspectRatio: 1,
                                                                                    viewportFraction: 1,
                                                                                    initialPage: index,
                                                                                  ),
                                                                                ),
                                                                              ),

                                                                              Row(
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                children: [
                                                                                  IconButton(
                                                                                    onPressed: () => buttonCarouselController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.linear),
                                                                                    icon: const Icon(Icons.arrow_back_rounded, color: Color(0xffffffff),),
                                                                                  ),
                                                                                  IconButton(
                                                                                    onPressed: () => buttonCarouselController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.linear),
                                                                                    icon: const Icon(Icons.arrow_forward_rounded, color: Color(0xffffffff),),
                                                                                  ),
                                                                                ],
                                                                              ),

                                                                              const SizedBox(height: 85,),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    );
                                                                  },
                                                                );
                                                              },
                                                            ),
                                                          );
                                                        }else{
                                                          return StaggeredGridView.countBuilder(
                                                            staggeredTileBuilder: (int index) => StaggeredTile.count(2, index.isEven ? 1 : 2),
                                                            physics: const NeverScrollableScrollPhysics(),
                                                            padding: EdgeInsets.zero,
                                                            crossAxisSpacing: 4.0,
                                                            mainAxisSpacing: 4.0,
                                                            crossAxisCount: 4,
                                                            shrinkWrap: true,
                                                            itemCount: 3,
                                                            itemBuilder: (BuildContext context, int index) => GestureDetector(
                                                              child: ((){
                                                                if(index != 1){
                                                                  return lookupMimeType(originalPost.data!.almPost.showOriginalPostImagesOrVideos[index])?.contains('video') == true 
                                                                  ? BetterPlayer.network('${originalPost.data!.almPost.showOriginalPostImagesOrVideos[index]}',
                                                                    betterPlayerConfiguration: BetterPlayerConfiguration(
                                                                      placeholder: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 16 / 9),
                                                                      controlsConfiguration: const BetterPlayerControlsConfiguration(showControls: false,),
                                                                      aspectRatio: 16 / 9,
                                                                      fit: BoxFit.contain,
                                                                    ),
                                                                  )
                                                                  : CachedNetworkImage(
                                                                    fit: BoxFit.cover,
                                                                    imageUrl: originalPost.data!.almPost.showOriginalPostImagesOrVideos[index],
                                                                    placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                                    errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                                  );
                                                                }else{
                                                                  return ((){
                                                                    if(originalPost.data!.almPost.showOriginalPostImagesOrVideos.length - 3 > 0){
                                                                      if(lookupMimeType(originalPost.data!.almPost.showOriginalPostImagesOrVideos[index])?.contains('video') == true){
                                                                        return Stack(
                                                                          fit: StackFit.expand,
                                                                          children: [
                                                                            BetterPlayer.network('${originalPost.data!.almPost.showOriginalPostImagesOrVideos[index]}',
                                                                              betterPlayerConfiguration: BetterPlayerConfiguration(
                                                                                placeholder: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 16 / 9),
                                                                                controlsConfiguration: const BetterPlayerControlsConfiguration(showControls: false,),
                                                                                aspectRatio: 16 / 9,
                                                                                fit: BoxFit.contain,
                                                                              ),
                                                                            ),

                                                                            Container(color: const Color(0xff000000).withOpacity(0.5),),

                                                                            Center(
                                                                              child: CircleAvatar(
                                                                                radius: 25,
                                                                                backgroundColor: const Color(0xffffffff).withOpacity(.5),
                                                                                child: Text('${originalPost.data!.almPost.showOriginalPostImagesOrVideos.length - 3}', style: const TextStyle(fontSize: 32, fontFamily: 'NexaBold', color: Color(0xffFFFFFF),),),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        );
                                                                      }else{
                                                                        return Stack(
                                                                          fit: StackFit.expand,
                                                                          children: [
                                                                            CachedNetworkImage(
                                                                              fit: BoxFit.cover,
                                                                              imageUrl: originalPost.data!.almPost.showOriginalPostImagesOrVideos[index],
                                                                              placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                                              errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                                            ),

                                                                            Container(color: const Color(0xff000000).withOpacity(0.5),),

                                                                            Center(
                                                                              child: CircleAvatar(
                                                                                radius: 25,
                                                                                backgroundColor: const Color(0xffffffff).withOpacity(.5),
                                                                                child: Text('${originalPost.data!.almPost.showOriginalPostImagesOrVideos.length - 3}', style: const TextStyle(fontSize: 32, fontFamily: 'NexaBold', color: Color(0xffFFFFFF),),),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        );
                                                                      }
                                                                    }else{
                                                                      if(lookupMimeType(originalPost.data!.almPost.showOriginalPostImagesOrVideos[index])?.contains('video') == true){
                                                                        return BetterPlayer.network('${originalPost.data!.almPost.showOriginalPostImagesOrVideos[index]}',
                                                                          betterPlayerConfiguration: BetterPlayerConfiguration(
                                                                            placeholder: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.contain, scale: 16 / 9),
                                                                            controlsConfiguration: const BetterPlayerControlsConfiguration(showControls: false,),
                                                                            aspectRatio: 16 / 9,
                                                                            fit: BoxFit.contain,
                                                                          ),
                                                                        );
                                                                      }else{
                                                                        return CachedNetworkImage(
                                                                          fit: BoxFit.cover,
                                                                          imageUrl: originalPost.data!.almPost.showOriginalPostImagesOrVideos[index],
                                                                          placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                                          errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                                        );
                                                                      }
                                                                    }
                                                                  }());
                                                                }
                                                              }()),
                                                              onTap: (){
                                                                showGeneralDialog(
                                                                  context: context,
                                                                  transitionDuration: const Duration(milliseconds: 0),
                                                                  barrierDismissible: true,
                                                                  barrierLabel: 'Dialog',
                                                                  pageBuilder: (_, __, ___){
                                                                    return Scaffold(
                                                                      backgroundColor: Colors.black12.withOpacity(0.7),
                                                                      body: SizedBox.expand(
                                                                        child: SafeArea(
                                                                          child: Column(
                                                                            children: [
                                                                              Container(
                                                                                alignment: Alignment.centerRight,
                                                                                padding: const EdgeInsets.only(right: 20.0),
                                                                                child: GestureDetector(
                                                                                  child: CircleAvatar(radius: 20, backgroundColor: const Color(0xff000000).withOpacity(0.8), child: const Icon(Icons.close_rounded, color: Color(0xffffffff),),),
                                                                                  onTap: (){
                                                                                    Navigator.pop(context);
                                                                                  },
                                                                                ),
                                                                              ),
                                                                              
                                                                              const SizedBox(height: 10,),

                                                                              Expanded(
                                                                                child: CarouselSlider(
                                                                                  carouselController: buttonCarouselController,
                                                                                  items: List.generate(
                                                                                    originalPost.data!.almPost.showOriginalPostImagesOrVideos.length, (next) => ((){
                                                                                      if(lookupMimeType(originalPost.data!.almPost.showOriginalPostImagesOrVideos[next])?.contains('video') == true){
                                                                                        return BetterPlayer.network('${originalPost.data!.almPost.showOriginalPostImagesOrVideos[next]}',
                                                                                          betterPlayerConfiguration: BetterPlayerConfiguration(
                                                                                            placeholder: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 16 / 9),
                                                                                            deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
                                                                                            autoDispose: false,
                                                                                            aspectRatio: 16 / 9,
                                                                                            fit: BoxFit.contain,
                                                                                          ),
                                                                                        );
                                                                                      }else{
                                                                                        return ExtendedImage.network(
                                                                                          originalPost.data!.almPost.showOriginalPostImagesOrVideos[next],
                                                                                          fit: BoxFit.contain,
                                                                                          loadStateChanged: (ExtendedImageState loading){
                                                                                            if(loading.extendedImageLoadState == LoadState.loading || loading.extendedImageLoadState == LoadState.failed){
                                                                                              return Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,);
                                                                                            }
                                                                                          },
                                                                                          mode: ExtendedImageMode.gesture,
                                                                                        );
                                                                                      }
                                                                                    }()),
                                                                                  ),
                                                                                  options: CarouselOptions(
                                                                                    autoPlay: false,
                                                                                    enlargeCenterPage: true,
                                                                                    aspectRatio: 1,
                                                                                    viewportFraction: 1,
                                                                                    initialPage: index,
                                                                                  ),
                                                                                ),
                                                                              ),

                                                                              Row(
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                children: [
                                                                                  IconButton(
                                                                                    onPressed: () => buttonCarouselController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.linear),
                                                                                    icon: const Icon(Icons.arrow_back_rounded, color: Color(0xffffffff),),
                                                                                  ),
                                                                                  IconButton(
                                                                                    onPressed: () => buttonCarouselController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.linear),
                                                                                    icon: const Icon(Icons.arrow_forward_rounded, color: Color(0xffffffff),),
                                                                                  ),
                                                                                ],
                                                                              ),

                                                                              const SizedBox(height: 85,),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    );
                                                                  },
                                                                );
                                                              },
                                                            ),
                                                          );
                                                        }
                                                      }()),
                                                    ),

                                                    const SizedBox(height: 20),
                                                  ],
                                                )
                                                : Container(color: const Color(0xffff0000), height: 0,),

                                                originalPost.data!.almPost.showOriginalPostPostTagged.isNotEmpty
                                                ? Column(
                                                  children: [
                                                    const SizedBox(height: 10),

                                                    Container(
                                                      alignment: Alignment.centerLeft,
                                                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                                                      child: RichText(
                                                        text: TextSpan(
                                                          children: [
                                                            const TextSpan(style: TextStyle(fontSize: 16, fontFamily: 'NexaRegular', color: Color(0xff888888)), text: 'with '),

                                                            TextSpan(
                                                              children: List.generate(
                                                                originalPost.data!.almPost.showOriginalPostPostTagged.length, (index) => TextSpan(
                                                                  style: const TextStyle(fontSize: 18, fontFamily: 'NexaBold', color: Color(0xff000000),),
                                                                  children: <TextSpan>[
                                                                    TextSpan(text: originalPost.data!.almPost.showOriginalPostPostTagged[index].showOriginalPostTaggedFirstName + ' ' + originalPost.data!.almPost.showOriginalPostPostTagged[index].showOriginalPostTaggedLastName,
                                                                    recognizer: TapGestureRecognizer()
                                                                      ..onTap = (){
                                                                        Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularUserProfile(userId: originalPost.data!.almPost.showOriginalPostPostTagged[index].showOriginalPostTaggedId, accountType: originalPost.data!.almPost.showOriginalPostPostTagged[index].showOriginalPostAccountType)));
                                                                      },
                                                                    ),
                                                                    index < originalPost.data!.almPost.showOriginalPostPostTagged.length - 1 ? const TextSpan(text: ', ') : const TextSpan(text: ''),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                                : const SizedBox(height: 0,),

                                                originalPost.data!.almPost.showOriginalPostLocation != ''
                                                ? Column(
                                                  children: [
                                                    const SizedBox(height: 10,),

                                                    Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                                      child: Row(
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          const Icon(Icons.place, color: Color(0xff888888)),

                                                          Expanded(
                                                            child: GestureDetector(
                                                              child: Text(originalPost.data!.almPost.showOriginalPostLocation, style: const TextStyle(fontSize: 18, fontFamily: 'NexaBold', color: Color(0xff000000),),),
                                                              onTap: (){
                                                                Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularMaps(latitude: originalPost.data!.almPost.showOriginalPostLatitude, longitude: originalPost.data!.almPost.showOriginalPostLongitude, isMemorial: false, memorialName: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageName, memorialImage: originalPost.data!.almPost.showOriginalPostPage.showOriginalPostPageProfileImage,)));
                                                              },
                                                            ),  
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                )
                                                : const SizedBox(height: 0,),

                                                Container(
                                                  height: 40,
                                                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          likePost == true
                                                          ? const FaIcon(FontAwesomeIcons.heart, color: Color(0xffE74C3C),)
                                                          : const FaIcon(FontAwesomeIcons.heart, color: Color(0xff000000),),

                                                          const SizedBox(width: 10,),

                                                          Text('${originalPost.data!.almPost.showOriginalPostNumberOfLikes}', style: const TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xffBDC3C7),),),
                                                        ],
                                                      ),

                                                      const SizedBox(width: 40,),

                                                      Row(
                                                        children: [
                                                          const FaIcon(FontAwesomeIcons.comment, color: Color(0xff000000),),

                                                          const SizedBox(width: 10,),

                                                          Text('${originalPost.data!.almPost.showOriginalPostNumberOfComments}', style: const TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xffBDC3C7),),),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),

                                      SliverToBoxAdapter( // COMMENTS AND REPLIES
                                        child: InkWell(
                                          onTap: (){
                                            filter.value = true;
                                          },
                                          child: IgnorePointer(
                                            ignoring: isGuestLoggedInListener,
                                            child: FutureBuilder<List<APIRegularShowListOfCommentsExtended>>(
                                              future: showListOfComments,
                                              builder: (context, listOfComments){
                                                if(listOfComments.connectionState != ConnectionState.done){
                                                  return const Center(child: CustomLoaderThreeDots());
                                                }
                                                else if(listOfComments.hasData){
                                                  return Column(
                                                    children: List.generate(listOfComments.data!.length, (i) => ListTile(
                                                      visualDensity: const VisualDensity(vertical: 4.0),
                                                      leading: listOfComments.data![i].showListOfCommentsUser.showListOfCommentsUserImage != ''
                                                      ? CircleAvatar(
                                                        backgroundColor: const Color(0xff888888),
                                                        foregroundImage: NetworkImage(listOfComments.data![i].showListOfCommentsUser.showListOfCommentsUserImage),
                                                      )
                                                      : const CircleAvatar(
                                                        backgroundColor: Color(0xff888888),
                                                        foregroundImage: AssetImage('assets/icons/user-placeholder.png'),
                                                      ),
                                                      title: Row(
                                                        children: [
                                                          Expanded(
                                                            child: currentUserId == listOfComments.data![i].showListOfCommentsUser.showListOfCommentsUserId && currentAccountType == listOfComments.data![i].showListOfCommentsUser.showListOfCommentsUserAccountType
                                                            ? const Text('You', style: TextStyle(fontSize: 20, fontFamily: 'NexaBold', color: Color(0xff000000),),)
                                                            : Text('${listOfComments.data![i].showListOfCommentsUser.showListOfCommentsUserFirstName} ${listOfComments.data![i].showListOfCommentsUser.showListOfCommentsUserLastName}', style: const TextStyle(fontSize: 20, fontFamily: 'NexaBold', color: Color(0xff000000),),),
                                                          ),

                                                          Expanded(
                                                            child: Align(
                                                              alignment: Alignment.centerRight,
                                                              child: FutureBuilder<APIRegularShowCommentOrReplyLikeStatus>(
                                                                future: getCommentOrReplyStatus(commentableType: 'Comment', commentableId: listOfComments.data![i].showListOfCommentsCommentId),
                                                                builder: (context, commentStatus){
                                                                  if(commentStatus.connectionState != ConnectionState.done){
                                                                    return const SizedBox(height: 0,);
                                                                  }else if(commentStatus.hasError){
                                                                    return const SizedBox(height: 0,);
                                                                  }
                                                                  else if(commentStatus.hasData){
                                                                    return MiscLikeButtonTemplate(likeStatus: commentStatus.data!.showCommentOrReplyLikeStatus, numberOfLikes: commentStatus.data!.showCommentOrReplyNumberOfLikes, commentableType: 'Comment', commentableId: listOfComments.data![i].showListOfCommentsCommentId, postType: 2);
                                                                  }else{
                                                                    return const SizedBox(height: 0,);
                                                                  }
                                                                }
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      subtitle: Column(
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Expanded(
                                                                child: Container(
                                                                  padding: const EdgeInsets.all(10.0),
                                                                  child: Text(listOfComments.data![i].showListOfCommentsCommentBody, style: const TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xffFFFFFF),),),
                                                                  decoration: const BoxDecoration(color: Color(0xff4EC9D4), borderRadius: BorderRadius.all(Radius.circular(10.0)),),
                                                                ),
                                                              ),
                                                            ],
                                                          ),

                                                          const SizedBox(height: 5,),

                                                          Row(
                                                            children: [
                                                              Text(timeago.format(DateTime.parse(listOfComments.data![i].showListOfCommentsCreatedAt)), style: const TextStyle(fontSize: 18, fontFamily: 'NexaRegular', color: Color(0xff000000),),),

                                                              const SizedBox(width: 20,),

                                                              GestureDetector(
                                                                child: const Text('Reply', style: TextStyle(fontSize: 18, fontFamily: 'NexaRegular', color: Color(0xff000000),),),
                                                                onTap: () async{
                                                                  if(controller.text != ''){
                                                                    controller.clear();
                                                                  }

                                                                  await showModalBottomSheet(context: context, builder: (context) => showKeyboard(
                                                                    isReply: true, 
                                                                    toReply: listOfComments.data![i].showListOfCommentsCommentBody,
                                                                    replyFrom: '${listOfComments.data![i].showListOfCommentsUser.showListOfCommentsUserFirstName}' '${listOfComments.data![i].showListOfCommentsUser.showListOfCommentsUserLastName}',
                                                                    currentCommentId: listOfComments.data![i].showListOfCommentsCommentId,
                                                                  ),);
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                          
                                                          const SizedBox(height: 20,),

                                                          FutureBuilder<List<APIRegularShowListOfRepliesExtended>>(
                                                            future: getListOfReplies(commentId: listOfComments.data![i].showListOfCommentsCommentId, page: page2),
                                                            builder: (context, listOfReplies){
                                                              if(listOfReplies.connectionState != ConnectionState.done){
                                                                return const Center(child: CustomLoaderThreeDots());
                                                              }else if(listOfReplies.hasError){
                                                                return const SizedBox(height: 0,);
                                                              }
                                                              else if(listOfReplies.hasData){
                                                                return Column(
                                                                  children: List.generate(listOfReplies.data!.length, (index) => ListTile(
                                                                    contentPadding: EdgeInsets.zero,
                                                                    visualDensity: const VisualDensity(vertical: 4.0),
                                                                    leading: listOfReplies.data![index].showListOfRepliesUser.showListRepliesUserImage != ''
                                                                    ? CircleAvatar(
                                                                      backgroundColor: const Color(0xff888888),
                                                                      foregroundImage: NetworkImage(listOfReplies.data![index].showListOfRepliesUser.showListRepliesUserImage),
                                                                    )
                                                                    : const CircleAvatar(
                                                                      backgroundColor: Color(0xff888888),
                                                                      foregroundImage: AssetImage('assets/icons/user-placeholder.png'),
                                                                    ),
                                                                    title: Row(
                                                                      children: [
                                                                        Expanded(
                                                                          child: currentUserId == listOfReplies.data![index].showListOfRepliesUser.showListRepliesUserUserId && currentAccountType == listOfReplies.data![index].showListOfRepliesUser.showListOfCommentsUserAccountType
                                                                          ? const Text('You', style: TextStyle(fontSize: 20, fontFamily: 'NexaBold', color: Color(0xff000000),),)
                                                                          : Text(listOfReplies.data![index].showListOfRepliesUser.showListRepliesUserFirstName + ' ' + listOfReplies.data![index].showListOfRepliesUser.showListRepliesUserLastName, style: const TextStyle(fontSize: 20, fontFamily: 'NexaBold', color: Color(0xff000000)),),
                                                                        ),

                                                                        Expanded(
                                                                          child: Align(
                                                                            alignment: Alignment.centerRight,
                                                                            child: FutureBuilder<APIRegularShowCommentOrReplyLikeStatus>(
                                                                              future: getCommentOrReplyStatus(commentableType: 'Reply', commentableId: listOfReplies.data![index].showListOfRepliesReplyId),
                                                                              builder: (context, replyStatus){
                                                                                if(replyStatus.connectionState != ConnectionState.done){
                                                                                  return const SizedBox(height: 0,);
                                                                                }else if(replyStatus.hasError){
                                                                                  return const SizedBox(height: 0,);
                                                                                }
                                                                                else if(replyStatus.hasData){
                                                                                  return MiscLikeButtonTemplate(likeStatus: replyStatus.data!.showCommentOrReplyLikeStatus, numberOfLikes: replyStatus.data!.showCommentOrReplyNumberOfLikes, commentableType: 'Reply', commentableId: listOfReplies.data![index].showListOfRepliesReplyId, postType: 2);
                                                                                }else{
                                                                                  return const SizedBox(height: 0,);
                                                                                }
                                                                              }
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    subtitle: Column(
                                                                      children: [
                                                                        Row(
                                                                          children: [
                                                                            Expanded(
                                                                              child: Container(
                                                                                padding: const EdgeInsets.all(10.0),
                                                                                child: Text(listOfReplies.data![index].showListOfRepliesReplyBody, style: const TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xffFFFFFF),),),
                                                                                decoration: const BoxDecoration(color: Color(0xff4EC9D4), borderRadius: BorderRadius.all(Radius.circular(10.0)),),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),

                                                                        const SizedBox(height: 5,),

                                                                        Row(
                                                                          children: [
                                                                            Text(timeago.format(DateTime.parse(listOfReplies.data![index].showListOfRepliesCreatedAt),), style: const TextStyle(fontSize: 18, fontFamily: 'NexaRegular', color: Color(0xff000000),),),

                                                                            const SizedBox(width: 40,),

                                                                            GestureDetector(
                                                                              child: const Text('Reply', style: TextStyle(fontSize: 18, fontFamily: 'NexaRegular', color: Color(0xff000000),),),
                                                                              onTap: () async{
                                                                                if(controller.text != ''){
                                                                                  controller.clear();
                                                                                }

                                                                                controller.text = listOfReplies.data![index].showListOfRepliesUser.showListRepliesUserFirstName + ' ' + listOfReplies.data![index].showListOfRepliesUser.showListRepliesUserLastName + ' ';

                                                                                await showModalBottomSheet(context: context, builder: (context) => showKeyboard(
                                                                                  isReply: true, 
                                                                                  toReply: listOfReplies.data![index].showListOfRepliesReplyBody,
                                                                                  replyFrom: '${listOfReplies.data![index].showListOfRepliesUser.showListRepliesUserFirstName} ${listOfReplies.data![index].showListOfRepliesUser.showListRepliesUserLastName}',
                                                                                  currentCommentId: listOfReplies.data![index].showListOfRepliesCommentId,
                                                                                ));
                                                                              },
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    onTap: (){
                                                                      Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularUserProfile(userId: listOfReplies.data![index].showListOfRepliesUser.showListRepliesUserUserId, accountType: listOfReplies.data![index].showListOfRepliesUser.showListOfCommentsUserAccountType,),),);
                                                                    },
                                                                    onLongPress: () async{
                                                                      if(currentUserId == listOfReplies.data![index].showListOfRepliesUser.showListRepliesUserUserId && currentAccountType == listOfReplies.data![index].showListOfRepliesUser.showListOfCommentsUserAccountType){
                                                                        await showMaterialModalBottomSheet(
                                                                          context: context,
                                                                          builder: (context) => SafeArea(
                                                                            top: false,
                                                                            child: Column(
                                                                              mainAxisSize: MainAxisSize.min,
                                                                              children: <Widget>[
                                                                                ListTile(
                                                                                  title: const Text('Edit'),
                                                                                  leading: const Icon(Icons.edit),
                                                                                  onTap: () async{
                                                                                    controller.text = controller.text + listOfReplies.data![index].showListOfRepliesReplyBody;

                                                                                    await showModalBottomSheet(
                                                                                      context: context,
                                                                                      builder: (context) => showKeyboardEdit(isEdit: false, editId: listOfReplies.data![index].showListOfRepliesReplyId),
                                                                                    );
                                                                                  },
                                                                                ),
                                                                                ListTile(
                                                                                  title: const Text('Delete'),
                                                                                  leading: const Icon(Icons.delete),
                                                                                  onTap: () async{
                                                                                    context.loaderOverlay.show();
                                                                                    await apiRegularDeleteReply(replyId: listOfReplies.data![index].showListOfRepliesReplyId);
                                                                                    controller.clear();
                                                                                    onRefresh();
                                                                                    context.loaderOverlay.hide();
                                                                                    Navigator.pop(context);
                                                                                  },
                                                                                )
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        );
                                                                      }else{
                                                                        await showMaterialModalBottomSheet(
                                                                          context: context,
                                                                          builder: (context) => SafeArea(
                                                                            top: false,
                                                                            child: Column(
                                                                              mainAxisSize: MainAxisSize.min,
                                                                              children: <Widget>[
                                                                                ListTile(
                                                                                  title: const Text('Report'),
                                                                                  leading: const Icon(Icons.edit),
                                                                                  onTap: (){
                                                                                    Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularReport(postId: widget.postId, reportType: 'Post')));
                                                                                  },
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        );
                                                                      }
                                                                    },
                                                                    ),
                                                                  ),
                                                                );
                                                              }else{
                                                                return const SizedBox(height: 0,);
                                                              }
                                                            }
                                                          ),
                                                        ],
                                                      ),
                                                      onTap: (){
                                                        Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularUserProfile(userId: listOfComments.data![i].showListOfCommentsUser.showListOfCommentsUserId, accountType: listOfComments.data![i].showListOfCommentsUser.showListOfCommentsUserAccountType,)));
                                                      },
                                                      onLongPress: () async{
                                                        if(currentUserId == listOfComments.data![i].showListOfCommentsUser.showListOfCommentsUserId && currentAccountType == listOfComments.data![i].showListOfCommentsUser.showListOfCommentsUserAccountType){
                                                          await showMaterialModalBottomSheet(
                                                            context: context,
                                                            builder: (context) => SafeArea(
                                                              top: false,
                                                              child: Column(
                                                                mainAxisSize: MainAxisSize.min,
                                                                children: <Widget>[
                                                                  ListTile(
                                                                    title: const Text('Edit'),
                                                                    leading: const Icon(Icons.edit),
                                                                    onTap: () async {
                                                                      controller.text = controller.text + listOfComments.data![i].showListOfCommentsCommentBody;

                                                                      await showModalBottomSheet(
                                                                        context: context,
                                                                        builder: (context) => showKeyboardEdit(isEdit: true, editId: listOfComments.data![i].showListOfCommentsCommentId),
                                                                      );
                                                                    },
                                                                  ),

                                                                  ListTile(
                                                                    title: const Text('Delete'),
                                                                    leading: const Icon(Icons.delete),
                                                                    onTap: () async{
                                                                      context.loaderOverlay.show();
                                                                      await apiRegularDeleteComment(commentId: listOfComments.data![i].showListOfCommentsCommentId);
                                                                      controller.clear();
                                                                      onRefresh();
                                                                      context.loaderOverlay.hide();
                                                                      Navigator.pop(context);
                                                                    },
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                        }else{
                                                          await showMaterialModalBottomSheet(
                                                            context: context,
                                                            builder: (context) => SafeArea(
                                                              top: false,
                                                              child: Column(
                                                                mainAxisSize: MainAxisSize.min,
                                                                children: <Widget>[
                                                                  ListTile(
                                                                    title: const Text('Report'),
                                                                    leading: const Icon(Icons.edit),
                                                                    onTap: (){
                                                                      Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularReport(postId: widget.postId, reportType: 'Post')));
                                                                    },
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                        }
                                                      },
                                                      ),
                                                    ),
                                                  );
                                                }else if(listOfComments.hasError){
                                                  return const MiscErrorMessageTemplate();
                                                }
                                                else{
                                                  return const SizedBox(height: 0,);
                                                }
                                              }
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }else{
                                  return const SizedBox(height: 0,);
                                }
                              },
                            ),
                          ),
                        ),
                      ),


                      filterListener
                      ? BackdropFilter(filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0), child: const MiscLoginToContinue(),)
                      : const SizedBox(height: 0),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  showKeyboard({bool isReply = false, String toReply = '',  String replyFrom = '', int currentCommentId = 0}){
    return InkWell(
      onTap: (){
        filter.value = true;
      },
      child: IgnorePointer(
        ignoring: isGuestLoggedIn.value,
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0,),
            child: isReply
            ? SizedBox(
              height: 200,
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.only(top: 10.0),
                            physics: const ClampingScrollPhysics(),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: RichText(
                                text: TextSpan(
                                  children: <TextSpan>[
                                    const TextSpan(text: 'Replying to ', style: TextStyle(color: Color(0xff888888,), fontSize: 24, fontFamily: 'NexaRegular',),),

                                    TextSpan(text: '$replyFrom\n', style: const TextStyle(color: Color(0xff000000), fontSize: 24, fontFamily: 'NexaRegular', fontWeight: FontWeight.bold)),

                                    TextSpan(text: toReply, style: const TextStyle(color: Color(0xff000000), fontSize: 24, fontFamily: 'NexaRegular',),),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: (){
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  Row(
                    children: [
                      currentUserImage.value != ''
                      ? CircleAvatar(
                        backgroundColor: const Color(0xff888888),
                        foregroundImage: NetworkImage(currentUserImage.value),
                      )
                      : const CircleAvatar(
                        backgroundColor: Color(0xff888888),
                        foregroundImage: AssetImage('assets/icons/user-placeholder.png'),
                      ),

                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            controller: controller,
                            style: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xffFFFFFF),),
                            keyboardType: TextInputType.text,
                            cursorColor: const Color(0xffFFFFFF),
                            maxLines: 2,
                            decoration: const InputDecoration(
                              filled: true,
                              labelText: 'Say something...',
                              fillColor: Color(0xffBDC3C7),
                              floatingLabelBehavior: FloatingLabelBehavior.never,
                              labelStyle: TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xffFFFFFF),),
                              border: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffBDC3C7),), borderRadius: BorderRadius.all(Radius.circular(10)),),
                              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffBDC3C7),), borderRadius: BorderRadius.all(Radius.circular(10)),),
                            ),
                          ),
                        ),
                      ),

                      GestureDetector(
                        child: const Text('Post', style: TextStyle(fontSize: 24, fontFamily: 'NexaBold', color: Color(0xff2F353D),),),
                        onTap: () async{
                          if(controller.text == ''){
                            await showDialog(
                              context: context,
                              builder: (context) => CustomDialog(
                                image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                title: 'Error',
                                description: 'Please input a comment.',
                                okButtonColor: const Color(0xfff44336), // RED
                                includeOkButton: true,
                              ),
                            );
                          }else{
                            context.loaderOverlay.show();
                            await apiRegularAddReply(commentId: currentCommentId, replyBody: controller.text);
                            controller.clear();
                            onRefresh();
                            context.loaderOverlay.hide();
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            )
            : Row(
              children: [
                currentUserImage.value != ''
                ? CircleAvatar(
                  backgroundColor: const Color(0xff888888),
                  foregroundImage: NetworkImage(currentUserImage.value),
                )
                : const CircleAvatar(
                  backgroundColor: Color(0xff888888),
                  foregroundImage: AssetImage('assets/icons/user-placeholder.png'),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      controller: controller,
                      cursorColor: const Color(0xffFFFFFF),
                      maxLines: 2,
                      keyboardType: TextInputType.text,
                      style: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xffFFFFFF),),
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Color(0xffBDC3C7),
                        labelText: 'Say something...',
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        labelStyle: TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xffFFFFFF),),
                        border: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffBDC3C7),), borderRadius: BorderRadius.all(Radius.circular(10)),),
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffBDC3C7),), borderRadius: BorderRadius.all(Radius.circular(10)),),
                      ),
                    ),
                  ),
                ),

                GestureDetector(
                  child: const Text('Post', style: TextStyle(fontSize: 24, fontFamily: 'NexaBold', color: Color(0xff2F353D),),),
                  onTap: () async{
                    if(controller.text == ''){
                      await showDialog(
                        context: context,
                        builder: (context) => CustomDialog(
                          image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                          title: 'Error',
                          description: 'Please input a comment.',
                          okButtonColor: const Color(0xfff44336), // RED
                          includeOkButton: true,
                        ),
                      );
                    }else{
                      context.loaderOverlay.show();
                      await apiRegularAddComment(postId: widget.postId, commentBody: controller.text);
                      controller.clear();
                      onRefresh();
                      context.loaderOverlay.hide();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  showKeyboardEdit({required bool isEdit, required int editId}){
    // isEdit - TRUE (COMMENT) | FALSE (REPLY)
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0,),
        child: Row(
          children: [
            currentUserImage.value != ''
            ? CircleAvatar(
              backgroundColor: const Color(0xff888888),
              foregroundImage: NetworkImage(currentUserImage.value),
            )
            : const CircleAvatar(
              backgroundColor: Color(0xff888888),
              foregroundImage: AssetImage('assets/icons/user-placeholder.png'),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  controller: controller,
                  cursorColor: const Color(0xffFFFFFF),
                  maxLines: 2,
                  keyboardType: TextInputType.text,
                  style: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xffFFFFFF),),
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Color(0xffBDC3C7),
                    labelText: 'Say something...',
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    labelStyle: TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xffFFFFFF),),
                    border: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffBDC3C7),), borderRadius: BorderRadius.all(Radius.circular(10)),),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffBDC3C7),), borderRadius: BorderRadius.all(Radius.circular(10)),),
                  ),
                ),
              ),
            ),

            GestureDetector(
              child: const Text('Post', style: TextStyle(fontSize: 24, fontFamily: 'NexaBold', color: Color(0xff2F353D),),),
              onTap: () async{
                if(controller.text == ''){
                  await showDialog(
                    context: context,
                    builder: (context) => CustomDialog(
                      image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                      title: 'Error',
                      description: 'Please input a comment.',
                      okButtonColor: const Color(0xfff44336), // RED
                      includeOkButton: true,
                    ),
                  );
                }else if(isEdit == true){
                  context.loaderOverlay.show();
                  await apiRegularEditComment(commentId: editId, commentBody: controller.text);
                  controller.clear();
                  onRefresh();
                  context.loaderOverlay.hide();
                }else{
                  context.loaderOverlay.show();
                  await apiRegularEditReply(replyId: editId, replyBody: controller.text);
                  controller.clear();
                  onRefresh();
                  context.loaderOverlay.hide();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}