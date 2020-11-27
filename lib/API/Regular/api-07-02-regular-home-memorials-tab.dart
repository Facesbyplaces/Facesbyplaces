import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIRegularHomeTabMemorialMain> apiRegularHomeMemorialsTab() async{

  final sharedPrefs = await SharedPreferences.getInstance();
  var getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  var getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  var getClient = sharedPrefs.getString('regular-client') ?? 'empty';

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
      familyMemorialList: parsedJson['family'],
      friendsMemorialList: parsedJson['friends'],
    );
  }
}

class APIRegularHomeTabMemorialExtended{

  List<APIRegularHomeTabMemorialExtendedPage> blm;
  List<APIRegularHomeTabMemorialExtendedPage> memorial;

  APIRegularHomeTabMemorialExtended({this.blm, this.memorial});

  factory APIRegularHomeTabMemorialExtended.fromJson(Map<String, dynamic> parsedJson){

    var blmList = parsedJson['blm'] as List;
    var memorialList = parsedJson['memorial'] as List;
    
    List<APIRegularHomeTabMemorialExtendedPage> newBLMList = blmList.map((e) => APIRegularHomeTabMemorialExtendedPage.fromJson(e)).toList();
    List<APIRegularHomeTabMemorialExtendedPage> newMemorialList = memorialList.map((e) => APIRegularHomeTabMemorialExtendedPage.fromJson(e)).toList();

    return APIRegularHomeTabMemorialExtended(
      blm: newBLMList,
      memorial: newMemorialList,
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

  APIRegularHomeTabMemorialExtendedPage({this.id, this.name, this.details, this.backgroundImage, this.profileImage, this.imagesOrVideos, this.relationship, this.pageCreator});

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





// class APIRegularHomeTabMemorialMain{

//   List<APIRegularHomeTabMemorialExtended> familyMemorialList;
//   List<APIRegularHomeTabMemorialExtended> friendsMemorialList;

//   APIRegularHomeTabMemorialMain({this.familyMemorialList, this.friendsMemorialList});

//   factory APIRegularHomeTabMemorialMain.fromJson(Map<String, dynamic> parsedJson){
    
//     var familyList = parsedJson['family'] as List;
//     var friendsList = parsedJson['friends'] as List;
    
//     List<APIRegularHomeTabMemorialExtended> familyMemorials = familyList.map((e) => APIRegularHomeTabMemorialExtended.fromJson(e)).toList();
//     List<APIRegularHomeTabMemorialExtended> friendsMemorials = friendsList.map((e) => APIRegularHomeTabMemorialExtended.fromJson(e)).toList();

//     return APIRegularHomeTabMemorialMain(
//       familyMemorialList: familyMemorials,
//       friendsMemorialList: friendsMemorials,
//     );
//   }
// }


// class APIRegularHomeTabMemorialExtended{
//   int id;
//   APIRegularHomeTabMemorialExtendedPage page;

//   APIRegularHomeTabMemorialExtended({this.id, this.page});

//   factory APIRegularHomeTabMemorialExtended.fromJson(Map<String, dynamic> parsedJson){
//     return APIRegularHomeTabMemorialExtended(
//       id: parsedJson['id'],
//       page: APIRegularHomeTabMemorialExtendedPage.fromJson(parsedJson['page']),
//     );
//   }
// }

// class APIRegularHomeTabMemorialExtendedPage{
//   int id;
//   String name;
//   APIRegularHomeTabMemorialExtendedPageDetails details;
//   dynamic backgroundImage;
//   dynamic profileImage;
//   dynamic imagesOrVideos;
//   String relationship;
//   APIRegularHomeTabMemorialExtendedPageCreator pageCreator;

//   APIRegularHomeTabMemorialExtendedPage({this.id, this.name, this.details, this.backgroundImage, this.profileImage, this.imagesOrVideos, this.relationship, this.pageCreator});

//   factory APIRegularHomeTabMemorialExtendedPage.fromJson(Map<String, dynamic> parsedJson){
//     return APIRegularHomeTabMemorialExtendedPage(
//       id: parsedJson['id'],
//       name: parsedJson['name'],
//       details: APIRegularHomeTabMemorialExtendedPageDetails.fromJson(parsedJson['details']),
//       backgroundImage: parsedJson['backgroundImage'],
//       profileImage: parsedJson['profileImage'],
//       imagesOrVideos: parsedJson['imagesOrVideos'],
//       relationship: parsedJson['relationship'],
//       pageCreator: APIRegularHomeTabMemorialExtendedPageCreator.fromJson(parsedJson['page_creator']),
      
//     );
//   }
// }

// class APIRegularHomeTabMemorialExtendedPageDetails{
//   String description;
//   String birthPlace;
//   String dob;
//   String rip;
//   String cemetery;
//   String country;

//   APIRegularHomeTabMemorialExtendedPageDetails({this.description, this.birthPlace, this.dob, this.rip, this.cemetery, this.country});

//   factory APIRegularHomeTabMemorialExtendedPageDetails.fromJson(Map<String, dynamic> parsedJson){
//     return APIRegularHomeTabMemorialExtendedPageDetails(
//       description: parsedJson['description'],
//       birthPlace: parsedJson['birthplace'],
//       dob: parsedJson['dob'],
//       rip: parsedJson['rip'],
//       cemetery: parsedJson['cemetery'],
//       country: parsedJson['country'],
//     );
//   }
// }

// class APIRegularHomeTabMemorialExtendedPageCreator{
//   int id;
//   String firstName;
//   String lastName;
//   String phoneNumber;
//   String email;
//   String userName;
//   dynamic image;

//   APIRegularHomeTabMemorialExtendedPageCreator({this.id, this.firstName, this.lastName, this.phoneNumber, this.email, this.userName, this.image});

//   factory APIRegularHomeTabMemorialExtendedPageCreator.fromJson(Map<String, dynamic> parsedJson){
//     return APIRegularHomeTabMemorialExtendedPageCreator(
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