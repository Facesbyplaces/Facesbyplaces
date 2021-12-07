import 'package:facesbyplaces/API/BLM/09-Settings-Memorial/api_settings_memorial_blm_06_delete_memorial.dart';
import 'package:facesbyplaces/API/BLM/09-Settings-Memorial/api_settings_memorial_blm_14_update_switch_status_family.dart';
import 'package:facesbyplaces/API/BLM/09-Settings-Memorial/api_settings_memorial_blm_15_update_switch_status_friends.dart';
import 'package:facesbyplaces/API/BLM/09-Settings-Memorial/api_settings_memorial_blm_16_update_switch_status_followers.dart';
import 'package:facesbyplaces/UI/Home/BLM/02-View-Memorial/home_view_memorial_blm_01_managed_memorial.dart';
import 'package:facesbyplaces/UI/Home/BLM/05-Donate/home_donate_blm_02_paypal_screen.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'home_settings_memorial_blm_02_page_details.dart';
import 'home_settings_memorial_blm_03_update_memorial_image.dart';
import 'home_settings_memorial_blm_04_page_managers.dart';
import 'home_settings_memorial_blm_05_page_family.dart';
import 'home_settings_memorial_blm_06_page_friends.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter/material.dart';
import 'package:dialog/dialog.dart';
import 'package:misc/misc.dart';

class HomeBLMMemorialSettings extends StatefulWidget{
  final int memorialId;
  final String memorialName;
  final bool switchFamily;
  final bool switchFriends;
  final bool switchFollowers;
  final bool newlyCreated;
  const HomeBLMMemorialSettings({Key? key, required this.memorialId, required this.memorialName, required this.switchFamily, required this.switchFriends, required this.switchFollowers, required this.newlyCreated}) : super(key: key);

  @override
  HomeBLMMemorialSettingsState createState() => HomeBLMMemorialSettingsState();
}

class HomeBLMMemorialSettingsState extends State<HomeBLMMemorialSettings>{
  ValueNotifier<bool> isSwitched1 = ValueNotifier<bool>(false);
  ValueNotifier<bool> isSwitched2 = ValueNotifier<bool>(false);
  ValueNotifier<bool> isSwitched3 = ValueNotifier<bool>(false);
  ValueNotifier<int> toggle = ValueNotifier<int>(0);
  Future? switchStatus;

  @override
  void initState(){
    super.initState();
    isSwitched1.value = widget.switchFamily;
    isSwitched2.value = widget.switchFriends;
    isSwitched3.value = widget.switchFollowers;
  }

