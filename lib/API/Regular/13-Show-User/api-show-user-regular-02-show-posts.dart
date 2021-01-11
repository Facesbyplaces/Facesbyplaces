import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIRegularShowUsersPostsMain> apiRegularShowUserPosts({int userId, int page}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

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
    return APIRegularShowUsersPostsMain.fromJson(newValue);
  }else{
    throw Exception('Failed to get the post');
  }
}


class APIRegularShowUsersPostsMain{
  int itemsRemaining;
  List<APIRegularShowUsersPostsExtended> familyMemorialList;

  APIRegularShowUsersPostsMain({this.familyMemorialList, this.itemsRemaining});

  factory APIRegularShowUsersPostsMain.fromJson(Map<String, dynamic> parsedJson){
    var newList = parsedJson['posts'] as List;
    List<APIRegularShowUsersPostsExtended> familyMemorials = newList.map((i) => APIRegularShowUsersPostsExtended.fromJson(i)).toList();

    return APIRegularShowUsersPostsMain(
      familyMemorialList: familyMemorials,
      itemsRemaining: parsedJson['itemsremaining'],
    );
  }
}


class APIRegularShowUsersPostsExtended{
  int id;
  APIRegularShowUsersPostsExtendedPage page;
  String body;
  String location;
  double latitude;
  double longitude;
  List<dynamic> imagesOrVideos;
  List<APIRegularShowUsersPostsExtendedTagged> postTagged;
  String createAt;
  int numberOfLikes;
  int numberOfComments;
  bool likeStatus;

  APIRegularShowUsersPostsExtended({this.id, this.page, this.body, this.location, this.latitude, this.longitude, this.imagesOrVideos, this.postTagged, this.createAt, this.numberOfLikes, this.numberOfComments, this.likeStatus});

  factory APIRegularShowUsersPostsExtended.fromJson(Map<String, dynamic> parsedJson){
    
    List<dynamic> newList1;

    if(parsedJson['imagesOrVideos'] != null){
      var list = parsedJson['imagesOrVideos'];
      newList1 = List<dynamic>.from(list);
    }

    var newList2 = parsedJson['tag_people'] as List;
    List<APIRegularShowUsersPostsExtendedTagged> taggedList = newList2.map((i) => APIRegularShowUsersPostsExtendedTagged.fromJson(i)).toList();
    
    return APIRegularShowUsersPostsExtended(
      id: parsedJson['id'],
      page: APIRegularShowUsersPostsExtendedPage.fromJson(parsedJson['page']),
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

class APIRegularShowUsersPostsExtendedPage{
  int id;
  String name;
  APIRegularShowUsersPostsExtendedPageDetails details;
  dynamic backgroundImage;
  dynamic profileImage;
  dynamic imagesOrVideos;
  String relationship;
  APIRegularShowUsersPostsExtendedPageCreator pageCreator;
  bool follower;
  bool manage;
  String pageType;
  String privacy;

  APIRegularShowUsersPostsExtendedPage({this.id, this.name, this.details, this.backgroundImage, this.profileImage, this.imagesOrVideos, this.relationship, this.pageCreator, this.follower, this.manage, this.pageType, this.privacy});

  factory APIRegularShowUsersPostsExtendedPage.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularShowUsersPostsExtendedPage(
      id: parsedJson['id'],
      name: parsedJson['name'],
      details: APIRegularShowUsersPostsExtendedPageDetails.fromJson(parsedJson['details']),
      backgroundImage: parsedJson['backgroundImage'],
      profileImage: parsedJson['profileImage'],
      imagesOrVideos: parsedJson['imagesOrVideos'],
      relationship: parsedJson['relationship'],
      pageCreator: APIRegularShowUsersPostsExtendedPageCreator.fromJson(parsedJson['page_creator']),
      follower: parsedJson['follower'],
      manage: parsedJson['manage'],
      pageType: parsedJson['page_type'],
      privacy: parsedJson['privacy'],
    );
  }
}

class APIRegularShowUsersPostsExtendedPageDetails{
  String description;
  String birthPlace;
  String dob;
  String rip;
  String cemetery;
  String country;

  APIRegularShowUsersPostsExtendedPageDetails({this.description, this.birthPlace, this.dob, this.rip, this.cemetery, this.country});

  factory APIRegularShowUsersPostsExtendedPageDetails.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularShowUsersPostsExtendedPageDetails(
      description: parsedJson['description'],
      birthPlace: parsedJson['birthplace'],
      dob: parsedJson['dob'],
      rip: parsedJson['rip'],
      cemetery: parsedJson['cemetery'],
      country: parsedJson['country'],
    );
  }
}

class APIRegularShowUsersPostsExtendedPageCreator{
  int id;
  String firstName;
  String lastName;
  String phoneNumber;
  String email;
  String userName;
  dynamic image;

  APIRegularShowUsersPostsExtendedPageCreator({this.id, this.firstName, this.lastName, this.phoneNumber, this.email, this.userName, this.image});

  factory APIRegularShowUsersPostsExtendedPageCreator.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularShowUsersPostsExtendedPageCreator(
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


class APIRegularShowUsersPostsExtendedTagged{
  int taggedId;
  String taggedFirstName;
  String taggedLastName;
  String taggedImage;

  APIRegularShowUsersPostsExtendedTagged({this.taggedId, this.taggedFirstName, this.taggedLastName, this.taggedImage});

  factory APIRegularShowUsersPostsExtendedTagged.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularShowUsersPostsExtendedTagged(
      taggedId: parsedJson['id'],
      taggedFirstName: parsedJson['first_name'],
      taggedLastName: parsedJson['last_name'],
      taggedImage: parsedJson['image']
    );
  }
}