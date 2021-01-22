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

    print('The length of tag people is ${post.tagPeople.length}');

    for(int i = 0; i < post.tagPeople.length; i++){
      print('The index is $i and the user id is ${post.tagPeople[i].userId}');
      print('The index is $i and the account type is ${post.tagPeople[i].accountType}');
      tagPeopleValue.add({'user_id': post.tagPeople[i].userId, 'account_type': post.tagPeople[i].accountType});
    }

    print('The length of tagPeopleValue is ${tagPeopleValue.length}');
    print('The tagPeopleValue is $tagPeopleValue');

    formData = FormData.fromMap({
      'post[page_type]': post.pageType,
      'post[page_id]': post.pageId,
      'post[body]': post.postBody,
      'post[location]': post.location,
      'post[latitude]': post.latitude,
      'post[longitude]': post.longitude,
      // 'tag_people': post.tagPeople,
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

    print('The status code of create post is ${response.statusCode}');
    print('The status code of create post is ${response.data}');

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
  List<BLMTaggedPeople> tagPeople;
  
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

class BLMTaggedPeople{
  int userId;
  int accountType;

  BLMTaggedPeople({
    this.userId,
    this.accountType,
  });
}