import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

Future<bool> apiRegularEditReply({required int replyId, required String replyBody}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  final http.Response response = await http.put(
    Uri.http('http://fbp.dev1.koda.ws/api/v1/posts/reply', ''),
    headers: <String, String>{
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    },
    body: <String, dynamic>{
      'reply_id': '$replyId',
      'body': '$replyBody',
    }
  );

  if(response.statusCode == 200){
    return true;
  }else{
    return false;
  }
}