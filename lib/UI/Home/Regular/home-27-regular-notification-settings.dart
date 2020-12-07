import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-08-blm-background.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-09-regular-extra.dart';
import 'package:flutter/material.dart';

class HomeRegularNotificationSettings extends StatefulWidget{

  @override
  HomeRegularNotificationSettingsState createState() => HomeRegularNotificationSettingsState();
}

class HomeRegularNotificationSettingsState extends State<HomeRegularNotificationSettings>{

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return WillPopScope(
      onWillPop: () async{
        return Navigator.canPop(context);
      },
      child: GestureDetector(
        onTap: (){
          FocusNode currentFocus = FocusScope.of(context);
          if(!currentFocus.hasPrimaryFocus){
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xff04ECFF),
            title: Text('Notification Settings', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xffffffff)),),
            centerTitle: true,
            leading: IconButton(icon: Icon(Icons.arrow_back, color: Color(0xffffffff),), onPressed: (){Navigator.pop(context);},),
          ),
          body: Stack(
            children: [
              MiscBLMBackgroundTemplate(image: AssetImage('assets/icons/background2.png'),),

              Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Expanded(
                      child: Column(
                        children: [

                          Row(
                            children: [
                              Expanded(child: Text('New Memorial Page', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),)),

                              MiscRegularToggleSwitchTemplate(),
                            ],
                          ),

                          Row(
                            children: [
                              Expanded(child: Text('New Activities', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),)),

                              MiscRegularToggleSwitchTemplate(),
                            ],
                          ),

                          Row(
                            children: [
                              Expanded(child: Text('Post Likes', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),)),

                              MiscRegularToggleSwitchTemplate(),
                            ],
                          ),

                          Row(
                            children: [
                              Expanded(child: Text('Post Comments', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),)),

                              MiscRegularToggleSwitchTemplate(),
                            ],
                          ),

                          Expanded(child: Container(),),

                        ],
                      ),
                    ),

                    Container(height: SizeConfig.blockSizeVertical * .1, color: Color(0xffffffff),),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          SizedBox(height: SizeConfig.blockSizeVertical * 5,),

                          Text('Page Invites', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 5, fontWeight: FontWeight.bold, color: Color(0xff000000),),),

                          SizedBox(height: SizeConfig.blockSizeVertical * 1,),

                          Row(
                            children: [
                              Expanded(child: Text('Add as Family', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),)),

                              MiscRegularToggleSwitchTemplate(),
                            ],
                          ),

                          Row(
                            children: [
                              Expanded(child: Text('Add as Friend', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),)),

                              MiscRegularToggleSwitchTemplate(),
                            ],
                          ),

                          Row(
                            children: [
                              Expanded(child: Text('Add as Page Admin', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),)),

                              MiscRegularToggleSwitchTemplate(),
                            ],
                          ),

                          Expanded(child: Container(),),

                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}