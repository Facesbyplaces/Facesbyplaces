import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<bool> apiRegularHomeCreatePost({required APIRegularCreatePost post}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  Dio dioRequest = Dio();
  FormData formData = FormData();
  List<Map<String, dynamic>> tagPeopleValue = [];

  for(int i = 0; i < post.almTagPeople.length; i++){
    tagPeopleValue.add({'user_id': post.almTagPeople[i].userId, 'account_type': post.almTagPeople[i].accountType});
  }

  formData = FormData.fromMap({
    'post[page_type]': post.almPageType,
    'post[page_id]': post.almPageId,
    'post[body]': post.almPostBody,
    'post[location]': post.almLocation,
    'post[latitude]': post.almLatitude,
    'post[longitude]': post.almLongitude,
    'tag_people': tagPeopleValue,
  });

  print('The value of tagPeopleValue is $tagPeopleValue');

  if(post.almImagesOrVideos != []){
    for(int i = 0; i < post.almImagesOrVideos.length; i++){
      if(post.almImagesOrVideos[i].path != null || post.almImagesOrVideos != ['']){
        var file = await MultipartFile.fromFile(post.almImagesOrVideos[i].path, filename: post.almImagesOrVideos[i].path);
        formData.files.add(MapEntry('post[imagesOrVideos][]', file));
      }
    }
  }

  var response = await dioRequest.post('http://fbp.dev1.koda.ws/api/v1/posts', data: formData,
    options: Options(
      followRedirects: false,
      validateStatus: (status) {
        return status! < 600;
      },
      headers: <String, String>{
        'access-token': getAccessToken,
        'uid': getUID,
        'client': getClient,
      }
    ),  
  );

  print('The status code of regular create post is ${response.statusCode}');

  if(response.statusCode == 200){
    return true;
  }else{
    return false;
  }
}

class APIRegularCreatePost{
  String almPageType;
  int almPageId;
  String almPostBody;
  String almLocation;
  List<dynamic> almImagesOrVideos;
  double almLatitude;
  double almLongitude;
  List<RegularTaggedPeople> almTagPeople;
  APIRegularCreatePost({required this.almPageType, required this.almPageId, required this.almPostBody, required this.almLocation, required this.almImagesOrVideos, required this.almLatitude, required this.almLongitude, required this.almTagPeople,});
}

class RegularTaggedPeople{
  int userId;
  int accountType;
  RegularTaggedPeople({required this.userId, required this.accountType,});
}