import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIBLMShowPageImagesMain> apiBLMShowPageImages({required int memorialId}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  final http.Response response = await http.get(
    Uri.http('http://fbp.dev1.koda.ws/api/v1/pages/blm/$memorialId/editImages', ''),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    }
  );

  if(response.statusCode == 200){
    var newValue = json.decode(response.body);
    return APIBLMShowPageImagesMain.fromJson(newValue);
  }else{
    throw Exception('Failed to get the events');
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
  int showPageImagesId;
  String showPageImagesName;
  APIBLMShowPageImagesExtendedDetails showPageImagesDetails;
  dynamic showPageImagesBackgroundImage;
  dynamic showPageImagesProfileImage;
  dynamic showPageImagesImagesOrVideos;
  String showPageImagesRelationship;
  APIBLMShowPageImagesExtendedPageCreator showPageImagesPageCreator;

  APIBLMShowPageImagesExtended({required this.showPageImagesId, required this.showPageImagesName, required this.showPageImagesDetails, required this.showPageImagesBackgroundImage, required this.showPageImagesProfileImage, required this.showPageImagesImagesOrVideos, required this.showPageImagesRelationship, required this.showPageImagesPageCreator});

  factory APIBLMShowPageImagesExtended.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMShowPageImagesExtended(
      showPageImagesId: parsedJson['id'],
      showPageImagesName: parsedJson['name'],
      showPageImagesDetails: APIBLMShowPageImagesExtendedDetails.fromJson(parsedJson['details']),
      showPageImagesBackgroundImage: parsedJson['backgroundImage'],
      showPageImagesProfileImage: parsedJson['profileImage'],
      showPageImagesImagesOrVideos: parsedJson['imagesOrVideos'],
      showPageImagesRelationship: parsedJson['relationship'],
      showPageImagesPageCreator: APIBLMShowPageImagesExtendedPageCreator.fromJson(parsedJson['page_creator'])
    );
  }
}

class APIBLMShowPageImagesExtendedDetails{
  String showPageImagesDetailsDescription;
  String showPageImagesDetailsLocation;
  String showPageImagesDetailsPrecinct;
  String showPageImagesDetailsDob;
  String showPageImagesDetailsRip;
  String showPageImagesDetailsState;
  String showPageImagesDetailsCountry;

  APIBLMShowPageImagesExtendedDetails({required this.showPageImagesDetailsDescription, required this.showPageImagesDetailsLocation, required this.showPageImagesDetailsPrecinct, required this.showPageImagesDetailsDob, required this.showPageImagesDetailsRip, required this.showPageImagesDetailsState, required this.showPageImagesDetailsCountry});

  factory APIBLMShowPageImagesExtendedDetails.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMShowPageImagesExtendedDetails(
      showPageImagesDetailsDescription: parsedJson['description'],
      showPageImagesDetailsLocation: parsedJson['location'],
      showPageImagesDetailsPrecinct: parsedJson['precinct'],
      showPageImagesDetailsDob: parsedJson['dob'],
      showPageImagesDetailsRip: parsedJson['rip'],
      showPageImagesDetailsState: parsedJson['state'],
      showPageImagesDetailsCountry: parsedJson['country'],
    );
  }
}

class APIBLMShowPageImagesExtendedPageCreator{
  int showPageImagesPageCreatorId;
  String showPageImagesPageCreatorFirstName;
  String showPageImagesPageCreatorLastName;
  String showPageImagesPageCreatorPhoneNumber;
  String showPageImagesPageCreatorEmail;
  String showPageImagesPageCreatorUserName;
  dynamic showPageImagesPageCreatorImage;

  APIBLMShowPageImagesExtendedPageCreator({required this.showPageImagesPageCreatorId, required this.showPageImagesPageCreatorFirstName, required this.showPageImagesPageCreatorLastName, required this.showPageImagesPageCreatorPhoneNumber, required this.showPageImagesPageCreatorEmail, required this.showPageImagesPageCreatorUserName, required this.showPageImagesPageCreatorImage});

  factory APIBLMShowPageImagesExtendedPageCreator.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMShowPageImagesExtendedPageCreator(
      showPageImagesPageCreatorId: parsedJson['id'],
      showPageImagesPageCreatorFirstName: parsedJson['first_name'],
      showPageImagesPageCreatorLastName: parsedJson['last_name'],
      showPageImagesPageCreatorPhoneNumber: parsedJson['phone_number'],
      showPageImagesPageCreatorEmail: parsedJson['email'],
      showPageImagesPageCreatorUserName: parsedJson['username'],
      showPageImagesPageCreatorImage: parsedJson['image'],
    );
  }
}