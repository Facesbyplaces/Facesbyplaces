import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIRegularSearchMemorialMain> apiRegularSearchMemorials(String keywords) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  // int memorialId = sharedPrefs.getInt('regular-user-memorial-id') ?? 0;
  var getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  var getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  var getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  final http.Response response = await http.get(
    'http://fbp.dev1.koda.ws/api/v1/search/memorials?keywords=$keywords&page=1',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    }
  );

  print('The response status in search profile is ${response.statusCode}');
  print('The response status in search profile is ${response.body}');

  // if(response.statusCode == 200){
  //   return true;
  // }else{
  //   return false;
  // }

  if(response.statusCode == 200){
    var newValue = json.decode(response.body);
    return APIRegularSearchMemorialMain.fromJson(newValue);
  }else{
    throw Exception('Failed to get the feed');
  }
}



class APIRegularSearchMemorialMain{

  List<APIRegularSearchMemorialExtended> familyMemorialList;

  APIRegularSearchMemorialMain({this.familyMemorialList});

  factory APIRegularSearchMemorialMain.fromJson(List<dynamic> parsedJson){
    List<APIRegularSearchMemorialExtended> familyMemorials = parsedJson.map((e) => APIRegularSearchMemorialExtended.fromJson(e)).toList();

    return APIRegularSearchMemorialMain(
      familyMemorialList: familyMemorials,
    );
  }
}


class APIRegularSearchMemorialExtended{
  int id;
  APIRegularSearchMemorialExtendedPage page;
  
  APIRegularSearchMemorialExtended({this.id, this.page});

  factory APIRegularSearchMemorialExtended.fromJson(Map<String, dynamic> parsedJson){
    
    return APIRegularSearchMemorialExtended(
      id: parsedJson['id'],
      page: APIRegularSearchMemorialExtendedPage.fromJson(parsedJson['page']),
    );
  }
}

class APIRegularSearchMemorialExtendedPage{
  int id;
  String name;
  APIRegularRegularMemorialExtendedPageDetails details;
  dynamic backgroundImage;
  dynamic profileImage;
  dynamic imagesOrVideos;
  String relationship;
  bool manage;
  bool famOrFriends;
  bool follower;

  APIRegularSearchMemorialExtendedPage({this.id, this.name, this.details, this.backgroundImage, this.profileImage, this.imagesOrVideos, this.relationship, this.manage, this.famOrFriends, this.follower});

  factory APIRegularSearchMemorialExtendedPage.fromJson(Map<String, dynamic> parsedJson){
    // List<dynamic> newList;

    // if(parsedJson['imagesOrVideos'] != null){
    //   var list = parsedJson['imagesOrVideos'];
    //   newList = List<dynamic>.from(list);
    // }

    return APIRegularSearchMemorialExtendedPage(
      id: parsedJson['id'],
      name: parsedJson['name'],
      details: APIRegularRegularMemorialExtendedPageDetails.fromJson(parsedJson['details']),
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

class APIRegularRegularMemorialExtendedPageDetails{
  String description;
  String birthPlace;
  String dob;
  String rip;
  String cemetery;
  String country;

  APIRegularRegularMemorialExtendedPageDetails({this.description, this.birthPlace, this.dob, this.rip, this.cemetery, this.country});

  factory APIRegularRegularMemorialExtendedPageDetails.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularRegularMemorialExtendedPageDetails(
      description: parsedJson['description'],
      birthPlace: parsedJson['birthplace'],
      dob: parsedJson['dob'],
      rip: parsedJson['rip'],
      cemetery: parsedJson['cemetery'],
      country: parsedJson['country'],
    );
  }
}

// class APIRegularHomeTabPostExtendedPageCreator{
//   int id;
//   String firstName;
//   String lastName;
//   String phoneNumber;
//   String email;
//   String userName;
//   dynamic image;

//   APIRegularHomeTabPostExtendedPageCreator({this.id, this.firstName, this.lastName, this.phoneNumber, this.email, this.userName, this.image});

//   factory APIRegularHomeTabPostExtendedPageCreator.fromJson(Map<String, dynamic> parsedJson){
//     return APIRegularHomeTabPostExtendedPageCreator(
//       id: parsedJson['id'],
//       firstName: parsedJson['first_name'],
//       lastName: parsedJson['last_name'],
//       phoneNumber: parsedJson['phone_number'],
//       email: parsedJson['email'],
//       userName: parsedJson['username'],
//       image: parsedJson['image']
//     );
//   }
// }