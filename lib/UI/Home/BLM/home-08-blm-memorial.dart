import 'package:facesbyplaces/API/BLM/api-10-blm-show-memorial.dart';
import 'package:facesbyplaces/API/BLM/api-15-blm-show-profile-post.dart';
import 'package:facesbyplaces/API/BLM/api-17-blm-follow-page.dart';
import 'package:facesbyplaces/API/BLM/api-18-blm-unfollow-page.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-05-blm-post.dart';
import 'package:facesbyplaces/UI/Miscellaneous/BLM/misc-09-blm-message.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';

class HomeBLMMemorialProfile extends StatefulWidget{

  HomeBLMMemorialProfileState createState() => HomeBLMMemorialProfileState();
}

class HomeBLMMemorialProfileState extends State<HomeBLMMemorialProfile>{

  final List<String> images = ['assets/icons/profile_post1.png', 'assets/icons/profile_post2.png', 'assets/icons/profile_post3.png', 'assets/icons/profile_post4.png'];
  final dataKey = new GlobalKey();

  void initState(){
    super.initState();
    // apiBLMShowMemorial();
    // apiBLMProfilePost();
  }

  String convertDate(String input){
    DateTime dateTime = DateTime.parse(input);

    final y = dateTime.year.toString().padLeft(4, '0');
    final m = dateTime.month.toString().padLeft(2, '0');
    final d = dateTime.day.toString().padLeft(2, '0');
    return '$d/$m/$y';
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    int memorialId = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: FutureBuilder<APIBLMShowMemorialMain>(
          future: apiBLMShowMemorial(memorialId),
          builder: (context, showProfile){
            if(showProfile.hasData){
              return Stack(
                children: [
                  
                  Container(
                    height: SizeConfig.screenHeight / 3, 
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover, 
                        image: showProfile.data.memorial.backgroundImage != null
                        ? NetworkImage(showProfile.data.memorial.backgroundImage)
                        : AssetImage('assets/icons/background3.png'),
                      ),
                    ),
                  ),

                  Column(
                    children: [
                      Container(
                        height: SizeConfig.screenHeight / 3.5,
                        color: Colors.transparent,
                        child: Container(
                          padding: EdgeInsets.only(left: 20.0, top: 20.0),
                          alignment: Alignment.topLeft,
                          child: IconButton(
                            onPressed: (){
                              Navigator.pop(context);
                            },
                            icon: Icon(Icons.arrow_back, color: Color(0xffffffff), size: SizeConfig.blockSizeVertical * 5,),
                          ),
                        ),
                      ), // INVISIBLE SPACE ABOVE THE BACKGROUND

                      Container(
                        width: SizeConfig.screenWidth,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                          color: Color(0xffffffff),
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: SizeConfig.blockSizeVertical * 12,),

                            Center(child: Text(showProfile.data.memorial.name, style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 5, fontWeight: FontWeight.bold, color: Color(0xff000000),),),),

                            SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                            Container(
                              width: SizeConfig.safeBlockHorizontal * 15,
                              height: SizeConfig.blockSizeVertical * 5,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: CircleAvatar(
                                      radius: SizeConfig.blockSizeVertical * 2,
                                      backgroundColor: Color(0xffE67E22),
                                      child: Icon(Icons.card_giftcard, color: Color(0xffffffff), size: SizeConfig.blockSizeVertical * 2,),
                                    ),
                                  ),

                                  SizedBox(width: SizeConfig.blockSizeHorizontal * 2,),

                                  Expanded(
                                    child: Text('45',
                                      style: TextStyle(
                                        fontSize: SizeConfig.safeBlockHorizontal * 4,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xff000000),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                            ((){
                              if(showProfile.data.memorial.details.description != ''){
                                return Container(
                                  padding: EdgeInsets.only(left: 20.0, right: 20.0),
                                  child: Text(showProfile.data.memorial.details.description,
                                    style: TextStyle(
                                      fontSize: SizeConfig.safeBlockHorizontal * 4,
                                      fontWeight: FontWeight.w300,
                                      color: Color(0xff000000),
                                    ),
                                  ),
                                );
                              }else if(showProfile.data.memorial.imagesOrVideos != null){
                                return Container(
                                  padding: EdgeInsets.only(left: 20.0, right: 20.0),
                                  child: Stack(
                                    children: [
                                      Container(
                                        height: SizeConfig.blockSizeHorizontal * 40,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: AssetImage('assets/icons/regular-image4.png'),
                                          ),
                                        ),
                                      ),

                                      Positioned(
                                        top: SizeConfig.blockSizeVertical * 7,
                                        left: SizeConfig.screenWidth / 2.8,
                                        child: Icon(Icons.play_arrow_rounded, color: Color(0xffffffff), size: SizeConfig.blockSizeVertical * 10,),
                                      ),
                                    ],
                                  ),
                                );
                              }else{
                                return Container(height: 0,);
                              }
                            }()),

                            SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                            Container(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: (){
                                        Navigator.pushNamed(context, '/home/blm/home-25-blm-donate');
                                      },
                                      child: CircleAvatar(
                                        radius: SizeConfig.blockSizeVertical * 3,
                                        backgroundColor: Color(0xffE67E22),
                                        child: Icon(Icons.card_giftcard, color: Color(0xffffffff), size: SizeConfig.blockSizeVertical * 3,),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 10.0, right: 10.0),
                                      child: MaterialButton(
                                        padding: EdgeInsets.zero,
                                        onPressed: () async{

                                          bool result;

                                          if(showProfile.data.memorial.follower){
                                            result = await apiBLMUnfollowPage(showProfile.data.memorial.id);
                                          }else{
                                            result = await apiBLMFollowPage(showProfile.data.memorial.id);
                                          }

                                          print('The result is $result');
                                          
                                        },
                                        child: Text(
                                          showProfile.data.memorial.follower
                                          ? 'Unjoin'
                                          : 'Join',
                                          style: TextStyle(
                                            fontSize: SizeConfig.safeBlockHorizontal * 5,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xffffffff),
                                          ),
                                        ),
                                        minWidth: SizeConfig.screenWidth / 2,
                                        height: SizeConfig.blockSizeVertical * 7,
                                        shape: StadiumBorder(),
                                        color: showProfile.data.memorial.manage
                                        ? Color(0xff04ECFF)
                                        : Color(0xff888888),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () async{
                                        await FlutterShare.share(
                                          title: 'Share',
                                          text: 'Share the link',
                                          linkUrl: 'https://flutter.dev/',
                                          chooserTitle: 'Share link'
                                        );
                                      },
                                      child: CircleAvatar(
                                        radius: SizeConfig.blockSizeVertical * 3,
                                        backgroundColor: Color(0xff3498DB),
                                        child: Icon(Icons.share, color: Color(0xffffffff), size: SizeConfig.blockSizeVertical * 3,),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                            Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: Column(
                                children: [

                                  Row(
                                    children: [
                                      Image.asset('assets/icons/prayer_logo.png', height: SizeConfig.blockSizeVertical * 3,),
                                      SizedBox(width: SizeConfig.blockSizeHorizontal * 2,),
                                      Text('Roman Catholic',
                                        style: TextStyle(
                                          fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                                          color: Color(0xff000000),
                                        ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                                  Row(
                                    children: [
                                      Icon(Icons.place, color: Color(0xff000000), size: SizeConfig.blockSizeVertical * 3,),
                                      SizedBox(width: SizeConfig.blockSizeHorizontal * 2,),
                                      Text(showProfile.data.memorial.details.precinct,
                                        style: TextStyle(
                                          fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                                          color: Color(0xff000000),
                                        ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                                  Row(
                                    children: [
                                      Icon(Icons.star, color: Color(0xff000000), size: SizeConfig.blockSizeVertical * 3,),
                                      SizedBox(width: SizeConfig.blockSizeHorizontal * 2,),
                                      Text(convertDate(showProfile.data.memorial.details.dob),
                                        style: TextStyle(
                                          fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                                          color: Color(0xff000000),
                                        ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                                  Row(
                                    children: [
                                      Image.asset('assets/icons/grave_logo.png', height: SizeConfig.blockSizeVertical * 3,),
                                      SizedBox(width: SizeConfig.blockSizeHorizontal * 2,),
                                      Text(convertDate(showProfile.data.memorial.details.rip),
                                        style: TextStyle(
                                          fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                                          color: Color(0xff000000),
                                        ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                                  Row(
                                    children: [
                                      Image.asset('assets/icons/grave_logo.png', height: SizeConfig.blockSizeVertical * 3,),
                                      SizedBox(width: SizeConfig.blockSizeHorizontal * 2,),
                                      GestureDetector(
                                        onTap: (){},
                                        child: Text(showProfile.data.memorial.details.location,
                                          style: TextStyle(
                                            fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                                            color: Color(0xff3498DB),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  
                                ],
                              ),
                            ),

                            SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                            Container(
                              height: 50.0,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: (){
                                        Scrollable.ensureVisible(dataKey.currentContext);
                                      },
                                      child: Column(
                                        children: [
                                          SizedBox(height: SizeConfig.blockSizeVertical * 1,),

                                          Text('26',
                                            style: TextStyle(
                                              fontSize: SizeConfig.safeBlockHorizontal * 5,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xff000000),
                                            ),
                                          ),

                                          Text('Post',
                                            style: TextStyle(
                                              fontSize: SizeConfig.safeBlockHorizontal * 3,
                                              fontWeight: FontWeight.w300,
                                              color: Color(0xffaaaaaa),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: (){
                                        Navigator.pushNamed(context, '/home/blm/home-22-blm-connection-list');
                                      },
                                      child: Column(
                                        children: [
                                          SizedBox(height: SizeConfig.blockSizeVertical * 1,),

                                          Text('526',
                                            style: TextStyle(
                                              fontSize: SizeConfig.safeBlockHorizontal * 5,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xff000000),
                                            ),
                                          ),

                                          Text('Family',
                                            style: TextStyle(
                                              fontSize: SizeConfig.safeBlockHorizontal * 3,
                                              fontWeight: FontWeight.w300,
                                              color: Color(0xffaaaaaa),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: (){
                                        Navigator.pushNamed(context, '/home/blm/home-22-blm-connection-list');
                                      },
                                      child: Column(
                                        children: [
                                          SizedBox(height: SizeConfig.blockSizeVertical * 1,),

                                          Text('526',
                                            style: TextStyle(
                                              fontSize: SizeConfig.safeBlockHorizontal * 5,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xff000000),
                                            ),
                                          ),

                                          Text('Friends',
                                            style: TextStyle(
                                              fontSize: SizeConfig.safeBlockHorizontal * 3,
                                              fontWeight: FontWeight.w300,
                                              color: Color(0xffaaaaaa),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: (){
                                        Navigator.pushNamed(context, '/home/blm/home-22-blm-connection-list');
                                      },
                                      child: Column(
                                        children: [
                                          SizedBox(height: SizeConfig.blockSizeVertical * 1,),

                                          Text('14.4K',
                                            style: TextStyle(
                                              fontSize: SizeConfig.safeBlockHorizontal * 5,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xff000000),
                                            ),
                                          ),

                                          Text('Followers',
                                            style: TextStyle(
                                              fontSize: SizeConfig.safeBlockHorizontal * 3,
                                              fontWeight: FontWeight.w300,
                                              color: Color(0xffaaaaaa),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Container(height: SizeConfig.blockSizeVertical * 1, color: Color(0xffeeeeee),),

                            Column(
                              children: [
                                SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                                Container(
                                  key: dataKey,
                                  padding: EdgeInsets.only(left: 20.0),
                                  alignment: Alignment.centerLeft,
                                  child: Text('Post',
                                    style: TextStyle(
                                      fontSize: SizeConfig.safeBlockHorizontal * 5,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff000000),
                                    ),
                                  ),
                                ),

                                SizedBox(height: SizeConfig.blockSizeVertical * 2,),

                                Container(
                                  width: SizeConfig.screenWidth,
                                  height: SizeConfig.blockSizeVertical * 12,
                                  padding: EdgeInsets.only(left: 20.0, right: 20.0),
                                  child: ListView.separated(
                                    physics: ClampingScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index){
                                      return Container(
                                        width: SizeConfig.blockSizeVertical * 12,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: AssetImage(images[index]),
                                          ),
                                        ),
                                      );
                                    }, 
                                    separatorBuilder: (context, index){
                                      return SizedBox(width: SizeConfig.blockSizeHorizontal * 2,);
                                    },
                                    itemCount: 4,
                                  ),
                                ),
                                SizedBox(height: SizeConfig.blockSizeVertical * 2,),
                              ],
                            ),

                            Container(height: SizeConfig.blockSizeVertical * 1, color: Color(0xffeeeeee),),

                            Padding(
                              padding: EdgeInsets.all(20.0),
                              child: FutureBuilder<APIBLMHomeProfilePostMain>(
                                future: apiBLMProfilePost(memorialId),
                                builder: (context, profilePost){
                                  if(profilePost.hasData){
                                    return Column(
                                      children: List.generate(profilePost.data.familyMemorialList.length, (index) => 
                                        Column(
                                          children: [
                                            MiscBLMPost(
                                              userId: profilePost.data.familyMemorialList[index].page.id,
                                              postId: profilePost.data.familyMemorialList[index].id,
                                              memorialId: profilePost.data.familyMemorialList[index].page.id,
                                              memorialName: profilePost.data.familyMemorialList[index].page.name,
                                              timeCreated: convertDate(profilePost.data.familyMemorialList[index].createAt),
                                              contents: [
                                                Column(
                                                  children: [
                                                    Align(
                                                      alignment: Alignment.topLeft,
                                                      child: RichText(
                                                        maxLines: 4,
                                                        overflow: TextOverflow.clip,
                                                        textAlign: TextAlign.left,
                                                        text: TextSpan(
                                                          text: profilePost.data.familyMemorialList[index].body,
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.w300,
                                                            color: Color(0xff000000),
                                                          ),
                                                        ),
                                                      ),
                                                    ),

                                                    SizedBox(height: SizeConfig.blockSizeVertical * 1,),
                                                  ],
                                                ),


                                                profilePost.data.familyMemorialList[index].imagesOrVideos != null
                                                ? Container(
                                                  height: SizeConfig.blockSizeHorizontal * 50,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                    image: DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: NetworkImage(profilePost.data.familyMemorialList[index].imagesOrVideos[0]),
                                                    ),
                                                  ),
                                                )
                                                : Container(height: 0,),
                                              ],
                                            ),

                                            SizedBox(height: SizeConfig.blockSizeVertical * 1,),

                                          ],
                                        ),                                      
                                      ),
                                    );
                                  }else if(profilePost.hasError){
                                    return Center(child: Text('Something went wrong. Please try again.', textAlign: TextAlign.center, style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),),);
                                  }else{
                                    return Container(child: Center(child: Container(child: SpinKitThreeBounce(color: Color(0xff000000), size: 50.0,), color: Color(0xffffffff),),),);
                                  }
                                },
                              ),
                            ),

                          ],
                        ),
                      ),
                    ],
                  ),

                  // Positioned(
                  //   top: SizeConfig.screenHeight / 5,
                  //   child: Container(
                  //     height: SizeConfig.blockSizeVertical * 18,
                  //     width: SizeConfig.screenWidth,
                  //     child: Row(
                  //       children: [
                  //         Expanded(child: Container(),),
                  //         Expanded(
                  //           child: CircleAvatar(
                  //             radius: SizeConfig.blockSizeVertical * 10,
                  //             backgroundColor: Color(0xff04ECFF),
                  //             child: Container(
                  //               height: SizeConfig.blockSizeVertical * 17,
                  //               child: Image.asset('assets/icons/profile2.png', fit: BoxFit.cover,),
                  //             ),
                  //           ),
                  //         ),
                  //         Expanded(child: Container(),),
                  //       ],
                  //     ),
                  //   ),
                  // ),

                ],
              );
            }else if(showProfile.hasError){
              return MiscBLMErrorMessageTemplate();
            }else{
              return Container(height: SizeConfig.screenHeight, child: Center(child: Container(child: SpinKitThreeBounce(color: Color(0xff000000), size: 50.0,), color: Color(0xffffffff),),),);
            }
          },
        ),
      ),
    );
  }
}
