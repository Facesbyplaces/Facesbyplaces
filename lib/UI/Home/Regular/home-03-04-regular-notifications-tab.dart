import 'package:facesbyplaces/API/Regular/api-07-04-regular-home-notifications-tab.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-05-regular-notifications.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter/material.dart';

class RegularMainPagesNotifications{
  int id;
  String createdAt;
  String updatedAt;
  int recipientId;
  int actorId;
  bool read;
  String action;
  String url;

  RegularMainPagesNotifications({this.id, this.createdAt, this.updatedAt, this.recipientId, this.actorId, this.read, this.action, this.url});
}

class HomeRegularNotificationsTab extends StatefulWidget{

  HomeRegularNotificationsTabState createState() => HomeRegularNotificationsTabState();
}

class HomeRegularNotificationsTabState extends State<HomeRegularNotificationsTab>{

  RefreshController refreshController = RefreshController(initialRefresh: true);
  List<RegularMainPagesNotifications> notifications = [];
  int itemRemaining = 1;
  int page = 1;

  void initState(){
    super.initState();
    onLoading();
  }

  void onRefresh() async{
    await Future.delayed(Duration(milliseconds: 1000));
    refreshController.refreshCompleted();
  }

  void onLoading() async{
    if(itemRemaining != 0){
      var newValue = await apiRegularHomeNotificationsTab(page);
      itemRemaining = newValue.itemsRemaining;

      for(int i = 0; i < newValue.notification.length; i++){
        notifications.add(
          RegularMainPagesNotifications(
            id: newValue.notification[i].id,
            createdAt: newValue.notification[i].createdAt,
            updatedAt: newValue.notification[i].updatedAt,
            actorId: newValue.notification[i].actorId,
            read: newValue.notification[i].read,
            action: newValue.notification[i].action,
            url: newValue.notification[i].url
          ),
        );
      }

      if(mounted)
      setState(() {});
      
      refreshController.loadComplete();
    }else{
      refreshController.loadNoData();
    }
  }


  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return SmartRefresher(
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
            body = Text('No more notifications.', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
          }
          return Container(
            height: 55.0,
            child: Center(child :body),
          );
        },
      ),
      controller: refreshController,
      onRefresh: onRefresh,
      onLoading: onLoading,
      child: ListView.separated(
        padding: EdgeInsets.all(10.0),
        physics: ClampingScrollPhysics(),
        itemBuilder: (c, i) {
          var container = GestureDetector(
            onTap: (){
              Navigator.pushNamed(context, '/home/regular/home-28-regular-show-original-post');
            },
            child: Container(
              child: MiscRegularNotificationDisplayTemplate(
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
                    text: '${notifications[i].createdAt}',
                    style: TextStyle(
                      fontSize: SizeConfig.safeBlockHorizontal * 3,
                      fontWeight: FontWeight.w300,
                      color: Color(0xff888888),
                    ),
                  ),
                  TextSpan(
                    text: '\n',
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


          if(notifications.length != 0){
            return container;
          }else{
            return Center(child: Text('Notification is empty.'),);
          }
          
        },
        separatorBuilder: (c, i) => Divider(height: SizeConfig.blockSizeVertical * 2, color: Colors.transparent),
        itemCount: notifications.length,
      ),
    );
  }
}

