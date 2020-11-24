import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIRegularHomeProfilePostMain> apiRegularProfilePost() async{

  final sharedPrefs = await SharedPreferences.getInstance();
  int memorialId = sharedPrefs.getInt('regular-user-memorial-id') ?? 0;
  var getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  var getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  var getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  final http.Response response = await http.get(
    // 'http://fbp.dev1.koda.ws/api/v1/mainpages/posts/?page=1',
    // 'http://fbp.dev1.koda.ws/api/v1/posts/$memorialId',

    'http://fbp.dev1.koda.ws/api/v1/posts/page/Memorial/$memorialId',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    }
  );

  print('The response status in profile posts is ${response.statusCode}');
  print('The response status in profile posts is ${response.body}');

  if(response.statusCode == 200){
    var newValue = json.decode(response.body);
    return APIRegularHomeProfilePostMain.fromJson(newValue);
  }else{
    throw Exception('Failed to get the post');
  }
}


class APIRegularHomeProfilePostMain{

  List<APIRegularHomeProfilePostExtended> familyMemorialList;

  APIRegularHomeProfilePostMain({this.familyMemorialList});

  factory APIRegularHomeProfilePostMain.fromJson(List<dynamic> parsedJson){
    List<APIRegularHomeProfilePostExtended> familyMemorials = parsedJson.map((e) => APIRegularHomeProfilePostExtended.fromJson(e)).toList();

    return APIRegularHomeProfilePostMain(
      familyMemorialList: familyMemorials,
    );
  }
}


class APIRegularHomeProfilePostExtended{
  int id;
  APIRegularHomeProfilePostExtendedPage page;
  String body;
  String location;
  double latitude;
  double longitude;
  List<dynamic> imagesOrVideos;

  APIRegularHomeProfilePostExtended({this.id, this.page, this.body, this.location, this.latitude, this.longitude, this.imagesOrVideos});

  factory APIRegularHomeProfilePostExtended.fromJson(Map<String, dynamic> parsedJson){
    
    List<dynamic> newList;

    if(parsedJson['imagesOrVideos'] != null){
      var list = parsedJson['imagesOrVideos'];
      newList = List<dynamic>.from(list);
    }
    
    return APIRegularHomeProfilePostExtended(
      id: parsedJson['id'],
      page: APIRegularHomeProfilePostExtendedPage.fromJson(parsedJson['page']),
      body: parsedJson['body'],
      location: parsedJson['location'],
      latitude: parsedJson['latitude'],
      longitude: parsedJson['longitude'],
      imagesOrVideos: newList,
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

  APIRegularHomeProfilePostExtendedPage({this.id, this.name, this.details, this.backgroundImage, this.profileImage, this.imagesOrVideos, this.relationship, this.pageCreator});

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