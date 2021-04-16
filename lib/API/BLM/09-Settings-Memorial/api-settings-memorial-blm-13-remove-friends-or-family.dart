import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<bool> apiBLMDeleteMemorialFriendsOrFamily({required int memorialId, required int userId, required int accountType}) async{
  
  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  Dio dioRequest = Dio();

  String pageType = 'Blm';

  if(accountType == 2){
    pageType = 'Memorial';
  }

  print('The memorialId is $memorialId');
  print('The userId is $userId');
  print('The pageType is $pageType');
  print('The accountType is $accountType');

  var response = await dioRequest.delete('http://fbp.dev1.koda.ws/api/v1/pageadmin/removeFamilyorFriend?page_type=$pageType&page_id=$memorialId&user_id=$userId&account_type=$accountType',
    options: Options(
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
    return true;
  }else{
    return false;
  }
}