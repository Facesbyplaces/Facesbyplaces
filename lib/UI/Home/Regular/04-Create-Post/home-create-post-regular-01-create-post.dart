// import 'package:facesbyplaces/API/Regular/05-Create-Post/api-create-post-regular-01-create-post.dart';
// import 'package:facesbyplaces/API/Regular/05-Create-Post/api-create-post-regular-02-list-of-managed-pages.dart';
// import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-02-regular-dialog.dart';
// import 'package:facesbyplaces/Configurations/size_configuration.dart';
// import 'package:loader_overlay/loader_overlay.dart';
// import 'package:location/location.dart' as Location;
// import 'package:image_picker/image_picker.dart';
// import 'package:video_player/video_player.dart';
// import 'package:giffy_dialog/giffy_dialog.dart';
// import 'package:flutter/material.dart';
// import 'package:mime/mime.dart';
// import 'dart:io';

// class RegularTaggedUsers{
//   String name;
//   int userId;
//   int accountType;

//   RegularTaggedUsers({this.name, this.userId, this.accountType});
// }

// class RegularManagedPages{
//   String name;
//   int pageId;
//   String image;

//   RegularManagedPages({this.name, this.pageId, this.image});
// }

// class HomeRegularCreatePost extends StatefulWidget{
//   final String name;
//   final int memorialId;
//   HomeRegularCreatePost({this.name, this.memorialId});

//   @override
//   HomeRegularCreatePostState createState() => HomeRegularCreatePostState(name: name, memorialId: memorialId);
// }

// class HomeRegularCreatePostState extends State<HomeRegularCreatePost>{
//   final String name;
//   final int memorialId;
//   HomeRegularCreatePostState({this.name, this.memorialId});

//   // final GlobalKey<MiscRegularInputFieldMultiTextPostTemplateState> _key1 = GlobalKey<MiscRegularInputFieldMultiTextPostTemplateState>();

//   List<RegularManagedPages> managedPages;
//   String currentSelection;
//   int currentIdSelected;
//   Future listManagedPages;
//   List<RegularTaggedUsers> users = [];
//   List<File> slideImages;
//   TextEditingController controller = TextEditingController();
//   int maxLines;

//   void initState(){
//     super.initState();
//     slideImages = [];
//     managedPages = [];
//     currentSelection = name;
//     currentIdSelected = memorialId;
//     getManagedPages();
//   }

//   void getManagedPages() async{
//     context.showLoaderOverlay();
//     var newValue = await apiRegularShowListOfManagedPages();
//     context.hideLoaderOverlay();

//     for(int i = 0; i < newValue.almPagesList.length; i++){
//       managedPages.add(
//         RegularManagedPages(
//           name: newValue.almPagesList[i].showListOfManagedPagesName,
//           pageId: newValue.almPagesList[i].showListOfManagedPagesId,
//           image: newValue.almPagesList[i].showListOfManagedPagesProfileImage,
//         ),
//       );
//     }
//     setState(() {});
//   }

//   File videoFile;
//   final picker = ImagePicker();
//   VideoPlayerController videoPlayerController;
//   String newLocation = '';
//   String person = '';

//   Future getVideo() async{
//     final pickedFile = await picker.getVideo(source: ImageSource.gallery);

//     if(pickedFile != null){
//       setState(() {
//         slideImages.add(File(pickedFile.path));
//         videoFile = File(pickedFile.path);
//         videoPlayerController = VideoPlayerController.file(videoFile)
//         ..initialize().then((_){
//           setState(() {
//             videoPlayerController.play();
//           });
//         });
//       });
//     }
//   }

//   Future getSlideFiles() async{
//     final pickedFile = await picker.getImage(source: ImageSource.gallery);
//     if(pickedFile != null){
//       setState(() {
//         slideImages.add(File(pickedFile.path));
//       });
//     }
//   }

