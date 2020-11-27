import 'package:facesbyplaces/API/Regular/api-07-04-regular-home-notifications-tab.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-05-regular-notifications.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';

class HomeRegularNotificationsTab extends StatefulWidget{

  HomeRegularNotificationsTabState createState() => HomeRegularNotificationsTabState();
}

class HomeRegularNotificationsTabState extends State<HomeRegularNotificationsTab>{

  void initState(){
    super.initState();
    apiRegularHomeNotificationsTab();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return FutureBuilder<APIRegularHomeTabNotificationMain>(
      future: apiRegularHomeNotificationsTab(),
      builder: (context, notificationsTab){
        if(notificationsTab.hasData){
          return Container(
            height: SizeConfig.screenHeight - (AppBar().preferredSize.height + SizeConfig.blockSizeVertical * 13),
            color: Color(0xffffffff),
            child: ListView.separated(
              physics: ClampingScrollPhysics(),
              itemCount: notificationsTab.data.notification.length,
              itemBuilder: (context, index){
                return MiscRegularNotificationDisplayTemplate(
                  content: [
                    TextSpan(
                      text: '${notificationsTab.data.notification[index].action}\n',
                      style: TextStyle(
                        fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                        fontWeight: FontWeight.w300,
                        color: Color(0xff000000),
                      ),
                    ),
                    TextSpan(
                      text: '30 mins ago',
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
                );
              }, 
              separatorBuilder: (context, index) => Divider(height: 0, color: Colors.transparent),
            ),
          );
        }else if(notificationsTab.hasError){
          return Center(child: Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),),);
        }else{
          return Container(child: Center(child: Container(child: SpinKitThreeBounce(color: Color(0xff000000), size: 50.0,), color: Color(0xffffffff),),),);
        }
      },
    );
  }
}

