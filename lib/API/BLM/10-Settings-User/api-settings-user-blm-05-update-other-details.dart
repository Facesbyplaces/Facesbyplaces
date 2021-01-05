// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:dio/dio.dart';

// Future<bool> apiBLMUpdateOtherDetails({String birthdate, String birthplace, String email, String address, String phoneNumber}) async{

//   bool result = false;

//   final sharedPrefs = await SharedPreferences.getInstance();
//   String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
//   String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
//   String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

//   try{
//     var dioRequest = Dio();

//     var formData;
//     formData = FormData();

//     if(birthdate != null && birthdate != ''){
//       formData.files.add(
//         MapEntry('birthdate', MultipartFile.fromString(birthdate),),
//       );
//     }

//     if(birthplace != null && birthplace != ''){
//       formData.files.add(
//         MapEntry('birthplace', MultipartFile.fromString(birthplace)),
//       );
//     }

//     if(email != null && email != ''){
//       formData.files.add(
//         MapEntry('email', MultipartFile.fromString(email)),
//       );
//     }

//     if(address != null && address != ''){
//       formData.files.add(
//         MapEntry('address', MultipartFile.fromString(address)),
//       );
//     }

//     if(phoneNumber != null && phoneNumber != ''){
//       formData.files.add(
//         MapEntry('phone_number', MultipartFile.fromString(phoneNumber)),
//       );
//     }

//     // formData.files.addAll([
//     //   // MapEntry('birthdate', MultipartFile.fromString(birthdate),),
//     //   // MapEntry('birthplace', MultipartFile.fromString(birthplace)),
//     //   // MapEntry('email', MultipartFile.fromString(email)),
//     //   // MapEntry('address', MultipartFile.fromString(address)),
//     //   // MapEntry('phone_number', MultipartFile.fromString(phoneNumber)),
//     // ]);

//     var response = await dioRequest.put('http://fbp.dev1.koda.ws/api/v1/users/updateOtherInfos', data: formData,
//       options: Options(
//         headers: <String, dynamic>{
//           'access-token': getAccessToken,
//           'uid': getUID,
//           'client': getClient,
//         }
//       ),  
//     );

//     print('The response of update other details is ${response.statusCode}');
//     print('The response of update other details is ${response.data}');

//     if(response.statusCode == 200){
//       result = true;
//     }
    
//   }catch(e){
//     result = false;
//   }

//   return result;
// }



import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

Future<bool> apiBLMUpdateOtherDetails({String birthdate, String birthplace, String email, String address, String phoneNumber}) async{

  bool result = false;

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  try{

    // formData.files.addAll([
    //   // MapEntry('birthdate', MultipartFile.fromString(birthdate),),
    //   // MapEntry('birthplace', MultipartFile.fromString(birthplace)),
    //   // MapEntry('email', MultipartFile.fromString(email)),
    //   // MapEntry('address', MultipartFile.fromString(address)),
    //   // MapEntry('phone_number', MultipartFile.fromString(phoneNumber)),
    // ]);

    // Map<String, String> value;

    // List<dynamic> list = [birthdate, birthplace, email, address, phoneNumber];
    // List<String> name = ['birthdate', 'birthplace', 'email', 'address', 'phone_number'];

    // Map<String, dynamic> value = {};

    // for(int i = 0; i < 4; i++){
    //   if(list[i] != '' && list[i] != null){
    //     value.addAll({name[i]: list[i]});
    //   }
    // }

    // print('The image adsfas is $image');

    // final formData = dio.FormData.fromMap(value);

    // if(image != '' && image != null){
    //   var file = await dio.MultipartFile.fromFile(image.path, filename: image.path);
    //   formData.files.add(MapEntry('user[image]', file));
    // }

    
    // 'http://fbp.dev1.koda.ws/api/v1/users/updateOtherInfos',

    final http.Response response = await http.put(
      
      'http://fbp.dev1.koda.ws/api/v1/users/updateOtherInfos?birthdate=$birthdate&birthplace=$birthplace&email=$email&address=$address&phone_number=$phoneNumber',
      headers: <String, String>{
        'access-token': getAccessToken,
        'uid': getUID,
        'client': getClient,
      },
    );

    print('The response of update other details is ${response.statusCode}');
    print('The response of update other details is ${response.body}');

    if(response.statusCode == 200){
      result = true;
    }
    
  }catch(e){
    print('The e is $e');
    result = false;
  }

  return result;
}