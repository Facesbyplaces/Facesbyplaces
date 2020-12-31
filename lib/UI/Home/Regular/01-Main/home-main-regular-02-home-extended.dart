// import 'package:facesbyplaces/UI/Home/Regular/Settings-Notifications/home-01-regular-notification-settings.dart';
// import 'package:facesbyplaces/UI/Home/Regular/Settings-Memorial/home-14-regular-user-details.dart';
// import 'package:facesbyplaces/API/Regular/api-41-regular-show-notification-settings.dart';
// import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-02-regular-bottom-sheet.dart';
// import 'package:facesbyplaces/API/Regular/api-22-regular-show-user-information.dart';
// import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-08-regular-dialog.dart';
// import 'package:facesbyplaces/Configurations/size_configuration.dart';
// import 'package:facesbyplaces/API/Regular/api-18-regular-logout.dart';
// import 'package:facesbyplaces/Bloc/bloc-04-bloc-regular-home.dart';
// import 'package:flutter_login_facebook/flutter_login_facebook.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:loader_overlay/loader_overlay.dart';
// import 'home-03-04-regular-notifications-tab.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'home-03-01-regular-feed-tab.dart';
// import 'home-03-02-regular-memorial-list-tab.dart';
// import 'home-03-03-regular-post-tab.dart';
// import '../../../ui-01-get-started.dart';
// import 'package:flutter/material.dart';

// class HomeRegularScreenExtended extends StatefulWidget{

//   HomeRegularScreenExtendedState createState() => HomeRegularScreenExtendedState();
// }

// class HomeRegularScreenExtendedState extends State<HomeRegularScreenExtended>{
//   Future drawerSettings;

//   Future<APIRegularShowProfileInformation> getDrawerInformation() async{
//     return await apiRegularShowProfileInformation();
//   }

//   void initState(){
//     super.initState();
//     drawerSettings = getDrawerInformation();
//   }

//   @override
//   Widget build(BuildContext context) {
//     SizeConfig.init(context);
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider<BlocHomeRegularUpdateCubit>(create: (context) => BlocHomeRegularUpdateCubit(),),
//         BlocProvider<BlocHomeRegularUpdateToggle>(create: (context) => BlocHomeRegularUpdateToggle(),),
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
//               leading: FutureBuilder<APIRegularShowProfileInformation>(
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
//               title: Text('FacesByPlaces.com', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xffffffff),),),
//               centerTitle: true,
//               actions: [
//                 IconButton(
//                   icon: Icon(Icons.search, color: Color(0xffffffff), size: SizeConfig.blockSizeVertical * 4,), 
//                   onPressed: () async{
//                     Navigator.pushNamed(context, '/home/regular/search');
//                   },
//                 ),
//               ],
//             ),
//             body: BlocBuilder<BlocHomeRegularUpdateCubit, int>(
//               builder: (context, toggleBottom){
//                 return Container(
//                   decoration: BoxDecoration(image: DecorationImage(fit: BoxFit.cover, image: AssetImage('assets/icons/background2.png'), colorFilter: ColorFilter.srgbToLinearGamma(),),),
//                   child: ((){
//                     switch(toggleBottom){
//                       case 0: return HomeRegularFeedTab(); break;
//                       case 1: return HomeRegularManageTab(); break;
//                       case 2: return HomeRegularPostTab(); break;
//                       case 3: return HomeRegularNotificationsTab(); break;
//                     }
//                   }()),
//                 );
//               },
//             ),
//             bottomSheet: MiscRegularBottomSheet(),
//             drawer: FutureBuilder<APIRegularShowProfileInformation>(
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

//                           Text(manageDrawer.data.firstName + ' ' + manageDrawer.data.lastName, textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 5, fontWeight: FontWeight.w500, color: Color(0xffffffff),),),

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
//                               Navigator.pushNamed(context, '/home/regular/create-memorial');
//                             },
//                             child: Text('Create Memorial Page', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 5, fontWeight: FontWeight.w200, color: Color(0xffffffff),),),
//                           ),

//                           SizedBox(height: SizeConfig.blockSizeVertical * 3,),

//                           GestureDetector(
//                             onTap: () async{
//                               context.showLoaderOverlay();
//                               APIRegularShowNotificationStatus result = await apiRegularShowNotificationStatus(userId: manageDrawer.data.userId);
//                               context.hideLoaderOverlay();

