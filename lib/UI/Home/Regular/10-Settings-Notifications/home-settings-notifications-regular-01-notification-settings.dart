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
// ignore: import_of_legacy_library_into_null_safe
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:flutter/material.dart';

class HomeRegularNotificationSettings extends StatefulWidget{
  final bool newMemorial;
  final bool newActivities;
  final bool postLikes;
  final bool postComments;
  final bool addFamily;
  final bool addFriends;
  final bool addAdmin;
  const HomeRegularNotificationSettings({required this.newMemorial, required this.newActivities, required this.postLikes, required this.postComments, required this.addFamily, required this.addFriends, required this.addAdmin});

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
  Widget build(BuildContext context){
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
            backgroundColor: const Color(0xff04ECFF),
            title: Text('Notification Settings', style: TextStyle( fontSize: SizeConfig.blockSizeVertical! * 2.74, fontFamily: 'NexaBold', color: const Color(0xffffffff),),),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Color(0xffffffff), size: SizeConfig.blockSizeVertical! * 3.65,),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
          ),
          body: Stack(
            children: [
              const MiscRegularBackgroundTemplate(image: const AssetImage('assets/icons/background2.png'),),
              SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Column(
                      children: [
                        Row(
                          children: [
                            Expanded(child: Text('New Memorial Page', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.11, fontFamily: 'HelveticaRegular', color: const Color(0xff000000),),),),

                            Switch(
                              value: toggle1,
                              activeColor: const Color(0xffFFFFFF),
                              activeTrackColor: const Color(0xff3498DB),
                              onChanged: (value) async{
                                context.loaderOverlay.show();
                                bool result = await apiRegularUpdateNotificationMemorial(hide: value);
                                context.loaderOverlay.hide();

                                if(result){
                                  setState((){
                                    toggle1 = value;
                                  });
                                }else{
                                  await showDialog(
                                    context: context,
                                    builder: (_) => AssetGiffyDialog(
                                      image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                      title: Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 3.16, fontFamily: 'NexaRegular'),),
                                      entryAnimation: EntryAnimation.DEFAULT,
                                      description: Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.87, fontFamily: 'NexaRegular'),),
                                      onlyOkButton: true,
                                      buttonOkColor: const Color(0xffff0000),
                                      onOkButtonPressed: (){
                                        Navigator.pop(context, true);
                                      },
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ),

                        Row(
                          children: [
                            Expanded(child: Text('New Activities', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.11, fontFamily: 'HelveticaRegular', color: const Color(0xff000000),),),),

                            Switch(
                              value: toggle2,
                              activeColor: const Color(0xffFFFFFF),
                              activeTrackColor: const Color(0xff3498DB),
                              onChanged: (value) async{
                                context.loaderOverlay.show();
                                bool result = await apiRegularUpdateNotificationActivities(hide: value);
                                context.loaderOverlay.hide();

                                if(result){
                                  setState((){
                                    toggle2 = value;
                                  });
                                }else{
                                  await showDialog(
                                    context: context,
                                    builder: (_) => AssetGiffyDialog(
                                      image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                      title: Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 3.16, fontFamily: 'NexaRegular'),),
                                      entryAnimation: EntryAnimation.DEFAULT,
                                      description: Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.87, fontFamily: 'NexaRegular'),),
                                      onlyOkButton: true,
                                      buttonOkColor: const Color(0xffff0000),
                                      onOkButtonPressed: (){
                                        Navigator.pop(context, true);
                                      },
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ),

                        Row(
                          children: [
                            Expanded(child: Text('Post Likes', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.11, fontFamily: 'HelveticaRegular', color: const Color(0xff000000),),),),

                            Switch(
                              value: toggle3,
                              activeColor: const Color(0xffFFFFFF),
                              activeTrackColor: const Color(0xff3498DB),
                              onChanged: (value) async{
                                context.loaderOverlay.show();
                                bool result = await apiRegularUpdateNotificationPostLikes(hide: value);
                                context.loaderOverlay.hide();

                                if(result){
                                  setState((){
                                    toggle3 = value;
                                  });
                                }else{
                                  await showDialog(
                                    context: context,
                                    builder: (_) => AssetGiffyDialog(
                                      image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                      title: Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 3.16, fontFamily: 'NexaRegular'),),
                                      entryAnimation: EntryAnimation.DEFAULT,
                                      description: Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.87, fontFamily: 'NexaRegular'),),
                                      onlyOkButton: true,
                                      buttonOkColor: const Color(0xffff0000),
                                      onOkButtonPressed: (){
                                        Navigator.pop(context, true);
                                      },
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ),

                        Row(
                          children: [
                            Expanded(child: Text('Post Comments', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.11, fontFamily: 'HelveticaRegular', color: const Color(0xff000000),),),),

                            Switch(
                              value: toggle4,
                              activeColor: const Color(0xffFFFFFF),
                              activeTrackColor: const Color(0xff3498DB),
                              onChanged: (value) async{
                                context.loaderOverlay.show();
                                bool result = await apiRegularUpdateNotificationPostComments(hide: value);
                                context.loaderOverlay.hide();

                                if(result){
                                  setState((){
                                    toggle4 = value;
                                  });
                                }else{
                                  await showDialog(
                                    context: context,
                                    builder: (_) => AssetGiffyDialog(
                                      image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                      title: Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 3.16, fontFamily: 'NexaRegular'),),
                                      entryAnimation: EntryAnimation.DEFAULT,
                                      description: Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.87, fontFamily: 'NexaRegular'),),
                                      onlyOkButton: true,
                                      buttonOkColor: const Color(0xffff0000),
                                      onOkButtonPressed: (){
                                        Navigator.pop(context, true);
                                      },
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),

                    SizedBox(height: SizeConfig.blockSizeVertical! * 5.12),

                    Divider(color: Colors.white, thickness: 1,),

                    SizedBox(height: SizeConfig.blockSizeVertical! * 5.12),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Page Invites', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.64, fontFamily: 'HelveticaBold', color: const Color(0xff000000),),),

                        const SizedBox(height: 10,),

                        Row(
                          children: [
                            Expanded(child: Text('Add as Family', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.11, fontFamily: 'HelveticaRegular', color: const Color(0xff000000),),),),

                            Switch(
                              value: toggle5,
                              activeColor: const Color(0xffFFFFFF),
                              activeTrackColor: const Color(0xff3498DB),
                              onChanged: (value) async{
                                context.loaderOverlay.show();
                                bool result = await apiRegularUpdateNotificationAddFamily(hide: value);
                                context.loaderOverlay.hide();

                                if(result){
                                  setState((){
                                    toggle5 = value;
                                  });
                                }else{
                                  await showDialog(
                                    context: context,
                                    builder: (_) => AssetGiffyDialog(
                                      image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                      title: Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 3.16, fontFamily: 'NexaRegular'),),
                                      entryAnimation: EntryAnimation.DEFAULT,
                                      description: Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.87, fontFamily: 'NexaRegular'),),
                                      onlyOkButton: true,
                                      buttonOkColor: const Color(0xffff0000),
                                      onOkButtonPressed: (){
                                        Navigator.pop(context, true);
                                      },
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                        
                        Row(
                          children: [
                            Expanded(child: Text('Add as Friend', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.11, fontFamily: 'HelveticaRegular', color: const Color(0xff000000),),)),

                            Switch(
                              value: toggle6,
                              activeColor: const Color(0xffFFFFFF),
                              activeTrackColor: const Color(0xff3498DB),
                              onChanged: (value) async{
                                context.loaderOverlay.show();
                                bool result = await apiRegularUpdateNotificationAddFriends(hide: value);
                                context.loaderOverlay.hide();

                                if(result){
                                  setState((){
                                    toggle6 = value;
                                  });
                                }else{
                                  await showDialog(
                                    context: context,
                                    builder: (_) => AssetGiffyDialog(
                                      image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                      title: Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 3.16, fontFamily: 'NexaRegular'),),
                                      entryAnimation: EntryAnimation.DEFAULT,
                                      description: Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.87, fontFamily: 'NexaRegular'),),
                                      onlyOkButton: true,
                                      buttonOkColor: const Color(0xffff0000),
                                      onOkButtonPressed: (){
                                        Navigator.pop(context, true);
                                      },
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(child: Text('Add as Page Admin', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.11, fontFamily: 'HelveticaRegular', color: const Color(0xff000000),),)),

                            Switch(
                              value: toggle7,
                              activeColor: const Color(0xffFFFFFF),
                              activeTrackColor: const Color(0xff3498DB),
                              onChanged: (value) async{
                                context.loaderOverlay.show();
                                bool result = await apiRegularUpdateNotificationAddAdmin(hide: value);
                                context.loaderOverlay.hide();

                                if(result){
                                  setState((){
                                    toggle7 = value;
                                  });
                                }else{
                                  await showDialog(
                                    context: context,
                                    builder: (_) => AssetGiffyDialog(
                                      image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                      title: Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 3.16, fontFamily: 'NexaRegular'),),
                                      entryAnimation: EntryAnimation.DEFAULT,
                                      description: Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.87, fontFamily: 'NexaRegular'),),
                                      onlyOkButton: true,
                                      buttonOkColor: const Color(0xffff0000),
                                      onOkButtonPressed: (){
                                        Navigator.pop(context, true);
                                      },
                                    ),
                                  );
                                }
                              },
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