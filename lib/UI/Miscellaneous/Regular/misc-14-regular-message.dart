import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter/material.dart';

class MiscRegularMessageTemplate extends StatelessWidget{

  final String message;

  MiscRegularMessageTemplate({this.message = 'Enter Verification Code'});

  @override
  Widget build(BuildContext context){
    SizeConfig.init(context);
    return Padding(
      padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 8,),
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          height: SizeConfig.blockSizeVertical * 5,
          width: SizeConfig.screenWidth / 1.2,
          child: Center(
            child: Text(message, 
              textAlign: TextAlign.center, 
              style: TextStyle(
                fontSize: SizeConfig.safeBlockHorizontal * 4,
                fontWeight: FontWeight.w300,
                color: Color(0xffffffff),
              ),
            ),
          ),
          decoration: BoxDecoration(
            color: Color(0xff000000),
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
        ),
      ),
    );
  }
}

class MiscRegularErrorMessageTemplate extends StatelessWidget{

  @override
  Widget build(BuildContext context){
    return Container(
      height: SizeConfig.screenHeight,
      child: Column(
        children: [
          Expanded(child: Container(),),

          Center(child: Icon(Icons.error_outline_rounded, color: Colors.red, size: SizeConfig.blockSizeVertical * 15,),),

          SizedBox(height: SizeConfig.blockSizeVertical * 10,),

          Center(
            child: Text('Something went wrong. Please try again.', 
            textAlign: TextAlign.center, 
              style: TextStyle(
                fontSize: SizeConfig.safeBlockHorizontal * 4, 
                color: Color(0xff000000),
              ),
            ),
          ),

          SizedBox(height: SizeConfig.blockSizeVertical * 10,),

          GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.directions_walk_rounded, color: Color(0xff000000), size: SizeConfig.blockSizeVertical * 5,),

                SizedBox(width: SizeConfig.blockSizeHorizontal * 2),

                Text('Go back'),
              ],
            ),
          ),

          Expanded(child: Container(),),
        ],
      ),
    );
  }
}