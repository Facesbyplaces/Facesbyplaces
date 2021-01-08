// import 'package:facesbyplaces/UI/Home/BLM/02-View-Memorial/home-view-memorial-blm-01-managed-memorial.dart';
// import 'package:facesbyplaces/API/BLM/05-Create-Post/api-create-post-blm-01-create-post.dart';
// import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-01-blm-input-field.dart';
// import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-02-blm-dialog.dart';
// import 'package:facesbyplaces/Configurations/size_configuration.dart';
// import 'package:location/location.dart' as Location;
// import 'package:loader_overlay/loader_overlay.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:video_player/video_player.dart';
// import 'package:flutter/material.dart';
// import 'dart:io';

// class BLMRelationshipItem{

//   final String name;
//   final String image;
  
//   const BLMRelationshipItem({this.name, this.image});
// }

// class HomeBLMCreatePost extends StatefulWidget{

//   @override
//   HomeBLMCreatePostState createState() => HomeBLMCreatePostState();
// }

// class HomeBLMCreatePostState extends State<HomeBLMCreatePost>{

//   final GlobalKey<MiscBLMInputFieldMultiTextPostTemplateState> _key1 = GlobalKey<MiscBLMInputFieldMultiTextPostTemplateState>();

//   File imageFile;
//   File videoFile;
//   final picker = ImagePicker();
//   VideoPlayerController videoPlayerController;
//   String newLocation;
//   String person;

//   Future getImage() async{
//     final pickedFile = await picker.getImage(source: ImageSource.gallery);

//     if(pickedFile != null){
//       setState(() {
//         imageFile = File(pickedFile.path);
//         videoFile = null;
//       });
//     }
//   }

//   Future getVideo() async{
//     final pickedFile = await picker.getVideo(source: ImageSource.gallery);

//     if(pickedFile != null){
//       setState(() {
//         videoFile = File(pickedFile.path);
//         imageFile = null;
//         videoPlayerController = VideoPlayerController.file(videoFile)
//         ..initialize().then((_){
//           setState(() {
//             videoPlayerController.play();
//           });
//         });
//       });
//     }
//   }

//   List<BLMRelationshipItem> relationship = [
//     const BLMRelationshipItem(name: 'Richard Nedd Memories', image: 'assets/icons/profile2.png'),
//     const BLMRelationshipItem(name: 'New Memorial', image: 'assets/icons/profile2.png'),
//   ];

//   BLMRelationshipItem currentSelection = const BLMRelationshipItem(name: 'New Memorial', image: 'assets/icons/profile2.png');

//   void initState(){
//     super.initState();
//     newLocation = '';
//     person = '';
//   }

//   @override
//   Widget build(BuildContext context) {
//     SizeConfig.init(context);
//     BLMRelationshipItemPost newValue = ModalRoute.of(context).settings.arguments;
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
//             title: Text('Create Post', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xffffffff)),),
//             centerTitle: true,
//             backgroundColor: Color(0xff04ECFF),
//             leading: IconButton(icon: Icon(Icons.arrow_back, color: Color(0xffffffff),), onPressed: (){Navigator.pop(context);},),
//             actions: [
//               GestureDetector(
//                 onTap: () async{

//                   File newFile;

//                   if(imageFile != null){
//                     newFile = imageFile;
//                   }else if(videoFile != null){
//                     newFile = videoFile;
//                   }

//                   Location.Location location = new Location.Location();

//                   bool serviceEnabled = await location.serviceEnabled();
//                   if (!serviceEnabled) {
//                     serviceEnabled = await location.requestService();
//                     if (!serviceEnabled) {
//                       return;
//                     }
//                   }

//                   Location.PermissionStatus permissionGranted = await location.hasPermission();
//                   if (permissionGranted == Location.PermissionStatus.denied) {
//                     permissionGranted = await location.requestPermission();
//                     if (permissionGranted != Location.PermissionStatus.granted) {
//                       return;
//                     }
//                   }

//                   Location.LocationData locationData = await location.getLocation();

//                   APIBLMCreatePost post = APIBLMCreatePost(
//                     pageType: 'Blm',
//                     postBody: _key1.currentState.controller.text,
//                     location: newLocation,
//                     imagesOrVideos: newFile,
//                     latitude: locationData.latitude.toString(),
//                     longitude: locationData.longitude.toString(),
//                   );

//                     context.showLoaderOverlay();
//                     bool result = await apiBLMHomeCreatePost(post, newValue.memorialId);
//                     context.hideLoaderOverlay();

//                   if(result){
//                     Navigator.popAndPushNamed(context, '/home/blm');
//                   }else{
//                     await showDialog(context: (context), builder: (build) => MiscBLMAlertDialog(title: 'Error', content: 'Something went wrong. Please try again.'));
//                   }
//                 }, 
//                 child: Padding(
//                   padding: EdgeInsets.only(right: 20.0), 
//                   child: Center(
//                     child: Text('Post', 
//                     style: TextStyle(
//                       color: Color(0xffffffff), 
//                       fontSize: SizeConfig.safeBlockHorizontal * 5,),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           body: SingleChildScrollView(
//             physics: ClampingScrollPhysics(),
//             child: Container(
//               height: SizeConfig.screenHeight - kToolbarHeight,
//               child: Column(
//                 children: [

//                   InputDecorator(
//                     decoration: InputDecoration(
//                       alignLabelWithHint: true,
//                       labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey),
//                       focusedBorder: UnderlineInputBorder(
//                         borderSide: BorderSide.none,
//                       ),
//                       border: UnderlineInputBorder(
//                         borderSide: BorderSide.none,
//                       ),
//                     ),
//                     child: DropdownButtonHideUnderline(
//                       child: DropdownButton<BLMRelationshipItem>(
//                         value: currentSelection,
//                         isDense: true,
//                         onChanged: (BLMRelationshipItem newValue) {
//                           setState(() {
//                             currentSelection = newValue;
//                           });
//                         },
//                         items: relationship.map((BLMRelationshipItem value) {
//                           return DropdownMenuItem<BLMRelationshipItem>(
//                             value: value,
//                             child: Row(
//                               children: [
//                                 CircleAvatar(backgroundImage: AssetImage(value.image),),

//                                 SizedBox(width: SizeConfig.blockSizeHorizontal * 2,),

//                                 Text(value.name),
//                               ],
//                             ),
//                           );
//                         }).toList(),
//                       ),
//                     ),
//                   ),

//                   Expanded(child: Padding(padding: EdgeInsets.all(20.0), child: MiscBLMInputFieldMultiTextPostTemplate(key: _key1, labelText: 'Speak out...', maxLines: 20),),),

//                   Container(
//                     child: ((){
//                       if(imageFile != null){
//                         return Container(height: SizeConfig.blockSizeVertical * 25, width: SizeConfig.screenWidth, padding: EdgeInsets.only(left: 20.0, right: 20.0,), child: Image.asset(imageFile.path, fit: BoxFit.cover),);
//                       }else if(videoFile != null){
//                         return Container(
//                           height: SizeConfig.blockSizeVertical * 25, 
//                           width: SizeConfig.screenWidth, 
//                           padding: EdgeInsets.only(left: 20.0, right: 20.0,), 
//                           child: GestureDetector(
//                             onTap: (){
//                               if(videoPlayerController.value.isPlaying){
//                                 videoPlayerController.pause();
//                               }else{
//                                 videoPlayerController.play();
//                               }
                              
//                             },
//                             onDoubleTap: () async{
//                               await getVideo();
//                             },
//                             child: AspectRatio(
//                               aspectRatio: videoPlayerController.value.aspectRatio,
//                               child: VideoPlayer(videoPlayerController),
//                             ),
//                           ),
//                         );
//                       }
//                     }()),
//                   ),

//                   SizedBox(height: SizeConfig.blockSizeVertical * 1,),

//                   Container(
//                     child: Row(
//                       children: [
//                         newLocation != ''
//                         ? Text('at')
//                         : Text(''),

//                         SizedBox(width: SizeConfig.blockSizeHorizontal * 1,),

//                         Text(newLocation, style: TextStyle(color: Color(0xff000000), fontSize: SizeConfig.safeBlockHorizontal * 4, fontWeight: FontWeight.bold),),

//                         SizedBox(width: SizeConfig.blockSizeHorizontal * 1,),

//                         person != ''
//                         ? Text('with')
//                         : Text(''),

//                         SizedBox(width: SizeConfig.blockSizeHorizontal * 1,),

//                         Text(person, style: TextStyle(color: Color(0xff000000), fontSize: SizeConfig.safeBlockHorizontal * 4, fontWeight: FontWeight.bold),),
//                       ],
//                     ), 
//                     padding: EdgeInsets.only(left: 20.0, right: 20.0,), 
//                     alignment: Alignment.centerLeft,
//                   ),

//                   SizedBox(height: SizeConfig.blockSizeVertical * 1,),

//                   Container(
//                     padding: EdgeInsets.only(left: 20.0, right: 20.0,),
//                     height: SizeConfig.blockSizeVertical * 20,
//                     child: Column(
//                       children: [
//                         Expanded(
//                           child: GestureDetector(
//                             onTap: () async{
//                               var result = await Navigator.pushNamed(context, '/home/blm/home-19-02-blm-create-post');

//                               setState(() {});

//                               if(result == null){
//                                 newLocation = '';
//                               }else{
//                                 newLocation = result.toString();
//                               }

//                             },
//                             child: Container(
//                               color: Colors.transparent,
//                               child: Row(
//                                 children: [
//                                   Expanded(child: Text('Add a location'),),
//                                   Icon(Icons.place, color: Color(0xff4EC9D4),)
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),

//                         Container(height: SizeConfig.blockSizeVertical * .1, color: Color(0xffeeeeee),),

//                         Expanded(
//                           child: GestureDetector(
//                             onTap: () async{
                              
//                               var result = await Navigator.pushNamed(context, '/home/blm/home-19-03-blm-create-post');

//                               setState(() {});

//                               if(result == null){
//                                 person = '';
//                               }else{
//                                 person = result.toString();
//                               }
//                             },
//                             child: Container(
//                               color: Colors.transparent,
//                               child: Row(
//                                 children: [
//                                   Expanded(child: Text('Tag a person you are with'),),
//                                   Icon(Icons.person, color: Color(0xff4EC9D4),)
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),

//                         Container(height: SizeConfig.blockSizeVertical * .1, color: Color(0xffeeeeee),),

//                         Expanded(
//                           child: GestureDetector(
//                             onTap: () async{

//                               var choice = await showDialog(context: (context), builder: (build) => MiscBLMUploadFromDialog(choice_1: 'Image', choice_2: 'Video',));

//                               if(choice == null){
//                                 choice = 0;
//                               }else{
//                                 if(choice == 1){
//                                   await getImage();
//                                 }else{
//                                   await getVideo();
//                                 }
//                               }
//                             },
//                             child: Container(
//                               color: Colors.transparent,
//                               child: Row(
//                                 children: [
//                                   Expanded(child: Text('Upload a Video / Image'),),
//                                   Icon(Icons.image, color: Color(0xff4EC9D4),)
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),

//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }




// import 'package:facesbyplaces/API/BLM/08-Search/api-23-blm-search-users.dart';
// import 'package:facesbyplaces/Configurations/size_configuration.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';
// import 'package:flutter/material.dart';

// class BLMSearchUsers{
//   String firstName;
//   String lastName;
//   String email;

//   BLMSearchUsers({this.firstName, this.lastName, this.email});
// }

// class HomeBLMCreatePostSearchUser extends StatefulWidget{

//   @override
//   HomeBLMCreatePostSearchUserState createState() => HomeBLMCreatePostSearchUserState();
// }

// class HomeBLMCreatePostSearchUserState extends State<HomeBLMCreatePostSearchUser>{
  
//   RefreshController refreshController = RefreshController(initialRefresh: true);
//   TextEditingController controller = TextEditingController();
//   List<BLMSearchUsers> users;
//   int itemRemaining;
//   bool empty;
//   int page;

//   void onRefresh() async{
//     await Future.delayed(Duration(milliseconds: 1000));
//     refreshController.refreshCompleted();
//   }  

//   void onLoading() async{
//     if(itemRemaining != 0){
//       var newValue = await apiBLMSearchUsers(controller.text, page);
//       itemRemaining = newValue.itemsRemaining;

//       for(int i = 0; i < newValue.users.length; i++){
//         users.add(BLMSearchUsers(firstName: newValue.users[i].firstName, lastName: newValue.users[i].lastName, email: newValue.users[i].email));
//       }

//       if(mounted)
//       setState(() {});
//       page++;
      
//       refreshController.loadComplete();
//     }else{
//       refreshController.loadNoData();
//     }
//   }

//   void initState(){
//     super.initState();
//     itemRemaining = 1;
//     empty = true;
//     users = [];
//     page = 1;
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
//             title: TextFormField(
//               onChanged: (newPlace){
//                 if(newPlace == ''){
//                   setState(() {
//                     empty = true;
//                     users = [];
//                     itemRemaining = 1;
//                     page = 1;
//                   });
//                 }
//               },
//               onFieldSubmitted: (newPlace){
//                 setState(() {
//                   controller.text = newPlace;
//                   empty = false;
//                 });

//                 onLoading();
//               },
//               decoration: InputDecoration(
//                 contentPadding: EdgeInsets.all(15.0),
//                 filled: true,
//                 fillColor: Color(0xffffffff),
//                 focusColor: Color(0xffffffff),
//                 hintText: 'Search User',
//                 hintStyle: TextStyle(
//                   fontSize: SizeConfig.safeBlockHorizontal * 4,
//                 ),
//                 prefixIcon: Icon(Icons.search, color: Colors.grey),
//                 border: OutlineInputBorder(
//                   borderSide: BorderSide(color: Color(0xffffffff)),
//                   borderRadius: BorderRadius.all(Radius.circular(25)),
//                 ),
//                 enabledBorder:  OutlineInputBorder(
//                   borderSide: BorderSide(color: Color(0xffffffff)),
//                   borderRadius: BorderRadius.all(Radius.circular(25)),
//                 ),
//                 focusedBorder:  OutlineInputBorder(
//                   borderSide: BorderSide(color: Color(0xffffffff)),
//                   borderRadius: BorderRadius.all(Radius.circular(25)),
//                 ),
//               ),
//             ),
//             leading: IconButton(icon: Icon(Icons.arrow_back, color: Color(0xffffffff),), onPressed: (){Navigator.pop(context);},),
//             backgroundColor: Color(0xff04ECFF),
//           ),
//           body: empty
//           ? SingleChildScrollView(
//             physics: ClampingScrollPhysics(),
//             padding: EdgeInsets.zero,
//             child: Container(
//               height: SizeConfig.screenHeight - kToolbarHeight,
//               child: Column(
//                 children: [
//                   Expanded(child: Container(),),

//                   Container(
//                     height: SizeConfig.blockSizeVertical * 30,
//                     width: SizeConfig.screenWidth / 2,
//                     decoration: BoxDecoration(
//                       image: DecorationImage(
//                         image: AssetImage('assets/icons/search-user.png'),
//                       ),
//                     ),
//                   ),

//                   SizedBox(height: SizeConfig.blockSizeVertical * 2,),

//                   Text('Search a location to add on your post', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),),

//                   Expanded(child: Container(),),
//                 ],
//               ),
//             ),
//           )
//           : Container(
//             height: SizeConfig.screenHeight,
//             child: SmartRefresher(
//               enablePullDown: false,
//               enablePullUp: true,
//               header: MaterialClassicHeader(),
//               footer: CustomFooter(
//                 loadStyle: LoadStyle.ShowWhenLoading,
//                 builder: (BuildContext context, LoadStatus mode){
//                   Widget body ;
//                   if(mode == LoadStatus.idle){
//                     body = Text('Pull up load', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
//                   }
//                   else if(mode == LoadStatus.loading){
//                     body = CircularProgressIndicator();
//                   }
//                   else if(mode == LoadStatus.failed){
//                     body = Text('Load Failed! Click retry!', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
//                   }
//                   else if(mode == LoadStatus.canLoading){
//                     body = Text('Release to load more', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
//                   }
//                   else{
//                     body = Text('End of result.', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
//                   }
//                   return Container(height: 55.0, child: Center(child:body),);
//                 },
//               ),
//               controller: refreshController,
//               onRefresh: onRefresh,
//               onLoading: onLoading,
//               child: ListView.separated(
//                 padding: EdgeInsets.all(10.0),
//                 shrinkWrap: true,
//                 itemBuilder: (c, i) {
//                   var container = GestureDetector(
//                     onTap: (){
//                       Navigator.pop(context, '${users[i].firstName}' + ' ' + '${users[i].lastName}');
//                     },
//                     child: Container(
//                       padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
//                       height: SizeConfig.blockSizeVertical * 10,
//                       child: Row(
//                         children: [

//                           CircleAvatar(backgroundImage: AssetImage('assets/icons/graveyard.png'), backgroundColor: Color(0xff888888)),

//                           SizedBox(width: SizeConfig.blockSizeHorizontal * 2,),

//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Expanded(child: Container(),),

//                                 Text('${users[i].firstName}' + ' ' + '${users[i].lastName}', style: TextStyle(fontWeight: FontWeight.bold,),),

//                                 Text('${users[i].email}', style: TextStyle(fontWeight: FontWeight.w400, fontSize: SizeConfig.safeBlockHorizontal * 3, color: Color(0xff888888)),),

//                                 Expanded(child: Container(),),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                   return container;
//                 },
//                 separatorBuilder: (c, i) => Divider(height: SizeConfig.blockSizeVertical * 2, color: Color(0xff888888)),
//                 itemCount: users.length,
//               ),
//             )
//           )
//         ),
//       ),
//     );
//   }
// }







// import 'package:facesbyplaces/API/BLM/10-Settings-User/api-settings-user-blm-04-show-other-details.dart';
// import 'package:facesbyplaces/API/BLM/13-Show-User/api-show-user-blm-01-show-user-information.dart';
// import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-05-blm-post.dart';
// import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-06-blm-custom-drawings.dart';
// import 'package:facesbyplaces/Configurations/size_configuration.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter/material.dart';
// import 'dart:ui';

// class HomeBLMUserProfile extends StatefulWidget{
//   final int userId;
//   HomeBLMUserProfile({this.userId});

//   HomeBLMUserProfileState createState() => HomeBLMUserProfileState(userId: userId);
// }

// class HomeBLMUserProfileState extends State<HomeBLMUserProfile>{
//   final int userId;
//   HomeBLMUserProfileState({this.userId});

//   Future showProfile;
//   Future showDetails;

//   void initState(){
//     super.initState();
//     showDetails = getOtherDetails(userId);
//     showProfile = getProfileInformation(userId);
//   }

//   Future<APIBLMShowOtherDetails> getOtherDetails(int userId) async{
//     return await apiBLMShowOtherDetails(userId);
//   }

//   Future<APIBLMShowUserInformation> getProfileInformation(int userId) async{
//     return await apiBLMShowUserInformation(userId: userId);
//   }

//   @override
//   Widget build(BuildContext context) {
//     SizeConfig.init(context);
//     return Scaffold(
//       body: Stack(
//         children: [

//           Container(height: SizeConfig.screenHeight, color: Color(0xffffffff),),

//           Container(
//             height: SizeConfig.screenHeight / 2.5,
//             child: Stack(
//               children: [

//                 CustomPaint(size: Size.infinite, painter: MiscBLMCurvePainter(),),

//                 Container(
//                   padding: EdgeInsets.only(bottom: 20.0),
//                   alignment: Alignment.bottomCenter,
//                   child: CircleAvatar(radius: SizeConfig.blockSizeVertical * 15, backgroundImage: AssetImage('assets/icons/profile1.png'),)
//                 ),

//               ],
//             ),
//           ),

