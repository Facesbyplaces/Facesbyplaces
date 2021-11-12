part of misc;

class MiscLikeButtonTemplate extends StatefulWidget{
  final bool likeStatus;
  final int numberOfLikes;
  final String commentableType;
  final int commentableId;
  final int postType; // ALM OR BLM (1 - BLM | 2 - ALM)
  const MiscLikeButtonTemplate({Key? key, required this.likeStatus, required this.numberOfLikes, required this.commentableType, required this.commentableId, required this.postType}) : super(key: key);

  @override
  MiscLikeButtonTemplateState createState() => MiscLikeButtonTemplateState();
}

class MiscLikeButtonTemplateState extends State<MiscLikeButtonTemplate>{
  final ValueNotifier<bool> _likeStatus = ValueNotifier<bool>(false);
  final ValueNotifier<int> _numberOfLikes = ValueNotifier<int>(0);

  @override
  void initState(){
    super.initState();
    _likeStatus.value = widget.likeStatus;
    _numberOfLikes.value = widget.numberOfLikes;
  }

  @override
  Widget build(BuildContext context){
    return ValueListenableBuilder(
      valueListenable: _likeStatus,
      builder: (_, bool _likeStatusListener, __) => ValueListenableBuilder(
        valueListenable: _numberOfLikes,
        builder: (_, int _numberOfLikesListener, __) => TextButton.icon(
          onPressed: () async{
            if(_likeStatus.value){
              _likeStatus.value = false;
              _numberOfLikes.value--;

              await apiLikeOrUnlikeCommentReply(commentableType: widget.commentableType, commentableId: widget.commentableId, likeStatus: false);
            }else{
              _likeStatus.value = true;
              _numberOfLikes.value++;

              await apiLikeOrUnlikeCommentReply(commentableType: widget.commentableType, commentableId: widget.commentableId, likeStatus: true);
            }
          },
          icon: ((){
            if(widget.postType == 1){ // BLM ICON
              if(_likeStatusListener){
                return const FaIcon(FontAwesomeIcons.peace, color: Color(0xffff0000),);
              }else{
                return const FaIcon(FontAwesomeIcons.peace, color: Color(0xff888888),);
              }
            }else{ // ALM ICON
              if(_likeStatusListener){
                return const FaIcon(FontAwesomeIcons.solidHeart, color: Color(0xffE74C3C),);
              }else{
                return const FaIcon(FontAwesomeIcons.heart, color: Color(0xff888888),);
              }
            }
          }()),
          label: Text('$_numberOfLikesListener', style: const TextStyle(fontSize: 20, fontFamily: 'NexaRegular', color: Color(0xffBDC3C7),),),
        ),
      ),
    );
  }
}

Future<bool> apiLikeOrUnlikeCommentReply({required String commentableType, required int commentableId, required bool likeStatus}) async{
  final sharedPrefs = await SharedPreferences.getInstance();
  bool userSessionRegular = sharedPrefs.getBool('regular-user-session') ?? false;
  bool userSessionBLM = sharedPrefs.getBool('blm-user-session') ?? false;
  String? getAccessToken;
  String? getUID;
  String? getClient;

  if(userSessionRegular == true){
    getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
    getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
    getClient = sharedPrefs.getString('regular-client') ?? 'empty';
  }else if(userSessionBLM == true){
    getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
    getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
    getClient = sharedPrefs.getString('blm-client') ?? 'empty';
  }

  Dio dioRequest = Dio();

  var response = await dioRequest.put('https://www.facesbyplaces.com/api/v1/posts/comment/unlikeOrLikeComment?commentable_type=$commentableType&commentable_id=$commentableId&like=$likeStatus',
    options: Options(
      headers: <String, dynamic>{
        'access-token': getAccessToken,
        'uid': getUID,
        'client': getClient,
      },
      validateStatus: (status){
        return status! < 600;
      },
      followRedirects: false,
    ),
  );

  if(response.statusCode == 200){
    return true;
  }else{
    return false;
  }
}