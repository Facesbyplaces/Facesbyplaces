import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter/material.dart';

class MiscNotificationDisplayTemplate extends StatelessWidget{
  final String imageIcon;
  final List<TextSpan> content;

  MiscNotificationDisplayTemplate({
    this.imageIcon = 'assets/icons/profile1.png',
    this.content,
  });

  @override
  Widget build(BuildContext context){
    SizeConfig.init(context);
    return Container(
      color: Color(0xffffffff),
      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: Row(
        children: [
          Expanded(
            child: CircleAvatar(radius: SizeConfig.blockSizeVertical * 3, child: Container(height: SizeConfig.blockSizeVertical * 17, child: Image.asset(imageIcon, fit: BoxFit.cover,),),),
          ),
          Expanded(
            flex: 4,
            child: Container(
              alignment: Alignment.centerLeft,
              child: RichText(
                text: TextSpan(
                  children: content,
                ),
              ),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xff000000), width: .5))
              ),
            ),
          ),
          Expanded(
            child: Container(),
          ),
        ],
      ),
    );
  }

}
