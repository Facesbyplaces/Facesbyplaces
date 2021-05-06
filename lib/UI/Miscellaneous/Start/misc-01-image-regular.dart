import 'package:flutter/material.dart';

class MiscStartImageRegularTemplate extends StatelessWidget{

  final String image;
  const MiscStartImageRegularTemplate({this.image = 'assets/icons/frontpage-image3.png',});

  @override
  Widget build(BuildContext context){
    return Container(
      padding: const EdgeInsets.all(5),
      color: const Color(0xffffffff),
      height: 100,
      width: 100,
      child: Image.asset(image),
    );
  }
}