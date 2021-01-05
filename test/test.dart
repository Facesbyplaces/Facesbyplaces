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




