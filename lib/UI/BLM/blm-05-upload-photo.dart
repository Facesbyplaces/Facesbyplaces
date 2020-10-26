import 'package:facesbyplaces/Bloc/bloc-01-bloc.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BLMUploadPhoto extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider<BlocUpdateProfilePicture>(
          create: (context) => BlocUpdateProfilePicture(),
        ),
        BlocProvider<BlocShowMessage>(
          create: (context) => BlocShowMessage(),
        ),
      ], 
      child: Scaffold(
        body: Stack(
          children: [

            Container(color: Color(0xffffffff),),

            BlocBuilder<BlocShowMessage, bool>(
              builder: (context, state){
                return ((){
                  if(state){
                    return Padding(
                      padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 8,),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          height: SizeConfig.blockSizeVertical * 5,
                          width: SizeConfig.screenWidth / 1.2,
                          child: Center(
                            child: Text('Please upload a valid photo / image', 
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
                  }else{
                    return Container();
                  }
                }());
              },
            ),

            Padding(
              padding: EdgeInsets.only(left: 20.0, right: 20.0),
              child: Column(
                children: [

                  SizedBox(height: SizeConfig.blockSizeVertical * 5,),

                  Center(
                    child: Text('Upload Photo', 
                      style: TextStyle(
                        fontSize: SizeConfig.safeBlockHorizontal * 8,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff000000),
                      ),
                    ),
                  ),

                  SizedBox(height: SizeConfig.blockSizeVertical * 5,),

                  BlocBuilder<BlocUpdateButtonText, int>(
                    builder: (context, state){
                      return context.bloc<BlocUpdateButtonText>().state != 0
                      ? MaterialButton(
                        padding: EdgeInsets.zero,
                        onPressed: (){
                          context.bloc<BlocShowMessage>().showMessage();

                          Duration duration = Duration(seconds: 2);

                          Future.delayed(duration, (){
                            context.bloc<BlocShowMessage>().showMessage();
                          });
                        },

                        child: Text('Sign Up',
                          style: TextStyle(
                            fontSize: SizeConfig.safeBlockHorizontal * 5,
                            fontWeight: FontWeight.bold,
                            color: Color(0xffffffff),
                          ),
                        ),

                        minWidth: SizeConfig.screenWidth / 2,
                        height: SizeConfig.blockSizeVertical * 7,
                        shape: StadiumBorder(),
                        color: Color(0xff4EC9D4)
                      )
                      : MaterialButton(
                        padding: EdgeInsets.zero,
                        onPressed: (){

                        },

                        child: Text('Speak Now',
                          style: TextStyle(
                            fontSize: SizeConfig.safeBlockHorizontal * 5,
                            fontWeight: FontWeight.bold,
                            color: Color(0xffffffff),
                          ),
                        ),

                        minWidth: SizeConfig.screenWidth / 2,
                        height: SizeConfig.blockSizeVertical * 7,
                        shape: StadiumBorder(),
                        color: Color(0xff000000)
                      );
                    },
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

