import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/UI/Home/Regular/11-Show-Post/home-show-post-regular-02-show-comments.dart';
import 'package:flutter/material.dart';

class MiscRegularNotificationDisplayTemplate extends StatelessWidget{
  final String imageIcon;
  final List<TextSpan> content;
  final int postId;

  MiscRegularNotificationDisplayTemplate({
    // this.imageIcon = 'assets/icons/app-icon.png',
    this.imageIcon = '',
    this.content,
    this.postId,
  });

  @override
  Widget build(BuildContext context){
    SizeConfig.init(context);
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularShowCommentsList(postId: postId,)));
      },
      child: Container(
        color: Color(0xffffffff),
        padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
        child: Row(
          children: [
            SizedBox(width: SizeConfig.blockSizeHorizontal * 2,),

            // CircleAvatar(backgroundImage: AssetImage(imageIcon), backgroundColor: Color(0xff888888),),
            
            CircleAvatar(backgroundColor: Color(0xff888888), backgroundImage: imageIcon != null && imageIcon != '' ? NetworkImage(imageIcon) : AssetImage('assets/icons/app-icon.png')),

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
      ),
    );
  }

}
