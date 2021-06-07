import 'package:facesbyplaces/API/BLM/09-Settings-Memorial/api-settings-memorial-blm-06-delete-memorial.dart';
import 'package:facesbyplaces/API/BLM/09-Settings-Memorial/api-settings-memorial-blm-14-update-switch-status-family.dart';
import 'package:facesbyplaces/API/BLM/09-Settings-Memorial/api-settings-memorial-blm-15-update-switch-status-friends.dart';
import 'package:facesbyplaces/API/BLM/09-Settings-Memorial/api-settings-memorial-blm-16-update-switch-status-followers.dart';
import 'package:facesbyplaces/UI/Home/BLM/02-View-Memorial/home-view-memorial-blm-01-managed-memorial.dart';
import 'package:facesbyplaces/UI/Home/BLM/05-Donate/home-donate-blm-02-paypal-screen.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-02-blm-dialog.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'home-settings-memorial-blm-02-page-details.dart';
import 'home-settings-memorial-blm-03-update-memorial-image.dart';
import 'home-settings-memorial-blm-04-page-managers.dart';
import 'home-settings-memorial-blm-05-page-family.dart';
import 'home-settings-memorial-blm-06-page-friends.dart';
import 'package:loader_overlay/loader_overlay.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:flutter/material.dart';

class HomeBLMMemorialSettings extends StatefulWidget {
  final int memorialId;
  final String memorialName;
  final bool switchFamily;
  final bool switchFriends;
  final bool switchFollowers;
  HomeBLMMemorialSettings({required this.memorialId, required this.memorialName, required this.switchFamily, required this.switchFriends, required this.switchFollowers});

  HomeBLMMemorialSettingsState createState() => HomeBLMMemorialSettingsState();
}

class HomeBLMMemorialSettingsState extends State<HomeBLMMemorialSettings> {
  ValueNotifier<int> toggle = ValueNotifier<int>(0);
  ValueNotifier<bool> isSwitched1 = ValueNotifier<bool>(false);
  ValueNotifier<bool> isSwitched2 = ValueNotifier<bool>(false);
  ValueNotifier<bool> isSwitched3 = ValueNotifier<bool>(false);
  Future? switchStatus;