//           Container(
//             height: Size.fromHeight(AppBar().preferredSize.height).height + (Size.fromHeight(AppBar().preferredSize.height).height / 2),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: Container(
//                     padding: EdgeInsets.only(left: 10.0),
//                     alignment: Alignment.centerLeft,
//                       child: IconButton(
//                       onPressed: (){
//                         Navigator.popUntil(context, ModalRoute.withName('/home/blm'));
//                       },
//                       icon: Icon(Icons.arrow_back, color: Color(0xffffffff), size: SizeConfig.blockSizeVertical * 5,), 
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: Container(
//                     padding: EdgeInsets.only(right: 10.0),
//                     alignment: Alignment.centerRight,
//                     child: IconButton(
//                       alignment: Alignment.centerRight,
//                       padding: EdgeInsets.zero,
//                       onPressed: (){},
//                       icon: Icon(Icons.more_vert, color: Color(0xffffffff), size: SizeConfig.blockSizeVertical * 5,),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           Positioned(
//             top: SizeConfig.screenHeight / 2.5,
//             child: Container(
//               width: SizeConfig.screenWidth,
//               child: Column(
//                 children: [
//                   Center(
//                     child: Text('Joan Oliver',
//                       style: TextStyle(
//                         fontSize: SizeConfig.safeBlockHorizontal * 5,
//                         fontWeight: FontWeight.bold,
//                         color: Color(0xff000000),
//                       ),
//                     ),
//                   ),

//                   SizedBox(height: SizeConfig.blockSizeVertical * 2,),

//                   Center(
//                     child: Text('+joan1980',
//                       style: TextStyle(
//                         fontSize: SizeConfig.safeBlockHorizontal * 4,
//                         fontWeight: FontWeight.w300,
//                         color: Color(0xff000000),
//                       ),
//                     ),
//                   ),

//                   SizedBox(height: SizeConfig.blockSizeVertical * 5,),

//                   GestureDetector(
//                     onTap: (){
//                       Navigator.pushNamed(context, '/home/blm/home-14-blm-user-details');
//                     },
//                     child: Center(
//                       child: Text('About',
//                         style: TextStyle(
//                           fontSize: SizeConfig.safeBlockHorizontal * 4,
//                           fontWeight: FontWeight.bold,
//                           color: Color(0xff04ECFF),
//                         ),
//                       ),
//                     ),
//                   ),

//                   SizedBox(height: SizeConfig.blockSizeVertical * 5,),

//                   Padding(
//                     padding: EdgeInsets.only(left: 20.0, right: 20.0),
//                     child: Column(
//                       children: [
//                         Row(
//                           children: [
//                             Expanded(
//                               child: Row(
//                                 children: [
//                                   Icon(Icons.star_outline, color: Color(0xffBDC3C7), size: SizeConfig.blockSizeVertical * 2,),

//                                   SizedBox(width: SizeConfig.blockSizeHorizontal * 2,),

//                                   Text('Birthdate',
//                                     style: TextStyle(
//                                       fontSize: SizeConfig.safeBlockHorizontal * 3.5,
//                                       color: Color(0xffBDC3C7),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             Expanded(
//                               child: Text('4/23/1995',
//                                 style: TextStyle(
//                                   fontSize: SizeConfig.safeBlockHorizontal * 3.5,
//                                   color: Color(0xff000000),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),

//                         SizedBox(height: SizeConfig.blockSizeVertical * 2,),

//                         Row(
//                           children: [
//                             Expanded(
//                               child: Row(
//                                 children: [
//                                   Icon(Icons.place, color: Color(0xffBDC3C7), size: SizeConfig.blockSizeVertical * 2,),

//                                   SizedBox(width: SizeConfig.blockSizeHorizontal * 2,),

//                                   Text('Birthplace',
//                                     style: TextStyle(
//                                       fontSize: SizeConfig.safeBlockHorizontal * 3.5,
//                                       color: Color(0xffBDC3C7),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             Expanded(
//                               child: Text('59 West 46th Street, New York City, NY 10036.',
//                                 overflow: TextOverflow.ellipsis,
//                                 style: TextStyle(
//                                   fontSize: SizeConfig.safeBlockHorizontal * 3.5,
//                                   color: Color(0xff000000),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),

//                         SizedBox(height: SizeConfig.blockSizeVertical * 2,),

//                         Row(
//                           children: [
//                             Expanded(
//                               child: Row(
//                                 children: [
//                                   Icon(Icons.home, color: Color(0xffBDC3C7), size: SizeConfig.blockSizeVertical * 2,),

//                                   SizedBox(width: SizeConfig.blockSizeHorizontal * 2,),

//                                   Text('Home Address',
//                                     style: TextStyle(
//                                       fontSize: SizeConfig.safeBlockHorizontal * 3.5,
//                                       color: Color(0xffBDC3C7),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             Expanded(
//                               child: Text('59 West 46th Street, New York City, NY 10036.',
//                                 overflow: TextOverflow.ellipsis,
//                                 style: TextStyle(
//                                   fontSize: SizeConfig.safeBlockHorizontal * 3.5,
//                                   color: Color(0xff000000),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),

//                         SizedBox(height: SizeConfig.blockSizeVertical * 2,),

//                         Row(
//                           children: [
//                             Expanded(
//                               child: Row(
//                                 children: [
//                                   Icon(Icons.email, color: Color(0xffBDC3C7), size: SizeConfig.blockSizeVertical * 2,),

//                                   SizedBox(width: SizeConfig.blockSizeHorizontal * 2,),

//                                   Text('Email Address',
//                                     style: TextStyle(
//                                       fontSize: SizeConfig.safeBlockHorizontal * 3.5,
//                                       color: Color(0xffBDC3C7),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             Expanded(
//                               child: Text('joan.oliver@gmail.com',
//                                 style: TextStyle(
//                                   fontSize: SizeConfig.safeBlockHorizontal * 3.5,
//                                   color: Color(0xff000000),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),

//                         SizedBox(height: SizeConfig.blockSizeVertical * 2,),

//                         Row(
//                           children: [
//                             Expanded(
//                               child: Row(
//                                 children: [
//                                   Icon(Icons.phone, color: Color(0xffBDC3C7), size: SizeConfig.blockSizeVertical * 2,),

//                                   SizedBox(width: SizeConfig.blockSizeHorizontal * 2,),

//                                   Text('Contact Number',
//                                     style: TextStyle(
//                                       fontSize: SizeConfig.safeBlockHorizontal * 3.5,
//                                       color: Color(0xffBDC3C7),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             Expanded(
//                               child: Text('+1 123456789',
//                                 style: TextStyle(
//                                   fontSize: SizeConfig.safeBlockHorizontal * 3.5,
//                                   color: Color(0xff000000),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),

//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),

//           MiscBLMUserProfileDraggableSwitchTabs(),

//         ],
//       ),
//     );
//   }
// }








// ===================================

// import 'package:facesbyplaces/API/BLM/02-Main/api-main-blm-01-logout.dart';
// import 'package:facesbyplaces/API/BLM/02-Main/api-main-blm-02-show-user-information.dart';
// import 'package:facesbyplaces/API/BLM/02-Main/api-main-blm-03-show-notifications-settings.dart';
// import 'package:facesbyplaces/UI/Home/BLM/07-Search/home-search-blm-01-search.dart';
// import 'package:facesbyplaces/UI/Home/BLM/09-Settings-User/home-settings-user-01-user-details.dart';
// import 'package:facesbyplaces/UI/Home/BLM/10-Settings-Notifications/home-settings-notifications-blm-01-notification-settings.dart';
// import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-02-blm-dialog.dart';
// import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-04-blm-extra.dart';
// import 'package:facesbyplaces/Configurations/size_configuration.dart';
// import 'package:flutter_login_facebook/flutter_login_facebook.dart';
// import 'package:facesbyplaces/Bloc/bloc-02-bloc-blm-home.dart';
// import 'package:responsive_widgets/responsive_widgets.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:loader_overlay/loader_overlay.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../../ui-01-get-started.dart';
// import 'package:flutter/material.dart';
// import 'home-main-blm-03-01-feed-tab.dart';
// import 'home-main-blm-03-02-memorial-list-tab.dart';
// import 'home-main-blm-03-03-post-tab.dart';
// import 'home-main-blm-03-04-notifications-tab.dart';

// class HomeBLMScreenExtended extends StatefulWidget{

//   HomeBLMScreenExtendedState createState() => HomeBLMScreenExtendedState();
// }

// class HomeBLMScreenExtendedState extends State<HomeBLMScreenExtended>{

//   Future drawerSettings;

//   Future<APIBLMShowProfileInformation> getDrawerInformation() async{
//     return await apiBLMShowProfileInformation();
//   }

//   void initState(){
//     super.initState();
//     drawerSettings = getDrawerInformation();
//   }

//   @override
//   Widget build(BuildContext context) {
//     SizeConfig.init(context);
//     ResponsiveWidgets.init(context,
//       height: SizeConfig.screenHeight,
//       width: SizeConfig.screenWidth,
//     );
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider<BlocHomeBLMToggleBottom>(create: (context) => BlocHomeBLMToggleBottom(),),
//         BlocProvider<BlocHomeBLMUpdateToggle>(create: (context) => BlocHomeBLMUpdateToggle(),),
//       ],
//       child: WillPopScope(
//         onWillPop: () async{
//           return Navigator.canPop(context);
//         },
//         child: GestureDetector(
//           onTap: (){
//             FocusNode currentFocus = FocusScope.of(context);
//             if(!currentFocus.hasPrimaryFocus){
//               currentFocus.unfocus();
//             }
//           },
//           child: Scaffold(
//             appBar: AppBar(
//               backgroundColor: Color(0xff4EC9D4),
//               leading: FutureBuilder<APIBLMShowProfileInformation>(
//                 future: drawerSettings,
//                 builder: (context, profileImage){
//                   if(profileImage.hasData){
//                     return Builder(
//                       builder: (context){
//                         return IconButton(
//                           icon: CircleAvatar(
//                             backgroundColor: Color(0xff888888),
//                             backgroundImage: ((){
//                               if(profileImage.data.image != null && profileImage.data.image != ''){
//                                 return NetworkImage(profileImage.data.image);
//                               }else{
//                                 return AssetImage('assets/icons/app-icon.png');
//                               }
//                             }()),
//                           ),
//                           onPressed: () async{
//                             Scaffold.of(context).openDrawer();
//                           },
//                         );
//                       },
//                     );
//                   }else if(profileImage.hasError){
//                     return Icon(Icons.error);
//                   }else{
//                     return Container(child: CircularProgressIndicator(), padding: EdgeInsets.all(20.0),);
//                   }
//                 },
//               ),
//               title: Text('FacesByPlaces.com', style: TextStyle(fontSize: ScreenUtil().setSp(16, allowFontScalingSelf: true), color: Color(0xffffffff),),),
//               centerTitle: true,
//               actions: [
//                 IconButton(
//                   icon: Icon(Icons.search, color: Color(0xffffffff), size: ScreenUtil().setHeight(35)), 
//                   onPressed: (){

//                     Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMSearch()));
//                   },
//                 ),
//               ],
//             ),
//             body: BlocBuilder<BlocHomeBLMToggleBottom, int>(
//               builder: (context, toggleBottom){
//                 return Container(
//                   decoration: BoxDecoration(image: DecorationImage(fit: BoxFit.cover, image: AssetImage('assets/icons/background2.png'), colorFilter: ColorFilter.srgbToLinearGamma(),),),
//                   child: ((){
//                     switch(toggleBottom){
//                       case 0: return HomeBLMFeedTab(); break;
//                       case 1: return HomeBLMManageTab(); break;
//                       case 2: return HomeBLMPostTab(); break;
//                       case 3: return HomeBLMNotificationsTab(); break;
//                     }
//                   }()),
//                 );
//               },
//             ),
//             bottomSheet: MiscBLMBottomSheet(),
//             drawer: FutureBuilder<APIBLMShowProfileInformation>(
//               future: drawerSettings,
//               builder: (context, manageDrawer){
//                 if(manageDrawer.hasData){
//                   return Drawer(
//                     child: Container(
//                       color: Color(0xff4EC9D4),
//                       child: Column(
//                         children: [
//                           SizedBox(height: SizeConfig.blockSizeVertical * 2,),

//                           CircleAvatar(
//                             radius: SizeConfig.blockSizeVertical * 10.5,
//                             backgroundColor: Color(0xff888888),
//                             backgroundImage: ((){
//                               if(manageDrawer.data.image != null && manageDrawer.data.image != ''){
//                                 return NetworkImage(manageDrawer.data.image);
//                               }else{
//                                 return AssetImage('assets/icons/app-icon.png');
//                               }
//                             }()),
//                           ),


//                           SizedBox(height: SizeConfig.blockSizeVertical * 2,),

//                           Text(manageDrawer.data.firstName + ' ' + manageDrawer.data.lastName, style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 5, fontWeight: FontWeight.w500, color: Color(0xffffffff),),),

//                           SizedBox(height: SizeConfig.blockSizeVertical * 5,),

//                           GestureDetector(
//                             onTap: (){
//                               Navigator.pop(context);
//                             },
//                             child: Text('Home', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 5, fontWeight: FontWeight.w200, color: Color(0xffffffff),),),
//                           ),

//                           SizedBox(height: SizeConfig.blockSizeVertical * 3,),

//                           GestureDetector(
//                             onTap: (){
//                               Navigator.pop(context);
//                               Navigator.pushNamed(context, '/home/blm/home-07-01-blm-create-memorial');
//                             },
//                             child: Text('Create Memorial Page', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 5, fontWeight: FontWeight.w200, color: Color(0xffffffff),),),
//                           ),

//                           SizedBox(height: SizeConfig.blockSizeVertical * 3,),

//                           GestureDetector(
//                             onTap: () async{

//                               context.showLoaderOverlay();
//                               APIBLMShowNotificationStatus result = await apiBLMShowNotificationStatus(userId: manageDrawer.data.userId);
//                               context.hideLoaderOverlay();

//                               Navigator.pop(context);
//                               Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMNotificationSettings(
//                                 newMemorial: result.newMemorial,
//                                 newActivities: result.newActivities,
//                                 postLikes: result.postLikes,
//                                 postComments: result.postComments,
//                                 addFamily: result.addFamily,
//                                 addFriends: result.addFriends,
//                                 addAdmin: result.addAdmin,
//                               )));
//                             },
//                             child: Text('Notification Settings', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 5, fontWeight: FontWeight.w200, color: Color(0xffffffff),),),
//                           ),

//                           SizedBox(height: SizeConfig.blockSizeVertical * 3,),

//                           GestureDetector(
//                             onTap: (){
//                               Navigator.pop(context);
//                               Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMUserProfileDetails(userId: manageDrawer.data.userId)));
//                             },
//                             child: Text('Profile Settings', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 5, fontWeight: FontWeight.w200, color: Color(0xffffffff),),),
//                           ),

//                           SizedBox(height: SizeConfig.blockSizeVertical * 3,),

//                           GestureDetector(
//                             onTap: () async{

//                               context.showLoaderOverlay();
//                               bool result = await apiBLMLogout();

//                               GoogleSignIn googleSignIn = GoogleSignIn(
//                                 scopes: [
//                                   'profile',
//                                   'email',
//                                   'openid'
//                                 ],
//                               );
//                               await googleSignIn.signOut();

//                               FacebookLogin fb = FacebookLogin();
//                               await fb.logOut();

//                               context.hideLoaderOverlay();

//                               if(result){
//                                 Route newRoute = MaterialPageRoute(builder: (BuildContext context) => UIGetStarted());
//                                 Navigator.pushAndRemoveUntil(context, newRoute, (route) => false);
//                               }else{
//                                 await showDialog(context: (context), builder: (build) => MiscBLMAlertDialog(title: 'Error', content: 'Something went wrong. Please try again'));
//                               }
                              
//                             },
//                             child: Text('Log Out', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 5, fontWeight: FontWeight.w200, color: Color(0xffffffff),),),
//                           ),
                          
//                         ],
//                       ),
//                     ),
//                   );
//                 }else if(manageDrawer.hasError){
//                   return Center(child: Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),),);
//                 }else{
//                   return Container(child: Center(child: Container(child: SpinKitThreeBounce(color: Color(0xff000000), size: 50.0,), color: Color(0xffffffff),),),);
//                 }
//               }
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }









// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:facesbyplaces/API/BLM/api-39-blm-show-original-post.dart';
// import 'package:facesbyplaces/Configurations/date-conversion.dart';
// import 'package:facesbyplaces/Configurations/size_configuration.dart';
// import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-15-blm-dropdown.dart';
// import 'package:flutter_share/flutter_share.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:flutter/material.dart';

// class HomeBLMViewComments extends StatefulWidget{
//   final int postId;
//   HomeBLMViewComments({this.postId});

//   @override
//   HomeBLMViewCommentsState createState() => HomeBLMViewCommentsState(postId: postId);
// }

// class HomeBLMViewCommentsState extends State<HomeBLMViewComments>{
//   final int postId;
//   HomeBLMViewCommentsState({this.postId});

//   Future showOriginalPost;

//   void initState(){
//     super.initState();
//     showOriginalPost = getOriginalPost(postId);
//   }

//   Future<APIBLMShowOriginalPostMainMain> getOriginalPost(postId) async{
//     return await apiBLMShowOriginalPost(postId);
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
//           body: Container(
//             padding: EdgeInsets.all(5.0),
//             child: FutureBuilder<APIBLMShowOriginalPostMainMain>(
//               future: showOriginalPost,
//               builder: (context, originalPost){
//                 if(originalPost.hasData){
//                   return Container(
//                     padding: EdgeInsets.only(left: 10.0, right: 10.0,),
//                     decoration: BoxDecoration(
//                       color: Color(0xffffffff),
//                       borderRadius: BorderRadius.all(Radius.circular(15),),
//                       boxShadow: <BoxShadow>[
//                         BoxShadow(
//                           color: Colors.grey.withOpacity(0.5),
//                           spreadRadius: 1,
//                           blurRadius: 5,
//                           offset: Offset(0, 0)
//                         ),
//                       ],
//                     ),
//                     child: Column(
//                       children: [
//                         Container(
//                           height: SizeConfig.blockSizeVertical * 10,
//                           child: Row(
//                             children: [
//                               GestureDetector(
//                                 onTap: () async{
                                  
//                                 },
//                                 child: CircleAvatar(backgroundColor: Color(0xff888888), backgroundImage: originalPost.data.post.page.profileImage != null ? NetworkImage(originalPost.data.post.page.profileImage) : AssetImage('assets/icons/graveyard.png')),
//                               ),
//                               Expanded(
//                                 child: Container(
//                                   padding: EdgeInsets.only(left: 10.0),
//                                   child: Column(
//                                     children: [
//                                       Expanded(
//                                         child: Align(alignment: Alignment.bottomLeft,
//                                           child: Text(originalPost.data.post.page.name,
//                                             overflow: TextOverflow.ellipsis,
//                                             style: TextStyle(
//                                               fontSize: SizeConfig.safeBlockHorizontal * 4,
//                                               fontWeight: FontWeight.bold,
//                                               color: Color(0xff000000),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                       Expanded(
//                                         child: Align(
//                                           alignment: Alignment.topLeft,
//                                           child: Text(convertDate(originalPost.data.post.createAt),
//                                             maxLines: 1,
//                                             style: TextStyle(
//                                               fontSize: SizeConfig.safeBlockHorizontal * 3,
//                                               fontWeight: FontWeight.w400,
//                                               color: Color(0xffaaaaaa)
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                               MiscBLMDropDownTemplate(userId: originalPost.data.post.page.id, postId: postId,),
//                             ],
//                           ),
//                         ),

//                         Expanded(
//                           child: Align(
//                             alignment: Alignment.centerLeft,
//                             child: Column(
//                               children: [
//                                 Container(alignment: Alignment.centerLeft, child: Text(originalPost.data.post.body),),

//                                 SizedBox(height: SizeConfig.blockSizeVertical * 2,),

