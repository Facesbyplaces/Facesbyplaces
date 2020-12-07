import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-04-blm-manage-memorial.dart';
import 'package:facesbyplaces/API/BLM/api-14-01-blm-search-posts.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter/material.dart';

class BLMSearchMainSuggested{
  int memorialId;
  String memorialName;
  String memorialDescription;

  BLMSearchMainSuggested({this.memorialId, this.memorialName, this.memorialDescription});
}

class HomeBLMSuggested extends StatefulWidget{

  HomeBLMSuggestedState createState() => HomeBLMSuggestedState();
}

class HomeBLMSuggestedState extends State<HomeBLMSuggested>{

  RefreshController refreshController = RefreshController(initialRefresh: true);
  List<BLMSearchMainSuggested> suggested = [];
  int itemRemaining = 1;
  int page = 1;

  void initState(){
    super.initState();
    onLoading();
  }

  void onRefresh() async{
    await Future.delayed(Duration(milliseconds: 1000));
    refreshController.refreshCompleted();
  }

  void onLoading() async{
    if(itemRemaining != 0){
      var newValue = await apiBLMSearchPosts('Country', page);
      itemRemaining = newValue.itemsRemaining;

      for(int i = 0; i < newValue.familyMemorialList.length; i++){
        suggested.add(BLMSearchMainSuggested(
          memorialId: newValue.familyMemorialList[i].page.id,
          memorialName: newValue.familyMemorialList[i].page.name,
          memorialDescription: newValue.familyMemorialList[i].page.details.description,
          ),    
        );
      }

      if(mounted)
      setState(() {});
      
      refreshController.loadComplete();
    }else{
      refreshController.loadNoData();
    }
  }
 

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Container(
      height: SizeConfig.screenHeight,
      child: SmartRefresher(
        enablePullDown: false,
        enablePullUp: true,
        header: MaterialClassicHeader(),
        footer: CustomFooter(
          loadStyle: LoadStyle.ShowWhenLoading,
          builder: (BuildContext context, LoadStatus mode){
            Widget body ;
            if(mode == LoadStatus.idle){
              body =  Text('Pull up load', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
            }
            else if(mode == LoadStatus.loading){
              body =  CircularProgressIndicator();
            }
            else if(mode == LoadStatus.failed){
              body = Text('Load Failed! Click retry!', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
            }
            else if(mode == LoadStatus.canLoading){
              body = Text('Release to load more', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
              page++;
            }
            else{
              body = Text('No more feed.', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
            }
            return Container(
              height: 55.0,
              child: Center(child :body),
            );
          },
        ),
        controller: refreshController,
        onRefresh: onRefresh,
        onLoading: onLoading,
        child: ListView.separated(
          physics: ClampingScrollPhysics(),
          padding: EdgeInsets.all(10.0),
          itemBuilder: (c, i) {

            var container = MiscBLMManageMemorialTab(
              index: i,
              memorialId: suggested[i].memorialId, 
              memorialName: suggested[i].memorialName, 
              description: suggested[i].memorialDescription);

            if(suggested.length != 0){
              return container;
            }else{
              return Center(child: Text('Search is empty.'),);
            }
          },
          separatorBuilder: (c, i) => Divider(height: SizeConfig.blockSizeVertical * 2, color: Colors.transparent),
          itemCount: suggested.length,
        ),
      )
    );
  }
}