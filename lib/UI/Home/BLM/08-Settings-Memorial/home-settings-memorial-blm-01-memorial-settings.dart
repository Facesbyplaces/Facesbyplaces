import 'package:facesbyplaces/API/BLM/09-Settings-Memorial/api-settings-memorial-blm-06-delete-memorial.dart';
import 'package:facesbyplaces/API/BLM/09-Settings-Memorial/api-settings-memorial-blm-14-update-switch-status-family.dart';
import 'package:facesbyplaces/API/BLM/09-Settings-Memorial/api-settings-memorial-blm-15-update-switch-status-friends.dart';
import 'package:facesbyplaces/API/BLM/09-Settings-Memorial/api-settings-memorial-blm-16-update-switch-status-followers.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-11-blm-setting-detail.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-02-blm-dialog.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'home-settings-memorial-blm-02-page-details.dart';
import 'home-settings-memorial-blm-03-update-memorial-image.dart';
import 'home-settings-memorial-blm-04-page-managers.dart';
import 'home-settings-memorial-blm-05-page-family.dart';
import 'home-settings-memorial-blm-06-page-friends.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:flutter/material.dart';

class HomeBLMMemorialSettings extends StatefulWidget{
  final int memorialId;
  final String memorialName;
  final bool switchFamily;
  final bool switchFriends;
  final bool switchFollowers;
  HomeBLMMemorialSettings({this.memorialId, this.memorialName, this.switchFamily, this.switchFriends, this.switchFollowers});
  
  HomeBLMMemorialSettingsState createState() => HomeBLMMemorialSettingsState(memorialId: memorialId, memorialName: memorialName, switchFamily: switchFamily, switchFriends: switchFriends, switchFollowers: switchFollowers);
}

class HomeBLMMemorialSettingsState extends State<HomeBLMMemorialSettings>{
  final int memorialId;
  final String memorialName;
  final bool switchFamily;
  final bool switchFriends;
  final bool switchFollowers;
  HomeBLMMemorialSettingsState({this.memorialId, this.memorialName, this.switchFamily, this.switchFriends, this.switchFollowers});
  
  int toggle;
  bool isSwitched1;
  bool isSwitched2;
  bool isSwitched3;
  Future switchStatus;

