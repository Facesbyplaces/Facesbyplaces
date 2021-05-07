import 'package:facesbyplaces/API/Regular/02-Main/api-main-regular-04-04-home-notifications-tab.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-10-regular-notification-display.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:flutter/material.dart';

class RegularMainPagesNotifications{
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

class HomeRegularNotificationsTab extends StatefulWidget{

  HomeRegularNotificationsTabState createState() => HomeRegularNotificationsTabState();
}

class HomeRegularNotificationsTabState extends State<HomeRegularNotificationsTab>{

  ScrollController scrollController = ScrollController();
  List<RegularMainPagesNotifications> notifications = [];
  bool isGuestLoggedIn = true;
  int itemRemaining = 1;
  int page = 1;
  int count = 0;

  void initState(){
    super.initState();
    isGuest();
  }

  void isGuest() async{
    final sharedPrefs = await SharedPreferences.getInstance();
    setState(() {
      isGuestLoggedIn = sharedPrefs.getBool('user-guest-session') ?? false;
    });
    if(isGuestLoggedIn != true){
      onLoading();
      scrollController.addListener(() {
        if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
          if(itemRemaining != 0){
            setState(() {
              onLoading();
            });
          }else{
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
  }

  Future<void> onRefresh() async{
    setState(() {
      onLoading();
    });
  }

  void onLoading() async{
    if(itemRemaining != 0){
      context.loaderOverlay.show();
      var newValue = await apiRegularHomeNotificationsTab(page: page).onError((error, stackTrace) async{
        context.loaderOverlay.hide();
        await showDialog(
          context: context,
          builder: (_) => 
            AssetGiffyDialog(
            image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
            title: const Text('Error', textAlign: TextAlign.center, style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
            entryAnimation: EntryAnimation.DEFAULT,
            description: Text('Something went wrong. Please try again.',
              textAlign: TextAlign.center,
            ),
            onlyOkButton: true,
            buttonOkColor: const Color(0xffff0000),
            onOkButtonPressed: () {
              Navigator.pop(context, true);
            },
          )
        );
        return Future.error('Error occurred: $error');
      });
      context.loaderOverlay.hide();

      itemRemaining = newValue.almItemsRemaining;
      count = count + newValue.almNotification.length;

      for(int i = 0; i < newValue.almNotification.length; i++){
        notifications.add(
          RegularMainPagesNotifications(
            id: newValue.almNotification[i].homeTabNotificationId,
            createdAt: newValue.almNotification[i].homeTabNotificationCreatedAt,
            updatedAt: newValue.almNotification[i].homeTabNotificationUpdatedAt,
            actorId: newValue.almNotification[i].homeTabNotificationActor.homeTabNotificationActorId,
            read: newValue.almNotification[i].homeTabNotificationRead,
            action: newValue.almNotification[i].homeTabNotificationAction,
            postId: newValue.almNotification[i].homeTabNotificationPostId,
            actorImage: newValue.almNotification[i].homeTabNotificationActor.homeTabNotificationActorImage,
            notificationType: newValue.almNotification[i].homeTabNotificationNotificationType,
          ),
        );
      }

      if(mounted)
      setState(() {});
      page++;
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Container(
      width: SizeConfig.screenWidth,
      child: count != 0
      ? RefreshIndicator(
        onRefresh: onRefresh,
        child: ListView.separated(
          controller: scrollController,
          physics: const ClampingScrollPhysics(),
          itemCount: count,
          separatorBuilder: (c, i) => const Divider(height: 10, color: Colors.transparent),
          itemBuilder: (c, i) {
            return MiscRegularNotificationDisplayTemplate(
              imageIcon: notifications[i].actorImage,
              postId: notifications[i].postId,
              notification: notifications[i].action,
              dateCreated: timeago.format(DateTime.parse(notifications[i].createdAt)),
              notificationType: notifications[i].notificationType,
              readStatus: notifications[i].read,
            );
          },
        )
      )
      : SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              SizedBox(height: (SizeConfig.screenHeight! - 85 - kToolbarHeight) / 3.5,),

              Image.asset('assets/icons/app-icon.png', height: 250, width: 250,),

              const SizedBox(height: 45,),

              const Text('Notification is empty', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: const Color(0xffB1B1B1),),),

              SizedBox(height: (SizeConfig.screenHeight! - 85 - kToolbarHeight) / 3.5,),
            ],
          ),
        ),
      ),
    );
  }
}