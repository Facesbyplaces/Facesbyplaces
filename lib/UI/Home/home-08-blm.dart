import 'package:facesbyplaces/Bloc/bloc-02-bloc.dart';
import 'package:facesbyplaces/UI/Miscellaneous/misc-04-extra.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter/material.dart';

class HomeBLM extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return BlocBuilder<BlocHomeUpdateListBLM, List<bool>>(
      builder: (context, state){
        return Container(
          height: SizeConfig.screenHeight - (AppBar().preferredSize.height + SizeConfig.blockSizeVertical * 19),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: state.length,
              itemBuilder: (context, index){
                return MiscJoinButton(index: index, tab: 2,);
              },
              separatorBuilder: (context, index){
                return Divider(height: 1, color: Colors.grey,);
              },
            ),
        );
      },
    );
  }
}
