import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-11-blm-notification-display.dart';
import 'package:facesbyplaces/API/BLM/api-07-04-blm-home-notifications-tab.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';

class HomeBLMNotificationsTab extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return FutureBuilder<bool>(
      future: apiBLMHomeNotificationsTab(),
      builder: (context, notificationsTab){
        if(notificationsTab.hasData){
          return Container(
            height: SizeConfig.screenHeight - (AppBar().preferredSize.height + SizeConfig.blockSizeVertical * 13),
            color: Color(0xffffffff),
            child: ListView(
              physics: ClampingScrollPhysics(),
              children: [

                MiscBLMNotificationDisplayTemplate(
                  content: [
                    TextSpan(
                      text: 'Jason Enriquez ',
                      style: TextStyle(
                        fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff000000),
                      ),
                    ),
                    TextSpan(
                      text: 'liked your posts\n',
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
                ),

                MiscBLMNotificationDisplayTemplate(
                  content: [
                    TextSpan(
                      text: 'Joan Oliver ',
                      style: TextStyle(
                        fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff000000),
                      ),
                    ),
                    TextSpan(
                      text: 'commented on your post\n',
                      style: TextStyle(
                        fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                        fontWeight: FontWeight.w300,
                        color: Color(0xff000000),
                      ),
                    ),
                    TextSpan(
                      text: 'an hour ago\n\n',
                      style: TextStyle(
                        fontSize: SizeConfig.safeBlockHorizontal * 3,
                        fontWeight: FontWeight.w300,
                        color: Color(0xff888888),
                      ),
                    ),
                    TextSpan(
                      text: 'What a heartwarming story 😇. Hope we can read more of your journey together.\n',
                      style: TextStyle(
                        fontSize: SizeConfig.safeBlockHorizontal * 3,
                        fontWeight: FontWeight.w300,
                        color: Color(0xff888888),
                      ),
                    ),
                  ],
                ),

                MiscBLMNotificationDisplayTemplate(
                  content: [
                    TextSpan(
                      text: 'Mike Perez ',
                      style: TextStyle(
                        fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff000000),
                      ),
                    ),
                    TextSpan(
                      text: 'likes your comment on\n',
                      style: TextStyle(
                        fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                        fontWeight: FontWeight.w300,
                        color: Color(0xff000000),
                      ),
                    ),
                    TextSpan(
                      text: 'In Memory of John Doe ',
                      style: TextStyle(
                        fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff000000),
                      ),
                    ),
                    TextSpan(
                      text: 'post\n',
                      style: TextStyle(
                        fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                        fontWeight: FontWeight.w300,
                        color: Color(0xff000000),
                      ),
                    ),
                    TextSpan(
                      text: 'an hour ago\n\n',
                      style: TextStyle(
                        fontSize: SizeConfig.safeBlockHorizontal * 3,
                        fontWeight: FontWeight.w300,
                        color: Color(0xff888888),
                      ),
                    ),
                    TextSpan(
                      text: 'My condolences to your family😭\n',
                      style: TextStyle(
                        fontSize: SizeConfig.safeBlockHorizontal * 3,
                        fontWeight: FontWeight.w300,
                        color: Color(0xff888888),
                      ),
                    ),
                  ],
                ),

                MiscBLMNotificationDisplayTemplate(
                  content: [
                    TextSpan(
                      text: 'Steve Wilson ',
                      style: TextStyle(
                        fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff000000),
                      ),
                    ),
                    TextSpan(
                      text: 'made you a manager of\n',
                      style: TextStyle(
                        fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                        fontWeight: FontWeight.w300,
                        color: Color(0xff000000),
                      ),
                    ),
                    TextSpan(
                      text: 'Mark Jacksons Memorial Page\n',
                      style: TextStyle(
                        fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff000000),
                      ),
                    ),
                    TextSpan(
                      text: '30 mins ago\n\n',
                      style: TextStyle(
                        fontSize: SizeConfig.safeBlockHorizontal * 3,
                        fontWeight: FontWeight.w300,
                        color: Color(0xff888888),
                      ),
                    ),
                  ],
                ),

                MiscBLMNotificationDisplayTemplate(
                  content: [
                    TextSpan(
                      text: 'Steve Wilson ',
                      style: TextStyle(
                        fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff000000),
                      ),
                    ),
                    TextSpan(
                      text: 'remove you as a manager of ',
                      style: TextStyle(
                        fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                        fontWeight: FontWeight.w300,
                        color: Color(0xff000000),
                      ),
                    ),
                    TextSpan(
                      text: 'Mark Jacksons Memorial Page\n',
                      style: TextStyle(
                        fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff000000),
                      ),
                    ),
                    TextSpan(
                      text: '30 mins ago\n\n',
                      style: TextStyle(
                        fontSize: SizeConfig.safeBlockHorizontal * 3,
                        fontWeight: FontWeight.w300,
                        color: Color(0xff888888),
                      ),
                    ),
                  ],
                ),

              ],
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

