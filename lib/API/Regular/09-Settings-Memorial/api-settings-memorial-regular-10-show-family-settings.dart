import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIRegularShowFamilySettingsMain> apiRegularShowFamilySettings({int memorialId, int page}) async{

  print('The memorial id in api is $memorialId');

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  final http.Response response = await http.get('http://fbp.dev1.koda.ws/api/v1/pages/memorials/$memorialId/family/index?page=$page',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    }
  );

  if(response.statusCode == 200){
    var newValue = json.decode(response.body);
    return APIRegularShowFamilySettingsMain.fromJson(newValue);
  }else{
    throw Exception('Failed to get the lists.');
  }
}

class APIRegularShowFamilySettingsMain{
  int itemsRemaining;
  List<APIRegularShowFamilySettingsExtended> familyList;

  APIRegularShowFamilySettingsMain({this.itemsRemaining, this.familyList});

  factory APIRegularShowFamilySettingsMain.fromJson(Map<String, dynamic> parsedJson){

    var newList1 = parsedJson['family'] as List;
    List<APIRegularShowFamilySettingsExtended> familyList = newList1.map((i) => APIRegularShowFamilySettingsExtended.fromJson(i)).toList();

    return APIRegularShowFamilySettingsMain(
      itemsRemaining: parsedJson['itemsremaining'],
      familyList: familyList,
    );
  }
}


class APIRegularShowFamilySettingsExtended{
  APIRegularShowFamilySettingsExtendedDetails user;
  String relationship;

  APIRegularShowFamilySettingsExtended({this.user, this.relationship});

  factory APIRegularShowFamilySettingsExtended.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularShowFamilySettingsExtended(
      user: APIRegularShowFamilySettingsExtendedDetails.fromJson(parsedJson['user']),
      relationship: parsedJson['relationship'],
    );
  }
}

class APIRegularShowFamilySettingsExtendedDetails{

  int id;
  String firstName;
  String lastName;
  dynamic image;
  String email;

  APIRegularShowFamilySettingsExtendedDetails({this.id, this.firstName, this.lastName, this.image, this.email});

  factory APIRegularShowFamilySettingsExtendedDetails.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularShowFamilySettingsExtendedDetails(
      id: parsedJson['id'],
      firstName: parsedJson['first_name'],
      lastName: parsedJson['last_name'],
      image: parsedJson['image'],
      email: parsedJson['email'],
    );
  }
}
