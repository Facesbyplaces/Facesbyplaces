import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-13-regular-post.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-17-regular-custom-drawings.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter/material.dart';

class HomeRegularUserProfileDetails extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      body: Stack(
        children: [

          Container(height: SizeConfig.screenHeight, color: Color(0xffECF0F1),),

          Container(
            height: SizeConfig.screenHeight / 2.5,
            child: Stack(
              children: [

                CustomPaint(size: Size.infinite, painter: MiscRegularCurvePainter(),),

                Positioned(
                  top: SizeConfig.blockSizeVertical * 8,
                  left: SizeConfig.screenWidth / 4.2,
                  child: CircleAvatar(
                    radius: SizeConfig.blockSizeVertical * 15,
                    backgroundImage: AssetImage('assets/icons/profile2.png'),
                  ),
                ),
              ],
            ),
          ),

          Container(
            height: Size.fromHeight(AppBar().preferredSize.height).height + (Size.fromHeight(AppBar().preferredSize.height).height / 2),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 10.0),
                    alignment: Alignment.centerLeft,
                      child: IconButton(
                      onPressed: (){
                        Navigator.of(context).pushNamedAndRemoveUntil('home/regular/home-14-regular-user-profile', ModalRoute.withName('/home/regular/home-06-regular-post'));
                      },
                      icon: Icon(Icons.arrow_back, color: Color(0xffffffff), size: SizeConfig.blockSizeVertical * 5,), 
                    ),
                  ),
                ),
                Expanded(
                  child: Container(),
                ),
              ],
            ),
          ),

          Positioned(
            top: SizeConfig.screenHeight / 2.5,
            child: Container(
              width: SizeConfig.screenWidth,
              child: Column(
                children: [
                  Center(
                    child: Text('Sara Rosario Suarez',
                      style: TextStyle(
                        fontSize: SizeConfig.safeBlockHorizontal * 5,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff000000),
                      ),
                    ),
                  ),

                  SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                  Center(
                    child: Text('+sara1980',
                      style: TextStyle(
                        fontSize: SizeConfig.safeBlockHorizontal * 4,
                        fontWeight: FontWeight.w300,
                        color: Color(0xff000000),
                      ),
                    ),
                  ),

                  SizedBox(height: SizeConfig.blockSizeVertical * 5,),

                  Center(
                    child: Text('About',
                      style: TextStyle(
                        fontSize: SizeConfig.safeBlockHorizontal * 4,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff04ECFF),
                      ),
                    ),
                  ),

                  SizedBox(height: SizeConfig.blockSizeVertical * 5,),

                ],
              ),
            ),
          ),

          MiscRegularUserProfileDetailsDraggable(),

        ],
      ),
    );
  }
}