//   @override
//   void dispose() {
//     videoPlayerController.dispose();
//     super.dispose();
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
//             title: Text('Create Post', style: TextStyle(fontSize: 16, color: Color(0xffffffff)),),
//             centerTitle: true,
//             backgroundColor: Color(0xff04ECFF),
//             leading: IconButton(icon: Icon(Icons.arrow_back, color: Color(0xffffffff),), onPressed: (){Navigator.pop(context);},),
//             actions: [
//               GestureDetector(
//                 onTap: () async{

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

//                   context.showLoaderOverlay();

//                   Location.LocationData locationData = await location.getLocation();
//                   List<RegularTaggedPeople> userIds = [];
                  
//                   if(users.length != 0){
//                     for(int i = 0; i < users.length; i++){
//                       userIds.add(
//                         RegularTaggedPeople(
//                           userId: users[i].userId,
//                           accountType: users[i].accountType,
//                         ),
//                       );
//                     }
//                   }

//                   List<File> newFiles = [];
//                   newFiles.addAll(slideImages);

//                   APIRegularCreatePost post = APIRegularCreatePost(
//                     almPageType: 'Memorial',
//                     almPostBody: controller.text,
//                     almPageId: currentIdSelected,
//                     almLocation: newLocation,
//                     almImagesOrVideos: newFiles,
//                     almLatitude: locationData.latitude,
//                     almLongitude: locationData.longitude,
//                     almTagPeople: userIds,
//                   );
                  
//                   bool result = await apiRegularHomeCreatePost(post: post);
//                   context.hideLoaderOverlay();

//                   if(result){
//                     Navigator.popAndPushNamed(context, '/home/regular');
//                   }else{
//                     await showDialog(
//                       context: context,
//                       builder: (_) => 
//                         AssetGiffyDialog(
//                         image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
//                         title: Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
//                         entryAnimation: EntryAnimation.DEFAULT,
//                         description: Text('Something went wrong. Please try again.',
//                           textAlign: TextAlign.center,
//                           style: TextStyle(),
//                         ),
//                         onlyOkButton: true,
//                         buttonOkColor: Colors.red,
//                         onOkButtonPressed: () {
//                           Navigator.pop(context, true);
//                         },
//                       )
//                     );
//                   }

//                 }, 
//                 child: Padding(
//                   padding: EdgeInsets.only(right: 20.0), 
//                   child: Center(
//                     child: Text('Post', 
//                     style: TextStyle(
//                       color: Color(0xffffffff), 
//                       fontSize: 20,),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           body: SingleChildScrollView(
//             physics: ClampingScrollPhysics(),
//             child: SafeArea(
//               child: Column(
//                 children: [

//                   Container(
//                     child: InputDecorator(
//                       decoration: InputDecoration(
//                         alignLabelWithHint: true,
//                         labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey,),
//                         focusedBorder: UnderlineInputBorder(
//                           borderSide: BorderSide.none,
//                         ),
//                         border: UnderlineInputBorder(
//                           borderSide: BorderSide.none,
//                         ),
//                       ),
//                       child: DropdownButtonHideUnderline(
//                         child: DropdownButton<int>(
//                           value: currentIdSelected,
//                           isDense: true,
//                           onChanged: (int newValue) {
//                             setState(() {
//                               currentIdSelected = newValue;
//                             });
//                           },
//                           items: managedPages.map((RegularManagedPages value) {
//                             return DropdownMenuItem<int>(
//                               value: value.pageId,
                              
//                               child: Row(
//                                 children: [
//                                   CircleAvatar(backgroundColor: Color(0xff888888), backgroundImage: value.image != null ? NetworkImage(value.image) : AssetImage('assets/icons/app-icon.png'),),

//                                   SizedBox(width: 20,),

//                                   Text(value.name, ),
//                                 ],
//                               ),
//                             );
//                           }).toList(),
//                         ),
//                       ),
//                     ),
//                     decoration: BoxDecoration(
//                       color: Color(0xffffffff),
//                       boxShadow: <BoxShadow>[
//                         BoxShadow(
//                           color: Colors.grey.withOpacity(0.5),
//                           spreadRadius: 1,
//                           blurRadius: 5,
//                           offset: Offset(0, 0)
//                         ),
//                       ],
//                     ),
//                   ),

