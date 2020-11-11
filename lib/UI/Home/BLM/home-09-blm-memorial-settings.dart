import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-04-blm-extra.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-12-blm-appbar.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/Bloc/bloc-02-bloc-blm-home.dart';
import 'home-10-01-blm-memorial-settings-extension.dart';
import 'home-10-02-blm-memorial-settings-extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class HomeBLMMemorialSettings extends StatelessWidget{

  @override
  Widget build(BuildContext context){
    SizeConfig.init(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider<BlocHomeBLMUpdateMemorialToggle>(
          create: (context) => BlocHomeBLMUpdateMemorialToggle(),
        ),
      ],
      child: Scaffold(
        appBar: MiscBLMAppBarTemplate(appBar: AppBar(), title:  Text('Memorial Settings', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xffffffff),),), leadingAction: (){Navigator.pop(context);},),
        body: Column(
          children: [
            Container(color: Color(0xffECF0F1), alignment: Alignment.centerLeft, padding: EdgeInsets.only(left: 10.0, right: 10.0), child: MiscBLMMemorialSettings(),),

            Expanded(
              child: BlocBuilder<BlocHomeBLMUpdateMemorialToggle, int>(
                builder: (context, state){
                  return ((){
                    switch(state){
                      case 0: return HomeBLMMemorialSettingsPage(); break;
                      case 1: return HomeBLMMemorialSettingsPrivacy(); break;
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