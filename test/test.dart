// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:facesbyplaces/API/Regular/api-10-regular-show-memorial.dart';
// import 'package:facesbyplaces/API/Regular/api-12-regular-show-profile-post.dart';
// import 'package:facesbyplaces/Configurations/date-conversion.dart';
// import 'package:facesbyplaces/Configurations/size_configuration.dart';
// import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-13-regular-post.dart';
// import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-14-regular-message.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_share/flutter_share.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';

// class HomeRegularProfile extends StatefulWidget{

//   @override
//   HomeRegularProfileState createState() => HomeRegularProfileState();
// }

// class HomeRegularProfileState extends State<HomeRegularProfile>{

//   final List<String> images = ['assets/icons/regular-image1.png', 'assets/icons/regular-image2.png', 'assets/icons/regular-image3.png', 'assets/icons/regular-image4.png'];
//   final dataKey = new GlobalKey();

//   // void initState(){
//   //   super.initState();
//   //   apiRegularShowMemorial(0);
//   //   apiRegularProfilePost(0);
//   // }

//   @override
//   Widget build(BuildContext context) {
//     SizeConfig.init(context);
//     int memorialId = ModalRoute.of(context).settings.arguments;
//     return Scaffold(
//       backgroundColor: Color(0xffeeeeee),
//       body: SingleChildScrollView(
//         physics: ClampingScrollPhysics(),
//         child: FutureBuilder<APIRegularShowMemorialMain>(
//           future: apiRegularShowMemorial(memorialId),
//           builder: (context, showProfile){
//             if(showProfile.hasData){
//               return Stack(
//                 children: [

//                   Container(
//                     height: SizeConfig.screenHeight / 3, 
//                     decoration: BoxDecoration(
//                       image: DecorationImage(
//                         fit: BoxFit.cover, 
//                         image: showProfile.data.memorial.backgroundImage != null
//                         ? NetworkImage(showProfile.data.memorial.backgroundImage)
//                         : AssetImage('assets/icons/regular-image1.png'),
//                       ),
//                     ),
//                   ),

//                   Column(
//                     children: [
//                       Container(
//                         height: SizeConfig.screenHeight / 3.5,
//                         padding: EdgeInsets.all(20.0),
//                         child: Row(
//                           children: [
//                             Expanded(
//                               child: Align(
//                                 alignment: Alignment.topCenter,
//                                 child: GestureDetector(
//                                   onTap: (){
//                                     Navigator.pop(context);
//                                   },
//                                   child: Row(
//                                     children: [
//                                       Icon(Icons.arrow_back, color: Color(0xffffffff),), 
//                                       Text('Back',
//                                         style: TextStyle(
//                                           fontSize: SizeConfig.safeBlockHorizontal * 5,
//                                           fontWeight: FontWeight.w500,
//                                           color: Color(0xffffffff),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             Expanded(
//                               child: Align(
//                                 alignment: Alignment.topRight,
//                                 child: GestureDetector(
//                                   onTap: (){
//                                     Navigator.pushNamed(context, 'home/regular/home-09-regular-create-post', arguments: memorialId);
//                                   },
//                                   child: Text('Create Post',
//                                     style: TextStyle(
//                                       fontSize: SizeConfig.safeBlockHorizontal * 5,
//                                       fontWeight: FontWeight.w500,
//                                       color: Color(0xffffffff),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ), // INVISIBLE SPACE ABOVE THE BACKGROUND

//                       Container(
//                         width: SizeConfig.screenWidth,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
//                           color: Color(0xffffffff),
//                         ),
//                         child: Column(
//                           children: [
//                             SizedBox(height: SizeConfig.blockSizeVertical * 12,),

//                             Center(child: Text(showProfile.data.memorial.name, style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 5, fontWeight: FontWeight.bold, color: Color(0xff000000),),),),

//                             SizedBox(height: SizeConfig.blockSizeVertical * 2,),

