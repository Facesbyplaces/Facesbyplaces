import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<bool> apiRegularAddFriends({required int memorialId, required int userId, required int accountType}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  Dio dioRequest = Dio();

  var response = await dioRequest.post('http://fbp.dev1.koda.ws/api/v1/pageadmin/addFriend',
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
  //   Uri.http('http://fbp.dev1.koda.ws/api/v1/pageadmin/addFriend', ''),
  //   headers: <String, String>{
  //     'access-token': getAccessToken,
  //     'uid': getUID,
  //     'client': getClient,
  //   },
  //   body: <String, dynamic>{
  //     'page_type': 'Memorial',
  //     'page_id': '$memorialId',
  //     'user_id': '$userId',
  //     'relationship': 'Friend',
  //     'account_type': '$accountType',
  //   }
  // );

  // if(response.statusCode == 200){
  //   return true;
  // }else{
  //   return false;
  // }
}