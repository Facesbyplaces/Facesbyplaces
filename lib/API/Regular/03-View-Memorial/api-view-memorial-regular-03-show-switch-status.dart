import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<APIRegularShowSwitchStatus> apiRegularShowSwitchStatus({required int memorialId}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  Dio dioRequest = Dio();

  var response = await dioRequest.get('http://fbp.dev1.koda.ws/api/v1/pageadmin/hideStatus/Memorial/$memorialId',
    options: Options(
      headers: <String, dynamic>{
        'access-token': getAccessToken,
        'uid': getUID,
        'client': getClient,
      }
    ),
  );

  if(response.statusCode == 200){
    var newData = Map<String, dynamic>.from(response.data);
    print('The first name is ${response.data}');
    return APIRegularShowSwitchStatus.fromJson(newData);
  }else{
    throw Exception('Error occurred: ${response.statusMessage}');
  }

  // final http.Response response = await http.get(
  //   Uri.http('http://fbp.dev1.koda.ws/api/v1/pageadmin/hideStatus/Memorial/$memorialId', ''),
  //   headers: <String, String>{
  //     'Content-Type': 'application/json',
  //     'access-token': getAccessToken,
  //     'uid': getUID,
  //     'client': getClient,
  //   }
  // );

  // if(response.statusCode == 200){
  //   var newValue = json.decode(response.body);
  //   return APIRegularShowSwitchStatus.fromJson(newValue);
  // }else{
  //   throw Exception('Failed to get the lists.');
  // }
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
