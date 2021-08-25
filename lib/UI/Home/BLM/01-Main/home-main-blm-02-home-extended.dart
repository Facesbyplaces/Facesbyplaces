import 'package:facesbyplaces/UI/Home/BLM/02-View-Memorial/home-view-memorial-blm-02-profile-memorial.dart';
import 'package:facesbyplaces/UI/Home/BLM/09-Settings-User/home-settings-user-blm-01-user-details.dart';
import 'package:facesbyplaces/UI/Home/BLM/10-Settings-Notifications/home-settings-notifications-blm-01-notification-settings.dart';
import 'package:facesbyplaces/UI/Home/BLM/11-Show-Post/home-show-post-blm-01-show-original-post-comments.dart';
import 'package:facesbyplaces/UI/Home/Regular/02-View-Memorial/home-view-memorial-regular-02-profile-memorial.dart';
import 'package:facesbyplaces/UI/Home/Regular/11-Show-Post/home-show-post-regular-01-show-original-post-comments.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-02-blm-dialog.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-07-blm-background.dart';
import 'package:facesbyplaces/API/BLM/02-Main/api-main-blm-01-logout.dart';
import 'package:facesbyplaces/API/BLM/02-Main/api-main-blm-02-show-user-information.dart';
import 'package:facesbyplaces/API/BLM/02-Main/api-main-blm-03-show-notifications-settings.dart';
import 'package:facesbyplaces/API/BLM/14-Notifications/api-notifications-blm-01-show-unread-notifications.dart';
import 'package:facesbyplaces/API/BLM/14-Notifications/api-notifications-blm-02-read-unread-notifications.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'home-main-blm-03-01-feed-tab.dart';
import 'home-main-blm-03-02-memorial-list-tab.dart';
import 'home-main-blm-03-03-post-tab.dart';
import 'home-main-blm-03-04-notifications-tab.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:giffy_dialog/giffy_dialog.dart';
import '../../../ui-01-get-started.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class HomeBLMScreenExtended extends StatefulWidget{
  final int newToggleBottom;
  const HomeBLMScreenExtended({required this.newToggleBottom});

  HomeBLMScreenExtendedState createState() => HomeBLMScreenExtendedState();
}

class HomeBLMScreenExtendedState extends State<HomeBLMScreenExtended>{
  ValueNotifier<List<bool>> bottomTab = ValueNotifier<List<bool>>([true, false, false, false]);
  ValueNotifier<bool> isGuestLoggedIn = ValueNotifier<bool>(true);
  ValueNotifier<int> unreadNotifications = ValueNotifier<int>(0);
  ValueNotifier<int> toggleBottom = ValueNotifier<int>(0);
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  Future<APIBLMShowProfileInformation>? drawerSettings;
  String _scanBarcode = 'Error';

  Future<APIBLMShowProfileInformation> getDrawerInformation() async{
    return await apiBLMShowProfileInformation();
  }

  void getUnreadNotifications() async{
    var value = await apiBLMShowUnreadNotifications();
    unreadNotifications.value = value;
  }

  void isGuest() async{
    final sharedPrefs = await SharedPreferences.getInstance();
    isGuestLoggedIn.value = sharedPrefs.getBool('user-guest-session') ?? false;

    if(isGuestLoggedIn.value != true){
      getUnreadNotifications();
      drawerSettings = getDrawerInformation();
    }
  }

