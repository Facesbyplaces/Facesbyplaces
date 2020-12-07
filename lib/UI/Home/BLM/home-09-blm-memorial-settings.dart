import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-13-blm-setting-detail.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-02-blm-dialog.dart';
import 'package:facesbyplaces/API/BLM/api-06-blm-delete-memorial.dart';
// import 'package:facesbyplaces/API/BLM/api-25-blm-hide-famliy-setting.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter/material.dart';
import 'home-11-blm-page-details.dart';
import 'home-21-blm-memorial-page-image.dart';
import 'home-26-blm-page-managers.dart';

class HomeBLMMemorialSettings extends StatefulWidget{
  
  HomeBLMMemorialSettingsState createState() => HomeBLMMemorialSettingsState();
}

class HomeBLMMemorialSettingsState extends State<HomeBLMMemorialSettings>{
  
  int toggle = 0;
  bool isSwitched1 = false;
  bool isSwitched2 = false;
  bool isSwitched3 = false;

  @override
  Widget build(BuildContext context){
    SizeConfig.init(context);
    int memorialId = ModalRoute.of(context).settings.arguments;
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
          onTap: (){
            // Navigator.pushNamed(context, '/home/blm/home-11-blm-page-details', arguments: memorialId);
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMPageDetails(memorialId: memorialId,)));
          },
        ),

        Container(height: SizeConfig.blockSizeVertical * .5, color: Color(0xffeeeeee),),

        MiscBLMSettingDetailTemplate(
          onTap: (){
            // Navigator.pushNamed(context, '/home/blm/home-07-03-blm-create-memorial');
            // Navigator.pushNamed(context, '/home/blm/home-21-blm-memorial-page-image', arguments: memorialId);
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMMemorialPageImage(memorialId: memorialId,)));
          }, 
          titleDetail: 'Page Image', 
          contentDetail: 'Update Page image and background image',
        ),

        Container(height: SizeConfig.blockSizeVertical * .5, color: Color(0xffeeeeee),),

        MiscBLMSettingDetailTemplate(
          onTap: (){
          // Navigator.pushNamed(context, '/home/blm/home-26-blm-page-managers');
          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMPageManagers(memorialId: memorialId,)));
          }, 
          titleDetail: 'Admins', 
          contentDetail: 'Add or remove admins of this page',
        ),

        Container(height: SizeConfig.blockSizeVertical * .5, color: Color(0xffeeeeee),),

        MiscBLMSettingDetailTemplate(onTap: (){
          Navigator.pushNamed(context, '/home/blm/home-27-blm-page-family');
        }, 
          titleDetail: 'Family', 
          contentDetail: 'Add or remove family of this page',
        ),

        Container(height: SizeConfig.blockSizeVertical * .5, color: Color(0xffeeeeee),),

        MiscBLMSettingDetailTemplate(onTap: (){
          Navigator.pushNamed(context, '/home/blm/home-28-blm-page-friends');
        }, 
          titleDetail: 'Friends', 
          contentDetail: 'Add or remove friends of this page',
        ),

        Container(height: SizeConfig.blockSizeVertical * .5, color: Color(0xffeeeeee),),

        MiscBLMSettingDetailTemplate(onTap: (){}, titleDetail: 'Paypal', contentDetail: 'Manage cards that receives the memorial gifts.'),

        Container(height: SizeConfig.blockSizeVertical * .5, color: Color(0xffeeeeee),),

        MiscBLMSettingDetailTemplate(
          onTap: () async{
            bool confirmResult = await showDialog(context: (context), builder: (build) => MiscBLMConfirmDialog(),);

            print('The memorialId is $memorialId');

            if(confirmResult){

              context.showLoaderOverlay();
              bool result = await apiBLMDeleteMemorial(memorialId);
              context.hideLoaderOverlay();

              if(result){
                // Navigator.popUntil(context, ModalRoute.withName('/home/blm'));
                Navigator.popAndPushNamed(context, '/home/blm');
              }else{
                await showDialog(context: (context), builder: (build) => MiscBLMAlertDialog(title: 'Error', content: 'Something went wrong. Please try again.'));
              }
            }
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
          onTap: (){}, 
          titleDetail: 'Customize shown info', 
          contentDetail: 'Customize what others see on your page',
        ),

        Container(height: SizeConfig.blockSizeVertical * .5, color: Color(0xffeeeeee),),

        Container(
          height: SizeConfig.blockSizeVertical * 10,
          color: Color(0xffffffff),
          child: Row(
            children: [
              Expanded(child: MiscBLMSettingDetailTemplate(onTap: (){}, titleDetail: 'Hide Family', contentDetail: 'Show or hide family details'),),

              Switch(
                value: isSwitched1,
                onChanged: (value){
                  setState(() {
                    isSwitched1 = value;
                  });
                },
                activeColor: Color(0xff2F353D),
                activeTrackColor: Color(0xff3498DB),
              ),

              // Container(
              //   padding: EdgeInsets.only(right: 20.0),
              //   child: FutureBuilder<bool>(
              //     future: apiBLMHideFamilySetting(memorialId),
              //     builder: (context, setting){
              //       if(setting.data){
              //         return Switch(
              //           value: setting.data,
              //           onChanged: (value) async{
              //           },
              //           activeColor: Color(0xff2F353D),
              //           activeTrackColor: Color(0xff3498DB),
              //         );
              //       }else if(setting.hasError){
              //         return Container(height: 0,);
              //       }else{
              //         return Center(child: CircularProgressIndicator(),);
              //       }
              //     },
              //   ),
              // ),

            ],
          ),
        ),

        Container(height: SizeConfig.blockSizeVertical * .5, color: Color(0xffeeeeee),),

        Container(
          height: SizeConfig.blockSizeVertical * 10,
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

              // Container(
              //   padding: EdgeInsets.only(right: 20.0),
              //   child: FutureBuilder<bool>(
              //     future: apiBLMHideFriendsSetting(memorialId),
              //     builder: (context, setting){
              //       if(setting.data){
              //         return Switch(
              //           value: setting.data,
              //           onChanged: (value) async{
              //           },
              //           activeColor: Color(0xff2F353D),
              //           activeTrackColor: Color(0xff3498DB),
              //         );
              //       }else if(setting.hasError){
              //         return Container(height: 0,);
              //       }else{
              //         return Center(child: CircularProgressIndicator(),);
              //       }
              //     },
              //   ),
              // ),

              Switch(
                value: isSwitched2,
                onChanged: (value){
                  setState(() {
                    isSwitched2 = value;
                  });
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
          color: Color(0xffffffff),
          child: Row(
            children: [
              Expanded(child: MiscBLMSettingDetailTemplate(onTap: (){}, titleDetail: 'Hide Followers', contentDetail: 'Show or hide your followers'),),

              // Container(
              //   padding: EdgeInsets.only(right: 20.0),
              //   child: FutureBuilder<bool>(
              //     future: apiBLMHideFriendsSetting(memorialId),
              //     builder: (context, setting){
              //       if(setting.data){
              //         return Switch(
              //           value: setting.data,
              //           onChanged: (value) async{
              //           },
              //           activeColor: Color(0xff2F353D),
              //           activeTrackColor: Color(0xff3498DB),
              //         );
              //       }else if(setting.hasError){
              //         return Container(height: 0,);
              //       }else{
              //         return Center(child: CircularProgressIndicator(),);
              //       }
              //     },
              //   ),
              // ),

              Switch(
                value: isSwitched3,
                onChanged: (value){
                  setState(() {
                    isSwitched3 = value;
                  });
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

