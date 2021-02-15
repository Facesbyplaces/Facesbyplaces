import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIBLMShowProfileInformation> apiBLMShowProfileInformation() async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  final http.Response response = await http.get('http://fbp.dev1.koda.ws/api/v1/users/image_show',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    }
  );

  if(response.statusCode == 200){
    var newValue = json.decode(response.body);
    return APIBLMShowProfileInformation.fromJson(newValue);
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

  APIBLMShowProfileInformation({this.showProfileInformationUserId, this.showProfileInformationFirstName, this.showProfileInformationLastName, this.showProfileInformationImage, this.showProfileInformationEmail, this.showProfileInformationGuest});

  factory APIBLMShowProfileInformation.fromJson(Map<String, dynamic> parsedJson){

    var newValue = parsedJson['user'];

    return APIBLMShowProfileInformation(
      showProfileInformationUserId: newValue['id'],
      showProfileInformationFirstName: newValue['first_name'],
      showProfileInformationLastName: newValue['last_name'],
      showProfileInformationImage: newValue['image'],
      showProfileInformationEmail: newValue['email'],
      showProfileInformationGuest: newValue['guest'],
    );
  }
}