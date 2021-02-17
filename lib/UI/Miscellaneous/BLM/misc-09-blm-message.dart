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