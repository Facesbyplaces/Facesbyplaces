import 'package:facesbyplaces/UI/Home/BLM/02-View-Memorial/home-view-memorial-blm-02-profile-memorial.dart';
import 'package:facesbyplaces/UI/Home/BLM/09-Settings-User/home-settings-user-01-user-details.dart';
import 'package:facesbyplaces/UI/Home/BLM/10-Settings-Notifications/home-settings-notifications-blm-01-notification-settings.dart';
import 'package:facesbyplaces/UI/Home/BLM/11-Show-Post/home-show-post-blm-01-show-original-post-comments.dart';
import 'package:facesbyplaces/UI/Home/Regular/02-View-Memorial/home-view-memorial-regular-02-profile-memorial.dart';
import 'package:facesbyplaces/UI/Home/Regular/11-Show-Post/home-show-post-regular-01-show-original-post-comments.dart';
import 'package:facesbyplaces/API/BLM/02-Main/api-main-blm-01-logout.dart';
import 'package:facesbyplaces/API/BLM/02-Main/api-main-blm-02-show-user-information.dart';
import 'package:facesbyplaces/API/BLM/02-Main/api-main-blm-03-show-notifications-settings.dart';
import 'package:facesbyplaces/API/BLM/14-Notifications/api-notifications-blm-01-show-unread-notifications.dart';
import 'package:facesbyplaces/API/BLM/14-Notifications/api-notifications-blm-02-read-unread-notifications.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-07-blm-background.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home-main-blm-03-01-feed-tab.dart';
import 'home-main-blm-03-02-memorial-list-tab.dart';
import 'home-main-blm-03-03-post-tab.dart';
import 'home-main-blm-03-04-notifications-tab.dart';
import '../../../ui-01-get-started.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart';
import 'dart:async';

class HomeBLMScreenExtended extends StatefulWidget{
  final int newToggleBottom;
  HomeBLMScreenExtended({this.newToggleBottom});

  HomeBLMScreenExtendedState createState() => HomeBLMScreenExtendedState(newToggleBottom: newToggleBottom);
}

class HomeBLMScreenExtendedState extends State<HomeBLMScreenExtended>{
  final int newToggleBottom;
  HomeBLMScreenExtendedState({this.newToggleBottom});

  int toggleBottom;
  List<bool> bottomTab;
  Future drawerSettings;
  int unreadNotifications;

  String _scanBarcode = 'Error';

  Future<APIBLMShowProfileInformation> getDrawerInformation() async{
    return await apiBLMShowProfileInformation();
  }

  void getUnreadNotifications() async{
    var value = await apiBLMShowUnreadNotifications();

    setState(() {
      unreadNotifications = value;
    });
  }

