import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

Future<bool> apiRegularDeleteMemorial() async{
  
  final sharedPrefs = await SharedPreferences.getInstance();
  int memorialId = sharedPrefs.getInt('regular-user-memorial-id') ?? 0;
  var getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  var getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  var getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  final http.Response response = await http.delete(
    'http://fbp.dev1.koda.ws/api/v1/pages/memorials/$memorialId',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    }
  );

  print('The response status is ${response.statusCode}');
  // print('The response status is ${response.body}');

  if(response.statusCode == 200){
    return true;
  }else{
    return false;
  }
}