import 'package:facesbyplaces/Bloc/bloc-04-bloc-regular-home.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-02-regular-bottom-sheet.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-03-regular-drawer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'home-03-01-regular-feed-tab.dart';
import 'home-03-02-regular-memorial-list-tab.dart';
import 'home-03-03-regular-post-tab.dart';
import 'home-03-04-regular-notifications-tab.dart';
import 'package:flutter/material.dart';

class HomeRegularScreenExtended extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider<BlocHomeRegularUpdateCubit>(
          create: (context) => BlocHomeRegularUpdateCubit(),
        ),
        BlocProvider<BlocHomeRegularUpdateToggle>(
          create: (context) => BlocHomeRegularUpdateToggle(),
        ),
        BlocProvider<BlocHomeRegularUpdateListSuggested>(
          create: (context) => BlocHomeRegularUpdateListSuggested(),
        ),
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
                    icon: Image.asset('assets/icons/profile2.png'),
                    onPressed: (){
                      Scaffold.of(context).openDrawer();
                    },
                  );
                },
              ),
              title: Text('FacesByPlaces.com', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xffffffff),),), 
              actions: [
                IconButton(icon: Icon(Icons.search, color: Color(0xffffffff), size: SizeConfig.blockSizeVertical * 4,), onPressed: (){Navigator.pushNamed(context, '/home/regular/home-05-regular-search');},),
              ],

            ),
            body: Container(
              child: BlocBuilder<BlocHomeRegularUpdateCubit, int>(
                builder: (context, state){
                  return ((){
                    switch(state){
                      case 0: return HomeRegularFeedTab(); break;
                      case 1: return HomeRegularManageTab(); break;
                      case 2: return HomeRegularPostTab(); break;
                      case 3: return HomeRegularNotificationsTab(); break;
                    }
                  }());
                },
              ),
            ),
            bottomSheet: MiscRegularBottomSheet(),
            drawer: MiscRegularDrawer(),
          ),
        ),
      ),
    );
  }
}
