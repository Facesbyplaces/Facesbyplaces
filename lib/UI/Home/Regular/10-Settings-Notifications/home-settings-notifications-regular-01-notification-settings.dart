import 'package:facesbyplaces/API/Regular/11-Settings-Notifications/api-settings-notifications-regular-01-update-notification-memorial.dart';
import 'package:facesbyplaces/API/Regular/11-Settings-Notifications/api-settings-notifications-regular-02-update-notification-activities.dart';
import 'package:facesbyplaces/API/Regular/11-Settings-Notifications/api-settings-notifications-regular-03-update-notification-post-likes.dart';
import 'package:facesbyplaces/API/Regular/11-Settings-Notifications/api-settings-notifications-regular-04-update-notification-post-comments.dart';
import 'package:facesbyplaces/API/Regular/11-Settings-Notifications/api-settings-notifications-regular-05-update-notification-add-family.dart';
import 'package:facesbyplaces/API/Regular/11-Settings-Notifications/api-settings-notifications-regular-06-update-notification-add-friends.dart';
import 'package:facesbyplaces/API/Regular/11-Settings-Notifications/api-settings-notifications-regular-07-update-notification-add-admin.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-07-regular-background.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter/material.dart';

class HomeRegularNotificationSettings extends StatefulWidget{
  final bool newMemorial;
  final bool newActivities;
  final bool postLikes;
  final bool postComments;
  final bool addFamily;
  final bool addFriends;
  final bool addAdmin;
  HomeRegularNotificationSettings({required this.newMemorial, required this.newActivities, required this.postLikes, required this.postComments, required this.addFamily, required this.addFriends, required this.addAdmin});

  @override
  HomeRegularNotificationSettingsState createState() => HomeRegularNotificationSettingsState(newMemorial: newMemorial, newActivities: newActivities, postLikes: postLikes, postComments: postComments, addFamily: addFamily, addFriends: addFriends, addAdmin: addAdmin);
}

class HomeRegularNotificationSettingsState extends State<HomeRegularNotificationSettings>{
  final bool newMemorial;
  final bool newActivities;
  final bool postLikes;
  final bool postComments;
  final bool addFamily;
  final bool addFriends;
  final bool addAdmin;
  HomeRegularNotificationSettingsState({required this.newMemorial, required this.newActivities, required this.postLikes, required this.postComments, required this.addFamily, required this.addFriends, required this.addAdmin});

  bool toggle1 = false;
  bool toggle2 = false;
  bool toggle3 = false;
  bool toggle4 = false;
  bool toggle5 = false;
  bool toggle6 = false;
  bool toggle7 = false;

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
            title: Text('Notification Settings', style: TextStyle(fontSize: 16, color: Color(0xffffffff)),),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back, 
                color: Color(0xffffffff),
              ), 
              onPressed: (){
                Navigator.pop(context);
              },
            ),
          ),
          body: Stack(
            children: [
              MiscRegularBackgroundTemplate(image: AssetImage('assets/icons/background2.png'),),

              SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Column(
                      children: [

                        Row(
                          children: [
                            Expanded(child: Text('New Memorial Page', style: TextStyle(fontSize: 16, color: Color(0xff000000),),)),

                            Switch(
                              value: toggle1,
                              onChanged: (value) async{
                                setState(() {
                                  toggle1 = value;
                                });
                                

                                context.showLoaderOverlay();
                                await apiRegularUpdateNotificationMemorial(hide: toggle1);
                                context.hideLoaderOverlay();
                              },
                              activeColor: Color(0xff2F353D),
                              activeTrackColor: Color(0xff3498DB),
                            ),

                          ],
                        ),

                        Row(
                          children: [
                            Expanded(child: Text('New Activities', style: TextStyle(fontSize: 16, color: Color(0xff000000),),)),

                            Switch(
                              value: toggle2,
                              onChanged: (value) async{
                                setState(() {
                                  toggle2 = value;
                                });
                                
                                context.showLoaderOverlay();
                                await apiRegularUpdateNotificationActivities(hide: toggle2);
                                context.hideLoaderOverlay();
                              },
                              activeColor: Color(0xff2F353D),
                              activeTrackColor: Color(0xff3498DB),
                            ),
                          ],
                        ),

                        Row(
                          children: [
                            Expanded(child: Text('Post Likes', style: TextStyle(fontSize: 16, color: Color(0xff000000),),)),

                            Switch(
                              value: toggle3,
                              onChanged: (value) async{
                                setState(() {
                                  toggle3 = value;
                                });
                                
                                context.showLoaderOverlay();
                                await apiRegularUpdateNotificationPostLikes(hide: toggle3);
                                context.hideLoaderOverlay();
                              },
                              activeColor: Color(0xff2F353D),
                              activeTrackColor: Color(0xff3498DB),
                            ),
                          ],
                        ),

                        Row(
                          children: [
                            Expanded(child: Text('Post Comments', style: TextStyle(fontSize: 16, color: Color(0xff000000),),)),

                            Switch(
                              value: toggle4,
                              onChanged: (value) async{
                                setState(() {
                                  toggle4 = value;
                                });
                                
                                context.showLoaderOverlay();
                                await apiRegularUpdateNotificationPostComments(hide: toggle4);
                                context.hideLoaderOverlay();
                              },
                              activeColor: Color(0xff2F353D),
                              activeTrackColor: Color(0xff3498DB),
                            ),
                          ],
                        ),

                      ],
                    ),

                    Container(height: .5, color: Color(0xffffffff),),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        SizedBox(height: 40,),

                        Text('Page Invites', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xff000000),),),

                        SizedBox(height: 10,),

                        Row(
                          children: [
                            Expanded(child: Text('Add as Family', style: TextStyle(fontSize: 16, color: Color(0xff000000),),)),

                            Switch(
                              value: toggle5,
                              onChanged: (value) async{
                                setState(() {
                                  toggle5 = value;
                                });
                                
                                context.showLoaderOverlay();
                                await apiRegularUpdateNotificationAddFamily(hide: toggle5);
                                context.hideLoaderOverlay();
                              },
                              activeColor: Color(0xff2F353D),
                              activeTrackColor: Color(0xff3498DB),
                            ),
                          ],
                        ),

                        Row(
                          children: [
                            Expanded(child: Text('Add as Friend', style: TextStyle(fontSize: 16, color: Color(0xff000000),),)),

                            Switch(
                              value: toggle6,
                              onChanged: (value) async{
                                setState(() {
                                  toggle6 = value;
                                });
                                
                                context.showLoaderOverlay();
                                await apiRegularUpdateNotificationAddFriends(hide: toggle6);
                                context.hideLoaderOverlay();
                              },
                              activeColor: Color(0xff2F353D),
                              activeTrackColor: Color(0xff3498DB),
                            ),
                          ],
                        ),

                        Row(
                          children: [
                            Expanded(child: Text('Add as Page Admin', style: TextStyle(fontSize: 16, color: Color(0xff000000),),)),

                            Switch(
                              value: toggle7,
                              onChanged: (value) async{
                                setState(() {
                                  toggle7 = value;
                                });
                                
                                context.showLoaderOverlay();
                                await apiRegularUpdateNotificationAddAdmin(hide: toggle7);
                                context.hideLoaderOverlay();
                              },
                              activeColor: Color(0xff2F353D),
                              activeTrackColor: Color(0xff3498DB),
                            ),
                          ],
                        ),

                      ],
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