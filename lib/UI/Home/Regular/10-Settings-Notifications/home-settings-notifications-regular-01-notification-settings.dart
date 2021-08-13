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
    print('Regular Show Post screen!');
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
                          title: Text('Notification Settings', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.74, fontFamily: 'NexaBold', color: const Color(0xffffffff),),),
                          backgroundColor: const Color(0xff04ECFF),
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
                                                  builder: (_) => AssetGiffyDialog(
                                                    description: Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.87, fontFamily: 'NexaRegular'),),
                                                    title: Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 3.16, fontFamily: 'NexaRegular'),),
                                                    image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                                    entryAnimation: EntryAnimation.DEFAULT,
                                                    buttonOkColor: const Color(0xffff0000),
                                                    onlyOkButton: true,
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
                                                  builder: (_) => AssetGiffyDialog(
                                                    description: Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.87, fontFamily: 'NexaRegular'),),
                                                    title: Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 3.16, fontFamily: 'NexaRegular'),),
                                                    image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                                    entryAnimation: EntryAnimation.DEFAULT,
                                                    buttonOkColor: const Color(0xffff0000),
                                                    onlyOkButton: true,
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
                                                  builder: (_) => AssetGiffyDialog(
                                                    description: Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.87, fontFamily: 'NexaRegular'),),
                                                    title: Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 3.16, fontFamily: 'NexaRegular'),),
                                                    image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                                    entryAnimation: EntryAnimation.DEFAULT,
                                                    buttonOkColor: const Color(0xffff0000),
                                                    onlyOkButton: true,
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
                                                  builder: (_) => AssetGiffyDialog(
                                                    description: Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.87, fontFamily: 'NexaRegular'),),
                                                    title: Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 3.16, fontFamily: 'NexaRegular'),),
                                                    image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                                    entryAnimation: EntryAnimation.DEFAULT,
                                                    buttonOkColor: const Color(0xffff0000),
                                                    onlyOkButton: true,
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
                                            value: toggle5Listener,
                                            activeColor: const Color(0xffFFFFFF),
                                            activeTrackColor: const Color(0xff3498DB),
                                            onChanged: (value) async{
                                              context.loaderOverlay.show();
                                              bool result = await apiRegularUpdateNotificationAddFamily(hide: value);
                                              context.loaderOverlay.hide();

                                              if(result){
                                                toggle5.value = value;
                                              }else{
                                                await showDialog(
                                                  context: context,
                                                  builder: (_) => AssetGiffyDialog(
                                                    description: Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.87, fontFamily: 'NexaRegular'),),
                                                    title: Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 3.16, fontFamily: 'NexaRegular'),),
                                                    image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                                    entryAnimation: EntryAnimation.DEFAULT,
                                                    buttonOkColor: const Color(0xffff0000),
                                                    onlyOkButton: true,
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
                                                  builder: (_) => AssetGiffyDialog(
                                                    description: Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.87, fontFamily: 'NexaRegular'),),
                                                    title: Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 3.16, fontFamily: 'NexaRegular'),),
                                                    image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                                    entryAnimation: EntryAnimation.DEFAULT,
                                                    buttonOkColor: const Color(0xffff0000),
                                                    onlyOkButton: true,
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
                                                  builder: (_) => AssetGiffyDialog(
                                                    description: Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.87, fontFamily: 'NexaRegular'),),
                                                    title: Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 3.16, fontFamily: 'NexaRegular'),),
                                                    image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                                                    entryAnimation: EntryAnimation.DEFAULT,
                                                    buttonOkColor: const Color(0xffff0000),
                                                    onlyOkButton: true,
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