import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-01-regular-manage-memorial.dart';
import 'package:facesbyplaces/API/Regular/api-07-02-regular-home-memorials-tab.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/Bloc/bloc-04-bloc-regular-home.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class HomeRegularManageTab extends StatefulWidget{

  HomeRegularManageTabState createState() => HomeRegularManageTabState();
}

class HomeRegularManageTabState extends State<HomeRegularManageTab>{

  void initState(){
    super.initState();
    apiRegularHomeMemorialsTab();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return FutureBuilder<APIRegularHomeTabMemorialMain>(
      future: apiRegularHomeMemorialsTab(),
      builder: (context, memorialsTab){
        if(memorialsTab.hasData){
          return Container(
            height: SizeConfig.screenHeight - SizeConfig.blockSizeVertical * 13 - AppBar().preferredSize.height,
            child: BlocBuilder<BlocHomeRegularUpdateListSuggested, List<bool>>(
              builder: (context, regularListSuggested){

                return Column(
                  children: [
                    Container(
                      height: SizeConfig.blockSizeVertical * 10,
                      padding: EdgeInsets.only(left: 20.0, right: 20.0),
                      color: Color(0xffeeeeee),
                      child: Row(
                        children: [
                          Expanded(child: Align(alignment: Alignment.centerLeft, child: Text('My Family', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, fontWeight: FontWeight.bold, color: Color(0xff000000),),),),),
                          Expanded(child: GestureDetector(onTap: (){Navigator.pushNamed(context, '/home/regular/home-04-01-regular-create-memorial');}, child: Align(alignment: Alignment.centerRight, child: Text('Create', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, fontWeight: FontWeight.bold, color: Color(0xff000000),),),),)),
                        ],
                      ),
                    ),

                    Expanded(
                      child: ListView.separated(
                        physics: ClampingScrollPhysics(),
                        itemCount: memorialsTab.data.familyMemorialList.length,
                        itemBuilder: (context, index){
                          return MiscRegularManageMemorialTab(index: index, tab: 0, memorialId: memorialsTab.data.familyMemorialList[index].page.id, memorialName: memorialsTab.data.familyMemorialList[index].page.name, description: memorialsTab.data.familyMemorialList[index].page.details.description,);
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
                        itemCount: memorialsTab.data.friendsMemorialList.length,
                        itemBuilder: (context, index){
                          return MiscRegularManageMemorialTab(index: index, tab: 0, memorialId: memorialsTab.data.friendsMemorialList[index].page.id, memorialName: memorialsTab.data.friendsMemorialList[index].page.name, description: memorialsTab.data.friendsMemorialList[index].page.details.description,);
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
