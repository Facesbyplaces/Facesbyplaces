// import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-01-blm-input-field.dart';
// import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-02-blm-dialog.dart';
// import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-04-blm-extra.dart';
// import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-07-blm-button.dart';
// import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-08-blm-background.dart';
// import 'package:facesbyplaces/Configurations/size_configuration.dart';
// import 'package:facesbyplaces/Bloc/bloc-02-bloc-blm-home.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter/material.dart';


// class HomeBLMCreateMemorial2 extends StatelessWidget{

//   final GlobalKey<MiscBLMInputFieldTemplateState> _key1 = GlobalKey<MiscBLMInputFieldTemplateState>();
//   final GlobalKey<MiscBLMInputFieldMultiTextTemplateState> _key2 = GlobalKey<MiscBLMInputFieldMultiTextTemplateState>();

//   final List<String> images = [
//     'assets/icons/profile_post1.png', 'assets/icons/profile_post2.png', 'assets/icons/profile_post3.png', 
//     'assets/icons/profile_post4.png', 'assets/icons/profile_post2.png', 'assets/icons/profile_post3.png',
//   ];

//   @override
//   Widget build(BuildContext context) {
//     SizeConfig.init(context);
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider<BlocHomeBLMStoryType>(
//           create: (context) => BlocHomeBLMStoryType(),
//         ),
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
//               backgroundColor: Color(0xff04ECFF),
//               title: Text('Cry out for the Victims', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xffffffff))),
//               centerTitle: true,
//               leading: IconButton(
//                 icon: Icon(Icons.arrow_back, color: Color(0xffffffff),), 
//                 onPressed: (){
//                   Navigator.pop(context);
//                 },
//               ),
//             ),
//             body: Stack(
//               children: [

//                 SingleChildScrollView(
//                   physics: NeverScrollableScrollPhysics(),
//                   child: Container(height: SizeConfig.screenHeight, child: MiscBLMBackgroundTemplate(image: AssetImage('assets/icons/background2.png'),),),
//                 ),

//                 Container(
//                   padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
//                   child: ListView(
//                     physics: ClampingScrollPhysics(),
//                     children: [

//                       MiscBLMInputFieldTemplate(key: _key1, labelText: 'Name of your Memorial Page'),

//                       SizedBox(height: SizeConfig.blockSizeVertical * 5,),

//                       Row(
//                         children: [
//                           Text('Share your Story', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, fontWeight: FontWeight.w300, color: Color(0xff000000),),),

//                           SizedBox(width: SizeConfig.blockSizeHorizontal * 5,),

//                           Expanded(child: MiscBLMStoryType(),),
//                         ],
//                       ),

//                       BlocBuilder<BlocHomeBLMStoryType, int>(
//                         builder: (context, state){
//                           return ((){
//                             switch(state){
//                               case 0: return MiscBLMInputFieldMultiTextTemplate(key: _key2,); break;
//                               case 1: return Container(
//                                 height: SizeConfig.blockSizeVertical * 34.5,
//                                 child: Icon(Icons.upload_rounded, color: Color(0xff888888), size: SizeConfig.blockSizeVertical * 20,),
//                                 decoration: BoxDecoration(
//                                   color: Color(0xffcccccc),
//                                   border: Border.all(color: Color(0xff000000),),
//                                   borderRadius: BorderRadius.all(Radius.circular(10)),
//                                 ),
//                               ); break;
//                               case 2: return Column(
//                                 children: [
//                                   Container(
//                                     height: SizeConfig.blockSizeVertical * 32,
//                                     child: Container(
//                                       height: SizeConfig.blockSizeVertical * 12,
//                                       child: GridView.count(
//                                         shrinkWrap: true,
//                                         crossAxisCount: 4,
//                                         crossAxisSpacing: 4,
//                                         mainAxisSpacing: 4,
//                                         children: List.generate(7, (index){
//                                           return ((){
//                                             if(index == images.length){
//                                               return Container(
//                                                 width: SizeConfig.blockSizeVertical * 10,
//                                                 child: Icon(Icons.add_rounded, color: Color(0xff000000), size: SizeConfig.blockSizeVertical * 7,),
//                                                 decoration: BoxDecoration(
//                                                   borderRadius: BorderRadius.circular(10),
//                                                   color: Color(0xffcccccc),
//                                                   border: Border.all(color: Color(0xff000000),),
//                                                 ),
//                                               );
//                                             }else{
//                                               return Container(
//                                                 width: SizeConfig.blockSizeVertical * 10,
//                                                 decoration: BoxDecoration(
//                                                   borderRadius: BorderRadius.circular(10),
//                                                   color: Color(0xffcccccc),
//                                                   border: Border.all(color: Color(0xff000000),),
//                                                   image: DecorationImage(
//                                                     image: AssetImage(images[index]),
//                                                   ),
//                                                 ),
//                                                 child: Stack(
//                                                   children: [
//                                                     Center(
//                                                       child: CircleAvatar(
//                                                         radius: SizeConfig.blockSizeVertical * 3,
//                                                         backgroundColor: Color(0xffffffff).withOpacity(.5),
//                                                         child: Text(
//                                                           index.toString(),
//                                                           style: TextStyle(
//                                                             fontSize: SizeConfig.safeBlockHorizontal * 7,
//                                                             fontWeight: FontWeight.bold,
//                                                             color: Color(0xffffffff),
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               );
//                                             }
//                                           }());
//                                         }),
//                                       ),
                                      
