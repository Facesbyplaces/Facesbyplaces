// import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-07-regular-button.dart';
// import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-08-regular-dialog.dart';
// import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-10-regular-background.dart';
// import 'package:facesbyplaces/Configurations/size_configuration.dart';
// import 'package:facesbyplaces/Bloc/bloc-04-bloc-regular-home.dart';
// import 'package:facesbyplaces/Bloc/bloc-01-bloc.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter/material.dart';

// class HomeRegularCreateMemorial3 extends StatelessWidget{

//   final List<String> images = ['assets/icons/regular-image1.png', 'assets/icons/regular-image2.png', 'assets/icons/regular-image3.png', 'assets/icons/regular-image4.png'];

//   @override
//   Widget build(BuildContext context) {
//     SizeConfig.init(context);
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider<BlocHomeRegularBackgroundImage>(
//           create: (context) => BlocHomeRegularBackgroundImage(),
//         ),
//         BlocProvider<BlocShowLoading>(
//           create: (context) => BlocShowLoading(),
//         ),
//       ],
//       child: BlocBuilder<BlocShowLoading, bool>(
//         builder: (context, loading){
//           return ((){
//             switch(loading){
//               case false: return Scaffold(
//                 appBar: AppBar(
//                   title: Text('Create a Memorial Page for friends and family.', maxLines: 2, style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, fontWeight: FontWeight.bold, color: Color(0xffffffff))),
//                   centerTitle: true,
//                   backgroundColor: Color(0xff04ECFF),
//                   leading: IconButton(icon: Icon(Icons.arrow_back, color: Color(0xffffffff),), onPressed: (){Navigator.pop(context);},),
//                 ),
//                 body: Stack(
//                   children: [

//                     MiscRegularBackgroundTemplate(image: AssetImage('assets/icons/background2.png'),),

//                     Container(
//                       padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
//                       child: ListView(
//                         physics: ClampingScrollPhysics(),
//                         children: [

//                           SizedBox(height: SizeConfig.blockSizeVertical * 2,),

//                           Text('Upload or Select an Image', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 5, fontWeight: FontWeight.w400, color: Color(0xff000000),),),

//                           SizedBox(height: SizeConfig.blockSizeVertical * 2,),

//                           Container(
//                             height: SizeConfig.blockSizeVertical * 25,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(10),
//                               image: DecorationImage(
//                                 fit: BoxFit.cover,
//                                 image: AssetImage('assets/icons/upload_background.png'),
//                               ),
//                             ),
//                             child: Stack(
//                               children: [

//                                 Center(
//                                   child: CircleAvatar(
//                                     radius: SizeConfig.blockSizeVertical * 7,
//                                     backgroundColor: Color(0xffffffff),
//                                     child: Padding(
//                                       padding: EdgeInsets.all(5),
//                                       child: CircleAvatar(
//                                         radius: SizeConfig.blockSizeVertical * 7,
//                                         backgroundImage: AssetImage('assets/icons/profile1.png'),
//                                       ),
//                                     ),
//                                   ),
//                                 ),

//                                 Positioned(
//                                   bottom: SizeConfig.blockSizeVertical * 5,
//                                   left: SizeConfig.screenWidth / 2,
//                                   child: CircleAvatar(
//                                     radius: SizeConfig.blockSizeVertical * 3,
//                                     backgroundColor: Color(0xffffffff),
//                                     child: CircleAvatar(
//                                       radius: SizeConfig.blockSizeVertical * 3,
//                                       backgroundColor: Colors.transparent,
//                                       child: Icon(Icons.camera, color: Color(0xffaaaaaa), size: SizeConfig.blockSizeVertical * 5.5,),
//                                     ),
//                                   ),
//                                 ),

//                                 Positioned(
//                                   top: SizeConfig.blockSizeVertical * 1,
//                                   right: SizeConfig.blockSizeVertical * 1,
//                                   child: CircleAvatar(
//                                     radius: SizeConfig.blockSizeVertical * 3,
//                                     backgroundColor: Color(0xffffffff),
//                                     child: Icon(Icons.camera, color: Color(0xffaaaaaa), size: SizeConfig.blockSizeVertical * 5.5,),
//                                   ),
//                                 ),

//                               ],
//                             ),
//                           ),

//                           SizedBox(height: SizeConfig.blockSizeVertical * 2,),

//                           Text('Upload the best photo of the person in the memorial page.', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 3, fontWeight: FontWeight.w300, color: Color(0xff000000),),),

//                           SizedBox(height: SizeConfig.blockSizeVertical * 5,),

//                           Text('Choose Background', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 5, fontWeight: FontWeight.w400, color: Color(0xff000000),),),

//                           SizedBox(height: SizeConfig.blockSizeVertical * 2,),

//                           BlocBuilder<BlocHomeRegularBackgroundImage, int>(
//                             builder: (context, chooseBackgroundImage){
//                               return Container(
//                                 height: SizeConfig.blockSizeVertical * 12,
//                                 child: ListView.separated(
//                                   physics: ClampingScrollPhysics(),
//                                   scrollDirection: Axis.horizontal,
//                                   itemBuilder: (context, index){
//                                     return ((){
//                                       if(index == 4){
//                                         return GestureDetector(
//                                           onTap: (){
//                                             context.bloc<BlocHomeRegularBackgroundImage>().updateToggle(index);
//                                           },
//                                           child: Container(
//                                             width: SizeConfig.blockSizeVertical * 12,
//                                             height: SizeConfig.blockSizeVertical * 12,    
//                                             child: Icon(Icons.add_rounded, color: Color(0xff000000), size: SizeConfig.blockSizeVertical * 7,),
//                                             decoration: BoxDecoration(
//                                               borderRadius: BorderRadius.circular(10),
//                                               color: Color(0xffcccccc),
//                                               border: Border.all(color: Color(0xff000000),),
//                                             ),
//                                           ),
//                                         );
//                                       }else{
//                                         return GestureDetector(
//                                           onTap: (){
//                                             context.bloc<BlocHomeRegularBackgroundImage>().updateToggle(index);
//                                           },
//                                           child: chooseBackgroundImage == index
//                                           ? Container(
//                                             padding: EdgeInsets.all(5),
//                                             width: SizeConfig.blockSizeVertical * 12,
//                                             height: SizeConfig.blockSizeVertical * 12,
//                                             decoration: BoxDecoration(
//                                               color: Color(0xff04ECFF),
//                                               borderRadius: BorderRadius.circular(10),
//                                             ),
//                                             child: Container(
//                                               width: SizeConfig.blockSizeVertical * 10,
//                                               height: SizeConfig.blockSizeVertical * 10,
//                                               decoration: BoxDecoration(
//                                                 borderRadius: BorderRadius.circular(10),
//                                                 image: DecorationImage(
//                                                   fit: BoxFit.cover,
//                                                   image: AssetImage(images[index]),
//                                                 ),
//                                               ),
//                                             ),
//                                           )
//                                           : Container(
//                                             padding: EdgeInsets.all(5),
//                                             width: SizeConfig.blockSizeVertical * 12,
//                                             height: SizeConfig.blockSizeVertical * 12,
//                                             decoration: BoxDecoration(
//                                               borderRadius: BorderRadius.circular(10),
//                                             ),
//                                             child: Container(
//                                               width: SizeConfig.blockSizeVertical * 10,
//                                               height: SizeConfig.blockSizeVertical * 10,
//                                               decoration: BoxDecoration(
//                                                 borderRadius: BorderRadius.circular(10),
//                                                 image: DecorationImage(
//                                                   fit: BoxFit.cover,
//                                                   image: AssetImage(images[index]),
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         );
//                                       }
//                                     }());
//                                   }, 
//                                   separatorBuilder: (context, index){
//                                     return SizedBox(width: SizeConfig.blockSizeHorizontal * 3,);
//                                   },
//                                   itemCount: 5,
//                                 ),
//                               );
//                             }
//                           ),

