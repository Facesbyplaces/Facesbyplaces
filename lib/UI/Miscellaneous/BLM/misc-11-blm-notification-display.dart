import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter/material.dart';

class MiscBLMNotificationDisplayTemplate extends StatelessWidget{
  final String imageIcon;
  final List<TextSpan> content;

  MiscBLMNotificationDisplayTemplate({
    this.imageIcon = 'assets/icons/graveyard.png',
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
          
          SizedBox(width: SizeConfig.blockSizeHorizontal * 2,),

          CircleAvatar(
            backgroundColor: Color(0xff888888),
            backgroundImage: AssetImage(imageIcon),
          ),

          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: 20.0, right: 20.0),
              alignment: Alignment.centerLeft,
              child: RichText(
                text: TextSpan(
                  children: content,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}
