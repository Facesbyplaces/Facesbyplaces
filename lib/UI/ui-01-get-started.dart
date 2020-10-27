import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'Miscellaneous/misc-07-button.dart';
import 'Miscellaneous/misc-08-background.dart';
import 'package:flutter/material.dart';

class UIGetStarted extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      body: Stack(
        children: [

          MiscBackgroundTemplate(),

          Column(
            children: [

              SizedBox(height: SizeConfig.blockSizeVertical * 15,),

              Center(child: Image.asset('assets/icons/logo.png', height: SizeConfig.blockSizeVertical * 30, width: SizeConfig.blockSizeVertical * 30,),),

              SizedBox(height: SizeConfig.blockSizeVertical * 10,),

              Center(child: Text('FacesByPlaces.com', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 5, fontWeight: FontWeight.bold, color: Color(0xff04ECFF),),),),

              SizedBox(height: SizeConfig.blockSizeVertical * 5,),

              Padding(
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                child: Center(
                  child: Text('Create a Memorial Page for Loved Ones by Sharing Stories, photos of Special Events & Occasions. Keeping their Memories alive for Generations', 
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: SizeConfig.safeBlockHorizontal * 5,
                      fontFamily: 'Roboto',
                      color: Color(0xffffffff),
                    ),
                  ),
                ),
              ),

              SizedBox(height: SizeConfig.blockSizeVertical * 10,),

              MiscButtonTemplate(buttonText: 'Get Started', buttonTextStyle: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, fontWeight: FontWeight.bold, color: Color(0xffffffff),), onPressed: (){Navigator.pushNamed(context, 'ui-02-login');}, width: SizeConfig.screenWidth / 1.5, height: SizeConfig.blockSizeVertical * 8, buttonColor: Color(0xff04ECFF),),

            ],
          ),
        ],
      ),
    );
  }
}