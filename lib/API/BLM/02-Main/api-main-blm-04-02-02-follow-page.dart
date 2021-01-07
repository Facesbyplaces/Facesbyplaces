import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

Future<bool> apiBLMModifyFollowPage({String pageType, int pageId, bool follow}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  print('The page id is $pageId');
  print('The follow is $follow');

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

  print('The response status is ${response.statusCode}');
  print('The response body is ${response.body}');

  if(response.statusCode == 200){
    return true;
  }else{
    return false;
  }
}