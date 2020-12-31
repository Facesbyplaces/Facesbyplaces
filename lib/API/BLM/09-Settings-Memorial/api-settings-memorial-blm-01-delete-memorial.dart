import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> apiBLMDeleteMemorial(int memorialId) async{
  final sharedPrefs = await SharedPreferences.getInstance();
  var getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  var getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  var getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  final http.Response response = await http.delete(
    'http://fbp.dev1.koda.ws/api/v1/pages/blm/$memorialId',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    }
  );

  if(response.statusCode == 200){
    return true;
  }else{
    return false;
  }
}