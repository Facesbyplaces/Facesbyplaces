import 'package:facesbyplaces/API/BLM/11-Settings-Notifications/api-settings-notifications-blm-01-update-notification-memorial.dart';
import 'package:facesbyplaces/API/BLM/11-Settings-Notifications/api-settings-notifications-blm-02-update-notification-activities.dart';
import 'package:facesbyplaces/API/BLM/11-Settings-Notifications/api-settings-notifications-blm-03-update-notification-post-likes.dart';
import 'package:facesbyplaces/API/BLM/11-Settings-Notifications/api-settings-notifications-blm-04-update-notification-post-comments.dart';
import 'package:facesbyplaces/API/BLM/11-Settings-Notifications/api-settings-notifications-blm-05-update-notification-add-family.dart';
import 'package:facesbyplaces/API/BLM/11-Settings-Notifications/api-settings-notifications-blm-06-update-notification-add-friends.dart';
import 'package:facesbyplaces/API/BLM/11-Settings-Notifications/api-settings-notifications-blm-07-update-notification-add-admin.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-07-blm-background.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:flutter/material.dart';

class HomeBLMNotificationSettings extends StatefulWidget{
  final bool newMemorial;
  final bool newActivities;
  final bool postLikes;
  final bool postComments;
  final bool addFamily;
  final bool addFriends;
  final bool addAdmin;

  const HomeBLMNotificationSettings({required this.newMemorial, required this.newActivities, required this.postLikes, required this.postComments, required this.addFamily, required this.addFriends, required this.addAdmin});

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

