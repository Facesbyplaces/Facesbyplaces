import 'package:shared_preferences/shared_preferences.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:dio/dio.dart';

Future<APIRegularShowMemorialMain> apiRegularShowMemorial({required int memorialId}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  Dio dioRequest = Dio();

  var response = await dioRequest.get('http://fbp.dev1.koda.ws/api/v1/pages/memorials/$memorialId',
    options: Options(
      headers: <String, dynamic>{
        'Content-Type': 'application/json',
        'access-token': getAccessToken,
        'uid': getUID,
        'client': getClient,
      }
    ),  
  );

  print('The status code of feed is ${response.statusCode}');

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

  APIRegularShowMemorialExtendedDetails({required this.showMemorialDetailsDescription, required this.showMemorialDetailsBirthPlace, required this.showMemorialDetailsDob, required this.showMemorialDetailsRip, required this.showMemorialDetailsCemetery, required this.showMemorialDetailsCountry});

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
    );
  }
}