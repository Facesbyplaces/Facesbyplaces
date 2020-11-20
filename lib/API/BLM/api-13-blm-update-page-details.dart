import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

Future<bool> apiBLMUpdatePageDetails({String name, String description, String location, String dob, String rip, String state, String country, String precinct}) async{

  bool result = false;

  final sharedPrefs = await SharedPreferences.getInstance();
  int memorialId = sharedPrefs.getInt('blm-user-memorial-id') ?? 0;
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  print('The memorial id is $memorialId');

  try{
    var dioRequest = Dio();

    var formData;
    formData = FormData();
    formData.files.addAll([
      MapEntry('name', MultipartFile.fromString(name,),),
      MapEntry('description', MultipartFile.fromString(description,),),
      MapEntry('location', MultipartFile.fromString(location,),),
      MapEntry('dob', MultipartFile.fromString(dob,),),
      MapEntry('rip', MultipartFile.fromString(rip,),),
      MapEntry('state', MultipartFile.fromString(state,),),
      MapEntry('country', MultipartFile.fromString(country,),),
      MapEntry('precinct', MultipartFile.fromString(precinct,),),
    ]);

    var response = await dioRequest.put('http://fbp.dev1.koda.ws/api/v1/pages/blm/$memorialId', data: formData,
      options: Options(
        headers: <String, dynamic>{
          'access-token': getAccessToken,
          'uid': getUID,
          'client': getClient,
        }
      ),  
    );


    if(response.statusCode == 200){
      // var newValue = json.decode(response.body);
      // return APIBLMShowPageDetailsMain.fromJson(newValue);
      result = true;
    }

    
  }catch(e){
    print('The e is $e');
    result = false;
  }

  return result;

  // final http.Response response = await http.put(
  //   'http://fbp.dev1.koda.ws/api/v1/pages/blm/$memorialId',
  //   headers: <String, String>{
  //     'Content-Type': 'application/json',
  //     'access-token': getAccessToken,
  //     'uid': getUID,
  //     'client': getClient,
  //   },
  //   body: <String, dynamic>{
  //     'name': name,
  //     'description': description,
  //     'location': location,
  //     'dob': dob,
  //     'rip': rip,
  //     'state': state,
  //     'country': country,
  //     'precinct': precinct,
  //   }
  // );


  //   var formData;
  //   formData = FormData();
  //   formData.files.addAll([
  //     MapEntry('blm[name]', MultipartFile.fromString(memorial.memorialName,),),
  //     MapEntry('blm[description]', MultipartFile.fromString(memorial.description,),),
  //     MapEntry('blm[location]', MultipartFile.fromString(memorial.locationOfIncident,),),
  //     MapEntry('blm[dob]', MultipartFile.fromString(memorial.dob,),),
  //     MapEntry('blm[rip]', MultipartFile.fromString(memorial.rip,),),
  //     MapEntry('blm[state]', MultipartFile.fromString(memorial.state,),),
  //     MapEntry('blm[country]', MultipartFile.fromString(memorial.country,),),
  //     MapEntry('blm[precinct]', MultipartFile.fromString(memorial.precinct,),),
  //     MapEntry('relationship', MultipartFile.fromString(memorial.relationship,),),
  //   ]);
  // print('The response status in update page details is ${response.statusCode}');
  // print('The response status in update page details is ${response.body}');





  // if(response.statusCode == 200){
  //   // var newValue = json.decode(response.body);
  //   // return APIBLMShowPageDetailsMain.fromJson(newValue);
  //   return true;
  // }else{
  //   return false;
  // }
}