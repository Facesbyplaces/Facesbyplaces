import 'package:facesbyplaces/API/Regular/09-Settings-Memorial/api-settings-memorial-regular-06-delete-memorial.dart';
import 'package:facesbyplaces/API/Regular/09-Settings-Memorial/api-settings-memorial-regular-14-update-switch-status-family.dart';
import 'package:facesbyplaces/API/Regular/09-Settings-Memorial/api-settings-memorial-regular-15-update-switch-status-friends.dart';
import 'package:facesbyplaces/API/Regular/09-Settings-Memorial/api-settings-memorial-regular-16-update-switch-status-followers.dart';
import 'package:facesbyplaces/UI/Home/Regular/02-View-Memorial/home-view-memorial-regular-01-managed-memorial.dart';
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
  
  HomeRegularMemorialSettingsState createState() => HomeRegularMemorialSettingsState(memorialId: memorialId, memorialName: memorialName, switchFamily: switchFamily, switchFriends: switchFriends, switchFollowers: switchFollowers);
}

class HomeRegularMemorialSettingsState extends State<HomeRegularMemorialSettings>{
  final int memorialId;
  final String memorialName;
  final bool switchFamily;
  final bool switchFriends;
  final bool switchFollowers;

  HomeRegularMemorialSettingsState({required this.memorialId, required this.memorialName, required this.switchFamily, required this.switchFriends, required this.switchFollowers});
  
  int toggle = 0;
  bool isSwitched1 = false;
  bool isSwitched2 = false;
  bool isSwitched3 = false;
  Future<bool>? switchStatus;

  void initState(){
    super.initState();
    isSwitched1 = switchFamily;
    isSwitched2 = switchFriends;
    isSwitched3 = switchFollowers;
  }

