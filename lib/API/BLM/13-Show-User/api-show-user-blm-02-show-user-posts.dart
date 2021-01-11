import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIBLMShowUsersPostsMain> apiBLMShowUserPosts({int userId, int page}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  final http.Response response = await http.get('http://fbp.dev1.koda.ws/api/v1/users/posts?user_id=$userId&page=$page',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    }
  );

  if(response.statusCode == 200){
    var newValue = json.decode(response.body);
    return APIBLMShowUsersPostsMain.fromJson(newValue);
  }else{
    throw Exception('Failed to get the post');
  }
}


class APIBLMShowUsersPostsMain{
  int itemsRemaining;
  List<APIBLMShowUsersPostsExtended> familyMemorialList;

  APIBLMShowUsersPostsMain({this.familyMemorialList, this.itemsRemaining});

  factory APIBLMShowUsersPostsMain.fromJson(Map<String, dynamic> parsedJson){
    var newList = parsedJson['posts'] as List;
    List<APIBLMShowUsersPostsExtended> familyMemorials = newList.map((i) => APIBLMShowUsersPostsExtended.fromJson(i)).toList();

    return APIBLMShowUsersPostsMain(
      familyMemorialList: familyMemorials,
      itemsRemaining: parsedJson['itemsremaining'],
    );
  }
}


class APIBLMShowUsersPostsExtended{
  int id;
  APIBLMShowUsersPostsExtendedPage page;
  String body;
  String location;
  double latitude;
  double longitude;
  List<dynamic> imagesOrVideos;
  List<APIBLMShowUsersPostsExtendedTagged> postTagged;
  String createAt;
  int numberOfLikes;
  int numberOfComments;
  bool likeStatus;

  APIBLMShowUsersPostsExtended({this.id, this.page, this.body, this.location, this.latitude, this.longitude, this.imagesOrVideos, this.postTagged, this.createAt, this.numberOfLikes, this.numberOfComments, this.likeStatus});

  factory APIBLMShowUsersPostsExtended.fromJson(Map<String, dynamic> parsedJson){
    
    List<dynamic> newList1;

    if(parsedJson['imagesOrVideos'] != null){
      var list = parsedJson['imagesOrVideos'];
      newList1 = List<dynamic>.from(list);
    }

    var newList2 = parsedJson['tag_people'] as List;
    List<APIBLMShowUsersPostsExtendedTagged> taggedList = newList2.map((i) => APIBLMShowUsersPostsExtendedTagged.fromJson(i)).toList();
    
    return APIBLMShowUsersPostsExtended(
      id: parsedJson['id'],
      page: APIBLMShowUsersPostsExtendedPage.fromJson(parsedJson['page']),
      body: parsedJson['body'],
      location: parsedJson['location'],
      latitude: parsedJson['latitude'],
      longitude: parsedJson['longitude'],
      imagesOrVideos: newList1,
      postTagged: taggedList,
      createAt: parsedJson['created_at'],
      numberOfLikes: parsedJson['numberOfLikes'],
      numberOfComments: parsedJson['numberOfComments'],
      likeStatus: parsedJson['likeStatus'],
    );
  }
}

class APIBLMShowUsersPostsExtendedPage{
  int id;
  String name;
  APIBLMShowUsersPostsExtendedPageDetails details;
  dynamic backgroundImage;
  dynamic profileImage;
  dynamic imagesOrVideos;
  String relationship;
  APIBLMShowUsersPostsExtendedPageCreator pageCreator;
  bool follower;
  bool manage;
  String pageType;
  String privacy;

  APIBLMShowUsersPostsExtendedPage({this.id, this.name, this.details, this.backgroundImage, this.profileImage, this.imagesOrVideos, this.relationship, this.pageCreator, this.follower, this.manage, this.pageType, this.privacy});

  factory APIBLMShowUsersPostsExtendedPage.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMShowUsersPostsExtendedPage(
      id: parsedJson['id'],
      name: parsedJson['name'],
      details: APIBLMShowUsersPostsExtendedPageDetails.fromJson(parsedJson['details']),
      backgroundImage: parsedJson['backgroundImage'],
      profileImage: parsedJson['profileImage'],
      imagesOrVideos: parsedJson['imagesOrVideos'],
      relationship: parsedJson['relationship'],
      pageCreator: APIBLMShowUsersPostsExtendedPageCreator.fromJson(parsedJson['page_creator']),
      follower: parsedJson['follower'],
      manage: parsedJson['manage'],
      pageType: parsedJson['page_type'],
      privacy: parsedJson['privacy'],
    );
  }
}

class APIBLMShowUsersPostsExtendedPageDetails{
  String description;
  String birthPlace;
  String dob;
  String rip;
  String cemetery;
  String country;

  APIBLMShowUsersPostsExtendedPageDetails({this.description, this.birthPlace, this.dob, this.rip, this.cemetery, this.country});

  factory APIBLMShowUsersPostsExtendedPageDetails.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMShowUsersPostsExtendedPageDetails(
      description: parsedJson['description'],
      birthPlace: parsedJson['birthplace'],
      dob: parsedJson['dob'],
      rip: parsedJson['rip'],
      cemetery: parsedJson['cemetery'],
      country: parsedJson['country'],
    );
  }
}

class APIBLMShowUsersPostsExtendedPageCreator{
  int id;
  String firstName;
  String lastName;
  String phoneNumber;
  String email;
  String userName;
  dynamic image;

  APIBLMShowUsersPostsExtendedPageCreator({this.id, this.firstName, this.lastName, this.phoneNumber, this.email, this.userName, this.image});

  factory APIBLMShowUsersPostsExtendedPageCreator.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMShowUsersPostsExtendedPageCreator(
      id: parsedJson['id'],
      firstName: parsedJson['first_name'],
      lastName: parsedJson['last_name'],
      phoneNumber: parsedJson['phone_number'],
      email: parsedJson['email'],
      userName: parsedJson['username'],
      image: parsedJson['image']
    );
  }
}


class APIBLMShowUsersPostsExtendedTagged{
  int taggedId;
  String taggedFirstName;
  String taggedLastName;
  String taggedImage;

  APIBLMShowUsersPostsExtendedTagged({this.taggedId, this.taggedFirstName, this.taggedLastName, this.taggedImage});

  factory APIBLMShowUsersPostsExtendedTagged.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMShowUsersPostsExtendedTagged(
      taggedId: parsedJson['id'],
      taggedFirstName: parsedJson['first_name'],
      taggedLastName: parsedJson['last_name'],
      taggedImage: parsedJson['image']
    );
  }
}