import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<bool> apiBLMHidePhoneNumber({required bool hide}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  Dio dioRequest = Dio();

  var response = await dioRequest.put('http://fbp.dev1.koda.ws/api/v1/users/hideOrUnhidePhonenumber?hide=$hide',
    options: Options(
      headers: <String, dynamic>{
        'Content-Type': 'application/json',
        'access-token': getAccessToken,
        'uid': getUID,
        'client': getClient,
      }
    ),  
  );

  print('The status code of hide phone number is ${response.statusCode}');

  if(response.statusCode == 200){
    return true;
  }else{
    return false;
  }

  // try{
  //   final http.Response response = await http.put(
  //     Uri.http('http://fbp.dev1.koda.ws/api/v1/users/hideOrUnhidePhonenumber?hide=$hide', ''),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json',
  //       'access-token': getAccessToken,
  //       'uid': getUID,
  //       'client': getClient,
  //     }
  //   );

  //   print('The status code of hide phone number is ${response.statusCode}');

  //   if(response.statusCode == 200){
  //     result = true;
  //   }
      
  // }catch(e){
  //   print('Error in settings hide phone number: $e');
  //   result = false;
  // }

  // return result;
}