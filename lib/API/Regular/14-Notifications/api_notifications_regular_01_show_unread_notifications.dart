import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<int> apiRegularShowUnreadNotifications() async{
  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  Dio dioRequest = Dio();

  // var response = await dioRequest.get('https://facesbyplaces.com/api/v1/notifications/numOfUnread',
  var response = await dioRequest.get('https://www.facesbyplaces.com/api/v1/notifications/numOfUnread',
    options: Options(
      headers: <String, dynamic>{
        'Content-Type': 'application/json',
        'access-token': getAccessToken,
        'uid': getUID,
        'client': getClient,
      },
      validateStatus: (status){
        return status! < 600;
      },
      followRedirects: false,
    ),  
  );

  if(response.statusCode == 200){
    var newData = Map<String, dynamic>.from(response.data);
    return newData['number_of_unread_notifs'];
  }else{
    throw Exception('Failed to get the user information');
  }
}
