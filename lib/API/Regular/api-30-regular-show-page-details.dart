import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIRegularShowPageDetailsMain> apiRegularShowPageDetails(int memorialId) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  final http.Response response = await http.get('http://fbp.dev1.koda.ws/api/v1/pages/memorials/$memorialId',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    }
  );

  // print('The status code for regular page details is ${response.statusCode}');
  // print('The status body for regular page details is ${response.body}');

  if(response.statusCode == 200){
    var newValue = json.decode(response.body);
    return APIRegularShowPageDetailsMain.fromJson(newValue);
  }else{
    throw Exception('Failed to get the events');
  }
}


class APIRegularShowPageDetailsMain{

  APIRegularShowPageDetailsExtended memorial;

  APIRegularShowPageDetailsMain({this.memorial});

  factory APIRegularShowPageDetailsMain.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularShowPageDetailsMain(
      memorial: APIRegularShowPageDetailsExtended.fromJson(parsedJson['memorial']),
    );
  }
}


class APIRegularShowPageDetailsExtended{
  int id;
  String name;
  APIRegularShowPageDetailsExtendedDetails details;
  dynamic backgroundImage;
  dynamic profileImage;
  dynamic imagesOrVideos;
  String relationship;
  APIRegularShowPageDetailsExtendedPageCreator pageCreator;

  APIRegularShowPageDetailsExtended({this.id, this.name, this.details, this.backgroundImage, this.profileImage, this.imagesOrVideos, this.relationship, this.pageCreator});

  factory APIRegularShowPageDetailsExtended.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularShowPageDetailsExtended(
      id: parsedJson['id'],
      name: parsedJson['name'],
      details: APIRegularShowPageDetailsExtendedDetails.fromJson(parsedJson['details']),
      backgroundImage: parsedJson['backgroundImage'],
      profileImage: parsedJson['profileImage'],
      imagesOrVideos: parsedJson['imagesOrVideos'],
      relationship: parsedJson['relationship'],
      pageCreator: APIRegularShowPageDetailsExtendedPageCreator.fromJson(parsedJson['page_creator'])
    );
  }
}

class APIRegularShowPageDetailsExtendedDetails{
  String description;
  String cemetery;
  String dob;
  String rip;
  String state;
  String country;

  APIRegularShowPageDetailsExtendedDetails({this.description, this.cemetery, this.dob, this.rip, this.state, this.country});

  factory APIRegularShowPageDetailsExtendedDetails.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularShowPageDetailsExtendedDetails(
      description: parsedJson['description'],
      cemetery: parsedJson['cemetery'],
      dob: parsedJson['dob'],
      rip: parsedJson['rip'],
      state: parsedJson['state'],
      country: parsedJson['country'],
    );
  }
}

class APIRegularShowPageDetailsExtendedPageCreator{
  int id;
  String firstName;
  String lastName;
  String phoneNumber;
  String email;
  String userName;
  dynamic image;

  APIRegularShowPageDetailsExtendedPageCreator({this.id, this.firstName, this.lastName, this.phoneNumber, this.email, this.userName, this.image});

  factory APIRegularShowPageDetailsExtendedPageCreator.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularShowPageDetailsExtendedPageCreator(
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