import 'package:shared_preferences/shared_preferences.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:dio/dio.dart';

Future<APIRegularShowUserInformation> apiRegularShowUserInformation({required int userId, required int accountType}) async{
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

  print('The user id in regular is $userId');
  print('The accountType in regular is $accountType');

  // var response = await dioRequest.get('http://fbp.dev1.koda.ws/api/v1/users/showDetails?user_id=$userId&account_type=$accountType',
  var response = await dioRequest.get('http://45.33.66.25:3001/api/v1/users/showDetails?user_id=$userId&account_type=$accountType',
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

  print('The status code of regular show user information is ${response.statusCode}');

  if(response.statusCode == 200){
    var newData = Map<String, dynamic>.from(response.data);
    return APIRegularShowUserInformation.fromJson(newData);
  }else{
    throw Exception('Failed to get the user profile');
  }
}

class APIRegularShowUserInformation{
  int showUserInformationId;
  String showUserInformationFirstName;
  String showUserInformationLastName;
  String showUserInformationBirthdate;
  String showUserInformationBirthplace;
  String showUserInformationHomeAddress;
  String showUserInformationEmailAddress;
  String showUserInformationContactNumber;
  String showUserInformationImage;
  APIRegularShowUserInformation({required this.showUserInformationId, required this.showUserInformationFirstName, required this.showUserInformationLastName, required this.showUserInformationBirthdate, required this.showUserInformationBirthplace, required this.showUserInformationHomeAddress, required this.showUserInformationEmailAddress, required this.showUserInformationContactNumber, required this.showUserInformationImage});

  factory APIRegularShowUserInformation.fromJson(Map<String, dynamic> parsedJson){
    DateTime dateTime;
    String newBirthdate;

    if(parsedJson['birthdate'] != null){
      String newValue = parsedJson['birthdate'];
      dateTime = DateTime.parse(newValue);
      newBirthdate = dateTime.format(AmericanDateFormats.standardWithComma);
    }else{
      newBirthdate = '';
    }

    return APIRegularShowUserInformation(
      showUserInformationId: parsedJson['id'],
      showUserInformationFirstName: parsedJson['first_name'] != null ? parsedJson['first_name'] : '',
      showUserInformationLastName: parsedJson['last_name'] != null ? parsedJson['last_name'] : '',
      showUserInformationBirthdate: newBirthdate,
      showUserInformationBirthplace: parsedJson['birthplace'] != null ? parsedJson['birthplace'] : '',
      showUserInformationHomeAddress: parsedJson['address'] != null ? parsedJson['address'] : '',
      showUserInformationEmailAddress: parsedJson['email'] != null ? parsedJson['email'] : '',
      showUserInformationContactNumber: parsedJson['phone_number'] != null ? parsedJson['phone_number'] : '',
      showUserInformationImage: parsedJson['image'] != null ? parsedJson['image'] : '',
    );
  }
}