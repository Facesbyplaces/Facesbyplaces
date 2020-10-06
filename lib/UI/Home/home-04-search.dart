import 'package:facesbyplaces/Bloc/bloc-02-bloc.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeSearch extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Stack(
      
      children: [

        Container(),

        SingleChildScrollView(
          child: Padding(
          padding: EdgeInsets.only(left: 20.0, right: 20.0),
            child: Column(
              children: [

                SizedBox(height: SizeConfig.blockSizeVertical * 25,),

                GestureDetector(
                  onTap: (){
                    context.bloc<HomeUpdateCubit>().modify(2);
                  },
                  child: Center(
                    child: CircleAvatar(
                      maxRadius: SizeConfig.blockSizeVertical * 10,
                      backgroundColor: Color(0xffEFFEFF),
                      child: Icon(Icons.search, color: Color(0xff4EC9D4), size: SizeConfig.blockSizeVertical * 15),
                    ),
                  ),
                ),

                SizedBox(height: SizeConfig.blockSizeVertical * 5,),

                Padding(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Text('Enter a memorial page name to start searching',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: SizeConfig.safeBlockHorizontal * 4,
                      fontWeight: FontWeight.w300,
                      color: Color(0xff000000),
                    ),
                  )
                ),
                
              ],
            ),
          ),
        ),
        
      ],
    );
  }
}