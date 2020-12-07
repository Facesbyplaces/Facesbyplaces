

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











// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:facesbyplaces/API/BLM/api-10-blm-show-memorial.dart';
// import 'package:facesbyplaces/API/BLM/api-15-blm-show-profile-post.dart';
// import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-05-blm-post.dart';
// import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-09-blm-message.dart';
// import 'package:facesbyplaces/Configurations/size_configuration.dart';
// import 'package:flutter_share/flutter_share.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:flutter/material.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';

// class HomeBLMProfile extends StatefulWidget{

//   HomeBLMProfileState createState() => HomeBLMProfileState();
// }

// class HomeBLMProfileState extends State<HomeBLMProfile>{

//   int page = 1;
//   int itemRemaining = 1;
//   int memorialId;
//   List<String> items = ["1", "2", "3", "4", "5", "6", "7", "8"];
//   List<Widget> feeds = [];
//   RefreshController refreshController = RefreshController(initialRefresh: true);

//   void initState(){
//     super.initState();
//     onLoading();
//   }

//   String convertDate(String input){
//     DateTime dateTime = DateTime.parse(input);

//     final y = dateTime.year.toString().padLeft(4, '0');
//     final m = dateTime.month.toString().padLeft(2, '0');
//     final d = dateTime.day.toString().padLeft(2, '0');
//     return '$d/$m/$y';
//   }

//   void onRefresh() async{
//     await Future.delayed(Duration(milliseconds: 1000));
//     refreshController.refreshCompleted();
//   }

//   void onLoading() async{
//     if(itemRemaining != 0){
//       // var newValue = await apiBLMHomeFeedTab(page);
//       var newValue = await apiBLMProfilePost(memorialId, page);
//       // itemRemaining = newValue.itemsRemaining;
//       feeds.add(Column(
//         children: [
//           MiscBLMPost(
//             userId: newValue.familyMemorialList[0].page.id,
//             postId: newValue.familyMemorialList[0].id,
//             memorialId: newValue.familyMemorialList[0].page.id,
//             memorialName: newValue.familyMemorialList[0].page.name,
//             profileImage: newValue.familyMemorialList[0].page.profileImage,
//             timeCreated: convertDate(newValue.familyMemorialList[0].createAt),
//             contents: [
//               Column(
//                 children: [
//                   Align(
//                     alignment: Alignment.topLeft,
//                     child: RichText(
//                       maxLines: 4,
//                       overflow: TextOverflow.clip,
//                       textAlign: TextAlign.left,
//                       text: TextSpan(
//                         text: newValue.familyMemorialList[0].body,
//                         style: TextStyle(
//                           fontWeight: FontWeight.w300,
//                           color: Color(0xff000000),
//                         ),
//                       ),
//                     ),
//                   ),

//                   SizedBox(height: SizeConfig.blockSizeVertical * 1,),
//                 ],
//               ),


//               newValue.familyMemorialList[0].imagesOrVideos != null
//               ? Container(
//                 height: SizeConfig.blockSizeHorizontal * 50,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.all(Radius.circular(5.0)),
//                   image: DecorationImage(
//                     fit: BoxFit.cover,
//                     image: NetworkImage(newValue.familyMemorialList[0].imagesOrVideos[0]),
//                   ),
//                 ),
//               )
//               : Container(height: 0,),
//             ],
//           ),

//           SizedBox(height: SizeConfig.blockSizeVertical * 1,),
//         ],
//       ));

//       setState(() {});
//       refreshController.loadComplete();
//     }else{
//       refreshController.loadNoData();
//     }
//   }

//   final List<String> images = ['assets/icons/profile_post1.png', 'assets/icons/profile_post2.png', 'assets/icons/profile_post3.png', 'assets/icons/profile_post4.png'];
//   final dataKey = new GlobalKey();

