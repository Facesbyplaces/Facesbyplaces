// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// Future<APIRegularShowUserInformation> apiRegularShowUserInformation({int userId}) async{

//   print('The user id used is $userId');

//   final sharedPrefs = await SharedPreferences.getInstance();
//   String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
//   String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
//   String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

//   final http.Response response = await http.get('http://fbp.dev1.koda.ws/api/v1/users/image_show?user_id=$userId',
//   // final http.Response response = await http.get('http://fbp.dev1.koda.ws/api/v1/users/showDetails?user_id=$userId',
//     headers: <String, String>{
//       'Content-Type': 'application/json',
//       'access-token': getAccessToken,
//       'uid': getUID,
//       'client': getClient,
//     }
//   );

//   print('The user information is ${response.statusCode}');
//   print('The user information is ${response.body}');

//   if(response.statusCode == 200){
//     var newValue = json.decode(response.body);
//     return APIRegularShowUserInformation.fromJson(newValue);
//   }else{
//     throw Exception('Failed to get the user information');
//   }
// }

// class APIRegularShowUserInformation{
//   int userId;
//   String firstName;
//   String lastName;
//   String image;
//   String email;
//   // String birthdate;
//   // String birthplace;
//   // String address;
//   // String phoneNumber;

//   // APIRegularShowUserInformation({this.userId, this.firstName, this.lastName, this.image, this.email, this.birthdate, this.birthplace, this.address, this.phoneNumber});
//   APIRegularShowUserInformation({this.userId, this.firstName, this.lastName, this.image, this.email,});

//   factory APIRegularShowUserInformation.fromJson(Map<String, dynamic> parsedJson){

//     var newValue = parsedJson['user'];

//     return APIRegularShowUserInformation(
//       userId: newValue['id'],
//       firstName: newValue['first_name'],
//       lastName: newValue['last_name'],
//       image: newValue['image'],
//       email: newValue['email'],
//       // birthdate: newValue['birthdate'],
//       // birthplace: newValue['birthplace'],
//       // address: newValue['address'],
//       // phoneNumber: newValue['phone_number'],
//     );
//   }
// }


import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIRegularShowUserInformation> apiRegularShowUserInformation({int userId}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  final http.Response response = await http.get('http://fbp.dev1.koda.ws/api/v1/users/getDetails?user_id=$userId',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    }
  );

  if(response.statusCode == 200){
    var newValue = json.decode(response.body);
    return APIRegularShowUserInformation.fromJson(newValue);
  }else{
    throw Exception('Failed to get the user profile');
  }
}

class APIRegularShowUserInformation{
  int id;
  String firstName;
  String lastName;
  String email;
  String phoneNumber;
  String question;
  
  APIRegularShowUserInformation({this.id, this.firstName, this.lastName, this.email, this.phoneNumber, this.question});

  factory APIRegularShowUserInformation.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularShowUserInformation(
      id: parsedJson['id'],
      firstName: parsedJson['first_name'],
      lastName: parsedJson['last_name'],
      email: parsedJson['email'],
      phoneNumber: parsedJson['phone_number'],
      question: parsedJson['question'],
    );
  }
}
