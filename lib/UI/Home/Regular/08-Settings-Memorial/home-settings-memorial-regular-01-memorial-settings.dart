// ignore_for_file: file_names
import 'package:facesbyplaces/API/Regular/09-Settings-Memorial/api-settings-memorial-regular-06-delete-memorial.dart';
import 'package:facesbyplaces/API/Regular/09-Settings-Memorial/api-settings-memorial-regular-14-update-switch-status-family.dart';
import 'package:facesbyplaces/API/Regular/09-Settings-Memorial/api-settings-memorial-regular-15-update-switch-status-friends.dart';
import 'package:facesbyplaces/API/Regular/09-Settings-Memorial/api-settings-memorial-regular-16-update-switch-status-followers.dart';
import 'package:facesbyplaces/UI/Home/Regular/02-View-Memorial/home-view-memorial-regular-01-managed-memorial.dart';
import 'package:facesbyplaces/UI/Home/Regular/05-Donate/home-donate-regular-02-paypal-screen.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-02-regular-dialog.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'home-settings-memorial-regular-02-page-details.dart';
import 'home-settings-memorial-regular-03-update-memorial-image.dart';
import 'home-settings-memorial-regular-04-page-managers.dart';
import 'home-settings-memorial-regular-05-page-family.dart';
import 'home-settings-memorial-regular-06-page-friends.dart';
import 'package:loader_overlay/loader_overlay.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:flutter/material.dart';

class HomeRegularMemorialSettings extends StatefulWidget{
  final int memorialId;
  final String memorialName;
  final bool switchFamily;
  final bool switchFriends;
  final bool switchFollowers;
  const HomeRegularMemorialSettings({required this.memorialId, required this.memorialName, required this.switchFamily, required this.switchFriends, required this.switchFollowers});

  HomeRegularMemorialSettingsState createState() => HomeRegularMemorialSettingsState();
}

class HomeRegularMemorialSettingsState extends State<HomeRegularMemorialSettings>{
  ValueNotifier<bool> isSwitched1 = ValueNotifier<bool>(false);
  ValueNotifier<bool> isSwitched2 = ValueNotifier<bool>(false);
  ValueNotifier<bool> isSwitched3 = ValueNotifier<bool>(false);
  ValueNotifier<int> toggle = ValueNotifier<int>(0);
  Future<bool>? switchStatus;

  void initState(){
    super.initState();
    isSwitched1.value = widget.switchFamily;
    isSwitched2.value = widget.switchFriends;
    isSwitched3.value = widget.switchFollowers;
  }

