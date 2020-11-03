import 'package:facesbyplaces/UI/Miscellaneous/misc-07-button.dart';
import 'package:facesbyplaces/UI/Miscellaneous/misc-08-background.dart';
import 'package:facesbyplaces/UI/Miscellaneous/misc-10-image-display.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter/material.dart';

class BLMJoin extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      body: Stack(
        children: [

          MiscBackgroundTemplate(image: AssetImage('assets/icons/background2.png'),),

          Padding(
            padding: EdgeInsets.only(left: 20.0, right: 20.0),
            child: Column(
              children: [

                SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                Align(alignment: Alignment.centerLeft, child: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back, color: Color(0xff000000), size: SizeConfig.blockSizeVertical * 5),),),

                SizedBox(height: SizeConfig.blockSizeVertical * 3,),

                Container(
                  height: SizeConfig.blockSizeVertical * 7,
                  padding: EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Center(
                          child: Text('BLACK',
                            style: TextStyle(
                              fontSize: SizeConfig.safeBlockHorizontal * 6,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff000000),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          child: Text('LIVES',
                            style: TextStyle(
                              fontSize: SizeConfig.safeBlockHorizontal * 6,
                              fontWeight: FontWeight.bold,
                              color: Color(0xffffffff),
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xff000000),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text('MATTER',
                            style: TextStyle(
                              fontSize: SizeConfig.safeBlockHorizontal * 6,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff000000),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: SizeConfig.blockSizeVertical * 10,),

                Container(
                  width: SizeConfig.screenWidth,
                  child: Stack(
                    children: [
                      Transform.rotate(angle: 75, child: MiscImageDisplayTemplate(),),

                      Positioned(left: SizeConfig.blockSizeHorizontal * 30, child: Transform.rotate(angle: 101, child: MiscImageDisplayTemplate(),),),

                      Positioned(right: 20, child: Transform.rotate(angle: 101, child: MiscImageDisplayTemplate(),),),

                      Positioned(right: 20, child: Transform.rotate(angle: 101, child: MiscImageDisplayTemplate(),),),

                      Positioned(top: SizeConfig.blockSizeHorizontal * 25, child: Transform.rotate(angle: 101, child: MiscImageDisplayTemplate(),),),

                      Positioned(top: SizeConfig.blockSizeHorizontal * 25, right: 0, child: MiscImageDisplayTemplate(),),

                      Positioned(bottom: 0, left: 0, child: Transform.rotate(angle: 0, child: MiscImageDisplayTemplate(),),),

                      Positioned(bottom: 0, left: SizeConfig.blockSizeHorizontal * 30, child: Transform.rotate(angle: 101, child: MiscImageDisplayTemplate(),),),

                      Positioned(right: 10, bottom: 0, child: Transform.rotate(angle: 101, child: MiscImageDisplayTemplate(),),),

                      Center(child: Image.asset('assets/icons/logo.png', height: SizeConfig.blockSizeVertical * 40, width: SizeConfig.blockSizeVertical * 20,),),

                    ],
                  ),
                ),

                SizedBox(height: SizeConfig.blockSizeVertical * 5,),

                Center(child: Text('Remembering the Victims', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 5, fontWeight: FontWeight.bold, color: Color(0xff000000),),),),

                SizedBox(height: SizeConfig.blockSizeVertical * 5,),
            
                MiscButtonTemplate(buttonText: 'Join', buttonTextStyle: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 5, fontWeight: FontWeight.bold, color: Color(0xffffffff),), onPressed: (){Navigator.pushNamed(context, '/blm/blm-02-login');}, width: SizeConfig.screenWidth / 2, height: SizeConfig.blockSizeVertical * 7, buttonColor: Color(0xff4EC9D4),),

              ],
            ),
          ),
        ],
      ),
    );
  }
}