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

    for(int i = 0; i < post.blmTagPeople.length; i++){
      tagPeopleValue.add({'user_id': post.blmTagPeople[i].userId, 'account_type': post.blmTagPeople[i].accountType});
    }

    formData = FormData.fromMap({
      'post[page_type]': post.blmPageType,
      'post[page_id]': post.blmPageId,
      'post[body]': post.blmPostBody,
      'post[location]': post.blmLocation,
      'post[latitude]': post.blmLatitude,
      'post[longitude]': post.blmLongitude,
      'tag_people': tagPeopleValue,
    });

    if(post.blmImagesOrVideos != null || post.blmImagesOrVideos != ['']){
      for(int i = 0; i < post.blmImagesOrVideos.length; i++){
        if(post.blmImagesOrVideos[i].path != null || post.blmImagesOrVideos != ['']){
          var file = await dio.MultipartFile.fromFile(post.blmImagesOrVideos[i].path, filename: post.blmImagesOrVideos[i].path);
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
  String blmPageType;
  int blmPageId;
  String blmPostBody;
  String blmLocation;
  List<dynamic> blmImagesOrVideos;
  double blmLatitude;
  double blmLongitude;
  List<RegularTaggedPeople> blmTagPeople;
  
  APIRegularCreatePost({
    this.blmPageType, 
    this.blmPageId, 
    this.blmPostBody,
    this.blmLocation,
    this.blmImagesOrVideos, 
    this.blmLatitude,
    this.blmLongitude, 
    this.blmTagPeople,
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