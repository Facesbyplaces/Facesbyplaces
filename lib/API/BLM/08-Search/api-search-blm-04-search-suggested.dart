import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIBLMSearchSuggestedMain> apiBLMSearchSuggested({int page}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  final http.Response response = await http.get('http://fbp.dev1.koda.ws/api/v1/search/suggested/?page=$page',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    }
  );

  if(response.statusCode == 200){
    var newValue = json.decode(response.body);
    return APIBLMSearchSuggestedMain.fromJson(newValue);
  }else{
    throw Exception('Failed to get the feed');
  }
}

class APIBLMSearchSuggestedMain{
  int itemsRemaining;
  List<APIBLMSearchSuggestedExtended> pages;

  APIBLMSearchSuggestedMain({this.itemsRemaining, this.pages});

  factory APIBLMSearchSuggestedMain.fromJson(Map<String, dynamic> parsedJson){

    var newList = parsedJson['pages'] as List;
    List<APIBLMSearchSuggestedExtended> pagesList = newList.map((i) => APIBLMSearchSuggestedExtended.fromJson(i)).toList();

    return APIBLMSearchSuggestedMain(
      itemsRemaining: parsedJson['itemsRemaining'],
      pages: pagesList,
    );
  }
}

class APIBLMSearchSuggestedExtended{
  int id;
  APIBLMSearchPostExtendedPage page;

  APIBLMSearchSuggestedExtended({this.id, this.page});

  factory APIBLMSearchSuggestedExtended.fromJson(Map<String, dynamic> parsedJson){
    
    return APIBLMSearchSuggestedExtended(
      id: parsedJson['id'],
      page: APIBLMSearchPostExtendedPage.fromJson(parsedJson['page'])
    );
  }
}


class APIBLMSearchPostExtendedPage{
  int id;
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

  APIBLMSearchPostExtendedPage({this.id, this.name, this.details, this.backgroundImage, this.profileImage, this.imagesOrVideos, this.relationship, this.pageCreator, this.manage, this.famOrFriends, this.follower, this.pageType, this.privacy});

  factory APIBLMSearchPostExtendedPage.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMSearchPostExtendedPage(
      id: parsedJson['id'],
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
  String location;
  String precinct;
  String dob;
  String rip;
  String state;
  String country;

  APIBLMPostExtendedPageDetails({this.description, this.location, this.precinct, this.dob, this.rip, this.state, this.country});

  factory APIBLMPostExtendedPageDetails.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMPostExtendedPageDetails(
      description: parsedJson['description'],
      location: parsedJson['location'],
      precinct: parsedJson['precinct'],
      dob: parsedJson['dob'],
      rip: parsedJson['rip'],
      state: parsedJson['state'],
      country: parsedJson['country'],
    );
  }
}

class APIBLMHomeTabPostExtendedPageCreator{
  int id;
  String firstName;
  String lastName;
  String phoneNumber;
  String email;
  String userName;
  dynamic image;

  APIBLMHomeTabPostExtendedPageCreator({this.id, this.firstName, this.lastName, this.phoneNumber, this.email, this.userName, this.image});

  factory APIBLMHomeTabPostExtendedPageCreator.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMHomeTabPostExtendedPageCreator(
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