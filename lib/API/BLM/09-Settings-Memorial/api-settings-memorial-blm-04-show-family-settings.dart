import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

Future<APIBLMShowFamilySettingsMain> apiBLMShowFamilySettings({required int memorialId, required int page}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  Dio dioRequest = Dio();

  var response = await dioRequest.get('http://fbp.dev1.koda.ws/api/v1/pages/blm/$memorialId/family/index?page=$page',
    options: Options(
      headers: <String, dynamic>{
        'Content-Type': 'application/json',
        'access-token': getAccessToken,
        'uid': getUID,
        'client': getClient,
      }
    ),  
  );

  print('The status code of show family settings is ${response.statusCode}');

  if(response.statusCode == 200){
    var newData = Map<String, dynamic>.from(response.data);
    return APIBLMShowFamilySettingsMain.fromJson(newData);
  }else{
    throw Exception('Failed to get the family settings.');
  }

  // final http.Response response = await http.get(
  //   Uri.http('http://fbp.dev1.koda.ws/api/v1/pages/blm/$memorialId/family/index?page=$page', ''),
  //   headers: <String, String>{
  //     'Content-Type': 'application/json',
  //     'access-token': getAccessToken,
  //     'uid': getUID,
  //     'client': getClient,
  //   }
  // );

  // if(response.statusCode == 200){
  //   var newValue = json.decode(response.body);
  //   return APIBLMShowFamilySettingsMain.fromJson(newValue);
  // }else{
  //   throw Exception('Failed to get the lists.');
  // }
}

class APIBLMShowFamilySettingsMain{
  int blmItemsRemaining;
  List<APIBLMShowFamilySettingsExtended> blmFamilyList;

  APIBLMShowFamilySettingsMain({required this.blmItemsRemaining, required this.blmFamilyList});

  factory APIBLMShowFamilySettingsMain.fromJson(Map<String, dynamic> parsedJson){

    var newList1 = parsedJson['family'] as List;
    List<APIBLMShowFamilySettingsExtended> familyList = newList1.map((i) => APIBLMShowFamilySettingsExtended.fromJson(i)).toList();

    return APIBLMShowFamilySettingsMain(
      blmItemsRemaining: parsedJson['itemsremaining'],
      blmFamilyList: familyList,
    );
  }
}

class APIBLMShowFamilySettingsExtended{
  APIBLMShowFamilySettingsExtendedDetails showFamilySettingsUser;
  String showFamilySettingsRelationship;

  APIBLMShowFamilySettingsExtended({required this.showFamilySettingsUser, required this.showFamilySettingsRelationship});

  factory APIBLMShowFamilySettingsExtended.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMShowFamilySettingsExtended(
      showFamilySettingsUser: APIBLMShowFamilySettingsExtendedDetails.fromJson(parsedJson['user']),
      showFamilySettingsRelationship: parsedJson['relationship'],
    );
  }
}

class APIBLMShowFamilySettingsExtendedDetails{

  int showFamilySettingsDetailsId;
  String showFamilySettingsDetailsFirstName;
  String showFamilySettingsDetailsLastName;
  dynamic showFamilySettingsDetailsImage;
  String showFamilySettingsDetailsEmail;
  int showFamilySettingsDetailsAccountType;

  APIBLMShowFamilySettingsExtendedDetails({required this.showFamilySettingsDetailsId, required this.showFamilySettingsDetailsFirstName, required this.showFamilySettingsDetailsLastName, required this.showFamilySettingsDetailsImage, required this.showFamilySettingsDetailsEmail, required this.showFamilySettingsDetailsAccountType});

  factory APIBLMShowFamilySettingsExtendedDetails.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMShowFamilySettingsExtendedDetails(
      showFamilySettingsDetailsId: parsedJson['id'],
      showFamilySettingsDetailsFirstName: parsedJson['first_name'],
      showFamilySettingsDetailsLastName: parsedJson['last_name'],
      showFamilySettingsDetailsImage: parsedJson['image'],
      showFamilySettingsDetailsEmail: parsedJson['email'],
      showFamilySettingsDetailsAccountType: parsedJson['account_type'],
    );
  }
}
