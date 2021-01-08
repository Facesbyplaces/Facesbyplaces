// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;

// Future<String> apiBLMLeavePage(int memorialId) async{

//   final sharedPrefs = await SharedPreferences.getInstance();
//   var getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
//   var getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
//   var getClient = sharedPrefs.getString('blm-client') ?? 'empty';

//   final http.Response response = await http.delete(
//     'http://fbp.dev1.koda.ws/api/v1/pages/blm/$memorialId/relationship/leave',
//     headers: <String, String>{
//       'Content-Type': 'application/json',
//       'access-token': getAccessToken,
//       'uid': getUID,
//       'client': getClient,
//     }
//   );

//   if(response.statusCode == 200){
//     return 'Succuess';
//   }else if(response.statusCode == 406){
//     return 'Can\'t leave a page without another adminstrator available. Please try again.';
//   }else{
//     return 'Something went wrong. Please try again.';
//   }
// }