import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

Future<bool> apiBLMMemorialSetRelationship({int memorialId, String relationship}) async{
  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  final http.Response response = await http.post(
    'http://fbp.dev1.koda.ws/api/v1/pages/memorials/relationship',
    headers: <String, String>{
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    },
    body: <String, dynamic>{
      'id': '$memorialId',
      'relationship': '$relationship',
    },
  );

  print('The status of set relationship is ${response.statusCode}');
  print('The status of set relationship is ${response.body}');

  if(response.statusCode == 200){
    return true;
  }else{
    return false;
  }
}