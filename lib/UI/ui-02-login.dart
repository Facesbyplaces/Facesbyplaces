import 'package:facesbyplaces/Configurations/size_configuration.dart';
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

            Image.asset('assets/icons/logo.png', height: 200, width: 200,),

            Text('FacesByPlaces.com', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xff000000),),),

            SizedBox(height: 100,),

            Text('Honor, Respect, Never Forget', textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xff000000),),),

            SizedBox(height: 100,),

            Text('Black Lives Matter', style: TextStyle(fontSize: 18, color: Color(0xff000000),),),

            SizedBox(height: 5),

            MaterialButton(
              padding: EdgeInsets.zero,
              minWidth: SizeConfig.screenWidth! / 1.5,
              height: 35,
              child: Row(
                children: [
                  CircleAvatar(
                    minRadius: 35,
                    backgroundColor: Color(0xff000000),
                    child: Center(child: Image.asset('assets/icons/fist.png', height: 20,),),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(left: 10.0, right: 10.0,),
                      alignment: Alignment.centerLeft,
                      child: Text('Speak for a loved one killed by law enforcement', 
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: Color(0xff000000),),
                      ),
                    ),
                  ),
                ],
              ),
              shape: StadiumBorder(),
              color: Color(0xffF2F2F2),
              onPressed: (){
                Navigator.pushNamed(context, '/regular/join');
              },
            ),

            SizedBox(height: 10),

            Text('All Lives Matter', style: TextStyle(fontSize: 18, color: Color(0xff000000),),),

            SizedBox(height: 5),

            MaterialButton(
              padding: EdgeInsets.zero,
              minWidth: SizeConfig.screenWidth! / 1.5,
              height: 35,
              child: Row(
                children: [
                  CircleAvatar(
                    minRadius: 35,
                    backgroundColor: Color(0xff04ECFF),
                    child: Center(child: Icon(Icons.favorite, size: 20, color: Color(0xffffffff),)),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(left: 10.0, right: 10.0,),
                      alignment: Alignment.centerLeft,
                      child: Text('Remembering friends and family',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: Color(0xff000000),),
                      ),
                    ),
                  ),
                ],
              ),
              shape: StadiumBorder(),
              color: Color(0xffE6FDFF),
              onPressed: (){
                Navigator.pushNamed(context, '/regular/join');
              },
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