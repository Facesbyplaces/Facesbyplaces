import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'Miscellaneous/Start/misc-01-start-button.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class UILogin01 extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      body: LayoutBuilder(
        builder: (_, BoxConstraints constraints) {
          ScreenUtil.init(
            context: _,
            constraints: constraints,
            designSize: Size(360, 690),
            allowFontScaling: false,
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
            child: Padding(
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              child: Container(
                height: SizeConfig.screenHeight,
                child: Column(
                  children: [

                    Expanded(child: Container(),),

                    Container(child: Image.asset('assets/icons/logo.png', height: 150.h, width: 150.h,),),

                    Center(child: Text('FacesByPlaces.com', style: TextStyle(fontSize: 18.ssp, fontWeight: FontWeight.bold, color: Color(0xff000000),),),),

                    Expanded(child: Container(),),

                    Center(child: Text('Honor, Respect, Never Forget', textAlign: TextAlign.center, style: TextStyle(fontSize: 18.ssp, fontWeight: FontWeight.bold, color: Color(0xff000000),),),),

                    Expanded(child: Container(),),

                    Center(child: Text('Black Lives Matter', style: TextStyle(fontSize: 18.ssp, color: Color(0xff000000),),),),

                    SizedBox(height: 5),

                    MiscStartButtonIconTemplate(
                      buttonText: 'Speak for a loved one killed by law enforcement', 
                      onPressed: (){
                        Navigator.pushNamed(context, '/blm/join');
                      },
                      width: SizeConfig.screenWidth / 1.5,
                      buttonTextStyle: TextStyle(fontSize: 14.ssp, fontWeight: FontWeight.w300, color: Color(0xff000000),),
                      // height: 35.h,
                      // height: 40.h,
                      buttonColor: Color(0xffF2F2F2),
                      image: Container(height: 20.h, child: Image.asset('assets/icons/fist.png'),),
                      // image: 'assets/icons/fist.png',
                      // image:               Align(
                      //   alignment: Alignment.centerLeft,
                      //   child: CircleAvatar(
                      //     // radius: 30,
                      //     // minRadius: 20.w,
                      //     // minRadius: 1.w,
                      //     backgroundColor: backgroundColor,
                      //     child: Center(child: image,),
                      //   ),
                      // ),
                    ),

                    SizedBox(height: 10.h),

                    Center(child: Text('All Lives Matter', style: TextStyle(fontSize: 18.ssp, color: Color(0xff000000),),),),

                    SizedBox(height: 5.h),

                    MiscStartButtonIconTemplate(
                      buttonText: 'Remembering friends and family', 
                      onPressed: (){
                        Navigator.pushNamed(context, '/regular/join');
                      },
                      width: SizeConfig.screenWidth / 1.5,
                      buttonTextStyle: TextStyle(fontSize: 14.ssp, fontWeight: FontWeight.w300, color: Color(0xff000000),),
                      height: 35.h,
                      buttonColor: Color(0xffE6FDFF),
                      backgroundColor: Color(0xff04ECFF),
                      image: Icon(Icons.favorite, size: 20.h, color: Color(0xffffffff),),
                      // image: 'assets/icons/fist.png',
                    ),
                    
                    SizedBox(height: 5),

                    RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Already have an account? ', 
                            style: TextStyle(
                              fontSize: 16.ssp,
                              color: Color(0xff000000),
                            ),
                          ),

                          TextSpan(
                            text: 'Login', 
                            style: TextStyle(
                              fontSize: 16.ssp,
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

                    Expanded(child: Container(),),

                  ],
                ),
              ),
            ),
          );
        }
      ),
    );
  }
}