import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<APIBLMShowProfileInformation> apiBLMShowProfileInformation() async{
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

  var response = await dioRequest.get('http://facesbyplaces.com/api/v1/users/image_show',
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
      showProfileInformationFirstName: newValue['first_name'] ?? '',
      showProfileInformationLastName: newValue['last_name'] ?? '',
      showProfileInformationImage: newValue['image'] ?? '',
      showProfileInformationEmail: newValue['email'] ?? '',
      showProfileInformationGuest: newValue['guest'],
      showProfileInformationAccountType: newValue['account_type'],
    );
  }
}