  @override
  Widget build(BuildContext context){
    SizeConfig.init(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff04ECFF),
        title: const Text('Memorial Settings', style: const TextStyle(fontSize: 16, color: const Color(0xffffffff),),),
        centerTitle: true,
          leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.pop(context);
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeRegularProfile(memorialId: memorialId, relationship: '', managed: true, newlyCreated: false,)));
          },
        ),
      ),
      body: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            width: SizeConfig.screenWidth,
            height: 70,
            child: DefaultTabController(
              length: 2,
              child: TabBar(
                labelColor: const Color(0xff04ECFF),
                unselectedLabelColor: const Color(0xff000000),
                indicatorColor: const Color(0xff04ECFF),
                onTap: (int index){
                  setState(() {
                    toggle = index;
                  });
                },
                tabs: [
                  const Center(
                    child: const Text('Page',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),

                  const Center(
                    child: const Text('Privacy',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            child: Container(
              child: ((){
                switch(toggle){
                  case 0: return settingsTab1(memorialId);
                  case 1: return settingsTab2(memorialId);
                }
              }()),
            ),
          ),
        ],
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
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularPageDetails(memorialId: memorialId,)));
          },
          title: const Text('Page Details', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xff000000),),),
          subtitle: const Text('Update page details', style: const TextStyle(fontWeight: FontWeight.w300, color: const Color(0xffBDC3C7),),),
        ),

        Container(height: 5, color: const Color(0xffeeeeee),),

        ListTile(
          tileColor: const Color(0xffffffff),
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularMemorialPageImage(memorialId: memorialId,)));
          },
          title: const Text('Page Image', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xff000000),),),
          subtitle: const Text('Update Page image and background image', style: const TextStyle(fontWeight: FontWeight.w300, color: const Color(0xffBDC3C7),),),
        ),

        Container(height: 5, color: const Color(0xffeeeeee),),

        ListTile(
          tileColor: const Color(0xffffffff),
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularPageManagers(memorialId: memorialId,)));
          },
          title: const Text('Admins', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xff000000),),),
          subtitle: const Text('Add or remove admins of this page', style: const TextStyle(fontWeight: FontWeight.w300, color: const Color(0xffBDC3C7),),),
        ),

        Container(height: 5, color: const Color(0xffeeeeee),),

        ListTile(
          tileColor: const Color(0xffffffff),
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularPageFamily(memorialId: memorialId, memorialName: memorialName, switchFamily: switchFamily, switchFriends: switchFriends, switchFollowers: switchFollowers)));
          },
          title: const Text('Family', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xff000000),),),
          subtitle: const Text('Add or remove family of this page', style: const TextStyle(fontWeight: FontWeight.w300, color: const Color(0xffBDC3C7),),),
        ),

        Container(height: 5, color: const Color(0xffeeeeee),),

        ListTile(
          tileColor: const Color(0xffffffff),
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularPageFriends(memorialId: memorialId, memorialName: memorialName, switchFamily: switchFamily, switchFriends: switchFriends, switchFollowers: switchFollowers)));
          },
          title: const Text('Friends', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xff000000),),),
          subtitle: const Text('Add or remove friends of this page', style: const TextStyle(fontWeight: FontWeight.w300, color: const Color(0xffBDC3C7),),),
        ),

        Container(height: 5, color: const Color(0xffeeeeee),),

        ListTile(
          tileColor: const Color(0xffffffff),
          onTap: (){
            Navigator.pushNamed(context, '/home/regular/donation-paypal');
          },
          title: const Text('Paypal', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xff000000),),),
          subtitle: const Text('Manage cards that receives the memorial gifts', style: const TextStyle(fontWeight: FontWeight.w300, color: const Color(0xffBDC3C7),),),
        ),

        Container(height: 5, color: const Color(0xffeeeeee),),

        ListTile(
          tileColor: const Color(0xffffffff),
          onTap: () async{
            bool confirmResult = await showDialog(context: (context), builder: (build) => MiscRegularConfirmDialog(content: 'Are you sure you want to delete "$memorialName"?',),);
            if(confirmResult){

              context.loaderOverlay.show();
              bool result = await apiRegularDeleteMemorial(memorialId: memorialId);
              context.loaderOverlay.hide();

              if(result){
                Navigator.popAndPushNamed(context, '/home/regular');
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
            }
          },
          title: const Text('Delete Page', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xff000000),),),
          subtitle: const Text('Completely remove the page. This is irreversible', style: const TextStyle(fontWeight: FontWeight.w300, color: const Color(0xffBDC3C7),),),
        ),

        const SizedBox(height: 10,),

        Image.asset('assets/icons/logo.png', height: 100, width: 100,),

        const SizedBox(height: 30,),
      ],
    );
  }

  settingsTab2(int memorialId){
    return ListView(
      physics: const ClampingScrollPhysics(),
      children: [

        const ListTile(
          tileColor: const Color(0xffffffff),
          title: const Text('Customize shown info', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xff000000),),),
          subtitle: const Text('Customize what others see on your page', style: const TextStyle(fontWeight: FontWeight.w300, color: const Color(0xffBDC3C7),),),
        ),

        Container(height: 5, color: const Color(0xffeeeeee),),

        Container(
          height: 80,
          color: const Color(0xffffffff),
          child: Row(
            children: [
              Expanded(
                child: const ListTile(
                  tileColor: const Color(0xffffffff),
                  title: const Text('Hide Family', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xff000000),),),
                  subtitle: const Text('Show or hide family details', style: const TextStyle(fontWeight: FontWeight.w300, color: const Color(0xffBDC3C7),),),
                ),
              ),

              Switch(
                value: isSwitched1,
                onChanged: (value) async{
                  setState(() {
                    isSwitched1 = value;
                  });
                  
                  await apiRegularUpdateSwitchStatusFamily(memorialId: memorialId, status: value);
                },
                activeColor: const Color(0xff2F353D),
                activeTrackColor: const Color(0xff3498DB),
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
                child: const ListTile(
                  tileColor: const Color(0xffffffff),
                  title: const Text('Hide Friends', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xff000000),),),
                  subtitle: const Text('Show or hide friends details', style: const TextStyle(fontWeight: FontWeight.w300, color: const Color(0xffBDC3C7),),),
                ),
              ),

              Switch(
                value: isSwitched2,
                onChanged: (value) async{
                  setState(() {
                    isSwitched2 = value;
                  });

                  await apiRegularUpdateSwitchStatusFriends(memorialId: memorialId, status: value);
                },
                activeColor: const Color(0xff2F353D),
                activeTrackColor: const Color(0xff3498DB),
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
                child: const ListTile(
                  tileColor: const Color(0xffffffff),
                  title: const Text('Hide Followers', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xff000000),),),
                  subtitle: const Text('Show or hide your followers', style: const TextStyle(fontWeight: FontWeight.w300, color: const Color(0xffBDC3C7),),),
                ),
              ),

              Switch(
                value: isSwitched3,
                onChanged: (value) async{
                  setState(() {
                    isSwitched3 = value;
                  });

                  await apiRegularUpdateSwitchStatusFollowers(memorialId: memorialId, status: value);
                },
                activeColor: const Color(0xff2F353D),
                activeTrackColor: const Color(0xff3498DB),
              ),
            ],
          ),
        ),

        Container(height: 5, color: const Color(0xffeeeeee),),

        const SizedBox(height: 80),

        Image.asset('assets/icons/logo.png', height: 100, width: 100,),

        const SizedBox(height: 10),
      ],
    );
  }
}