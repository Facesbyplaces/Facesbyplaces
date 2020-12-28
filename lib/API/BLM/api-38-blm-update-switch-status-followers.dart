import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

Future<bool> apiBLMUpdateSwitchStatusFollowers(int memorialId, bool status) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  final http.Response response = await http.put('http://fbp.dev1.koda.ws/api/v1/pageadmin/unhideOrHideFollowers/Blm/$memorialId?hide=$status',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    }
  );

  print('The status of switch is ${response.statusCode}');
  print('The status of switch is ${response.body}');

  if(response.statusCode == 200){
    return true;
  }else{
    return false;
  }
}