  Future<void> scanQR() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode("#ff6666", "Cancel", true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });

    List<dynamic> newValue = _scanBarcode.split('-');

    if(_scanBarcode != 'Error'){
      if(newValue[0] == 'Memorial'){
        if(newValue[2] == 'Blm'){
          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMMemorialProfile(memorialId: int.parse(newValue[1]), pageType: newValue[2], newJoin: false,)));
        }else{
          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularMemorialProfile(memorialId: int.parse(newValue[1]), pageType: newValue[2], newJoin: false,)));
        }
      }else{
        if(newValue[4] == 'Blm'){
          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMShowOriginalPostComments(postId: int.parse(newValue[1]),)));
        }else{
          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularShowOriginalPostComments(postId: int.parse(newValue[1]))));
        }
      }
    }else{
      await showDialog(
        context: context,
        builder: (_) => 
          AssetGiffyDialog(
          image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
          title: Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
          entryAnimation: EntryAnimation.DEFAULT,
          description: Text('Something went wrong. Please try again.',
            textAlign: TextAlign.center,
            style: TextStyle(),
          ),
          onlyOkButton: true,
          buttonOkColor: Colors.red,
          onOkButtonPressed: () {
            Navigator.pop(context, true);
          },
        )
      );
    }
  }

  void initState(){
    super.initState();
    unreadNotifications = 0;
    getUnreadNotifications();
    toggleBottom = newToggleBottom;
    bottomTab = toggleBottom ==  0 ? [true, false, false, false] : [false, true, false, false];
    drawerSettings = getDrawerInformation();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
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
            leading: FutureBuilder<APIBLMShowProfileInformation>(
              future: drawerSettings,
              builder: (context, profileImage){
                if(profileImage.hasData){
                  return Builder(
                    builder: (context){
                      return IconButton(
                        icon: CircleAvatar(
                          backgroundColor: Color(0xff888888),
                          backgroundImage: ((){
                            if(profileImage.data.showProfileInformationImage != null && profileImage.data.showProfileInformationImage != ''){
                              return NetworkImage(profileImage.data.showProfileInformationImage);
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
                  return IconButton(
                    icon: CircleAvatar(
                      backgroundColor: Color(0xff888888),
                      backgroundImage: AssetImage('assets/icons/app-icon.png'),
                    ),
                    onPressed: () async{
                      Scaffold.of(context).openDrawer();
                    }
                  );
                }else{
                  return Container(child: CircularProgressIndicator(), padding: EdgeInsets.all(20.0),);
                }
              },
            ),
            title: Text('FacesByPlaces.com', style: TextStyle(fontSize: 16, color: Color(0xffffffff),),),
            centerTitle: true,
            actions: [
              IconButton(
                icon: Icon(Icons.search, color: Color(0xffffffff), size: 35),
                onPressed: () async{
                  Navigator.pushNamed(context, '/home/blm/search');
                },
              ),
            ],
          ),
          body: Stack(
            children: [

              SingleChildScrollView(physics: NeverScrollableScrollPhysics(), child: Container(height: SizeConfig.screenHeight, child: MiscBLMBackgroundTemplate(image: AssetImage('assets/icons/background2.png'),),),),

              ((){
                switch(toggleBottom){
                  case 0: return HomeBLMFeedTab(); break;
                  case 1: return HomeBLMManageTab(); break;
                  case 2: return HomeBLMPostTab(); break;
                  case 3: return HomeBLMNotificationsTab(); break;
                }
              }()),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Color(0xffffffff),
            onPressed: () async{
              scanQR();
            },
            child: Icon(Icons.qr_code, color: Color(0xff4EC9D4),),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              height: 65,
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
                        SizedBox(height: 5),
                        Text('Feed', style: TextStyle(fontSize: 12,),),
                      ],
                    ),
                  ),

                  Container(
                    width: SizeConfig.screenWidth / 4,
                    child: Column(
                      children: [
                        Icon(MdiIcons.graveStone),
                        SizedBox(height: 5),
                        Text('Memorials', style: TextStyle(fontSize: 12,),),
                      ],
                    ),
                  ),

                  Container(
                    width: SizeConfig.screenWidth / 4,
                    child: Column(
                      children: [
                        Icon(MdiIcons.post),
                        SizedBox(height: 5),
                        Text('Post', style: TextStyle(fontSize: 12,),),
                      ],
                    ),
                  ),

                  Container(
                    width: SizeConfig.screenWidth / 4,
                    child: Column(
                      children: [
                        Badge(
                          position: BadgePosition.topEnd(top: 0, end: -10),
                          animationDuration: Duration(milliseconds: 300),
                          animationType: BadgeAnimationType.fade,
                          badgeColor: unreadNotifications == 0 ? Color(0xff888888) : Colors.red,
                          badgeContent: unreadNotifications >= 10 ? Text('10+', style: TextStyle(color: Colors.white, fontSize: 10),) : Text('$unreadNotifications', style: TextStyle(color: Colors.white, fontSize: 12),),
                          child: Icon(MdiIcons.heart),
                        ),
                        SizedBox(height: 5),
                        Text('Notification', style: TextStyle(fontSize: 12,),),
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
                    await apiBLMReadUnreadNotifications();
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
          ),
          drawer: FutureBuilder<APIBLMShowProfileInformation>(
            future: drawerSettings,
            builder: (context, manageDrawer){
              if(manageDrawer.hasData){
                if(manageDrawer.data.showProfileInformationGuest != true){
                  return Drawer(
                    child: Container(
                      alignment: Alignment.topCenter,
                      color: Color(0xff4EC9D4),
                      child: SingleChildScrollView(
                        physics: ClampingScrollPhysics(),
                        child: Column(
                          children: [
                            SizedBox(height: 20),

                            CircleAvatar(
                              radius: 100,
                              backgroundColor: Color(0xff888888),
                              backgroundImage: ((){
                                if(manageDrawer.data.showProfileInformationImage != null && manageDrawer.data.showProfileInformationImage != ''){
                                  return NetworkImage(manageDrawer.data.showProfileInformationImage);
                                }else{
                                  return AssetImage('assets/icons/app-icon.png');
                                }
                              }()),
                            ),

                            SizedBox(height: 20),

                            Text(manageDrawer.data.showProfileInformationFirstName + ' ' + manageDrawer.data.showProfileInformationLastName, textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Color(0xffffffff),),),

                            SizedBox(height: 45),

                            GestureDetector(
                              onTap: (){
                                Navigator.pop(context);
                              },
                              child: Text('Home', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w200, color: Color(0xffffffff),),),
                            ),

                            SizedBox(height: 25),

                            GestureDetector(
                              onTap: (){
                                Navigator.pop(context);
                                Navigator.pushNamed(context, '/home/blm/create-memorial');
                              },
                              child: Text('Create Memorial Page', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w200, color: Color(0xffffffff),),),
                            ),

                            SizedBox(height: 20),

                            GestureDetector(
                              onTap: () async{
                                context.showLoaderOverlay();
                                APIBLMShowNotificationStatus result = await apiBLMShowNotificationStatus(userId: manageDrawer.data.showProfileInformationUserId);
                                context.hideLoaderOverlay();

                                Navigator.pop(context);
                                Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMNotificationSettings(
                                  newMemorial: result.showNotificationStatusNewMemorial,
                                  newActivities: result.showNotificationStatusNewActivities,
                                  postLikes: result.showNotificationStatusPostLikes,
                                  postComments: result.showNotificationStatusPostComments,
                                  addFamily: result.showNotificationStatusAddFamily,
                                  addFriends: result.showNotificationStatusAddFriends,
                                  addAdmin: result.showNotificationStatusAddAdmin,
                                )));
                              },
                              child: Text('Notification Settings', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w200, color: Color(0xffffffff),),),
                            ),

                            SizedBox(height: 20),

                            GestureDetector(
                              onTap: () async{
                                Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMUserProfileDetails(userId: manageDrawer.data.showProfileInformationUserId)));
                              },
                              child: Text('Profile Settings', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w200, color: Color(0xffffffff),),),
                            ),

                            SizedBox(height: 20),

                            GestureDetector(
                              onTap: () async{

                                context.showLoaderOverlay();
                                bool result = await apiBLMLogout();

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
                                  await showDialog(
                                    context: context,
                                    builder: (_) => 
                                      AssetGiffyDialog(
                                      image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                      title: Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                                      entryAnimation: EntryAnimation.DEFAULT,
                                      description: Text('Something went wrong. Please try again.',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(),
                                      ),
                                      onlyOkButton: true,
                                      buttonOkColor: Colors.red,
                                      onOkButtonPressed: () {
                                        Navigator.pop(context, true);
                                      },
                                    )
                                  );
                                }
                                
                              },
                              child: Text('Log Out', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w200, color: Color(0xffffffff),),),
                            ),
                            
                          ],
                        ),
                      ),
                    ),
                  );
                }else{
                  return Drawer(
                    child: Container(
                      alignment: Alignment.topCenter,
                      color: Color(0xff4EC9D4),
                      child: SingleChildScrollView(
                        physics: ClampingScrollPhysics(),
                        child: Column(
                          children: [
                            SizedBox(height: 20),

                            CircleAvatar(
                              radius: 100,
                              backgroundColor: Color(0xff888888),
                              backgroundImage: ((){
                                if(manageDrawer.data.showProfileInformationImage != null && manageDrawer.data.showProfileInformationImage != ''){
                                  return NetworkImage(manageDrawer.data.showProfileInformationImage);
                                }else{
                                  return AssetImage('assets/icons/app-icon.png');
                                }
                              }()),
                            ),

                            SizedBox(height: 20),

                            Text(manageDrawer.data.showProfileInformationFirstName + ' ' + manageDrawer.data.showProfileInformationLastName, textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Color(0xffffffff),),),

                            SizedBox(height: 45),

                            GestureDetector(
                              onTap: (){
                                Navigator.pop(context);
                              },
                              child: Text('Home', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w200, color: Color(0xffffffff),),),
                            ),

                            SizedBox(height: 25),

                            GestureDetector(
                              onTap: () async{
                                final sharedPrefs = await SharedPreferences.getInstance();

                                sharedPrefs.remove('blm-user-id');
                                sharedPrefs.remove('blm-access-token');
                                sharedPrefs.remove('blm-uid');
                                sharedPrefs.remove('blm-client');
                                sharedPrefs.remove('blm-user-session');

                                sharedPrefs.remove('regular-user-id');
                                sharedPrefs.remove('regular-access-token');
                                sharedPrefs.remove('regular-uid');
                                sharedPrefs.remove('regular-client');
                                sharedPrefs.remove('regular-user-session');

                                sharedPrefs.remove('user-guest-session');

                                Route newRoute = MaterialPageRoute(builder: (BuildContext context) => UIGetStarted());
                                Navigator.pushAndRemoveUntil(context, newRoute, (route) => false);
                              },
                              child: Text('Sign up or Sign in', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w200, color: Color(0xffffffff),),),
                            ),
                            
                          ],
                        ),
                      ),
                    ),
                  );
                }
              }else if(manageDrawer.hasError){
                return Drawer(
                  child: Container(
                    alignment: Alignment.topCenter,
                    color: Color(0xff4EC9D4),
                    child: Column(
                      children: [
                        SizedBox(height: 20,),
                        
                        CircleAvatar(
                          radius: 100,
                          backgroundColor: Color(0xff888888),
                          backgroundImage: AssetImage('assets/icons/app-icon.png'),
                        ),

                        Expanded(child: Container(),),

                        GestureDetector(
                          onTap: (){
                            Navigator.pop(context);
                          },
                          child: Text('Something went wrong. Please try again.', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w200, color: Color(0xffffffff),), textAlign: TextAlign.center,),
                        ),

                        Expanded(child: Container(),),

                        GestureDetector(
                          onTap: (){
                            Route newRoute = MaterialPageRoute(builder: (BuildContext context) => UIGetStarted());
                            Navigator.pushAndRemoveUntil(context, newRoute, (route) => false);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.directions_walk_rounded, color: Color(0xffffffff), size: 16,),

                              SizedBox(width: 20),

                              Text('Go back', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w200, color: Color(0xffffffff),),),
                            ],
                          ),
                        ),

                        Expanded(child: Container(),),
                        
                      ],
                    ),
                  ),
                );
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
