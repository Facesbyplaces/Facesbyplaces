import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-09-regular-extra.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/Bloc/bloc-01-bloc.dart';
import 'package:facesbyplaces/Bloc/bloc-04-bloc-regular-home.dart';
import 'home-11-01-regular-memorial-settings-extension.dart';
import 'home-11-02-regular-memorial-settings-extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class HomeRegularMemorialSettings extends StatelessWidget{

  @override
  Widget build(BuildContext context){
    SizeConfig.init(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider<BlocHomeRegularUpdateMemorialToggle>(create: (context) => BlocHomeRegularUpdateMemorialToggle(),),
        BlocProvider<BlocShowLoading>(create: (context) => BlocShowLoading(),),
      ],
      child: BlocBuilder<BlocHomeRegularUpdateMemorialToggle, int>(
        builder: (context, toggle){
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Color(0xff04ECFF),
              title:  Text('Memorial Settings', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xffffffff),),),
              centerTitle: true,
              leading: IconButton(icon: Icon(Icons.arrow_back, color: Color(0xffffffff),), onPressed: (){Navigator.pop(context);},),
            ),
            body: Column(
              children: [

                BlocBuilder<BlocShowLoading, bool>(
                  builder: (context, loading){
                    return ((){
                      switch(loading){
                        case false: return Container(color: Color(0xffECF0F1), alignment: Alignment.centerLeft, padding: EdgeInsets.only(left: 10.0, right: 10.0), child: MiscRegularMemorialSettings(),);
                        case true: return Container(height: 0,);
                      }
                    }());
                  }
                ),

                Expanded(
                  child: ((){
                    switch(toggle){
                      case 0: return HomeRegularMemorialSettingsPage(); break;
                      case 1: return HomeRegularMemorialSettingsPrivacy(); break;
                    }
                  }()),
                ),

              ],
            ),
          );
        },
      ),
    );
  }
}