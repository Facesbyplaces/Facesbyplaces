import 'package:date_time_format/date_time_format.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
    throw Exception('Failed to get the events');
  }
}

class APIBLMShowMemorialMain{

  APIBLMShowMemorialExtended memorial;

  APIBLMShowMemorialMain({this.memorial});

  factory APIBLMShowMemorialMain.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMShowMemorialMain(
      memorial: APIBLMShowMemorialExtended.fromJson(parsedJson['blm']),
    );
  }
}


class APIBLMShowMemorialExtended{
  int blmId;
  String blmName;
  APIBLMShowMemorialExtendedDetails blmDetails;
  String blmBackgroundImage;
  String blmProfileImage;
  dynamic blmImagesOrVideos;
  String blmRelationship;
  APIBLMShowMemorialExtendedPageCreator blmPageCreator;
  bool blmManage;
  bool blmFamOrFriends;
  bool blmFollower;
  int blmPostsCount;
  int blmFamilyCount;
  int blmFriendsCount;
  int blmFollowersCount;

  APIBLMShowMemorialExtended({this.blmId, this.blmName, this.blmDetails, this.blmBackgroundImage, this.blmProfileImage, this.blmImagesOrVideos, this.blmRelationship, this.blmPageCreator, this.blmManage, this.blmFamOrFriends, this.blmFollower, this.blmPostsCount, this.blmFamilyCount, this.blmFriendsCount, this.blmFollowersCount});

  factory APIBLMShowMemorialExtended.fromJson(Map<String, dynamic> parsedJson){

    return APIBLMShowMemorialExtended(
      blmId: parsedJson['id'],
      blmName: parsedJson['name'],
      blmDetails: APIBLMShowMemorialExtendedDetails.fromJson(parsedJson['details']),
      blmBackgroundImage: parsedJson['backgroundImage'],
      blmProfileImage: parsedJson['profileImage'],
      blmImagesOrVideos: parsedJson['imagesOrVideos'],
      blmRelationship: parsedJson['relationship'],
      blmPageCreator: APIBLMShowMemorialExtendedPageCreator.fromJson(parsedJson['page_creator']),
      blmManage: parsedJson['manage'],
      blmFamOrFriends: parsedJson['famOrFriends'],
      blmFollower: parsedJson['follower'],
      blmPostsCount: parsedJson['postsCount'],
      blmFamilyCount: parsedJson['familyCount'],
      blmFriendsCount: parsedJson['friendsCount'],
      blmFollowersCount: parsedJson['followersCount'],
    );
  }
}


class APIBLMShowMemorialExtendedDetails{
  String description;
  String location;
  String precinct;
  String dob;
  String rip;
  String state;
  String country;

  APIBLMShowMemorialExtendedDetails({this.description, this.location, this.precinct, this.dob, this.rip, this.state, this.country});

  factory APIBLMShowMemorialExtendedDetails.fromJson(Map<String, dynamic> parsedJson){
    String newDOB = parsedJson['dob'];
    DateTime dob = DateTime.parse(newDOB);

    String newRIP = parsedJson['rip'];
    DateTime rip = DateTime.parse(newRIP);


    return APIBLMShowMemorialExtendedDetails(
      description: parsedJson['description'],
      location: parsedJson['location'],
      precinct: parsedJson['precinct'],
      dob: dob.format(AmericanDateFormats.standardWithComma),
      rip: rip.format(AmericanDateFormats.standardWithComma),
      state: parsedJson['state'],
      country: parsedJson['country'],
    );
  }
}

class APIBLMShowMemorialExtendedPageCreator{
  int id;
  String firstName;
  String lastName;
  String phoneNumber;
  String email;
  String userName;
  dynamic image;

  APIBLMShowMemorialExtendedPageCreator({this.id, this.firstName, this.lastName, this.phoneNumber, this.email, this.userName, this.image,});

  factory APIBLMShowMemorialExtendedPageCreator.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMShowMemorialExtendedPageCreator(
      id: parsedJson['id'],
      firstName: parsedJson['first_name'],
      lastName: parsedJson['last_name'],
      phoneNumber: parsedJson['phone_number'],
      email: parsedJson['email'],
      userName: parsedJson['username'],
      image: parsedJson['image'],
    );
  }
}