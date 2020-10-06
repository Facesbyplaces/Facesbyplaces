import 'package:facesbyplaces/Bloc/bloc-02-bloc.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/UI/Miscellaneous/misc-04-extra.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'home-06-suggested.dart';

class HomePost extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Stack(
      
      children: [

        Column(
          children: [

            Container(
              // padding: EdgeInsets.only(top: 10.0),
              color: Color(0xffffffff),
              alignment: Alignment.center,
              child: MiscTabs(),
            ),

            SizedBox(height: SizeConfig.blockSizeVertical * 2,),

            BlocBuilder<HomeUpdateToggleFeed, int>(
              builder: (context, state){
                return ((){
                  switch(state){
                    case 0: return HomePostExtended(); break;
                    case 1: return HomeSuggested(); break;
                    case 2: return Container(color: Colors.blue,); break;
                    case 3: return Container(color: Colors.green,); break;
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
      height: SizeConfig.screenHeight - (AppBar().preferredSize.height + SizeConfig.blockSizeVertical * 13),
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