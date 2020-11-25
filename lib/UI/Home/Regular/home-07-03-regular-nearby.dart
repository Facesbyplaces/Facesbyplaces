import 'package:facesbyplaces/API/Regular/api-13-01-regular-search-memorial.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-12-regular-memorial-list.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/Bloc/bloc-04-bloc-regular-home.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'home-05-regular-search.dart';

class HomeRegularNearby extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    final ScreenArguments newValue = ModalRoute.of(context).settings.arguments;
    return FutureBuilder<bool>(
      future: apiRegularSearchMemorials(newValue.title),
      builder: (context, postNearby){
        return BlocBuilder<BlocHomeRegularUpdateListNearby, List<bool>>(
          builder: (context, state){
            return ListView.separated(
              physics: ClampingScrollPhysics(),
              itemCount: state.length,
              itemBuilder: (context, index){
                return MiscManageMemoriaWithButton(index: index, tab: 2,);
              },
              separatorBuilder: (context, index){
                return Divider(height: 1, color: Colors.grey,);
              },
            );
          },
        );
      },
    );
  }
}