//   @override
//   Widget build(BuildContext context) {
//     SizeConfig.init(context);
//     memorialId = ModalRoute.of(context).settings.arguments;
//     return Scaffold(
//       body: SmartRefresher(
//         enablePullDown: false,
//         enablePullUp: true,
//         header: MaterialClassicHeader(),
//         footer: CustomFooter(
//           loadStyle: LoadStyle.ShowWhenLoading,
//           builder: (BuildContext context, LoadStatus mode){
//             Widget body ;
//             if(mode == LoadStatus.idle){
//               body =  Text('Pull up load', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
//             }
//             else if(mode == LoadStatus.loading){
//               body =  CircularProgressIndicator();
//             }
//             else if(mode == LoadStatus.failed){
//               body = Text('Load Failed! Click retry!', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
//             }
//             else if(mode == LoadStatus.canLoading){
//               body = Text('Release to load more', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
//               page++;
//             }
//             else{
//               body = Text('No more feed.', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
//             }
//             return Container(
//               height: 55.0,
//               child: Center(child:body),
//             );
//           },
//         ),
//         controller: refreshController,
//         onRefresh: onRefresh,
//         onLoading: onLoading,
//         child: SingleChildScrollView(
//         // physics: ClampingScrollPhysics(),
//         physics: NeverScrollableScrollPhysics(),
//         child: FutureBuilder<APIBLMShowMemorialMain>(
//           future: apiBLMShowMemorial(memorialId),
//           builder: (context, profile){
//             if(profile.hasData){
//               return Stack(
//                 children: [

//                   // Container(height: SizeConfig.screenHeight / 3, decoration: BoxDecoration(image: DecorationImage(fit: BoxFit.cover, image: AssetImage('assets/icons/background4.png'),),),),
//                   Container(
//                     height: SizeConfig.screenHeight / 3, 
//                     decoration: BoxDecoration(
//                       image: DecorationImage(
//                         fit: BoxFit.cover, 
//                         image: profile.data.memorial.backgroundImage != null
//                         ? NetworkImage(profile.data.memorial.backgroundImage)
//                         : AssetImage('assets/icons/background3.png'),
//                       ),
//                     ),
//                   ),

//                   Column(
//                     children: [

//                       Container(height: SizeConfig.screenHeight / 3.5, color: Colors.transparent,),

//                       Container(
//                         width: SizeConfig.screenWidth,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
//                           color: Color(0xffffffff),
//                         ),
//                         child: Column(
//                           children: [

//                             SizedBox(height: SizeConfig.blockSizeVertical * 12,),

//                             Center(child: Text(profile.data.memorial.name, style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 5, fontWeight: FontWeight.bold, color: Color(0xff000000),),),),

//                             SizedBox(height: SizeConfig.blockSizeVertical * 2,),

//                             Container(
//                               width: SizeConfig.safeBlockHorizontal * 15,
//                               height: SizeConfig.blockSizeVertical * 5,
//                               child: Row(
//                                 children: [
//                                   Expanded(
//                                     child: CircleAvatar(
//                                       radius: SizeConfig.blockSizeVertical * 2,
//                                       backgroundColor: Color(0xff000000),
//                                       child: CircleAvatar(
//                                         radius: SizeConfig.blockSizeVertical * 1,
//                                         backgroundColor: Colors.transparent,
//                                         backgroundImage: AssetImage('assets/icons/fist.png'),
//                                       ),
//                                     ),
//                                   ),

//                                   SizedBox(width: SizeConfig.blockSizeHorizontal * 2,),

//                                   Expanded(
//                                     child: Text('45',
//                                       style: TextStyle(
//                                         fontSize: SizeConfig.safeBlockHorizontal * 4,
//                                         fontWeight: FontWeight.w500,
//                                         color: Color(0xff000000),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),

//                             SizedBox(height: SizeConfig.blockSizeVertical * 2,),

//                             // Container(
//                             //   padding: EdgeInsets.only(left: 20.0, right: 20.0),
//                             //   child: Stack(
//                             //     children: [
//                             //       Image.asset('assets/icons/upload_background.png'),

