import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIBLMShowListOfManagedPages> apiBLMShowListOfManagedPages() async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  final http.Response response = await http.get('http://fbp.dev1.koda.ws/api/v1/posts/listPages/show',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    }
  );

  if(response.statusCode == 200){
    var newValue = json.decode(response.body);
    return APIBLMShowListOfManagedPages.fromJson(newValue);
  }else{
    throw Exception('Failed to get the lists.');
  }
}

class APIBLMShowListOfManagedPages{
  List<APIBLMShowListOfManagedPagesExtended> blmPagesList;

  APIBLMShowListOfManagedPages({this.blmPagesList});

  factory APIBLMShowListOfManagedPages.fromJson(Map<String, dynamic> parsedJson){

    var newList1 = parsedJson['pages'] as List;
    List<APIBLMShowListOfManagedPagesExtended> pagesList = newList1.map((i) => APIBLMShowListOfManagedPagesExtended.fromJson(i)).toList();

    return APIBLMShowListOfManagedPages(
      blmPagesList: pagesList,
    );
  }
}

class APIBLMShowListOfManagedPagesExtended{
  int blmManagedPagesId;
  String blmManagedPagesName;
  dynamic blmManagedPagesProfileImage;

  APIBLMShowListOfManagedPagesExtended({this.blmManagedPagesId, this.blmManagedPagesName, this.blmManagedPagesProfileImage});

  factory APIBLMShowListOfManagedPagesExtended.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMShowListOfManagedPagesExtended(
      blmManagedPagesId: parsedJson['id'],
      blmManagedPagesName: parsedJson['name'],
      blmManagedPagesProfileImage: parsedJson['profileImage'],
    );
  }
}