//                   // Expanded(child: Padding(padding: EdgeInsets.all(20.0), child: MiscRegularInputFieldMultiTextPostTemplate(key: _key1, labelText: 'Speak out...', maxLines: 20),),),
//                   FocusScope(
//                     child: Focus(
//                       onFocusChange: (focus){
//                         if(focus){
//                           setState(() {
//                             maxLines = 10;
//                           });
//                         }else{
//                           setState(() {
//                             maxLines = 5;
//                           });
//                         }
//                       },
//                       child: Padding(
//                         padding: EdgeInsets.all(10),
//                         child: TextFormField(
//                           controller: controller,
//                           cursorColor: Color(0xff000000),
//                           maxLines: maxLines,
//                           keyboardType: TextInputType.text,
//                           decoration: InputDecoration(
//                             fillColor: Color(0xffffffff),
//                             alignLabelWithHint: true,
//                             labelText: 'Speak out...',
//                             labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey),
//                             border: OutlineInputBorder(
//                               borderSide: BorderSide(
//                                 color: Color(0xff000000),
//                               ),
//                               borderRadius: BorderRadius.all(Radius.circular(10)),
//                             ),
//                             focusedBorder: OutlineInputBorder(
//                               borderSide: BorderSide(
//                                 color: Colors.transparent,
//                               ),
//                             ),
//                             enabledBorder: OutlineInputBorder(
//                               borderSide: BorderSide(
//                                 color: Colors.transparent,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),

//                   SizedBox(height: 10,),

//                   Container(
//                     child: Wrap(
//                       spacing: 5.0,
//                       children: List.generate(
//                         users.length, 
//                         (index) => Chip(
//                           labelPadding: const EdgeInsets.only(left: 8.0),
//                           label: Text(users[index].name),
//                           deleteIcon: Icon(Icons.close, size: 18,),
//                           onDeleted: () {
//                             setState(() {
//                               users.removeAt(index);
//                             });
//                           },
//                         ),
//                       ),
//                     ),
//                     padding: EdgeInsets.only(left: 20.0, right: 20.0,), 
//                     alignment: Alignment.centerLeft,
//                   ),

//                   SizedBox(height: 10,),

//                   Container(
//                     child: ((){
//                       if(slideImages.length != 0){
//                         return Container(
//                           height: 200,
//                           width: SizeConfig.screenWidth,
//                           padding: EdgeInsets.only(left: 20.0, right: 20.0),
//                           child: Container(
//                             height: 100,
//                             child: GridView.count(
//                               physics: ClampingScrollPhysics(),
//                               crossAxisCount: 4,
//                               crossAxisSpacing: 4,
//                               mainAxisSpacing: 4,
//                               children: List.generate(slideImages.length, (index){
//                                 return lookupMimeType(slideImages[index].path).contains('video') == true
//                                 ? GestureDetector(
//                                   onDoubleTap: (){
//                                     setState(() {
//                                       slideImages.removeAt(index);
//                                     });
//                                   },
//                                   onTap: (){
//                                     if(videoPlayerController.value.isPlaying){
//                                       videoPlayerController.pause();
//                                       print('Paused!');
//                                     }else{
//                                       videoPlayerController.play();
//                                       print('Played!');
//                                     }
//                                   },
//                                   child: Container(
//                                     child: AspectRatio(
//                                       aspectRatio: videoPlayerController.value.aspectRatio,
//                                       child: VideoPlayer(videoPlayerController),
//                                     ),
//                                   ),
//                                 )
//                                 : GestureDetector(
//                                   onDoubleTap: (){
//                                     setState(() {
//                                       slideImages.removeAt(index);
//                                     });
//                                   },
//                                   child: Container(
//                                     width: 80,
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(10),
//                                       color: Color(0xffcccccc),
//                                       border: Border.all(color: Color(0xff000000),),
//                                       image: DecorationImage(
//                                         fit: BoxFit.cover,
//                                         image: AssetImage(slideImages[index].path),
//                                       ),
//                                     ),
//                                     child: Stack(
//                                       children: [
//                                         Center(
//                                           child: CircleAvatar(
//                                             radius: 25,
//                                             backgroundColor: Color(0xffffffff).withOpacity(.5),
//                                             child: Text(
//                                               index.toString(),
//                                               style: TextStyle(
//                                                 fontSize: 40,
//                                                 fontWeight: FontWeight.bold,
//                                                 color: Color(0xffffffff),
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 );
//                               }),
//                             ),
//                           ),
//                         );
//                       }else{
//                         return Container(height: 0,);
//                       }
//                     }()),
//                   ),

