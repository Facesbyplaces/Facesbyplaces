import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIBLMSearchPostMain> apiBLMSearchNearby(int page, double latitude, double longitude) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

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
    return APIBLMSearchPostMain.fromJson(newValue);
  }else{
    throw Exception('Failed to get the feed');
  }
}



class APIBLMSearchPostMain{
  int blmItemsRemaining;
  int memorialItemsRemaining;
  List<APIBLMSearchPostExtended> blmList;
  List<APIBLMSearchPostExtended> memorialList;

  APIBLMSearchPostMain({this.blmItemsRemaining, this.memorialItemsRemaining, this.blmList, this.memorialList});

  factory APIBLMSearchPostMain.fromJson(Map<String, dynamic> parsedJson){
    print('test!');

    var newList1 = parsedJson['blm'] as List;
    var newList2 = parsedJson['memorial'] as List;

    List<APIBLMSearchPostExtended> blmList = newList1.map((i) => APIBLMSearchPostExtended.fromJson(i)).toList();
    print('test test test');

    List<APIBLMSearchPostExtended> memorialList = newList2.map((e) => APIBLMSearchPostExtended.fromJson(e)).toList();

    print('new new new');

    return APIBLMSearchPostMain(
      blmItemsRemaining: parsedJson['blmItemsRemaining'],
      memorialItemsRemaining: parsedJson['memorialItemsRemaining'],
      blmList: blmList,
      memorialList: memorialList,
    );
  }
}


class APIBLMSearchPostExtended{
  int id;
  String name;
  APIBLMPostExtendedPageDetails details;
  dynamic backgroundImage;
  dynamic profileImage;
  dynamic imagesOrVideos;
  String relationship;
  APIBLMHomeTabPostExtendedPageCreator pageCreator;
  bool follower;

  APIBLMSearchPostExtended({this.id, this.name, this.details, this.backgroundImage, this.profileImage, this.imagesOrVideos, this.relationship, this.pageCreator, this.follower});

  factory APIBLMSearchPostExtended.fromJson(Map<String, dynamic> parsedJson){
    print('last!');

    return APIBLMSearchPostExtended(
      id: parsedJson['id'],
      name: parsedJson['name'],
      details: APIBLMPostExtendedPageDetails.fromJson(parsedJson['details']),
      backgroundImage: parsedJson['backgroundImage'],
      profileImage: parsedJson['profileImage'],
      imagesOrVideos: parsedJson['imagesOrVideos'],
      relationship: parsedJson['relationship'],
      pageCreator: APIBLMHomeTabPostExtendedPageCreator.fromJson(parsedJson['page_creator']),
      follower: parsedJson['follower'],
    );
  }
}

class APIBLMPostExtendedPageDetails{
  String description;
  String location;
  String precinct;
  String dob;
  String rip;
  String state;
  String country;

  APIBLMPostExtendedPageDetails({this.description, this.location, this.precinct, this.dob, this.rip, this.state, this.country});

  factory APIBLMPostExtendedPageDetails.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMPostExtendedPageDetails(
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

class APIBLMHomeTabPostExtendedPageCreator{
  int id;
  String firstName;
  String lastName;
  String phoneNumber;
  String email;
  String userName;
  dynamic image;

  APIBLMHomeTabPostExtendedPageCreator({this.id, this.firstName, this.lastName, this.phoneNumber, this.email, this.userName, this.image});

  factory APIBLMHomeTabPostExtendedPageCreator.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMHomeTabPostExtendedPageCreator(
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