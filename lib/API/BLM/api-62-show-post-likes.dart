// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// Future<APIBLMShowPostLikes> apiBLMShowPostLikes({int postId}) async{

//   final sharedPrefs = await SharedPreferences.getInstance();
//   String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
//   String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
//   String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

//   final http.Response response = await http.get('http://fbp.dev1.koda.ws/api/v1/posts/likePost/status?post_id=$postId',
//     headers: <String, String>{
//       'Content-Type': 'application/json',
//       'access-token': getAccessToken,
//       'uid': getUID,
//       'client': getClient,
//     }
//   );

//     print('The status code of likes is ${response.statusCode}');
//     print('The status body of likes is ${response.body}');

//   if(response.statusCode == 200){
//     var newValue = json.decode(response.body);
//     return APIBLMShowPostLikes.fromJson(newValue);
//   }else{
//     throw Exception('Failed to get the feed');
//   }
// }



// class APIBLMShowPostLikes{
//   bool isLiked;
//   int numberOfLikes;
  
//   APIBLMShowPostLikes({this.isLiked, this.numberOfLikes});

//   factory APIBLMShowPostLikes.fromJson(Map<String, dynamic> parsedJson){

//     return APIBLMShowPostLikes(
//       isLiked: parsedJson['like'],
//       numberOfLikes: parsedJson['numberOfLikes'],
//     );
//   }
// }
