import 'package:shared_preferences/shared_preferences.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:dio/dio.dart';

Future<APIBLMShowMemorialMain> apiBLMShowMemorial({required int memorialId}) async{
  final sharedPrefs = await SharedPreferences.getInstance();
  bool userSessionRegular = sharedPrefs.getBool('regular-user-session') ?? false;
  bool userSessionBLM = sharedPrefs.getBool('blm-user-session') ?? false;
  String? getAccessToken;
  String? getUID;
  String? getClient;

  if(userSessionRegular == true){
    getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
    getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
    getClient = sharedPrefs.getString('regular-client') ?? 'empty';
  }else if(userSessionBLM == true){
    getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
    getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
    getClient = sharedPrefs.getString('blm-client') ?? 'empty';
  }

  Dio dioRequest = Dio();

  var response = await dioRequest.get('https://www.facesbyplaces.com/api/v1/pages/blm/$memorialId',
    options: Options(
      headers: <String, dynamic>{
        'Content-Type': 'application/json',
        'access-token': getAccessToken,
        'uid': getUID,
        'client': getClient,
      },
      validateStatus: (status){
        return status! < 600;
      },
      followRedirects: false,
    ),  
  );

  if(response.statusCode == 200){
    var newData = Map<String, dynamic>.from(response.data);
    return APIBLMShowMemorialMain.fromJson(newData);
  }else{
    throw Exception('Failed to show the memorial details');
  }
}

class APIBLMShowMemorialMain{
  APIBLMShowMemorialExtended blmMemorial;
  APIBLMShowMemorialMain({required this.blmMemorial});

  factory APIBLMShowMemorialMain.fromJson(Map<String, dynamic> parsedJson){
    return APIBLMShowMemorialMain(
      blmMemorial: APIBLMShowMemorialExtended.fromJson(parsedJson['blm']),
    );
  }
}

class APIBLMShowMemorialExtended{
  int memorialId;
  String memorialName;
  APIBLMShowMemorialExtendedDetails memorialDetails;
  String memorialBackgroundImage;
  String memorialProfileImage;
  List<dynamic> memorialImagesOrVideos;
  String memorialRelationship;
  bool memorialManage;
  bool memorialFamOrFriends;
  bool memorialFollower;
  int memorialPostsCount;
  int memorialFamilyCount;
  int memorialFriendsCount;
  int memorialFollowersCount;
  APIBLMShowMemorialExtended({required this.memorialId, required this.memorialName, required this.memorialDetails, required this.memorialBackgroundImage, required this.memorialProfileImage, required this.memorialImagesOrVideos, required this.memorialRelationship, required this.memorialManage, required this.memorialFamOrFriends, required this.memorialFollower, required this.memorialPostsCount, required this.memorialFamilyCount, required this.memorialFriendsCount, required this.memorialFollowersCount});

  factory APIBLMShowMemorialExtended.fromJson(Map<String, dynamic> parsedJson){
    List<dynamic>? newList1;

    if(parsedJson['imagesOrVideos'] != null){
      var list = parsedJson['imagesOrVideos'];
      newList1 = List<dynamic>.from(list);
    }

    return APIBLMShowMemorialExtended(
      memorialId: parsedJson['id'],
      memorialName: parsedJson['name'] ?? '',
      memorialDetails: APIBLMShowMemorialExtendedDetails.fromJson(parsedJson['details']),
      memorialBackgroundImage: parsedJson['backgroundImage'] ?? '',
      memorialProfileImage: parsedJson['profileImage'] ?? '',
      memorialImagesOrVideos: newList1 ?? [],
      memorialRelationship: parsedJson['relationship'] ?? '',
      memorialManage: parsedJson['manage'],
      memorialFamOrFriends: parsedJson['famOrFriends'],
      memorialFollower: parsedJson['follower'],
      memorialPostsCount: parsedJson['postsCount'],
      memorialFamilyCount: parsedJson['familyCount'],
      memorialFriendsCount: parsedJson['friendsCount'],
      memorialFollowersCount: parsedJson['followersCount'],
    );
  }
}

class APIBLMShowMemorialExtendedDetails{
  String memorialDetailsDescription;
  String memorialDetailsLocation;
  String memorialDetailsPrecinct;
  String memorialDetailsRip;
  String memorialDetailsState;
  String memorialDetailsCountry;
  bool memorialAcceptDonations;
  double memorialLatitude;
  double memorialLongitude;
  APIBLMShowMemorialExtendedDetails({required this.memorialDetailsDescription, required this.memorialDetailsLocation, required this.memorialDetailsPrecinct, required this.memorialDetailsRip, required this.memorialDetailsState, required this.memorialDetailsCountry, required this.memorialAcceptDonations, required this.memorialLatitude, required this.memorialLongitude});

  factory APIBLMShowMemorialExtendedDetails.fromJson(Map<String, dynamic> parsedJson){
    // String newRIP = parsedJson['rip'];
    // DateTime rip = DateTime.parse(newRIP);

    return APIBLMShowMemorialExtendedDetails(
      memorialDetailsDescription: parsedJson['description'] ?? '',
      memorialDetailsLocation: parsedJson['location'] ?? '',
      memorialDetailsPrecinct: parsedJson['precinct'] ?? '',
      // memorialDetailsRip: rip.format(AmericanDateFormats.standardWithComma),
      memorialDetailsRip: ((){
        if(parsedJson['rip'] == null || parsedJson['rip'] == 'Unknown'){
          return 'Unknown';
        }else{
          String newRIP = parsedJson['rip'];
          DateTime rip = DateTime.parse(newRIP);
          return rip.format(AmericanDateFormats.standardWithComma);
        }
      }()),
      memorialDetailsState: parsedJson['state'] ?? '',
      memorialDetailsCountry: parsedJson['country'] ?? '',
      memorialAcceptDonations: parsedJson['accept_donations'] ?? false,
      memorialLatitude: parsedJson['latitude'] ?? 0.0,
      memorialLongitude: parsedJson['longitude'] ?? 0.0,
    );
  }
}