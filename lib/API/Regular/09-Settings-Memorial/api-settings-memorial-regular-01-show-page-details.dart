import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIRegularShowPageDetailsMain> apiRegularShowPageDetails({int memorialId}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  final http.Response response = await http.get('http://fbp.dev1.koda.ws/api/v1/pages/memorials/$memorialId',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    }
  );

  if(response.statusCode == 200){
    var newValue = json.decode(response.body);
    return APIRegularShowPageDetailsMain.fromJson(newValue);
  }else{
    throw Exception('Failed to get the events');
  }
}


class APIRegularShowPageDetailsMain{

  APIRegularShowPageDetailsExtended almMemorial;

  APIRegularShowPageDetailsMain({this.almMemorial});

  factory APIRegularShowPageDetailsMain.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularShowPageDetailsMain(
      almMemorial: APIRegularShowPageDetailsExtended.fromJson(parsedJson['memorial']),
    );
  }
}


class APIRegularShowPageDetailsExtended{
  int showPageDetailsId;
  String showPageDetailsName;
  APIRegularShowPageDetailsExtendedDetails showPageDetailsDetails;
  dynamic showPageDetailsBackgroundImage;
  dynamic showPageDetailsProfileImage;
  dynamic showPageDetailsImagesOrVideos;
  String showPageDetailsRelationship;
  APIRegularShowPageDetailsExtendedPageCreator showPageDetailsPageCreator;

  APIRegularShowPageDetailsExtended({this.showPageDetailsId, this.showPageDetailsName, this.showPageDetailsDetails, this.showPageDetailsBackgroundImage, this.showPageDetailsProfileImage, this.showPageDetailsImagesOrVideos, this.showPageDetailsRelationship, this.showPageDetailsPageCreator});

  factory APIRegularShowPageDetailsExtended.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularShowPageDetailsExtended(
      showPageDetailsId: parsedJson['id'],
      showPageDetailsName: parsedJson['name'],
      showPageDetailsDetails: APIRegularShowPageDetailsExtendedDetails.fromJson(parsedJson['details']),
      showPageDetailsBackgroundImage: parsedJson['backgroundImage'],
      showPageDetailsProfileImage: parsedJson['profileImage'],
      showPageDetailsImagesOrVideos: parsedJson['imagesOrVideos'],
      showPageDetailsRelationship: parsedJson['relationship'],
      showPageDetailsPageCreator: APIRegularShowPageDetailsExtendedPageCreator.fromJson(parsedJson['page_creator'])
    );
  }
}

class APIRegularShowPageDetailsExtendedDetails{
  String showPageDetailsDetailsDescription;
  String showPageDetailsDetailsCemetery;
  String showPageDetailsDetailsDob;
  String showPageDetailsDetailsRip;
  String showPageDetailsDetailsState;
  String showPageDetailsDetailsCountry;

  APIRegularShowPageDetailsExtendedDetails({this.showPageDetailsDetailsDescription, this.showPageDetailsDetailsCemetery, this.showPageDetailsDetailsDob, this.showPageDetailsDetailsRip, this.showPageDetailsDetailsState, this.showPageDetailsDetailsCountry});

  factory APIRegularShowPageDetailsExtendedDetails.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularShowPageDetailsExtendedDetails(
      showPageDetailsDetailsDescription: parsedJson['description'],
      showPageDetailsDetailsCemetery: parsedJson['cemetery'],
      showPageDetailsDetailsDob: parsedJson['dob'],
      showPageDetailsDetailsRip: parsedJson['rip'],
      showPageDetailsDetailsState: parsedJson['state'],
      showPageDetailsDetailsCountry: parsedJson['country'],
    );
  }
}

class APIRegularShowPageDetailsExtendedPageCreator{
  int showPageDetailsPageCreatorId;
  String showPageDetailsPageCreatorFirstName;
  String showPageDetailsPageCreatorLastName;
  String showPageDetailsPageCreatorPhoneNumber;
  String showPageDetailsPageCreatorEmail;
  String showPageDetailsPageCreatorUserName;
  dynamic showPageDetailsPageCreatorImage;

  APIRegularShowPageDetailsExtendedPageCreator({this.showPageDetailsPageCreatorId, this.showPageDetailsPageCreatorFirstName, this.showPageDetailsPageCreatorLastName, this.showPageDetailsPageCreatorPhoneNumber, this.showPageDetailsPageCreatorEmail, this.showPageDetailsPageCreatorUserName, this.showPageDetailsPageCreatorImage});

  factory APIRegularShowPageDetailsExtendedPageCreator.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularShowPageDetailsExtendedPageCreator(
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