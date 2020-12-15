import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<APIRegularShowPostLikes> apiRegularShowPostLikes({int postId}) async{

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('regular-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('regular-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('regular-client') ?? 'empty';

  final http.Response response = await http.get('http://fbp.dev1.koda.ws/api/v1/posts/likePost/status?post_id=$postId',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'access-token': getAccessToken,
      'uid': getUID,
      'client': getClient,
    }
  );

  if(response.statusCode == 200){
    var newValue = json.decode(response.body);
    return APIRegularShowPostLikes.fromJson(newValue);
  }else{
    throw Exception('Failed to get the feed');
  }
}



class APIRegularShowPostLikes{
  bool isLiked;
  int numberOfLikes;
  
  APIRegularShowPostLikes({this.isLiked, this.numberOfLikes});

  factory APIRegularShowPostLikes.fromJson(Map<String, dynamic> parsedJson){

    return APIRegularShowPostLikes(
      isLiked: parsedJson['like'],
      numberOfLikes: parsedJson['numberOfLikes'],
    );
  }
}