//                   Container(
//                     padding: EdgeInsets.only(left: 20.0, right: 20.0,),
//                     height: 160,
//                     child: Column(
//                       children: [
//                         Expanded(
//                           child: GestureDetector(
//                             onTap: () async{
//                               var result = await Navigator.pushNamed(context, '/home/regular/create-post-location');

//                               newLocation = result.toString();
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

//                         Container(height: 1, color: Color(0xffeeeeee),),

//                         Expanded(
//                           child: GestureDetector(
//                             onTap: () async{
                              
//                               var result = await Navigator.pushNamed(context, '/home/regular/create-post-user');

//                               if(result != null){
//                                 users.add(result);
//                               }

//                               setState(() {});
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

//                         Container(height: 1, color: Color(0xffeeeeee),),

//                         Expanded(
//                           child: GestureDetector(
//                             onTap: () async{

//                               var choice = await showDialog(context: (context), builder: (build) => MiscRegularUploadFromDialog(choice_1: 'Image', choice_2: 'Video',));

//                               if(choice == null){
//                                 choice = 0;
//                               }else{
//                                 if(choice == 1){
//                                   await getSlideFiles();
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




import 'package:badges/badges.dart';
import 'package:better_player/better_player.dart';
import 'package:facesbyplaces/API/Regular/05-Create-Post/api-create-post-regular-01-create-post.dart';
import 'package:facesbyplaces/API/Regular/05-Create-Post/api-create-post-regular-02-list-of-managed-pages.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-02-regular-dialog.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:location/location.dart' as Location;
import 'package:image_picker/image_picker.dart';
// import 'package:video_player/video_player.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'dart:io';

class RegularTaggedUsers{
  String name;
  int userId;
  int accountType;

  RegularTaggedUsers({this.name, this.userId, this.accountType});
}

class RegularManagedPages{
  String name;
  int pageId;
  String image;

  RegularManagedPages({this.name, this.pageId, this.image});
}

class HomeRegularCreatePost extends StatefulWidget{
  final String name;
  final int memorialId;
  HomeRegularCreatePost({this.name, this.memorialId});

  @override
  HomeRegularCreatePostState createState() => HomeRegularCreatePostState(name: name, memorialId: memorialId);
}

class HomeRegularCreatePostState extends State<HomeRegularCreatePost>{
  final String name;
  final int memorialId;
  HomeRegularCreatePostState({this.name, this.memorialId});

  // final GlobalKey<MiscRegularInputFieldMultiTextPostTemplateState> _key1 = GlobalKey<MiscRegularInputFieldMultiTextPostTemplateState>();

  List<RegularManagedPages> managedPages;
  String currentSelection;
  int currentIdSelected;
  Future listManagedPages;
  List<RegularTaggedUsers> users = [];
  List<File> slideImages;
  TextEditingController controller = TextEditingController();
  int maxLines;

  File videoFile;
  final picker = ImagePicker();
  BetterPlayerController betterPlayerController;
  String newLocation = '';
  String person = '';
  int removeAttachment;

  void initState(){
    super.initState();
    slideImages = [];
    managedPages = [];
    currentSelection = name;
    currentIdSelected = memorialId;
    removeAttachment = 0;
    getManagedPages();
  }