//                                     ),
//                                   ),

//                                   Text('Drag & drop to rearrange images.',style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 3.5,fontWeight: FontWeight.w300, color: Color(0xff000000),),),
//                                 ],
//                               ); break;
//                             }
//                           }());
//                         },
//                       ),

//                       SizedBox(height: SizeConfig.blockSizeVertical * 2,),

//                       Text('Describe the events that happened to your love one.',style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 3.5,fontWeight: FontWeight.w300, color: Color(0xff000000),),),

//                       SizedBox(height: SizeConfig.blockSizeVertical * 10,),

//                       MiscBLMButtonTemplate(
//                         onPressed: () async{
//                           if(_key1.currentState.controller.text == ''){
//                             await showDialog(context: (context), builder: (build) => MiscBLMAlertDialog(title: 'Error', content: 'Please complete the form before submitting.', confirmText: 'OK',),);
//                           }else{
//                             Navigator.pushNamed(context, '/home/blm/home-07-03-blm-create-memorial');
//                           }
//                         }, 
//                         width: SizeConfig.screenWidth / 2, 
//                         height: SizeConfig.blockSizeVertical * 7,
//                       ),

//                     ],
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





// import 'package:facesbyplaces/Configurations/size_configuration.dart';
// import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-01-blm-input-field.dart';
// import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-02-blm-dialog.dart';
// import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-04-blm-extra.dart';
// import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-07-blm-button.dart';
// import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-08-blm-background.dart';
// import 'package:facesbyplaces/Bloc/bloc-02-bloc-blm-home.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:reorderables/reorderables.dart';
// import 'package:video_player/video_player.dart';
// import 'package:flutter/material.dart';
// import 'dart:io';

// class HomeCreateMemorial2 extends StatefulWidget {

//   @override
//   HomeCreateMemorial2State createState() => HomeCreateMemorial2State();
// }

// class HomeCreateMemorial2State extends State<HomeCreateMemorial2> {

//   final double _iconSize = 90;
//   List<Widget> _tiles;

//   @override
//   void initState() {
//     super.initState();
//     _tiles = <Widget>[
//       Icon(Icons.filter_1, size: _iconSize),
//       Icon(Icons.filter_2, size: _iconSize),
//       Icon(Icons.filter_3, size: _iconSize),
//       Icon(Icons.filter_4, size: _iconSize),
//       Icon(Icons.filter_5, size: _iconSize),
//       Icon(Icons.filter_6, size: _iconSize),
//       Icon(Icons.filter_7, size: _iconSize),
//       Icon(Icons.filter_8, size: _iconSize),
//       Icon(Icons.filter_9, size: _iconSize),
//     ];
//   }

//   @override
//   Widget build(BuildContext context) {
//     void _onReorder(int oldIndex, int newIndex) {
//       setState(() {
//         Widget row = _tiles.removeAt(oldIndex);
//         _tiles.insert(newIndex, row);
//       });
//     }

//     var wrap = ReorderableWrap(
//       spacing: 8.0,
//       runSpacing: 4.0,
//       padding: const EdgeInsets.all(8),
//       children: _tiles,
//       onReorder: _onReorder,
//        onNoReorder: (int index) {
//         //this callback is optional
//         debugPrint('${DateTime.now().toString().substring(5, 22)} reorder cancelled. index:$index');
//       },
//       onReorderStarted: (int index) {
//         //this callback is optional
//         debugPrint('${DateTime.now().toString().substring(5, 22)} reorder started: index:$index');
//       }
//     );

