import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIBLMShowMemorialMain> apiBLMShowMemorial(int memorialId) async{

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
  int id;
  String name;
  APIBLMShowMemorialExtendedDetails details;
  String backgroundImage;
  String profileImage;
  dynamic imagesOrVideos;
  String relationship;
  APIBLMShowMemorialExtendedPageCreator pageCreator;
  bool manage;
  bool famOrFriends;
  bool follower;
  int postsCount;
  int familyCount;
  int friendsCount;
  int followersCount;

  APIBLMShowMemorialExtended({this.id, this.name, this.details, this.backgroundImage, this.profileImage, this.imagesOrVideos, this.relationship, this.pageCreator, this.manage, this.famOrFriends, this.follower, this.postsCount, this.familyCount, this.friendsCount, this.followersCount});

  factory APIBLMShowMemorialExtended.fromJson(Map<String, dynamic> parsedJson){

    return APIBLMShowMemorialExtended(
      id: parsedJson['id'],
      name: parsedJson['name'],
      details: APIBLMShowMemorialExtendedDetails.fromJson(parsedJson['details']),
      backgroundImage: parsedJson['backgroundImage'],
      profileImage: parsedJson['profileImage'],
      imagesOrVideos: parsedJson['imagesOrVideos'],
      relationship: parsedJson['relationship'],
      pageCreator: APIBLMShowMemorialExtendedPageCreator.fromJson(parsedJson['page_creator']),
      manage: parsedJson['manage'],
      famOrFriends: parsedJson['famOrFriends'],
      follower: parsedJson['follower'],
      postsCount: parsedJson['postsCount'],
      familyCount: parsedJson['familyCount'],
      friendsCount: parsedJson['friendsCount'],
      followersCount: parsedJson['followersCount'],
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
    return APIBLMShowMemorialExtendedDetails(
      description: parsedJson['description'],
      location: parsedJson['location'],
      precinct: parsedJson['precinct'],
      dob: parsedJson['dob'],
      rip: parsedJson['rip'],
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