import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

Future<APIRegularShowProfileInformation> apiRegularShowProfileInformation() async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  Dio dioRequest = Dio();

  var response = await dioRequest.get('http://fbp.dev1.koda.ws/api/v1/users/image_show',
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
    return APIRegularShowProfileInformation.fromJson(newData);
  }else{
    throw Exception('Error occurred: ${response.statusMessage}');
  }

  // final http.Response response = await http.get(
  //   // Uri.http('http://fbp.dev1.koda.ws/api/v1/users/image_show', ''),
  //   Uri.http('fbp.dev1.koda.ws', '/api/v1/users/image_show',),
  //   headers: <String, String>{
  //     'Content-Type': 'application/json',
  //     'access-token': getAccessToken,
  //     'uid': getUID,
  //     'client': getClient,
  //   }
  // );

  // if(response.statusCode == 200){
  //   var newValue = json.decode(response.body);
  //   return APIRegularShowProfileInformation.fromJson(newValue);
  // }else{
  //   throw Exception('Failed to get the user information');
  // }
}

class APIRegularShowProfileInformation{
  int showProfileInformationUserId;
  String showProfileInformationFirstName;
  String showProfileInformationLastName;
  String showProfileInformationImage;
  String showProfileInformationEmail;
  bool showProfileInformationGuest;
  int showProfileInformationAccountType;

  APIRegularShowProfileInformation({required this.showProfileInformationUserId, required this.showProfileInformationFirstName, required this.showProfileInformationLastName, required this.showProfileInformationImage, required this.showProfileInformationEmail, required this.showProfileInformationGuest, required this.showProfileInformationAccountType});

  factory APIRegularShowProfileInformation.fromJson(Map<String, dynamic> parsedJson){

    var newValue = parsedJson['user'];

    return APIRegularShowProfileInformation(
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