import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIBLMShowMemorialMain> apiBLMShowMemorial() async{

  final sharedPrefs = await SharedPreferences.getInstance();
  int memorialId = sharedPrefs.getInt('blm-user-memorial-id') ?? 0;
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  final http.Response response = await http.get(
    // 'http://fbp.dev1.koda.ws/api/v1/pages/memorials/$memorialId',
    'http://fbp.dev1.koda.ws/api/v1/pages/blm/$memorialId',
    // 'http://fbp.dev1.koda.ws/api/v1/pages/blm/2',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    }
  );
  
  print('The response status in blm show memorial is ${response.statusCode}');
  print('The response status in blm show memorial is ${response.body}');

  if(response.statusCode == 200){
    var newValue = json.decode(response.body);
    return APIBLMShowMemorialMain.fromJson(newValue);
  }else{
    throw Exception('Failed to get the events');
  }
}




class APIBLMShowMemorialMain{

  APIBLMShowMemorialExtended memorial;

  APIBLMShowMemorialMain({this.memorial});

  factory APIBLMShowMemorialMain.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMShowMemorialMain(
      memorial: APIBLMShowMemorialExtended.fromJson(parsedJson['blm']),
    );
  }
}


class APIBLMShowMemorialExtended{
  int id;
  String name;
  APIBLMShowMemorialExtendedDetails details;
  dynamic backgroundImage;
  dynamic profileImage;
  dynamic imagesOrVideos;
  String relationship;
  APIBLMShowMemorialExtendedPageCreator pageCreator;

  APIBLMShowMemorialExtended({this.id, this.name, this.details, this.backgroundImage, this.profileImage, this.imagesOrVideos, this.relationship, this.pageCreator});

  factory APIBLMShowMemorialExtended.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMShowMemorialExtended(
      id: parsedJson['id'],
      name: parsedJson['name'],
      details: APIBLMShowMemorialExtendedDetails.fromJson(parsedJson['details']),
      backgroundImage: parsedJson['backgroundImage'],
      profileImage: parsedJson['profileImage'],
      imagesOrVideos: parsedJson['imagesOrVideos'],
      relationship: parsedJson['relationship'],
      pageCreator: APIBLMShowMemorialExtendedPageCreator.fromJson(parsedJson['page_creator'])
    );
  }
}


class APIBLMShowMemorialExtendedDetails{
  String description;
  String birthPlace;
  String dob;
  String rip;
  String cemetery;
  String country;

  APIBLMShowMemorialExtendedDetails({this.description, this.birthPlace, this.dob, this.rip, this.cemetery, this.country});

  factory APIBLMShowMemorialExtendedDetails.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMShowMemorialExtendedDetails(
      description: parsedJson['description'],
      birthPlace: parsedJson['birthplace'],
      dob: parsedJson['dob'],
      rip: parsedJson['rip'],
      cemetery: parsedJson['cemetery'],
      country: parsedJson['country'],
    );
  }
}

class APIBLMShowMemorialExtendedPageCreator{
  int id;
  String firstName;
  String lastName;
  String phoneNumber;
  String email;
  String userName;
  dynamic image;

  APIBLMShowMemorialExtendedPageCreator({this.id, this.firstName, this.lastName, this.phoneNumber, this.email, this.userName, this.image});