//                             Container(
//                               width: SizeConfig.safeBlockHorizontal * 15,
//                               height: SizeConfig.blockSizeVertical * 5,
//                               child: Row(
//                                 children: [
//                                   Expanded(
//                                     child: CircleAvatar(
//                                       radius: SizeConfig.blockSizeVertical * 2,
//                                       backgroundColor: Color(0xffE67E22),
//                                       child: Icon(Icons.card_giftcard, color: Color(0xffffffff), size: SizeConfig.blockSizeVertical * 2,),
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

//                             ((){
//                               if(showProfile.data.memorial.details.description != ''){
//                                 return Container(
//                                   padding: EdgeInsets.only(left: 20.0, right: 20.0),
//                                   child: Text(showProfile.data.memorial.details.description,
//                                     style: TextStyle(
//                                       fontSize: SizeConfig.safeBlockHorizontal * 4,
//                                       fontWeight: FontWeight.w300,
//                                       color: Color(0xff000000),
//                                     ),
//                                   ),
//                                 );
//                               }else if(showProfile.data.memorial.imagesOrVideos != null){
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
//                                   Expanded(child: Container(),),
//                                   Expanded(
//                                     flex: 2,
//                                     child: Padding(
//                                       padding: EdgeInsets.only(left: 10.0, right: 10.0),
//                                       child: MaterialButton(
//                                         padding: EdgeInsets.zero,
//                                         onPressed: (){
//                                           // Navigator.pushNamed(context, 'home/regular/home-19-regular-connection-list');
//                                           Navigator.pushNamed(context, 'home/regular/home-10-regular-memorial-settings');
//                                         },
//                                         child: Text(
//                                           showProfile.data.memorial.manage
//                                           ? 'Manage'
//                                           : 'Settings',
//                                           style: TextStyle(
//                                             fontSize: SizeConfig.safeBlockHorizontal * 5,
//                                             fontWeight: FontWeight.bold,
//                                             color: Color(0xffffffff),
//                                           ),
//                                         ),
//                                         minWidth: SizeConfig.screenWidth / 2,
//                                         height: SizeConfig.blockSizeVertical * 7,
//                                         shape: StadiumBorder(),
//                                         // color: Color(0xff04ECFF),
//                                         color: showProfile.data.memorial.manage
//                                         ? Color(0xff04ECFF)
//                                         : Color(0xff888888),
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
//                                       Image.asset('assets/icons/prayer_logo.png', height: SizeConfig.blockSizeVertical * 3,),
//                                       SizedBox(width: SizeConfig.blockSizeHorizontal * 2,),
//                                       Text('Roman Catholic',
//                                         style: TextStyle(
//                                           fontSize: SizeConfig.safeBlockHorizontal * 3.5,
//                                           color: Color(0xff000000),
//                                         ),
//                                       ),
//                                     ],
//                                   ),

//                                   SizedBox(height: SizeConfig.blockSizeVertical * 1,),

//                                   Row(
//                                     children: [
//                                       Icon(Icons.place, color: Color(0xff000000), size: SizeConfig.blockSizeVertical * 3,),
//                                       SizedBox(width: SizeConfig.blockSizeHorizontal * 2,),
//                                       Text(showProfile.data.memorial.details.birthPlace,
//                                         style: TextStyle(
//                                           fontSize: SizeConfig.safeBlockHorizontal * 3.5,
//                                           color: Color(0xff000000),
//                                         ),
//                                       ),
//                                     ],
//                                   ),

//                                   SizedBox(height: SizeConfig.blockSizeVertical * 1,),

//                                   Row(
//                                     children: [
//                                       Icon(Icons.star, color: Color(0xff000000), size: SizeConfig.blockSizeVertical * 3,),
//                                       SizedBox(width: SizeConfig.blockSizeHorizontal * 2,),
//                                       Text(convertDate(showProfile.data.memorial.details.dob),
//                                         style: TextStyle(
//                                           fontSize: SizeConfig.safeBlockHorizontal * 3.5,
//                                           color: Color(0xff000000),
//                                         ),
//                                       ),
//                                     ],
//                                   ),

//                                   SizedBox(height: SizeConfig.blockSizeVertical * 1,),