//     var column = Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: <Widget>[
//         wrap,
//         ButtonBar(
//           alignment: MainAxisAlignment.start,
//           children: <Widget>[
//             IconButton(
//               iconSize: 50,
//               icon: Icon(Icons.add_circle),
//               color: Colors.deepOrange,
//               padding: const EdgeInsets.all(0.0),
//               onPressed: () {
//                 var newTile = Icon(Icons.filter_9_plus, size: _iconSize);
//                 setState(() {
//                   _tiles.add(newTile);
//                 });
//               },
//             ),
//             IconButton(
//               iconSize: 50,
//               icon: Icon(Icons.remove_circle),
//               color: Colors.teal,
//               padding: const EdgeInsets.all(0.0),
//               onPressed: () {
//                 setState(() {
//                   _tiles.removeAt(0);
//                 });
//               },
//             ),
//           ],
//         ),
//       ],
//     );

//     return Scaffold(
//       body: SingleChildScrollView(
//         child: column,
//       ),
//     );

//   }

//   // final GlobalKey<MiscBLMInputFieldTemplateState> _key8 = GlobalKey<MiscBLMInputFieldTemplateState>();
//   // final GlobalKey<MiscBLMInputFieldMultiTextTemplateState> _key9 = GlobalKey<MiscBLMInputFieldMultiTextTemplateState>();

//   // File videoFile;
//   // File imageFile;
//   // final picker = ImagePicker();
//   // VideoPlayerController videoPlayerController;

//   // Future getVideo() async{
//   //   final pickedFile = await picker.getVideo(source: ImageSource.gallery);

//   //   if(pickedFile != null){
//   //     setState(() {
//   //       videoFile = File(pickedFile.path);
//   //       videoPlayerController = VideoPlayerController.file(videoFile)
//   //       ..initialize().then((_){
//   //         setState(() {
//   //           videoPlayerController.play();
//   //         });
//   //       });
//   //     });
//   //   }
//   // }

//   // Future<File> getSlideImage() async{
//   //   final pickedFile = await picker.getImage(source: ImageSource.gallery);
//   //   return imageFile = File(pickedFile.path);
//   // }

//   // List<Widget> slideImages = [
//   //   Container(
//   //     height: 50,
//   //     width: 50,
//   //     decoration: BoxDecoration(
//   //       image: DecorationImage(
//   //         image: AssetImage('assets/icons/profile_post1.png'),
//   //       ),
//   //     ),
//   //   ),

//   //   Container(
//   //     height: 50,
//   //     width: 50,
//   //     decoration: BoxDecoration(
//   //       image: DecorationImage(
//   //         image: AssetImage('assets/icons/profile_post2.png'),
//   //       ),
//   //     ),
//   //   ),

//   //   Container(
//   //     height: 50,
//   //     width: 50,
//   //     decoration: BoxDecoration(
//   //       image: DecorationImage(
//   //         image: AssetImage('assets/icons/profile_post3.png'),
//   //       ),
//   //     ),
//   //   ),
//   // ];

//   // @override
//   // Widget build(BuildContext context) {
//   //   SizeConfig.init(context);

//   //   void onReorder(int oldIndex, int newIndex) {
//   //     setState(() {
//   //       // slideImages.insert(newIndex, slideImages.removeAt(oldIndex));
//   //       Widget row = slideImages.removeAt(oldIndex);
//   //       slideImages.insert(newIndex, row);
//   //     });
//   //   }

//   //   var wrap = ReorderableWrap(
//   //     spacing: 8.0,
//   //     runSpacing: 4.0,
//   //     children: slideImages,
//   //     // onReorder: onReorder,
//   //     onReorder: onReorder,
//   //      onNoReorder: (int index) {
//   //       //this callback is optional
//   //       debugPrint('${DateTime.now().toString().substring(5, 22)} reorder cancelled. index:$index');
//   //     },
//   //     onReorderStarted: (int index) {
//   //       //this callback is optional
//   //       debugPrint('${DateTime.now().toString().substring(5, 22)} reorder started: index:$index');
//   //     }
//   //   );


