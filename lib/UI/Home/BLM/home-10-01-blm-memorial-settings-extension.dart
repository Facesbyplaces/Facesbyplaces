import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-02-blm-dialog.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-13-blm-setting-detail.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter/material.dart';

class HomeBLMMemorialSettingsPage extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return ListView(
      physics: ClampingScrollPhysics(),
      children: [

        MiscBLMSettingDetailTemplate(onTap: (){Navigator.pushNamed(context, '/home/blm/home-11-blm-page-details');},),

        Container(height: SizeConfig.blockSizeVertical * .5, color: Color(0xffeeeeee),),

        MiscBLMSettingDetailTemplate(onTap: (){Navigator.pushNamed(context, '/home/regular/home-04-03-regular-create-memorial');}, titleDetail: 'Page Image', contentDetail: 'Update Page image and background image'),

        Container(height: SizeConfig.blockSizeVertical * .5, color: Color(0xffeeeeee),),

        MiscBLMSettingDetailTemplate(onTap: (){}, titleDetail: 'Admins', contentDetail: 'Add or remove admins of this page'),

        Container(height: SizeConfig.blockSizeVertical * .5, color: Color(0xffeeeeee),),

        MiscBLMSettingDetailTemplate(onTap: (){}, titleDetail: 'Family', contentDetail: 'Add or remove family of this page'),

        Container(height: SizeConfig.blockSizeVertical * .5, color: Color(0xffeeeeee),),

        MiscBLMSettingDetailTemplate(onTap: (){}, titleDetail: 'Friends', contentDetail: 'Add or remove friends of this page'),

        Container(height: SizeConfig.blockSizeVertical * .5, color: Color(0xffeeeeee),),

        MiscBLMSettingDetailTemplate(onTap: (){}, titleDetail: 'Paypal', contentDetail: 'Manage cards that receives the memorial gifts.'),

        Container(height: SizeConfig.blockSizeVertical * .5, color: Color(0xffeeeeee),),

        MiscBLMSettingDetailTemplate(onTap: ()async{await showDialog(context: (context), builder: (build) => MiscBLMConfirmDialog());}, titleDetail: 'Delete Page', contentDetail: 'Completely remove the page. This is irreversible'),

        SizedBox(height: SizeConfig.blockSizeVertical * 5,),

        Container(height: SizeConfig.blockSizeVertical * 10, child: Image.asset('assets/icons/logo.png'),),

        SizedBox(height: SizeConfig.blockSizeVertical * 1,),

      ],
    );
  }
}