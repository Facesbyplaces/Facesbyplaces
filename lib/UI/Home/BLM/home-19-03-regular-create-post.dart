// import 'package:facesbyplaces/Configurations/size_configuration.dart';
// import 'package:flutter/material.dart';

// class HomeBLMCreatePostSearchUser extends StatefulWidget{

//   @override
//   HomeBLMCreatePostSearchUserState createState() => HomeBLMCreatePostSearchUserState();
// }

// class HomeBLMCreatePostSearchUserState extends State<HomeBLMCreatePostSearchUser>{
  
//   TextEditingController controller = TextEditingController();
//   List<String> users = [];
//   bool empty = true;

//   @override
//   Widget build(BuildContext context) {
//     SizeConfig.init(context);
//     return WillPopScope(
//       onWillPop: () async{
//         return Navigator.canPop(context);
//       },
//       child: GestureDetector(
//         onTap: (){
//           FocusNode currentFocus = FocusScope.of(context);
//           if(!currentFocus.hasPrimaryFocus){
//             currentFocus.unfocus();
//           }
//         },
//         child: Scaffold(
//           appBar: AppBar(
//             title: TextFormField(
//               onChanged: (newPlaces){
//                 if(newPlaces == ''){
//                   setState(() {
//                     empty = true;
//                     users = [];
//                   });
//                 }else{
//                   setState(() {
//                     empty = false;
//                     users.add(newPlaces);
//                   });
//                 }

                
//               },
//               decoration: InputDecoration(
//                 contentPadding: EdgeInsets.all(15.0),
//                 filled: true,
//                 fillColor: Color(0xffffffff),
//                 focusColor: Color(0xffffffff),
//                 hintText: 'Search User',
//                 hintStyle: TextStyle(
//                   fontSize: SizeConfig.safeBlockHorizontal * 4,
//                 ),
//                 prefixIcon: Icon(Icons.search, color: Colors.grey),
//                 border: OutlineInputBorder(
//                   borderSide: BorderSide(color: Color(0xffffffff)),
//                   borderRadius: BorderRadius.all(Radius.circular(25)),
//                 ),
//                 enabledBorder:  OutlineInputBorder(
//                   borderSide: BorderSide(color: Color(0xffffffff)),
//                   borderRadius: BorderRadius.all(Radius.circular(25)),
//                 ),
//                 focusedBorder:  OutlineInputBorder(
//                   borderSide: BorderSide(color: Color(0xffffffff)),
//                   borderRadius: BorderRadius.all(Radius.circular(25)),
//                 ),
//               ),
//             ),
//             leading: IconButton(icon: Icon(Icons.arrow_back, color: Color(0xffffffff),), onPressed: (){Navigator.pop(context);},),
//             backgroundColor: Color(0xff04ECFF),
//           ),
//           body: empty
//           ? SingleChildScrollView(
//             physics: ClampingScrollPhysics(),
//             padding: EdgeInsets.zero,
//             child: Container(
//               height: SizeConfig.screenHeight - kToolbarHeight,
//               child: Column(
//                 children: [
//                   Expanded(child: Container(),),

//                   Container(
//                     height: SizeConfig.blockSizeVertical * 30,
//                     width: SizeConfig.screenWidth / 2,
//                     decoration: BoxDecoration(
//                       image: DecorationImage(
//                         image: AssetImage('assets/icons/search-user.png'),
//                       ),
//                     ),
//                   ),

//                   SizedBox(height: SizeConfig.blockSizeVertical * 2,),

//                   Text('Search a location to add on your post', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),),

//                   Expanded(child: Container(),),
//                 ],
//               ),
//             ),
//           )
//           : ListView.separated(
//             physics: ClampingScrollPhysics(),
//             itemBuilder: (context, index){
//               return GestureDetector(
//                 onTap: (){
//                   Navigator.pop(context, users[index]);
//                 },
//                 child: Container(
//                   height: SizeConfig.blockSizeVertical * 10,
//                   width: SizeConfig.screenWidth,
//                   padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 0.0,),
//                   alignment: Alignment.centerLeft,
//                   child: ListTile(
//                     leading: CircleAvatar(
//                       radius: SizeConfig.blockSizeVertical * 8,
//                       backgroundImage: AssetImage('assets/icons/profile2.png'),
//                     ),
//                     title: Text('${users[index]}'),
//                     subtitle: Text('+user$index'),
//                   ),
//                 ),
//               );
//             }, 
//             separatorBuilder: (context, index){
//               return Divider(thickness: SizeConfig.blockSizeVertical * .1, color: Color(0xff888888),);
//             },
//             itemCount: users.length,
//           ),
//         ),
//       ),
//     );
//   }
// }



import 'package:facesbyplaces/API/Regular/api-21-regular-search-users.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter/material.dart';

class BLMSearchUsers{
  String firstName;
  String lastName;
  String email;

  BLMSearchUsers({this.firstName, this.lastName, this.email});
}

class HomeBLMCreatePostSearchUser extends StatefulWidget{

  @override
  HomeBLMCreatePostSearchUserState createState() => HomeBLMCreatePostSearchUserState();
}

class HomeBLMCreatePostSearchUserState extends State<HomeBLMCreatePostSearchUser>{
  
  RefreshController refreshController = RefreshController(initialRefresh: true);
  TextEditingController controller = TextEditingController();
  List<BLMSearchUsers> users = [];
  int itemRemaining = 1;
  bool empty = true;
  int page = 1;

  void onRefresh() async{
    await Future.delayed(Duration(milliseconds: 1000));
    refreshController.refreshCompleted();
  }  

  void onLoading() async{
    if(itemRemaining != 0){
      var newValue = await apiRegularSearchUsers(controller.text, page);
      itemRemaining = newValue.itemsRemaining;

      for(int i = 0; i < newValue.users.length; i++){
        users.add(BLMSearchUsers(firstName: newValue.users[i].firstName, lastName: newValue.users[i].lastName, email: newValue.users[i].email));
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
                    body = Text('End of result.', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),);
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
                itemBuilder: (c, i) {
                  var container = GestureDetector(
                    onTap: (){
                      // Navigator.pop(context, users[i]);
                      Navigator.pop(context, '${users[i].firstName}' + ' ' + '${users[i].lastName}');
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                      height: SizeConfig.blockSizeVertical * 10,
                      child: Row(
                        children: [

                          CircleAvatar(backgroundImage: AssetImage('assets/icons/graveyard.png'), backgroundColor: Color(0xff888888)),

                          SizedBox(width: SizeConfig.blockSizeHorizontal * 2,),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(child: Container(),),

                                Text('${users[i].firstName}' + ' ' + '${users[i].lastName}', style: TextStyle(fontWeight: FontWeight.bold,),),

                                Text('${users[i].email}', style: TextStyle(fontWeight: FontWeight.w400, fontSize: SizeConfig.safeBlockHorizontal * 3, color: Color(0xff888888)),),

                                Expanded(child: Container(),),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                  return container;
                },
                separatorBuilder: (c, i) => Divider(height: SizeConfig.blockSizeVertical * 2, color: Color(0xff888888)),
                itemCount: users.length,
              ),
            )
          )
        ),
      ),
    );
  }
}
