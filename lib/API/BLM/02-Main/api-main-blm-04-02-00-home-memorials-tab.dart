import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<APIBLMHomeTabMemorialMain> apiBLMHomeMemorialsTab({required int page}) async{
  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  Dio dioRequest = Dio();

  var response = await dioRequest.get('http://facesbyplaces.com/api/v1/mainpages/memorials?page=$page',
    options: Options(
      followRedirects: false,
      validateStatus: (status){
        return status! < 600;
      },
      headers: <String, dynamic>{
        'Content-Type': 'application/json',
        'access-token': getAccessToken,
        'uid': getUID,
        'client': getClient,
      }
    ),  
  );

  print('The status code of blm home memorials tab is ${response.statusCode}');

  if(response.statusCode == 200){
    var newData = Map<String, dynamic>.from(response.data);
    return APIBLMHomeTabMemorialMain.fromJson(newData);
  }else{
    throw Exception('Failed to get the memorials');
  }
}

class APIBLMHomeTabMemorialMain{
  APIBLMHomeTabMemorialFamilyExtended blmFamilyMemorialList;
  APIBLMHomeTabMemorialFriendsExtended blmFriendsMemorialList;
  APIBLMHomeTabMemorialMain({required this.blmFamilyMemorialList, required this.blmFriendsMemorialList});

  factory APIBLMHomeTabMemorialMain.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMHomeTabMemorialMain(
      blmFamilyMemorialList: APIBLMHomeTabMemorialFamilyExtended.fromJson(parsedJson['family']),
      blmFriendsMemorialList: APIBLMHomeTabMemorialFriendsExtended.fromJson(parsedJson['friends']),
    );
  }
}

class APIBLMHomeTabMemorialFamilyExtended{
  int blmHomeTabMemorialFamilyItemsRemaining;
  int memorialHomeTabMemorialFamilyItemsRemaining;
  List<APIBLMHomeTabMemorialExtendedPage> blmHomeTabMemorialPage;
  List<APIBLMHomeTabMemorialExtendedPage> memorialHomeTabMemorialPage;
  APIBLMHomeTabMemorialFamilyExtended({required this.blmHomeTabMemorialPage, required this.memorialHomeTabMemorialPage, required this.blmHomeTabMemorialFamilyItemsRemaining, required this.memorialHomeTabMemorialFamilyItemsRemaining,});

  factory APIBLMHomeTabMemorialFamilyExtended.fromJson(Map<String, dynamic> parsedJson){
    var blmList = parsedJson['blm'] as List;
    var memorialList = parsedJson['memorial'] as List;

    List<APIBLMHomeTabMemorialExtendedPage>? newBLMList;
    List<APIBLMHomeTabMemorialExtendedPage>? newMemorialList;

    if(blmList.isNotEmpty == true){
       newBLMList = blmList.map((e) => APIBLMHomeTabMemorialExtendedPage.fromJson(e)).toList();
    }else{
      newBLMList = [];
    }
    
    if(memorialList.isNotEmpty == true){
      newMemorialList = memorialList.map((e) => APIBLMHomeTabMemorialExtendedPage.fromJson(e)).toList();
    }else{
      newMemorialList = [];
    }

    return APIBLMHomeTabMemorialFamilyExtended(
      blmHomeTabMemorialPage: newBLMList,
      memorialHomeTabMemorialPage: newMemorialList,
      blmHomeTabMemorialFamilyItemsRemaining: parsedJson['blmFamilyItemsRemaining'],
      memorialHomeTabMemorialFamilyItemsRemaining: parsedJson['memorialFamilyItemsRemaining'],
    );
  }
}

class APIBLMHomeTabMemorialFriendsExtended{
  int blmHomeTabMemorialFriendsItemsRemaining;
  int memorialHomeTabMemorialFriendsItemsRemaining;
  List<APIBLMHomeTabMemorialExtendedPage> blmHomeTabMemorialPage;
  List<APIBLMHomeTabMemorialExtendedPage> memorialHomeTabMemorialPage;
  APIBLMHomeTabMemorialFriendsExtended({required this.blmHomeTabMemorialPage, required this.memorialHomeTabMemorialPage, required this.blmHomeTabMemorialFriendsItemsRemaining, required this.memorialHomeTabMemorialFriendsItemsRemaining,});

