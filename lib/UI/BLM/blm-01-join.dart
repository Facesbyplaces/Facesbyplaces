import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-07-blm-button.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-08-blm-background.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-10-blm-image-display.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter/material.dart';
import 'package:responsive_widgets/responsive_widgets.dart';

class BLMJoin extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    ResponsiveWidgets.init(context,
      height: SizeConfig.screenHeight,
      width: SizeConfig.screenWidth,
    );
    return Scaffold(
      body: Stack(
        children: [

          MiscBLMBackgroundTemplate(image: AssetImage('assets/icons/background2.png'),),

          ContainerResponsive(
            height: SizeConfig.screenHeight,
            width: SizeConfig.screenWidth,
            alignment: Alignment.center,
            child: ContainerResponsive(
              padding: EdgeInsetsResponsive.only(left: 10.0, right: 10.0),
              width: SizeConfig.screenWidth,
              heightResponsive: false,
              widthResponsive: true,
              alignment: Alignment.center,
              // child: Padding(
              //   padding: EdgeInsets.only(left: 20.0, right: 20.0),
              //   child: 
              // ),
              child: SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                child: Column(
                  children: [

                    // SizedBox(height: SizeConfig.blockSizeVertical * 2,),
                    SizedBox(height: ScreenUtil().setHeight(10)),

                    Align(
                      alignment: Alignment.centerLeft, 
                      child: IconButton(
                        onPressed: (){
                          Navigator.pop(context);
                        }, 
                        icon: Icon(Icons.arrow_back, color: Color(0xff000000), size: ScreenUtil().setHeight(30),),
                      ),
                    ),

                    // SizedBox(height: SizeConfig.blockSizeVertical * 3,),
                    SizedBox(height: ScreenUtil().setHeight(10)),

                    Container(
                      // height: SizeConfig.blockSizeVertical * 7,
                      // padding: EdgeInsets.only(left: 20.0, right: 20.0),
                      height: ScreenUtil().setHeight(45),
                      child: Row(
                        children: [
                          Expanded(
                            child: Center(
                              child: Text('BLACK',
                                style: TextStyle(
                                  // fontSize: SizeConfig.safeBlockHorizontal * 6,
                                  fontSize: ScreenUtil().setSp(24, allowFontScalingSelf: true),
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff000000),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              child: Text('LIVES',
                                style: TextStyle(
                                  // fontSize: SizeConfig.safeBlockHorizontal * 6,
                                  fontSize: ScreenUtil().setSp(24, allowFontScalingSelf: true),
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xffffffff),
                                ),
                              ),
                              decoration: BoxDecoration(
                                color: Color(0xff000000),
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Text('MATTER',
                                style: TextStyle(
                                  // fontSize: SizeConfig.safeBlockHorizontal * 6,
                                  fontSize: ScreenUtil().setSp(24, allowFontScalingSelf: true),
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff000000),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // SizedBox(height: SizeConfig.blockSizeVertical * 10,),

                    SizedBox(height: ScreenUtil().setHeight(50)),

                    ContainerResponsive(
                      // height: SizeConfig.screenHeight / 2,
                      // height: SizeConfig.screenHeight / 2,
                      // height: ScreenUtil().setHeight(),
                      width: SizeConfig.screenWidth,
                      height: SizeConfig.screenHeight / 2,
                      heightResponsive: false,
                      widthResponsive: true,
                      // Center(child: Image.asset('assets/icons/logo.png', height: ScreenUtil().setHeight(150), width: ScreenUtil().setWidth(150),),),
                      child: Stack(
                        children: [
                          Transform.rotate(angle: 75, child: MiscBLMImageDisplayTemplate(),),

                          Positioned(left: SizeConfig.blockSizeHorizontal * 30, child: Transform.rotate(angle: 101, child: MiscBLMImageDisplayTemplate(),),),

                          Positioned(right: 20, child: Transform.rotate(angle: 101, child: MiscBLMImageDisplayTemplate(),),),

                          Positioned(right: 20, child: Transform.rotate(angle: 101, child: MiscBLMImageDisplayTemplate(),),),

                          Positioned(top: SizeConfig.blockSizeHorizontal * 25, child: Transform.rotate(angle: 101, child: MiscBLMImageDisplayTemplate(),),),

                          Positioned(top: SizeConfig.blockSizeHorizontal * 25, right: 0, child: MiscBLMImageDisplayTemplate(),),

                          Positioned(bottom: 0, left: 0, child: Transform.rotate(angle: 0, child: MiscBLMImageDisplayTemplate(),),),

                          Positioned(bottom: 0, left: SizeConfig.blockSizeHorizontal * 30, child: Transform.rotate(angle: 101, child: MiscBLMImageDisplayTemplate(),),),

                          Positioned(right: 10, bottom: 0, child: Transform.rotate(angle: 101, child: MiscBLMImageDisplayTemplate(),),),

                          // Center(child: Image.asset('assets/icons/logo.png', height: SizeConfig.blockSizeVertical * 40, width: SizeConfig.blockSizeVertical * 20,),),
                          Center(child: Image.asset('assets/icons/logo.png', height: ScreenUtil().setHeight(150), width: ScreenUtil().setWidth(150),),),
                          

                        ],
                      ),
                    ),


                    // SizedBox(height: SizeConfig.blockSizeVertical * 5,),
                    SizedBox(height: ScreenUtil().setHeight(25)),

                    // Expanded(child: Container(),),

                    Center(child: Text('Remembering the Victims', style: TextStyle(fontSize: ScreenUtil().setSp(18, allowFontScalingSelf: true), fontWeight: FontWeight.bold, color: Color(0xff000000),),),),

                    SizedBox(height: SizeConfig.blockSizeVertical * 5,),
                
                    MiscBLMButtonTemplate(
                      buttonText: 'Join', 
                      buttonTextStyle: TextStyle(
                        // fontSize: SizeConfig.safeBlockHorizontal * 5,
                        fontSize: ScreenUtil().setSp(16, allowFontScalingSelf: true),
                        fontWeight: FontWeight.bold, 
                        color: Color(0xffffffff),
                      ), 
                      onPressed: (){
                        Navigator.pushNamed(context, '/blm/login');
                      }, 
                      width: SizeConfig.screenWidth / 2, 
                      height: ScreenUtil().setHeight(45),
                      buttonColor: Color(0xff4EC9D4),
                    ),

                    // Expanded(child: Container(),),

                  ],
                ),
              ),
            ),
          ),

          
        ],
      ),
    );
  }
}