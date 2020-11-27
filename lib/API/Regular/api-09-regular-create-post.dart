import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart' as dio;

Future<bool> apiRegularHomeCreatePost(APIRegularCreatePost post) async{

  bool result = false;
  final sharedPrefs = await SharedPreferences.getInstance();
  int memorialId = sharedPrefs.getInt('regular-user-memorial-id') ?? 0;
  var getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  var getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  var getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  try{
    var dioRequest = dio.Dio();

    var formData;
    formData = FormData();

    formData.files.addAll([
      MapEntry('post[page_type]', MultipartFile.fromString(post.pageType),),
      MapEntry('post[page_id]', MultipartFile.fromString(memorialId.toString()),),
      MapEntry('post[body]', MultipartFile.fromString(post.postBody),),
      MapEntry('post[location]', MultipartFile.fromString(post.location),),
      MapEntry('post[latitude]', MultipartFile.fromString(post.latitude),),
      MapEntry('post[longitude]', MultipartFile.fromString(post.longitude),),
      MapEntry('tag_people[]', MultipartFile.fromString(post.tagPeople),),
    ]);

    
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

    print('The status code in regular create post is ${response.statusCode}');
    print('The status code in regular create post is ${response.data}');

    if(response.statusCode == 200){
      result = true;
    }
  }catch(e){
    print('The e is $e');
    result = false;
  }

  return result;
}

class APIRegularCreatePost{
  String pageType;
  String pageId;
  String postBody;
  String location;
  dynamic imagesOrVideos;
  String latitude;
  String longitude;
  String tagPeople;
  
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