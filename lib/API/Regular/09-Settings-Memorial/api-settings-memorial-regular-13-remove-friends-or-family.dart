import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<bool> apiRegularDeleteMemorialFriendsOrFamily({required int memorialId, required int userId, required int accountType}) async{
  
  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  Dio dioRequest = Dio();
  String pageType = 'Memorial';

  if(accountType == 1){
    pageType = 'Blm';
  }

  print('The memorialId is $memorialId');
  print('The userId is $userId');
  print('The pageType is $pageType');
  print('The accountType is $accountType');

  var response = await dioRequest.delete('http://fbp.dev1.koda.ws/api/v1/pageadmin/removeFamilyorFriend?page_type=$pageType&page_id=$memorialId&user_id=$userId&account_type=$accountType',
    options: Options(
      headers: <String, dynamic>{
        'access-token': getAccessToken,
        'uid': getUID,
        'client': getClient,
      }
    ),
  );

  print('The status code of regular remove friends or family is ${response.statusCode}');

  if(response.statusCode == 200){
    return true;
  }else{
    return false;
  }
}