import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-04-blm-manage-memorial.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/Bloc/bloc-02-bloc-blm-home.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class HomeManageTab extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Container(
      height: SizeConfig.screenHeight - SizeConfig.blockSizeVertical * 13 - AppBar().preferredSize.height,
      child: BlocBuilder<BlocHomeBLMUpdateListSuggested, List<bool>>(
        builder: (context, state){
          return ListView.separated(
            physics: ClampingScrollPhysics(),
            itemCount: state.length,
            itemBuilder: (context, index){

              if(index == 0){
                return Container(
                  height: SizeConfig.blockSizeVertical * 10,
                  padding: EdgeInsets.only(left: 20.0, right: 20.0),
                  color: Color(0xffeeeeee),
                  child: Row(
                    children: [
                      Expanded(
                        child: Align(alignment: Alignment.centerLeft, child: Text('My Family', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, fontWeight: FontWeight.bold, color: Color(0xff000000),),),),
                      ),
                      Expanded(
                        child: Align(alignment: Alignment.centerRight, child: Text('Create', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, fontWeight: FontWeight.bold, color: Color(0xff000000),),),),
                      ),
                    ],
                  ),
                );
              }else if(index == 3){
                return Container(
                  height: SizeConfig.blockSizeVertical * 10,
                  padding: EdgeInsets.only(left: 20.0, right: 20.0),
                  color: Color(0xffeeeeee),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text('My Friends',
                      style: TextStyle(
                        fontSize: SizeConfig.safeBlockHorizontal * 4,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff000000),
                      ),
                    ),
                  ),
                );
              }else{
                return MiscBLMManageMemorialTab(index: index, tab: 0,);
              }
            },
            separatorBuilder: (context, index){
              return Divider(height: 1, color: Colors.grey,);
            },
          );
        }
      ),
    );
  }
}

