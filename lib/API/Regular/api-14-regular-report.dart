import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
// import 'dart:convert';

Future<bool> apiRegularReport(int userId, int postId, String subject, String body) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  // int memorialId = sharedPrefs.getInt('regular-user-memorial-id') ?? 0;
  var getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  var getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  var getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  final http.Response response = await http.post(
    // 'http://fbp.dev1.koda.ws/api/v1/reports/report?report[reportable_type]=Post&report[reportable_id]=1&report[subject]=Inappropriate Language&report[description]=He used the "N" word.',
    'http://fbp.dev1.koda.ws/api/v1/reports/report?report[reportable_type]=Post&report[reportable_id]=1&report[user_id]=$userId&report[post_id]=$postId&report[subject]=$subject&report[description]=$body',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    }
  );

  print('The response status in report is ${response.statusCode}');
  print('The response status in report is ${response.body}');

  if(response.statusCode == 200){
    return true;
  }else{
    return false;
  }
}
