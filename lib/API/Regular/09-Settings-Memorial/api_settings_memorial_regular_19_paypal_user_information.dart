import 'package:dio/dio.dart';

Future<APIRegularShowPaypalUserInformation> apiRegularMemorialPaypalUserInformation({required String accessToken}) async{
  Dio dioRequest = Dio();

  var response = await dioRequest.get('https://api-m.sandbox.paypal.com/v1/identity/oauth2/userinfo?schema=paypalv1.1',
    options: Options(
      headers: <String, dynamic>{
        'Authorization': 'Bearer $accessToken',
      },
      validateStatus: (status){
        return status! < 600;
      },
      followRedirects: false,
    ),
  );

  if(response.statusCode == 200){
    var newData = Map<String, dynamic>.from(response.data);
    return APIRegularShowPaypalUserInformation.fromJson(newData);
  }else{
    throw Exception('Error occurred: ${response.statusMessage}');
  }
}

class APIRegularShowPaypalUserInformation{
  String userId;
  String name;
  List<APIRegularShowPaypalUserInformationExtended> emails;
  APIRegularShowPaypalUserInformation({required this.userId, required this.name, required this.emails});

  factory APIRegularShowPaypalUserInformation.fromJson(Map<String, dynamic> parsedJson){
    var newList = parsedJson['emails'] as List;
    List<APIRegularShowPaypalUserInformationExtended> emailsList = newList.map((i) => APIRegularShowPaypalUserInformationExtended.fromJson(i)).toList();

    return APIRegularShowPaypalUserInformation(
      userId: parsedJson['user_id'],
      name: parsedJson['name'],
      emails: emailsList,
    );
  }
}

class APIRegularShowPaypalUserInformationExtended{
  String email;
  APIRegularShowPaypalUserInformationExtended({required this.email});

  factory APIRegularShowPaypalUserInformationExtended.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularShowPaypalUserInformationExtended(
      email: parsedJson['value'],
    );
  }
}