//                             //       Positioned(
//                             //         top: SizeConfig.blockSizeVertical * 7,
//                             //         left: SizeConfig.screenWidth / 2.8,
//                             //         child: Icon(Icons.play_arrow_rounded, color: Color(0xffffffff), size: SizeConfig.blockSizeVertical * 10,),
//                             //       ),
//                             //     ],
//                             //   ),
//                             // ),

//                             ((){
//                               if(profile.data.memorial.details.description != ''){
//                                 return Container(
//                                   padding: EdgeInsets.only(left: 20.0, right: 20.0),
//                                   child: Text(profile.data.memorial.details.description,
//                                     style: TextStyle(
//                                       fontSize: SizeConfig.safeBlockHorizontal * 4,
//                                       fontWeight: FontWeight.w300,
//                                       color: Color(0xff000000),
//                                     ),
//                                   ),
//                                 );
//                               }else if(profile.data.memorial.imagesOrVideos != null){
//                                 return Container(
//                                   padding: EdgeInsets.only(left: 20.0, right: 20.0),
//                                   child: Stack(
//                                     children: [
//                                       Container(
//                                         height: SizeConfig.blockSizeHorizontal * 40,
//                                         decoration: BoxDecoration(
//                                           borderRadius: BorderRadius.all(Radius.circular(5.0)),
//                                           image: DecorationImage(
//                                             fit: BoxFit.cover,
//                                             image: AssetImage('assets/icons/regular-image4.png'),
//                                           ),
//                                         ),
//                                       ),

//                                       Positioned(
//                                         top: SizeConfig.blockSizeVertical * 7,
//                                         left: SizeConfig.screenWidth / 2.8,
//                                         child: Icon(Icons.play_arrow_rounded, color: Color(0xffffffff), size: SizeConfig.blockSizeVertical * 10,),
//                                       ),
//                                     ],
//                                   ),
//                                 );
//                               }else{
//                                 return Container(height: 0,);
//                               }
//                             }()),

//                             SizedBox(height: SizeConfig.blockSizeVertical * 2,),

//                             Container(
//                               child: Row(
//                                 children: [
//                                   Expanded(
//                                     child: Container(),
//                                   ),
//                                   Expanded(
//                                     flex: 2,
//                                     child: Padding(
//                                       padding: EdgeInsets.only(left: 10.0, right: 10.0),
//                                       child: MaterialButton(
//                                         padding: EdgeInsets.zero,
//                                         onPressed: (){
//                                           Navigator.pushNamed(context, '/home/blm/home-09-blm-memorial-settings');
//                                         },
//                                         child: Text('Manage',
//                                           style: TextStyle(
//                                             fontSize: SizeConfig.safeBlockHorizontal * 5,
//                                             fontWeight: FontWeight.bold,
//                                             color: Color(0xffffffff),
//                                           ),
//                                         ),
//                                         minWidth: SizeConfig.screenWidth / 2,
//                                         height: SizeConfig.blockSizeVertical * 7,
//                                         shape: StadiumBorder(),
//                                         color: Color(0xff2F353D),
//                                       ),
//                                     ),
//                                   ),
//                                   Expanded(
//                                     child: GestureDetector(
//                                       onTap: () async{
//                                         await FlutterShare.share(
//                                           title: 'Share',
//                                           text: 'Share the link',
//                                           linkUrl: 'https://flutter.dev/',
//                                           chooserTitle: 'Share link'
//                                         );
//                                       },
//                                       child: CircleAvatar(
//                                         radius: SizeConfig.blockSizeVertical * 3,
//                                         backgroundColor: Color(0xff3498DB),
//                                         child: Icon(Icons.share, color: Color(0xffffffff), size: SizeConfig.blockSizeVertical * 3,),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),

//                             SizedBox(height: SizeConfig.blockSizeVertical * 2,),

//                             Padding(
//                               padding: EdgeInsets.only(left: 20),
//                               child: Column(
//                                 children: [

