import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:http_auth/http_auth.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class LoginPaypalTest extends StatelessWidget {

  final TextEditingController controller1 = TextEditingController();
  final TextEditingController controller2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff04ECFF),
        title: Text('Paypal', style: TextStyle(fontSize: 16, color: Color(0xffffffff)),),
        centerTitle: true,
        leading: IconButton(icon: Icon(Icons.arrow_back, color: Color(0xffffffff),), onPressed: (){Navigator.pop(context);},),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(left: 20.0, right: 20.0),
        physics: ClampingScrollPhysics(),
        child: Column(
          children: [
            
            Container(
              height: 240,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/icons/paypal.png'),
                ),
              ),
              // child: FaIcon(FontAwesomeIcons.paypal,),
            ),

            Text('Log in with Paypal', style: TextStyle(fontSize: 16, color: Color(0xff000000)),),

            SizedBox(height: 40),

            TextFormField(
              controller: controller1,
              keyboardType: TextInputType.emailAddress,
              cursorColor: Color(0xff000000),
              decoration: InputDecoration(
                fillColor: Color(0xffffffff),
                filled: true,
                alignLabelWithHint: true,
                labelText: 'Email',
                labelStyle: TextStyle(fontSize: 16, color: Color(0xff888888)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide(
                    color: Color(0xff000000),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide(
                    color: Color(0xff000000),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide(
                    color: Color(0xff000000),
                  ),
                ),
              ),
            ),

            SizedBox(height: 20,),

            TextFormField(
              controller: controller2,
              obscureText: true,
              keyboardType: TextInputType.text,
              cursorColor: Color(0xff000000),
              decoration: InputDecoration(
                fillColor: Color(0xffffffff),
                filled: true,
                alignLabelWithHint: true,
                labelText: 'Password',
                labelStyle: TextStyle(fontSize: 16, color: Color(0xff888888)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide(
                    color: Color(0xff000000),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide(
                    color: Color(0xff000000),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide(
                    color: Color(0xff000000),
                  ),
                ),
              ),
            ),

            SizedBox(height: 40),

            MaterialButton(
              padding: EdgeInsets.zero,
              onPressed: () async{
                print('hehehe');
                var client = BasicAuthClient('AdFMd7tGZjQMPhTpOiEZSkK7SYmBAoAY71Mrdjbe9g_JVrlY0_0Df-ncKw4wl__YXNBn15PtdGiQNuUT', 'ELQ49uFroNvBtx-DUQ1uIiLv4vpEMk5WM7VRqzq92KANWsTgHe6SJdAibXqAulq4g9tSixZPFrLzCN0m');
                // Uri.parse('https://api.sandbox.paypal.com/v1/oauth2/token?grant_type=client_credentials');

                try{
                  print('start here');
                  var response = await client.post(Uri.parse('https://api.sandbox.paypal.com/v1/oauth2/token?grant_type=client_credentials'));
                  print('hereee');
                  print('The response is ${response.body}');
                  print('The response is ${response.statusCode}');

                  if (response.statusCode == 200) {
                    // final body = json.jsonDecode(response.body);
                    final body = json.decode(response.body);
                    return body["access_token"];
                  }

                }catch(e){
                  print('The error is $e');
                }

              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 40,
                    height: 60,
                    decoration: BoxDecoration(
                      // color: Colors.blue,
                      image: DecorationImage(
                        image: AssetImage('assets/icons/paypal.png',),
                        fit: BoxFit.cover,
                      ),
                    ),
                    // child: FaIcon(FontAwesomeIcons.paypal,),
                  ),

                  SizedBox(width: 9,),

                  Text(
                    'Log in with Paypal',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold, 
                      color: Color(0xff000000),
                    ), 
                  ),
                ],
              ),
              minWidth: SizeConfig.screenWidth,
              height: 48,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)
              ),
              color: Color(0xffdddddd),
            ),

            SizedBox(height: 20),

          ],
        ),
      ),
    );
  }
}