//                               Navigator.pop(context);
//                               Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularNotificationSettings(
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
//                             onTap: () async{
//                               Navigator.pop(context);
//                               Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularUserProfileDetails(userId: manageDrawer.data.userId)));
//                             },
//                             child: Text('Profile Settings', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 5, fontWeight: FontWeight.w200, color: Color(0xffffffff),),),
//                           ),

//                           SizedBox(height: SizeConfig.blockSizeVertical * 3,),

//                           GestureDetector(
//                             onTap: () async{

//                               context.showLoaderOverlay();
//                               bool result = await apiRegularLogout();

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
//                                 await showDialog(context: (context), builder: (build) => MiscRegularAlertDialog(title: 'Error', content: 'Something went wrong. Please try again'));
//                               }

//                               //   Route newRoute = MaterialPageRoute(builder: (BuildContext context) => UIGetStarted());
//                               //   Navigator.pushAndRemoveUntil(context, newRoute, (route) => false);

//                               // final sharedPrefs = await SharedPreferences.getInstance();

//                               // sharedPrefs.remove('blm-user-id');
//                               // sharedPrefs.remove('blm-access-token');
//                               // sharedPrefs.remove('blm-uid');
//                               // sharedPrefs.remove('blm-client');
//                               // sharedPrefs.remove('blm-user-session');

//                               // sharedPrefs.remove('regular-user-id');
//                               // sharedPrefs.remove('regular-access-token');
//                               // sharedPrefs.remove('regular-uid');
//                               // sharedPrefs.remove('regular-client');
//                               // sharedPrefs.remove('regular-user-session');
                              
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





import 'package:facesbyplaces/UI/Home/Regular/09-Settings-User/home-settings-user-regular-01-user-details.dart';
import 'package:facesbyplaces/API/Regular/api-41-regular-show-notification-settings.dart';
import 'package:facesbyplaces/UI/Home/Regular/10-Settings-Notifications/home-settings-notifications-regular-01-notification-settings.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-02-regular-bottom-sheet.dart';
import 'package:facesbyplaces/API/Regular/api-22-regular-show-user-information.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-08-regular-dialog.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/API/Regular/api-18-regular-logout.dart';
import 'package:facesbyplaces/Bloc/bloc-04-bloc-regular-home.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../ui-01-get-started.dart';
import 'package:flutter/material.dart';

import 'home-main-regular-03-01-feed-tab.dart';
import 'home-main-regular-03-02-memorial-list-tab.dart';
import 'home-main-regular-03-03-post-tab.dart';
import 'home-main-regular-03-04-notifications-tab.dart';

class HomeRegularScreenExtended extends StatefulWidget{

  HomeRegularScreenExtendedState createState() => HomeRegularScreenExtendedState();
}

class HomeRegularScreenExtendedState extends State<HomeRegularScreenExtended>{
  Future drawerSettings;

  Future<APIRegularShowProfileInformation> getDrawerInformation() async{
    return await apiRegularShowProfileInformation();
  }

