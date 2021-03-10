import 'package:facesbyplaces/API/Regular/08-Search/api-search-regular-05-search-users.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
// import 'package:substring_highlight/substring_highlight.dart';
// import 'home-create-post-regular-01-create-post.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter/material.dart';

class RegularSearchUsers{
  int userId;
  String firstName;
  String lastName;
  String email;
  int accountType;
  String image;

  RegularSearchUsers({required this.userId, required this.firstName, required this.lastName, required this.email, required this.accountType, required this.image});
}

class HomeRegularCreatePostSearchUser extends StatefulWidget{

  @override
  HomeRegularCreatePostSearchUserState createState() => HomeRegularCreatePostSearchUserState();
}

class HomeRegularCreatePostSearchUserState extends State<HomeRegularCreatePostSearchUser>{
  
  // RefreshController refreshController = RefreshController(initialRefresh: true);
  TextEditingController controller = TextEditingController();
  List<RegularSearchUsers> users = [];
  int itemRemaining = 1;
  bool empty = true;
  int page = 1;

  // void onRefresh() async{
  //   await Future.delayed(Duration(milliseconds: 1000));
  //   refreshController.refreshCompleted();
  // }  

  void onLoading() async{
    if(itemRemaining != 0){
      var newValue = await apiRegularSearchUsers(keywords: controller.text, page: page);
      itemRemaining = newValue.almItemsRemaining;

      for(int i = 0; i < newValue.almSearchUsers.length; i++){
        users.add(
          RegularSearchUsers(
            userId: newValue.almSearchUsers[i].searchUsersId, 
            firstName: newValue.almSearchUsers[i].searchUsersFirstName, 
            lastName: newValue.almSearchUsers[i].searchUsersLastName,
            email: newValue.almSearchUsers[i].searchUsersEmail,
            accountType: newValue.almSearchUsers[i].searchUsersAccountType,
            image: newValue.almSearchUsers[i].searchUsersImage,
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
            title: TextFormField(
              onChanged: (newPlace){
                if(newPlace == ''){
                  setState(() {
                    empty = true;
                    users = [];
                    itemRemaining = 1;
                    page = 1;
                  });
                }
              },
              onFieldSubmitted: (newPlace){
                setState(() {
                  controller.text = newPlace;
                  empty = false;
                });

                onLoading();
              },
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(15.0),
                filled: true,
                fillColor: Color(0xffffffff),
                focusColor: Color(0xffffffff),
                hintText: 'Search User',
                hintStyle: TextStyle(
                  fontSize: 16,
                ),
                suffixIcon: IconButton(
                  onPressed: (){
                    print('Search!');
                    setState(() {
                      empty = false;
                    });

                    onLoading();
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
            leading: IconButton(icon: Icon(Icons.arrow_back, color: Color(0xffffffff),), onPressed: (){Navigator.pop(context);},),
            backgroundColor: Color(0xff04ECFF),
          ),
          body: Container(
            height: SizeConfig.screenHeight! - kToolbarHeight,
            width: SizeConfig.screenWidth,
            child: empty
            ? SingleChildScrollView(
              physics: ClampingScrollPhysics(),
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
              width: SizeConfig.screenWidth,
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
              //     itemBuilder: (c, i) {
              //       return GestureDetector(
              //         onTap: (){
              //           Navigator.pop(context, RegularTaggedUsers(name: users[i].firstName + ' ' + users[i].lastName, userId: users[i].userId, accountType: users[i].accountType));
              //         },
              //         child: Container(
              //           padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              //           child: Row(
              //             children: [

              //               CircleAvatar(
              //                 maxRadius: 40,
              //                 backgroundColor: Color(0xff888888),
              //                 // backgroundImage: users[i].image != null ? NetworkImage(users[i].image) : AssetImage('assets/icons/app-icon.png'),
              //                 backgroundImage: NetworkImage(users[i].image),
              //               ),

              //               SizedBox(width: 25,),

              //               Expanded(
              //                 child: Column(
              //                   mainAxisAlignment: MainAxisAlignment.start,
              //                   crossAxisAlignment: CrossAxisAlignment.start,
              //                   children: [
              //                     SubstringHighlight(
              //                       text: users[i].firstName + ' ' + users[i].lastName,
              //                       term: controller.text,
              //                       textStyle: TextStyle(color: Color(0xff000000),),
              //                       textStyleHighlight: TextStyle(color: Color(0xff04ECFF),),
              //                     ),

              //                     Text(users[i].email, style: TextStyle(fontSize: 12, color: Color(0xff888888),),),

              //                   ],
              //                 ),
              //               ),
              //             ],
              //           ),
              //         ),
              //       );
              //     },
              //     separatorBuilder: (c, i) => Divider(height: 10, color: Color(0xff888888)),
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
