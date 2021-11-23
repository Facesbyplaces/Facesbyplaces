import 'package:facesbyplaces/API/Regular/11-Settings-Notifications/api_settings_notifications_regular_01_update_notification_memorial.dart';
import 'package:facesbyplaces/API/Regular/11-Settings-Notifications/api_settings_notifications_regular_02_update_notification_activities.dart';
import 'package:facesbyplaces/API/Regular/11-Settings-Notifications/api_settings_notifications_regular_03_update_notification_post_likes.dart';
import 'package:facesbyplaces/API/Regular/11-Settings-Notifications/api_settings_notifications_regular_04_update_notification_post_comments.dart';
import 'package:facesbyplaces/API/Regular/11-Settings-Notifications/api_settings_notifications_regular_05_update_notification_add_family.dart';
import 'package:facesbyplaces/API/Regular/11-Settings-Notifications/api_settings_notifications_regular_06_update_notification_add_friends.dart';
import 'package:facesbyplaces/API/Regular/11-Settings-Notifications/api_settings_notifications_regular_07_update_notification_add_admin.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter/material.dart';
import 'package:dialog/dialog.dart';
import 'package:misc/misc.dart';

class HomeRegularNotificationSettings extends StatefulWidget{
  final bool newMemorial;
  final bool newActivities;
  final bool postLikes;
  final bool postComments;
  final bool addFamily;
  final bool addFriends;
  final bool addAdmin;
  const HomeRegularNotificationSettings({Key? key, required this.newMemorial, required this.newActivities, required this.postLikes, required this.postComments, required this.addFamily, required this.addFriends, required this.addAdmin}) : super(key: key);

  @override
  HomeRegularNotificationSettingsState createState() => HomeRegularNotificationSettingsState();
}

class HomeRegularNotificationSettingsState extends State<HomeRegularNotificationSettings>{
  ValueNotifier<bool> toggle1 = ValueNotifier<bool>(false);
  ValueNotifier<bool> toggle2 = ValueNotifier<bool>(false);
  ValueNotifier<bool> toggle3 = ValueNotifier<bool>(false);
  ValueNotifier<bool> toggle4 = ValueNotifier<bool>(false);
  ValueNotifier<bool> toggle5 = ValueNotifier<bool>(false);
  ValueNotifier<bool> toggle6 = ValueNotifier<bool>(false);
  ValueNotifier<bool> toggle7 = ValueNotifier<bool>(false);

