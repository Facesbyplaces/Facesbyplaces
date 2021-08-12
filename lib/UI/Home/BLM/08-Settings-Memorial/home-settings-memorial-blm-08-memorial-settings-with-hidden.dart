import 'package:facesbyplaces/API/BLM/09-Settings-Memorial/api-settings-memorial-blm-17-set-relationship.dart';
import 'package:facesbyplaces/API/BLM/02-Main/api-main-blm-04-02-01-leave-page.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-02-blm-dialog.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:loader_overlay/loader_overlay.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:flutter/material.dart';

class HomeBLMMemorialSettingsWithHidden extends StatefulWidget{
  final int memorialId;
  final String relationship;
  const HomeBLMMemorialSettingsWithHidden({required this.memorialId, required this.relationship});
  
  HomeBLMMemorialSettingsWithHiddenState createState() => HomeBLMMemorialSettingsWithHiddenState();
}

class HomeBLMMemorialSettingsWithHiddenState extends State<HomeBLMMemorialSettingsWithHidden>{
  ValueNotifier<int> toggle = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context){
    SizeConfig.init(context);
    return ValueListenableBuilder(
      valueListenable: toggle,
      builder: (_, int toggleListener, __) => Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff04ECFF),
          title: const Text('Memorial Settings', style: const TextStyle(fontSize: 16, color: const Color(0xffffffff),),),
          centerTitle: true,
            leading: IconButton(
            icon: const Icon(Icons.arrow_back),
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
                  unselectedLabelColor: const Color(0xff000000),
                  indicatorColor: const Color(0xff04ECFF),
                  labelColor: const Color(0xff04ECFF),
                  onTap: (int index){
                    toggle.value = index;
                  },
                  tabs: [
                    const Center(child: const Text('Page', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400,),),),

                    const Center(child: const Text('Privacy', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400,),),),
                  ],
                ),
              ),
            ),

            Expanded(
              child: Container(
                child: ((){
                  switch(toggleListener){
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
        const ListTile(
          tileColor: const Color(0xffaaaaaa),
          title: const Text('Page Details', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xff000000),),),
          subtitle: const Text('Update page details', style: const TextStyle(fontWeight: FontWeight.w300, color: const Color(0xffBDC3C7),),),
        ),

        Container(height: 5, color: const Color(0xffeeeeee),),

        const ListTile(
          tileColor: const Color(0xffaaaaaa),
          title: const Text('Page Image', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xff000000),),),
          subtitle: const Text('Update Page image and background image', style: const TextStyle(fontWeight: FontWeight.w300, color: const Color(0xffBDC3C7),),),
        ),

        Container(height: 5, color: const Color(0xffeeeeee),),

        const ListTile(
          tileColor: const Color(0xffaaaaaa),
          title: const Text('Admins', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xff000000),),),
          subtitle: const Text('Add or remove admins of this page', style: const TextStyle(fontWeight: FontWeight.w300, color: const Color(0xffBDC3C7),),),
        ),

        Container(height: 5, color: const Color(0xffeeeeee),),

        const ListTile(
          tileColor: const Color(0xffaaaaaa),
          title: const Text('Family', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xff000000),),),
          subtitle: const Text('Add or remove family of this page', style: const TextStyle(fontWeight: FontWeight.w300, color: const Color(0xffBDC3C7),),),
        ),

        Container(height: 5, color: const Color(0xffeeeeee),),

        ListTile(
          tileColor: const Color(0xffaaaaaa),
          title: Text('Friends', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.64, fontFamily: 'NexaRegular', color: const Color(0xff000000)),),
          subtitle: Text('Add or remove friends of this page', style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.64, fontFamily: 'NexaRegular', color: const Color(0xffBDC3C7)),),
        ),

        Container(height: 5, color: const Color(0xffeeeeee),),

        widget.relationship != 'Friend'
        ? ListTile(
          tileColor: Color(0xffffffff),
          title: const Text('Relationship', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xff000000),),),
          subtitle: const Text('Set your relationship for this page', style: const TextStyle(fontWeight: FontWeight.w300, color: const Color(0xffBDC3C7),),),
          onTap: () async{
            String choice = await showDialog(context: (context), builder: (build) => MiscBLMRelationshipFromDialog());

            if(choice != ''){
              bool result = await apiBLMMemorialSetRelationship(memorialId: memorialId, relationship: choice);

              if(result == true){
                await showDialog(
                  context: context,
                  builder: (_) => AssetGiffyDialog(
                    description: Text('Successfully updated the relationship setting.', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.87, fontFamily: 'NexaRegular',),),
                    title: Text('Success', textAlign: TextAlign.center,  style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 3.16, fontFamily: 'NexaRegular'),),
                    image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                    entryAnimation: EntryAnimation.DEFAULT,
                    onlyOkButton: true,
                    onOkButtonPressed: (){
                      Navigator.pop(context, true);
                    },
                  )
                );
              }else{
                await showDialog(
                  context: context,
                  builder: (_) => AssetGiffyDialog(
                    description: Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.87, fontFamily: 'NexaRegular',),),
                    title: Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 3.16, fontFamily: 'NexaRegular'),),
                    image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                    entryAnimation: EntryAnimation.DEFAULT,
                    buttonOkColor: const Color(0xffff0000),
                    onlyOkButton: true,
                    onOkButtonPressed: (){
                      Navigator.pop(context, true);
                    },
                  )
                );
              }
            }
          },
        )
        : ListTile(
          tileColor: const Color(0xffffffff),
          title: const Text('Leave Page', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xff000000),),),
          subtitle: const Text('Leave this page', style: const TextStyle(fontWeight: FontWeight.w300, color: const Color(0xffBDC3C7),),),
          onTap: () async{
            bool confirmResult = await showDialog(context: (context), builder: (build) => const MiscBLMConfirmDialog(title: 'Leave page', content: 'Are you sure you want to leave this page?',),);
            if(confirmResult){

              context.loaderOverlay.show();
              String result = await apiBLMLeavePage(memorialId: memorialId);
              context.loaderOverlay.hide();

              if(result != 'Failed'){
                if(result == 'Blm'){
                  Navigator.popAndPushNamed(context, '/home/blm');
                }else{
                  Navigator.popAndPushNamed(context, '/home/regular');
                }
              }else{
                await showDialog(
                  context: context,
                  builder: (_) => AssetGiffyDialog(
                    description: Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 2.87, fontFamily: 'NexaRegular',),),
                    title: Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 3.16, fontFamily: 'NexaRegular'),),
                    image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                    entryAnimation: EntryAnimation.DEFAULT,
                    buttonOkColor: const Color(0xffff0000),
                    onlyOkButton: true,
                    onOkButtonPressed: (){
                      Navigator.pop(context, true);
                    },
                  )
                );
              }
            }
          },
        ),

        Container(height: 5, color: const Color(0xffeeeeee),),

        const ListTile(
          tileColor: const Color(0xffaaaaaa),
          title: const Text('Paypal', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xff000000),),),
          subtitle: const Text('Manage cards that receives the memorial gifts.', style: const TextStyle(fontWeight: FontWeight.w300, color: const Color(0xffBDC3C7),),),
        ),

        Container(height: 5, color: const Color(0xffeeeeee),),

        const ListTile(
          tileColor: const Color(0xffaaaaaa),
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
          tileColor: const Color(0xffaaaaaa),
          title: const Text('Customize shown info', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xff000000),),),
          subtitle: const Text('Customize what others see on your page', style: const TextStyle(fontWeight: FontWeight.w300, color: const Color(0xffBDC3C7),),),
        ),

        Container(height: 5, color: const Color(0xffeeeeee),),

        Container(
          height: 80,
          color: const Color(0xffaaaaaa),
          child: Row(
            children: [
              Expanded(
                child: const ListTile(
                  tileColor: const Color(0xffaaaaaa),
                  title: const Text('Hide Family', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xff000000),),),
                  subtitle: const Text('Show or hide family details', style: const TextStyle(fontWeight: FontWeight.w300, color: const Color(0xffBDC3C7),),),
                ),
              ),

              Switch(
                value: false,
                onChanged: (value) => {},
                activeColor: const Color(0xff2F353D),
                activeTrackColor: const Color(0xff3498DB),
              ),
            ],
          ),
        ),

        Container(height: 5, color: const Color(0xffeeeeee),),

        Container(
          height: 80,
          color: const Color(0xffaaaaaa),
          child: Row(
            children: [
              Expanded(
                child: const ListTile(
                  tileColor: const Color(0xffaaaaaa),
                  title: const Text('Hide Friends', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xff000000),),),
                  subtitle: const Text('Show or hide friends details', style: const TextStyle(fontWeight: FontWeight.w300, color: const Color(0xffBDC3C7),),),
                ),
              ),

              Switch(
                value: false,
                onChanged: (value) => {},
                activeColor: const Color(0xff2F353D),
                activeTrackColor: const Color(0xff3498DB),
              ),
            ],
          ),
        ),

        Container(height: 5, color: const Color(0xffeeeeee),),

        Container(
          height: 80,
          color: const Color(0xffaaaaaa),
          child: Row(
            children: [
              Expanded(
                child: const ListTile(
                  tileColor: const Color(0xffaaaaaa),
                  title: const Text('Hide Followers', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xff000000),),),
                  subtitle: const Text('Show or hide your followers', style: const TextStyle(fontWeight: FontWeight.w300, color: const Color(0xffBDC3C7),),),
                ),
              ),

              Switch(
                value: false,
                onChanged: (value) => {},
                activeColor: const Color(0xff2F353D),
                activeTrackColor: const Color(0xff3498DB),
              ),
            ],
          ),
        ),

        const SizedBox(height: 10,),

        Image.asset('assets/icons/logo.png', height: 100, width: 100,),

        const SizedBox(height: 30,),
      ],
    );
  }
}