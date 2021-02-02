import 'package:facesbyplaces/UI/Home/BLM/02-View-Memorial/home-view-memorial-blm-02-profile-memorial.dart';
import 'package:facesbyplaces/UI/Home/BLM/11-Show-Post/home-show-post-blm-01-show-original-post.dart';
import 'package:facesbyplaces/UI/Home/Regular/02-View-Memorial/home-view-memorial-regular-02-profile-memorial.dart';
import 'package:facesbyplaces/UI/Home/Regular/10-Settings-Notifications/home-settings-notifications-regular-01-notification-settings.dart';
import 'package:facesbyplaces/API/Regular/14-Notifications/api-notifications-regular-01-show-unread-notifications.dart';
import 'package:facesbyplaces/API/Regular/14-Notifications/api-notifications-regular-02-read-unread-notifications.dart';
import 'package:facesbyplaces/UI/Home/Regular/09-Settings-User/home-settings-user-regular-01-user-details.dart';
import 'package:facesbyplaces/API/Regular/02-Main/api-main-regular-01-logout.dart';
import 'package:facesbyplaces/API/Regular/02-Main/api-main-regular-02-show-user-information.dart';
import 'package:facesbyplaces/API/Regular/02-Main/api-main-regular-03-show-notification-settings.dart';
import 'package:facesbyplaces/UI/Home/Regular/11-Show-Post/home-show-post-regular-01-show-original-post.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-02-regular-dialog.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'home-main-regular-03-01-feed-tab.dart';
import 'home-main-regular-03-02-memorial-list-tab.dart';
import 'home-main-regular-03-03-post-tab.dart';
import 'home-main-regular-03-04-notifications-tab.dart';
import '../../../ui-01-get-started.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart';
import 'dart:async';

class HomeRegularScreenExtended extends StatefulWidget{

  HomeRegularScreenExtendedState createState() => HomeRegularScreenExtendedState();
}

class HomeRegularScreenExtendedState extends State<HomeRegularScreenExtended>{

  int toggleBottom;
  List<bool> bottomTab;
  Future drawerSettings;
  int unreadNotifications;

  String _scanBarcode = 'Error';

  Future<APIRegularShowProfileInformation> getDrawerInformation() async{
    return await apiRegularShowProfileInformation();
  }

  void getUnreadNotifications() async{
    var value = await apiRegularShowUnreadNotifications();

    setState(() {
      unreadNotifications = value;
    });
  }

