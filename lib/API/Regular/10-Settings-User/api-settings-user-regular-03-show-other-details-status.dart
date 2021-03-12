import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<APIRegularShowOtherDetailsStatus> apiRegularShowOtherDetailsStatus({required int userId}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  Dio dioRequest = Dio();

  var response = await dioRequest.get('http://fbp.dev1.koda.ws/api/v1/users/otherDetailsStatus',
    options: Options(
      headers: <String, dynamic>{
        'access-token': getAccessToken,
        'uid': getUID,
        'client': getClient,
      }
    ),
  );

  print('The status code of other details is ${response.statusCode}');

  if(response.statusCode == 200){
    var newData = Map<String, dynamic>.from(response.data);
    return APIRegularShowOtherDetailsStatus.fromJson(newData);
  }else{
    throw Exception('Error occurred: ${response.statusMessage}');
  }
}

class APIRegularShowOtherDetailsStatus{
  bool showOtherDetailsStatusHideBirthdate;
  bool showOtherDetailsStatusHideBirthplace;
  bool showOtherDetailsStatusHideEmail;
  bool showOtherDetailsStatusHideAddress;
  bool showOtherDetailsStatusHidePhoneNumber;

  APIRegularShowOtherDetailsStatus({required this.showOtherDetailsStatusHideBirthdate, required this.showOtherDetailsStatusHideBirthplace, required this.showOtherDetailsStatusHideEmail, required this.showOtherDetailsStatusHideAddress, required this.showOtherDetailsStatusHidePhoneNumber});

  factory APIRegularShowOtherDetailsStatus.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularShowOtherDetailsStatus(
      showOtherDetailsStatusHideBirthdate: parsedJson['hideBirthdate'],
      showOtherDetailsStatusHideBirthplace: parsedJson['hideBirthplace'],
      showOtherDetailsStatusHideEmail: parsedJson['hideEmail'],
      showOtherDetailsStatusHideAddress: parsedJson['hideAddress'],
      showOtherDetailsStatusHidePhoneNumber: parsedJson['hidePhonenumber'],
    );
  }
}
