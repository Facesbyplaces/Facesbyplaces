import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<APIRegularHomeTabMemorialMain> apiRegularHomeMemorialsTab({required int page}) async{
  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  Dio dioRequest = Dio();

  var response = await dioRequest.get('https://facesbyplaces.com/api/v1/mainpages/memorials?page=$page',
    options: Options(
      followRedirects: false,
      validateStatus: (status){
        return status! < 600;
      },
      headers: <String, dynamic>{
        'access-token': getAccessToken,
        'uid': getUID,
        'client': getClient,
      }
    ),
  );

  if(response.statusCode == 200){
    var newData = Map<String, dynamic>.from(response.data);
    return APIRegularHomeTabMemorialMain.fromJson(newData);
  }else{
    throw Exception('Error occurred in main page - memorials: ${response.statusMessage}');
  }
}

class APIRegularHomeTabMemorialMain{
  APIRegularHomeTabMemorialFamilyExtended almFamilyMemorialList;
  APIRegularHomeTabMemorialFriendsExtended almFriendsMemorialList;
  APIRegularHomeTabMemorialMain({required this.almFamilyMemorialList, required this.almFriendsMemorialList});

  factory APIRegularHomeTabMemorialMain.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularHomeTabMemorialMain(
      almFamilyMemorialList: APIRegularHomeTabMemorialFamilyExtended.fromJson(parsedJson['family']),
      almFriendsMemorialList: APIRegularHomeTabMemorialFriendsExtended.fromJson(parsedJson['friends']),
    );
  }
}

class APIRegularHomeTabMemorialFamilyExtended{
  int blmHomeTabMemorialFamilyItemsRemaining;
  int memorialHomeTabMemorialFamilyItemsRemaining;
  List<APIRegularHomeTabMemorialExtendedPage> blmHomeTabMemorialPage;
  List<APIRegularHomeTabMemorialExtendedPage> memorialHomeTabMemorialPage;
  APIRegularHomeTabMemorialFamilyExtended({required this.blmHomeTabMemorialPage, required this.memorialHomeTabMemorialPage, required this.blmHomeTabMemorialFamilyItemsRemaining, required this.memorialHomeTabMemorialFamilyItemsRemaining});

  factory APIRegularHomeTabMemorialFamilyExtended.fromJson(Map<String, dynamic> parsedJson){
    var blmList = parsedJson['blm'] as List;
    var memorialList = parsedJson['memorial'] as List;

    List<APIRegularHomeTabMemorialExtendedPage>? newBLMList;
    List<APIRegularHomeTabMemorialExtendedPage>? newMemorialList;

    if(blmList.isNotEmpty == true){
       newBLMList = blmList.map((e) => APIRegularHomeTabMemorialExtendedPage.fromJson(e)).toList();
    }else{
      newBLMList = [];
    }
    
    if(memorialList.isNotEmpty == true){
      newMemorialList = memorialList.map((e) => APIRegularHomeTabMemorialExtendedPage.fromJson(e)).toList();
    }else{
      newMemorialList = [];
    }

    return APIRegularHomeTabMemorialFamilyExtended(
      blmHomeTabMemorialPage: newBLMList,
      memorialHomeTabMemorialPage: newMemorialList,
      blmHomeTabMemorialFamilyItemsRemaining: parsedJson['blmFamilyItemsRemaining'],
      memorialHomeTabMemorialFamilyItemsRemaining: parsedJson['memorialFamilyItemsRemaining'],
    );
  }
}

class APIRegularHomeTabMemorialFriendsExtended{
  int blmHomeTabMemorialFriendsItemsRemaining;
  int memorialHomeTabMemorialFriendsItemsRemaining;
  List<APIRegularHomeTabMemorialExtendedPage> blmHomeTabMemorialPage;
  List<APIRegularHomeTabMemorialExtendedPage> memorialHomeTabMemorialPage;
  APIRegularHomeTabMemorialFriendsExtended({required this.blmHomeTabMemorialPage, required this.memorialHomeTabMemorialPage, required this.blmHomeTabMemorialFriendsItemsRemaining, required this.memorialHomeTabMemorialFriendsItemsRemaining});

