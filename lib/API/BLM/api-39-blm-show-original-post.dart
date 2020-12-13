import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIBLMShowOriginalPostMainMain> apiBLMShowOriginalPost(int postId) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  print('The postId is $postId');

  final http.Response response = await http.get(
    'http://fbp.dev1.koda.ws/api/v1/posts/$postId',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    }
  );

  print('The status of show original post is ${response.statusCode}');
  // print('The status of show original post is ${response.body}');

  if(response.statusCode == 200){
    var newValue = json.decode(response.body);
    return APIBLMShowOriginalPostMainMain.fromJson(newValue);
  }else{
    throw Exception('Failed to get the post');
  }
}



class APIBLMShowOriginalPostMainMain{
  APIBLMShowOriginalPostMainExtended post;
  

  APIBLMShowOriginalPostMainMain({this.post});

  factory APIBLMShowOriginalPostMainMain.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMShowOriginalPostMainMain(
      post: APIBLMShowOriginalPostMainExtended.fromJson(parsedJson['post'])
    );
  }
}


class APIBLMShowOriginalPostMainExtended{
  int id;
  APIBLMShowOriginalPostMainExtendedPage page;
  String body;
  String location;
  double latitude;
  double longitude;
  List<dynamic> imagesOrVideos;
  String createAt;

  APIBLMShowOriginalPostMainExtended({this.id, this.page, this.body, this.location, this.latitude, this.longitude, this.imagesOrVideos, this.createAt});

  factory APIBLMShowOriginalPostMainExtended.fromJson(Map<String, dynamic> parsedJson){

    print('The memorial name is ${parsedJson['name']}');
    
    List<dynamic> newList;

    if(parsedJson['imagesOrVideos'] != null){
      var list = parsedJson['imagesOrVideos'];
      newList = List<dynamic>.from(list);
    }
    
    return APIBLMShowOriginalPostMainExtended(
      id: parsedJson['id'],
      page: APIBLMShowOriginalPostMainExtendedPage.fromJson(parsedJson['page']),
      body: parsedJson['body'],
      location: parsedJson['location'],
      latitude: parsedJson['latitude'],
      longitude: parsedJson['longitude'],
      imagesOrVideos: newList,
      createAt: parsedJson['created_at'],
    );
  }
}

class APIBLMShowOriginalPostMainExtendedPage{
  int id;
  String name;
  APIBLMShowOriginalPostMainExtendedPageDetails details;
  dynamic backgroundImage;
  dynamic profileImage;
  dynamic imagesOrVideos;
  String relationship;
  APIBLMShowOriginalPostMainExtendedPageCreator pageCreator;

  APIBLMShowOriginalPostMainExtendedPage({this.id, this.name, this.details, this.backgroundImage, this.profileImage, this.imagesOrVideos, this.relationship, this.pageCreator});

  factory APIBLMShowOriginalPostMainExtendedPage.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMShowOriginalPostMainExtendedPage(
      id: parsedJson['id'],
      name: parsedJson['name'],
      details: APIBLMShowOriginalPostMainExtendedPageDetails.fromJson(parsedJson['details']),
      backgroundImage: parsedJson['backgroundImage'],
      profileImage: parsedJson['profileImage'],
      imagesOrVideos: parsedJson['imagesOrVideos'],
      relationship: parsedJson['relationship'],
      pageCreator: APIBLMShowOriginalPostMainExtendedPageCreator.fromJson(parsedJson['page_creator']),
      
    );
  }
}

class APIBLMShowOriginalPostMainExtendedPageDetails{
  String description;
  String birthPlace;
  String dob;
  String rip;
  String cemetery;
  String country;

  APIBLMShowOriginalPostMainExtendedPageDetails({this.description, this.birthPlace, this.dob, this.rip, this.cemetery, this.country});

  factory APIBLMShowOriginalPostMainExtendedPageDetails.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMShowOriginalPostMainExtendedPageDetails(
      description: parsedJson['description'],
      birthPlace: parsedJson['birthplace'],
      dob: parsedJson['dob'],
      rip: parsedJson['rip'],
      cemetery: parsedJson['cemetery'],
      country: parsedJson['country'],
    );
  }
}

class APIBLMShowOriginalPostMainExtendedPageCreator{
  int id;
  String firstName;
  String lastName;
  String phoneNumber;
  String email;
  String userName;
  dynamic image;

  APIBLMShowOriginalPostMainExtendedPageCreator({this.id, this.firstName, this.lastName, this.phoneNumber, this.email, this.userName, this.image});

  factory APIBLMShowOriginalPostMainExtendedPageCreator.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMShowOriginalPostMainExtendedPageCreator(
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