//                                   Row(
//                                     children: [
//                                       Image.asset('assets/icons/grave_logo.png', height: SizeConfig.blockSizeVertical * 3,),
//                                       SizedBox(width: SizeConfig.blockSizeHorizontal * 2,),
//                                       Text(convertDate(showProfile.data.memorial.details.rip),
//                                         style: TextStyle(
//                                           fontSize: SizeConfig.safeBlockHorizontal * 3.5,
//                                           color: Color(0xff000000),
//                                         ),
//                                       ),
//                                     ],
//                                   ),

//                                   SizedBox(height: SizeConfig.blockSizeVertical * 1,),

//                                   Row(
//                                     children: [
//                                       Image.asset('assets/icons/grave_logo.png', height: SizeConfig.blockSizeVertical * 3,),
//                                       SizedBox(width: SizeConfig.blockSizeHorizontal * 2,),
//                                       GestureDetector(
//                                         onTap: (){},
//                                         child: Text(showProfile.data.memorial.details.cemetery,
//                                           style: TextStyle(
//                                             fontSize: SizeConfig.safeBlockHorizontal * 3.5,
//                                             color: Color(0xff3498DB),
//                                           ),
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

//                                           Text(showProfile.data.memorial.postsCount.toString(),
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
//                                   Expanded(
//                                     child: GestureDetector(
//                                       onTap: (){
//                                         Navigator.pushNamed(context, 'home/regular/home-19-regular-connection-list');
//                                       },
//                                       child: Column(
//                                         children: [
//                                           SizedBox(height: SizeConfig.blockSizeVertical * 1,),

//                                           Text(showProfile.data.memorial.familyCount.toString(),
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
//                                   Expanded(
//                                     child: GestureDetector(
//                                       onTap: (){
//                                         Navigator.pushNamed(context, 'home/regular/home-19-regular-connection-list');
//                                       },
//                                       child: Column(
//                                         children: [
//                                           SizedBox(height: SizeConfig.blockSizeVertical * 1,),

//                                           Text(showProfile.data.memorial.friendsCount.toString(),
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
//                                   Expanded(
//                                     child: GestureDetector(
//                                       onTap: (){
//                                         Navigator.pushNamed(context, 'home/regular/home-19-regular-connection-list');
//                                       },
//                                       child: Column(
//                                         children: [
//                                           SizedBox(height: SizeConfig.blockSizeVertical * 1,),

//                                           Text(showProfile.data.memorial.followersCount.toString(),
//                                             style: TextStyle(
//                                               fontSize: SizeConfig.safeBlockHorizontal * 5,
//                                               fontWeight: FontWeight.bold,
//                                               color: Color(0xff000000),
//                                             ),
//                                           ),

//                                           Text('Followers',
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

//                             Container(height: SizeConfig.blockSizeVertical * 1, color: Color(0xffeeeeee),),

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

//                             Container(height: SizeConfig.blockSizeVertical * 1, color: Color(0xffeeeeee),),

//                             Padding(
//                               padding: EdgeInsets.all(20.0),
//                               child: FutureBuilder<APIRegularHomeProfilePostMain>(
//                                 future: apiRegularProfilePost(memorialId),
//                                 builder: (context, profilePost){
//                                   if(profilePost.hasData){
//                                     return Column(
//                                       children: List.generate(profilePost.data.familyMemorialList.length, (index) => 
//                                         Column(
//                                           children: [
//                                             MiscRegularPost(
//                                               userId: profilePost.data.familyMemorialList[index].page.id,
//                                               postId: profilePost.data.familyMemorialList[index].id,
//                                               memorialId: profilePost.data.familyMemorialList[index].page.id,
//                                               memorialName: profilePost.data.familyMemorialList[index].page.name,
//                                               profileImage: profilePost.data.familyMemorialList[index].page.profileImage,
//                                               contents: [
//                                                 Column(
//                                                   children: [
//                                                     Align(
//                                                       alignment: Alignment.topLeft,
//                                                       child: RichText(
//                                                         maxLines: 4,
//                                                         overflow: TextOverflow.clip,
//                                                         textAlign: TextAlign.left,
//                                                         text: TextSpan(
//                                                           text: profilePost.data.familyMemorialList[index].body,
//                                                           style: TextStyle(
//                                                             fontWeight: FontWeight.w300,
//                                                             color: Color(0xff000000),
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ),

