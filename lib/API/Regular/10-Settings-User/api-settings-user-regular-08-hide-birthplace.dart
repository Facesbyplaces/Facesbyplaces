import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

Future<bool> apiRegularHideBirthplace({required bool hide}) async{

  bool result = false;
  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  try{
    final http.Response response = await http.put(
      Uri.http('http://fbp.dev1.koda.ws/api/v1/users/hideOrUnhideBirthplace?hide=$hide', ''),
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
    print('Error in settings hide birthplace: $e');
    result = false;
  }

  return result;
}