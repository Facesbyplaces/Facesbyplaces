import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-06-regular-button.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-07-regular-background.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter/material.dart';

class RegularJoin extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      body: Container(
        height: SizeConfig.screenHeight,
        child: Stack(
          children: [

            MiscRegularBackgroundTemplate(),

            Padding(
              padding: EdgeInsets.only(left: 20.0, right: 20.0),
              child: Column(
                children: [

                  SizedBox(height: 30),
                  
                  Align(
                    alignment: Alignment.centerLeft, 
                    child: IconButton(
                      onPressed: (){
                        Navigator.pop(context);
                      }, 
                      icon: Icon(
                        Icons.arrow_back, 
                        color: Color(0xff000000), 
                        size: 30,
                      ),
                    ),
                  ),

                  Expanded(child: Container(),),

                  Container(child: Image.asset('assets/icons/logo.png', height: 150, width: 150,),),

                  Expanded(child: Container(),),
                  
                  Center(child: Text('All Lives Matter', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Color(0xffffffff),),),),

                  SizedBox(height: 20),

                  MiscRegularButtonTemplate(
                    buttonText: 'Next', 
                    buttonTextStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold, 
                      color: Color(0xffffffff),
                    ), 
                    onPressed: (){
                      Navigator.pushNamed(context, '/regular/login');
                    }, 
                    width: 150,
                    height: 45,
                    buttonColor: Color(0xff04ECFF),
                  ),

                  Expanded(child: Container(),),

                ],
              ),
            ),
            
          ],
        ),
      ),
    );
  }
}