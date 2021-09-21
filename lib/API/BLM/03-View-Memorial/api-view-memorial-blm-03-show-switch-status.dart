// ignore_for_file: file_names
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<APIBLMShowSwitchStatus> apiBLMShowSwitchStatus({required int memorialId}) async{
  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  Dio dioRequest = Dio();

  var response = await dioRequest.get('http://facesbyplaces.com/api/v1/pageadmin/hideStatus/Blm/$memorialId',
    options: Options(
      followRedirects: false,
      validateStatus: (status){
        return status! < 600;
      },
      headers: <String, dynamic>{
        'Content-Type': 'application/json',
        'access-token': getAccessToken,
        'uid': getUID,
        'client': getClient,
      }
    ),  
  );

  if(response.statusCode == 200){
    var newData = Map<String, dynamic>.from(response.data);
    return APIBLMShowSwitchStatus.fromJson(newData);
  }else{
    throw Exception('Failed to show switch status');
  }
}

class APIBLMShowSwitchStatus{
  bool switchStatusFamily;
  bool switchStatusFriends;
  bool switchStatusFollowers;
  bool switchStatusSuccess;
  APIBLMShowSwitchStatus({required this.switchStatusFamily, required this.switchStatusFriends, required this.switchStatusFollowers, required this.switchStatusSuccess});

  factory APIBLMShowSwitchStatus.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMShowSwitchStatus(
      switchStatusFamily: parsedJson['family'],
      switchStatusFriends: parsedJson['friends'],
      switchStatusFollowers: parsedJson['followers'],
      switchStatusSuccess: true,
    );
  }
}