//                                                     SizedBox(height: SizeConfig.blockSizeVertical * 1,),
//                                                   ],
//                                                 ),

//                                                 profilePost.data.familyMemorialList[index].imagesOrVideos != null
//                                                 ? Container(
//                                                   height: SizeConfig.blockSizeHorizontal * 50,
//                                                   decoration: BoxDecoration(
//                                                     borderRadius: BorderRadius.all(Radius.circular(5.0)),
//                                                   ),
//                                                   child: CachedNetworkImage(
//                                                     imageUrl: profilePost.data.familyMemorialList[index].imagesOrVideos[0],
//                                                     placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
//                                                     errorWidget: (context, url, error) => Icon(Icons.error),
//                                                   ),
//                                                 )
//                                                 : Container(height: 0,),
//                                               ],
//                                             ),

//                                             SizedBox(height: SizeConfig.blockSizeVertical * 1,),

//                                           ],
//                                         ),
//                                       ),
//                                     );
//                                   }else if(profilePost.hasError){
//                                     return Center(child: Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),),);
//                                   }else{
//                                     return Container(child: Center(child: Container(child: SpinKitThreeBounce(color: Color(0xff000000), size: 50.0,), color: Color(0xffffffff),),),);
//                                   }
//                                 },
//                               ),
//                             ),

//                           ],
//                         ),
//                       ),
//                     ],
//                   ),

//                   Positioned(
//                     top: SizeConfig.screenHeight / 5,
//                     child: Container(
//                       height: SizeConfig.blockSizeVertical * 18,
//                       width: SizeConfig.screenWidth,
//                       child: Row(
//                         children: [
//                           Expanded(child: Container(),),
//                           Expanded(
//                             child: CircleAvatar(
//                               radius: SizeConfig.blockSizeVertical * 12,
//                               backgroundColor: Color(0xff04ECFF),
//                               child: Padding(
//                                 padding: EdgeInsets.all(5),
//                                   child: CircleAvatar(
//                                   radius: SizeConfig.blockSizeVertical * 12,
//                                   backgroundColor: Color(0xff888888),
//                                   backgroundImage: showProfile.data.memorial.profileImage != null
//                                   ? NetworkImage(showProfile.data.memorial.profileImage)
//                                   : AssetImage('assets/icons/graveyard.png'),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Expanded(child: Container(),),
//                         ],
//                       ),
//                     ),
//                   ),

//                 ],
//               );
//             }else if(showProfile.hasError){
//               return MiscRegularErrorMessageTemplate();
//             }else{
//               return Container(height: SizeConfig.screenHeight, child: Center(child: Container(child: SpinKitThreeBounce(color: Color(0xff000000), size: 50.0,), color: Color(0xffffffff),),),);
//             }
//           },
//         ),
//       ),
//     );
//   }
// }



