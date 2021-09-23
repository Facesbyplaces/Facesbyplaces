import 'home_main_blm_02_home_extended.dart';
import 'package:flutter/material.dart';

class HomeBLMScreen extends StatelessWidget{
  const HomeBLMScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return const Scaffold(
      body: HomeBLMScreenExtended(newToggleBottom: 0,),
    );
  }
}