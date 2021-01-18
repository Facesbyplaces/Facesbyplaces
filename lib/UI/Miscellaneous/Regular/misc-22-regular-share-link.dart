// // StreamSubscription<Map> streamSubscription;
// // void listenDeepLinkData(){
// //   streamSubscription = FlutterBranchSdk.initSession().listen((data) {
// //     if((data.containsKey("+clicked_branch_link") && data["+clicked_branch_link"] == true) && data.containsKey("link-category")){
// //       print('The link category is ${data["link-category"]}');
// //       initUnitShare();
// //     }else if (data.containsKey("+clicked_branch_link") && data["+clicked_branch_link"] == true){
// //       initUnit();
// //     }
// //   }, onError: (error) {
// //     PlatformException platformException = error as PlatformException;
// //     print('InitSession error: ${platformException.code} - ${platformException.message}');
// //   });

// // }





// import 'dart:async';

// import 'package:facesbyplaces/UI/Home/Regular/11-Show-Post/home-show-post-regular-01-show-original-post.dart';
// import 'package:facesbyplaces/UI/Regular/regular-06-password-reset.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';

// void miscRegularShowReply({BuildContext context}) async{

//   print('New Test New Test New Test New Test New Test New Test New Test New Test');

//   initUnit() async{
//     bool login = await FlutterBranchSdk.isUserIdentified();

//     print('The value of isUserIdentified for login is $login');

//     if(login){
//       var value1 = await FlutterBranchSdk.getLatestReferringParams();
//       var value2 = await FlutterBranchSdk.getFirstReferringParams();

//       print('The value of getLatestReferringParams is $value1');
//       print('The value of getFirstReferringParams is $value2');

//       Navigator.push(context, MaterialPageRoute(builder: (context) => RegularPasswordReset()));
//     }
//   }

//   initUnitShare() async{
//     bool login = await FlutterBranchSdk.isUserIdentified();

//     print('The value of isUserIdentified for login is $login');

//     if(login){
//       var value1 = await FlutterBranchSdk.getLatestReferringParams();
//       var value2 = await FlutterBranchSdk.getFirstReferringParams();

//       print('The value of getLatestReferringParams is $value1');
//       print('The value of getFirstReferringParams is $value2');

//       // Navigator.push(context, MaterialPageRoute(builder: (context) => RegularPasswordReset()));

//       // Navigator.pushReplacementNamed(context, '/home/regular');
//       FlutterBranchSdk.logout();

//       print('Navigate!');

//       // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeRegularScreen()));
//       // Navigator.pushNamed(context, '/home/regular/search');
//       // Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularShowOriginalPost(postId: 1, likeStatus: false, numberOfLikes: 0,)));
//       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeRegularShowOriginalPost(postId: 1, likeStatus: false, numberOfLikes: 0,)));
//     }
//   }

//   StreamSubscription<Map> streamSubscription;

//   void listenDeepLinkData(){
//     streamSubscription = FlutterBranchSdk.initSession().listen((data) {
//       if((data.containsKey("+clicked_branch_link") && data["+clicked_branch_link"] == true) && data.containsKey("link-category")){
//         print('The link category is ${data["link-category"]}');
//         initUnitShare();
//       }else if (data.containsKey("+clicked_branch_link") && data["+clicked_branch_link"] == true){
//         initUnit();
//       }
//     }, onError: (error) {
//       PlatformException platformException = error as PlatformException;
//       print('InitSession error: ${platformException.code} - ${platformException.message}');
//     });
//   }

//   print('Read read read read!');

//   listenDeepLinkData();

//   streamSubscription.cancel();



// }