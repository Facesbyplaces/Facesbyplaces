// import 'package:facesbyplaces/API/BLM/api-22-blm-show-user-information.dart';
// import 'package:facesbyplaces/Configurations/size_configuration.dart';
// import 'package:facesbyplaces/API/BLM/api-20-blm-logout.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:loader_overlay/loader_overlay.dart';
// import 'package:flutter/material.dart';
// import '../../ui-01-get-started.dart';
// import 'misc-02-blm-dialog.dart';
// import 'dart:io';


// class MiscBLMDrawer extends StatefulWidget{

//   MiscBLMDrawerState createState() => MiscBLMDrawerState();
// }

// class MiscBLMDrawerState extends State<MiscBLMDrawer>{

//   File myFile;

//   void initState(){
//     super.initState();
//     apiBLMShowProfileInformation();
//   }

//   @override
//   Widget build(BuildContext context){
//     return Drawer(
//       child: Container(
//         color: Color(0xff4EC9D4),
//         child: FutureBuilder<APIBLMShowProfileInformation>(
//           future: apiBLMShowProfileInformation(),
//           builder: (context, manageDrawer){
//             if(manageDrawer.hasData){
//               return Column(
//                 children: [
//                   SizedBox(height: SizeConfig.blockSizeVertical * 2,),

//                   CircleAvatar(
//                     radius: SizeConfig.blockSizeVertical * 10.5,
//                     backgroundColor: Color(0xff888888),
//                     backgroundImage: ((){
//                       if(manageDrawer.data.image != null && manageDrawer.data.image != ''){
//                         return NetworkImage(manageDrawer.data.image);
//                       }else{
//                         return AssetImage('assets/icons/graveyard.png');
//                       }
//                     }()),
//                   ),

//                   SizedBox(height: SizeConfig.blockSizeVertical * 2,),

//                   Text(manageDrawer.data.firstName + ' ' + manageDrawer.data.lastName, style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 5, fontWeight: FontWeight.w500, color: Color(0xffffffff),),),

//                   SizedBox(height: SizeConfig.blockSizeVertical * 5,),

//                   GestureDetector(
//                     onTap: (){
//                       Navigator.pop(context);
//                     },
//                     child: Text('Home', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 5, fontWeight: FontWeight.w200, color: Color(0xffffffff),),),
//                   ),

//                   SizedBox(height: SizeConfig.blockSizeVertical * 3,),

//                   GestureDetector(
//                     onTap: (){
//                       // key.currentState.close();
//                       Navigator.pop(context);
//                       Navigator.pushNamed(context, '/home/blm/home-07-01-blm-create-memorial');
//                     },
//                     child: Text('Create Memorial Page', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 5, fontWeight: FontWeight.w200, color: Color(0xffffffff),),),
//                   ),

//                   SizedBox(height: SizeConfig.blockSizeVertical * 3,),

//                   GestureDetector(
//                     onTap: (){
//                       Navigator.pop(context);
//                       Navigator.pushNamed(context, '/home/blm/home-30-blm-notification-settings');
//                     },
//                     child: Text('Notification Settings', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 5, fontWeight: FontWeight.w200, color: Color(0xffffffff),),),
//                   ),

//                   SizedBox(height: SizeConfig.blockSizeVertical * 3,),

//                   GestureDetector(
//                     onTap: (){
//                       Navigator.pop(context);
//                       Navigator.pushNamed(context, '/home/blm/home-14-blm-user-details');
//                     },
//                     child: Text('Profile Settings', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 5, fontWeight: FontWeight.w200, color: Color(0xffffffff),),),
//                   ),

//                   SizedBox(height: SizeConfig.blockSizeVertical * 3,),

//                   GestureDetector(
//                     onTap: () async{
//                       context.showLoaderOverlay();
//                       bool result = await apiBLMLogout();
//                       context.hideLoaderOverlay();

//                       if(result){
//                         Route newRoute = MaterialPageRoute(builder: (BuildContext context) => UIGetStarted());
//                         Navigator.pushAndRemoveUntil(context, newRoute, (route) => false);
//                       }else{
//                         await showDialog(context: (context), builder: (build) => MiscBLMAlertDialog(title: 'Error', content: 'Something went wrong. Please try again'));
//                       }
                      
//                     },
//                     child: Text('Log Out', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 5, fontWeight: FontWeight.w200, color: Color(0xffffffff),),),
//                   ),
                  
