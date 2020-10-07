import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter/material.dart';

class RegularTest extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Stack(
      children: [

        Container(color: Colors.red,),

      ],
    );
  }
}