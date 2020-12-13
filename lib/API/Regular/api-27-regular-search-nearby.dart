import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIRegularSearchPostMain> apiRegularSearchNearby(int page, double latitude, double longitude) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  print('The longitude is $longitude');
  print('The latitude is $latitude');

  final http.Response response = await http.get(
    'http://fbp.dev1.koda.ws/api/v1/search/nearby?longitude=$longitude&latitude=$latitude&page=$page',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    }
  );

  print('The status of search nearby is ${response.statusCode}');
  print('The status of search nearby is ${response.body}');

  if(response.statusCode == 200){
    var newValue = json.decode(response.body);
    return APIRegularSearchPostMain.fromJson(newValue);
  }else{
    throw Exception('Failed to get the feed');
  }
}



class APIRegularSearchPostMain{
  int blmItemsRemaining;
  int memorialItemsRemaining;
  List<APIRegularSearchPostExtended> blmList;
  List<APIRegularSearchPostExtended> memorialList;

  APIRegularSearchPostMain({this.blmItemsRemaining, this.memorialItemsRemaining, this.blmList, this.memorialList});

  factory APIRegularSearchPostMain.fromJson(Map<String, dynamic> parsedJson){
    print('test!');

    var newList1 = parsedJson['blm'] as List;
    var newList2 = parsedJson['memorial'] as List;

    List<APIRegularSearchPostExtended> blmList = newList1.map((i) => APIRegularSearchPostExtended.fromJson(i)).toList();
    print('test test test');

    List<APIRegularSearchPostExtended> memorialList = newList2.map((e) => APIRegularSearchPostExtended.fromJson(e)).toList();

    print('new new new');

    return APIRegularSearchPostMain(
      blmItemsRemaining: parsedJson['blmItemsRemaining'],
      memorialItemsRemaining: parsedJson['memorialItemsRemaining'],
      blmList: blmList,
      memorialList: memorialList,
    );
  }
}


class APIRegularSearchPostExtended{
  int id;
  String name;
  APIRegularPostExtendedPageDetails details;
  dynamic backgroundImage;
  dynamic profileImage;
  dynamic imagesOrVideos;
  String relationship;
  APIRegularHomeTabPostExtendedPageCreator pageCreator;
  bool follower;

  APIRegularSearchPostExtended({this.id, this.name, this.details, this.backgroundImage, this.profileImage, this.imagesOrVideos, this.relationship, this.pageCreator, this.follower});

  factory APIRegularSearchPostExtended.fromJson(Map<String, dynamic> parsedJson){
    print('last!');

    return APIRegularSearchPostExtended(
      id: parsedJson['id'],
      name: parsedJson['name'],
      details: APIRegularPostExtendedPageDetails.fromJson(parsedJson['details']),
      backgroundImage: parsedJson['backgroundImage'],
      profileImage: parsedJson['profileImage'],
      imagesOrVideos: parsedJson['imagesOrVideos'],
      relationship: parsedJson['relationship'],
      pageCreator: APIRegularHomeTabPostExtendedPageCreator.fromJson(parsedJson['page_creator']),
      follower: parsedJson['follower'],
    );
  }
}

class APIRegularPostExtendedPageDetails{
  String description;
  String location;
  String precinct;
  String dob;
  String rip;
  String state;
  String country;

  APIRegularPostExtendedPageDetails({this.description, this.location, this.precinct, this.dob, this.rip, this.state, this.country});

  factory APIRegularPostExtendedPageDetails.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularPostExtendedPageDetails(
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

class APIRegularHomeTabPostExtendedPageCreator{
  int id;
  String firstName;
  String lastName;
  String phoneNumber;
  String email;
  String userName;
  dynamic image;

  APIRegularHomeTabPostExtendedPageCreator({this.id, this.firstName, this.lastName, this.phoneNumber, this.email, this.userName, this.image});

  factory APIRegularHomeTabPostExtendedPageCreator.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularHomeTabPostExtendedPageCreator(
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