//                 ],
//               );
//             }else if(manageDrawer.hasError){
//               return Center(child: Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),),);
//             }else{
//               return Container(child: Center(child: Container(child: SpinKitThreeBounce(color: Color(0xff000000), size: 50.0,), color: Color(0xffffffff),),),);
//             }
//           },
//         ),
//       ),
//     );
//   }
// }





// import 'package:facesbyplaces/API/BLM/api-22-blm-show-user-information.dart';
// import 'package:facesbyplaces/Configurations/size_configuration.dart';
// import 'package:facesbyplaces/API/BLM/api-20-blm-logout.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:loader_overlay/loader_overlay.dart';
// import 'package:flutter/material.dart';
// import '../../ui-01-get-started.dart';
// import 'misc-02-blm-dialog.dart';
// import 'dart:io';


// class MiscBLMDrawer extends StatefulWidget{

//   MiscBLMDrawerState createState() => MiscBLMDrawerState();
// }

// class MiscBLMDrawerState extends State<MiscBLMDrawer>{

//   File myFile;
//   Future drawerSettings;

//   // void initState(){
//   //   super.initState();
//   //   apiBLMShowProfileInformation();
//   // }

//   void initState(){
//     super.initState();
//     // apiBLMShowProfileInformation();
//     drawerSettings = getDrawerInformation();
//   }

//   Future<APIBLMShowProfileInformation> getDrawerInformation() async{
//     return await apiBLMShowProfileInformation();
//   }

//   @override
//   Widget build(BuildContext context){
//     return Drawer(
//       child: Container(
//         color: Color(0xff4EC9D4),
//         child: FutureBuilder<APIBLMShowProfileInformation>(
//           future: drawerSettings,
//           builder: (context, manageDrawer){
//             if(manageDrawer.connectionState == ConnectionState.none){
//               return Center(child: Text('Empty drawer settings.', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),),);
//             }else if(manageDrawer.connectionState == ConnectionState.active || manageDrawer.connectionState == ConnectionState.waiting){
//               // return Center(child: Text('Waiting...', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),),);
//               return Container(child: Center(child: Container(child: SpinKitThreeBounce(color: Color(0xff000000), size: 50.0,), color: Color(0xffffffff),),),);
//             }else if(manageDrawer.connectionState == ConnectionState.done){
//               return Column(
//                 children: [
//                   SizedBox(height: SizeConfig.blockSizeVertical * 2,),

//                   CircleAvatar(
//                     radius: SizeConfig.blockSizeVertical * 10.5,
//                     backgroundColor: Color(0xff888888),
//                     backgroundImage: ((){
//                       if(manageDrawer.data.image != null && manageDrawer.data.image != ''){
//                         return NetworkImage(manageDrawer.data.image);
//                       }else{
//                         return AssetImage('assets/icons/graveyard.png');
//                       }
//                     }()),
//                   ),

//                   SizedBox(height: SizeConfig.blockSizeVertical * 2,),

//                   Text(manageDrawer.data.firstName + ' ' + manageDrawer.data.lastName, style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 5, fontWeight: FontWeight.w500, color: Color(0xffffffff),),),

//                   SizedBox(height: SizeConfig.blockSizeVertical * 5,),

//                   GestureDetector(
//                     onTap: (){
//                       Navigator.pop(context);
//                     },
//                     child: Text('Home', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 5, fontWeight: FontWeight.w200, color: Color(0xffffffff),),),
//                   ),

//                   SizedBox(height: SizeConfig.blockSizeVertical * 3,),

//                   GestureDetector(
//                     onTap: (){
//                       // key.currentState.close();
//                       Navigator.pop(context);
//                       Navigator.pushNamed(context, '/home/blm/home-07-01-blm-create-memorial');
//                     },
//                     child: Text('Create Memorial Page', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 5, fontWeight: FontWeight.w200, color: Color(0xffffffff),),),
//                   ),

//                   SizedBox(height: SizeConfig.blockSizeVertical * 3,),

//                   GestureDetector(
//                     onTap: (){
//                       Navigator.pop(context);
//                       Navigator.pushNamed(context, '/home/blm/home-30-blm-notification-settings');
//                     },
//                     child: Text('Notification Settings', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 5, fontWeight: FontWeight.w200, color: Color(0xffffffff),),),
//                   ),

