part of misc;

class MiscNotificationDisplayTemplate extends StatelessWidget{
  final String imageIcon;
  final String notification;
  final String dateCreated;
  final int postId;
  final String notificationType;
  final bool readStatus;
  final String actor;
  final int actorId;
  final int actorAccountType;
  final VoidCallback imageOnPressed;
  const MiscNotificationDisplayTemplate({Key? key, this.imageIcon = '', required this.notification, required this.dateCreated, required this.postId, required this.notificationType, required this.readStatus, required this.actor, required this.actorId, required this.actorAccountType, required this.imageOnPressed}) : super(key: key);

  @override
  Widget build(BuildContext context){
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
          backgroundColor: Color(0xff888888),
          foregroundImage: AssetImage('assets/icons/user-placeholder.png'),
        ),
        onTap: imageOnPressed,
        // onTap: (){
          // Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularUserProfile(userId: actorId, accountType: actorAccountType)));
        // },
      ),
      title: EasyRichText(notification,
        patternList: [
          EasyRichTextPattern(
            targetString: actor,
            matchOption: 'first',
            style: const TextStyle(color: Color(0xff000000), fontFamily: 'NexaBold',),
            recognizer: TapGestureRecognizer()
            ..onTap = (){
              // Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularUserProfile(userId: actorId, accountType: actorAccountType)));
            }
          ),
        ],
        defaultStyle: const TextStyle(fontFamily: 'NexaRegular', fontSize: 18, color: Color(0xff000000),),
      ),
      subtitle: Text(dateCreated, style: const TextStyle(fontSize: 16, fontFamily: 'RobotoLight', color: Color(0xff000000),),),
      onTap: () async{
        // if(notificationType == 'Memorial'){
        //   context.loaderOverlay.show();
        //   var memorialProfile = await apiRegularShowMemorial(memorialId: postId);
        //   context.loaderOverlay.hide();

        //   Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularMemorialProfile(memorialId: postId, pageType: notificationType, newJoin: memorialProfile.almMemorial.showMemorialFollower,)));
        // }else if(notificationType == 'Blm'){
        //   context.loaderOverlay.show();
        //   var blmProfile = await apiBLMShowMemorial(memorialId: postId);
        //   context.loaderOverlay.hide();

        //   Navigator.push(context, MaterialPageRoute(builder: (context) => HomeBLMMemorialProfile(memorialId: postId, pageType: notificationType, newJoin: blmProfile.blmMemorial.memorialFollower,)));
        // }else if(notificationType == 'Post'){
        //   Navigator.push(context, MaterialPageRoute(builder: (context) => HomeRegularShowOriginalPostComments(postId: postId)));
        // }
      },
    );
  }
}