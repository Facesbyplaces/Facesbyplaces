import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

Future<bool> apiBLMUpdateOtherDetails({String birthdate, String birthplace, String email, String address, String phoneNumber}) async{

  bool result = false;

  final sharedPrefs = await SharedPreferences.getInstance();
  String getAccessToken = sharedPrefs.getString('blm-access-token') ?? 'empty';
  String getUID = sharedPrefs.getString('blm-uid') ?? 'empty';
  String getClient = sharedPrefs.getString('blm-client') ?? 'empty';

  try{

    final http.Response response = await http.put('http://fbp.dev1.koda.ws/api/v1/users/updateOtherInfos?birthdate=$birthdate&birthplace=$birthplace&email=$email&address=$address&phone_number=$phoneNumber',
      headers: <String, String>{
        'access-token': getAccessToken,
        'uid': getUID,
        'client': getClient,
      },
    );

    if(response.statusCode == 200){
      result = true;
    }
    
  }catch(e){
    print('Error in settings update other details: $e');
    result = false;
  }

  return result;
}