import 'package:facesbyplaces/Configurations/size_configuration.dart';
// import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

class MiscBLMImageDisplayTemplate extends StatelessWidget{

  final String image;

  MiscBLMImageDisplayTemplate({this.image = 'assets/icons/blm-image2.png'});

  @override
  Widget build(BuildContext context){
    SizeConfig.init(context);
    return LayoutBuilder(
      builder: (_, BoxConstraints constraints) {
        ScreenUtil.init(
          context: _,
          constraints: constraints,
          designSize: Size(360, 690),
          allowFontScaling: false,
        );
        return Container(
          // height: ScreenUtil().setHeight(100),
          // width: ScreenUtil().setWidth(100),
          // height: 100,
          // width: 100,
          // height: 120,
          // width: 120,
          // width: SizeConfig.safeBlockHorizontal * 10,
          // height: SizeConfig.safeBlockVertical * 10,
          // width: SizeConfig.blockSizeVertical * 15,
          // height: SizeConfig.blockSizeVertical * 15,
          // height: 50.w,
          // width: 50.w,
          // height: 100.w,
          // width: 100.w,
          height: 150.w,
          width: 150.w,
          color: Color(0xffF4F3EB),
          child: Padding(
            padding: EdgeInsets.all(5.0),
            child: Transform.rotate(
              angle: 25,
              child: Image.asset(image),
            ),
          ),
        );
      }
    );
  }
}

class MiscBLMImageDisplayFeedTemplate extends StatelessWidget{

  final String image;
  final double backSize;
  final double frontSize;
  final Color backgroundColor;

  MiscBLMImageDisplayFeedTemplate({
    this.image = 'assets/icons/app-icon.png',
    this.backSize = 20,
    this.frontSize = 15,
    this.backgroundColor = const Color(0xff000000),
  });

  @override
  Widget build(BuildContext context){
    SizeConfig.init(context);
    return CircleAvatar(
      radius: backSize,
      backgroundColor: backgroundColor,
      child: CircleAvatar(
        radius: frontSize,
        backgroundColor: Colors.transparent,
        backgroundImage: AssetImage(image),
      ),
    );
  }
}