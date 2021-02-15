import 'package:shared_preferences/shared_preferences.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIBLMShowMemorialMain> apiBLMShowMemorial({int memorialId}) async{

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
    return APIBLMShowMemorialMain.fromJson(newValue);
  }else{
    throw Exception('Failed to show the memorial details');
  }
}

class APIBLMShowMemorialMain{

  APIBLMShowMemorialExtended blmMemorial;

  APIBLMShowMemorialMain({this.blmMemorial});

  factory APIBLMShowMemorialMain.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMShowMemorialMain(
      blmMemorial: APIBLMShowMemorialExtended.fromJson(parsedJson['blm']),
    );
  }
}

class APIBLMShowMemorialExtended{
  int memorialId;
  String memorialName;
  APIBLMShowMemorialExtendedDetails memorialDetails;
  String memorialBackgroundImage;
  String memorialProfileImage;
  dynamic memorialImagesOrVideos;
  String memorialRelationship;
  APIBLMShowMemorialExtendedPageCreator memorialPageCreator;
  bool memorialManage;
  bool memorialFamOrFriends;
  bool memorialFollower;
  int memorialPostsCount;
  int memorialFamilyCount;
  int memorialFriendsCount;
  int memorialFollowersCount;

  APIBLMShowMemorialExtended({this.memorialId, this.memorialName, this.memorialDetails, this.memorialBackgroundImage, this.memorialProfileImage, this.memorialImagesOrVideos, this.memorialRelationship, this.memorialPageCreator, this.memorialManage, this.memorialFamOrFriends, this.memorialFollower, this.memorialPostsCount, this.memorialFamilyCount, this.memorialFriendsCount, this.memorialFollowersCount});

  factory APIBLMShowMemorialExtended.fromJson(Map<String, dynamic> parsedJson){

    return APIBLMShowMemorialExtended(
      memorialId: parsedJson['id'],
      memorialName: parsedJson['name'],
      memorialDetails: APIBLMShowMemorialExtendedDetails.fromJson(parsedJson['details']),
      memorialBackgroundImage: parsedJson['backgroundImage'],
      memorialProfileImage: parsedJson['profileImage'],
      memorialImagesOrVideos: parsedJson['imagesOrVideos'],
      memorialRelationship: parsedJson['relationship'],
      memorialPageCreator: APIBLMShowMemorialExtendedPageCreator.fromJson(parsedJson['page_creator']),
      memorialManage: parsedJson['manage'],
      memorialFamOrFriends: parsedJson['famOrFriends'],
      memorialFollower: parsedJson['follower'],
      memorialPostsCount: parsedJson['postsCount'],
      memorialFamilyCount: parsedJson['familyCount'],
      memorialFriendsCount: parsedJson['friendsCount'],
      memorialFollowersCount: parsedJson['followersCount'],
    );
  }
}

class APIBLMShowMemorialExtendedDetails{
  String memorialDetailsDescription;
  String memorialDetailsLocation;
  String memorialDetailsPrecinct;
  String memorialDetailsDob;
  String memorialDetailsRip;
  String memorialDetailsState;
  String memorialDetailsCountry;

  APIBLMShowMemorialExtendedDetails({this.memorialDetailsDescription, this.memorialDetailsLocation, this.memorialDetailsPrecinct, this.memorialDetailsDob, this.memorialDetailsRip, this.memorialDetailsState, this.memorialDetailsCountry});

  factory APIBLMShowMemorialExtendedDetails.fromJson(Map<String, dynamic> parsedJson){

    String newDOB = parsedJson['dob'];
    DateTime dob = DateTime.parse(newDOB);
    String newRIP = parsedJson['rip'];
    DateTime rip = DateTime.parse(newRIP);

    return APIBLMShowMemorialExtendedDetails(
      memorialDetailsDescription: parsedJson['description'],
      memorialDetailsLocation: parsedJson['location'],
      memorialDetailsPrecinct: parsedJson['precinct'],
      memorialDetailsDob: dob.format(AmericanDateFormats.standardWithComma),
      memorialDetailsRip: rip.format(AmericanDateFormats.standardWithComma),
      memorialDetailsState: parsedJson['state'],
      memorialDetailsCountry: parsedJson['country'],
    );
  }
}

class APIBLMShowMemorialExtendedPageCreator{
  int memorialPageCreatorId;
  String memorialPageCreatorFirstName;
  String memorialPageCreatorLastName;
  String memorialPageCreatorPhoneNumber;
  String memorialPageCreatorEmail;
  String memorialPageCreatorUserName;
  dynamic memorialPageCreatorImage;

  APIBLMShowMemorialExtendedPageCreator({this.memorialPageCreatorId, this.memorialPageCreatorFirstName, this.memorialPageCreatorLastName, this.memorialPageCreatorPhoneNumber, this.memorialPageCreatorEmail, this.memorialPageCreatorUserName, this.memorialPageCreatorImage,});

  factory APIBLMShowMemorialExtendedPageCreator.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMShowMemorialExtendedPageCreator(
      memorialPageCreatorId: parsedJson['id'],
      memorialPageCreatorFirstName: parsedJson['first_name'],
      memorialPageCreatorLastName: parsedJson['last_name'],
      memorialPageCreatorPhoneNumber: parsedJson['phone_number'],
      memorialPageCreatorEmail: parsedJson['email'],
      memorialPageCreatorUserName: parsedJson['username'],
      memorialPageCreatorImage: parsedJson['image'],
    );
  }
}