import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter/material.dart';

class MiscBLMUploadFromDialog extends StatelessWidget{

  final String choice_1;
  final String choice_2;

  MiscBLMUploadFromDialog({this.choice_1 = 'Camera', this.choice_2 = 'Gallery'});

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
              child: Text(choice_1,
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
              child: Text(choice_2,
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

class MiscBLMRelationshipFromDialog extends StatelessWidget{

  Widget build(BuildContext context){
    SizeConfig.init(context);
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5))
      ),
      child: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text('Choose the relationship of this person:',
            textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: SizeConfig.safeBlockHorizontal * 4,
                fontWeight: FontWeight.w200,
                color: Color(0xff000000),
              ),
            ),

            Expanded(child: Container(),),

            GestureDetector(
              onTap: (){
                Navigator.pop(context, 'Father');
              },
              child: Text('Father',
                style: TextStyle(
                  fontSize: SizeConfig.safeBlockHorizontal * 4,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff000000).withOpacity(0.5),
                ),
              ),
            ),

            SizedBox(height: SizeConfig.blockSizeVertical * 5,),

            GestureDetector(
              onTap: (){
                Navigator.pop(context, 'Mother');
              },
              child: Text('Mother',
                style: TextStyle(
                  fontSize: SizeConfig.safeBlockHorizontal * 4,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff000000).withOpacity(0.5),
                ),
              ),
            ),

            SizedBox(height: SizeConfig.blockSizeVertical * 5,),

            GestureDetector(
              onTap: (){
                Navigator.pop(context, 'Sister');
              },
              child: Text('Sister',
                style: TextStyle(
                  fontSize: SizeConfig.safeBlockHorizontal * 4,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff000000).withOpacity(0.5),
                ),
              ),
            ),

            SizedBox(height: SizeConfig.blockSizeVertical * 5,),

            GestureDetector(
              onTap: (){
                Navigator.pop(context, 'Brother');
              },
              child: Text('Brother',
                style: TextStyle(
                  fontSize: SizeConfig.safeBlockHorizontal * 4,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff000000).withOpacity(0.5),
                ),
              ),
            ),

            SizedBox(height: SizeConfig.blockSizeVertical * 5,),

            GestureDetector(
              onTap: (){
                Navigator.pop(context, 'Aunt');
              },
              child: Text('Aunt',
                style: TextStyle(
                  fontSize: SizeConfig.safeBlockHorizontal * 4,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff000000).withOpacity(0.5),
                ),
              ),
            ),

            SizedBox(height: SizeConfig.blockSizeVertical * 5,),

            GestureDetector(
              onTap: (){
                Navigator.pop(context, 'Uncle');
              },
              child: Text('Uncle',
                style: TextStyle(
                  fontSize: SizeConfig.safeBlockHorizontal * 4,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff000000).withOpacity(0.5),
                ),
              ),
            ),

            SizedBox(height: SizeConfig.blockSizeVertical * 5,),

            GestureDetector(
              onTap: (){
                Navigator.pop(context, 'Nephew');
              },
              child: Text('Nephew',
                style: TextStyle(
                  fontSize: SizeConfig.safeBlockHorizontal * 4,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff000000).withOpacity(0.5),
                ),
              ),
            ),

            SizedBox(height: SizeConfig.blockSizeVertical * 5,),

            GestureDetector(
              onTap: (){
                Navigator.pop(context, 'Grandfather');
              },
              child: Text('Grandfather',
                style: TextStyle(
                  fontSize: SizeConfig.safeBlockHorizontal * 4,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff000000).withOpacity(0.5),
                ),
              ),
            ),

            SizedBox(height: SizeConfig.blockSizeVertical * 5,),

            GestureDetector(
              onTap: (){
                Navigator.pop(context, 'Grandmother');
              },
              child: Text('Grandmother',
                style: TextStyle(
                  fontSize: SizeConfig.safeBlockHorizontal * 4,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff000000).withOpacity(0.5),
                ),
              ),
            ),

            Expanded(child: Container(),),
          ],
        ),
      ),
    );
  }
}

class MiscBLMAlertDialog extends StatelessWidget{

  final String title;
  final String content;
  final String confirmText;
  final Color color;

  MiscBLMAlertDialog({
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
            Align(
              alignment: Alignment.centerLeft,
              child: Text(title,
                style: TextStyle(
                  fontSize: SizeConfig.safeBlockHorizontal * 5,
                  fontWeight: FontWeight.bold,
                  color: color,
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
            GestureDetector(
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
          ],
        ),
      ),
    );
  }
}


class MiscBLMConfirmDialog extends StatelessWidget{

  final String title;
  final String content;
  final String confirm_1;
  final String confirm_2;
  final Color confirmColor_1;
  final Color confirmColor_2;

  MiscBLMConfirmDialog({
    this.title = 'Confirm Delete',
    this.content = 'Are you sure you want to delete "Mark Jacksons Memorial"?',
    this.confirm_1 = 'Yes',
    this.confirm_2 = 'No',
    this.confirmColor_1 = const Color(0xffFF0000),
    this.confirmColor_2 = const Color(0xff04ECFF),
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
              child: Center(
                child: Text(title,
                  style: TextStyle(
                    fontSize: SizeConfig.safeBlockHorizontal * 5,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff000000),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Text(content,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: SizeConfig.safeBlockHorizontal * 4,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff000000),
                ),
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: (){
                        Navigator.pop(context, true);
                      },
                      child: Text(confirm_1,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: SizeConfig.safeBlockHorizontal * 5,
                          fontWeight: FontWeight.bold,
                          color: confirmColor_1,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: (){
                        Navigator.pop(context, false);
                      },
                      child: Text(confirm_2,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: SizeConfig.safeBlockHorizontal * 5,
                          fontWeight: FontWeight.bold,
                          color: confirmColor_2,
                        ),
                      ),
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


