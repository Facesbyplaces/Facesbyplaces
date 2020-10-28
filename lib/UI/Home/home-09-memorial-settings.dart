import 'package:facesbyplaces/UI/Miscellaneous/misc-02-dialog.dart';
import 'package:facesbyplaces/UI/Miscellaneous/misc-04-extra.dart';
import 'package:facesbyplaces/UI/Miscellaneous/misc-12-appbar.dart';
import 'package:facesbyplaces/UI/Miscellaneous/misc-13-setting-detail.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/Bloc/bloc-02-bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';


class HomeMemorialSettings extends StatelessWidget{

  @override
  Widget build(BuildContext context){
    SizeConfig.init(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider<BlocHomeUpdateMemorialToggle>(
          create: (context) => BlocHomeUpdateMemorialToggle(),
        ),
      ],
      child: Scaffold(
        appBar: MiscAppBarTemplate(appBar: AppBar(), title:  Text('Memorial Settings', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xffffffff),),), leadingAction: (){Navigator.pop(context);},),
        body: Column(
          children: [
            Container(color: Color(0xffECF0F1), alignment: Alignment.centerLeft, padding: EdgeInsets.only(left: 10.0, right: 10.0), child: MiscMemorialSettings(),),

            Expanded(
              child: BlocBuilder<BlocHomeUpdateMemorialToggle, int>(
                builder: (context, state){
                  return ((){
                    switch(state){
                      case 0: return HomeMemorialSettingsPage(); break;
                      case 1: return HomeMemorialSettingsPrivacy(); break;
                    }
                  }());
                },
              ),
            ),

          ],
        ),
      ),
    );
  }
}

class HomeMemorialSettingsPage extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return ListView(
      shrinkWrap: true,
      children: [

        MiscSettingDetailTemplate(onTap: (){Navigator.pushNamed(context, 'home/home-11-page-details');},),

        Container(height: SizeConfig.blockSizeVertical * .5, color: Color(0xffeeeeee),),

        MiscSettingDetailTemplate(onTap: (){Navigator.pushNamed(context, 'home/home-07-03-create-memorial');}, titleDetail: 'Page Image', contentDetail: 'Update Page image and background image'),

        Container(height: SizeConfig.blockSizeVertical * .5, color: Color(0xffeeeeee),),

        MiscSettingDetailTemplate(onTap: (){}, titleDetail: 'Admins', contentDetail: 'Add or remove admins of this page'),

        Container(height: SizeConfig.blockSizeVertical * .5, color: Color(0xffeeeeee),),

        MiscSettingDetailTemplate(onTap: (){}, titleDetail: 'Family', contentDetail: 'Add or remove family of this page'),

        Container(height: SizeConfig.blockSizeVertical * .5, color: Color(0xffeeeeee),),

        MiscSettingDetailTemplate(onTap: (){}, titleDetail: 'Friends', contentDetail: 'Add or remove friends of this page'),

        Container(height: SizeConfig.blockSizeVertical * .5, color: Color(0xffeeeeee),),

        MiscSettingDetailTemplate(onTap: (){}, titleDetail: 'Paypal', contentDetail: 'Manage cards that receives the memorial gifts.'),

        Container(height: SizeConfig.blockSizeVertical * .5, color: Color(0xffeeeeee),),

        MiscSettingDetailTemplate(onTap: ()async{await showDialog(context: (context), builder: (build) => DeletePageDialog());}, titleDetail: 'Delete Page', contentDetail: 'Completely remove the page. This is irreversible'),

        SizedBox(height: SizeConfig.blockSizeVertical * 5,),

        Container(height: SizeConfig.blockSizeVertical * 10, child: Image.asset('assets/icons/logo.png'),),

      ],
    );
  }
}

class HomeMemorialSettingsPrivacy extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return ListView(
      shrinkWrap: true,
      children: [

        MiscSettingDetailTemplate(onTap: (){}, titleDetail: 'Customize shown info', contentDetail: 'Customize what others see on your page'),

        Container(height: SizeConfig.blockSizeVertical * .5, color: Color(0xffeeeeee),),

        Container(
          height: SizeConfig.blockSizeVertical * 10,
          color: Color(0xffffffff),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: MiscSettingDetailTemplate(onTap: (){}, titleDetail: 'Hide Family', contentDetail: 'Show or hide family details'),
              ),
              Expanded(
                child: MiscToggleSwitchTemplate(),
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
                child: MiscSettingDetailTemplate(onTap: (){}, titleDetail: 'Hide Friends', contentDetail: 'Show or hide friends details'),
              ),
              Expanded(
                child: MiscToggleSwitchTemplate(),
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
                child: MiscSettingDetailTemplate(onTap: (){}, titleDetail: 'Hide Followers', contentDetail: 'Show or hide your followers'),
              ),
              Expanded(
                child: MiscToggleSwitchTemplate(),
              ),
            ],
          ),
        ),

        Container(height: SizeConfig.blockSizeVertical * .5, color: Color(0xffeeeeee),),

        SizedBox(height: SizeConfig.blockSizeVertical * 5,),

        Container(height: SizeConfig.blockSizeVertical * 10, child: Image.asset('assets/icons/logo.png'),),

        SizedBox(height: SizeConfig.blockSizeVertical * 5,),

      ],
    );
  }
}