  factory APIBLMShowMemorialExtendedPageCreator.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMShowMemorialExtendedPageCreator(
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




// ========================================================================================================================



// class APIBLMShowProfileMain{

//   List<APIBLMShowProfileExtended> familyMemorialList;

//   APIBLMShowProfileMain({this.familyMemorialList});

//   factory APIBLMShowProfileMain.fromJson(Map<String, dynamic> parsedJson){

//     var familyList = parsedJson['family'] as List;  
//     List<APIBLMShowProfileExtended> familyMemorials = familyList.map((e) => APIBLMShowProfileExtended.fromJson(e)).toList();

//     return APIBLMShowProfileMain(
//       familyMemorialList: familyMemorials,
//     );
//   }
// }


// class APIBLMShowProfileExtended{
//   int id;
//   APIBLMShowProfileExtendedPage page;
//   String body;
//   String location;
//   double latitude;
//   double longitude;
//   List<dynamic> imagesOrVideos;

//   APIBLMShowProfileExtended({this.id, this.page, this.body, this.location, this.latitude, this.longitude, this.imagesOrVideos});

//   factory APIBLMShowProfileExtended.fromJson(Map<String, dynamic> parsedJson){
    
//     List<dynamic> newList;

//     if(parsedJson['imagesOrVideos'] != null){
//       var list = parsedJson['imagesOrVideos'];
//       newList = List<dynamic>.from(list);
//     }
    
//     return APIBLMShowProfileExtended(
//       id: parsedJson['id'],
//       page: APIBLMShowProfileExtendedPage.fromJson(parsedJson['page']),
//       body: parsedJson['body'],
//       location: parsedJson['location'],
//       latitude: parsedJson['latitude'],
//       longitude: parsedJson['longitude'],
//       imagesOrVideos: newList,
//     );
//   }
// }

// class APIBLMShowProfileExtendedPage{
//   int id;
//   String name;
//   APIBLMShowProfileExtendedPageDetails details;
//   dynamic backgroundImage;
//   dynamic profileImage;
//   dynamic imagesOrVideos;
//   String relationship;
//   APIBLMShowProfileExtendedPageCreator pageCreator;

//   APIBLMShowProfileExtendedPage({this.id, this.name, this.details, this.backgroundImage, this.profileImage, this.imagesOrVideos, this.relationship, this.pageCreator});

//   factory APIBLMShowProfileExtendedPage.fromJson(Map<String, dynamic> parsedJson){
//     return APIBLMShowProfileExtendedPage(
//       id: parsedJson['id'],
//       name: parsedJson['name'],
//       details: APIBLMShowProfileExtendedPageDetails.fromJson(parsedJson['details']),
//       backgroundImage: parsedJson['backgroundImage'],
//       profileImage: parsedJson['profileImage'],
//       imagesOrVideos: parsedJson['imagesOrVideos'],
//       relationship: parsedJson['relationship'],
//       pageCreator: APIBLMShowProfileExtendedPageCreator.fromJson(parsedJson['page_creator']),
      
//     );
//   }
// }

// class APIBLMShowProfileExtendedPageDetails{
//   String description;
//   String birthPlace;
//   String dob;
//   String rip;
//   String cemetery;
//   String country;

//   APIBLMShowProfileExtendedPageDetails({this.description, this.birthPlace, this.dob, this.rip, this.cemetery, this.country});

//   factory APIBLMShowProfileExtendedPageDetails.fromJson(Map<String, dynamic> parsedJson){
//     return APIBLMShowProfileExtendedPageDetails(
//       description: parsedJson['description'],
//       birthPlace: parsedJson['birthplace'],
//       dob: parsedJson['dob'],
//       rip: parsedJson['rip'],
//       cemetery: parsedJson['cemetery'],
//       country: parsedJson['country'],
//     );
//   }
// }

// class APIBLMShowProfileExtendedPageCreator{
//   int id;
//   String firstName;
//   String lastName;
//   String phoneNumber;
//   String email;
//   String userName;
//   dynamic image;

//   APIBLMShowProfileExtendedPageCreator({this.id, this.firstName, this.lastName, this.phoneNumber, this.email, this.userName, this.image});

//   factory APIBLMShowProfileExtendedPageCreator.fromJson(Map<String, dynamic> parsedJson){
//     return APIBLMShowProfileExtendedPageCreator(
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






// ========================================================================================================================





// class APIBLMShowMemorialMain{

//   APIBLMShowMemorialExtended memorial;

//   APIBLMShowMemorialMain({this.memorial});

//   factory APIBLMShowMemorialMain.fromJson(Map<String, dynamic> parsedJson){
//     return APIBLMShowMemorialMain(
//       memorial: APIBLMShowMemorialExtended.fromJson(parsedJson['family']),
//     );
//   }
// }


// class APIBLMShowMemorialExtended{
//   int id;
//   String name;
//   APIBLMShowMemorialExtendedDetails details;
//   dynamic backgroundImage;
//   dynamic profileImage;
//   dynamic imagesOrVideos;
//   String relationship;
//   APIBLMShowMemorialExtendedPageCreator pageCreator;

//   APIBLMShowMemorialExtended({this.id, this.name, this.details, this.backgroundImage, this.profileImage, this.imagesOrVideos, this.relationship, this.pageCreator});

//   factory APIBLMShowMemorialExtended.fromJson(Map<String, dynamic> parsedJson){
//     return APIBLMShowMemorialExtended(
//       id: parsedJson['id'],
//       name: parsedJson['name'],
//       details: APIBLMShowMemorialExtendedDetails.fromJson(parsedJson['details']),
//       backgroundImage: parsedJson['backgroundImage'],
//       profileImage: parsedJson['profileImage'],
//       imagesOrVideos: parsedJson['imagesOrVideos'],
//       relationship: parsedJson['relationship'],
//       pageCreator: APIBLMShowMemorialExtendedPageCreator.fromJson(parsedJson['page_creator'])
//     );
//   }
// }


// class APIBLMShowMemorialExtendedDetails{
//   String description;
//   String location;
//   String precinct;
//   String dob;
//   String rip;
//   String state;
//   String country;

//   APIBLMShowMemorialExtendedDetails({this.description, this.location, this.precinct, this.dob, this.rip, this.state, this.country});

//   factory APIBLMShowMemorialExtendedDetails.fromJson(Map<String, dynamic> parsedJson){
//     return APIBLMShowMemorialExtendedDetails(
//       description: parsedJson['description'],
//       location: parsedJson['location'],
//       precinct: parsedJson['precinct'],
//       dob: parsedJson['dob'],
//       rip: parsedJson['rip'],
//       state: parsedJson['state'],
//       country: parsedJson['country'],
//     );
//   }
// }

// class APIBLMShowMemorialExtendedPageCreator{
//   int id;
//   String firstName;
//   String lastName;
//   String phoneNumber;
//   String email;
//   String userName;
//   dynamic image;

//   APIBLMShowMemorialExtendedPageCreator({this.id, this.firstName, this.lastName, this.phoneNumber, this.email, this.userName, this.image});

//   factory APIBLMShowMemorialExtendedPageCreator.fromJson(Map<String, dynamic> parsedJson){
//     return APIBLMShowMemorialExtendedPageCreator(
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