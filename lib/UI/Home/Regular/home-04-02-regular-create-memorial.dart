// import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-06-regular-input-field.dart';
// import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-07-regular-button.dart';
// import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-08-regular-dialog.dart';
// import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-09-regular-extra.dart';
// import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-10-regular-background.dart';
// import 'package:facesbyplaces/Configurations/size_configuration.dart';
// import 'package:facesbyplaces/Bloc/bloc-04-bloc-regular-home.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter/material.dart';

// class HomeRegularCreateMemorial2 extends StatelessWidget{

//   final GlobalKey<MiscRegularInputFieldTemplateState> _key1 = GlobalKey<MiscRegularInputFieldTemplateState>();
//   final GlobalKey<MiscRegularInputFieldMultiTextTemplateState> _key2 = GlobalKey<MiscRegularInputFieldMultiTextTemplateState>();

//   final List<String> images = ['assets/icons/profile_post1.png', 'assets/icons/profile_post2.png', 'assets/icons/profile_post3.png', 'assets/icons/profile_post4.png', 'assets/icons/profile_post2.png', 'assets/icons/profile_post3.png',];

//   @override
//   Widget build(BuildContext context) {
//     SizeConfig.init(context);
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider<BlocHomeRegularStoryType>(
//           create: (context) => BlocHomeRegularStoryType(),
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
//               title: Text('Create a Memorial Page for friends and family.', maxLines: 2, style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, fontWeight: FontWeight.bold, color: Color(0xffffffff))),
//               centerTitle: true,
//               backgroundColor: Color(0xff04ECFF),
//               leading: IconButton(icon: Icon(Icons.arrow_back, color: Color(0xffffffff),), onPressed: (){Navigator.pop(context);},),
//             ),
//             body: BlocBuilder<BlocHomeRegularStoryType, int>(
//               builder: (context, storyType){
//                 return Stack(
//                   children: [

//                     SingleChildScrollView(physics: NeverScrollableScrollPhysics(), child: Container(height: SizeConfig.screenHeight, child: MiscRegularBackgroundTemplate(image: AssetImage('assets/icons/background2.png'),),),),

//                     Container(
//                       padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
//                       child: ListView(
//                         physics: ClampingScrollPhysics(),
//                         children: [

//                           MiscRegularInputFieldTemplate(key: _key1, labelText: 'Name of your Memorial Page'),

//                           SizedBox(height: SizeConfig.blockSizeVertical * 5,),

//                           Row(
//                             children: [
//                               Text('Share your Story', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, fontWeight: FontWeight.w300, color: Color(0xff000000),),),

//                               SizedBox(width: SizeConfig.blockSizeHorizontal * 5,),

//                               Expanded(child: MiscRegularStoryType(),),
//                             ],
//                           ),

//                           ((){
//                             switch(storyType){
//                               case 0: return MiscRegularInputFieldMultiTextTemplate(key: _key2,); break;
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
//                           }()),


//                           SizedBox(height: SizeConfig.blockSizeVertical * 2,),

//                           Text('Describe the events that happened to your love one.',style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 3.5,fontWeight: FontWeight.w300, color: Color(0xff000000),),),

//                           SizedBox(height: SizeConfig.blockSizeVertical * 10,),

//                           MiscRegularButtonTemplate(
//                             buttonColor: Color(0xff04ECFF),
//                             onPressed: () async{
//                               // memorial.memorialName = _key1.currentState.controller.text;
//                               // memorial.description = _key2.currentState.controller.text;

//                               if(_key1.currentState.controller.text == ''){
//                                 await showDialog(context: (context), builder: (build) => MiscRegularAlertDialog(title: 'Error', content: 'Please complete the form before submitting.', confirmText: 'OK',),);
//                               }else{
//                                 Navigator.pushNamed(context, '/home/regular/home-04-03-regular-create-memorial');
//                               }
//                             }, 
//                             width: SizeConfig.screenWidth / 2, 
//                             height: SizeConfig.blockSizeVertical * 7,
//                           ),

//                         ],
//                       ),
//                     ),

//                   ],
//                 );
//               },
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }



// ===================================================================================================


// import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-06-regular-input-field.dart';
// import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-07-regular-button.dart';
// import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-08-regular-dialog.dart';
// import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-09-regular-extra.dart';
// import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-10-regular-background.dart';
// import 'package:facesbyplaces/Configurations/size_configuration.dart';
// import 'package:facesbyplaces/Bloc/bloc-04-bloc-regular-home.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter/material.dart';

// // class HomeRegularCreateMemorial2 extends StatelessWidget{

// class HomeRegularCreateMemorial2 extends StatefulWidget{

//   HomeRegularCreateMemorial2State createState() => HomeRegularCreateMemorial2State();
// }

// class HomeRegularCreateMemorial2State extends State<HomeRegularCreateMemorial2>{

//   final GlobalKey<MiscRegularInputFieldTemplateState> _key1 = GlobalKey<MiscRegularInputFieldTemplateState>();
//   final GlobalKey<MiscRegularInputFieldMultiTextTemplateState> _key2 = GlobalKey<MiscRegularInputFieldMultiTextTemplateState>();

//   final List<String> images = ['assets/icons/profile_post1.png', 'assets/icons/profile_post2.png', 'assets/icons/profile_post3.png', 'assets/icons/profile_post4.png', 'assets/icons/profile_post2.png', 'assets/icons/profile_post3.png',];

