import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-11-blm-notification-display.dart';
import 'package:facesbyplaces/API/BLM/api-07-04-blm-home-notifications-tab.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';

class HomeBLMNotificationsTab extends StatefulWidget{

  HomeBLMNotificationsTabState createState() => HomeBLMNotificationsTabState();
}

class HomeBLMNotificationsTabState extends State<HomeBLMNotificationsTab>{

  void initState(){
    super.initState();
    apiBLMHomeNotificationsTab();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return FutureBuilder<APIBLMHomeTabNotificationMain>(
      future: apiBLMHomeNotificationsTab(),
      builder: (context, notificationsTab){
        if(notificationsTab.hasData){
          return Container(
            height: SizeConfig.screenHeight - (AppBar().preferredSize.height + SizeConfig.blockSizeVertical * 13),
            color: Color(0xffffffff),
            child: ListView.separated(
              physics: ClampingScrollPhysics(),
              itemCount: notificationsTab.data.notification.length,
              itemBuilder: (context, index){
                return MiscBLMNotificationDisplayTemplate(
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

