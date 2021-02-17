import 'package:shared_preferences/shared_preferences.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIRegularShowMemorialMain> apiRegularShowMemorial({int memorialId}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  final http.Response response = await http.get(
    'http://fbp.dev1.koda.ws/api/v1/pages/memorials/$memorialId',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    }
  );

  if(response.statusCode == 200){
    var newValue = json.decode(response.body);
    return APIRegularShowMemorialMain.fromJson(newValue);
  }else{
    throw Exception('Failed to get the events');
  }
}

class APIRegularShowMemorialMain{

  APIRegularShowMemorialExtended almMemorial;

  APIRegularShowMemorialMain({this.almMemorial});

  factory APIRegularShowMemorialMain.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularShowMemorialMain(
      almMemorial: APIRegularShowMemorialExtended.fromJson(parsedJson['memorial']),
    );
  }
}

class APIRegularShowMemorialExtended{
  int showMemorialId;
  String showMemorialName;
  APIRegularShowMemorialExtendedDetails showMemorialDetails;
  String showMemorialBackgroundImage;
  String showMemorialProfileImage;
  List<dynamic> showMemorialImagesOrVideos;
  String showMemorialRelationship;
  APIRegularShowMemorialExtendedPageCreator showMemorialPageCreator;
  bool showMemorialManage;
  bool showMemorialFamOrFriends;
  bool showMemorialFollower;
  int showMemorialPostsCount;
  int showMemorialFamilyCount;
  int showMemorialFriendsCount;
  int showMemorialFollowersCount;

  APIRegularShowMemorialExtended({this.showMemorialId, this.showMemorialName, this.showMemorialDetails, this.showMemorialBackgroundImage, this.showMemorialProfileImage, this.showMemorialImagesOrVideos, this.showMemorialRelationship, this.showMemorialPageCreator, this.showMemorialManage, this.showMemorialFamOrFriends, this.showMemorialFollower, this.showMemorialPostsCount, this.showMemorialFamilyCount, this.showMemorialFriendsCount, this.showMemorialFollowersCount});

  factory APIRegularShowMemorialExtended.fromJson(Map<String, dynamic> parsedJson){

    List<dynamic> newList1;

    if(parsedJson['imagesOrVideos'] != null){
      var list = parsedJson['imagesOrVideos'];
      newList1 = List<dynamic>.from(list);
    }

    return APIRegularShowMemorialExtended(
      showMemorialId: parsedJson['id'],
      showMemorialName: parsedJson['name'],
      showMemorialDetails: APIRegularShowMemorialExtendedDetails.fromJson(parsedJson['details']),
      showMemorialBackgroundImage: parsedJson['backgroundImage'],
      showMemorialProfileImage: parsedJson['profileImage'],
      showMemorialImagesOrVideos: newList1,
      showMemorialRelationship: parsedJson['relationship'],
      showMemorialPageCreator: APIRegularShowMemorialExtendedPageCreator.fromJson(parsedJson['page_creator']),
      showMemorialManage: parsedJson['manage'],
      showMemorialFamOrFriends: parsedJson['famOrFriends'],
      showMemorialFollower: parsedJson['follower'],
      showMemorialPostsCount: parsedJson['postsCount'],
      showMemorialFamilyCount: parsedJson['familyCount'],
      showMemorialFriendsCount: parsedJson['friendsCount'],
      showMemorialFollowersCount: parsedJson['followersCount'],
    );
  }
}

class APIRegularShowMemorialExtendedDetails{
  String showMemorialDetailsDescription;
  String showMemorialDetailsBirthPlace;
  String showMemorialDetailsDob;
  String showMemorialDetailsRip;
  String showMemorialDetailsCemetery;
  String showMemorialDetailsCountry;

  APIRegularShowMemorialExtendedDetails({this.showMemorialDetailsDescription, this.showMemorialDetailsBirthPlace, this.showMemorialDetailsDob, this.showMemorialDetailsRip, this.showMemorialDetailsCemetery, this.showMemorialDetailsCountry});

  factory APIRegularShowMemorialExtendedDetails.fromJson(Map<String, dynamic> parsedJson){
    String newDOB = parsedJson['dob'];
    DateTime dob = DateTime.parse(newDOB);

    String newRIP = parsedJson['rip'];
    DateTime rip = DateTime.parse(newRIP);
    return APIRegularShowMemorialExtendedDetails(
      showMemorialDetailsDescription: parsedJson['description'],
      showMemorialDetailsBirthPlace: parsedJson['birthplace'],
      showMemorialDetailsDob: dob.format(AmericanDateFormats.standardWithComma),
      showMemorialDetailsRip: rip.format(AmericanDateFormats.standardWithComma),
      showMemorialDetailsCemetery: parsedJson['cemetery'],
      showMemorialDetailsCountry: parsedJson['country'],
    );
  }
}

class APIRegularShowMemorialExtendedPageCreator{
  int showMemorialPageCreatorId;
  String showMemorialPageCreatorFirstName;
  String showMemorialPageCreatorLastName;
  String showMemorialPageCreatorPhoneNumber;
  String showMemorialPageCreatorEmail;
  String showMemorialPageCreatorUserName;
  dynamic showMemorialPageCreatorImage;

  APIRegularShowMemorialExtendedPageCreator({this.showMemorialPageCreatorId, this.showMemorialPageCreatorFirstName, this.showMemorialPageCreatorLastName, this.showMemorialPageCreatorPhoneNumber, this.showMemorialPageCreatorEmail, this.showMemorialPageCreatorUserName, this.showMemorialPageCreatorImage,});

  factory APIRegularShowMemorialExtendedPageCreator.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularShowMemorialExtendedPageCreator(
      showMemorialPageCreatorId: parsedJson['id'],
      showMemorialPageCreatorFirstName: parsedJson['first_name'],
      showMemorialPageCreatorLastName: parsedJson['last_name'],
      showMemorialPageCreatorPhoneNumber: parsedJson['phone_number'],
      showMemorialPageCreatorEmail: parsedJson['email'],
      showMemorialPageCreatorUserName: parsedJson['username'],
      showMemorialPageCreatorImage: parsedJson['image'],
    );
  }
}