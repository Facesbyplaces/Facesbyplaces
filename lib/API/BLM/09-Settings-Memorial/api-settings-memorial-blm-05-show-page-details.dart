import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIBLMShowPageDetailsMain> apiBLMShowPageDetails(int memorialId) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  final http.Response response = await http.get(
    'http://fbp.dev1.koda.ws/api/v1/pages/blm/$memorialId',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    }
  );

  if(response.statusCode == 200){
    var newValue = json.decode(response.body);
    return APIBLMShowPageDetailsMain.fromJson(newValue);
  }else{
    throw Exception('Failed to get the events');
  }
}

class APIBLMShowPageDetailsMain{

  APIBLMShowPageDetailsExtended memorial;

  APIBLMShowPageDetailsMain({this.memorial});

  factory APIBLMShowPageDetailsMain.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMShowPageDetailsMain(
      memorial: APIBLMShowPageDetailsExtended.fromJson(parsedJson['blm']),
    );
  }
}


class APIBLMShowPageDetailsExtended{
  int id;
  String name;
  APIBLMShowPageDetailsExtendedDetails details;
  dynamic backgroundImage;
  dynamic profileImage;
  dynamic imagesOrVideos;
  String relationship;
  APIBLMShowPageDetailsExtendedPageCreator pageCreator;

  APIBLMShowPageDetailsExtended({this.id, this.name, this.details, this.backgroundImage, this.profileImage, this.imagesOrVideos, this.relationship, this.pageCreator});

  factory APIBLMShowPageDetailsExtended.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMShowPageDetailsExtended(
      id: parsedJson['id'],
      name: parsedJson['name'],
      details: APIBLMShowPageDetailsExtendedDetails.fromJson(parsedJson['details']),
      backgroundImage: parsedJson['backgroundImage'],
      profileImage: parsedJson['profileImage'],
      imagesOrVideos: parsedJson['imagesOrVideos'],
      relationship: parsedJson['relationship'],
      pageCreator: APIBLMShowPageDetailsExtendedPageCreator.fromJson(parsedJson['page_creator'])
    );
  }
}


class APIBLMShowPageDetailsExtendedDetails{
  String description;
  String location;
  String precinct;
  String dob;
  String rip;
  String state;
  String country;

  APIBLMShowPageDetailsExtendedDetails({this.description, this.location, this.precinct, this.dob, this.rip, this.state, this.country});

  factory APIBLMShowPageDetailsExtendedDetails.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMShowPageDetailsExtendedDetails(
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

class APIBLMShowPageDetailsExtendedPageCreator{
  int id;
  String firstName;
  String lastName;
  String phoneNumber;
  String email;
  String userName;
  dynamic image;

  APIBLMShowPageDetailsExtendedPageCreator({this.id, this.firstName, this.lastName, this.phoneNumber, this.email, this.userName, this.image});

  factory APIBLMShowPageDetailsExtendedPageCreator.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMShowPageDetailsExtendedPageCreator(
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