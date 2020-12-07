import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIRegularHomeTabFeedMain> apiRegularHomeFeedTab(int page) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  var getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  var getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  var getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  final http.Response response = await http.get(
    'http://fbp.dev1.koda.ws/api/v1/mainpages/feed/?page=$page',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    }
  );

  // print('The response status in regular feed is ${response.statusCode}');
  // print('The response status in regular feed is ${response.body}');

  if(response.statusCode == 200){
    var newValue = json.decode(response.body);
    return APIRegularHomeTabFeedMain.fromJson(newValue);
  }else{
    throw Exception('Failed to get the feed');
  }
}


// class APIRegularHomeTabFeedMain{
//   int itemsRemaining;
//   List<APIRegularHomeTabFeedExtended> familyMemorialList;

//   APIRegularHomeTabFeedMain({this.itemsRemaining, this.familyMemorialList});

//   factory APIRegularHomeTabFeedMain.fromJson(Map<String, dynamic> parsedJson){
//     var newList = parsedJson['posts'] as List;
//     List<APIRegularHomeTabFeedExtended> familyMemorials = newList.map((i) => APIRegularHomeTabFeedExtended.fromJson(i)).toList();

//     return APIRegularHomeTabFeedMain(
//       itemsRemaining: parsedJson['itemsremaining'],
//       familyMemorialList: familyMemorials,
//     );
//   }
// }

class APIRegularHomeTabFeedMain{
  int itemsRemaining;
  List<APIRegularHomeTabFeedExtended> familyMemorialList;

  APIRegularHomeTabFeedMain({this.familyMemorialList, this.itemsRemaining});

  factory APIRegularHomeTabFeedMain.fromJson(Map<String, dynamic> parsedJson){
    var newList = parsedJson['posts'] as List;
    List<APIRegularHomeTabFeedExtended> familyMemorials = newList.map((i) => APIRegularHomeTabFeedExtended.fromJson(i)).toList();

    return APIRegularHomeTabFeedMain(
      familyMemorialList: familyMemorials,
      itemsRemaining: parsedJson['itemsremaining'],
    );
  }
}


class APIRegularHomeTabFeedExtended{
  int id;
  APIRegularHomeTabFeedExtendedPage page;
  String body;
  String location;
  double latitude;
  double longitude;
  List<dynamic> imagesOrVideos;
  String createAt;

  APIRegularHomeTabFeedExtended({this.id, this.page, this.body, this.location, this.latitude, this.longitude, this.imagesOrVideos, this.createAt});

  factory APIRegularHomeTabFeedExtended.fromJson(Map<String, dynamic> parsedJson){
    
    List<dynamic> newList;

    if(parsedJson['imagesOrVideos'] != null){
      var list = parsedJson['imagesOrVideos'];
      newList = List<dynamic>.from(list);
    }
    
    return APIRegularHomeTabFeedExtended(
      id: parsedJson['id'],
      page: APIRegularHomeTabFeedExtendedPage.fromJson(parsedJson['page']),
      body: parsedJson['body'],
      location: parsedJson['location'],
      latitude: parsedJson['latitude'],
      longitude: parsedJson['longitude'],
      imagesOrVideos: newList,
      createAt: parsedJson['created_at'],
    );
  }
}

class APIRegularHomeTabFeedExtendedPage{
  int id;
  String name;
  APIRegularHomeTabFeedExtendedPageDetails details;
  dynamic backgroundImage;
  dynamic profileImage;
  dynamic imagesOrVideos;
  String relationship;
  APIRegularHomeTabFeedExtendedPageCreator pageCreator;

  APIRegularHomeTabFeedExtendedPage({this.id, this.name, this.details, this.backgroundImage, this.profileImage, this.imagesOrVideos, this.relationship, this.pageCreator});

  factory APIRegularHomeTabFeedExtendedPage.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularHomeTabFeedExtendedPage(
      id: parsedJson['id'],
      name: parsedJson['name'],
      details: APIRegularHomeTabFeedExtendedPageDetails.fromJson(parsedJson['details']),
      backgroundImage: parsedJson['backgroundImage'],
      profileImage: parsedJson['profileImage'],
      imagesOrVideos: parsedJson['imagesOrVideos'],
      relationship: parsedJson['relationship'],
      pageCreator: APIRegularHomeTabFeedExtendedPageCreator.fromJson(parsedJson['page_creator']),
      
    );
  }
}

class APIRegularHomeTabFeedExtendedPageDetails{
  String description;
  String birthPlace;
  String dob;
  String rip;
  String cemetery;
  String country;

  APIRegularHomeTabFeedExtendedPageDetails({this.description, this.birthPlace, this.dob, this.rip, this.cemetery, this.country});

  factory APIRegularHomeTabFeedExtendedPageDetails.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularHomeTabFeedExtendedPageDetails(
      description: parsedJson['description'],
      birthPlace: parsedJson['birthplace'],
      dob: parsedJson['dob'],
      rip: parsedJson['rip'],
      cemetery: parsedJson['cemetery'],
      country: parsedJson['country'],
    );
  }
}

