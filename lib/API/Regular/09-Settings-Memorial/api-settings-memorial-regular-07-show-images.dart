import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIRegularShowPageImagesMain> apiRegularShowPageImages(int memorialId) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  final http.Response response = await http.get('http://fbp.dev1.koda.ws/api/v1/pages/memorials/$memorialId/editImages',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    }
  );

  print('The status code for show images is ${response.statusCode}');
  // print('The status body for show images is ${response.body}');

  if(response.statusCode == 200){
    var newValue = json.decode(response.body);
    return APIRegularShowPageImagesMain.fromJson(newValue);
  }else{
    throw Exception('Failed to get the images');
  }
}

class APIRegularShowPageImagesMain{

  APIRegularShowPageImagesExtended memorial;

  APIRegularShowPageImagesMain({this.memorial});

  factory APIRegularShowPageImagesMain.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularShowPageImagesMain(
      memorial: APIRegularShowPageImagesExtended.fromJson(parsedJson['memorial']),
    );
  }
}


class APIRegularShowPageImagesExtended{
  int id;
  String name;
  APIRegularShowPageImagesExtendedDetails details;
  dynamic backgroundImage;
  dynamic profileImage;
  dynamic imagesOrVideos;
  String relationship;
  APIRegularShowPageImagesExtendedPageCreator pageCreator;

  APIRegularShowPageImagesExtended({this.id, this.name, this.details, this.backgroundImage, this.profileImage, this.imagesOrVideos, this.relationship, this.pageCreator});

  factory APIRegularShowPageImagesExtended.fromJson(Map<String, dynamic> parsedJson){
    List<dynamic> newList1;

    if(parsedJson['imagesOrVideos'] != null){
      var list = parsedJson['imagesOrVideos'];
      newList1 = List<dynamic>.from(list);
    }

    return APIRegularShowPageImagesExtended(
      id: parsedJson['id'],
      name: parsedJson['name'],
      details: APIRegularShowPageImagesExtendedDetails.fromJson(parsedJson['details']),
      backgroundImage: parsedJson['backgroundImage'],
      profileImage: parsedJson['profileImage'],
      // imagesOrVideos: parsedJson['imagesOrVideos'],
      imagesOrVideos: newList1,
      relationship: parsedJson['relationship'],
      pageCreator: APIRegularShowPageImagesExtendedPageCreator.fromJson(parsedJson['page_creator'])
    );
  }
}


class APIRegularShowPageImagesExtendedDetails{
  String description;
  String location;
  String precinct;
  String dob;
  String rip;
  String state;
  String country;

  APIRegularShowPageImagesExtendedDetails({this.description, this.location, this.precinct, this.dob, this.rip, this.state, this.country});

  factory APIRegularShowPageImagesExtendedDetails.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularShowPageImagesExtendedDetails(
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

class APIRegularShowPageImagesExtendedPageCreator{
  int id;
  String firstName;
  String lastName;
  String phoneNumber;
  String email;
  String userName;
  dynamic image;

  APIRegularShowPageImagesExtendedPageCreator({this.id, this.firstName, this.lastName, this.phoneNumber, this.email, this.userName, this.image});

  factory APIRegularShowPageImagesExtendedPageCreator.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularShowPageImagesExtendedPageCreator(
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