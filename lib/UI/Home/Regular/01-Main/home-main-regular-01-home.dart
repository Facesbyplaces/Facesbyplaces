// ignore_for_file: file_names
import 'home-main-regular-02-home-extended.dart';
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