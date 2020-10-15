import 'package:facesbyplaces/Bloc/bloc-02-bloc.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeFeed extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Stack(
      children: [

        Container(),

        Container(
          // padding: EdgeInsets.only(left: 20.0, right: 20.0),
          child: Column(
            children: [

              SizedBox(height: SizeConfig.blockSizeVertical * 5,),

              Align(
                alignment: Alignment.center,
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Welcome to\n',
                        style: TextStyle(
                          fontSize: SizeConfig.safeBlockHorizontal * 5,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff000000),
                        ),
                      ),

                      TextSpan(
                        text: 'Faces by Places', 
                        style: TextStyle(
                          fontSize: SizeConfig.safeBlockHorizontal * 5,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff000000),
                        ),
                      ),

                    ],
                  ),
                ),
              ),

              SizedBox(height: SizeConfig.blockSizeVertical * 5,),

              // Center(child: Image.asset('assets/icons/logo.png', height: SizeConfig.blockSizeVertical * 30, width: SizeConfig.blockSizeVertical * 25,),),

              Container(
                width: SizeConfig.screenWidth,
                // color: Colors.red,
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      top: SizeConfig.blockSizeVertical * 5,
                      child: CircleAvatar(
                        radius: SizeConfig.blockSizeVertical * 10,
                        backgroundColor: Color(0xff000000),
                        child: CircleAvatar(
                          radius: SizeConfig.blockSizeVertical * 9.5,
                          backgroundColor: Colors.transparent,
                          backgroundImage: AssetImage('assets/icons/blm-image5.png'),
                        ),
                      ),
                    ),

                    Positioned(
                      right: 0,
                      top: SizeConfig.blockSizeVertical * 5,
                      child: CircleAvatar(
                        radius: SizeConfig.blockSizeVertical * 10,
                        backgroundColor: Color(0xff04ECFF),
                        child: CircleAvatar(
                          radius: SizeConfig.blockSizeVertical * 9.5,
                          backgroundColor: Colors.transparent,
                          backgroundImage: AssetImage('assets/icons/blm-image5.png'),
                        ),
                      ),
                    ),

                    Positioned(
                      left: SizeConfig.blockSizeHorizontal * 12,
                      top: SizeConfig.blockSizeVertical * 4,
                      child: CircleAvatar(
                        radius: SizeConfig.blockSizeVertical * 11,
                        backgroundColor: Color(0xff000000),
                        child: CircleAvatar(
                          radius: SizeConfig.blockSizeVertical * 10.5,
                          backgroundColor: Colors.transparent,
                          backgroundImage: AssetImage('assets/icons/blm-image5.png'),
                        ),
                      ),
                    ),

                    Positioned(
                      right: SizeConfig.blockSizeHorizontal * 12,
                      top: SizeConfig.blockSizeVertical * 4,
                      child: CircleAvatar(
                        radius: SizeConfig.blockSizeVertical * 11,
                        backgroundColor: Color(0xff04ECFF),
                        child: CircleAvatar(
                          radius: SizeConfig.blockSizeVertical * 10.5,
                          backgroundColor: Colors.transparent,
                          backgroundImage: AssetImage('assets/icons/blm-image5.png'),
                        ),
                      ),
                    ),

                    Center(child: Image.asset('assets/icons/logo.png', height: SizeConfig.blockSizeVertical * 30, width: SizeConfig.blockSizeVertical * 25,),),
                  ],
                ),
              ),
              

              SizedBox(height: SizeConfig.blockSizeVertical * 5,),

              Center(
                child: Text('Feed is empty',
                  style: TextStyle(
                    fontSize: SizeConfig.safeBlockHorizontal * 5,
                    fontWeight: FontWeight.bold,
                    color: Color(0xffB1B1B1),
                  ),
                ),
              ),

              SizedBox(height: SizeConfig.blockSizeVertical * 2,),

              Padding(
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                child: Center(
                  child: Text('Create or join the memorial pages of other users to get started',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: SizeConfig.safeBlockHorizontal * 4,
                      color: Color(0xff000000),
                    ),
                  ),
                ),
              ),

              SizedBox(height: SizeConfig.blockSizeVertical * 5,),

              MaterialButton(
                padding: EdgeInsets.zero,
                onPressed: (){
                  context.bloc<BlocHomeUpdateCubit>().modify(4);
                },
                child: Text('Create',
                  style: TextStyle(
                    fontSize: SizeConfig.safeBlockHorizontal * 5,
                    fontWeight: FontWeight.bold,
                    color: Color(0xffffffff),
                  ),
                ),
                minWidth: SizeConfig.screenWidth / 2,
                height: SizeConfig.blockSizeVertical * 7,
                shape: StadiumBorder(),
                color: Color(0xff000000),
              ),
            ],
          ),
        ),
      ],
    );
  }
}