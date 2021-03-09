import 'package:facesbyplaces/API/BLM/09-Settings-Memorial/api-settings-memorial-blm-11-add-family.dart';
import 'package:facesbyplaces/API/BLM/09-Settings-Memorial/api-settings-memorial-blm-12-add-friends.dart';
import 'package:facesbyplaces/API/BLM/08-Search/api-search-blm-05-search-users.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-02-blm-dialog.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
// import 'package:substring_highlight/substring_highlight.dart';
import 'home-settings-memorial-blm-05-page-family.dart';
import 'home-settings-memorial-blm-06-page-friends.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:loader_overlay/loader_overlay.dart';
// import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:flutter/material.dart';

class BLMSearchUsers{
  final int userId;
  final String firstName;
  final String lastName;
  final String image;
  final String email;
  final int accountType;

  BLMSearchUsers({required this.userId, required this.firstName, required this.lastName, required this.image, required this.email, required this.accountType});
}

class HomeBLMSearchUser extends StatefulWidget{
  final bool isFamily;
  final int memorialId;
  HomeBLMSearchUser({required this.isFamily, required this.memorialId});

  @override
  HomeBLMSearchUserState createState() => HomeBLMSearchUserState(isFamily: isFamily, memorialId: memorialId);
}

class HomeBLMSearchUserState extends State<HomeBLMSearchUser>{
  final bool isFamily;
  final int memorialId;
  HomeBLMSearchUserState({required this.isFamily, required this.memorialId});
  
  // RefreshController refreshController = RefreshController(initialRefresh: true);
  TextEditingController controller = TextEditingController();
  List<BLMSearchUsers> users = [];
  int itemRemaining = 1;
  String keywords = '';
  bool empty = true;
  int page = 1;

  // void onRefresh() async{
  //   await Future.delayed(Duration(milliseconds: 1000));
  //   refreshController.refreshCompleted();
  // }

