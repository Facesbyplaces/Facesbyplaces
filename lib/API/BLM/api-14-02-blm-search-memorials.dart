import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIBLMSearchMemorialMain> apiBLMSearchMemorials(String keywords) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  final http.Response response = await http.get(
    'http://fbp.dev1.koda.ws/api/v1/search/memorials?keywords=$keywords&page=1',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    }
  );

  if(response.statusCode == 200){
    var newValue = json.decode(response.body);
    return APIBLMSearchMemorialMain.fromJson(newValue);
  }else{
    throw Exception('Failed to get the feed');
  }
}



class APIBLMSearchMemorialMain{

  List<APIBLMSearchMemorialExtended> familyMemorialList;

  APIBLMSearchMemorialMain({this.familyMemorialList});

  factory APIBLMSearchMemorialMain.fromJson(List<dynamic> parsedJson){
    List<APIBLMSearchMemorialExtended> familyMemorials = parsedJson.map((e) => APIBLMSearchMemorialExtended.fromJson(e)).toList();

    return APIBLMSearchMemorialMain(
      familyMemorialList: familyMemorials,
    );
  }
}


class APIBLMSearchMemorialExtended{
  int id;
  APIBLMSearchMemorialExtendedPage page;
  
  APIBLMSearchMemorialExtended({this.id, this.page});

  factory APIBLMSearchMemorialExtended.fromJson(Map<String, dynamic> parsedJson){
    
    return APIBLMSearchMemorialExtended(
      id: parsedJson['id'],
      page: APIBLMSearchMemorialExtendedPage.fromJson(parsedJson['page']),
    );
  }
}

class APIBLMSearchMemorialExtendedPage{
  int id;
  String name;
  APIBLMSearchMemorialExtendedPageDetails details;
  dynamic backgroundImage;
  dynamic profileImage;
  dynamic imagesOrVideos;
  String relationship;
  bool manage;
  bool famOrFriends;
  bool follower;

  APIBLMSearchMemorialExtendedPage({this.id, this.name, this.details, this.backgroundImage, this.profileImage, this.imagesOrVideos, this.relationship, this.manage, this.famOrFriends, this.follower});

  factory APIBLMSearchMemorialExtendedPage.fromJson(Map<String, dynamic> parsedJson){

    return APIBLMSearchMemorialExtendedPage(
      id: parsedJson['id'],
      name: parsedJson['name'],
      details: APIBLMSearchMemorialExtendedPageDetails.fromJson(parsedJson['details']),
      backgroundImage: parsedJson['backgroundImage'],
      profileImage: parsedJson['profileImage'],
      imagesOrVideos: parsedJson['imagesOrVideos'],
      relationship: parsedJson['relationship'],
      manage: parsedJson['manage'],
      famOrFriends: parsedJson['famOrFriends'],
      follower: parsedJson['follower'],
    );
  }
}

class APIBLMSearchMemorialExtendedPageDetails{
  String description;
  String birthPlace;
  String dob;
  String rip;
  String cemetery;
  String country;

  APIBLMSearchMemorialExtendedPageDetails({this.description, this.birthPlace, this.dob, this.rip, this.cemetery, this.country});

  factory APIBLMSearchMemorialExtendedPageDetails.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMSearchMemorialExtendedPageDetails(
      description: parsedJson['description'],
      birthPlace: parsedJson['birthplace'],
      dob: parsedJson['dob'],
      rip: parsedJson['rip'],
      cemetery: parsedJson['cemetery'],
      country: parsedJson['country'],
    );
  }
}
