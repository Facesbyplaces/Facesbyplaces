// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;

// Future<bool> apiRegularShowPageDetails() async{

//   final sharedPrefs = await SharedPreferences.getInstance();
//   int memorialId = sharedPrefs.getInt('blm-user-memorial-id') ?? 0;

//   final http.Response response = await http.get(
//     'http://fbp.dev1.koda.ws/api/v1/pages/blm/$memorialId',
//     headers: <String, String>{
//       'Content-Type': 'application/json',
//     }
//   );

//   print('The response status in show memorial is ${response.statusCode}');
//   print('The response status in show memorial is ${response.body}');

//   if(response.statusCode == 200){
//     return true;
//   }else{
//     return false;
//   }
// }