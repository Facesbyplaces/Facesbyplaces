import 'dart:ui';
import 'package:facesbyplaces/Bloc/bloc-02-bloc.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/UI/Miscellaneous/misc-05-post.dart';
import 'package:facesbyplaces/UI/Miscellaneous/misc-06-custom-drawings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class HomeUserProfileDetails extends StatefulWidget{

  @override
  HomeUserProfileDetailsState createState() => HomeUserProfileDetailsState();
}

class HomeUserProfileDetailsState extends State<HomeUserProfileDetails>{

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return ListView(
      shrinkWrap: true,
      children: [
        Stack(
          children: [

            Container(
              height: SizeConfig.screenHeight,
              color: Color(0xffECF0F1),
            ),

            Container(
              height: SizeConfig.screenHeight / 2.5,
              child: Stack(
                children: [

                  CustomPaint(
                    size: Size.infinite,
                    painter: CurvePainter(),
                  ),

                  Positioned(
                    top: SizeConfig.blockSizeVertical * 8,
                    left: SizeConfig.screenWidth / 4.2,
                    child: CircleAvatar(
                      radius: SizeConfig.blockSizeVertical * 15,
                      backgroundImage: AssetImage('assets/icons/profile1.png'),
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
                          context.bloc<BlocHomeUpdateCubit>().modify(14);
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

            MiscUserProfileDetailsDraggable(),

          ],
        ),
      ],
    );
  }
}