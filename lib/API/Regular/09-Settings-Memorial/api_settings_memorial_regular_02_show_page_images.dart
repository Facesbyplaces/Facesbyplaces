import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<APIRegularShowPageImagesMain> apiRegularShowPageImages({required int memorialId}) async{
  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  Dio dioRequest = Dio();

  var response = await dioRequest.get('https://www.facesbyplaces.com/api/v1/pages/memorials/$memorialId/editImages',
    options: Options(
      headers: <String, dynamic>{
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
      showPageImagesBackgroundImage: parsedJson['backgroundImage'] ?? '',
      showPageImagesProfileImage: parsedJson['profileImage'] ?? '',
      showPageImagesRelationship: parsedJson['relationship'] ?? '',
    );
  }
}