  @override
  Widget build(BuildContext context){
    SizeConfig.init(context);
    return ValueListenableBuilder(
      valueListenable: toggle,
      builder: (_, int toggleListener, __) => Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff04ECFF),
          title: const Text('Memorial Settings', style: TextStyle(fontSize: 26, fontFamily: 'NexaRegular', color: Color(0xffffffff),),),
          centerTitle: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back,size: 35,),
            onPressed: (){
              Navigator.pop(context);
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeBLMProfile(memorialId: widget.memorialId, relationship: '', managed: true, newlyCreated: widget.newlyCreated,)));
            },
          ),
        ),
        body: DefaultTabController(
          length: 2,
          child: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraint){
                return SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraint.maxHeight),
                    child: IntrinsicHeight(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 70,
                            child: TabBar(
                              labelColor: const Color(0xff04ECFF),
                              unselectedLabelColor: const Color(0xff000000),
                              indicatorColor: const Color(0xff04ECFF),
                              indicatorSize: TabBarIndicatorSize.label,
                              tabs: const [
                                Text('Page', style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xff2F353D),),),

                                Text('Privacy', style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xff2F353D)),),
                              ],
                              onTap: (int index){
                                toggle.value = index;
                              },
                            ),
                          ),

                          Expanded(
                            child: SizedBox(
                              child: ((){
                                switch (toggleListener){
                                  case 0: return settingsTab1();
                                  case 1: return settingsTab2();
                                }
                              }()),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
            ),
          ),
        ),
      ),
    );
  }

  settingsTab1(){
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        children: [
          ListTile(
            tileColor: const Color(0xffffffff),
            title: const Text('Page Details', style: TextStyle(fontSize: 24, fontFamily: 'NexaBold', color: Color(0xff2F353D),),),
            subtitle: const Text('Update page details', style: TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xffBDC3C7),),),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMPageDetails(memorialId: widget.memorialId,)));
            },
          ),
          
          Container(height: 5, color: const Color(0xffeeeeee),),

          ListTile(
            tileColor: const Color(0xffffffff),
            title: const Text('Page Image', style: TextStyle(fontSize: 24, fontFamily: 'NexaBold', color: Color(0xff2F353D),),),
            subtitle: const Text('Update Page image and background image', style: TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xffBDC3C7),),),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMMemorialPageImage(memorialId: widget.memorialId,)));
            },
          ),

          Container(height: 5, color: const Color(0xffeeeeee),),

          ListTile(
            tileColor: const Color(0xffffffff),
            title: const Text('Admins', style: TextStyle(fontSize: 24, fontFamily: 'NexaBold', color: Color(0xff2F353D),),),
            subtitle: const Text('Add or remove admins of this page', style: TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xffBDC3C7),),),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMPageManagers(memorialId: widget.memorialId,)));
            },
          ),

          Container(height: 5, color: const Color(0xffeeeeee),),

          ListTile(
            tileColor: const Color(0xffffffff),
            title: const Text('Family', style: TextStyle(fontSize: 24, fontFamily: 'NexaBold', color: Color(0xff2F353D),),),
            subtitle: const Text('Add or remove family of this page', style: TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xffBDC3C7),),),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMPageFamily(memorialId: widget.memorialId, memorialName: widget.memorialName, switchFamily: widget.switchFamily, switchFriends: widget.switchFriends, switchFollowers: widget.switchFollowers), settings: const RouteSettings(name: 'memorial-settings'),),);
            },
          ),

          Container(height: 5, color: const Color(0xffeeeeee),),

          ListTile(
            tileColor: const Color(0xffffffff),
            title: const Text('Friends', style: TextStyle(fontSize: 24, fontFamily: 'NexaBold', color: Color(0xff2F353D),),),
            subtitle: const Text('Add or remove friends of this page', style: TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xffBDC3C7),),),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMPageFriends(memorialId: widget.memorialId, memorialName: widget.memorialName, switchFamily: widget.switchFamily, switchFriends: widget.switchFriends, switchFollowers: widget.switchFollowers,),),);
            },
          ),

          Container(height: 5, color: const Color(0xffeeeeee),),

          ListTile(
            tileColor: const Color(0xffffffff),
            title: const Text('Paypal', style: TextStyle(fontSize: 24, fontFamily: 'NexaBold', color: Color(0xff2F353D),),),
            subtitle: const Text('Manage cards that receives the memorial gifts', style: TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xffBDC3C7),),),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMPaypal(pageId: widget.memorialId)));
            },
          ),

          Container(height: 5, color: const Color(0xffeeeeee),),

          ListTile(
            tileColor: const Color(0xffffffff),
            title: const Text('Delete Page', style: TextStyle(fontSize: 24, fontFamily: 'NexaBold', color: Color(0xff2F353D),),),
            subtitle: const Text('Completely remove the page. This is irreversible', style: TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xffBDC3C7),),),
            onTap: () async{
              bool confirmResult = await showDialog(context: (context), builder: (build) => MiscConfirmDialog(content: 'Are you sure you want to delete "${widget.memorialName}"?',),);

              if(confirmResult){
                context.loaderOverlay.show();
                bool result = await apiBLMDeleteMemorial(memorialId: widget.memorialId);
                context.loaderOverlay.hide();

                if(result){
                  Navigator.popAndPushNamed(context, '/home/blm');
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
              }
            },
          ),

          Container(height: 5, color: const Color(0xffeeeeee),),

          const SizedBox(height: 100,),

          Image.asset('assets/icons/logo.png', height: 100, width: 100,),

          const SizedBox(height: 30,),
        ],
      ),
    );
  }

  settingsTab2() {
    return ValueListenableBuilder(
      valueListenable: isSwitched1,
      builder: (_, bool isSwitched1Listener, __) => ValueListenableBuilder(
        valueListenable: isSwitched2,
        builder: (_, bool isSwitched2Listener, __) => ValueListenableBuilder(
          valueListenable: isSwitched3,
          builder: (_, bool isSwitched3Listener, __) => Column(
            children: [
              const ListTile(
                tileColor: Color(0xffffffff),
                title: Text('Customize shown info', style: TextStyle(fontSize: 24, fontFamily: 'NexaBold', color: Color(0xff2F353D),),),
                subtitle: Text('Customize what others see on your page', style: TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xffBDC3C7),),),
              ),

              Container(height: 5, color: const Color(0xffeeeeee),),

              Container(
                height: 80,
                color: const Color(0xffffffff),
                child: Row(
                  children: [
                    const Expanded(
                      child: ListTile(
                        tileColor: Color(0xffffffff),
                        title: Text('Hide Family', style: TextStyle(fontSize: 24, fontFamily: 'NexaBold', color: Color(0xff2F353D),),),
                        subtitle: Text('Show or hide family details', style: TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xffBDC3C7),),),
                      ),
                    ),
                    Switch(
                      value: isSwitched1Listener,
                      activeColor: const Color(0xff2F353D),
                      activeTrackColor: const Color(0xff3498DB),
                      onChanged: (value) async{
                        isSwitched1.value = value;
                        await apiBLMUpdateSwitchStatusFamily(memorialId: widget.memorialId, status: value);
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
                    const Expanded(
                      child: ListTile(
                        tileColor: Color(0xffffffff),
                        title: Text('Hide Friends', style: TextStyle(fontSize: 24, fontFamily: 'NexaBold', color: Color(0xff2F353D),),),
                        subtitle: Text('Show or hide friends details', style: TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xffBDC3C7),),),
                      ),
                    ),
                    Switch(
                      value: isSwitched2Listener,
                      activeColor: const Color(0xff2F353D),
                      activeTrackColor: const Color(0xff3498DB),
                      onChanged: (value) async{
                        isSwitched2.value = value;
                        await apiBLMUpdateSwitchStatusFriends(memorialId: widget.memorialId, status: value);
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
                    const Expanded(
                      child: ListTile(
                        tileColor: Color(0xffffffff),
                        title: Text('Hide Followers', style: TextStyle(fontSize: 24, fontFamily: 'NexaBold', color: Color(0xff2F353D),),),
                        subtitle: Text('Show or hide your followers', style: TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xffBDC3C7),),),
                      ),
                    ),
                    Switch(
                      value: isSwitched3Listener,
                      activeColor: const Color(0xff2F353D),
                      activeTrackColor: const Color(0xff3498DB),
                      onChanged: (value) async{
                        isSwitched3.value = value;
                        await apiBLMUpdateSwitchStatusFollowers(memorialId: widget.memorialId, status: value);
                      },
                    ),
                  ],
                ),
              ),

              Container(height: 5, color: const Color(0xffeeeeee),),

              const SizedBox(height: 80),

              const Expanded(child: SizedBox()),

              Image.asset('assets/icons/logo.png', height: 100, width: 100,),

              const SizedBox(height: 10,),
            ],
          ),
        ),
      ),
    );
  }
}