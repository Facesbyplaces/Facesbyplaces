import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<bool> apiRegularReport({required int postId, required String reportType, required String subject, required String body}) async{
  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  Dio dioRequest = Dio();

  var response = await dioRequest.post('https://facesbyplaces.com/api/v1/reports/report?report[reportable_type]=$reportType&report[reportable_id]=$postId&report[subject]=$subject&report[description]=$body',
    options: Options(
      followRedirects: false,
      validateStatus: (status){
        return status! < 600;
      },
      headers: <String, dynamic>{
        'Content-Type': 'application/json',
        'access-token': getAccessToken,
        'uid': getUID,
        'client': getClient,
      }
    ),
  );

  if(response.statusCode == 200){
    return true;
  }else{
    return false;
  }
}