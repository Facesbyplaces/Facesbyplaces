// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:dio/dio.dart' as dio;
// import 'package:dio/dio.dart';

// Future<bool> apiRegularModifyFollowPage({int pageId, bool follow}) async{

//   bool result = false;
//   final sharedPrefs = await SharedPreferences.getInstance();
//   var getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
//   var getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
//   var getClient = sharedPrefs.getString('regular-client') ?? 'empty';

//   try{
//     var dioRequest = dio.Dio();

//     var formData;
//     formData = FormData();

//     formData = FormData.fromMap({
//       'page_type': 'Memorial',
//       'page_id': pageId,
//       'follow': follow,
//     });

//     var response = await dioRequest.put('http://fbp.dev1.koda.ws/api/v1/followers', data: formData,
//       options: Options(
//         headers: <String, String>{
//           'access-token': getAccessToken,
//           'uid': getUID,
//           'client': getClient,
//         }
//       ),  
//     );

//     print('The status code is ${response.statusCode}');
//     print('The status data is ${response.data}');

//     if(response.statusCode == 200){
//       result = true;
//     }

//   }catch(e){
//     print('The value of e is ${e.toString()}');
//     result = false;
//   }

//   return result;
// }



import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

Future<bool> apiRegularModifyFollowPage({String pageType, int pageId, bool follow}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  var getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  var getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  var getClient = sharedPrefs.getString('regular-client') ?? 'empty';

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