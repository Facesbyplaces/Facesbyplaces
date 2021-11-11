import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<APIRegularShowPageDetailsMain> apiRegularShowPageDetails({required int memorialId}) async{
  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  Dio dioRequest = Dio();

  // var response = await dioRequest.get('https://facesbyplaces.com/api/v1/pages/memorials/$memorialId',
  var response = await dioRequest.get('https://www.facesbyplaces.com/api/v1/pages/memorials/$memorialId',
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
    return APIRegularShowPageDetailsMain.fromJson(newData);
  }else{
    throw Exception('Error occurred: ${response.statusMessage}');
  }
}

class APIRegularShowPageDetailsMain{
  APIRegularShowPageDetailsExtended almMemorial;
  APIRegularShowPageDetailsMain({required this.almMemorial});

  factory APIRegularShowPageDetailsMain.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularShowPageDetailsMain(
      almMemorial: APIRegularShowPageDetailsExtended.fromJson(parsedJson['memorial']),
    );
  }
}

class APIRegularShowPageDetailsExtended{
  String showPageDetailsName;
  APIRegularShowPageDetailsExtendedDetails showPageDetailsDetails;
  String showPageDetailsRelationship;
  APIRegularShowPageDetailsExtended({required this.showPageDetailsName, required this.showPageDetailsDetails, required this.showPageDetailsRelationship});

  factory APIRegularShowPageDetailsExtended.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularShowPageDetailsExtended(
      showPageDetailsName: parsedJson['name'] ?? '',
      showPageDetailsDetails: APIRegularShowPageDetailsExtendedDetails.fromJson(parsedJson['details']),
      showPageDetailsRelationship: parsedJson['relationship'] ?? '',
    );
  }
}

class APIRegularShowPageDetailsExtendedDetails{
  String showPageDetailsDetailsDescription;
  String showPageDetailsDetailsCemetery;
  String showPageDetailsDetailsDob;
  String showPageDetailsDetailsRip;
  String showPageDetailsDetailsCountry;
  APIRegularShowPageDetailsExtendedDetails({required this.showPageDetailsDetailsDescription, required this.showPageDetailsDetailsCemetery, required this.showPageDetailsDetailsDob, required this.showPageDetailsDetailsRip, required this.showPageDetailsDetailsCountry});

  factory APIRegularShowPageDetailsExtendedDetails.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularShowPageDetailsExtendedDetails(
      showPageDetailsDetailsDescription: parsedJson['description'] ?? '',
      showPageDetailsDetailsCemetery: parsedJson['cemetery'] ?? '',
      showPageDetailsDetailsDob: parsedJson['dob'] ?? '',
      showPageDetailsDetailsRip: parsedJson['rip'] ?? '',
      showPageDetailsDetailsCountry: parsedJson['country'] ?? '',
    );
  }
}