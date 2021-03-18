import 'package:shared_preferences/shared_preferences.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:dio/dio.dart';

Future<APIRegularShowUserInformation> apiRegularShowUserInformation({required int userId, required int accountType}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  Dio dioRequest = Dio();

  var response = await dioRequest.get('http://fbp.dev1.koda.ws/api/v1/users/showDetails?user_id=$userId&account_type=$accountType',
    options: Options(
      headers: <String, dynamic>{
        'Content-Type': 'application/json',
        'access-token': getAccessToken,
        'uid': getUID,
        'client': getClient,
      }
    ),  
  );

  print('The status code of registration is ${response.statusCode}');

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