//   //   return MultiBlocProvider(
//   //     providers: [
//   //       BlocProvider<BlocHomeBLMStoryType>(
//   //         create: (context) => BlocHomeBLMStoryType(),
//   //       ),
//   //     ], 
//   //     child: Scaffold(
//   //       body: BlocBuilder<BlocHomeBLMStoryType, int>(
//   //       builder: (context, storyType){
//   //         return Stack(
//   //           children: [

//   //             SingleChildScrollView(
//   //               physics: NeverScrollableScrollPhysics(),
//   //               child: Container(height: SizeConfig.screenHeight, child: MiscBLMBackgroundTemplate(image: AssetImage('assets/icons/background2.png'),),),
//   //             ),

//   //             Container(
//   //               padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
//   //               child: ListView(
//   //                 physics: ClampingScrollPhysics(),
//   //                 children: [

//   //                   MiscBLMInputFieldTemplate(key: _key8, labelText: 'Name of your Memorial Page'),

//   //                   SizedBox(height: SizeConfig.blockSizeVertical * 5,),

//   //                   Row(
//   //                     children: [
//   //                       Text('Share your Story', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, fontWeight: FontWeight.w300, color: Color(0xff000000),),),

//   //                       SizedBox(width: SizeConfig.blockSizeHorizontal * 5,),

//   //                       Expanded(child: MiscBLMStoryType(),),
//   //                     ],
//   //                   ),

//   //                   Container(
//   //                     child: ((){
//   //                       switch(storyType){
//   //                         case 0: return MiscBLMInputFieldMultiTextTemplate(key: _key9,); break;
//   //                         case 1: return GestureDetector(
//   //                           onTap: () async{
//   //                             await getVideo();
//   //                           },
//   //                           child: Container(
//   //                             height: SizeConfig.blockSizeVertical * 34.5,
//   //                             decoration: BoxDecoration(
//   //                               color: Color(0xffcccccc),
//   //                               border: Border.all(color: Color(0xff000000),),
//   //                               borderRadius: BorderRadius.all(Radius.circular(10)),
//   //                             ),
//   //                             child: videoFile == null 
//   //                             ? Icon(Icons.upload_rounded, color: Color(0xff888888), size: SizeConfig.blockSizeVertical * 20,)
//   //                             : GestureDetector(
//   //                               onTap: (){
//   //                                 if(videoPlayerController.value.isPlaying){
//   //                                   videoPlayerController.pause();
//   //                                 }else{
//   //                                   videoPlayerController.play();
//   //                                 }
                                  
//   //                               },
//   //                               onDoubleTap: () async{
//   //                                 await getVideo();
//   //                               },
//   //                               child: AspectRatio(
//   //                                 aspectRatio: videoPlayerController.value.aspectRatio,
//   //                                 child: VideoPlayer(videoPlayerController),
//   //                               ),
//   //                             ),
//   //                           ),
//   //                         ); break;
//   //                         // case 2: return GridView.count(
//   //                         //   crossAxisCount: 1,
//   //                         //   children: [
//   //                         //     // ReorderableWrap(
//   //                         //     //   children: slideImages,
//   //                         //     //   onReorder: onReorder,
//   //                         //     // ),


//   //                         case 2: return Column(
//   //                           children: [
//   //                             // Container(
//   //                             //   height: SizeConfig.blockSizeVertical * 32,
//   //                             //   child: Container(
//   //                             //     height: SizeConfig.blockSizeVertical * 12,
//   //                             //     child: GridView.count(
//   //                             //       physics: ClampingScrollPhysics(),
//   //                             //       crossAxisCount: 4,
//   //                             //       crossAxisSpacing: 4,
//   //                             //       mainAxisSpacing: 4,
//   //                             //       children: List.generate(slideImages.length + 1, (index){
//   //                             //         return ((){
//   //                             //           if(index == slideImages.length){
//   //                             //             return GestureDetector(
//   //                             //               onTap: () async{
//   //                             //                 // // await getSlideImage();
//   //                             //                 File newFile = await getSlideImage();

