import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIRegularSearchPostMain> apiRegularSearchPosts(String keywords, int page) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  final http.Response response = await http.get(
    'http://fbp.dev1.koda.ws/api/v1/search/posts?page=$page&keywords=$keywords',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    }
  );

  print('The status of search posts is ${response.statusCode}');
  print('The status of search is ${response.body}');

  if(response.statusCode == 200){
    var newValue = json.decode(response.body);
    return APIRegularSearchPostMain.fromJson(newValue);
  }else{
    throw Exception('Failed to get the feed');
  }
}



class APIRegularSearchPostMain{
  int itemsRemaining;
  List<APIRegularSearchPostExtended> familyMemorialList;

  APIRegularSearchPostMain({this.itemsRemaining, this.familyMemorialList});

  factory APIRegularSearchPostMain.fromJson(Map<String, dynamic> parsedJson){
    var newList = parsedJson['posts'] as List;
    List<APIRegularSearchPostExtended> familyMemorials = newList.map((i) => APIRegularSearchPostExtended.fromJson(i)).toList();

    return APIRegularSearchPostMain(
      itemsRemaining: parsedJson['itemsremaining'],
      familyMemorialList: familyMemorials,
    );
  }
}


class APIRegularSearchPostExtended{
  int id;
  APIRegularSearchPostExtendedPage page;
  String body;
  String location;
  double latitude;
  double longitude;
  List<dynamic> imagesOrVideos;
  String createAt;

  APIRegularSearchPostExtended({this.id, this.page, this.body, this.location, this.latitude, this.longitude, this.imagesOrVideos, this.createAt});

  factory APIRegularSearchPostExtended.fromJson(Map<String, dynamic> parsedJson){
    
    List<dynamic> newList;

    if(parsedJson['imagesOrVideos'] != null){
      var list = parsedJson['imagesOrVideos'];
      newList = List<dynamic>.from(list);
    }
    
    return APIRegularSearchPostExtended(
      id: parsedJson['id'],
      page: APIRegularSearchPostExtendedPage.fromJson(parsedJson['page']),
      body: parsedJson['body'],
      location: parsedJson['location'],
      latitude: parsedJson['latitude'],
      longitude: parsedJson['longitude'],
      imagesOrVideos: newList,
      createAt: parsedJson['created_at'],
    );
  }
}

class APIRegularSearchPostExtendedPage{
  int id;
  String name;
  APIRegularPostExtendedPageDetails details;
  dynamic backgroundImage;
  dynamic profileImage;
  dynamic imagesOrVideos;
  String relationship;
  APIRegularHomeTabPostExtendedPageCreator pageCreator;

  APIRegularSearchPostExtendedPage({this.id, this.name, this.details, this.backgroundImage, this.profileImage, this.imagesOrVideos, this.relationship, this.pageCreator});

  factory APIRegularSearchPostExtendedPage.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularSearchPostExtendedPage(
      id: parsedJson['id'],
      name: parsedJson['name'],
      details: APIRegularPostExtendedPageDetails.fromJson(parsedJson['details']),
      backgroundImage: parsedJson['backgroundImage'],
      profileImage: parsedJson['profileImage'],
      imagesOrVideos: parsedJson['imagesOrVideos'],
      relationship: parsedJson['relationship'],
      pageCreator: APIRegularHomeTabPostExtendedPageCreator.fromJson(parsedJson['page_creator']),
      
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
  int id;
  String firstName;
  String lastName;
  String phoneNumber;
  String email;
  String userName;
  dynamic image;

  APIRegularHomeTabPostExtendedPageCreator({this.id, this.firstName, this.lastName, this.phoneNumber, this.email, this.userName, this.image});

  factory APIRegularHomeTabPostExtendedPageCreator.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularHomeTabPostExtendedPageCreator(
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