import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<String> apiBLMAddFriends({required int memorialId, required int userId, required int accountType}) async{
  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  Dio dioRequest = Dio();
  FormData formData = FormData();
  
  formData.files.addAll([
    MapEntry('page_type', MultipartFile.fromString('Blm'),),
    MapEntry('page_id', MultipartFile.fromString(memorialId.toString())),
    MapEntry('user_id', MultipartFile.fromString(userId.toString()),),
    MapEntry('relationship', MultipartFile.fromString('Friend'),),
    MapEntry('account_type', MultipartFile.fromString(accountType.toString()),),
  ]);

  var response = await dioRequest.post('http://fbp.dev1.koda.ws/api/v1/pageadmin/addFriend', data: formData,
    options: Options(
      followRedirects: false,
      validateStatus: (status){
        return status! < 600;
      },
      headers: <String, dynamic>{
        'access-token': getAccessToken,
        'uid': getUID,
        'client': getClient,
      }
    ),  
  );

  print('The status code of blm add friends is ${response.statusCode}');

  if(response.statusCode == 200){
    return 'Success';
  }else if(response.statusCode == 409){
    return 'This user is already part of the memorial page';
  }else{
    var newData = Map<String, dynamic>.from(response.data);
    return newData['error'];
  }
}