//                           SizedBox(height: SizeConfig.blockSizeVertical * 2,),

//                           Text('Upload your own or select from the pre-mades.', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 3, fontWeight: FontWeight.w300, color: Color(0xff000000),),),

//                           SizedBox(height: SizeConfig.blockSizeVertical * 10,),

//                           MiscRegularButtonTemplate(
//                             onPressed: () async{

//                               // APIRegularCreateMemorial memorial;

//                               // context.bloc<BlocShowLoading>().modify(true);
//                               // bool result = await apiRegularCreateMemorial(memorial);
//                               // context.bloc<BlocShowLoading>().modify(false);

//                               // if(result){
//                               //   Navigator.pushReplacementNamed(context, '/home/regular/home-08-regular-memorial-profile');
//                               // }else{
//                               //   await showDialog(context: (context), builder: (build) => MiscRegularAlertDialog(title: 'Error', content: 'Something went wrong. Please try again.'));
//                               // }
//                           }, 
//                           width: SizeConfig.screenWidth / 2, 
//                           height: SizeConfig.blockSizeVertical * 7),

//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ); break;
//               case true: return Scaffold(body: Container(height: SizeConfig.screenHeight, child: Center(child: Container(child: SpinKitThreeBounce(color: Color(0xff000000), size: 50.0,), color: Color(0xffffffff),),)),); break;
//             }
//           }());
//         },
//       ),
//     );
//   }
// }


