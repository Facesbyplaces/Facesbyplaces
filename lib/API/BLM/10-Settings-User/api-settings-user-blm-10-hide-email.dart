import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

Future<bool> apiBLMHideEmail({required bool hide}) async{

  bool result = false;

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  try{
    final http.Response response = await http.put(
      Uri.http('http://fbp.dev1.koda.ws/api/v1/users/hideOrUnhideEmail?hide=$hide', ''),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'access-token': getAccessToken,
        'uid': getUID,
        'client': getClient,
      }
    );

    if(response.statusCode == 200){
      result = true;
    }
      
  }catch(e){
    print('Error in settings hide email: $e');
    result = false;
  }

  return result;
}