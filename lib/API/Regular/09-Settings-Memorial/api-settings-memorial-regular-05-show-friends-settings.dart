// ignore_for_file: file_names
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<APIRegularShowFriendsSettingsMain> apiRegularShowFriendsSettings({required int memorialId, required int page}) async{
  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  Dio dioRequest = Dio();

  var response = await dioRequest.get('http://facesbyplaces.com/api/v1/pages/memorials/$memorialId/friends/index?page=$page',
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
    return APIRegularShowFriendsSettingsMain.fromJson(newData);
  }else{
    throw Exception('Error occurred: ${response.statusMessage}');
  }
}

class APIRegularShowFriendsSettingsMain{
  int almItemsRemaining;
  List<APIRegularShowFriendsSettingsExtended> almFriendsList;
  APIRegularShowFriendsSettingsMain({required this.almItemsRemaining, required this.almFriendsList});

  factory APIRegularShowFriendsSettingsMain.fromJson(Map<String, dynamic> parsedJson){
    var newList1 = parsedJson['friends'] as List;
    List<APIRegularShowFriendsSettingsExtended> familyList = newList1.map((i) => APIRegularShowFriendsSettingsExtended.fromJson(i)).toList();

    return APIRegularShowFriendsSettingsMain(
      almItemsRemaining: parsedJson['itemsremaining'],
      almFriendsList: familyList,
    );
  }
}

class APIRegularShowFriendsSettingsExtended{
  APIRegularShowFriendsSettingsExtendedDetails showFriendsSettingsUser;
  String showFriendsSettingsRelationship;
  APIRegularShowFriendsSettingsExtended({required this.showFriendsSettingsUser, required this.showFriendsSettingsRelationship});

  factory APIRegularShowFriendsSettingsExtended.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularShowFriendsSettingsExtended(
      showFriendsSettingsUser: APIRegularShowFriendsSettingsExtendedDetails.fromJson(parsedJson['user']),
      showFriendsSettingsRelationship: parsedJson['relationship'],
    );
  }
}

class APIRegularShowFriendsSettingsExtendedDetails{
  int showFriendsSettingsDetailsId;
  String showFriendsSettingsDetailsFirstName;
  String showFriendsSettingsDetailsLastName;
  String showFriendsSettingsDetailsImage;
  String showFriendsSettingsDetailsEmail;
  int showFriendsSettingsDetailsAccountType;
  APIRegularShowFriendsSettingsExtendedDetails({required this.showFriendsSettingsDetailsId, required this.showFriendsSettingsDetailsFirstName, required this.showFriendsSettingsDetailsLastName, required this.showFriendsSettingsDetailsImage, required this.showFriendsSettingsDetailsEmail, required this.showFriendsSettingsDetailsAccountType});

  factory APIRegularShowFriendsSettingsExtendedDetails.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularShowFriendsSettingsExtendedDetails(
      showFriendsSettingsDetailsId: parsedJson['id'],
      showFriendsSettingsDetailsFirstName: parsedJson['first_name'] ?? '',
      showFriendsSettingsDetailsLastName: parsedJson['last_name'] ?? '',
      showFriendsSettingsDetailsImage: parsedJson['image'] ?? '',
      showFriendsSettingsDetailsEmail: parsedJson['email'] ?? '',
      showFriendsSettingsDetailsAccountType: parsedJson['account_type'],
    );
  }
}