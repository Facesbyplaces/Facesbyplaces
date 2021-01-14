import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

Future<bool> apiRegularUpdateSwitchStatusFriends({int memorialId, bool status}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  print('The memorial id is $memorialId');
  print('The status is $status');

  print('The access token in friends switch is $getAccessToken');
  print('The UID in friends switch is $getUID');
  print('The client in friends switch is $getClient');

  final http.Response response = await http.put('http://fbp.dev1.koda.ws/api/v1/pageadmin/unhideOrHideFriends/Memorial/$memorialId?hide=$status',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    }
  );

  print('The friends switch status is ${response.statusCode}');
  // print('The friends switch body is ${response.body}');

  if(response.statusCode == 200){
    print('Changed!');
    print('The new access token in friends switch is ${response.headers['access-token'].toString().replaceAll('[' ,'',).replaceAll(']', '')}');
    print('The new UID in friends switch is ${response.headers['uid'].toString().replaceAll('[' ,'',).replaceAll(']', '')}');
    print('The new client in friends switch is ${response.headers['client'].toString().replaceAll('[' ,'',).replaceAll(']', '')}');

    // if(response.headers['access-token'].toString().replaceAll('[', '').replaceAll(']', '') != null && response.headers['uid'].toString().replaceAll('[', '').replaceAll(']', '') != null && response.headers['client'].toString().replaceAll('[', '').replaceAll(']', '') != null){
    //   sharedPrefs.setString('regular-access-token', response.headers['access-token'].toString().replaceAll('[' ,'',).replaceAll(']', ''));
    //   sharedPrefs.setString('regular-uid', response.headers['uid'].toString().replaceAll('[' ,'',).replaceAll(']', ''));    
    //   sharedPrefs.setString('regular-client', response.headers['client'].toString().replaceAll('[' ,'',).replaceAll(']', ''));
    // }
    return true;
  }else{
    return false;
  }
}