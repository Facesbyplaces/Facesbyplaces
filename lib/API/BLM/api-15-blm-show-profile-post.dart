import 'package:async/async.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIBLMHomeProfilePostMain> apiBLMProfilePost(int memorialId, int page) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  // int memorialId = sharedPrefs.getInt('blm-user-memorial-id') ?? 0;
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  print('The memorial id $memorialId');

  AsyncMemoizer memoizer = AsyncMemoizer();

  var value = await memoizer.runOnce(() async{
    final http.Response response = await http.get(
      'http://fbp.dev1.koda.ws/api/v1/posts/page/Blm/$memorialId?page=$page',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'access-token': getAccessToken,
        'uid': getUID,
        'client': getClient,
      }
    );

    print('The show profile post is ${response.statusCode}');
    print('The show profile body is ${response.body}');

    if(response.statusCode == 200){
      var newValue = json.decode(response.body);
      return APIBLMHomeProfilePostMain.fromJson(newValue);
    }else{
      throw Exception('Failed to get the post');
    }
  });

  return value;

}


class APIBLMHomeProfilePostMain{
  int itemsRemaining;
  List<APIBLMHomeProfilePostExtended> familyMemorialList;

  APIBLMHomeProfilePostMain({this.itemsRemaining, this.familyMemorialList});

  factory APIBLMHomeProfilePostMain.fromJson(Map<String, dynamic> parsedJson){
    var newList = parsedJson['posts'] as List;
    List<APIBLMHomeProfilePostExtended> familyMemorials = newList.map((i) => APIBLMHomeProfilePostExtended.fromJson(i)).toList();

    return APIBLMHomeProfilePostMain(
      itemsRemaining: parsedJson['itemsremaining'],
      familyMemorialList: familyMemorials,
    );
  }
}


class APIBLMHomeProfilePostExtended{
  int id;
  APIBLMHomeProfilePostExtendedPage page;
  String body;
  String location;
  double latitude;
  double longitude;
  List<dynamic> imagesOrVideos;
  String createAt;

  APIBLMHomeProfilePostExtended({this.id, this.page, this.body, this.location, this.latitude, this.longitude, this.imagesOrVideos, this.createAt});

  factory APIBLMHomeProfilePostExtended.fromJson(Map<String, dynamic> parsedJson){
    
    List<dynamic> newList;

    if(parsedJson['imagesOrVideos'] != null){
      var list = parsedJson['imagesOrVideos'];
      newList = List<dynamic>.from(list);
    }
    
    return APIBLMHomeProfilePostExtended(
      id: parsedJson['id'],
      page: APIBLMHomeProfilePostExtendedPage.fromJson(parsedJson['page']),
      body: parsedJson['body'],
      location: parsedJson['location'],
      latitude: parsedJson['latitude'],
      longitude: parsedJson['longitude'],
      imagesOrVideos: newList,
      createAt: parsedJson['created_at'],
    );
  }
}

class APIBLMHomeProfilePostExtendedPage{
  int id;
  String name;
  APIBLMHomeProfilePostExtendedPageDetails details;
  dynamic backgroundImage;
  dynamic profileImage;
  dynamic imagesOrVideos;
  String relationship;
  APIBLMHomeProfilePostExtendedPageCreator pageCreator;

  APIBLMHomeProfilePostExtendedPage({this.id, this.name, this.details, this.backgroundImage, this.profileImage, this.imagesOrVideos, this.relationship, this.pageCreator});

  factory APIBLMHomeProfilePostExtendedPage.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMHomeProfilePostExtendedPage(
      id: parsedJson['id'],
      name: parsedJson['name'],
      details: APIBLMHomeProfilePostExtendedPageDetails.fromJson(parsedJson['details']),
      backgroundImage: parsedJson['backgroundImage'],
      profileImage: parsedJson['profileImage'],
      imagesOrVideos: parsedJson['imagesOrVideos'],
      relationship: parsedJson['relationship'],
      pageCreator: APIBLMHomeProfilePostExtendedPageCreator.fromJson(parsedJson['page_creator']),
      
    );
  }
}

class APIBLMHomeProfilePostExtendedPageDetails{
  String description;
  String birthPlace;
  String dob;
  String rip;
  String cemetery;
  String country;

  APIBLMHomeProfilePostExtendedPageDetails({this.description, this.birthPlace, this.dob, this.rip, this.cemetery, this.country});

  factory APIBLMHomeProfilePostExtendedPageDetails.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMHomeProfilePostExtendedPageDetails(
      description: parsedJson['description'],
      birthPlace: parsedJson['birthplace'],
      dob: parsedJson['dob'],
      rip: parsedJson['rip'],
      cemetery: parsedJson['cemetery'],
      country: parsedJson['country'],
    );
  }
}

class APIBLMHomeProfilePostExtendedPageCreator{
  int id;
  String firstName;
  String lastName;
  String phoneNumber;
  String email;
  String userName;
  dynamic image;

  APIBLMHomeProfilePostExtendedPageCreator({this.id, this.firstName, this.lastName, this.phoneNumber, this.email, this.userName, this.image});

  factory APIBLMHomeProfilePostExtendedPageCreator.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMHomeProfilePostExtendedPageCreator(
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