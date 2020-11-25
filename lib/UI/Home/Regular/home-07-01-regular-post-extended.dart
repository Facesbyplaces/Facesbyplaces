import 'package:facesbyplaces/API/Regular/api-13-01-regular-search-memorial.dart';
import 'package:facesbyplaces/API/Regular/api-13-02-regular-search-suggested.dart';
import 'package:facesbyplaces/UI/Miscellaneous/Regular/misc-04-regular-dropdown.dart';
import 'package:facesbyplaces/Configurations/size_configuration.dart';
import 'package:flutter/material.dart';

import 'home-05-regular-search.dart';

class HomeRegularPostExtended extends StatefulWidget{

  HomeRegularPostExtendedState createState() => HomeRegularPostExtendedState();
}

class HomeRegularPostExtendedState extends State<HomeRegularPostExtended>{

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    final ScreenArguments newValue = ModalRoute.of(context).settings.arguments;
    return FutureBuilder<bool>(
      // future: apiRegularSearchPost(newValue.title),
      future: apiRegularSearchPosts(newValue.title),
      builder: (context, searchPost){
        return ListView.builder(
          physics: ClampingScrollPhysics(),
          padding: EdgeInsets.only(left: 10.0, right: 10.0),
          itemCount: 5,
          itemBuilder: (context, index){
            return Column(
              children: [
                SizedBox(height: SizeConfig.blockSizeVertical * 1,),

                Container(
                  padding: EdgeInsets.all(10.0),
                  height: SizeConfig.blockSizeVertical * 60,
                  decoration: BoxDecoration(
                    color: Color(0xffffffff),
                    borderRadius: BorderRadius.all(Radius.circular(15),),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0, 0)
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: (){
                                Navigator.pushNamed(context, 'home/regular/home-14-regular-user-profile');
                              },
                              child: CircleAvatar(backgroundImage: AssetImage('assets/icons/profile2.png'),),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(left: 10.0),
                                child: Column(
                                  children: [
                                    Expanded(child: Align(alignment: Alignment.bottomLeft,child: Text('Richard Nedd Memories', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, fontWeight: FontWeight.bold, color: Color(0xff000000),),),),),
                                    Expanded(child: Align(alignment: Alignment.topLeft, child: Text('an hour ago', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 3, fontWeight: FontWeight.w400, color: Color(0xffaaaaaa),),),),),
                                  ],
                                ),
                              ),
                            ),
                            MiscRegularDropDownTemplate()
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: RichText(
                                maxLines: 4,
                                overflow: TextOverflow.clip,
                                textAlign: TextAlign.left,
                                text: TextSpan(
                                  text: 'He was someone who was easy to go with. We had a lot of memories together. '
                                  'We\'ve been travelling all around the world together ever since we graduated college. We will surely miss you Will ❤️❤️❤️',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    color: Color(0xff000000),
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: SizeConfig.blockSizeVertical * 1,),

                            Align(
                              alignment: Alignment.centerLeft,
                              child: RichText(
                                maxLines: 1,
                                overflow: TextOverflow.clip,
                                textAlign: TextAlign.left,
                                text: TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: 'with ',
                                      style: TextStyle(
                                        fontSize: SizeConfig.safeBlockHorizontal * 3,
                                        fontWeight: FontWeight.w300,
                                        color: Color(0xffaaaaaa),
                                      ),
                                    ),

                                    TextSpan(
                                      text: 'William Shaw & John Howard',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff000000),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: AssetImage('assets/icons/blm2.png',),
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(width: SizeConfig.blockSizeHorizontal * 2,),
                            
                            Expanded(
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10.0),
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: AssetImage('assets/icons/blm3.png',),
                                        ),
                                      ),
                                    ),
                                  ),

                                  SizedBox(height: SizeConfig.blockSizeVertical * 1,),

                                  Expanded(
                                    child: Stack(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10.0),
                                            color: Color(0xff888888),
                                          ),
                                        ),

                                        Align(
                                          child: Text('+4',
                                            style: TextStyle(
                                              fontSize: SizeConfig.safeBlockHorizontal * 7,
                                              color: Color(0xffffffff),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: (){},
                                child: Row(
                                  children: [
                                    Image.asset('assets/icons/peace_logo.png', width: SizeConfig.blockSizeHorizontal * 7, height: SizeConfig.blockSizeVertical * 7,),

                                    SizedBox(width: SizeConfig.blockSizeHorizontal * 1,),

                                    Text('24.3K', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),),
                                  ],
                                ),
                              ),
                            ),

                            SizedBox(width: SizeConfig.blockSizeHorizontal * 2,),

                            Expanded(
                              child: GestureDetector(
                                onTap: (){},
                                child: Row(
                                  children: [
                                    Image.asset('assets/icons/comment_logo.png', width: SizeConfig.blockSizeHorizontal * 7, height: SizeConfig.blockSizeVertical * 7,),

                                    SizedBox(width: SizeConfig.blockSizeHorizontal * 1,),

                                    Text('14.3K', style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4, color: Color(0xff000000),),),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: GestureDetector(
                                onTap: (){},
                                child: Align(alignment: Alignment.centerRight, child: Image.asset('assets/icons/share_logo.png', width: SizeConfig.blockSizeHorizontal * 13, height: SizeConfig.blockSizeVertical * 13,),),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: SizeConfig.blockSizeVertical * 1,),
              ],
            );
          }
        );
      },
    );
  }
}