  factory APIBLMHomeTabMemorialFriendsExtended.fromJson(Map<String, dynamic> parsedJson){
    var blmList = parsedJson['blm'] as List;
    var memorialList = parsedJson['memorial'] as List;

    List<APIBLMHomeTabMemorialExtendedPage>? newBLMList;
    List<APIBLMHomeTabMemorialExtendedPage>? newMemorialList;

    if(blmList.isNotEmpty == true){
       newBLMList = blmList.map((e) => APIBLMHomeTabMemorialExtendedPage.fromJson(e)).toList();
    }else{
      newBLMList = [];
    }
    
    if(memorialList.isNotEmpty == true){
      newMemorialList = memorialList.map((e) => APIBLMHomeTabMemorialExtendedPage.fromJson(e)).toList();
    }else{
      newMemorialList = [];
    }

    return APIBLMHomeTabMemorialFriendsExtended(
      blmHomeTabMemorialPage: newBLMList,
      memorialHomeTabMemorialPage: newMemorialList,
      blmHomeTabMemorialFriendsItemsRemaining: parsedJson['blmFriendsItemsRemaining'],
      memorialHomeTabMemorialFriendsItemsRemaining: parsedJson['memorialFriendsItemsRemaining']
    );
  }
}

class APIBLMHomeTabMemorialExtendedPage{
  int blmHomeTabMemorialPageId;
  String blmHomeTabMemorialPageName;
  APIBLMHomeTabMemorialExtendedPageDetails blmHomeTabMemorialPageDetails;
  String blmHomeTabMemorialPageProfileImage;
  String blmHomeTabMemorialPageRelationship;
  bool blmHomeTabMemorialPageManage;
  bool blmHomeTabMemorialPageFamOrFriends;
  bool blmHomeTabMemorialPageFollower;
  String blmHomeTabMemorialPagePageType;
  APIBLMHomeTabMemorialExtendedPage({required this.blmHomeTabMemorialPageId, required this.blmHomeTabMemorialPageName, required this.blmHomeTabMemorialPageDetails, required this.blmHomeTabMemorialPageProfileImage, required this.blmHomeTabMemorialPageRelationship, required this.blmHomeTabMemorialPageManage, required this.blmHomeTabMemorialPageFamOrFriends, required this.blmHomeTabMemorialPageFollower, required this.blmHomeTabMemorialPagePageType});

  factory APIBLMHomeTabMemorialExtendedPage.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMHomeTabMemorialExtendedPage(
      blmHomeTabMemorialPageId: parsedJson['id'],
      blmHomeTabMemorialPageName: parsedJson['name'] != null ? parsedJson['name'] : '',
      blmHomeTabMemorialPageDetails: APIBLMHomeTabMemorialExtendedPageDetails.fromJson(parsedJson['details']),
      blmHomeTabMemorialPageProfileImage: parsedJson['profileImage'] != null ? parsedJson['profileImage'] : '',
      blmHomeTabMemorialPageRelationship: parsedJson['relationship'] != null ? parsedJson['relationship'] : '',
      blmHomeTabMemorialPageManage: parsedJson['manage'],
      blmHomeTabMemorialPageFamOrFriends: parsedJson['famOrFriends'],
      blmHomeTabMemorialPageFollower: parsedJson['follower'],
      blmHomeTabMemorialPagePageType: parsedJson['page_type'] != null ? parsedJson['page_type'] : '',
    );
  }
}

class APIBLMHomeTabMemorialExtendedPageDetails{
  String blmHomeTabMemorialPageDetailsDescription;
  APIBLMHomeTabMemorialExtendedPageDetails({required this.blmHomeTabMemorialPageDetailsDescription});

  factory APIBLMHomeTabMemorialExtendedPageDetails.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMHomeTabMemorialExtendedPageDetails(
      blmHomeTabMemorialPageDetailsDescription: parsedJson['description'] != null ? parsedJson['description'] : '',
    );
  }
}