//                                   Row(
//                                     children: [
//                                       Icon(Icons.place, color: Color(0xff000000), size: SizeConfig.blockSizeVertical * 3,),
//                                       SizedBox(width: SizeConfig.blockSizeHorizontal * 2,),
//                                       Text(profile.data.memorial.details.country,
//                                         style: TextStyle(
//                                           fontSize: SizeConfig.safeBlockHorizontal * 3.5,
//                                           color: Color(0xff000000),
//                                         ),
//                                       ),
//                                     ],
//                                   ),

//                                   SizedBox(height: SizeConfig.blockSizeVertical * 2,),

//                                   Row(
//                                     children: [
//                                       Icon(Icons.star, color: Color(0xff000000), size: SizeConfig.blockSizeVertical * 3,),
//                                       SizedBox(width: SizeConfig.blockSizeHorizontal * 2,),
//                                       Text(convertDate(profile.data.memorial.details.dob),
//                                         style: TextStyle(
//                                           fontSize: SizeConfig.safeBlockHorizontal * 3.5,
//                                           color: Color(0xff000000),
//                                         ),
//                                       ),
//                                     ],
//                                   ),

//                                   SizedBox(height: SizeConfig.blockSizeVertical * 2,),

//                                   Row(
//                                     children: [
//                                       Image.asset('assets/icons/grave_logo.png', height: SizeConfig.blockSizeVertical * 3,),
//                                       SizedBox(width: SizeConfig.blockSizeHorizontal * 2,),
//                                       Text(convertDate(profile.data.memorial.details.rip),
//                                         style: TextStyle(
//                                           fontSize: SizeConfig.safeBlockHorizontal * 3.5,
//                                           color: Color(0xff000000),
//                                         ),
//                                       ),
//                                     ],
//                                   ),

//                                 ],
//                               ),
//                             ),

//                             SizedBox(height: SizeConfig.blockSizeVertical * 2,),

//                             Container(
//                               height: 50.0,
//                               child: Row(
//                                 children: [
//                                   Expanded(
//                                     child: GestureDetector(
//                                       onTap: (){
//                                         Scrollable.ensureVisible(dataKey.currentContext);
//                                       },
//                                       child: Column(
//                                         children: [
//                                           SizedBox(height: SizeConfig.blockSizeVertical * 1,),

//                                           Text(profile.data.memorial.postsCount.toString(),
//                                             style: TextStyle(
//                                               fontSize: SizeConfig.safeBlockHorizontal * 5,
//                                               fontWeight: FontWeight.bold,
//                                               color: Color(0xff000000),
//                                             ),
//                                           ),

//                                           Text('Post',
//                                             style: TextStyle(
//                                               fontSize: SizeConfig.safeBlockHorizontal * 3,
//                                               fontWeight: FontWeight.w300,
//                                               color: Color(0xffaaaaaa),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
                                  
//                                   Container(width: SizeConfig.blockSizeHorizontal * .5, color: Color(0xffeeeeee),),

//                                   Expanded(
//                                     child: GestureDetector(
//                                       onTap: (){
//                                         Navigator.pushNamed(context, '/home/blm/home-22-blm-connection-list');
//                                       },
//                                       child: Column(
//                                         children: [
//                                           SizedBox(height: SizeConfig.blockSizeVertical * 1,),

//                                           Text(profile.data.memorial.familyCount.toString(),
//                                             style: TextStyle(
//                                               fontSize: SizeConfig.safeBlockHorizontal * 5,
//                                               fontWeight: FontWeight.bold,
//                                               color: Color(0xff000000),
//                                             ),
//                                           ),

//                                           Text('Family',
//                                             style: TextStyle(
//                                               fontSize: SizeConfig.safeBlockHorizontal * 3,
//                                               fontWeight: FontWeight.w300,
//                                               color: Color(0xffaaaaaa),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),

