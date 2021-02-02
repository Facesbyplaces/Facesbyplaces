import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';

Future<bool> apiBLMHomeCreatePost({APIBLMCreatePost post}) async{

  bool result = false;
  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  try{
    var dioRequest = dio.Dio();
    var formData = FormData();

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
    
    if(post.blmPostImagesOrVideos != null || post.blmPostImagesOrVideos != ['']){
      for(int i = 0; i < post.blmPostImagesOrVideos.length; i++){
        if(post.blmPostImagesOrVideos[i].path != null || post.blmPostImagesOrVideos != ['']){
          var file = await dio.MultipartFile.fromFile(post.blmPostImagesOrVideos[i].path, filename: post.blmPostImagesOrVideos[i].path);
          formData.files.add(MapEntry('post[imagesOrVideos][]', file));
        }
      }

    }

    var response = await dioRequest.post('http://fbp.dev1.koda.ws/api/v1/posts', data: formData,
      options: Options(
        headers: <String, String>{
          'access-token': getAccessToken,
          'uid': getUID,
          'client': getClient,
        }
      ),  
    );

    if(response.statusCode == 200){
      result = true;
    }
  }catch(e){
    result = false;
  }

  return result;
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
  
  APIBLMCreatePost({
    this.blmPostPageType,
    this.blmPostPageId,
    this.blmPostPostBody,
    this.blmPostLocation,
    this.blmPostImagesOrVideos,
    this.blmPostLatitude,
    this.blmPostLongitude,
    this.blmPostTagPeople,
  });
}

class BLMTaggedPeople{
  int userId;
  int accountType;

  BLMTaggedPeople({
    this.userId,
    this.accountType,
  });
}