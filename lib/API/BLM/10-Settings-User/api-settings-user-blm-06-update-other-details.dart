import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<bool> apiBLMUpdateOtherDetails({required String birthdate, required String birthplace, required String email, required String address, required String phoneNumber}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  print('The birthdate is $birthdate');
  print('The birthplace is $birthplace');
  print('The email is $email');
  print('The address is $address');
  print('The phoneNumber is $phoneNumber');

  Dio dioRequest = Dio();

  var response = await dioRequest.put('http://fbp.dev1.koda.ws/api/v1/users/updateOtherInfos?birthdate=$birthdate&birthplace=$birthplace&email=$email&address=$address&phone_number=$phoneNumber',
    options: Options(
      headers: <String, dynamic>{
        'Content-Type': 'application/json',
        'access-token': getAccessToken,
        'uid': getUID,
        'client': getClient,
      }
    ),  
  );

  print('The status code of update other details status is ${response.statusCode}');

  if(response.statusCode == 200){
    return true;
  }else{
    return false;
  }

  // try{

  //   final http.Response response = await http.put(
  //     Uri.http('http://fbp.dev1.koda.ws/api/v1/users/updateOtherInfos?birthdate=$birthdate&birthplace=$birthplace&email=$email&address=$address&phone_number=$phoneNumber', ''),
  //     headers: <String, String>{
  //       'access-token': getAccessToken,
  //       'uid': getUID,
  //       'client': getClient,
  //     },
  //   );

  //   print('The status of other details is ${response.statusCode}');

  //   if(response.statusCode == 200){
  //     result = true;
  //   }
    
  // }catch(e){
  //   print('Error in settings update other details: $e');
  //   result = false;
  // }

  // return result;
}