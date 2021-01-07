import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter/material.dart';

class MiscRegularSettingDetailTemplate extends StatelessWidget{

  final Function onTap;
  final String titleDetail;
  final String contentDetail;
  final Color backgroundColor;

  MiscRegularSettingDetailTemplate({
    this.onTap,
    this.titleDetail = 'Page Details',
    this.contentDetail = 'Update page details',
    this.backgroundColor = const Color(0xffffffff),
  });

  @override
  Widget build(BuildContext context){
    SizeConfig.init(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: SizeConfig.blockSizeVertical * 10,
        // color: Color(0xffffffff),
        color: backgroundColor,
        padding: EdgeInsets.only(left: 20.0, right: 20.0),
        child: Column(
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(titleDetail,
                  style: TextStyle(
                    fontSize: SizeConfig.safeBlockHorizontal * 4,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff000000),
                  ),
                ),
              ),
            ),

            Expanded(
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(contentDetail,
                  style: TextStyle(
                    fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                    fontWeight: FontWeight.w300,
                    color: Color(0xffBDC3C7),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}