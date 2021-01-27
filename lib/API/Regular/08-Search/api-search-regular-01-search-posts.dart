import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIRegularSearchPostMain> apiRegularSearchPosts({String keywords, int page}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  final http.Response response = await http.get('http://fbp.dev1.koda.ws/api/v1/search/posts?page=$page&keywords=$keywords',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    }
  );

  print('The status code of search posts is ${response.statusCode}');

  if(response.statusCode == 200){
    var newValue = json.decode(response.body);
    return APIRegularSearchPostMain.fromJson(newValue);
  }else{
    throw Exception('Failed to get the posts.');
  }
}

class APIRegularSearchPostMain{
  int itemsRemaining;
  List<APIRegularSearchPostExtended> searchPostList;

  APIRegularSearchPostMain({this.itemsRemaining, this.searchPostList});

  factory APIRegularSearchPostMain.fromJson(Map<String, dynamic> parsedJson){
    var newList = parsedJson['posts'] as List;
    List<APIRegularSearchPostExtended> searchPostList = newList.map((i) => APIRegularSearchPostExtended.fromJson(i)).toList();

    return APIRegularSearchPostMain(
      itemsRemaining: parsedJson['itemsremaining'],
      searchPostList: searchPostList,
    );
  }
}


class APIRegularSearchPostExtended{
  int postId;
  APIRegularSearchPostExtendedPage page;
  String body;
  String location;
  double latitude;
  double longitude;
  List<dynamic> imagesOrVideos;
  List<APIRegularHomeTabPostExtendedTagged> postTagged;
  List<dynamic> tagPeople;
  String createAt;
  int numberOfLikes;
  int numberOfComments;
  bool likeStatus;

  APIRegularSearchPostExtended({this.postId, this.page, this.body, this.location, this.latitude, this.longitude, this.imagesOrVideos, this.postTagged, this.tagPeople, this.createAt, this.numberOfLikes, this.numberOfComments, this.likeStatus});

  factory APIRegularSearchPostExtended.fromJson(Map<String, dynamic> parsedJson){
    
    List<dynamic> newList1;

    if(parsedJson['imagesOrVideos'] != null){
      var list = parsedJson['imagesOrVideos'];
      newList1 = List<dynamic>.from(list);
    }

    var newList2 = parsedJson['tag_people'] as List;
    List<APIRegularHomeTabPostExtendedTagged> taggedList = newList2.map((i) => APIRegularHomeTabPostExtendedTagged.fromJson(i)).toList();
    
    return APIRegularSearchPostExtended(
      postId: parsedJson['id'],
      page: APIRegularSearchPostExtendedPage.fromJson(parsedJson['page']),
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

class APIRegularSearchPostExtendedPage{
  int pageId;
  String name;
  APIRegularPostExtendedPageDetails details;
  dynamic backgroundImage;
  dynamic profileImage;
  dynamic imagesOrVideos;
  String relationship;
  APIRegularHomeTabPostExtendedPageCreator pageCreator;
  bool manage;
  bool famOrFriends;
  bool follower;
  String pageType;
  String privacy;

  APIRegularSearchPostExtendedPage({this.pageId, this.name, this.details, this.backgroundImage, this.profileImage, this.imagesOrVideos, this.relationship, this.pageCreator, this.manage, this.famOrFriends, this.follower, this.pageType, this.privacy});

  factory APIRegularSearchPostExtendedPage.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularSearchPostExtendedPage(
      pageId: parsedJson['id'],
      name: parsedJson['name'],
      details: APIRegularPostExtendedPageDetails.fromJson(parsedJson['details']),
      backgroundImage: parsedJson['backgroundImage'],
      profileImage: parsedJson['profileImage'],
      imagesOrVideos: parsedJson['imagesOrVideos'],
      relationship: parsedJson['relationship'],
      pageCreator: APIRegularHomeTabPostExtendedPageCreator.fromJson(parsedJson['page_creator']),
      manage: parsedJson['manage'],
      famOrFriends: parsedJson['famOrFriends'],
      follower: parsedJson['follower'],
      pageType: parsedJson['page_type'],
      privacy: parsedJson['privacy'],
    );
  }
}

class APIRegularPostExtendedPageDetails{
  String description;
  String birthPlace;
  String dob;
  String rip;
  String cemetery;
  String country;

  APIRegularPostExtendedPageDetails({this.description, this.birthPlace, this.dob, this.rip, this.cemetery, this.country});

  factory APIRegularPostExtendedPageDetails.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularPostExtendedPageDetails(
      description: parsedJson['description'],
      birthPlace: parsedJson['birthplace'],
      dob: parsedJson['dob'],
      rip: parsedJson['rip'],
      cemetery: parsedJson['cemetery'],
      country: parsedJson['country'],
    );
  }
}

class APIRegularHomeTabPostExtendedPageCreator{
  int creatorId;
  String firstName;
  String lastName;
  String phoneNumber;
  String email;
  String userName;
  dynamic image;

  APIRegularHomeTabPostExtendedPageCreator({this.creatorId, this.firstName, this.lastName, this.phoneNumber, this.email, this.userName, this.image});

  factory APIRegularHomeTabPostExtendedPageCreator.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularHomeTabPostExtendedPageCreator(
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

class APIRegularHomeTabPostExtendedTagged{
  int taggedId;
  String taggedFirstName;
  String taggedLastName;
  String taggedImage;

  APIRegularHomeTabPostExtendedTagged({this.taggedId, this.taggedFirstName, this.taggedLastName, this.taggedImage});

  factory APIRegularHomeTabPostExtendedTagged.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularHomeTabPostExtendedTagged(
      taggedId: parsedJson['id'],
      taggedFirstName: parsedJson['first_name'],
      taggedLastName: parsedJson['last_name'],
      taggedImage: parsedJson['image']
    );
  }
}