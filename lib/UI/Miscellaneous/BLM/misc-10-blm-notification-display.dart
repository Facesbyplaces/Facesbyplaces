import 'package:facesbyplaces/UI/Home/BLM/11-Show-Post/home-show-post-blm-01-show-original-post-comments.dart';
import 'package:facesbyplaces/UI/Home/Regular/02-View-Memorial/home-view-memorial-regular-02-profile-memorial.dart';
import 'package:facesbyplaces/API/Regular/03-View-Memorial/api-view-memorial-regular-01-show-memorial-details.dart';
import 'package:facesbyplaces/UI/Home/BLM/02-View-Memorial/home-view-memorial-blm-02-profile-memorial.dart';
import 'package:facesbyplaces/API/BLM/03-View-Memorial/api-view-memorial-blm-01-show-memorial-details.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter/material.dart';

class MiscBLMNotificationDisplayTemplate extends StatelessWidget{
  final String imageIcon;
  final String notification;
  final String dateCreated;
  final int postId;
  final String notificationType;
  final bool readStatus;

  MiscBLMNotificationDisplayTemplate({
    this.imageIcon = '',
    required this.notification,
    required this.dateCreated,
    required this.postId,
    required this.notificationType,
    required this.readStatus,
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

          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularMemorialProfile(memorialId: postId, pageType: notificationType, newJoin: memorialProfile.almMemorial.showMemorialFollower,)));
        }else if(notificationType == 'Blm'){
          context.showLoaderOverlay();
          var blmProfile = await apiBLMShowMemorial(memorialId: postId);
          context.hideLoaderOverlay();

          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMMemorialProfile(memorialId: postId, pageType: notificationType, newJoin: blmProfile.blmMemorial.memorialFollower,)));
        }else if(notificationType == 'Post'){
          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMShowOriginalPostComments(postId: postId)));
        }
      },
      leading: imageIcon != ''
      ? CircleAvatar(
        backgroundColor: Color(0xff888888), 
        backgroundImage: NetworkImage(imageIcon),
      )
      : CircleAvatar(
        backgroundColor: Color(0xff888888), 
        backgroundImage: AssetImage('assets/icons/app-icon.png'),
      ),
      title: Text(notification, style: TextStyle(fontWeight: FontWeight.w300, fontSize: 16),),
      subtitle: Text(dateCreated),
    );
  }
}