//                                   Container(width: SizeConfig.blockSizeHorizontal * .5, color: Color(0xffeeeeee),),

//                                   Expanded(
//                                     child: GestureDetector(
//                                       onTap: (){
//                                         Navigator.pushNamed(context, '/home/blm/home-22-blm-connection-list');
//                                       },
//                                       child: Column(
//                                         children: [
//                                           SizedBox(height: SizeConfig.blockSizeVertical * 1,),

//                                           Text(profile.data.memorial.friendsCount.toString(),
//                                             style: TextStyle(
//                                               fontSize: SizeConfig.safeBlockHorizontal * 5,
//                                               fontWeight: FontWeight.bold,
//                                               color: Color(0xff000000),
//                                             ),
//                                           ),

//                                           Text('Friends',
//                                             style: TextStyle(
//                                               fontSize: SizeConfig.safeBlockHorizontal * 3,
//                                               fontWeight: FontWeight.w300,
//                                               color: Color(0xffaaaaaa),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),

//                                   Container(width: SizeConfig.blockSizeHorizontal * .5, color: Color(0xffeeeeee),),

//                                   Expanded(
//                                     child: GestureDetector(
//                                       onTap: (){
//                                         Navigator.pushNamed(context, '/home/blm/home-22-blm-connection-list');
//                                       },
//                                       child: Column(
//                                         children: [
//                                           SizedBox(height: SizeConfig.blockSizeVertical * 1,),

//                                           Text(profile.data.memorial.followersCount.toString(),
//                                             style: TextStyle(
//                                               fontSize: SizeConfig.safeBlockHorizontal * 5,
//                                               fontWeight: FontWeight.bold,
//                                               color: Color(0xff000000),
//                                             ),
//                                           ),

//                                           Text('Joined',
//                                             style: TextStyle(
//                                               fontSize: SizeConfig.safeBlockHorizontal * 3,
//                                               fontWeight: FontWeight.w300,
//                                               color: Color(0xffaaaaaa),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),

//                             Container(height: SizeConfig.blockSizeVertical * .5, color: Color(0xffffffff),),

//                             Container(height: SizeConfig.blockSizeVertical * .5, color: Color(0xffeeeeee),),

//                             Column(
//                               children: [
//                                 SizedBox(height: SizeConfig.blockSizeVertical * 2,),

//                                 Container(
//                                   key: dataKey,
//                                   padding: EdgeInsets.only(left: 20.0),
//                                   alignment: Alignment.centerLeft,
//                                   child: Text('Post',
//                                     style: TextStyle(
//                                       fontSize: SizeConfig.safeBlockHorizontal * 5,
//                                       fontWeight: FontWeight.bold,
//                                       color: Color(0xff000000),
//                                     ),
//                                   ),
//                                 ),

//                                 SizedBox(height: SizeConfig.blockSizeVertical * 2,),

//                                 Container(
//                                   width: SizeConfig.screenWidth,
//                                   height: SizeConfig.blockSizeVertical * 12,
//                                   padding: EdgeInsets.only(left: 20.0, right: 20.0),
//                                   child: ListView.separated(
//                                     physics: ClampingScrollPhysics(),
//                                     scrollDirection: Axis.horizontal,
//                                     itemBuilder: (context, index){
//                                       return Container(
//                                         width: SizeConfig.blockSizeVertical * 12,
//                                         decoration: BoxDecoration(
//                                           borderRadius: BorderRadius.circular(10),
//                                           image: DecorationImage(
//                                             fit: BoxFit.cover,
//                                             image: AssetImage(images[index]),
//                                           ),
//                                         ),
//                                       );
//                                     }, 
//                                     separatorBuilder: (context, index){
//                                       return SizedBox(width: SizeConfig.blockSizeHorizontal * 2,);
//                                     },
//                                     itemCount: 4,
//                                   ),
//                                 ),
//                                 SizedBox(height: SizeConfig.blockSizeVertical * 2,),
//                               ],
//                             ),

