import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

Future<bool> apiRegularMemorialSetRelationship({required int memorialId, required String relationship}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  Dio dioRequest = Dio();

  var response = await dioRequest.post('http://fbp.dev1.koda.ws/api/v1/pages/memorials/relationship',
    options: Options(
      headers: <String, dynamic>{
        'access-token': getAccessToken,
        'uid': getUID,
        'client': getClient,
      }
    ),
  );

  print('The page friends settings is ${response.statusCode}');

  if(response.statusCode == 200){
    return true;
  }else{
    return false;
  }

  // final http.Response response = await http.post(
  //   Uri.http('http://fbp.dev1.koda.ws/api/v1/pages/memorials/relationship', ''),
  //   headers: <String, String>{
  //     'access-token': getAccessToken,
  //     'uid': getUID,
  //     'client': getClient,
  //   },
  //   body: <String, dynamic>{
  //     'id': '$memorialId',
  //     'relationship': '$relationship',
  //   },
  // );

  // if(response.statusCode == 200){
  //   return true;
  // }else{
  //   return false;
  // }
}