import 'package:facesbyplaces/UI/Home/BLM/02-View-Memorial/home-view-memorial-blm-02-profile-memorial.dart';
import 'package:facesbyplaces/UI/Home/BLM/09-Settings-User/home-settings-user-blm-01-user-details.dart';
import 'package:facesbyplaces/UI/Home/BLM/10-Settings-Notifications/home-settings-notifications-blm-01-notification-settings.dart';
import 'package:facesbyplaces/UI/Home/BLM/11-Show-Post/home-show-post-blm-01-show-original-post-comments.dart';
import 'package:facesbyplaces/UI/Home/Regular/02-View-Memorial/home-view-memorial-regular-02-profile-memorial.dart';
import 'package:facesbyplaces/UI/Home/Regular/11-Show-Post/home-show-post-regular-01-show-original-post-comments.dart';
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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'home-main-blm-03-01-feed-tab.dart';
import 'home-main-blm-03-02-memorial-list-tab.dart';
import 'home-main-blm-03-03-post-tab.dart';
import 'home-main-blm-03-04-notifications-tab.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import '../../../ui-01-get-started.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class HomeBLMScreenExtended extends StatefulWidget{
  final int newToggleBottom;
  HomeBLMScreenExtended({required this.newToggleBottom});

  HomeBLMScreenExtendedState createState() => HomeBLMScreenExtendedState(newToggleBottom: newToggleBottom);
}

class HomeBLMScreenExtendedState extends State<HomeBLMScreenExtended>{
  final int newToggleBottom;
  HomeBLMScreenExtendedState({required this.newToggleBottom});

