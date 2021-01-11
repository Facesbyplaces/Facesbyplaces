import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIRegularSearchMemorialMain> apiRegularSearchBLM({String keywords}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  final http.Response response = await http.get('http://fbp.dev1.koda.ws/api/v1/search/memorials?keywords=$keywords&page=blm',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    }
  );

  if(response.statusCode == 200){
    var newValue = json.decode(response.body);
    return APIRegularSearchMemorialMain.fromJson(newValue);
  }else{
    throw Exception('Failed to get the memorials.');
  }
}

class APIRegularSearchMemorialMain{
  int itemsRemaining;
  List<APIRegularSearchMemorialPage> memorialList;

  APIRegularSearchMemorialMain({this.itemsRemaining, this.memorialList});

  factory APIRegularSearchMemorialMain.fromJson(Map<String, dynamic> parsedJson){

    var memorialList = parsedJson['memorials'] as List;
    List<APIRegularSearchMemorialPage> newMemorialList = memorialList.map((e) => APIRegularSearchMemorialPage.fromJson(e)).toList();

    return APIRegularSearchMemorialMain(
      itemsRemaining: parsedJson['itemsremaining'],
      memorialList: newMemorialList,
    );
  }
}

class APIRegularSearchMemorialPage{
  int id;
  APIRegularSearchMemorialExtended page;

  APIRegularSearchMemorialPage({this.id, this.page});

  factory APIRegularSearchMemorialPage.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularSearchMemorialPage(
      id: parsedJson['id'],
      page: APIRegularSearchMemorialExtended.fromJson(parsedJson['page']),
    );
  }
}

class APIRegularSearchMemorialExtended{
  int id;
  String name;
  APIRegularSearchMemorialExtendedPageDetails details;
  dynamic backgroundImage;
  dynamic profileImage;
  List<dynamic> imagesOrVideos;
  String relationship;
  APIRegularSearchMemorialExtendedPageCreator pageCreator;
  bool manage;
  bool famOrFriends;
  bool follower;
  String pageType;
  String privacy;

  APIRegularSearchMemorialExtended({this.id, this.name, this.details, this.backgroundImage, this.profileImage, this.imagesOrVideos, this.relationship, this.pageCreator, this.manage, this.famOrFriends, this.follower, this.pageType, this.privacy});

  factory APIRegularSearchMemorialExtended.fromJson(Map<String, dynamic> parsedJson){

    List<dynamic> newList1;

    if(parsedJson['imagesOrVideos'] != null){
      var list = parsedJson['imagesOrVideos'];
      newList1 = List<dynamic>.from(list);
    }

    return APIRegularSearchMemorialExtended(
      id: parsedJson['id'],
      name: parsedJson['name'],
      details: APIRegularSearchMemorialExtendedPageDetails.fromJson(parsedJson['details']),
      backgroundImage: parsedJson['backgroundImage'],
      profileImage: parsedJson['profileImage'],
      imagesOrVideos: newList1,
      relationship: parsedJson['relationship'],
      pageCreator: APIRegularSearchMemorialExtendedPageCreator.fromJson(parsedJson['page_creator']),
      manage: parsedJson['manage'],
      famOrFriends: parsedJson['famOrFriends'],
      follower: parsedJson['follower'],
      pageType: parsedJson['page_type'],
      privacy: parsedJson['privacy'],
    );
  }
}


class APIRegularSearchMemorialExtendedPageDetails{
  String description;
  String birthPlace;
  String dob;
  String rip;
  String cemetery;
  String country;

  APIRegularSearchMemorialExtendedPageDetails({this.description, this.birthPlace, this.dob, this.rip, this.cemetery, this.country});

  factory APIRegularSearchMemorialExtendedPageDetails.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularSearchMemorialExtendedPageDetails(
      description: parsedJson['description'],
      birthPlace: parsedJson['birthplace'],
      dob: parsedJson['dob'],
      rip: parsedJson['rip'],
      cemetery: parsedJson['cemetery'],
      country: parsedJson['country'],
    );
  }
}

class APIRegularSearchMemorialExtendedPageCreator{
  int id;
  String firstName;
  String lastName;
  String phoneNumber;
  String email;
  String userName;
  dynamic image;

  APIRegularSearchMemorialExtendedPageCreator({this.id, this.firstName, this.lastName, this.phoneNumber, this.email, this.userName, this.image});

  factory APIRegularSearchMemorialExtendedPageCreator.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularSearchMemorialExtendedPageCreator(
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
