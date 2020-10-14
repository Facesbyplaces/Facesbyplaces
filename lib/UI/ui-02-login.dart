import 'package:facesbyplaces/Bloc/bloc-01-bloc.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class UILogin01 extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [

        Container(color: Color(0xffffffff),),

        Padding(
          padding: EdgeInsets.only(left: 20.0, right: 20.0),
          child: Column(
            children: [

              SizedBox(height: SizeConfig.blockSizeVertical * 10,),

              Center(child: Image.asset('assets/icons/logo.png', height: SizeConfig.blockSizeVertical * 30, width: SizeConfig.blockSizeVertical * 30,),),

              SizedBox(height: SizeConfig.blockSizeVertical * 5,),

              Center(
                child: Text('FacesByPlaces.com', 
                  style: TextStyle(
                    fontSize: SizeConfig.safeBlockHorizontal * 4,
                    color: Color(0xff000000),
                  ),
                ),
              ),

              SizedBox(height: SizeConfig.blockSizeVertical * 5,),

              Center(
                child: Text('Honor, Respect, Never Forget', 
                  style: TextStyle(
                    fontSize: SizeConfig.safeBlockHorizontal * 5,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff000000)
                  ),
                ),
              ),

              SizedBox(height: SizeConfig.blockSizeVertical * 5,),

              Center(
                child: Text('Black Lives Matter', 
                  style: TextStyle(
                    fontSize: SizeConfig.safeBlockHorizontal * 4,
                    color: Color(0xff000000)
                  ),
                ),
              ),

              SizedBox(height: SizeConfig.blockSizeVertical * 1,),

              MaterialButton(
                padding: EdgeInsets.zero,
                onPressed: (){
                  context.bloc<BlocUpdateCubit>().modify(2);
                },
                minWidth: SizeConfig.screenWidth / 1.5,
                height: SizeConfig.blockSizeVertical * 10,
                child: Row(
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: CircleAvatar(
                          maxRadius: SizeConfig.blockSizeVertical * 5,
                          backgroundColor: Color(0xff000000),
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Image.asset('assets/icons/fist.png'),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Container(
                        padding: EdgeInsets.only(left: 10.0),
                        alignment: Alignment.centerLeft,
                        child: Text('Speak for a loved one killed by law enforcement',
                          style: TextStyle(
                            fontSize: SizeConfig.safeBlockHorizontal * 4,
                            fontWeight: FontWeight.w300,
                            color: Color(0xff000000),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                  ],
                ),
                shape: StadiumBorder(),
                color: Color(0xffF2F2F2),
              ),

              SizedBox(height: SizeConfig.blockSizeVertical * 3,),

              Center(
                child: Text('All Lives Matter', 
                  style: TextStyle(
                    fontSize: SizeConfig.safeBlockHorizontal * 4,
                    color: Color(0xff000000)
                  ),
                ),
              ),

              SizedBox(height: SizeConfig.blockSizeVertical * 1,),

              MaterialButton(
                padding: EdgeInsets.zero,
                onPressed: (){
                  context.bloc<BlocUpdateCubit>().modify(3);
                },
                minWidth: SizeConfig.screenWidth / 1.5,
                height: SizeConfig.blockSizeVertical * 10,
                child: Row(
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: CircleAvatar(
                          maxRadius: SizeConfig.blockSizeVertical * 5,
                          backgroundColor: Color(0xff04ECFF),
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Icon(Icons.favorite, size: SizeConfig.blockSizeVertical * 7, color: Color(0xffffffff),)
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Container(
                        padding: EdgeInsets.only(left: 10.0),
                        alignment: Alignment.centerLeft,
                        child: Text('Remembering friends and family',
                          style: TextStyle(
                            fontSize: SizeConfig.safeBlockHorizontal * 4,
                            fontWeight: FontWeight.w300,
                            color: Color(0xff000000),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                  ],
                ),
                shape: StadiumBorder(),
                color: Color(0xffE6FDFF),
              ),

              SizedBox(height: SizeConfig.blockSizeVertical * 3,),

              RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Already have an account? ', 
                      style: TextStyle(
                        fontSize: SizeConfig.safeBlockHorizontal * 4,
                        color: Color(0xff000000),
                      ),
                    ),

                    TextSpan(
                      text: 'Login', 
                      style: TextStyle(
                        fontSize: SizeConfig.safeBlockHorizontal * 4,
                        color: Color(0xff04ECFF),
                      ),
                      recognizer: TapGestureRecognizer()
                      ..onTap = (){
                        context.bloc<BlocUpdateCubit>().modify(4);
                      }
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}