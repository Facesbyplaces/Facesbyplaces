import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/Bloc/bloc-04-bloc-regular-home.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class MiscRegularTabs extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return BlocBuilder<BlocHomeRegularUpdateToggleFeed, int>(
      builder: (context, state){
        return Container(
          alignment: Alignment.center,
          width: SizeConfig.screenWidth,
          height: SizeConfig.blockSizeVertical * 8,
          color: Color(0xffffffff),
          child: DefaultTabController(
            length: 4,
            child: TabBar(
              isScrollable: true,
              labelColor: Color(0xff04ECFF),
              unselectedLabelColor: Color(0xff000000),
              indicatorColor: Color(0xff04ECFF),
              onTap: (int number){
                context.bloc<BlocHomeRegularUpdateToggleFeed>().updateToggle(number);
              },
              tabs: [

                Center(
                  child: Text('Post',
                    style: TextStyle(
                      fontSize: SizeConfig.safeBlockHorizontal * 4,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),

                Center(child: Text('Suggested',
                    style: TextStyle(
                      fontSize: SizeConfig.safeBlockHorizontal * 4,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),

                Center(
                  child: Text('Nearby',
                    style: TextStyle(
                      fontSize: SizeConfig.safeBlockHorizontal * 4,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),

                Center(
                  child: Text('BLM',
                    style: TextStyle(
                      fontSize: SizeConfig.safeBlockHorizontal * 4,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),

              ],
            ),
          ),
        );
      },
    );
  }
}