//                                 Expanded(
//                                   child: Container(
//                                     child: ((){
//                                       if(originalPost.data.post.imagesOrVideos != null){
//                                         return Container(
//                                           child: CachedNetworkImage(
//                                             fit: BoxFit.cover,
//                                             imageUrl: originalPost.data.post.page.imagesOrVideos[0],
//                                             placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
//                                             errorWidget: (context, url, error) => Center(child: Icon(Icons.error),),
//                                           ),
//                                         );
//                                       }else{
//                                         return Container(height: 0,);
//                                       }
//                                     }()),
//                                   ),
//                                 ),

//                               ],
//                             ),
//                           ),
//                         ),

//                         Container(
//                           height: SizeConfig.blockSizeVertical * 10,
//                           child: Row(
//                             children: [
//                               GestureDetector(
//                                 onTap: (){},
//                                 child: Row(
//                                   children: [
//                                     Image.asset('assets/icons/peace_logo.png', width: SizeConfig.blockSizeHorizontal * 5, height: SizeConfig.blockSizeVertical * 5,),

//                                     SizedBox(width: SizeConfig.blockSizeHorizontal * 1,),

//                                     Text('0', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),),
//                                   ],
//                                 ),
//                               ),

//                               SizedBox(width: SizeConfig.blockSizeHorizontal * 2,),

//                               GestureDetector(
//                                 onTap: (){},
//                                 child: Row(
//                                   children: [
//                                     Image.asset('assets/icons/comment_logo.png', width: SizeConfig.blockSizeHorizontal * 5, height: SizeConfig.blockSizeVertical * 5,),

//                                     SizedBox(width: SizeConfig.blockSizeHorizontal * 1,),

//                                     Text('0', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),),
//                                   ],
//                                 ),
//                               ),
//                               Expanded(
//                                 child: GestureDetector(
//                                   onTap: () async{
//                                     await FlutterShare.share(
//                                       title: 'Share',
//                                       text: 'Share the link',
//                                       linkUrl: 'https://flutter.dev/',
//                                       chooserTitle: 'Share link'
//                                     );
//                                   },
//                                   child: Align(alignment: Alignment.centerRight, child: Image.asset('assets/icons/share_logo.png', width: SizeConfig.blockSizeHorizontal * 13, height: SizeConfig.blockSizeVertical * 13,),),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),

//                       ],
//                     ),
//                   );
//                 }else if(originalPost.hasError){
//                   return Container(child: Center(child: Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),),));
//                 }else{
//                   return Container(child: Center(child: Container(child: SpinKitThreeBounce(color: Color(0xff000000), size: 50.0,), color: Color(0xffffffff),),),);
//                 }
//               }
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }







// import 'package:facesbyplaces/API/Regular/02-Main/api-main-regular-02-show-user-information.dart';
// import 'package:facesbyplaces/API/Regular/12-Show-Post/api-show-post-regular-03-show-post-comments.dart';
// import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-02-regular-bottom-sheet.dart';
// import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-19-regular-empty-display.dart';
// import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-20-regular-reply.dart';
// import 'package:facesbyplaces/Configurations/size_configuration.dart';
// import 'package:facesbyplaces/Configurations/date-conversion.dart';
// import 'package:responsive_widgets/responsive_widgets.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';
// import 'package:loader_overlay/loader_overlay.dart';
// import 'package:flutter/material.dart';

// class RegularOriginalComment{
//   int commentId;
//   int postId;
//   int userId;
//   String commentBody;
//   String createdAt;
//   String firstName;
//   String lastName;
//   dynamic image;

//   RegularOriginalComment({this.commentId, this.postId, this.userId, this.commentBody, this.createdAt, this.firstName, this.lastName, this.image});
// }

// class RegularOriginalReply{
//   int commentId;
//   int postId;
//   int userId;
//   String commentBody;
//   String createdAt;
//   String firstName;
//   String lastName;
//   dynamic image;

//   RegularOriginalReply({this.commentId, this.postId, this.userId, this.commentBody, this.createdAt, this.firstName, this.lastName, this.image});
// }

// class HomeRegularShowCommentsList extends StatefulWidget{
//   final int postId;
//   final int numberOfLikes;
//   final int numberOfComments;
//   HomeRegularShowCommentsList({this.postId, this.numberOfLikes, this.numberOfComments});

//   @override
//   HomeRegularShowCommentsListState createState() => HomeRegularShowCommentsListState(postId: postId, numberOfLikes: numberOfLikes, numberOfComments: numberOfComments);
// }

// class HomeRegularShowCommentsListState extends State<HomeRegularShowCommentsList>{
//   final int postId;
//   final int numberOfLikes;
//   final int numberOfComments;
//   HomeRegularShowCommentsListState({this.postId, this.numberOfLikes, this.numberOfComments});

//   GlobalKey<MiscRegularBottomSheetCommentState> key1;
//   RefreshController refreshController = RefreshController(initialRefresh: true);
//   static TextEditingController controller = TextEditingController();
//   List<RegularOriginalComment> comments;
//   Future showOriginalPost;
//   int itemRemaining;
//   int page;
//   int count;
//   List<int> commentIds;
//   int page2;
//   static Future<APIRegularShowProfileInformation> currentUser;
//   // static String userImage;
//   // static String userImage = 'assets/icons/app-icon.png';

//   void initState(){
//     super.initState();
//     // userImage = 'assets/icons/app-icon.png';
//     key1 = GlobalKey<MiscRegularBottomSheetCommentState>();
//     itemRemaining = 1;
//     comments = [];
//     commentIds = [];
//     page = 1;
//     count = 0;
//     onLoading();
//     currentUser = getDrawerInformation();
//   }

//   void onRefresh() async{
//     await Future.delayed(Duration(milliseconds: 1000));
//     refreshController.refreshCompleted();
//   }

//   void onLoading() async{
//     if(itemRemaining != 0){
//       context.showLoaderOverlay();
//       var newValue = await apiRegularShowListOfComments(postId: postId, page: page);
//       context.hideLoaderOverlay();
//       itemRemaining = newValue.itemsRemaining;
//       count = count + newValue.commentsList.length;

//       for(int i = 0; i < newValue.commentsList.length; i++){
//         comments.add(
//           RegularOriginalComment(
//             commentId: newValue.commentsList[i].commentId,
//             postId: newValue.commentsList[i].postId,
//             userId: newValue.commentsList[i].user.userId,
//             commentBody: newValue.commentsList[i].commentBody,
//             createdAt: newValue.commentsList[i].createdAt,
//             firstName: newValue.commentsList[i].user.firstName,
//             lastName: newValue.commentsList[i].user.lastName,
//             image: newValue.commentsList[i].user.image,
//           ),    
//         );

//         commentIds.add(newValue.commentsList[i].commentId,);
//       }

//       if(mounted)
//       setState(() {});
//       page++;
      
//       refreshController.loadComplete();
//     }else{
//       refreshController.loadNoData();
//     }
//   }

//   // void onLoadingReplies() async{
//   //   if(itemRemaining != 0){
//   //     context.showLoaderOverlay();
//   //     var newValue = await apiRegularShowListOfReplies(commentId: commentId, page: page2);
//   //     context.hideLoaderOverlay();
//   //     itemRemaining = newValue.itemsRemaining;
//   //     count = count + newValue.commentsList.length;

//   //     for(int i = 0; i < newValue.commentsList.length; i++){
//   //       // comments.add(
//   //       //   RegularOriginalComment(
//   //       //     commentId: newValue.commentsList[i].commentId,
//   //       //     userId: newValue.commentsList[i].user.userId,
//   //       //     commentBody: newValue.commentsList[i].commentBody,
//   //       //     createdAt: newValue.commentsList[i].createdAt,
//   //       //     firstName: newValue.commentsList[i].user.firstName,
//   //       //     lastName: newValue.commentsList[i].user.lastName,
//   //       //     image: newValue.commentsList[i].user.image,
//   //       //   ),    
//   //       // );
//   //     }

//   //     if(mounted)
//   //     setState(() {});
//   //     page++;
      
//   //     refreshController.loadComplete();
//   //   }else{
//   //     refreshController.loadNoData();
//   //   }
//   // }

  

//   Future<APIRegularShowProfileInformation> getDrawerInformation() async{
//     return await apiRegularShowProfileInformation();
//   }

//   Widget bottomSheet = Padding(
//     padding: EdgeInsets.only(left: 20.0, right: 20.0,),
//     child: Row(
//       children: [
        
//         FutureBuilder<APIRegularShowProfileInformation>(
//           future: currentUser,
//           builder: (context, user){
//             if(user.hasData){
//               return CircleAvatar(backgroundColor: Color(0xff888888), backgroundImage: NetworkImage(user.data.image));
//             }else if(user.hasError){
//               return CircleAvatar(backgroundColor: Color(0xff888888), backgroundImage: AssetImage('assets/icons/app-icon.png'));
//             }
//             else{
//               return CircularProgressIndicator();
//             }
//           },
//         ),

//         Expanded(
//           child: Padding(
//             padding: EdgeInsets.all(10.0),
//             child: TextFormField(
//               controller: controller,
//               cursorColor: Color(0xff000000),
//               keyboardType: TextInputType.text,
//               decoration: InputDecoration(
//                 fillColor: Color(0xffBDC3C7),
//                 filled: true,
//                 labelText: 'Say something...',
//                 labelStyle: TextStyle(
//                   fontSize: 14,
//                   color: Color(0xffffffff),
//                 ),
//                 border: OutlineInputBorder(
//                   borderSide: BorderSide(
//                     color: Color(0xffBDC3C7),
//                   ),
//                   borderRadius: BorderRadius.all(Radius.circular(10)),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderSide: BorderSide(
//                     color: Color(0xffBDC3C7),
//                   ),
//                   borderRadius: BorderRadius.all(Radius.circular(10)),
//                 ),
//               ),
//             ),
//           ),
//         ),

//         GestureDetector(
//           onTap: (){
//             controller.clear();
//           },
//           child: Text('Post',
//             style: TextStyle(
//               fontSize: SizeConfig.safeBlockHorizontal * 4,
//               fontWeight: FontWeight.bold, 
//               color: Color(0xff000000),
//             ),
//           ),
//         ),
//       ],
//     ),
//   );

//   @override
//   Widget build(BuildContext context) {
//     SizeConfig.init(context);
//     ResponsiveWidgets.init(context,
//       height: SizeConfig.screenHeight,
//       width: SizeConfig.screenWidth,
//     );
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
//             title: Text('Comments', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xffffffff)),),
//             centerTitle: true,
//             leading: IconButton(
//               icon: Icon(Icons.arrow_back, color: Color(0xffffffff),), 
//               onPressed: (){
//                 Navigator.pop(context);
//               },
//             ),
//           ),
//           body: count != 0
//           ? Column(
//             children: [
//               Container(
//                 height: SizeConfig.blockSizeVertical * 5,
//                 padding: EdgeInsets.only(left: 10.0, right: 10.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [

//                     GestureDetector(
//                       onTap: () async{
                        
//                       },
//                       child: Row(
//                         children: [
//                           Icon(Icons.favorite_border_outlined, color: Color(0xff000000),),

//                           SizedBox(width: SizeConfig.blockSizeHorizontal * 1,),

//                           Text('$numberOfLikes', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),),

//                         ],
//                       ),
//                     ),

//                     SizedBox(width: SizeConfig.blockSizeHorizontal * 5,),

//                     GestureDetector(
//                       onTap: (){
                        
//                       },
//                       child: Row(
//                         children: [
//                           Icon(Icons.chat_bubble_outline_outlined, color: Color(0xff000000),),

//                           SizedBox(width: SizeConfig.blockSizeHorizontal * 1,),

//                           Text('$numberOfComments', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               Expanded(
//                 child: SmartRefresher(
//                   enablePullDown: false,
//                   enablePullUp: true,
//                   header: MaterialClassicHeader(),
//                   footer: CustomFooter(
//                     loadStyle: LoadStyle.ShowWhenLoading,
//                     builder: (BuildContext context, LoadStatus mode){
//                       Widget body;
//                       if(mode == LoadStatus.idle){
//                         body = Text('Pull up load', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
//                       }
//                       else if(mode == LoadStatus.loading){
//                         body = CircularProgressIndicator();
//                       }
//                       else if(mode == LoadStatus.failed){
//                         body = Text('Load Failed! Click retry!', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
//                       }
//                       else if(mode == LoadStatus.canLoading){
//                         body = Text('Release to load more', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
//                       }
//                       else{
//                         body = Text('End of conversation.', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
//                       }
//                       return Container(height: 55.0, child: Center(child: body),);
//                     },
//                   ),
//                   controller: refreshController,
//                   onRefresh: onRefresh,
//                   onLoading: onLoading,
//                   child: ListView.separated(
//                     padding: EdgeInsets.all(10.0),
//                     physics: ClampingScrollPhysics(),
//                     itemBuilder: (c, i) {
//                       return Column(
//                         children: [
//                           Container(
//                             height: SizeConfig.blockSizeVertical * 5,
//                             child: Row(
//                               children: [
//                                 CircleAvatar(
//                                   backgroundImage: comments[i].image != null ? NetworkImage(comments[i].image) : AssetImage('assets/icons/app-icon.png'),
//                                   backgroundColor: Color(0xff888888),
//                                 ),

//                                 SizedBox(width: SizeConfig.blockSizeHorizontal * 1,),

//                                 Expanded(
//                                   child: Text(comments[i].firstName.toString() + ' ' + comments[i].lastName.toString(),
//                                     style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ),

//                                 Icon(Icons.favorite_border_outlined, color: Color(0xffE74C3C),),

//                                 SizedBox(width: SizeConfig.blockSizeHorizontal * 1,),

//                                 Text('0', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),),

//                               ],
//                             ),
//                           ),

//                           Row(
//                             children: [
//                               SizedBox(width: SizeConfig.blockSizeHorizontal * 12,),

//                               Expanded(
//                                 child: Container(
//                                   padding: EdgeInsets.all(10.0),
//                                   child: Text(
//                                     comments[i].commentBody,
//                                     style: TextStyle(
//                                       color: Color(0xffffffff),
//                                     ),
//                                   ),
//                                   decoration: BoxDecoration(
//                                     color: Color(0xff4EC9D4),
//                                     borderRadius: BorderRadius.all(Radius.circular(10.0)),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),

//                           SizedBox(height: SizeConfig.blockSizeVertical * 1,),

//                           Row(
//                             children: [

//                               SizedBox(width: SizeConfig.blockSizeHorizontal * 12,),

//                               Text(convertDate(comments[i].createdAt)),

//                               SizedBox(width: SizeConfig.blockSizeHorizontal * 5,),

//                               Text('Reply',),

//                             ],
//                           ),

//                           SizedBox(height: SizeConfig.blockSizeVertical * 1,),

//                           Column(
//                             children: List.generate(3, (index) => 
//                               MiscRegularShowReply(
//                                 image: comments[i].image,
//                                 firstName: comments[i].firstName,
//                                 lastName: comments[i].lastName,
//                                 commentBody: comments[i].commentBody,
//                                 createdAt: comments[i].createdAt,
//                                 numberOfLikes: 1,
//                               ),
//                             ),
//                           ),

//                         ],
//                       );
//                     },
//                     separatorBuilder: (c, i) => Divider(height: SizeConfig.blockSizeVertical * 2, color: Colors.transparent),
//                     itemCount: comments.length,
//                   ),
//                 ),
//               ),
//             ],
//           )
//           : SingleChildScrollView(
//             physics: ClampingScrollPhysics(),
//             child: ContainerResponsive(
//             height: SizeConfig.screenHeight,
//             width: SizeConfig.screenWidth,
//             alignment: Alignment.center,
//             child: ContainerResponsive(
//               width: SizeConfig.screenWidth,
//               heightResponsive: false,
//               widthResponsive: true,
//               alignment: Alignment.center,
//               child: SingleChildScrollView(
//                 physics: ClampingScrollPhysics(),
//                 child: MiscRegularEmptyDisplayTemplate(message: 'Comment is empty',),
//               ),
//             ),
//           ),
//           ),
//         bottomSheet: bottomSheet,
//         ),
//       ),
//     );
//   }
// }







// import 'package:facesbyplaces/API/BLM/02-Main/api-main-blm-02-show-user-information.dart';
// import 'package:facesbyplaces/API/BLM/12-Show-Post/api-show-post-blm-03-show-post-comments.dart';
// import 'package:facesbyplaces/API/BLM/12-Show-Post/api-show-post-blm-04-show-comment-replies.dart';
// import 'package:facesbyplaces/API/BLM/12-Show-Post/api-show-post-blm-05-add-comment.dart';
// import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-16-blm-empty-display.dart';
// import 'package:facesbyplaces/Configurations/size_configuration.dart';
// import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
// import 'package:responsive_widgets/responsive_widgets.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';
// import 'package:loader_overlay/loader_overlay.dart';
// import 'package:timeago/timeago.dart' as timeago;
// import 'package:flutter/material.dart';

// class BLMOriginalComment{
//   int commentId;
//   int postId;
//   int userId;
//   String commentBody;
//   String createdAt;
//   String firstName;
//   String lastName;
//   dynamic image;
//   List<BLMOriginalReply> listOfReplies;

//   BLMOriginalComment({this.commentId, this.postId, this.userId, this.commentBody, this.createdAt, this.firstName, this.lastName, this.image, this.listOfReplies});
// }

// class BLMOriginalReply{
//   int replyId;
//   int commentId;
//   int userId;
//   String replyBody;
//   String createdAt;
//   String firstName;
//   String lastName;
//   dynamic image;

//   BLMOriginalReply({this.replyId, this.commentId, this.userId, this.replyBody, this.createdAt, this.firstName, this.lastName, this.image});
// }

// class HomeBLMShowCommentsList extends StatefulWidget{
//   final int postId;
//   final int userId;
//   final int numberOfLikes;
//   final int numberOfComments;
//   HomeBLMShowCommentsList({this.postId, this.userId, this.numberOfLikes, this.numberOfComments});

//   @override
//   HomeBLMShowCommentsListState createState() => HomeBLMShowCommentsListState(postId: postId, userId: userId, numberOfLikes: numberOfLikes, numberOfComments: numberOfComments);
// }

// class HomeBLMShowCommentsListState extends State<HomeBLMShowCommentsList>{
//   final int postId;
//   final int userId;
//   final int numberOfLikes;
//   final int numberOfComments;
//   HomeBLMShowCommentsListState({this.postId, this.userId, this.numberOfLikes, this.numberOfComments});

//   RefreshController refreshController = RefreshController(initialRefresh: true);
//   static TextEditingController controller = TextEditingController();
//   List<BLMOriginalComment> comments;
//   List<BLMOriginalReply> replies;
//   Future showOriginalPost;
//   int itemRemaining;
//   int repliesRemaining;
//   int page1;
//   int count;
//   int numberOfReplies;
//   int page2;
//   static Future<APIBLMShowProfileInformation> currentUser;
//   int replyToComment;
//   int replyToReply;
  

//   void initState(){
//     super.initState();
//     itemRemaining = 1;
//     repliesRemaining = 1;
//     comments = [];
//     replies = [];
//     numberOfReplies = 0;
//     page1 = 1;
//     page2 = 1;
//     count = 0;
//     replyToComment = 0;
//     replyToReply = 0;
//     onLoading();
//     currentUser = getDrawerInformation();
//   }

//   void onRefresh() async{
//     await Future.delayed(Duration(milliseconds: 1000));
//     refreshController.refreshCompleted();
//   }

//   void onLoading() async{
//     if(itemRemaining != 0){
//       context.showLoaderOverlay();
//       var newValue1 = await apiBLMShowListOfComments(postId: postId, page: page1);
//       context.hideLoaderOverlay();
//       itemRemaining = newValue1.itemsRemaining;
//       count = count + newValue1.commentsList.length;