//                   SizedBox(height: SizeConfig.blockSizeVertical * 3,),

//                   GestureDetector(
//                     onTap: (){
//                       Navigator.pop(context);
//                       Navigator.pushNamed(context, '/home/blm/home-14-blm-user-details');
//                     },
//                     child: Text('Profile Settings', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 5, fontWeight: FontWeight.w200, color: Color(0xffffffff),),),
//                   ),

//                   SizedBox(height: SizeConfig.blockSizeVertical * 3,),

//                   GestureDetector(
//                     onTap: () async{
//                       context.showLoaderOverlay();
//                       bool result = await apiBLMLogout();
//                       context.hideLoaderOverlay();

//                       if(result){
//                         Route newRoute = MaterialPageRoute(builder: (BuildContext context) => UIGetStarted());
//                         Navigator.pushAndRemoveUntil(context, newRoute, (route) => false);
//                       }else{
//                         await showDialog(context: (context), builder: (build) => MiscBLMAlertDialog(title: 'Error', content: 'Something went wrong. Please try again'));
//                       }
                      
//                     },
//                     child: Text('Log Out', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 5, fontWeight: FontWeight.w200, color: Color(0xffffffff),),),
//                   ),
                  
//                 ],
//               );
//             }else{
//               return Center(child: Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),),);
//             }

//             // if(manageDrawer.hasData){
//             //   return Column(
//             //     children: [
//             //       SizedBox(height: SizeConfig.blockSizeVertical * 2,),

//             //       CircleAvatar(
//             //         radius: SizeConfig.blockSizeVertical * 10.5,
//             //         backgroundColor: Color(0xff888888),
//             //         backgroundImage: ((){
//             //           if(manageDrawer.data.image != null && manageDrawer.data.image != ''){
//             //             return NetworkImage(manageDrawer.data.image);
//             //           }else{
//             //             return AssetImage('assets/icons/graveyard.png');
//             //           }
//             //         }()),
//             //       ),

//             //       SizedBox(height: SizeConfig.blockSizeVertical * 2,),

//             //       Text(manageDrawer.data.firstName + ' ' + manageDrawer.data.lastName, style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 5, fontWeight: FontWeight.w500, color: Color(0xffffffff),),),

//             //       SizedBox(height: SizeConfig.blockSizeVertical * 5,),

//             //       GestureDetector(
//             //         onTap: (){
//             //           Navigator.pop(context);
//             //         },
//             //         child: Text('Home', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 5, fontWeight: FontWeight.w200, color: Color(0xffffffff),),),
//             //       ),

//             //       SizedBox(height: SizeConfig.blockSizeVertical * 3,),

//             //       GestureDetector(
//             //         onTap: (){
//             //           // key.currentState.close();
//             //           Navigator.pop(context);
//             //           Navigator.pushNamed(context, '/home/blm/home-07-01-blm-create-memorial');
//             //         },
//             //         child: Text('Create Memorial Page', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 5, fontWeight: FontWeight.w200, color: Color(0xffffffff),),),
//             //       ),

//             //       SizedBox(height: SizeConfig.blockSizeVertical * 3,),

//             //       GestureDetector(
//             //         onTap: (){
//             //           Navigator.pop(context);
//             //           Navigator.pushNamed(context, '/home/blm/home-30-blm-notification-settings');
//             //         },
//             //         child: Text('Notification Settings', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 5, fontWeight: FontWeight.w200, color: Color(0xffffffff),),),
//             //       ),

//             //       SizedBox(height: SizeConfig.blockSizeVertical * 3,),

//             //       GestureDetector(
//             //         onTap: (){
//             //           Navigator.pop(context);
//             //           Navigator.pushNamed(context, '/home/blm/home-14-blm-user-details');
//             //         },
//             //         child: Text('Profile Settings', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 5, fontWeight: FontWeight.w200, color: Color(0xffffffff),),),
//             //       ),

//             //       SizedBox(height: SizeConfig.blockSizeVertical * 3,),

//             //       GestureDetector(
//             //         onTap: () async{
//             //           context.showLoaderOverlay();
//             //           bool result = await apiBLMLogout();
//             //           context.hideLoaderOverlay();

