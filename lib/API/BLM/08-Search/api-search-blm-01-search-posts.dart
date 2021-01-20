import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIBLMSearchPostMain> apiBLMSearchPosts({String keywords, int page}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  final http.Response response = await http.get('http://fbp.dev1.koda.ws/api/v1/search/posts?page=$page&keywords=$keywords',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    }
  );

  if(response.statusCode == 200){
    var newValue = json.decode(response.body);
    return APIBLMSearchPostMain.fromJson(newValue);
  }else{
    throw Exception('Failed to get the feed');
  }
}

class APIBLMSearchPostMain{
  int itemsRemaining;
  List<APIBLMSearchPostExtended> searchPostList;

  APIBLMSearchPostMain({this.itemsRemaining, this.searchPostList});

  factory APIBLMSearchPostMain.fromJson(Map<String, dynamic> parsedJson){
    var newList = parsedJson['posts'] as List;
    List<APIBLMSearchPostExtended> familyMemorials = newList.map((i) => APIBLMSearchPostExtended.fromJson(i)).toList();

    return APIBLMSearchPostMain(
      itemsRemaining: parsedJson['itemsremaining'],
      searchPostList: familyMemorials,
    );
  }
}


class APIBLMSearchPostExtended{
  int postId;
  APIBLMSearchPostExtendedPage page;
  String body;
  String location;
  double latitude;
  double longitude;
  List<dynamic> imagesOrVideos;
  List<APIBLMHomeProfilePostExtendedTagged> postTagged;
  String createAt;
  int numberOfLikes;
  int numberOfComments;
  bool likeStatus;

  APIBLMSearchPostExtended({this.postId, this.page, this.body, this.location, this.latitude, this.longitude, this.imagesOrVideos, this.postTagged, this.createAt, this.numberOfLikes, this.numberOfComments, this.likeStatus});

  factory APIBLMSearchPostExtended.fromJson(Map<String, dynamic> parsedJson){
    
    List<dynamic> newList;

    if(parsedJson['imagesOrVideos'] != null){
      var list = parsedJson['imagesOrVideos'];
      newList = List<dynamic>.from(list);
    }

    var newList2 = parsedJson['tag_people'] as List;
    List<APIBLMHomeProfilePostExtendedTagged> taggedList = newList2.map((i) => APIBLMHomeProfilePostExtendedTagged.fromJson(i)).toList();
    
    return APIBLMSearchPostExtended(
      postId: parsedJson['id'],
      page: APIBLMSearchPostExtendedPage.fromJson(parsedJson['page']),
      body: parsedJson['body'],
      location: parsedJson['location'],
      latitude: parsedJson['latitude'],
      longitude: parsedJson['longitude'],
      imagesOrVideos: newList,
      postTagged: taggedList,
      createAt: parsedJson['created_at'],
      numberOfLikes: parsedJson['numberOfLikes'],
      numberOfComments: parsedJson['numberOfComments'],
      likeStatus: parsedJson['likeStatus'],
    );
  }
}

class APIBLMSearchPostExtendedPage{
  int pageId;
  String name;
  APIBLMPostExtendedPageDetails details;
  dynamic backgroundImage;
  dynamic profileImage;
  dynamic imagesOrVideos;
  String relationship;
  APIBLMHomeTabPostExtendedPageCreator pageCreator;
  bool manage;
  bool famOrFriends;
  bool follower;
  String pageType;
  String privacy;

  APIBLMSearchPostExtendedPage({this.pageId, this.name, this.details, this.backgroundImage, this.profileImage, this.imagesOrVideos, this.relationship, this.pageCreator, this.manage, this.famOrFriends, this.follower, this.pageType, this.privacy});

  factory APIBLMSearchPostExtendedPage.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMSearchPostExtendedPage(
      pageId: parsedJson['id'],
      name: parsedJson['name'],
      details: APIBLMPostExtendedPageDetails.fromJson(parsedJson['details']),
      backgroundImage: parsedJson['backgroundImage'],
      profileImage: parsedJson['profileImage'],
      imagesOrVideos: parsedJson['imagesOrVideos'],
      relationship: parsedJson['relationship'],
      pageCreator: APIBLMHomeTabPostExtendedPageCreator.fromJson(parsedJson['page_creator']),
      manage: parsedJson['manage'],
      famOrFriends: parsedJson['famOrFriends'],
      follower: parsedJson['follower'],
      pageType: parsedJson['page_type'],
      privacy: parsedJson['privacy'],
    );
  }
}

class APIBLMPostExtendedPageDetails{
  String description;
  String birthPlace;
  String dob;
  String rip;
  String cemetery;
  String country;

  APIBLMPostExtendedPageDetails({this.description, this.birthPlace, this.dob, this.rip, this.cemetery, this.country});

  factory APIBLMPostExtendedPageDetails.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMPostExtendedPageDetails(
      description: parsedJson['description'],
      birthPlace: parsedJson['birthplace'],
      dob: parsedJson['dob'],
      rip: parsedJson['rip'],
      cemetery: parsedJson['cemetery'],
      country: parsedJson['country'],
    );
  }
}

class APIBLMHomeTabPostExtendedPageCreator{
  int creatorId;
  String firstName;
  String lastName;
  String phoneNumber;
  String email;
  String userName;
  dynamic image;

  APIBLMHomeTabPostExtendedPageCreator({this.creatorId, this.firstName, this.lastName, this.phoneNumber, this.email, this.userName, this.image});

  factory APIBLMHomeTabPostExtendedPageCreator.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMHomeTabPostExtendedPageCreator(
      creatorId: parsedJson['id'],
      firstName: parsedJson['first_name'],
      lastName: parsedJson['last_name'],
      phoneNumber: parsedJson['phone_number'],
      email: parsedJson['email'],
      userName: parsedJson['username'],
      image: parsedJson['image']
    );
  }
}

class APIBLMHomeProfilePostExtendedTagged{
  int taggedId;
  String taggedFirstName;
  String taggedLastName;
  String taggedImage;

  APIBLMHomeProfilePostExtendedTagged({this.taggedId, this.taggedFirstName, this.taggedLastName, this.taggedImage});

  factory APIBLMHomeProfilePostExtendedTagged.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMHomeProfilePostExtendedTagged(
      taggedId: parsedJson['id'],
      taggedFirstName: parsedJson['first_name'],
      taggedLastName: parsedJson['last_name'],
      taggedImage: parsedJson['image']
    );
  }
}