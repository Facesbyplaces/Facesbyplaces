import 'package:http/http.dart' as http;

Future<bool> apiRegularHomeMemorialsTab() async{

  final http.Response response = await http.get(
    'http://fbp.dev1.koda.ws/api/v1/mainpages/memorials',
    headers: <String, String>{
      'Content-Type': 'application/json',
    }
  );

  print('The response status is ${response.statusCode}');
  print('The response status is ${response.body}');

  if(response.statusCode == 200){
    return true;
  }else{
    return false;
  }
}