import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-02-blm-dialog.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/API/BLM/api-23-blm-search-users.dart';
import 'package:facesbyplaces/API/BLM/api-40-blm-add-family.dart';
import 'package:facesbyplaces/API/BLM/api-41-blm-add-friends.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter/material.dart';

import 'home-settings-memorial-blm-05-page-family.dart';
import 'home-settings-memorial-blm-06-page-friends.dart';

class BLMSearchUsers{
  final int userId;
  final String firstName;
  final String lastName;
  final String image;
  final String email;

  BLMSearchUsers({this.userId, this.firstName, this.lastName, this.image, this.email});
}

class HomeBLMSearchUser extends StatefulWidget{
  final bool isFamily;
  final int memorialId;
  HomeBLMSearchUser({this.isFamily, this.memorialId});

  @override
  HomeBLMSearchUserState createState() => HomeBLMSearchUserState(isFamily: isFamily, memorialId: memorialId);
}

class HomeBLMSearchUserState extends State<HomeBLMSearchUser>{
  final bool isFamily;
  final int memorialId;
  HomeBLMSearchUserState({this.isFamily, this.memorialId});
  
  RefreshController refreshController = RefreshController(initialRefresh: true);
  TextEditingController controller = TextEditingController();
  List<BLMSearchUsers> users;
  int itemRemaining;
  String keywords;
    bool empty;
  int page;

  void initState(){
    super.initState();
    users = [];
    empty = true;
    page = 1;
    itemRemaining = 1;
    keywords = '';
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
      for(int i = 0; i < newValue.users.length; i++){
        users.add(
          BLMSearchUsers(
            userId: newValue.users[i].userId,
            firstName: newValue.users[i].firstName,
            lastName: newValue.users[i].lastName,
            email: newValue.users[i].email,
          ),
        );
      }

      if(mounted)
      setState(() {});
      page++;
      
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
                setState(() {
                  keywords = newPlaces;
                });                

                if(newPlaces != ''){
                  setState(() {
                    empty = false;
                    itemRemaining = 1;
                    page = 1;
                    keywords = '';
                  });
                }else{
                  empty = true;
                  setState(() {
                    users = [];
                  });
                }
                
              },
              onFieldSubmitted: (newPlaces){
                setState(() {
                  keywords = newPlaces;
                });

                if(newPlaces != ''){
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
                  Widget body;
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
                  return Container(height: 55.0, child: Center(child: body),);
                },
              ),
              controller: refreshController,
              onRefresh: onRefresh,
              onLoading: onLoading,
              child: ListView.separated(
                padding: EdgeInsets.all(10.0),
                shrinkWrap: true,
                itemBuilder: (c, index){
                  var container = GestureDetector(
                    onTap: () async{
                      if(isFamily){

                        String choice = await showDialog(context: (context), builder: (build) => MiscBLMRelationshipFromDialog());

                        context.showLoaderOverlay();
                        bool result = await apiBLMAddFamily(memorialId, users[index].userId, choice);
                        context.hideLoaderOverlay();

                        if(result){
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeBLMPageFamily(memorialId: memorialId,), settings: RouteSettings(name: 'newRoute')),);
                          Navigator.popUntil(context, ModalRoute.withName('newRoute'));
                        }else{
                          await showDialog(context: (context), builder: (build) => MiscBLMAlertDialog(title: 'Error', content: 'Something went wrong. Please try again.'));
                        }
                      }else{
                        context.showLoaderOverlay();
                        bool result = await apiBLMAddFriends(memorialId, users[index].userId);
                        context.hideLoaderOverlay();

                        if(result){
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeBLMPageFriends(memorialId: memorialId,), settings: RouteSettings(name: 'newRoute')),);
                          Navigator.popUntil(context, ModalRoute.withName('newRoute'));
                        }else{
                          await showDialog(context: (context), builder: (build) => MiscBLMAlertDialog(title: 'Error', content: 'Something went wrong. Please try again.'));
                        }

                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            maxRadius: SizeConfig.blockSizeVertical * 5,
                            backgroundColor: Color(0xff888888),
                            backgroundImage: AssetImage('assets/icons/graveyard.png'),
                          ),

                          SizedBox(width: SizeConfig.blockSizeHorizontal * 3,),

                          Column(
                            children: [
                              RichText(
                                text: TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(text: users[index].firstName, style: users[index].firstName == keywords ? TextStyle(color: Color(0xff04ECFF)) : TextStyle(color: Color(0xff000000))),

                                    TextSpan(text: ' '),

                                    TextSpan(text: users[index].lastName, style: users[index].lastName == keywords ? TextStyle(color: Color(0xff04ECFF)) : TextStyle(color: Color(0xff000000))),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                  return container;
                },
                separatorBuilder: (c, i) => Divider(height: SizeConfig.blockSizeVertical * .5, color: Color(0xff000000)),
                itemCount: users.length,
              ),
            )
          ),
        ),
      ),
    );
  }
}