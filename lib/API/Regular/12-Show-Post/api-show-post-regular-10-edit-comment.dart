import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

Future<bool> apiRegularEditComment({int commentId, String commentBody}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

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

  print('The status code of edit comment in regular is ${response.statusCode}');
  print('The status body of edit comment in regular is ${response.body}');

  if(response.statusCode == 200){
    return true;
  }else{
    return false;
  }
}