import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<APIBLMShowPageDetailsMain> apiBLMShowPageDetails({required int memorialId}) async{
  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  Dio dioRequest = Dio();

  // var response = await dioRequest.get('http://fbp.dev1.koda.ws/api/v1/pages/blm/$memorialId',
  var response = await dioRequest.get('http://45.33.66.25:3001/api/v1/pages/blm/$memorialId',
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

  print('The status code of blm show page details is ${response.statusCode}');

  if(response.statusCode == 200){
    var newData = Map<String, dynamic>.from(response.data);
    return APIBLMShowPageDetailsMain.fromJson(newData);
  }else{
    throw Exception('Failed to get the page details.');
  }
}

class APIBLMShowPageDetailsMain{
  APIBLMShowPageDetailsExtended blmMemorial;
  APIBLMShowPageDetailsMain({required this.blmMemorial});

  factory APIBLMShowPageDetailsMain.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMShowPageDetailsMain(
      blmMemorial: APIBLMShowPageDetailsExtended.fromJson(parsedJson['blm']),
    );
  }
}


class APIBLMShowPageDetailsExtended{
  String showPageDetailsName;
  APIBLMShowPageDetailsExtendedDetails showPageDetailsDetails;
  String showPageDetailsRelationship;
  APIBLMShowPageDetailsExtended({required this.showPageDetailsName, required this.showPageDetailsDetails, required this.showPageDetailsRelationship,});

  factory APIBLMShowPageDetailsExtended.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMShowPageDetailsExtended(
      showPageDetailsName: parsedJson['name'],
      showPageDetailsDetails: APIBLMShowPageDetailsExtendedDetails.fromJson(parsedJson['details']),
      showPageDetailsRelationship: parsedJson['relationship'],
    );
  }
}


class APIBLMShowPageDetailsExtendedDetails{
  String showPageDetailsDetailsDescription;
  String showPageDetailsDetailsLocation;
  String showPageDetailsDetailsPrecinct;
  String showPageDetailsDetailsDob;
  String showPageDetailsDetailsRip;
  String showPageDetailsDetailsState;
  String showPageDetailsDetailsCountry;
  APIBLMShowPageDetailsExtendedDetails({required this.showPageDetailsDetailsDescription, required this.showPageDetailsDetailsLocation, required this.showPageDetailsDetailsPrecinct, required this.showPageDetailsDetailsDob, required this.showPageDetailsDetailsRip, required this.showPageDetailsDetailsState, required this.showPageDetailsDetailsCountry});

  factory APIBLMShowPageDetailsExtendedDetails.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMShowPageDetailsExtendedDetails(
      showPageDetailsDetailsDescription: parsedJson['description'] != null ? parsedJson['description'] : '',
      showPageDetailsDetailsLocation: parsedJson['location'] != null ? parsedJson['location'] : '',
      showPageDetailsDetailsPrecinct: parsedJson['precinct'] != null ? parsedJson['precinct'] : '',
      showPageDetailsDetailsDob: parsedJson['dob'] != null ? parsedJson['dob'] : '',
      showPageDetailsDetailsRip: parsedJson['rip'] != null ? parsedJson['rip'] : '',
      showPageDetailsDetailsState: parsedJson['state'] != null ? parsedJson['state'] : '',
      showPageDetailsDetailsCountry: parsedJson['country'] != null ? parsedJson['country'] : '',
    );
  }
}