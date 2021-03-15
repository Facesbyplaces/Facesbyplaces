

import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
import 'package:dio/dio.dart';

Future<APIBLMShowProfileInformation> apiBLMShowProfileInformation() async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  Dio dioRequest = Dio();

  var response = await dioRequest.get('http://fbp.dev1.koda.ws/api/v1/users/image_show', 
    options: Options(
      headers: <String, dynamic>{
        'Content-Type': 'application/json',
        'access-token': getAccessToken,
        'uid': getUID,
        'client': getClient,
      }
    ),  
  );

  print('The status code of user is ${response.statusCode}');


  if(response.statusCode == 200){
    var newData = Map<String, dynamic>.from(response.data);
    return APIBLMShowProfileInformation.fromJson(newData);
  }else{
    throw Exception('Failed to get the user information');
  }
}

class APIBLMShowProfileInformation{
  int showProfileInformationUserId;
  String showProfileInformationFirstName;
  String showProfileInformationLastName;
  String showProfileInformationImage;
  String showProfileInformationEmail;
  bool showProfileInformationGuest;
  int showProfileInformationAccountType;

  APIBLMShowProfileInformation({required this.showProfileInformationUserId, required this.showProfileInformationFirstName, required this.showProfileInformationLastName, required this.showProfileInformationImage, required this.showProfileInformationEmail, required this.showProfileInformationGuest, required this.showProfileInformationAccountType});

  factory APIBLMShowProfileInformation.fromJson(Map<String, dynamic> parsedJson){

    var newValue = parsedJson['user'];

    return APIBLMShowProfileInformation(
      showProfileInformationUserId: newValue['id'],
      showProfileInformationFirstName: newValue['first_name'],
      showProfileInformationLastName: newValue['last_name'],
      showProfileInformationImage: newValue['image'],
      showProfileInformationEmail: newValue['email'],
      showProfileInformationGuest: newValue['guest'],
      showProfileInformationAccountType: newValue['account_type'],
    );
  }
}