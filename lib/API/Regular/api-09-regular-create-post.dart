import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';

Future<bool> apiRegularHomeCreatePost(APIRegularCreatePost post) async{

  bool result = false;
  final sharedPrefs = await SharedPreferences.getInstance();
  var getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  var getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  var getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  print('The access token is $getAccessToken');
  print('The UID is $getUID');
  print('The client is $getClient');

  print('The page type is ${post.pageType}');
  print('The page id is ${post.pageId}');
  print('The body is ${post.postBody}');
  print('The location is ${post.location}');
  print('The latitude is ${post.latitude}');
  print('The longitude is ${post.longitude}');
  print('The image or video is ${post.imagesOrVideos}');
  print('The tag people is ${post.tagPeople.toString()}');

  try{
    var dioRequest = dio.Dio();

    var formData;
    formData = FormData();

    formData = FormData.fromMap({
      'post[page_type]': post.pageType,
      'post[page_id]': post.pageId,
      'post[body]': post.postBody,
      'post[location]': post.location,
      'post[latitude]': post.latitude,
      'post[longitude]': post.longitude,
      'tag_people': post.tagPeople,
      // 'tag_people': '[]',
    });
    
    if(post.imagesOrVideos != null){
      var file = await dio.MultipartFile.fromFile(post.imagesOrVideos.path, filename: post.imagesOrVideos.path);
      formData.files.add(MapEntry('post[imagesOrVideos][]', file));
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

    print('The response status is ${response.statusCode}');
    print('The response data is ${response.data}');

    if(response.statusCode == 200){
      result = true;
    }
  }catch(e){
    print('The value of e is ${e.toString()}');
    result = false;
  }

  return result;
}

class APIRegularCreatePost{
  String pageType;
  int pageId;
  String postBody;
  String location;
  dynamic imagesOrVideos;
  double latitude;
  double longitude;
  List<int> tagPeople;
  
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