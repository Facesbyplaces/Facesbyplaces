import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter/material.dart';

class MiscBLMErrorMessageTemplate extends StatelessWidget{

  @override
  Widget build(BuildContext context){
    return Align(
      alignment: Alignment.center,
      child: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Column(
          children: [

            SizedBox(height: 30,),

            Image.asset('assets/icons/app-icon.png', width: 300, height: 300,),

            SizedBox(height: 100,),

            Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600, color: Colors.red),),
            
            SizedBox(height: 30,),

            Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: TextStyle(fontSize: 16),),

            SizedBox(height: 30,),

            MaterialButton(
              padding: EdgeInsets.zero,
              onPressed: () async{
                Navigator.pop(context);
              },
              child: Text('Go back',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xffffffff),
                ),
              ),
              minWidth: SizeConfig.screenWidth / 2,
              height: 45,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
              color: Colors.grey,
            ),

            SizedBox(height: 30,),

          ],
        ),
      ),
    );
  }
}

class MiscBLMLoginToContinue extends StatelessWidget{

  @override
  Widget build(BuildContext context){
    return Align(
      alignment: Alignment.center,
      child: SingleChildScrollView(
        padding: EdgeInsets.only(left: 20.0, right: 20.0),
        physics: ClampingScrollPhysics(),
        child: Column(
          children: [

            SizedBox(height: 30,),

            Image.asset('assets/icons/app-icon.png', width: 300, height: 300,),

            SizedBox(height: 30,),

            Text('FacesbyPlaces', textAlign: TextAlign.center, style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
            
            SizedBox(height: 30,),

            Text('Sign in or sign up to get the most out of the FacesbyPlaces app; list of memorials nearby, posts and much more.', textAlign: TextAlign.center, style: TextStyle(fontSize: 16),),

            SizedBox(height: 100,),

            GestureDetector(
              onTap: (){
                Navigator.of(context).pushNamedAndRemoveUntil('/blm/login', ModalRoute.withName('/blm/join'));
              },
              child: Text('Sign in or sign up to continue', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xff4EC9D4)),),
            ),

            SizedBox(height: 30,),

          ],
        ),
      ),
    );
  }
}