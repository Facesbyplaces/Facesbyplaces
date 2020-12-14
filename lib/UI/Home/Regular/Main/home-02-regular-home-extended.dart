import 'package:facesbyplaces/UI/Home/Regular/Settings-Notifications/home-01-regular-notification-settings.dart';
import 'package:facesbyplaces/UI/Home/Regular/Settings-Memorial/home-14-regular-user-details.dart';
import 'package:facesbyplaces/API/Regular/api-41-regular-show-notification-settings.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-02-regular-bottom-sheet.dart';
import 'package:facesbyplaces/API/Regular/api-22-regular-show-user-information.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-08-regular-dialog.dart';
import 'package:facesbyplaces/API/Regular/api-18-regular-logout.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/Bloc/bloc-04-bloc-regular-home.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'home-03-04-regular-notifications-tab.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Search/home-05-regular-search.dart';
import 'home-03-01-regular-feed-tab.dart';
import 'home-03-02-regular-memorial-list-tab.dart';
import 'home-03-03-regular-post-tab.dart';
import '../../../ui-01-get-started.dart';
import 'package:flutter/material.dart';

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
    return MultiBlocProvider(
      providers: [
        BlocProvider<BlocHomeRegularUpdateCubit>(create: (context) => BlocHomeRegularUpdateCubit(),),
        BlocProvider<BlocHomeRegularUpdateToggle>(create: (context) => BlocHomeRegularUpdateToggle(),),
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
                                return AssetImage('assets/icons/graveyard.png');
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
              title: Text('FacesByPlaces.com', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xffffffff),),),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: Icon(Icons.search, color: Color(0xffffffff), size: SizeConfig.blockSizeVertical * 4,), 
                  onPressed: () async{

                    Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularSearch()));

                  },
                ),
              ],
            ),
            body: BlocBuilder<BlocHomeRegularUpdateCubit, int>(
              builder: (context, toggleBottom){
                return Container(
                  decoration: BoxDecoration(image: DecorationImage(fit: BoxFit.cover, image: AssetImage('assets/icons/background2.png'), colorFilter: ColorFilter.srgbToLinearGamma(),),),
                  child: ((){
                    switch(toggleBottom){
                      case 0: return HomeRegularFeedTab(); break;
                      case 1: return HomeRegularManageTab(); break;
                      case 2: return HomeRegularPostTab(); break;
                      case 3: return HomeRegularNotificationsTab(); break;
                    }
                  }()),
                );
              },
            ),
            bottomSheet: MiscRegularBottomSheet(),
            drawer: FutureBuilder<APIRegularShowProfileInformation>(
              future: drawerSettings,
              builder: (context, manageDrawer){
                if(manageDrawer.hasData){
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
                              if(manageDrawer.data.image != null && manageDrawer.data.image != ''){
                                return NetworkImage(manageDrawer.data.image);
                              }else{
                                return AssetImage('assets/icons/graveyard.png');
                              }
                            }()),
                          ),

                          SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                          Text(manageDrawer.data.firstName + ' ' + manageDrawer.data.lastName, style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 5, fontWeight: FontWeight.w500, color: Color(0xffffffff),),),

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
                              Navigator.pop(context);
                              Navigator.pushNamed(context, '/home/regular/home-04-01-regular-create-memorial');
                            },
                            child: Text('Create Memorial Page', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 5, fontWeight: FontWeight.w200, color: Color(0xffffffff),),),
                          ),

                          SizedBox(height: SizeConfig.blockSizeVertical * 3,),

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
                            child: Text('Notification Settings', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 5, fontWeight: FontWeight.w200, color: Color(0xffffffff),),),
                          ),

                          SizedBox(height: SizeConfig.blockSizeVertical * 3,),

                          GestureDetector(
                            onTap: () async{
                              Navigator.pop(context);
                              Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularUserProfileDetails(userId: manageDrawer.data.userId)));
                            },
                            child: Text('Profile Settings', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 5, fontWeight: FontWeight.w200, color: Color(0xffffffff),),),
                          ),

                          SizedBox(height: SizeConfig.blockSizeVertical * 3,),

                          GestureDetector(
                            onTap: () async{
                              context.showLoaderOverlay();
                              bool result = await apiRegularLogout();
                              context.hideLoaderOverlay();

                              if(result){
                                Route newRoute = MaterialPageRoute(builder: (BuildContext context) => UIGetStarted());
                                Navigator.pushAndRemoveUntil(context, newRoute, (route) => false);
                              }else{
                                await showDialog(context: (context), builder: (build) => MiscRegularAlertDialog(title: 'Error', content: 'Something went wrong. Please try again'));
                              }
                              
                            },
                            child: Text('Log Out', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 5, fontWeight: FontWeight.w200, color: Color(0xffffffff),),),
                          ),
                          
                        ],
                      ),
                    ),
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
      ),
    );
  }
}