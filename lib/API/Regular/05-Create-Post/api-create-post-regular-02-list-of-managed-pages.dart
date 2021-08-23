import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<APIRegularShowListOfManagedPages> apiRegularShowListOfManagedPages() async{
  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  Dio dioRequest = Dio();

  // var response = await dioRequest.get('http://45.33.66.25:3001/api/v1/posts/listPages/show',
  var response = await dioRequest.get('http://facesbyplaces.com/api/v1/posts/listPages/show',
    options: Options(
      followRedirects: false,
      validateStatus: (status){
        return status! < 600;
      },
      headers: <String, dynamic>{
        'Content-Type': 'application/json',
        'access-token': getAccessToken,
        'uid': getUID,
        'client': getClient,
      }
    ),  
  );

  print('The status code of regular list of managed pages is ${response.statusCode}');
  print('The status data of regular list of managed pages is ${response.data}');

  if(response.statusCode == 200){
    var newData = Map<String, dynamic>.from(response.data);
    return APIRegularShowListOfManagedPages.fromJson(newData);
  }else{
    throw Exception('Failed to get the list of pages.');
  }
}

class APIRegularShowListOfManagedPages{
  List<APIRegularShowListOfManagedPagesExtended> almPagesList;
  APIRegularShowListOfManagedPages({required this.almPagesList});

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
  String showListOfManagedPagesProfileImage;
  APIRegularShowListOfManagedPagesExtended({required this.showListOfManagedPagesId, required this.showListOfManagedPagesName, required this.showListOfManagedPagesProfileImage});

  factory APIRegularShowListOfManagedPagesExtended.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularShowListOfManagedPagesExtended(
      showListOfManagedPagesId: parsedJson['id'],
      showListOfManagedPagesName: parsedJson['name'] != null ? parsedJson['name'] : '',
      showListOfManagedPagesProfileImage: parsedJson['profileImage'] != null ? parsedJson['profileImage'] : '',
    );
  }
}