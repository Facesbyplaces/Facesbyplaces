import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-04-blm-manage-memorial.dart';
import 'package:facesbyplaces/API/BLM/api-07-02-blm-home-memorials-tab.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/Bloc/bloc-02-bloc-blm-home.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class HomeBLMManageTab extends StatefulWidget{

  HomeBLMManageTabState createState() => HomeBLMManageTabState();
}

class HomeBLMManageTabState extends State<HomeBLMManageTab>{

  void initState(){
    super.initState();
    apiBLMHomeMemorialsTab();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return FutureBuilder<APIBLMHomeTabMemorialMain>(
      future: apiBLMHomeMemorialsTab(),
      builder: (context, memorialsTab){
        if(memorialsTab.hasData){
          return Container(
            height: SizeConfig.screenHeight - SizeConfig.blockSizeVertical * 13 - AppBar().preferredSize.height,
            child: BlocBuilder<BlocHomeBLMUpdateListSuggested, List<bool>>(
              builder: (context, listSuggested){

                return Column(
                  children: [
                    Container(
                      height: SizeConfig.blockSizeVertical * 10,
                      padding: EdgeInsets.only(left: 20.0, right: 20.0),
                      color: Color(0xffeeeeee),
                      child: Row(
                        children: [
                          Expanded(child: Align(alignment: Alignment.centerLeft, child: Text('My Family', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, fontWeight: FontWeight.bold, color: Color(0xff000000),),),),),
                          Expanded(child: GestureDetector(onTap: (){Navigator.pushNamed(context, '/home/blm/home-07-01-blm-create-memorial');}, child: Align(alignment: Alignment.centerRight, child: Text('Create', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, fontWeight: FontWeight.bold, color: Color(0xff000000),),),),)),
                        ],
                      ),
                    ),

                    Expanded(
                      child: ListView.separated(
                        physics: ClampingScrollPhysics(),
                        itemCount: memorialsTab.data.familyMemorialList.blm.length,
                        itemBuilder: (context, index){
                          return MiscBLMManageMemorialTab(index: index, tab: 0, memorialId: memorialsTab.data.familyMemorialList.blm[index].id, memorialName: memorialsTab.data.familyMemorialList.blm[index].name, description: memorialsTab.data.familyMemorialList.blm[index].details.description,);
                        },
                        separatorBuilder: (context, index){
                          return Divider(height: 1, color: Colors.grey,);
                        },
                      ),
                    ),

                    Container(
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
                    ),

                    Expanded(
                      child: ListView.separated(
                        physics: ClampingScrollPhysics(),
                        itemCount: memorialsTab.data.friendsMemorialList.blm.length,
                        itemBuilder: (context, index){
                          return MiscBLMManageMemorialTab(index: index, tab: 0, memorialId: memorialsTab.data.friendsMemorialList.blm[index].id, memorialName: memorialsTab.data.friendsMemorialList.blm[index].name, description: memorialsTab.data.friendsMemorialList.blm[index].details.description,);
                        },
                        separatorBuilder: (context, index){
                          return Divider(height: 1, color: Colors.grey,);
                        },
                      ),
                    ),
                  ],
                );
              }
            ),
          );
        }else if(memorialsTab.hasError){
          return Center(child: Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),),);
        }else{
          return Container(child: Center(child: Container(child: SpinKitThreeBounce(color: Color(0xff000000), size: 50.0,), color: Color(0xffffffff),),),);
        }
      },
    );
  }
}

