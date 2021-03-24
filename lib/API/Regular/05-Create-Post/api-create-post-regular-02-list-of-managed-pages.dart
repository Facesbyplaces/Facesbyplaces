import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<APIRegularShowListOfManagedPages> apiRegularShowListOfManagedPages() async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  APIRegularShowListOfManagedPages? result;
  CancelToken cancelToken = CancelToken();

  try{
    Dio dioRequest = Dio();

    var response = await dioRequest.get(
      'http://fbp.dev1.koda.ws/api/v1/posts/listPages/show',
      options: Options(
        followRedirects: false,
        validateStatus: (status) {
          return status! < 600;
        },
        headers: <String, dynamic>{
          'Content-Type': 'application/json',
          'access-token': getAccessToken,
          'uid': getUID,
          'client': getClient,
        },
      ),
      cancelToken: cancelToken
    );

    print('The status code of registration is ${response.statusCode}');

    if(response.statusCode == 200){
      var newData = Map<String, dynamic>.from(response.data);
      result = APIRegularShowListOfManagedPages.fromJson(newData);
    }

    return result!;
  }on DioError catch(e){
    print('The error 1 is ${e.response!.data}');
    print('The error 2 is ${e.response!.headers}');
    print('The error 4 is');
    print('The error 5 is ${e.message}');

    cancelToken.cancel("cancelled");
    return Future.error('Something went wrong. Please try again.');
    
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