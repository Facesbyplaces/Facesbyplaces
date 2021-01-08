import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

Future<bool> apiBLMReport({int postId, String reportType, String subject, String body}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';


  final http.Response response = await http.post(
    // 'http://fbp.dev1.koda.ws/api/v1/reports/report?report[reportable_type]=Post&report[reportable_id]=1&report[user_id]=$userId&report[post_id]=$postId&report[subject]=$subject&report[description]=$body',
    'http://fbp.dev1.koda.ws/api/v1/reports/report?report[reportable_type]=$reportType&report[reportable_id]=$postId&report[subject]=$subject&report[description]=$body',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    }
  );

  print('The response status of report is ${response.statusCode}');
  print('The response body of report is ${response.body}');

  if(response.statusCode == 200){
    return true;
  }else{
    return false;
  }
}