  void initState(){
    super.initState();
    isSwitched1.value = widget.switchFamily;
    isSwitched2.value = widget.switchFriends;
    isSwitched3.value = widget.switchFollowers;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return ValueListenableBuilder(
      valueListenable: toggle,
      builder: (_, int toggleListener, __) => Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff04ECFF),
          title: Row(
            children: [
              Text('Memorial Settings', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 3.16, fontFamily: 'NexaRegular', color: const Color(0xffffffff),),),
              Spacer()
            ],
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back,size: SizeConfig.blockSizeVertical! * 3.52,),
            onPressed: (){
              Navigator.pop(context);
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeBLMProfile(memorialId: widget.memorialId, relationship: '', managed: true, newlyCreated: false,)));
            },
          ),
        ),
        body: Column(
          children: [
            Container(
              height: 70,
              child: DefaultTabController(
                length: 2,
                child: TabBar(
                  labelColor: const Color(0xff04ECFF),
                  unselectedLabelColor: const Color(0xff000000),
                  indicatorColor: const Color(0xff04ECFF),
                  indicatorSize: TabBarIndicatorSize.label,
                  onTap: (int index) {
                    toggle.value = index;
                  },
                  tabs: [
                    Text('Page', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.64, fontFamily: 'NexaRegular', color: const Color(0xff2F353D),),),
                    Text('Privacy', style: TextStyle( fontSize: SizeConfig.blockSizeVertical! * 2.64, fontFamily: 'NexaRegular', color: const Color(0xff2F353D),),),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                child: (() {
                  switch (toggleListener){
                    case 0: return settingsTab1(widget.memorialId);
                    case 1: return settingsTab2(widget.memorialId);
                  }
                }()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  settingsTab1(int memorialId){
    return ListView(
      physics: const ClampingScrollPhysics(),
      children: [
        ListTile(
          tileColor: const Color(0xffffffff),
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMPageDetails(memorialId: memorialId,)));
          },
          title: Text('Page Details', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.64, fontFamily: 'NexaBold', color: const Color(0xff2F353D),),),
          subtitle: Text('Update page details', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.11, fontFamily: 'NexaRegular', color: const Color(0xffBDC3C7),),),
        ),
        
        Container(height: 5, color: const Color(0xffeeeeee),),

        ListTile(
          tileColor: const Color(0xffffffff),
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMMemorialPageImage(memorialId: memorialId,)));
          },
          title: Text('Page Image', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.64, fontFamily: 'NexaBold', color: const Color(0xff2F353D),),),
          subtitle: Text('Update Page image and background image', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.11, fontFamily: 'NexaRegular', color: const Color(0xffBDC3C7),),),
        ),

        Container(height: 5, color: const Color(0xffeeeeee),),

        ListTile(
          tileColor: const Color(0xffffffff),
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMPageManagers(memorialId: memorialId,)));
          },
          title: Text('Admins', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.64, fontFamily: 'NexaBold', color: const Color(0xff2F353D),),),
          subtitle: Text('Add or remove admins of this page', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.11, fontFamily: 'NexaRegular', color: const Color(0xffBDC3C7),),),
        ),

        Container(height: 5, color: const Color(0xffeeeeee),),

        ListTile(
          tileColor: const Color(0xffffffff),
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMPageFamily(
                memorialId: memorialId,
                memorialName: widget.memorialName,
                switchFamily: widget.switchFamily,
                switchFriends: widget.switchFriends,
                switchFollowers: widget.switchFollowers),
                settings: RouteSettings(name: 'memorial-settings'),
              ),
            );
          },
          title: Text('Family', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.64, fontFamily: 'NexaBold', color: const Color(0xff2F353D),),),
          subtitle: Text('Add or remove family of this page', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.11, fontFamily: 'NexaRegular', color: const Color(0xffBDC3C7),),),
        ),

        Container(height: 5, color: const Color(0xffeeeeee),),

        ListTile(
          tileColor: const Color(0xffffffff),
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMPageFriends(
                  memorialId: memorialId,
                  memorialName: widget.memorialName,
                  switchFamily: widget.switchFamily,
                  switchFriends: widget.switchFriends,
                  switchFollowers: widget.switchFollowers,
                ),
              ),
            );
          },
          title: Text('Friends', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.64, fontFamily: 'NexaBold', color: const Color(0xff2F353D),),),
          subtitle: Text('Add or remove friends of this page', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.11, fontFamily: 'NexaRegular', color: const Color(0xffBDC3C7),),),
        ),

        Container(height: 5, color: const Color(0xffeeeeee),),

        ListTile(
          tileColor: const Color(0xffffffff),
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMPaypal(pageId: memorialId)));
          },
          title: Text('Paypal', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.64, fontFamily: 'NexaBold', color: const Color(0xff2F353D),),),
          subtitle: Text('Manage cards that receives the memorial gifts', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.11, fontFamily: 'NexaRegular', color: const Color(0xffBDC3C7),),),
        ),

        Container(height: 5, color: const Color(0xffeeeeee),),

        ListTile(
          tileColor: Color(0xffffffff),
          onTap: () async{
            bool confirmResult = await showDialog(
              context: (context),
              builder: (build) => MiscBLMConfirmDialog(content: 'Are you sure you want to delete "${widget.memorialName}"?',),
            );

            if(confirmResult){
              context.loaderOverlay.show();
              bool result = await apiBLMDeleteMemorial(memorialId: memorialId);
              context.loaderOverlay.hide();

              if(result){
                Navigator.popAndPushNamed(context, '/home/blm');
              }else{
                await showDialog(
                  context: context,
                  builder: (_) => AssetGiffyDialog(
                    image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                    title: Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 3.16, fontFamily: 'NexaRegular'),),
                    entryAnimation: EntryAnimation.DEFAULT,
                    description: Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.87, fontFamily: 'NexaRegular',),),
                    onlyOkButton: true,
                    buttonOkColor: const Color(0xffff0000),
                    onOkButtonPressed: (){
                      Navigator.pop(context, true);
                    },
                  ),
                );
              }
            }
          },
          title: Text('Delete Page', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.64, fontFamily: 'NexaBold', color: const Color(0xff2F353D),),),
          subtitle: Text('Completely remove the page. This is irreversible', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.11, fontFamily: 'NexaRegular', color: const Color(0xffBDC3C7),),),
        ),

        const SizedBox(height: 10,),

        Image.asset('assets/icons/logo.png', height: 100, width: 100,),

        const SizedBox(height: 30,),
      ],
    );
  }

  settingsTab2(int memorialId) {
    return ValueListenableBuilder(
      valueListenable: isSwitched1,
      builder: (_, bool isSwitched1Listener, __) => ValueListenableBuilder(
        valueListenable: isSwitched2,
        builder: (_, bool isSwitched2Listener, __) => ValueListenableBuilder(
          valueListenable: isSwitched3,
          builder: (_, bool isSwitched3Listener, __) => Column(
            children: [
              ListTile(
                tileColor: const Color(0xffffffff),
                title: Text('Customize shown info', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.64, fontFamily: 'NexaBold', color: const Color(0xff2F353D),),),
                subtitle: Text('Customize what others see on your page', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.11, fontFamily: 'NexaRegular', color: const Color(0xffBDC3C7),),),
              ),

              Container(height: 5, color: const Color(0xffeeeeee),),

              Container(
                height: 80,
                color: const Color(0xffffffff),
                child: Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        tileColor: const Color(0xffffffff),
                        title: Text('Hide Family', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.64, fontFamily: 'NexaBold', color: const Color(0xff2F353D),),),
                        subtitle: Text('Show or hide family details', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.11, fontFamily: 'NexaRegular', color: const Color(0xffBDC3C7),),),
                      ),
                    ),
                    Switch(
                      value: isSwitched1Listener,
                      activeColor: const Color(0xff2F353D),
                      activeTrackColor: const Color(0xff3498DB),
                      onChanged: (value) async{
                        isSwitched1.value = value;
                        await apiBLMUpdateSwitchStatusFamily(memorialId: memorialId, status: value);
                      },
                    ),
                  ],
                ),
              ),

              Container(height: 5, color: const Color(0xffeeeeee),),

              Container(
                height: 80,
                color: const Color(0xffffffff),
                child: Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        tileColor: const Color(0xffffffff),
                        title: Text('Hide Friends', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.64, fontFamily: 'NexaBold', color: const Color(0xff2F353D),),),
                        subtitle: Text('Show or hide friends details', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.11, fontFamily: 'NexaRegular', color: const Color(0xffBDC3C7),),),
                      ),
                    ),
                    Switch(
                      value: isSwitched2Listener,
                      activeColor: const Color(0xff2F353D),
                      activeTrackColor: const Color(0xff3498DB),
                      onChanged: (value) async {
                        isSwitched2.value = value;
                        await apiBLMUpdateSwitchStatusFriends(memorialId: memorialId, status: value);
                      },
                    ),
                  ],
                ),
              ),

              Container(height: 5, color: const Color(0xffeeeeee),),

              Container(
                height: 80,
                color: const Color(0xffffffff),
                child: Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        tileColor: const Color(0xffffffff),
                        title: Text('Hide Followers', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.64, fontFamily: 'NexaBold', color: const Color(0xff2F353D),),),
                        subtitle: Text('Show or hide your followers', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.11, fontFamily: 'NexaRegular', color: const Color(0xffBDC3C7),),),
                      ),
                    ),
                    Switch(
                      value: isSwitched3Listener,
                      activeColor: const Color(0xff2F353D),
                      activeTrackColor: const Color(0xff3498DB),
                      onChanged: (value) async {
                        isSwitched3.value = value;
                        await apiBLMUpdateSwitchStatusFollowers(memorialId: memorialId, status: value);
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10,),

              Expanded(child: Container()),

              Image.asset('assets/icons/logo.png', height: 100, width: 100,),

              const SizedBox(height: 10,),
            ],
          ),
        ),
      ),
    );
  }
}