import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter/material.dart';

class BLMPasswordReset extends StatefulWidget{
  final String initialLink;
  BLMPasswordReset({this.initialLink});

  BLMPasswordResetState createState() => BLMPasswordResetState();
}

class BLMPasswordResetState extends State<BLMPasswordReset>{
  final String initialLink;
  BLMPasswordResetState({this.initialLink});

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

