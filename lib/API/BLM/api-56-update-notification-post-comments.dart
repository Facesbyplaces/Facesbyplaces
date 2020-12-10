import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

Future<bool> apiBLMUpdateNotificationPostComments({bool hide}) async{

  bool result = false;

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  try{
    final http.Response response = await http.put(
      'http://fbp.dev1.koda.ws/api/v1/notifications/postComments?setting=$hide',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'access-token': getAccessToken,
        'uid': getUID,
        'client': getClient,
      }
    );
    
    print('The status code for notification update post comments is ${response.statusCode}');

    if(response.statusCode == 200){
      result = true;
    }
      
  }catch(e){
    print('The e is $e');
    result = false;
  }

  return result;
}