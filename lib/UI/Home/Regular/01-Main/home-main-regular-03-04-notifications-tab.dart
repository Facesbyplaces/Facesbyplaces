import 'package:facesbyplaces/API/Regular/02-Main/api-main-regular-04-04-home-notifications-tab.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-05-regular-notifications.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-19-regular-empty-display.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/material.dart';

class RegularMainPagesNotifications{
  int id;
  String createdAt;
  String updatedAt;
  int recipientId;
  int actorId;
  String actorImage;
  bool read;
  String action;
  int postId;

  RegularMainPagesNotifications({this.id, this.createdAt, this.updatedAt, this.recipientId, this.actorId, this.actorImage, this.read, this.action, this.postId});
}

class HomeRegularNotificationsTab extends StatefulWidget{

  HomeRegularNotificationsTabState createState() => HomeRegularNotificationsTabState();
}

class HomeRegularNotificationsTabState extends State<HomeRegularNotificationsTab>{

  RefreshController refreshController = RefreshController(initialRefresh: true);
  List<RegularMainPagesNotifications> notifications;
  int itemRemaining;
  int page;
  int count;

  void initState(){
    super.initState();
    notifications = [];
    itemRemaining = 1;
    count = 0;
    page = 1;
    onLoading();
  }

  void onRefresh() async{
    await Future.delayed(Duration(milliseconds: 1000));
    refreshController.refreshCompleted();
  }

  void onLoading() async{
    if(itemRemaining != 0){
      context.showLoaderOverlay();
      var newValue = await apiRegularHomeNotificationsTab(page: page);
      context.hideLoaderOverlay();

      itemRemaining = newValue.itemsRemaining;
      count = count + newValue.notification.length;

      for(int i = 0; i < newValue.notification.length; i++){
        notifications.add(
          RegularMainPagesNotifications(
            id: newValue.notification[i].id,
            createdAt: newValue.notification[i].createdAt,
            updatedAt: newValue.notification[i].updatedAt,
            actorId: newValue.notification[i].actor.id,
            read: newValue.notification[i].read,
            action: newValue.notification[i].action,
            postId: newValue.notification[i].postId,
            actorImage: newValue.notification[i].actor.image,
          ),
        );
      }

      if(mounted)
      setState(() {});
      page++;
      
      refreshController.loadComplete();
      
    }else{
      refreshController.loadNoData();
    }
  }


  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    ResponsiveWidgets.init(context,
      height: SizeConfig.screenHeight,
      width: SizeConfig.screenWidth,
    );
    return Container(
      height: SizeConfig.screenHeight - SizeConfig.blockSizeVertical * 13 - AppBar().preferredSize.height,
      child: count != 0
      ? SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: MaterialClassicHeader(
          color: Color(0xffffffff),
          backgroundColor: Color(0xff4EC9D4),
        ),
        footer: CustomFooter(
          loadStyle: LoadStyle.ShowWhenLoading,
          builder: (BuildContext context, LoadStatus mode){
            Widget body;
            if(mode == LoadStatus.loading){
              body = CircularProgressIndicator();
            }
            return Center(child: body);
          },
        ),
        controller: refreshController,
        onRefresh: onRefresh,
        onLoading: onLoading,
        child: ListView.separated(
          physics: ClampingScrollPhysics(),
          itemBuilder: (c, i) {

            return MiscRegularNotificationDisplayTemplate(
              imageIcon: notifications[i].actorImage,
              postId: notifications[i].postId,
              notification: notifications[i].action,
              dateCreated: timeago.format(DateTime.parse(notifications[i].createdAt)),
            );
            
          },
          separatorBuilder: (c, i) => Divider(height: SizeConfig.blockSizeVertical * .5, color: Colors.transparent),
          itemCount: notifications.length,
        ),
      )
      : ContainerResponsive(
        height: SizeConfig.screenHeight,
        width: SizeConfig.screenWidth,
        alignment: Alignment.center,
        child: ContainerResponsive(
          width: SizeConfig.screenWidth,
          heightResponsive: false,
          widthResponsive: true,
          alignment: Alignment.center,
          child: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: MiscRegularEmptyDisplayTemplate(message: 'Notification is empty'),
          ),
        ),
      ),
    );
  }
}

