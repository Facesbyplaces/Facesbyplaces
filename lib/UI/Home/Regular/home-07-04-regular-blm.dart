import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-12-regular-memorial-list.dart';
import 'package:facesbyplaces/API/Regular/api-13-02-regular-search-memorial.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/Bloc/bloc-04-bloc-regular-home.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'home-05-regular-search.dart';

class HomeRegularBLM extends StatefulWidget{

  HomeRegularBLMState createState() => HomeRegularBLMState();
}

class HomeRegularBLMState extends State<HomeRegularBLM>{

  void initState(){
    super.initState();
    apiRegularSearchMemorials('');
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    final ScreenArguments newValue = ModalRoute.of(context).settings.arguments;
    return FutureBuilder<APIRegularSearchMemorialMain>(
      future: apiRegularSearchMemorials(newValue.title),
      builder: (context, memorialBLM){
        if(memorialBLM.hasData){
          return BlocBuilder<BlocHomeRegularUpdateListBLM, List<bool>>(
            builder: (context, state){
              return ListView.separated(
                physics: ClampingScrollPhysics(),
                itemCount: memorialBLM.data.familyMemorialList.length,
                itemBuilder: (context, index){
                  return MiscManageMemoriaWithButton(index: index, tab: 3, title: memorialBLM.data.familyMemorialList[index].page.name, content: memorialBLM.data.familyMemorialList[index].page.details.description,);
                },
                separatorBuilder: (context, index){
                  return Divider(height: 1, color: Colors.grey,);
                },
              );
            },
          );
        }else if(memorialBLM.hasError){
          return Center(child: Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),),);
        }else{
          return Container(child: Center(child: Container(child: SpinKitThreeBounce(color: Color(0xff000000), size: 50.0,), color: Color(0xffffffff),),),);
        }

      },
    );
  }
}
