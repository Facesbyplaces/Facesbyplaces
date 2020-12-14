import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter/material.dart';

class RegularPasswordReset extends StatefulWidget{
  final String initialLink;
  RegularPasswordReset({this.initialLink});

  RegularPasswordResetState createState() => RegularPasswordResetState();
}

class RegularPasswordResetState extends State<RegularPasswordReset>{
  final String initialLink;
  RegularPasswordResetState({this.initialLink});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      body: Container(
        child: Center(
          child: Text('Reset password and the initial link is $initialLink'),
        ),
      ),
    );
  }
}