  Future<void> scanQR() async{
    String barcodeScanRes;
    try{
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode("#ff6666", "Cancel", true, ScanMode.QR);
      print(barcodeScanRes);
    }on PlatformException{
      barcodeScanRes = 'Failed to get platform version.';
    }

    if(!mounted)
    return;

    setState((){
      _scanBarcode = barcodeScanRes;
    });

    List<dynamic> newValue = _scanBarcode.split('-');

    if(_scanBarcode != 'Error'){
      if(newValue[0] == 'Memorial'){
        if(newValue[2] == 'Blm'){
          Navigator.push(context,MaterialPageRoute(builder: (context) => HomeBLMMemorialProfile(memorialId: int.parse(newValue[1]), pageType: newValue[2], newJoin: false,)));
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
        builder: (_) => AssetGiffyDialog(
          title: Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 3.16, fontFamily: 'NexaRegular',),),
          description: Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.87, fontFamily: 'NexaRegular',),),
          image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
          entryAnimation: EntryAnimation.DEFAULT,
          buttonOkColor: const Color(0xffff0000),
          onlyOkButton: true,
          onOkButtonPressed: (){
            Navigator.pop(context, true);
          },
        ),
      );
    }
  }

  void initState(){
    super.initState();
    isGuest();
    toggleBottom.value = widget.newToggleBottom;
    bottomTab.value = toggleBottom.value == 0 ? [true, false, false, false] : [false, true, false, false];
    var newMessage = PushNotificationService(_firebaseMessaging, context);
    newMessage.initialise();
  }

  @override
  Widget build(BuildContext context){
    SizeConfig.init(context);
    print('Home blm extended rebuild!');
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
                    backgroundColor: const Color(0xff4EC9D4),
                    leading: FutureBuilder<APIBLMShowProfileInformation>(
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
                                    backgroundColor: const Color(0xff888888),
                                    foregroundImage: const AssetImage('assets/icons/user-placeholder.png'),
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
                            icon: const CircleAvatar(backgroundColor: const Color(0xff888888), foregroundImage: const AssetImage('assets/icons/user-placeholder.png'),),
                            onPressed: () async{
                              Scaffold.of(context).openDrawer();
                            },
                          );
                        }else{
                          return Container(child: const CircularProgressIndicator(), padding: const EdgeInsets.all(20.0),);
                        }
                      },
                    ),
                    title: Text('FacesByPlaces.com', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.74, fontFamily: 'NexaBold', color: const Color(0xffffffff),),),
                    centerTitle: true,
                    actions: [
                      GestureDetector(
                        child: Container(
                          padding: EdgeInsets.only(right: SizeConfig.blockSizeHorizontal! * 5),
                          width: SizeConfig.blockSizeHorizontal! * 12.18,
                          height: SizeConfig.blockSizeVertical! * 4.04,
                          child: Image.asset('assets/icons/zoom.png',),
                        ),
                        onTap: (){
                          Navigator.pushNamed(context, '/home/blm/search');
                        },
                      ),
                    ],
                  ),
                  body: Stack(
                    children: [
                      SingleChildScrollView(
                        physics: const NeverScrollableScrollPhysics(),
                        child: Container(height: SizeConfig.screenHeight, child: const MiscBLMBackgroundTemplate(image: const AssetImage('assets/icons/background2.png'),),),
                      ),

                      Container(
                        child: ((){
                          switch (toggleBottomListener){
                            case 0: return const HomeBLMFeedTab();
                            case 1: return const HomeBLMManageTab();
                            case 2: return const HomeBLMPostTab();
                            case 3: return const HomeBLMNotificationsTab();
                          }
                        }()),
                      ),
                    ],
                  ),
                  floatingActionButton: FloatingActionButton(
                    backgroundColor: const Color(0xffffffff),
                    child: const Icon(Icons.qr_code, color: const Color(0xff4EC9D4),),
                    onPressed: () async{
                      scanQR();
                    },
                  ),
                  floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
                  bottomNavigationBar: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      height: 65,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xffffffff),
                        boxShadow: <BoxShadow>[
                          BoxShadow(color: const Color(0xff888888).withOpacity(0.5), blurRadius: 5, spreadRadius: 1, offset: const Offset(0, 0)),
                        ],
                      ),
                      child: ToggleButtons(
                        selectedColor: const Color(0xff04ECFF),
                        color: const Color(0xffB1B1B1),
                        fillColor: Colors.transparent,
                        isSelected: bottomTabListener,
                        renderBorder: false,
                        borderWidth: 0,
                        children: [
                          Container(
                            width: SizeConfig.screenWidth! / 4,
                            child: Column(
                              children: [
                                const Icon(MdiIcons.fire,),
                                const SizedBox(height: 5),
                                Text('Feed', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 1.76, fontFamily: 'NexaLight'),),
                              ],
                            ),
                          ),
                          Container(
                            width: SizeConfig.screenWidth! / 4,
                            child: Column(
                              children: [
                                const Icon(MdiIcons.graveStone),
                                const SizedBox(height: 5),
                                Text('Memorials', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 1.76, fontFamily: 'NexaLight'),),
                              ],
                            ),
                          ),
                          Container(
                            width: SizeConfig.screenWidth! / 4,
                            child: Column(
                              children: [
                                const Icon(MdiIcons.post),
                                const SizedBox(height: 5),
                                Text('Post', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 1.76, fontFamily: 'NexaLight'),),
                              ],
                            ),
                          ),
                          Container(
                            width: SizeConfig.screenWidth! / 4,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Column(
                                  children: <Widget>[
                                    const Icon(MdiIcons.heart),
                                    const SizedBox(height: 5),
                                    Text('Notification', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 1.76, fontFamily: 'NexaLight'),),
                                  ],
                                ),
                                Positioned(
                                  top: 0,
                                  right: 20,
                                  child: CircleAvatar(
                                    radius: 12,
                                    backgroundColor: const Color(0xffff0000),
                                    child: isGuestLoggedInListener == true
                                    ? const Text('0', style: const TextStyle(color: const Color(0xffffffff), fontSize: 12),)
                                    : Text(unreadNotificationListener > 99 ? '99+' : '$unreadNotificationListener', style: const TextStyle(color: const Color(0xffffffff), fontSize: 12),),
                                  ),
                                )
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
                              await apiBLMReadUnreadNotifications();
                              unreadNotifications.value = 0;
                              getUnreadNotifications();
                            }
                          }
                        },
                      ),
                    ),
                  ),
                  drawer: isGuestLoggedInListener != true
                  ? FutureBuilder<APIBLMShowProfileInformation>(
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
                                  const SizedBox(height: 20),
                                  GestureDetector(
                                    child: manageDrawer.data!.showProfileInformationImage != ''
                                    ? Container(
                                      decoration: BoxDecoration(shape: BoxShape.circle,border: Border.all(color: const Color(0xffffffff), width: 3,),),
                                      child: CircleAvatar(
                                        radius: 100,
                                        backgroundColor: const Color(0xff888888),
                                        foregroundImage: NetworkImage(manageDrawer.data!.showProfileInformationImage),
                                      ),
                                    )
                                    : const CircleAvatar(
                                      radius: 100,
                                      backgroundColor: const Color(0xff888888),
                                      foregroundImage: const AssetImage('assets/icons/user-placeholder.png'),
                                    ),
                                    onTap: (){
                                      showGeneralDialog(
                                        context: context,
                                        barrierLabel: 'Dialog',
                                        barrierDismissible: true,
                                        transitionDuration: const Duration(milliseconds: 0),
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
                                                        child: CircleAvatar(
                                                          radius: 20,
                                                          backgroundColor: const Color(0xff000000).withOpacity(0.8),
                                                          child: const Icon(Icons.close_rounded, color: const Color(0xffffffff),),
                                                        ),
                                                        onTap: (){
                                                          Navigator.pop(context);
                                                        },
                                                      ),
                                                    ),

                                                    const SizedBox(height: 20,),

                                                    Expanded(
                                                      child: CachedNetworkImage(
                                                        errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                        placeholder: (context, url) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                        imageUrl: manageDrawer.data!.showProfileInformationImage,
                                                        fit: BoxFit.cover,
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
                                    style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.74, fontFamily: 'NexaBold', color: const Color(0xffffffff),),
                                  ),

                                  const SizedBox(height: 45),

                                  GestureDetector(
                                    child: Text('Home', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.74, fontFamily: 'NexaLight', color: const Color(0xffffffff),),),
                                    onTap: (){
                                      Navigator.pop(context);
                                    },
                                  ),

                                  const SizedBox(height: 25),

                                  GestureDetector(
                                    child: Text('Create Memorial Page', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.74, fontFamily: 'NexaLight', color: const Color(0xffffffff),),),
                                    onTap: (){
                                      Navigator.pop(context);
                                      Navigator.pushNamed(context, '/home/blm/create-memorial');
                                    },
                                  ),

                                  const SizedBox(height: 20),

                                  GestureDetector(
                                    child: Text('Notification Settings', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.74, fontFamily: 'NexaLight', color: const Color(0xffffffff),),),
                                    onTap: () async{
                                      context.loaderOverlay.show();
                                      APIBLMShowNotificationStatus result = await apiBLMShowNotificationStatus(userId: manageDrawer.data!.showProfileInformationUserId);
                                      context.loaderOverlay.hide();

                                      Navigator.pop(context);
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMNotificationSettings(newMemorial: result.showNotificationStatusNewMemorial, newActivities: result.showNotificationStatusNewActivities, postLikes: result.showNotificationStatusPostLikes, postComments: result.showNotificationStatusPostComments, addFamily: result.showNotificationStatusAddFamily, addFriends: result.showNotificationStatusAddFriends, addAdmin: result.showNotificationStatusAddAdmin,)));
                                    },
                                  ),

                                  const SizedBox(height: 20),

                                  GestureDetector(
                                    child: Text('Profile Settings', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.74, fontFamily: 'NexaLight', color: const Color(0xffffffff),),),
                                    onTap: () async{
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMUserProfileDetails(userId: manageDrawer.data!.showProfileInformationUserId)));
                                    },
                                  ),

                                  const SizedBox(height: 20),

                                  GestureDetector(
                                    child: Text('Log Out', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.74, fontFamily: 'NexaLight', color: const Color(0xffffffff),),),
                                    onTap: () async{
                                      bool confirmResult = await showDialog(context: (context), builder: (build) => const MiscBLMConfirmDialog(title: 'Log Out', content: 'Are you sure you want to logout from this account?', confirmColor_1: const Color(0xff000000), confirmColor_2: const Color(0xff888888),));

                                      if(confirmResult){
                                        context.loaderOverlay.show();
                                        bool result = await apiBLMLogout();
                                        context.loaderOverlay.hide();

                                        if(result){
                                          Route newRoute = MaterialPageRoute(builder: (BuildContext context) => const UIGetStarted());
                                          Navigator.pushAndRemoveUntil(context, newRoute, (route) => false);
                                        }else{
                                          await showDialog(
                                            context: context,
                                            builder: (_) => AssetGiffyDialog(
                                              description: Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.87, fontFamily: 'NexaRegular',),),
                                              title: Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 3.16, fontFamily: 'NexaRegular'),),
                                              image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                              entryAnimation: EntryAnimation.DEFAULT,
                                              buttonOkColor: const Color(0xffff0000),
                                              onlyOkButton: true,
                                              onOkButtonPressed: (){
                                                Navigator.pop(context, true);
                                              },
                                            ),
                                          );
                                        }
                                      }
                                    },
                                  ),
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

                                const CircleAvatar(radius: 100, backgroundColor: const Color(0xff888888), foregroundImage: const AssetImage('assets/icons/user-placeholder.png'),),

                                Expanded(child: Container(),),

                                GestureDetector(
                                  child: Text('Something went wrong. Please try again.', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.74, fontFamily: 'NexaLight', color: const Color(0xffffffff),), textAlign: TextAlign.center,),
                                  onTap: (){
                                    Navigator.pop(context);
                                  },
                                ),

                                Expanded(child: Container(),),

                                GestureDetector(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.directions_walk_rounded, color: const Color(0xffffffff), size: 16,),
                                      
                                      const SizedBox(width: 20),

                                      Text('Go back', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.74, fontFamily: 'NexaLight', color: const Color(0xffffffff),),),
                                    ],
                                  ),
                                  onTap: (){
                                    Route newRoute = MaterialPageRoute(builder: (BuildContext context) => const UIGetStarted());
                                    Navigator.pushAndRemoveUntil(context, newRoute, (route) => false);
                                  },
                                ),

                                Expanded(child: Container(),),
                              ],
                            ),
                          ),
                        );
                      }else{
                        return Container(child: Center(child: Container(child: const SpinKitThreeBounce(color: const Color(0xff000000), size: 50.0,), color: const Color(0xffffffff),),),);
                      }
                    }
                  )
                  : Drawer(
                    child: Container(
                      alignment: Alignment.topCenter,
                      color: const Color(0xff4EC9D4),
                      child: SingleChildScrollView(
                        physics: const ClampingScrollPhysics(),
                        child: Column(
                          children: [
                            const SizedBox(height: 20),

                            const CircleAvatar(radius: 100, backgroundColor: const Color(0xff888888),foregroundImage: const AssetImage('assets/icons/user-placeholder.png'),),

                            const SizedBox(height: 20),

                            Text('Guest User', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.74, fontFamily: 'NexaBold', color: const Color(0xffffffff),),),

                            const SizedBox(height: 45),

                            GestureDetector(
                              child: Text('Home', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.74, fontFamily: 'NexaLight', color: const Color(0xffffffff),),),
                              onTap: (){
                                Navigator.pop(context);
                              },
                            ),
                            
                            const SizedBox(height: 25),

                            GestureDetector(
                              child: Text('Sign up or Sign in', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.74, fontFamily: 'NexaLight', color: const Color(0xffffffff),),),
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