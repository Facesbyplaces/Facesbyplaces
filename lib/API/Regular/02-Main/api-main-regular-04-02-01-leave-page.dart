import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

Future<bool> apiRegularLeavePage({int memorialId}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  var getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  var getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  var getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  final http.Response response = await http.delete('http://fbp.dev1.koda.ws/api/v1/pages/memorials/$memorialId/relationship/leave',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    }
  );

  print('The status code for leave page is ${response.statusCode}');
  print('The status body for leave page is ${response.body}');

  if(response.statusCode == 200){
    // return 'Succss';
    return true;
  }else{
    // return 'Something went wrong. Please try again.';
    return false;
  }

// else if(response.statusCode == 406){
//     return 'Can\'t leave a page without another adminstrator available. Please try again.';
//   }
}