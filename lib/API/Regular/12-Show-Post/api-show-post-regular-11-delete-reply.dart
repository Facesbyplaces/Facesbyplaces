import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

Future<bool> apiRegularDeleteReply({int replyId}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  final http.Response response = await http.delete('http://fbp.dev1.koda.ws/api/v1/posts/reply?reply_id=$replyId',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    },
  );

  print('The status code of delete reply in regular is ${response.statusCode}');
  print('The status body of delete reply in regular is ${response.body}');

  if(response.statusCode == 200){
    return true;
  }else{
    return false;
  }
}