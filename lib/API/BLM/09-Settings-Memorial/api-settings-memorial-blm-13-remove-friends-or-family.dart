import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

Future<bool> apiBLMDeleteMemorialFriendsOrFamily({int memorialId, int userId, int accountType}) async{
  
  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  final http.Response response = await http.delete(
    // 'http://fbp.dev1.koda.ws/api/v1/pageadmin/removeFamilyorFriend/Blm/$memorialId/$userId',
    // 'http://fbp.dev1.koda.ws/api/v1/pageadmin/removeFamilyorFriend/Blm/$memorialId/$userId',
    'http://fbp.dev1.koda.ws/api/v1/pageadmin/removeFamilyorFriend?page_type=Blm&page_id=$memorialId&user_id=$userId&account_type=$accountType',
    // /pageadmin/removeFamilyorFriend?page_type=Memorial&page_id=5&user_id=2&account_type=2
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    }
  );

  print('The status code of remove friends and family is ${response.statusCode}');

  if(response.statusCode == 200){
    return true;
  }else{
    return false;
  }
}