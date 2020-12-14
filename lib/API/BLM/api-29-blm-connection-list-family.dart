import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIBLMConnectionListFamilyMain> apiBLMConnectionListFamily(int memorialId, int page) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  final http.Response response = await http.get('http://fbp.dev1.koda.ws/api/v1/pages/blm/$memorialId/family/index?page=$page',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    }
  );

  if(response.statusCode == 200){
    var newValue = json.decode(response.body);
    return APIBLMConnectionListFamilyMain.fromJson(newValue);
  }else{
    throw Exception('Failed to get the lists.');
  }
}



class APIBLMConnectionListFamilyMain{
  int itemsRemaining;
  List<APIBLMConnectionListFamilyExtended> familyList;

  APIBLMConnectionListFamilyMain({this.itemsRemaining, this.familyList});

  factory APIBLMConnectionListFamilyMain.fromJson(Map<String, dynamic> parsedJson){

    var newList1 = parsedJson['family'] as List;
    List<APIBLMConnectionListFamilyExtended> familyList = newList1.map((i) => APIBLMConnectionListFamilyExtended.fromJson(i)).toList();

    return APIBLMConnectionListFamilyMain(
      itemsRemaining: parsedJson['itemsremaining'],
      familyList: familyList,
    );
  }
}


class APIBLMConnectionListFamilyExtended{
  APIBLMConnectionListFamilyExtendedDetails user;
  String relationship;

  APIBLMConnectionListFamilyExtended({this.user, this.relationship});

  factory APIBLMConnectionListFamilyExtended.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMConnectionListFamilyExtended(
      user: APIBLMConnectionListFamilyExtendedDetails.fromJson(parsedJson['user']),
      relationship: parsedJson['relationship'],
    );
  }
}

class APIBLMConnectionListFamilyExtendedDetails{

  int id;
  String firstName;
  String lastName;
  dynamic image;

  APIBLMConnectionListFamilyExtendedDetails({this.id, this.firstName, this.lastName, this.image});

  factory APIBLMConnectionListFamilyExtendedDetails.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMConnectionListFamilyExtendedDetails(
      id: parsedJson['id'],
      firstName: parsedJson['first_name'],
      lastName: parsedJson['last_name'],
      image: parsedJson['image'],
    );
  }
}
