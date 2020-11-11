import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-04-blm-extra.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-16-blm-drawer.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/UI/Home/BLM/home-03-01-blm-feed-tab.dart';
import 'package:facesbyplaces/UI/Home/BLM/home-03-04-blm-notifications-tab.dart';
import 'package:facesbyplaces/Bloc/bloc-02-bloc-blm-home.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'home-03-02-blm-memorial-list-tab.dart';
import 'package:flutter/material.dart';
import 'home-03-03-blm-post-tab.dart';

class HomeBLMScreenExtended extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider<BlocHomeBLMToggleBottom>(create: (context) => BlocHomeBLMToggleBottom(),),
        BlocProvider<BlocHomeBLMUpdateToggle>(create: (context) => BlocHomeBLMUpdateToggle(),),
        BlocProvider<BlocHomeBLMUpdateListSuggested>(create: (context) => BlocHomeBLMUpdateListSuggested(),),
      ],
      child: WillPopScope(
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
              backgroundColor: Color(0xff4EC9D4),
              leading: Builder(
                builder: (context){
                  return IconButton(
                    icon: Image.asset('assets/icons/profile1.png'),
                    onPressed: (){
                      Scaffold.of(context).openDrawer();
                    },
                  );
                },
              ),
              title: Text('FacesByPlaces.com', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xffffffff),),), 
              actions: [
                IconButton(icon: Icon(Icons.search, color: Color(0xffffffff), size: SizeConfig.blockSizeVertical * 4,), 
                onPressed: (){Navigator.pushNamed(context, '/home/blm/home-04-blm-search');},),
              ],
            ),
            body: BlocBuilder<BlocHomeBLMToggleBottom, int>(
              builder: (context, toggleBottom){
                return Container(
                  decoration: BoxDecoration(image: DecorationImage(fit: BoxFit.cover, image: AssetImage('assets/icons/background2.png'), colorFilter: ColorFilter.srgbToLinearGamma(),),),
                  child: ((){
                    switch(toggleBottom){
                      case 0: return HomeBLMFeedTab(); break;
                      case 1: return HomeBLMManageTab(); break;
                      case 2: return HomeBLMPostTab(); break;
                      case 3: return HomeBLMNotificationsTab(); break;
                    }
                  }()),
                );
              },
            ),
            bottomSheet: MiscBLMBottomSheet(),
            drawer: MiscBLMDrawer(),
          ),
        ),
      ),
    );
  }
}
