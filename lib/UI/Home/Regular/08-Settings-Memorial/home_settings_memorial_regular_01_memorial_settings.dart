import 'package:facesbyplaces/API/Regular/09-Settings-Memorial/api_settings_memorial_regular_06_delete_memorial.dart';
import 'package:facesbyplaces/API/Regular/09-Settings-Memorial/api_settings_memorial_regular_14_update_switch_status_family.dart';
import 'package:facesbyplaces/API/Regular/09-Settings-Memorial/api_settings_memorial_regular_15_update_switch_status_friends.dart';
import 'package:facesbyplaces/API/Regular/09-Settings-Memorial/api_settings_memorial_regular_16_update_switch_status_followers.dart';
import 'package:facesbyplaces/UI/Home/Regular/02-View-Memorial/home_view_memorial_regular_01_managed_memorial.dart';
import 'package:facesbyplaces/UI/Home/Regular/05-Donate/home_donate_regular_02_paypal_screen.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'home_settings_memorial_regular_02_page_details.dart';
import 'home_settings_memorial_regular_03_update_memorial_image.dart';
import 'home_settings_memorial_regular_04_page_managers.dart';
import 'home_settings_memorial_regular_05_page_family.dart';
import 'home_settings_memorial_regular_06_page_friends.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter/material.dart';
import 'package:dialog/dialog.dart';
import 'package:misc/misc.dart';

class HomeRegularMemorialSettings extends StatefulWidget{
  final int memorialId;
  final String memorialName;
  final bool switchFamily;
  final bool switchFriends;
  final bool switchFollowers;
  const HomeRegularMemorialSettings({Key? key, required this.memorialId, required this.memorialName, required this.switchFamily, required this.switchFriends, required this.switchFollowers}) : super(key: key);

  @override
  HomeRegularMemorialSettingsState createState() => HomeRegularMemorialSettingsState();
}

