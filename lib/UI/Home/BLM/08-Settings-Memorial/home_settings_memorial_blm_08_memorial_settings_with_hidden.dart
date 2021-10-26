import 'package:facesbyplaces/API/BLM/09-Settings-Memorial/api_settings_memorial_blm_17_set_relationship.dart';
import 'package:facesbyplaces/API/BLM/02-Main/api_main_blm_04_02_01_leave_page.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter/material.dart';
import 'package:dialog/dialog.dart';
import 'package:misc/misc.dart';

class HomeBLMMemorialSettingsWithHidden extends StatefulWidget{
  final int memorialId;
  final String relationship;
  const HomeBLMMemorialSettingsWithHidden({Key? key, required this.memorialId, required this.relationship}) : super(key: key);

  @override
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
          backgroundColor: const Color(0xff04ECFF),
          title: const Text('Memorial Settings', style: TextStyle(fontSize: 26, fontFamily: 'NexaRegular', color: Color(0xffffffff),),),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, size: 35,),
            onPressed: (){
              Navigator.pop(context);
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
                              tabs: const [
                                Text('Page', style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xff2F353D),),),
                                            
                                Text('Privacy', style: TextStyle(fontSize: 24, fontFamily: 'NexaRegular', color: Color(0xff2F353D),),),
                              ],
                            ),
                          ),
                        ),

                        Expanded(
                          child: SizedBox(
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
                ),
              );
            },
          )
        ),
      ),
    );
  }

  settingsTab1(int memorialId){
    return Column(
      children: [
        const ListTile(
          title: Text('Page Details', style: TextStyle(fontSize: 24, fontFamily: 'NexaBold', color: Color(0xff2F353D),),),
          subtitle: Text('Update page details', style: TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xffBDC3C7),),),
          tileColor: Color(0xffaaaaaa),
        ),

        Container(height: 5, color: const Color(0xffeeeeee),),

        const ListTile(
          title: Text('Page Image', style: TextStyle(fontSize: 24, fontFamily: 'NexaBold', color: Color(0xff2F353D),),),
          subtitle: Text('Update Page image and background image', style: TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xffBDC3C7),),),
          tileColor: Color(0xffaaaaaa),
        ),

        Container(height: 5, color: const Color(0xffeeeeee),),

        const ListTile(
          title: Text('Admins', style: TextStyle(fontSize: 24, fontFamily: 'NexaBold', color: Color(0xff2F353D),),),
          subtitle: Text('Add or remove admins of this page', style: TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xffBDC3C7),),),
          tileColor: Color(0xffaaaaaa),
        ),

        Container(height: 5, color: const Color(0xffeeeeee),),

        const ListTile(
          title: Text('Family', style: TextStyle(fontSize: 24, fontFamily: 'NexaBold', color: Color(0xff2F353D),),),
          subtitle: Text('Add or remove family of this page', style: TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xffBDC3C7),),),
          tileColor: Color(0xffaaaaaa),
        ),

        Container(height: 5, color: const Color(0xffeeeeee),),

        const ListTile(
          title: Text('Friends', style: TextStyle(fontSize: 24, fontFamily: 'NexaBold', color: Color(0xff2F353D),),),
          subtitle: Text('Add or remove friends of this page', style: TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xffBDC3C7),),),
          tileColor: Color(0xffaaaaaa),
        ),

        Container(height: 5, color: const Color(0xffeeeeee),),

        widget.relationship != 'Friend'
        ? ListTile(
          title: const Text('Relationship', style: TextStyle(fontSize: 24, fontFamily: 'NexaBold', color: Color(0xff2F353D),),),
          subtitle: const Text('Set your relationship for this page', style: TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xffBDC3C7),),),
          tileColor: const Color(0xffffffff),
          onTap: () async{
            String choice = await showDialog(context: (context), builder: (build) => const MiscRelationshipFromDialog());

            if(choice != ''){
              bool result = await apiBLMMemorialSetRelationship(memorialId: memorialId, relationship: choice);

              if(result == true){
                await showDialog(
                  context: context,
                  builder: (context) => CustomDialog(
                    image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
                    title: 'Success',
                    description: 'Successfully updated the relationship setting.',
                    okButtonColor: const Color(0xff4caf50), // GREEN
                    includeOkButton: true,
                  ),
                );
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
        )
        : ListTile(
          title: const Text('Leave Page', style: TextStyle(fontSize: 24, fontFamily: 'NexaBold', color: Color(0xff2F353D),),),
          subtitle: const Text('Leave this page', style: TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xffBDC3C7),),),
          tileColor: const Color(0xffffffff),
          onTap: () async{
            bool confirmResult = await showDialog(context: (context), builder: (build) => const MiscConfirmDialog(title: 'Leave page', content: 'Are you sure you want to leave this page?',),);
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
    return Column(
      children: [
        const ListTile(
          title: Text('Customize shown info', style: TextStyle(fontSize: 24, fontFamily: 'NexaBold', color: Color(0xff2F353D),),),
          subtitle: Text('Customize what others see on your page', style: TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xffBDC3C7),),),
          tileColor: Color(0xffaaaaaa),
        ),

        Container(height: 5, color: const Color(0xffeeeeee),),

        Container(
          height: 80,
          color: const Color(0xffaaaaaa),
          child: Row(
            children: [
              const Expanded(
                child: ListTile(
                  title: Text('Hide Family', style: TextStyle(fontSize: 24, fontFamily: 'NexaBold', color: Color(0xff2F353D),),),
                  subtitle: Text('Show or hide family details', style: TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xffBDC3C7),),),
                  tileColor: Color(0xffaaaaaa),
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
             const Expanded(
                child: ListTile(
                  title: Text('Hide Friends', style: TextStyle(fontSize: 24, fontFamily: 'NexaBold', color: Color(0xff2F353D),),),
                  subtitle: Text('Show or hide friends details', style: TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xffBDC3C7),),),
                  tileColor: Color(0xffaaaaaa),
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
              const Expanded(
                child: ListTile(
                  title: Text('Hide Followers', style: TextStyle(fontSize: 24, fontFamily: 'NexaBold', color: Color(0xff2F353D),),),
                  subtitle: Text('Show or hide your followers', style: TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xffBDC3C7),),),
                  tileColor: Color(0xffaaaaaa),
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

        const SizedBox(height: 80,),

        const Expanded(child: SizedBox()),

        Image.asset('assets/icons/logo.png', height: 100, width: 100,),

        const SizedBox(height: 30,),
      ],
    );
  }
}