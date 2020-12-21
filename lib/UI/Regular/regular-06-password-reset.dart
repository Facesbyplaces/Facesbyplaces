import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';

class RegularPasswordReset extends StatefulWidget{

  RegularPasswordResetState createState() => RegularPasswordResetState();
}

class RegularPasswordResetState extends State<RegularPasswordReset>{

  void initState(){
    super.initState();
    FlutterBranchSdk.logout();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      body: Container(
        child: Center(
          child: Text('Success!'),
        ),
      ),
    );
  }
}

