import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'Miscellaneous/Start/misc-01-start-button.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class UILogin01 extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    ResponsiveWidgets.init(context,
      height: SizeConfig.screenHeight,
      width: SizeConfig.screenWidth,
    );
    return ResponsiveWidgets.builder(
      allowFontScaling: true,
      child: Scaffold(
        body: ContainerResponsive(
          height: SizeConfig.screenHeight,
          width: SizeConfig.screenWidth,
          alignment: Alignment.center,
          child: ContainerResponsive(
            padding: EdgeInsetsResponsive.only(left: 10.0, right: 10.0),
            width: SizeConfig.screenHeight,
            heightResponsive: false,
            widthResponsive: true,
            alignment: Alignment.center,
            child: Column(
              children: [

                Expanded(child: Container(),),

                Container(child: Image.asset('assets/icons/logo.png', height: ScreenUtil().setWidth(150), width: ScreenUtil().setWidth(150),),),

                SizedBox(height: ScreenUtil().setHeight(5)),

                Center(child: Text('FacesByPlaces.com', style: TextStyle(fontSize: ScreenUtil().setSp(18, allowFontScalingSelf: false), fontWeight: FontWeight.bold, color: Color(0xff000000),),),),

                SizedBox(height: ScreenUtil().setHeight(5)),

                Expanded(child: Container(),),

                Center(child: Text('Honor, Respect, Never Forget', textAlign: TextAlign.center, style: TextStyle(fontSize: ScreenUtil().setSp(18, allowFontScalingSelf: false), fontWeight: FontWeight.bold, color: Color(0xff000000),),),),

                SizedBox(height: ScreenUtil().setHeight(5)),

                Expanded(child: Container(),),

                Center(child: Text('Black Lives Matter', style: TextStyle(fontSize: ScreenUtil().setSp(16, allowFontScalingSelf: false), color: Color(0xff000000),),),),

                SizedBox(height: ScreenUtil().setHeight(2)),

                MiscStartButtonIconTemplate(
                  buttonText: 'Speak for a loved one killed by law enforcement', 
                  onPressed: (){Navigator.pushNamed(context, '/blm/join');},
                  width: SizeConfig.screenWidth / 1.5,
                  buttonTextStyle: TextStyle(fontSize: ScreenUtil().setSp(14, allowFontScalingSelf: true), fontWeight: FontWeight.w300, color: Color(0xff000000),),
                  height: ScreenUtil().setHeight(30),
                  buttonColor: Color(0xffF2F2F2),
                  image: Container(height: 30.h, child: Image.asset('assets/icons/fist.png'),),
                ),

                SizedBox(height: ScreenUtil().setHeight(5)),

                Center(child: Text('All Lives Matter', style: TextStyle(fontSize: ScreenUtil().setSp(16, allowFontScalingSelf: false), color: Color(0xff000000),),),),

                SizedBox(height: ScreenUtil().setHeight(2)),

                MiscStartButtonIconTemplate(
                  buttonText: 'Remembering friends and family', 
                  onPressed: (){Navigator.pushNamed(context, '/regular/join');},
                  width: SizeConfig.screenWidth / 1.5,
                  buttonTextStyle: TextStyle(fontSize: ScreenUtil().setSp(14, allowFontScalingSelf: true), fontWeight: FontWeight.w300, color: Color(0xff000000),),
                  height: ScreenUtil().setHeight(30),
                  buttonColor: Color(0xffE6FDFF),
                  backgroundColor: Color(0xff04ECFF),
                  image: Icon(Icons.favorite, size: 30.h, color: Color(0xffffffff),),
                ),
                
                SizedBox(height: ScreenUtil().setHeight(5)),

                RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Already have an account? ', 
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(14, allowFontScalingSelf: true),
                          color: Color(0xff000000),
                        ),
                      ),

                      TextSpan(
                        text: 'Login', 
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(14, allowFontScalingSelf: true),
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
      ),
    );
  }
}