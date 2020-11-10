import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/Bloc/bloc-04-bloc-regular-home.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';


class MiscRegularStoryType extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Container(
      height: SizeConfig.blockSizeVertical * 8,
      child: DefaultTabController(
        length: 3,
        child: TabBar(
          isScrollable: false,
          labelColor: Color(0xff04ECFF),
          unselectedLabelColor: Color(0xff000000),
          indicatorColor: Colors.transparent,
          onTap: (int number){
            context.bloc<BlocHomeRegularStoryType>().updateToggle(number);
          },
          tabs: [

            Center(
              child: Text('Text',
                style: TextStyle(
                  fontSize: SizeConfig.safeBlockHorizontal * 3,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),

            Center(child: 
              Text('Video',
                style: TextStyle(
                  fontSize: SizeConfig.safeBlockHorizontal * 3,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),

            Center(
              child: Text('Slide',
                style: TextStyle(
                  fontSize: SizeConfig.safeBlockHorizontal * 3,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}