  void onLoading() async{
    if(itemRemaining != 0){
      var newValue = await apiBLMSearchUsers(keywords: keywords, page: page);
      itemRemaining = newValue.blmItemsRemaining;
      for(int i = 0; i < newValue.blmUsers.length; i++){
        users.add(
          BLMSearchUsers(
            userId: newValue.blmUsers[i].searchUsersUserId,
            firstName: newValue.blmUsers[i].searchUsersFirstName,
            lastName: newValue.blmUsers[i].searchUsersLastName,
            email: newValue.blmUsers[i].searchUsersEmail,
            image: newValue.blmUsers[i].searchUsersImage,
            accountType: newValue.blmUsers[i].searchUsersAccountType,
          ),
        );
      }

      if(mounted)
      setState(() {});
      page++;
      
      // refreshController.loadComplete();
    }else{
      // refreshController.loadNoData();
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
            flexibleSpace: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: IconButton(icon: Icon(Icons.arrow_back, color: Color(0xffffffff),), onPressed: (){Navigator.pop(context);},),
                  ),
                  Container(
                    width: SizeConfig.screenWidth! / 1.3,
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
                          fontSize: 14,
                        ),
                        suffixIcon: IconButton(
                          onPressed: (){
                            setState(() {
                              keywords = controller.text;
                            });

                            if(controller.text != ''){
                              onLoading();
                            }
                          },
                          icon: Icon(Icons.search, color: Colors.grey),
                        ),
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
            ),
            leading: Container(),
            backgroundColor: Color(0xff04ECFF),
          ),
          body: Container(
            height: SizeConfig.screenHeight! - kToolbarHeight,
            width: SizeConfig.screenWidth,
            child: empty
            ? SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  SizedBox(height: (SizeConfig.screenHeight! - kToolbarHeight) / 3.5,),

                  Image.asset('assets/icons/search-user.png', height: 240, width: 240,),

                  SizedBox(height: 20,),

                  Text('Search a location to add on your post', style: TextStyle(fontSize: 16, color: Color(0xff000000),),),

                  SizedBox(height: (SizeConfig.screenHeight! - kToolbarHeight) / 3.5,),
                ],
              ),
            )
            : Container(
              height: SizeConfig.screenHeight,
              child: Container(),
              // child: SmartRefresher(
              //   enablePullDown: true,
              //   enablePullUp: true,
              //   header: MaterialClassicHeader(
              //     color: Color(0xffffffff),
              //     backgroundColor: Color(0xff4EC9D4),
              //   ),
              //   footer: CustomFooter(
              //     loadStyle: LoadStyle.ShowWhenLoading,
              //     builder: (BuildContext context, LoadStatus mode){
              //       Widget body = Container();
              //       if(mode == LoadStatus.loading){
              //         body = CircularProgressIndicator();
              //       }
              //       return Center(child: body);
              //     },
              //   ),
              //   controller: refreshController,
              //   onRefresh: onRefresh,
              //   onLoading: onLoading,
              //   child: ListView.separated(
              //     padding: EdgeInsets.all(10.0),
              //     physics: ClampingScrollPhysics(),
              //     itemBuilder: (c, index){
              //       return GestureDetector(
              //         onTap: () async{
              //           if(isFamily){

              //             String choice = await showDialog(context: (context), builder: (build) => MiscBLMRelationshipFromDialog());

              //             context.showLoaderOverlay();
              //             bool result = await apiBLMAddFamily(memorialId: memorialId, userId: users[index].userId, relationship: choice, accountType: users[index].accountType);
              //             context.hideLoaderOverlay();

              //             if(result){
              //               Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeBLMPageFamily(memorialId: memorialId,), settings: RouteSettings(name: 'newRoute')),);
              //               Navigator.popUntil(context, ModalRoute.withName('newRoute'));
              //             }else{
              //               await showDialog(
              //                 context: context,
              //                 builder: (_) => 
              //                   AssetGiffyDialog(
              //                   image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
              //                   title: Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
              //                   entryAnimation: EntryAnimation.DEFAULT,
              //                   description: Text('This user may not accept invite requests as of the moment. Please try again later.',
              //                     textAlign: TextAlign.center,
              //                     style: TextStyle(),
              //                   ),
              //                   onlyOkButton: true,
              //                   buttonOkColor: Colors.red,
              //                   onOkButtonPressed: () {
              //                     Navigator.pop(context, true);
              //                   },
              //                 )
              //               );
              //             }
              //           }else{
              //             context.showLoaderOverlay();
              //             bool result = await apiBLMAddFriends(memorialId: memorialId, userId: users[index].userId, accountType: users[index].accountType);
              //             context.hideLoaderOverlay();

              //             if(result){
              //               Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeBLMPageFriends(memorialId: memorialId,), settings: RouteSettings(name: 'newRoute')),);
              //               Navigator.popUntil(context, ModalRoute.withName('newRoute'));
              //             }else{
              //               await showDialog(
              //                 context: context,
              //                 builder: (_) => 
              //                   AssetGiffyDialog(
              //                   image: Image.asset('assets/icons/cover-icon.png', fit: BoxFit.cover,),
              //                   title: Text('Error', textAlign: TextAlign.center, style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),),
              //                   entryAnimation: EntryAnimation.DEFAULT,
              //                   description: Text('This user may not accept invite requests as of the moment. Please try again later.',
              //                     textAlign: TextAlign.center,
              //                     style: TextStyle(),
              //                   ),
              //                   onlyOkButton: true,
              //                   buttonOkColor: Colors.red,
              //                   onOkButtonPressed: () {
              //                     Navigator.pop(context, true);
              //                   },
              //                 )
              //               );
              //             }

              //           }
              //         },
              //         child: Container(
              //           padding: EdgeInsets.all(10.0),
              //           child: Row(
              //             children: [
              //               CircleAvatar(
              //                 maxRadius: 40,
              //                 backgroundColor: Color(0xff888888),
              //                 // backgroundImage: users[index].image != null ? NetworkImage(users[index].image) : AssetImage('assets/icons/app-icon.png'),
              //                 backgroundImage: NetworkImage(users[index].image),
              //               ),

              //               SizedBox(width: 25,),

              //               Expanded(
              //                 child: Column(
              //                   mainAxisAlignment: MainAxisAlignment.start,
              //                   crossAxisAlignment: CrossAxisAlignment.start,
              //                   children: [
              //                     SubstringHighlight(
              //                       text: users[index].firstName + ' ' + users[index].lastName,
              //                       term: keywords,
              //                       textStyle: TextStyle(color: Color(0xff000000),),
              //                       textStyleHighlight: TextStyle(color: Color(0xff04ECFF),),
              //                     ),

              //                     Text(users[index].email, style: TextStyle(fontSize: 12, color: Color(0xff888888),),),

              //                   ],
              //                 ),
              //               ),
              //             ],
              //           ),
              //         ),
              //       );
              //     },
              //     separatorBuilder: (c, i) => Divider(height: 5, color: Color(0xff000000)),
              //     itemCount: users.length,
              //   ),
              // )
            ),
          ),
        ),
      ),
    );
  }
}