  void getManagedPages() async{
    context.showLoaderOverlay();
    var newValue = await apiRegularShowListOfManagedPages();
    context.hideLoaderOverlay();

    for(int i = 0; i < newValue.almPagesList.length; i++){
      managedPages.add(
        RegularManagedPages(
          name: newValue.almPagesList[i].showListOfManagedPagesName,
          pageId: newValue.almPagesList[i].showListOfManagedPagesId,
          image: newValue.almPagesList[i].showListOfManagedPagesProfileImage,
        ),
      );
    }
    setState(() {});
  }

  Future getVideo() async{
    final pickedFile = await picker.getVideo(source: ImageSource.gallery);

    if(pickedFile != null){
      setState(() {
        slideImages.add(File(pickedFile.path));
        videoFile = File(pickedFile.path);
        BetterPlayerDataSource betterPlayerDataSource =BetterPlayerDataSource(BetterPlayerDataSourceType.file, '${pickedFile.path}');
        betterPlayerController = BetterPlayerController(
          BetterPlayerConfiguration(
            aspectRatio: 1 / 2,
            controlsConfiguration: BetterPlayerControlsConfiguration(
              showControls: false,
            ),
          ), 
          betterPlayerDataSource: betterPlayerDataSource,
        );
        // videoPlayerController = VideoPlayerController.file(videoFile)
        // ..initialize().then((_){
        //   setState(() {
        //     videoPlayerController.play();
        //   });
        // });
      });
    }
  }

