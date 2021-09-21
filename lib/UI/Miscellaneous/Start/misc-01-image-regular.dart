// ignore_for_file: file_names
import 'package:flutter/material.dart';

class MiscStartImageRegularTemplate extends StatelessWidget{
  final String image;
  const MiscStartImageRegularTemplate({Key? key, this.image = 'assets/icons/frontpage-image3.png',}) : super(key: key);

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