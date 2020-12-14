import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIRegularHomeTabMemorialMain> apiRegularHomeMemorialsTab(int page) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  var getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  var getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  var getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  final http.Response response = await http.get('http://fbp.dev1.koda.ws/api/v1/mainpages/memorials?page=$page',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    }
  );

  if(response.statusCode == 200){
    var newValue = json.decode(response.body);
    return APIRegularHomeTabMemorialMain.fromJson(newValue);
  }else{
    throw Exception('Failed to get the memorials');
  }
}



class APIRegularHomeTabMemorialMain{

  APIRegularHomeTabMemorialExtended familyMemorialList;
  APIRegularHomeTabMemorialExtended friendsMemorialList;

  APIRegularHomeTabMemorialMain({this.familyMemorialList, this.friendsMemorialList});

  factory APIRegularHomeTabMemorialMain.fromJson(Map<String, dynamic> parsedJson){

    return APIRegularHomeTabMemorialMain(
      familyMemorialList: APIRegularHomeTabMemorialExtended.fromJson(parsedJson['family']),
      friendsMemorialList: APIRegularHomeTabMemorialExtended.fromJson(parsedJson['friends']),
    );
  }
}

class APIRegularHomeTabMemorialExtended{
  int blmFamilyItemsRemaining;
  int memorialFamilyItemsRemaining;
  int blmFriendsItemsRemaining;
  int memorialFriendsItemsRemaining;
  List<APIRegularHomeTabMemorialExtendedPage> blm;
  List<APIRegularHomeTabMemorialExtendedPage> memorial;

  APIRegularHomeTabMemorialExtended({this.blm, this.memorial, this.blmFamilyItemsRemaining, this.memorialFamilyItemsRemaining, this.blmFriendsItemsRemaining, this.memorialFriendsItemsRemaining});

  factory APIRegularHomeTabMemorialExtended.fromJson(Map<String, dynamic> parsedJson){

    var blmList = parsedJson['blm'] as List;
    var memorialList = parsedJson['memorial'] as List;

    List<APIRegularHomeTabMemorialExtendedPage> newBLMList = blmList.map((e) => APIRegularHomeTabMemorialExtendedPage.fromJson(e)).toList();
    List<APIRegularHomeTabMemorialExtendedPage> newMemorialList = memorialList.map((e) => APIRegularHomeTabMemorialExtendedPage.fromJson(e)).toList();

    return APIRegularHomeTabMemorialExtended(
      blm: newBLMList,
      memorial: newMemorialList,
      blmFamilyItemsRemaining: parsedJson['blmFamilyItemsRemaining'],
      memorialFamilyItemsRemaining: parsedJson['memorialFamilyItemsRemaining'],
      blmFriendsItemsRemaining: parsedJson['blmFriendsItemsRemaining'],
      memorialFriendsItemsRemaining: parsedJson['memorialFriendsItemsRemaining']
    );
  }
}

class APIRegularHomeTabMemorialExtendedPage{
  int id;
  String name;
  APIRegularHomeTabMemorialExtendedPageDetails details;
  dynamic backgroundImage;
  dynamic profileImage;
  dynamic imagesOrVideos;
  String relationship;
  APIRegularHomeTabMemorialExtendedPageCreator pageCreator;
  bool managed;

  APIRegularHomeTabMemorialExtendedPage({this.id, this.name, this.details, this.backgroundImage, this.profileImage, this.imagesOrVideos, this.relationship, this.pageCreator, this.managed});

  factory APIRegularHomeTabMemorialExtendedPage.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularHomeTabMemorialExtendedPage(
      id: parsedJson['id'],
      name: parsedJson['name'],
      details: APIRegularHomeTabMemorialExtendedPageDetails.fromJson(parsedJson['details']),
      backgroundImage: parsedJson['backgroundImage'],
      profileImage: parsedJson['profileImage'],
      imagesOrVideos: parsedJson['imagesOrVideos'],
      relationship: parsedJson['relationship'],
      pageCreator: APIRegularHomeTabMemorialExtendedPageCreator.fromJson(parsedJson['page_creator']),
      managed: parsedJson['manage'],
    );
  }
}

class APIRegularHomeTabMemorialExtendedPageDetails{
  String description;
  String birthPlace;
  String dob;
  String rip;
  String cemetery;
  String country;

  APIRegularHomeTabMemorialExtendedPageDetails({this.description, this.birthPlace, this.dob, this.rip, this.cemetery, this.country});

  factory APIRegularHomeTabMemorialExtendedPageDetails.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularHomeTabMemorialExtendedPageDetails(
      description: parsedJson['description'],
      birthPlace: parsedJson['birthplace'],
      dob: parsedJson['dob'],
      rip: parsedJson['rip'],
      cemetery: parsedJson['cemetery'],
      country: parsedJson['country'],
    );
  }
}

class APIRegularHomeTabMemorialExtendedPageCreator{
  int id;
  String firstName;
  String lastName;
  String phoneNumber;
  String email;
  String userName;
  dynamic image;

  APIRegularHomeTabMemorialExtendedPageCreator({this.id, this.firstName, this.lastName, this.phoneNumber, this.email, this.userName, this.image});

  factory APIRegularHomeTabMemorialExtendedPageCreator.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularHomeTabMemorialExtendedPageCreator(
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
