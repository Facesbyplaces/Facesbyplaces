import 'package:facesbyplaces/UI/Home/Regular/02-View-Memorial/home-view-memorial-regular-02-profile-memorial.dart';
import 'package:facesbyplaces/UI/Home/Regular/09-Settings-User/home-settings-user-regular-01-user-details.dart';
import 'package:facesbyplaces/UI/Home/Regular/10-Settings-Notifications/home-settings-notifications-regular-01-notification-settings.dart';
import 'package:facesbyplaces/UI/Home/Regular/11-Show-Post/home-show-post-regular-01-show-original-post-comments.dart';
import 'package:facesbyplaces/UI/Home/BLM/02-View-Memorial/home-view-memorial-blm-02-profile-memorial.dart';
import 'package:facesbyplaces/UI/Home/BLM/11-Show-Post/home-show-post-blm-01-show-original-post-comments.dart';
import 'package:facesbyplaces/API/Regular/02-Main/api-main-regular-01-logout.dart';
import 'package:facesbyplaces/API/Regular/02-Main/api-main-regular-02-show-user-information.dart';
import 'package:facesbyplaces/API/Regular/02-Main/api-main-regular-03-show-notification-settings.dart';
import 'package:facesbyplaces/API/Regular/14-Notifications/api-notifications-regular-01-show-unread-notifications.dart';
import 'package:facesbyplaces/API/Regular/14-Notifications/api-notifications-regular-02-read-unread-notifications.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-07-regular-background.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home-main-regular-03-01-feed-tab.dart';
import 'home-main-regular-03-02-memorial-list-tab.dart';
import 'home-main-regular-03-03-post-tab.dart';
import 'home-main-regular-03-04-notifications-tab.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loader_overlay/loader_overlay.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:giffy_dialog/giffy_dialog.dart';
import '../../../ui-01-get-started.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class HomeRegularScreenExtended extends StatefulWidget {
  final int newToggleBottom;
  const HomeRegularScreenExtended({required this.newToggleBottom});

  HomeRegularScreenExtendedState createState() => HomeRegularScreenExtendedState();
}

class HomeRegularScreenExtendedState extends State<HomeRegularScreenExtended> {
  ValueNotifier<int> unreadNotifications = ValueNotifier<int>(0);
  ValueNotifier<int> toggleBottom = ValueNotifier<int>(0);
  ValueNotifier<List<bool>> bottomTab = ValueNotifier<List<bool>>([true, false, false, false]);
  ValueNotifier<bool> isGuestLoggedIn = ValueNotifier<bool>(true);

  Future<APIRegularShowProfileInformation>? drawerSettings;
  String _scanBarcode = 'Error';

  Future<APIRegularShowProfileInformation> getDrawerInformation() async {
    return await apiRegularShowProfileInformation();
  }

  void getUnreadNotifications() async {
    var value = await apiRegularShowUnreadNotifications();
    unreadNotifications.value = value;
  }

  void isGuest() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    isGuestLoggedIn.value = sharedPrefs.getBool('user-guest-session') ?? false;

