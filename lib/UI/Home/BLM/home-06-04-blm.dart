import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-04-blm-extra.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/Bloc/bloc-02-bloc-blm-home.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class HomeBLMBLM extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return BlocBuilder<BlocHomeBLMUpdateListBLM, List<bool>>(
      builder: (context, state){
        return ListView.separated(
          physics: ClampingScrollPhysics(),
          itemCount: state.length,
          itemBuilder: (context, index){
            return MiscBLMJoinButton(index: index, tab: 2,);
          },
          separatorBuilder: (context, index){
            return Divider(height: 1, color: Colors.grey,);
          },
        );
      },
    );
  }
}
