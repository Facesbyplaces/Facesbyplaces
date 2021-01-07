import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIBLMSearchMemorialMain> apiBLMSearchBLM(String keywords) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  final http.Response response = await http.get('http://fbp.dev1.koda.ws/api/v1/search/memorials?keywords=$keywords&page=blm',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    }
  );

  print('The status code for blm search is ${response.statusCode}');
  print('The status body for blm search is ${response.body}');

  if(response.statusCode == 200){
    var newValue = json.decode(response.body);
    return APIBLMSearchMemorialMain.fromJson(newValue);
  }else{
    throw Exception('Failed to get the memorials.');
  }
}

class APIBLMSearchMemorialMain{
  int itemsRemaining;
  // List<APIBLMSearchMemorialExtended> memorialList;
  List<APIBLMSearchMemorialPage> memorialList;

  APIBLMSearchMemorialMain({this.itemsRemaining, this.memorialList});

  factory APIBLMSearchMemorialMain.fromJson(Map<String, dynamic> parsedJson){

    print('Samplee!');

    print('The item remaining is ${parsedJson['itemsremaining']}');
    // print('The memorials list is ${parsedJson['memorials']}');

    var memorialList = parsedJson['memorials'] as List;
    // List<APIBLMSearchMemorialExtended> newMemorialList = memorialList.map((e) => APIBLMSearchMemorialExtended.fromJson(e)).toList();

    // var memorialList = parsedJson['memorials'] as List;

    // print('The length is ${memorialList.length}');

    List<APIBLMSearchMemorialPage> newMemorialList = memorialList.map((e) => APIBLMSearchMemorialPage.fromJson(e)).toList();

    print('The memorial list is $newMemorialList');

    print('Nicee!');

    return APIBLMSearchMemorialMain(
      itemsRemaining: parsedJson['itemsremaining'],
      memorialList: newMemorialList,
    );
  }
}

class APIBLMSearchMemorialPage{
  int id;
  APIBLMSearchMemorialExtended page;

  APIBLMSearchMemorialPage({this.id, this.page});

  factory APIBLMSearchMemorialPage.fromJson(Map<String, dynamic> parsedJson){
    print('New new new!');
    return APIBLMSearchMemorialPage(
      id: parsedJson['id'],
      // page: parsedJson['page'],
      page: APIBLMSearchMemorialExtended.fromJson(parsedJson['page']),
    );
  }
}

class APIBLMSearchMemorialExtended{
  int id;
  String name;
  APIBLMSearchMemorialExtendedPageDetails details;
  dynamic backgroundImage;
  dynamic profileImage;
  List<dynamic> imagesOrVideos;
  String relationship;
  APIBLMSearchMemorialExtendedPageCreator pageCreator;
  // bool managed;
  // bool follower;
  // String pageType;

  bool manage;
  bool famOrFriends;
  bool follower;
  String pageType;
  String privacy;

  APIBLMSearchMemorialExtended({this.id, this.name, this.details, this.backgroundImage, this.profileImage, this.imagesOrVideos, this.relationship, this.pageCreator, this.manage, this.famOrFriends, this.follower, this.pageType, this.privacy});

  factory APIBLMSearchMemorialExtended.fromJson(Map<String, dynamic> parsedJson){
    print('The id is ${parsedJson['id']}');

    List<dynamic> newList1;

    if(parsedJson['imagesOrVideos'] != null){
      var list = parsedJson['imagesOrVideos'];
      newList1 = List<dynamic>.from(list);
    }

    return APIBLMSearchMemorialExtended(
      id: parsedJson['id'],
      name: parsedJson['name'],
      details: APIBLMSearchMemorialExtendedPageDetails.fromJson(parsedJson['details']),
      backgroundImage: parsedJson['backgroundImage'],
      profileImage: parsedJson['profileImage'],
      // imagesOrVideos: parsedJson['imagesOrVideos'],
      imagesOrVideos: newList1,
      relationship: parsedJson['relationship'],
      pageCreator: APIBLMSearchMemorialExtendedPageCreator.fromJson(parsedJson['page_creator']),
      manage: parsedJson['manage'],
      famOrFriends: parsedJson['famOrFriends'],
      follower: parsedJson['follower'],
      pageType: parsedJson['page_type'],
      privacy: parsedJson['privacy'],
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
    print('Test test test!');
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

class APIBLMSearchMemorialExtendedPageCreator{
  int id;
  String firstName;
  String lastName;
  String phoneNumber;
  String email;
  String userName;
  dynamic image;

  APIBLMSearchMemorialExtendedPageCreator({this.id, this.firstName, this.lastName, this.phoneNumber, this.email, this.userName, this.image});

  factory APIBLMSearchMemorialExtendedPageCreator.fromJson(Map<String, dynamic> parsedJson){
    print('Sample sample sample!');
    print('The value is $parsedJson');
    return APIBLMSearchMemorialExtendedPageCreator(
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