//                             Container(height: SizeConfig.blockSizeVertical * .5, color: Color(0xffeeeeee),),

//                             // Container(
//                             //   padding: EdgeInsets.all(10.0),
//                             //   color: Color(0xffffffff),
//                             //   child: Column(
//                             //     children: [
//                             //       MiscBLMPostDisplayTemplate(),
//                             //     ],
//                             //   ),
//                             // ),

//                             ListView.separated(
//                               padding: EdgeInsets.all(10.0),
//                               shrinkWrap: true,
//                               itemBuilder: (c, i) => feeds[i],
//                               separatorBuilder: (c, i) => Divider(height: SizeConfig.blockSizeVertical * 2, color: Colors.transparent),
//                               itemCount: feeds.length,
//                             ),

//                             Container(
//                               height: SizeConfig.screenHeight,
//                               child: SmartRefresher(
//                                 enablePullDown: false,
//                                 enablePullUp: true,
//                                 header: MaterialClassicHeader(),
//                                 footer: CustomFooter(
//                                   loadStyle: LoadStyle.ShowWhenLoading,
//                                   builder: (BuildContext context, LoadStatus mode){
//                                     Widget body ;
//                                     if(mode == LoadStatus.idle){
//                                       body =  Text('Pull up load', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
//                                     }
//                                     else if(mode == LoadStatus.loading){
//                                       body =  CircularProgressIndicator();
//                                     }
//                                     else if(mode == LoadStatus.failed){
//                                       body = Text('Load Failed! Click retry!', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
//                                     }
//                                     else if(mode == LoadStatus.canLoading){
//                                       body = Text('Release to load more', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
//                                       page++;
//                                     }
//                                     else{
//                                       body = Text('No more feed.', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
//                                     }
//                                     return Container(
//                                       height: 55.0,
//                                       child: Center(child:body),
//                                     );
//                                   },
//                                 ),
//                                 controller: refreshController,
//                                 onRefresh: onRefresh,
//                                 onLoading: onLoading,
//                                 child: ListView.separated(
//                                   padding: EdgeInsets.all(10.0),
//                                   shrinkWrap: true,
//                                   itemBuilder: (c, i) => feeds[i],
//                                   separatorBuilder: (c, i) => Divider(height: SizeConfig.blockSizeVertical * 2, color: Colors.transparent),
//                                   itemCount: feeds.length,
//                                 ),
//                               )
//                             ),

//                             // Padding(
//                             //   padding: EdgeInsets.all(20.0),
//                             //   child: FutureBuilder<APIBLMHomeProfilePostMain>(
//                             //     future: apiBLMProfilePost(memorialId),
//                             //     builder: (context, profilePost){
//                             //       if(profilePost.hasData){
//                             //         return Column(
//                             //           children: List.generate(profilePost.data.familyMemorialList.length, (index) => 
//                             //             Column(
//                             //               children: [
//                             //                 MiscBLMPost(
//                             //                   userId: profilePost.data.familyMemorialList[index].page.id,
//                             //                   postId: profilePost.data.familyMemorialList[index].id,
//                             //                   memorialId: profilePost.data.familyMemorialList[index].page.id,
//                             //                   memorialName: profilePost.data.familyMemorialList[index].page.name,
//                             //                   timeCreated: convertDate(profilePost.data.familyMemorialList[index].createAt),
//                             //                   contents: [
//                             //                     Column(
//                             //                       children: [
//                             //                         Align(
//                             //                           alignment: Alignment.topLeft,
//                             //                           child: RichText(
//                             //                             maxLines: 4,
//                             //                             overflow: TextOverflow.clip,
//                             //                             textAlign: TextAlign.left,
//                             //                             text: TextSpan(
//                             //                               text: profilePost.data.familyMemorialList[index].body,
//                             //                               style: TextStyle(
//                             //                                 fontWeight: FontWeight.w300,
//                             //                                 color: Color(0xff000000),
//                             //                               ),
//                             //                             ),
//                             //                           ),
//                             //                         ),