//   //                             //                 setState(() {
//   //                             //                   slideImages.add(
//   //                             //                     Container(
//   //                             //                       child: Image.file(newFile, fit: BoxFit.cover),
//   //                             //                     ),
//   //                             //                   );
//   //                             //                 });
//   //                             //               },
//   //                             //               child: Container(
//   //                             //                 width: SizeConfig.blockSizeVertical * 10,
//   //                             //                 child: Icon(Icons.add_rounded, color: Color(0xff000000), size: SizeConfig.blockSizeVertical * 7,),
//   //                             //                 decoration: BoxDecoration(
//   //                             //                   borderRadius: BorderRadius.circular(10),
//   //                             //                   color: Color(0xffcccccc),
//   //                             //                   border: Border.all(color: Color(0xff000000),),
//   //                             //                 ),
//   //                             //               ),
//   //                             //             );
//   //                             //           }else{
//   //                             //             return ReorderableWrap(
//   //                             //               children: slideImages,
//   //                             //               onReorder: onReorder,
//   //                             //             );
//   //                             //           }
//   //                             //         }());
//   //                             //       }),
//   //                             //     ),
//   //                             //   ),
//   //                             // ),

//   //                             // Container(
//   //                             //   height: SizeConfig.blockSizeVertical * 20,
//   //                             //   width: SizeConfig.screenWidth,
//   //                             //   color: Colors.red,
//   //                             //   child: ReorderableWrap(
//   //                             //     spacing: 8.0,
//   //                             //     runSpacing: 4.0,
//   //                             //     children: slideImages,
//   //                             //     onReorder: onReorder,
//   //                             //   ),
//   //                             // ),

//   //                             wrap,

//   //                             GestureDetector(
//   //                               onTap: () async{
//   //                                 // // await getSlideImage();
//   //                                 File newFile = await getSlideImage();

//   //                                 setState(() {
//   //                                   slideImages.add(
//   //                                     Container(
//   //                                       child: Image.file(newFile, fit: BoxFit.cover),
//   //                                     ),
//   //                                   );
//   //                                 });
//   //                               },
//   //                               child: Container(
//   //                                 width: SizeConfig.blockSizeVertical * 10,
//   //                                 child: Icon(Icons.add_rounded, color: Color(0xff000000), size: SizeConfig.blockSizeVertical * 7,),
//   //                                 decoration: BoxDecoration(
//   //                                   borderRadius: BorderRadius.circular(10),
//   //                                   color: Color(0xffcccccc),
//   //                                   border: Border.all(color: Color(0xff000000),),
//   //                                 ),
//   //                               ),
//   //                             ),


//   //                             Text('Drag & drop to rearrange images.',style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 3.5,fontWeight: FontWeight.w300, color: Color(0xff000000),),),
//   //                           ],
//   //                         ); break;


//   //                         // case 2: return Column(
//   //                         //   children: [
//   //                         //     Container(
//   //                         //       height: SizeConfig.blockSizeVertical * 32,
//   //                         //       child: Container(
//   //                         //         height: SizeConfig.blockSizeVertical * 12,
//   //                         //         child: GridView.count(
//   //                         //           physics: ClampingScrollPhysics(),
//   //                         //           crossAxisCount: 4,
//   //                         //           crossAxisSpacing: 4,
//   //                         //           mainAxisSpacing: 4,
//   //                         //           children: List.generate(slideImages.length + 1, (index){
//   //                         //             return ((){
//   //                         //               if(index == slideImages.length){
//   //                         //                 // return GestureDetector(
//   //                         //                 //   onTap: () async{
//   //                         //                 //     // await getSlideImage();
//   //                         //                 //     File newFile = await getSlideImage();

//   //                         //                 //     setState(() {
//   //                         //                 //       slideImages.add(newFile);
//   //                         //                 //     });
//   //                         //                 //   },
//   //                         //                 //   child: Container(
//   //                         //                 //     width: SizeConfig.blockSizeVertical * 10,
//   //                         //                 //     child: Icon(Icons.add_rounded, color: Color(0xff000000), size: SizeConfig.blockSizeVertical * 7,),
//   //                         //                 //     decoration: BoxDecoration(
//   //                         //                 //       borderRadius: BorderRadius.circular(10),
//   //                         //                 //       color: Color(0xffcccccc),
//   //                         //                 //       border: Border.all(color: Color(0xff000000),),
//   //                         //                 //     ),
//   //                         //                 //   ),
//   //                         //                 // );

