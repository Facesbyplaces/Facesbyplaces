import 'package:facesbyplaces/API/BLM/api-23-blm-search-users.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeRegularSearchUser extends StatefulWidget{

  @override
  HomeRegularSearchUserState createState() => HomeRegularSearchUserState();
}

class HomeRegularSearchUserState extends State<HomeRegularSearchUser>{
  
  TextEditingController controller = TextEditingController();
  // List<String> users = [];
  List<Widget> users = [];
  bool empty = true;
  int page = 1;
  RefreshController refreshController = RefreshController(initialRefresh: true);
  int itemRemaining = 1;
  String keywords = '';

  void initState(){
    super.initState();
    onLoading();
  }

  String convertDate(String input){
    DateTime dateTime = DateTime.parse(input);

    final y = dateTime.year.toString().padLeft(4, '0');
    final m = dateTime.month.toString().padLeft(2, '0');
    final d = dateTime.day.toString().padLeft(2, '0');
    return '$d/$m/$y';
  }

  void onRefresh() async{
    await Future.delayed(Duration(milliseconds: 1000));
    refreshController.refreshCompleted();
  }

  void onLoading() async{
    if(itemRemaining != 0){
      var newValue = await apiBLMSearchUsers(keywords, page);
      itemRemaining = newValue.itemsRemaining;
      users.add(Column(
        children: [

          SizedBox(height: SizeConfig.blockSizeVertical * 1,),
        ],
      ));
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
    return WillPopScope(
      onWillPop: () async{
        return Navigator.canPop(context);
      },
      child: GestureDetector(
        onTap: (){
          FocusNode currentFocus = FocusScope.of(context);
          if(!currentFocus.hasPrimaryFocus){
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: TextFormField(
              onChanged: (newPlaces){
                // if(newPlaces == ''){
                //   setState(() {
                //     empty = true;
                //     users = [];
                //   });
                // }else{
                //   setState(() {
                //     empty = false;
                //     users.add(newPlaces);
                //   });
                // }

                setState(() {
                  keywords = newPlaces;
                });                

                if(newPlaces != ''){
                  empty = false;
                  onLoading();
                }
                
              },
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(15.0),
                filled: true,
                fillColor: Color(0xffffffff),
                focusColor: Color(0xffffffff),
                hintText: 'Search User',
                hintStyle: TextStyle(
                  fontSize: SizeConfig.safeBlockHorizontal * 4,
                ),
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xffffffff)),
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                ),
                enabledBorder:  OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xffffffff)),
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                ),
                focusedBorder:  OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xffffffff)),
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                ),
              ),
            ),
            leading: IconButton(icon: Icon(Icons.arrow_back, color: Color(0xffffffff),), onPressed: (){Navigator.pop(context);},),
            backgroundColor: Color(0xff04ECFF),
          ),
          body: empty
          ? SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            padding: EdgeInsets.zero,
            child: Container(
              height: SizeConfig.screenHeight - kToolbarHeight,
              child: Column(
                children: [
                  Expanded(child: Container(),),

                  Container(
                    height: SizeConfig.blockSizeVertical * 30,
                    width: SizeConfig.screenWidth / 2,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/icons/search-user.png'),
                      ),
                    ),
                  ),

                  SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                  Text('Search a location to add on your post', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),),

                  Expanded(child: Container(),),
                ],
              ),
            ),
          )
          : Container(
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
                    body = Text('No more results.', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
                  }
                  return Container(
                    height: 55.0,
                    child: Center(child:body),
                  );
                },
              ),
              controller: refreshController,
              onRefresh: onRefresh,
              onLoading: onLoading,
              child: ListView.separated(
                padding: EdgeInsets.all(10.0),
                shrinkWrap: true,
                itemBuilder: (c, i) => users[i],
                separatorBuilder: (c, i) => Divider(height: SizeConfig.blockSizeVertical * 2, color: Colors.transparent),
                itemCount: users.length,
              ),
            )
          ),
        ),
      ),
    );
  }
}