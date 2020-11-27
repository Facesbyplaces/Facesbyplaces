

// import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-01-blm-input-field.dart';
// import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-02-blm-dialog.dart';
// import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-07-blm-button.dart';
// import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-08-blm-background.dart';
// import 'package:facesbyplaces/Configurations/size_configuration.dart';
// import 'package:flutter/material.dart';

// class HomeBLMCreateMemorial extends StatelessWidget{

//   final GlobalKey<MiscBLMInputFieldTemplateState> _key1 = GlobalKey<MiscBLMInputFieldTemplateState>();
//   final GlobalKey<MiscBLMInputFieldTemplateState> _key2 = GlobalKey<MiscBLMInputFieldTemplateState>();
//   final GlobalKey<MiscBLMInputFieldTemplateState> _key3 = GlobalKey<MiscBLMInputFieldTemplateState>();
//   final GlobalKey<MiscBLMInputFieldTemplateState> _key4 = GlobalKey<MiscBLMInputFieldTemplateState>();
//   final GlobalKey<MiscBLMInputFieldTemplateState> _key5 = GlobalKey<MiscBLMInputFieldTemplateState>();
//   final GlobalKey<MiscBLMInputFieldTemplateState> _key6 = GlobalKey<MiscBLMInputFieldTemplateState>();
//   final GlobalKey<MiscBLMInputFieldTemplateState> _key7 = GlobalKey<MiscBLMInputFieldTemplateState>();

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
//             title: Text('Cry out for the Victims', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xffffffff))),
//             centerTitle: true,
//             leading: IconButton(
//               icon: Icon(Icons.arrow_back, color: Color(0xffffffff),), 
//               onPressed: (){
//                 Navigator.popUntil(context, ModalRoute.withName('/home/blm'),);
//               }
//             ),
//           ),
//           body: Stack(
//             children: [

//               SingleChildScrollView(
//                 physics: NeverScrollableScrollPhysics(),
//                 child: Container(height: SizeConfig.screenHeight, child: MiscBLMBackgroundTemplate(image: AssetImage('assets/icons/background2.png'),),),
//               ),

//               Container(
//                 padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
//                 child: ListView(
//                   physics: ClampingScrollPhysics(),
//                   children: [
//                     MiscBLMInputFieldDropDown(key: _key1,),

//                     SizedBox(height: SizeConfig.blockSizeVertical * 2,),

//                     MiscBLMInputFieldTemplate(key: _key2, labelText: 'Location of the incident'),

//                     SizedBox(height: SizeConfig.blockSizeVertical * 2,),

//                     MiscBLMInputFieldTemplate(key: _key3, labelText: 'Precinct / Station House (Optional)'),

//                     SizedBox(height: SizeConfig.blockSizeVertical * 2,),

//                     MiscBLMInputFieldTemplate(key: _key4, labelText: 'DOB'),

//                     SizedBox(height: SizeConfig.blockSizeVertical * 2,),

//                     MiscBLMInputFieldTemplate(key: _key5, labelText: 'RIP'),

//                     SizedBox(height: SizeConfig.blockSizeVertical * 2,),

//                     MiscBLMInputFieldTemplate(key: _key6, labelText: 'Country'),

//                     SizedBox(height: SizeConfig.blockSizeVertical * 2,),

//                     MiscBLMInputFieldTemplate(key: _key7, labelText: 'State'),

//                     SizedBox(height: SizeConfig.blockSizeVertical * 5,),

//                     MiscBLMButtonTemplate(
//                       onPressed: () async{

//                         if(_key2.currentState.controller.text == '' || _key4.currentState.controller.text == '' || 
//                         _key5.currentState.controller.text == '' || _key6.currentState.controller.text == '' || _key7.currentState.controller.text == ''){
//                           await showDialog(context: (context), builder: (build) => MiscBLMAlertDialog(title: 'Error', content: 'Please complete the form before submitting.', confirmText: 'OK',),);
//                         }else{
//                           Navigator.pushNamed(context, '/home/blm/home-07-02-blm-create-memorial');
//                         }

//                       }, 
//                       width: SizeConfig.screenWidth / 2, 
//                       height: SizeConfig.blockSizeVertical * 7
//                     ),

//                   ],
//                 ),
//               ),

//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }







// import 'package:facesbyplaces/API/BLM/api-09-blm-create-post.dart';
// import 'package:facesbyplaces/Bloc/bloc-01-bloc.dart';
// import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-01-blm-input-field.dart';
// import 'package:facesbyplaces/Configurations/size_configuration.dart';
// import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-02-blm-dialog.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';

// class HomeBLMCreatePost extends StatelessWidget{

//   final GlobalKey<MiscBLMInputFieldTemplateState> _key1 = GlobalKey<MiscBLMInputFieldTemplateState>();

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
//         child: MultiBlocProvider(
//           providers: [
//             BlocProvider<BlocShowLoading>(create: (context) => BlocShowLoading(),)
//           ],
//           child: BlocBuilder<BlocShowLoading, bool>(
//             builder: (context, loading){
//               return ((){
//                 switch(loading){
//                   case false: return Scaffold(
//                     appBar: AppBar(
//                       backgroundColor: Color(0xff04ECFF),
//                       leading: Builder(
//                         builder: (context){
//                           return IconButton(
//                             icon: Icon(Icons.arrow_back, color: Color(0xffffffff),),
//                             onPressed: (){
//                               Navigator.popAndPushNamed(context, '/home/blm');
//                             },
//                           );
//                         },
//                       ),
//                       title: Text('Post', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xffffffff),),), 
//                       actions: [
//                         GestureDetector(
//                           onTap: () async{