  Future getSlideFiles() async{
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if(pickedFile != null){
      setState(() {
        slideImages.add(File(pickedFile.path));
      });
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
            title: Text('Create Post', style: TextStyle(fontSize: 16, color: Color(0xffffffff)),),
            centerTitle: true,
            backgroundColor: Color(0xff04ECFF),
            leading: IconButton(icon: Icon(Icons.arrow_back, color: Color(0xffffffff),), onPressed: (){Navigator.pop(context);},),
            actions: [
              GestureDetector(
                onTap: () async{

                  Location.Location location = new Location.Location();

                  bool serviceEnabled = await location.serviceEnabled();
                  if (!serviceEnabled) {
                    serviceEnabled = await location.requestService();
                    if (!serviceEnabled) {
                      return;
                    }
                  }

                  Location.PermissionStatus permissionGranted = await location.hasPermission();
                  if (permissionGranted == Location.PermissionStatus.denied) {
                    permissionGranted = await location.requestPermission();
                    if (permissionGranted != Location.PermissionStatus.granted) {
                      return;
                    }
                  }

                  context.showLoaderOverlay();

                  Location.LocationData locationData = await location.getLocation();
                  List<RegularTaggedPeople> userIds = [];
                  
                  if(users.length != 0){
                    for(int i = 0; i < users.length; i++){
                      userIds.add(
                        RegularTaggedPeople(
                          userId: users[i].userId,
                          accountType: users[i].accountType,
                        ),
                      );
                    }
                  }

                  List<File> newFiles = [];
                  newFiles.addAll(slideImages);

                  APIRegularCreatePost post = APIRegularCreatePost(
                    almPageType: 'Memorial',
                    almPostBody: controller.text,
                    almPageId: currentIdSelected,
                    almLocation: newLocation,
                    almImagesOrVideos: newFiles,
                    almLatitude: locationData.latitude,
                    almLongitude: locationData.longitude,
                    almTagPeople: userIds,
                  );
                  
                  bool result = await apiRegularHomeCreatePost(post: post);
                  context.hideLoaderOverlay();

                  if(result){
                    Navigator.popAndPushNamed(context, '/home/regular');
                  }else{
                    await showDialog(
                      context: context,
                      builder: (_) => 
                        AssetGiffyDialog(
                        image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                        title: Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                        entryAnimation: EntryAnimation.DEFAULT,
                        description: Text('Something went wrong. Please try again.',
                          textAlign: TextAlign.center,
                          style: TextStyle(),
                        ),
                        onlyOkButton: true,
                        buttonOkColor: Colors.red,
                        onOkButtonPressed: () {
                          Navigator.pop(context, true);
                        },
                      )
                    );
                  }

                }, 
                child: Padding(
                  padding: EdgeInsets.only(right: 20.0), 
                  child: Center(
                    child: Text('Post', 
                    style: TextStyle(
                      color: Color(0xffffffff), 
                      fontSize: 20,),
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: SafeArea(
              child: Column(
                children: [

                  Container(
                    child: InputDecorator(
                      decoration: InputDecoration(
                        alignLabelWithHint: true,
                        labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey,),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<int>(
                          value: currentIdSelected,
                          isDense: true,
                          onChanged: (int newValue) {
                            setState(() {
                              currentIdSelected = newValue;
                            });
                          },
                          items: managedPages.map((RegularManagedPages value) {
                            return DropdownMenuItem<int>(
                              value: value.pageId,
                              
                              child: Row(
                                children: [
                                  CircleAvatar(backgroundColor: Color(0xff888888), backgroundImage: value.image != null ? NetworkImage(value.image) : AssetImage('assets/icons/app-icon.png'),),

                                  SizedBox(width: 20,),

                                  Text(value.name, ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xffffffff),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: Offset(0, 0)
                        ),
                      ],
                    ),
                  ),

                  // Expanded(child: Padding(padding: EdgeInsets.all(20.0), child: MiscRegularInputFieldMultiTextPostTemplate(key: _key1, labelText: 'Speak out...', maxLines: 20),),),
                  FocusScope(
                    child: Focus(
                      onFocusChange: (focus){
                        if(focus){
                          setState(() {
                            maxLines = 10;
                          });
                        }else{
                          setState(() {
                            maxLines = 5;
                          });
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: TextFormField(
                          controller: controller,
                          cursorColor: Color(0xff000000),
                          maxLines: maxLines,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            fillColor: Color(0xffffffff),
                            alignLabelWithHint: true,
                            labelText: 'Speak out...',
                            labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xff000000),
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.transparent,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.transparent,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 10,),

                  Container(
                    child: Wrap(
                      spacing: 5.0,
                      children: List.generate(
                        users.length, 
                        (index) => Chip(
                          labelPadding: const EdgeInsets.only(left: 8.0),
                          label: Text(users[index].name),
                          deleteIcon: Icon(Icons.close, size: 18,),
                          onDeleted: () {
                            setState(() {
                              users.removeAt(index);
                            });
                          },
                        ),
                      ),
                    ),
                    padding: EdgeInsets.only(left: 20.0, right: 20.0,), 
                    alignment: Alignment.centerLeft,
                  ),

                  SizedBox(height: 10,),

                  Container(
                    child: ((){
                      if(slideImages.length != 0){
                        return Container(
                          height: 200,
                          width: SizeConfig.screenWidth,
                          padding: EdgeInsets.only(left: 20.0, right: 20.0),
                          child: Container(
                            height: 100,
                            child: GridView.count(
                              physics: ClampingScrollPhysics(),
                              crossAxisCount: 4,
                              crossAxisSpacing: 4,
                              mainAxisSpacing: 4,
                              children: List.generate(slideImages.length, (index){
                                return GestureDetector(
                                  onTap: (){
                                    setState(() {
                                      removeAttachment = index;
                                    });
                                  },
                                  child: lookupMimeType(slideImages[index].path).contains('video') == true
                                  // ? BetterPlayer(
                                  //   controller: betterPlayerController,
                                  // )
                                  ? Container(
                                    width: 80,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Color(0xffcccccc),
                                      border: Border.all(color: Color(0xff000000),),
                                    //   image: DecorationImage(
                                    //     fit: BoxFit.cover,
                                    //     image: AssetImage(slideImages[index].path),
                                    //   ),
                                    ),
                                    child: Stack(
                                      children: [
                                        BetterPlayer(
                                          controller: betterPlayerController,
                                        ),
                                        
                                        Center(
                                          child: CircleAvatar(
                                            radius: 25,
                                            backgroundColor: Color(0xffffffff).withOpacity(.5),
                                            child: Text('$index',
                                              style: TextStyle(
                                                fontSize: 40,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xffffffff),
                                              ),
                                            ),
                                          ),
                                        ),

                                        removeAttachment == index
                                        ? GestureDetector(
                                          onTap: (){
                                            setState(() {
                                              slideImages.removeAt(index);
                                            });
                                          },
                                          child: Badge(
                                            position: BadgePosition.topEnd(top: 0, end: 0),
                                            animationDuration: Duration(milliseconds: 300),
                                            animationType: BadgeAnimationType.fade,
                                            badgeColor: Color(0xff000000),
                                            badgeContent: Icon(Icons.close, color: Color(0xffffffff),),
                                          ),
                                        )
                                        : Container(height: 0),
                                      ],
                                    ),
                                  )
                                  : Container(
                                    width: 80,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Color(0xffcccccc),
                                      border: Border.all(color: Color(0xff000000),),
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: AssetImage(slideImages[index].path),
                                      ),
                                    ),
                                    child: Stack(
                                      children: [
                                        Center(
                                          child: CircleAvatar(
                                            radius: 25,
                                            backgroundColor: Color(0xffffffff).withOpacity(.5),
                                            child: Text('$index',
                                              style: TextStyle(
                                                fontSize: 40,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xffffffff),
                                              ),
                                            ),
                                          ),
                                        ),

                                        removeAttachment == index
                                        ? GestureDetector(
                                          onTap: (){
                                            setState(() {
                                              slideImages.removeAt(index);
                                            });
                                          },
                                          child: Badge(
                                            position: BadgePosition.topEnd(top: 0, end: 0),
                                            animationDuration: Duration(milliseconds: 300),
                                            animationType: BadgeAnimationType.fade,
                                            badgeColor: Color(0xff000000),
                                            badgeContent: Icon(Icons.close, color: Color(0xffffffff),),
                                          ),
                                        )
                                        : Container(height: 0),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                        );
                      }else{
                        return Container(height: 0,);
                      }
                    }()),
                  ),

                  Container(
                    padding: EdgeInsets.only(left: 20.0, right: 20.0,),
                    height: 160,
                    child: Column(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () async{
                              var result = await Navigator.pushNamed(context, '/home/regular/create-post-location');

                              newLocation = result.toString();
                            },
                            child: Container(
                              color: Colors.transparent,
                              child: Row(
                                children: [
                                  Expanded(child: Text('Add a location'),),
                                  Icon(Icons.place, color: Color(0xff4EC9D4),)
                                ],
                              ),
                            ),
                          ),
                        ),

                        Container(height: 1, color: Color(0xffeeeeee),),

                        Expanded(
                          child: GestureDetector(
                            onTap: () async{
                              
                              var result = await Navigator.pushNamed(context, '/home/regular/create-post-user');

                              if(result != null){
                                users.add(result);
                              }

                              setState(() {});
                            },
                            child: Container(
                              color: Colors.transparent,
                              child: Row(
                                children: [
                                  Expanded(child: Text('Tag a person you are with'),),
                                  Icon(Icons.person, color: Color(0xff4EC9D4),)
                                ],
                              ),
                            ),
                          ),
                        ),

                        Container(height: 1, color: Color(0xffeeeeee),),

                        Expanded(
                          child: GestureDetector(
                            onTap: () async{

                              var choice = await showDialog(context: (context), builder: (build) => MiscRegularUploadFromDialog(choice_1: 'Image', choice_2: 'Video',));

                              if(choice == null){
                                choice = 0;
                              }else{
                                if(choice == 1){
                                  await getSlideFiles();
                                }else{
                                  await getVideo();
                                }
                              }
                              
                            },
                            child: Container(
                              color: Colors.transparent,
                              child: Row(
                                children: [
                                  Expanded(child: Text('Upload a Video / Image'),),
                                  Icon(Icons.image, color: Color(0xff4EC9D4),)
                                ],
                              ),
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                  
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}