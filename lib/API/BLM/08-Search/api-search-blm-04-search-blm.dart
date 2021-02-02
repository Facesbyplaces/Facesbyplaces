import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIBLMSearchMemorialMain> apiBLMSearchBLM({String keywords}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  final http.Response response = await http.get('http://fbp.dev1.koda.ws/api/v1/search/memorials?keywords=$keywords&page=blm',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    }
  );

  if(response.statusCode == 200){
    var newValue = json.decode(response.body);
    return APIBLMSearchMemorialMain.fromJson(newValue);
  }else{
    throw Exception('Failed to get the memorials.');
  }
}

class APIBLMSearchMemorialMain{
  int blmItemsRemaining;
  List<APIBLMSearchMemorialPage> blmMemorialList;

  APIBLMSearchMemorialMain({this.blmItemsRemaining, this.blmMemorialList});

  factory APIBLMSearchMemorialMain.fromJson(Map<String, dynamic> parsedJson){

    var memorialList = parsedJson['memorials'] as List;
    List<APIBLMSearchMemorialPage> newMemorialList = memorialList.map((e) => APIBLMSearchMemorialPage.fromJson(e)).toList();

    return APIBLMSearchMemorialMain(
      blmItemsRemaining: parsedJson['itemsremaining'],
      blmMemorialList: newMemorialList,
    );
  }
}

class APIBLMSearchMemorialPage{
  int searchMemorialId;
  APIBLMSearchMemorialExtended searchMemorialPage;

  APIBLMSearchMemorialPage({this.searchMemorialId, this.searchMemorialPage});

  factory APIBLMSearchMemorialPage.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMSearchMemorialPage(
      searchMemorialId: parsedJson['id'],
      searchMemorialPage: APIBLMSearchMemorialExtended.fromJson(parsedJson['page']),
    );
  }
}

class APIBLMSearchMemorialExtended{
  int searchMemorialId;
  String searchMemorialName;
  APIBLMSearchMemorialExtendedPageDetails searchMemorialDetails;
  dynamic searchMemorialBackgroundImage;
  dynamic searchMemorialProfileImage;
  List<dynamic> searchMemorialImagesOrVideos;
  String searchMemorialRelationship;
  APIBLMSearchMemorialExtendedPageCreator searchMemorialPageCreator;
  bool searchMemorialManage;
  bool searchMemorialFamOrFriends;
  bool searchMemorialFollower;
  String searchMemorialPageType;
  String searchMemorialPrivacy;

  APIBLMSearchMemorialExtended({this.searchMemorialId, this.searchMemorialName, this.searchMemorialDetails, this.searchMemorialBackgroundImage, this.searchMemorialProfileImage, this.searchMemorialImagesOrVideos, this.searchMemorialRelationship, this.searchMemorialPageCreator, this.searchMemorialManage, this.searchMemorialFamOrFriends, this.searchMemorialFollower, this.searchMemorialPageType, this.searchMemorialPrivacy});

  factory APIBLMSearchMemorialExtended.fromJson(Map<String, dynamic> parsedJson){
    List<dynamic> newList1;

    if(parsedJson['imagesOrVideos'] != null){
      var list = parsedJson['imagesOrVideos'];
      newList1 = List<dynamic>.from(list);
    }

    return APIBLMSearchMemorialExtended(
      searchMemorialId: parsedJson['id'],
      searchMemorialName: parsedJson['name'],
      searchMemorialDetails: APIBLMSearchMemorialExtendedPageDetails.fromJson(parsedJson['details']),
      searchMemorialBackgroundImage: parsedJson['backgroundImage'],
      searchMemorialProfileImage: parsedJson['profileImage'],
      searchMemorialImagesOrVideos: newList1,
      searchMemorialRelationship: parsedJson['relationship'],
      searchMemorialPageCreator: APIBLMSearchMemorialExtendedPageCreator.fromJson(parsedJson['page_creator']),
      searchMemorialManage: parsedJson['manage'],
      searchMemorialFamOrFriends: parsedJson['famOrFriends'],
      searchMemorialFollower: parsedJson['follower'],
      searchMemorialPageType: parsedJson['page_type'],
      searchMemorialPrivacy: parsedJson['privacy'],
    );
  }
}


class APIBLMSearchMemorialExtendedPageDetails{
  String searchMemorialPageDetailsDescription;
  String searchMemorialPageDetailsBirthPlace;
  String searchMemorialPageDetailsDob;
  String searchMemorialPageDetailsRip;
  String searchMemorialPageDetailsCemetery;
  String searchMemorialPageDetailsCountry;

  APIBLMSearchMemorialExtendedPageDetails({this.searchMemorialPageDetailsDescription, this.searchMemorialPageDetailsBirthPlace, this.searchMemorialPageDetailsDob, this.searchMemorialPageDetailsRip, this.searchMemorialPageDetailsCemetery, this.searchMemorialPageDetailsCountry});

  factory APIBLMSearchMemorialExtendedPageDetails.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMSearchMemorialExtendedPageDetails(
      searchMemorialPageDetailsDescription: parsedJson['description'],
      searchMemorialPageDetailsBirthPlace: parsedJson['birthplace'],
      searchMemorialPageDetailsDob: parsedJson['dob'],
      searchMemorialPageDetailsRip: parsedJson['rip'],
      searchMemorialPageDetailsCemetery: parsedJson['cemetery'],
      searchMemorialPageDetailsCountry: parsedJson['country'],
    );
  }
}

class APIBLMSearchMemorialExtendedPageCreator{
  int searchMemorialPageCreatorId;
  String searchMemorialPageCreatorFirstName;
  String searchMemorialPageCreatorLastName;
  String searchMemorialPageCreatorPhoneNumber;
  String searchMemorialPageCreatorEmail;
  String searchMemorialPageCreatorUserName;
  dynamic searchMemorialPageCreatorImage;

  APIBLMSearchMemorialExtendedPageCreator({this.searchMemorialPageCreatorId, this.searchMemorialPageCreatorFirstName, this.searchMemorialPageCreatorLastName, this.searchMemorialPageCreatorPhoneNumber, this.searchMemorialPageCreatorEmail, this.searchMemorialPageCreatorUserName, this.searchMemorialPageCreatorImage});

  factory APIBLMSearchMemorialExtendedPageCreator.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMSearchMemorialExtendedPageCreator(
      searchMemorialPageCreatorId: parsedJson['id'],
      searchMemorialPageCreatorFirstName: parsedJson['first_name'],
      searchMemorialPageCreatorLastName: parsedJson['last_name'],
      searchMemorialPageCreatorPhoneNumber: parsedJson['phone_number'],
      searchMemorialPageCreatorEmail: parsedJson['email'],
      searchMemorialPageCreatorUserName: parsedJson['username'],
      searchMemorialPageCreatorImage: parsedJson['image']
    );
  }
}