    if (isGuestLoggedIn.value != true) {
      getUnreadNotifications();
      drawerSettings = getDrawerInformation();
    }
  }

  Future<void> scanQR() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode("#ff6666", "Cancel", true, ScanMode.QR);
      print('Scanning: $barcodeScanRes');
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
    // _scanBarcode = barcodeScanRes;

    List<dynamic> newValue = _scanBarcode.split('-');

    print('The newValue in QR code is $newValue');

    if (_scanBarcode != 'Error') {
      if (newValue[0] == 'Memorial') {
        if (newValue[2] == 'Blm') {
          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMMemorialProfile(memorialId: int.parse(newValue[1]), pageType: newValue[2], newJoin: false,)));
        } else {
          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularMemorialProfile(memorialId: int.parse(newValue[1]), pageType: newValue[2], newJoin: false,)));
        }
      } else {
        if (newValue[4] == 'Blm') {
          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMShowOriginalPostComments(postId: int.parse(newValue[1]))));
        } else {
          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularShowOriginalPostComments(postId: int.parse(newValue[1]))));
        }
      }
    } else {
      await showDialog(
        context: context,
          builder: (_) => AssetGiffyDialog(
          image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
          title: Text('Error', 
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: SizeConfig.blockSizeVertical! * 3.16,
              fontFamily: 'NexaRegular',
            ),
          ),
          entryAnimation: EntryAnimation.DEFAULT,
          description: Text(
            'Something went wrong. Please try again.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: SizeConfig.blockSizeVertical! * 2.87,
              fontFamily: 'NexaRegular',
            ),
          ),
          onlyOkButton: true,
          buttonOkColor: const Color(0xffff0000),
          onOkButtonPressed: () {
            Navigator.pop(context, true);
          },
        ),
      );
    }
  }

  void initState() {
    super.initState();
    isGuest();
    toggleBottom.value = widget.newToggleBottom;
    bottomTab.value = toggleBottom.value == 0 ? [true, false, false, false] : [false, true, false, false];
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    print('Home extended screen build!');
    return WillPopScope(
      onWillPop: () async {
        return Navigator.canPop(context);
      },
      child: GestureDetector(
        onTap: () {
          FocusNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: ValueListenableBuilder(
          valueListenable: toggleBottom,
          builder: (_, int toggleBottomListener, __) => ValueListenableBuilder(
            valueListenable: bottomTab,
            builder: (_, List<bool> bottomTabListener, __) =>
                ValueListenableBuilder(
              valueListenable: unreadNotifications,
              builder: (_, int unreadNotificationListener, __) =>
                  ValueListenableBuilder(
                valueListenable: isGuestLoggedIn,
                builder: (_, bool isGuestLoggedInListener, __) => Scaffold(
                  appBar: AppBar(
                    backgroundColor: Color(0xff4EC9D4),
                    leading: FutureBuilder<APIRegularShowProfileInformation>(
                      future: drawerSettings,
                      builder: (context, profileImage) {
                        if (profileImage.hasData) {
                          return Builder(
                            builder: (context) {
                              return IconButton(
                                icon: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                  ),
                                  child: CircleAvatar(
                                    backgroundColor: const Color(0xff888888),
                                    foregroundImage: NetworkImage(profileImage.data!.showProfileInformationImage),
                                    backgroundImage: const AssetImage('assets/icons/app-icon.png'),
                                  ),
                                ),
                                onPressed: () async {
                                  Scaffold.of(context).openDrawer();
                                },
                              );
                            },
                          );
                        } else if (profileImage.hasError || isGuestLoggedInListener) {
                          return IconButton(
                            icon: const CircleAvatar(
                              backgroundColor: const Color(0xff888888),
                              foregroundImage: const AssetImage('assets/icons/app-icon.png'),
                            ),
                            onPressed: () async {
                              Scaffold.of(context).openDrawer();
                            },
                          );
                        } else {
                          return Container(
                            child: const CircularProgressIndicator(),
                            padding: const EdgeInsets.all(20.0),
                          );
                        }
                      },
                    ),
                    title: Text('FacesByPlaces.com',
                      style: TextStyle(
                        fontSize: SizeConfig.blockSizeVertical! * 2.74,
                        fontFamily: 'NexaBold',
                        color: const Color(0xffffffff),
                      ),
                    ),
                    centerTitle: true,
                    actions: [
                      GestureDetector(
                        onTap: (){
                          Navigator.pushNamed(context, '/home/regular/search');
                        },
                        child: SizedBox(
                          height: SizeConfig.blockSizeVertical! * 4.04,
                          width: SizeConfig.blockSizeHorizontal! * 7.18,
                          child: Image.asset('assets/icons/zoom.png',),
                        ),
                      ),
                    ],
                  ),
                  body: Stack(
                    children: [
                      SingleChildScrollView(
                        physics: const NeverScrollableScrollPhysics(),
                        child: Container(
                          height: SizeConfig.screenHeight,
                          child: const MiscRegularBackgroundTemplate(
                            image: const AssetImage('assets/icons/background2.png'),
                          ),
                        ),
                      ),
                      Container(
                        child: (() {
                          switch (toggleBottomListener) {
                            case 0: return HomeRegularFeedTab();
                            case 1: return HomeRegularManageTab();
                            case 2: return HomeRegularPostTab();
                            case 3: return HomeRegularNotificationsTab();
                          }
                        }()),
                      ),
                    ],
                  ),
                  floatingActionButton: FloatingActionButton(
                    backgroundColor: const Color(0xffffffff),
                    onPressed: () async {
                      scanQR();
                    },
                    child: const Icon(
                      Icons.qr_code,
                      color: const Color(0xff4EC9D4),
                    ),
                  ),
                  floatingActionButtonLocation:
                      FloatingActionButtonLocation.centerDocked,
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
                                const Icon(
                                  MdiIcons.fire,
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Feed',
                                  style: TextStyle(
                                      fontSize: SizeConfig.blockSizeVertical! * 1.76,
                                    fontFamily: 'NexaLight'
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: SizeConfig.screenWidth! / 4,
                            child: Column(
                              children: [
                                const Icon(MdiIcons.graveStone),
                                const SizedBox(height: 5),
                                Text(
                                  'Memorials',
                                  style: TextStyle(
                                      fontSize: SizeConfig.blockSizeVertical! * 1.76,
                                      fontFamily: 'NexaLight'
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: SizeConfig.screenWidth! / 4,
                            child: Column(
                              children: [
                                const Icon(MdiIcons.post),
                                const SizedBox(height: 5),
                                Text(
                                  'Post',
                                  style: TextStyle(
                                      fontSize: SizeConfig.blockSizeVertical! * 1.76,
                                      fontFamily: 'NexaLight'
                                  ),
                                ),
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
                                    Text(
                                      'Notification',
                                      style: TextStyle(
                                          fontSize: SizeConfig.blockSizeVertical! * 1.76,
                                          fontFamily: 'NexaLight'
                                      ),
                                    ),
                                  ],
                                ),
                                Positioned(
                                  top: 0,
                                  right: 20,
                                  child: CircleAvatar(
                                    radius: 12,
                                    backgroundColor: const Color(0xffff0000),
                                    child: isGuestLoggedInListener == true
                                        ? const Text(
                                            '0',
                                            style: const TextStyle(
                                                color: const Color(0xffffffff),
                                                fontSize: 12),
                                          )
                                        : Text(
                                            unreadNotificationListener > 99
                                                ? '99+'
                                                : '$unreadNotificationListener',
                                            style: const TextStyle(
                                                color: const Color(0xffffffff),
                                                fontSize: 12),
                                          ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                        onPressed: (int index) async {
                          toggleBottom.value = index;

                          for (int i = 0; i < bottomTabListener.length; i++) {
                            if (i == toggleBottom.value) {
                              bottomTabListener[i] = true;
                            } else {
                              bottomTabListener[i] = false;
                            }
                          }

                          if (toggleBottom.value == 3) {
                            if (isGuestLoggedInListener != true) {
                              await apiRegularReadUnreadNotifications();
                              unreadNotifications.value = 0;
                              getUnreadNotifications();
                            }
                          }
                        },
                        isSelected: bottomTabListener,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xffffffff),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: const Color(0xff888888).withOpacity(0.5),
                              blurRadius: 5,
                              spreadRadius: 1,
                              offset: const Offset(0, 0)),
                        ],
                      ),
                    ),
                  ),
                  drawer: isGuestLoggedInListener != true
                      ? FutureBuilder<APIRegularShowProfileInformation>(
                          future: drawerSettings,
                          builder: (context, manageDrawer) {
                            if (manageDrawer.hasData) {
                              return Drawer(
                                child: Container(
                                  alignment: Alignment.topCenter,
                                  color: const Color(0xff4EC9D4),
                                  child: SingleChildScrollView(
                                    physics: ClampingScrollPhysics(),
                                    child: Column(
                                      children: [
                                        const SizedBox(height: 20),
                                        GestureDetector(
                                          onTap: () {
                                            showGeneralDialog(
                                              context: context,
                                              barrierDismissible: true,
                                              barrierLabel: 'Dialog',
                                              transitionDuration:
                                                  const Duration(
                                                      milliseconds: 0),
                                              pageBuilder: (_, __, ___) {
                                                return Scaffold(
                                                  backgroundColor: Colors
                                                      .black12
                                                      .withOpacity(0.7),
                                                  body: SizedBox.expand(
                                                    child: SafeArea(
                                                      child: Column(
                                                        children: [
                                                          Container(
                                                            alignment: Alignment
                                                                .centerRight,
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    right:
                                                                        20.0),
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child:
                                                                  CircleAvatar(
                                                                radius: 20,
                                                                backgroundColor:
                                                                    const Color(
                                                                            0xff000000)
                                                                        .withOpacity(
                                                                            0.8),
                                                                child:
                                                                    const Icon(
                                                                  Icons
                                                                      .close_rounded,
                                                                  color: const Color(
                                                                      0xffffffff),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 20,
                                                          ),
                                                          Expanded(
                                                              child:
                                                                  CachedNetworkImage(
                                                            fit: BoxFit.cover,
                                                            imageUrl: manageDrawer
                                                                .data!
                                                                .showProfileInformationImage,
                                                            placeholder:
                                                                (context,
                                                                        url) =>
                                                                    const Center(
                                                              child:
                                                                  const CircularProgressIndicator(),
                                                            ),
                                                            errorWidget:
                                                                (context, url,
                                                                        error) =>
                                                                    Image.asset(
                                                              'assets/icons/cover-icon.png',
                                                              fit: BoxFit.cover,
                                                              scale: 1.0,
                                                            ),
                                                          )),
                                                          const SizedBox(
                                                            height: 80,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                          child: manageDrawer.data!
                                                      .showProfileInformationImage !=
                                                  ''
                                              ? Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: Colors.white,
                                                width: 3,
                                              ),
                                            ),
                                            child: CircleAvatar(
                                              radius: 100,
                                              backgroundColor:
                                              const Color(0xff888888),
                                              foregroundImage: NetworkImage(
                                                  manageDrawer.data!
                                                      .showProfileInformationImage),
                                              backgroundImage: const AssetImage(
                                                  'assets/icons/app-icon.png'),
                                            ),
                                          )
                                              : const CircleAvatar(
                                                  radius: 100,
                                                  backgroundColor:
                                                      const Color(0xff888888),
                                                  backgroundImage: const AssetImage(
                                                      'assets/icons/app-icon.png'),
                                                ),
                                        ),
                                        const SizedBox(height: 20),
                                        Text(
                                          manageDrawer.data!
                                                  .showProfileInformationFirstName +
                                              ' ' +
                                              manageDrawer.data!
                                                  .showProfileInformationLastName,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: SizeConfig.blockSizeVertical! * 2.74,
                                           fontFamily: 'NexaBold',
                                            color: const Color(0xffffffff),
                                          ),
                                        ),
                                        const SizedBox(height: 45),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            'Home',
                                            style: TextStyle(
                                              fontSize: SizeConfig.blockSizeVertical! * 2.74,
                                              fontFamily: 'NexaLight',
                                              color: const Color(0xffffffff),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 25),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.pop(context);
                                            Navigator.pushNamed(context,
                                                '/home/regular/create-memorial');
                                          },
                                          child: Text(
                                            'Create Memorial Page',
                                            style: TextStyle(
                                              fontSize: SizeConfig.blockSizeVertical! * 2.74,
                                              fontFamily: 'NexaLight',
                                              color: const Color(0xffffffff),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        GestureDetector(
                                          onTap: () async {
                                            context.loaderOverlay.show();
                                            APIRegularShowNotificationStatus
                                                result =
                                                await apiRegularShowNotificationStatus(
                                                    userId: manageDrawer.data!
                                                        .showProfileInformationUserId);
                                            context.loaderOverlay.hide();

                                            Navigator.pop(context);
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        HomeRegularNotificationSettings(
                                                          newMemorial: result
                                                              .showNotificationStatusNewMemorial,
                                                          newActivities: result
                                                              .showNotificationStatusNewActivities,
                                                          postLikes: result
                                                              .showNotificationStatusPostLikes,
                                                          postComments: result
                                                              .showNotificationStatusPostComments,
                                                          addFamily: result
                                                              .showNotificationStatusAddFamily,
                                                          addFriends: result
                                                              .showNotificationStatusAddFriends,
                                                          addAdmin: result
                                                              .showNotificationStatusAddAdmin,
                                                        )));
                                          },
                                          child: Text(
                                            'Notification Settings',
                                            style: TextStyle(
                                              fontSize: SizeConfig.blockSizeVertical! * 2.74,
                                              fontFamily: 'NexaLight',
                                              color: const Color(0xffffffff),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        GestureDetector(
                                          onTap: () async {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        HomeRegularUserProfileDetails(
                                                            userId: manageDrawer
                                                                .data!
                                                                .showProfileInformationUserId)));
                                          },
                                          child: Text(
                                            'Profile Settings',
                                            style: TextStyle(
                                              fontSize: SizeConfig.blockSizeVertical! * 2.74,
                                              fontFamily: 'NexaLight',
                                              color: const Color(0xffffffff),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        GestureDetector(
                                          onTap: () async {
                                            context.loaderOverlay.show();
                                            bool result =
                                                await apiRegularLogout();
                                            context.loaderOverlay.hide();

                                            if (result) {
                                              Route newRoute =
                                                  MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          const UIGetStarted());
                                              Navigator.pushAndRemoveUntil(
                                                  context,
                                                  newRoute,
                                                  (route) => false);
                                            } else {
                                              await showDialog(
                                                  context: context,
                                                  builder: (_) =>
                                                      AssetGiffyDialog(
                                                        image: Image.asset(
                                                          'assets/icons/cover-icon.png',
                                                          fit: BoxFit.cover,
                                                        ),
                                                        title: const Text(
                                                          'Error',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: const TextStyle(
                                                              fontSize: 22.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                        entryAnimation:
                                                            EntryAnimation
                                                                .DEFAULT,
                                                        description: Text(
                                                          'Something went wrong. Please try again.',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              fontSize: SizeConfig
                                                                  .blockSizeVertical! *
                                                                  2.87,
                                                              fontFamily: 'NexaRegular'),
                                                        ),
                                                        onlyOkButton: true,
                                                        buttonOkColor:
                                                            const Color(
                                                                0xffff0000),
                                                        onOkButtonPressed: () {
                                                          Navigator.pop(
                                                              context, true);
                                                        },
                                                      ));
                                            }
                                          },
                                          child: Text(
                                            'Log Out',
                                            style: TextStyle(
                                              fontSize: SizeConfig.blockSizeVertical! * 2.74,
                                              fontFamily: 'NexaLight',
                                              color: const Color(0xffffffff),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            } else if (manageDrawer.hasError) {
                              return Drawer(
                                child: Container(
                                  alignment: Alignment.topCenter,
                                  color: const Color(0xff4EC9D4),
                                  child: Column(
                                    children: [
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      const CircleAvatar(
                                        radius: 100,
                                        backgroundColor:
                                            const Color(0xff888888),
                                        foregroundImage: const AssetImage(
                                            'assets/icons/app-icon.png'),
                                      ),
                                      Expanded(
                                        child: Container(),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text(
                                          'Something went wrong. Please try again.',
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w200,
                                            color: const Color(0xffffffff),
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Route newRoute = MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  const UIGetStarted());
                                          Navigator.pushAndRemoveUntil(context,
                                              newRoute, (route) => false);
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Icon(
                                              Icons.directions_walk_rounded,
                                              color: const Color(0xffffffff),
                                              size: 16,
                                            ),
                                            const SizedBox(width: 20),
                                            const Text(
                                              'Go back',
                                              style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w200,
                                                color: const Color(0xffffffff),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            } else {
                              return Container(
                                child: Center(
                                  child: Container(
                                    child: const SpinKitThreeBounce(
                                      color: const Color(0xff000000),
                                      size: 50.0,
                                    ),
                                    color: const Color(0xffffffff),
                                  ),
                                ),
                              );
                            }
                          })
                      : Drawer(
                          child: Container(
                            alignment: Alignment.topCenter,
                            color: const Color(0xff4EC9D4),
                            child: SingleChildScrollView(
                              physics: const ClampingScrollPhysics(),
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  const CircleAvatar(
                                    radius: 100,
                                    backgroundColor: const Color(0xff888888),
                                    foregroundImage: const AssetImage(
                                        'assets/icons/app-icon.png'),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                   Text(
                                    'Guest User',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: SizeConfig.blockSizeVertical! * 2.74,
                                      fontFamily: 'NexaBold',
                                      color: const Color(0xffffffff),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 45,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      'Home',
                                      style: TextStyle(
                                        fontSize: SizeConfig.blockSizeVertical! * 2.74,
                                        fontFamily: 'NexaLight',
                                        color: const Color(0xffffffff),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 25,
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      final sharedPrefs =
                                          await SharedPreferences.getInstance();

                                      sharedPrefs.remove('blm-user-id');
                                      sharedPrefs.remove('blm-access-token');
                                      sharedPrefs.remove('blm-uid');
                                      sharedPrefs.remove('blm-client');
                                      sharedPrefs.remove('blm-user-session');

                                      sharedPrefs.remove('regular-user-id');
                                      sharedPrefs
                                          .remove('regular-access-token');
                                      sharedPrefs.remove('regular-uid');
                                      sharedPrefs.remove('regular-client');
                                      sharedPrefs
                                          .remove('regular-user-session');

                                      sharedPrefs.remove('user-guest-session');

                                      Route newRoute = MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              const UIGetStarted());
                                      Navigator.pushAndRemoveUntil(
                                          context, newRoute, (route) => false);
                                    },
                                    child: Text(
                                      'Sign up or Sign in',
                                      style: TextStyle(
                                        fontSize: SizeConfig.blockSizeVertical! * 2.74,
                                        fontFamily: 'NexaLight',
                                        color: const Color(0xffffffff),
                                      ),
                                    ),
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