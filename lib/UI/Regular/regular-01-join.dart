import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/UI/Miscellaneous/misc-07-button.dart';
import 'package:facesbyplaces/UI/Miscellaneous/misc-08-background.dart';
import 'package:flutter/material.dart';

class RegularJoin extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      body: Stack(
        children: [

          MiscBackgroundTemplate(),

          Padding(
            padding: EdgeInsets.only(left: 20.0, right: 20.0),
            child: Column(
              children: [

                SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                Align(alignment: Alignment.centerLeft, child: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back, color: Color(0xff000000), size: SizeConfig.blockSizeVertical * 5),),),

                Center(child: Image.asset('assets/icons/logo.png', height: SizeConfig.blockSizeVertical * 40, width: SizeConfig.blockSizeVertical * 20,),),

                SizedBox(height: SizeConfig.blockSizeVertical * 25,),

                Center(child: Text('All Lives Matter', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 8, fontWeight: FontWeight.bold, color: Color(0xffffffff),),),),

                SizedBox(height: SizeConfig.blockSizeVertical * 5,),

                MiscButtonTemplate(buttonText: 'Next', buttonTextStyle: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 5, fontWeight: FontWeight.bold, color: Color(0xffffffff),), onPressed: (){Navigator.pushNamed(context, 'regular/regular-02-login');}, width: SizeConfig.screenWidth / 2, height: SizeConfig.blockSizeVertical * 8, buttonColor: Color(0xff04ECFF),),

              ],
            ),
          ),
        ],
      ),
    );
  }
}