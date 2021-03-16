import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

Future<APIBLMShowPageDetailsMain> apiBLMShowPageDetails({required int memorialId}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  Dio dioRequest = Dio();

  var response = await dioRequest.get('http://fbp.dev1.koda.ws/api/v1/pages/blm/$memorialId',
    options: Options(
      headers: <String, dynamic>{
        'Content-Type': 'application/json',
        'access-token': getAccessToken,
        'uid': getUID,
        'client': getClient,
      }
    ),  
  );

  print('The status code of page details is ${response.statusCode}');

  if(response.statusCode == 200){
    var newData = Map<String, dynamic>.from(response.data);
    return APIBLMShowPageDetailsMain.fromJson(newData);
  }else{
    throw Exception('Failed to get the page details.');
  }

  // final http.Response response = await http.get(
  //   Uri.http('http://fbp.dev1.koda.ws/api/v1/pages/blm/$memorialId', ''),
  //   headers: <String, String>{
  //     'Content-Type': 'application/json',
  //     'access-token': getAccessToken,
  //     'uid': getUID,
  //     'client': getClient,
  //   }
  // );

  // if(response.statusCode == 200){
  //   var newValue = json.decode(response.body);
  //   return APIBLMShowPageDetailsMain.fromJson(newValue);
  // }else{
  //   throw Exception('Failed to get the events');
  // }
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
  int showPageDetailsId;
  String showPageDetailsName;
  APIBLMShowPageDetailsExtendedDetails showPageDetailsDetails;
  dynamic showPageDetailsBackgroundImage;
  dynamic showPageDetailsProfileImage;
  dynamic showPageDetailsImagesOrVideos;
  String showPageDetailsRelationship;
  APIBLMShowPageDetailsExtendedPageCreator showPageDetailsPageCreator;

  APIBLMShowPageDetailsExtended({required this.showPageDetailsId, required this.showPageDetailsName, required this.showPageDetailsDetails, required this.showPageDetailsBackgroundImage, required this.showPageDetailsProfileImage, required this.showPageDetailsImagesOrVideos, required this.showPageDetailsRelationship, required this.showPageDetailsPageCreator});

  factory APIBLMShowPageDetailsExtended.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMShowPageDetailsExtended(
      showPageDetailsId: parsedJson['id'],
      showPageDetailsName: parsedJson['name'],
      showPageDetailsDetails: APIBLMShowPageDetailsExtendedDetails.fromJson(parsedJson['details']),
      showPageDetailsBackgroundImage: parsedJson['backgroundImage'],
      showPageDetailsProfileImage: parsedJson['profileImage'],
      showPageDetailsImagesOrVideos: parsedJson['imagesOrVideos'],
      showPageDetailsRelationship: parsedJson['relationship'],
      showPageDetailsPageCreator: APIBLMShowPageDetailsExtendedPageCreator.fromJson(parsedJson['page_creator'])
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
      showPageDetailsDetailsDescription: parsedJson['description'],
      showPageDetailsDetailsLocation: parsedJson['location'],
      showPageDetailsDetailsPrecinct: parsedJson['precinct'],
      showPageDetailsDetailsDob: parsedJson['dob'],
      showPageDetailsDetailsRip: parsedJson['rip'],
      showPageDetailsDetailsState: parsedJson['state'],
      showPageDetailsDetailsCountry: parsedJson['country'],
    );
  }
}

class APIBLMShowPageDetailsExtendedPageCreator{
  int showPageDetailsPageCreatorId;
  String showPageDetailsPageCreatorFirstName;
  String showPageDetailsPageCreatorLastName;
  String showPageDetailsPageCreatorPhoneNumber;
  String showPageDetailsPageCreatorEmail;
  String showPageDetailsPageCreatorUserName;
  dynamic showPageDetailsPageCreatorImage;

  APIBLMShowPageDetailsExtendedPageCreator({required this.showPageDetailsPageCreatorId, required this.showPageDetailsPageCreatorFirstName, required this.showPageDetailsPageCreatorLastName, required this.showPageDetailsPageCreatorPhoneNumber, required this.showPageDetailsPageCreatorEmail, required this.showPageDetailsPageCreatorUserName, required this.showPageDetailsPageCreatorImage});

  factory APIBLMShowPageDetailsExtendedPageCreator.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMShowPageDetailsExtendedPageCreator(
      showPageDetailsPageCreatorId: parsedJson['id'],
      showPageDetailsPageCreatorFirstName: parsedJson['first_name'],
      showPageDetailsPageCreatorLastName: parsedJson['last_name'],
      showPageDetailsPageCreatorPhoneNumber: parsedJson['phone_number'],
      showPageDetailsPageCreatorEmail: parsedJson['email'],
      showPageDetailsPageCreatorUserName: parsedJson['username'],
      showPageDetailsPageCreatorImage: parsedJson['image']
    );
  }
}