import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIRegularShowMemorialMain> apiRegularShowMemorial({int memorialId}) async{

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

  print('The show memorial status code is ${response.statusCode}');
  // print('The show memorial status body is ${response.body}');

  if(response.statusCode == 200){
    var newValue = json.decode(response.body);
    return APIRegularShowMemorialMain.fromJson(newValue);
  }else{
    throw Exception('Failed to get the events');
  }
}

class APIRegularShowMemorialMain{

  APIRegularShowMemorialExtended memorial;

  APIRegularShowMemorialMain({this.memorial});

  factory APIRegularShowMemorialMain.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularShowMemorialMain(
      memorial: APIRegularShowMemorialExtended.fromJson(parsedJson['memorial']),
    );
  }
}


class APIRegularShowMemorialExtended{
  int memorialId;
  String memorialName;
  APIRegularShowMemorialExtendedDetails memorialDetails;
  String memorialBackgroundImage;
  String memorialProfileImage;
  List<dynamic> memorialImagesOrVideos;
  String memorialRelationship;
  APIRegularShowMemorialExtendedPageCreator memorialPageCreator;
  bool memorialManage;
  bool memorialFamOrFriends;
  bool memorialFollower;
  int memorialPostsCount;
  int memorialFamilyCount;
  int memorialFriendsCount;
  int memorialFollowersCount;

  APIRegularShowMemorialExtended({this.memorialId, this.memorialName, this.memorialDetails, this.memorialBackgroundImage, this.memorialProfileImage, this.memorialImagesOrVideos, this. memorialRelationship, this.memorialPageCreator, this.memorialManage, this.memorialFamOrFriends, this.memorialFollower, this.memorialPostsCount, this.memorialFamilyCount, this.memorialFriendsCount, this.memorialFollowersCount});

  factory APIRegularShowMemorialExtended.fromJson(Map<String, dynamic> parsedJson){

    List<dynamic> newList1;

    if(parsedJson['imagesOrVideos'] != null){
      var list = parsedJson['imagesOrVideos'];
      newList1 = List<dynamic>.from(list);
    }

    return APIRegularShowMemorialExtended(
      memorialId: parsedJson['id'],
      memorialName: parsedJson['name'],
      memorialDetails: APIRegularShowMemorialExtendedDetails.fromJson(parsedJson['details']),
      memorialBackgroundImage: parsedJson['backgroundImage'],
      memorialProfileImage: parsedJson['profileImage'],
      // memorialImagesOrVideos: parsedJson['imagesOrVideos'],
      memorialImagesOrVideos: newList1,
      memorialRelationship: parsedJson['relationship'],
      memorialPageCreator: APIRegularShowMemorialExtendedPageCreator.fromJson(parsedJson['page_creator']),
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


class APIRegularShowMemorialExtendedDetails{
  String description;
  String birthPlace;
  String dob;
  String rip;
  String cemetery;
  String country;

  APIRegularShowMemorialExtendedDetails({this.description, this.birthPlace, this.dob, this.rip, this.cemetery, this.country});

  factory APIRegularShowMemorialExtendedDetails.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularShowMemorialExtendedDetails(
      description: parsedJson['description'],
      birthPlace: parsedJson['birthplace'],
      dob: parsedJson['dob'],
      rip: parsedJson['rip'],
      cemetery: parsedJson['cemetery'],
      country: parsedJson['country'],
    );
  }
}

class APIRegularShowMemorialExtendedPageCreator{
  int id;
  String firstName;
  String lastName;
  String phoneNumber;
  String email;
  String userName;
  dynamic image;

  APIRegularShowMemorialExtendedPageCreator({this.id, this.firstName, this.lastName, this.phoneNumber, this.email, this.userName, this.image,});

  factory APIRegularShowMemorialExtendedPageCreator.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularShowMemorialExtendedPageCreator(
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