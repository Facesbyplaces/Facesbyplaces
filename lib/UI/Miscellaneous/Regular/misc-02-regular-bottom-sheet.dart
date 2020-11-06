import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/Bloc/bloc-03-bloc-regular-home.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class MiscRegularBottomSheet extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return BlocBuilder<BlocHomeRegularUpdateToggle, List<bool>>(
      builder: (context, state){
        return Container(
          height: SizeConfig.blockSizeVertical * 10,
          alignment: Alignment.center,
          width: SizeConfig.screenWidth,
          child: ToggleButtons(
            borderWidth: 0,
            renderBorder: false,
            selectedColor: Color(0xff04ECFF),
            fillColor: Colors.transparent,
            color: Color(0xffB1B1B1),
            children: [

              Container(
                width: SizeConfig.screenWidth / 4,
                child: Column(
                  children: [
                    Icon(MdiIcons.fire, size: SizeConfig.blockSizeVertical * 4,),
                    SizedBox(height: SizeConfig.blockSizeVertical * 1),
                    Text('Feed', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 3,),),
                  ],
                ),
              ),

              Container(
                width: SizeConfig.screenWidth / 4,
                child: Column(
                  children: [
                    Icon(MdiIcons.graveStone, size: SizeConfig.blockSizeVertical * 4,),
                    SizedBox(height: SizeConfig.blockSizeVertical * 1),
                    Text('Memorials', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 3,),),
                  ],
                ),
              ),

              Container(
                width: SizeConfig.screenWidth / 4,
                child: Column(
                  children: [
                    Icon(MdiIcons.post, size: SizeConfig.blockSizeVertical * 4,),
                    SizedBox(height: SizeConfig.blockSizeVertical * 1),
                    Text('Post', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 3,),),
                  ],
                ),
              ),

              Container(
                width: SizeConfig.screenWidth / 4,
                child: Column(
                  children: [
                    Icon(MdiIcons.heart, size: SizeConfig.blockSizeVertical * 4,),
                    SizedBox(height: SizeConfig.blockSizeVertical * 1),
                    Text('Notification', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 3,),),
                  ],
                ),
              ),

            ],
            onPressed: (int index){
              context.bloc<BlocHomeRegularUpdateToggle>().updateToggle(index);
              switch(index){
                case 0: context.bloc<BlocHomeRegularUpdateCubit>().modify(0); break;
                case 1: context.bloc<BlocHomeRegularUpdateCubit>().modify(1); break;
                case 2: context.bloc<BlocHomeRegularUpdateCubit>().modify(2); break;
                case 3: context.bloc<BlocHomeRegularUpdateCubit>().modify(3); break;
              }
            },
            isSelected: context.bloc<BlocHomeRegularUpdateToggle>().state,
          ),
          
          decoration: BoxDecoration(
            color: Color(0xffffffff),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                blurRadius: 5,
                spreadRadius: 1,
                offset: Offset(0, 0)
              ),
            ],
          ),
        );
      },
    );
  }
}