class APIRegularHomeTabFeedExtendedPageCreator{
  int id;
  String firstName;
  String lastName;
  String phoneNumber;
  String email;
  String userName;
  dynamic image;

  APIRegularHomeTabFeedExtendedPageCreator({this.id, this.firstName, this.lastName, this.phoneNumber, this.email, this.userName, this.image});

  factory APIRegularHomeTabFeedExtendedPageCreator.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularHomeTabFeedExtendedPageCreator(
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




// class APIRegularHomeTabFeedMain{

//   List<APIRegularHomeTabFeedExtended> familyMemorialList;

//   APIRegularHomeTabFeedMain({this.familyMemorialList});

//   factory APIRegularHomeTabFeedMain.fromJson(List<dynamic> parsedJson){
//     List<APIRegularHomeTabFeedExtended> familyMemorials = parsedJson.map((e) => APIRegularHomeTabFeedExtended.fromJson(e)).toList();

//     return APIRegularHomeTabFeedMain(
//       familyMemorialList: familyMemorials,
//     );
//   }
// }


// class APIRegularHomeTabFeedExtended{
//   int id;
//   APIRegularHomeTabFeedExtendedPage page;
//   String body;
//   String location;
//   double latitude;
//   double longitude;
//   List<dynamic> imagesOrVideos;

//   APIRegularHomeTabFeedExtended({this.id, this.page, this.body, this.location, this.latitude, this.longitude, this.imagesOrVideos});

//   factory APIRegularHomeTabFeedExtended.fromJson(Map<String, dynamic> parsedJson){
    
//     List<dynamic> newList;

//     if(parsedJson['imagesOrVideos'] != null){
//       var list = parsedJson['imagesOrVideos'];
//       newList = List<dynamic>.from(list);
//     }
    
//     return APIRegularHomeTabFeedExtended(
//       id: parsedJson['id'],
//       page: APIRegularHomeTabFeedExtendedPage.fromJson(parsedJson['page']),
//       body: parsedJson['body'],
//       location: parsedJson['location'],
//       latitude: parsedJson['latitude'],
//       longitude: parsedJson['longitude'],
//       imagesOrVideos: newList,
//     );
//   }
// }

// class APIRegularHomeTabFeedExtendedPage{
//   int id;
//   String name;
//   APIRegularHomeTabFeedExtendedPageDetails details;
//   dynamic backgroundImage;
//   dynamic profileImage;
//   dynamic imagesOrVideos;
//   String relationship;
//   APIRegularHomeTabFeedExtendedPageCreator pageCreator;

//   APIRegularHomeTabFeedExtendedPage({this.id, this.name, this.details, this.backgroundImage, this.profileImage, this.imagesOrVideos, this.relationship, this.pageCreator});

//   factory APIRegularHomeTabFeedExtendedPage.fromJson(Map<String, dynamic> parsedJson){
//     return APIRegularHomeTabFeedExtendedPage(
//       id: parsedJson['id'],
//       name: parsedJson['name'],
//       details: APIRegularHomeTabFeedExtendedPageDetails.fromJson(parsedJson['details']),
//       backgroundImage: parsedJson['backgroundImage'],
//       profileImage: parsedJson['profileImage'],
//       imagesOrVideos: parsedJson['imagesOrVideos'],
//       relationship: parsedJson['relationship'],
//       pageCreator: APIRegularHomeTabFeedExtendedPageCreator.fromJson(parsedJson['page_creator']),
      
//     );
//   }
// }

// class APIRegularHomeTabFeedExtendedPageDetails{
//   String description;
//   String birthPlace;
//   String dob;
//   String rip;
//   String cemetery;
//   String country;

//   APIRegularHomeTabFeedExtendedPageDetails({this.description, this.birthPlace, this.dob, this.rip, this.cemetery, this.country});

//   factory APIRegularHomeTabFeedExtendedPageDetails.fromJson(Map<String, dynamic> parsedJson){
//     return APIRegularHomeTabFeedExtendedPageDetails(
//       description: parsedJson['description'],
//       birthPlace: parsedJson['birthplace'],
//       dob: parsedJson['dob'],
//       rip: parsedJson['rip'],
//       cemetery: parsedJson['cemetery'],
//       country: parsedJson['country'],
//     );
//   }
// }

// class APIRegularHomeTabFeedExtendedPageCreator{
//   int id;
//   String firstName;
//   String lastName;
//   String phoneNumber;
//   String email;
//   String userName;
//   dynamic image;

//   APIRegularHomeTabFeedExtendedPageCreator({this.id, this.firstName, this.lastName, this.phoneNumber, this.email, this.userName, this.image});

//   factory APIRegularHomeTabFeedExtendedPageCreator.fromJson(Map<String, dynamic> parsedJson){
//     return APIRegularHomeTabFeedExtendedPageCreator(
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