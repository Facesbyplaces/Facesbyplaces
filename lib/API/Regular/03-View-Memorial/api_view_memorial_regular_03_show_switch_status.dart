import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<APIRegularShowSwitchStatus> apiRegularShowSwitchStatus({required int memorialId}) async{
  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  Dio dioRequest = Dio();

  var response = await dioRequest.get('https://www.facesbyplaces.com/api/v1/pageadmin/hideStatus/Memorial/$memorialId',
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
  bool showSwitchStatusManaged;
  // bool showSwitchStatusSuccess;
  // APIRegularShowSwitchStatus({required this.showSwitchStatusFamily, required this.showSwitchStatusFriends, required this.showSwitchStatusFollowers, required this.showSwitchStatusSuccess});
  APIRegularShowSwitchStatus({required this.showSwitchStatusFamily, required this.showSwitchStatusFriends, required this.showSwitchStatusFollowers, required this.showSwitchStatusManaged});

  factory APIRegularShowSwitchStatus.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularShowSwitchStatus(
      showSwitchStatusFamily: parsedJson['family'] ?? false,
      showSwitchStatusFriends: parsedJson['friends'] ?? false,
      showSwitchStatusFollowers: parsedJson['followers'] ?? false,
      showSwitchStatusManaged: parsedJson['manage'] ?? false,
      // showSwitchStatusSuccess: true,
    );
  }
}