  HomeBLMNotificationSettingsState({required this.newMemorial, required this.newActivities, required this.postLikes, required this.postComments, required this.addFamily, required this.addFriends, required this.addAdmin});

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
            backgroundColor: const Color(0xff04ECFF),
            title: const Text('Notification Settings', style: const TextStyle(fontSize: 16, color: const Color(0xffffffff)),),
            centerTitle: true,
            leading: IconButton(icon: const Icon(Icons.arrow_back, color: const Color(0xffffffff),), onPressed: (){Navigator.pop(context);},),
          ),
          body: Stack(
            children: [
              const MiscBLMBackgroundTemplate(image: const AssetImage('assets/icons/background2.png'),),

              SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Column(
                      children: [

                        Row(
                          children: [
                            Expanded(child: const Text('New Memorial Page', style: const TextStyle(fontSize: 14, color: const Color(0xff000000),),)),

                            Switch(
                              value: toggle1,
                              onChanged: (value) async{
                                bool result = await apiBLMUpdateNotificationMemorial(hide: value);

                                if(result){
                                  setState(() {
                                    toggle1 = value;
                                  });
                                }else{
                                  await showDialog(
                                    context: context,
                                    builder: (_) => 
                                      AssetGiffyDialog(
                                      image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                      title: const Text('Error', textAlign: TextAlign.center, style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                                      entryAnimation: EntryAnimation.DEFAULT,
                                      description: const Text('Something went wrong. Please try again.',
                                        textAlign: TextAlign.center,
                                      ),
                                      onlyOkButton: true,
                                      buttonOkColor: const Color(0xffff0000),
                                      onOkButtonPressed: () {
                                        Navigator.pop(context, true);
                                      },
                                    )
                                  );
                                }
                              },
                              activeColor: const Color(0xff2F353D),
                              activeTrackColor: const Color(0xff3498DB),
                            ),
                          ],
                        ),

                        Row(
                          children: [
                            Expanded(child: const Text('New Activities', style: const TextStyle(fontSize: 14, color: const Color(0xff000000),),)),

                            Switch(
                              value: toggle2,
                              onChanged: (value) async{
                                bool result = await apiBLMUpdateNotificationActivities(hide: value);

                                if(result){
                                  setState(() {
                                    toggle2 = value;
                                  });
                                }else{
                                  await showDialog(
                                    context: context,
                                    builder: (_) => 
                                      AssetGiffyDialog(
                                      image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                      title: const Text('Error', textAlign: TextAlign.center, style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                                      entryAnimation: EntryAnimation.DEFAULT,
                                      description: const Text('Something went wrong. Please try again.',
                                        textAlign: TextAlign.center,
                                      ),
                                      onlyOkButton: true,
                                      buttonOkColor: const Color(0xffff0000),
                                      onOkButtonPressed: () {
                                        Navigator.pop(context, true);
                                      },
                                    )
                                  );
                                }
                              },
                              activeColor: const Color(0xff2F353D),
                              activeTrackColor: const Color(0xff3498DB),
                            ),
                          ],
                        ),

                        Row(
                          children: [
                            Expanded(child: const Text('Post Likes', style: const TextStyle(fontSize: 14, color: const Color(0xff000000),),)),
                            
                            Switch(
                              value: toggle3,
                              onChanged: (value) async{
                                bool result = await apiBLMUpdateNotificationPostLikes(hide: value);

                                if(result){
                                  setState(() {
                                    toggle3 = value;
                                  });
                                }else{
                                  await showDialog(
                                    context: context,
                                    builder: (_) => 
                                      AssetGiffyDialog(
                                      image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                      title: const Text('Error', textAlign: TextAlign.center, style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                                      entryAnimation: EntryAnimation.DEFAULT,
                                      description: const Text('Something went wrong. Please try again.',
                                        textAlign: TextAlign.center,
                                      ),
                                      onlyOkButton: true,
                                      buttonOkColor: const Color(0xffff0000),
                                      onOkButtonPressed: () {
                                        Navigator.pop(context, true);
                                      },
                                    )
                                  );
                                }
                              },
                              activeColor: const Color(0xff2F353D),
                              activeTrackColor: const Color(0xff3498DB),
                            ),
                          ],
                        ),

                        Row(
                          children: [
                            Expanded(child: const Text('Post Comments', style: const TextStyle(fontSize: 14, color: const Color(0xff000000),),)),

                            Switch(
                              value: toggle4,
                              onChanged: (value) async{
                                bool result = await apiBLMUpdateNotificationPostComments(hide: value);

                                if(result){
                                  setState(() {
                                    toggle4 = value;
                                  });
                                }else{
                                  await showDialog(
                                    context: context,
                                    builder: (_) => 
                                      AssetGiffyDialog(
                                      image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                      title: const Text('Error', textAlign: TextAlign.center, style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                                      entryAnimation: EntryAnimation.DEFAULT,
                                      description: const Text('Something went wrong. Please try again.',
                                        textAlign: TextAlign.center,
                                      ),
                                      onlyOkButton: true,
                                      buttonOkColor: const Color(0xffff0000),
                                      onOkButtonPressed: () {
                                        Navigator.pop(context, true);
                                      },
                                    )
                                  );
                                }
                              },
                              activeColor: const Color(0xff2F353D),
                              activeTrackColor: const Color(0xff3498DB),
                            ),
                          ],
                        ),
                      ],
                    ),

                    Container(height: .5, color: const Color(0xffffffff),),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        const SizedBox(height: 40,),

                        const Text('Page Invites', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xff000000),),),

                        const SizedBox(height: 10,),

                        Row(
                          children: [
                            Expanded(child: const Text('Add as Family', style: const TextStyle(fontSize: 14, color: const Color(0xff000000),),)),

                            Switch(
                              value: toggle5,
                              onChanged: (value) async{
                                bool result = await apiBLMUpdateNotificationAddFamily(hide: value);

                                if(result){
                                  setState(() {
                                    toggle5 = value;
                                  });
                                }else{
                                  await showDialog(
                                    context: context,
                                    builder: (_) => 
                                      AssetGiffyDialog(
                                      image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                      title: const Text('Error', textAlign: TextAlign.center, style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                                      entryAnimation: EntryAnimation.DEFAULT,
                                      description: const Text('Something went wrong. Please try again.',
                                        textAlign: TextAlign.center,
                                      ),
                                      onlyOkButton: true,
                                      buttonOkColor: const Color(0xffff0000),
                                      onOkButtonPressed: () {
                                        Navigator.pop(context, true);
                                      },
                                    )
                                  );
                                }
                              },
                              activeColor: const Color(0xff2F353D),
                              activeTrackColor: const Color(0xff3498DB),
                            ),
                          ],
                        ),

                        Row(
                          children: [
                            Expanded(child: const Text('Add as Friend', style: const TextStyle(fontSize: 14, color: const Color(0xff000000),),)),

                            Switch(
                              value: toggle6,
                              onChanged: (value) async{
                                bool result = await apiBLMUpdateNotificationAddFriends(hide: value);

                                if(result){
                                  setState(() {
                                    toggle6 = value;
                                  });
                                }else{
                                  await showDialog(
                                    context: context,
                                    builder: (_) => 
                                      AssetGiffyDialog(
                                      image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                      title: const Text('Error', textAlign: TextAlign.center, style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                                      entryAnimation: EntryAnimation.DEFAULT,
                                      description: const Text('Something went wrong. Please try again.',
                                        textAlign: TextAlign.center,
                                      ),
                                      onlyOkButton: true,
                                      buttonOkColor: const Color(0xffff0000),
                                      onOkButtonPressed: () {
                                        Navigator.pop(context, true);
                                      },
                                    )
                                  );
                                }
                              },
                              activeColor: const Color(0xff2F353D),
                              activeTrackColor: const Color(0xff3498DB),
                            ),
                          ],
                        ),

                        Row(
                          children: [
                            Expanded(child: const Text('Add as Page Admin', style: const TextStyle(fontSize: 14, color: const Color(0xff000000),),)),

                            Switch(
                              value: toggle7,
                              onChanged: (value) async{
                                bool result = await apiBLMUpdateNotificationAddAdmin(hide: value);

                                if(result){
                                  setState(() {
                                    toggle7 = value;
                                  });
                                }else{
                                  await showDialog(
                                    context: context,
                                    builder: (_) => 
                                      AssetGiffyDialog(
                                      image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                      title: const Text('Error', textAlign: TextAlign.center, style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                                      entryAnimation: EntryAnimation.DEFAULT,
                                      description: const Text('Something went wrong. Please try again.',
                                        textAlign: TextAlign.center,
                                      ),
                                      onlyOkButton: true,
                                      buttonOkColor: const Color(0xffff0000),
                                      onOkButtonPressed: () {
                                        Navigator.pop(context, true);
                                      },
                                    )
                                  );
                                }
                              },
                              activeColor: const Color(0xff2F353D),
                              activeTrackColor: const Color(0xff3498DB),
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