import 'package:facesbyplaces/API/Regular/02-Main/api-main-regular-04-04-home-notifications-tab.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-10-regular-notification-display.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/material.dart';

class RegularMainPagesNotifications{
  int id;
  String createdAt;
  String updatedAt;
  int actorId;
  String actorImage;
  bool read;
  String action;
  int postId;
  String notificationType;

  RegularMainPagesNotifications({required this.id, required this.createdAt, required this.updatedAt, required this.actorId, required this.actorImage, required this.read, required this.action, required this.postId, required this.notificationType});
}

class HomeRegularNotificationsTab extends StatefulWidget{

  HomeRegularNotificationsTabState createState() => HomeRegularNotificationsTabState();
}

class HomeRegularNotificationsTabState extends State<HomeRegularNotificationsTab>{

  List<RegularMainPagesNotifications> notifications = [];
  int itemRemaining = 1;
  int page = 1;
  int count = 0;

  void initState(){
    super.initState();
    onLoading();
  }

  Future<void> onRefresh() async{
    setState(() {
      onLoading();
    });
  }

  void onLoading() async{
    if(itemRemaining != 0){
      context.showLoaderOverlay();
      var newValue = await apiRegularHomeNotificationsTab(page: page);
      context.hideLoaderOverlay();

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
          physics: ClampingScrollPhysics(),
          itemCount: count,
          separatorBuilder: (c, i) => Divider(height: 10, color: Colors.transparent),
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
        physics: ClampingScrollPhysics(),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              SizedBox(height: (SizeConfig.screenHeight! - 85 - kToolbarHeight) / 3.5,),

              Image.asset('assets/icons/app-icon.png', height: 250, width: 250,),

              SizedBox(height: 45,),

              Text('Notification is empty', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xffB1B1B1),),),

              SizedBox(height: (SizeConfig.screenHeight! - 85 - kToolbarHeight) / 3.5,),
            ],
          ),
        ),
      ),
    );
  }
}

