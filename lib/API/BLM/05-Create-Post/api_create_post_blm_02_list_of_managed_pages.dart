import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<APIBLMShowListOfManagedPages> apiBLMShowListOfManagedPages() async{
  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  Dio dioRequest = Dio();

  var response = await dioRequest.get('https://www.facesbyplaces.com/api/v1/posts/listPages/show',
    options: Options(
      headers: <String, dynamic>{
        'Content-Type': 'application/json',
        'access-token': getAccessToken,
        'uid': getUID,
        'client': getClient,
      },
      validateStatus: (status){
        return status! < 600;
      },
      followRedirects: false,
    ),  
  );

  if(response.statusCode == 200){
    var newData = Map<String, dynamic>.from(response.data);
    return APIBLMShowListOfManagedPages.fromJson(newData);
  }else{
    throw Exception('Failed to get the list of pages');
  }
}

class APIBLMShowListOfManagedPages{
  List<APIBLMShowListOfManagedPagesExtended> blmPagesList;
  APIBLMShowListOfManagedPages({required this.blmPagesList});

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
  String blmManagedPagesProfileImage;
  APIBLMShowListOfManagedPagesExtended({required this.blmManagedPagesId, required this.blmManagedPagesName, required this.blmManagedPagesProfileImage});

  factory APIBLMShowListOfManagedPagesExtended.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMShowListOfManagedPagesExtended(
      blmManagedPagesId: parsedJson['id'],
      blmManagedPagesName: parsedJson['name'] ?? '',
      blmManagedPagesProfileImage: parsedJson['profileImage'] ?? '',
    );
  }
}