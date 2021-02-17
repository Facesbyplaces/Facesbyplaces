import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

Future<bool> apiRegularModifyFollowPage({String pageType, int pageId, bool follow}) async{

  print('The follow is $follow');

  final sharedPrefs = await SharedPreferences.getInstance();
  bool userSessionRegular = sharedPrefs.getBool('regular-user-session') ?? false;
  bool userSessionBLM = sharedPrefs.getBool('blm-user-session') ?? false;
  String getAccessToken;
  String getUID;
  String getClient;

  if(userSessionRegular == true){
    getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
    getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
    getClient = sharedPrefs.getString('regular-client') ?? 'empty';
  }else if(userSessionBLM == true){
    getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
    getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
    getClient = sharedPrefs.getString('blm-client') ?? 'empty';
  }

  print('The getAccessToken is $getAccessToken');
  print('The getUID is $getUID');
  print('The getClient is $getClient');

  final http.Response response = await http.put('http://fbp.dev1.koda.ws/api/v1/followers',
    headers: <String, String>{
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    },
    body: <String, dynamic>{
      'page_type': '$pageType',
      'page_id': '$pageId',
      'follow': '$follow',
    }
  );

  print('The status code of follow page is ${response.statusCode}');
  print('The status body of follow page is ${response.body}');
  print('The status headers of follow page is ${response.headers}');

  if(response.statusCode == 200){
    return true;
  }else{
    return false;
  }
}