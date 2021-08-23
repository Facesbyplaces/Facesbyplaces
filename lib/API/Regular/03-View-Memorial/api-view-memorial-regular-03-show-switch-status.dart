import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<APIRegularShowSwitchStatus> apiRegularShowSwitchStatus({required int memorialId}) async{
  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  Dio dioRequest = Dio();

  print('The memorial id is $memorialId');

  // var response = await dioRequest.get('http://45.33.66.25:3001/api/v1/pageadmin/hideStatus/Memorial/$memorialId',
  var response = await dioRequest.get('http://facesbyplaces.com/api/v1/pageadmin/hideStatus/Memorial/$memorialId',
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

  print('The status code of regular show switch status is ${response.statusCode}');

  if(response.statusCode == 200){
    var newData = Map<String, dynamic>.from(response.data);
    return APIRegularShowSwitchStatus.fromJson(newData);
  }else{
    throw Exception('Error occurred: ${response.statusMessage}');
  }
}

class APIRegularShowSwitchStatus{
  bool showSwitchStatusFamily;
  bool showSwitchStatusFriends;
  bool showSwitchStatusFollowers;
  bool showSwitchStatusSuccess;
  APIRegularShowSwitchStatus({required this.showSwitchStatusFamily, required this.showSwitchStatusFriends, required this.showSwitchStatusFollowers, required this.showSwitchStatusSuccess});

  factory APIRegularShowSwitchStatus.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularShowSwitchStatus(
      showSwitchStatusFamily: parsedJson['family'],
      showSwitchStatusFriends: parsedJson['friends'],
      showSwitchStatusFollowers: parsedJson['followers'],
      showSwitchStatusSuccess: true,
    );
  }
}