//       for(int i = 0; i < newValue1.commentsList.length; i++){
//         print('The number of loops is $i');
//         if(repliesRemaining != 0){
//           context.showLoaderOverlay();
//           var newValue2 = await apiBLMShowListOfReplies(postId: newValue1.commentsList[i].commentId, page: page2);
//           context.hideLoaderOverlay();
//           // numberOfReplies = newValue2.repliesList.length;
//           print('The number of replies is ${newValue2.repliesList.length}');
//           for(int j = 0; j < newValue2.repliesList.length; j++){
//             replies.add(
//               BLMOriginalReply(
//                 replyId: newValue2.repliesList[j].replyId,
//                 commentId: newValue2.repliesList[j].commentId,
//                 userId: newValue2.repliesList[j].user.userId,
//                 replyBody: newValue2.repliesList[j].replyBody,
//                 // createdAt: timeago.format(DateTime.parse(newValue2.repliesList[j].createdAt)),
//                 createdAt: newValue2.repliesList[j].createdAt,
//                 firstName: newValue2.repliesList[j].user.firstName,
//                 lastName: newValue2.repliesList[j].user.lastName,
//                 image: newValue2.repliesList[j].user.image,
//               ),
//             );

//             print('The reply is ${newValue2.repliesList[j].replyBody}');
//           }

          

//           repliesRemaining = newValue2.itemsRemaining;
//           page2++;
//         }

//         repliesRemaining = 1;
//         page2 = 1;

        
        
//         comments.add(
//           BLMOriginalComment(
//             commentId: newValue1.commentsList[i].commentId,
//             postId: newValue1.commentsList[i].postId,
//             userId: newValue1.commentsList[i].user.userId,
//             commentBody: newValue1.commentsList[i].commentBody,
//             createdAt: newValue1.commentsList[i].createdAt,
//             firstName: newValue1.commentsList[i].user.firstName,
//             lastName: newValue1.commentsList[i].user.lastName,
//             image: newValue1.commentsList[i].user.image,
//             listOfReplies: replies
//           ),    
//         );

//         print('The length of replies is ${comments[i].listOfReplies.length}');

//         // print('The reply body is ${comments[i].listOfReplies[0].replyBody}');

//         // replies.clear();
//         replies = [];
      
//       }

      

//       if(mounted)
//       setState(() {});
//       page1++;
      
//       refreshController.loadComplete();
//     }else{
//       refreshController.loadNoData();
//     }
//   }

//   Future<APIBLMShowProfileInformation> getDrawerInformation() async{
//     return await apiBLMShowProfileInformation();
//   }

//   @override
//   Widget build(BuildContext context) {
//     SizeConfig.init(context);
//     ResponsiveWidgets.init(context,
//       height: SizeConfig.screenHeight,
//       width: SizeConfig.screenWidth,
//     );
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
//             title: Text('Comments', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xffffffff)),),
//             centerTitle: true,
//             leading: IconButton(
//               icon: Icon(Icons.arrow_back, color: Color(0xffffffff),), 
//               onPressed: (){
//                 controller.clear();
//                 Navigator.pop(context);
//               },
//             ),
//           ),
//           body: count != 0
//           ? Container(
//             height: SizeConfig.screenHeight - SizeConfig.blockSizeVertical * 13 - AppBar().preferredSize.height,
//             child: Column(
//             children: [
//               Container(
//                 height: SizeConfig.blockSizeVertical * 5,
//                 padding: EdgeInsets.only(left: 10.0, right: 10.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [

//                     GestureDetector(
//                       onTap: () async{
                        
//                       },
//                       child: Row(
//                         children: [
//                           Icon(Icons.favorite_border_outlined, color: Color(0xff000000),),

//                           SizedBox(width: SizeConfig.blockSizeHorizontal * 1,),

//                           Text('$numberOfLikes', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),),

//                         ],
//                       ),
//                     ),

//                     SizedBox(width: SizeConfig.blockSizeHorizontal * 5,),

//                     GestureDetector(
//                       onTap: (){
                        
//                       },
//                       child: Row(
//                         children: [
//                           Icon(Icons.chat_bubble_outline_outlined, color: Color(0xff000000),),

//                           SizedBox(width: SizeConfig.blockSizeHorizontal * 1,),

//                           Text('$numberOfComments', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               Expanded(
//                 child: SmartRefresher(
//                   enablePullDown: false,
//                   enablePullUp: true,
//                   header: MaterialClassicHeader(),
//                   footer: CustomFooter(
//                     loadStyle: LoadStyle.ShowWhenLoading,
//                     builder: (BuildContext context, LoadStatus mode){
//                       Widget body;
//                       if(mode == LoadStatus.idle){
//                         body = Text('Pull up load', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
//                       }
//                       else if(mode == LoadStatus.loading){
//                         body = CircularProgressIndicator();
//                       }
//                       else if(mode == LoadStatus.failed){
//                         body = Text('Load Failed! Click retry!', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
//                       }
//                       else if(mode == LoadStatus.canLoading){
//                         body = Text('Release to load more', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
//                       }
//                       else{
//                         body = Text('End of conversation.', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
//                       }
//                       return Container(height: 55.0, child: Center(child: body),);
//                     },
//                   ),
//                   controller: refreshController,
//                   onRefresh: onRefresh,
//                   onLoading: onLoading,
//                   child: ListView.separated(
//                     padding: EdgeInsets.all(10.0),
//                     physics: ClampingScrollPhysics(),
//                     itemBuilder: (c, i) {
//                       return Column(
//                         children: [
//                           Container(
//                             height: SizeConfig.blockSizeVertical * 5,
//                             child: Row(
//                               children: [
//                                 CircleAvatar(
//                                   backgroundImage: comments[i].image != null ? NetworkImage(comments[i].image) : AssetImage('assets/icons/app-icon.png'),
//                                   backgroundColor: Color(0xff888888),
//                                 ),

//                                 SizedBox(width: SizeConfig.blockSizeHorizontal * 1,),

//                                 userId == comments[i].userId
//                                 ? Expanded(
//                                   child: Text('You',
//                                     style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 )
//                                 : Expanded(
//                                   child: Text('${comments[i].firstName}' + ' ' + '${comments[i].lastName}',
//                                     style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ),

//                                 Icon(Icons.favorite_border_outlined, color: Color(0xffE74C3C),),

//                                 SizedBox(width: SizeConfig.blockSizeHorizontal * 1,),

//                                 Text('0', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),),

//                               ],
//                             ),
//                           ),

//                           Row(
//                             children: [
//                               SizedBox(width: SizeConfig.blockSizeHorizontal * 12,),

//                               Expanded(
//                                 child: Container(
//                                   padding: EdgeInsets.all(10.0),
//                                   child: Text(
//                                     comments[i].commentBody,
//                                     style: TextStyle(
//                                       color: Color(0xffffffff),
//                                     ),
//                                   ),
//                                   decoration: BoxDecoration(
//                                     color: Color(0xff4EC9D4),
//                                     borderRadius: BorderRadius.all(Radius.circular(10.0)),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),

//                           SizedBox(height: SizeConfig.blockSizeVertical * 1,),

//                           Row(
//                             children: [

//                               SizedBox(width: SizeConfig.blockSizeHorizontal * 12,),

//                               Text(timeago.format(DateTime.parse(comments[i].createdAt))),

//                               SizedBox(width: SizeConfig.blockSizeHorizontal * 5,),

//                               GestureDetector(
//                                 onTap: (){
//                                   setState(() {
//                                     replyToComment = i;
//                                   });
//                                   print('The index of reply is $replyToComment');
//                                 },
//                                 child: Text('Reply',),
//                               ),

//                             ],
//                           ),

//                           SizedBox(height: SizeConfig.blockSizeVertical * 1,),

//                           comments[i].listOfReplies.length != 0
//                           ? Column(
//                               children: List.generate(comments[i].listOfReplies.length, (index) => 
//                               // MiscBLMShowReply(
//                               //   currentUserId: userId,
//                               //   userId: comments[i].listOfReplies[index].userId,
//                               //   image: comments[i].listOfReplies[index].image,
//                               //   firstName: comments[i].listOfReplies[index].firstName,
//                               //   lastName: comments[i].listOfReplies[index].lastName,
//                               //   commentBody: comments[i].listOfReplies[index].replyBody,
//                               //   createdAt: comments[i].listOfReplies[index].createdAt,
//                               //   numberOfLikes: 1,
//                               // ),

//                               Column(
//                                 children: [
//                                   Container(
//                                     height: SizeConfig.blockSizeVertical * 5,
//                                     child: Row(
//                                       children: [
//                                         SizedBox(width: SizeConfig.blockSizeHorizontal * 12,),

//                                         CircleAvatar(
//                                           backgroundImage: comments[i].listOfReplies[index].image != null ? NetworkImage(comments[i].listOfReplies[index].image) : AssetImage('assets/icons/app-icon.png'),
//                                           backgroundColor: Color(0xff888888),
//                                         ),

//                                         SizedBox(width: SizeConfig.blockSizeHorizontal * 1,),

//                                         userId == comments[i].listOfReplies[index].userId
//                                         ? Expanded(
//                                           child: Text('You',
//                                             style: TextStyle(
//                                               fontWeight: FontWeight.bold,
//                                             ),
//                                           ),
//                                         )
//                                         : Expanded(
//                                           child: Text(comments[i].listOfReplies[index].firstName + ' ' + comments[i].listOfReplies[index].lastName,
//                                             style: TextStyle(
//                                               fontWeight: FontWeight.bold,
//                                             ),
//                                           ),
//                                         ),

//                                         Icon(Icons.favorite_border_outlined, color: Color(0xffE74C3C),),

//                                         SizedBox(width: SizeConfig.blockSizeHorizontal * 1,),

//                                         Text('$numberOfLikes', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),),

//                                       ],
//                                     ),
//                                   ),

//                                   Row(
//                                     children: [
//                                       SizedBox(width: SizeConfig.blockSizeHorizontal * 24,),

//                                       Expanded(
//                                         child: Container(
//                                           padding: EdgeInsets.all(10.0),
//                                           child: Text(
//                                             comments[i].listOfReplies[index].replyBody,
//                                             style: TextStyle(
//                                               color: Color(0xffffffff),
//                                             ),
//                                           ),
//                                           decoration: BoxDecoration(
//                                             color: Color(0xff4EC9D4),
//                                             borderRadius: BorderRadius.all(Radius.circular(10.0)),
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),

//                                   SizedBox(height: SizeConfig.blockSizeVertical * 1,),

//                                   Row(
//                                     children: [

//                                       SizedBox(width: SizeConfig.blockSizeHorizontal * 24,),

//                                       // Text(convertDate(createdAt)),
//                                       Text(timeago.format(DateTime.parse(comments[i].listOfReplies[index].createdAt))),

//                                       SizedBox(width: SizeConfig.blockSizeHorizontal * 5,),

//                                       GestureDetector(
//                                         onTap: (){
//                                           setState(() {
//                                             replyToReply = index;
//                                           });
//                                           print('The index of reply is $replyToComment');
//                                         },
//                                         child: 
//                                         replyToReply == index
//                                         ? Text('Reply', style: TextStyle(fontWeight: FontWeight.bold),)
//                                         : Text('Reply',),
//                                       ),

//                                     ],
//                                   ),

//                                   SizedBox(height: SizeConfig.blockSizeVertical * 1,),

//                                 ],
//                               ),
//                             ),
//                           )
//                           : Container(
//                             height: 0,
//                           ),

//                         ],
//                       );
//                     },
//                     separatorBuilder: (c, i) => Divider(height: SizeConfig.blockSizeVertical * 2, color: Colors.transparent),
//                     itemCount: comments.length,
//                   ),
//                 ),
//               ),
//             ],
//           )
//           )
//           : SingleChildScrollView(
//             physics: ClampingScrollPhysics(),
//             child: ContainerResponsive(
//               height: SizeConfig.screenHeight,
//               width: SizeConfig.screenWidth,
//               alignment: Alignment.center,
//               child: ContainerResponsive(
//                 width: SizeConfig.screenWidth,
//                 heightResponsive: false,
//                 widthResponsive: true,
//                 alignment: Alignment.center,
//                 child: SingleChildScrollView(
//                   physics: ClampingScrollPhysics(),
//                   child: MiscBLMEmptyDisplayTemplate(message: 'Comment is empty',),
//                 ),
//               ),
//             ),
//           ),
//           bottomNavigationBar: Padding(
//             padding: EdgeInsets.only(left: 20.0, right: 20.0,),
//             child: Row(
//               children: [
                
//                 FutureBuilder<APIBLMShowProfileInformation>(
//                   future: currentUser,
//                   builder: (context, user){
//                     if(user.hasData){
//                       return CircleAvatar(backgroundColor: Color(0xff888888), backgroundImage: NetworkImage(user.data.image));
//                     }else if(user.hasError){
//                       return CircleAvatar(backgroundColor: Color(0xff888888), backgroundImage: AssetImage('assets/icons/app-icon.png'));
//                     }
//                     else{
//                       return CircularProgressIndicator();
//                     }
//                   },
//                 ),

//                 Expanded(
//                   child: Padding(
//                     padding: EdgeInsets.all(10.0),
//                     child: TextFormField(
//                       onTap: () async{
//                         await showMaterialModalBottomSheet(
//                           expand: true,
//                           context: context,
//                           builder: (context) => Container(
//                             padding: EdgeInsets.all(20.0),
//                             child: TextFormField(
//                               controller: controller,
//                               cursorColor: Color(0xff000000),
//                               keyboardType: TextInputType.text,
//                               maxLines: 10,
//                               decoration: InputDecoration(
//                                 // fillColor: Color(0xffBDC3C7),
//                                 // filled: true,
//                                 labelText: 'Say something...',
//                                 labelStyle: TextStyle(
//                                   fontSize: 14,
//                                   color: Color(0xffffffff),
//                                 ),
//                                 border: UnderlineInputBorder(
//                                   borderSide: BorderSide(
//                                     color: Colors.transparent,
//                                   ),
//                                 ),
//                                 focusedBorder: UnderlineInputBorder(
//                                   borderSide: BorderSide(
//                                     color: Colors.transparent,
//                                   ),
//                                 ),
//                                 enabledBorder: UnderlineInputBorder(
//                                   borderSide: BorderSide(
//                                     color: Colors.transparent,
//                                   ),
//                                 ),
//                                 // focusedBorder: OutlineInputBorder(
//                                 //   borderSide: BorderSide(
//                                 //     color: Color(0xffBDC3C7),
//                                 //   ),
//                                 //   borderRadius: BorderRadius.all(Radius.circular(10)),
//                                 // ),
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                       readOnly: true,
//                       controller: controller,
//                       cursorColor: Color(0xff000000),
//                       keyboardType: TextInputType.text,
//                       decoration: InputDecoration(
//                         fillColor: Color(0xffBDC3C7),
//                         filled: true,
//                         labelText: 'Say something...',
//                         labelStyle: TextStyle(
//                           fontSize: 14,
//                           color: Color(0xffffffff),
//                         ),
//                         border: OutlineInputBorder(
//                           borderSide: BorderSide(
//                             color: Color(0xffBDC3C7),
//                           ),
//                           borderRadius: BorderRadius.all(Radius.circular(10)),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderSide: BorderSide(
//                             color: Color(0xffBDC3C7),
//                           ),
//                           borderRadius: BorderRadius.all(Radius.circular(10)),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),

//                 GestureDetector(
//                   onTap: () async{

//                     print('The post id is $postId');
//                     print('The post id is ${controller.text}');

//                     context.showLoaderOverlay();
//                     bool result = await apiBLMAddComment(postId: postId, commentBody: controller.text);
//                     context.hideLoaderOverlay();

//                     controller.clear();

//                     itemRemaining = 1;
//                     repliesRemaining = 1;
//                     comments = [];
//                     replies = [];
//                     numberOfReplies = 0;
//                     page1 = 1;
//                     page2 = 1;
//                     count = 0;
//                     replyToComment = 0;
//                     replyToReply = 0;
//                     onLoading();

//                     print('The result is $result');

//                     onLoading();
//                   },
//                   child: Text('Post',
//                     style: TextStyle(
//                       fontSize: SizeConfig.safeBlockHorizontal * 4,
//                       fontWeight: FontWeight.bold, 
//                       color: Color(0xff000000),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }











// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// Future<APIRegularSearchMemorialMain> apiRegularSearchBLM(String keywords) async{

//   final sharedPrefs = await SharedPreferences.getInstance();
//   String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
//   String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
//   String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

//   final http.Response response = await http.get('http://fbp.dev1.koda.ws/api/v1/search/memorials?keywords=$keywords&page=blm',
//     headers: <String, String>{
//       'Content-Type': 'application/json',
//       'access-token': getAccessToken,
//       'uid': getUID,
//       'client': getClient,
//     }
//   );

//   if(response.statusCode == 200){
//     var newValue = json.decode(response.body);
//     return APIRegularSearchMemorialMain.fromJson(newValue);
//   }else{
//     throw Exception('Failed to get the memorials.');
//   }
// }

// class APIRegularSearchMemorialMain{
//   int itemsRemaining;
//   List<APIRegularSearchMemorialExtended> memorialList;

//   APIRegularSearchMemorialMain({this.itemsRemaining, this.memorialList});

//   factory APIRegularSearchMemorialMain.fromJson(Map<String, dynamic> parsedJson){

//     var memorialList = parsedJson['memorials'] as List;
//     List<APIRegularSearchMemorialExtended> newMemorialList = memorialList.map((e) => APIRegularSearchMemorialExtended.fromJson(e)).toList();

//     return APIRegularSearchMemorialMain(
//       itemsRemaining: parsedJson['itemsremaining'],
//       memorialList: newMemorialList,
//     );
//   }
// }


// class APIRegularSearchMemorialExtended{
//   int id;
//   String name;
//   APIRegularSearchMemorialExtendedPageDetails details;
//   dynamic backgroundImage;
//   dynamic profileImage;
//   dynamic imagesOrVideos;
//   String relationship;
//   APIRegularSearchMemorialExtendedPageCreator pageCreator;
//   bool managed;
//   bool follower;
//   String pageType;

//   APIRegularSearchMemorialExtended({this.id, this.name, this.details, this.backgroundImage, this.profileImage, this.imagesOrVideos, this.relationship, this.pageCreator, this.managed, this.follower, this.pageType});

//   factory APIRegularSearchMemorialExtended.fromJson(Map<String, dynamic> parsedJson){
//     return APIRegularSearchMemorialExtended(
//       id: parsedJson['id'],
//       name: parsedJson['name'],
//       details: APIRegularSearchMemorialExtendedPageDetails.fromJson(parsedJson['details']),
//       backgroundImage: parsedJson['backgroundImage'],
//       profileImage: parsedJson['profileImage'],
//       imagesOrVideos: parsedJson['imagesOrVideos'],
//       relationship: parsedJson['relationship'],
//       pageCreator: APIRegularSearchMemorialExtendedPageCreator.fromJson(parsedJson['page_creator']),
//       managed: parsedJson['manage'],
//       follower: parsedJson['follower'],
//       pageType: parsedJson['page_type'],
//     );
//   }
// }

// class APIRegularSearchMemorialExtendedPageDetails{
//   String description;
//   String birthPlace;
//   String dob;
//   String rip;
//   String cemetery;
//   String country;

//   APIRegularSearchMemorialExtendedPageDetails({this.description, this.birthPlace, this.dob, this.rip, this.cemetery, this.country});

//   factory APIRegularSearchMemorialExtendedPageDetails.fromJson(Map<String, dynamic> parsedJson){
//     return APIRegularSearchMemorialExtendedPageDetails(
//       description: parsedJson['description'],
//       birthPlace: parsedJson['birthplace'],
//       dob: parsedJson['dob'],
//       rip: parsedJson['rip'],
//       cemetery: parsedJson['cemetery'],
//       country: parsedJson['country'],
//     );
//   }
// }

// class APIRegularSearchMemorialExtendedPageCreator{
//   int id;
//   String firstName;
//   String lastName;
//   String phoneNumber;
//   String email;
//   String userName;
//   dynamic image;

//   APIRegularSearchMemorialExtendedPageCreator({this.id, this.firstName, this.lastName, this.phoneNumber, this.email, this.userName, this.image});

