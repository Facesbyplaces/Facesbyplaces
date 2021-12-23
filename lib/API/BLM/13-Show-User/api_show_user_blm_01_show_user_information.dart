import 'package:shared_preferences/shared_preferences.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:dio/dio.dart';

Future<APIBLMShowUserInformation> apiBLMShowUserInformation({required int userId, required int accountType}) async{
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

  var response = await dioRequest.get('https://www.facesbyplaces.com/api/v1/users/showDetails?user_id=$userId&account_type=$accountType',
    options: Options(
      headers: <String, dynamic>{
        'Content-Type': 'application/json',
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
    return APIBLMShowUserInformation.fromJson(newData);
  }else{
    throw Exception('Failed to get the user profile');
  }
}

class APIBLMShowUserInformation{
  int showUserInformationId;
  String showUserInformationFirstName;
  String showUserInformationLastName;
  String showUserInformationBirthdate;
  String showUserInformationBirthplace;
  String showUserInformationHomeAddress;
  String showUserInformationEmailAddress;
  String showUserInformationContactNumber;
  String showUserInformationImage;
  APIBLMShowUserInformation({required this.showUserInformationId, required this.showUserInformationFirstName, required this.showUserInformationLastName, required this.showUserInformationBirthdate, required this.showUserInformationBirthplace, required this.showUserInformationHomeAddress, required this.showUserInformationEmailAddress, required this.showUserInformationContactNumber, required this.showUserInformationImage});

  factory APIBLMShowUserInformation.fromJson(Map<String, dynamic> parsedJson){
    DateTime dateTime;
    String newBirthdate;

    if(parsedJson['birthdate'] != null && parsedJson['birthdate'] != ''){
      String newValue = parsedJson['birthdate'];
      dateTime = DateTime.parse(newValue);
      newBirthdate = dateTime.format(AmericanDateFormats.standardWithComma);
    }else{
      newBirthdate = '';
    }

    return APIBLMShowUserInformation(
      showUserInformationId: parsedJson['id'],
      showUserInformationFirstName: parsedJson['first_name'] ?? '',
      showUserInformationLastName: parsedJson['last_name'] ?? '',
      showUserInformationBirthdate: newBirthdate,
      showUserInformationBirthplace: parsedJson['birthplace'] ?? '',
      showUserInformationHomeAddress: parsedJson['address'] ?? '',
      showUserInformationEmailAddress: parsedJson['email'] ?? '',
      showUserInformationContactNumber: parsedJson['phone_number'] ?? '',
      showUserInformationImage: parsedJson['image'] ?? '',
    );
  }
}