import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter/material.dart';

class MiscBLMMessageTemplate extends StatelessWidget{

  final String message;

  MiscBLMMessageTemplate({this.message = 'Enter Verification Code'});

  @override
  Widget build(BuildContext context){
    SizeConfig.init(context);
    return Padding(
      padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 8,),
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          height: SizeConfig.blockSizeVertical * 5,
          width: SizeConfig.screenWidth / 1.2,
          child: Center(
            child: Text(message, 
              textAlign: TextAlign.center, 
              style: TextStyle(
                fontSize: SizeConfig.safeBlockHorizontal * 4,
                fontWeight: FontWeight.w300,
                color: Color(0xffffffff),
              ),
            ),
          ),
          decoration: BoxDecoration(
            color: Color(0xff000000),
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
        ),
      ),
    );
  }
}