// ===================================================================================================

// import 'package:facesbyplaces/API/Regular/api-06-regular-create-memorial.dart';
// import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-07-regular-button.dart';
// import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-08-regular-dialog.dart';
// import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-10-regular-background.dart';
// import 'package:facesbyplaces/Configurations/size_configuration.dart';
// import 'package:facesbyplaces/Bloc/bloc-04-bloc-regular-home.dart';
// import 'package:facesbyplaces/Bloc/bloc-01-bloc.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter/material.dart';

// class HomeRegularCreateMemorial3 extends StatelessWidget{

//   final List<String> images = ['assets/icons/regular-image1.png', 'assets/icons/regular-image2.png', 'assets/icons/regular-image3.png', 'assets/icons/regular-image4.png'];

//   @override
//   Widget build(BuildContext context) {
//     SizeConfig.init(context);
//     return BlocBuilder<BlocShowLoading, bool>(
//       builder: (context, loading){
//         return ((){
//           switch(loading){
//             case false: return Stack(
//               children: [

//                 MiscRegularBackgroundTemplate(image: AssetImage('assets/icons/background2.png'),),

//                 Container(
//                   padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
//                   child: ListView(
//                     physics: ClampingScrollPhysics(),
//                     children: [

//                       SizedBox(height: SizeConfig.blockSizeVertical * 2,),

//                       Text('Upload or Select an Image', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 5, fontWeight: FontWeight.w400, color: Color(0xff000000),),),

//                       SizedBox(height: SizeConfig.blockSizeVertical * 2,),

//                       Container(
//                         height: SizeConfig.blockSizeVertical * 25,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(10),
//                           image: DecorationImage(
//                             fit: BoxFit.cover,
//                             image: AssetImage('assets/icons/upload_background.png'),
//                           ),
//                         ),
//                         child: Stack(
//                           children: [

//                             Center(
//                               child: CircleAvatar(
//                                 radius: SizeConfig.blockSizeVertical * 7,
//                                 backgroundColor: Color(0xffffffff),
//                                 child: Padding(
//                                   padding: EdgeInsets.all(5),
//                                   child: CircleAvatar(
//                                     radius: SizeConfig.blockSizeVertical * 7,
//                                     backgroundImage: AssetImage('assets/icons/profile1.png'),
//                                   ),
//                                 ),
//                               ),
//                             ),

//                             Positioned(
//                               bottom: SizeConfig.blockSizeVertical * 5,
//                               left: SizeConfig.screenWidth / 2,
//                               child: CircleAvatar(
//                                 radius: SizeConfig.blockSizeVertical * 3,
//                                 backgroundColor: Color(0xffffffff),
//                                 child: CircleAvatar(
//                                   radius: SizeConfig.blockSizeVertical * 3,
//                                   backgroundColor: Colors.transparent,
//                                   child: Icon(Icons.camera, color: Color(0xffaaaaaa), size: SizeConfig.blockSizeVertical * 5.5,),
//                                 ),
//                               ),
//                             ),

//                             Positioned(
//                               top: SizeConfig.blockSizeVertical * 1,
//                               right: SizeConfig.blockSizeVertical * 1,
//                               child: CircleAvatar(
//                                 radius: SizeConfig.blockSizeVertical * 3,
//                                 backgroundColor: Color(0xffffffff),
//                                 child: Icon(Icons.camera, color: Color(0xffaaaaaa), size: SizeConfig.blockSizeVertical * 5.5,),
//                               ),
//                             ),

//                           ],
//                         ),
//                       ),

//                       SizedBox(height: SizeConfig.blockSizeVertical * 2,),

//                       Text('Upload the best photo of the person in the memorial page.', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 3, fontWeight: FontWeight.w300, color: Color(0xff000000),),),

//                       SizedBox(height: SizeConfig.blockSizeVertical * 5,),

//                       Text('Choose Background', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 5, fontWeight: FontWeight.w400, color: Color(0xff000000),),),

//                       SizedBox(height: SizeConfig.blockSizeVertical * 2,),