  ValueNotifier<int> unreadNotifications = ValueNotifier<int>(0);
  ValueNotifier<int> toggleBottom = ValueNotifier<int>(0);
  ValueNotifier<List<bool>> bottomTab = ValueNotifier<List<bool>>([true, false, false, false]);
  ValueNotifier<bool> isGuestLoggedIn = ValueNotifier<bool>(true);

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
          title: const Text('Error', textAlign: TextAlign.center, style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
          entryAnimation: EntryAnimation.DEFAULT,
          description: const Text('Something went wrong. Please try again.',
            textAlign: TextAlign.center,
          ),
          onlyOkButton: true,
          buttonOkColor: const Color(0xffff0000),
          onOkButtonPressed: () {
            Navigator.pop(context, true);
          },
        )
      );
    }
  }

  void initState(){
    super.initState();
    isGuest();
    toggleBottom.value = newToggleBottom;
    bottomTab.value = toggleBottom.value ==  0 ? [true, false, false, false] : [false, true, false, false];
  }

  @override
  Widget build(BuildContext context) {
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
                                icon: CircleAvatar(
                                  backgroundColor: const Color(0xff888888),
                                  foregroundImage: NetworkImage(profileImage.data!.showProfileInformationImage),
                                  backgroundImage: const AssetImage('assets/icons/app-icon.png'),
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
                              backgroundColor: const Color(0xff888888),
                              foregroundImage: const AssetImage('assets/icons/app-icon.png'),
                            ),
                            onPressed: () async{
                              Scaffold.of(context).openDrawer();
                            }
                          );
                        }else{
                          return Container(child: const CircularProgressIndicator(), padding: const EdgeInsets.all(20.0),);
                        }
                      },
                    ),
                    title: const Text('FacesByPlaces.com', style: const TextStyle(fontSize: 16, color: const Color(0xffffffff),),),
                    centerTitle: true,
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.search, color: const Color(0xffffffff), size: 35),
                        onPressed: () async{
                          Navigator.pushNamed(context, '/home/blm/search');
                        },
                      ),
                    ],
                  ),
                  body: Stack(
                    children: [

                      SingleChildScrollView(
                        physics: const NeverScrollableScrollPhysics(), 
                        child: Container(
                          height: SizeConfig.screenHeight, 
                          child: const MiscBLMBackgroundTemplate(
                            image: const AssetImage('assets/icons/background2.png'),
                          ),
                        ),
                      ),

                      Container(
                        child: ((){
                          switch(toggleBottomListener){
                            case 0: return HomeBLMFeedTab();
                            case 1: return HomeBLMManageTab();
                            case 2: return HomeBLMPostTab();
                            case 3: return HomeBLMNotificationsTab();
                          }
                        }()),
                      ),
                    ],
                  ),
                  floatingActionButton: FloatingActionButton(
                    backgroundColor: const Color(0xffffffff),
                    onPressed: () async{
                      scanQR();
                    },
                    child: const Icon(Icons.qr_code, color: const Color(0xff4EC9D4),),
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
                        selectedColor: const Color(0xff04ECFF),
                        fillColor: Colors.transparent,
                        color: const Color(0xffB1B1B1),
                        children: [

                          Container(
                            width: SizeConfig.screenWidth! / 4,
                            child: Column(
                              children: [
                                const Icon(MdiIcons.fire,),
                                const SizedBox(height: 5),
                                const Text('Feed', style: const TextStyle(fontSize: 12,),),
                              ],
                            ),
                          ),

                          Container(
                            width: SizeConfig.screenWidth! / 4,
                            child: Column(
                              children: [
                                const Icon(MdiIcons.graveStone),
                                const SizedBox(height: 5),
                                const Text('Memorials', style: const TextStyle(fontSize: 12,),),
                              ],
                            ),
                          ),

                          Container(
                            width: SizeConfig.screenWidth! / 4,
                            child: Column(
                              children: [
                                const Icon(MdiIcons.post),
                                const SizedBox(height: 5),
                                const Text('Post', style: const TextStyle(fontSize: 12,),),
                              ],
                            ),
                          ),

                          Container(
                            width: SizeConfig.screenWidth! / 4,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Column(
                                  children: const <Widget>[
                                    const Icon(MdiIcons.heart),
                                    const SizedBox(height: 5),
                                    const Text('Notification', style: const TextStyle(fontSize: 12,),),
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
                        isSelected: bottomTabListener
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xffffffff),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: const Color(0xff888888).withOpacity(0.5),
                            blurRadius: 5,
                            spreadRadius: 1,
                            offset: const Offset(0, 0)
                          ),
                        ],
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
                                    onTap: (){
                                      showGeneralDialog(
                                        context: context,
                                        barrierDismissible: true,
                                        barrierLabel: 'Dialog',
                                        transitionDuration: const Duration(milliseconds: 0),
                                        pageBuilder: (_, __, ___) {
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
                                                        onTap: (){
                                                          Navigator.pop(context);
                                                        },
                                                        child: CircleAvatar(
                                                          radius: 20,
                                                          backgroundColor: const Color(0xff000000).withOpacity(0.8),
                                                          child: const Icon(Icons.close_rounded, color: const Color(0xffffffff),),
                                                        ),
                                                      ),
                                                    ),

                                                    const SizedBox(height: 20,),

                                                    Expanded(
                                                      child: CachedNetworkImage(
                                                        fit: BoxFit.cover,
                                                        imageUrl: manageDrawer.data!.showProfileInformationImage,
                                                        placeholder: (context, url) => const Center(child: const CircularProgressIndicator(),),
                                                        errorWidget: (context, url, error) => Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover, scale: 1.0,),
                                                      )
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
                                    child: manageDrawer.data!.showProfileInformationImage != ''
                                    ? CircleAvatar(
                                      radius: 100,
                                      backgroundColor: const Color(0xff888888),
                                      foregroundImage: NetworkImage(manageDrawer.data!.showProfileInformationImage),
                                      backgroundImage: const AssetImage('assets/icons/app-icon.png'),
                                    )
                                    : const CircleAvatar(
                                      radius: 100,
                                      backgroundColor: const Color(0xff888888),
                                      foregroundImage: const AssetImage('assets/icons/app-icon.png'),
                                    ),
                                  ),

                                  const SizedBox(height: 20),

                                  Text(manageDrawer.data!.showProfileInformationFirstName + ' ' + manageDrawer.data!.showProfileInformationLastName, textAlign: TextAlign.center, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: const Color(0xffffffff),),),

                                  const SizedBox(height: 45),

                                  GestureDetector(
                                    onTap: (){
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Home', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w200, color: const Color(0xffffffff),),),
                                  ),

                                  const SizedBox(height: 25),

                                  GestureDetector(
                                    onTap: (){
                                      Navigator.pop(context);
                                      Navigator.pushNamed(context, '/home/blm/create-memorial');
                                    },
                                    child: const Text('Create Memorial Page', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w200, color: const Color(0xffffffff),),),
                                  ),

                                  const SizedBox(height: 20),

                                  GestureDetector(
                                    onTap: () async{
                                      context.loaderOverlay.show();
                                      APIBLMShowNotificationStatus result = await apiBLMShowNotificationStatus(userId: manageDrawer.data!.showProfileInformationUserId);
                                      context.loaderOverlay.hide();

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
                                    child: const Text('Notification Settings', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w200, color: const Color(0xffffffff),),),
                                  ),

                                  const SizedBox(height: 20),

                                  GestureDetector(
                                    onTap: () async{
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMUserProfileDetails(userId: manageDrawer.data!.showProfileInformationUserId)));
                                    },
                                    child: const Text('Profile Settings', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w200, color: const Color(0xffffffff),),),
                                  ),

                                  const SizedBox(height: 20),

                                  GestureDetector(
                                    onTap: () async{

                                      context.loaderOverlay.show();
                                      bool result = await apiBLMLogout();
                                      context.loaderOverlay.hide();

                                      if(result){
                                        Route newRoute = MaterialPageRoute(builder: (BuildContext context) => const UIGetStarted());
                                        Navigator.pushAndRemoveUntil(context, newRoute, (route) => false);
                                      }else{
                                        await showDialog(
                                          context: context,
                                          builder: (_) => 
                                            AssetGiffyDialog(
                                            image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                            title: const Text('Error', textAlign: TextAlign.center, style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                                            entryAnimation: EntryAnimation.DEFAULT,
                                            description: const Text('Something went wrong. Please try again.',
                                              textAlign: TextAlign.center,
                                            ),
                                            onlyOkButton: true,
                                            buttonOkColor: const Color(0xffff0000),
                                            onOkButtonPressed: () {
                                              Navigator.pop(context, true);
                                            },
                                          )
                                        );
                                      }
                                      
                                    },
                                    child: const Text('Log Out', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w200, color: const Color(0xffffffff),),),
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
                                
                                const CircleAvatar(
                                  radius: 100,
                                  backgroundColor: const Color(0xff888888),
                                  foregroundImage: const AssetImage('assets/icons/app-icon.png'),
                                ),

                                Expanded(child: Container(),),

                                GestureDetector(
                                  onTap: (){
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Something went wrong. Please try again.', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w200, color: const Color(0xffffffff),), textAlign: TextAlign.center,),
                                ),

                                Expanded(child: Container(),),

                                GestureDetector(
                                  onTap: (){
                                    Route newRoute = MaterialPageRoute(builder: (BuildContext context) => const UIGetStarted());
                                    Navigator.pushAndRemoveUntil(context, newRoute, (route) => false);
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.directions_walk_rounded, color: const Color(0xffffffff), size: 16,),

                                      const SizedBox(width: 20),

                                      const Text('Go back', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w200, color: const Color(0xffffffff),),),
                                    ],
                                  ),
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

                            const CircleAvatar(
                              radius: 100,
                              backgroundColor: const Color(0xff888888),
                              foregroundImage: const AssetImage('assets/icons/app-icon.png'),
                            ),

                            const SizedBox(height: 20),

                            const Text('Guest User', textAlign: TextAlign.center, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: const Color(0xffffffff),),),

                            const SizedBox(height: 45),

                            GestureDetector(
                              onTap: (){
                                Navigator.pop(context);
                              },
                              child: const Text('Home', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w200, color: const Color(0xffffffff),),),
                            ),

                            const SizedBox(height: 25),

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

                                Route newRoute = MaterialPageRoute(builder: (BuildContext context) => const UIGetStarted());
                                Navigator.pushAndRemoveUntil(context, newRoute, (route) => false);
                              },
                              child: const Text('Sign up or Sign in', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w200, color: const Color(0xffffffff),),),
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
