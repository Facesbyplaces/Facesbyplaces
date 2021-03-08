import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'Miscellaneous/Start/misc-01-start-button.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class UILogin01 extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        padding: EdgeInsets.only(left: 20.0, right: 20.0),
        child: Column(
          children: [

            SizedBox(height: 100,),

            Container(child: Image.asset('assets/icons/logo.png', height: 200, width: 200,),),

            Center(child: Text('FacesByPlaces.com', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xff000000),),),),

            SizedBox(height: 100,),

            Center(child: Text('Honor, Respect, Never Forget', textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xff000000),),),),

            SizedBox(height: 100,),

            Center(child: Text('Black Lives Matter', style: TextStyle(fontSize: 18, color: Color(0xff000000),),),),

            SizedBox(height: 5),

            MiscStartButtonIconTemplate(
              height: 50,
              buttonText: 'Speak for a loved one killed by law enforcement', 
              onPressed: (){
                Navigator.pushNamed(context, '/blm/join');
              },
              width: SizeConfig.screenWidth! / 1.5,
              buttonTextStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: Color(0xff000000),),
              buttonColor: Color(0xffF2F2F2),
              image: Container(height: 20, child: Image.asset('assets/icons/fist.png'),),
            ),

            SizedBox(height: 10),

            Center(child: Text('All Lives Matter', style: TextStyle(fontSize: 18, color: Color(0xff000000),),),),

            SizedBox(height: 5),

            MiscStartButtonIconTemplate(
              buttonText: 'Remembering friends and family', 
              onPressed: (){
                Navigator.pushNamed(context, '/regular/join');
              },
              width: SizeConfig.screenWidth! / 1.5,
              buttonTextStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: Color(0xff000000),),
              height: 35,
              buttonColor: Color(0xffE6FDFF),
              backgroundColor: Color(0xff04ECFF),
              image: Icon(Icons.favorite, size: 20, color: Color(0xffffffff),),
            ),
            
            SizedBox(height: 5),

            RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: 'Already have an account? ', 
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xff000000),
                    ),
                  ),

                  TextSpan(
                    text: 'Login', 
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xff04ECFF),
                    ),
                    recognizer: TapGestureRecognizer()
                    ..onTap = (){
                      Navigator.pushNamed(context, '/regular/login');
                    }
                  ),
                ],
              ),
            ),

            SizedBox(height: 100,),

          ],
        ),
      ),
    );
  }
}