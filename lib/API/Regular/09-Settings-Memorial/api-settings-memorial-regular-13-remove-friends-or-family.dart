import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<String> apiRegularDeleteMemorialFriendsOrFamily({required int memorialId, required int userId, required int accountType}) async{
  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  Dio dioRequest = Dio();

  // var response = await dioRequest.delete('http://45.33.66.25:3001/api/v1/pageadmin/removeFamilyorFriend?page_type=Memorial&page_id=$memorialId&user_id=$userId&account_type=$accountType',
  var response = await dioRequest.delete('http://facesbyplaces.com/api/v1/pageadmin/removeFamilyorFriend?page_type=Memorial&page_id=$memorialId&user_id=$userId&account_type=$accountType',
    options: Options(
      followRedirects: false,
      validateStatus: (status){
        return status! < 600;
      },
      headers: <String, dynamic>{
        'access-token': getAccessToken,
        'uid': getUID,
        'client': getClient,
      }
    ),
  );

  print('The status code of regular remove friends or family is ${response.statusCode}');

  if(response.statusCode == 200){
    return 'Success';
  }else{
    var newData = Map<String, dynamic>.from(response.data);
    return newData['error'];
  }
}