import 'package:facesbyplaces/API/Regular/08-Search/api-search-regular-05-search-users.dart';
import 'package:facesbyplaces/API/Regular/09-Settings-Memorial/api-settings-memorial-regular-11-add-family.dart';
import 'package:facesbyplaces/API/Regular/09-Settings-Memorial/api-settings-memorial-regular-12-add-friends.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-02-regular-dialog.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'home-settings-memorial-regular-05-page-family.dart';
import 'home-settings-memorial-regular-06-page-friends.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter/material.dart';

class RegularSearchUsers{
  final int userId;
  final String firstName;
  final String lastName;
  final String image;
  final String email;
  final int accountType;

  RegularSearchUsers({this.userId, this.firstName, this.lastName, this.image, this.email, this.accountType});
}

class HomeRegularSearchUser extends StatefulWidget{
  final bool isFamily;
  final int memorialId;
  HomeRegularSearchUser({this.isFamily, this.memorialId});

  @override
  HomeRegularSearchUserState createState() => HomeRegularSearchUserState(isFamily: isFamily, memorialId: memorialId);
}

class HomeRegularSearchUserState extends State<HomeRegularSearchUser>{
  final bool isFamily;
  final int memorialId;
  HomeRegularSearchUserState({this.isFamily, this.memorialId});
  
  RefreshController refreshController = RefreshController(initialRefresh: true);
  TextEditingController controller = TextEditingController();
  List<RegularSearchUsers> users;
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
      var newValue = await apiRegularSearchUsers(keywords: keywords, page: page);
      itemRemaining = newValue.itemsRemaining;
      for(int i = 0; i < newValue.users.length; i++){
        users.add(
          RegularSearchUsers(
            userId: newValue.users[i].userId,
            firstName: newValue.users[i].firstName,
            lastName: newValue.users[i].lastName,
            email: newValue.users[i].email,
            image: newValue.users[i].image,
            accountType: newValue.users[i].accountType,
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
    ResponsiveWidgets.init(context,
      height: SizeConfig.screenHeight,
      width: SizeConfig.screenWidth,
    );
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
            flexibleSpace: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: IconButton(icon: Icon(Icons.arrow_back, color: Color(0xffffffff),), onPressed: (){Navigator.pop(context);},),
                ),
                Container(
                  width: SizeConfig.screenWidth / 1.3,
                  child: TextFormField(
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
                        fontSize: ScreenUtil().setSp(14, allowFontScalingSelf: true),
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
                ),
                Expanded(child: Container()),
              ],
            ), 
            leading: Container(),
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
              enablePullDown: true,
              enablePullUp: true,
              header: MaterialClassicHeader(
                color: Color(0xffffffff),
                backgroundColor: Color(0xff4EC9D4),
              ),
              footer: CustomFooter(
                loadStyle: LoadStyle.ShowWhenLoading,
                builder: (BuildContext context, LoadStatus mode){
                  Widget body;
                  if(mode == LoadStatus.loading){
                    body = CircularProgressIndicator();
                  }
                  return Center(child: body);
                },
              ),
              controller: refreshController,
              onRefresh: onRefresh,
              onLoading: onLoading,
              child: ListView.separated(
                padding: EdgeInsets.all(10.0),
                physics: ClampingScrollPhysics(),
                itemBuilder: (c, index){
                  return GestureDetector(
                    onTap: () async{
                      if(isFamily){

                        String choice = await showDialog(context: (context), builder: (build) => MiscRegularRelationshipFromDialog());

                        context.showLoaderOverlay();
                        bool result = await apiRegularAddFamily(memorialId: memorialId, userId: users[index].userId, relationship: choice, accountType: users[index].accountType);
                        context.hideLoaderOverlay();

                        if(result){
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeRegularPageFamily(memorialId: memorialId,), settings: RouteSettings(name: 'newRoute')),);
                          Navigator.popUntil(context, ModalRoute.withName('newRoute'));
                        }else{
                          await showDialog(context: (context), builder: (build) => MiscRegularAlertDialog(title: 'Error', content: 'This user may not accept invite requests as of the moment. Please try again later.'));
                        }
                      }else{
                        context.showLoaderOverlay();
                        bool result = await apiRegularAddFriends(memorialId: memorialId, userId: users[index].userId, accountType: users[index].accountType);
                        context.hideLoaderOverlay();

                        if(result){
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeRegularPageFriends(memorialId: memorialId,), settings: RouteSettings(name: 'newRoute')),);
                          Navigator.popUntil(context, ModalRoute.withName('newRoute'));
                        }else{
                          await showDialog(context: (context), builder: (build) => MiscRegularAlertDialog(title: 'Error', content: 'This user may not accept invite requests as of the moment. Please try again later.'));
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
                            backgroundImage: users[index].image != null ? NetworkImage(users[index].image) : AssetImage('assets/icons/app-icon.png'),
                          ),


                          SizedBox(width: SizeConfig.blockSizeHorizontal * 3,),

                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                textAlign: TextAlign.left,
                                text: TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(text: users[index].firstName, style: users[index].firstName == keywords ? TextStyle(color: Color(0xff04ECFF)) : TextStyle(color: Color(0xff000000))),

                                    TextSpan(text: ' '),

                                    TextSpan(text: users[index].lastName, style: users[index].lastName == keywords ? TextStyle(color: Color(0xff04ECFF)) : TextStyle(color: Color(0xff000000))),

                                  ],
                                ),
                              ),

                              Text(users[index].email, style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 3.5, color: Color(0xff888888),),),

                            ],
                          ),

                          
                        ],
                      ),
                    ),
                  );
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