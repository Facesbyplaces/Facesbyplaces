import 'package:facesbyplaces/Bloc/bloc-02-bloc.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/UI/Miscellaneous/misc-04-extra.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'home-06-suggested.dart';
import 'home-07-nearby.dart';
import 'home-08-blm.dart';

class HomePost extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Stack(
      
      children: [

        Column(
          children: [

            Container(
              color: Color(0xffffffff),
              alignment: Alignment.center,
              child: MiscTabs(),
            ),

            BlocBuilder<HomeUpdateToggleFeed, int>(
              builder: (context, state){
                return ((){
                  switch(state){
                    case 0: return Container(height: SizeConfig.blockSizeVertical * 2,); break;
                    case 1: return Container(height: SizeConfig.blockSizeVertical * 2,); break;
                    case 2: return 
                    Container(
                      height: SizeConfig.blockSizeVertical * 5,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            SizedBox(width: SizeConfig.blockSizeHorizontal * 2,),

                            Icon(Icons.location_pin, color: Color(0xff979797),),

                            SizedBox(width: SizeConfig.blockSizeHorizontal * 2,),

                            Text('4015 Oral Lake Road, New York', style: TextStyle(color: Color(0xff000000), fontSize: SizeConfig.safeBlockHorizontal * 3.5,),),
                          ],
                        ),
                      ),
                    ); break;
                    case 3: return 
                    Container(
                      height: SizeConfig.blockSizeVertical * 5,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            SizedBox(width: SizeConfig.blockSizeHorizontal * 2,),

                            Icon(Icons.location_pin, color: Color(0xff979797),),

                            SizedBox(width: SizeConfig.blockSizeHorizontal * 2,),

                            Text('4015 Oral Lake Road, New York', style: TextStyle(color: Color(0xff000000), fontSize: SizeConfig.safeBlockHorizontal * 3.5,),),
                          ],
                        ),
                      ),
                    );
                    break;
                  }
                }());
              },
            ),

            BlocBuilder<HomeUpdateToggleFeed, int>(
              builder: (context, state){
                return ((){
                  switch(state){
                    case 0: return HomePostExtended(); break;
                    case 1: return HomeSuggested(); break;
                    case 2: return HomeNearby(); break;
                    case 3: return HomeBLM(); break;
                    
                  }
                }());
              },
            ),

          ],
        ),
        
      ],
    );
  }
}

class HomePostExtended extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.screenHeight - (AppBar().preferredSize.height + SizeConfig.blockSizeVertical * 16),
      child: ListView(
        padding: EdgeInsets.only(left: 10.0, right: 10.0),
        shrinkWrap: true,
        children: [
          Column(
            children: [

              Container(
                padding: EdgeInsets.all(10.0),
                height: SizeConfig.blockSizeVertical * 30,
                decoration: BoxDecoration(
                  color: Color(0xffffffff),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
              ),

              SizedBox(height: SizeConfig.blockSizeVertical * 2,),

              Container(
                padding: EdgeInsets.all(10.0),
                height: SizeConfig.blockSizeVertical * 30,
                decoration: BoxDecoration(
                  color: Color(0xffffffff),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
              ),

              SizedBox(height: SizeConfig.blockSizeVertical * 2,),

              Container(
                padding: EdgeInsets.all(10.0),
                height: SizeConfig.blockSizeVertical * 30,
                decoration: BoxDecoration(
                  color: Color(0xffffffff),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
              ),
              
            ],
          ),
        ],
      ),
    );
  }
}