//                       BlocBuilder<BlocHomeRegularBackgroundImage, int>(
//                         builder: (context, chooseBackgroundImage){
//                           return Container(
//                             height: SizeConfig.blockSizeVertical * 12,
//                             child: ListView.separated(
//                               physics: ClampingScrollPhysics(),
//                               scrollDirection: Axis.horizontal,
//                               itemBuilder: (context, index){
//                                 return ((){
//                                   if(index == 4){
//                                     return GestureDetector(
//                                       onTap: (){
//                                         context.bloc<BlocHomeRegularBackgroundImage>().updateToggle(index);
//                                       },
//                                       child: Container(
//                                         width: SizeConfig.blockSizeVertical * 12,
//                                         height: SizeConfig.blockSizeVertical * 12,    
//                                         child: Icon(Icons.add_rounded, color: Color(0xff000000), size: SizeConfig.blockSizeVertical * 7,),
//                                         decoration: BoxDecoration(
//                                           borderRadius: BorderRadius.circular(10),
//                                           color: Color(0xffcccccc),
//                                           border: Border.all(color: Color(0xff000000),),
//                                         ),
//                                       ),
//                                     );
//                                   }else{
//                                     return GestureDetector(
//                                       onTap: (){
//                                         context.bloc<BlocHomeRegularBackgroundImage>().updateToggle(index);
//                                       },
//                                       child: chooseBackgroundImage == index
//                                       ? Container(
//                                         padding: EdgeInsets.all(5),
//                                         width: SizeConfig.blockSizeVertical * 12,
//                                         height: SizeConfig.blockSizeVertical * 12,
//                                         decoration: BoxDecoration(
//                                           color: Color(0xff04ECFF),
//                                           borderRadius: BorderRadius.circular(10),
//                                         ),
//                                         child: Container(
//                                           width: SizeConfig.blockSizeVertical * 10,
//                                           height: SizeConfig.blockSizeVertical * 10,
//                                           decoration: BoxDecoration(
//                                             borderRadius: BorderRadius.circular(10),
//                                             image: DecorationImage(
//                                               fit: BoxFit.cover,
//                                               image: AssetImage(images[index]),
//                                             ),
//                                           ),
//                                         ),
//                                       )
//                                       : Container(
//                                         padding: EdgeInsets.all(5),
//                                         width: SizeConfig.blockSizeVertical * 12,
//                                         height: SizeConfig.blockSizeVertical * 12,
//                                         decoration: BoxDecoration(
//                                           borderRadius: BorderRadius.circular(10),
//                                         ),
//                                         child: Container(
//                                           width: SizeConfig.blockSizeVertical * 10,
//                                           height: SizeConfig.blockSizeVertical * 10,
//                                           decoration: BoxDecoration(
//                                             borderRadius: BorderRadius.circular(10),
//                                             image: DecorationImage(
//                                               fit: BoxFit.cover,
//                                               image: AssetImage(images[index]),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     );
//                                   }
//                                 }());
//                               }, 
//                               separatorBuilder: (context, index){
//                                 return SizedBox(width: SizeConfig.blockSizeHorizontal * 3,);
//                               },
//                               itemCount: 5,
//                             ),
//                           );
//                         }
//                       ),

//                       SizedBox(height: SizeConfig.blockSizeVertical * 2,),

//                       Text('Upload your own or select from the pre-mades.', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 3, fontWeight: FontWeight.w300, color: Color(0xff000000),),),

//                       SizedBox(height: SizeConfig.blockSizeVertical * 10,),

//                       MiscRegularButtonTemplate(
//                         onPressed: () async{

//                           APIRegularCreateMemorial memorial = APIRegularCreateMemorial();

//                           context.bloc<BlocShowLoading>().modify(true);
//                           bool result = await apiRegularCreateMemorial(memorial);
//                           context.bloc<BlocShowLoading>().modify(false);

//                           if(result){
//                             Navigator.pushReplacementNamed(context, '/home/regular/home-08-regular-memorial-profile');
//                           }else{
//                             await showDialog(context: (context), builder: (build) => MiscRegularAlertDialog(title: 'Error', content: 'Something went wrong. Please try again.'));
//                           }
//                       }, 
//                       width: SizeConfig.screenWidth / 2, 
//                       height: SizeConfig.blockSizeVertical * 7),

//                     ],
//                   ),
//                 ),
//               ],
//             ); break;
//             case true: return Container(height: SizeConfig.screenHeight, child: Center(child: Container(child: SpinKitThreeBounce(color: Color(0xff000000), size: 50.0,), color: Color(0xffffffff),),));
//           }
//         }());
//       },
//     );
//   }
// }

