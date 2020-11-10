import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-05-blm-post.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-06-blm-custom-drawings.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

class HomeUserProfile extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      body: Stack(
        children: [

          Container(height: SizeConfig.screenHeight, color: Color(0xffffffff),),

          Container(
            height: SizeConfig.screenHeight / 2.5,
            child: Stack(
              children: [

                CustomPaint(size: Size.infinite, painter: MiscBLMCurvePainter(),),

                Container(
                  padding: EdgeInsets.only(bottom: 20.0),
                  alignment: Alignment.bottomCenter,
                  child: CircleAvatar(radius: SizeConfig.blockSizeVertical * 15, backgroundImage: AssetImage('assets/icons/profile1.png'),)
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
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back, color: Color(0xffffffff), size: SizeConfig.blockSizeVertical * 5,), 
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(right: 10.0),
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.zero,
                      onPressed: (){},
                      icon: Icon(Icons.more_vert, color: Color(0xffffffff), size: SizeConfig.blockSizeVertical * 5,),
                    ),
                  ),
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
                    child: Text('Joan Oliver',
                      style: TextStyle(
                        fontSize: SizeConfig.safeBlockHorizontal * 5,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff000000),
                      ),
                    ),
                  ),

                  SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                  Center(
                    child: Text('+joan1980',
                      style: TextStyle(
                        fontSize: SizeConfig.safeBlockHorizontal * 4,
                        fontWeight: FontWeight.w300,
                        color: Color(0xff000000),
                      ),
                    ),
                  ),

                  SizedBox(height: SizeConfig.blockSizeVertical * 5,),

                  GestureDetector(
                    onTap: (){
                      Navigator.pushNamed(context, '/home/blm/home-14-blm-user-details');
                    },
                    child: Center(
                      child: Text('About',
                        style: TextStyle(
                          fontSize: SizeConfig.safeBlockHorizontal * 4,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff04ECFF),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: SizeConfig.blockSizeVertical * 5,),

                  Padding(
                    padding: EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Icon(Icons.star_outline, color: Color(0xffBDC3C7), size: SizeConfig.blockSizeVertical * 2,),

                                  SizedBox(width: SizeConfig.blockSizeHorizontal * 2,),

                                  Text('Birthdate',
                                    style: TextStyle(
                                      fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                                      color: Color(0xffBDC3C7),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Text('4/23/1995',
                                style: TextStyle(
                                  fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                                  color: Color(0xff000000),
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                        Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Icon(Icons.place, color: Color(0xffBDC3C7), size: SizeConfig.blockSizeVertical * 2,),

                                  SizedBox(width: SizeConfig.blockSizeHorizontal * 2,),

                                  Text('Birthplace',
                                    style: TextStyle(
                                      fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                                      color: Color(0xffBDC3C7),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Text('59 West 46th Street, New York City, NY 10036.',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                                  color: Color(0xff000000),
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                        Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Icon(Icons.home, color: Color(0xffBDC3C7), size: SizeConfig.blockSizeVertical * 2,),

                                  SizedBox(width: SizeConfig.blockSizeHorizontal * 2,),

                                  Text('Home Address',
                                    style: TextStyle(
                                      fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                                      color: Color(0xffBDC3C7),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Text('59 West 46th Street, New York City, NY 10036.',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                                  color: Color(0xff000000),
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                        Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Icon(Icons.email, color: Color(0xffBDC3C7), size: SizeConfig.blockSizeVertical * 2,),

                                  SizedBox(width: SizeConfig.blockSizeHorizontal * 2,),

                                  Text('Email Address',
                                    style: TextStyle(
                                      fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                                      color: Color(0xffBDC3C7),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Text('joan.oliver@gmail.com',
                                style: TextStyle(
                                  fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                                  color: Color(0xff000000),
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                        Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Icon(Icons.phone, color: Color(0xffBDC3C7), size: SizeConfig.blockSizeVertical * 2,),

                                  SizedBox(width: SizeConfig.blockSizeHorizontal * 2,),

                                  Text('Contact Number',
                                    style: TextStyle(
                                      fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                                      color: Color(0xffBDC3C7),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Text('+1 123456789',
                                style: TextStyle(
                                  fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                                  color: Color(0xff000000),
                                ),
                              ),
                            ),
                          ],
                        ),

                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          MiscBLMUserProfileDraggableSwitchTabs(),

        ],
      ),
    );
  }
}