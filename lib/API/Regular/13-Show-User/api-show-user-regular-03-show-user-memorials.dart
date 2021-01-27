import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIRegularShowUserMemorialsMain> apiRegularShowUserMemorials({int userId, int page}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  print('The access token is $getAccessToken');
  print('The uid is $getUID');
  print('The client is $getClient');

  final http.Response response = await http.get(
    // 'http://fbp.dev1.koda.ws/api/v1/users/memorials?user_id=$userId&page=$page',
    'http://fbp.dev1.koda.ws/api/v1/users/memorials?user_id=$userId&page=$page&account_type=2',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    }
  );

  print('The status of code of show memorials is ${response.statusCode}');
  // print('The status of headers of show memorials is ${response.headers}');
  print('The status of body of show memorials is ${response.body}');

  if(response.statusCode == 200){
    var newValue = json.decode(response.body);
    return APIRegularShowUserMemorialsMain.fromJson(newValue);
  }else{
    throw Exception('Failed to get the memorials');
  }
}



class APIRegularShowUserMemorialsMain{
  int ownedItemsRemaining;
  int followedItemsRemaining;
  List<APIRegularShowUserMemorialsExtended> owned;
  List<APIRegularShowUserMemorialsExtended> followed;

  APIRegularShowUserMemorialsMain({this.ownedItemsRemaining, this.followedItemsRemaining, this.owned, this.followed});

  factory APIRegularShowUserMemorialsMain.fromJson(Map<String, dynamic> parsedJson){

    var ownedList = parsedJson['owned'] as List;
    var followedList = parsedJson['followed'] as List;

    List<APIRegularShowUserMemorialsExtended> newOwnedList = ownedList.map((e) => APIRegularShowUserMemorialsExtended.fromJson(e)).toList();

    List<APIRegularShowUserMemorialsExtended> newFollowedList = followedList.map((e) => APIRegularShowUserMemorialsExtended.fromJson(e)).toList();

    return APIRegularShowUserMemorialsMain(
      ownedItemsRemaining: parsedJson['ownedItemsRemaining'],
      followedItemsRemaining: parsedJson['followedItemsRemaining'],
      owned: newOwnedList,
      followed: newFollowedList,
    );
  }
}

class APIRegularShowUserMemorialsExtended{

  APIRegularShowUserMemorialsExtendedPage page;

  APIRegularShowUserMemorialsExtended({this.page});

  factory APIRegularShowUserMemorialsExtended.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularShowUserMemorialsExtended(
      page: APIRegularShowUserMemorialsExtendedPage.fromJson(parsedJson['page']),
    );
  }
}

class APIRegularShowUserMemorialsExtendedPage{
  int pageId;
  String pageName;
  APIRegularShowUserMemorialsExtendedPageDetails pageDetails;
  dynamic pageBackgroundImage;
  dynamic pageProfileImage;
  dynamic pageImagesOrVideos;
  String pageRelationship;
  APIRegularShowUserMemorialsExtendedPageCreator pageCreator;
  bool pageManage;
  bool pageFamOrFriends;
  bool pageFollower;
  String pageType;
  String pagePrivacy;

  APIRegularShowUserMemorialsExtendedPage({this.pageId, this.pageName, this.pageDetails, this.pageBackgroundImage, this.pageProfileImage, this.pageImagesOrVideos, this.pageRelationship, this.pageCreator, this.pageManage, this.pageFamOrFriends, this.pageFollower, this.pageType, this.pagePrivacy});

  factory APIRegularShowUserMemorialsExtendedPage.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularShowUserMemorialsExtendedPage(
      pageId: parsedJson['id'],
      pageName: parsedJson['name'],
      pageDetails: APIRegularShowUserMemorialsExtendedPageDetails.fromJson(parsedJson['details']),
      pageBackgroundImage: parsedJson['backgroundImage'],
      pageProfileImage: parsedJson['profileImage'],
      pageImagesOrVideos: parsedJson['imagesOrVideos'],
      pageRelationship: parsedJson['relationship'],
      pageCreator: APIRegularShowUserMemorialsExtendedPageCreator.fromJson(parsedJson['page_creator']),
      pageManage: parsedJson['manage'],
      pageFamOrFriends: parsedJson['famOrFriends'],
      pageFollower: parsedJson['follower'],
      pageType: parsedJson['page_type'],
      pagePrivacy: parsedJson['privacy'],
    );
  }
}

class APIRegularShowUserMemorialsExtendedPageDetails{
  String description;
  String dob;
  String rip;

  APIRegularShowUserMemorialsExtendedPageDetails({this.description, this.dob, this.rip,});
  
  factory APIRegularShowUserMemorialsExtendedPageDetails.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularShowUserMemorialsExtendedPageDetails(
      description: parsedJson['description'],
      dob: parsedJson['dob'],
      rip: parsedJson['rip'],
    );
  }
}

class APIRegularShowUserMemorialsExtendedPageCreator{
  int id;
  String firstName;
  String lastName;
  String phoneNumber;
  String email;
  String userName;
  dynamic image;

  APIRegularShowUserMemorialsExtendedPageCreator({this.id, this.firstName, this.lastName, this.phoneNumber, this.email, this.userName, this.image});

  factory APIRegularShowUserMemorialsExtendedPageCreator.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularShowUserMemorialsExtendedPageCreator(
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