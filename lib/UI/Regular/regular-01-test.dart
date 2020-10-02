import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter/material.dart';
// import 'package:facesbyplaces/Bloc/bloc-01-bloc.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

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