//   //                         //                 return DragTarget(
//   //                         //                   builder: (context, ),
//   //                         //                 );
//   //                         //               }else{
//   //                         //                 return Container(
//   //                         //                   width: SizeConfig.blockSizeVertical * 10,
//   //                         //                   decoration: BoxDecoration(
//   //                         //                     borderRadius: BorderRadius.circular(10),
//   //                         //                     color: Color(0xffcccccc),
//   //                         //                     border: Border.all(color: Color(0xff000000),),
//   //                         //                     image: DecorationImage(
//   //                         //                       fit: BoxFit.cover,
//   //                         //                       image: AssetImage(slideImages[index].path),
//   //                         //                     ),
//   //                         //                   ),
//   //                         //                   child: Stack(
//   //                         //                     children: [
//   //                         //                       Center(
//   //                         //                         child: CircleAvatar(
//   //                         //                           radius: SizeConfig.blockSizeVertical * 3,
//   //                         //                           backgroundColor: Color(0xffffffff).withOpacity(.5),
//   //                         //                           child: Text(
//   //                         //                             index.toString(),
//   //                         //                             style: TextStyle(
//   //                         //                               fontSize: SizeConfig.safeBlockHorizontal * 7,
//   //                         //                               fontWeight: FontWeight.bold,
//   //                         //                               color: Color(0xffffffff),
//   //                         //                             ),
//   //                         //                           ),
//   //                         //                         ),
//   //                         //                       ),
//   //                         //                     ],
//   //                         //                   ),
//   //                         //                 );
//   //                         //               }

//   //                         //               // if(index == images.length){
//   //                         //               //   return Container(
//   //                         //               //     width: SizeConfig.blockSizeVertical * 10,
//   //                         //               //     child: Icon(Icons.add_rounded, color: Color(0xff000000), size: SizeConfig.blockSizeVertical * 7,),
//   //                         //               //     decoration: BoxDecoration(
//   //                         //               //       borderRadius: BorderRadius.circular(10),
//   //                         //               //       color: Color(0xffcccccc),
//   //                         //               //       border: Border.all(color: Color(0xff000000),),
//   //                         //               //     ),
//   //                         //               //   );
//   //                         //               // }else{
//   //                         //               //   return Container(
//   //                         //               //     width: SizeConfig.blockSizeVertical * 10,
//   //                         //               //     decoration: BoxDecoration(
//   //                         //               //       borderRadius: BorderRadius.circular(10),
//   //                         //               //       color: Color(0xffcccccc),
//   //                         //               //       border: Border.all(color: Color(0xff000000),),
//   //                         //               //       image: DecorationImage(
//   //                         //               //         image: AssetImage(images[index]),
//   //                         //               //       ),
//   //                         //               //     ),
//   //                         //               //     child: Stack(
//   //                         //               //       children: [
//   //                         //               //         Center(
//   //                         //               //           child: CircleAvatar(
//   //                         //               //             radius: SizeConfig.blockSizeVertical * 3,
//   //                         //               //             backgroundColor: Color(0xffffffff).withOpacity(.5),
//   //                         //               //             child: Text(
//   //                         //               //               index.toString(),
//   //                         //               //               style: TextStyle(
//   //                         //               //                 fontSize: SizeConfig.safeBlockHorizontal * 7,
//   //                         //               //                 fontWeight: FontWeight.bold,
//   //                         //               //                 color: Color(0xffffffff),
//   //                         //               //               ),
//   //                         //               //             ),
//   //                         //               //           ),
//   //                         //               //         ),
//   //                         //               //       ],
//   //                         //               //     ),
//   //                         //               //   );
//   //                         //               // }
//   //                         //             }());
//   //                         //           }),
//   //                         //         ),
//   //                         //       ),
//   //                         //     ),
//   //                         //     Text('Drag & drop to rearrange images.',style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 3.5,fontWeight: FontWeight.w300, color: Color(0xff000000),),),
//   //                         //   ],
//   //                         // ); break;
//   //                       }
//   //                     }()),
//   //                   ),

//   //                   SizedBox(height: SizeConfig.blockSizeVertical * 2,),

//   //                   Text('Describe the events that happened to your love one.',style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 3.5,fontWeight: FontWeight.w300, color: Color(0xff000000),),),

//   //                   SizedBox(height: SizeConfig.blockSizeVertical * 10,),

