import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'Miscellaneous/Start/misc-01-start-button.dart';
import 'Miscellaneous/Start/misc-02-start-background.dart';
import 'package:flutter/material.dart';

const double pi = 3.1415926535897932;

class UIGetStarted extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    ResponsiveWidgets.init(context,
      height: SizeConfig.screenHeight,
      width: SizeConfig.screenWidth,
      allowFontScaling: true,
    );
    return ResponsiveWidgets.builder(
      child: Scaffold(
        body: Stack(
          children: [

            ContainerResponsive(
              height: SizeConfig.screenHeight,
              width: SizeConfig.screenWidth,
              alignment: Alignment.center,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  MiscStartBackgroundTemplate(),

                  ContainerResponsive(
                    // width: SizeConfig.screenHeight,
                    width: SizeConfig.screenWidth,
                    heightResponsive: false,
                    widthResponsive: true,
                    alignment: Alignment.topCenter,
                    child: Stack(
                      children: [
                        ContainerResponsive(
                          // height: SizeConfig.screenHeight / 2,
                          height: SizeConfig.screenHeight / 2,
                          // height: ScreenUtil().setHeight(),
                          heightResponsive: false,
                          widthResponsive: true,
                          child: Stack(
                            children: [
                              Positioned(
                                left: 0,
                                child: Transform.rotate(
                                  angle: -pi / 30,
                                  child: Container(
                                    padding: EdgeInsets.all(5),
                                    color: Color(0xffffffff),
                                    // height: (SizeConfig.screenHeight / 2) / 4,
                                    // ScreenUtil().setWidth(540)
                                    height: ScreenUtil().setHeight(100),
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
                                    // height: (SizeConfig.screenHeight / 2) / 4,
                                    // height: ScreenUtil().setHeight(200),
                                    height: ScreenUtil().setHeight(100),
                                    child: Image.asset('assets/icons/frontpage-image4.png'),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: (SizeConfig.screenHeight / 2) / 4,
                                child: Container(
                                  padding: EdgeInsets.all(5),
                                  color: Color(0xffffffff),
                                  // height: (SizeConfig.screenHeight / 2) / 4,
                                  // height: ScreenUtil().setHeight(200),
                                  height: ScreenUtil().setHeight(100),
                                  child: Image.asset('assets/icons/frontpage-image5.png'),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                child: Container(
                                  padding: EdgeInsets.all(5),
                                  color: Color(0xffffffff),
                                  // height: (SizeConfig.screenHeight / 2) / 4,
                                  height: ScreenUtil().setHeight(100),
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
                                    // height: (SizeConfig.screenHeight / 2) / 4,
                                    height: ScreenUtil().setHeight(100),
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
                                    // height: (SizeConfig.screenHeight / 2) / 4,
                                    height: ScreenUtil().setHeight(100),
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
                                    // height: (SizeConfig.screenHeight / 2) / 4,
                                    height: ScreenUtil().setHeight(100),
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
                                    // height: (SizeConfig.screenHeight / 2) / 4,
                                    height: ScreenUtil().setHeight(100),
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
                                    // height: (SizeConfig.screenHeight / 2) / 4,
                                    height: ScreenUtil().setHeight(100),
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
                                    // height: (SizeConfig.screenHeight / 2) / 4,
                                    height: ScreenUtil().setHeight(100),
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
                                    // height: (SizeConfig.screenHeight / 2) / 4,
                                    height: ScreenUtil().setHeight(100),
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
                                    // height: (SizeConfig.screenHeight / 2) / 4,
                                    height: ScreenUtil().setHeight(100),
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
                                    // height: (SizeConfig.screenHeight / 2) / 4,
                                    height: ScreenUtil().setHeight(100),
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
                                    // height: (SizeConfig.screenHeight / 2) / 4,
                                    height: ScreenUtil().setHeight(100),
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
                                    // height: (SizeConfig.screenHeight / 2) / 4,
                                    height: ScreenUtil().setHeight(100),
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
                                    // height: (SizeConfig.screenHeight / 2) / 4,
                                    height: ScreenUtil().setHeight(100),
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
                                    // height: (SizeConfig.screenHeight / 2) / 4,
                                    height: ScreenUtil().setHeight(100),
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
                                    // height: (SizeConfig.screenHeight / 2) / 4,
                                    height: ScreenUtil().setHeight(100),
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
                                    // height: (SizeConfig.screenHeight / 2) / 4,
                                    height: ScreenUtil().setHeight(100),
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
                                    // height: (SizeConfig.screenHeight / 2) / 4,
                                    height: ScreenUtil().setHeight(100),
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
                                    // height: (SizeConfig.screenHeight / 2) / 4,
                                    height: ScreenUtil().setHeight(100),
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
                                    // height: (SizeConfig.screenHeight / 2) / 4,
                                    height: ScreenUtil().setHeight(100),
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
                                    // height: (SizeConfig.screenHeight / 2) / 4,
                                    height: ScreenUtil().setHeight(100),
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
                                    // height: (SizeConfig.screenHeight / 2) / 4,
                                    height: ScreenUtil().setHeight(100),
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
                                    // height: (SizeConfig.screenHeight / 2) / 4,
                                    height: ScreenUtil().setHeight(100),
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
                                    // height: (SizeConfig.screenHeight / 2) / 4,
                                    height: ScreenUtil().setHeight(100),
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
                                    // height: (SizeConfig.screenHeight / 2) / 4,
                                    height: ScreenUtil().setHeight(100),
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
                                    // height: (SizeConfig.screenHeight / 2) / 4,
                                    height: ScreenUtil().setHeight(100),
                                    child: Image.asset('assets/icons/frontpage-image5.png'),
                                  ),
                                ),
                              ),

                            ],
                          ),
                        ),

                        Container(
                          child: Column(
                            children: [

                              Container(
                                height: SizeConfig.screenHeight / 2,
                                child: Image.asset('assets/icons/logo.png', height: 200, width: 200,),
                              ),

                              Expanded(
                                child: Column(
                                  children: [

                                    Expanded(child: Container(),),

                                    Center(child: Text('FacesByPlaces.com', style: TextStyle(fontSize: ScreenUtil().setSp(20, allowFontScalingSelf: true), fontWeight: FontWeight.bold, color: Color(0xff04ECFF),),),),

                                    SizedBox(height: ScreenUtil().setHeight(20)),

                                    Padding(
                                      padding: EdgeInsets.only(left: 20.0, right: 20.0),
                                      child: Center(
                                        child: Text('Create a Memorial Page for Loved Ones by Sharing Stories, photos of Special Events & Occasions. Keeping their Memories alive for Generations', 
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: ScreenUtil().setSp(16, allowFontScalingSelf: true),
                                            fontFamily: 'Roboto',
                                            color: Color(0xffffffff),
                                          ),
                                        ),
                                      ),
                                    ),

                                    Expanded(child: Container(),),

                                    MiscStartButtonTemplate(
                                      buttonText: 'Get Started', 
                                      buttonTextStyle: TextStyle(
                                        fontSize: ScreenUtil().setSp(14, allowFontScalingSelf: true),
                                        fontWeight: FontWeight.bold, 
                                        color: Color(0xffffffff),
                                      ), 
                                      onPressed: (){
                                        Navigator.pushNamed(context, '/login');
                                      }, 
                                      width: ScreenUtil().setWidth(200),
                                      height: ScreenUtil().setHeight(45),
                                      buttonColor: Color(0xff04ECFF),
                                    ),

                                    Expanded(child: Container(),),

                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                      ],
                    ),
                  ),
                ],
              ),
            ),
            
          ],
        ),
      ),
    );
  }
}