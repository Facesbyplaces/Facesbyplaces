import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter/material.dart';

class MiscRegularUploadFromDialog extends StatelessWidget{

  Widget build(BuildContext context){
    SizeConfig.init(context);
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5))
      ),
      child: Container(
        height: SizeConfig.screenHeight / 4,
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text('Upload From',
              style: TextStyle(
                fontSize: SizeConfig.safeBlockHorizontal * 4,
                fontWeight: FontWeight.w200,
                color: Color(0xff000000),
              ),
            ),

            SizedBox(height: SizeConfig.blockSizeVertical * 5,),

            GestureDetector(
              onTap: (){
                Navigator.pop(context, 1);
              },
              child: Text('Camera',
                style: TextStyle(
                  fontSize: SizeConfig.safeBlockHorizontal * 4,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff000000).withOpacity(0.5),
                ),
              ),
            ),

            SizedBox(height: SizeConfig.blockSizeVertical * 5,),

            GestureDetector(
              onTap: (){
                Navigator.pop(context, 2);
              },
              child: Text('Gallery',
                style: TextStyle(
                  fontSize: SizeConfig.safeBlockHorizontal * 4,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff000000).withOpacity(0.5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class MiscRegularAlertDialog extends StatelessWidget{

  final String title;
  final String content;
  final String confirmText;
  final Color color;

  MiscRegularAlertDialog({
    this.title = '',
    this.content = '',
    this.confirmText = 'OK',
    this.color = Colors.red,
  });

  Widget build(BuildContext context){
    SizeConfig.init(context);
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5))
      ),
      child: Container(
        height: SizeConfig.screenHeight / 4,
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(title,
                  style: TextStyle(
                    fontSize: SizeConfig.safeBlockHorizontal * 5,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(content,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: SizeConfig.safeBlockHorizontal * 4,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff000000),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: (){
                  Navigator.pop(context, true);
                },
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(confirmText,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: SizeConfig.safeBlockHorizontal * 4,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
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