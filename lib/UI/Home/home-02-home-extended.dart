import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/UI/Miscellaneous/misc-04-extra.dart';
import 'package:facesbyplaces/UI/Home/home-03-01-feed-tab.dart';
import 'package:facesbyplaces/UI/Home/home-03-04-notifications-tab.dart';
import 'package:facesbyplaces/Bloc/bloc-02-bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'home-03-02-memorial-list-tab.dart';
import 'package:flutter/material.dart';
import 'home-03-03-post-tab.dart';

class HomeScreenExtended extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider<BlocHomeUpdateCubit>(
          create: (context) => BlocHomeUpdateCubit(),
        ),
        BlocProvider<BlocHomeUpdateToggle>(
          create: (context) => BlocHomeUpdateToggle(),
        ),
        BlocProvider<BlocHomeUpdateListSuggested>(
          create: (context) => BlocHomeUpdateListSuggested(),
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
                onPressed: (){
                  Navigator.pushNamed(context, '/home/home-04-search');},
                ),
              ],

            ),
            body: Container(
              decoration: BoxDecoration(image: DecorationImage(fit: BoxFit.cover, image: AssetImage('assets/icons/background2.png'), colorFilter: ColorFilter.srgbToLinearGamma(),),),
              child: BlocBuilder<BlocHomeUpdateCubit, int>(
                builder: (context, state){
                  return ((){
                    switch(state){
                      case 0: return HomeFeedTab(); break;
                      case 1: return HomeManageTab(); break;
                      case 2: return HomePostTab(); break;
                      case 3: return HomeNotificationsTab(); break;
                    }
                  }());
                },
              ),
            ),
            bottomSheet: MiscBottomSheet(),
            drawer: Drawer(
              child: Container(
                color: Color(0xff4EC9D4),
                child: Column(
                  children: [
                    SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                    CircleAvatar(
                      radius: SizeConfig.blockSizeVertical * 10.5,
                      backgroundColor: Color(0xffffffff),
                      child: CircleAvatar(
                        radius: SizeConfig.blockSizeVertical * 10,
                        backgroundImage: AssetImage('assets/icons/profile1.png'),
                      ),
                    ),

                    SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                    Text('Michael Philips', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 5, fontWeight: FontWeight.w500, color: Color(0xffffffff),),),

                    SizedBox(height: SizeConfig.blockSizeVertical * 5,),

                    GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: Text('Home', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 5, fontWeight: FontWeight.w200, color: Color(0xffffffff),),),
                    ),

                    SizedBox(height: SizeConfig.blockSizeVertical * 3,),

                    GestureDetector(
                      onTap: (){
                        Navigator.pushNamed(context, '/home/home-07-01-create-memorial');
                      },
                      child: Text('Create Memorial Page', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 5, fontWeight: FontWeight.w200, color: Color(0xffffffff),),),
                    ),

                    SizedBox(height: SizeConfig.blockSizeVertical * 3,),

                    Text('Notification Settings', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 5, fontWeight: FontWeight.w200, color: Color(0xffffffff),),),

                    SizedBox(height: SizeConfig.blockSizeVertical * 3,),

                    GestureDetector(
                      onTap: (){
                        Navigator.pushNamed(context, '/home/home-13-user-details');
                      },
                      child: Text('Profile Settings', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 5, fontWeight: FontWeight.w200, color: Color(0xffffffff),),),
                    ),

                    SizedBox(height: SizeConfig.blockSizeVertical * 3,),

                    GestureDetector(
                      onTap: (){

                        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                        
                      },
                      child: Text('Log Out', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 5, fontWeight: FontWeight.w200, color: Color(0xffffffff),),),
                    ),
                    
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
