import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<String> apiRegularAddFamily({required int memorialId, required int userId, required String relationship, required int accountType}) async{
  final sharedPrefs = await SharedPreferences.getInstance();
  bool userSessionRegular = sharedPrefs.getBool('regular-user-session') ?? false;
  bool userSessionBLM = sharedPrefs.getBool('blm-user-session') ?? false;
  String? getAccessToken;
  String? getUID;
  String? getClient;

  if(userSessionRegular == true){
    getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
    getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
    getClient = sharedPrefs.getString('regular-client') ?? 'empty';
  }else if(userSessionBLM == true){
    getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
    getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
    getClient = sharedPrefs.getString('blm-client') ?? 'empty';
  }

  Dio dioRequest = Dio();
  FormData formData = FormData();

  formData.files.addAll([
    MapEntry('page_type', MultipartFile.fromString('Memorial'),),
    MapEntry('page_id', MultipartFile.fromString('$memorialId')),
    MapEntry('user_id', MultipartFile.fromString('$userId'),),
    MapEntry('relationship', MultipartFile.fromString(relationship),),
    MapEntry('account_type', MultipartFile.fromString('$accountType'),),
  ]);

  var response = await dioRequest.post('https://www.facesbyplaces.com/api/v1/pageadmin/addFamily', data: formData,
    options: Options(
      headers: <String, dynamic>{
        'access-token': getAccessToken,
        'uid': getUID,
        'client': getClient,
      },
      validateStatus: (status){
        return status! < 600;
      },
      followRedirects: false,
    ),  
  );

  if(response.statusCode == 200){
    return 'Success';
  }else if(response.statusCode == 409){
    return 'This user is already part of the memorial page';
  }else{
    var newData = Map<String, dynamic>.from(response.data);
    return newData['error'];
  }
}