  factory APIRegularHomeTabMemorialFriendsExtended.fromJson(Map<String, dynamic> parsedJson){
    var blmList = parsedJson['blm'] as List;
    var memorialList = parsedJson['memorial'] as List;

    List<APIRegularHomeTabMemorialExtendedPage>? newBLMList;
    List<APIRegularHomeTabMemorialExtendedPage>? newMemorialList;

    if(blmList.isNotEmpty == true){
       newBLMList = blmList.map((e) => APIRegularHomeTabMemorialExtendedPage.fromJson(e)).toList();
    }else{
      newBLMList = [];
    }
    
    if(memorialList.isNotEmpty == true){
      newMemorialList = memorialList.map((e) => APIRegularHomeTabMemorialExtendedPage.fromJson(e)).toList();
    }else{
      newMemorialList = [];
    }

    return APIRegularHomeTabMemorialFriendsExtended(
      blmHomeTabMemorialPage: newBLMList,
      memorialHomeTabMemorialPage: newMemorialList,
      blmHomeTabMemorialFriendsItemsRemaining: parsedJson['blmFriendsItemsRemaining'],
      memorialHomeTabMemorialFriendsItemsRemaining: parsedJson['memorialFriendsItemsRemaining']
    );
  }
}

class APIRegularHomeTabMemorialExtendedPage{
  int blmHomeTabMemorialPageId;
  String blmHomeTabMemorialPageName;
  APIRegularHomeTabMemorialExtendedPageDetails blmHomeTabMemorialPageDetails;
  String blmHomeTabMemorialPageProfileImage;
  String blmHomeTabMemorialPageRelationship;
  bool blmHomeTabMemorialPageManage;
  bool blmHomeTabMemorialPageFamOrFriends;
  bool blmHomeTabMemorialPageFollower;
  String blmHomeTabMemorialPagePageType;
  APIRegularHomeTabMemorialExtendedPage({required this.blmHomeTabMemorialPageId, required this.blmHomeTabMemorialPageName, required this.blmHomeTabMemorialPageDetails, required this.blmHomeTabMemorialPageProfileImage, required this.blmHomeTabMemorialPageRelationship, required this.blmHomeTabMemorialPageManage, required this.blmHomeTabMemorialPageFamOrFriends, required this.blmHomeTabMemorialPageFollower, required this.blmHomeTabMemorialPagePageType});

  factory APIRegularHomeTabMemorialExtendedPage.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularHomeTabMemorialExtendedPage(
      blmHomeTabMemorialPageId: parsedJson['id'],
      blmHomeTabMemorialPageName: parsedJson['name'] ?? '',
      blmHomeTabMemorialPageDetails: APIRegularHomeTabMemorialExtendedPageDetails.fromJson(parsedJson['details']),
      blmHomeTabMemorialPageProfileImage: parsedJson['profileImage'] ?? '',
      blmHomeTabMemorialPageRelationship: parsedJson['relationship'] ?? '',
      blmHomeTabMemorialPageManage: parsedJson['manage'],
      blmHomeTabMemorialPageFamOrFriends: parsedJson['famOrFriends'],
      blmHomeTabMemorialPageFollower: parsedJson['follower'],
      blmHomeTabMemorialPagePageType: parsedJson['page_type'] ?? '',
    );
  }
}

class APIRegularHomeTabMemorialExtendedPageDetails{
  String blmHomeTabMemorialPageDetailsDescription;
  APIRegularHomeTabMemorialExtendedPageDetails({required this.blmHomeTabMemorialPageDetailsDescription});

  factory APIRegularHomeTabMemorialExtendedPageDetails.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularHomeTabMemorialExtendedPageDetails(
      blmHomeTabMemorialPageDetailsDescription: parsedJson['description'] ?? '',
    );
  }
}