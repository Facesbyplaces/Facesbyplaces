import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

Future<APIBLMShowOtherDetailsStatus> apiBLMShowOtherDetailsStatus({required int userId}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  Dio dioRequest = Dio();

  var response = await dioRequest.get('http://fbp.dev1.koda.ws/api/v1/users/otherDetailsStatus',
    options: Options(
      headers: <String, dynamic>{
        'Content-Type': 'application/json',
        'access-token': getAccessToken,
        'uid': getUID,
        'client': getClient,
      }
    ),  
  );

  print('The status code of other details status is ${response.statusCode}');

  if(response.statusCode == 200){
    var newData = Map<String, dynamic>.from(response.data);
    return APIBLMShowOtherDetailsStatus.fromJson(newData);
  }else{
    throw Exception('Failed to get the account details');
  }
}

class APIBLMShowOtherDetailsStatus{
  bool showOtherDetailsStatusHideBirthdate;
  bool showOtherDetailsStatusHideBirthplace;
  bool showOtherDetailsStatusHideEmail;
  bool showOtherDetailsStatusHideAddress;
  bool showOtherDetailsStatusHidePhoneNumber;

  APIBLMShowOtherDetailsStatus({required this.showOtherDetailsStatusHideBirthdate, required this.showOtherDetailsStatusHideBirthplace, required this.showOtherDetailsStatusHideEmail, required this.showOtherDetailsStatusHideAddress, required this.showOtherDetailsStatusHidePhoneNumber});

  factory APIBLMShowOtherDetailsStatus.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMShowOtherDetailsStatus(
      showOtherDetailsStatusHideBirthdate: parsedJson['hideBirthdate'],
      showOtherDetailsStatusHideBirthplace: parsedJson['hideBirthplace'],
      showOtherDetailsStatusHideEmail: parsedJson['hideEmail'],
      showOtherDetailsStatusHideAddress: parsedJson['hideAddress'],
      showOtherDetailsStatusHidePhoneNumber: parsedJson['hidePhonenumber'],
    );
  }
}
