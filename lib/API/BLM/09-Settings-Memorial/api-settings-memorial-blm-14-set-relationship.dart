import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

Future<bool> apiBLMMemorialSetRelationship({int memorialId, String relationship}) async{
  final sharedPrefs = await SharedPreferences.getInstance();
  var getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  var getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  var getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  final http.Response response = await http.post(
    'http://fbp.dev1.koda.ws/api/v1/pages/blm/relationship',
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