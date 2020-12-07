import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIBLMSettingFamilyManagers> apiBLMSettingFamilyManagers(int memorialId, int page) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  final http.Response response = await http.get(
    'http://fbp.dev1.koda.ws/api/v1/pages/blm/$memorialId/family/index?page=$page',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    }
  );

  print('The status of page managers is ${response.statusCode}');
  print('The status of page managers is ${response.body}');

  if(response.statusCode == 200){
    var newValue = json.decode(response.body);
    return APIBLMSettingFamilyManagers.fromJson(newValue);
  }else{
    throw Exception('Failed to get the feed');
  }
}



class APIBLMSettingFamilyManagers{
  int itemsRemaining;
  List<APIBLMSettingFamilyManagersExtended> familyList;

  APIBLMSettingFamilyManagers({this.itemsRemaining, this.familyList});

  factory APIBLMSettingFamilyManagers.fromJson(Map<String, dynamic> parsedJson){

    var newList1 = parsedJson['family'] as List;
    List<APIBLMSettingFamilyManagersExtended> familyList = newList1.map((i) => APIBLMSettingFamilyManagersExtended.fromJson(i)).toList();

    return APIBLMSettingFamilyManagers(
      itemsRemaining: parsedJson['itemsremaining'],
      familyList: familyList,
    );
  }
}


class APIBLMSettingFamilyManagersExtended{
  APIBLMSettingFamilyManagersExtendedDetails user;
  String relationship;

  APIBLMSettingFamilyManagersExtended({this.user, this.relationship});

  factory APIBLMSettingFamilyManagersExtended.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMSettingFamilyManagersExtended(
      user: APIBLMSettingFamilyManagersExtendedDetails.fromJson(parsedJson),
      relationship: parsedJson['relationship'],
    );
  }
}

class APIBLMSettingFamilyManagersExtendedDetails{

  int id;
  String firstName;
  String lastName;
  dynamic image;

  APIBLMSettingFamilyManagersExtendedDetails({this.id, this.firstName, this.lastName, this.image});

  factory APIBLMSettingFamilyManagersExtendedDetails.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMSettingFamilyManagersExtendedDetails(
      id: parsedJson['id'],
      firstName: parsedJson['first_name'],
      lastName: parsedJson['last_name'],
      image: parsedJson['image'],
    );
  }
}
