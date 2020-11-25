import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

Future<bool> apiRegularSearchMemorials(String keywords) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  // int memorialId = sharedPrefs.getInt('regular-user-memorial-id') ?? 0;
  var getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  var getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  var getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  final http.Response response = await http.get(
    'http://fbp.dev1.koda.ws/api/v1/search/memorials?keywords=$keywords&page=1',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    }
  );

  print('The response status in search profile is ${response.statusCode}');
  print('The response status in search profile is ${response.body}');

  if(response.statusCode == 200){
    return true;
  }else{
    return false;
  }
}
