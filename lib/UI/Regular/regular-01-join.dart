import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-07-regular-button.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-08-regular-background.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:flutter/material.dart';

class RegularJoin extends StatelessWidget {

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

          MiscRegularBackgroundTemplate(),

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
              child: Padding(
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                child: Column(
                  children: [

                    SizedBox(height: ScreenUtil().setHeight(10)),
                    
                    Align(alignment: Alignment.centerLeft, child: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back, color: Color(0xff000000), size: ScreenUtil().setHeight(30),),),),

                    Expanded(child: Container(),),

                    Container(child: Image.asset('assets/icons/logo.png', height: ScreenUtil().setWidth(150), width: ScreenUtil().setWidth(150),),),

                    Expanded(child: Container(),),
                    
                    Center(child: Text('All Lives Matter', style: TextStyle(fontSize: ScreenUtil().setSp(30, allowFontScalingSelf: true), fontWeight: FontWeight.bold, color: Color(0xffffffff),),),),

                    SizedBox(height: ScreenUtil().setHeight(20)),

                    MiscRegularButtonTemplate(
                      buttonText: 'Next', 
                      buttonTextStyle: TextStyle(
                        fontSize: ScreenUtil().setSp(14, allowFontScalingSelf: true),
                        fontWeight: FontWeight.bold, 
                        color: Color(0xffffffff),
                      ), 
                      onPressed: (){
                        Navigator.pushNamed(context, '/regular/login');
                      }, 
                      width: ScreenUtil().setWidth(200),
                      height: ScreenUtil().setHeight(45),
                      buttonColor: Color(0xff04ECFF),
                    ),

                    Expanded(child: Container(),),

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