class HomeRegularMemorialSettingsState extends State<HomeRegularMemorialSettings>{
  ValueNotifier<bool> isSwitched1 = ValueNotifier<bool>(false);
  ValueNotifier<bool> isSwitched2 = ValueNotifier<bool>(false);
  ValueNotifier<bool> isSwitched3 = ValueNotifier<bool>(false);
  ValueNotifier<int> toggle = ValueNotifier<int>(0);
  Future<bool>? switchStatus;

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
            icon: const Icon(Icons.arrow_back, size: 35,),
            onPressed: (){
              Navigator.pop(context);
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeRegularProfile(memorialId: widget.memorialId, relationship: '', managed: true, newlyCreated: false,)));
            },
          ),
        ),
        body: SafeArea(
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
                          child: DefaultTabController(
                            length: 2,
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
                        ),

                        Expanded(
                          child: SizedBox(
                            child: ((){
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
                ),
              );
            }
          ),
        ),
      ),
    );
  }

  settingsTab1(int memorialId){
    return Column(
      children: [
        ListTile(
          title: const Text('Page Details', style: TextStyle(fontSize: 24, fontFamily: 'NexaBold', color: Color(0xff2F353D),),),
          subtitle: const Text('Update page details', style: TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xffBDC3C7),),),
          tileColor: const Color(0xffffffff),          
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularPageDetails(memorialId: memorialId,)));
          },
        ),

        Container(height: 5, color: const Color(0xffeeeeee),),

        ListTile(
          title: const Text('Page Image', style: TextStyle(fontSize: 24, fontFamily: 'NexaBold', color: Color(0xff2F353D),),),
          subtitle: const Text('Update Page image and background image', style: TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xffBDC3C7),),),
          tileColor: const Color(0xffffffff),
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularMemorialPageImage(memorialId: memorialId,)));
          },
        ),

        Container(height: 5, color: const Color(0xffeeeeee),),

        ListTile(
          title: const Text('Admins', style: TextStyle(fontSize: 24, fontFamily: 'NexaBold', color: Color(0xff2F353D),),),
          subtitle: const Text('Add or remove admins of this page', style: TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xffBDC3C7),),),
          tileColor: const Color(0xffffffff),
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularPageManagers(memorialId: memorialId,)));
          },
        ),

        Container(height: 5, color: const Color(0xffeeeeee),),

        ListTile(
          title: const Text('Family', style: TextStyle(fontSize: 24, fontFamily: 'NexaBold', color: Color(0xff2F353D),),),
          subtitle: const Text('Add or remove family of this page', style: TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xffBDC3C7),),),
          tileColor: const Color(0xffffffff),
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularPageFamily(memorialId: memorialId, memorialName: widget.memorialName, switchFamily: widget.switchFamily, switchFriends: widget.switchFriends, switchFollowers: widget.switchFollowers)));
          },
        ),

        Container(height: 5, color: const Color(0xffeeeeee),),

        ListTile(
          title: const Text('Friends', style: TextStyle(fontSize: 24, fontFamily: 'NexaBold', color: Color(0xff2F353D),),),
          subtitle: const Text('Add or remove friends of this page', style: TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xffBDC3C7),),),
          tileColor: const Color(0xffffffff),
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularPageFriends(memorialId: memorialId, memorialName: widget.memorialName, switchFamily: widget.switchFamily, switchFriends: widget.switchFriends, switchFollowers: widget.switchFollowers)));
          },
        ),

        Container(height: 5, color: const Color(0xffeeeeee),),

        ListTile(
          title: const Text('Paypal', style: TextStyle(fontSize: 24, fontFamily: 'NexaBold', color: Color(0xff2F353D),),),
          subtitle: const Text('Manage cards that receives the memorial gifts', style: TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xffBDC3C7),),),
          tileColor: const Color(0xffffffff),
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularPaypal(pageId: memorialId)));
          },
        ),

        Container(height: 5, color: const Color(0xffeeeeee),),

        ListTile(
          title: const Text('Delete Page', style: TextStyle(fontSize: 24, fontFamily: 'NexaBold', color: Color(0xff2F353D),),),
          subtitle: const Text('Completely remove the page. This is irreversible', style: TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xffBDC3C7),),),
          tileColor: const Color(0xffffffff),
          onTap: () async{
            bool confirmResult = await showDialog(context: (context), builder: (build) => MiscConfirmDialog(content: 'Are you sure you want to delete "${widget.memorialName}"?',),);

            if(confirmResult){
              context.loaderOverlay.show();
              bool result = await apiRegularDeleteMemorial(memorialId: memorialId);
              context.loaderOverlay.hide();

              if(result){
                Navigator.popAndPushNamed(context, '/home/regular');
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

        const SizedBox(height: 10,),
        
        const Expanded(child: SizedBox()),

        Image.asset('assets/icons/logo.png', height: 100, width: 100,),

        const SizedBox(height: 30,),
      ],
    );
  }

  settingsTab2(int memorialId){
    return ValueListenableBuilder(
      valueListenable: isSwitched1,
      builder: (_, bool isSwitched1Listener, __) => ValueListenableBuilder(
        valueListenable: isSwitched2,
        builder: (_, bool isSwitched2Listener, __) => ValueListenableBuilder(
          valueListenable: isSwitched3,
          builder: (_, bool isSwitched3Listener, __) => Column(
            children: [
              const ListTile(
                title: Text('Customize shown info', style: TextStyle(fontSize: 24, fontFamily: 'NexaBold', color: Color(0xff2F353D),),),
                subtitle: Text('Customize what others see on your page', style: TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xffBDC3C7),),),
                tileColor: Color(0xffffffff),
              ),

              Container(height: 5, color: const Color(0xffeeeeee),),

              Container(
                height: 80,
                color: const Color(0xffffffff),
                child: Row(
                  children: [
                    const Expanded(
                      child: ListTile(
                        title: Text('Hide Family', style: TextStyle(fontSize: 24, fontFamily: 'NexaBold', color: Color(0xff2F353D),),),
                        subtitle: Text('Show or hide family details', style: TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xffBDC3C7),),),
                        tileColor: Color(0xffffffff),
                      ),
                    ),

                    Switch(
                      activeTrackColor: const Color(0xff3498DB),
                      activeColor: const Color(0xff2F353D),
                      value: isSwitched1Listener,
                      onChanged: (value) async{
                        isSwitched1.value = value;
                        await apiRegularUpdateSwitchStatusFamily(memorialId: memorialId, status: value);
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
                        title: Text('Hide Friends', style: TextStyle(fontSize: 24, fontFamily: 'NexaBold', color: Color(0xff2F353D),),),
                        subtitle: Text('Show or hide friends details', style: TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xffBDC3C7),),),
                        tileColor: Color(0xffffffff),
                      ),
                    ),

                    Switch(
                      activeTrackColor: const Color(0xff3498DB),
                      activeColor: const Color(0xff2F353D),
                      value: isSwitched2Listener,
                      onChanged: (value) async{
                        isSwitched2.value = value;
                        await apiRegularUpdateSwitchStatusFriends(memorialId: memorialId, status: value);
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
                        title: Text('Hide Followers', style: TextStyle(fontSize: 24, fontFamily: 'NexaBold', color: Color(0xff2F353D),),),
                        subtitle: Text('Show or hide your followers', style: TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xffBDC3C7),),),
                        tileColor: Color(0xffffffff),
                      ),
                    ),
                    
                    Switch(
                      activeTrackColor: const Color(0xff3498DB),
                      activeColor: const Color(0xff2F353D),
                      value: isSwitched3Listener,
                      onChanged: (value) async{
                        isSwitched3.value = value;
                        await apiRegularUpdateSwitchStatusFollowers(memorialId: memorialId, status: value);
                      },                      
                    ),
                  ],
                ),
              ),

              Container(height: 5, color: const Color(0xffeeeeee),),

              const SizedBox(height: 80),

              Expanded(child: Container()),

              Image.asset('assets/icons/logo.png', height: 100, width: 100,),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}