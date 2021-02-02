import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIBLMShowPageDetailsMain> apiBLMShowPageDetails({int memorialId}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  final http.Response response = await http.get('http://fbp.dev1.koda.ws/api/v1/pages/blm/$memorialId',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    }
  );

  if(response.statusCode == 200){
    var newValue = json.decode(response.body);
    return APIBLMShowPageDetailsMain.fromJson(newValue);
  }else{
    throw Exception('Failed to get the events');
  }
}

class APIBLMShowPageDetailsMain{

  APIBLMShowPageDetailsExtended blmMemorial;

  APIBLMShowPageDetailsMain({this.blmMemorial});

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

  APIBLMShowPageDetailsExtended({this.showPageDetailsId, this.showPageDetailsName, this.showPageDetailsDetails, this.showPageDetailsBackgroundImage, this.showPageDetailsProfileImage, this.showPageDetailsImagesOrVideos, this.showPageDetailsRelationship, this.showPageDetailsPageCreator});

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

  APIBLMShowPageDetailsExtendedDetails({this.showPageDetailsDetailsDescription, this.showPageDetailsDetailsLocation, this.showPageDetailsDetailsPrecinct, this.showPageDetailsDetailsDob, this.showPageDetailsDetailsRip, this.showPageDetailsDetailsState, this.showPageDetailsDetailsCountry});

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

  APIBLMShowPageDetailsExtendedPageCreator({this.showPageDetailsPageCreatorId, this.showPageDetailsPageCreatorFirstName, this.showPageDetailsPageCreatorLastName, this.showPageDetailsPageCreatorPhoneNumber, this.showPageDetailsPageCreatorEmail, this.showPageDetailsPageCreatorUserName, this.showPageDetailsPageCreatorImage});

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