import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-07-blm-button.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-08-blm-background.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

class BLMJoin extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      body: LayoutBuilder(
        builder: (_, BoxConstraints constraints) {
          ScreenUtil.init(
            context: _,
            constraints: constraints,
            designSize: Size(SizeConfig.screenWidth, SizeConfig.screenHeight),
            allowFontScaling: true,
          );
          return ResponsiveWrapper(
            maxWidth: SizeConfig.screenWidth,
            defaultScale: true,
            breakpoints: [
              ResponsiveBreakpoint.resize(480, name: MOBILE),
              ResponsiveBreakpoint.autoScale(800, name: TABLET),
              ResponsiveBreakpoint.resize(1000, name: DESKTOP),
              ResponsiveBreakpoint.autoScale(2460, name: '4K'),
            ],
            child: Container(
              height: SizeConfig.screenHeight,
              child: Stack(
                children: [

                  MiscBLMBackgroundTemplate(image: AssetImage('assets/icons/background2.png'),),

                  SingleChildScrollView(
                    physics: ClampingScrollPhysics(),
                    child: Padding(
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
                              icon: Icon(Icons.arrow_back, color: Color(0xff000000), size: 30),
                            ),
                          ),

                          SizedBox(height: 10),

                          Container(
                            height: 45,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Center(
                                    child: Text('BLACK',
                                      style: TextStyle(
                                        fontSize: 24.ssp,
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
                                        fontSize: 24.ssp,
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
                                        fontSize: 24.ssp,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff000000),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 50,),

                          Container(
                            // color: Colors.red,
                            // width: (SizeConfig.screenWidth / 1.2).h,
                            width: 500,
                            // height: (SizeConfig.screenWidth / 1.2).h,
                            height: 500,
                            child: Stack(
                              children: [

                                Positioned(
                                  top: 25,
                                  child: Transform.rotate(
                                    angle: 75,
                                    child: Container(
                                      height: 150,
                                      width: 150,
                                      color: Color(0xffF4F3EB),
                                      child: Padding(
                                        padding: EdgeInsets.all(5.0),
                                        child: Transform.rotate(
                                          angle: 25,
                                          child: Image.asset('assets/icons/blm-image2.png'),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                Positioned(
                                  // top: ((SizeConfig.screenWidth / 1.2).h) / 7.5,
                                  // left: ((SizeConfig.screenWidth / 1.2).h) / 3.5,
                                  left: 200,
                                  // left: ((SizeConfig.screenWidth / 1.2).h) / 2,
                                  child: Transform.rotate(
                                    angle: 101, 
                                    child: Container(
                                      height: 150,
                                      width: 150,
                                      color: Color(0xffF4F3EB),
                                      child: Padding(
                                        padding: EdgeInsets.all(5.0),
                                        child: Transform.rotate(
                                          angle: 25,
                                          child: Image.asset('assets/icons/blm-image2.png'),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                Positioned(
                                  top: 100,
                                  right: 0,
                                  child: Transform.rotate(
                                    angle: 101, 
                                    child: Container(
                                      height: 150,
                                      width: 150,
                                      color: Color(0xffF4F3EB),
                                      child: Padding(
                                        padding: EdgeInsets.all(5.0),
                                        child: Transform.rotate(
                                          angle: 25,
                                          child: Image.asset('assets/icons/blm-image2.png'),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                Positioned(
                                  // top: ((SizeConfig.screenWidth / 1.2).h) / 3.5,
                                  top: 200,
                                  child: Transform.rotate(
                                    angle: 101, 
                                    child: Container(
                                      height: 150,
                                      width: 150,
                                      color: Color(0xffF4F3EB),
                                      child: Padding(
                                        padding: EdgeInsets.all(5.0),
                                        child: Transform.rotate(
                                          angle: 25,
                                          child: Image.asset('assets/icons/blm-image2.png'),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                // Positioned(
                                //   top: ((SizeConfig.screenWidth / 1.2).h) / 3.5,
                                //   child: Transform.rotate(
                                //     angle: 101, 
                                //     child: Container(
                                //       height: 150.h,
                                //       width: 150.h,
                                //       color: Color(0xffF4F3EB),
                                //       child: Padding(
                                //         padding: EdgeInsets.all(5.0),
                                //         child: Transform.rotate(
                                //           angle: 25,
                                //           child: Image.asset('assets/icons/blm-image2.png'),
                                //         ),
                                //       ),
                                //     ),
                                //   ),
                                // ),

                                Positioned(
                                  // top: ((SizeConfig.screenWidth / 1.2).h) / 3.5,
                                  top: 200,
                                  right: 0,
                                  child: Container(
                                    height: 150,
                                    width: 150,
                                    color: Color(0xffF4F3EB),
                                    child: Padding(
                                      padding: EdgeInsets.all(5.0),
                                      child: Transform.rotate(
                                        angle: 25,
                                        child: Image.asset('assets/icons/blm-image2.png'),
                                      ),
                                    ),
                                  ),
                                ),

                                Positioned(
                                  bottom: 0,
                                  child: Container(
                                    height: 150,
                                    width: 150,
                                    color: Color(0xffF4F3EB),
                                    child: Padding(
                                      padding: EdgeInsets.all(5.0),
                                      child: Transform.rotate(
                                        angle: 25,
                                        child: Image.asset('assets/icons/blm-image2.png'),
                                      ),
                                    ),
                                  ),
                                ),

                                Positioned(
                                  bottom: 0,
                                  // left: ((SizeConfig.screenWidth / 1.2).h) / 3.5,
                                  left: 150,
                                  child: Transform.rotate(
                                    angle: 101, 
                                    child: Container(
                                      height: 150,
                                      width: 150,
                                      color: Color(0xffF4F3EB),
                                      child: Padding(
                                        padding: EdgeInsets.all(5.0),
                                        child: Transform.rotate(
                                          angle: 25,
                                          child: Image.asset('assets/icons/blm-image2.png'),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Transform.rotate(
                                    angle: 101, 
                                    child: Container(
                                      height: 150,
                                      width: 150,
                                      color: Color(0xffF4F3EB),
                                      child: Padding(
                                        padding: EdgeInsets.all(5.0),
                                        child: Transform.rotate(
                                          angle: 25,
                                          child: Image.asset('assets/icons/blm-image2.png'),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                Center(child: Image.asset('assets/icons/logo.png', height: 200, width: 200,),),                                

                              ],
                            ),
                          ),

                          // Container(
                          //   width: (SizeConfig.screenWidth / 1.2),
                          //   height: (SizeConfig.screenWidth / 1.2),
                          //   // width: (SizeConfig.screenWidth / 1.5),
                          //   // height: (SizeConfig.screenWidth / 1.5),
                          //   child: Stack(
                          //     children: [
                          //       Transform.rotate(angle: 75, child: MiscBLMImageDisplayTemplate(),),

                          //       Positioned(left: SizeConfig.screenWidth / 3.5, child: Transform.rotate(angle: 101, child: MiscBLMImageDisplayTemplate(),),),

                          //       Positioned(right: 20, child: Transform.rotate(angle: 101, child: MiscBLMImageDisplayTemplate(),),),

                          //       Positioned(right: 20, child: Transform.rotate(angle: 101, child: MiscBLMImageDisplayTemplate(),),),

                          //       Positioned(top: (SizeConfig.screenWidth / 1.5) / 2.5, child: Transform.rotate(angle: 101, child: MiscBLMImageDisplayTemplate(),),),

                          //       Positioned(top: (SizeConfig.screenWidth / 1.5) / 2.5, right: 0, child: MiscBLMImageDisplayTemplate(),),

                          //       Positioned(bottom: 0, left: 0, child: Transform.rotate(angle: 0, child: MiscBLMImageDisplayTemplate(),),),

                          //       Positioned(bottom: 0, left: SizeConfig.screenWidth / 3.5, child: Transform.rotate(angle: 101, child: MiscBLMImageDisplayTemplate(),),),

                          //       Positioned(right: 10, bottom: 0, child: Transform.rotate(angle: 101, child: MiscBLMImageDisplayTemplate(),),),

                          //       // Center(child: Image.asset('assets/icons/logo.png', height: 150, width: 150,),),
                          //       Center(child: Image.asset('assets/icons/logo.png', height: SizeConfig.safeBlockVertical * 20, width: SizeConfig.safeBlockVertical * 20,),),
                                
                          //     ],
                          //   ),
                          // ),

                          SizedBox(height: 50,),
                          // Expanded(child: Container(),),

                          Center(child: Text('Remembering the Victims', style: TextStyle(fontSize: 18.ssp, fontWeight: FontWeight.bold, color: Color(0xff000000),),),),

                          SizedBox(height: SizeConfig.blockSizeVertical * 5,),
                      
                          MiscBLMButtonTemplate(
                            buttonText: 'Join', 
                            buttonTextStyle: TextStyle(
                              fontSize: 16.ssp,
                              fontWeight: FontWeight.bold, 
                              color: Color(0xffffffff),
                            ), 
                            onPressed: (){
                              Navigator.pushNamed(context, '/blm/login');
                            }, 
                            width: SizeConfig.screenWidth / 2, 
                            height: 45,
                            buttonColor: Color(0xff4EC9D4),
                          ),

                          SizedBox(height: 80,),

                        ],
                      ),
                    ),
                  ),
                  
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
