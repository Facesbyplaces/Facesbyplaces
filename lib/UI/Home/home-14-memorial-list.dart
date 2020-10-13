import 'package:facesbyplaces/Bloc/bloc-02-bloc.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/UI/Miscellaneous/misc-04-extra.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeManage extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
      return ListView(
        children: [
        Container(
          height: SizeConfig.screenHeight - (AppBar().preferredSize.height + SizeConfig.blockSizeVertical * 13),
          child: BlocBuilder<HomeUpdateListSuggested, List<bool>>(
            builder: (context, state){
              return Container(
                child: ListView.separated(
                  shrinkWrap: true,
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
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text('My Family',
                                  style: TextStyle(
                                    fontSize: SizeConfig.safeBlockHorizontal * 4,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff000000),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text('Create',
                                  style: TextStyle(
                                    fontSize: SizeConfig.safeBlockHorizontal * 4,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff000000),
                                  ),
                                ),
                              ),
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
                      return MiscManageButton(index: index, tab: 0,);
                    }
                    
                  },
                  separatorBuilder: (context, index){
                    return Divider(height: 1, color: Colors.grey,);
                  },
                ),
              );
            }
          ),
        ),
      ],
    );
  }
}

