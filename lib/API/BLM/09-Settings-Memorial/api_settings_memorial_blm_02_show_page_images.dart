import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<APIBLMShowPageImagesMain> apiBLMShowPageImages({required int memorialId}) async{
  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  Dio dioRequest = Dio();

  var response = await dioRequest.get('https://www.facesbyplaces.com/api/v1/pages/blm/$memorialId/editImages',
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
    return APIBLMShowPageImagesMain.fromJson(newData);
  }else{
    throw Exception('Failed to get the page images.');
  }
}

class APIBLMShowPageImagesMain{
  APIBLMShowPageImagesExtended blmMemorial;
  APIBLMShowPageImagesMain({required this.blmMemorial});

  factory APIBLMShowPageImagesMain.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMShowPageImagesMain(
      blmMemorial: APIBLMShowPageImagesExtended.fromJson(parsedJson['blm']),
    );
  }
}

class APIBLMShowPageImagesExtended{
  dynamic showPageImagesBackgroundImage;
  dynamic showPageImagesProfileImage;
  String showPageImagesRelationship;
  APIBLMShowPageImagesExtended({required this.showPageImagesBackgroundImage, required this.showPageImagesProfileImage, required this.showPageImagesRelationship,});

  factory APIBLMShowPageImagesExtended.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMShowPageImagesExtended(
      showPageImagesBackgroundImage: parsedJson['backgroundImage'],
      showPageImagesProfileImage: parsedJson['profileImage'],
      showPageImagesRelationship: parsedJson['relationship'],
    );
  }
}