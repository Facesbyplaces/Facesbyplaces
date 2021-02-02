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

    for(int i = 0; i < post.tagPeople.length; i++){
      tagPeopleValue.add({'user_id': post.tagPeople[i].userId, 'account_type': post.tagPeople[i].accountType});
    }

    formData = FormData.fromMap({
      'post[page_type]': post.pageType,
      'post[page_id]': post.pageId,
      'post[body]': post.postBody,
      'post[location]': post.location,
      'post[latitude]': post.latitude,
      'post[longitude]': post.longitude,
      'tag_people': tagPeopleValue,
    });

    if(post.imagesOrVideos != null || post.imagesOrVideos != ['']){
      for(int i = 0; i < post.imagesOrVideos.length; i++){
        if(post.imagesOrVideos[i].path != null || post.imagesOrVideos != ['']){
          var file = await dio.MultipartFile.fromFile(post.imagesOrVideos[i].path, filename: post.imagesOrVideos[i].path);
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
  String pageType;
  int pageId;
  String postBody;
  String location;
  List<dynamic> imagesOrVideos;
  double latitude;
  double longitude;
  List<RegularTaggedPeople> tagPeople;
  
  APIRegularCreatePost({
    this.pageType, 
    this.pageId, 
    this.postBody,
    this.location,
    this.imagesOrVideos, 
    this.latitude,
    this.longitude, 
    this.tagPeople,
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