  @override
  void initState(){
    super.initState();
    toggle1.value = widget.newMemorial;
    toggle2.value = widget.newActivities;
    toggle3.value = widget.postLikes;
    toggle4.value = widget.postComments;
    toggle5.value = widget.addFamily;
    toggle6.value = widget.addFriends;
    toggle7.value = widget.addAdmin;
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
        child: ValueListenableBuilder(
          valueListenable: toggle1,
          builder: (_, bool toggle1Listener, __) => ValueListenableBuilder(
            valueListenable: toggle2,
            builder: (_, bool toggle2Listener, __) => ValueListenableBuilder(
              valueListenable: toggle3,
              builder: (_, bool toggle3Listener, __) => ValueListenableBuilder(
                valueListenable: toggle4,
                builder: (_, bool toggle4Listener, __) => ValueListenableBuilder(
                  valueListenable: toggle5,
                  builder: (_, bool toggle5Listener, __) => ValueListenableBuilder(
                    valueListenable: toggle6,
                    builder: (_, bool toggle6Listener, __) => ValueListenableBuilder(
                      valueListenable: toggle7,
                      builder: (_, bool toggle7Listener, __) => Scaffold(
                        appBar: AppBar(
                          title: const Text('Notification Settings', style: TextStyle(fontSize: 26, fontFamily: 'NexaBold', color: Color(0xffffffff),),),
                          backgroundColor: const Color(0xff04ECFF),
                          centerTitle: true,
                          leading: IconButton(
                            icon: const Icon(Icons.arrow_back, color: Color(0xffffffff), size: 35,),
                            onPressed: (){
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        body: Stack(
                          children: [
                            const MiscBackgroundTemplate(image: AssetImage('assets/icons/background2.png'),),
                            SingleChildScrollView(
                              physics: const ClampingScrollPhysics(),
                                padding: const EdgeInsets.all(20.0),
                                child: SafeArea(
                                  child: Column(
                                  children: [
                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                            const Expanded(child: Text('New Memorial Page', style: TextStyle(fontSize: 20, fontFamily: 'HelveticaRegular', color: Color(0xff000000),),),),

                                            Switch(
                                              value: toggle1Listener,
                                              activeColor: const Color(0xffFFFFFF),
                                              activeTrackColor: const Color(0xff3498DB),
                                              onChanged: (value) async{
                                                context.loaderOverlay.show();
                                                bool result = await apiRegularUpdateNotificationMemorial(hide: value);
                                                context.loaderOverlay.hide();

                                                if(result){
                                                  toggle1.value = value;
                                                }else{
                                                  await showDialog(
                                                    context: context,
                                                    builder: (context) => CustomDialog(
                                                      image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                                      title: 'Error',
                                                      description: 'Something went wrong. Please try again.',
                                                      okButtonColor: const Color(0xfff44336), // RED
                                                      includeOkButton: true,
                                                    ),
                                                  );
                                                }
                                              },
                                            ),
                                          ],
                                        ),

                                        Row(
                                          children: [
                                            const Expanded(child: Text('New Activities', style: TextStyle(fontSize: 20, fontFamily: 'HelveticaRegular', color: Color(0xff000000),),),),

                                            Switch(
                                              value: toggle2Listener,
                                              activeTrackColor: const Color(0xff3498DB),
                                              activeColor: const Color(0xffFFFFFF),
                                              onChanged: (value) async{
                                                context.loaderOverlay.show();
                                                bool result = await apiRegularUpdateNotificationActivities(hide: value);
                                                context.loaderOverlay.hide();

                                                if(result){
                                                  toggle2.value = value;
                                                }else{
                                                  await showDialog(
                                                    context: context,
                                                    builder: (context) => CustomDialog(
                                                      image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                                      title: 'Error',
                                                      description: 'Something went wrong. Please try again.',
                                                      okButtonColor: const Color(0xfff44336), // RED
                                                      includeOkButton: true,
                                                    ),
                                                  );
                                                }
                                              },
                                            ),
                                          ],
                                        ),

                                        Row(
                                          children: [
                                            const Expanded(child: Text('Post Likes', style: TextStyle(fontSize: 20, fontFamily: 'HelveticaRegular', color: Color(0xff000000),),),),

                                            Switch(
                                              value: toggle3Listener,
                                              activeTrackColor: const Color(0xff3498DB),
                                              activeColor: const Color(0xffFFFFFF),
                                              onChanged: (value) async{
                                                context.loaderOverlay.show();
                                                bool result = await apiRegularUpdateNotificationPostLikes(hide: value);
                                                context.loaderOverlay.hide();

                                                if(result){
                                                  toggle3.value = value;
                                                }else{
                                                  await showDialog(
                                                    context: context,
                                                    builder: (context) => CustomDialog(
                                                      image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                                      title: 'Error',
                                                      description: 'Something went wrong. Please try again.',
                                                      okButtonColor: const Color(0xfff44336), // RED
                                                      includeOkButton: true,
                                                    ),
                                                  );
                                                }
                                              },
                                            ),
                                          ],
                                        ),

                                        Row(
                                          children: [
                                            const Expanded(child: Text('Post Comments', style: TextStyle(fontSize: 20, fontFamily: 'HelveticaRegular', color: Color(0xff000000),),),),

                                            Switch(
                                              value: toggle4Listener,
                                              activeTrackColor: const Color(0xff3498DB),
                                              activeColor: const Color(0xffFFFFFF),
                                              onChanged: (value) async{
                                                context.loaderOverlay.show();
                                                bool result = await apiRegularUpdateNotificationPostComments(hide: value);
                                                context.loaderOverlay.hide();

                                                if(result){
                                                  toggle4.value = value;
                                                }else{
                                                  await showDialog(
                                                    context: context,
                                                    builder: (context) => CustomDialog(
                                                      image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                                      title: 'Error',
                                                      description: 'Something went wrong. Please try again.',
                                                      okButtonColor: const Color(0xfff44336), // RED
                                                      includeOkButton: true,
                                                    ),
                                                  );
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 50),

                                    const Divider(color: Color(0xffffffff), thickness: 1,),

                                    const SizedBox(height: 50),

                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text('Page Invites', style: TextStyle(fontSize: 26, fontFamily: 'HelveticaBold', color: Color(0xff000000),),),

                                        const SizedBox(height: 10,),

                                        Row(
                                          children: [
                                            const Expanded(child: Text('Add as Family', style: TextStyle(fontSize: 20, fontFamily: 'HelveticaRegular', color: Color(0xff000000),),),),

                                            Switch(
                                              value: toggle5Listener,
                                              activeColor: const Color(0xffFFFFFF),
                                              activeTrackColor: const Color(0xff3498DB),
                                              onChanged: (value) async{
                                                context.loaderOverlay.show();
                                                bool result = await apiRegularUpdateNotificationAddFamily(hide: value);
                                                context.loaderOverlay.hide();

                                                if(result){
                                                  toggle5.value = value;
                                                  await showDialog(
                                                    context: context,
                                                    builder: (context) => CustomDialog(
                                                      image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                                      title: 'Error',
                                                      description: 'Something went wrong. Please try again.',
                                                      okButtonColor: const Color(0xfff44336), // RED
                                                      includeOkButton: true,
                                                    ),
                                                  );
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                        
                                        Row(
                                          children: [
                                            const Expanded(child: Text('Add as Friend', style: TextStyle(fontSize: 20, fontFamily: 'HelveticaRegular', color: Color(0xff000000),),)),

                                            Switch(
                                              value: toggle6Listener,
                                              activeColor: const Color(0xffFFFFFF),
                                              activeTrackColor: const Color(0xff3498DB),
                                              onChanged: (value) async{
                                                context.loaderOverlay.show();
                                                bool result = await apiRegularUpdateNotificationAddFriends(hide: value);
                                                context.loaderOverlay.hide();

                                                if(result){
                                                  toggle6.value = value;
                                                }else{
                                                  await showDialog(
                                                    context: context,
                                                    builder: (context) => CustomDialog(
                                                      image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                                      title: 'Error',
                                                      description: 'Something went wrong. Please try again.',
                                                      okButtonColor: const Color(0xfff44336), // RED
                                                      includeOkButton: true,
                                                    ),
                                                  );
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                        
                                        Row(
                                          children: [
                                            const Expanded(child: Text('Add as Page Admin', style: TextStyle(fontSize: 20, fontFamily: 'HelveticaRegular', color: Color(0xff000000),),)),

                                            Switch(
                                              value: toggle7Listener,
                                              activeColor: const Color(0xffFFFFFF),
                                              activeTrackColor: const Color(0xff3498DB),
                                              onChanged: (value) async{
                                                context.loaderOverlay.show();
                                                bool result = await apiRegularUpdateNotificationAddAdmin(hide: value);
                                                context.loaderOverlay.hide();

                                                if(result){
                                                  toggle7.value = value;
                                                }else{
                                                  await showDialog(
                                                    context: context,
                                                    builder: (context) => CustomDialog(
                                                      image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                                      title: 'Error',
                                                      description: 'Something went wrong. Please try again.',
                                                      okButtonColor: const Color(0xfff44336), // RED
                                                      includeOkButton: true,
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
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}