//   factory APIRegularSearchMemorialExtendedPageCreator.fromJson(Map<String, dynamic> parsedJson){
//     return APIRegularSearchMemorialExtendedPageCreator(
//       id: parsedJson['id'],
//       firstName: parsedJson['first_name'],
//       lastName: parsedJson['last_name'],
//       phoneNumber: parsedJson['phone_number'],
//       email: parsedJson['email'],
//       userName: parsedJson['username'],
//       image: parsedJson['image']
//     );
//   }
// }





// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// Future<APIBLMSearchMemorialMain> apiBLMSearchBLM(String keywords) async{

//   final sharedPrefs = await SharedPreferences.getInstance();
//   String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
//   String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
//   String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

//   final http.Response response = await http.get('http://fbp.dev1.koda.ws/api/v1/search/memorials?keywords=$keywords&page=blm',
//     headers: <String, String>{
//       'Content-Type': 'application/json',
//       'access-token': getAccessToken,
//       'uid': getUID,
//       'client': getClient,
//     }
//   );

//   print('The status code for blm search is ${response.statusCode}');
//   print('The status body for blm search is ${response.body}');

//   if(response.statusCode == 200){
//     var newValue = json.decode(response.body);
//     return APIBLMSearchMemorialMain.fromJson(newValue);
//   }else{
//     throw Exception('Failed to get the memorials.');
//   }
// }

// class APIBLMSearchMemorialMain{
//   int itemsRemaining;
//   List<APIBLMSearchMemorialExtended> memorialList;

//   APIBLMSearchMemorialMain({this.itemsRemaining, this.memorialList});

//   factory APIBLMSearchMemorialMain.fromJson(Map<String, dynamic> parsedJson){

//     print('Samplee!');

//     print('The item remaining is ${parsedJson['itemsremaining']}');
//     print('The memorials list is ${parsedJson['memorials']}');

//     var memorialList = parsedJson['memorials'] as List;
//     List<APIBLMSearchMemorialExtended> newMemorialList = memorialList.map((e) => APIBLMSearchMemorialExtended.fromJson(e)).toList();

//     print('Nicee!');

//     return APIBLMSearchMemorialMain(
//       itemsRemaining: parsedJson['itemsremaining'],
//       memorialList: newMemorialList,
//     );
//   }
// }


// class APIBLMSearchMemorialPage{
//   int id;
//   APIBLMSearchMemorialExtended page;

//   APIBLMSearchMemorialPage({this.id, this.page});

//   factory APIBLMSearchMemorialPage.fromJson(Map<String, dynamic> parsedJson){
//     return APIBLMSearchMemorialPage(
//       id: parsedJson['id'],
//       page: parsedJson['page'],
//     );
//   }
// }


// class APIBLMSearchMemorialExtended{
//   int id;
//   String name;
//   APIBLMSearchMemorialExtendedPageDetails details;
//   dynamic backgroundImage;
//   dynamic profileImage;
//   dynamic imagesOrVideos;
//   String relationship;
//   APIBLMSearchMemorialExtendedPageCreator pageCreator;
//   bool managed;
//   bool follower;

//   APIBLMSearchMemorialExtended({this.id, this.name, this.details, this.backgroundImage, this.profileImage, this.imagesOrVideos, this.relationship, this.pageCreator, this.managed, this.follower});

//   factory APIBLMSearchMemorialExtended.fromJson(Map<String, dynamic> parsedJson){
//     return APIBLMSearchMemorialExtended(
//       id: parsedJson['id'],
//       name: parsedJson['name'],
//       details: APIBLMSearchMemorialExtendedPageDetails.fromJson(parsedJson['details']),
//       backgroundImage: parsedJson['backgroundImage'],
//       profileImage: parsedJson['profileImage'],
//       imagesOrVideos: parsedJson['imagesOrVideos'],
//       relationship: parsedJson['relationship'],
//       pageCreator: APIBLMSearchMemorialExtendedPageCreator.fromJson(parsedJson['page_creator']),
//       managed: parsedJson['manage'],
//       follower: parsedJson['follower'],
//     );
//   }
// }

// class APIBLMSearchMemorialExtendedPageDetails{
//   String description;
//   String birthPlace;
//   String dob;
//   String rip;
//   String cemetery;
//   String country;

//   APIBLMSearchMemorialExtendedPageDetails({this.description, this.birthPlace, this.dob, this.rip, this.cemetery, this.country});

//   factory APIBLMSearchMemorialExtendedPageDetails.fromJson(Map<String, dynamic> parsedJson){
//     return APIBLMSearchMemorialExtendedPageDetails(
//       description: parsedJson['description'],
//       birthPlace: parsedJson['birthplace'],
//       dob: parsedJson['dob'],
//       rip: parsedJson['rip'],
//       cemetery: parsedJson['cemetery'],
//       country: parsedJson['country'],
//     );
//   }
// }

// class APIBLMSearchMemorialExtendedPageCreator{
//   int id;
//   String firstName;
//   String lastName;
//   String phoneNumber;
//   String email;
//   String userName;
//   dynamic image;

//   APIBLMSearchMemorialExtendedPageCreator({this.id, this.firstName, this.lastName, this.phoneNumber, this.email, this.userName, this.image});

//   factory APIBLMSearchMemorialExtendedPageCreator.fromJson(Map<String, dynamic> parsedJson){
//     return APIBLMSearchMemorialExtendedPageCreator(
//       id: parsedJson['id'],
//       firstName: parsedJson['first_name'],
//       lastName: parsedJson['last_name'],
//       phoneNumber: parsedJson['phone_number'],
//       email: parsedJson['email'],
//       userName: parsedJson['username'],
//       image: parsedJson['image']
//     );
//   }
// }



// import 'package:facesbyplaces/API/BLM/03-View-Memorial/api-view-memorial-blm-04-01-connection-list-family.dart';
// import 'package:facesbyplaces/API/BLM/03-View-Memorial/api-view-memorial-blm-04-02-connection-list-friends.dart';
// import 'package:facesbyplaces/API/BLM/03-View-Memorial/api-view-memorial-blm-04-03-connection-list-follower.dart';
// import 'package:facesbyplaces/Configurations/size_configuration.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';
// import 'package:loader_overlay/loader_overlay.dart';
// import 'package:flutter/material.dart';

// class BLMConnectionListItem{
//   final String firstName;
//   final String lastName;
//   final String image;

//   BLMConnectionListItem({this.firstName, this.lastName, this.image});
// }

// class HomeBLMConnectionList extends StatefulWidget{
//   final int memorialId;
//   final int newToggle;
//   HomeBLMConnectionList({this.memorialId, this.newToggle});

//   HomeBLMConnectionListState createState() => HomeBLMConnectionListState(memorialId: memorialId, newToggle: newToggle);
// }

// class HomeBLMConnectionListState extends State<HomeBLMConnectionList>{
//   final int memorialId;
//   final int newToggle;
//   HomeBLMConnectionListState({this.memorialId, this.newToggle});

  
//   RefreshController refreshController = RefreshController(initialRefresh: true);
//   List<BLMConnectionListItem> listsFamily;
//   List<BLMConnectionListItem> listsFriends;
//   List<BLMConnectionListItem> listsFollowers;
//   List<BLMConnectionListItem> searches;
//   bool onSearch;
//   Future connectionListFamily;
//   int itemRemaining1;
//   int itemRemaining2;
//   int itemRemaining3;
//   int page;
//   int toggle;

//   void onRefresh() async{
//     await Future.delayed(Duration(milliseconds: 1000));
//     refreshController.refreshCompleted();
//   }

//   void onLoading1() async{
//     if(itemRemaining1 != 0){

//       context.showLoaderOverlay();
//       var newValue = await apiBLMConnectionListFamily(memorialId, page);
//       context.hideLoaderOverlay();

//       itemRemaining1 = newValue.itemsRemaining;

//       for(int i = 0; i < newValue.familyList.length; i++){
//         listsFamily.add(
//           BLMConnectionListItem(
//             firstName: newValue.familyList[i].user.firstName,
//             lastName: newValue.familyList[i].user.lastName,
//             image: newValue.familyList[i].user.image,
//           ),    
//         );
//       }

//       if(mounted)
//       setState(() {});
      
//       refreshController.loadComplete();
      
//     }else{
//       refreshController.loadNoData();
//     }
//   }

//   void onLoading2() async{
//     if(itemRemaining2 != 0){
//       context.showLoaderOverlay();
//       var newValue = await apiBLMConnectionListFriends(memorialId, page);
//       context.hideLoaderOverlay();

//       itemRemaining2 = newValue.itemsRemaining;

//       for(int i = 0; i < newValue.friendsList.length; i++){
//         listsFriends.add(
//           BLMConnectionListItem(
//             firstName: newValue.friendsList[i].user.firstName,
//             lastName: newValue.friendsList[i].user.lastName,
//             image: newValue.friendsList[i].user.image,
//           ),    
//         );
//       }

//       if(mounted)
//       setState(() {});
      
//       refreshController.loadComplete();
      
//     }else{
//       refreshController.loadNoData();
//     }
//   }

//   void onLoading3() async{
//     if(itemRemaining3 != 0){
//       context.showLoaderOverlay();
//       var newValue = await apiBLMConnectionListFollowers(memorialId, page);
//       context.hideLoaderOverlay();

//       itemRemaining3 = newValue.itemsRemaining;

//       for(int i = 0; i < newValue.followersList.length; i++){
//         listsFriends.add(
//           BLMConnectionListItem(
//             firstName: newValue.followersList[i].user.firstName,
//             lastName: newValue.followersList[i].user.lastName,
//             image: newValue.followersList[i].user.image,
//           ),    
//         );
//       }

//       if(mounted)
//       setState(() {});
//       page++;
      
//       refreshController.loadComplete();
      
//     }else{
//       refreshController.loadNoData();
//     }
//   }

//   void initState(){
//     super.initState();
//     onLoading1();
//     onLoading2();
//     onLoading3();
//     toggle = newToggle;
//     listsFamily = [];
//     listsFriends = [];
//     listsFollowers = [];
//     searches = [];
//     onSearch = false;
//     itemRemaining1 = 1;
//     itemRemaining2 = 1;
//     itemRemaining3 = 1;
//     page = 1;
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
//             title: TextFormField(
//               onChanged: (search){
//                 if(toggle == 0){
//                   for(int i = 0; i < listsFamily.length; i++){
//                     if(listsFamily[i].firstName == search || listsFamily[i].lastName == search){
//                       searches.add(listsFamily[i]);
//                     }
//                   }
//                 }

//                 if(search == ''){
//                   setState(() {
//                     onSearch = false;
//                     searches = [];
//                   });
//                 }else{
//                   setState(() {
//                     onSearch = true;
//                   });
//                 }
//               },
//               decoration: InputDecoration(
//                 contentPadding: EdgeInsets.all(15.0),
//                 filled: true,
//                 fillColor: Color(0xffffffff),
//                 focusColor: Color(0xffffffff),
//                 hintText: ((){
//                   switch(toggle){
//                     case 0: return 'Search Family'; break;
//                     case 1: return 'Search Friends'; break;
//                     case 2: return 'Search Followers'; break;
//                   }
//                 }()),
//                 hintStyle: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4,),
//                 prefixIcon: Icon(Icons.search, color: Colors.grey),
//                 border: OutlineInputBorder(
//                   borderSide: BorderSide(color: Color(0xffffffff)),
//                   borderRadius: BorderRadius.all(Radius.circular(25)),
//                 ),
//                 enabledBorder:  OutlineInputBorder(
//                   borderSide: BorderSide(color: Color(0xffffffff)),
//                   borderRadius: BorderRadius.all(Radius.circular(25)),
//                 ),
//                 focusedBorder:  OutlineInputBorder(
//                   borderSide: BorderSide(color: Color(0xffffffff)),
//                   borderRadius: BorderRadius.all(Radius.circular(25)),
//                 ),
//               ),
//             ),
//             leading: IconButton(
//               icon: Icon(Icons.arrow_back, color: Color(0xffffffff),), 
//               onPressed: (){
//                 Navigator.pop(context);
//               },
//             ),
//             backgroundColor: Color(0xff04ECFF),
//           ),
//           body: Column(
//             children: [

//               Container(
//                 alignment: Alignment.center,
//                 width: SizeConfig.screenWidth,
//                 height: SizeConfig.blockSizeVertical * 8,
//                 color: Color(0xffffffff),
//                 child: DefaultTabController(
//                   initialIndex: toggle,
//                   length: 3,
//                   child: TabBar(
//                     labelColor: Color(0xff04ECFF),
//                     unselectedLabelColor: Color(0xff000000),
//                     indicatorColor: Color(0xff04ECFF),
//                     onTap: (int number){
//                       setState(() {
//                         toggle = number;
//                       });
//                     },
//                     tabs: [

//                       Center(
//                         child: Text('Family',
//                           style: TextStyle(
//                             fontSize: SizeConfig.safeBlockHorizontal * 4,
//                             fontWeight: FontWeight.w400,
//                           ),
//                         ),
//                       ),

//                       Center(child: Text('Friends',
//                           style: TextStyle(
//                             fontSize: SizeConfig.safeBlockHorizontal * 4,
//                             fontWeight: FontWeight.w400,
//                           ),
//                         ),
//                       ),

//                       Center(
//                         child: Text('Followers',
//                           style: TextStyle(
//                             fontSize: SizeConfig.safeBlockHorizontal * 4,
//                             fontWeight: FontWeight.w400,
//                           ),
//                         ),
//                       ),

//                     ],
//                   ),
//                 ),
//               ),

//               Expanded(
//                 child: ((){
//                   switch(toggle){
//                     case 0: return connectionListFamilyWidget(); break;
//                     case 1: return connectionListFriendsWidget(); break;
//                     case 2: return connectionListFollowersWidget(); break;
//                   }
//                 }()),
//               ),

//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   connectionListFamilyWidget(){
//     return Container(
//       child: SmartRefresher(
//         enablePullDown: false,
//         enablePullUp: true,
//         header: MaterialClassicHeader(),
//         footer: CustomFooter(
//           loadStyle: LoadStyle.ShowWhenLoading,
//           builder: (BuildContext context, LoadStatus mode){
//             Widget body;
//             if(mode == LoadStatus.idle){
//               body =  Text('Pull up load.', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
//             }
//             else if(mode == LoadStatus.loading){
//               body =  CircularProgressIndicator();
//             }
//             else if(mode == LoadStatus.failed){
//               body = Text('Load Failed! Please try again.', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
//             }
//             else if(mode == LoadStatus.canLoading){
//               body = Text('Release to load more.', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
//             }
//             else{
//               body = Text('No more list.', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
//             }
//             return Container(height: 55.0, child: Center(child: body),);
//           },
//         ),
//         controller: refreshController,
//         onRefresh: onRefresh,
//         onLoading: onLoading1,
//         child: Container(
//           padding: EdgeInsets.all(10.0),
//           child: GridView.count(
//             physics: ClampingScrollPhysics(),
//             crossAxisSpacing: 2,
//             mainAxisSpacing: 20,
//             crossAxisCount: 4,
//             children: List.generate(
//               onSearch ? searches.length : listsFamily.length, (index) => Column(
//                 children: [
//                   onSearch
//                   ? Expanded(
//                     child: CircleAvatar(
//                       radius: SizeConfig.blockSizeVertical * 5, 
//                       backgroundColor: Color(0xff888888),
//                       backgroundImage: ((){
//                         if(searches[index].image.toString() == '' || searches[index].image.toString() == null){
//                           // return AssetImage('assets/icons/graveyard.png');
//                           return AssetImage('assets/icons/app-icon.png');
//                           // child: CircleAvatar(backgroundColor: Color(0xff888888), backgroundImage: profileImage != null ? NetworkImage(profileImage) : AssetImage('assets/icons/app-icon.png')),
//                         }else{
//                           return CachedNetworkImageProvider(
//                             searches[index].image.toString(),
//                             scale: 1.0,
//                           );
//                         }
//                       }()),
//                     ),

//                     // child: CircleAvatar(backgroundColor: Color(0xff888888), backgroundImage: searches[index].image.toString() != null || searches[index].image.toString() == '' ? NetworkImage(searches[index].image.toString()) : AssetImage('assets/icons/app-icon.png')),
//                   )
//                   : Expanded(
//                     child: CircleAvatar(
//                       radius: SizeConfig.blockSizeVertical * 5, 
//                       backgroundColor: Color(0xff888888),
//                       backgroundImage: ((){
//                         if(listsFamily[index].image.toString() == '' || listsFamily[index].image.toString() == null){
//                           return AssetImage('assets/icons/graveyard.png');
//                         }else{
//                           return CachedNetworkImageProvider(
//                             listsFamily[index].image.toString(),
//                             scale: 1.0,
//                           );
//                         }
//                       }()),
//                     ),
//                     // child: CircleAvatar(backgroundColor: Color(0xff888888), backgroundImage: searches[index].image.toString() != null || searches[index].image.toString() == '' ? NetworkImage(searches[index].image.toString()) : AssetImage('assets/icons/app-icon.png')),
//                   ),

//                   onSearch
//                   ? Text(searches[index].firstName.toString() + ' ' + searches[index].lastName.toString(), textAlign: TextAlign.center, overflow: TextOverflow.clip, maxLines: 1, style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 3.5))
//                   : Text(listsFamily[index].firstName.toString() + ' ' + listsFamily[index].lastName.toString(), textAlign: TextAlign.center, overflow: TextOverflow.clip, maxLines: 1, style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 3.5)),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       )
//     );
//   }

//   connectionListFriendsWidget(){
//     return Container(
//       child: SmartRefresher(
//         enablePullDown: false,
//         enablePullUp: true,
//         header: MaterialClassicHeader(),
//         footer: CustomFooter(
//           loadStyle: LoadStyle.ShowWhenLoading,
//           builder: (BuildContext context, LoadStatus mode){
//             Widget body;
//             if(mode == LoadStatus.idle){
//               body =  Text('Pull up load.', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
//             }
//             else if(mode == LoadStatus.loading){
//               body =  CircularProgressIndicator();
//             }
//             else if(mode == LoadStatus.failed){
//               body = Text('Load Failed! Please try again.', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
//             }
//             else if(mode == LoadStatus.canLoading){
//               body = Text('Release to load more.', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
//               page++;
//             }
//             else{
//               body = Text('No more post.', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
//             }
//             return Container(height: 55.0, child: Center(child: body),);
//           },
//         ),
//         controller: refreshController,
//         onRefresh: onRefresh,
//         onLoading: onLoading2,
//         child: Container(
//           padding: EdgeInsets.all(10.0),
//           child: GridView.count(
//             physics: ClampingScrollPhysics(),
//             crossAxisSpacing: 2,
//             mainAxisSpacing: 20,
//             crossAxisCount: 4,
//             children: List.generate(
//               onSearch ? searches.length : listsFriends.length, (index) => Column(
//                 children: [
//                   onSearch
//                   ? Expanded(
//                     child: CircleAvatar(
//                       radius: SizeConfig.blockSizeVertical * 5, 
//                       backgroundColor: Color(0xff888888),
//                       backgroundImage: ((){
//                         if(searches[index].image.toString() == '' || searches[index].image.toString() == null){
//                           return AssetImage('assets/icons/graveyard.png');
//                         }else{
//                           return CachedNetworkImageProvider(
//                             searches[index].image.toString(),
//                             scale: 1.0,
//                           );
//                         }
//                       }()),
//                     ),
//                   )
//                   : Expanded(
//                     child: CircleAvatar(
//                       radius: SizeConfig.blockSizeVertical * 5, 
//                       backgroundColor: Color(0xff888888),
//                       backgroundImage: ((){
//                         if(listsFriends[index].image.toString() == '' || listsFriends[index].image.toString() == null){
//                           return AssetImage('assets/icons/graveyard.png');
//                         }else{
//                           return CachedNetworkImageProvider(
//                             listsFriends[index].image.toString(),
//                             scale: 1.0,
//                           );
//                         }
//                       }()),
//                     ),
//                   ),

