import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIBLMShowUserMemorialsMain> apiBLMShowUserMemorials({int userId, int page}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  final http.Response response = await http.get('http://fbp.dev1.koda.ws/api/v1/users/memorials?user_id=$userId&page=$page&account_type=1',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    }
  );

  if(response.statusCode == 200){
    var newValue = json.decode(response.body);
    return APIBLMShowUserMemorialsMain.fromJson(newValue);
  }else{
    throw Exception('Failed to get the memorials');
  }
}









class APIBLMShowUserMemorialsMain{
  int ownedItemsRemaining;
  int followedItemsRemaining;
  List<APIBLMShowUserMemorialsExtended> owned;
  List<APIBLMShowUserMemorialsExtended> followed;

  APIBLMShowUserMemorialsMain({this.ownedItemsRemaining, this.followedItemsRemaining, this.owned, this.followed});

  factory APIBLMShowUserMemorialsMain.fromJson(Map<String, dynamic> parsedJson){

    var ownedList = parsedJson['owned'] as List;
    var followedList = parsedJson['followed'] as List;

    List<APIBLMShowUserMemorialsExtended> newOwnedList = ownedList.map((e) => APIBLMShowUserMemorialsExtended.fromJson(e)).toList();

    List<APIBLMShowUserMemorialsExtended> newFollowedList = followedList.map((e) => APIBLMShowUserMemorialsExtended.fromJson(e)).toList();

    return APIBLMShowUserMemorialsMain(
      ownedItemsRemaining: parsedJson['ownedItemsRemaining'],
      followedItemsRemaining: parsedJson['followedItemsRemaining'],
      owned: newOwnedList,
      followed: newFollowedList,
    );
  }
}

class APIBLMShowUserMemorialsExtended{

  APIBLMShowUserMemorialsExtendedPage page;

  APIBLMShowUserMemorialsExtended({this.page});

  factory APIBLMShowUserMemorialsExtended.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMShowUserMemorialsExtended(
      page: APIBLMShowUserMemorialsExtendedPage.fromJson(parsedJson['page']),
    );
  }
}

class APIBLMShowUserMemorialsExtendedPage{
  int pageId;
  String pageName;
  APIBLMShowUserMemorialsExtendedPageDetails pageDetails;
  dynamic pageBackgroundImage;
  dynamic pageProfileImage;
  dynamic pageImagesOrVideos;
  String pageRelationship;
  APIBLMShowUserMemorialsExtendedPageCreator pageCreator;
  bool pageManage;
  bool pageFamOrFriends;
  bool pageFollower;
  String pageType;
  String pagePrivacy;

  APIBLMShowUserMemorialsExtendedPage({this.pageId, this.pageName, this.pageDetails, this.pageBackgroundImage, this.pageProfileImage, this.pageImagesOrVideos, this.pageRelationship, this.pageCreator, this.pageManage, this.pageFamOrFriends, this.pageFollower, this.pageType, this.pagePrivacy});

  factory APIBLMShowUserMemorialsExtendedPage.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMShowUserMemorialsExtendedPage(
      pageId: parsedJson['id'],
      pageName: parsedJson['name'],
      pageDetails: APIBLMShowUserMemorialsExtendedPageDetails.fromJson(parsedJson['details']),
      pageBackgroundImage: parsedJson['backgroundImage'],
      pageProfileImage: parsedJson['profileImage'],
      pageImagesOrVideos: parsedJson['imagesOrVideos'],
      pageRelationship: parsedJson['relationship'],
      pageCreator: APIBLMShowUserMemorialsExtendedPageCreator.fromJson(parsedJson['page_creator']),
      pageManage: parsedJson['manage'],
      pageFamOrFriends: parsedJson['famOrFriends'],
      pageFollower: parsedJson['follower'],
      pageType: parsedJson['page_type'],
      pagePrivacy: parsedJson['privacy'],
    );
  }
}

class APIBLMShowUserMemorialsExtendedPageDetails{
  String description;
  String dob;
  String rip;

  APIBLMShowUserMemorialsExtendedPageDetails({this.description, this.dob, this.rip,});
  
  factory APIBLMShowUserMemorialsExtendedPageDetails.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMShowUserMemorialsExtendedPageDetails(
      description: parsedJson['description'],
      dob: parsedJson['dob'],
      rip: parsedJson['rip'],
    );
  }
}

class APIBLMShowUserMemorialsExtendedPageCreator{
  int id;
  String firstName;
  String lastName;
  String phoneNumber;
  String email;
  String userName;
  dynamic image;

  APIBLMShowUserMemorialsExtendedPageCreator({this.id, this.firstName, this.lastName, this.phoneNumber, this.email, this.userName, this.image});

  factory APIBLMShowUserMemorialsExtendedPageCreator.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMShowUserMemorialsExtendedPageCreator(
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
