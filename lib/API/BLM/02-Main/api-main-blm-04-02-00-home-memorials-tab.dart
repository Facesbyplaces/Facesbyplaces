import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIBLMHomeTabMemorialMain> apiBLMHomeMemorialsTab(int page) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  final http.Response response = await http.get(
    'http://fbp.dev1.koda.ws/api/v1/mainpages/memorials?page=$page',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    }
  );

  print('The status code is ${response.statusCode}');
  print('The status body is ${response.body}');

  if(response.statusCode == 200){
    var newValue = json.decode(response.body);
    return APIBLMHomeTabMemorialMain.fromJson(newValue);
  }else{
    throw Exception('Failed to get the memorials');
  }
}



class APIBLMHomeTabMemorialMain{

  APIBLMHomeTabMemorialExtended familyMemorialList;
  APIBLMHomeTabMemorialExtended friendsMemorialList;

  APIBLMHomeTabMemorialMain({this.familyMemorialList, this.friendsMemorialList});

  factory APIBLMHomeTabMemorialMain.fromJson(Map<String, dynamic> parsedJson){

    return APIBLMHomeTabMemorialMain(
      familyMemorialList: APIBLMHomeTabMemorialExtended.fromJson(parsedJson['family']),
      friendsMemorialList: APIBLMHomeTabMemorialExtended.fromJson(parsedJson['friends']),
    );
  }
}

class APIBLMHomeTabMemorialExtended{
  int blmFamilyItemsRemaining;
  int memorialFamilyItemsRemaining;
  int blmFriendsItemsRemaining;
  int memorialFriendsItemsRemaining;
  List<APIBLMHomeTabMemorialExtendedPage> blm;
  List<APIBLMHomeTabMemorialExtendedPage> memorial;

  APIBLMHomeTabMemorialExtended({this.blm, this.memorial, this.blmFamilyItemsRemaining, this.memorialFamilyItemsRemaining, this.blmFriendsItemsRemaining, this.memorialFriendsItemsRemaining});

  factory APIBLMHomeTabMemorialExtended.fromJson(Map<String, dynamic> parsedJson){

    var blmList = parsedJson['blm'] as List;
    var memorialList = parsedJson['memorial'] as List;

    List<APIBLMHomeTabMemorialExtendedPage> newBLMList = blmList.map((e) => APIBLMHomeTabMemorialExtendedPage.fromJson(e)).toList();
    List<APIBLMHomeTabMemorialExtendedPage> newMemorialList = memorialList.map((e) => APIBLMHomeTabMemorialExtendedPage.fromJson(e)).toList();

    return APIBLMHomeTabMemorialExtended(
      blm: newBLMList,
      memorial: newMemorialList,
      blmFamilyItemsRemaining: parsedJson['blmFamilyItemsRemaining'],
      memorialFamilyItemsRemaining: parsedJson['memorialFamilyItemsRemaining'],
      blmFriendsItemsRemaining: parsedJson['blmFriendsItemsRemaining'],
      memorialFriendsItemsRemaining: parsedJson['memorialFriendsItemsRemaining']
    );
  }
}

class APIBLMHomeTabMemorialExtendedPage{
  int id;
  String name;
  APIBLMHomeTabMemorialExtendedPageDetails details;
  dynamic backgroundImage;
  dynamic profileImage;
  dynamic imagesOrVideos;
  String relationship;
  APIBLMHomeTabMemorialExtendedPageCreator pageCreator;
  // bool managed;
  bool manage;
  bool famOrFriends;
  bool follower;
  String pageType;
  String privacy;

  APIBLMHomeTabMemorialExtendedPage({this.id, this.name, this.details, this.backgroundImage, this.profileImage, this.imagesOrVideos, this.relationship, this.pageCreator, this.manage, this.famOrFriends, this.follower, this.pageType, this.privacy});

  factory APIBLMHomeTabMemorialExtendedPage.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMHomeTabMemorialExtendedPage(
      id: parsedJson['id'],
      name: parsedJson['name'],
      details: APIBLMHomeTabMemorialExtendedPageDetails.fromJson(parsedJson['details']),
      backgroundImage: parsedJson['backgroundImage'],
      profileImage: parsedJson['profileImage'],
      imagesOrVideos: parsedJson['imagesOrVideos'],
      relationship: parsedJson['relationship'],
      pageCreator: APIBLMHomeTabMemorialExtendedPageCreator.fromJson(parsedJson['page_creator']),
      // managed: parsedJson['manage'],
      manage: parsedJson['manage'],
      famOrFriends: parsedJson['famOrFriends'],
      follower: parsedJson['follower'],
      pageType: parsedJson['page_type'],
      privacy: parsedJson['privacy'],
    );
  }
}

class APIBLMHomeTabMemorialExtendedPageDetails{
  String description;
  String birthPlace;
  String dob;
  String rip;
  String cemetery;
  String country;

  APIBLMHomeTabMemorialExtendedPageDetails({this.description, this.birthPlace, this.dob, this.rip, this.cemetery, this.country});

  factory APIBLMHomeTabMemorialExtendedPageDetails.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMHomeTabMemorialExtendedPageDetails(
      description: parsedJson['description'],
      birthPlace: parsedJson['birthplace'],
      dob: parsedJson['dob'],
      rip: parsedJson['rip'],
      cemetery: parsedJson['cemetery'],
      country: parsedJson['country'],
    );
  }
}

class APIBLMHomeTabMemorialExtendedPageCreator{
  int id;
  String firstName;
  String lastName;
  String phoneNumber;
  String email;
  String userName;
  dynamic image;

  APIBLMHomeTabMemorialExtendedPageCreator({this.id, this.firstName, this.lastName, this.phoneNumber, this.email, this.userName, this.image});

  factory APIBLMHomeTabMemorialExtendedPageCreator.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMHomeTabMemorialExtendedPageCreator(
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