//                   onSearch
//                   ? Text(searches[index].firstName.toString() + ' ' + searches[index].lastName.toString(), textAlign: TextAlign.center, overflow: TextOverflow.clip, maxLines: 1, style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 3.5))
//                   : Text(listsFriends[index].firstName.toString() + ' ' + listsFriends[index].lastName.toString(), textAlign: TextAlign.center, overflow: TextOverflow.clip, maxLines: 1, style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 3.5)),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       )
//     );
//   }

//   connectionListFollowersWidget(){
//     return Container(
//       child: SmartRefresher(
//         enablePullDown: false,
//         enablePullUp: true,
//         header: MaterialClassicHeader(),
//         footer: CustomFooter(
//           loadStyle: LoadStyle.ShowWhenLoading,
//           builder: (BuildContext context, LoadStatus mode){
//             Widget body;
//             if(mode == LoadStatus.idle){
//               body =  Text('Pull up load.', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
//             }
//             else if(mode == LoadStatus.loading){
//               body =  CircularProgressIndicator();
//             }
//             else if(mode == LoadStatus.failed){
//               body = Text('Load Failed! Please try again.', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
//             }
//             else if(mode == LoadStatus.canLoading){
//               body = Text('Release to load more.', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
//               page++;
//             }
//             else{
//               body = Text('No more post.', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
//             }
//             return Container(height: 55.0, child: Center(child: body),);
//           },
//         ),
//         controller: refreshController,
//         onRefresh: onRefresh,
//         onLoading: onLoading3,
//         child: Container(
//           padding: EdgeInsets.all(10.0),
//           child: GridView.count(
//             physics: ClampingScrollPhysics(),
//             crossAxisSpacing: 2,
//             mainAxisSpacing: 20,
//             crossAxisCount: 4,
//             children: List.generate(
//               onSearch ? searches.length : listsFriends.length, (index) => Column(
//                 children: [
//                   onSearch
//                   ? Expanded(
//                     child: CircleAvatar(
//                       radius: SizeConfig.blockSizeVertical * 5, 
//                       backgroundColor: Color(0xff888888),
//                       backgroundImage: ((){
//                         if(searches[index].image.toString() == '' || searches[index].image.toString() == null){
//                           return AssetImage('assets/icons/graveyard.png');
//                         }else{
//                           return CachedNetworkImageProvider(
//                             searches[index].image.toString(),
//                             scale: 1.0,
//                           );
//                         }
//                       }()),
//                     ),
//                   )
//                   : Expanded(
//                     child: CircleAvatar(
//                       radius: SizeConfig.blockSizeVertical * 5, 
//                       backgroundColor: Color(0xff888888),
//                       backgroundImage: ((){
//                         if(listsFollowers[index].image.toString() == '' || listsFollowers[index].image.toString() == null){
//                           return AssetImage('assets/icons/graveyard.png');
//                         }else{
//                           return CachedNetworkImageProvider(
//                             listsFollowers[index].image.toString(),
//                             scale: 1.0,
//                           );
//                         }
//                       }()),
//                     ),
//                   ),

//                   onSearch
//                   ? Text(searches[index].firstName.toString() + ' ' + searches[index].lastName.toString(), textAlign: TextAlign.center, overflow: TextOverflow.clip, maxLines: 1, style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 3.5))
//                   : Text(listsFollowers[index].firstName.toString() + ' ' + listsFollowers[index].lastName.toString(), textAlign: TextAlign.center, overflow: TextOverflow.clip, maxLines: 1, style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 3.5)),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       )
//     );
//   }

// }







// ================================================================================

// import 'package:facesbyplaces/API/BLM/08-Search/api-search-blm-01-search-posts.dart';
// import 'package:facesbyplaces/API/BLM/08-Search/api-search-blm-02-search-blm.dart';
// import 'package:facesbyplaces/API/BLM/08-Search/api-search-blm-03-search-nearby.dart';
// import 'package:facesbyplaces/API/BLM/08-Search/api-search-blm-04-search-suggested.dart';
// import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-04-blm-manage-memorial.dart';
// import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-05-blm-post.dart';
// import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-16-blm-empty-display.dart';
// import 'package:facesbyplaces/Configurations/size_configuration.dart';
// import 'package:timeago/timeago.dart' as timeago;
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';
// import 'package:flutter/material.dart';
// import 'package:responsive_widgets/responsive_widgets.dart';

// class BLMSearchMainPosts{
//   int userId;
//   int postId;
//   int memorialId;
//   String memorialName;
//   String timeCreated;
//   String postBody;
//   dynamic profileImage;
//   List<dynamic> imagesOrVideos;

//   bool managed;
//   bool joined;
//   int numberOfLikes;
//   int numberOfComments;
//   bool likeStatus;

//   int numberOfTagged;
//   List<String> taggedFirstName;
//   List<String> taggedLastName;
//   List<String> taggedImage;
//   List<int> taggedId;

//   BLMSearchMainPosts({this.userId, this.postId, this.memorialId, this.memorialName, this.timeCreated, this.postBody, this.profileImage, this.imagesOrVideos, this.managed, this.joined, this.numberOfLikes, this.numberOfComments, this.likeStatus, this.numberOfTagged, this.taggedFirstName, this.taggedLastName, this.taggedImage, this.taggedId});
// }

// class BLMSearchMainSuggested{
//   int memorialId;
//   String memorialName;
//   String memorialDescription;
//   bool managed;
//   bool joined;
//   String pageType;

//   BLMSearchMainSuggested({this.memorialId, this.memorialName, this.memorialDescription, this.managed, this.joined, this.pageType});
// }

// class BLMSearchMainNearby{
//   int memorialId;
//   String memorialName;
//   String memorialDescription;
//   bool managed;
//   bool joined;
//   String pageType;

//   BLMSearchMainNearby({this.memorialId, this.memorialName, this.memorialDescription, this.managed, this.joined, this.pageType});
// }

// class BLMSearchMainBLM{
//   int memorialId;
//   String memorialName;
//   String memorialDescription;
//   bool managed;
//   bool joined;
//   String pageType;

//   BLMSearchMainBLM({this.memorialId, this.memorialName, this.memorialDescription, this.managed, this.joined, this.pageType});
// }


// class HomeBLMPost extends StatefulWidget{
//   final String keyword;
//   final int newToggle;
//   final double latitude;
//   final double longitude;
//   final String currentLocation;
//   HomeBLMPost({this.keyword, this.newToggle, this.latitude, this.longitude, this.currentLocation});

//   HomeBLMPostState createState() => HomeBLMPostState(keyword: keyword, newToggle: newToggle, latitude: latitude, longitude: longitude, currentLocation: currentLocation);
// }

// class HomeBLMPostState extends State<HomeBLMPost>{
//   final String keyword;
//   final int newToggle;
//   final double latitude;
//   final double longitude;
//   final String currentLocation;
//   HomeBLMPostState({this.keyword, this.newToggle, this.latitude, this.longitude, this.currentLocation});

  
//   RefreshController refreshController = RefreshController(initialRefresh: true);
//   List<BLMSearchMainPosts> feeds = [];
//   List<BLMSearchMainSuggested> suggested = [];
//   List<BLMSearchMainNearby> nearby = [];
//   List<BLMSearchMainBLM> blm = [];
//   int postItemRemaining = 1;
//   int suggestedItemRemaining = 1;
//   int nearbyBlmItemsRemaining = 1;
//   int nearbyMemorialItemsRemaining = 1;
//   int blmItemRemaining = 1;
//   int page1 = 1;
//   int page2 = 1;
//   int page3 = 1;
//   int page4 = 1;
//   int toggle;
//   int tabCount1 = 0;
//   int tabCount2 = 0;
//   int tabCount3 = 0;
//   int tabCount4 = 0;


//   void onRefresh() async{
//     await Future.delayed(Duration(milliseconds: 1000));
//     refreshController.refreshCompleted();
//   }

//   void onLoading1() async{

//     if(postItemRemaining != 0){
//       var newValue = await apiBLMSearchPosts(keyword, page1);
//       postItemRemaining = newValue.itemsRemaining;
//       tabCount1 = tabCount1 + newValue.familyMemorialList.length;

//       List<String> newList1 = [];
//       List<String> newList2 = [];
//       List<String> newList3 = [];
//       List<int> newList4 = [];


//       for(int i = 0; i < newValue.familyMemorialList.length; i++){
//         for(int j = 0; j < newValue.familyMemorialList[i].postTagged.length; j++){
//           newList1.add(newValue.familyMemorialList[i].postTagged[j].taggedFirstName);
//           newList2.add(newValue.familyMemorialList[i].postTagged[j].taggedLastName);
//           newList3.add(newValue.familyMemorialList[i].postTagged[j].taggedImage);
//           newList4.add(newValue.familyMemorialList[i].postTagged[j].taggedId);
//         }

//         feeds.add(BLMSearchMainPosts(
//           userId: newValue.familyMemorialList[i].page.pageCreator.id, 
//           postId: newValue.familyMemorialList[i].id,
//           memorialId: newValue.familyMemorialList[i].page.id,
//           timeCreated: newValue.familyMemorialList[i].createAt,
//           memorialName: newValue.familyMemorialList[i].page.name,
//           postBody: newValue.familyMemorialList[i].body,
//           profileImage: newValue.familyMemorialList[i].page.profileImage,
//           imagesOrVideos: newValue.familyMemorialList[i].imagesOrVideos,

//           managed: newValue.familyMemorialList[i].page.manage,
//           joined: newValue.familyMemorialList[i].page.follower,
//           numberOfComments: newValue.familyMemorialList[i].numberOfComments,
//           numberOfLikes: newValue.familyMemorialList[i].numberOfLikes,
//           likeStatus: newValue.familyMemorialList[i].likeStatus,

//           numberOfTagged: newValue.familyMemorialList[i].postTagged.length,
//           taggedFirstName: newList1,
//           taggedLastName: newList2,
//           taggedImage: newList3,
//           taggedId: newList4,
//           ),    
//         );
//       }

//       if(mounted)
//       setState(() {});
//       page1++;
      
//       refreshController.loadComplete();
//     }else{
//       refreshController.loadNoData();
//     }
//   }

//   void onLoading2() async{
//     if(suggestedItemRemaining != 0){
//       var newValue = await apiBLMSearchSuggested(page2);
//       suggestedItemRemaining = newValue.itemsRemaining;
//       tabCount2 = tabCount2 + newValue.pages.length;

//       for(int i = 0; i < newValue.pages.length; i++){
//         suggested.add(BLMSearchMainSuggested(
//           memorialId: newValue.pages[i].page.id,
//           memorialName: newValue.pages[i].page.name,
//           memorialDescription: newValue.pages[i].page.details.description,
//           joined: newValue.pages[i].page.follower,

//           managed: newValue.pages[i].page.managed,
//           pageType: newValue.pages[i].page.pageType,
//           ),    
//         );
//       }

//       if(mounted)
//       setState(() {});
//       page2++;
      
//       refreshController.loadComplete();
//     }else{
//       refreshController.loadNoData();
//     }
//   }
 
//   void onLoading3() async{

//     if(nearbyBlmItemsRemaining != 0){
//       var newValue = await apiBLMSearchNearby(page3, latitude, longitude);
//       nearbyBlmItemsRemaining = newValue.blmItemsRemaining;
//       tabCount3 = tabCount3 + newValue.blmList.length;

//       for(int i = 0; i < newValue.blmList.length; i++){
//         nearby.add(BLMSearchMainNearby(
//           memorialId: newValue.blmList[i].id,
//           memorialName: newValue.blmList[i].name,
//           memorialDescription: newValue.blmList[i].details.description,
//           joined: newValue.blmList[i].follower,

//           managed: newValue.blmList[i].managed,
//           pageType: newValue.blmList[i].pageType,
//           ),    
//         );
//       }

//       if(mounted)
//       setState(() {});
//       page3++;
      
//       refreshController.loadComplete();
//     }
//     else if(nearbyMemorialItemsRemaining != 0){
//       var newValue = await apiBLMSearchNearby(page3, latitude, longitude);
//       nearbyMemorialItemsRemaining = newValue.memorialItemsRemaining;
//       tabCount3 = tabCount3 + newValue.memorialList.length;

//       for(int i = 0; i < newValue.memorialList.length; i++){
//         nearby.add(BLMSearchMainNearby(
//           memorialId: newValue.memorialList[i].id,
//           memorialName: newValue.memorialList[i].name,
//           memorialDescription: newValue.memorialList[i].details.description,
//           joined: newValue.blmList[i].follower,

//           managed: newValue.blmList[i].managed,
//           pageType: newValue.blmList[i].pageType,
//           ),    
//         );
//       }

//       if(mounted)
//       setState(() {});
//       page3++;
      
//       refreshController.loadComplete();
//     }
//     else{
//       refreshController.loadNoData();
//     }
//   } 

//   void onLoading4() async{
//     if(blmItemRemaining != 0){
//       var newValue = await apiBLMSearchBLM(keyword);
//       blmItemRemaining = newValue.itemsRemaining;
//       tabCount4 = tabCount4 + newValue.memorialList.length;

//       for(int i = 0; i < newValue.memorialList.length; i++){
//         blm.add(BLMSearchMainBLM(
//           memorialId: newValue.memorialList[i].id,
//           // memorialName: newValue.memorialList[i].name,
//           // memorialDescription: newValue.memorialList[i].details.description,
//           // joined: newValue.memorialList[i].follower,
//           memorialName: newValue.memorialList[i].page.name,
//           memorialDescription: newValue.memorialList[i].page.details.description,
//           joined: newValue.memorialList[i].page.follower,
//           managed: newValue.memorialList[i].page.managed,
//           pageType: newValue.memorialList[i].page.pageType,
//           ),    
//         );
//       }

//       if(mounted)
//       setState(() {});
//       page4++;
      
//       refreshController.loadComplete();
//     }else{
//       refreshController.loadNoData();
//     }
//   }

//   void initState(){
//     super.initState();
//     toggle = newToggle;
//     onLoading1();
//     onLoading2();
//     onLoading3();
//     onLoading4();
//   }

//   @override
//   Widget build(BuildContext context) {
//     SizeConfig.init(context);
//     ResponsiveWidgets.init(context,
//       height: SizeConfig.screenHeight,
//       width: SizeConfig.screenWidth,
//     );
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
//             title: TextFormField(
//               onChanged: (search){
                
//               },
//               decoration: InputDecoration(
//                 contentPadding: EdgeInsets.all(15.0),
//                 filled: true,
//                 fillColor: Color(0xffffffff),
//                 focusColor: Color(0xffffffff),
//                 hintText: 'Search Memorial',
//                 hintStyle: TextStyle(
//                   // fontSize: SizeConfig.safeBlockHorizontal * 4,
//                   fontSize: ScreenUtil().setSp(14, allowFontScalingSelf: true),
//                 ),
//                 prefixIcon: Icon(Icons.search, color: Colors.grey),
//                 border: OutlineInputBorder(
//                   borderSide: BorderSide(color: Color(0xffffffff)),
//                   borderRadius: BorderRadius.all(Radius.circular(25)),
//                 ),
//                 enabledBorder:  OutlineInputBorder(
//                   borderSide: BorderSide(color: Color(0xffffffff)),
//                   borderRadius: BorderRadius.all(Radius.circular(25)),
//                 ),
//                 focusedBorder:  OutlineInputBorder(
//                   borderSide: BorderSide(color: Color(0xffffffff)),
//                   borderRadius: BorderRadius.all(Radius.circular(25)),
//                 ),
//               ),
//             ),
//             leading: IconButton(
//               icon: Icon(Icons.arrow_back, color: Color(0xffffffff),), 
//               onPressed: (){
//                 Navigator.pop(context);
//               },
//             ),
//             backgroundColor: Color(0xff04ECFF),
//           ),
//           body: Container(
//             decoration: BoxDecoration(image: DecorationImage(fit: BoxFit.cover, image: AssetImage('assets/icons/background2.png'), colorFilter: ColorFilter.srgbToLinearGamma(),),),
//             child: Column(
//               children: [

//                 Container(
//                   alignment: Alignment.center,
//                   width: SizeConfig.screenWidth,
//                   // height: SizeConfig.blockSizeVertical * 8,
//                   height: ScreenUtil().setHeight(55),
//                   color: Color(0xffffffff),
//                   child: DefaultTabController(
//                     length: 4,
//                     child: TabBar(
//                       isScrollable: true,
//                       labelColor: Color(0xff04ECFF),
//                       unselectedLabelColor: Color(0xff000000),
//                       indicatorColor: Color(0xff04ECFF),
//                       onTap: (int number){
//                         setState(() {
//                           toggle = number;
//                         });
//                       },
//                       tabs: [

//                         Center(
//                           child: Text('Post',
//                             style: TextStyle(
//                               // fontSize: SizeConfig.safeBlockHorizontal * 4,
//                               fontSize: ScreenUtil().setSp(14, allowFontScalingSelf: true),
//                               fontWeight: FontWeight.w400,
//                             ),
//                           ),
//                         ),

//                         Center(
//                           child: Text('Suggested',
//                             style: TextStyle(
//                               // fontSize: SizeConfig.safeBlockHorizontal * 4,
//                               fontSize: ScreenUtil().setSp(14, allowFontScalingSelf: true),
//                               fontWeight: FontWeight.w400,
//                             ),
//                           ),
//                         ),

//                         Center(
//                           child: Text('Nearby',
//                             style: TextStyle(
//                               // fontSize: SizeConfig.safeBlockHorizontal * 4,
//                               fontSize: ScreenUtil().setSp(14, allowFontScalingSelf: true),
//                               fontWeight: FontWeight.w400,
//                             ),
//                           ),
//                         ),

//                         Center(
//                           child: Text('BLM',
//                             style: TextStyle(
//                               // fontSize: SizeConfig.safeBlockHorizontal * 4,
//                               fontSize: ScreenUtil().setSp(14, allowFontScalingSelf: true),
//                               fontWeight: FontWeight.w400,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),

//                 Container(
//                   child: ((){
//                     switch(toggle){
//                       case 0: return Container(height: SizeConfig.blockSizeVertical * 2,); break;
//                       case 1: return Container(height: SizeConfig.blockSizeVertical * 2,); break;
//                       case 2: return 
//                       Container(
//                         height: SizeConfig.blockSizeVertical * 5,
//                         child: Align(
//                           alignment: Alignment.centerLeft,
//                           child: Row(
//                             children: [
//                               SizedBox(width: SizeConfig.blockSizeHorizontal * 2,),

//                               Icon(Icons.location_pin, color: Color(0xff979797),),

//                               SizedBox(width: SizeConfig.blockSizeHorizontal * 2,),

//                               ((){
//                                 if(currentLocation != null || currentLocation != ''){
//                                   return Text(currentLocation, style: TextStyle(color: Color(0xff000000), fontSize: ScreenUtil().setSp(12, allowFontScalingSelf: true),),);
//                                 }else{
//                                   Text('', style: TextStyle(color: Color(0xff000000), fontSize: ScreenUtil().setSp(12, allowFontScalingSelf: true),),);
//                                 }
//                               }()),
//                             ],
//                           ),
//                         ),
//                       ); break;
//                       case 3: return 
//                       Container(
//                         height: SizeConfig.blockSizeVertical * 5,
//                         child: Align(
//                           alignment: Alignment.centerLeft,
//                           child: Row(
//                             children: [
//                               SizedBox(width: SizeConfig.blockSizeHorizontal * 2,),

//                               Icon(Icons.location_pin, color: Color(0xff979797),),

//                               SizedBox(width: SizeConfig.blockSizeHorizontal * 2,),

