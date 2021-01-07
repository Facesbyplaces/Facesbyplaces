// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:dio/dio.dart';

// Future<bool> apiRegularAddFriends(int memorialId, int userId) async{

//   bool result = false;

//   final sharedPrefs = await SharedPreferences.getInstance();
//   String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
//   String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
//   String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

//   try{
//     var dioRequest = Dio();

//     var formData;
//     formData = FormData();
//     formData.files.addAll([
//       MapEntry('page_type', MultipartFile.fromString('Memorial'),),
//       MapEntry('page_id', MultipartFile.fromString(memorialId.toString())),
//       MapEntry('user_id', MultipartFile.fromString(userId.toString()),),
//       MapEntry('relationship', MultipartFile.fromString('Friend'),),
//     ]);

//     var response = await dioRequest.post('http://fbp.dev1.koda.ws/api/v1/pageadmin/addFriend', data: formData,
//       options: Options(
//         headers: <String, dynamic>{
//           'access-token': getAccessToken,
//           'uid': getUID,
//           'client': getClient,
//         }
//       ),  
//     );

//     print('The status code for add friends is ${response.statusCode}');
//     print('The status body for add friends is ${response.data}');

//     if(response.statusCode == 200){
//       result = true;
//     }
    
//   }catch(e){
//     print('The e is $e');
//     result = false;
//   }

//   return result;
// }



import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

Future<bool> apiRegularAddFriends({int memorialId, int userId}) async{

  // bool result = false;

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';


  final http.Response response = await http.post('http://fbp.dev1.koda.ws/api/v1/pageadmin/addFriend',
    headers: <String, String>{
      // 'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    },
    body: <String, dynamic>{
      'page_type': 'Memorial',
      'page_id': '$memorialId',
      'user_id': '$userId',
      'relationship': 'Friend',
    }
  );

  print('The add friend status is ${response.statusCode}');
  print('The add friend body is ${response.body}');

  if(response.statusCode == 200){
    return true;
  }else{
    return false;
  }
}