  Future<void> scanQR() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode("#ff6666", "Cancel", true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });

    print('The _scanBarcode is $_scanBarcode');
    List<dynamic> newValue = _scanBarcode.split('-');

    print('The newValue is $newValue');
    print('The newValue is ${newValue[0]}');
    print('The newValue is ${newValue[1]}');
    print('The newValue is ${newValue[2]}');

    if(_scanBarcode != 'Error'){
      if(newValue[0] == 'Memorial'){
        if(newValue[2] == 'Blm'){
          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMMemorialProfile(memorialId: int.parse(newValue[1]), pageType: newValue[2], newJoin: false,)));
        }else{
          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularMemorialProfile(memorialId: int.parse(newValue[1]), pageType: newValue[2], newJoin: false,)));
        }
      }else{
        print('The newValue[4] in alm is ${newValue[4]}');
        if(newValue[4] == 'Blm'){
          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMShowOriginalPost(postId: int.parse(newValue[1]), likeStatus: int.parse(newValue[2]) == 1 ? true : false, numberOfLikes: int.parse(newValue[3]),)));
        }else{
          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularShowOriginalPost(postId: int.parse(newValue[1]), likeStatus: int.parse(newValue[2]) == 1 ? true : false, numberOfLikes: int.parse(newValue[3]))));
        }
      }
    }else{
      await showDialog(context: (context), builder: (build) => MiscRegularAlertDialog(title: 'Error', content: 'Something went wrong. Please try again'));
    }
  }

  void initState(){
    super.initState();
    unreadNotifications = 0;
    getUnreadNotifications();
    toggleBottom = 0;
    bottomTab = [true, false, false, false];
    drawerSettings = getDrawerInformation();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    ResponsiveWidgets.init(context,
      height: SizeConfig.screenHeight,
      width: SizeConfig.screenWidth,
    );
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
          floatingActionButton: FloatingActionButton(
            backgroundColor: Color(0xffffffff),
            onPressed: () async{
              scanQR();
            },
            child: Icon(Icons.qr_code, color: Color(0xff4EC9D4),),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          bottomSheet: Container(
            height: ScreenUtil().setHeight(65),
            alignment: Alignment.center,
            child: ToggleButtons(
              borderWidth: 0,
              renderBorder: false,
              selectedColor: Color(0xff04ECFF),
              fillColor: Colors.transparent,
              color: Color(0xffB1B1B1),
              children: [

                Container(
                  width: SizeConfig.screenWidth / 4,
                  child: Column(
                    children: [
                      Icon(MdiIcons.fire,),
                      SizedBox(height: SizeConfig.blockSizeVertical * 1),
                      Text('Feed', style: TextStyle(fontSize: ScreenUtil().setSp(12, allowFontScalingSelf: true),),),
                    ],
                  ),
                ),

                Container(
                  width: SizeConfig.screenWidth / 4,
                  child: Column(
                    children: [
                      Icon(MdiIcons.graveStone),
                      SizedBox(height: SizeConfig.blockSizeVertical * 1),
                      Text('Memorials', style: TextStyle(fontSize: ScreenUtil().setSp(12, allowFontScalingSelf: true),),),
                    ],
                  ),
                ),

                Container(
                  width: SizeConfig.screenWidth / 4,
                  child: Column(
                    children: [
                      Icon(MdiIcons.post),
                      SizedBox(height: SizeConfig.blockSizeVertical * 1),
                      Text('Post', style: TextStyle(fontSize: ScreenUtil().setSp(12, allowFontScalingSelf: true),),),
                    ],
                  ),
                ),

                Container(
                  width: SizeConfig.screenWidth / 4,
                  child: Column(
                    children: [
                      Badge(
                        position: BadgePosition.topEnd(top: -3, end: -10),
                        animationDuration: Duration(milliseconds: 300),
                        animationType: BadgeAnimationType.fade,
                        badgeColor: unreadNotifications == 0 ? Color(0xff888888) : Colors.red,
                        badgeContent: Text(
                          '$unreadNotifications',
                          style: TextStyle(color: Colors.white),
                        ),
                        child: Icon(MdiIcons.heart),
                      ),
                      SizedBox(height: SizeConfig.blockSizeVertical * 1),
                      Text('Notification', style: TextStyle(fontSize: ScreenUtil().setSp(12, allowFontScalingSelf: true),),),
                    ],
                  ),
                ),

              ],
              onPressed: (int index) async{
                setState(() {
                  toggleBottom = index;

                  for(int i = 0; i < bottomTab.length; i++){
                    if(i == toggleBottom){
                      bottomTab[i] = true;
                    }else{
                      bottomTab[i] = false;
                    }
                  }

                });

                if(toggleBottom == 3){
                  await apiRegularReadUnreadNotifications();
                  unreadNotifications = 0;
                  getUnreadNotifications();
                }
              },
              isSelected: bottomTab
            ),
            
            decoration: BoxDecoration(
              color: Color(0xffffffff),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  blurRadius: 5,
                  spreadRadius: 1,
                  offset: Offset(0, 0)
                ),
              ],
            ),
          ),
          drawer: FutureBuilder<APIRegularShowProfileInformation>(
            future: drawerSettings,
            builder: (context, manageDrawer){
              if(manageDrawer.hasData){
                if(manageDrawer.data.guest != true){
                  return Drawer(
                    child: ContainerResponsive(
                      height: SizeConfig.screenHeight,
                      width: SizeConfig.screenWidth,
                      alignment: Alignment.center,
                      child: ContainerResponsive(
                        width: SizeConfig.screenWidth,
                        heightResponsive: false,
                        widthResponsive: true,
                        alignment: Alignment.topCenter,
                        color: Color(0xff4EC9D4),
                        child: SingleChildScrollView(
                          physics: ClampingScrollPhysics(),
                          child: Column(
                            children: [
                              SizedBox(height: ScreenUtil().setHeight(20)),

                              CircleAvatar(
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

                              SizedBox(height: ScreenUtil().setHeight(20)),

                              Text(manageDrawer.data.firstName + ' ' + manageDrawer.data.lastName, textAlign: TextAlign.center, style: TextStyle(fontSize: ScreenUtil().setSp(20, allowFontScalingSelf: true), fontWeight: FontWeight.w500, color: Color(0xffffffff),),),

                              SizedBox(height: ScreenUtil().setHeight(45)),

                              GestureDetector(
                                onTap: (){
                                  Navigator.pop(context);
                                },
                                child: Text('Home', style: TextStyle(fontSize: ScreenUtil().setSp(20, allowFontScalingSelf: true), fontWeight: FontWeight.w200, color: Color(0xffffffff),),),
                              ),

                              SizedBox(height: ScreenUtil().setHeight(25)),

                              GestureDetector(
                                onTap: (){
                                  Navigator.pop(context);
                                  Navigator.pushNamed(context, '/home/regular/create-memorial');
                                },
                                child: Text('Create Memorial Page', style: TextStyle(fontSize: ScreenUtil().setSp(20, allowFontScalingSelf: true), fontWeight: FontWeight.w200, color: Color(0xffffffff),),),
                              ),

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

                              SizedBox(height: ScreenUtil().setHeight(20)),

                              GestureDetector(
                                onTap: () async{
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularUserProfileDetails(userId: manageDrawer.data.userId)));
                                },
                                child: Text('Profile Settings', style: TextStyle(fontSize: ScreenUtil().setSp(20, allowFontScalingSelf: true), fontWeight: FontWeight.w200, color: Color(0xffffffff),),),
                              ),

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
                                  
                                },
                                child: Text('Log Out', style: TextStyle(fontSize: ScreenUtil().setSp(20, allowFontScalingSelf: true), fontWeight: FontWeight.w200, color: Color(0xffffffff),),),
                              ),
                              
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }else{
                  return Drawer(
                    child: ContainerResponsive(
                      height: SizeConfig.screenHeight,
                      width: SizeConfig.screenWidth,
                      alignment: Alignment.center,
                      child: ContainerResponsive(
                        width: SizeConfig.screenWidth,
                        heightResponsive: false,
                        widthResponsive: true,
                        alignment: Alignment.topCenter,
                        color: Color(0xff4EC9D4),
                        child: SingleChildScrollView(
                          physics: ClampingScrollPhysics(),
                          child: Column(
                            children: [
                              SizedBox(height: ScreenUtil().setHeight(20)),

                              CircleAvatar(
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

                              SizedBox(height: ScreenUtil().setHeight(20)),

                              Text(manageDrawer.data.firstName + ' ' + manageDrawer.data.lastName, textAlign: TextAlign.center, style: TextStyle(fontSize: ScreenUtil().setSp(20, allowFontScalingSelf: true), fontWeight: FontWeight.w500, color: Color(0xffffffff),),),

                              SizedBox(height: ScreenUtil().setHeight(45)),

                              GestureDetector(
                                onTap: (){
                                  Navigator.pop(context);
                                },
                                child: Text('Home', style: TextStyle(fontSize: ScreenUtil().setSp(20, allowFontScalingSelf: true), fontWeight: FontWeight.w200, color: Color(0xffffffff),),),
                              ),

                              SizedBox(height: ScreenUtil().setHeight(25)),

                              GestureDetector(
                                onTap: (){
                                  Route newRoute = MaterialPageRoute(builder: (BuildContext context) => UIGetStarted());
                                  Navigator.pushAndRemoveUntil(context, newRoute, (route) => false);
                                },
                                child: Text('Sign up or Sign in', style: TextStyle(fontSize: ScreenUtil().setSp(20, allowFontScalingSelf: true), fontWeight: FontWeight.w200, color: Color(0xffffffff),),),
                              ),
                              
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }
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
  }
}