//   //                   MiscBLMButtonTemplate(
//   //                     onPressed: () async{
//   //                       if(_key8.currentState.controller.text == ''){
//   //                         await showDialog(context: (context), builder: (build) => MiscBLMAlertDialog(title: 'Error', content: 'Please complete the form before submitting.', confirmText: 'OK',),);
//   //                       }else{
//   //                         context.bloc<BlocBLMBLMCreateMemorial>().modify(2);
//   //                       }
//   //                     }, 
//   //                     width: SizeConfig.screenWidth / 2, 
//   //                     height: SizeConfig.blockSizeVertical * 7,
//   //                   ),

//   //                 ],
//   //               ),
//   //             ),
//   //           ],
//   //         );
//   //       },
//   //     ),
//   //     ),
//   //   );
//   // }
// }





// // import 'dart:math' as math;
// // import 'package:flutter/material.dart';
// // import 'package:reorderables/reorderables.dart';

// // class HomeCreateMemorial2 extends StatefulWidget {
// //   HomeCreateMemorial2({
// //     Key key,
// //     this.depth = 0,
// //     this.valuePrefix = '',
// //     this.color,
// //   }) : super(key: key);
// //   final int depth;
// //   final String valuePrefix;
// //   final Color color;
// //   final List<Widget> _tiles = [];

// //   @override
// //   HomeCreateMemorial2State createState() => HomeCreateMemorial2State();
// // }

// // class HomeCreateMemorial2State extends State<HomeCreateMemorial2> {
// // //  List<Widget> _tiles;
// //   Color _color;
// //   Color _colorBrighter;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _color = widget.color ?? Colors.primaries[widget.depth % Colors.primaries.length];
// //     _colorBrighter = Color.lerp(_color, Colors.white, 0.6);
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     void _onReorder(int oldIndex, int newIndex) {
// //       setState(() {
// //         widget._tiles.insert(newIndex, widget._tiles.removeAt(oldIndex));
// //       });
// //     }

// //     var wrap = ReorderableWrap(
// //       spacing: 8.0,
// //       runSpacing: 4.0,
// //       padding: const EdgeInsets.all(8),
// //       children: widget._tiles,
// //       onReorder: _onReorder,
// //       onNoReorder: (int index) {
// //         //this callback is optional
// //         debugPrint('${DateTime.now().toString().substring(5, 22)} reorder cancelled. index:$index');
// //       },
// //     );

// //     var buttonBar = Container(
// //       color: _colorBrighter,
// //       child: Row(
// //         mainAxisSize: MainAxisSize.min,
// //         mainAxisAlignment: MainAxisAlignment.start,
// //         children: <Widget>[
// //           IconButton(
// //             iconSize: 42,
// //             icon: Icon(Icons.add_circle),
// //             color: Colors.deepOrange,
// //             padding: const EdgeInsets.all(0.0),
// //             onPressed: () {
// //               setState(() {
// //                 widget._tiles.add(
// //                   Card(
// //                     child: Container(
// //                       child: Text('${widget.valuePrefix}${widget._tiles.length}', textScaleFactor: 3 / math.sqrt(widget.depth + 1)),
// //                       padding: EdgeInsets.all((24.0 / math.sqrt(widget.depth + 1)).roundToDouble()),
// //                     ),
// //                     color: _colorBrighter,
// //                     elevation: 3,
// //                   )
// //                 );
// //               });
// //             },
// //           ),
// //           IconButton(
// //             iconSize: 42,
// //             icon: Icon(Icons.remove_circle),
// //             color: Colors.teal,
// //             padding: const EdgeInsets.all(0.0),
// //             onPressed: () {
// //               setState(() {
// //                 widget._tiles.removeAt(0);
// //               });
// //             },
// //           ),
// //           IconButton(
// //             iconSize: 42,
// //             icon: Icon(Icons.add_to_photos),
// //             color: Colors.pink,
// //             padding: const EdgeInsets.all(0.0),
// //             onPressed: () {
// //               setState(() {
// //                 widget._tiles.add((HomeCreateMemorial2(depth: widget.depth + 1, valuePrefix: '${widget.valuePrefix}${widget._tiles.length}.',)));
// //               });
// //             },
// //           ),
// //           Text('Level ${widget.depth} / ${widget.valuePrefix}'),
// //         ],
// //       )
// //     );

// //     var column = Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         buttonBar,
// //         wrap,
// //       ]
// //     );

// //     return Scaffold(
// //       body: SingleChildScrollView(
// //         child: Container(child: column, color: _color,),
// //       ),
// //     );
// //   }
// // }