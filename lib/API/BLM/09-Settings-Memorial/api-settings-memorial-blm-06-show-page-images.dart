import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIBLMShowPageImagesMain> apiBLMShowPageImages({int memorialId}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  final http.Response response = await http.get(
    'http://fbp.dev1.koda.ws/api/v1/pages/blm/$memorialId/editImages',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    }
  );

  if(response.statusCode == 200){
    var newValue = json.decode(response.body);
    return APIBLMShowPageImagesMain.fromJson(newValue);
  }else{
    throw Exception('Failed to get the events');
  }
}

class APIBLMShowPageImagesMain{

  APIBLMShowPageImagesExtended memorial;

  APIBLMShowPageImagesMain({this.memorial});

  factory APIBLMShowPageImagesMain.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMShowPageImagesMain(
      memorial: APIBLMShowPageImagesExtended.fromJson(parsedJson['blm']),
    );
  }
}


class APIBLMShowPageImagesExtended{
  int id;
  String name;
  APIBLMShowPageImagesExtendedDetails details;
  dynamic backgroundImage;
  dynamic profileImage;
  dynamic imagesOrVideos;
  String relationship;
  APIBLMShowPageImagesExtendedPageCreator pageCreator;

  APIBLMShowPageImagesExtended({this.id, this.name, this.details, this.backgroundImage, this.profileImage, this.imagesOrVideos, this.relationship, this.pageCreator});

  factory APIBLMShowPageImagesExtended.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMShowPageImagesExtended(
      id: parsedJson['id'],
      name: parsedJson['name'],
      details: APIBLMShowPageImagesExtendedDetails.fromJson(parsedJson['details']),
      backgroundImage: parsedJson['backgroundImage'],
      profileImage: parsedJson['profileImage'],
      imagesOrVideos: parsedJson['imagesOrVideos'],
      relationship: parsedJson['relationship'],
      pageCreator: APIBLMShowPageImagesExtendedPageCreator.fromJson(parsedJson['page_creator'])
    );
  }
}


class APIBLMShowPageImagesExtendedDetails{
  String description;
  String location;
  String precinct;
  String dob;
  String rip;
  String state;
  String country;

  APIBLMShowPageImagesExtendedDetails({this.description, this.location, this.precinct, this.dob, this.rip, this.state, this.country});

  factory APIBLMShowPageImagesExtendedDetails.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMShowPageImagesExtendedDetails(
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

class APIBLMShowPageImagesExtendedPageCreator{
  int id;
  String firstName;
  String lastName;
  String phoneNumber;
  String email;
  String userName;
  dynamic image;

  APIBLMShowPageImagesExtendedPageCreator({this.id, this.firstName, this.lastName, this.phoneNumber, this.email, this.userName, this.image});

  factory APIBLMShowPageImagesExtendedPageCreator.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMShowPageImagesExtendedPageCreator(
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