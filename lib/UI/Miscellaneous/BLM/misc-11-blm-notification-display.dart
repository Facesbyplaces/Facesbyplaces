import 'package:facesbyplaces/UI/Home/BLM/11-Show-Post/home-show-post-blm-01-show-original-post.dart';
import 'package:facesbyplaces/API/BLM/12-Show-Post/api-show-post-blm-01-show-original-post.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter/material.dart';

class MiscBLMNotificationDisplayTemplate extends StatelessWidget{
  final String imageIcon;
  final String notification;
  final String dateCreated;
  final int postId;

  MiscBLMNotificationDisplayTemplate({
    this.imageIcon = '',
    this.notification,
    this.dateCreated,
    this.postId,
  });

  @override
  Widget build(BuildContext context){
    SizeConfig.init(context);
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      tileColor: Color(0xffffffff),
      onTap: () async{
        print('The post id is $postId');
        context.showLoaderOverlay();
        var result = await apiBLMShowOriginalPost(postId: postId);                
        context.hideLoaderOverlay();

        Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMShowOriginalPost(postId: postId, likeStatus: result.post.likeStatus, numberOfLikes: result.post.numberOfLikes)));
      },
      leading: CircleAvatar(backgroundColor: Color(0xff888888), backgroundImage: imageIcon != null && imageIcon != '' ? NetworkImage(imageIcon) : AssetImage('assets/icons/app-icon.png')),
      title: Text(notification, style: TextStyle(fontWeight: FontWeight.w300, fontSize: SizeConfig.safeBlockHorizontal * 4),),
      subtitle: Text(dateCreated),
    );
  }
}
