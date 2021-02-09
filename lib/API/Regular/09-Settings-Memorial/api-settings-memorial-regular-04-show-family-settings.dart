import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIRegularShowFamilySettingsMain> apiRegularShowFamilySettings({int memorialId, int page}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  APIRegularShowFamilySettingsMain returnValue;

  try{
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
    }
  }catch(e){
    throw Exception('$e');
  }

  return returnValue;
}

class APIRegularShowFamilySettingsMain{
  int almItemsRemaining;
  List<APIRegularShowFamilySettingsExtended> almFamilyList;

  APIRegularShowFamilySettingsMain({this.almItemsRemaining, this.almFamilyList});

  factory APIRegularShowFamilySettingsMain.fromJson(Map<String, dynamic> parsedJson){

    var newList1 = parsedJson['family'] as List;
    List<APIRegularShowFamilySettingsExtended> familyList = newList1.map((i) => APIRegularShowFamilySettingsExtended.fromJson(i)).toList();

    return APIRegularShowFamilySettingsMain(
      almItemsRemaining: parsedJson['itemsremaining'],
      almFamilyList: familyList,
    );
  }
}


class APIRegularShowFamilySettingsExtended{
  APIRegularShowFamilySettingsExtendedDetails showFamilySettingsUser;
  String showFamilySettingsRelationship;

  APIRegularShowFamilySettingsExtended({this.showFamilySettingsUser, this.showFamilySettingsRelationship});

  factory APIRegularShowFamilySettingsExtended.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularShowFamilySettingsExtended(
      showFamilySettingsUser: APIRegularShowFamilySettingsExtendedDetails.fromJson(parsedJson['user']),
      showFamilySettingsRelationship: parsedJson['relationship'],
    );
  }
}

class APIRegularShowFamilySettingsExtendedDetails{

  int showFamilySettingsDetailsId;
  String showFamilySettingsDetailsFirstName;
  String showFamilySettingsDetailsLastName;
  dynamic showFamilySettingsDetailsImage;
  String showFamilySettingsDetailsEmail;
  int showFamilySettingsDetailsAccountType;

  APIRegularShowFamilySettingsExtendedDetails({this.showFamilySettingsDetailsId, this.showFamilySettingsDetailsFirstName, this.showFamilySettingsDetailsLastName, this.showFamilySettingsDetailsImage, this.showFamilySettingsDetailsEmail, this.showFamilySettingsDetailsAccountType});

  factory APIRegularShowFamilySettingsExtendedDetails.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularShowFamilySettingsExtendedDetails(
      showFamilySettingsDetailsId: parsedJson['id'],
      showFamilySettingsDetailsFirstName: parsedJson['first_name'],
      showFamilySettingsDetailsLastName: parsedJson['last_name'],
      showFamilySettingsDetailsImage: parsedJson['image'],
      showFamilySettingsDetailsEmail: parsedJson['email'],
      showFamilySettingsDetailsAccountType: parsedJson['account_type'],
    );
  }
}