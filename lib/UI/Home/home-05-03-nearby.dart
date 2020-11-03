import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/UI/Miscellaneous/misc-04-extra.dart';
import 'package:facesbyplaces/Bloc/bloc-02-bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class HomeNearby extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return BlocBuilder<BlocHomeUpdateListNearby, List<bool>>(
      builder: (context, state){
        return ListView.separated(
          physics: ClampingScrollPhysics(),
          shrinkWrap: true,
          itemCount: state.length,
          itemBuilder: (context, index){
            return MiscJoinButton(index: index, tab: 1,);
          },
          separatorBuilder: (context, index){
            return Divider(height: 1, color: Colors.grey,);
          },
        );
      },
    );
  }
}