import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  BranchContentMetaData metadata;
  BranchUniversalObject buo;
  BranchLinkProperties lp;
  BranchEvent eventStandart;
  BranchEvent eventCustom;

  var scaffoldKey = new GlobalKey<ScaffoldState>();
  StreamSubscription<Map> streamSubscription;
  StreamController<String> controllerData = StreamController<String>();
  StreamController<String> controllerInitSession = StreamController<String>();
  StreamController<String> controllerUrl = StreamController<String>();

  @override
  void initState() {
    super.initState();

    FlutterBranchSdk.setIdentity('branch_user_test');
    //FlutterBranchSdk.setIOSSKAdNetworkMaxTime(72);

    listenDynamicLinks();

    initDeepLinkData();
  }

  void listenDynamicLinks() async {
    streamSubscription = FlutterBranchSdk.initSession().listen((data) {
      print('listenDynamicLinks - DeepLink Data: $data');
      controllerData.sink.add((data.toString()));
      if (data.containsKey('+clicked_branch_link') &&
          data['+clicked_branch_link'] == true) {
        print(
            '------------------------------------Link clicked----------------------------------------------');
        print('Custom string: ${data['custom_string']}');
        print('Custom number: ${data['custom_number']}');
        print('Custom bool: ${data['custom_bool']}');
        print('Custom list number: ${data['custom_list_number']}');
        print(
            '------------------------------------------------------------------------------------------------');
        showSnackBar(
            message: 'Link clicked: Custom string - ${data['custom_string']}',
            duration: 10);
      }
    }, onError: (error) {
      PlatformException platformException = error as PlatformException;
      print(
          'InitSession error: ${platformException.code} - ${platformException.message}');
      controllerInitSession.add(
          'InitSession error: ${platformException.code} - ${platformException.message}');
    });
  }

  void initDeepLinkData() {
    metadata = BranchContentMetaData()
        .addCustomMetadata('custom_string', 'abc')
        .addCustomMetadata('custom_number', 12345)
        .addCustomMetadata('custom_bool', true)
        .addCustomMetadata('custom_list_number', [
      1,
      2,
      3,
      4,
      5
    ]).addCustomMetadata('custom_list_string', ['a', 'b', 'c']);
    /* --optional Custom Metadata
    metadata.contentSchema = BranchContentSchema.COMMERCE_PRODUCT;
    metadata.price = 50.99;
    metadata.currencyType = BranchCurrencyType.BRL;
    metadata.quantity = 50;
    metadata.sku = 'sku';
    metadata.productName = 'productName';
    metadata.productBrand = 'productBrand';
    metadata.productCategory = BranchProductCategory.ELECTRONICS;
    metadata.productVariant = 'productVariant';
    metadata.condition = BranchCondition.NEW;
    metadata.rating = 100;
    metadata.ratingAverage = 50;
    metadata.ratingMax = 100;
    metadata.ratingCount = 2;
    metadata.setAddress(
        street: 'street',
        city: 'city',
        region: 'ES',
        country: 'Brazil',
        postalCode: '99999-987');
    metadata.setLocation(31.4521685, -114.7352207);
    */

    buo = BranchUniversalObject(
      canonicalIdentifier: 'flutter/branch',
      title: 'Flutter Branch Plugin',
      imageUrl:
          'https://flutter.dev/assets/flutter-lockup-4cb0ee072ab312e59784d9fbf4fb7ad42688a7fdaea1270ccf6bbf4f34b7e03f.svg',
      contentDescription: 'Flutter Branch Description',
      contentMetadata: BranchContentMetaData()
        ..addCustomMetadata('custom_string', 'abc')
        ..addCustomMetadata('custom_number', 12345)
        ..addCustomMetadata('custom_bool', true)
        ..addCustomMetadata('custom_list_number', [1, 2, 3, 4, 5])
        ..addCustomMetadata('custom_list_string', ['a', 'b', 'c']),
      keywords: ['Plugin', 'Branch', 'Flutter'],
      publiclyIndex: true,
      locallyIndex: true,
    );
    FlutterBranchSdk.registerView(buo: buo);

    lp = BranchLinkProperties(
        channel: 'facebook',
        feature: 'sharing',
        //alias: 'flutterplugin' //define link url,
        stage: 'new share',
        campaign: 'xxxxx',
        tags: ['one', 'two', 'three']);
    lp.addControlParam('\$uri_redirect_mode', '1');

    eventStandart = BranchEvent.standardEvent(BranchStandardEvent.ADD_TO_CART);
    /* --optional Event data
    eventStandart.transactionID = '12344555';
    eventStandart.currency = BranchCurrencyType.BRL;
    eventStandart.revenue = 1.5;
    eventStandart.shipping = 10.2;
    eventStandart.tax = 12.3;
    eventStandart.coupon = 'test_coupon';
    eventStandart.affiliation = 'test_affiliation';
    eventStandart.eventDescription = 'Event_description';
    eventStandart.searchQuery = 'item 123';
    eventStandart.adType = BranchEventAdType.BANNER;
    eventStandart.addCustomData(
        'Custom_Event_Property_Key1', 'Custom_Event_Property_val1');
    eventStandart.addCustomData(
        'Custom_Event_Property_Key2', 'Custom_Event_Property_val2');
  */
    eventCustom = BranchEvent.customEvent('Custom_event');
    eventCustom.addCustomData(
        'Custom_Event_Property_Key1', 'Custom_Event_Property_val1');
    eventCustom.addCustomData(
        'Custom_Event_Property_Key2', 'Custom_Event_Property_val2');
  }

  void showSnackBar({@required String message, int duration = 3}) {
    scaffoldKey.currentState.removeCurrentSnackBar();
    scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(message),
      duration: Duration(seconds: duration),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: const Text('Branch.io Plugin Example App'),
        ),
        body: ListView(
          //physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.all(10),
          children: <Widget>[
            StreamBuilder<String>(
              stream: controllerInitSession.stream,
              initialData: '',
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data.isNotEmpty) {
                  return Column(
                    children: <Widget>[
                      Center(
                          child: Text(
                        snapshot.data,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
                      ))
                    ],
                  );
                } else {
                  return Container();
                }
              },
            ),
            RaisedButton(
              child: Text('Validate SDK Integration'),
              onPressed: () {
                FlutterBranchSdk.validateSDKIntegration();
                if (Platform.isAndroid) {
                  showSnackBar(message: 'Check messages in run log or logcat');
                }
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  child: RaisedButton(
                    child: Text('Enable tracking'),
                    onPressed: () {
                      FlutterBranchSdk.disableTracking(false);
                    },
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: RaisedButton(
                    child: Text('Disable tracking'),
                    onPressed: () {
                      FlutterBranchSdk.disableTracking(true);
                    },
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  child: RaisedButton(
                    child: Text('Identify user'),
                    onPressed: () {
                      FlutterBranchSdk.setIdentity('branch_user_test');
                    },
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: RaisedButton(
                    child: Text('User logout'),
                    onPressed: () {
                      FlutterBranchSdk.logout();
                    },
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  child: RaisedButton(
                    child: Text('Register view'),
                    onPressed: () {
                      FlutterBranchSdk.registerView(buo: buo);
                    },
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: RaisedButton(
                    child: Text('Track content'),
                    onPressed: () {
                      FlutterBranchSdk.trackContent(
                          buo: buo, branchEvent: eventStandart);
                      FlutterBranchSdk.trackContent(
                          buo: buo, branchEvent: eventCustom);

                      FlutterBranchSdk.trackContentWithoutBuo(
                          branchEvent: eventStandart);
                      FlutterBranchSdk.trackContentWithoutBuo(
                          branchEvent: eventCustom);
                    },
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  child: RaisedButton(
                    child: Text('Get First Parameters'),
                    onPressed: () async {
                      Map<dynamic, dynamic> params =
                          await FlutterBranchSdk.getFirstReferringParams();
                      controllerData.sink.add(params.toString());
                    },
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: RaisedButton(
                    child: Text('Get Last Parameters'),
                    onPressed: () async {
                      Map<dynamic, dynamic> params =
                          await FlutterBranchSdk.getLatestReferringParams();
                      controllerData.sink.add(params.toString());
                    },
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  child: RaisedButton(
                    child: Text('List on Search'),
                    onPressed: () async {
                      bool success =
                          await FlutterBranchSdk.listOnSearch(buo: buo);
                      print(success);
                      success = await FlutterBranchSdk.listOnSearch(
                          buo: buo, linkProperties: lp);
                      print(success);
                    },
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: RaisedButton(
                    child: Text('Remove from Search'),
                    onPressed: () async {
                      bool success =
                          await FlutterBranchSdk.removeFromSearch(buo: buo);
                      print('Remove sucess: $success');
                      success = await FlutterBranchSdk.removeFromSearch(
                          buo: buo, linkProperties: lp);
                      print('Remove sucess: $success');
                    },
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  child: RaisedButton(
                    child: Text('Viewing Credits'),
                    onPressed: () async {
                      bool isUserIdentified =
                          await FlutterBranchSdk.isUserIdentified();

                      if (!isUserIdentified) {
                        showSnackBar(message: 'User not identified');
                        return;
                      }

                      int credits = 0;
                      BranchResponse response =
                          await FlutterBranchSdk.loadRewards();
                      if (response.success) {
                        credits = response.result;
                        print('Crédits');
                        showSnackBar(message: 'Credits: $credits');
                      } else {
                        showSnackBar(
                            message: 'Credits error: ${response.errorMessage}');
                      }
                    },
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: RaisedButton(
                    child: Text('Redeeming Credits'),
                    onPressed: () async {
                      bool isUserIdentified =
                          await FlutterBranchSdk.isUserIdentified();

                      print('isUserIdentified: $isUserIdentified');

                      if (!isUserIdentified) {
                        showSnackBar(message: 'User not identified');
                        return;
                      }
                      bool success = false;
                      BranchResponse response =
                          await FlutterBranchSdk.redeemRewards(count: 5);
                      if (response.success) {
                        success = response.result;
                        print('Redeeming Credits: $success');
                        showSnackBar(message: 'Redeeming Credits: $success');
                      } else {
                        print(
                            'Redeeming Credits error: ${response.errorMessage}');
                        showSnackBar(
                            message:
                                'Redeeming Credits error: ${response.errorMessage}');
                      }
                      //success = await
                    },
                  ),
                ),
              ],
            ),
            RaisedButton(
                child: Text('Get Credits Hystory'),
                onPressed: () async {
                  bool isUserIdentified =
                      await FlutterBranchSdk.isUserIdentified();

                  print('isUserIdentified: $isUserIdentified');

                  if (!isUserIdentified) {
                    showSnackBar(message: 'User not identified');
                    return;
                  }

                  BranchResponse response =
                      await FlutterBranchSdk.getCreditHistory();
                  if (response.success) {
                    print('Credits Hystory: ${response.result}');
                    showSnackBar(
                        message:
                            'Check log for view Credit History. Records: ${(response.result as List).length}');
                  } else {
                    print(
                        'Get Credits Hystory error: ${response.errorMessage}');
                    showSnackBar(
                        message:
                            'Get Credits Hystory error: ${response.errorMessage}');
                  }
                }),
            RaisedButton(
              child: Text('Generate Link'),
              onPressed: generateLink,
            ),
            StreamBuilder<String>(
              stream: controllerUrl.stream,
              initialData: '',
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data.isNotEmpty) {
                  return Column(
                    children: <Widget>[
                      Center(
                          child: Text(
                        'Link build',
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      )),
                      Center(child: Text(snapshot.data))
                    ],
                  );
                } else {
                  return Container();
                }
              },
            ),
            RaisedButton(
              child: Text('Share Link'),
              onPressed: shareLink,
            ),
            SizedBox(
              height: 10,
            ),
            Divider(),
            Center(
              child: Text(
                'Deep Link data',
                style:
                    TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
              ),
            ),
            Divider(),
            StreamBuilder<String>(
              stream: controllerData.stream,
              initialData: '',
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data.isNotEmpty) {
                  return Column(
                    children: <Widget>[Center(child: Text(snapshot.data))],
                  );
                } else {
                  return Container();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void generateLink() async {
    BranchResponse response =
        await FlutterBranchSdk.getShortUrl(buo: buo, linkProperties: lp);
    if (response.success) {
      controllerUrl.sink.add('${response.result}');
    } else {
      controllerUrl.sink
          .add('Error : ${response.errorCode} - ${response.errorMessage}');
    }
  }

  void shareLink() async {
    BranchResponse response = await FlutterBranchSdk.showShareSheet(
        buo: buo,
        linkProperties: lp,
        messageText: 'My Share text',
        androidMessageTitle: 'My Message Title',
        androidSharingTitle: 'My Share with');

    if (response.success) {
      showSnackBar(message: 'showShareSheet Sucess', duration: 5);
    } else {
      showSnackBar(
          message:
              'showShareSheet Error: ${response.errorCode} - ${response.errorMessage}',
          duration: 5);
    }
  }

  @override
  void dispose() {
    super.dispose();
    controllerData.close();
    controllerUrl.close();
    controllerInitSession.close();
    streamSubscription.cancel();
  }
}