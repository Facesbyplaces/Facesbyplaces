import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-07-regular-button.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-08-regular-background.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

class RegularJoin extends StatelessWidget {

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
            child: Container(
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
                              size: 30.h,
                            ),
                          ),
                        ),

                        Expanded(child: Container(),),

                        Container(child: Image.asset('assets/icons/logo.png', height: 150.h, width: 150.h,),),

                        Expanded(child: Container(),),
                        
                        Center(child: Text('All Lives Matter', style: TextStyle(fontSize: 30.ssp, fontWeight: FontWeight.bold, color: Color(0xffffffff),),),),

                        SizedBox(height: 20),

                        MiscRegularButtonTemplate(
                          buttonText: 'Next', 
                          buttonTextStyle: TextStyle(
                            fontSize: 14.ssp,
                            fontWeight: FontWeight.bold, 
                            color: Color(0xffffffff),
                          ), 
                          onPressed: (){
                            Navigator.pushNamed(context, '/regular/login');
                          }, 
                          width: 150.h,
                          height: 45.h,
                          // width: SizeConfig.screenWidth / 2, 
                          // height: 45,
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
      ),
    );
  }
}