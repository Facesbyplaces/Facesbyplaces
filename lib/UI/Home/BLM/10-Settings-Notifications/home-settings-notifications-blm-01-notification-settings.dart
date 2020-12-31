import 'package:facesbyplaces/API/BLM/11-Settings-Notifications/api-settings-notifications-blm-01-update-notification-memorial.dart';
import 'package:facesbyplaces/API/BLM/11-Settings-Notifications/api-settings-notifications-blm-02-update-notification-activities.dart';
import 'package:facesbyplaces/API/BLM/11-Settings-Notifications/api-settings-notifications-blm-03-update-notification-post-likes.dart';
import 'package:facesbyplaces/API/BLM/11-Settings-Notifications/api-settings-notifications-blm-04-update-notification-post-comments.dart';
import 'package:facesbyplaces/API/BLM/11-Settings-Notifications/api-settings-notifications-blm-05-update-notification-add-family.dart';
import 'package:facesbyplaces/API/BLM/11-Settings-Notifications/api-settings-notifications-blm-06-update-notification-add-friends.dart';
import 'package:facesbyplaces/API/BLM/11-Settings-Notifications/api-settings-notifications-blm-07-update-notification-add-admin.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-08-blm-background.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter/material.dart';

class HomeBLMNotificationSettings extends StatefulWidget{
  final bool newMemorial;
  final bool newActivities;
  final bool postLikes;
  final bool postComments;
  final bool addFamily;
  final bool addFriends;
  final bool addAdmin;
  HomeBLMNotificationSettings({this.newMemorial, this.newActivities, this.postLikes, this.postComments, this.addFamily, this.addFriends, this.addAdmin});

  @override
  HomeBLMNotificationSettingsState createState() => HomeBLMNotificationSettingsState(newMemorial: newMemorial, newActivities: newActivities, postLikes: postLikes, postComments: postComments, addFamily: addFamily, addFriends: addFriends, addAdmin: addAdmin);
}

class HomeBLMNotificationSettingsState extends State<HomeBLMNotificationSettings>{
  final bool newMemorial;
  final bool newActivities;
  final bool postLikes;
  final bool postComments;
  final bool addFamily;
  final bool addFriends;
  final bool addAdmin;
  HomeBLMNotificationSettingsState({this.newMemorial, this.newActivities, this.postLikes, this.postComments, this.addFamily, this.addFriends, this.addAdmin});

  bool toggle1;
  bool toggle2;
  bool toggle3;
  bool toggle4;
  bool toggle5;
  bool toggle6;
  bool toggle7;

  void initState(){
    super.initState();
    toggle1 = newMemorial;
    toggle2 = newActivities;
    toggle3 = postLikes;
    toggle4 = postComments;
    toggle5 = addFamily;
    toggle6 = addFriends;
    toggle7 = addAdmin;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return WillPopScope(
      onWillPop: () async{
        return Navigator.canPop(context);
      },
      child: GestureDetector(
        onTap: (){
          FocusNode currentFocus = FocusScope.of(context);
          if(!currentFocus.hasPrimaryFocus){
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xff04ECFF),
            title: Text('Notification Settings', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xffffffff)),),
            centerTitle: true,
            leading: IconButton(icon: Icon(Icons.arrow_back, color: Color(0xffffffff),), onPressed: (){Navigator.pop(context);},),
          ),
          body: Stack(
            children: [
              MiscBLMBackgroundTemplate(image: AssetImage('assets/icons/background2.png'),),

              Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Expanded(
                      child: Column(
                        children: [

                          Row(
                            children: [
                              Expanded(child: Text('New Memorial Page', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),)),

                              Switch(
                                value: toggle1,
                                onChanged: (value) async{
                                  setState(() {
                                    toggle1 = value;
                                  });
                                  
                                  await apiBLMUpdateNotificationMemorial(hide: toggle1);
                                },
                                activeColor: Color(0xff2F353D),
                                activeTrackColor: Color(0xff3498DB),
                              ),

                            ],
                          ),

                          Row(
                            children: [
                              Expanded(child: Text('New Activities', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),)),

                              Switch(
                                value: toggle2,
                                onChanged: (value) async{
                                  setState(() {
                                    toggle2 = value;
                                  });
                                  
                                  await apiBLMUpdateNotificationActivities(hide: toggle2);
                                },
                                activeColor: Color(0xff2F353D),
                                activeTrackColor: Color(0xff3498DB),
                              ),
                            ],
                          ),

                          Row(
                            children: [
                              Expanded(child: Text('Post Likes', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),)),
                              
                              Switch(
                                value: toggle3,
                                onChanged: (value) async{
                                  setState(() {
                                    toggle3 = value;
                                  });
                                  
                                  await apiBLMUpdateNotificationPostLikes(hide: toggle3);
                                },
                                activeColor: Color(0xff2F353D),
                                activeTrackColor: Color(0xff3498DB),
                              ),
                            ],
                          ),

                          Row(
                            children: [
                              Expanded(child: Text('Post Comments', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),)),

                              Switch(
                                value: toggle4,
                                onChanged: (value) async{
                                  setState(() {
                                    toggle4 = value;
                                  });
                                  
                                  await apiBLMUpdateNotificationPostComments(hide: toggle4);
                                },
                                activeColor: Color(0xff2F353D),
                                activeTrackColor: Color(0xff3498DB),
                              ),
                            ],
                          ),

                          Expanded(child: Container(),),

                        ],
                      ),
                    ),

                    Container(height: SizeConfig.blockSizeVertical * .1, color: Color(0xffffffff),),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          SizedBox(height: SizeConfig.blockSizeVertical * 5,),

                          Text('Page Invites', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 5, fontWeight: FontWeight.bold, color: Color(0xff000000),),),

                          SizedBox(height: SizeConfig.blockSizeVertical * 1,),

                          Row(
                            children: [
                              Expanded(child: Text('Add as Family', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),)),

                              Switch(
                                value: toggle5,
                                onChanged: (value) async{
                                  setState(() {
                                    toggle5 = value;
                                  });
                                  
                                  await apiBLMUpdateNotificationAddFamily(hide: toggle5);
                                },
                                activeColor: Color(0xff2F353D),
                                activeTrackColor: Color(0xff3498DB),
                              ),
                            ],
                          ),

                          Row(
                            children: [
                              Expanded(child: Text('Add as Friend', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),)),

                              Switch(
                                value: toggle6,
                                onChanged: (value) async{
                                  setState(() {
                                    toggle6 = value;
                                  });
                                  
                                  await apiBLMUpdateNotificationAddFriends(hide: toggle6);
                                },
                                activeColor: Color(0xff2F353D),
                                activeTrackColor: Color(0xff3498DB),
                              ),
                            ],
                          ),

                          Row(
                            children: [
                              Expanded(child: Text('Add as Page Admin', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),)),

                              Switch(
                                value: toggle7,
                                onChanged: (value) async{
                                  setState(() {
                                    toggle7 = value;
                                  });
                                  
                                  await apiBLMUpdateNotificationAddAdmin(hide: toggle7);
                                },
                                activeColor: Color(0xff2F353D),
                                activeTrackColor: Color(0xff3498DB),
                              ),
                            ],
                          ),

                          Expanded(child: Container(),),

                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}