import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';

class BLMPasswordReset extends StatefulWidget{

  BLMPasswordResetState createState() => BLMPasswordResetState();
}

class BLMPasswordResetState extends State<BLMPasswordReset>{

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
          child: Text('Success in BLM'),
        ),
      ),
    );
  }
}
