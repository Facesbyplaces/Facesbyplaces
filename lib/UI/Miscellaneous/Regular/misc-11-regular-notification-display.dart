import 'package:facesbyplaces/API/BLM/03-View-Memorial/api-view-memorial-blm-01-show-memorial-details.dart';
import 'package:facesbyplaces/API/Regular/03-View-Memorial/api-view-memorial-regular-02-show-memorial-details.dart';
import 'package:facesbyplaces/UI/Home/BLM/02-View-Memorial/home-view-memorial-blm-02-profile-memorial.dart';
import 'package:facesbyplaces/UI/Home/Regular/02-View-Memorial/home-view-memorial-regular-02-profile-memorial.dart';
import 'package:facesbyplaces/UI/Home/Regular/11-Show-Post/home-show-post-regular-01-show-original-post.dart';
import 'package:facesbyplaces/API/Regular/12-Show-Post/api-show-post-regular-01-show-original-post.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter/material.dart';

class MiscRegularNotificationDisplayTemplate extends StatelessWidget{
  final String imageIcon;
  final String notification;
  final String dateCreated;
  final int postId;
  final String notificationType;
  final bool readStatus;

  MiscRegularNotificationDisplayTemplate({
    this.imageIcon = '',
    this.notification,
    this.dateCreated,
    this.postId,
    this.notificationType,
    this.readStatus,
  });

  @override
  Widget build(BuildContext context){
    SizeConfig.init(context);
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      tileColor: readStatus == true ? Color(0xffffffff) : Color(0xffdddddd),
      onTap: () async{

        if(notificationType == 'Memorial'){
          context.showLoaderOverlay();
          var memorialProfile = await apiRegularShowMemorial(memorialId: postId);
          context.hideLoaderOverlay();

          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularMemorialProfile(memorialId: postId, pageType: notificationType, newJoin: memorialProfile.memorial.memorialFollower,)));
        }else if(notificationType == 'Blm'){
          context.showLoaderOverlay();
          var blmProfile = await apiBLMShowMemorial(memorialId: postId);
          context.hideLoaderOverlay();

          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMMemorialProfile(memorialId: postId, pageType: notificationType, newJoin: blmProfile.memorial.blmFollower,)));
        }else if(notificationType == 'Post'){
          context.showLoaderOverlay();
          var result = await apiRegularShowOriginalPost(postId: postId);                
          context.hideLoaderOverlay();

          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularShowOriginalPost(postId: postId, likeStatus: result.post.likeStatus, numberOfLikes: result.post.numberOfLikes)));
        }
      },
      leading: CircleAvatar(backgroundColor: Color(0xff888888), backgroundImage: imageIcon != null && imageIcon != '' ? NetworkImage(imageIcon) : AssetImage('assets/icons/app-icon.png')),
      title: Text(notification, style: TextStyle(fontWeight: FontWeight.w300, fontSize: SizeConfig.safeBlockHorizontal * 4),),
      subtitle: Text(dateCreated),
    );
  }
}
