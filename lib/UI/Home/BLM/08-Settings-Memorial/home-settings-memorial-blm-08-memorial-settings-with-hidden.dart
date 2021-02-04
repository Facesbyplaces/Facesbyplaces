import 'package:facesbyplaces/API/BLM/09-Settings-Memorial/api-settings-memorial-blm-17-set-relationship.dart';
import 'package:facesbyplaces/API/BLM/02-Main/api-main-blm-04-02-01-leave-page.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-02-blm-dialog.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-12-blm-setting-detail.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:flutter/material.dart';

class HomeBLMMemorialSettingsWithHidden extends StatefulWidget{
  final int memorialId;
  final String relationship;
  HomeBLMMemorialSettingsWithHidden({this.memorialId, this.relationship});
  
  HomeBLMMemorialSettingsWithHiddenState createState() => HomeBLMMemorialSettingsWithHiddenState(memorialId: memorialId, relationship: relationship);
}

class HomeBLMMemorialSettingsWithHiddenState extends State<HomeBLMMemorialSettingsWithHidden>{
  final int memorialId;
  final String relationship;
  HomeBLMMemorialSettingsWithHiddenState({this.memorialId, this.relationship});
  
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
        title:  Text('Memorial Settings', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xffffffff),),),
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
                        fontSize: SizeConfig.safeBlockHorizontal * 4,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),

                  Center(child: Text('Privacy',
                      style: TextStyle(
                        fontSize: SizeConfig.safeBlockHorizontal * 4,
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
    );
  }

  settingsTab1(int memorialId){
    return ListView(
      physics: ClampingScrollPhysics(),
      children: [

        MiscBLMSettingDetailTemplate(
          backgroundColor: Color(0xffaaaaaa),
          onTap: (){
            
          },
        ),

        Container(height: SizeConfig.blockSizeVertical * .5, color: Color(0xffeeeeee),),

        MiscBLMSettingDetailTemplate(
          backgroundColor: Color(0xffaaaaaa),
          onTap: (){
            
          }, 
          titleDetail: 'Page Image', 
          contentDetail: 'Update Page image and background image',
        ),

        Container(height: SizeConfig.blockSizeVertical * .5, color: Color(0xffeeeeee),),

        MiscBLMSettingDetailTemplate(
          backgroundColor: Color(0xffaaaaaa),
          onTap: (){
            
          }, 
          titleDetail: 'Admins', 
          contentDetail: 'Add or remove admins of this page',
        ),

        Container(height: SizeConfig.blockSizeVertical * .5, color: Color(0xffeeeeee),),

        MiscBLMSettingDetailTemplate(
          backgroundColor: Color(0xffaaaaaa),
          onTap: (){
          }, 
          titleDetail: 'Family', 
          contentDetail: 'Add or remove family of this page',
        ),

        Container(height: SizeConfig.blockSizeVertical * .5, color: Color(0xffeeeeee),),

        MiscBLMSettingDetailTemplate(
          backgroundColor: Color(0xffaaaaaa),
          onTap: (){
          }, 
          titleDetail: 'Friends', 
          contentDetail: 'Add or remove friends of this page',
        ),

        Container(height: SizeConfig.blockSizeVertical * .5, color: Color(0xffeeeeee),),

        relationship != 'Friend'
        ? MiscBLMSettingDetailTemplate(
          onTap: () async{
            String choice = await showDialog(context: (context), builder: (build) => MiscBLMRelationshipFromDialog());

            if(choice != null){
              bool result = await apiBLMMemorialSetRelationship(memorialId: memorialId, relationship: choice);

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
        : MiscBLMSettingDetailTemplate(
          onTap: () async{
            bool confirmResult = await showDialog(context: (context), builder: (build) => MiscBLMConfirmDialog(title: 'Leave page', content: 'Are you sure you want to leave this page?',),);
            if(confirmResult){

              context.showLoaderOverlay();
              bool result = await apiBLMLeavePage(memorialId: memorialId);
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
          titleDetail: 'Leave Page',
          contentDetail: 'Leave this page',
        ),

        Container(height: SizeConfig.blockSizeVertical * .5, color: Color(0xffeeeeee),),

        MiscBLMSettingDetailTemplate(
          backgroundColor: Color(0xffaaaaaa),
          onTap: (){
          }, 
          titleDetail: 'Paypal', 
          contentDetail: 'Manage cards that receives the memorial gifts.',
        ),

        Container(height: SizeConfig.blockSizeVertical * .5, color: Color(0xffeeeeee),),

        MiscBLMSettingDetailTemplate(
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

        MiscBLMSettingDetailTemplate(
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
                child: MiscBLMSettingDetailTemplate(
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
                child: MiscBLMSettingDetailTemplate(
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
              Expanded(child: MiscBLMSettingDetailTemplate(
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

