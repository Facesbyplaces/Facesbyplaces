import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<APIRegularShowPageImagesMain> apiRegularShowPageImages({required int memorialId}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  Dio dioRequest = Dio();

  var response = await dioRequest.get('http://fbp.dev1.koda.ws/api/v1/pages/memorials/$memorialId/editImages',
    options: Options(
      followRedirects: false,
      validateStatus: (status) {
        return status! < 600;
      },
      headers: <String, dynamic>{
        'access-token': getAccessToken,
        'uid': getUID,
        'client': getClient,
      }
    ),
  );

  print('The status code of regular show page images is ${response.statusCode}');

  if(response.statusCode == 200){
    var newData = Map<String, dynamic>.from(response.data);
    return APIRegularShowPageImagesMain.fromJson(newData);
  }else{
    throw Exception('Error occurred: ${response.statusMessage}');
  }
}

class APIRegularShowPageImagesMain{

  APIRegularShowPageImagesExtended almMemorial;
  APIRegularShowPageImagesMain({required this.almMemorial});

  factory APIRegularShowPageImagesMain.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularShowPageImagesMain(
      almMemorial: APIRegularShowPageImagesExtended.fromJson(parsedJson['memorial']),
    );
  }
}

class APIRegularShowPageImagesExtended{
  String showPageImagesBackgroundImage;
  String showPageImagesProfileImage;
  String showPageImagesRelationship;

  APIRegularShowPageImagesExtended({required this.showPageImagesBackgroundImage, required this.showPageImagesProfileImage, required this.showPageImagesRelationship});

  factory APIRegularShowPageImagesExtended.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularShowPageImagesExtended(
      showPageImagesBackgroundImage: parsedJson['backgroundImage'] != null ? parsedJson['backgroundImage'] : '',
      showPageImagesProfileImage: parsedJson['profileImage'] != null ? parsedJson['profileImage'] : '',
      showPageImagesRelationship: parsedJson['relationship'] != null ? parsedJson['relationship'] : '',
    );
  }
}