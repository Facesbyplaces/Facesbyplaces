import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
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
    ResponsiveWidgets.init(context,
      height: SizeConfig.screenHeight,
      width: SizeConfig.screenWidth,
    );
    return Column(
      children: [

        Center(child: Image.asset('assets/icons/app-icon.png', height: ScreenUtil().setHeight(250), width: ScreenUtil().setWidth(250),),),

        SizedBox(height: ScreenUtil().setHeight(45)),

        Center(child: Text(message, style: TextStyle(fontSize: ScreenUtil().setSp(20, allowFontScalingSelf: true), fontWeight: FontWeight.bold, color: Color(0xffB1B1B1),),),),

        SizedBox(height: SizeConfig.blockSizeVertical * 5,),

        Padding(padding: EdgeInsets.only(left: 20.0, right: 20.0), child: Center(child: Text(contentMessage, textAlign: TextAlign.center, style: TextStyle(fontSize: ScreenUtil().setSp(16, allowFontScalingSelf: true), color: Color(0xff000000),),),),),

        SizedBox(height: ScreenUtil().setHeight(20)),

      ],
    );
  }
}