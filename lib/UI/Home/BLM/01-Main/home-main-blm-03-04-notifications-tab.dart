import 'package:facesbyplaces/API/BLM/02-Main/api-main-blm-04-04-home-notifications-tab.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-10-blm-notification-display.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/material.dart';

class BLMMainPagesNotifications{
  int id;
  String createdAt;
  String updatedAt;
  int actorId;
  String actorImage;
  bool read;
  String action;
  int postId;
  String notificationType;

  BLMMainPagesNotifications({required this.id, required this.createdAt, required this.updatedAt, required this.actorId, required this.actorImage, required this.read, required this.action, required this.postId, required this.notificationType});
}

class HomeBLMNotificationsTab extends StatefulWidget{

  HomeBLMNotificationsTabState createState() => HomeBLMNotificationsTabState();
}

class HomeBLMNotificationsTabState extends State<HomeBLMNotificationsTab>{

  ScrollController scrollController = ScrollController();
  List<BLMMainPagesNotifications> notifications = [];
  int itemRemaining = 1;
  int page = 1;
  int count = 0;

  void initState(){
    super.initState();
    onLoading();
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        if(itemRemaining != 0){
          setState(() {
            onLoading();
          });
        }else{
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('No more notifications to show'),
              duration: Duration(seconds: 1),
              backgroundColor: Color(0xff4EC9D4),
            ),
          );
        }
      }
    });
  }

  Future<void> onRefresh() async{
    setState(() {
      onLoading();
    });
  }

  void onLoading() async{
    if(itemRemaining != 0){
      context.showLoaderOverlay();
      var newValue = await apiBLMHomeNotificationsTab(page: page);
      context.hideLoaderOverlay();

      itemRemaining = newValue.blmItemsRemaining;
      count = count + newValue.blmNotification.length;

      for(int i = 0; i < newValue.blmNotification.length; i++){
        notifications.add(
          BLMMainPagesNotifications(
            id: newValue.blmNotification[i].homeTabNotificationId,
            createdAt: newValue.blmNotification[i].homeTabNotificationCreatedAt,
            updatedAt: newValue.blmNotification[i].homeTabNotificationUpdatedAt,
            actorId: newValue.blmNotification[i].homeTabNotificationActor.homeTabNotificationActorId,
            read: newValue.blmNotification[i].homeTabNotificationRead,
            action: newValue.blmNotification[i].homeTabNotificationAction,
            postId: newValue.blmNotification[i].homeTabNotificationPostId,
            actorImage: newValue.blmNotification[i].homeTabNotificationActor.homeTabNotificationActorImage,
            notificationType: newValue.blmNotification[i].homeTabNotificationNotificationType,
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
          physics: ClampingScrollPhysics(),
          itemCount: count,
          separatorBuilder: (c, i) => Divider(height: 10, color: Colors.transparent),
          itemBuilder: (c, i) {
            return MiscBLMNotificationDisplayTemplate(
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