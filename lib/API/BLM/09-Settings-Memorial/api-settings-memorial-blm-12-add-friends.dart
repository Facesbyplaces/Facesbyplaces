import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<bool> apiBLMAddFriends(int memorialId, int userId) async{

  bool result = false;

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  try{
    var dioRequest = Dio();

    var formData;
    formData = FormData();
    formData.files.addAll([
      MapEntry('page_type', MultipartFile.fromString('Blm'),),
      MapEntry('page_id', MultipartFile.fromString(memorialId.toString())),
      MapEntry('user_id', MultipartFile.fromString(userId.toString()),),
      MapEntry('relationship', MultipartFile.fromString('Friend'),),
    ]);

    var response = await dioRequest.post('http://fbp.dev1.koda.ws/api/v1/pageadmin/addFriend', data: formData,
      options: Options(
        headers: <String, dynamic>{
          'access-token': getAccessToken,
          'uid': getUID,
          'client': getClient,
        }
      ),  
    );


    if(response.statusCode == 200){
      result = true;
    }
    
  }catch(e){
    result = false;
  }

  return result;
}