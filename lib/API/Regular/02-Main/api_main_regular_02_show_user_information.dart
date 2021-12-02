import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<APIRegularShowProfileInformation> apiRegularShowProfileInformation() async{
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

  var response = await dioRequest.get('https://www.facesbyplaces.com/api/v1/users/image_show',
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
    return APIRegularShowProfileInformation.fromJson(newData);
  }else{
    throw Exception('Error occurred: ${response.statusMessage}');
  }
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
      showProfileInformationFirstName: newValue['first_name'] ?? '',
      showProfileInformationLastName: newValue['last_name'] ?? '',
      showProfileInformationImage: newValue['image'] ?? '',
      showProfileInformationEmail: newValue['email'] ?? '',
      showProfileInformationGuest: newValue['guest'],
      showProfileInformationAccountType: newValue['account_type'],
    );
  }
}