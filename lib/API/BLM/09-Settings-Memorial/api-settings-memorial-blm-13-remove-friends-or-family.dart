import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

Future<bool> apiBLMDeleteMemorialFriendsOrFamily({required int memorialId, required int userId, required int accountType}) async{
  
  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  final http.Response response = await http.delete(
    Uri.http('http://fbp.dev1.koda.ws/api/v1/pageadmin/removeFamilyorFriend?page_type=Blm&page_id=$memorialId&user_id=$userId&account_type=$accountType', ''),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    }
  );

  if(response.statusCode == 200){
    return true;
  }else{
    return false;
  }
}