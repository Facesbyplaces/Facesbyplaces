import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter/material.dart';

class MiscRegularNotificationDisplayTemplate extends StatelessWidget{
  final String imageIcon;
  final List<TextSpan> content;

  MiscRegularNotificationDisplayTemplate({
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

          CircleAvatar(backgroundImage: AssetImage(imageIcon), backgroundColor: Color(0xff888888),),

          SizedBox(width: SizeConfig.blockSizeHorizontal * 5,),

          Expanded(
            child: Container(
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