//             //           if(result){
//             //             Route newRoute = MaterialPageRoute(builder: (BuildContext context) => UIGetStarted());
//             //             Navigator.pushAndRemoveUntil(context, newRoute, (route) => false);
//             //           }else{
//             //             await showDialog(context: (context), builder: (build) => MiscBLMAlertDialog(title: 'Error', content: 'Something went wrong. Please try again'));
//             //           }
                      
//             //         },
//             //         child: Text('Log Out', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 5, fontWeight: FontWeight.w200, color: Color(0xffffffff),),),
//             //       ),
                  
//             //     ],
//             //   );
//             // }else if(manageDrawer.hasError){
//             //   return Center(child: Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),),);
//             // }else{
//             //   return Container(child: Center(child: Container(child: SpinKitThreeBounce(color: Color(0xff000000), size: 50.0,), color: Color(0xffffffff),),),);
//             // }
//           },
//         ),
//       ),
//     );
//   }
// }





// import 'package:facesbyplaces/API/BLM/api-22-blm-show-user-information.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/API/BLM/api-20-blm-logout.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter/material.dart';
import '../../ui-01-get-started.dart';
import 'misc-02-blm-dialog.dart';
// import 'dart:io';


// class MiscBLMDrawer extends StatefulWidget{

//   MiscBLMDrawerState createState() => MiscBLMDrawerState();
// }

class MiscBLMDrawer extends StatelessWidget{

  final String firstName;
  final String lastName;
  final String image;

  MiscBLMDrawer({this.firstName, this.lastName, this.image});

  @override
  Widget build(BuildContext context){
    return Drawer(
      child: Container(
        color: Color(0xff4EC9D4),
        child: Column(
          children: [
            SizedBox(height: SizeConfig.blockSizeVertical * 2,),

            CircleAvatar(
              radius: SizeConfig.blockSizeVertical * 10.5,
              backgroundColor: Color(0xff888888),
              backgroundImage: ((){
                if(image != null && image != ''){
                  return AssetImage(image);
                }else{
                  return AssetImage('assets/icons/graveyard.png');
                }
              }()),
            ),

            SizedBox(height: SizeConfig.blockSizeVertical * 2,),

            Text(firstName + ' ' + lastName, style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 5, fontWeight: FontWeight.w500, color: Color(0xffffffff),),),

            SizedBox(height: SizeConfig.blockSizeVertical * 5,),

            GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: Text('Home', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 5, fontWeight: FontWeight.w200, color: Color(0xffffffff),),),
            ),

            SizedBox(height: SizeConfig.blockSizeVertical * 3,),

            GestureDetector(
              onTap: (){
                // key.currentState.close();
                Navigator.pop(context);
                Navigator.pushNamed(context, '/home/blm/home-07-01-blm-create-memorial');
              },
              child: Text('Create Memorial Page', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 5, fontWeight: FontWeight.w200, color: Color(0xffffffff),),),
            ),

            SizedBox(height: SizeConfig.blockSizeVertical * 3,),

            GestureDetector(
              onTap: (){
                Navigator.pop(context);
                Navigator.pushNamed(context, '/home/blm/home-30-blm-notification-settings');
              },
              child: Text('Notification Settings', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 5, fontWeight: FontWeight.w200, color: Color(0xffffffff),),),
            ),

            SizedBox(height: SizeConfig.blockSizeVertical * 3,),

            GestureDetector(
              onTap: (){
                Navigator.pop(context);
                Navigator.pushNamed(context, '/home/blm/home-14-blm-user-details');
              },
              child: Text('Profile Settings', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 5, fontWeight: FontWeight.w200, color: Color(0xffffffff),),),
            ),

            SizedBox(height: SizeConfig.blockSizeVertical * 3,),

            GestureDetector(
              onTap: () async{
                context.showLoaderOverlay();
                bool result = await apiBLMLogout();
                context.hideLoaderOverlay();

                if(result){
                  Route newRoute = MaterialPageRoute(builder: (BuildContext context) => UIGetStarted());
                  Navigator.pushAndRemoveUntil(context, newRoute, (route) => false);
                }else{
                  await showDialog(context: (context), builder: (build) => MiscBLMAlertDialog(title: 'Error', content: 'Something went wrong. Please try again'));
                }
                
              },
              child: Text('Log Out', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 5, fontWeight: FontWeight.w200, color: Color(0xffffffff),),),
            ),
            
          ],
        ),
      ),
    );
  }
}