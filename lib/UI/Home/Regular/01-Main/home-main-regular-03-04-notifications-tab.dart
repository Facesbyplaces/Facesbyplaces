import 'package:facesbyplaces/API/Regular/02-Main/api-main-regular-04-04-home-notifications-tab.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-10-regular-notification-display.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:timeago/timeago.dart' as timeago;
// ignore: import_of_legacy_library_into_null_safe
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:flutter/material.dart';

class RegularMainPagesNotifications {
  final int id;
  final String createdAt;
  final String updatedAt;
  final int actorId;
  final String actorImage;
  final bool read;
  final String action;
  final int postId;
  final String notificationType;

  const RegularMainPagesNotifications({required this.id, required this.createdAt, required this.updatedAt, required this.actorId, required this.actorImage, required this.read, required this.action, required this.postId, required this.notificationType});
}

class HomeRegularNotificationsTab extends StatefulWidget {
  HomeRegularNotificationsTabState createState() => HomeRegularNotificationsTabState();
}

class HomeRegularNotificationsTabState extends State<HomeRegularNotificationsTab> {
  List<MiscRegularNotificationDisplayTemplate> notifications = [];
  ScrollController scrollController = ScrollController();
  ValueNotifier<int> count = ValueNotifier<int>(0);
  bool isGuestLoggedIn = true;
  int itemRemaining = 1;
  int page = 1;

  void initState() {
    super.initState();
    isGuest();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (itemRemaining != 0) {
          onLoading();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: const Text('No more notifications to show'),
              duration: const Duration(seconds: 1),
              backgroundColor: const Color(0xff4EC9D4),
            ),
          );
        }
      }
    });
  }

  void isGuest() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    isGuestLoggedIn = sharedPrefs.getBool('user-guest-session') ?? false;

    if (isGuestLoggedIn != true) {
      onLoading();
    }
  }

  Future<void> onRefresh() async {
    count.value = 0;
    notifications = [];
    itemRemaining = 1;
    page = 1;
    onLoading();
  }

  void onLoading() async {
    if (itemRemaining != 0) {
      context.loaderOverlay.show();
      var newValue = await apiRegularHomeNotificationsTab(page: page)
          .onError((error, stackTrace) async {
        context.loaderOverlay.hide();
        await showDialog(
            context: context,
            builder: (_) => AssetGiffyDialog(
              image: Image.asset(
                'assets/icons/cover-icon.png',
                fit: BoxFit.cover,
              ),
              title: const Text(
                'Error',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 22.0, fontWeight: FontWeight.w600),
              ),
              entryAnimation: EntryAnimation.DEFAULT,
              description: Text(
                'Something went wrong. Please try again.',
                textAlign: TextAlign.center,
              ),
              onlyOkButton: true,
              buttonOkColor: const Color(0xffff0000),
              onOkButtonPressed: () {
                Navigator.pop(context, true);
              },
            ));
        return Future.error('Error occurred: $error');
      });
      context.loaderOverlay.hide();

      itemRemaining = newValue.almItemsRemaining;
      count.value = count.value + newValue.almNotification.length;

      for (int i = 0; i < newValue.almNotification.length; i++) {
        notifications.add(
          MiscRegularNotificationDisplayTemplate(
            imageIcon: newValue.almNotification[i].homeTabNotificationActor.homeTabNotificationActorImage,
            postId: newValue.almNotification[i].homeTabNotificationPostId,
            notification: newValue.almNotification[i].homeTabNotificationAction,
            dateCreated: timeago.format(DateTime.parse(newValue.almNotification[i].homeTabNotificationCreatedAt,)),
            notificationType: newValue.almNotification[i].homeTabNotificationNotificationType,
            readStatus: newValue.almNotification[i].homeTabNotificationRead,
          ),
        );
      }

      if(mounted)
      page++;
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    print('Notification tab rebuild!');
    return ValueListenableBuilder(
      valueListenable: count,
      builder: (_, int countListener, __) => Container(
        width: SizeConfig.screenWidth,
        child: countListener != 0
            ? RefreshIndicator(
            onRefresh: onRefresh,
            child: ListView.separated(
              controller: scrollController,
              physics: const ClampingScrollPhysics(),
              itemCount: countListener,
              separatorBuilder: (c, i) =>
              const Divider(height: 10, color: Colors.transparent),
              itemBuilder: (c, i) => notifications[i],
            ))
            : SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height:
                  (SizeConfig.screenHeight! - 85 - kToolbarHeight) /
                      3.5,
                ),
                Image.asset(
                  'assets/icons/app-icon.png',
                  height: 250,
                  width: 250,
                ),
                const SizedBox(
                  height: 45,
                ),
                Text(
                  'Notification is empty',
                  style: TextStyle(
                    fontSize: SizeConfig.blockSizeVertical! * 3.52,
                    fontFamily: 'NexaBold',
                    color: const Color(0xffB1B1B1),
                  ),
                ),
                SizedBox(
                  height:
                  (SizeConfig.screenHeight! - 85 - kToolbarHeight) /
                      3.5,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}