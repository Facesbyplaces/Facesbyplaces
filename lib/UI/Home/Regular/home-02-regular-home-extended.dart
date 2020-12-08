import 'package:cached_network_image/cached_network_image.dart';
import 'package:facesbyplaces/API/Regular/api-20-regular-show-user-information.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-02-regular-bottom-sheet.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-03-regular-drawer.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/Bloc/bloc-04-bloc-regular-home.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home-03-01-regular-feed-tab.dart';
import 'home-03-02-regular-memorial-list-tab.dart';
import 'home-03-03-regular-post-tab.dart';
import 'home-03-04-regular-notifications-tab.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class HomeRegularScreenExtended extends StatefulWidget{

  @override
  HomeRegularScreenExtendedState createState() => HomeRegularScreenExtendedState();
}

class HomeRegularScreenExtendedState extends State<HomeRegularScreenExtended>{

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider<BlocHomeRegularUpdateCubit>(
          create: (context) => BlocHomeRegularUpdateCubit(),
        ),
        BlocProvider<BlocHomeRegularUpdateToggle>(
          create: (context) => BlocHomeRegularUpdateToggle(),
        ),
        BlocProvider<BlocHomeRegularUpdateListSuggested>(
          create: (context) => BlocHomeRegularUpdateListSuggested(),
        ),
      ],
      child: WillPopScope(
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
                future: apiRegularShowProfileInformation(),
                builder: (context, profileImage){
                  if(profileImage.hasData){
                    return Builder(
                      builder: (context){
                        return IconButton(
                          icon: CircleAvatar(
                            backgroundColor: Color(0xffffffff),
                            child: CachedNetworkImage(
                              imageUrl: profileImage.data.image,
                              placeholder: (context, url) => Container(child: CircularProgressIndicator(), padding: EdgeInsets.all(20.0),),
                              errorWidget: (context, url, error) => Icon(Icons.error),
                            ),
                          ),
                          onPressed: (){
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
              title: Text('FacesByPlaces.com', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xffffffff),),), 
              // actions: [
              //   IconButton(icon: Icon(Icons.search, color: Color(0xffffffff), size: SizeConfig.blockSizeVertical * 4,), onPressed: (){Navigator.pushNamed(context, '/home/regular/home-05-regular-search');},),
              // ],
              actions: [
                IconButton(
                  icon: Icon(Icons.search, color: Color(0xffffffff), size: SizeConfig.blockSizeVertical * 4,), 
                  onPressed: () async{
                    

                    Location location = new Location();

                    bool serviceEnabled = await location.serviceEnabled();
                    if (!serviceEnabled) {
                      serviceEnabled = await location.requestService();
                      if (!serviceEnabled) {
                        return;
                      }
                    }

                    PermissionStatus permissionGranted = await location.hasPermission();
                    if (permissionGranted == PermissionStatus.denied) {
                      permissionGranted = await location.requestPermission();
                      if (permissionGranted != PermissionStatus.granted) {
                        return;
                      }
                    }

                    LocationData locationData = await location.getLocation();

                    final sharedPrefs = await SharedPreferences.getInstance();
                    sharedPrefs.setDouble('regular-user-location-latitude', locationData.latitude);
                    sharedPrefs.setDouble('regular-user-location-longitude', locationData.longitude);

                    Navigator.pushNamed(context, '/home/regular/home-05-regular-search');

                  },
                ),
              ],

            ),
            body: Container(
              child: BlocBuilder<BlocHomeRegularUpdateCubit, int>(
                builder: (context, state){
                  return ((){
                    switch(state){
                      case 0: return HomeRegularFeedTab(); break;
                      case 1: return HomeRegularManageTab(); break;
                      case 2: return HomeRegularPostTab(); break;
                      case 3: return HomeRegularNotificationsTab(); break;
                    }
                  }());
                },
              ),
            ),
            bottomSheet: MiscRegularBottomSheet(),
            drawer: MiscRegularDrawer(),
          ),
        ),
      ),
    );
  }
}




// import 'package:facesbyplaces/API/BLM/api-22-blm-show-user-information.dart';
// import 'package:facesbyplaces/Bloc/bloc-04-bloc-regular-home.dart';
// import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-02-blm-dialog.dart';
// // import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-04-blm-extra.dart';
// import 'package:facesbyplaces/Configurations/size_configuration.dart';
// import 'package:facesbyplaces/API/BLM/api-20-blm-logout.dart';
// import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-02-regular-bottom-sheet.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:loader_overlay/loader_overlay.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:location/location.dart' as Location;
// import 'package:flutter/material.dart';
// import '../../ui-01-get-started.dart';
// import 'dart:io';

