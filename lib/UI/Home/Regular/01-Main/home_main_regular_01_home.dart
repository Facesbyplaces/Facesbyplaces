import 'home_main_regular_02_home_extended.dart';
import 'package:flutter/material.dart';

class HomeRegularScreen extends StatelessWidget{
  const HomeRegularScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return const Scaffold(
      body: HomeRegularScreenExtended(newToggleBottom: 0,),
    );
  }
}