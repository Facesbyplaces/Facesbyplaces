import 'package:facesbyplaces/API/Regular/02-Main/api-main-regular-04-02-01-leave-page.dart';
import 'package:facesbyplaces/API/Regular/09-Settings-Memorial/api-settings-memorial-regular-17-set-relationship.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-02-regular-dialog.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:flutter/material.dart';

class HomeRegularMemorialSettingsWithHidden extends StatefulWidget{
  final int memorialId;
  final String relationship;
  HomeRegularMemorialSettingsWithHidden({required this.memorialId, required this.relationship});
  
  HomeRegularMemorialSettingsWithHiddenState createState() => HomeRegularMemorialSettingsWithHiddenState(memorialId: memorialId, relationship: relationship);
}

class HomeRegularMemorialSettingsWithHiddenState extends State<HomeRegularMemorialSettingsWithHidden>{
  final int memorialId;
  final String relationship;
  HomeRegularMemorialSettingsWithHiddenState({required this.memorialId, required this.relationship});
  
  int toggle = 0;

  void initState(){
    super.initState();
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
          tileColor: Color(0xffaaaaaa),
          title: Text('Page Details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xff000000),),),
          subtitle: Text('Update page details', style: TextStyle(fontWeight: FontWeight.w300, color: Color(0xffBDC3C7),),),
        ),

        Container(height: 5, color: Color(0xffeeeeee),),

        ListTile(
          tileColor: Color(0xffaaaaaa),
          title: Text('Page Image', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xff000000),),),
          subtitle: Text('Update Page image and background image', style: TextStyle(fontWeight: FontWeight.w300, color: Color(0xffBDC3C7),),),
        ),

        Container(height: 5, color: Color(0xffeeeeee),),

        ListTile(
          tileColor: Color(0xffaaaaaa),
          title: Text('Admins', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xff000000),),),
          subtitle: Text('Add or remove admins of this page', style: TextStyle(fontWeight: FontWeight.w300, color: Color(0xffBDC3C7),),),
        ),

        Container(height: 5, color: Color(0xffeeeeee),),

        ListTile(
          tileColor: Color(0xffaaaaaa),
          title: Text('Family', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xff000000),),),
          subtitle: Text('Add or remove family of this page', style: TextStyle(fontWeight: FontWeight.w300, color: Color(0xffBDC3C7),),),
        ),

        Container(height: 5, color: Color(0xffeeeeee),),

        ListTile(
          tileColor: Color(0xffaaaaaa),
          title: Text('Friends', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xff000000),),),
          subtitle: Text('Add or remove friends of this page', style: TextStyle(fontWeight: FontWeight.w300, color: Color(0xffBDC3C7),),),
        ),

        Container(height: 5, color: Color(0xffeeeeee),),

        relationship != 'Friend'
        ? ListTile(
          onTap: () async{
            String choice = await showDialog(context: (context), builder: (build) => MiscRegularRelationshipFromDialog());

            if(choice != ''){
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
          tileColor: Color(0xffffffff),
          title: Text('Relationship', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xff000000),),),
          subtitle: Text('Set your relationship for this page', style: TextStyle(fontWeight: FontWeight.w300, color: Color(0xffBDC3C7),),),
        )
        : ListTile(
          onTap: () async{
            bool confirmResult = await showDialog(context: (context), builder: (build) => MiscRegularConfirmDialog(title: 'Leave page', content: 'Are you sure you want to leave this page?',),);
            if(confirmResult){

              context.showLoaderOverlay();
              String result = await apiRegularLeavePage(memorialId: memorialId);
              context.hideLoaderOverlay();

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
          tileColor: Color(0xffffffff),
          title: Text('Leave Page', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xff000000),),),
          subtitle: Text('Leave this page', style: TextStyle(fontWeight: FontWeight.w300, color: Color(0xffBDC3C7),),),
        ),

        Container(height: 5, color: Color(0xffeeeeee),),

        ListTile(
          tileColor: Color(0xffaaaaaa),
          title: Text('Paypal', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xff000000),),),
          subtitle: Text('Manage cards that receives the memorial gifts.', style: TextStyle(fontWeight: FontWeight.w300, color: Color(0xffBDC3C7),),),
        ),

        Container(height: 5, color: Color(0xffeeeeee),),

        ListTile(
          tileColor: Color(0xffaaaaaa),
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
          tileColor: Color(0xffaaaaaa),
          title: Text('Customize shown info', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xff000000),),),
          subtitle: Text('Customize what others see on your page', style: TextStyle(fontWeight: FontWeight.w300, color: Color(0xffBDC3C7),),),
        ),

        Container(height: 5, color: Color(0xffeeeeee),),

        Container(
          height: 80,
          color: Color(0xffaaaaaa),
          child: Row(
            children: [
              Expanded(
                child: ListTile(
                  tileColor: Color(0xffaaaaaa),
                  title: Text('Hide Family', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xff000000),),),
                  subtitle: Text('Show or hide family details', style: TextStyle(fontWeight: FontWeight.w300, color: Color(0xffBDC3C7),),),
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

        Container(height: 5, color: Color(0xffeeeeee),),

        Container(
          height: 80,
          color: Color(0xffaaaaaa),
          child: Row(
            children: [
              Expanded(
                child: ListTile(
                  tileColor: Color(0xffaaaaaa),
                  title: Text('Hide Friends', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xff000000),),),
                  subtitle: Text('Show or hide friends details', style: TextStyle(fontWeight: FontWeight.w300, color: Color(0xffBDC3C7),),),
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

        Container(height: 5, color: Color(0xffeeeeee),),

        Container(
          height: 80,
          color: Color(0xffaaaaaa),
          child: Row(
            children: [
              Expanded(
                child: ListTile(
                  tileColor: Color(0xffaaaaaa),
                  title: Text('Hide Followers', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xff000000),),),
                  subtitle: Text('Show or hide your followers', style: TextStyle(fontWeight: FontWeight.w300, color: Color(0xffBDC3C7),),),
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

        Container(height: 5, color: Color(0xffeeeeee),),

        SizedBox(height: 80,),

        Image.asset('assets/icons/logo.png', height: 100, width: 100,),

        SizedBox(height: 10,),

      ],
    );
  }
}