//                             context.bloc<BlocShowLoading>().modify(true);
//                             bool result = await apiRegularHomeCreatePost();
//                             context.bloc<BlocShowLoading>().modify(false);

//                             if(result){
//                               Navigator.popAndPushNamed(context, '/home/blm');
//                             }else{
//                               await showDialog(context: (context), builder: (build) => MiscBLMAlertDialog(title: 'Error', content: 'Something went wrong. Please try again.'));
//                             }
//                           }, 
//                           child: Padding(
//                             padding: EdgeInsets.only(right: 20.0), 
//                             child: Center(
//                               child: Text('Post', 
//                               style: TextStyle(
//                                 color: Color(0xffffffff), 
//                                 fontSize: SizeConfig.safeBlockHorizontal * 5,),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     body: ListView(
//                       physics: ClampingScrollPhysics(),
//                       children: [

//                         Container(
//                           height: SizeConfig.blockSizeVertical * 10,
                          
//                           child: Row(
//                             children: [
//                               Expanded(
//                                 child: CircleAvatar(
//                                   radius: SizeConfig.blockSizeVertical * 3,
//                                   child: Container(
//                                     height: SizeConfig.blockSizeVertical * 17,
//                                     child: Image.asset('assets/icons/profile1.png', fit: BoxFit.cover,),
//                                   ),
//                                 ),
//                               ),
//                               Expanded(
//                                 flex: 3,
//                                 child: Text('Richard Nedd Memories',
//                                   style: TextStyle(
//                                     fontSize: SizeConfig.safeBlockHorizontal * 4,
//                                     fontWeight: FontWeight.bold,
//                                     color: Color(0xff000000),
//                                   ),
//                                 ),
//                               ),
//                               Expanded(
//                                 child: Center(
//                                   child: IconButton(
//                                     onPressed: (){},
//                                     icon: Icon(Icons.arrow_drop_down, color: Color(0xff000000),),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           decoration: BoxDecoration(
//                             color: Color(0xffffffff),
//                             boxShadow: <BoxShadow>[
//                               BoxShadow(
//                                 color: Colors.grey.withOpacity(0.5),
//                                 spreadRadius: 1,
//                                 blurRadius: 5,
//                                 offset: Offset(0, 0)
//                               ),
//                             ],
//                           ),
//                         ),

//                         SizedBox(height: SizeConfig.blockSizeVertical * 1,),

//                         Padding(padding: EdgeInsets.only(left: 20.0, right: 20.0), child: MiscBLMInputFieldTemplate(key: _key1, labelText: 'Speak out...', maxLines: 10),),

//                         Container(height: SizeConfig.blockSizeVertical * 25, child: Image.asset('assets/icons/upload_background.png', fit: BoxFit.cover),),

//                         Container(
//                           height: SizeConfig.blockSizeVertical * 20,
//                           child: Column(
//                             children: [
//                               Expanded(
//                                 child: Container(
//                                   padding: EdgeInsets.only(left: 20.0),
//                                   color: Color(0xffffffff),
//                                   child: Row(
//                                     children: [
//                                       Expanded(
//                                         flex: 2,
//                                         child: Text('Add a location'),
//                                       ),
//                                       Expanded(
//                                         child: Icon(Icons.place, color: Color(0xff4EC9D4),)
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),

//                               Container(height: SizeConfig.blockSizeVertical * .1, color: Color(0xffeeeeee),),

//                               Expanded(
//                                 child: Container(
//                                   padding: EdgeInsets.only(left: 20.0),
//                                   color: Color(0xffffffff),
//                                   child: Row(
//                                     children: [
//                                       Expanded(
//                                         flex: 2,
//                                         child: Text('Tag a person you are with'),
//                                       ),
//                                       Expanded(
//                                         child: Icon(Icons.person, color: Color(0xff4EC9D4),)
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),

//                               Container(height: SizeConfig.blockSizeVertical * .1, color: Color(0xffeeeeee),),

//                               Expanded(
//                                 child: Container(
//                                   padding: EdgeInsets.only(left: 20.0),
//                                   color: Color(0xffffffff),
//                                   child: Row(
//                                     children: [
//                                       Expanded(
//                                         flex: 2,
//                                         child: Text('Upload a Video / Image'),
//                                       ),
//                                       Expanded(
//                                         child: Icon(Icons.image, color: Color(0xff4EC9D4),)
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),

//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ); break;
//                   case true: return Scaffold(body: Container(height: SizeConfig.screenHeight, child: Center(child: Container(child: SpinKitThreeBounce(color: Color(0xff000000), size: 50.0,), color: Color(0xffffffff),),)),); break;
//                 }
//               }());
//             }
//           ),
//         ),
//       ),
//     );
//   }
// }



