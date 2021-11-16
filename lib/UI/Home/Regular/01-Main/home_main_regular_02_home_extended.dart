import 'package:facesbyplaces/UI/Home/Regular/02-View-Memorial/home_view_memorial_regular_02_profile_memorial.dart';
import 'package:facesbyplaces/UI/Home/Regular/09-Settings-User/home_settings_user_regular_01_user_details.dart';
import 'package:facesbyplaces/UI/Home/Regular/10-Settings-Notifications/home_settings_notifications_regular_01_notification_settings.dart';
import 'package:facesbyplaces/UI/Home/Regular/11-Show-Post/home_show_post_regular_01_show_original_post_comments.dart';
import 'package:facesbyplaces/UI/Home/BLM/02-View-Memorial/home_view_memorial_blm_02_profile_memorial.dart';
import 'package:facesbyplaces/UI/Home/BLM/11-Show-Post/home_show_post_blm_01_show_original_post_comments.dart';
import 'package:facesbyplaces/API/Regular/02-Main/api_main_regular_01_logout.dart';
import 'package:facesbyplaces/API/Regular/02-Main/api_main_regular_02_show_user_information.dart';
import 'package:facesbyplaces/API/Regular/02-Main/api_main_regular_03_show_notification_settings.dart';
import 'package:facesbyplaces/API/Regular/14-Notifications/api_notifications_regular_01_show_unread_notifications.dart';
import 'package:facesbyplaces/API/Regular/14-Notifications/api_notifications_regular_02_read_unread_notifications.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_main_regular_03_01_feed_tab.dart';
import 'home_main_regular_03_02_memorial_list_tab.dart';
import 'home_main_regular_03_03_post_tab.dart';
import 'home_main_regular_03_04_notifications_tab.dart';
import 'package:loader_overlay/loader_overlay.dart';
import '../../../ui_01_get_started.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:loader/loader.dart';
import 'package:dialog/dialog.dart';
import 'package:misc/misc.dart';
import 'dart:async';

class HomeRegularScreenExtended extends StatefulWidget{
  final int newToggleBottom;
  const HomeRegularScreenExtended({Key? key, required this.newToggleBottom}) : super(key: key);

  @override
  HomeRegularScreenExtendedState createState() => HomeRegularScreenExtendedState();
}

class HomeRegularScreenExtendedState extends State<HomeRegularScreenExtended>{
  ValueNotifier<List<bool>> bottomTab = ValueNotifier<List<bool>>([true, false, false, false]);
  ValueNotifier<bool> isGuestLoggedIn = ValueNotifier<bool>(true);
  ValueNotifier<int> unreadNotifications = ValueNotifier<int>(0);
  ValueNotifier<int> toggleBottom = ValueNotifier<int>(0);
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  Future<APIRegularShowProfileInformation>? drawerSettings;
  String _scanBarcode = 'Error';

  Future<APIRegularShowProfileInformation> getDrawerInformation() async{
    return await apiRegularShowProfileInformation();
  }

  void getUnreadNotifications() async{ // NUMBER OF NOTIFICATIONS - RED ICON DISPLAYED AT THE TOP OF NOTIFICATION ICON
    var value = await apiRegularShowUnreadNotifications();
    unreadNotifications.value = value;
  }

  void isGuest() async{ // CHECKS IF THE USER IS A GUEST
    final sharedPrefs = await SharedPreferences.getInstance();
    isGuestLoggedIn.value = sharedPrefs.getBool('user-guest-session') ?? false;

    if(isGuestLoggedIn.value != true){
      getUnreadNotifications();
      drawerSettings = getDrawerInformation();
    }
  }

