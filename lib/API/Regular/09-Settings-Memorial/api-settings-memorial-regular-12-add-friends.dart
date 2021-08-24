import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<String> apiRegularAddFriends({required int memorialId, required int userId, required int accountType}) async{
  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  Dio dioRequest = Dio();
  FormData formData = FormData();

  formData = FormData.fromMap({
    'page_type': 'Memorial',
    'page_id': '$memorialId',
    'user_id': '$userId',
    'relationship': 'Friend',
     'account_type': '$accountType',
  });

  var response = await dioRequest.post('http://facesbyplaces.com/api/v1/pageadmin/addFriend', data: formData,
    options: Options(
      followRedirects: false,
      validateStatus: (status){
        return status! < 600;
      },
      headers: <String, dynamic>{
        'access-token': getAccessToken,
        'uid': getUID,
        'client': getClient,
      },
    ),
  );

  print('The status code of regular add friends is ${response.statusCode}');

  if(response.statusCode == 200){
    return 'Success';
  }else if(response.statusCode == 409){
    return 'This user is already part of the memorial page';
  }else{
    var newData = Map<String, dynamic>.from(response.data);
    return newData['error'];
  }
}