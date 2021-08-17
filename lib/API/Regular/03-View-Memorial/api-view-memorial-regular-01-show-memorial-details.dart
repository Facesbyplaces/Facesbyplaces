import 'package:shared_preferences/shared_preferences.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:dio/dio.dart';

Future<APIRegularShowMemorialMain> apiRegularShowMemorial({required int memorialId}) async{
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

  print('The memorial id is $memorialId');

  var response = await dioRequest.get('http://45.33.66.25:3001/api/v1/pages/memorials/$memorialId',
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
  
  print('The status code of regular show memorial details is ${response.statusCode}');

  if(response.statusCode == 200){
    var newData = Map<String, dynamic>.from(response.data);
    return APIRegularShowMemorialMain.fromJson(newData);
  }else{
    throw Exception('Failed to show the memorial details');
  }
}

class APIRegularShowMemorialMain{
  APIRegularShowMemorialExtended almMemorial;
  APIRegularShowMemorialMain({required this.almMemorial});

  factory APIRegularShowMemorialMain.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularShowMemorialMain(
      almMemorial: APIRegularShowMemorialExtended.fromJson(parsedJson['memorial']),
    );
  }
}

class APIRegularShowMemorialExtended{
  int showMemorialId;
  String showMemorialName;
  APIRegularShowMemorialExtendedDetails showMemorialDetails;
  String showMemorialBackgroundImage;
  String showMemorialProfileImage;
  List<dynamic> showMemorialImagesOrVideos;
  bool showMemorialFollower;
  int showMemorialPostsCount;
  int showMemorialFamilyCount;
  int showMemorialFriendsCount;
  int showMemorialFollowersCount;
  APIRegularShowMemorialExtended({required this.showMemorialId, required this.showMemorialName, required this.showMemorialDetails, required this.showMemorialBackgroundImage, required this.showMemorialProfileImage, required this.showMemorialImagesOrVideos, required this.showMemorialFollower, required this.showMemorialPostsCount, required this.showMemorialFamilyCount, required this.showMemorialFriendsCount, required this.showMemorialFollowersCount});

  factory APIRegularShowMemorialExtended.fromJson(Map<String, dynamic> parsedJson){
    List<dynamic>? newList1;

    if(parsedJson['imagesOrVideos'] != null){
      var list = parsedJson['imagesOrVideos'];
      newList1 = List<dynamic>.from(list);
    }

    return APIRegularShowMemorialExtended(
      showMemorialId: parsedJson['id'],
      showMemorialName: parsedJson['name'] != null ? parsedJson['name'] : '',
      showMemorialDetails: APIRegularShowMemorialExtendedDetails.fromJson(parsedJson['details']),
      showMemorialBackgroundImage: parsedJson['backgroundImage'] != null ? parsedJson['backgroundImage'] : '',
      showMemorialProfileImage: parsedJson['profileImage'] != null ? parsedJson['profileImage'] : '',
      showMemorialImagesOrVideos: newList1 != null ? newList1 : [],
      showMemorialFollower: parsedJson['follower'],
      showMemorialPostsCount: parsedJson['postsCount'],
      showMemorialFamilyCount: parsedJson['familyCount'],
      showMemorialFriendsCount: parsedJson['friendsCount'],
      showMemorialFollowersCount: parsedJson['followersCount'],
    );
  }
}

class APIRegularShowMemorialExtendedDetails{
  String showMemorialDetailsDescription;
  String showMemorialDetailsBirthPlace;
  String showMemorialDetailsDob;
  String showMemorialDetailsRip;
  String showMemorialDetailsCemetery;
  String showMemorialDetailsCountry;
  bool showMemorialAcceptDonations;
  double showMemorialLatitude;
  double showMemorialLongitude;
  APIRegularShowMemorialExtendedDetails({required this.showMemorialDetailsDescription, required this.showMemorialDetailsBirthPlace, required this.showMemorialDetailsDob, required this.showMemorialDetailsRip, required this.showMemorialDetailsCemetery, required this.showMemorialDetailsCountry, required this.showMemorialAcceptDonations, required this.showMemorialLatitude, required this.showMemorialLongitude});

  factory APIRegularShowMemorialExtendedDetails.fromJson(Map<String, dynamic> parsedJson){
    String newDOB = parsedJson['dob'];
    DateTime dob = DateTime.parse(newDOB);

    String newRIP = parsedJson['rip'];
    DateTime rip = DateTime.parse(newRIP);
    
    return APIRegularShowMemorialExtendedDetails(
      showMemorialDetailsDescription: parsedJson['description'] != null ? parsedJson['description'] : '',
      showMemorialDetailsBirthPlace: parsedJson['birthplace'] != null ? parsedJson['birthplace'] : '',
      showMemorialDetailsDob: dob.format(AmericanDateFormats.standardWithComma),
      showMemorialDetailsRip: rip.format(AmericanDateFormats.standardWithComma),
      showMemorialDetailsCemetery: parsedJson['cemetery'] != null ? parsedJson['cemetery'] : '',
      showMemorialDetailsCountry: parsedJson['country'] != null ? parsedJson['country'] : '',
      showMemorialAcceptDonations: parsedJson['accept_donations'] != null ? parsedJson['accept_donations'] : false,
      showMemorialLatitude: parsedJson['latitude'] != null ? parsedJson['latitude'] : 0.0,
      showMemorialLongitude: parsedJson['longitude'] != null ? parsedJson['longitude'] : 0.0,
    );
  }
}