//                               ((){
//                                 if(currentLocation != null || currentLocation != ''){
//                                   return Text(currentLocation, style: TextStyle(color: Color(0xff000000), fontSize: ScreenUtil().setSp(12, allowFontScalingSelf: true),),);
//                                 }else{
//                                   Text('', style: TextStyle(color: Color(0xff000000), fontSize: ScreenUtil().setSp(12, allowFontScalingSelf: true),),);
//                                 }
//                               }()),
//                             ],
//                           ),
//                         ),
//                       ); break;
//                     }
//                   }()),
//                 ),

//                 Expanded(
//                   child: Container(
//                     child: ((){
//                       switch(toggle){
//                         case 0: return searchPostExtended(); break;
//                         case 1: return searchSuggestedExtended(); break;
//                         case 2: return searchNearbyExtended(); break;
//                         case 3: return searchBLMExtended(); break;
//                       }
//                     }()),
//                   ),
//                 ),

//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   searchPostExtended(){
//     return Container(
//       height: SizeConfig.screenHeight,
//       child: tabCount1 != 0
//       ? SmartRefresher(
//         enablePullDown: false,
//         enablePullUp: true,
//         header: MaterialClassicHeader(),
//         footer: CustomFooter(
//           loadStyle: LoadStyle.ShowWhenLoading,
//           builder: (BuildContext context, LoadStatus mode){
//             Widget body;
//             if(mode == LoadStatus.idle){
//               body =  Text('Pull up load', style: TextStyle(fontSize: ScreenUtil().setSp(14, allowFontScalingSelf: true), color: Color(0xff000000),),);
//             }
//             else if(mode == LoadStatus.loading){
//               body =  CircularProgressIndicator();
//             }
//             else if(mode == LoadStatus.failed){
//               body = Text('Load Failed! Click retry!', style: TextStyle(fontSize: ScreenUtil().setSp(14, allowFontScalingSelf: true), color: Color(0xff000000),),);
//             }
//             else if(mode == LoadStatus.canLoading){
//               body = Text('Release to load more', style: TextStyle(fontSize: ScreenUtil().setSp(14, allowFontScalingSelf: true), color: Color(0xff000000),),);
//             }
//             else{
//               body = Text('No more feed.', style: TextStyle(fontSize: ScreenUtil().setSp(14, allowFontScalingSelf: true), color: Color(0xff000000),),);
//             }
//             return Container(height: 55.0, child: Center(child: body),);
//           },
//         ),
//         controller: refreshController,
//         onRefresh: onRefresh,
//         onLoading: onLoading1,
//         child: ListView.separated(
//           padding: EdgeInsets.all(10.0),
//           physics: ClampingScrollPhysics(),
//           itemBuilder: (c, i) {
//             var container = MiscBLMPost(
//               userId: feeds[i].userId,
//               postId: feeds[i].postId,
//               memorialId: feeds[i].memorialId,
//               memorialName: feeds[i].memorialName,
//               // timeCreated: convertDate(feeds[i].timeCreated),
//               timeCreated: timeago.format(DateTime.parse(feeds[i].timeCreated)),

//               managed: feeds[i].managed,
//               joined: feeds[i].joined,
//               profileImage: feeds[i].profileImage,
//               numberOfComments: feeds[i].numberOfComments,
//               numberOfLikes: feeds[i].numberOfLikes,
//               likeStatus: feeds[i].likeStatus,

//               numberOfTagged: feeds[i].numberOfTagged,
//               taggedFirstName: feeds[i].taggedFirstName,
//               taggedLastName: feeds[i].taggedLastName,
//               taggedId: feeds[i].taggedId,
//               contents: [
//                 Column(
//                   children: [
//                     Align(
//                       alignment: Alignment.topLeft,
//                       child: RichText(
//                         maxLines: 4,
//                         overflow: TextOverflow.clip,
//                         textAlign: TextAlign.left,
//                         text: TextSpan(
//                           text: feeds[i].postBody,
//                           style: TextStyle(
//                             fontWeight: FontWeight.w300,
//                             color: Color(0xff000000),
//                           ),
//                         ),
//                       ),
//                     ),

//                     SizedBox(height: SizeConfig.blockSizeVertical * 1,),
//                   ],
//                 ),

//                 feeds[i].imagesOrVideos != null
//                 ? Container(
//                   height: SizeConfig.blockSizeHorizontal * 50,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.all(Radius.circular(5.0)),
//                   ),
//                   child: CachedNetworkImage(
//                     imageUrl: feeds[i].imagesOrVideos[0],
//                     placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
//                     errorWidget: (context, url, error) => Icon(Icons.error),
//                   ),
//                 )
//                 : Container(height: 0,),
//               ],
//             );

//             if(feeds.length != 0){
//               return container;
//             }else{
//               return Center(child: Text('Feed is empty.'),);
//             }
            
//           },
//           separatorBuilder: (c, i) => Divider(height: SizeConfig.blockSizeVertical * 2, color: Colors.transparent),
//           itemCount: feeds.length,
//         ),
//       )
//       // : MiscBLMEmptyDisplayTemplate(message: 'Post is empty',),

//       : ContainerResponsive(
//         height: SizeConfig.screenHeight,
//         width: SizeConfig.screenWidth,
//         alignment: Alignment.center,
//         child: ContainerResponsive(
//           width: SizeConfig.screenWidth,
//           // height: SizeConfig.screenHeight,
//           height: SizeConfig.screenHeight + ScreenUtil().setHeight(55),
//           heightResponsive: false,
//           widthResponsive: true,
//           alignment: Alignment.center,
//           child: SingleChildScrollView(
//             physics: ClampingScrollPhysics(),
//             child: MiscBLMEmptyDisplayTemplate(message: 'Post is empty',),
//           ),
//         ),
//       ),
//     );
//   }

//   searchSuggestedExtended(){
//     return Container(
//       height: SizeConfig.screenHeight,
//       child: tabCount2 != 0
//       ? SmartRefresher(
//         enablePullDown: false,
//         enablePullUp: true,
//         header: MaterialClassicHeader(),
//         footer: CustomFooter(
//           loadStyle: LoadStyle.ShowWhenLoading,
//           builder: (BuildContext context, LoadStatus mode){
//             Widget body;
//             if(mode == LoadStatus.idle){
//               body = Text('Pull up load', style: TextStyle(fontSize: ScreenUtil().setSp(14, allowFontScalingSelf: true), color: Color(0xff000000),),);
//             }
//             else if(mode == LoadStatus.loading){
//               body = CircularProgressIndicator();
//             }
//             else if(mode == LoadStatus.failed){
//               body = Text('Load Failed! Click retry!', style: TextStyle(fontSize: ScreenUtil().setSp(14, allowFontScalingSelf: true), color: Color(0xff000000),),);
//             }
//             else if(mode == LoadStatus.canLoading){
//               body = Text('Release to load more', style: TextStyle(fontSize: ScreenUtil().setSp(14, allowFontScalingSelf: true), color: Color(0xff000000),),);
//             }
//             else{
//               body = Text('No more feed.', style: TextStyle(fontSize: ScreenUtil().setSp(14, allowFontScalingSelf: true), color: Color(0xff000000),),);
//             }
//             return Container(height: 55.0, child: Center(child: body),);
//           },
//         ),
//         controller: refreshController,
//         onRefresh: onRefresh,
//         onLoading: onLoading2,
//         child: ListView.separated(
//           physics: ClampingScrollPhysics(),
//           itemBuilder: (c, i) {

//             var container = MiscBLMManageMemorialTab(
//               index: i,
//               memorialId: suggested[i].memorialId, 
//               memorialName: suggested[i].memorialName, 
//               description: suggested[i].memorialDescription,
//               managed: suggested[i].joined,
//               follower: suggested[i].joined,
//               pageType: suggested[i].pageType,
//             );

//             return container;
//           },
//           separatorBuilder: (c, i) => Divider(height: SizeConfig.blockSizeVertical * .5, color: Colors.transparent),
//           itemCount: suggested.length,
//         ),
//       )
//       // : MiscBLMEmptyDisplayTemplate(message: 'Suggested is empty',),
//       : ContainerResponsive(
//         height: SizeConfig.screenHeight,
//         width: SizeConfig.screenWidth,
//         alignment: Alignment.center,
//         child: ContainerResponsive(
//           width: SizeConfig.screenWidth,
//           // height: SizeConfig.screenHeight,
//           height: SizeConfig.screenHeight + ScreenUtil().setHeight(55),
//           heightResponsive: false,
//           widthResponsive: true,
//           alignment: Alignment.center,
//           child: SingleChildScrollView(
//             physics: ClampingScrollPhysics(),
//             child: MiscBLMEmptyDisplayTemplate(message: 'Suggested is empty',),
//           ),
//         ),
//       ),
//     );
//   }

//   searchNearbyExtended(){
//     return Container(
//       height: SizeConfig.screenHeight,
//       child: tabCount3 != 0
//       ? SmartRefresher(
//         enablePullDown: false,
//         enablePullUp: true,
//         header: MaterialClassicHeader(),
//         footer: CustomFooter(
//           loadStyle: LoadStyle.ShowWhenLoading,
//           builder: (BuildContext context, LoadStatus mode){
//             Widget body ;
//             if(mode == LoadStatus.idle){
//               body =  Text('Pull up load', style: TextStyle(fontSize: ScreenUtil().setSp(14, allowFontScalingSelf: true), color: Color(0xff000000),),);
//             }
//             else if(mode == LoadStatus.loading){
//               body =  CircularProgressIndicator();
//             }
//             else if(mode == LoadStatus.failed){
//               body = Text('Load Failed! Click retry!', style: TextStyle(fontSize: ScreenUtil().setSp(14, allowFontScalingSelf: true), color: Color(0xff000000),),);
//             }
//             else if(mode == LoadStatus.canLoading){
//               body = Text('Release to load more', style: TextStyle(fontSize: ScreenUtil().setSp(14, allowFontScalingSelf: true), color: Color(0xff000000),),);
//             }
//             else{
//               body = Text('No more feed.', style: TextStyle(fontSize: ScreenUtil().setSp(14, allowFontScalingSelf: true), color: Color(0xff000000),),);
//             }
//             return Container(height: 55.0, child: Center(child: body),);
//           },
//         ),
//         controller: refreshController,
//         onRefresh: onRefresh,
//         onLoading: onLoading3,
//         child: ListView.separated(
//           physics: ClampingScrollPhysics(),
//           itemBuilder: (c, i) {

//             var container = MiscBLMManageMemorialTab(
//               index: i,
//               memorialId: nearby[i].memorialId, 
//               memorialName: nearby[i].memorialName, 
//               description: nearby[i].memorialDescription,
//               managed: nearby[i].joined,
//             );

//             return container;
//           },
//           separatorBuilder: (c, i) => Divider(height: SizeConfig.blockSizeVertical * .5, color: Colors.transparent),
//           itemCount: nearby.length,
//         ),
//       )
//       // : MiscBLMEmptyDisplayTemplate(message: 'Nearby is empty',),
//       : ContainerResponsive(
//         height: SizeConfig.screenHeight,
//         width: SizeConfig.screenWidth,
//         alignment: Alignment.center,
//         child: ContainerResponsive(
//           width: SizeConfig.screenWidth,
//           // height: SizeConfig.screenHeight,
//           height: SizeConfig.screenHeight + ScreenUtil().setHeight(55),
//           heightResponsive: false,
//           widthResponsive: true,
//           alignment: Alignment.center,
//           child: SingleChildScrollView(
//             physics: ClampingScrollPhysics(),
//             child: MiscBLMEmptyDisplayTemplate(message: 'Nearby is empty',),
//           ),
//         ),
//       ),
//     );
//   }

//   searchBLMExtended(){
//     return Container(
//       height: SizeConfig.screenHeight,
//       child: tabCount4 != 0
//       ? SmartRefresher(
//         enablePullDown: false,
//         enablePullUp: true,
//         header: MaterialClassicHeader(),
//         footer: CustomFooter(
//           loadStyle: LoadStyle.ShowWhenLoading,
//           builder: (BuildContext context, LoadStatus mode){
//             Widget body;
//             if(mode == LoadStatus.idle){
//               body = Text('Pull up load', style: TextStyle(fontSize: ScreenUtil().setSp(14, allowFontScalingSelf: true), color: Color(0xff000000),),);
//             }
//             else if(mode == LoadStatus.loading){
//               body = CircularProgressIndicator();
//             }
//             else if(mode == LoadStatus.failed){
//               body = Text('Load Failed! Click retry!', style: TextStyle(fontSize: ScreenUtil().setSp(14, allowFontScalingSelf: true), color: Color(0xff000000),),);
//             }
//             else if(mode == LoadStatus.canLoading){
//               body = Text('Release to load more', style: TextStyle(fontSize: ScreenUtil().setSp(14, allowFontScalingSelf: true), color: Color(0xff000000),),);
//             }
//             else{
//               body = Text('No more feed.', style: TextStyle(fontSize: ScreenUtil().setSp(14, allowFontScalingSelf: true), color: Color(0xff000000),),);
//             }
//             return Container(height: 55.0, child: Center(child: body),);
//           },
//         ),
//         controller: refreshController,
//         onRefresh: onRefresh,
//         onLoading: onLoading4,
//         child: ListView.separated(
//           physics: ClampingScrollPhysics(),
//           itemBuilder: (c, i) {

//             var container = MiscBLMManageMemorialTab(
//               index: i,
//               memorialId: blm[i].memorialId, 
//               memorialName: blm[i].memorialName, 
//               description: blm[i].memorialDescription,
//             );

//             return container;
//           },
//           separatorBuilder: (c, i) => Divider(height: SizeConfig.blockSizeVertical * .5, color: Colors.transparent),
//           itemCount: blm.length,
//         ),
//       )
//       // : MiscBLMEmptyDisplayTemplate(message: 'BLM is empty',),
//       : ContainerResponsive(
//         height: SizeConfig.screenHeight,
//         width: SizeConfig.screenWidth,
//         alignment: Alignment.center,
//         child: ContainerResponsive(
//           width: SizeConfig.screenWidth,
//           // height: SizeConfig.screenHeight,
//           height: SizeConfig.screenHeight + ScreenUtil().setHeight(55),
//           heightResponsive: false,
//           widthResponsive: true,
//           alignment: Alignment.center,
//           child: SingleChildScrollView(
//             physics: ClampingScrollPhysics(),
//             child: MiscBLMEmptyDisplayTemplate(message: 'BLM is empty',),
//           ),
//         ),
//       ),
//     );
//   }
// }




// import 'package:facesbyplaces/API/BLM/02-Main/api-main-blm-05-leave-page.dart';
// import 'package:facesbyplaces/Configurations/size_configuration.dart';
// import 'package:facesbyplaces/UI/Home/BLM/02-View-Memorial/home-view-memorial-blm-01-managed-memorial.dart';
// import 'package:facesbyplaces/UI/Home/BLM/02-View-Memorial/home-view-memorial-blm-02-profile-memorial.dart';
// import 'package:facesbyplaces/UI/Home/Regular/02-View-Memorial/home-view-memorial-regular-02-profile-memorial.dart';
// import 'package:flutter/material.dart';
// import 'package:responsive_widgets/responsive_widgets.dart';
// import 'misc-02-blm-dialog.dart';

// class MiscBLMManageMemorialTab extends StatefulWidget{
//   // final int index;
//   // final String memorialName;
//   // final String description;
//   // final String image;
//   // final int memorialId;
//   // final bool managed;

//   // MiscBLMManageMemorialTab({
//   //   this.index, 
//   //   this.memorialName = '',
//   //   this.description = '',
//   //   this.image = 'assets/icons/graveyard.png',
//   //   this.memorialId,
//   //   this.managed,
//   // });


//   final int index;
//   final int tab;
//   final String memorialName;
//   final String description;
//   final String image;
//   final int memorialId;
//   final bool managed;
//   final bool follower;
//   final String pageType;
//   final String relationship;

//   MiscBLMManageMemorialTab({
//     this.index, 
//     this.tab,
//     this.memorialName = '',
//     this.description = '',
//     this.image,
//     this.memorialId,
//     this.managed,
//     this.follower,
//     this.pageType,
//     this.relationship,
//   });

//   MiscBLMManageMemorialTabState createState() => MiscBLMManageMemorialTabState(index: index, tab: tab, memorialName: memorialName, description: description, image: image, memorialId: memorialId, managed: managed, follower: follower, pageType: pageType, relationship: re);
//   // MiscBLMManageMemorialTabState createState() => MiscBLMManageMemorialTabState(index: index, memorialName: memorialName, description: description, image: image, memorialId: memorialId, managed: managed);
// }

// class MiscBLMManageMemorialTabState extends State<MiscBLMManageMemorialTab>{

//   // final int index;
//   // final String memorialName;
//   // final String description;
//   // final String image;
//   // final int memorialId;
//   // final bool managed;

//   // MiscBLMManageMemorialTabState({
//   //   this.index, 
//   //   this.memorialName,
//   //   this.description,
//   //   this.image,
//   //   this.memorialId,
//   //   this.managed,
//   // });

//   final int index;
//   final int tab;
//   final String memorialName;
//   final String description;
//   final String image;
//   final int memorialId;
//   final bool managed;
//   final bool follower;
//   final String pageType;
//   final String relationship;

//   MiscBLMManageMemorialTabState({
//     this.index, 
//     this.tab,
//     this.memorialName = '',
//     this.description = '',
//     this.image,
//     this.memorialId,
//     this.managed,
//     this.follower,
//     this.pageType,
//     this.relationship,
//   });

//   bool manageButton;

//   void initState(){
//     super.initState();
//     manageButton = managed;
//   }

//   @override
//   Widget build(BuildContext context){
//     SizeConfig.init(context);
//     ResponsiveWidgets.init(context,
//       height: SizeConfig.screenHeight,
//       width: SizeConfig.screenWidth,
//     );
//     return GestureDetector(
//       onTap: () async{
//         print('The value of managed is $managed');
//         print('The value of memorial id is $memorialId');
//         print('The value of follower is $follower');
//         print('The value of pageType is $pageType');

//         // Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMProfile(memorialId: memorialId,)));

