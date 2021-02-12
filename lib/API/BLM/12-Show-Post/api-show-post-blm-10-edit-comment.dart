import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

Future<bool> apiBLMEditComment({int commentId, String commentBody}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  final http.Response response = await http.put('http://fbp.dev1.koda.ws/api/v1/posts/comment',
    headers: <String, String>{
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    },
    body: <String, dynamic>{
      'comment_id': '$commentId',
      'body': '$commentBody',
    }
  );

  print('The status code of edit comment is ${response.statusCode}');
  print('The status body of edit comment is ${response.body}');

  if(response.statusCode == 200){
    return true;
  }else{
    return false;
  }
}