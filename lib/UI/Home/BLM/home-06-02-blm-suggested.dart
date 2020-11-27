import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-04-blm-manage-memorial.dart';
import 'package:facesbyplaces/API/BLM/api-14-02-blm-search-memorials.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/Bloc/bloc-02-bloc-blm-home.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'home-04-blm-search.dart';

class HomeBLMSuggested extends StatefulWidget{

  HomeBLMSuggestedState createState() => HomeBLMSuggestedState();
}

class HomeBLMSuggestedState extends State<HomeBLMSuggested>{

  void initState(){
    super.initState();
    apiBLMSearchMemorials('');
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    final BLMArguments newValue = ModalRoute.of(context).settings.arguments;
    return FutureBuilder<APIBLMSearchMemorialMain>(
      future: apiBLMSearchMemorials(newValue.title),
      builder: (context, memorialSuggested){
        if(memorialSuggested.hasData){
          return BlocBuilder<BlocHomeBLMUpdateListSuggested, List<bool>>(
            builder: (context, state){
              return ListView.separated(
                physics: ClampingScrollPhysics(),
                itemCount: memorialSuggested.data.familyMemorialList.length,
                itemBuilder: (context, index){
                  return MiscBLMManageMemoriaWithButton(index: index, tab: 1, title: memorialSuggested.data.familyMemorialList[index].page.name, content: memorialSuggested.data.familyMemorialList[index].page.details.description, memorialId: memorialSuggested.data.familyMemorialList[index].id);
                },
                separatorBuilder: (context, index){
                  return Divider(height: 1, color: Colors.grey,);
                },
              );
            },
          );
        }else if(memorialSuggested.hasError){
          return Center(child: Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),),);
        }else{
          return Container(child: Center(child: Container(child: SpinKitThreeBounce(color: Color(0xff000000), size: 50.0,), color: Color(0xffffffff),),),);
        }
      },
    );
  }
}


