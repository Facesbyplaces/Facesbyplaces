import 'package:facesbyplaces/UI/Home/BLM/11-Show-Post/home-show-post-blm-01-show-original-post-comments.dart';
import 'package:facesbyplaces/UI/Home/BLM/12-Show-User/home-show-user-blm-01-user.dart';
import 'package:facesbyplaces/UI/Home/Regular/02-View-Memorial/home-view-memorial-regular-02-profile-memorial.dart';
import 'package:facesbyplaces/API/Regular/03-View-Memorial/api-view-memorial-regular-01-show-memorial-details.dart';
import 'package:facesbyplaces/UI/Home/BLM/02-View-Memorial/home-view-memorial-blm-02-profile-memorial.dart';
import 'package:facesbyplaces/API/BLM/03-View-Memorial/api-view-memorial-blm-01-show-memorial-details.dart';
import 'package:flutter/gestures.dart';
import '../../../Configurations/size_configuration.dart';
import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter/material.dart';

class MiscBLMNotificationDisplayTemplate extends StatelessWidget{
  final String imageIcon;
  final String notification;
  final String dateCreated;
  final int postId;
  final String notificationType;
  final bool readStatus;
  final String actor;
  final int actorId;
  final int actorAccountType;
  const MiscBLMNotificationDisplayTemplate({this.imageIcon = '', required this.notification, required this.dateCreated, required this.postId, required this.notificationType, required this.readStatus, required this.actor, required this.actorId, required this.actorAccountType});

  @override
  Widget build(BuildContext context){
    SizeConfig.init(context);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      tileColor: readStatus == true ? const Color(0xffffffff) : const Color(0xffdddddd),
      leading: GestureDetector(
        child: imageIcon != ''
        ? CircleAvatar(
          backgroundColor: const Color(0xff888888),
          foregroundImage: NetworkImage(imageIcon),
          backgroundImage: const AssetImage('assets/icons/user-placeholder.png'),
        )
        : const CircleAvatar(
          backgroundColor: const Color(0xff888888),
          foregroundImage: const AssetImage('assets/icons/user-placeholder.png'),
        ),
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMUserProfile(userId: actorId, accountType: actorAccountType)));
        },
      ),
      title: EasyRichText(notification,
        patternList: [
          EasyRichTextPattern(
            targetString: '$actor',
            matchOption: 'first',
            style: TextStyle(color: Color(0xff000000), fontWeight: FontWeight.bold),
            recognizer: TapGestureRecognizer()
            ..onTap = (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMUserProfile(userId: actorId, accountType: actorAccountType)));
            }
          ),
        ],
      ),
      subtitle: Text(dateCreated, style: TextStyle(fontSize: SizeConfig.blockSizeVertical! * 1.76, fontFamily: 'RobotoLight', color: const Color(0xff000000),),),
      onTap: () async{
        if(notificationType == 'Memorial'){
          context.loaderOverlay.show();
          var memorialProfile = await apiRegularShowMemorial(memorialId: postId);
          context.loaderOverlay.hide();

          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularMemorialProfile(memorialId: postId, pageType: notificationType, newJoin: memorialProfile.almMemorial.showMemorialFollower,)));
        }else if (notificationType == 'Blm'){
          context.loaderOverlay.show();
          var blmProfile = await apiBLMShowMemorial(memorialId: postId);
          context.loaderOverlay.hide();

          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMMemorialProfile(memorialId: postId, pageType: notificationType, newJoin: blmProfile.blmMemorial.memorialFollower,)));
        }else if (notificationType == 'Post'){
          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMShowOriginalPostComments(postId: postId)));
        }
      },
    );
  }
}