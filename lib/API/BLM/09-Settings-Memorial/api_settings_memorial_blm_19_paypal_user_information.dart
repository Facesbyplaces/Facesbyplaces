import 'package:dio/dio.dart';

Future<APIBLMShowPaypalUserInformation> apiBLMMemorialPaypalUserInformation({required String accessToken}) async{
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
    return APIBLMShowPaypalUserInformation.fromJson(newData);
  }else{
    throw Exception('Error occurred: ${response.statusMessage}');
  }
}

class APIBLMShowPaypalUserInformation{
  String userId;
  String name;
  List<APIBLMShowPaypalUserInformationExtended> emails;
  APIBLMShowPaypalUserInformation({required this.userId, required this.name, required this.emails});

  factory APIBLMShowPaypalUserInformation.fromJson(Map<String, dynamic> parsedJson){
    var newList = parsedJson['emails'] as List;
    List<APIBLMShowPaypalUserInformationExtended> emailsList = newList.map((i) => APIBLMShowPaypalUserInformationExtended.fromJson(i)).toList();

    return APIBLMShowPaypalUserInformation(
      userId: parsedJson['user_id'],
      name: parsedJson['name'],
      emails: emailsList,
    );
  }
}

class APIBLMShowPaypalUserInformationExtended{
  String email;
  APIBLMShowPaypalUserInformationExtended({required this.email});

  factory APIBLMShowPaypalUserInformationExtended.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMShowPaypalUserInformationExtended(
      email: parsedJson['value'],
    );
  }
}