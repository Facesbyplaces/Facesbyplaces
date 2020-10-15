import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter/material.dart';
import 'package:facesbyplaces/Bloc/bloc-01-bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegularJoin extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      body: Stack(
        children: [

          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/icons/background.png'),
                colorFilter: ColorFilter.srgbToLinearGamma(),
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.only(left: 20.0, right: 20.0),
            child: Column(
              children: [

                SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: (){
                      context.bloc<BlocUpdateCubit>().modify(1);
                      context.bloc<UpdateCubitRegular>().modify(0); // RESETS THE UPDATE CUBIT BACK TO ZERO
                    },
                    icon: Icon(Icons.arrow_back, color: Color(0xff000000), size: SizeConfig.blockSizeVertical * 5),
                  ),
                ),

                Center(child: Image.asset('assets/icons/logo.png', height: SizeConfig.blockSizeVertical * 40, width: SizeConfig.blockSizeVertical * 20,),),

                SizedBox(height: SizeConfig.blockSizeVertical * 25,),

                Center(
                  child: Text('All Lives Matter', 
                    style: TextStyle(
                      fontSize: SizeConfig.safeBlockHorizontal * 8,
                      fontWeight: FontWeight.bold,
                      color: Color(0xffffffff)
                    ),
                  ),
                ),

                SizedBox(height: SizeConfig.blockSizeVertical * 5,),
            
                MaterialButton(
                  padding: EdgeInsets.zero,
                  onPressed: (){
                    context.bloc<UpdateCubitRegular>().modify(1);
                  },
                  child: Text('Next',
                    style: TextStyle(
                      fontSize: SizeConfig.safeBlockHorizontal * 5,
                      fontWeight: FontWeight.bold,
                      color: Color(0xffffffff),
                    ),
                  ),
                  minWidth: SizeConfig.screenWidth / 2,
                  height: SizeConfig.blockSizeVertical * 7,
                  shape: StadiumBorder(),
                  color: Color(0xff04ECFF),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}