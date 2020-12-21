import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter/material.dart';

class MiscBLMEmptyDisplayTemplate extends StatelessWidget{

  final String message;
  final String contentMessage;

  MiscBLMEmptyDisplayTemplate({
    this.message = 'Post is empty',
    this.contentMessage = 'Create a memorial page for loved ones by sharing stories, special events and photos of special occasions. Keeping their memories alive for generations.',
  });

  @override
  Widget build(BuildContext context){
    SizeConfig.init(context);
    return Column(
      children: [

        SizedBox(height: SizeConfig.blockSizeVertical * 5,),
        
        Center(child: Image.asset('assets/icons/app-icon.png', height: SizeConfig.blockSizeVertical * 30, width: SizeConfig.blockSizeVertical * 25,),),

        SizedBox(height: SizeConfig.blockSizeVertical * 5,),

        Center(child: Text(message, style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 5, fontWeight: FontWeight.bold, color: Color(0xffB1B1B1),),),),

        SizedBox(height: SizeConfig.blockSizeVertical * 5,),

        Padding(padding: EdgeInsets.only(left: 20.0, right: 20.0), child: Center(child: Text(contentMessage, textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),),),),

        Expanded(child: Container(),),

      ],
    );
  }
}