//                             //                         SizedBox(height: SizeConfig.blockSizeVertical * 1,),
//                             //                       ],
//                             //                     ),

//                             //                     profilePost.data.familyMemorialList[index].imagesOrVideos != null
//                             //                     ? Container(
//                             //                       height: SizeConfig.blockSizeHorizontal * 50,
//                             //                       decoration: BoxDecoration(
//                             //                         borderRadius: BorderRadius.all(Radius.circular(5.0)),
//                             //                       ),
//                             //                       child: CachedNetworkImage(
//                             //                         imageUrl: profilePost.data.familyMemorialList[index].imagesOrVideos[0],
//                             //                         placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
//                             //                         errorWidget: (context, url, error) => Icon(Icons.error),
//                             //                       ),
//                             //                     )
//                             //                     : Container(height: 0,),
//                             //                   ],
//                             //                 ),

//                             //                 SizedBox(height: SizeConfig.blockSizeVertical * 1,),

//                             //               ],
//                             //             ),                                      
//                             //           ),
//                             //         );
//                             //       }else if(profilePost.hasError){
//                             //         return Center(child: Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),),);
//                             //       }else{
//                             //         return Container(child: Center(child: Container(child: SpinKitThreeBounce(color: Color(0xff000000), size: 50.0,), color: Color(0xffffffff),),),);
//                             //       }
//                             //     },
//                             //   ),
//                             // ),
                            
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),

//                   Container(
//                     height: Size.fromHeight(AppBar().preferredSize.height).height + (Size.fromHeight(AppBar().preferredSize.height).height / 2),
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: Padding(
//                             padding: EdgeInsets.only(left: 20.0),
//                             child: GestureDetector(
//                               onTap: (){
//                                 Navigator.popAndPushNamed(context, '/home/blm');
//                               },
//                               child: Row(
//                                 children: [
//                                   Icon(Icons.arrow_back, color: Color(0xffffffff),), 
//                                   Text('Back',
//                                     style: TextStyle(
//                                       fontSize: SizeConfig.safeBlockHorizontal * 5,
//                                       fontWeight: FontWeight.w500,
//                                       color: Color(0xffffffff),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                         Expanded(
//                           child: Container(
//                             padding: EdgeInsets.only(right: 20.0),
//                             alignment: Alignment.centerRight,
//                             child: GestureDetector(
//                               onTap: (){
//                                 Navigator.pushNamed(context, '/home/blm/home-19-blm-create-post');
//                               },
//                               child: Text('Create Post',
//                                 style: TextStyle(
//                                   fontSize: SizeConfig.safeBlockHorizontal * 5,
//                                   fontWeight: FontWeight.w500,
//                                   color: Color(0xffffffff),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),

//                   Positioned(
//                     top: SizeConfig.screenHeight / 5,
//                     child: Container(
//                       height: SizeConfig.blockSizeVertical * 18,
//                       width: SizeConfig.screenWidth,
//                       child: Row(
//                         children: [
//                           Expanded(
//                             child: Container(),
//                           ),
//                           Expanded(
//                             child: CircleAvatar(
//                               radius: SizeConfig.blockSizeVertical * 12,
//                               backgroundColor: Color(0xff000000),
//                               child: Padding(
//                                 padding: EdgeInsets.all(5),
//                                   child: CircleAvatar(
//                                   radius: SizeConfig.blockSizeVertical * 12,
//                                   backgroundImage: AssetImage('assets/icons/profile1.png'),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Expanded(
//                             child: Container(),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               );
//             }else if(profile.hasError){
//               return MiscBLMErrorMessageTemplate();
//             }else{
//               return Container(height: SizeConfig.screenHeight, child: Center(child: Container(child: SpinKitThreeBounce(color: Color(0xff000000), size: 50.0,), color: Color(0xffffffff),),),);
//             }
//           },
//         ),
//       ),
//       ),
//     );
//   }

// }