import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<String> apiBLMDeleteMemorialFriendsOrFamily({required int memorialId, required int userId, required int accountType}) async{
  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  Dio dioRequest = Dio();

  // var response = await dioRequest.delete('http://45.33.66.25:3001/api/v1/pageadmin/removeFamilyorFriend?page_type=Blm&page_id=$memorialId&user_id=$userId&account_type=$accountType',
  var response = await dioRequest.delete('http://facesbyplaces.com/api/v1/pageadmin/removeFamilyorFriend?page_type=Blm&page_id=$memorialId&user_id=$userId&account_type=$accountType',
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

  print('The status code of blm remove friends is ${response.statusCode}');

  if(response.statusCode == 200){
    return 'Success';
  }else{
    var newData = Map<String, dynamic>.from(response.data);
    return newData['error'];
  }
}