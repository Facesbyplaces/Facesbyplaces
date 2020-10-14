import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter/material.dart';

class ShowDialog extends StatelessWidget{

  final String title;
  final String content;
  final Color color;

  ShowDialog({this.title , this.content, this.color});

  Widget build(BuildContext context){
    SizeConfig.init(context);
    return AlertDialog(
      title: Text(title,
        style: TextStyle(
          fontSize: SizeConfig.safeBlockHorizontal * 4,
          color: color,
        ),
      ),
      content: Text(content,
        style: TextStyle(
          fontSize: SizeConfig.safeBlockHorizontal * 4,
        ),
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: (){
            Navigator.pop(context, false);
          }, 
          child: Text("OK", 
            style: TextStyle(
              fontSize: SizeConfig.safeBlockHorizontal * 3,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}

class UploadFrom extends StatelessWidget{

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

class DeletePageDialog extends StatelessWidget{

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
                child: Text('Confirm Delete',
                  style: TextStyle(
                    fontSize: SizeConfig.safeBlockHorizontal * 5,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff000000),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Text('Are you sure you want to delete "Mark Jacksons Memorial"?',
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
                        print('Successfully deleted!');
                        Navigator.pop(context);
                      },
                      child: Text('Yes',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: SizeConfig.safeBlockHorizontal * 5,
                          fontWeight: FontWeight.bold,
                          color: Color(0xffFF0000),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: (){
                        print('Cancelled!');
                        Navigator.pop(context);
                      },
                      child: Text('No',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: SizeConfig.safeBlockHorizontal * 5,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff04ECFF),
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