  Future<void> scanQR() async{ // QR SCANNER FUNCTION
    String barcodeScanRes;

    try{
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode("#ff6666", "Cancel", true, ScanMode.QR);
    }on PlatformException{
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState((){
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
          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMShowOriginalPostComments(postId: int.parse(newValue[1]))));
        }else{
          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularShowOriginalPostComments(postId: int.parse(newValue[1]))));
        }
      }
    }else{
      await showDialog(
        context: context,
        builder: (context) => CustomDialog(
          image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
          title: 'Error',
          description: 'Something went wrong. Please try again.',
          okButtonColor: const Color(0xfff44336), // RED
          includeOkButton: true,
        ),
      );
    }
  }

  @override
  void initState(){
    super.initState();
    isGuest();
    toggleBottom.value = widget.newToggleBottom;
    bottomTab.value = toggleBottom.value == 0 ? [true, false, false, false] : [false, true, false, false]; // ICON TOGGLE - DEFAULT IS 0 OR FIRST ICON
    var newMessage = PushNotificationService(_firebaseMessaging, context); // PUSH NOTIFICATION
    newMessage.initialise();
  }

  @override
  Widget build(BuildContext context){
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
        child: ValueListenableBuilder(
          valueListenable: toggleBottom,
          builder: (_, int toggleBottomListener, __) => ValueListenableBuilder(
            valueListenable: bottomTab,
            builder: (_, List<bool> bottomTabListener, __) => ValueListenableBuilder(
              valueListenable: unreadNotifications,
              builder: (_, int unreadNotificationListener, __) => ValueListenableBuilder(
                valueListenable: isGuestLoggedIn,
                builder: (_, bool isGuestLoggedInListener, __) => Scaffold(
                  appBar: AppBar(
                    title: const Text('FacesByPlaces.com', style: TextStyle(fontSize: 26, fontFamily: 'NexaBold', color: Color(0xffffffff),),),
                    backgroundColor: const Color(0xff4EC9D4),
                    centerTitle: true,
                    leading: FutureBuilder<APIRegularShowProfileInformation>(
                      future: drawerSettings,
                      builder: (context, profileImage){
                        if(profileImage.hasData){
                          return Builder(
                            builder: (context){
                              return IconButton(
                                icon: Container(
                                  decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: const Color(0xffffffff), width: 2,),),
                                  child: profileImage.data!.showProfileInformationImage != ''
                                  ? CircleAvatar(
                                    backgroundColor: const Color(0xff888888),
                                    foregroundImage: NetworkImage(profileImage.data!.showProfileInformationImage),
                                  )
                                  : const CircleAvatar(
                                    backgroundColor: Color(0xff888888),
                                    foregroundImage: AssetImage('assets/icons/user-placeholder.png'),
                                  ),
                                ),
                                onPressed: () async{
                                  Scaffold.of(context).openDrawer();
                                },
                              );
                            },
                          );
                        }else if(profileImage.hasError || isGuestLoggedInListener){
                          return IconButton(
                            icon: const CircleAvatar(
                              backgroundColor: Color(0xff888888),
                              foregroundImage: AssetImage('assets/icons/user-placeholder.png'),
                            ),
                            onPressed: () async{
                              Scaffold.of(context).openDrawer();
                            },
                          );
                        }else{
                          return const Padding(child: CircularProgressIndicator(), padding: EdgeInsets.all(20.0),);
                        }
                      },
                    ),
                    actions: [
                      IconButton(
                        onPressed: (){
                          Navigator.pushNamed(context, '/home/regular/search');
                        },
                        icon: Image.asset('assets/icons/zoom.png',),
                      ),
                    ],
                  ),
                  body: Stack(
                    children: [
                      SingleChildScrollView(
                        physics: const NeverScrollableScrollPhysics(),
                        child: SizedBox(height: SizeConfig.screenHeight, child: const MiscBackgroundTemplate(image: AssetImage('assets/icons/background2.png'),),),
                      ),

                      SizedBox(
                        child: ((){
                          switch (toggleBottomListener){
                            case 0: return const HomeRegularFeedTab(key: Key('1'));
                            case 1: return const HomeRegularManageTab(key: Key('2'));
                            case 2: return const HomeRegularPostTab(key: Key('3'));
                            case 3: return const HomeRegularNotificationsTab(key: Key('4'));
                          }
                        }()),
                      ),
                    ],
                  ),
                  floatingActionButton: FloatingActionButton(
                    child: const Icon(Icons.qr_code, color: Color(0xff4EC9D4),),
                    backgroundColor: const Color(0xffffffff),
                    onPressed: () async{
                      scanQR();
                    },
                  ),
                  floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
                  bottomNavigationBar: SafeArea(
                    child: SingleChildScrollView( // TOGGLE ICONS
                      scrollDirection: Axis.horizontal,
                      child: Container(
                        alignment: Alignment.center,
                        height: 65,
                        decoration: BoxDecoration(
                          color: const Color(0xffffffff),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: const Color(0xff888888).withOpacity(0.5),
                              blurRadius: 5,
                              spreadRadius: 1,
                              offset: const Offset(0, 0),
                            ),
                          ],
                        ),
                        child: ToggleButtons(
                          selectedColor: const Color(0xff04ECFF),
                          color: const Color(0xffB1B1B1),
                          isSelected: bottomTabListener,
                          fillColor: Colors.transparent,
                          renderBorder: false,
                          borderWidth: 0,
                          children: [
                            SizedBox(
                              width: SizeConfig.screenWidth! / 4,
                              child: Column(
                                children: const [
                                  Icon(MdiIcons.fire,),

                                  SizedBox(height: 5),

                                  Text('Feed', style: TextStyle(fontSize: 18, fontFamily: 'NexaLight'),),
                                ],
                              ),
                            ),

                            SizedBox(
                              width: SizeConfig.screenWidth! / 4,
                              child: Column(
                                children: const [
                                  Icon(MdiIcons.graveStone),

                                  SizedBox(height: 5),

                                  Text('Memorials', style: TextStyle(fontSize: 18, fontFamily: 'NexaLight'),),
                                ],
                              ),
                            ),

                            SizedBox(
                              width: SizeConfig.screenWidth! / 4,
                              child: Column(
                                children: const [
                                  Icon(MdiIcons.post),

                                  SizedBox(height: 5),

                                  Text('Post', style: TextStyle(fontSize: 18, fontFamily: 'NexaLight',),),
                                ],
                              ),
                            ),

                            SizedBox(
                              width: SizeConfig.screenWidth! / 4,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Column(
                                    children: const <Widget>[
                                      Icon(MdiIcons.heart),

                                      SizedBox(height: 5),

                                      Text('Notification', style: TextStyle(fontSize: 18, fontFamily: 'NexaLight',),),
                                    ],
                                  ),

                                  Positioned(
                                    top: 0,
                                    right: 20,
                                    child: isGuestLoggedInListener || unreadNotificationListener == 0
                                    ? const SizedBox(height: 0,)
                                    : CircleAvatar(
                                      radius: 12,
                                      backgroundColor: const Color(0xffff0000),
                                      child: Text(unreadNotificationListener > 99 ? '99+' : '$unreadNotificationListener', style: const TextStyle(color: Color(0xffffffff), fontSize: 12),),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          onPressed: (int index) async{
                            toggleBottom.value = index;

                            for(int i = 0; i < bottomTabListener.length; i++){
                              if(i == toggleBottom.value){
                                bottomTabListener[i] = true;
                              }else{
                                bottomTabListener[i] = false;
                              }
                            }

                            if(toggleBottom.value == 3){
                              if(isGuestLoggedInListener != true){
                                await apiRegularReadUnreadNotifications();
                                unreadNotifications.value = 0;
                                getUnreadNotifications();
                              }
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  drawer: isGuestLoggedInListener != true
                  ? FutureBuilder<APIRegularShowProfileInformation>( // DRAWER
                    future: drawerSettings,
                    builder: (context, manageDrawer){
                      if(manageDrawer.hasData){
                        return Drawer(
                          child: Container(
                            alignment: Alignment.topCenter,
                            color: const Color(0xff4EC9D4),
                            child: SingleChildScrollView(
                              physics: const ClampingScrollPhysics(),
                              child: Column(
                                children: [
                                  const SizedBox(height: 50),

                                  GestureDetector(
                                    child: manageDrawer.data!.showProfileInformationImage != ''
                                    ? Container(
                                      child: CircleAvatar(radius: 100, backgroundColor: const Color(0xff888888), foregroundImage: NetworkImage(manageDrawer.data!.showProfileInformationImage),),
                                      decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: const Color(0xffffffff), width: 3,),),
                                    )
                                    : const CircleAvatar(
                                      radius: 100,
                                      backgroundColor: Color(0xff888888),
                                      foregroundImage: AssetImage('assets/icons/user-placeholder.png'),
                                    ),
                                    onTap: (){
                                      showGeneralDialog(
                                        context: context,
                                        transitionDuration: const Duration(milliseconds: 0),
                                        barrierDismissible: true,
                                        barrierLabel: 'Dialog',
                                        pageBuilder: (_, __, ___){
                                          return Scaffold(
                                            backgroundColor: Colors.black12.withOpacity(0.7),
                                            body: SizedBox.expand(
                                              child: SafeArea(
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      alignment: Alignment.centerRight,
                                                      padding: const EdgeInsets.only(right: 20.0),
                                                      child: GestureDetector(
                                                        child: CircleAvatar(radius: 20, backgroundColor: const Color(0xff000000).withOpacity(0.8), child: const Icon(Icons.close_rounded, color: Color(0xffffffff),),),
                                                        onTap: (){
                                                          Navigator.pop(context);
                                                        },
                                                      ),
                                                    ),

                                                    const SizedBox(height: 20,),

                                                    Expanded(
                                                      child: CachedNetworkImage(
                                                        fit: BoxFit.cover,
                                                        imageUrl: manageDrawer.data!.showProfileInformationImage,
                                                        placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                        errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                      ),
                                                    ),

                                                    const SizedBox(height: 80,),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  ),

                                  const SizedBox(height: 20),

                                  Text(
                                    manageDrawer.data!.showProfileInformationFirstName + ' ' + manageDrawer.data!.showProfileInformationLastName,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 28, fontFamily: 'NexaBold', color: Color(0xffffffff),),
                                  ),

                                  const SizedBox(height: 45),

                                  GestureDetector(
                                    child: const Text('Home', textAlign: TextAlign.center, style: TextStyle(fontSize: 26, fontFamily: 'NexaLight', color: Color(0xffffffff),),),
                                    onTap: (){
                                      Navigator.pop(context);
                                    },
                                  ),

                                  const SizedBox(height: 25),

                                  GestureDetector(
                                    child: const Text('Create Memorial Page', textAlign: TextAlign.center, style: TextStyle(fontSize: 26, fontFamily: 'NexaLight', color: Color(0xffffffff),),),
                                    onTap: (){
                                      Navigator.pop(context);
                                      Navigator.pushNamed(context, '/home/regular/create-memorial');
                                    },
                                  ),

                                  const SizedBox(height: 20),

                                  GestureDetector(
                                    child: const Text('Notification Settings', textAlign: TextAlign.center, style: TextStyle(fontSize: 26, fontFamily: 'NexaLight', color: Color(0xffffffff),),),
                                    onTap: () async{
                                      context.loaderOverlay.show();
                                      APIRegularShowNotificationStatus result = await apiRegularShowNotificationStatus(userId: manageDrawer.data!.showProfileInformationUserId);
                                      context.loaderOverlay.hide();

                                      Navigator.pop(context);
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularNotificationSettings(newMemorial: result.showNotificationStatusNewMemorial, newActivities: result.showNotificationStatusNewActivities, postLikes: result.showNotificationStatusPostLikes, postComments: result.showNotificationStatusPostComments, addFamily: result.showNotificationStatusAddFamily, addFriends: result.showNotificationStatusAddFriends, addAdmin: result.showNotificationStatusAddAdmin,),),);
                                    },
                                  ),

                                  const SizedBox(height: 20),

                                  GestureDetector(
                                    child: const Text('Profile Settings', textAlign: TextAlign.center, style: TextStyle(fontSize: 26, fontFamily: 'NexaLight', color: Color(0xffffffff),),),
                                    onTap: () async{
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularUserProfileDetails(userId: manageDrawer.data!.showProfileInformationUserId)));
                                    },
                                  ),

                                  const SizedBox(height: 20),

                                  GestureDetector(
                                    child: const Text('Log Out', textAlign: TextAlign.center, style: TextStyle(fontSize: 26, fontFamily: 'NexaLight', color: Color(0xffffffff),),),
                                    onTap: () async{
                                      bool confirmResult = await showDialog(context: (context), builder: (build) => const MiscConfirmDialog(title: 'Log Out', content: 'Are you sure you want to logout from this account?', confirmColor_1: Color(0xff000000), confirmColor_2: Color(0xff888888),));

                                      if(confirmResult){
                                        context.loaderOverlay.show();
                                        bool result = await apiRegularLogout();
                                        context.loaderOverlay.hide();

                                        if(result){
                                          Route newRoute = MaterialPageRoute(builder: (BuildContext context) => const UIGetStarted());
                                          Navigator.pushAndRemoveUntil(context, newRoute, (route) => false);
                                        }else{
                                          await showDialog(
                                            context: context,
                                            builder: (context) => CustomDialog(
                                              image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                              title: 'Error',
                                              description: 'Something went wrong. Please try again.',
                                              okButtonColor: const Color(0xfff44336), // RED
                                              includeOkButton: true,
                                            ),
                                          );
                                        }
                                      }
                                    },
                                  ),

                                  const SizedBox(height: 50),
                                ],
                              ),
                            ),
                          ),
                        );
                      }else if(manageDrawer.hasError){
                        return Drawer(
                          child: Container(
                            alignment: Alignment.topCenter,
                            color: const Color(0xff4EC9D4),
                            child: Column(
                              children: [
                                const SizedBox(height: 20,),

                                const CircleAvatar(
                                  radius: 100,
                                  backgroundColor: Color(0xff888888),
                                  foregroundImage: AssetImage('assets/icons/user-placeholder.png'),
                                ),

                                const Expanded(child: SizedBox(),),

                                GestureDetector(
                                  child: const Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: TextStyle(fontSize: 26, fontFamily: 'NexaRegular', color: Color(0xffFFFFFF),),),
                                  onTap: (){
                                    Navigator.pop(context);
                                  },
                                ),

                                const Expanded(child: SizedBox(),),

                                GestureDetector(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(Icons.directions_walk_rounded, color: Color(0xffffffff), size: 16,),

                                      SizedBox(width: 20),

                                      Text('Go back', textAlign: TextAlign.center, style: TextStyle(fontSize: 26, fontFamily: 'NexaRegular', color: Color(0xffFFFFFF),),),
                                    ],
                                  ),
                                  onTap: (){
                                    Route newRoute = MaterialPageRoute(builder: (BuildContext context) => const UIGetStarted());
                                    Navigator.pushAndRemoveUntil(context, newRoute, (route) => false);
                                  },
                                ),

                                const Expanded(child: SizedBox(),),
                              ],
                            ),
                          ),
                        );
                      }else{
                        return const Center(child: CustomLoader(),);
                      }
                    },
                  )
                  : Drawer( // DRAWER FOR GUEST LOGIN
                    child: Container(
                      alignment: Alignment.topCenter,
                      color: const Color(0xff4EC9D4),
                      child: SingleChildScrollView(
                        physics: const ClampingScrollPhysics(),
                        child: Column(
                          children: [
                            const SizedBox(height: 20,),

                            const CircleAvatar(
                              radius: 100,
                              backgroundColor: Color(0xff888888),
                              foregroundImage: AssetImage('assets/icons/user-placeholder.png'),
                            ),

                            const SizedBox(height: 20,),

                            const Text('Guest User', textAlign: TextAlign.center, style: TextStyle(fontSize: 28, fontFamily: 'NexaBold', color: Color(0xffffffff),),),

                            const SizedBox(height: 45,),

                            GestureDetector(
                              child: const Text('Home', textAlign: TextAlign.center, style: TextStyle(fontSize: 26, fontFamily: 'NexaLight', color: Color(0xffffffff),),),
                              onTap: (){
                                Navigator.pop(context);
                              },
                            ),

                            const SizedBox(height: 25,),

                            GestureDetector(
                              child: const Text('Sign up or Sign in', textAlign: TextAlign.center, style: TextStyle(fontSize: 26, fontFamily: 'NexaLight', color: Color(0xffffffff),),),
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

                                Route newRoute = MaterialPageRoute(builder: (BuildContext context) => const UIGetStarted());
                                Navigator.pushAndRemoveUntil(context, newRoute, (route) => false);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}