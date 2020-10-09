import 'package:facesbyplaces/Bloc/bloc-02-bloc.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/UI/Home/home-03-feed.dart';
import 'package:facesbyplaces/UI/Home/home-09-memorial.dart';
import 'package:facesbyplaces/UI/Miscellaneous/misc-04-extra.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'home-04-search.dart';
import 'home-05-post.dart';
import 'home-10-create-memorial.dart';

class HomeScreenExtended extends StatelessWidget{

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
          appBar: MiscMainAppBar(
            appBar: BlocBuilder<HomeUpdateCubit, int>(
              builder: (context, state){
                return ((){
                  switch(state){
                    case 0: return MiscAppBar1(appBar: AppBar(),); break;
                    case 1: return MiscAppBar2(appBar: AppBar(),); break;
                    case 2: return MiscAppBar2(appBar: AppBar(),); break;
                    case 3: return Container(height: 0,); break;
                    case 4: return MiscAppBar3(appBar: AppBar(), position: 0,); break;
                    case 5: return MiscAppBar3(appBar: AppBar(), position: 4,); break;
                    case 6: return MiscAppBar3(appBar: AppBar(), position: 5,); break;
                  }
                }());
              },
            ),
          ),

          body: SingleChildScrollView(
            child: Container(
              height: SizeConfig.screenHeight,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/icons/background2.png'),
                  colorFilter: ColorFilter.srgbToLinearGamma(),
                ),
              ),

              child: BlocBuilder<HomeUpdateCubit, int>(
                builder: (context, state){
                  return ((){
                    switch(state){
                      case 0: return HomeFeed(); break;
                      case 1: return HomeSearch(); break;
                      case 2: return HomePost(); break;
                      case 3: return HomeMemorialProfile(); break;
                      case 4: return HomeCreateMemorial(); break;
                      case 5: return HomeCreateMemorial2(); break;
                      case 6: return HomeCreateMemorial3(); break;
                    }
                  }());
                },
              ),
            ),
          ),

          bottomSheet: BlocBuilder<HomeUpdateCubit, int>(
            builder: (context, state){
              return ((){
                switch(state){
                  case 0: return MiscBottomSheet(); break;
                  case 1: return Container(height: 0,); break;
                  case 2: return Container(height: 0,); break;
                  case 3: return Container(height: 0,); break;
                  case 4: return Container(height: 0,); break;
                  case 5: return Container(height: 0,); break;
                  case 6: return Container(height: 0,); break;
                }
              }());
            },
          ),

        ),
      ),
    );
  }
}