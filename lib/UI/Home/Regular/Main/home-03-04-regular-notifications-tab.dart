import 'package:facesbyplaces/UI/Home/Regular/Show-Post/home-31-regular-show-original-post.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-05-regular-notifications.dart';
import 'package:facesbyplaces/API/Regular/api-07-04-regular-home-notifications-tab.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/Configurations/date-conversion.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:loader_overlay/loader_overlay.dart';
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
      var newValue = await apiRegularHomeNotificationsTab(page);
      context.hideLoaderOverlay();

      itemRemaining = newValue.itemsRemaining;
      count = newValue.notification.length;

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
    return Container(
      height: SizeConfig.screenHeight - SizeConfig.blockSizeVertical * 13 - AppBar().preferredSize.height,
      child: count != 0
      ? SmartRefresher(
        enablePullDown: false,
        enablePullUp: true,
        header: MaterialClassicHeader(),
        footer: CustomFooter(
          loadStyle: LoadStyle.ShowWhenLoading,
          builder: (BuildContext context, LoadStatus mode){
            Widget body ;
            if(mode == LoadStatus.idle){
              body =  Text('Pull up load', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
            }
            else if(mode == LoadStatus.loading){
              body =  CircularProgressIndicator();
            }
            else if(mode == LoadStatus.failed){
              body = Text('Load Failed! Click retry!', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
            }
            else if(mode == LoadStatus.canLoading){
              body = Text('Release to load more', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
              page++;
            }
            else{
              body = Text('End of notifications.', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
            }
            return Container(height: 55.0, child: Center(child: body),
            );
          },
        ),
        controller: refreshController,
        onRefresh: onRefresh,
        onLoading: onLoading,
        child: ListView.separated(
          physics: ClampingScrollPhysics(),
          itemBuilder: (c, i) {
            var container = GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularShowOriginalPost(postId: notifications[i].postId,)));
              },
              child: Container(
                child: MiscRegularNotificationDisplayTemplate(
                  // imageIcon: notifications[i].actorImage,
                  content: [
                    TextSpan(
                      text: '${notifications[i].action}\n',
                      style: TextStyle(
                        fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                        fontWeight: FontWeight.w300,
                        color: Color(0xff000000),
                      ),
                    ),
                    TextSpan(
                      text: '${convertDate(notifications[i].createdAt)}',
                      style: TextStyle(
                        fontSize: SizeConfig.safeBlockHorizontal * 3,
                        fontWeight: FontWeight.w300,
                        color: Color(0xff888888),
                      ),
                    ),
                    TextSpan(
                      text: '\n\n',
                      style: TextStyle(
                        fontSize: SizeConfig.safeBlockHorizontal * 3,
                        fontWeight: FontWeight.w300,
                        color: Color(0xff888888),
                      ),
                    ),
                  ],
                ),
              ),
            );

            return container;
            
          },
          separatorBuilder: (c, i) => Divider(height: SizeConfig.blockSizeVertical * .5, color: Colors.transparent),
          itemCount: notifications.length,
        ),
      )
      : Container(
        child: Center(child: Text('Notification is empty', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),),),
      ),
    );
  }
}
