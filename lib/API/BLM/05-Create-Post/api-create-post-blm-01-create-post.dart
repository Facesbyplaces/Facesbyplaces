import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<bool> apiBLMHomeCreatePost({required APIBLMCreatePost post}) async{
  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  Dio dioRequest = Dio();
  FormData formData = FormData();
  List<Map<String, dynamic>> tagPeopleValue = [];

  for(int i = 0; i < post.blmPostTagPeople.length; i++){
    tagPeopleValue.add({'user_id': post.blmPostTagPeople[i].userId, 'account_type': post.blmPostTagPeople[i].accountType});
  }

  formData = FormData.fromMap({
    'post[page_type]': post.blmPostPageType,
    'post[page_id]': post.blmPostPageId,
    'post[body]': post.blmPostPostBody,
    'post[location]': post.blmPostLocation,
    'post[latitude]': post.blmPostLatitude,
    'post[longitude]': post.blmPostLongitude,
    'tag_people': tagPeopleValue,
  });
  
  if(post.blmPostImagesOrVideos != []){
    for(int i = 0; i < post.blmPostImagesOrVideos.length; i++){
      if(post.blmPostImagesOrVideos[i].path != null || post.blmPostImagesOrVideos != ['']){
        var file = await MultipartFile.fromFile(post.blmPostImagesOrVideos[i].path, filename: post.blmPostImagesOrVideos[i].path);
        formData.files.add(MapEntry('post[imagesOrVideos][]', file));
      }
    }
  }

  var response = await dioRequest.post('http://fbp.dev1.koda.ws/api/v1/posts', data: formData,
    options: Options(
      followRedirects: false,
      validateStatus: (status){
        return status! < 600;
      },
      headers: <String, String>{
        'access-token': getAccessToken,
        'uid': getUID,
        'client': getClient,
      }
    ),  
  );

  print('The status code of blm create post is ${response.statusCode}');

  if(response.statusCode == 200){
    return true;
  }else{
    return false;
  }
}

class APIBLMCreatePost{
  String blmPostPageType;
  int blmPostPageId;
  String blmPostPostBody;
  String blmPostLocation;
  List<dynamic> blmPostImagesOrVideos;
  double blmPostLatitude;
  double blmPostLongitude;
  List<BLMTaggedPeople> blmPostTagPeople;
  APIBLMCreatePost({required this.blmPostPageType, required this.blmPostPageId, required this.blmPostPostBody, required this.blmPostLocation, required this.blmPostImagesOrVideos, required this.blmPostLatitude, required this.blmPostLongitude, required this.blmPostTagPeople,});
}

class BLMTaggedPeople{
  int userId;
  int accountType;
  BLMTaggedPeople({required this.userId, required this.accountType,});
}