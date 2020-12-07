import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-04-blm-extra.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-13-blm-setting-detail.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter/material.dart';

class HomeBLMMemorialSettingsPrivacy extends StatefulWidget{

  HomeBLMMemorialSettingsPrivacyState createState() => HomeBLMMemorialSettingsPrivacyState();
}

class HomeBLMMemorialSettingsPrivacyState extends State<HomeBLMMemorialSettingsPrivacy>{

  bool isSwitched1 = false;

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
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
              // Expanded(
              //   child: MiscBLMToggleSwitchTemplate(),
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
                flex: 2,
                child: MiscBLMSettingDetailTemplate(onTap: (){}, titleDetail: 'Hide Friends', contentDetail: 'Show or hide friends details'),
              ),
              Expanded(
                child: MiscBLMToggleSwitchTemplate(),
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
              Expanded(
                flex: 2,
                child: MiscBLMSettingDetailTemplate(onTap: (){}, titleDetail: 'Hide Followers', contentDetail: 'Show or hide your followers'),
              ),
              Expanded(
                child: MiscBLMToggleSwitchTemplate(),
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