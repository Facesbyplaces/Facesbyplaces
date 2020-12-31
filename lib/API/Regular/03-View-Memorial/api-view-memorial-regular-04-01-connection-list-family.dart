import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIRegularConnectionListFamilyMain> apiRegularConnectionListFamily(int memorialId, int page) async{

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
    return APIRegularConnectionListFamilyMain.fromJson(newValue);
  }else{
    throw Exception('Failed to get the lists.');
  }
}



class APIRegularConnectionListFamilyMain{
  int itemsRemaining;
  List<APIRegularConnectionListFamilyExtended> familyList;

  APIRegularConnectionListFamilyMain({this.itemsRemaining, this.familyList});

  factory APIRegularConnectionListFamilyMain.fromJson(Map<String, dynamic> parsedJson){

    var newList1 = parsedJson['family'] as List;
    List<APIRegularConnectionListFamilyExtended> familyList = newList1.map((i) => APIRegularConnectionListFamilyExtended.fromJson(i)).toList();

    return APIRegularConnectionListFamilyMain(
      itemsRemaining: parsedJson['itemsremaining'],
      familyList: familyList,
    );
  }
}


class APIRegularConnectionListFamilyExtended{
  APIRegularConnectionListFamilyExtendedDetails user;
  String relationship;

  APIRegularConnectionListFamilyExtended({this.user, this.relationship});

  factory APIRegularConnectionListFamilyExtended.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularConnectionListFamilyExtended(
      user: APIRegularConnectionListFamilyExtendedDetails.fromJson(parsedJson['user']),
      relationship: parsedJson['relationship'],
    );
  }
}

class APIRegularConnectionListFamilyExtendedDetails{

  int id;
  String firstName;
  String lastName;
  dynamic image;

  APIRegularConnectionListFamilyExtendedDetails({this.id, this.firstName, this.lastName, this.image});

  factory APIRegularConnectionListFamilyExtendedDetails.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularConnectionListFamilyExtendedDetails(
      id: parsedJson['id'],
      firstName: parsedJson['first_name'],
      lastName: parsedJson['last_name'],
      image: parsedJson['image'],
    );
  }
}
