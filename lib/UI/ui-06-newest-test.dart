// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class NewestTest extends StatefulWidget{
  const NewestTest();

  @override
  NewestTestState createState() => NewestTestState();
}

class NewestTestState extends State<NewestTest>{

  void request() async{
    Dio dioRequest = Dio();
    FormData formData = FormData();

    // formData.files.addAll([
    //   MapEntry('mobile', MultipartFile.fromString('+6392551267'),),
    // ]);
    // final http.Response response = await http.post(
    //   Uri.parse('https://staging.helpur.app/v1/phone'),
    //   body: jsonEncode(<String, String>{
    //     'mobile': number,
    //   }),
    // );
    // print(response.statusCode);
    // Response<dynamic> response = await dioRequest.post('https://staging.helpur.app/v1/phone',
    Response<dynamic> response = await dioRequest.post('https://staging.helpur.app/v1/phone?mobile=+6392551267',
      // data: formData,
      options: Options(
        followRedirects: false,
        validateStatus: (status){
          return status! < 600;
        },
        headers: <String, dynamic>{
          'Content-Type': 'application/json',
        },
      ),  
    );

    print('The status code of blm show page details is ${response.statusCode}');


  }

  void initState(){
    request();
    super.initState();
  }


  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.red,
    );
  }
}