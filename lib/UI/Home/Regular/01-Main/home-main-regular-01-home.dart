// ignore_for_file: file_names
import 'home-main-regular-02-home-extended.dart';
import 'package:flutter/material.dart';

class HomeRegularScreen extends StatelessWidget{
  const HomeRegularScreen();

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: HomeRegularScreenExtended(newToggleBottom: 0,),
    );
  }
}