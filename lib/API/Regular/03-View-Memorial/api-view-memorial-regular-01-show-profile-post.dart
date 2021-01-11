import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIRegularHomeProfilePostMain> apiRegularProfilePost({int memorialId, int page}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  final http.Response response = await http.get('http://fbp.dev1.koda.ws/api/v1/posts/page/Memorial/$memorialId?page=$page',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    }
  );

  if(response.statusCode == 200){
    var newValue = json.decode(response.body);
    return APIRegularHomeProfilePostMain.fromJson(newValue);
  }else{
    throw Exception('Failed to get the post');
  }

}


class APIRegularHomeProfilePostMain{
  int itemsRemaining;
  List<APIRegularHomeProfilePostExtended> familyMemorialList;

  APIRegularHomeProfilePostMain({this.itemsRemaining, this.familyMemorialList});

  factory APIRegularHomeProfilePostMain.fromJson(Map<String, dynamic> parsedJson){
    var newList = parsedJson['posts'] as List;
    List<APIRegularHomeProfilePostExtended> familyMemorials = newList.map((i) => APIRegularHomeProfilePostExtended.fromJson(i)).toList();

    return APIRegularHomeProfilePostMain(
      itemsRemaining: parsedJson['itemsremaining'],
      familyMemorialList: familyMemorials,
    );
  }
}


class APIRegularHomeProfilePostExtended{
  int postId;
  APIRegularHomeProfilePostExtendedPage postPage;
  String postBody;
  String postLocation;
  double postLatitude;
  double postLongitude;
  List<dynamic> postImagesOrVideos;
  List<APIRegularHomeProfilePostExtendedTagged> postTagged;
  String postCreatedAt;
  int postNumberOfLikes;
  int postNumberOfComments;
  bool postLikeStatus;

  APIRegularHomeProfilePostExtended({this.postId, this.postPage, this.postBody, this.postLocation, this.postLatitude, this.postLongitude, this.postImagesOrVideos, this.postTagged, this.postCreatedAt, this.postNumberOfLikes, this.postNumberOfComments, this.postLikeStatus});

  factory APIRegularHomeProfilePostExtended.fromJson(Map<String, dynamic> parsedJson){
    
    List<dynamic> newList1;

    if(parsedJson['imagesOrVideos'] != null){
      var list = parsedJson['imagesOrVideos'];
      newList1 = List<dynamic>.from(list);
    }

    var newList2 = parsedJson['tag_people'] as List;
    List<APIRegularHomeProfilePostExtendedTagged> taggedList = newList2.map((i) => APIRegularHomeProfilePostExtendedTagged.fromJson(i)).toList();
    
    return APIRegularHomeProfilePostExtended(
      postId: parsedJson['id'],
      postPage: APIRegularHomeProfilePostExtendedPage.fromJson(parsedJson['page']),
      postBody: parsedJson['body'],
      postLocation: parsedJson['location'],
      postLatitude: parsedJson['latitude'],
      postLongitude: parsedJson['longitude'],
      postImagesOrVideos: newList1,
      postTagged: taggedList,
      postCreatedAt: parsedJson['created_at'],
      postNumberOfLikes: parsedJson['numberOfLikes'],
      postNumberOfComments: parsedJson['numberOfComments'],
      postLikeStatus: parsedJson['likeStatus'],
    );
  }
}

class APIRegularHomeProfilePostExtendedPage{
  int id;
  String name;
  APIRegularHomeProfilePostExtendedPageDetails details;
  dynamic backgroundImage;
  dynamic profileImage;
  dynamic imagesOrVideos;
  String relationship;
  APIRegularHomeProfilePostExtendedPageCreator pageCreator;
  bool follower;
  bool manage;
  String pageType;
  String privacy;

  APIRegularHomeProfilePostExtendedPage({this.id, this.name, this.details, this.backgroundImage, this.profileImage, this.imagesOrVideos, this.relationship, this.pageCreator, this.follower, this.manage, this.pageType, this.privacy});

  factory APIRegularHomeProfilePostExtendedPage.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularHomeProfilePostExtendedPage(
      id: parsedJson['id'],
      name: parsedJson['name'],
      details: APIRegularHomeProfilePostExtendedPageDetails.fromJson(parsedJson['details']),
      backgroundImage: parsedJson['backgroundImage'],
      profileImage: parsedJson['profileImage'],
      imagesOrVideos: parsedJson['imagesOrVideos'],
      relationship: parsedJson['relationship'],
      pageCreator: APIRegularHomeProfilePostExtendedPageCreator.fromJson(parsedJson['page_creator']),
      follower: parsedJson['follower'],
      manage: parsedJson['manage'],
      pageType: parsedJson['page_type'],
      privacy: parsedJson['privacy'],
    );
  }
}

class APIRegularHomeProfilePostExtendedPageDetails{
  String description;
  String birthPlace;
  String dob;
  String rip;
  String cemetery;
  String country;

  APIRegularHomeProfilePostExtendedPageDetails({this.description, this.birthPlace, this.dob, this.rip, this.cemetery, this.country});

  factory APIRegularHomeProfilePostExtendedPageDetails.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularHomeProfilePostExtendedPageDetails(
      description: parsedJson['description'],
      birthPlace: parsedJson['birthplace'],
      dob: parsedJson['dob'],
      rip: parsedJson['rip'],
      cemetery: parsedJson['cemetery'],
      country: parsedJson['country'],
    );
  }
}

class APIRegularHomeProfilePostExtendedPageCreator{
  int id;
  String firstName;
  String lastName;
  String phoneNumber;
  String email;
  String userName;
  dynamic image;

  APIRegularHomeProfilePostExtendedPageCreator({this.id, this.firstName, this.lastName, this.phoneNumber, this.email, this.userName, this.image});

  factory APIRegularHomeProfilePostExtendedPageCreator.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularHomeProfilePostExtendedPageCreator(
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

class APIRegularHomeProfilePostExtendedTagged{
  int taggedId;
  String taggedFirstName;
  String taggedLastName;
  String taggedImage;

  APIRegularHomeProfilePostExtendedTagged({this.taggedId, this.taggedFirstName, this.taggedLastName, this.taggedImage});

  factory APIRegularHomeProfilePostExtendedTagged.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularHomeProfilePostExtendedTagged(
      taggedId: parsedJson['id'],
      taggedFirstName: parsedJson['first_name'],
      taggedLastName: parsedJson['last_name'],
      taggedImage: parsedJson['image']
    );
  }
}