import 'package:facesbyplaces/API/Regular/02-Main/api-main-regular-04-02-01-leave-page.dart';
import 'package:facesbyplaces/API/Regular/09-Settings-Memorial/api-settings-memorial-regular-17-set-relationship.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-02-regular-dialog.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-12-regular-setting-detail.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class HomeRegularMemorialSettingsWithHidden extends StatefulWidget{
  final int memorialId;
  final String relationship;
  HomeRegularMemorialSettingsWithHidden({this.memorialId, this.relationship});
  
  HomeRegularMemorialSettingsWithHiddenState createState() => HomeRegularMemorialSettingsWithHiddenState(memorialId: memorialId, relationship: relationship);
}

class HomeRegularMemorialSettingsWithHiddenState extends State<HomeRegularMemorialSettingsWithHidden>{
  final int memorialId;
  final String relationship;
  HomeRegularMemorialSettingsWithHiddenState({this.memorialId, this.relationship});
  
  int toggle;
  bool isSwitched1;
  bool isSwitched2;
  bool isSwitched3;
  Future switchStatus;

  void initState(){
    super.initState();
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
        child: Container(
          height: SizeConfig.screenHeight - kToolbarHeight,
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                width: SizeConfig.screenWidth,
                height: SizeConfig.blockSizeVertical * 8,
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
    );
  }

