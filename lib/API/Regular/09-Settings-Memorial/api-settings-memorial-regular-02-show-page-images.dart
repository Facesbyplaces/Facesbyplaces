import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIRegularShowPageImagesMain> apiRegularShowPageImages({required int memorialId}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  final http.Response response = await http.get(
    Uri.http('http://fbp.dev1.koda.ws/api/v1/pages/memorials/$memorialId/editImages', ''),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    }
  );

  if(response.statusCode == 200){
    var newValue = json.decode(response.body);
    return APIRegularShowPageImagesMain.fromJson(newValue);
  }else{
    throw Exception('Failed to get the images');
  }
}

class APIRegularShowPageImagesMain{

  APIRegularShowPageImagesExtended almMemorial;
  APIRegularShowPageImagesMain({required this.almMemorial});

  factory APIRegularShowPageImagesMain.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularShowPageImagesMain(
      almMemorial: APIRegularShowPageImagesExtended.fromJson(parsedJson['memorial']),
    );
  }
}

class APIRegularShowPageImagesExtended{
  int showPageImagesId;
  String showPageImagesName;
  APIRegularShowPageImagesExtendedDetails showPageImagesDetails;
  dynamic showPageImagesBackgroundImage;
  dynamic showPageImagesProfileImage;
  dynamic showPageImagesImagesOrVideos;
  String showPageImagesRelationship;
  APIRegularShowPageImagesExtendedPageCreator showPageImagesPageCreator;

  APIRegularShowPageImagesExtended({required this.showPageImagesId, required this.showPageImagesName, required this.showPageImagesDetails, required this.showPageImagesBackgroundImage, required this.showPageImagesProfileImage, required this.showPageImagesImagesOrVideos, required this.showPageImagesRelationship, required this.showPageImagesPageCreator});

  factory APIRegularShowPageImagesExtended.fromJson(Map<String, dynamic> parsedJson){
    List<dynamic>? newList1;

    if(parsedJson['imagesOrVideos'] != null){
      var list = parsedJson['imagesOrVideos'];
      newList1 = List<dynamic>.from(list);
    }

    return APIRegularShowPageImagesExtended(
      showPageImagesId: parsedJson['id'],
      showPageImagesName: parsedJson['name'],
      showPageImagesDetails: APIRegularShowPageImagesExtendedDetails.fromJson(parsedJson['details']),
      showPageImagesBackgroundImage: parsedJson['backgroundImage'],
      showPageImagesProfileImage: parsedJson['profileImage'],
      showPageImagesImagesOrVideos: newList1!,
      showPageImagesRelationship: parsedJson['relationship'],
      showPageImagesPageCreator: APIRegularShowPageImagesExtendedPageCreator.fromJson(parsedJson['page_creator'])
    );
  }
}

class APIRegularShowPageImagesExtendedDetails{
  String showPageImagesDetailsDescription;
  String showPageImagesDetailsLocation;
  String showPageImagesDetailsPrecinct;
  String showPageImagesDetailsDob;
  String showPageImagesDetailsRip;
  String showPageImagesDetailsState;
  String showPageImagesDetailsCountry;

  APIRegularShowPageImagesExtendedDetails({required this.showPageImagesDetailsDescription, required this.showPageImagesDetailsLocation, required this.showPageImagesDetailsPrecinct, required this.showPageImagesDetailsDob, required this.showPageImagesDetailsRip, required this.showPageImagesDetailsState, required this.showPageImagesDetailsCountry});

  factory APIRegularShowPageImagesExtendedDetails.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularShowPageImagesExtendedDetails(
      showPageImagesDetailsDescription: parsedJson['description'],
      showPageImagesDetailsLocation: parsedJson['location'],
      showPageImagesDetailsPrecinct: parsedJson['precinct'],
      showPageImagesDetailsDob: parsedJson['dob'],
      showPageImagesDetailsRip: parsedJson['rip'],
      showPageImagesDetailsState: parsedJson['state'],
      showPageImagesDetailsCountry: parsedJson['country'],
    );
  }
}

class APIRegularShowPageImagesExtendedPageCreator{
  int showPageImagesPageCreatorId;
  String showPageImagesPageCreatorFirstName;
  String showPageImagesPageCreatorLastName;
  String showPageImagesPageCreatorPhoneNumber;
  String showPageImagesPageCreatorEmail;
  String showPageImagesPageCreatorUserName;
  dynamic showPageImagesPageCreatorImage;

  APIRegularShowPageImagesExtendedPageCreator({required this.showPageImagesPageCreatorId, required this.showPageImagesPageCreatorFirstName, required this.showPageImagesPageCreatorLastName, required this.showPageImagesPageCreatorPhoneNumber, required this.showPageImagesPageCreatorEmail, required this.showPageImagesPageCreatorUserName, required this.showPageImagesPageCreatorImage});

  factory APIRegularShowPageImagesExtendedPageCreator.fromJson(Map<String, dynamic> parsedJson){
    return APIRegularShowPageImagesExtendedPageCreator(
      showPageImagesPageCreatorId: parsedJson['id'],
      showPageImagesPageCreatorFirstName: parsedJson['first_name'],
      showPageImagesPageCreatorLastName: parsedJson['last_name'],
      showPageImagesPageCreatorPhoneNumber: parsedJson['phone_number'],
      showPageImagesPageCreatorEmail: parsedJson['email'],
      showPageImagesPageCreatorUserName: parsedJson['username'],
      showPageImagesPageCreatorImage: parsedJson['image']
    );
  }
}