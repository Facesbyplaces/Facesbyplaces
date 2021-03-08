import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

Future<bool> apiRegularModifyFollowPage({required String pageType, required int pageId, required bool follow}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  bool userSessionRegular = sharedPrefs.getBool('regular-user-session') ?? false;
  bool userSessionBLM = sharedPrefs.getBool('blm-user-session') ?? false;
  String? getAccessToken;
  String? getUID;
  String? getClient;

  if(userSessionRegular == true){
    getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
    getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
    getClient = sharedPrefs.getString('regular-client') ?? 'empty';
  }else if(userSessionBLM == true){
    getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
    getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
    getClient = sharedPrefs.getString('blm-client') ?? 'empty';
  }

  final http.Response response = await http.put(
    Uri.http('http://fbp.dev1.koda.ws/api/v1/followers', ''),
    headers: <String, String>{
      'access-token': getAccessToken!,
      'uid': getUID!,
      'client': getClient!,
    },
    body: <String, dynamic>{
      'page_type': '$pageType',
      'page_id': '$pageId',
      'follow': '$follow',
    }
  );

  if(response.statusCode == 200){
    return true;
  }else{
    return false;
  }
}