  void initState(){
    super.initState();
    drawerSettings = getDrawerInformation();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    ResponsiveWidgets.init(context,
      height: SizeConfig.screenHeight,
      width: SizeConfig.screenWidth,
    );
    return MultiBlocProvider(
      providers: [
        BlocProvider<BlocHomeRegularUpdateCubit>(create: (context) => BlocHomeRegularUpdateCubit(),),
        BlocProvider<BlocHomeRegularUpdateToggle>(create: (context) => BlocHomeRegularUpdateToggle(),),
      ],
      child: BlocBuilder<BlocHomeRegularUpdateCubit, int>(
        builder: (context, toggleBottom){
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
                  backgroundColor: Color(0xff4EC9D4),
                  leading: FutureBuilder<APIRegularShowProfileInformation>(
                    future: drawerSettings,
                    builder: (context, profileImage){
                      if(profileImage.hasData){
                        return Builder(
                          builder: (context){
                            return IconButton(
                              icon: CircleAvatar(
                                backgroundColor: Color(0xff888888),
                                backgroundImage: ((){
                                  if(profileImage.data.image != null && profileImage.data.image != ''){
                                    return NetworkImage(profileImage.data.image);
                                  }else{
                                    return AssetImage('assets/icons/app-icon.png');
                                  }
                                }()),
                              ),
                              onPressed: () async{
                                Scaffold.of(context).openDrawer();
                              },
                            );
                          },
                        );
                      }else if(profileImage.hasError){
                        return Icon(Icons.error);
                      }else{
                        return Container(child: CircularProgressIndicator(), padding: EdgeInsets.all(20.0),);
                      }
                    },
                  ),
                  title: Text('FacesByPlaces.com', style: TextStyle(fontSize: ScreenUtil().setSp(16, allowFontScalingSelf: true), color: Color(0xffffffff),),),
                  centerTitle: true,
                  actions: [
                    IconButton(
                      // ScreenUtil().setHeight(20)
                      // icon: Icon(Icons.search, color: Color(0xffffffff), size: SizeConfig.blockSizeVertical * 4,),
                      icon: Icon(Icons.search, color: Color(0xffffffff), size: ScreenUtil().setHeight(35)),
                      onPressed: () async{
                        Navigator.pushNamed(context, '/home/regular/search');
                      },
                    ),
                  ],
                ),
                body: Container(
                  decoration: BoxDecoration(image: DecorationImage(fit: BoxFit.cover, image: AssetImage('assets/icons/background2.png'), colorFilter: ColorFilter.srgbToLinearGamma(),),),
                  child: ((){
                    switch(toggleBottom){
                      case 0: return HomeRegularFeedTab(); break;
                      case 1: return HomeRegularManageTab(); break;
                      case 2: return HomeRegularPostTab(); break;
                      case 3: return HomeRegularNotificationsTab(); break;
                    }
                  }()),
                ),
                bottomSheet: MiscRegularBottomSheet(),
                drawer: FutureBuilder<APIRegularShowProfileInformation>(
                  future: drawerSettings,
                  builder: (context, manageDrawer){
                    if(manageDrawer.hasData){
                      return Drawer(
                        child: ContainerResponsive(
                          height: SizeConfig.screenHeight,
                          width: SizeConfig.screenWidth,
                          alignment: Alignment.center,
                          child: ContainerResponsive(
                            width: SizeConfig.screenWidth,
                            heightResponsive: false,
                            widthResponsive: true,
                            // alignment: Alignment.center,
                            alignment: Alignment.topCenter,
                            color: Color(0xff4EC9D4),
                            child: SingleChildScrollView(
                              physics: ClampingScrollPhysics(),
                              child: Column(
                                children: [
                                  // SizedBox(height: SizeConfig.blockSizeVertical * 2,),
                                  SizedBox(height: ScreenUtil().setHeight(20)),

                                  CircleAvatar(
                                    // radius: SizeConfig.blockSizeVertical * 10.5,
                                    radius: ScreenUtil().setHeight(100),
                                    backgroundColor: Color(0xff888888),
                                    backgroundImage: ((){
                                      if(manageDrawer.data.image != null && manageDrawer.data.image != ''){
                                        return NetworkImage(manageDrawer.data.image);
                                      }else{
                                        return AssetImage('assets/icons/app-icon.png');
                                      }
                                    }()),
                                  ),

                                  // SizedBox(height: SizeConfig.blockSizeVertical * 2,),
                                  SizedBox(height: ScreenUtil().setHeight(20)),

                                  Text(manageDrawer.data.firstName + ' ' + manageDrawer.data.lastName, textAlign: TextAlign.center, style: TextStyle(fontSize: ScreenUtil().setSp(20, allowFontScalingSelf: true), fontWeight: FontWeight.w500, color: Color(0xffffffff),),),

                                  // SizedBox(height: SizeConfig.blockSizeVertical * 5,),
                                  SizedBox(height: ScreenUtil().setHeight(45)),

                                  GestureDetector(
                                    onTap: (){
                                      Navigator.pop(context);
                                    },
                                    // ScreenUtil().setSp(20, allowFontScalingSelf: true),
                                    // child: Text('Home', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 5, fontWeight: FontWeight.w200, color: Color(0xffffffff),),),
                                    child: Text('Home', style: TextStyle(fontSize: ScreenUtil().setSp(20, allowFontScalingSelf: true), fontWeight: FontWeight.w200, color: Color(0xffffffff),),),
                                  ),

                                  // SizedBox(height: SizeConfig.blockSizeVertical * 3,),
                                  SizedBox(height: ScreenUtil().setHeight(25)),

                                  GestureDetector(
                                    onTap: (){
                                      Navigator.pop(context);
                                      Navigator.pushNamed(context, '/home/regular/create-memorial');
                                    },
                                    child: Text('Create Memorial Page', style: TextStyle(fontSize: ScreenUtil().setSp(20, allowFontScalingSelf: true), fontWeight: FontWeight.w200, color: Color(0xffffffff),),),
                                  ),

                                  // SizedBox(height: SizeConfig.blockSizeVertical * 3,),
                                  SizedBox(height: ScreenUtil().setHeight(20)),

                                  GestureDetector(
                                    onTap: () async{
                                      context.showLoaderOverlay();
                                      APIRegularShowNotificationStatus result = await apiRegularShowNotificationStatus(userId: manageDrawer.data.userId);
                                      context.hideLoaderOverlay();

                                      Navigator.pop(context);
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularNotificationSettings(
                                        newMemorial: result.newMemorial,
                                        newActivities: result.newActivities,
                                        postLikes: result.postLikes,
                                        postComments: result.postComments,
                                        addFamily: result.addFamily,
                                        addFriends: result.addFriends,
                                        addAdmin: result.addAdmin,
                                      )));
                                    },
                                    child: Text('Notification Settings', style: TextStyle(fontSize: ScreenUtil().setSp(20, allowFontScalingSelf: true), fontWeight: FontWeight.w200, color: Color(0xffffffff),),),
                                  ),

                                  // SizedBox(height: SizeConfig.blockSizeVertical * 3,),
                                  SizedBox(height: ScreenUtil().setHeight(20)),

                                  GestureDetector(
                                    onTap: () async{
                                      Navigator.pop(context);
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularUserProfileDetails(userId: manageDrawer.data.userId)));
                                    },
                                    child: Text('Profile Settings', style: TextStyle(fontSize: ScreenUtil().setSp(20, allowFontScalingSelf: true), fontWeight: FontWeight.w200, color: Color(0xffffffff),),),
                                  ),

                                  // SizedBox(height: SizeConfig.blockSizeVertical * 3,),
                                  SizedBox(height: ScreenUtil().setHeight(20)),

                                  GestureDetector(
                                    onTap: () async{

                                      context.showLoaderOverlay();
                                      bool result = await apiRegularLogout();

                                      GoogleSignIn googleSignIn = GoogleSignIn(
                                        scopes: [
                                          'profile',
                                          'email',
                                          'openid'
                                        ],
                                      );
                                      await googleSignIn.signOut();

                                      FacebookLogin fb = FacebookLogin();
                                      await fb.logOut();

                                      context.hideLoaderOverlay();

                                      if(result){
                                        Route newRoute = MaterialPageRoute(builder: (BuildContext context) => UIGetStarted());
                                        Navigator.pushAndRemoveUntil(context, newRoute, (route) => false);
                                      }else{
                                        await showDialog(context: (context), builder: (build) => MiscRegularAlertDialog(title: 'Error', content: 'Something went wrong. Please try again'));
                                      }

                                      //   Route newRoute = MaterialPageRoute(builder: (BuildContext context) => UIGetStarted());
                                      //   Navigator.pushAndRemoveUntil(context, newRoute, (route) => false);

                                      // final sharedPrefs = await SharedPreferences.getInstance();

                                      // sharedPrefs.remove('blm-user-id');
                                      // sharedPrefs.remove('blm-access-token');
                                      // sharedPrefs.remove('blm-uid');
                                      // sharedPrefs.remove('blm-client');
                                      // sharedPrefs.remove('blm-user-session');

                                      // sharedPrefs.remove('regular-user-id');
                                      // sharedPrefs.remove('regular-access-token');
                                      // sharedPrefs.remove('regular-uid');
                                      // sharedPrefs.remove('regular-client');
                                      // sharedPrefs.remove('regular-user-session');
                                      
                                    },
                                    child: Text('Log Out', style: TextStyle(fontSize: ScreenUtil().setSp(20, allowFontScalingSelf: true), fontWeight: FontWeight.w200, color: Color(0xffffffff),),),
                                  ),
                                  
                                ],
                              ),
                            ),
                          ),
                        ),
                        // child: 
                      );
                    }else if(manageDrawer.hasError){
                      return Center(child: Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),),);
                    }else{
                      return Container(child: Center(child: Container(child: SpinKitThreeBounce(color: Color(0xff000000), size: 50.0,), color: Color(0xffffffff),),),);
                    }
                  }
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
