import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'Miscellaneous/misc-07-button.dart';
import 'Miscellaneous/misc-08-background.dart';
import 'package:flutter/material.dart';

const double pi = 3.1415926535897932;

class UIGetStarted extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      body: Stack(
        children: [

          MiscBackgroundTemplate(),

          Container(
            height: SizeConfig.screenHeight / 2,
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  child: Transform.rotate(
                    angle: -pi / 30,
                    child: Container(
                      padding: EdgeInsets.all(5),
                      color: Color(0xffffffff),
                      height: (SizeConfig.screenHeight / 2) / 4,
                      child: Image.asset('assets/icons/frontpage-image3.png'),
                    ),
                  ),
                ),
                Positioned(
                  top: (SizeConfig.screenHeight / 2) / 4,
                  child: Transform.rotate(
                    angle: -pi / 30,
                    child: Container(
                      padding: EdgeInsets.all(5),
                      color: Color(0xffffffff),
                      height: (SizeConfig.screenHeight / 2) / 4,
                      child: Image.asset('assets/icons/frontpage-image4.png'),
                    ),
                  ),
                ),
                Positioned(
                  bottom: (SizeConfig.screenHeight / 2) / 4,
                  child: Container(
                    padding: EdgeInsets.all(5),
                    color: Color(0xffffffff),
                    height: (SizeConfig.screenHeight / 2) / 4,
                    child: Image.asset('assets/icons/frontpage-image5.png'),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    padding: EdgeInsets.all(5),
                    color: Color(0xffffffff),
                    height: (SizeConfig.screenHeight / 2) / 4,
                    child: Image.asset('assets/icons/frontpage-image7.png'),
                  ),
                ),



                Positioned(
                  left: SizeConfig.screenWidth / 7.5,
                  child: Transform.rotate(
                    angle: pi / 30,
                    child: Container(
                      padding: EdgeInsets.all(5),
                      color: Color(0xffffffff),
                      height: (SizeConfig.screenHeight / 2) / 4,
                      child: Image.asset('assets/icons/frontpage-image3.png'),
                    ),
                  ),
                ),
                Positioned(
                  top: (SizeConfig.screenHeight / 2) / 4,
                  left: SizeConfig.screenWidth / 7.5,
                  child: Transform.rotate(
                    angle: 0,
                    child: Container(
                      padding: EdgeInsets.all(5),
                      color: Color(0xffffffff),
                      height: (SizeConfig.screenHeight / 2) / 4,
                      child: Image.asset('assets/icons/frontpage-image7.png'),
                    ),
                  ),
                ),
                Positioned(
                  bottom: (SizeConfig.screenHeight / 2) / 4,
                  left: SizeConfig.screenWidth / 7.5,
                  child: Transform.rotate(
                    angle: pi / 30,
                    child: Container(
                      padding: EdgeInsets.all(5),
                      color: Color(0xffffffff),
                      height: (SizeConfig.screenHeight / 2) / 4,
                      child: Image.asset('assets/icons/frontpage-image4.png'),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: SizeConfig.screenWidth / 7.5,
                  child: Transform.rotate(
                    angle: -pi / 80,
                    child: Container(
                      padding: EdgeInsets.all(5),
                      color: Color(0xffffffff),
                      height: (SizeConfig.screenHeight / 2) / 4,
                      child: Image.asset('assets/icons/frontpage-image5.png'),
                    ),
                  ),
                ),



                Positioned(
                  left: SizeConfig.screenWidth / 3.5,
                  child: Transform.rotate(
                    angle: -pi / 30,
                    child: Container(
                      padding: EdgeInsets.all(5),
                      color: Color(0xffffffff),
                      height: (SizeConfig.screenHeight / 2) / 4,
                      child: Image.asset('assets/icons/frontpage-image7.png'),
                    ),
                  ),
                ),
                Positioned(
                  top: (SizeConfig.screenHeight / 2) / 4,
                  left: SizeConfig.screenWidth / 3.5,
                  child: Transform.rotate(
                    angle: 0,
                    child: Container(
                      padding: EdgeInsets.all(5),
                      color: Color(0xffffffff),
                      height: (SizeConfig.screenHeight / 2) / 4,
                      child: Image.asset('assets/icons/frontpage-image5.png'),
                    ),
                  ),
                ),
                Positioned(
                  bottom: (SizeConfig.screenHeight / 2) / 4,
                  left: SizeConfig.screenWidth / 3.5,
                  child: Transform.rotate(
                    angle: pi / 30,
                    child: Container(
                      padding: EdgeInsets.all(5),
                      color: Color(0xffffffff),
                      height: (SizeConfig.screenHeight / 2) / 4,
                      child: Image.asset('assets/icons/frontpage-image3.png'),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: SizeConfig.screenWidth / 3.5,
                  child: Transform.rotate(
                    angle: pi / 45,
                    child: Container(
                      padding: EdgeInsets.all(5),
                      color: Color(0xffffffff),
                      height: (SizeConfig.screenHeight / 2) / 4,
                      child: Image.asset('assets/icons/frontpage-image4.png'),
                    ),
                  ),
                ),



                Positioned(
                  right: SizeConfig.screenWidth / 3,
                  child: Transform.rotate(
                    angle: -pi / 30,
                    child: Container(
                      padding: EdgeInsets.all(5),
                      color: Color(0xffffffff),
                      height: (SizeConfig.screenHeight / 2) / 4,
                      child: Image.asset('assets/icons/frontpage-image4.png'),
                    ),
                  ),
                ),
                Positioned(
                  top: (SizeConfig.screenHeight / 2) / 4,
                  right: SizeConfig.screenWidth / 3,
                  child: Transform.rotate(
                    angle: 0,
                    child: Container(
                      padding: EdgeInsets.all(5),
                      color: Color(0xffffffff),
                      height: (SizeConfig.screenHeight / 2) / 4,
                      child: Image.asset('assets/icons/frontpage-image7.png'),
                    ),
                  ),
                ),
                Positioned(
                  bottom: (SizeConfig.screenHeight / 2) / 4,
                  right: SizeConfig.screenWidth / 3,
                  child: Transform.rotate(
                    angle: pi / 30,
                    child: Container(
                      padding: EdgeInsets.all(5),
                      color: Color(0xffffffff),
                      height: (SizeConfig.screenHeight / 2) / 4,
                      child: Image.asset('assets/icons/frontpage-image5.png'),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: SizeConfig.screenWidth / 3,
                  child: Transform.rotate(
                    angle: pi / 50,
                    child: Container(
                      padding: EdgeInsets.all(5),
                      color: Color(0xffffffff),
                      height: (SizeConfig.screenHeight / 2) / 4,
                      child: Image.asset('assets/icons/frontpage-image7.png'),
                    ),
                  ),
                ),



                Positioned(
                  right: SizeConfig.screenWidth / 4.5,
                  child: Transform.rotate(
                    angle: -pi / 30,
                    child: Container(
                      padding: EdgeInsets.all(5),
                      color: Color(0xffffffff),
                      height: (SizeConfig.screenHeight / 2) / 4,
                      child: Image.asset('assets/icons/frontpage-image3.png'),
                    ),
                  ),
                ),
                Positioned(
                  top: (SizeConfig.screenHeight / 2) / 4,
                  right: SizeConfig.screenWidth / 4.5,
                  child: Transform.rotate(
                    angle: 0,
                    child: Container(
                      padding: EdgeInsets.all(5),
                      color: Color(0xffffffff),
                      height: (SizeConfig.screenHeight / 2) / 4,
                      child: Image.asset('assets/icons/frontpage-image4.png'),
                    ),
                  ),
                ),
                Positioned(
                  bottom: (SizeConfig.screenHeight / 2) / 4,
                  right: SizeConfig.screenWidth / 4.5,
                  child: Transform.rotate(
                    angle: 0,
                    child: Container(
                      padding: EdgeInsets.all(5),
                      color: Color(0xffffffff),
                      height: (SizeConfig.screenHeight / 2) / 4,
                      child: Image.asset('assets/icons/frontpage-image5.png'),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: SizeConfig.screenWidth / 4.5,
                  child: Transform.rotate(
                    angle: -pi / 50,
                    child: Container(
                      padding: EdgeInsets.all(5),
                      color: Color(0xffffffff),
                      height: (SizeConfig.screenHeight / 2) / 4,
                      child: Image.asset('assets/icons/frontpage-image7.png'),
                    ),
                  ),
                ),



                Positioned(
                  right: SizeConfig.screenWidth / 10,
                  child: Transform.rotate(
                    angle: -pi / 30,
                    child: Container(
                      padding: EdgeInsets.all(5),
                      color: Color(0xffffffff),
                      height: (SizeConfig.screenHeight / 2) / 4,
                      child: Image.asset('assets/icons/frontpage-image7.png'),
                    ),
                  ),
                ),
                Positioned(
                  top: (SizeConfig.screenHeight / 2) / 4,
                  right: SizeConfig.screenWidth / 10,
                  child: Transform.rotate(
                    angle: 0,
                    child: Container(
                      padding: EdgeInsets.all(5),
                      color: Color(0xffffffff),
                      height: (SizeConfig.screenHeight / 2) / 4,
                      child: Image.asset('assets/icons/frontpage-image5.png'),
                    ),
                  ),
                ),
                Positioned(
                  bottom: (SizeConfig.screenHeight / 2) / 4,
                  right: SizeConfig.screenWidth / 10,
                  child: Transform.rotate(
                    angle: -pi / 12,
                    child: Container(
                      padding: EdgeInsets.all(5),
                      color: Color(0xffffffff),
                      height: (SizeConfig.screenHeight / 2) / 4,
                      child: Image.asset('assets/icons/frontpage-image3.png'),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: SizeConfig.screenWidth / 10,
                  child: Transform.rotate(
                    angle: pi / 30,
                    child: Container(
                      padding: EdgeInsets.all(5),
                      color: Color(0xffffffff),
                      height: (SizeConfig.screenHeight / 2) / 4,
                      child: Image.asset('assets/icons/frontpage-image4.png'),
                    ),
                  ),
                ),




                Positioned(
                  right: -20,
                  child: Transform.rotate(
                    angle: 0,
                    child: Container(
                      padding: EdgeInsets.all(5),
                      color: Color(0xffffffff),
                      height: (SizeConfig.screenHeight / 2) / 4,
                      child: Image.asset('assets/icons/frontpage-image4.png'),
                    ),
                  ),
                ),
                Positioned(
                  top: (SizeConfig.screenHeight / 2) / 4,
                  right: -20,
                  child: Transform.rotate(
                    angle: -pi / 30,
                    child: Container(
                      padding: EdgeInsets.all(5),
                      color: Color(0xffffffff),
                      height: (SizeConfig.screenHeight / 2) / 4,
                      child: Image.asset('assets/icons/frontpage-image7.png'),
                    ),
                  ),
                ),
                Positioned(
                  bottom: (SizeConfig.screenHeight / 2) / 4,
                  right: -20,
                  child: Transform.rotate(
                    angle: -pi / 12,
                    child: Container(
                      padding: EdgeInsets.all(5),
                      color: Color(0xffffffff),
                      height: (SizeConfig.screenHeight / 2) / 4,
                      child: Image.asset('assets/icons/frontpage-image4.png'),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: -20,
                  child: Transform.rotate(
                    angle: 0,
                    child: Container(
                      padding: EdgeInsets.all(5),
                      color: Color(0xffffffff),
                      height: (SizeConfig.screenHeight / 2) / 4,
                      child: Image.asset('assets/icons/frontpage-image5.png'),
                    ),
                  ),
                ),



              ],
            ),
          ),

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