  @override
  Widget build(BuildContext context){
    SizeConfig.init(context);
    print('Memorial settings rebuild!');
    return ValueListenableBuilder(
      valueListenable: toggle,
      builder: (_, int toggleListener, __) => Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff04ECFF),
          title: const Text('Memorial Settings', style: const TextStyle(fontSize: 26, fontFamily: 'NexaRegular', color: const Color(0xffffffff),),),
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
                        Container(
                          height: 70,
                          child: DefaultTabController(
                            length: 2,
                            child: TabBar(
                              labelColor: const Color(0xff04ECFF),
                              unselectedLabelColor: const Color(0xff000000),
                              indicatorColor: const Color(0xff04ECFF),
                              indicatorSize: TabBarIndicatorSize.label,
                              tabs: [
                                const Text('Page', style: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: const Color(0xff2F353D),),),

                                const Text('Privacy', style: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: const Color(0xff2F353D)),),
                              ],
                              onTap: (int index){
                                toggle.value = index;
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
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
          title: const Text('Page Details', style: const TextStyle(fontSize: 24, fontFamily: 'NexaBold', color: const Color(0xff2F353D),),),
          subtitle: const Text('Update page details', style: const TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: const Color(0xffBDC3C7),),),
          tileColor: const Color(0xffffffff),          
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularPageDetails(memorialId: memorialId,)));
          },
        ),

        Container(height: 5, color: const Color(0xffeeeeee),),

        ListTile(
          title: const Text('Page Image', style: const TextStyle(fontSize: 24, fontFamily: 'NexaBold', color: const Color(0xff2F353D),),),
          subtitle: const Text('Update Page image and background image', style: const TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: const Color(0xffBDC3C7),),),
          tileColor: const Color(0xffffffff),
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularMemorialPageImage(memorialId: memorialId,)));
          },
        ),

        Container(height: 5, color: const Color(0xffeeeeee),),

        ListTile(
          title: const Text('Admins', style: const TextStyle(fontSize: 24, fontFamily: 'NexaBold', color: const Color(0xff2F353D),),),
          subtitle: const Text('Add or remove admins of this page', style: const TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: const Color(0xffBDC3C7),),),
          tileColor: const Color(0xffffffff),
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularPageManagers(memorialId: memorialId,)));
          },
        ),

        Container(height: 5, color: const Color(0xffeeeeee),),

        ListTile(
          title: const Text('Family', style: const TextStyle(fontSize: 24, fontFamily: 'NexaBold', color: const Color(0xff2F353D),),),
          subtitle: const Text('Add or remove family of this page', style: const TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: const Color(0xffBDC3C7),),),
          tileColor: const Color(0xffffffff),
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularPageFamily(memorialId: memorialId, memorialName: widget.memorialName, switchFamily: widget.switchFamily, switchFriends: widget.switchFriends, switchFollowers: widget.switchFollowers)));
          },
        ),

        Container(height: 5, color: const Color(0xffeeeeee),),

        ListTile(
          title: const Text('Friends', style: const TextStyle(fontSize: 24, fontFamily: 'NexaBold', color: const Color(0xff2F353D),),),
          subtitle: const Text('Add or remove friends of this page', style: const TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: const Color(0xffBDC3C7),),),
          tileColor: const Color(0xffffffff),
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularPageFriends(memorialId: memorialId, memorialName: widget.memorialName, switchFamily: widget.switchFamily, switchFriends: widget.switchFriends, switchFollowers: widget.switchFollowers)));
          },
        ),

        Container(height: 5, color: const Color(0xffeeeeee),),

        ListTile(
          title: const Text('Paypal', style: const TextStyle(fontSize: 24, fontFamily: 'NexaBold', color: const Color(0xff2F353D),),),
          subtitle: const Text('Manage cards that receives the memorial gifts', style: const TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: const Color(0xffBDC3C7),),),
          tileColor: const Color(0xffffffff),
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularPaypal(pageId: memorialId)));
          },
        ),

        Container(height: 5, color: const Color(0xffeeeeee),),

        ListTile(
          title: const Text('Delete Page', style: const TextStyle(fontSize: 24, fontFamily: 'NexaBold', color: const Color(0xff2F353D),),),
          subtitle: const Text('Completely remove the page. This is irreversible', style: const TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: const Color(0xffBDC3C7),),),
          tileColor: const Color(0xffffffff),
          onTap: () async{
            bool confirmResult = await showDialog(context: (context), builder: (build) => MiscRegularConfirmDialog(content: 'Are you sure you want to delete "${widget.memorialName}"?',),);

            if(confirmResult){
              context.loaderOverlay.show();
              bool result = await apiRegularDeleteMemorial(memorialId: memorialId);
              context.loaderOverlay.hide();

              if(result){
                Navigator.popAndPushNamed(context, '/home/regular');
              }else{
                await showDialog(
                  context: context,
                  builder: (_) => AssetGiffyDialog(
                    title: const Text('Error', textAlign: TextAlign.center, style: const TextStyle(fontSize: 32, fontFamily: 'NexaRegular'),),
                    description: const Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: const TextStyle(fontSize: 24, fontFamily: 'NexaRegular',),),
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
            }
          },
        ),

        Container(height: 5, color: const Color(0xffeeeeee),),

        const SizedBox(height: 10,),
        
        Expanded(child: Container()),

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
              ListTile(
                title: const Text('Customize shown info', style: const TextStyle(fontSize: 24, fontFamily: 'NexaBold', color: const Color(0xff2F353D),),),
                subtitle: const Text('Customize what others see on your page', style: const TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: const Color(0xffBDC3C7),),),
                tileColor: const Color(0xffffffff),
              ),

              Container(height: 5, color: const Color(0xffeeeeee),),

              Container(
                height: 80,
                color: const Color(0xffffffff),
                child: Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        title: const Text('Hide Family', style: const TextStyle(fontSize: 24, fontFamily: 'NexaBold', color: const Color(0xff2F353D),),),
                        subtitle: const Text('Show or hide family details', style: const TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: const Color(0xffBDC3C7),),),
                        tileColor: const Color(0xffffffff),
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
                    Expanded(
                      child: ListTile(
                        title: const Text('Hide Friends', style: const TextStyle(fontSize: 24, fontFamily: 'NexaBold', color: const Color(0xff2F353D),),),
                        subtitle: const Text('Show or hide friends details', style: const TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: const Color(0xffBDC3C7),),),
                        tileColor: const Color(0xffffffff),
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
                    Expanded(
                      child: ListTile(
                        title: const Text('Hide Followers', style: const TextStyle(fontSize: 24, fontFamily: 'NexaBold', color: const Color(0xff2F353D),),),
                        subtitle: const Text('Show or hide your followers', style: const TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: const Color(0xffBDC3C7),),),
                        tileColor: const Color(0xffffffff),
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