  void initState(){
    super.initState();
    isSwitched1 = switchFamily;
    isSwitched2 = switchFriends;
    isSwitched3 = switchFollowers;
    toggle = 0;
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
      body: ResponsiveWrapper(
        maxWidth: SizeConfig.screenWidth,
        defaultScale: true,
        breakpoints: [
          ResponsiveBreakpoint.resize(480, name: MOBILE),
          ResponsiveBreakpoint.autoScale(800, name: TABLET),
          ResponsiveBreakpoint.resize(1000, name: DESKTOP),
          ResponsiveBreakpoint.autoScale(2460, name: '4K'),
        ],
        child: SingleChildScrollView(
          child: Container(
            height: SizeConfig.screenHeight - kToolbarHeight,
            child: Column(
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

                        Center(child: Text('Privacy',
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
                        case 0: return settingsTab1(memorialId); break;
                        case 1: return settingsTab2(memorialId); break;
                      }
                    }()),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  settingsTab1(int memorialId){
    return ListView(
      physics: ClampingScrollPhysics(),
      children: [

        MiscBLMSettingDetailTemplate(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMPageDetails(memorialId: memorialId,)));
          },
        ),

        Container(height: 5, color: Color(0xffeeeeee),),

        MiscBLMSettingDetailTemplate(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMMemorialPageImage(memorialId: memorialId,)));
          }, 
          titleDetail: 'Page Image', 
          contentDetail: 'Update Page image and background image',
        ),

        Container(height: 5, color: Color(0xffeeeeee),),

        MiscBLMSettingDetailTemplate(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMPageManagers(memorialId: memorialId,)));
          }, 
          titleDetail: 'Admins', 
          contentDetail: 'Add or remove admins of this page',
        ),

        Container(height: 5, color: Color(0xffeeeeee),),

        MiscBLMSettingDetailTemplate(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMPageFamily(memorialId: memorialId,)));
          }, 
          titleDetail: 'Family', 
          contentDetail: 'Add or remove family of this page',
        ),

        Container(height: 5, color: Color(0xffeeeeee),),

        MiscBLMSettingDetailTemplate(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMPageFriends(memorialId: memorialId,)));
          }, 
          titleDetail: 'Friends', 
          contentDetail: 'Add or remove friends of this page',
        ),

        Container(height: 5, color: Color(0xffeeeeee),),

        MiscBLMSettingDetailTemplate(
          onTap: (){
            Navigator.pushNamed(context, '/home/blm/donation-paypal');
          }, 
          titleDetail: 'Paypal', 
          contentDetail: 'Manage cards that receives the memorial gifts.',
        ),

        Container(height: 5, color: Color(0xffeeeeee),),

        MiscBLMSettingDetailTemplate(
          onTap: () async{
            bool confirmResult = await showDialog(context: (context), builder: (build) => MiscBLMConfirmDialog(
              content: 'Are you sure you want to delete "$memorialName"?',
            ),);
            if(confirmResult){

              context.showLoaderOverlay();
              bool result = await apiBLMDeleteMemorial(memorialId: memorialId);
              context.hideLoaderOverlay();

              if(result){
                Navigator.popAndPushNamed(context, '/home/blm');
              }else{
                await showDialog(
                  context: context,
                  builder: (_) => 
                    AssetGiffyDialog(
                    image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                    title: Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                    entryAnimation: EntryAnimation.DEFAULT,
                    description: Text('Something went wrong. Please try again.',
                      textAlign: TextAlign.center,
                      style: TextStyle(),
                    ),
                    onlyOkButton: true,
                    buttonOkColor: Colors.red,
                    onOkButtonPressed: () {
                      Navigator.pop(context, true);
                    },
                  )
                );
              }
            }
          }, 
          titleDetail: 'Delete Page', 
          contentDetail: 'Completely remove the page. This is irreversible',
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

        MiscBLMSettingDetailTemplate(
          onTap: (){}, 
          titleDetail: 'Customize shown info', 
          contentDetail: 'Customize what others see on your page',
        ),

        Container(height: 5, color: Color(0xffeeeeee),),

        Container(
          height: 80,
          color: Color(0xffffffff),
          child: Row(
            children: [
              Expanded(child: MiscBLMSettingDetailTemplate(onTap: (){}, titleDetail: 'Hide Family', contentDetail: 'Show or hide family details'),),

              Switch(
                value: isSwitched1,
                onChanged: (value) async{
                  setState(() {
                    isSwitched1 = value;
                  });

                  context.showLoaderOverlay();
                  await apiBLMUpdateSwitchStatusFamily(memorialId: memorialId, status: value);
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
                child: MiscBLMSettingDetailTemplate(
                  onTap: (){

                  }, 
                  titleDetail: 'Hide Friends', 
                  contentDetail: 'Show or hide friends details',
                ),
              ),


              Switch(
                value: isSwitched2,
                onChanged: (value) async{
                  setState(() {
                    isSwitched2 = value;
                  });

                  context.showLoaderOverlay();
                  await apiBLMUpdateSwitchStatusFriends(memorialId: memorialId, status: value);
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
              Expanded(child: MiscBLMSettingDetailTemplate(onTap: (){}, titleDetail: 'Hide Followers', contentDetail: 'Show or hide your followers'),),

              Switch(
                value: isSwitched3,
                onChanged: (value) async{
                  setState(() {
                    isSwitched3 = value;
                  });

                  context.showLoaderOverlay();
                  await apiBLMUpdateSwitchStatusFollowers(memorialId: memorialId, status: value);
                  context.hideLoaderOverlay();
                },
                activeColor: Color(0xff2F353D),
                activeTrackColor: Color(0xff3498DB),
              ),

            ],
          ),
        ),

        SizedBox(height: 10,),

        Image.asset('assets/icons/logo.png', height: 100, width: 100,),

        SizedBox(height: 30,),

      ],
    );
  }
}

