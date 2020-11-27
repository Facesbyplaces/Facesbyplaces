import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

Future<bool> apiRegularFollowPage(int memorialId) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  var getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  var getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  var getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  final http.Response response = await http.post(
    'http://fbp.dev1.koda.ws/api/v1/followers?follower[page_type]=Memorial&follower[page_id]=$memorialId',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    }
  );

  print('The response status in follow page is ${response.statusCode}');
  print('The response status in follow page is ${response.body}');

  if(response.statusCode == 200){
    return true;
  }else{
    return false;
  }
}
