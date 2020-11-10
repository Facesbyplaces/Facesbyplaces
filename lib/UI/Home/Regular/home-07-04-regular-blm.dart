import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-12-regular-memorial-list.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/Bloc/bloc-04-bloc-regular-home.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class HomeRegularBLM extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return BlocBuilder<BlocHomeRegularUpdateListBLM, List<bool>>(
      builder: (context, state){
        return ListView.separated(
          physics: ClampingScrollPhysics(),
          itemCount: state.length,
          itemBuilder: (context, index){
            return MiscManageMemoriaWithButton(index: index, tab: 3,);
          },
          separatorBuilder: (context, index){
            return Divider(height: 1, color: Colors.grey,);
          },
        );
      },
    );
  }
}
