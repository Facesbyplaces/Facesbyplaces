import 'package:facesbyplaces/Bloc/bloc-02-bloc.dart';
import 'package:facesbyplaces/UI/Home/home-02-home-extended.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<BlocHomeUpdateCubit>(
            create: (context) => BlocHomeUpdateCubit(),
          ),
          BlocProvider<BlocHomeUpdateToggle>(
            create: (context) => BlocHomeUpdateToggle(),
          ),
          BlocProvider<BlocHomeUpdateToggleFeed>(
            create: (context) => BlocHomeUpdateToggleFeed(),
          ),
          BlocProvider<BlocHomeUpdateListSuggested>(
            create: (context) => BlocHomeUpdateListSuggested(),
          ),
          BlocProvider<BlocHomeUpdateListNearby>(
            create: (context) => BlocHomeUpdateListNearby(),
          ),
          BlocProvider<BlocHomeUpdateListBLM>(
            create: (context) => BlocHomeUpdateListBLM(),
          ),
          BlocProvider<BlocHomeUpdateMemorialToggle>(
            create: (context) => BlocHomeUpdateMemorialToggle(),
          ),
          BlocProvider<BlocUserProfileTabs>(
            create: (context) => BlocUserProfileTabs(),
          ),
        ],
      child: HomeScreenExtended(),
      ),
    );
  }
}