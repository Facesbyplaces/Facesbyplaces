import 'dart:ui';
import 'package:facesbyplaces/Bloc/bloc-02-bloc.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/UI/Miscellaneous/misc-05-post.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CurvePainter extends CustomPainter{

  @override
  void paint(Canvas canvas, Size size){
    var paint = Paint();
    paint.color = Color(0xff04ECFF);
    paint.style = PaintingStyle.fill;

    var path = Path();

    path.moveTo(0, size.height * 0.75);
    path.quadraticBezierTo(size.width / 2, size.height * 1.2, size.width, size.height * 0.75);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate){
    return true;
  }
}

class HomeUserProfile extends StatefulWidget{

  @override
  HomeUserProfileState createState() => HomeUserProfileState();
}

class HomeUserProfileState extends State<HomeUserProfile>{

  double height;
  Offset position;

  @override
  void initState(){
    super.initState();
    height = SizeConfig.screenHeight;
    position = Offset(0.0, height - 100);
  }
  
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
              color: Color(0xffffffff),
            ),



            Container(
              height: SizeConfig.screenHeight / 2.5,
              // color: Colors.red,
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
                          context.bloc<BlocHomeUpdateCubit>().modify(2);
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

            Positioned(
              left: position.dx,
              top: position.dy + SizeConfig.blockSizeVertical * 10,
              child: Draggable(
                feedback: MiscDraggableMain(newHeight: SizeConfig.screenHeight - position.dy,),
                onDraggableCanceled: (Velocity velocity, Offset offset){
                  setState(() {
                    position = offset;
                  });
                },
                child: MiscDraggableMain(newHeight: SizeConfig.screenHeight - position.dy,),
                childWhenDragging: Container(),
                axis: Axis.vertical,
              ),
            ),

          ],
        ),
      ],
    );
  }
}