//         if(managed == true){
//           Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMProfile(memorialId: memorialId,)));
//         }else{
//           if(pageType == 'Memorial'){
//             Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularMemorialProfile(memorialId: memorialId, newJoin: follower,)));
//           }else{
//             Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMMemorialProfile(memorialId: memorialId, newJoin: follower,)));
//           }
//         }
//       },
//       child: Container(
//         height: SizeConfig.blockSizeVertical * 15,
//         color: Color(0xffffffff),
//         child: Row(
//           children: [
//             // Padding(padding: EdgeInsets.only(left: 10.0), child: CircleAvatar(maxRadius: SizeConfig.blockSizeVertical * 5, backgroundColor: Color(0xff4EC9D4), backgroundImage: AssetImage(image),),),
//             Padding(
//               padding: EdgeInsets.only(left: 10.0), 
//               child: CircleAvatar(
//                 radius: SizeConfig.blockSizeVertical * 5, 
//                 backgroundColor: Color(0xff888888), 
//                 backgroundImage: image != null ? NetworkImage(image) : AssetImage('assets/icons/app-icon.png'),
//               ),
//             ),
//             Expanded(
//               child: Padding(
//                 padding: EdgeInsets.only(left: 20.0, right: 20.0),
//                 child: Column(
//                   children: [
//                     Expanded(
//                       child: Align(
//                         alignment: Alignment.bottomLeft,
//                         child: Text(memorialName,
//                           overflow: TextOverflow.ellipsis,
//                           maxLines: 2,
//                           style: TextStyle(
//                             // fontSize: SizeConfig.safeBlockHorizontal * 4,
//                             fontSize: ScreenUtil().setSp(14, allowFontScalingSelf: true),
//                             fontWeight: FontWeight.bold,
//                             color: Color(0xff000000),
//                           ),
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                       child: Align(
//                         alignment: Alignment.topLeft,
//                         child: Text(description,
//                           overflow: TextOverflow.ellipsis,
//                           maxLines: 3,
//                           style: TextStyle(
//                             // fontSize: SizeConfig.safeBlockHorizontal * 3,
//                             fontSize: ScreenUtil().setSp(12, allowFontScalingSelf: true),
//                             fontWeight: FontWeight.w200,
//                             color: Colors.grey,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             Container(
//               padding: EdgeInsets.only(right: 15.0),
//               child: MaterialButton(
//                 elevation: 0,
//                 padding: EdgeInsets.zero,
//                 textColor: manageButton ? Color(0xffffffff) : Color(0xff4EC9D4),
//                 splashColor: Color(0xff4EC9D4),
//                 onPressed: () async{

//                   if(manageButton == true){
//                     bool confirmResult = await showDialog(context: (context), builder: (build) => MiscBLMConfirmDialog(title: 'Confirm', content: 'Are you sure you want to leave this page?', confirmColor_1: Color(0xff04ECFF), confirmColor_2: Color(0xffFF0000),));

//                     if(confirmResult){
//                       String result = await apiBLMLeavePage(memorialId);

//                       if(result != 'Success'){
//                         await showDialog(context: (context), builder: (build) => MiscBLMAlertDialog(title: 'Error', content: result));
//                       }
//                     }
//                   }

//                 },
//                 child: manageButton ? Text('Leave', style: TextStyle(fontSize: ScreenUtil().setSp(14, allowFontScalingSelf: true),),) : Text('Manage', style: TextStyle(fontSize: ScreenUtil().setSp(14, allowFontScalingSelf: true),),),
//                 // height: SizeConfig.blockSizeVertical * 5,
//                 height: ScreenUtil().setHeight(35),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.all(Radius.circular(5)),
//                   side: manageButton ? BorderSide(color: Color(0xff04ECFF)) : BorderSide(color: Color(0xff4EC9D4)),
//                 ),
//                 color: manageButton ? Color(0xff04ECFF) : Color(0xffffffff),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


// import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-04-blm-manage-memorial.dart';
// import 'package:facesbyplaces/API/BLM/02-Main/api-main-blm-04-02-00-home-memorials-tab.dart';
// import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-16-blm-empty-display.dart';
// import 'package:facesbyplaces/Configurations/size_configuration.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';
// import 'package:loader_overlay/loader_overlay.dart';
// import 'package:flutter/material.dart';
// import 'package:responsive_widgets/responsive_widgets.dart';

// class BLMMainPagesMemorials{
//   int memorialId;
//   String memorialName;
//   String memorialDescription;
//   bool managed;

//   BLMMainPagesMemorials({this.memorialId, this.memorialName, this.memorialDescription, this.managed});
// }

// class HomeBLMManageTab extends StatefulWidget{

//   HomeBLMManageTabState createState() => HomeBLMManageTabState();
// }

// class HomeBLMManageTabState extends State<HomeBLMManageTab>{

//   RefreshController refreshController = RefreshController(initialRefresh: true);
//   List<Widget> finalMemorials;
//   int blmFamilyItemsRemaining;
//   int blmFriendsItemsRemaining;
//   int page1;
//   int page2;
//   bool flag1;
//   int count;

//   void initState(){
//     super.initState();
//     finalMemorials = [];
//     blmFamilyItemsRemaining = 1;
//     blmFriendsItemsRemaining = 1;
//     page1 = 1;
//     page2 = 1;
//     count = 0;
//     flag1 = false;
//     addMemorials1();
//     onLoading1();
//   }

//   void onRefresh() async{
//     await Future.delayed(Duration(milliseconds: 1000));
//     refreshController.refreshCompleted();
//   }

//   void addMemorials1(){
//     finalMemorials.add(
//       Container(
//         height: SizeConfig.blockSizeVertical * 10,
//         padding: EdgeInsets.only(left: 20.0, right: 20.0),
//         color: Color(0xffeeeeee),
//         child: Row(
//           children: [
//             Expanded(child: Align(alignment: Alignment.centerLeft, child: Text('My Family', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xff000000),),),),),
            
//             Expanded(
//               child: GestureDetector(
//                 onTap: (){
//                   Navigator.pushNamed(context, '/home/blm/create-memorial');
//                 },
//               child: Align(alignment: Alignment.centerRight, child: Text('Create', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xff000000),),),),),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void addMemorials2(){
//     finalMemorials.add(
//       Container(
//         height: SizeConfig.blockSizeVertical * 10,
//         padding: EdgeInsets.only(left: 20.0, right: 20.0),
//         color: Color(0xffeeeeee),
//         child: Align(
//           alignment: Alignment.centerLeft,
//           child: Text('My Friends',
//             style: TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.bold,
//               color: Color(0xff000000),
//             ),
//           ),
//         ),
//       ),
//     );
//   }


//   void onLoading() async{

//     if(flag1 == false){
//       onLoading1();
//     }else{
//       onLoading2();
//     }
//   }

//   void onLoading1() async{

//     if(blmFamilyItemsRemaining != 0){
//       context.showLoaderOverlay();
//       var newValue = await apiBLMHomeMemorialsTab(page1);
//       context.hideLoaderOverlay();

//       blmFamilyItemsRemaining = newValue.familyMemorialList.blmFamilyItemsRemaining;
//       count = count + newValue.familyMemorialList.blm.length;

//       for(int i = 0; i < newValue.familyMemorialList.blm.length; i++){
//         finalMemorials.add(
//           MiscBLMManageMemorialTab(
//             // index: i,
//             // memorialId: newValue.familyMemorialList.blm[i].id, 
//             // memorialName: newValue.familyMemorialList.blm[i].name,
//             // description: newValue.familyMemorialList.blm[i].details.description,
//             // managed: newValue.familyMemorialList.blm[i].managed,

//             index: i,
//             memorialName: newValue.familyMemorialList.memorial[i].name,
//             description: newValue.familyMemorialList.memorial[i].details.description,
//             image: newValue.familyMemorialList.memorial[i].profileImage,
//             memorialId: newValue.familyMemorialList.memorial[i].id, 
//             managed: newValue.familyMemorialList.memorial[i].manage,
//             follower: newValue.familyMemorialList.memorial[i].follower,
//             pageType: newValue.familyMemorialList.memorial[i].pageType,
//             relationship: newValue.familyMemorialList.memorial[i].relationship,
//           ),
//         );
//       }

//       print('The count is $count');

//       if(mounted)
//       setState(() {});
//       page1++;

//       if(blmFamilyItemsRemaining == 0){
//         addMemorials2();
//       }
      
//       refreshController.loadComplete();
//     }else{
//       setState(() {
//         flag1 = true;
//       });
      
//       refreshController.loadNoData();
//     }
//   }

//   void onLoading2() async{

//     if(blmFriendsItemsRemaining != 0){
//       context.showLoaderOverlay();
//       var newValue = await apiBLMHomeMemorialsTab(page2);
//       context.hideLoaderOverlay();

//       blmFriendsItemsRemaining = newValue.friendsMemorialList.blmFriendsItemsRemaining;
//       count = count + newValue.familyMemorialList.blm.length;

//       for(int i = 0; i < newValue.familyMemorialList.blm.length; i++){
//         finalMemorials.add(
//           MiscBLMManageMemorialTab(
//             // index: i,
//             // memorialId: newValue.friendsMemorialList.blm[i].id,
//             // memorialName: newValue.friendsMemorialList.blm[i].name,
//             // description: newValue.friendsMemorialList.blm[i].details.description,
//             // managed: newValue.familyMemorialList.blm[i].managed,
//             index: i,
//             memorialName: newValue.friendsMemorialList.memorial[i].name,
//             description: newValue.friendsMemorialList.memorial[i].details.description,
//             image: newValue.friendsMemorialList.memorial[i].profileImage,
//             memorialId: newValue.friendsMemorialList.memorial[i].id, 
//             managed: newValue.friendsMemorialList.memorial[i].manage,
//             follower: newValue.friendsMemorialList.memorial[i].follower,
//             famOrFriends: newValue.friendsMemorialList.memorial[i].famOrFriends,
//             pageType: newValue.friendsMemorialList.memorial[i].pageType,
//             relationship: newValue.friendsMemorialList.memorial[i].relationship,
//           ),
//         );
//       }

//       if(mounted)
//       setState(() {});
//       page2++;

      

//       refreshController.loadComplete();
//     }else{
//       refreshController.loadNoData();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     SizeConfig.init(context);
//     ResponsiveWidgets.init(context,
//       height: SizeConfig.screenHeight,
//       width: SizeConfig.screenWidth,
//     );
//     return Container(
//       height: SizeConfig.screenHeight - SizeConfig.blockSizeVertical * 13 - AppBar().preferredSize.height,
//       child: count != 0
//       ? SmartRefresher(
//         enablePullDown: false,
//         enablePullUp: true,
//         header: MaterialClassicHeader(),
//         footer: CustomFooter(
//           loadStyle: LoadStyle.ShowWhenLoading,
//           builder: (BuildContext context, LoadStatus mode){
//             Widget body;
//             if(mode == LoadStatus.idle){
//               body = Text('Pull up load', style: TextStyle(fontSize: ScreenUtil().setSp(14, allowFontScalingSelf: true), color: Color(0xff000000),),);
//             }
//             else if(mode == LoadStatus.loading){
//               body = CircularProgressIndicator();
//             }
//             else if(mode == LoadStatus.failed){
//               body = Text('Load Failed! Click retry!', style: TextStyle(fontSize: ScreenUtil().setSp(14, allowFontScalingSelf: true), color: Color(0xff000000),),);
//             }
//             else if(mode == LoadStatus.canLoading){
//               body = Text('Release to load more', style: TextStyle(fontSize: ScreenUtil().setSp(14, allowFontScalingSelf: true), color: Color(0xff000000),),);
//             }
//             else{
//               body = Text('No more memorials.', style: TextStyle(fontSize: ScreenUtil().setSp(14, allowFontScalingSelf: true), color: Color(0xff000000),),);
//             }
//             return Container(height: 55.0, child: Center(child: body),);
//           },
//         ),
//         controller: refreshController,
//         onRefresh: onRefresh,
//         onLoading: onLoading,
//         child: ListView.separated(
//           physics: ClampingScrollPhysics(),
//           itemBuilder: (c, i) {
//             return finalMemorials[i];
//           },
//           separatorBuilder: (c, i) => Divider(height: SizeConfig.blockSizeVertical * 1, color: Colors.transparent),
//           itemCount: finalMemorials.length,
//         ),
//       )
//       : ContainerResponsive(
//         height: SizeConfig.screenHeight,
//         width: SizeConfig.screenWidth,
//         alignment: Alignment.center,
//         child: ContainerResponsive(
//           width: SizeConfig.screenWidth,
//           heightResponsive: false,
//           widthResponsive: true,
//           alignment: Alignment.center,
//           child: SingleChildScrollView(
//             physics: ClampingScrollPhysics(),
//             child: MiscBLMEmptyDisplayTemplate(message: 'Memorial is empty',),
//           ),
//         ),
//       ),
//     );
//   }
// }









// import 'package:facesbyplaces/API/BLM/09-Settings-Memorial/api-settings-memorial-blm-08-show-admin-settings.dart';
// import 'package:facesbyplaces/Configurations/size_configuration.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';
// import 'package:loader_overlay/loader_overlay.dart';
// import 'package:flutter/material.dart';

// class BLMShowAdminSettings{
//   final String firstName;
//   final String lastName;
//   final String image;
//   final String relationship;

//   BLMShowAdminSettings({this.firstName, this.lastName, this.image, this.relationship});
// }

// class HomeBLMPageManagers extends StatefulWidget{
//   final int memorialId;
//   HomeBLMPageManagers({this.memorialId});

//   HomeBLMPageManagersState createState() => HomeBLMPageManagersState(memorialId: memorialId);
// }

// class HomeBLMPageManagersState extends State<HomeBLMPageManagers>{
//   final int memorialId;
//   HomeBLMPageManagersState({this.memorialId});

//   RefreshController refreshController = RefreshController(initialRefresh: true);
//   List<BLMShowAdminSettings> adminList = [];
//   List<BLMShowAdminSettings> familyList = [];
//   int adminItemsRemaining = 1;
//   int familyItemsRemaining = 1;
//   int page = 1;

//   void initState(){
//     super.initState();
//     onLoading1();
//     onLoading2();
//   }

//   void onRefresh() async{
//     await Future.delayed(Duration(milliseconds: 1000));
//     refreshController.refreshCompleted();
//   }

//   void onLoading1() async{
//     if(adminItemsRemaining != 0){
//       context.showLoaderOverlay();
//       var newValue = await apiBLMShowAdminSettings(memorialId, page);
//       adminItemsRemaining = newValue.adminItemsRemaining;

//       for(int i = 0; i < newValue.adminList.length; i++){
//         adminList.add(
//           BLMShowAdminSettings(
//             firstName: newValue.adminList[i].user.firstName,
//             lastName: newValue.adminList[i].user.lastName,
//             image: newValue.adminList[i].user.image,
//             relationship: newValue.adminList[i].relationship,
//           ),
//         );
//       }

//       if(mounted)
//       setState(() {});
//       page++;
      
//       refreshController.loadComplete();
//       context.hideLoaderOverlay();
//     }else{
//       refreshController.loadNoData();
//     }
//   }

//   void onLoading2() async{
    
//     if(familyItemsRemaining != 0){
//       context.showLoaderOverlay();
//       var newValue = await apiBLMShowAdminSettings(memorialId, page);
//       context.hideLoaderOverlay();
//       familyItemsRemaining = newValue.familyItemsRemaining;

//       for(int i = 0; i < newValue.familyList.length; i++){
//         familyList.add(
//           BLMShowAdminSettings(
//             firstName: newValue.familyList[i].user.firstName,
//             lastName: newValue.familyList[i].user.lastName,
//             image: newValue.adminList[i].user.image,
//             relationship: newValue.familyList[i].relationship
//           ),
//         );
//       }

//       if(mounted)
//       setState(() {});
//       page++;
      
//       refreshController.loadComplete();
      
//     }else{
//       refreshController.loadNoData();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     SizeConfig.init(context);
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Color(0xff04ECFF),
//         title:  Text('Memorial Settings', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xffffffff),),),
//         centerTitle: true,
//           leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: (){
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: Container(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Expanded(
//               child: SmartRefresher(
//                 enablePullDown: false,
//                 enablePullUp: true,
//                 header: MaterialClassicHeader(),
//                 footer: CustomFooter(
//                   loadStyle: LoadStyle.ShowWhenLoading,
//                   builder: (BuildContext context, LoadStatus mode){
//                     Widget body ;
//                     if(mode == LoadStatus.idle){
//                       body =  Text('Pull up load.', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
//                     }
//                     else if(mode == LoadStatus.loading){
//                       body =  CircularProgressIndicator();
//                     }
//                     else if(mode == LoadStatus.failed){
//                       body = Text('Load Failed! Please try again.', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
//                     }
//                     else if(mode == LoadStatus.canLoading){
//                       body = Text('Release to load more.', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
//                     }else{
//                       body = Text('End of list.', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
//                     }
//                     return Container(height: 55.0, child: Center(child: body),);
//                   },
//                 ),
//                 controller: refreshController,
//                 onRefresh: onRefresh,
//                 onLoading: onLoading1,
//                 child: ListView.separated(
//                   physics: ClampingScrollPhysics(),
//                   itemBuilder: (c, i) {
//                     var container = Container(
//                       padding: EdgeInsets.all(10.0),
//                       child: Row(
//                         children: [
//                           CircleAvatar(
//                             maxRadius: SizeConfig.blockSizeVertical * 5,
//                             backgroundColor: Color(0xff888888),
//                             backgroundImage: AssetImage('assets/icons/graveyard.png'),
//                           ),

//                           SizedBox(width: SizeConfig.blockSizeHorizontal * 3,),

//                           Expanded(
//                             child: Container(
//                               child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(adminList[i].firstName + ' ' + adminList[i].lastName, style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, fontWeight: FontWeight.bold, color: Color(0xff000000)),),

//                                 Text(adminList[i].relationship, style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 3.5, color: Color(0xff888888)),),
//                               ],
//                             ),
//                             ),
//                           ),

//                           SizedBox(width: SizeConfig.blockSizeHorizontal * 3,),

//                           MaterialButton(
//                             minWidth: SizeConfig.screenWidth / 3.5,
//                             padding: EdgeInsets.zero,
//                             textColor: Color(0xffffffff),
//                             splashColor: Color(0xff04ECFF),
//                             onPressed: () async{

//                             },
//                             child: Text('Remove', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 3.5,),),
//                             height: SizeConfig.blockSizeVertical * 5,
//                             shape: StadiumBorder(
//                               side: BorderSide(color: Color(0xffE74C3C)),
//                             ),
//                               color: Color(0xffE74C3C),
//                           ),

//                         ],
//                       ),
//                     );

//                     return container;
                    
//                   },
//                   separatorBuilder: (c, i) => Divider(height: SizeConfig.blockSizeVertical * 1, color: Colors.transparent),
//                   itemCount: adminList.length,
//                 ),
//               ),
//             ),

//             SizedBox(height: SizeConfig.blockSizeVertical * 2,),

//             Padding(padding: EdgeInsets.only(left: 20.0,), child: Text('Family', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 3.5, color: Color(0xff888888)),),),

//             Expanded(
//               child: SmartRefresher(
//                 enablePullDown: false,
//                 enablePullUp: true,
//                 header: MaterialClassicHeader(),
//                 footer: CustomFooter(
//                   loadStyle: LoadStyle.ShowWhenLoading,
//                   builder: (BuildContext context, LoadStatus mode){
//                     Widget body ;
//                     if(mode == LoadStatus.idle){
//                       body =  Text('Pull up load.', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
//                     }
//                     else if(mode == LoadStatus.loading){
//                       body =  CircularProgressIndicator();
//                     }
//                     else if(mode == LoadStatus.failed){
//                       body = Text('Load Failed! Please try again.', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
//                     }
//                     else if(mode == LoadStatus.canLoading){
//                       body = Text('Release to load more.', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
//                       page++;
//                     }else{
//                       body = Text('End of list.', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
//                     }
//                     return Container(height: 55.0, child: Center(child: body),);
//                   },
//                 ),
//                 controller: refreshController,
//                 onRefresh: onRefresh,
//                 onLoading: onLoading2,
//                 child: ListView.separated(
//                   physics: ClampingScrollPhysics(),
//                   itemBuilder: (c, i) {
//                     var container = Container(
//                       padding: EdgeInsets.all(10.0),
//                       child: Row(
//                         children: [
//                           CircleAvatar(
//                             maxRadius: SizeConfig.blockSizeVertical * 5,
//                             backgroundColor: Color(0xff888888),
//                             backgroundImage: AssetImage('assets/icons/graveyard.png'),
//                           ),

//                           SizedBox(width: SizeConfig.blockSizeHorizontal * 3,),

//                           Expanded(
//                             child: Container(
//                               child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(familyList[i].firstName + ' ' + familyList[i].lastName, style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, fontWeight: FontWeight.bold, color: Color(0xff000000)),),

//                                 Text(familyList[i].relationship, style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 3.5, color: Color(0xff888888)),),
//                               ],
//                             ),
//                             ),
//                           ),

//                           SizedBox(width: SizeConfig.blockSizeHorizontal * 3,),

//                           MaterialButton(
//                             minWidth: SizeConfig.screenWidth / 3.5,
//                             padding: EdgeInsets.zero,
//                             textColor: Color(0xffffffff),
//                             splashColor: Color(0xff04ECFF),
//                             onPressed: () async{

//                             },
//                             child: Text('Make Manager', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 3.5,),),
//                             height: SizeConfig.blockSizeVertical * 5,
//                             shape: StadiumBorder(
//                               side: BorderSide(color: Color(0xff04ECFF)),
//                             ),
//                               color: Color(0xff04ECFF),
//                           ),

//                         ],
//                       ),
//                     );

//                     return container;
                    
//                   },
//                   separatorBuilder: (c, i) => Divider(height: SizeConfig.blockSizeVertical * 1, color: Colors.transparent),
//                   itemCount: familyList.length,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }






