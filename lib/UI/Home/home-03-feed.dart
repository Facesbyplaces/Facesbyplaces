import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter/material.dart';

class HomeFeed extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Stack(
      children: [

        Container(

        ),


        Padding(
          padding: EdgeInsets.only(left: 20.0, right: 20.0),
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

              Center(child: Image.asset('assets/icons/logo.png', height: SizeConfig.blockSizeVertical * 30, width: SizeConfig.blockSizeVertical * 25,),),

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

              Center(
                child: Text('Create or join the memorial pages of other users to get started',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: SizeConfig.safeBlockHorizontal * 4,
                    color: Color(0xff000000),
                  ),
                ),
              ),

              SizedBox(height: SizeConfig.blockSizeVertical * 5,),

              MaterialButton(
                padding: EdgeInsets.zero,
                onPressed: (){
                  
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