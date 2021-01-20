import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';

Future<bool> apiBLMHomeCreatePost({APIBLMCreatePost post}) async{

  bool result = false;
  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  for(int i = 0; i < post.tagPeople.length; i++){
    print('The userId is ${post.tagPeople[i].userId} and the accountType is ${post.tagPeople[i].accountType}');
  }

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
      // 'tag_people': post.tagPeople,
    });

    // if(post.tagPeople != null){
    //   for(int i = 0; i < post.tagPeople.length; i++){
    //     if(post.imagesOrVideos[i].path != null || post.imagesOrVideos != ['']){
    //       var file = await dio.MultipartFile.fromFile(post.imagesOrVideos[i].path, filename: post.imagesOrVideos[i].path);
    //       formData.files.add(MapEntry('post[imagesOrVideos][]', file));
    //     }
    //   }

    // }

    
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
    print('The value of e is ${e.toString()}');
    result = false;
  }

  return result;
}

class APIBLMCreatePost{
  String pageType;
  int pageId;
  String postBody;
  String location;
  List<dynamic> imagesOrVideos;
  double latitude;
  double longitude;
  // List<int> tagPeople;
  List<TaggedPeople> tagPeople;
  
  APIBLMCreatePost({
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

class TaggedPeople{
  int userId;
  int accountType;

  TaggedPeople({
    this.userId,
    this.accountType,
  });
}