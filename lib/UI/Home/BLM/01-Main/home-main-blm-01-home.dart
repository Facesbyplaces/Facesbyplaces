import 'home-main-blm-02-home-extended.dart';
import 'package:flutter/material.dart';

class HomeBLMScreen extends StatelessWidget{
  const HomeBLMScreen();

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: const HomeBLMScreenExtended(newToggleBottom: 0,),
    );
  }
}