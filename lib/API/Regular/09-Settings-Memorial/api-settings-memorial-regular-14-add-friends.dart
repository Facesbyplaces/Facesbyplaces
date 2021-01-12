import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

Future<bool> apiRegularAddFriends({int memorialId, int userId}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';


  final http.Response response = await http.post('http://fbp.dev1.koda.ws/api/v1/pageadmin/addFriend',
    headers: <String, String>{
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    },
    body: <String, dynamic>{
      'page_type': 'Memorial',
      'page_id': '$memorialId',
      'user_id': '$userId',
      'relationship': 'Friend',
    }
  );

  if(response.statusCode == 200){
    if(response.headers['access-token'].toString().replaceAll('[', '').replaceAll(']', '') != null && response.headers['uid'].toString().replaceAll('[', '').replaceAll(']', '') != null && response.headers['client'].toString().replaceAll('[', '').replaceAll(']', '') != null){
      sharedPrefs.setString('regular-access-token', response.headers['access-token'].toString().replaceAll('[' ,'',).replaceAll(']', ''));
      sharedPrefs.setString('regular-uid', response.headers['uid'].toString().replaceAll('[' ,'',).replaceAll(']', ''));    
      sharedPrefs.setString('regular-client', response.headers['client'].toString().replaceAll('[' ,'',).replaceAll(']', ''));
    }
    return true;
  }else{
    return false;
  }
}