import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/Bloc/bloc-02-bloc-blm-home.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class MiscBLMConnectionTabs extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return BlocBuilder<BlocHomeBLMUpdateToggleFeed, int>(
      builder: (context, state){
        return Container(
          alignment: Alignment.center,
          width: SizeConfig.screenWidth,
          height: SizeConfig.blockSizeVertical * 8,
          color: Color(0xffffffff),
          child: DefaultTabController(
            length: 3,
            child: TabBar(
              labelColor: Color(0xff04ECFF),
              unselectedLabelColor: Color(0xff000000),
              indicatorColor: Color(0xff04ECFF),
              onTap: (int number){
                context.bloc<BlocHomeBLMUpdateToggleFeed>().updateToggle(number);
              },
              tabs: [

                Center(
                  child: Text('Family',
                    style: TextStyle(
                      fontSize: SizeConfig.safeBlockHorizontal * 4,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),

                Center(child: Text('Friends',
                    style: TextStyle(
                      fontSize: SizeConfig.safeBlockHorizontal * 4,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),

                Center(
                  child: Text('Followers',
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
