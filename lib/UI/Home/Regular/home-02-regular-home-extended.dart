// import 'package:facesbyplaces/API/Regular/api-07-01-regular-home-feed-tab.dart';
// import 'package:facesbyplaces/API/Regular/api-07-02-regular-home-memorials-tab.dart';
// import 'package:facesbyplaces/API/Regular/api-07-03-regular-home-post-tab.dart';
// import 'package:facesbyplaces/API/Regular/api-07-04-regular-home-notifications-tab.dart';
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
