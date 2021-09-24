part of misc;

class MiscNotificationDisplayTemplate extends StatelessWidget{
  final String imageIcon;
  final String notification;
  final String dateCreated;
  final bool readStatus;
  final String actor;
  final VoidCallback imageOnPressed;
  final VoidCallback titleOnPressed;
  final VoidCallback notificationOnPressed;
  const MiscNotificationDisplayTemplate({Key? key, this.imageIcon = '', required this.notification, required this.dateCreated, required this.readStatus, required this.actor, required this.imageOnPressed, required this.titleOnPressed, required this.notificationOnPressed}) : super(key: key);

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
      ),
      title: EasyRichText(notification,
        patternList: [
          EasyRichTextPattern(
            targetString: actor,
            matchOption: 'first',
            style: const TextStyle(color: Color(0xff000000), fontFamily: 'NexaBold',),
            recognizer: TapGestureRecognizer()
            ..onTap = titleOnPressed
          ),
        ],
        defaultStyle: const TextStyle(fontFamily: 'NexaRegular', fontSize: 18, color: Color(0xff000000),),
      ),
      subtitle: Text(dateCreated, style: const TextStyle(fontSize: 16, fontFamily: 'RobotoLight', color: Color(0xff000000),),),
      onTap: notificationOnPressed,
    );
  }
}