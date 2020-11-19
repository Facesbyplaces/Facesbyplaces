import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

Future<APIBLMCreateMemorialMain> apiBLMHomeMemorialsTab() async{

  final sharedPrefs = await SharedPreferences.getInstance();
  var getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  var getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  var getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  final http.Response response = await http.get(
    'http://fbp.dev1.koda.ws/api/v1/mainpages/memorials',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    }
  );
  
  print('The response status in memorial is ${response.statusCode}');
  print('The response status in memorial is ${response.body}');
  print('The response headers in memorial is ${response.headers}');

  if(response.statusCode == 200){

    if(response.headers['access-token'] != null && response.headers['uid'] != null && response.headers['client'] != null){
      sharedPrefs.setString('blm-access-token', response.headers['access-token']);
      sharedPrefs.setString('blm-uid', response.headers['uid']);    
      sharedPrefs.setString('blm-client', response.headers['client']);
    }

    var newValue = json.decode(response.body);
    return APIBLMCreateMemorialMain.fromJson(newValue);
  }else{
    throw Exception('Failed to get the events');
  }
}

class APIBLMCreateMemorialMain{

  List<APIBLMCreateMemorialExtended> familyMemorialList;
  List<APIBLMCreateMemorialExtended> friendsMemorialList;

  APIBLMCreateMemorialMain({this.familyMemorialList, this.friendsMemorialList});

  factory APIBLMCreateMemorialMain.fromJson(Map<String, dynamic> parsedJson){
    
    var familyList = parsedJson['family'] as List;
    var friendsList = parsedJson['friends'] as List;
    
    List<APIBLMCreateMemorialExtended> familyMemorials = familyList.map((e) => APIBLMCreateMemorialExtended.fromJson(e)).toList();
    List<APIBLMCreateMemorialExtended> friendsMemorials = friendsList.map((e) => APIBLMCreateMemorialExtended.fromJson(e)).toList();

    return APIBLMCreateMemorialMain(
      familyMemorialList: familyMemorials,
      friendsMemorialList: friendsMemorials,
    );
  }
}


class APIBLMCreateMemorialExtended{
  int id;
  APIBLMCreateMemorialExtendedPage page;

  APIBLMCreateMemorialExtended({this.id, this.page});

  factory APIBLMCreateMemorialExtended.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMCreateMemorialExtended(
      id: parsedJson['id'],
      page: APIBLMCreateMemorialExtendedPage.fromJson(parsedJson['page']),
    );
  }
}

class APIBLMCreateMemorialExtendedPage{
  int id;
  String name;
  APIBLMCreateMemorialExtendedPageDetails details;
  dynamic backgroundImage;
  dynamic profileImage;
  dynamic imagesOrVideos;
  String relationship;
  APIBLMCreateMemorialExtendedPageCreator pageCreator;

  APIBLMCreateMemorialExtendedPage({this.id, this.name, this.details, this.backgroundImage, this.profileImage, this.imagesOrVideos, this.relationship, this.pageCreator});

  factory APIBLMCreateMemorialExtendedPage.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMCreateMemorialExtendedPage(
      id: parsedJson['id'],
      name: parsedJson['name'],
      details: APIBLMCreateMemorialExtendedPageDetails.fromJson(parsedJson['details']),
      backgroundImage: parsedJson['backgroundImage'],
      profileImage: parsedJson['profileImage'],
      imagesOrVideos: parsedJson['imagesOrVideos'],
      relationship: parsedJson['relationship'],
      pageCreator: APIBLMCreateMemorialExtendedPageCreator.fromJson(parsedJson['page_creator']),
      
    );
  }
}

class APIBLMCreateMemorialExtendedPageDetails{
  String description;
  String birthPlace;
  String dob;
  String rip;
  String cemetery;
  String country;

  APIBLMCreateMemorialExtendedPageDetails({this.description, this.birthPlace, this.dob, this.rip, this.cemetery, this.country});

  factory APIBLMCreateMemorialExtendedPageDetails.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMCreateMemorialExtendedPageDetails(
      description: parsedJson['description'],
      birthPlace: parsedJson['birthplace'],
      dob: parsedJson['dob'],
      rip: parsedJson['rip'],
      cemetery: parsedJson['cemetery'],
      country: parsedJson['country'],
    );
  }
}

class APIBLMCreateMemorialExtendedPageCreator{
  int id;
  String firstName;
  String lastName;
  String phoneNumber;
  String email;
  String userName;
  dynamic image;

  APIBLMCreateMemorialExtendedPageCreator({this.id, this.firstName, this.lastName, this.phoneNumber, this.email, this.userName, this.image});

  factory APIBLMCreateMemorialExtendedPageCreator.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMCreateMemorialExtendedPageCreator(
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