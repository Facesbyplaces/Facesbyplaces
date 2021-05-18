import 'package:facesbyplaces/API/BLM/02-Main/api-main-blm-04-04-home-notifications-tab.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-10-blm-notification-display.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/material.dart';

class HomeBLMNotificationsTab extends StatefulWidget {
  HomeBLMNotificationsTabState createState() => HomeBLMNotificationsTabState();
}

class HomeBLMNotificationsTabState extends State<HomeBLMNotificationsTab> {
  List<MiscBLMNotificationDisplayTemplate> notifications = [];
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
      var newValue = await apiBLMHomeNotificationsTab(page: page);
      context.loaderOverlay.hide();

      itemRemaining = newValue.blmItemsRemaining;
      count.value = count.value + newValue.blmNotification.length;

      for (int i = 0; i < newValue.blmNotification.length; i++) {
        notifications.add(
          MiscBLMNotificationDisplayTemplate(
            imageIcon: newValue.blmNotification[i].homeTabNotificationActor
                .homeTabNotificationActorImage,
            postId: newValue.blmNotification[i].homeTabNotificationPostId,
            notification: newValue.blmNotification[i].homeTabNotificationAction,
            dateCreated: timeago.format(DateTime.parse(
              newValue.blmNotification[i].homeTabNotificationCreatedAt,
            )),
            notificationType:
                newValue.blmNotification[i].homeTabNotificationNotificationType,
            readStatus: newValue.blmNotification[i].homeTabNotificationRead,
          ),
        );
      }

      if (mounted) page++;
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    print('BLM Notification tab screen rebuild!');
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