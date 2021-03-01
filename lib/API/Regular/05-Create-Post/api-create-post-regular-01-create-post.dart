import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';

Future<bool> apiRegularHomeCreatePost({APIRegularCreatePost post}) async{

  bool result = false;

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  try{

    var dioRequest = dio.Dio();
    var formData = FormData();
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

    if(post.almImagesOrVideos != null || post.almImagesOrVideos != ['']){
      for(int i = 0; i < post.almImagesOrVideos.length; i++){
        if(post.almImagesOrVideos[i].path != null || post.almImagesOrVideos != ['']){
          var file = await dio.MultipartFile.fromFile(post.almImagesOrVideos[i].path, filename: post.almImagesOrVideos[i].path);
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
    print('Error in create post: $e');
    result = false;
  }

  return result;
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
  
  APIRegularCreatePost({
    this.almPageType,
    this.almPageId, 
    this.almPostBody,
    this.almLocation,
    this.almImagesOrVideos, 
    this.almLatitude,
    this.almLongitude, 
    this.almTagPeople,
  });
}

class RegularTaggedPeople{
  int userId;
  int accountType;

  RegularTaggedPeople({
    this.userId,
    this.accountType,
  });
}