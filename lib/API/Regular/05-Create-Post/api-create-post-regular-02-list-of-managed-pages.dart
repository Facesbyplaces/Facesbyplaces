import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIRegularShowListOfManagedPages> apiRegularShowListOfManagedPages() async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

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
    return APIRegularShowListOfManagedPages.fromJson(newValue);
  }else{
    throw Exception('Failed to get the lists of managed pages.');
  }
}

class APIRegularShowListOfManagedPages{
  List<APIRegularShowListOfManagedPagesExtended> almPagesList;

  APIRegularShowListOfManagedPages({this.almPagesList});

  factory APIRegularShowListOfManagedPages.fromJson(Map<String, dynamic> parsedJson){

    var newList1 = parsedJson['pages'] as List;
    List<APIRegularShowListOfManagedPagesExtended> pagesList = newList1.map((i) => APIRegularShowListOfManagedPagesExtended.fromJson(i)).toList();

    return APIRegularShowListOfManagedPages(
      almPagesList: pagesList,
    );
  }
}


class APIRegularShowListOfManagedPagesExtended{
  int showListOfManagedPagesId;
  String showListOfManagedPagesName;
  dynamic showListOfManagedPagesProfileImage;

  APIRegularShowListOfManagedPagesExtended({this.showListOfManagedPagesId, this.showListOfManagedPagesName, this.showListOfManagedPagesProfileImage});

  factory APIRegularShowListOfManagedPagesExtended.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularShowListOfManagedPagesExtended(
      showListOfManagedPagesId: parsedJson['id'],
      showListOfManagedPagesName: parsedJson['name'],
      showListOfManagedPagesProfileImage: parsedJson['profileImage'],
    );
  }
}