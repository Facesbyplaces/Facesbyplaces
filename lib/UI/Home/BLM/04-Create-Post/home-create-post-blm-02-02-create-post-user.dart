import 'package:facesbyplaces/API/BLM/08-Search/api-search-blm-05-search-users.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
// import 'package:substring_highlight/substring_highlight.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';
// import 'home-create-post-blm-01-create-post.dart';
import 'package:flutter/material.dart';

import 'home-create-post-blm-01-create-post.dart';

class BLMSearchUsers{
  int userId;
  String firstName;
  String lastName;
  String email;
  int accountType;
  String image;

  BLMSearchUsers({required this.userId, required this.firstName, required this.lastName, required this.email, required this.accountType, required this.image});
}

class HomeBLMCreatePostSearchUser extends StatefulWidget{

  @override
  HomeBLMCreatePostSearchUserState createState() => HomeBLMCreatePostSearchUserState();
}

class HomeBLMCreatePostSearchUserState extends State<HomeBLMCreatePostSearchUser>{
  
  TextEditingController controller = TextEditingController();
  ScrollController scrollController = ScrollController();
  List<BLMSearchUsers> users = [];
  int itemRemaining = 1;
  bool empty = true;
  int page = 1;

  void initState(){
    super.initState();
    // onLoading();
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        if(itemRemaining != 0){
          setState(() {
            onLoading();
          });
        }else{
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('No more users to show'),
              duration: Duration(seconds: 1),
              backgroundColor: Color(0xff4EC9D4),
            ),
          );
        }
      }
    });
  }

  Future<void> onRefresh() async{
    setState(() {
      onLoading();
    });
  }

  void onLoading() async{
    if(itemRemaining != 0){
      var newValue = await apiBLMSearchUsers(keywords: controller.text, page: page);
      itemRemaining = newValue.blmItemsRemaining;

      for(int i = 0; i < newValue.blmUsers.length; i++){
        users.add(
          BLMSearchUsers(
            userId: newValue.blmUsers[i].searchUsersUserId, 
            firstName: newValue.blmUsers[i].searchUsersFirstName, 
            lastName: newValue.blmUsers[i].searchUsersLastName,
            email: newValue.blmUsers[i].searchUsersEmail,
            accountType: newValue.blmUsers[i].searchUsersAccountType,
            image: newValue.blmUsers[i].searchUsersImage,
          )
        );
      }

      if(mounted)
      setState(() {});
      page++;
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
          body: empty == false
          ? RefreshIndicator(
            onRefresh: onRefresh,
            child: ListView.separated(
              controller: scrollController,
              padding: EdgeInsets.all(10.0),
              physics: ClampingScrollPhysics(),
              itemCount: users.length,
              separatorBuilder: (c, i) => Divider(height: 10, color: Colors.transparent),
              itemBuilder: (c, i) {
                return ListTile(
                  onTap: (){
                    Navigator.pop(context, BLMTaggedUsers(name: users[i].firstName + ' ' + users[i].lastName, userId: users[i].userId, accountType: users[i].accountType));
                  },
                  leading: users[i].image != '' 
                  ? CircleAvatar(
                    maxRadius: 40,
                    backgroundColor: Color(0xff888888),
                    backgroundImage: NetworkImage(users[i].image),
                  )
                  : CircleAvatar(
                    maxRadius: 40,
                    backgroundColor: Color(0xff888888),
                    backgroundImage: AssetImage('assets/icons/app-icon.png'),
                  ),
                  title: Text(users[i].firstName + ' ' + users[i].lastName,),
                  subtitle: Text(users[i].email, style: TextStyle(fontSize: 12, color: Color(0xff888888),),),
                );
              }
            ),
          )
          : Container(
            width: SizeConfig.screenWidth,
            child: SingleChildScrollView(
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
          ),
          // body: Container(
          //   height: SizeConfig.screenHeight! - kToolbarHeight,
          //   width: SizeConfig.screenWidth,
          //   child: empty
          //   ? SingleChildScrollView(
          //     physics: ClampingScrollPhysics(),
          //     child: Column(
          //       children: [
          //         SizedBox(height: (SizeConfig.screenHeight! - kToolbarHeight) / 3.5,),

          //         Image.asset('assets/icons/search-user.png', height: 240, width: 240,),

          //         SizedBox(height: 20,),

          //         Text('Search a location to add on your post', style: TextStyle(fontSize: 16, color: Color(0xff000000),),),

          //         SizedBox(height: (SizeConfig.screenHeight! - kToolbarHeight) / 3.5,),
          //       ],
          //     ),
          //   )
          //   : Container(
          //     height: SizeConfig.screenHeight,
          //     width: SizeConfig.screenWidth,
          //     // child: SmartRefresher(
          //     //   enablePullDown: true,
          //     //   enablePullUp: true,
          //     //   header: MaterialClassicHeader(
          //     //     color: Color(0xffffffff),
          //     //     backgroundColor: Color(0xff4EC9D4),
          //     //   ),
          //     //   footer: CustomFooter(
          //     //     loadStyle: LoadStyle.ShowWhenLoading,
          //     //     builder: (BuildContext context, LoadStatus mode){
          //     //       Widget body = Container();
          //     //       if(mode == LoadStatus.loading){
          //     //         body = CircularProgressIndicator();
          //     //       }
          //     //       return Center(child: body);
          //     //     },
          //     //   ),
          //     //   controller: refreshController,
          //     //   onRefresh: onRefresh,
          //     //   onLoading: onLoading,
          //     //   child: ListView.separated(
          //     //     padding: EdgeInsets.all(10.0),
          //     //     physics: ClampingScrollPhysics(),
          //     //     itemBuilder: (c, i) {
          //     //       return GestureDetector(
          //     //         onTap: (){
          //     //           Navigator.pop(context, BLMTaggedUsers(name: users[i].firstName + ' ' + users[i].lastName, userId: users[i].userId, accountType: users[i].accountType));
          //     //         },
          //     //         child: Container(
          //     //           padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
          //     //           child: Row(
          //     //             children: [
          //     //               CircleAvatar(
          //     //                 maxRadius: 40,
          //     //                 backgroundColor: Color(0xff888888),
          //     //                 // backgroundImage: users[i].image != null ? NetworkImage(users[i].image) : AssetImage('assets/icons/app-icon.png'),
          //     //                 backgroundImage: NetworkImage(users[i].image),
          //     //               ),

          //     //               SizedBox(width: 25,),

          //     //               Expanded(
          //     //                 child: Column(
          //     //                   mainAxisAlignment: MainAxisAlignment.start,
          //     //                   crossAxisAlignment: CrossAxisAlignment.start,
          //     //                   children: [
          //     //                     SubstringHighlight(
          //     //                       text: users[i].firstName + ' ' + users[i].lastName,
          //     //                       term: controller.text,
          //     //                       textStyle: TextStyle(color: Color(0xff000000),),
          //     //                       textStyleHighlight: TextStyle(color: Color(0xff04ECFF),),
          //     //                     ),

          //     //                     Text(users[i].email, style: TextStyle(fontSize: 12, color: Color(0xff888888),),),

          //     //                   ],
          //     //                 ),
          //     //               ),
          //     //             ],
          //     //           ),
          //     //         ),
          //     //       );
          //     //     },
          //     //     separatorBuilder: (c, i) => Divider(height: 10, color: Color(0xff888888)),
          //     //     itemCount: users.length,
          //     //   ),
          //     // ),
          //   )
          // ),
        ),
      ),
    );
  }
}
