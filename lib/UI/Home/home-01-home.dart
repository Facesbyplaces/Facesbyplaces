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
          BlocProvider<HomeUpdateCubit>(
            create: (context) => HomeUpdateCubit(),
          ),
          BlocProvider<HomeUpdateToggle>(
            create: (context) => HomeUpdateToggle(),
          ),
          BlocProvider<HomeUpdateToggleFeed>(
            create: (context) => HomeUpdateToggleFeed(),
          ),
          BlocProvider<HomeUpdateListSuggested>(
            create: (context) => HomeUpdateListSuggested(),
          ),
          BlocProvider<HomeUpdateListNearby>(
            create: (context) => HomeUpdateListNearby(),
          ),
          BlocProvider<HomeUpdateListBLM>(
            create: (context) => HomeUpdateListBLM(),
          ),
        ],
      child: HomeScreenExtended(),
      ),
    );
  }
}