// import 'home-03-01-regular-feed-tab.dart';
// import 'home-03-02-regular-memorial-list-tab.dart';
// import 'home-03-03-regular-post-tab.dart';
// import 'home-03-04-regular-notifications-tab.dart';
// import 'home-05-regular-search.dart';

// class HomeRegularScreenExtended extends StatefulWidget{

//   HomeRegularScreenExtendedState createState() => HomeRegularScreenExtendedState();
// }

// class HomeRegularScreenExtendedState extends State<HomeRegularScreenExtended>{

//   File myFile;
//   Future drawerSettings;
//   Future leadingSettings;

//   void initState(){
//     super.initState();
//     drawerSettings = getDrawerInformation();
//   }

//   Future<APIBLMShowProfileInformation> getDrawerInformation() async{
//     return await apiBLMShowProfileInformation();
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
//               leading: FutureBuilder<APIBLMShowProfileInformation>(
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
//                                 return AssetImage('assets/icons/graveyard.png');
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
                    
//                     Location.Location location = new Location.Location();

//                     bool serviceEnabled = await location.serviceEnabled();
//                     if (!serviceEnabled) {
//                       serviceEnabled = await location.requestService();
//                       if (!serviceEnabled) {
//                         return;
//                       }
//                     }

//                     Location.PermissionStatus permissionGranted = await location.hasPermission();
//                     if (permissionGranted == Location.PermissionStatus.denied) {
//                       permissionGranted = await location.requestPermission();
//                       if (permissionGranted != Location.PermissionStatus.granted) {
//                         return;
//                       }
//                     }

//                     Location.LocationData locationData = await location.getLocation();

//                     print('The latitude is ${locationData.latitude}');
//                     print('The longitude is ${locationData.longitude}');

//                     List<Placemark> placemarks = await placemarkFromCoordinates(locationData.latitude, locationData.longitude);

//                     print('The placemarks ${placemarks[0].name}');

//                     Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularSearch(latitude: locationData.latitude, longitude: locationData.longitude, currentLocation: placemarks[0].name,)));



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
//             drawer: FutureBuilder<APIBLMShowProfileInformation>(
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
//                                 return AssetImage('assets/icons/graveyard.png');
//                               }
//                             }()),
//                           ),

//                           SizedBox(height: SizeConfig.blockSizeVertical * 2,),

//                           Text(manageDrawer.data.firstName + ' ' + manageDrawer.data.lastName, style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 5, fontWeight: FontWeight.w500, color: Color(0xffffffff),),),

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
//                               Navigator.pushNamed(context, '/home/regular/home-04-01-regular-create-memorial');
//                             },
//                             child: Text('Create Memorial Page', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 5, fontWeight: FontWeight.w200, color: Color(0xffffffff),),),
//                           ),

//                           SizedBox(height: SizeConfig.blockSizeVertical * 3,),

//                           GestureDetector(
//                             onTap: (){
//                               Navigator.pop(context);
//                               Navigator.pushNamed(context, 'home/regular/home-27-regular-notification-settings');
//                             },
//                             child: Text('Notification Settings', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 5, fontWeight: FontWeight.w200, color: Color(0xffffffff),),),
//                           ),

//                           SizedBox(height: SizeConfig.blockSizeVertical * 3,),

//                           GestureDetector(
//                             onTap: (){
//                               Navigator.pop(context);
//                               Navigator.pushNamed(context,'home/regular/home-15-regular-user-details');
//                             },
//                             child: Text('Profile Settings', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 5, fontWeight: FontWeight.w200, color: Color(0xffffffff),),),
//                           ),

//                           SizedBox(height: SizeConfig.blockSizeVertical * 3,),

//                           GestureDetector(
//                             onTap: () async{
//                               context.showLoaderOverlay();
//                               bool result = await apiBLMLogout();
//                               context.hideLoaderOverlay();

//                               if(result){
//                                 Route newRoute = MaterialPageRoute(builder: (BuildContext context) => UIGetStarted());
//                                 Navigator.pushAndRemoveUntil(context, newRoute, (route) => false);
//                               }else{
//                                 await showDialog(context: (context), builder: (build) => MiscBLMAlertDialog(title: 'Error', content: 'Something went wrong. Please try again'));
//                               }
                              
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