  settingsTab1(int memorialId){
    return ListView(
      physics: ClampingScrollPhysics(),
      children: [

        MiscRegularSettingDetailTemplate(
          backgroundColor: Color(0xffaaaaaa),
          onTap: (){
            
          },
        ),

        Container(height: SizeConfig.blockSizeVertical * .5, color: Color(0xffeeeeee),),

        MiscRegularSettingDetailTemplate(
          backgroundColor: Color(0xffaaaaaa),
          onTap: (){
            
          }, 
          titleDetail: 'Page Image', 
          contentDetail: 'Update Page image and background image',
        ),

        Container(height: SizeConfig.blockSizeVertical * .5, color: Color(0xffeeeeee),),

        MiscRegularSettingDetailTemplate(
          backgroundColor: Color(0xffaaaaaa),
          onTap: (){
            
          }, 
          titleDetail: 'Admins', 
          contentDetail: 'Add or remove admins of this page',
        ),

        Container(height: SizeConfig.blockSizeVertical * .5, color: Color(0xffeeeeee),),

        MiscRegularSettingDetailTemplate(
          backgroundColor: Color(0xffaaaaaa),
          onTap: (){
          }, 
          titleDetail: 'Family', 
          contentDetail: 'Add or remove family of this page',
        ),

        Container(height: SizeConfig.blockSizeVertical * .5, color: Color(0xffeeeeee),),

        MiscRegularSettingDetailTemplate(
          backgroundColor: Color(0xffaaaaaa),
          onTap: (){
          }, 
          titleDetail: 'Friends', 
          contentDetail: 'Add or remove friends of this page',
        ),

        Container(height: SizeConfig.blockSizeVertical * .5, color: Color(0xffeeeeee),),

        relationship != 'Friend'
        ? MiscRegularSettingDetailTemplate(
          onTap: () async{
            String choice = await showDialog(context: (context), builder: (build) => MiscRegularRelationshipFromDialog());

            if(choice != null){
              bool result = await apiRegularMemorialSetRelationship(memorialId: memorialId, relationship: choice);

              if(result == true){
                await showDialog(
                  context: context,
                  builder: (_) => 
                    AssetGiffyDialog(
                    image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                    title: Text('Success', textAlign: TextAlign.center, style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                    entryAnimation: EntryAnimation.DEFAULT,
                    description: Text('Successfully updated the relationship setting.',
                      textAlign: TextAlign.center,
                      style: TextStyle(),
                    ),
                    onlyOkButton: true,
                    buttonOkColor: Colors.green,
                    onOkButtonPressed: () {
                      Navigator.pop(context, true);
                    },
                  )
                );
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
          titleDetail: 'Relationship',
          contentDetail: 'Set your relationship for this page',
        )
        : MiscRegularSettingDetailTemplate(
          onTap: () async{
            bool confirmResult = await showDialog(context: (context), builder: (build) => MiscRegularConfirmDialog(title: 'Leave page', content: 'Are you sure you want to leave this page?',),);
            if(confirmResult){

              context.showLoaderOverlay();
              bool result = await apiRegularLeavePage(memorialId: memorialId);
              context.hideLoaderOverlay();

              if(result){
                Navigator.popAndPushNamed(context, '/home/regular');
              }else{
                // await showDialog(context: (context), builder: (build) => MiscRegularAlertDialog(title: 'Error', content: 'Something went wrong. Please try again.'));
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
          titleDetail: 'Leave Page',
          contentDetail: 'Leave this page',
        ),

        Container(height: SizeConfig.blockSizeVertical * .5, color: Color(0xffeeeeee),),

        MiscRegularSettingDetailTemplate(
          backgroundColor: Color(0xffaaaaaa),
          onTap: (){
          }, 
          titleDetail: 'Paypal', 
          contentDetail: 'Manage cards that receives the memorial gifts.',
        ),

        Container(height: SizeConfig.blockSizeVertical * .5, color: Color(0xffeeeeee),),

        MiscRegularSettingDetailTemplate(
          backgroundColor: Color(0xffaaaaaa),
          onTap: () async{
          }, 
          titleDetail: 'Delete Page', 
          contentDetail: 'Completely remove the page. This is irreversible',
        ),

        SizedBox(height: SizeConfig.blockSizeVertical * 5,),

        Container(height: SizeConfig.blockSizeVertical * 10, child: Image.asset('assets/icons/logo.png'),),

        SizedBox(height: SizeConfig.blockSizeVertical * 1,),

      ],
    );
  }

  settingsTab2(int memorialId){
    return ListView(
      physics: ClampingScrollPhysics(),
      children: [

        MiscRegularSettingDetailTemplate(
          backgroundColor: Color(0xffaaaaaa),
          onTap: (){}, 
          titleDetail: 'Customize shown info', 
          contentDetail: 'Customize what others see on your page',
        ),

        Container(height: SizeConfig.blockSizeVertical * .5, color: Color(0xffeeeeee),),

        Container(
          height: SizeConfig.blockSizeVertical * 10,
          color: Color(0xffaaaaaa),
          child: Row(
            children: [
              Expanded(
                child: MiscRegularSettingDetailTemplate(
                  backgroundColor: Color(0xffaaaaaa),
                  onTap: (){}, 
                  titleDetail: 'Hide Family', 
                  contentDetail: 'Show or hide family details',
                ),
              ),

              Switch(
                value: false,
                onChanged: (value) async{

                },
                activeColor: Color(0xff2F353D),
                activeTrackColor: Color(0xff3498DB),
              ),
            ],
          ),
        ),

        Container(height: SizeConfig.blockSizeVertical * .5, color: Color(0xffeeeeee),),

        Container(
          height: SizeConfig.blockSizeVertical * 10,
          color: Color(0xffaaaaaa),
          child: Row(
            children: [
              Expanded(
                child: MiscRegularSettingDetailTemplate(
                  backgroundColor: Color(0xffaaaaaa),
                  onTap: (){

                  }, 
                  titleDetail: 'Hide Friends', 
                  contentDetail: 'Show or hide friends details',
                ),
              ),


              Switch(
                value: false,
                onChanged: (value) async{

                },
                activeColor: Color(0xff2F353D),
                activeTrackColor: Color(0xff3498DB),
              ),

            ],
          ),
        ),

        Container(height: SizeConfig.blockSizeVertical * .5, color: Color(0xffeeeeee),),

        Container(
          height: SizeConfig.blockSizeVertical * 10,
          color: Color(0xffaaaaaa),
          child: Row(
            children: [
              Expanded(child: MiscRegularSettingDetailTemplate(
                backgroundColor: Color(0xffaaaaaa),
                onTap: (){}, 
                titleDetail: 'Hide Followers', 
                contentDetail: 'Show or hide your followers'),
              ),

              Switch(
                value: false,
                onChanged: (value) async{

                },
                activeColor: Color(0xff2F353D),
                activeTrackColor: Color(0xff3498DB),
              ),

            ],
          ),
        ),

        Container(height: SizeConfig.blockSizeVertical * .5, color: Color(0xffeeeeee),),

        SizedBox(height: SizeConfig.blockSizeVertical * 5,),

        Container(height: SizeConfig.blockSizeVertical * 10, child: Image.asset('assets/icons/logo.png'),),

        SizedBox(height: SizeConfig.blockSizeVertical * 1,),

      ],
    );
  }
}

