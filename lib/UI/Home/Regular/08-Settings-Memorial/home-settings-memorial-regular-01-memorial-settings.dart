import 'package:facesbyplaces/API/Regular/09-Settings-Memorial/api-settings-memorial-regular-06-delete-memorial.dart';
import 'package:facesbyplaces/API/Regular/09-Settings-Memorial/api-settings-memorial-regular-14-update-switch-status-family.dart';
import 'package:facesbyplaces/API/Regular/09-Settings-Memorial/api-settings-memorial-regular-15-update-switch-status-friends.dart';
import 'package:facesbyplaces/API/Regular/09-Settings-Memorial/api-settings-memorial-regular-16-update-switch-status-followers.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-02-regular-dialog.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-11-regular-setting-detail.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'home-settings-memorial-regular-02-page-details.dart';
import 'home-settings-memorial-regular-03-update-memorial-image.dart';
import 'home-settings-memorial-regular-04-page-managers.dart';
import 'home-settings-memorial-regular-05-page-family.dart';
import 'home-settings-memorial-regular-06-page-friends.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter/material.dart';

class HomeRegularMemorialSettings extends StatefulWidget{
  final int memorialId;
  final String memorialName;
  final bool switchFamily;
  final bool switchFriends;
  final bool switchFollowers;
  HomeRegularMemorialSettings({required this.memorialId, required this.memorialName, required this.switchFamily, required this.switchFriends, required this.switchFollowers});
  
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
        backgroundColor: Color(0xff04ECFF),
        title:  Text('Memorial Settings', style: TextStyle(fontSize: 16, color: Color(0xffffffff),),),
        centerTitle: true,
          leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.pop(context);
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
                labelColor: Color(0xff04ECFF),
                unselectedLabelColor: Color(0xff000000),
                indicatorColor: Color(0xff04ECFF),
                onTap: (int index){
                  setState(() {
                    toggle = index;
                  });
                },
                tabs: [

                  Center(
                    child: Text('Page',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),

                  Center(
                    child: Text('Privacy',
                      style: TextStyle(
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
      physics: ClampingScrollPhysics(),
      children: [

        ListTile(
          tileColor: Color(0xffffffff),
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularPageDetails(memorialId: memorialId,)));
          },
          title: Text('Page Details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xff000000),),),
          subtitle: Text('Update page details', style: TextStyle(fontWeight: FontWeight.w300, color: Color(0xffBDC3C7),),),
        ),

        Container(height: 5, color: Color(0xffeeeeee),),

        ListTile(
          tileColor: Color(0xffffffff),
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularMemorialPageImage(memorialId: memorialId,)));
          },
          title: Text('Page Image', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xff000000),),),
          subtitle: Text('Update Page image and background image', style: TextStyle(fontWeight: FontWeight.w300, color: Color(0xffBDC3C7),),),
        ),

        Container(height: 5, color: Color(0xffeeeeee),),

        ListTile(
          tileColor: Color(0xffffffff),
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularPageManagers(memorialId: memorialId,)));
          },
          title: Text('Admins', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xff000000),),),
          subtitle: Text('Add or remove admins of this page', style: TextStyle(fontWeight: FontWeight.w300, color: Color(0xffBDC3C7),),),
        ),

        Container(height: 5, color: Color(0xffeeeeee),),

        ListTile(
          tileColor: Color(0xffffffff),
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularPageFamily(memorialId: memorialId,)));
          },
          title: Text('Family', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xff000000),),),
          subtitle: Text('Add or remove family of this page', style: TextStyle(fontWeight: FontWeight.w300, color: Color(0xffBDC3C7),),),
        ),

        Container(height: 5, color: Color(0xffeeeeee),),

        ListTile(
          tileColor: Color(0xffffffff),
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularPageFriends(memorialId: memorialId,)));
          },
          title: Text('Friends', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xff000000),),),
          subtitle: Text('Add or remove friends of this page', style: TextStyle(fontWeight: FontWeight.w300, color: Color(0xffBDC3C7),),),
        ),

        Container(height: 5, color: Color(0xffeeeeee),),

        ListTile(
          tileColor: Color(0xffffffff),
          onTap: (){
            Navigator.pushNamed(context, '/home/regular/donation-paypal');
          },
          title: Text('Paypal', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xff000000),),),
          subtitle: Text('Manage cards that receives the memorial gifts', style: TextStyle(fontWeight: FontWeight.w300, color: Color(0xffBDC3C7),),),
        ),

        Container(height: 5, color: Color(0xffeeeeee),),

        ListTile(
          tileColor: Color(0xffffffff),
          onTap: () async{
            bool confirmResult = await showDialog(context: (context), builder: (build) => MiscRegularConfirmDialog(content: 'Are you sure you want to delete "$memorialName"?',),);
            if(confirmResult){

              context.showLoaderOverlay();
              bool result = await apiRegularDeleteMemorial(memorialId: memorialId);
              context.hideLoaderOverlay();

              if(result){
                Navigator.popAndPushNamed(context, '/home/regular');
              }else{
                await showOkAlertDialog(
                  context: context,
                  title: 'Error',
                  message: 'Something went wrong. Please try again.'
                );
              }
            }
          },
          title: Text('Delete Page', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xff000000),),),
          subtitle: Text('Completely remove the page. This is irreversible', style: TextStyle(fontWeight: FontWeight.w300, color: Color(0xffBDC3C7),),),
        ),

        SizedBox(height: 10,),

        Image.asset('assets/icons/logo.png', height: 100, width: 100,),

        SizedBox(height: 30,),

      ],
    );
  }

  settingsTab2(int memorialId){
    return ListView(
      physics: ClampingScrollPhysics(),
      children: [

        ListTile(
          tileColor: Color(0xffffffff),
          title: Text('Customize shown info', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xff000000),),),
          subtitle: Text('Customize what others see on your page', style: TextStyle(fontWeight: FontWeight.w300, color: Color(0xffBDC3C7),),),
        ),

        // MiscRegularSettingDetailTemplate(
        //   onTap: (){}, 
        //   titleDetail: 'Customize shown info', 
        //   contentDetail: 'Customize what others see on your page',
        // ),

        Container(height: 5, color: Color(0xffeeeeee),),

        Container(
          height: 80,
          color: Color(0xffffffff),
          child: Row(
            children: [
              Expanded(
                child: ListTile(
                  tileColor: Color(0xffffffff),
                  title: Text('Hide Family', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xff000000),),),
                  subtitle: Text('Show or hide family details', style: TextStyle(fontWeight: FontWeight.w300, color: Color(0xffBDC3C7),),),
                ),
              ),

              Switch(
                value: isSwitched1,
                onChanged: (value) async{
                  setState(() {
                    isSwitched1 = value;
                  });
                  
                  context.showLoaderOverlay();      
                  await apiRegularUpdateSwitchStatusFamily(memorialId: memorialId, status: value);
                  context.hideLoaderOverlay();
                },
                activeColor: Color(0xff2F353D),
                activeTrackColor: Color(0xff3498DB),
              ),
            ],
          ),
        ),

        Container(height: 5, color: Color(0xffeeeeee),),

        Container(
          height: 80,
          color: Color(0xffffffff),
          child: Row(
            children: [
              Expanded(
                child: ListTile(
                  tileColor: Color(0xffffffff),
                  title: Text('Hide Friends', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xff000000),),),
                  subtitle: Text('Show or hide friends details', style: TextStyle(fontWeight: FontWeight.w300, color: Color(0xffBDC3C7),),),
                ),
                // child: MiscRegularSettingDetailTemplate(
                //   onTap: (){

                //   }, 
                //   titleDetail: 'Hide Friends', 
                //   contentDetail: 'Show or hide friends details',
                // ),
              ),


              Switch(
                value: isSwitched2,
                onChanged: (value) async{
                  setState(() {
                    isSwitched2 = value;
                  });

                  context.showLoaderOverlay();
                  await apiRegularUpdateSwitchStatusFriends(memorialId: memorialId, status: value);
                  context.hideLoaderOverlay();
                },
                activeColor: Color(0xff2F353D),
                activeTrackColor: Color(0xff3498DB),
              ),

            ],
          ),
        ),

        Container(height: 5, color: Color(0xffeeeeee),),

        Container(
          height: 80,
          color: Color(0xffffffff),
          child: Row(
            children: [
              Expanded(
                child: ListTile(
                  tileColor: Color(0xffffffff),
                  title: Text('Hide Followers', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xff000000),),),
                  subtitle: Text('Show or hide your followers', style: TextStyle(fontWeight: FontWeight.w300, color: Color(0xffBDC3C7),),),
                ),
                // child: MiscRegularSettingDetailTemplate(
                //   onTap: (){}, 
                //   titleDetail: 'Hide Followers', 
                //   contentDetail: 'Show or hide your followers'
                // ),
              ),

              Switch(
                value: isSwitched3,
                onChanged: (value) async{
                  setState(() {
                    isSwitched3 = value;
                  });

                  context.showLoaderOverlay();
                  await apiRegularUpdateSwitchStatusFollowers(memorialId: memorialId, status: value);
                  context.hideLoaderOverlay();
                },
                activeColor: Color(0xff2F353D),
                activeTrackColor: Color(0xff3498DB),
              ),

            ],
          ),
        ),

        Container(height: 5, color: Color(0xffeeeeee),),

        SizedBox(height: 80),

        Image.asset('assets/icons/logo.png', height: 100, width: 100,),

        SizedBox(height: 10),

      ],
    );
  }
}