//   @override
//   Widget build(BuildContext context) {
//     SizeConfig.init(context);
//     return BlocBuilder<BlocHomeRegularStoryType, int>(
//       builder: (context, storyType){
//         return Stack(
//           children: [

//             SingleChildScrollView(physics: NeverScrollableScrollPhysics(), child: Container(height: SizeConfig.screenHeight, child: MiscRegularBackgroundTemplate(image: AssetImage('assets/icons/background2.png'),),),),

//             Container(
//               padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
//               child: ListView(
//                 physics: ClampingScrollPhysics(),
//                 children: [

//                   MiscRegularInputFieldTemplate(key: _key1, labelText: 'Name of your Memorial Page'),

//                   SizedBox(height: SizeConfig.blockSizeVertical * 5,),

//                   Row(
//                     children: [
//                       Text('Share your Story', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, fontWeight: FontWeight.w300, color: Color(0xff000000),),),

//                       SizedBox(width: SizeConfig.blockSizeHorizontal * 5,),

//                       Expanded(child: MiscRegularStoryType(),),
//                     ],
//                   ),

//                   ((){
//                     switch(storyType){
//                       case 0: return MiscRegularInputFieldMultiTextTemplate(key: _key2,); break;
//                       case 1: return Container(
//                         height: SizeConfig.blockSizeVertical * 34.5,
//                         child: Icon(Icons.upload_rounded, color: Color(0xff888888), size: SizeConfig.blockSizeVertical * 20,),
//                         decoration: BoxDecoration(
//                           color: Color(0xffcccccc),
//                           border: Border.all(color: Color(0xff000000),),
//                           borderRadius: BorderRadius.all(Radius.circular(10)),
//                         ),
//                       ); break;
//                       case 2: return Column(
//                         children: [
//                           Container(
//                             height: SizeConfig.blockSizeVertical * 32,
//                             child: Container(
//                               height: SizeConfig.blockSizeVertical * 12,
//                               child: GridView.count(
//                                 shrinkWrap: true,
//                                 crossAxisCount: 4,
//                                 crossAxisSpacing: 4,
//                                 mainAxisSpacing: 4,
//                                 children: List.generate(7, (index){
//                                   return ((){
//                                     if(index == images.length){
//                                       return Container(
//                                         width: SizeConfig.blockSizeVertical * 10,
//                                         child: Icon(Icons.add_rounded, color: Color(0xff000000), size: SizeConfig.blockSizeVertical * 7,),
//                                         decoration: BoxDecoration(
//                                           borderRadius: BorderRadius.circular(10),
//                                           color: Color(0xffcccccc),
//                                           border: Border.all(color: Color(0xff000000),),
//                                         ),
//                                       );
//                                     }else{
//                                       return Container(
//                                         width: SizeConfig.blockSizeVertical * 10,
//                                         decoration: BoxDecoration(
//                                           borderRadius: BorderRadius.circular(10),
//                                           color: Color(0xffcccccc),
//                                           border: Border.all(color: Color(0xff000000),),
//                                           image: DecorationImage(
//                                             image: AssetImage(images[index]),
//                                           ),
//                                         ),
//                                         child: Stack(
//                                           children: [
//                                             Center(
//                                               child: CircleAvatar(
//                                                 radius: SizeConfig.blockSizeVertical * 3,
//                                                 backgroundColor: Color(0xffffffff).withOpacity(.5),
//                                                 child: Text(
//                                                   index.toString(),
//                                                   style: TextStyle(
//                                                     fontSize: SizeConfig.safeBlockHorizontal * 7,
//                                                     fontWeight: FontWeight.bold,
//                                                     color: Color(0xffffffff),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       );
//                                     }
//                                   }());
//                                 }),
//                               ),
                              
//                             ),
//                           ),

//                           Text('Drag & drop to rearrange images.',style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 3.5,fontWeight: FontWeight.w300, color: Color(0xff000000),),),
//                         ],
//                       ); break;
//                     }
//                   }()),


//                   SizedBox(height: SizeConfig.blockSizeVertical * 2,),

//                   Text('Describe the events that happened to your love one.',style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 3.5,fontWeight: FontWeight.w300, color: Color(0xff000000),),),

//                   SizedBox(height: SizeConfig.blockSizeVertical * 10,),

//                   MiscRegularButtonTemplate(
//                     buttonColor: Color(0xff04ECFF),
//                     onPressed: () async{
//                       // memorial.memorialName = _key1.currentState.controller.text;
//                       // memorial.description = _key2.currentState.controller.text;

//                       if(_key1.currentState.controller.text == ''){
//                         await showDialog(context: (context), builder: (build) => MiscRegularAlertDialog(title: 'Error', content: 'Please complete the form before submitting.', confirmText: 'OK',),);
//                       }else{
//                         // Navigator.pushNamed(context, '/home/regular/home-04-03-regular-create-memorial');
//                         context.bloc<BlocHomeRegularCreateMemorial>().modify(2);
//                       }
//                     }, 
//                     width: SizeConfig.screenWidth / 2, 
//                     height: SizeConfig.blockSizeVertical * 7,
//                   ),

//                 ],
//               ),
//             ),

//           ],
//         );
//       },
//     );
//   }
// }