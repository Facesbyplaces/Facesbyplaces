import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIBLMShowFamilySettingsMain> apiBLMShowFamilySettings(int memorialId, int page) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  print('The memorial id is $memorialId');
  print('The page number is $page');

  final http.Response response = await http.get('http://fbp.dev1.koda.ws/api/v1/pages/blm/$memorialId/family/index?page=$page',
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
    return APIBLMShowFamilySettingsMain.fromJson(newValue);
  }else{
    throw Exception('Failed to get the lists.');
  }
}



class APIBLMShowFamilySettingsMain{
  int itemsRemaining;
  List<APIBLMShowFamilySettingsExtended> familyList;

  APIBLMShowFamilySettingsMain({this.itemsRemaining, this.familyList});

  factory APIBLMShowFamilySettingsMain.fromJson(Map<String, dynamic> parsedJson){

    var newList1 = parsedJson['family'] as List;
    List<APIBLMShowFamilySettingsExtended> familyList = newList1.map((i) => APIBLMShowFamilySettingsExtended.fromJson(i)).toList();

    return APIBLMShowFamilySettingsMain(
      itemsRemaining: parsedJson['itemsremaining'],
      familyList: familyList,
    );
  }
}


class APIBLMShowFamilySettingsExtended{
  APIBLMShowFamilySettingsExtendedDetails user;
  String relationship;

  APIBLMShowFamilySettingsExtended({this.user, this.relationship});

  factory APIBLMShowFamilySettingsExtended.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMShowFamilySettingsExtended(
      user: APIBLMShowFamilySettingsExtendedDetails.fromJson(parsedJson['user']),
      relationship: parsedJson['relationship'],
    );
  }
}

class APIBLMShowFamilySettingsExtendedDetails{

  int id;
  String firstName;
  String lastName;
  dynamic image;

  APIBLMShowFamilySettingsExtendedDetails({this.id, this.firstName, this.lastName, this.image});

  factory APIBLMShowFamilySettingsExtendedDetails.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMShowFamilySettingsExtendedDetails(
      id: parsedJson['id'],
      firstName: parsedJson['first_name'],
      lastName: parsedJson['last_name'],
      image: parsedJson['image'],
    );
  }
}
