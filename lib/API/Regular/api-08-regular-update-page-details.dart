import 'package:http/http.dart' as http;

Future<bool> apiRegularHomeUpdatePageDetails() async{

  final http.Response response = await http.post(
    'https://01244d89dd6fd9fd5dae11b6ec419531.m.pipedream.net',
    headers: <String, String>{
      'Content-Type': 'application/json',
    }
  );

  print('The response status is ${response.statusCode}');
  // print('The response status is ${response.body}');

  if(response.statusCode == 200){
    return true;
  }else{
    return false;
  }
}