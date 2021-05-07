import 'package:facesbyplaces/API/BLM/09-Settings-Memorial/api-settings-memorial-blm-17-set-relationship.dart';
import 'package:facesbyplaces/API/BLM/02-Main/api-main-blm-04-02-01-leave-page.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-02-blm-dialog.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:flutter/material.dart';

class HomeBLMMemorialSettingsWithHidden extends StatefulWidget{
  final int memorialId;
  final String relationship;
  const HomeBLMMemorialSettingsWithHidden({required this.memorialId, required this.relationship});
  
  HomeBLMMemorialSettingsWithHiddenState createState() => HomeBLMMemorialSettingsWithHiddenState(memorialId: memorialId, relationship: relationship);
}

class HomeBLMMemorialSettingsWithHiddenState extends State<HomeBLMMemorialSettingsWithHidden>{
  final int memorialId;
  final String relationship;
  HomeBLMMemorialSettingsWithHiddenState({required this.memorialId, required this.relationship});
  
  int toggle = 0;

  @override
  Widget build(BuildContext context){
    SizeConfig.init(context);
    return Scaffold(
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

        const ListTile(
          tileColor: const Color(0xffaaaaaa),
          title: const Text('Friends', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xff000000),),),
          subtitle: const Text('Add or remove friends of this page', style: const TextStyle(fontWeight: FontWeight.w300, color: const Color(0xffBDC3C7),),),
        ),

        Container(height: 5, color: const Color(0xffeeeeee),),

        relationship != 'Friend'
        ? ListTile(
          tileColor: Color(0xffffffff),
          onTap: () async{
            String choice = await showDialog(context: (context), builder: (build) => MiscBLMRelationshipFromDialog());

            if(choice != ''){
              bool result = await apiBLMMemorialSetRelationship(memorialId: memorialId, relationship: choice);

              if(result == true){
                await showDialog(
                  context: context,
                  builder: (_) => 
                    AssetGiffyDialog(
                    image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                    title: const Text('Success', textAlign: TextAlign.center, style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
                    entryAnimation: EntryAnimation.DEFAULT,
                    description: const Text('Successfully updated the relationship setting.',
                      textAlign: TextAlign.center,
                    ),
                    onlyOkButton: true,
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
          title: const Text('Relationship', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xff000000),),),
          subtitle: const Text('Set your relationship for this page', style: const TextStyle(fontWeight: FontWeight.w300, color: const Color(0xffBDC3C7),),),
        )
        : ListTile(
          tileColor: const Color(0xffffffff),
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
          title: const Text('Leave Page', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xff000000),),),
          subtitle: const Text('Leave this page', style: const TextStyle(fontWeight: FontWeight.w300, color: const Color(0xffBDC3C7),),),
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